# Example: p4lang: autoroute to p2p te over mpls

=== "Topology"

    ![Alt text](../d2/p4lang-rout175/p4lang-rout175.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v9
     rd 1:1
     exit
    int lo9
     vrf for v9
     ipv4 addr 10.10.10.227 255.255.255.255
     exit
    int eth1
     vrf for v9
     ipv4 addr 10.11.12.254 255.255.255.0
     exit
    int eth2
     exit
    server dhcp4 eth1
     pool 10.11.12.1 10.11.12.99
     gateway 10.11.12.254
     netmask 255.255.255.0
     dns-server 10.10.10.227
     domain-name p4l
     static 0000.0000.2222 10.11.12.111
     interface eth1
     vrf v9
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.101 255.255.255.255
     ipv6 addr 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     justadvert lo0
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     justadvert lo0
     exit
    int sdn1
     no autostat
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int sdn2
     no autostat
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv6 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int sdn3
     no autostat
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1234:3::1 ffff:ffff::
     ipv6 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int sdn4
     no autostat
     vrf for v1
     ipv4 addr 1.1.4.1 255.255.255.0
     ipv6 addr 1234:4::1 ffff:ffff::
     ipv6 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int tun11
     tun sou lo0
     tun dest 2.2.2.103
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.11.1 255.255.255.0
     ipv4 autoroute lsrp4 1 2.2.2.103 1.1.11.2 exclu
     exit
    int tun12
     tun sou lo0
     tun dest 4321::103
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 1234:11::1 ffff:ffff::
     ipv6 autoroute lsrp6 1 4321::103 1234:11::2 exclu
     exit
    int tun21
     tun sou lo0
     tun dest 2.2.2.104
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.12.1 255.255.255.0
     ipv4 autoroute lsrp4 1 2.2.2.104 1.1.12.2 exclu
     exit
    int tun22
     tun sou lo0
     tun dest 4321::104
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 1234:12::1 ffff:ffff::
     ipv6 autoroute lsrp6 1 4321::104 1234:12::2 exclu
     exit
    int tun31
     tun sou lo0
     tun dest 2.2.2.105
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.13.1 255.255.255.0
     ipv4 autoroute lsrp4 1 2.2.2.105 1.1.13.2 exclu
     exit
    int tun32
     tun sou lo0
     tun dest 4321::105
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 1234:13::1 ffff:ffff::
     ipv6 autoroute lsrp6 1 4321::105 1234:13::2 exclu
     exit
    int tun41
     tun sou lo0
     tun dest 2.2.2.106
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.14.1 255.255.255.0
     ipv4 autoroute lsrp4 1 2.2.2.106 1.1.14.2 exclu
     exit
    int tun42
     tun sou lo0
     tun dest 4321::106
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 1234:14::1 ffff:ffff::
     ipv6 autoroute lsrp6 1 4321::106 1234:14::2 exclu
     exit
    server p4lang p4
     interconnect eth2
     export-vrf v1
     export-port sdn1 1 10
     export-port sdn2 2 10
     export-port sdn3 3 10
     export-port sdn4 4 10
     export-port tun11 dynamic
     export-port tun12 dynamic
     export-port tun21 dynamic
     export-port tun22 dynamic
     export-port tun31 dynamic
     export-port tun32 dynamic
     export-port tun41 dynamic
     export-port tun42 dynamic
     vrf v9
     exit
    ```

    **r2**

    ```
    hostname r2
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.103 255.255.255.255
     ipv6 addr 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.3
     justadvert lo0
     justadvert eth1
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.3
     justadvert lo0
     justadvert eth1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int tun11
     tun sou lo0
     tun dest 2.2.2.101
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.11.2 255.255.255.0
     ipv4 autoroute lsrp4 1 2.2.2.101 1.1.11.1 exclu
     exit
    int tun12
     tun sou lo0
     tun dest 4321::101
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 1234:11::2 ffff:ffff::
     ipv6 autoroute lsrp6 1 4321::101 1234:11::1 exclu
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.104 255.255.255.255
     ipv6 addr 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.4
     justadvert lo0
     justadvert eth1
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.4
     justadvert lo0
     justadvert eth1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int tun11
     tun sou lo0
     tun dest 2.2.2.101
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.12.2 255.255.255.0
     ipv4 autoroute lsrp4 1 2.2.2.101 1.1.12.1 exclu
     exit
    int tun12
     tun sou lo0
     tun dest 4321::101
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 1234:12::2 ffff:ffff::
     ipv6 autoroute lsrp6 1 4321::101 1234:12::1 exclu
     exit
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.105 255.255.255.255
     ipv6 addr 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.5
     justadvert lo0
     justadvert eth1
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.5
     justadvert lo0
     justadvert eth1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int tun11
     tun sou lo0
     tun dest 2.2.2.101
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.13.2 255.255.255.0
     ipv4 autoroute lsrp4 1 2.2.2.103 1.1.12.1 exclu
     exit
    int tun12
     tun sou lo0
     tun dest 4321::101
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 1234:13::2 ffff:ffff::
     ipv6 autoroute lsrp6 1 4321::101 1234:13::1 exclu
     exit
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.106 255.255.255.255
     ipv6 addr 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.6
     justadvert lo0
     justadvert eth1
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.6
     justadvert lo0
     justadvert eth1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.4.2 255.255.255.0
     ipv6 addr 1234:4::2 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int tun11
     tun sou lo0
     tun dest 2.2.2.101
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.14.2 255.255.255.0
     ipv4 autoroute lsrp4 1 2.2.2.103 1.1.14.1 exclu
     exit
    int tun12
     tun sou lo0
     tun dest 4321::101
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 1234:14::2 ffff:ffff::
     ipv6 autoroute lsrp6 1 4321::101 1234:14::1 exclu
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1 sou sdn1
    r1 tping 100 10 1234:1::2 vrf v1 sou sdn1
    r1 tping 100 10 1.1.2.2 vrf v1 sou sdn2
    r1 tping 100 10 1234:2::2 vrf v1 sou sdn2
    r1 tping 100 10 1.1.3.2 vrf v1 sou sdn3
    r1 tping 100 10 1234:3::2 vrf v1 sou sdn3
    r1 tping 100 10 1.1.4.2 vrf v1 sou sdn4
    r1 tping 100 10 1234:4::2 vrf v1 sou sdn4
    r3 tping 100 10 1.1.1.2 vrf v1 sou eth1
    r3 tping 100 10 1234:1::2 vrf v1 sou eth1
    r3 tping 100 10 1.1.2.2 vrf v1 sou eth1
    r3 tping 100 10 1234:2::2 vrf v1 sou eth1
    r3 tping 100 10 1.1.3.2 vrf v1 sou eth1
    r3 tping 100 10 1234:3::2 vrf v1 sou eth1
    r3 tping 100 10 1.1.4.2 vrf v1 sou eth1
    r3 tping 100 10 1234:4::2 vrf v1 sou eth1
    r4 tping 100 10 1.1.1.2 vrf v1 sou eth1
    r4 tping 100 10 1234:1::2 vrf v1 sou eth1
    r4 tping 100 10 1.1.2.2 vrf v1 sou eth1
    r4 tping 100 10 1234:2::2 vrf v1 sou eth1
    r4 tping 100 10 1.1.3.2 vrf v1 sou eth1
    r4 tping 100 10 1234:3::2 vrf v1 sou eth1
    r4 tping 100 10 1.1.4.2 vrf v1 sou eth1
    r4 tping 100 10 1234:4::2 vrf v1 sou eth1
    r5 tping 100 10 1.1.1.2 vrf v1 sou eth1
    r5 tping 100 10 1234:1::2 vrf v1 sou eth1
    r5 tping 100 10 1.1.2.2 vrf v1 sou eth1
    r5 tping 100 10 1234:2::2 vrf v1 sou eth1
    r5 tping 100 10 1.1.3.2 vrf v1 sou eth1
    r5 tping 100 10 1234:3::2 vrf v1 sou eth1
    r5 tping 100 10 1.1.4.2 vrf v1 sou eth1
    r5 tping 100 10 1234:4::2 vrf v1 sou eth1
    r6 tping 100 10 1.1.1.2 vrf v1 sou eth1
    r6 tping 100 10 1234:1::2 vrf v1 sou eth1
    r6 tping 100 10 1.1.2.2 vrf v1 sou eth1
    r6 tping 100 10 1234:2::2 vrf v1 sou eth1
    r6 tping 100 10 1.1.3.2 vrf v1 sou eth1
    r6 tping 100 10 1234:3::2 vrf v1 sou eth1
    r6 tping 100 10 1.1.4.2 vrf v1 sou eth1
    r6 tping 100 10 1234:4::2 vrf v1 sou eth1
    r1 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r1 tping 100 10 4321::101 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r1 tping 100 10 4321::103 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r1 tping 100 10 4321::104 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r1 tping 100 10 4321::105 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r1 tping 100 10 4321::106 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r3 tping 100 10 4321::101 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r3 tping 100 10 4321::103 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r3 tping 100 10 4321::104 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r3 tping 100 10 4321::105 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r3 tping 100 10 4321::106 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r4 tping 100 10 4321::101 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r4 tping 100 10 4321::103 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r4 tping 100 10 4321::104 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r4 tping 100 10 4321::105 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r4 tping 100 10 4321::106 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r5 tping 100 10 4321::101 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r5 tping 100 10 4321::103 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r5 tping 100 10 4321::104 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r5 tping 100 10 4321::105 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r5 tping 100 10 4321::106 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r6 tping 100 10 4321::101 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r6 tping 100 10 4321::103 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r6 tping 100 10 4321::104 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r6 tping 100 10 4321::105 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r6 tping 100 10 4321::106 vrf v1 sou lo0
    r1 dping sdn . r6 1.1.3.2 vrf v1 sou eth1
    r1 dping sdn . r6 1234:3::2 vrf v1 sou eth1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [p4lang-rout175](../clab/p4lang-rout175/p4lang-rout175.yml) file  
        3. Launch ContainerLab `p4lang-rout175.yml` topology:  

        ```
           containerlab deploy --topo p4lang-rout175.yml  
        ```
        4. Destroy ContainerLab `p4lang-rout175.yml` topology:  

        ```
           containerlab destroy --topo p4lang-rout175.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `p4lang-rout175.tst` file [here](../tst/p4lang-rout175.tst)  
        3. Launch `p4lang-rout175.tst` test:  

        ```
           java -jar ../../rtr.jar test tester p4lang-rout175 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `p4lang-rout175.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
