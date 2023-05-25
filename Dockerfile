FROM ubuntu:22.04

RUN apt-get update     && apt-get upgrade -y     && apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:DoYouEvenGriftBr0?' | chpasswd
#RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# Create a non-root user: mason
#RUN useradd -m mason && echo "mason:mason" | chpasswd && adduser mason sudo


RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Switch to the new user in the Docker image
#USER mason

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
