#!/bin/bash
set -e

# 检查是否指定了 compose 文件
if [ -z "$1" ]; then
  echo "用法: $0 <docker-compose.yml路径>"
  exit 1
fi

COMPOSE_FILE="$1"
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "错误: 找不到指定的文件 $COMPOSE_FILE"
  exit 1
fi

PROJECT_DIR=$(basename "$(pwd)")
COMPOSE_BASENAME=$(basename "$COMPOSE_FILE" .yml)
IMAGES_FILE="${PROJECT_DIR}_images.txt"
IMAGES_TAR="${PROJECT_DIR}_images.tar"
PACKAGE="${PROJECT_DIR}_docker_project_backup.tar.gz"
INSTALL_SH="install_${PROJECT_DIR}.sh"

echo "开始打包项目，提取镜像信息..."

# 提取镜像名列表
docker compose -f "$COMPOSE_FILE" config | grep 'image:' | awk '{print $2}' | sort -u > "$IMAGES_FILE"

echo "收集到的镜像列表："
cat "$IMAGES_FILE"

echo "开始导出镜像，可能需要一些时间，请耐心等待..."

# 导出镜像到tar
xargs docker save -o "$IMAGES_TAR" < "$IMAGES_FILE"

echo "导出镜像完成，正在生成安装脚本..."

# 生成安装脚本（只导入镜像，不自动启动容器）
cat > "$INSTALL_SH" <<EOF
#!/bin/bash
set -e

echo "正在导入镜像..."
docker load -i $IMAGES_TAR

echo "镜像导入完成。"
echo "你可以使用以下命令启动服务："
echo "docker compose -f $COMPOSE_FILE up -d"
EOF

chmod +x "$INSTALL_SH"

echo "生成压缩包..."

# 打包compose文件、镜像、列表和安装脚本
tar czvf "$PACKAGE" "$COMPOSE_FILE" "$IMAGES_TAR" "$IMAGES_FILE" "$INSTALL_SH"

echo "打包完成！生成的包为: $PACKAGE"

# 清理中间文件
echo "删除临时文件..."
rm -f "$IMAGES_FILE" "$IMAGES_TAR" "$INSTALL_SH"
echo "临时文件已删除，打包过程结束！"
echo ""
echo "操作说明："
echo "1. 将 $PACKAGE 上传到目标服务器（例如用 scp 或 ftp 工具）"
echo "2. 登录到服务器，进入存放压缩包的目录"
echo "3. 解压压缩包，命令如下："
echo "   tar xzvf $PACKAGE"
echo "4. 运行自动生成的安装脚本，命令如下："
echo "   ./install_${PROJECT_DIR}.sh"
echo ""
echo "安装脚本会自动导入项目所需的所有镜像。"
echo "最后，你可以手动启动服务，命令如下："
echo "   docker compose -f $COMPOSE_FILE up -d"
echo ""
echo "----------"
