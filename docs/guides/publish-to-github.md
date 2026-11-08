# 把这个仓库发布到 GitHub（一次性，约 5 分钟）

> 只需要做一次。做完之后，以后每次更新只有 `git add / commit / push` 三个命令。

## 前置状态（2026-11 检查结果）

| 项 | 状态 |
|---|---|
| Git | ✅ 已安装 2.56 |
| 本地仓库 | ✅ 已初始化，首次提交完成 |
| 提交身份 | ✅ `2462297573-web` / `2462297573@qq.com` |
| SSH 密钥 | ✅ 已生成（`~/.ssh/id_ed25519`） |
| 密钥是否已加到 GitHub | ❌ **未添加** —— 这是唯一缺的一步 |
| 远程仓库 | ⏳ 还没创建 |

---

## 步骤 1：把公钥添加到 GitHub

1. 打开 <https://github.com/settings/keys>
2. 点 **New SSH key**
3. Title 随便填，比如 `SCUT laptop`
4. Key type 保持 **Authentication Key**
5. Key 一栏粘贴下面这条（在 PowerShell 里运行可以打印出来）：

```powershell
Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"
```

6. 点 **Add SSH key**

验证（应该看到 `Hi 2462297573-web! You've successfully authenticated`）：

```powershell
ssh -T git@github.com
```

> 第一次会问 `Are you sure you want to continue connecting?` —— 输入 `yes` 回车。

---

## 步骤 2：在 GitHub 上新建空仓库

1. 打开 <https://github.com/new>
2. Repository name 填：`scut-se-journey`
3. 选 **Public**
4. **不要**勾选 "Add a README file"、".gitignore"、"license"（本地已经有内容了，勾了会冲突）
5. 点 **Create repository**

---

## 步骤 3：推送

远程地址已经配好了。直接跑：

```powershell
cd C:\Users\旅行包\Documents\deepseek-harness\default-workspace\scut-se-journey
git push -u origin main
```

然后刷新 <https://github.com/2462297573-web/scut-se-journey> ，应该能看到 20 个文件和一次提交。

---

## 如果报错

| 报错 | 原因 | 解决 |
|---|---|---|
| `Permission denied (publickey)` | 公钥没加成功 / 加错账号 | 回步骤 1，确认 `ssh -T git@github.com` 能通过 |
| `Repository not found` | 仓库名拼错，或还没创建 | 回步骤 2；确认用户名是 `2462297573-web` |
| `remote origin already exists` | 已经配过 | `git remote set-url origin git@github.com:2462297573-web/scut-se-journey.git` |
| `src refspec main does not match any` | 本地还没有提交 | `git log` 应该能看到 `init: ...`，没有就说明没提交成功 |
| `Connection timed out`（22 端口被封） | 网络限制 | 见下方"备用：走 443 端口" |

### 备用：走 443 端口

如果 22 端口连不通，在 `~/.ssh/config` 里加：

```
Host github.com
  HostName ssh.github.com
  Port 443
  User git
```

---

## 之后的日常（记住这三行就够）

```powershell
git add .
git commit -m "feat: 实现动态数组"
git push
```

详细说明见 [git-basics.md](git-basics.md)。
