.PHONY: sshd
sshd:
	@cp -v ./SSH/ca.pub /etc/ssh/ca.pub
	@touch /etc/ssh/revoked_keys
	@cp -v ./SSH/sshd_config.d /etc/ssh/
	@service ssh restart

.PHONY: ssh
ssh:
	@cp -v ./SSH/spmzt-cert.pub ~/.ssh/
	@cp -v ./SSH/known_hosts ~/.ssh/

.PHONY: install
install: ssh sshd
	@echo Done.