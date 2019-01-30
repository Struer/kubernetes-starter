#!/bin/bash

IMAGE=`cat IMAGE_NAME` #获取镜像名
DEPLOYMENT=$1  #用于构建deployment的xxx.yaml文件中deployment的名字
MODULE=$2  #用于构建deployment的xxx.yaml文件中deployment下的image的名字
echo "update image to:${IMAGE}"
kubectl set image deployments/${DEPLOYMENT} ${MODULE}=${IMAGE}