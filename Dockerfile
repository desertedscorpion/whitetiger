FROM taf7lwappqystqp4u7wjsqkdc7dquw/heavytombstone
MAINTAINER “Emory Merryman” emory.merryman+DoTDeCocXJroqaWu@gmail.com>
ENV KEY_ID="2D2D81DA" PASS_REPO="git@github.com:AFnRFCb7/lanterngold.git"
USER root
RUN dnf update --assumeyes && dnf install --assumeyes byobu bash-completion pass git gnupg gnupg2 findutils && dnf update --assumeyes && dnf clean all && mkdir /home/${LUSER}/.ssh && mkdir /home/${LUSER}/bin
COPY config /home/${LUSER}/.ssh/config
COPY post-commit.sh /home/${LUSER}/bin/post-commit
COPY phonetic.sh /home/${LUSER}/bin/phonetic
COPY init.sh /home/${LUSER}/bin/init
COPY expire.sh /home/${LUSER}/bin/expire
RUN chown --recursive ${LUSER}:${LUSER} /home/${LUSER}/.ssh /home/${LUSER}/bin
USER ${LUSER}
VOLUME /home/${LUSER}/private
RUN chmod 0700 /home/${LUSER}/.ssh && chmod 0600 /home/${LUSER}/.ssh/config && chmod 0500 /home/${LUSER}/bin/*
CMD /bin/init