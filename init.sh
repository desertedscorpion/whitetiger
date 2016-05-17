#!/bin/bash

cp /root/private/id_rsa /root/.ssh/id_rsa &&
    chmod 0600 /root/.ssh/id_rsa &&
    (gpg --allow-secret-key- --import /root/private/secret.key || true ) &&
    (gpg2 --allow-secret-key- --import /root/private/secret.key || true ) &&
    gpg --import-ownertrust /root/private/owner.trust &&
    pass init ${KEY_ID} &&
    git config --global user.email "emory.merryman+$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)@gmail.com" &&
    git config --global user.name "Emory Merryman" &&
    pass git init &&
    pass git remote add origin ${PASS_REPO} &&
    pass git fetch origin master &&
    pass git checkout master &&
    pass git rebase origin/master &&
    ln --symbolic --force /root/bin/post-commit /root/.password-store/.git/hooks &&
    /usr/bin/byobu &&
    /root/bin/post-commit &&
    true
