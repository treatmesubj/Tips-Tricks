// NODE_EXTRA_CA_CERTS="/usr/local/share/ca-certificates/combined.crt" node node.js-utilize-certs.js
// on Debian, despite `sudo update-ca-certificates`, node did not utilize them

const tls = require('tls');
const fs = require('node:fs');

const content = JSON.stringify(tls.getCACertificates(), null, 2);
fs.writeFileSync('certs.txt', content, 'utf8');
