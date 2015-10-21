#!/bin/sh
(python gfwtools.py networks vpn --prefer include --base foreign --excludes data/thunets.txt,data/cnnets.txt | python gfwtools.py generate vpnroutes --gateway 10.122.0.2) > /usr/local/bin/vpnroutes.sh
rm -f data/delegated-apnic-latest
