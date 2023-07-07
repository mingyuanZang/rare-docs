# Example: bgp with bier

=== "Topology"

    ![Alt text](../d2/rout-bgp313/rout-bgp313.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     local-as 1
     bier 256 10 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 bier
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     local-as 1
     bier 256 10 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 2
     neigh 1234:1::2 bier
     red conn
     exit
    int tun1
     tun sou lo0
     tun dest 9.9.9.9
     tun doma 2.2.2.4
     tun vrf v1
     tun key 1
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     exit
    int tun2
     tun sou lo0
     tun dest 9999::9
     tun doma 4321::4
     tun vrf v1
     tun key 1
     tun mod bier
     vrf for v1
     ipv6 addr 4321::1111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff0
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     local-as 2
     bier 256 10 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 bier
     neigh 1.1.1.6 remote-as 3
     neigh 1.1.1.6 bier
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     local-as 2
     bier 256 10 2
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 bier
     neigh 1234:2::2 remote-as 3
     neigh 1234:2::2 bier
     red conn
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     local-as 3
     bier 256 10 3
     router-id 4.4.4.3
     neigh 1.1.1.5 remote-as 2
     neigh 1.1.1.5 bier
     neigh 1.1.1.10 remote-as 4
     neigh 1.1.1.10 bier
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     local-as 3
     bier 256 10 3
     router-id 6.6.6.3
     neigh 1234:2::1 remote-as 2
     neigh 1234:2::1 bier
     neigh 1234:3::2 remote-as 4
     neigh 1234:3::2 bier
     red conn
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
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     local-as 4
     bier 256 10 4
     router-id 4.4.4.4
     neigh 1.1.1.9 remote-as 3
     neigh 1.1.1.9 bier
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     local-as 4
     bier 256 10 4
     router-id 6.6.6.4
     neigh 1234:3::1 remote-as 3
     neigh 1234:3::1 bier
     red conn
     exit
    int tun1
     tun sou lo0
     tun dest 9.9.9.9
     tun doma 2.2.2.1
     tun vrf v1
     tun key 3
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     exit
    int tun2
     tun sou lo0
     tun dest 9999::9
     tun doma 4321::1
     tun vrf v1
     tun key 3
     tun mod bier
     vrf for v1
     ipv6 addr 4321::1112 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff0
     exit
    ```

=== "Verification"

    ```
    r1 tping 0 20 2.2.2.4 vrf v1 sou lo0
    r4 tping 0 20 2.2.2.1 vrf v1 sou lo0
    r1 tping 0 20 4321::4 vrf v1 sou lo0
    r4 tping 0 20 4321::1 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1
    r1 tping 100 60 4321::1112 vrf v1
    r4 tping 100 60 3.3.3.1 vrf v1
    r4 tping 100 60 4321::1111 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp313](../clab/rout-bgp313/rout-bgp313.yml) file  
        3. Launch ContainerLab `rout-bgp313.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp313.yml  
        ```
        4. Destroy ContainerLab `rout-bgp313.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp313.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp313.tst` file [here](../tst/rout-bgp313.tst)  
        3. Launch `rout-bgp313.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp313 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp313.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
