openssl ca -config .\openssl.conf -out public.crt -infiles request.csr

# openssl ca -config openssl.conf -revoke .\asterisco.apps.ocp.previc.gov\public.crt