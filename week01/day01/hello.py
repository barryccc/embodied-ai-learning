"""
Day 1 · hello.py
=====================================================================
目标：确认 Python 环境可用，跑通你今天第一个脚本。

运行：
    conda activate embodied
    python hello.py

看到 6 行输出，就说明 Python 环境没问题了。
=====================================================================
"""

import sys
import platform
from datetime import datetime

print("=" * 46)
print("Hello, embodied AI!")
print("=" * 46)
print(f"今天日期 : {datetime.now():%Y-%m-%d}")
print(f"Python   : {sys.version.split()[0]}")
print(f"解释器   : {sys.executable}")
print(f"系统     : {platform.system()} {platform.release()}")
print("=" * 46)
print("Day 1 目标：跑通环境 -> 写 Python -> git 提交")
