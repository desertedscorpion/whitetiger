FROM taf7lwappqystqp4u7wjsqkdc7dquw/easternmoose
ENV KEY_ID="2D2D81DA" PASS_REPO="git@github.com:AFnRFCb7/lanterngold.git"
RUN dnf update --assumeyes && dnf install --assumeyes gnome-terminal byobu bash-completion pass git gnupg gnupg2 findutils && dnf update --assumeyes && dnf clean all && mkdir /root/.ssh && mkdir /root/bin
COPY config /root/.ssh/config
COPY post-commit.sh /root/bin/post-commit
COPY phonetic.sh /root/bin/phonetic
COPY init.sh /root/bin/init
COPY expire.sh /root/bin/expire
VOLUME /root/private
RUN chmod 0700 /root/.ssh && chmod 0600 /root/.ssh/config && chmod 0500 /root/bin/*
CMD /root/bin/init