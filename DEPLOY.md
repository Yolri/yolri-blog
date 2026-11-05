# 部署手册（自己动手版）

这份手册按顺序做就行，每一步都写了"怎么验证做对了"。
遇到报错先看最后一节「常见报错」。

---

## 先认清现在的状态

- 站点目录：`D:\DSHWorks\blog`
- 本地 Hugo：`D:\DSHWorks\tools\hugo\hugo.exe`（v0.169.0）
- 本地 Dart Sass：`D:\DSHWorks\tools\dart-sass\dart-sass`
- 已经跑通过本地预览，主题、菜单、示例文章都在
- 还差三件事：**改成你的信息** → **推到 GitHub** → **Vercel 部署**

每次开新终端，先跑这一行把 Sass 加进 PATH（否则构建会报 TOCSS-DART）：

```powershell
$env:Path = "D:\DSHWorks\tools\dart-sass\dart-sass;" + $env:Path
```

---

## 第 1 步：把演示信息换成你自己的

### 1.1 `hugo.toml`

用记事本 / VS Code 打开 `D:\DSHWorks\blog\hugo.toml`，改这几行：

| 行号 | 现在的值 | 改成 |
|---|---|---|
| 19 | `baseURL = 'https://azxt.org/'` | 先填 `'https://你的项目名.vercel.app/'`，结尾的 `/` 不能少。真实地址部署完才知道，第 5 步再回来改 |
| 22 | `title = '爱则心痛(演示) \| azxt'` | 你的站点名，比如 `'小白的博客'` |
| 40 | `author = "爱则心痛(演示)"` | 你的昵称 |
| 41 | `description = "..."` | 一句话介绍你的站，会出现在搜索结果里 |
| 42 | `email = "admin@azxt.org"` | 你的邮箱 |
| 43 | `github = "aizexintong"` | 你的 GitHub 用户名（只填用户名，不带链接） |
| 44 | `domain = "azxt.org"` | 你的域名，没有域名就先填 `你的项目名.vercel.app` |
| 45 | `siteTime = "2026-04-01T00:00:00+08:00"` | 你开始写博客的时间，格式照抄 |

第 69 行 `enableComments = false`：先别开评论，等站点跑通再说。

### 1.2 `data/theme.yaml`

打开 `D:\DSHWorks\blog\data\theme.yaml`，这是首屏文案的唯一来源。必改的：

- 第 30 行 `title:` 首屏大标题
- 第 32-36 行 `subtitles:` 轮播副标题（几行都行，一行一个 `- "..."`）
- 第 38 行 `description:` 首屏描述
- 第 48 行 `badgeText:`、第 49 行 `greeting:`
- 第 52-53 行 `quote.text` / `quote.author`
- 第 75-78 行 首页「关于我」小卡片
- 第 99-101 行 「关于」页的名字、头衔、座右铭
- 第 116 行 `number: "8+"` 开发经验年数
- 第 150-168 行 「保持联系」的邮箱、GitHub、网站
- 第 179-181 行 头像路径（默认 `/headimg.jpg`，图片放 `blog\static\headimg.jpg`）
- 第 229-265 行 社交图标，不想显示的改 `show: false`

第 189/194/199/208/217/218 行是作者放的随机图接口（`t.alcy.cc`），能直接显示，但换自己的更好看。想换就把 URL 换成你自己的图片地址，本地图片放 `blog\static\` 下，写成 `/图片名.jpg`。

**注意**：`theme.yaml` 是 YAML，缩进必须用空格，不能按 Tab，冒号后面要有一个空格。

### 1.3 验证

在 `D:\DSHWorks\blog` 下运行：

```powershell
D:\DSHWorks\tools\hugo\hugo.exe server --bind 127.0.0.1 --port 1313 --baseURL http://127.0.0.1:1313/
```

浏览器打开 <http://127.0.0.1:1313>，看首屏标题是不是你的了。看完按 `Ctrl+C` 停掉。

---

## 第 2 步：建 GitHub 仓库

1. 打开 <https://github.com/new>
2. Repository name 填 `my-blog`（随便起，记住就行）
3. 选 **Public**（私有仓库也能部署，但 Public 更省事）
4. **不要**勾 "Add a README file"、**不要**选 .gitignore、**不要**选 license（本地已有文件，勾了会冲突）
5. 点 Create repository

建完后页面上会显示一串命令，先别管，按下面第 3 步走。

---

## 第 3 步：把代码推上去

在 `D:\DSHWorks\blog` 下依次执行（把 `<你的用户名>` 和 `<仓库名>` 换成实际的）：

```powershell
git remote add origin https://github.com/<你的用户名>/<仓库名>.git
git push -u origin main
```

**第一次 push 会要求登录**，Windows 版 Git 自带凭据管理器，通常会弹出一个窗口：

- 选 **Sign in with your browser** → 浏览器里登录 GitHub → 授权
- 如果没弹窗，而是在命令行里问 Username / Password：用户名填 GitHub 用户名，**密码不能填登录密码**，要填令牌（PAT）。生成方法：GitHub 头像 → Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token (classic) → 勾 `repo` → 生成后复制那串 `ghp_xxx`，粘到密码处。

**验证**：刷新 GitHub 仓库页面，能看到 `hugo.toml`、`themes/`、`content/` 这些，就成功了。

---

## 第 4 步：Vercel 部署

1. 打开 <https://vercel.com/signup>，选 **Continue with GitHub** 注册/登录
2. 登录后点 **Add New → Project**
3. 找到你的 `my-blog` 仓库，点 **Import**
4. 配置页面上，如果它自动识别成 Hugo，**什么都别改**；如果没识别出来，把 Framework Preset 选成 **Other** 也行
   - 构建命令和输出目录已经写死在仓库的 `vercel.json` 里了，不用手填
5. 点 **Deploy**，等 1-3 分钟

**验证**：出现 "Congratulations!" 就是成功了，点 **Continue to Dashboard**，再点域名就能打开。

以后每次 `git push`，Vercel 会自动重新构建，不用再点。

> 仓库里的 `vercel.json` 和 `build.sh` 是给 Vercel 用的：Hugo 0.169 不自带 Dart Sass，构建脚本会先下载 Dart Sass 和 Hugo 再编译。这两个文件不要删。

---

## 第 5 步：拿真实地址，回填 baseURL

部署成功后会得到一个域名，形如 `my-blog-xxxx.vercel.app`。

1. 回到 `hugo.toml` 第 19 行，把 `baseURL` 改成 `'https://my-blog-xxxx.vercel.app/'`
2. 提交并推送：

```powershell
git add hugo.toml
git commit -m "chore: 设置正式站点地址"
git push
```

Vercel 会自动重新部署。这一步影响 RSS 和分享卡片的链接，不影响主页显示，但值得做对。

---

## 第 6 步：以后怎么发文章

新建 `D:\DSHWorks\blog\content\posts\文章名.md`，开头写：

```markdown
---
title: "文章标题"
date: 2026-11-06T10:00:00+08:00
draft: false
tags: ["标签1", "标签2"]
categories: ["随笔"]
---

正文……
```

注意 `date` 不要写成未来的时间，否则本地预览看不到这篇。

发文章流程：

```powershell
# 1. 本地看一眼
D:\DSHWorks\tools\hugo\hugo.exe server --bind 127.0.0.1 --port 1313

# 2. 没问题就提交
git add -A
git commit -m "post: 文章标题"
git push
```

推上去 1-2 分钟后线上就有了。

---

## 第 7 步（可选）：绑自己的域名

前提：你有一个域名。

1. Vercel 项目 → **Settings → Domains** → 输入域名 → **Add**
2. 按它给的提示去域名服务商加解析：
   - 根域名（`example.com`）：A 记录指向 `76.76.21.21`
   - 子域名（`www.example.com` 或 `blog.example.com`）：CNAME 指向 `cname.vercel-dns.com`
3. 等 DNS 生效（几分钟到几小时），Vercel 会自动签发 HTTPS 证书
4. 把 `hugo.toml` 的 `baseURL` 再改成你的域名

---

## ⚠️ 国内访问的现实问题（重要，先看）

`*.vercel.app` 这个域名在国内很多网络下打不开（DNS 被污染），部署成功不代表你能直接访问。
三种情况：

1. **绑了自己的域名，能打开** —— 最常见，速度一般但可用。优先走这条。
2. **绑了域名还是打不开** —— 换 Cloudflare Pages（把仓库连过去，构建命令填 `chmod +x build.sh && ./build.sh`，输出目录 `public`，同样要处理 Dart Sass）。
3. **想稳** —— 你本来就有阿里云服务器和 BT 面板。可以在本地执行 `D:\DSHWorks\tools\hugo\hugo.exe --minify` 生成 `public` 目录，再用面板的文件管理把 `public` 里的内容传到网站根目录。纯静态站，不需要数据库和 PHP，这是国内最稳的方案，缺点是每次更新要手动传。

---

## 常见报错

| 报错 | 原因 | 解决 |
|---|---|---|
| `TOCSS-DART: failed to transform ... You need to install Dart Sass` | 本地没把 dart-sass 加进 PATH | 按开头那行命令加 PATH 再跑 |
| `failed to load Git data: fatal: not a git repository` | 目录里没有 `.git` | `git init` 后提交一次；或把 `enableGitInfo` 改 false |
| 本地预览打开是 404 | 文章的 `date` 是未来时间 | 改成本地当前时间之前 |
| push 时 `Authentication failed` | 密码填成了登录密码 | 用 PAT 令牌，或让凭据管理器弹窗登录 |
| Vercel 构建失败，日志里有 `Dart Sass: not installed` | `build.sh` 没生效或没执行权限 | 确认 `build.sh` 和 `vercel.json` 在仓库根目录，且 `build.sh` 是 LF 换行（仓库里已配 `.gitattributes`） |
| Vercel 构建失败，`hugo: command not found` | 同理，构建脚本没跑 | 检查 `vercel.json` 的 buildCommand |
| 线上样式全丢 | `baseURL` 填错或没改 | 按第 5 步改对，重新部署 |
| 推上去但 Vercel 没自动构建 | 项目没连上仓库 | Vercel → Settings → Git 里重新连接 |

---

## 文件清单（哪些能删）

- 能删：`public/`、`resources/`（构建产物，每次自动生成）
- 不能删：`vercel.json`、`build.sh`、`.gitattributes`、`hugo.toml`、`themes/`、`content/`、`data/`
