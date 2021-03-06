#!/bin/sh

IP=$(echo $1 || ipconfig getifaddr en1 || ipconfig getifaddr en0 | egrep -o "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$")

if [ ! $IP ]
then
    echo "Usage: generate-ip-cert.sh 127.0.0.1"
    exit 1
fi

echo "[req]
default_bits  = 2048
distinguished_name = req_distinguished_name
req_extensions = req_ext
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
countryName = XX
stateOrProvinceName = N/A
localityName = N/A
organizationName = Self-signed certificate
commonName = $IP: Self-signed certificate

[req_ext]
subjectAltName = @alt_names

[v3_req]
subjectAltName = @alt_names

[alt_names]
IP.1 = 127.0.0.1
IP.2 = 192.168.0.10
IP.3 = 192.168.1.10
IP.4 = 192.168.2.10
IP.5 = 192.168.43.12
IP.6 = $IP

DNS.1 = localhost
DNS.2 = *.localhost
DNS.3 = *.picornell.dev
" > san.cnf

openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout local.key -out local.cert -config san.cnf
rm san.cnf
