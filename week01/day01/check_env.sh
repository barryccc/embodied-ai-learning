#!/usr/bin/env bash
# =====================================================================
#  Day 1 环境体检脚本 —— WSL / Ubuntu 端
# ---------------------------------------------------------------------
#  作用：打印 Python / Conda / Git / PyTorch / CUDA / GPU 等关键信息，
#        结果同时打印到屏幕并保存为 env_report_linux.txt。
#
#  用法（在 WSL 的 Ubuntu 终端里）：
#
#      bash check_env.sh
#
#  然后把生成的文件内容整体贴给 Claude。
# =====================================================================

REPORT="env_report_linux.txt"

{
  sec() { echo ""; echo "===== $1 ====="; }
  have() {
    if command -v "$1" >/dev/null 2>&1; then
      echo "OK   : $1  ->  $(command -v "$1")"
    else
      echo "缺失 : $1"
    fi
  }

  sec "时间"
  date

  sec "系统"
  grep -E "^(NAME|VERSION)=" /etc/os-release 2>/dev/null
  uname -a
  if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "结论 : 运行在 WSL 中，发行版 = ${WSL_DISTRO_NAME:-未知}"
  else
    echo "结论 : 原生 Linux（不是 WSL）"
  fi

  sec "硬件"
  echo "CPU 核心数 : $(nproc)"
  free -h | head -2
  echo "磁盘 (HOME) :"
  df -h "$HOME"

  sec "基础工具"
  have git;    git --version 2>/dev/null
  have curl
  have wget
  have gcc
  have make
  echo "--- git 身份 ---"
  echo "user.name  : $(git config --global user.name  2>/dev/null)"
  echo "user.email : $(git config --global user.email 2>/dev/null)"

  sec "Python"
  have python3; python3 --version 2>/dev/null
  have pip3;    pip3 --version 2>/dev/null

  sec "Conda"
  have conda
  if command -v conda >/dev/null 2>&1; then
    conda --version
    echo "--- 已有 conda 环境 ---"
    conda env list 2>/dev/null
  fi

  sec "GPU 透传 (WSL 能不能用显卡的关键)"
  if [ -e /dev/dxg ]; then
    echo "OK   : /dev/dxg 存在 —— WSL GPU 透传已开启"
  else
    echo "缺失 : /dev/dxg 不存在 —— WSL 里可能用不了显卡"
  fi
  if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi
  else
    echo "nvidia-smi 不在 PATH（WSL 里通常由 Windows 驱动自动透传，没有的话先检查 Windows 端驱动）"
  fi

  sec "PyTorch"
  python3 - <<'PY' 2>/dev/null || echo "PyTorch 未安装，或当前 python3 环境里没有 torch"
try:
    import torch, torchvision
    print("torch       :", torch.__version__)
    print("torchvision :", torchvision.__version__)
    print("cuda avail  :", torch.cuda.is_available())
    if torch.cuda.is_available():
        print("cuda version:", torch.version.cuda)
        print("gpu         :", torch.cuda.get_device_name(0))
except ImportError as e:
    print("导入失败 :", e)
PY

  sec "Jupyter / VS Code server"
  have jupyter
  have code

  sec "结束"
  echo "体检完毕。请把 env_report_linux.txt 的内容整体复制，粘给 Claude。"
} 2>&1 | tee "$REPORT"

echo ""
echo ">>> 报告已保存到 : $(pwd)/$REPORT"
echo ">>> 请把这个文件的内容整体复制，粘给 Claude。"
