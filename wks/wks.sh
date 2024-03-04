#!/bin/sh

KEYID=$1

# WKD lookup works by domain, so only the domain you're hosting needs to be updated by this script
DOMAIN='spmzt.net'

# Since this will be plaintext, export in armor format for gpg.$DOMAIN
gpg --armor --export ${KEYID} > pubkey.gpg

# WKD - get the hashes from gpg and filter to only the email @ the $DOMAIN, and extract the hash
WKDHASH=$(gpg --with-wkd-hash -k ${KEYID} | grep '^\s\+\S\+@'${DOMAIN}'$' | sed -E "s/^[[:space:]]+([a-z0-9]{32})@$DOMAIN/\1/")

# Direct key
mkdir -p /usr/local/www/${DOMAIN}/.well-known/openpgpkey/hu
mkdir -p /usr/local/www/${DOMAIN}/.well-known/openpgpkey/${DOMAIN}/hu
gpg --export ${KEYID} > /usr/local/www/${DOMAIN}/.well-known/openpgpkey/hu/${WKDHASH}
gpg --export ${KEYID} > /usr/local/www/${DOMAIN}/.well-known/openpgpkey/${DOMAIN}/hu/${WKDHASH}

# Advanced
cd /usr/local/www/$DOMAIN/.well-known
gpg --list-options show-only-fpr-mbox -k @$DOMAIN | grep $DOMAIN | /usr/local/bin/gpg-wks-client -v --install-key
