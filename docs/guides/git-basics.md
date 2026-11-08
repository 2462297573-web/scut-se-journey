# Git 与 GitHub 入门（写给第一次用的人）

> 目标：读完之后你能独立完成「改文件 → 提交 → 推到 GitHub」这一整套，并且知道出错时怎么办。
> 全程在 **PowerShell** 里操作（Win + X → 终端）。不需要装 Git Bash。

---

## 一、先搞懂四个词（只需 2 分钟）

| 词 | 是什么 | 类比 |
|---|---|---|
| **工作区** | 你电脑上能看到的文件夹 | 书桌 |
| **暂存区**（stage） | 你已经挑好、准备存进档案的东西 | 待归档的托盘 |
| **本地仓库**（commit） | 已经拍好快照的历史 | 档案柜 |
| **远程仓库**（GitHub） | 云端的备份和展示页 | 云端备份 + 展示柜 |

流程永远是这四步：

```
改文件  →  git add  →  git commit  →  git push
(书桌)     (放托盘)     (进档案柜)      (同步到云端)
```

**关键理解**：`commit` 是**本地**操作，不需要网络，可以随时做。`push` 才需要联网。所以"忘了 push"不会丢东西，只是没备份。

---

## 二、一次性配置（只做一次）

你的身份已经配好了（`2462297573-web` / `2462297573@qq.com`）。再补三行，让以后少踩坑：

```powershell
# 1. 让中文文件名正常显示（否则 git status 会显示 \344\275\240 这种乱码）
git config --global core.quotepath false

# 2. 默认分支叫 main（和 GitHub 一致）
git config --global init.defaultBranch main

# 3. 换行符：Windows 上自动处理，避免每次提交都提示 LF/CRLF 警告
git config --global core.autocrlf true
```

验证：

```powershell
git config --list --show-origin | Select-String "user.name|user.email|quotepath"
```

---

## 三、每天：三个命令（90% 的时间只用这三个）

在仓库目录里（`scut-se-journey`）：

```powershell
git status                 # 看现在有什么变化（先看再动，这是好习惯）

git add .                  # 把当前所有改动放进暂存区

git commit -m "feat: 实现单链表的插入和删除"    # 拍快照，写清楚做了什么

git push                   # 推到 GitHub
```

**`git status` 是你最好的朋友。** 不确定的时候，先跑它，它会告诉你下一步该干嘛。

### 提交信息怎么写

格式：`类型: 一句话说明`

| 类型 | 什么时候用 | 例子 |
|---|---|---|
| `feat` | 新增功能/代码 | `feat: 实现哈希表拉链法` |
| `fix` | 修 bug | `fix: 修复链表删除头节点崩溃` |
| `docs` | 文档/笔记 | `docs: 补充 BFS 和 DFS 的对比` |
| `journal` | 日志 | `journal: 第 3 周复盘` |
| `refactor` | 重构（不改功能） | `refactor: 把链表拆成 .h/.cpp` |
| `chore` | 杂事 | `chore: 更新 .gitignore` |

❌ 不要写：`update`、`修改`、`111`、`asdf` —— 三个月后你自己都看不懂。

---

## 四、每周日：15 分钟复盘（这是这个仓库的核心习惯）

1. 打开 `journal/2026-11.md`（当月那个文件）
2. 填「本周」一栏：做了什么、卡在哪、下周做什么
3. 跑：

```powershell
git add .
git commit -m "journal: 第 N 周复盘"
git push
```

4. 顺手看一眼 GitHub 网页，确认更新上去了

详细模板见 [weekly-review.md](weekly-review.md)。

---

## 五、每月：开一篇新日志

```powershell
# 方法 A：手动复制（最简单）
Copy-Item journal\2026-11.md journal\2026-12.md

# 方法 B：用仓库里的脚本
.\scripts\new-journal.ps1
```

然后改标题里的月份，把模板内容清空重写。

---

## 六、分支与 Pull Request（现在不用，但要知道）

**什么时候需要分支？** 当你改的东西"可能搞砸"的时候，比如大改项目结构、尝试一个新框架。

```powershell
git switch -c feat/vn-branch-system    # 新建并切换到分支
# ... 改代码 ...
git add . ; git commit -m "feat: 加入分支选择系统"
git push -u origin feat/vn-branch-system
```

然后去 GitHub 网页，会出现 **Compare & pull request** 按钮 → 创建 PR → 自己看看改动 → Merge。

**为什么值得学：** PR 是团队协作的基本单位，也是你未来实习第一天就要用的东西。现在一个人用，就当练习。

查看/切回主分支：

```powershell
git branch                 # 看所有分支（* 是当前）
git switch main            # 切回 main
```

---

## 七、出错了怎么办（速查表）

| 报错 / 现象 | 原因 | 解法 |
|---|---|---|
| `fatal: not a git repository` | 你在仓库文件夹外面 | `cd` 进 `scut-se-journey` 再跑 |
| `! [rejected] main -> main (fetch first)` | GitHub 上有你本地没有的提交 | `git pull --rebase` 再 `git push` |
| `error: remote origin already exists` | 已经配过远程地址 | `git remote set-url origin <新地址>` |
| `CONFLICT (content): Merge conflict in xxx` | 两边改了同一行 | 打开文件，删掉 `<<<<<<<` `=======` `>>>>>>>` 标记，留下你要的内容，然后 `git add .` + `git commit` |
| `You are in 'detached HEAD' state` | 你切到了某个历史提交 | `git switch main` 回去 |
| `warning: LF will be replaced by CRLF` | 换行符差异，**不是错误** | 忽略，或按第二节配 `core.autocrlf` |
| 中文文件名显示成 `\344\275\240` | 编码显示设置 | `git config --global core.quotepath false` |
| `fatal: refusing to merge unrelated histories` | 两个仓库历史无关 | `git pull --allow-unrelated-histories` |
| 提交错了信息 | 还没 push | `git commit --amend -m "新信息"` |
| 提交错了文件 | 还没 push | `git reset --soft HEAD~1` 撤销提交（改动还在） |
| 已经 push 了密码/密钥 | **严重** | 立刻去对应平台**吊销该密钥**，再考虑 `git filter-repo` 清理历史。**改 .gitignore 是没用的**，历史里还在 |

> 记住一条：**只要还没 `push`，几乎所有错误都能挽回。** 所以不确定的时候，先别 push。

---

## 八、这个仓库的固定流程（照抄即可）

### 每次写完代码

```powershell
cd C:\Users\旅行包\Documents\deepseek-harness\default-workspace\scut-se-journey
git status
git add .
git commit -m "feat: 实现动态数组的扩容"
git push
```

### 每周日

```powershell
git add .
git commit -m "journal: 第 N 周"
git push
```

### 想看自己这周改了什么

```powershell
git log --oneline -10              # 最近 10 次提交
git diff                           # 还没 add 的改动
git diff --stat HEAD~5             # 最近 5 次提交改了多少
```

---

## 九、第一次 push 会遇到登录

第一次 `git push` 时，Windows 会弹出窗口让你登录 GitHub（Git Credential Manager）。登录一次之后就会记住，以后不用再输。

如果没弹窗、或者提示要密码：

1. GitHub **不接受账号密码**，要用 **Personal Access Token（PAT）**
2. 网页：GitHub → 右上角头像 → Settings → Developer settings → Personal access tokens → **Tokens (classic)** → Generate new token
3. 勾选 `repo` 权限，生成后**复制那一串**（只显示一次）
4. 在弹窗里：用户名填 `2462297573-web`，密码粘贴 **token**

> token 存在 Windows 凭据管理器里，不会进仓库。**永远不要把 token 写进任何文件。**

---

## 十、不想用命令行？

可以装 **GitHub Desktop**（图形界面，按钮化操作），或者用 VS Code 左侧的源代码管理面板。

但建议至少学会本文的六个命令：`status / add / commit / push / pull / log`。原因是：**出问题时，GUI 只会给你一句看不懂的错误，命令行会告诉你具体哪里错了。**

---

## 十一、接下来 7 天的小任务

- [ ] Day 1：跑一遍 `git status` / `git log --oneline`，看懂输出
- [ ] Day 2：改一行 README，完整走一遍 add → commit → push
- [ ] Day 3：故意改坏一个文件再改回来，看 `git diff` 怎么显示
- [ ] Day 4：用 `git switch -c test` 建个分支，随便改点东西，再切回 main
- [ ] Day 5：在 GitHub 网页上看自己的提交历史，点进一次 commit 看 diff
- [ ] Day 6：建一个 Issue（用 `.github/ISSUE_TEMPLATE` 里的模板）
- [ ] Day 7：写第一次周复盘并 push

七天之后，你比 90% 的大一学生更会用 Git。
