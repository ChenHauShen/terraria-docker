#!/bin/sh

echo "\n启动配置:\nconfigpath=$CONFIGPATH\nworldpath=$WORLDPATH\nlogpath=$LOGPATH\n"
echo "复制插件..."
cp -Rfv /plugins/* ./ServerPlugins

mono --server --gc=sgen -O=all TerrariaServer.exe -configPath "$CONFIGPATH" -worldpath "$WORLDPATH" -logpath "$LOGPATH" "$@" 