keytool -genkey -alias mykey -keyalg RSA -sigalg SHA256withRSA -validity 3650 -keystore server.keystore -storetype JKS #-ext san=dns:apps.ocp.previc.gov
keytool -export -alias mykey -keystore server.keystore -rfc -file public.crt
keytool -importkeystore -srckeystore server.keystore -destkeystore server.p12 -deststoretype PKCS12
openssl pkcs12 -in server.p12  -nodes -nocerts -out private.key
openssl x509 -x509toreq -sha256 -in public.crt -signkey private.key -out request.csr