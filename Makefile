.PHONY: sshd
sshd:
	@cp -v ./SSH/ca.pub /etc/ssh/ca.pub
	@touch /etc/ssh/revoked_keys
	@cp -v ./SSH/sshd_config.d /etc/ssh/
	@service ssh restart

.PHONY: ssh
ssh:
	@cp -v ./SSH/spmzt*-cert.pub ~/.ssh/
	@cp -v ./SSH/known_hosts ~/.ssh/

.PHONY: ca
ca:
	@if [ "${OS}" = "FreeBSD" ]; then\
		mkdir -p /usr/local/etc/ssl/certs/;\
		cp ./certificates/CA/53bc2f23.0 /usr/local/etc/ssl/certs/SPMZT.crt;\
		certctl rehash;\
	else\
		mkdir -p /usr/local/share/ca-certificates/;\
		cp ./certificates/CA/53bc2f23.0 /usr/local/share/ca-certificates/SPMZT.crt;\
		update-ca-certificates;\
	fi

	@cp ./certificates/CA/53bc2f23.0 /usr/share/ca-certificates/SPMZT.crt
	@update-ca-certificates

.PHONY: install
install: ssh sshd ca
	@echo Done.