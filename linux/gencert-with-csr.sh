#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: ./gencert-with-csr.sh <CN DO CERTIFICADO> <NOME DA CA QUE ASSINA>"
    echo "Remember to escape asterisk with backslash in case of wildcard CN."
    exit 1
fi

CN=$1
FOLDER=$1
if [[ $CN == '*'* ]]; then
        FOLDER="asterisco${FOLDER:1}"
fi
mkdir -p gerados
FOLDER="gerados/$FOLDER"
SUB_CA_NAME=$2

echo "Usando common name $CN."
echo "Usando pasta $FOLDER."
echo "Usando ca $SUB_CA_NAME"
rm -rf $FOLDER
mkdir $FOLDER
#openssl genrsa -out $FOLDER/private.key 2048
touch $FOLDER/request.conf 
tee $FOLDER/request.conf << END
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
DNS.1 = *.ocp.previc.gov
DNS.2 = $CN
END
touch $FOLDER/openssl.conf
tee $FOLDER/openssl.conf << END
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.ocp.previc.gov
DNS.2 = $CN
END

#openssl req -new -sha256 -key $FOLDER/private.key -subj "/C=BR/ST=DF/L=Brasilia/O=Previc/OU=CGTI/CN=$CN" -config $FOLDER/openssl.conf -out $FOLDER/request.csr
openssl req -sha256 -nodes -newkey rsa:2048 -subj "/C=BR/ST=DF/L=Brasilia/O=Previc/OU=CGTI/CN=$CN" -keyout $FOLDER/private.key -out $FOLDER/request.csr -config $FOLDER/request.conf
openssl x509 -req -in $FOLDER/request.csr -CA sub-ca/$SUB_CA_NAME/ca.crt -CAkey sub-ca/$SUB_CA_NAME/ca.key -CAcreateserial -out $FOLDER/public.crt -days 3650 -sha256 -extfile $FOLDER/openssl.conf -extensions v3_req

