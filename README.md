#### 管理服务器常用 shell 脚本

##### create-public-key.sh 
从管理服务器使用账户密码登录到远程服务器，自动在远程服务器创建公钥，并且把公钥添加到管理服务器

调用方式
````
./create-public-key.sh 192.168.1.2 password
````

##### create-proxy.sh
在服务器上创建 https 代理服务

调用方式
````
./create-proxy.sh
````

##### remote-install-script.sh
远程部署脚本

在管理服务器给远程服务器安装服务