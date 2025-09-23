FROM atmoz/sftp

COPY /docker/sftp/var/users.conf /etc/sftp/users.conf
COPY /docker/sftp/var/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY /docker/sftp/init.d/init.sh /etc/sftp.d/init.sh
RUN chmod u+x /etc/sftp.d/init.sh

WORKDIR /home/sftp
VOLUME /home/sftp/share