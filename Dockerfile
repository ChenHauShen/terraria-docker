FROM alpine:3.11.6 AS base

RUN apk add --update-cache \
    unzip

# 复制启动文件
COPY bootstrap.sh /tshock/bootstrap.sh

# 下载和解压 TShock
ADD https://github.com/Pryaxis/TShock/releases/download/v4.4.0-pre8/TShock_4.4.0_Pre8_Terraria1.4.0.4.zip /
RUN unzip TShock_4.4.0_Pre8_Terraria1.4.0.4.zip-d /tshock && \
    rm TShock_4.4.0_Pre8_Terraria1.4.0.4.zip && \
    chmod +x /tshock/TerrariaServer.exe && \
    # 将bootstrap.sh添加可执行权限
    chmod +x /tshock/bootstrap.sh

FROM mono:6.8.0.96-slim

LABEL maintainer="Chenhao Shen <shenchenhao1234@hotmail.com>"

# 增加端口映射
EXPOSE 7777 7878

# 增加环境变量
ENV WORLDPATH=/world
ENV CONFIGPATH=/world
ENV LOGPATH=/tshock/logs

# 增加文件目录映射
VOLUME ["/world", "/tshock/logs", "/plugins"]

# 安装tshock依赖
RUN apt-get update -y && \
    apt-get install -y nuget && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# 复制游戏文件
COPY --from=base /tshock/ /tshock/

# 设置服务器工作目录
WORKDIR /tshock

# 运行bootstrap.sh
ENTRYPOINT [ "/bin/sh", "bootstrap.sh" ]