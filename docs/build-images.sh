#!/bin/bash


MODULE=$1 #变量传入模块名
TIME=`date "+%Y%m%d%H%M"` #获取当前时间年月日时分作为tag中一部分
GIT_REVERSION=`git log -1 --pretty=format:"%h"` # 当前拉取的代码的最新版本号
IMAGE_NAME=hub.mydocker.com/micro-service/${MODULE}:${TIME}_${GIT_REVERSION}  #镜像名字和版本

cd ${MODULE}
#build镜像
docker build -t ${IMAGE_NAME} .
cd -
# 推镜像到仓库
docker push ${IMAGE_NAME}
# 将镜像名写入到IMAGE_NAME文件中，供deploy时使用
echo "${IMAGE_NAME}" > IMAGE_NAME