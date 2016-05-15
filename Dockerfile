FROM taf7lwappqystqp4u7wjsqkdc7dquw/heavytombstone
MAINTAINER “Emory Merryman” emory.merryman+DoTDeCocXJroqaWu@gmail.com>
ENV KEY_ID="2D2D81DA" PASS_REPO="git@github.com:AFnRFCb7/lanterngold.git"
USER root
RUN dnf update --assumeyes && dnf install --assumeyes bash-completion pass git gnupg gnupg2 findutils && dnf update --assumeyes && dnf clean all && mkdir /home/${LUSER}/.ssh
COPY config /home/${LUSER}/.ssh/config
RUN chown --recursive ${LUSER}:${LUSER} /home/${LUSER}/.ssh
USER ${LUSER}
VOLUME /home/${LUSER}/private
RUN chmod 0700 /home/${LUSER}/.ssh && chmod 0600 /home/${LUSER}/.ssh/config && mkdir /home/${LUSER}/bin
COPY post-commit.sh /home/${LUSER}/bin/post-commit
COPY phonetic.sh /home/${LUSER}/bin/phonetic
RUN chmod 0500 /home/${LUSER}/bin/*
CMD cp /home/${LUSER}/private/id_rsa /home/${LUSER}/.ssh/id_rsa && chmod 0600 /h
ome/${LUSER}/.ssh/id_rsa && (gpg --allow-secret-key- --import /home/${LUSER}/pri
vate/secret.key || true ) &&  (gpg2 --allow-secret-key- --import /home/${LUSER}/
private/secret.key || true ) && pass init ${KEY_ID} && git config --global user.email "emory.merryman+$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)@gmail.com" && git config --global user.name "Emory Merryman" && pass git init && pass git remote add origin ${PASS_REPO} && pass git fetch origin master && pass git checkout master && pass git rebase origin/master && ln --symbolic --force /home/${LUSER}/bin/post-commit /home/${LUSER}/.password-store/.git/hooks && /usr/bin/bash