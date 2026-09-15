"""
Day 1 · python_basics.py
=====================================================================
覆盖你计划里列出的 Python 基础：
    变量 / list / dict / tuple / set / if / for / while
    函数 / 类 / import / 文件读写 / 异常处理

运行：
    conda activate embodied
    python python_basics.py

重要提醒：不要只运行一遍就完事。
    每一段都自己改一改（改数字、改逻辑、改名字），再跑一次看结果。
    看别人写 100 行，不如自己改 10 行。
=====================================================================
"""

import os     # import：导入 Python 自带的库（标准库）
import json


# ---------- 1. 变量 ----------------------------------------------------
name = "徐子奇"
goal = "具身智能 / VLA 算法工程师"
days_left = 730                       # 两年 ≈ 730 天
print("[1 变量]", name, "|", goal, "| 还剩", days_left, "天")


# ---------- 2. list 列表（有序、可修改）--------------------------------
skills = ["python", "linux", "git", "pytorch"]
skills.append("transformer")          # 尾部追加
skills[0] = "Python"                  # 索引从 0 开始，可以改
print("[2 list]", skills, "| 长度 =", len(skills))


# ---------- 3. dict 字典（键 -> 值）------------------------------------
progress = {"python": 10, "pytorch": 0, "vla": 0}
progress["pytorch"] += 5              # 更新某个键的值
for key, value in progress.items():   # 遍历键值对
    print(f"[3 dict] {key:<8} -> {value}%")


# ---------- 4. tuple 元组（有序、不可修改）-----------------------------
origin = (0.0, 0.0, 0.0)              # 机器人末端的一个坐标，一旦定下不该被改
print("[4 tuple] 坐标 =", origin, "| x =", origin[0])


# ---------- 5. set 集合（自动去重）-------------------------------------
tags = ["vla", "robot", "vla", "il"]  # 注意里面有重复的 "vla"
unique = set(tags)
print("[5 set] 去重后 =", unique, "| 原始个数 =", len(tags), "-> 去重后 =", len(unique))


# ---------- 6. if 条件分支 ---------------------------------------------
hours = 7                             # 试着改成 3.5 或 5 再跑一次
if hours >= 6:
    level = "达标"
elif hours >= 4:
    level = "勉强"
else:
    level = "太少了"
print("[6 if] 今天有效学习", hours, "小时 ->", level)


# ---------- 7. for 循环 ------------------------------------------------
week = ["Day1", "Day2", "Day3", "Day4", "Day5", "Day6", "Day7"]
for i, d in enumerate(week, start=1):  # enumerate 同时拿到序号和内容
    print(f"[7 for] 第 {i} 天: {d}")


# ---------- 8. while 循环 ----------------------------------------------
epoch, loss = 0, 1.0
while loss > 0.3 and epoch < 5:        # 两个条件同时满足才继续
    epoch += 1
    loss *= 0.5                        # 假装每轮 loss 减半
print(f"[8 while] {epoch} 轮后 loss = {loss:.3f}")


# ---------- 9. 函数 ----------------------------------------------------
def calculate_average(numbers):
    """返回一列数字的平均值；空列表要主动报错，而不是崩掉。"""
    if not numbers:
        raise ValueError("numbers 不能为空")
    return sum(numbers) / len(numbers)


def accuracy(correct, total):
    """把 (正确数 / 总数) 换算成百分数，保留两位小数。"""
    return round(correct / total * 100, 2)


avg = calculate_average([1, 2, 3, 4, 5])
print("[9 函数] 平均值 =", avg, "| 准确率 =", accuracy(95, 100), "%")


# ---------- 10. 类 -----------------------------------------------------
class Experiment:
    """一次实验记录 —— 类似你以后每次训练 run 的一行日志。"""

    def __init__(self, name, lr=1e-3):   # 构造：创建对象时执行
        self.name = name
        self.lr = lr
        self.history = []                # 每轮的 loss / acc 都存在这

    def log_epoch(self, epoch, loss, acc):
        self.history.append({"epoch": epoch, "loss": loss, "acc": acc})

    def summary(self):
        if not self.history:
            return f"{self.name}: 还没有记录"
        best = min(self.history, key=lambda r: r["loss"])  # loss 最小的那一轮
        return f"{self.name}: 共 {len(self.history)} 轮, 最优轮 = {best}"


exp = Experiment("mnist-mlp", lr=1e-3)
exp.log_epoch(1, 0.85, 0.72)
exp.log_epoch(2, 0.31, 0.90)
exp.log_epoch(3, 0.18, 0.95)
print("[10 类]", exp.summary())


# ---------- 11. 文件读写 -----------------------------------------------
log_path = "day01_output.txt"
with open(log_path, "w", encoding="utf-8") as f:   # 写模式，with 会自动关闭文件
    f.write("Day1 学习记录\n")
    f.write(json.dumps(progress, ensure_ascii=False) + "\n")

with open(log_path, "r", encoding="utf-8") as f:   # 读模式
    content = f.read()
print("[11 文件] 写入并读回 ->", repr(content))
os.remove(log_path)                                 # 用完删掉，保持目录干净


# ---------- 12. 异常处理 -----------------------------------------------
try:
    print("[12 异常] 尝试对空列表求平均 ...")
    calculate_average([])                            # 这里会抛出 ValueError
except ValueError as e:
    print("[12 异常] 成功捕获错误 ->", e)
finally:
    print("[12 异常] 无论有没有出错，finally 都会执行")


# =====================================================================
#  TODO · 留给你自己动手（这才是真正的“学习证据”）
# ---------------------------------------------------------------------
#  1) 把 skills 换成本周你真正要学的 4 个东西，并倒序打印。
#  2) 给 Experiment 加一个方法 best_epoch()，返回 loss 最小的轮数。
#  3) 写一个普通函数 add(a, b)，再写一个 lambda 版本，比较两种写法。
#  4) 让 while 循环最多跑 10 轮，把每轮的 loss 存进一个 list 再打印。
#  5) 把 progress 用 json 存成文件，再读回来打印（参考第 11 段）。
# =====================================================================

print("\n[Day1] python_basics.py 运行完毕。别忘了: git add . && git commit")
