#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This file is released under BSD 2-clause license.
import click
import sys
from netaddr import IPSet, IPNetwork
from gfwtools.chnroutes import china_networks
from gfwtools.utility import private_networks, \
    networks_from_source, foreign_networks, approx_networks

__author__ = 'ipwx'


@click.group()
def cli():
    pass


@cli.group()
def networks():
    """Query about the networks."""


@networks.command()
def china():
    """Query about the china networks."""
    networks = china_networks()
    print '\n'.join(map(str, networks.iter_cidrs()))


@networks.command()
def foreign():
    """Query about the foreign networks."""
    networks = foreign_networks()
    print '\n'.join(map(str, networks.iter_cidrs()))


@networks.command()
@click.option('--base', type=click.Choice(['china', 'foreign']),
              help='Base on china or foreign networks.',
              default='foreign')
@click.option('--prefer', type=click.Choice(['include', 'exclude']),
              help='Prefer to include or to exclude networks when approximate.',
              default='include')
@click.option('--approx', type=int, help='Size of network to be approximated.',
              default=20)
@click.option('--includes', help='List of networks that must be included.',
              type=click.Path())
@click.option('--excludes', help='List of networks that must be excluded.',
              type=click.Path())
def vpn(base, prefer, approx, includes=None, excludes=None):
    """
    Generate networks for VPN route table.
    """
    def load_networks(path_arr):
        if path_arr:
            ret = IPSet()
            for path in path_arr.split(','):
                ret |= networks_from_source(open(path, 'rb').read())
            return ret

    must_include = load_networks(includes)
    must_exclude = private_networks()
    if excludes:
        must_exclude |= load_networks(excludes)
    base_networks = china_networks() if base == 'china' else foreign_networks()
    networks = approx_networks(
        base_networks,
        prefer == 'include',
        approx,
        must_include,
        must_exclude
    )
    print '\n'.join(map(str, networks.iter_cidrs()))


@cli.group()
def generate():
    """Generate scripts."""


CHNROUTES_HEADER = """#!/bin/sh

if [ "$1" = "down" -o "$1" = "del" ]; then
    action=del
else
    action=add
    suf="via $(ip route show 0/0 | grep via | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')"
fi

ip -batch - <<EOF
"""

@generate.command()
def chnroutes():
    """Generate chnroutes.sh according to networks given by sys.stdin."""
    networks = filter(lambda s: s, map(str.strip, sys.stdin.read().split('\n')))
    print CHNROUTES_HEADER
    for network in networks:
        print 'route $action %s $suf' % network
    print 'EOF'


VPNROUTES_HEADER = """#!/bin/sh

suf="via %(gateway)s"
if [ "$1" = "down" -o "$1" = "del" ]; then
    action=del
else
    action=add
fi

ip -batch - <<EOF
"""

@generate.command()
@click.option('--gateway', '-G', help='Specify the VPN gateway.',
              default='10.122.0.2')
def vpnroutes(gateway):
    """Generate vpnroutes.sh according to networks given by sys.stdin."""
    networks = filter(lambda s: s, map(str.strip, sys.stdin.read().split('\n')))
    print VPNROUTES_HEADER % {'gateway': gateway}
    for network in networks:
        print 'route $action %s $suf' % network
    print 'EOF'
    
    
WIN_VPNROUTES_HEADER = """@echo off
set SUFFIX=
if "%1" EQU "down" (
    set ACTION=delete
) else if "%1" EQU "del" (
    set ACTION=delete
) else (
    set ACTION=add
    set SUFFIX=metric=5 store=active
)

set TMPFILE=%temp%\\routes.txt
echo pushd interface ipv4 > %TMPFILE%
"""

@generate.command()
def win_vpnroutes():
    """Generate vpnroutes.bat according to networks given by sys.stdin."""
    networks = filter(lambda s: s, map(str.strip, sys.stdin.read().split('\n')))
    print WIN_VPNROUTES_HEADER
    for network in networks:
        n = IPNetwork(network)
        print 'echo %ACTION% route {0} "%intf%" %remote_tun_ip% %SUFFIX% >> %TMPFILE%'.format(network)
    print ("""
netsh -f %TMPFILE%
del %TMPFILE%
echo done
""")


@generate.command()
def openvpn_routes():
    """Generate openvpn routes on given networks."""
    networks = filter(lambda s: s, map(str.strip, sys.stdin.read().split('\n')))
    for network in networks:
        n = IPNetwork(network)
        print 'route %s %s vpn_gateway' % (n.network, n.netmask)


if __name__ == '__main__':
    cli()
