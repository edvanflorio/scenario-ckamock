#!/bin/bash
set -e

NAMESPACE="web-app"
GATEWAY_NAME="web-gateway"
HTTPROUTE_NAME="web-route"
GATEWAY_CLASS="nginx-class"
HOSTNAME="gateway.web.k8s.local"
SERVICE_NAME="web-service"
SERVICE_PORT=80
TLS_SECRET="web-tls"

echo "Validating Kubernetes Gateway API migration..."

kubectl get gateway $GATEWAY_NAME -n $NAMESPACE >/dev/null || { echo "FAIL: Gateway $GATEWAY_NAME does not exist in namespace $NAMESPACE"; exit 1; }

gc=$(kubectl get gateway $GATEWAY_NAME -n $NAMESPACE -o jsonpath='{.spec.gatewayClassName}')
if [ "$gc" != "$GATEWAY_CLASS" ]; then
  echo "FAIL: GatewayClass mismatch: expected $GATEWAY_CLASS, got $gc"; exit 1
fi

listener_count=$(kubectl get gateway $GATEWAY_NAME -n $NAMESPACE -o json | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d['spec']['listeners']))")
if [ "$listener_count" -eq 0 ]; then
  echo "FAIL: No listeners configured on Gateway"; exit 1
fi

https_listener=$(kubectl get gateway $GATEWAY_NAME -n $NAMESPACE -o json | python3 -c "
import sys,json
d=json.load(sys.stdin)
for l in d['spec']['listeners']:
    if l.get('protocol') == 'HTTPS':
        print(l.get('hostname',''))
        print(l.get('port',''))
        print(l.get('tls',{}).get('certificateRefs',[{}])[0].get('name',''))
        break
")

listener_hostname=$(echo "$https_listener" | sed -n '1p')
listener_port=$(echo "$https_listener" | sed -n '2p')
tls_secret_name=$(echo "$https_listener" | sed -n '3p')

[ "$listener_hostname" = "$HOSTNAME" ] || { echo "FAIL: Listener hostname: expected $HOSTNAME, got $listener_hostname"; exit 1; }
[ "$listener_port" = "443" ] || { echo "FAIL: Listener port: expected 443, got $listener_port"; exit 1; }
[ "$tls_secret_name" = "$TLS_SECRET" ] || { echo "FAIL: TLS secret: expected $TLS_SECRET, got $tls_secret_name"; exit 1; }

kubectl get httproute $HTTPROUTE_NAME -n $NAMESPACE >/dev/null || { echo "FAIL: HTTPRoute $HTTPROUTE_NAME does not exist"; exit 1; }

route_hosts=$(kubectl get httproute $HTTPROUTE_NAME -n $NAMESPACE -o jsonpath='{.spec.hostnames[*]}')
echo "$route_hosts" | grep -qw "$HOSTNAME" || { echo "FAIL: HTTPRoute does not contain hostname $HOSTNAME"; exit 1; }

backend_service=$(kubectl get httproute $HTTPROUTE_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[0].backendRefs[0].name}')
backend_port=$(kubectl get httproute $HTTPROUTE_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[0].backendRefs[0].port}')
[ "$backend_service" = "$SERVICE_NAME" ] || { echo "FAIL: Backend service: expected $SERVICE_NAME, got $backend_service"; exit 1; }
[ "$backend_port" = "$SERVICE_PORT" ] || { echo "FAIL: Backend port: expected $SERVICE_PORT, got $backend_port"; exit 1; }

echo "PASS: All Gateway API migration validations passed."
