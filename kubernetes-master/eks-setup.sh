#!/bin/bash

echo '{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "eks.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}' >/tmp/admin.json
aws iam create-role --role-name eksServiceRole --assume-role-policy-document file:///tmp/admin.json
aws iam attach-role-policy --role-name eksServiceRole --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
aws iam attach-role-policy --role-name eksServiceRole --policy-arn arn:aws:iam::aws:policy/AmazonEKSServicePolicy 
ROLENAME=$(aws iam list-roles --query "Roles[*].Arn" --output text |xargs -n1 | grep eksServiceRole)
VPCID=$(aws ec2 describe-vpcs  --filters "Name=isDefault,Values=true" --query "Vpcs[0].VpcId" --output text)
SUBNETS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPCID" --query "Subnets[*].SubnetId" --output text|xargs |sed -e 's/ /,/g')
aws ec2 create-security-group --description eks-sg --group-name eks-sg --vpc-id $VPCID 
SG=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=eks-sg" --query "SecurityGroups[*].GroupId" --output text)
aws eks create-cluster --name devel --role-arn $ROLENAME --resources-vpc-config subnetIds=$SUBNETS,securityGroupIds=$SG
aws eks describe-cluster --name devel --query cluster.status

