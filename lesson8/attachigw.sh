#!/bin/bash

aws ec2 attach-internet-gateway --vpc-id "vpc-0a492537a7a5966d1" --internet-gateway-id "igw-028c68053e8092df9" --region us-east-1
