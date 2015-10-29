#!/bin/sh
(python gfwtools.py networks vpn --prefer include --base foreign --excludes data/thunets.txt,data/cnnets.txt | python gfwtools.py generate vpnroutes --gateway "10.123.0.2 dev gre1") > /usr/local/bin/vpnroutes.sh
(python gfwtools.py networks vpn --prefer include --base foreign --excludes data/thunets.txt,data/cnnets.txt | python gfwtools.py generate vpnroutes --gateway "10.123.0.3 dev grevps6") > /usr/local/bin/vpnroutes2.sh
chmod +x /usr/local/bin/vpnroutes.sh
chmod +x /usr/local/bin/vpnroutes2.sh
rm -f data/delegated-apnic-latest
