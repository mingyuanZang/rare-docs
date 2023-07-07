description lsrp auto mesh tunnel

addrouter r1
int ser1 ser 0000.0000.1111 $1a$ $1b$
!
vrf def v1
 rd 1:1
 label-mode per-prefix
 exit
access-list test4
 deny 1 any all any all
 permit all any all any all
 exit
access-list test6
 deny 58 any all any all
 permit all any all any all
 exit
prefix-list all
 sequence 10 permit 0.0.0.0/0 le 32
 sequence 20 permit ::/0 le 128
 exit
router lsrp4 1
 vrf v1
 router 4.4.4.1
 red conn
 automesh all
 exit
router lsrp6 1
 vrf v1
 router 6.6.6.1
 red conn
 automesh all
 exit
int lo0
 vrf for v1
 ipv4 addr 2.2.2.1 255.255.255.255
 ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
 exit
int ser1
 vrf for v1
 ipv4 addr 9.9.9.1 255.255.255.0
 ipv6 addr 9999::1 ffff::
 router lsrp4 1 ena
 router lsrp6 1 ena
 ipv4 access-group-in test4
 ipv6 access-group-in test6
 mpls enable
 mpls rsvp4
 mpls rsvp6
 exit
!

addrouter r2
int ser1 ser 0000.0000.2222 $1b$ $1a$
!
vrf def v1
 rd 1:1
 label-mode per-prefix
 exit
access-list test4
 deny 1 any all any all
 permit all any all any all
 exit
access-list test6
 deny 58 any all any all
 permit all any all any all
 exit
prefix-list all
 sequence 10 permit 0.0.0.0/0 le 32
 sequence 20 permit ::/0 le 128
 exit
router lsrp4 1
 vrf v1
 router 4.4.4.2
 red conn
 automesh all
 exit
router lsrp6 1
 vrf v1
 router 6.6.6.2
 red conn
 automesh all
 exit
int lo0
 vrf for v1
 ipv4 addr 2.2.2.2 255.255.255.255
 ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
 exit
int ser1
 vrf for v1
 ipv4 addr 9.9.9.2 255.255.255.0
 ipv6 addr 9999::2 ffff::
 router lsrp4 1 ena
 router lsrp6 1 ena
 ipv4 access-group-in test4
 ipv6 access-group-in test6
 mpls enable
 mpls rsvp4
 mpls rsvp6
 exit
!


r1 tping 100 40 9.9.9.2 vrf v1
r1 tping 100 40 9999::2 vrf v1

r2 tping 100 40 9.9.9.1 vrf v1
r2 tping 100 40 9999::1 vrf v1

r1 tping 0 40 2.2.2.2 vrf v1
r1 tping 0 40 4321::2 vrf v1

r2 tping 0 40 2.2.2.1 vrf v1
r2 tping 0 40 4321::1 vrf v1

r2 output show ipv4 lsrp 1 nei
r2 output show ipv6 lsrp 1 nei
r2 output show ipv4 lsrp 1 dat
r2 output show ipv6 lsrp 1 dat
r2 output show ipv4 lsrp 1 tre
r2 output show ipv6 lsrp 1 tre
r2 output show ipv4 route v1
r2 output show ipv6 route v1
