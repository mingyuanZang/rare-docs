# Example: ibgp with nexthop tracking routepolicy

=== "Topology"

    ![Alt text](../d2/rout-bgp250/rout-bgp250.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
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
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    route-policy rm1
     if distance 0
      pass
     enif
     exit
    route-policy rm2
     set aspath 3 3 3
     pass
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     nexthop route-policy rm1
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 route-policy-in rm2
     neigh 1.1.1.2 route-policy-out rm2
     neigh 1.1.1.6 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     nexthop route-policy rm1
     neigh 1234:1::2 remote-as 1
     neigh 1234:1::2 route-policy-in rm2
     neigh 1234:1::2 route-policy-out rm2
     neigh 1234:2::2 remote-as 1
     red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
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
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    route-policy rm1
     if distance 0
      pass
     enif
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.2
     nexthop route-policy rm1
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.5 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.2
     nexthop route-policy rm1
     neigh 1234:1::1 remote-as 1
     neigh 1234:2::1 remote-as 1
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    sleep 3000
    r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 5 4321::2 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 5 4321::1 vrf v1 sou lo0
    r1 send conf t
    r1 send int eth2
    r1 send shut
    r1 send end
    r2 send conf t
    r2 send int eth2
    r2 send shut
    r2 send end
    r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 5 4321::2 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 5 4321::1 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp250](../clab/rout-bgp250/rout-bgp250.yml) file  
        3. Launch ContainerLab `rout-bgp250.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp250.yml  
        ```
        4. Destroy ContainerLab `rout-bgp250.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp250.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp250.tst` file [here](../tst/rout-bgp250.tst)  
        3. Launch `rout-bgp250.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp250 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp250.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
