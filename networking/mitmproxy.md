```bash
sudo apt install mitmproxy
mitmweb
# Web server listening at http://127.0.0.1:8081/
# Proxy server listening at *:8080
curl -k -x http://localhost:8080 https://google.com
```

## VSCode configure proxy
```
nvim /mnt/c/Users/JohnHupperts/AppData/Roaming/Code/User/settings.json
Add below:
    "wca.verifySSL": false,
    "http.proxy": "http://localhost:8080",
    "http.proxyStrictSSL": false,
    "http.proxySupport": "override"
Now close Vscode, and reopen it from a terminal with code   --ignore-certificate-errors
```
