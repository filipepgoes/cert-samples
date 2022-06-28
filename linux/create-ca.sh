#!/bin/bash

mkdir -p root-ca
openssl genrsa -des3 -out root-ca/root-ca.key 4096 
openssl req -nodes -new -x509 -days 3650 -key root-ca/root-ca.key -out root-ca/root-ca.crt
