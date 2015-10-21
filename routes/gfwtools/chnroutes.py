#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This file is released under BSD 2-clause license.
import os

import urllib2
import re
import math
from netaddr import IPSet, IPNetwork

__author__ = 'ipwx'

cached_apnic_latest_path = os.path.join(
    os.path.dirname(__file__),
    '../data/delegated-apnic-latest'
)


def download_delegated_apnic_latest():
    url = r'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest'
    cnt = urllib2.urlopen(url).read()
    with open(cached_apnic_latest_path, 'wb') as f:
        f.write(cnt)


def get_delegated_apnic_latest():
    if not os.path.isfile(cached_apnic_latest_path):
        download_delegated_apnic_latest()
    with open(cached_apnic_latest_path, 'rb') as f:
        return f.read()


def china_networks():
    # fetch data from apnic
    data = get_delegated_apnic_latest()
    cnregex = re.compile(
        r'apnic\|cn\|ipv4\|[0-9\.]+\|[0-9]+\|[0-9]+\|a.*', re.IGNORECASE)
    cndata = cnregex.findall(data)
    results = []
    for item in cndata:
        unit_items = item.split('|')
        starting_ip = unit_items[3]
        num_ip = int(unit_items[4])
        # mask in *nix format
        mask2 = 32 - int(math.log(num_ip, 2))
        results.append(IPNetwork(u'%s/%s' % (starting_ip, mask2)))
    return IPSet(results)
