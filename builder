#!/bin/bash
sudo rm -fr factory &&
sudo rm -fr distrib &&
sudo mkarchiso -v -r -w factory -o distrib source