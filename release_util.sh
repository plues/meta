#!/bin/sh

push_confirmation() {
    while true; do
        read -p "Push $1 release? [Y/n] " yn
        case $yn in
            [Yy]* ) break;;
            "" ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no. ";;
        esac
    done
    if ! git push origin master:master --tags; then exit; fi
    if ! git push origin develop:develop; then exit; fi
}

continue_confirmation() {
    while true; do
        read -p "Continue? [Y/n] " yn
        case $yn in
            [Yy]* ) break;;
            "" ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no. ";;
        esac
    done
}