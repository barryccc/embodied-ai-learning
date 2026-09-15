#!/usr/bin/env bash
# =====================================================================
#  Day 1 · 第 4–6 步 一键脚本
#  Miniconda + conda 环境 embodied + PyTorch(CUDA)
# ---------------------------------------------------------------------
#  用法（在 WSL / Ubuntu 终端里，进到本文件所在目录）：
#
#      bash day1_setup.sh
#
#  想换 PyTorch 的 CUDA 版本（默认 cu126）：
#
#      CUDA_TAG=cu128 bash day1_setup.sh
#
#  可以重复运行：装好的步骤会自动跳过。
# =====================================================================

set -u

CUDA_TAG="${CUDA_TAG:-cu126}"
CONDA_DIR="$HOME/miniconda3"
ENV_NAME="embodied"

info() { printf "\n\033[36m===== %s =====\033[0m\n" "$1"; }
ok()   { printf "\033[32m[OK] %s\033[0m\n" "$1"; }
warn() { printf "\033[33m[!]  %s\033[0m\n" "$1"; }
die()  { printf "\033[31m[×]  %s\033[0m\n" "$1"; echo; echo "把上面这段完整贴给 Claude。"; exit 1; }

# ---------------------------------------------------------------- 0
info "0. 环境检查"
if grep -qi microsoft /proc/version 2>/dev/null; then
    ok "确认在 WSL 里"
else
    warn "没检测到 WSL 特征，但仍会继续（原生 Linux 也可以）"
fi
command -v sudo >/dev/null 2>&1 || die "找不到 sudo"
[ -n "${HOME:-}" ] || die "HOME 变量为空"

# ---------------------------------------------------------------- 1
info "1. 安装编译工具 (build-essential)"
if command -v gcc >/dev/null 2>&1 && command -v make >/dev/null 2>&1; then
    ok "gcc / make 已存在，跳过"
else
    echo "（下面 sudo 会让你输密码，输入时屏幕不动是正常的）"
    sudo apt update && sudo apt install -y build-essential || die "apt 安装 build-essential 失败"
    ok "build-essential 装好"
fi

# ---------------------------------------------------------------- 2
info "2. 安装 Miniconda"
if [ -x "$CONDA_DIR/bin/conda" ]; then
    ok "Miniconda 已存在于 $CONDA_DIR，跳过"
else
    cd "$HOME" || die "无法进入 HOME 目录"
    if [ ! -f "$HOME/miniconda.sh" ]; then
        echo "下载 Miniconda（几百 MB，走代理应该还行）..."
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "$HOME/miniconda.sh" \
            || die "下载 Miniconda 失败 —— 多半是代理没生效"
    fi
    bash "$HOME/miniconda.sh" -b -p "$CONDA_DIR" || die "Miniconda 安装脚本执行失败"
    ok "Miniconda 装到 $CONDA_DIR"
fi

# ---------------------------------------------------------------- 3
info "3. conda init（写入 ~/.bashrc）"
"$CONDA_DIR/bin/conda" init bash >/dev/null 2>&1 || warn "conda init 返回非零，通常可忽略"
ok "已写入 ~/.bashrc（下次新开终端自动生效）"

# ---------------------------------------------------------------- 3.5
info "3.5 配置 conda-forge 社区源"
# 关键：直接写死 ~/.condarc。
# 不要用 'conda config --add channels conda-forge' —— 它会把 defaults 一起写进去，
# 而 defaults (repo.anaconda.com) 会触发 Anaconda 的 Terms of Service 检查。
if [ -f "$HOME/.condarc" ]; then
    cp "$HOME/.condarc" "$HOME/.condarc.bak.$(date +%s)"
    warn "已备份原有 ~/.condarc"
fi
cat > "$HOME/.condarc" <<'YAML'
channels:
  - conda-forge
channel_priority: strict
show_channel_urls: true
YAML
ok "已写入 ~/.condarc"

echo "--- 当前生效的 conda 配置来源 ---"
"$CONDA_DIR/bin/conda" config --show-sources 2>/dev/null
echo "--- 当前 channels ---"
"$CONDA_DIR/bin/conda" config --show channels 2>/dev/null
echo "（channels 里不应该再出现 defaults，出现就是没配好）"

# 让当前脚本也能用 conda
# shellcheck disable=SC1091
source "$CONDA_DIR/etc/profile.d/conda.sh" || die "source conda.sh 失败"

# ---------------------------------------------------------------- 4
info "4. 创建 conda 环境 $ENV_NAME (python 3.11)"
if [ -d "$CONDA_DIR/envs/$ENV_NAME" ]; then
    ok "环境 $ENV_NAME 已存在，跳过"
else
    echo "创建中，可能要几分钟..."
    # --override-channels 双保险：彻底忽略任何残留的 defaults
    conda create -n "$ENV_NAME" python=3.11 -y --override-channels -c conda-forge \
        || die "conda create 失败 —— 把报错贴给我"
    ok "环境 $ENV_NAME 创建完成"
fi

conda activate "$ENV_NAME" || die "conda activate $ENV_NAME 失败"
ok "已激活 $ENV_NAME -> $(python --version 2>&1)"

# ---------------------------------------------------------------- 5
info "5. 安装 PyTorch (CUDA $CUDA_TAG) + torchvision"
python -m pip install --upgrade pip >/dev/null 2>&1
if python -c "import torch" >/dev/null 2>&1; then
    ok "torch 已安装，跳过"
else
    echo "从 download.pytorch.org 下载，比较大，耐心等..."
    pip install torch torchvision --index-url "https://download.pytorch.org/whl/$CUDA_TAG" \
        || die "PyTorch 安装失败 —— 把 CUDA_TAG 换成 cu128 再跑一次: CUDA_TAG=cu128 bash day1_setup.sh"
    ok "PyTorch 安装完成"
fi

# ---------------------------------------------------------------- 6
info "6. 验证 PyTorch 和 GPU"
python - <<'PY'
import torch, torchvision
print("torch       :", torch.__version__)
print("torchvision :", torchvision.__version__)
print("cuda avail  :", torch.cuda.is_available())
if torch.cuda.is_available():
    print("cuda version:", torch.version.cuda)
    print("gpu         :", torch.cuda.get_device_name(0))
    print("vram (GB)   :", round(torch.cuda.get_device_properties(0).total_memory / 1024**3, 1))
PY

info "全部完成"
echo "新开一个终端，然后："
echo "    conda activate $ENV_NAME"
echo "    python hello.py"
echo "    python python_basics.py"
