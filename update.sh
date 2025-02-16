#!/usr/bin/env bash

git pull origin main
docker rmi kali
docker build -t kali .
