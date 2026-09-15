# Day 1 · 环境搭建指南

> **今天唯一的目标**：在 WSL 里跑通 `python hello.py`，并且成功 `git commit` 一次。
> 你的方案：**Windows + WSL2 (Ubuntu 22.04) + NVIDIA 独显**

建议节奏（对齐你计划里的时间表）：

| 时间 | 做什么 |
|------|--------|
| 09:00–11:00 | 第 0–2 步：体检 + 装 WSL2 |
| 11:00–12:00 | 第 3–5 步：基础工具 + conda 环境 |
| 14:00–17:00 | 第 6–7 步：装 PyTorch（最容易卡，留足时间）+ VS Code |
| 19:00–21:00 | 第 8–10 步：GitHub + 跑代码 + 提交 |
| 21:00–21:30 | 写 `README.md` 学习记录 |

---

## 第 0 步：先体检，再动手

1. 把今天收到的文件放进一个文件夹，例如 `D:\embodied-ai-learning\week01\day01\`。
2. **Windows 端**：在该文件夹里打开 PowerShell，执行：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\check_env.ps1
   ```
   会生成 `env_report_windows.txt`。
3. **WSL 端**（等第 2 步装完 WSL 后再来）：在 Ubuntu 终端里执行
   ```bash
   bash check_env.sh
   ```
   会生成 `env_report_linux.txt`。
4. 把这两个 txt 的内容整体贴给我，我帮你判断缺什么、怎么补。

> 现在还没装 WSL，就先做第 1 步，装完再回头跑 Linux 端脚本。

---

## 第 1 步：确认 NVIDIA Windows 驱动

有独显的话，先在 Windows PowerShell 里敲：

```powershell
nvidia-smi
```

能打印出**显卡型号**和右上角的 **CUDA Version** 就说明驱动 OK。

> ⚠️ 关键坑：**WSL 直接用 Windows 的显卡驱动，不要在 WSL 里再装一遍显卡驱动**，那会把环境搞坏。没有输出就去 NVIDIA 官网按型号装 Game Ready / Studio 驱动。

---

## 第 2 步：装 WSL2 + Ubuntu 22.04

以**管理员身份**打开 PowerShell：

```powershell
wsl --install -d Ubuntu-22.04
```

装完**重启电脑**。重启后 Ubuntu 会自动弹出来，让你设一个 Linux 用户名和密码（密码记牢，`sudo` 要用，输入时屏幕不显示是正常的）。

验证：

```powershell
wsl -l -v
```

应看到 `Ubuntu-22.04`，且 `VERSION` 为 `2`。

如果 `wsl --install` 报错，先执行一次 `wsl --update` 再重试。

---

## 第 3 步：WSL 基础配置

进入 Ubuntu（开始菜单搜 `Ubuntu`，或在 PowerShell 里直接敲 `wsl`）。

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential git curl wget vim
git --version
```

`build-essential` 以后编译依赖会用到，先装上省事。

---

## 第 4 步：装 Miniconda

```bash
cd ~
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda3
$HOME/miniconda3/bin/conda init
```

**关掉终端，重新打开**（让 `conda init` 生效），然后：

```bash
conda --version
```

> 下载慢的话，可以换国内镜像，或先手动下载好再 `bash miniconda.sh -b -p $HOME/miniconda3`。

---

## 第 5 步：创建项目环境

以后具身智能相关的东西都放进这个环境，保持干净：

```bash
conda create -n embodied python=3.11 -y
conda activate embodied
python --version          # 应为 3.11.x
```

终端提示符前面出现 `(embodied)` 就对了。

> **以后每次开新终端，第一件事就是** `conda activate embodied`，不然用的可能是系统 Python。

---

## 第 6 步：装 PyTorch（CUDA 版）

先看你的显卡驱动支持的 CUDA 上限：Windows 里 `nvidia-smi` 右上角 `CUDA Version: 12.x`。

然后**不要凭记忆敲安装命令**，打开官方选择器，按你的情况勾选，把生成的命令复制过来：

👉 https://pytorch.org/get-started/locally/

形式大致是这样（`cuXXX` 以官方页面当时为准，可能比下面更新）：

```bash
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu126
```

装完在 `embodied` 环境里验证：

```bash
python -c "import torch; print(torch.__version__, torch.cuda.is_available(), torch.cuda.get_device_name(0))"
```

- 打印出版本号，且是 `True` + 你的显卡名 → ✅ 成功
- 打印 `False` → 说明 torch 装成了 CPU 版或 GPU 没透传，把 `check_env.sh` 的结果贴给我
- `ImportError` → torch 没装上，回到安装步骤

> **这一步不用追求完美**。就算暂时只有 CPU 版，第一周的 MNIST 也完全够用，别卡在这里。

---

## 第 7 步：VS Code + WSL 插件

1. Windows 上装 VS Code：https://code.visualstudio.com/
2. 打开 VS Code，在扩展市场里搜索并安装：
   - **WSL**（Microsoft 官方）
   - **Python**（Microsoft）
   - **Jupyter**
3. 在 Ubuntu 终端里进入代码目录，敲：
   ```bash
   code .
   ```
   会自动以 WSL 模式打开 VS Code，左下角显示 `WSL: Ubuntu-22.04`。
4. 打开 `.py` 文件时，右下角把 Python 解释器选成 `embodied` 那个。

---

## 第 8 步：GitHub 仓库 + Git 配置

配一次 Git 身份（邮箱换成你 GitHub 的）：

```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
git config --global init.defaultBranch main
```

到 GitHub 网页新建仓库 `embodied-ai-learning`（public / private 都行，**不要**勾 "Add a README"，要空仓库）。

回到 WSL：

```bash
cd ~
mkdir -p embodied-ai-learning/week01/day01
cd embodied-ai-learning
git init
# 把 day01 的文件复制进来（下面路径换成你实际放文件的路径）
cp /mnt/d/embodied-ai-learning/week01/day01/*.py   week01/day01/
cp /mnt/d/embodied-ai-learning/week01/day01/*.sh   week01/day01/
cp /mnt/d/embodied-ai-learning/week01/day01/*.ps1  week01/day01/
cp /mnt/d/embodied-ai-learning/week01/day01/*.md   week01/day01/
# 关联远程仓库（换成你自己的地址）
git remote add origin https://github.com/你的用户名/embodied-ai-learning.git
```

> 小知识：WSL 里 Windows 的 `D:` 盘就是 `/mnt/d/`。
> 但**代码建议放在 WSL 家目录 `~/`**（也就是上面这样），读写更快，也不会遇到权限怪问题。

---

## 第 9 步：跑通今天的代码

```bash
conda activate embodied
cd ~/embodied-ai-learning/week01/day01
python hello.py
python python_basics.py
```

两份都出结果 → Day 1 的代码部分完成。

---

## 第 10 步：提交

```bash
cd ~/embodied-ai-learning
git add .
git commit -m "day1: python basics + hello world + env report"
git push -u origin main
```

> 如果 `push` 提示要密码：GitHub 现在**不能用账号密码**，要用 **Personal Access Token**
> （GitHub → Settings → Developer settings → Personal access tokens），当密码填进去；
> 或者配 SSH key。第一次会有点绕，卡住就把完整报错贴给我。

---

## Day 1 验收清单

- [ ] `check_env.ps1` 跑过，拿到 `env_report_windows.txt`
- [ ] `wsl -l -v` 显示 Ubuntu-22.04 / VERSION 2
- [ ] `check_env.sh` 跑过，拿到 `env_report_linux.txt`
- [ ] `conda activate embodied` 能进环境，`python --version` = 3.11.x
- [ ] `python -c "import torch; ..."` 能打印出结果（哪怕是 False）
- [ ] `python hello.py` 跑通
- [ ] `python python_basics.py` 跑通
- [ ] GitHub 上有 `embodied-ai-learning` 仓库，`week01/day01/` 已提交
- [ ] `week01/day01/README.md` 写好了今天的学习记录

**顺序就是**：体检 → 装 WSL → conda 环境 → torch → 跑代码 → 提交。
任何一步报错，把**完整报错信息**贴给我，不要自己硬扛。
