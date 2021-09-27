#!/usr/bin/env bash
# 编译+部署order站点

# 需要配置如下参数
# 项目路径, 在Execute Shell中配置项目路径, pwd 就可以获得该项目路径
# export PROJ_PATH=这个jenkins任务在部署机器上的路径

# 输入你的环境上tomcat的全路径
# export TOMCAT_APP_PATH=tomcat在部署机器上的路径

# 自定义的Shell函数
killTomcat()
{
    pid =`ps -ef|grep tomcat|grep java|awk '{print $2}'`
    echo "tomcat PID list: $pid"
    if [ "$pid" = "" ]
    then
      echo "no tomcat PID alive"
    else
      kill -9 $pid
    fi
}

# 进入项目目录
cd $PROJ_PATH/order
# maven打包到本地仓库
mvn clean install
# 停止Tomcat
killTomcat

# 部署应用程序：删除原有项目，复制新的项目并改名为ROOT.war
rm -rf $TOMCAT_APP_PATH/webapps/ROOT
rm -f $TOMCAT_APP_PATH/webapps/ROOT.war
rm -f $TOMCAT_APP_PATH/webapps/order.war
cp $PROJ_PATH/order/target/order.war $TOMCAT_APP_PATH/webapps/
cd $TOMCAT_APP_PATH/webapps/
mv order.war ROOT.war

# 启动Tomcat
cd $TOMCAT_APP_PATH/
sh bin/startup.sh
