# 输入法

- fedora 默认的 ibus 智能拼音已经能满足正常需求，但是词库还需优化
- 这里选用 rime 

## 安装rime

- `dnf install ibus-rime`
- 安装完成后重启，然后在输入源中添加中文Rime

## 下载词库

- `git clone git@github.com:iDvel/rime-ice.git $HOME/.config/ibus/rime`
- 部署rime

## 修改部分配置

```shell
echo 'patch:
  # 候选词个数
  "menu/page_size": 8
  "switcher/hotkeys": 
    - Control+F4
  "ascii_composer/switch_key":
    Caps_Lock: clear
    Control_L: noop
    Control_R: noop
    Eisu_toggle: clear
    Shift_L: noop # 关闭左边 shift 的中英文切换功能
    Shift_R: commit_text
    key_binder/bindings/+:
      # 开启逗号句号翻页
      - { when: paging, accept: comma, send: Page_Up }
      - { when: has_menu, accept: period, send: Page_Down }' > $HOME/.config/ibus/rime/default.custom.yaml
```
- 重新部署rime