#!/bin/bash

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
