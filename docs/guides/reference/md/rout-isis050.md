# Example: isis with bier

=== "Topology"

    ![Alt text](../d2/rout-isis050/rout-isis050.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     is-type level2
     bier 256 10
     both bier
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     is-type level2
     bier 256 10
     both bier
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     router isis4 1 ena
     router isis4 1 bier index 1
     exit
    int lo2
     vrf for v1
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 bier index 1
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv4 access-group-in test4
     mpls enable
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 access-group-in test6
     mpls enable
     router isis6 1 ena
     exit
    int tun1
     tun sou lo1
     tun dest 9.9.9.9
     tun doma 2.2.2.3
     tun vrf v1
     tun key 1
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     exit
    int tun2
     tun sou lo2
     tun dest 9999::9
     tun doma 4321::3
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
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.2222.00
     is-type level2
     bier 256 10
     both bier
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.2222.00
     is-type level2
     bier 256 10
     both bier
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     router isis4 1 ena
     router isis4 1 bier index 2
     exit
    int lo2
     vrf for v1
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 bier index 2
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv4 access-group-in test4
     mpls enable
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv6 access-group-in test6
     mpls enable
     router isis6 1 ena
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv4 access-group-in test4
     mpls enable
     router isis4 1 ena
     exit
    int eth2.12
     vrf for v1
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv6 access-group-in test6
     mpls enable
     router isis6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.3333.00
     is-type level2
     bier 256 10
     both bier
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.3333.00
     is-type level2
     bier 256 10
     both bier
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     router isis4 1 ena
     router isis4 1 bier index 3
     exit
    int lo2
     vrf for v1
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 bier index 3
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv4 access-group-in test4
     mpls enable
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv6 access-group-in test6
     mpls enable
     router isis6 1 ena
     exit
    int tun1
     tun sou lo1
     tun dest 9.9.9.9
     tun doma 2.2.2.1
     tun vrf v1
     tun key 3
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     exit
    int tun2
     tun sou lo2
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
    r1 tping 0 20 2.2.2.3 vrf v1 sou lo1
    r3 tping 0 20 2.2.2.1 vrf v1 sou lo1
    r1 tping 0 20 4321::3 vrf v1 sou lo2
    r3 tping 0 20 4321::1 vrf v1 sou lo2
    r1 tping 100 20 3.3.3.2 vrf v1
    r1 tping 100 20 4321::1112 vrf v1
    r3 tping 100 20 3.3.3.1 vrf v1
    r3 tping 100 20 4321::1111 vrf v1
    r2 output show ipv4 isis 1 nei
    r2 output show ipv6 isis 1 nei
    r2 output show ipv4 isis 1 dat 2
    r2 output show ipv6 isis 1 dat 2
    r2 output show ipv4 isis 1 tre 2
    r2 output show ipv6 isis 1 tre 2
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    r2 output show ipv4 bier v1
    r2 output show ipv6 bier v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-isis050](../clab/rout-isis050/rout-isis050.yml) file  
        3. Launch ContainerLab `rout-isis050.yml` topology:  

        ```
           containerlab deploy --topo rout-isis050.yml  
        ```
        4. Destroy ContainerLab `rout-isis050.yml` topology:  

        ```
           containerlab destroy --topo rout-isis050.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis050.tst` file [here](../tst/rout-isis050.tst)  
        3. Launch `rout-isis050.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis050 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis050.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
