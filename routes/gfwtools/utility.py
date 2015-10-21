#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This file is released under BSD 2-clause license.
import bisect
import socket
from netaddr import IPNetwork, IPSet, AddrFormatError
from gfwtools.chnroutes import china_networks

__author__ = 'ipwx'


def all_networks():
    return IPSet(IPNetwork('0.0.0.0/0'))


def negate_networks(networks):
    return all_networks() - networks


def networks_from_source(source):
    """Make network objects from configuration lines."""
    ret = []
    for line in source.split('\n'):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        try:
            ret.append(IPNetwork(unicode(line)))
        except AddrFormatError:
            for addr in socket.gethostbyname_ex(line)[2]:
                ret.append(IPNetwork(addr))
    return IPSet(ret)


def private_networks():
    """Get list of private networks."""
    return networks_from_source("""
        # http://en.wikipedia.org/wiki/Reserved_IP_addresses
        0.0.0.0/8
        10.0.0.0/8
        100.64.0.0/10
        127.0.0.0/8
        169.254.0.0/16
        172.16.0.0/12
        192.0.0.0/29
        192.0.2.0/24
        192.88.99.0/24
        192.168.0.0/16
        198.18.0.0/15
        198.51.100.0/24
        203.0.113.0/24
        224.0.0.0/4
        240.0.0.0/4
        255.255.255.255/32
    """)


def foreign_networks():
    return negate_networks(china_networks() | private_networks())


def approx_networks(base_networks, prefer_include, min_size, must_include=None,
                    must_exclude=None):
    if prefer_include:
        ret = all_networks() - IPSet(
            network for network in negate_networks(base_networks).iter_cidrs()
            if network.prefixlen <= min_size
        )
    else:
        ret = IPSet(
            network for network in base_networks.iter_cidrs()
            if network.prefixlen <= min_size
        )

    ret |= must_include or IPSet()
    ret -= must_exclude or IPSet()
    return ret
