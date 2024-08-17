FROM atmoz/sftp

COPY ./var/users.conf /etc/sftp/users.conf
COPY ./var/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
#COPY ./var/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY ./init.d/init.sh /etc/sftp.d/init.sh
RUN chmod u+x /etc/sftp.d/init.sh

WORKDIR /home/emarsys_tulip
VOLUME /home/emarsys_tulip/share