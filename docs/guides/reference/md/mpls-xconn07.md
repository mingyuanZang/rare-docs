# Example: cross connect with sreth

=== "Topology"

    ![Alt text](../d2/mpls-xconn07/mpls-xconn07.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    int tun1
     tunnel vrf v1
     tunnel mode sreth
     tunnel key 123
     tunnel source ethernet1
     tunnel destination 1.1.1.2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    xconnect con
     side1 v1 eth1 sreth 1.1.1.1 123
     side2 v1 eth2 sreth 1234:2::2 123
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    int tun1
     tunnel vrf v1
     tunnel mode sreth
     tunnel key 123
     tunnel source ethernet1
     tunnel destination 1234:2::1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234:2::2 vrf v1
    r1 tping 100 5 2.2.2.2 vrf v1
    r3 tping 100 5 2.2.2.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-xconn07](../clab/mpls-xconn07/mpls-xconn07.yml) file  
        3. Launch ContainerLab `mpls-xconn07.yml` topology:  

        ```
           containerlab deploy --topo mpls-xconn07.yml  
        ```
        4. Destroy ContainerLab `mpls-xconn07.yml` topology:  

        ```
           containerlab destroy --topo mpls-xconn07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-xconn07.tst` file [here](../tst/mpls-xconn07.tst)  
        3. Launch `mpls-xconn07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-xconn07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-xconn07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
