description interop9: bgp aspath

addrouter r1
int eth1 eth 0000.0000.1111 $per1$
!
vrf def v1
 rd 1:1
 exit
int eth1
 vrf for v1
 ipv4 addr 1.1.1.1 255.255.255.0
 ipv6 addr 1234::1 ffff::
 exit
int lo0
 vrf for v1
 ipv4 addr 2.2.2.1 255.255.255.255
 ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
 exit
route-map rm1
 sequence 10 act deny
  match aspath .*1234.*
 sequence 20 act permit
 exit
router bgp4 1
 vrf v1
 no safe-ebgp
 address uni
 local-as 1
 router-id 4.4.4.1
 neigh 1.1.1.2 remote-as 2
 neigh 1.1.1.2 route-map-in rm1
 red conn
 exit
router bgp6 1
 vrf v1
 no safe-ebgp
 address uni
 local-as 1
 router-id 6.6.6.1
 neigh 1234::2 remote-as 2
 neigh 1234::2 route-map-in rm1
 red conn
 exit
!

addpersist r2
int eth1 eth 0000.0000.2222 $per1$
!
set interfaces ge-0/0/0.0 family inet address 1.1.1.2/24
set interfaces ge-0/0/0.0 family inet6 address 1234::2/64
set interfaces lo0.0 family inet address 2.2.2.2/32
set interfaces lo0.0 family inet6 address 4321::2/128
set interfaces lo0.0 family inet address 2.2.2.3/32
set interfaces lo0.0 family inet6 address 4321::3/128
set interfaces lo0.0 family inet address 2.2.2.4/32
set interfaces lo0.0 family inet6 address 4321::4/128
set routing-options autonomous-system 2
set policy-options policy-statement ps1 term 1 from interface [ 2.2.2.3 4321::3 ]
set policy-options policy-statement ps1 term 1 then as-path-prepend 1234
set policy-options policy-statement ps1 term 1 then accept
set policy-options policy-statement ps1 term 2 from protocol direct
set policy-options policy-statement ps1 term 2 then as-path-prepend 4321
set policy-options policy-statement ps1 term 2 then accept
set protocols bgp export ps1
set protocols bgp group peers type external
set protocols bgp group peers peer-as 1
set protocols bgp group peers neighbor 1.1.1.1
set protocols bgp group peers neighbor 1234::1
commit
!


r1 tping 100 10 1.1.1.2 vrf v1
r1 tping 100 10 1234::2 vrf v1
r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
r1 tping 100 60 4321::2 vrf v1 sou lo0
r1 tping 0 60 2.2.2.3 vrf v1 sou lo0
r1 tping 0 60 4321::3 vrf v1 sou lo0
r1 tping 100 60 2.2.2.4 vrf v1 sou lo0
r1 tping 100 60 4321::4 vrf v1 sou lo0
