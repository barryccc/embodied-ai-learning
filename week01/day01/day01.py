"""
Day 1 · week01/python/day01.py
=====================================================================
你计划里那句"今天一定写一个小程序"，就是这个文件。

说明：这是【骨架】—— 结构、注释、提示我都写好了，
带 TODO 的地方留给你填。填完就是一份完整的小程序。

运行：
    conda activate embodied
    python day01.py

建议：填一段、跑一次、看输出对不对，再往下填。
=====================================================================
"""

# ---------------------------------------------------------------------
# 第 1 步：最简单的版本 —— 遍历一个任务列表
# ---------------------------------------------------------------------
tasks = ["grasp", "push", "place"]

for task in tasks:
    print("Current task:", task)

print("-" * 40)


# ---------------------------------------------------------------------
# 第 2 步：把数据装进 dict（字典）
# ---------------------------------------------------------------------
robot = {
    "name": "my_robot",
    "dof": 6,
    "tasks": ["grasp", "push", "place"],
}

# TODO 1：打印机器人的名字和自由度
#   提示：print(robot["name"])  /  print(robot["dof"])
print(robot["name"])
print(robot["dof"])
# TODO 2：遍历 robot["tasks"]，逐个打印 "Current task: xxx"
#   提示：和上面第 1 步的 for 循环完全一样，只是把 tasks 换成 robot["tasks"]

for task in robot["tasks"]:
    print("Current task:", task)


print("-" * 40)


# ---------------------------------------------------------------------
# 第 3 步（自己加）：写一个 function
# ---------------------------------------------------------------------
def describe_robot(robot):
    """接收一个 robot 字典，返回一句描述。"""
    # TODO 3：返回类似 "my_robot has 6 DOF, 3 tasks"
    #   提示：用 f-string，比如
    #         return f'{robot["name"]} has {robot["dof"]} DOF, {len(robot["tasks"])} tasks'
    return f'{robot["name"]} has {robot["dof"]} DOF, {len(robot["tasks"])} tasks'


# TODO 4：调用上面的函数，并把返回值打印出来
#   提示：print(describe_robot(robot))
print(describe_robot(robot))

print("-" * 40)


# ---------------------------------------------------------------------
# 第 4 步（自己写）：写一个 class
# 这就是你以后天天会看到的 `class MyModel(nn.Module)` 的雏形
# ---------------------------------------------------------------------
class Robot:
    def __init__(self, name, dof):
        # TODO 5：把 name 和 dof 存到 self 上
        #   提示：self.name = name  /  self.dof = dof
        self.name = name
        self.dof = dof

    def move(self, task):
        """打印一行 '<名字> is doing <任务>'"""
        # TODO 6：实现它
        print(f'{self.name} is doing {task}')

    def report(self):
        """打印这个机器人的名字和自由度"""
        # TODO 7：实现它
        print(f'{self.name} has {self.dof} DOF')


# TODO 8：创建一个 Robot 实例，然后调用 move() 和 report()

my = Robot("my_robot", 6)
my.move("grasp")
my.report()


print("\n[day01] 把上面 8 个 TODO 都填完并跑通 —— 今天的小程序就算完成了。")
