#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

function main { (
    ensure_caddy
    ensure_unzip
    download_certs

    echo "import $(pwd)/Caddyfile" >/etc/caddy/Caddyfile
    systemctl restart caddy
); }

function ensure_caddy { (
    if ! command -v caddy &>/dev/null; then
        apt install -y debian-keyring debian-archive-keyring apt-transport-https
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/caddy-stable.asc
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
        apt update
        apt install -y caddy
    fi
); }

function ensure_unzip { (
    if ! command -v unzip &>/dev/null; then
        apt install -y unzip
    fi
); }

function download_certs { (
    rm -rf certs
    mkdir -p certs
    cd certs

    curl -Lo "fnmt.cer" "https://www.sede.fnmt.gob.es/documents/10445900/10526749/AC_Raiz_FNMT-RCM_SHA256.cer"
    openssl x509 -inform der -in fnmt.cer -out fnmt.pem

    curl -Lo "dnie-01.zip" "https://www.dnielectronico.es/ZIP/ACDNIE001.crt.zip"
    unzip "dnie-01.zip"
    mv *.crt dnie-001.cer
    openssl x509 -inform der -in dnie-001.cer -out dnie-001.pem

    curl -Lo "dnie-02.zip" "https://www.dnielectronico.es/ZIP/ACDNIE002.crt.zip"
    unzip "dnie-02.zip"
    mv *.crt dnie-002.cer
    openssl x509 -inform der -in dnie-002.cer -out dnie-002.pem

    curl -Lo "dnie-03.zip" "https://www.dnielectronico.es/ZIP/ACDNIE003.crt.zip"
    unzip "dnie-03.zip"
    mv *.crt dnie-003.cer
    openssl x509 -inform der -in dnie-003.cer -out dnie-003.pem

    curl -Lo "dnie-04.zip" "https://www.dnielectronico.es/ZIP/ACDNIE004.crt.zip"
    unzip "dnie-04.zip"
    mv *.crt dnie-004.cer
    openssl x509 -inform der -in dnie-004.cer -out dnie-004.pem

    curl -Lo "dnie-05.zip" "https://www.dnielectronico.es/ZIP/ACDNIE005.crt.zip"
    unzip "dnie-05.zip"
    mv *.crt dnie-005.cer
    openssl x509 -inform der -in dnie-005.cer -out dnie-005.pem

    curl -Lo "dnie-06.zip" "https://www.dnielectronico.es/ZIP/ACDNIE006.crt.zip"
    unzip "dnie-06.zip"
    mv *.crt dnie-006.cer
    openssl x509 -inform der -in dnie-006.cer -out dnie-006.pem

    rm -f *.zip
    rm -f *.cer
); }

main
