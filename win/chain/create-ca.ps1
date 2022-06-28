mkdir ca
mkdir ca/ca.db.certs
echo $null >> ca/ca.db.index
echo "1234" >> ca/ca.db.serial
"00" | Out-File -encoding ascii -NoNewline ".\ca\ca.db.serial"
openssl genrsa -out ca/ca.key 1024
openssl req -config openssl.conf -new -x509 -days 3650 -key ca/ca.key -out ca/ca.crt