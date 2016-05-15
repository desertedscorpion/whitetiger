#!/bin/bash

mkdir /tmp/gpg-agent &&
    chmod 700 /tmp/gpg-agent &&
    eval $(gpg-agent --write-env-file /tmp/gpg-agent/gpg_agent_info \
                     --use-standard-socket --daemon \
                     --default-cache-ttl=${GPG_DEFAULT_CACHE:-31536000} \
                     --max-cache-ttl=${GPG_MAX_CACHE:-31536000} ) &&
    while gpg-connect-agent /bye
    do
	sleep 2 &&
	    true
    done &&
    cp /home/${LUSER}/private/id_rsa /home/${LUSER}/.ssh/id_rsa &&
    chmod 0600 /home/${LUSER}/.ssh/id_rsa &&
    (gpg --allow-secret-key- --import /home/${LUSER}/private/secret.key || true ) &&
    (gpg2 --allow-secret-key- --import /home/${LUSER}/private/secret.key || true ) &&
    gpg --import-ownertrust /home/${LUSER}/private/owner.trust &&
    pass init ${KEY_ID} &&
    git config --global user.email "emory.merryman+$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)@gmail.com" &&
    git config --global user.name "Emory Merryman" &&
    pass git init &&
    pass git remote add origin ${PASS_REPO} &&
    pass git fetch origin master &&
    pass git checkout master &&
    pass git rebase origin/master &&
    ln --symbolic --force /home/${LUSER}/bin/post-commit /home/${LUSER}/.password-store/.git/hooks &&
    /usr/bin/bash &&
    /home/${LUSER}/bin/post-commit &&
    true
