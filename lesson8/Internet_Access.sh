#!/bin/bash


aws ec2 create-route --route-table-id rtb-01ef647c9d86c61e7 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-028c68053e8092df9
