#!/bin/bash

display_var TRIX_CTRL_IP

# BIND (DNS server) configuration

echo_info 'Make named listen for requests on all interfaces'
sed -i -e 's/\(.*listen-on port 53 { \).*\( };\)/\1any;\2/' /etc/named.conf

echo_info 'Make named accept queries from all nodes that are not blocked by the firewall'
sed -i -e 's,\(.*allow-query\s.*{ \).*\( };\),\1any;\2,' /etc/named.conf

echo_info 'Enable and start named service'
systemctl enable named
systemctl start named

echo_info "Use this DNS server as the default resolver"

sed -i "s,^\(search .*\),# \1,g" /etc/resolv.conf
sed -i "s,^\(nameserver .*\),# \1,g" /etc/resolv.conf

append_line /etc/resolv.conf "search cluster ipmi"
append_line /etc/resolv.conf "nameserver $TRIX_CTRL_IP"

echo_warn "Please make sure to disable PEERDNS in your network-scripts to avoid resolv.conf override!"
