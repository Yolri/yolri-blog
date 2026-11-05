---
title: "第一篇：把博客搭起来"
date: 2026-11-04T22:00:00+08:00
lastmod: 2026-11-04T22:00:00+08:00
description: "用 Hugo + 幻梦 Illusion 搭起第一个页面，顺带验证文章、代码高亮、标题锚点和目录。"
tags: ["Hugo", "建站", "Illusion"]
categories: ["日常"]
draft: false
toc: true
---

这篇文章没有别的用途，就是把主题的各个环节跑一遍：文章列表、详情页、代码块高亮、标题锚点、右侧目录、标签与分类归档。

## 为什么选静态站点

静态站点把 Markdown 编译成 HTML，服务器只需要发文件，不需要数据库和后台进程。也正因为如此，它可以扔给 Vercel、Cloudflare Pages 这类免费托管，推一次代码就自动构建一次。

## 一段代码

```python
def fib(n: int) -> int:
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a
```

## 一个公式

行内公式 $E = mc^2$，独立公式：

$$
\int_{-\infty}^{+\infty} e^{-x^2}\,\mathrm{d}x = \sqrt{\pi}
$$

## 下一步

把 `data/theme.yaml` 里的首页文案、头像、背景换成自己的，再把这篇文章删掉或者改写。
