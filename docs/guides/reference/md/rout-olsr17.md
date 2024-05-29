# Example: olsr outgoing metric with routepolicy

=== "Topology"

    ![Alt text](../d2/rout-olsr17/rout-olsr17.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router olsr4 1
     vrf v1
     exit
    router olsr6 1
     vrf v1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.111 255.255.255.255
     ipv6 addr 4321::111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.222 255.255.255.255
     ipv6 addr 4321::222 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    server telnet tel
     vrf v1
     port 666
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router olsr4 1
     vrf v1
     red conn
     exit
    router olsr6 1
     vrf v1
     red conn
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
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router olsr4 1
     vrf v1
     exit
    router olsr6 1
     vrf v1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.111 255.255.255.255
     ipv6 addr 4321::111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    route-policy rm1
     set metric +200
     pass
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     router olsr4 1 route-policy-out rm1
     router olsr6 1 route-policy-out rm1
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 100 130 2.2.2.3 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r1 tping 100 130 4321::3 vrf v1
    r2 tping 100 130 2.2.2.1 vrf v1
    r2 tping 100 130 2.2.2.3 vrf v1
    r2 tping 100 130 4321::1 vrf v1
    r2 tping 100 130 4321::3 vrf v1
    r3 tping 100 130 2.2.2.1 vrf v1
    r3 tping 100 130 2.2.2.2 vrf v1
    r3 tping 100 130 4321::1 vrf v1
    r3 tping 100 130 4321::2 vrf v1
    r2 tping 100 130 2.2.2.111 vrf v1
    r2 tping 100 130 4321::111 vrf v1
    r2 tping 0 130 2.2.2.222 vrf v1
    r2 tping 0 130 4321::222 vrf v1
    r2 send telnet 2.2.2.111 666 vrf v1
    r2 tping 100 130 2.2.2.222 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 130 2.2.2.222 vrf v1
    r2 send telnet 4321::111 666 vrf v1
    r2 tping 100 130 2.2.2.222 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 130 2.2.2.222 vrf v1
    r2 output show ipv4 olsr 1 sum
    r2 output show ipv6 olsr 1 sum
    r2 output show ipv4 olsr 1 dat
    r2 output show ipv6 olsr 1 dat
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-olsr17](../clab/rout-olsr17/rout-olsr17.yml) file  
        3. Launch ContainerLab `rout-olsr17.yml` topology:  

        ```
           containerlab deploy --topo rout-olsr17.yml  
        ```
        4. Destroy ContainerLab `rout-olsr17.yml` topology:  

        ```
           containerlab destroy --topo rout-olsr17.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-olsr17.tst` file [here](../tst/rout-olsr17.tst)  
        3. Launch `rout-olsr17.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-olsr17 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-olsr17.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
