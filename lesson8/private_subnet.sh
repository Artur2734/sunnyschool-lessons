#!/bin/bash


aws ec2 create-nat-gateway --subnet-id subnet-0d45f555de75e32bc --allocation-id eipalloc-0ac0f55d741187bd5

aws ec2 associate-route-table --subnet-id subnet-0d45f555de75e32bc --route-table-id rtb-051026e806ff19be9

aws ec2 create-route --route-table-id rtb-051026e806ff19be9 --destination-cidr-block 0.0.0.0/0 --nat-gateway-id nat-08a6281be4267026b