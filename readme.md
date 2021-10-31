## Using GnuPG Agent as a SSH agent

Enable SSH support in GnuPG Agent by adding the corresponding option in the agent configuration file, `~/.gnupg/gpg-agent.conf`:

```
enable-ssh-support
```

While GnuPG programs can start the GnuPG Agent on demand, starting explicitly the agent is necessary to ensure that the agent is running when a SSH client needs it. The two lines below, to be inserted into a `~/.xprofile` script, are sufficient:[1](https://incenp.org/notes/2015/gnupg-for-ssh-authentication.html#footnote1)

```
unset SSH_AGENT_PID;
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi;
export GPG_TTY=$(tty);
gpg-connect-agent updatestartuptty /bye >/dev/null
```

With the GPG agent running, you can start using it with your existing SSH keys, exactly like you would use *ssh-agent*. For example, to load your default `~/.ssh/id_rsa` key into the agent, just run as usual:

```
$ ssh-add
```

### Using the authentication subkey

To tell the agent that the authentication subkey can be used with SSH, extract the *keygrip* of that subkey:

```
$ gpg2 --with-keygrip -k alice
pub   rsa4096/CB2F38F25B491A54 2014-12-31 [SC] [expires: 2017-12-30]
      Keygrip = D4DF0C35D3E22FA6AC37DA2E54FB03F73616A3CB
uid               [ultimate] Alice <alice@example.org>
sub   rsa2048/04BB7F8FDEC5E5D9 2014-12-31 [S] [expires: 2015-12-31]
      Keygrip = 21B2EDF018D7CAF0B45644FDB753DD42307C4425
sub   rsa2048/BBB6B86627C2D43A 2014-12-31 [E] [expires: 2015-12-31]
      Keygrip = 2E149DA9C5E46E0DECC6A17EFD8B5FB1DF1E1BAB
sub   rsa2048/7D2233B8833E70AF 2014-12-31 [A] [expires: 2015-12-31]
      Keygrip = ECF4591CC28EC303BB12D1E866C8B8AFFB675C7D
```

and write it into the `~/.gnupg/sshcontrol` file:

```
# List of allowed ssh keys.  Only keys present in this file are used
# in the SSH protocol.  The ssh-add tool may add new entries to this
[…]
ECF4591CC28EC303BB12D1E866C8B8AFFB675C7D
```

You may then verify that the key is indeed available for SSH by querying the agent for available identities:

```
$ ssh-add -l
2048 e3:40:d5:eb:ef:b1:3a:37:87:3d:a8:44:1d:81:ed:6a (none) (RSA)
```

Finally, extract the public key from the agent in a form suitable for inclusion into a `~/.ssh/authorized_keys` file:

```
$ ssh-add -L
ssh-rsa AAAAB3NzaC1yc2EAA[…truncated output…]KhJHfdIcCMRF (none)
```

