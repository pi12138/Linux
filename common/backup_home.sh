#!/usr/bin/env bash
#
# backup_home.sh - 备份用户目录脚本
#
# 功能：
#   - 备份指定用户目录（默认当前用户 HOME）
#   - 支持排除指定目录（默认保留 .git，可通过参数排除）
#   - 备份文件和还原脚本默认输出到 /tmp（支持自定义输出路径）
#   - 自动生成还原脚本，内置备份文件路径，方便一键还原
#
# 注意事项：
#   - /tmp 目录可能是 tmpfs（内存盘），重启后文件会丢失，请及时移动备份文件和还原脚本到持久存储
#
# 用法：
#   ./backup_home.sh [选项]
#
# 选项：
#   --output <path>       指定备份文件输出路径（同时生成同目录的还原脚本）
#   --home <path>         指定要备份的用户目录，默认为 $HOME
#   --exclude-git         备份时排除 .git 目录
#   --exclude <dir>       备份时排除指定目录，可多次使用
#
# 示例：
#   ./backup_home.sh
#   ./backup_home.sh --exclude-git --exclude node_modules
#   ./backup_home.sh --output /home/pi/backup/home_backup.tar.gz --home /home/pi
#
# 还原方法：
#   备份完成后，会在备份文件同目录生成还原脚本，示例：
#     /tmp/restore_home_20230811_123456.sh
#   拷贝备份文件和还原脚本到新系统，执行：
#     ./restore_home_20230811_123456.sh
#

set -e

HOME_DIR="$HOME"
DATE=$(date +%Y%m%d_%H%M%S)
TMP_DIR="/tmp"
BACKUP_FILE="${TMP_DIR}/home_backup_${DATE}.tar.gz"
RESTORE_SCRIPT="${TMP_DIR}/restore_home_${DATE}.sh"

# 默认排除列表（包含备份文件自身，后续生成时动态替换备份文件名）
DEFAULT_EXCLUDES=(
  ".cache"
  ".npm"
  "Downloads"
  ".local/share/Trash"
  "__BACKUP_FILE__"  # 占位符，稍后替换成实际文件名
  ".codeium"
  ".pyenv/versions"
  ".go"
  ".vscode-remote-containers"
  ".vscode-server"
  ".nvm/versions"
)

EXCLUDE_LIST=()

# 生成排除参数，替换占位符
for d in "${DEFAULT_EXCLUDES[@]}"; do
  if [[ "$d" == "__BACKUP_FILE__" ]]; then
    EXCLUDE_LIST+=("--exclude=$(basename "$BACKUP_FILE")")
  else
    EXCLUDE_LIST+=("--exclude=$d")
  fi
done

# 解析用户参数，用户传的排除参数也会加进 EXCLUDE_LIST
while [[ $# -gt 0 ]]; do
    case "$1" in
        --output)
            BACKUP_FILE="$2"
            RESTORE_SCRIPT="${BACKUP_FILE%.*}_restore.sh"
            # 这里更新排除列表里的备份文件名
            EXCLUDE_LIST=()
            for d in "${DEFAULT_EXCLUDES[@]}"; do
              if [[ "$d" == "__BACKUP_FILE__" ]]; then
                EXCLUDE_LIST+=("--exclude=$(basename "$BACKUP_FILE")")
              else
                EXCLUDE_LIST+=("--exclude=$d")
              fi
            done
            shift 2
            ;;
        --home)
            HOME_DIR="$2"
            shift 2
            ;;
        --exclude-git)
            EXCLUDE_LIST+=("--exclude=.git")
            shift
            ;;
        --exclude)
            EXCLUDE_LIST+=("--exclude=$2")
            shift 2
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

echo "开始备份: $HOME_DIR -> $BACKUP_FILE"
echo "默认排除目录: ${DEFAULT_EXCLUDES[*]}"
echo "最终排除列表: ${EXCLUDE_LIST[*]}"
echo

tar czvf "$BACKUP_FILE" "${EXCLUDE_LIST[@]}" -C "$HOME_DIR" .

echo "备份完成: $BACKUP_FILE"

# 生成还原脚本
cat > "$RESTORE_SCRIPT" << EOF
#!/usr/bin/env bash
set -euo pipefail

BACKUP_FILE="${BACKUP_FILE}"
TARGET_DIR="\$HOME"

if [[ ! -f "\$BACKUP_FILE" ]]; then
    echo "错误：备份文件 \$BACKUP_FILE 不存在！"
    exit 1
fi

echo "开始解压备份文件 \$BACKUP_FILE 到 \$TARGET_DIR"
mkdir -p "\$TARGET_DIR"
tar xzvf "\$BACKUP_FILE" -C "\$TARGET_DIR"

echo "设置常用 SSH 密钥权限（如果存在）..."
if [[ -d "\$TARGET_DIR/.ssh" ]]; then
  chmod 700 "\$TARGET_DIR/.ssh"
  chmod 600 "\$TARGET_DIR/.ssh/"* || true
  echo "  SSH 权限已修正"
fi

echo "还原完成！"
EOF

chmod +x "$RESTORE_SCRIPT"

echo "生成还原脚本: $RESTORE_SCRIPT"
echo ""
echo "注意：/tmp 可能是临时文件系统，文件可能会在重启后丢失。"
echo "请尽快将备份文件和还原脚本移动到持久存储，比如："
echo "  mv $BACKUP_FILE ~/"
echo "  mv $RESTORE_SCRIPT ~/"

