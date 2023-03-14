# test_go_amd64
一个用来测试服务器的GOAMD64支持情况的脚本，方便用户在编译时设置GOAMD64参数，本脚本只支持x86架构的Linux服务器。

### 用法
`
run_test_amd64.sh ubuntu@192.168.100.128
`

也可以配置SSH Config文件
`
Host lan_server
  Hostname 192.168.100.128
  User ubuntu
`
然后直接

`
run_test_amd64.sh lan_server
`
