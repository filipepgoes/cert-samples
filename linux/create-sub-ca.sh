#!/bin/bash


if [ $# -lt 2 ]; then
    echo "Usage: ./create-sub-ca.sh <CN DA SUBCA> <NOME DA CA>"
    exit 1
fi

CN=$1
NAME=$2
mkdir -p sub-ca
DIR=sub-ca/$NAME
rm -rf $DIR
mkdir -p $DIR
touch $DIR/openssl.conf
tee $DIR/openssl.conf << END
[req]
distinguished_name = req_distinguished_name
req_extensions = req_ext
prompt = no
[req_distinguished_name]
C = BR
ST = DF
L = Brasilia
O = Previc
OU = CGTI
CN = $CN
[req_ext]
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.$NAME.previc.gov
DNS.2 = $CN
[ v3_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = CA:true
keyUsage = cRLSign, keyCertSign
nsCertType = sslCA, server
subjectAltName = URI:$CN
issuerAltName = issuer:copy

END
openssl genrsa -out $DIR/ca.key 4096
openssl req -new -key $DIR/ca.key -out $DIR/ca.csr
openssl x509 -req -days 3650 -in $DIR/ca.csr -CA root-ca/root-ca.crt -CAkey root-ca/root-ca.key -CAcreateserial -out $DIR/ca.crt -extfile $DIR/openssl.conf -extensions v3_ca
