```bash
sudo apt install mitmproxy
mitmweb
# Web server listening at http://127.0.0.1:8081/
# Proxy server listening at *:8080
curl -k -x http://localhost:8080 https://google.com
```
