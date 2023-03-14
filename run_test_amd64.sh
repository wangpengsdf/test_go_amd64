#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    echo "必须输入一个SSH的目标服务器" && exit -1
fi

export UPLOAD_FILE="test_amd64.tar.bz2"
export UPLOAD_TEST_DIR="/tmp/test_amd64_asjaslhjashdyamgps"

# 创建临时工作目录
mkdir -p $UPLOAD_TEST_DIR
cd $UPLOAD_TEST_DIR

# 生成一个空的main.go
cat << EOF > main.go
package main

func main() {}
EOF

# 编译不同GOAMD64的程序
GOAMD64=v4 GOOS=linux GOARCH=amd64 go build -o v4 main.go
GOAMD64=v3 GOOS=linux GOARCH=amd64 go build -o v3 main.go
GOAMD64=v2 GOOS=linux GOARCH=amd64 go build -o v2 main.go
rm -rf main.go

# 打包并上传，# 删除本地文件
tar zcf $UPLOAD_FILE v4 v3 v2
scp $UPLOAD_FILE $1:/tmp >> /dev/null 2>&1
rm -rf $UPLOAD_FILE  v4 v3 v2

# 生成测试脚本
cat << EOF > test_amd64.sh
mkdir -p $UPLOAD_TEST_DIR;
mv /tmp/$UPLOAD_FILE $UPLOAD_TEST_DIR;
cd $UPLOAD_TEST_DIR && tar zxf $UPLOAD_FILE;
$UPLOAD_TEST_DIR/v4 > /dev/null 2>&1 && echo 'support AMD64 V4' && rm -rf $UPLOAD_TEST_DIR && exit;
$UPLOAD_TEST_DIR/v3 > /dev/null 2>&1 && echo 'support AMD64 V3' && rm -rf $UPLOAD_TEST_DIR && exit;
$UPLOAD_TEST_DIR/v2 > /dev/null 2>&1 && echo 'support AMD64 V2' && rm -rf $UPLOAD_TEST_DIR && exit;
echo 'support AMD64 V1' && rm -rf $UPLOAD_TEST_DIR && exit;
EOF

# 执行测试脚本
ssh $1 'bash -s' < test_amd64.sh

# 删除本地脚本
rm -rf $UPLOAD_TEST_DIR
