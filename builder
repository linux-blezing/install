#!/bin/bash

if [[ -d "factory" ]];then
    sudo rm -fr factory
fi

if [[ -d "distrib" ]];then
    sudo rm -fr distrib
fi

sudo mkarchiso -v -r -w factory -o distrib source