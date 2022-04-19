#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

apt update
apt upgrade -y
apt install -y debian-keyring debian-archive-keyring apt-transport-https unzip
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/caddy-stable.asc
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
apt update
apt install -y caddy

rm *.zip
rm *.pem

echo "import $(pwd)/Caddyfile" > /etc/caddy/Caddyfile
curl -Lo "fnmt.cer" "https://www.sede.fnmt.gob.es/documents/10445900/10526749/AC_Raiz_FNMT-RCM_SHA256.cer"
openssl x509 -inform der -in fnmt.cer -out fnmt.pem

curl -Lo "dnie-04.zip" "https://www.dnielectronico.es/ZIP/ACDNIE004.crt.zip"
unzip "dnie-04.zip"
mv *.crt dnie-004.pem

curl -Lo "dnie-05.zip" "https://www.dnielectronico.es/ZIP/ACDNIE005.crt.zip"
unzip "dnie-05.zip"
mv *.crt dnie-005.pem

curl -Lo "dnie-06.zip" "https://www.dnielectronico.es/ZIP/ACDNIE006.crt.zip"
unzip "dnie-06.zip"
mv *.crt dnie-006.pem

systemctl restart caddy
