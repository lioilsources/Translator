#!/usr/bin/env bash
# Založí Cloudflare tunel a DNS pro Tlumočníka a spustí connector na L40S.
# Spouští uživatel na Macu. Token nikdy nevypisuje, jde přes stdin do .env na VM.
# Lze spustit opakovaně: existující tunel i DNS záznam znovu použije.
set -euo pipefail
ZONE=ol1n.com
HOST=tlumocnik.ol1n.com
NAME=tlumocnik
SERVICE=http://orchestrator:8096
VM=ol1n@10.10.0.10
DIR=/srv/work/translator/deploy/l40s

set -a; . "$HOME/.cloudflare/api.env"; set +a
API_TOKEN=${CLOUDFLARE_API_TOKEN:-${CF_API_TOKEN:-}}
[ -n "$API_TOKEN" ] || { echo "api.env nemá CLOUDFLARE_API_TOKEN ani CF_API_TOKEN"; exit 1; }

cf() { # <metoda> <cesta> [json]
  curl -sS -X "$1" "https://api.cloudflare.com/client/v4$2" \
    -H "Authorization: Bearer $API_TOKEN" -H "Content-Type: application/json" ${3:+--data "$3"}
}
field() { # vypíše výraz nad odpovědí, při chybě API skončí bez tajných údajů
  python3 -c '
import json, sys
d = json.load(sys.stdin)
if not d.get("success"):
    sys.exit("Cloudflare: " + "; ".join(e.get("message", "?") for e in d.get("errors", [])))
r = d["result"]
print(eval(sys.argv[1]))' "$1"
}

zone_json=$(cf GET "/zones?name=$ZONE")
ZONE_ID=$(printf %s "$zone_json" | field 'r[0]["id"]')
ACCOUNT=$(printf %s "$zone_json" | field 'r[0]["account"]["id"]')

TUNNEL=$(cf GET "/accounts/$ACCOUNT/cfd_tunnel?name=$NAME&is_deleted=false" | field 'r[0]["id"] if r else ""')
if [ -z "$TUNNEL" ]; then
  TUNNEL=$(cf POST "/accounts/$ACCOUNT/cfd_tunnel" "{\"name\":\"$NAME\",\"config_src\":\"cloudflare\"}" | field 'r["id"]')
  echo "tunel založen"
else
  echo "tunel už existuje"
fi

cf PUT "/accounts/$ACCOUNT/cfd_tunnel/$TUNNEL/configurations" \
  "{\"config\":{\"ingress\":[{\"hostname\":\"$HOST\",\"service\":\"$SERVICE\"},{\"service\":\"http_status:404\"}]}}" \
  | field '"ingress nastaven"'

RECORD=$(cf GET "/zones/$ZONE_ID/dns_records?name=$HOST" | field 'r[0]["id"] if r else ""')
DNS="{\"type\":\"CNAME\",\"name\":\"$HOST\",\"content\":\"$TUNNEL.cfargotunnel.com\",\"proxied\":true}"
if [ -z "$RECORD" ]; then
  cf POST "/zones/$ZONE_ID/dns_records" "$DNS" | field '"DNS založeno"'
else
  cf PUT "/zones/$ZONE_ID/dns_records/$RECORD" "$DNS" | field '"DNS aktualizováno"'
fi

cf GET "/accounts/$ACCOUNT/cfd_tunnel/$TUNNEL/token" | field 'r' | ssh -o BatchMode=yes "$VM" "
  set -e; read -r T; cd $DIR; umask 077
  sed -i '/^TUNNEL_TOKEN=/d' .env; printf 'TUNNEL_TOKEN=%s\n' \"\$T\" >> .env
  chmod 600 .env; docker compose --profile tunnel up -d tunnel 2>&1 | tail -1"
echo "hotovo"
