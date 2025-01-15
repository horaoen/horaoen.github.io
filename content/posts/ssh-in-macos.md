+++
title = "ssh in macos"
date = "2024-10-15"
+++

```bash
brew tap probezy/core && brew install cpolar
cpolar authtoken xxxxxxx
sudo cpolar service install
sudo cpolar service start
ssh macOS用户名@公网地址 -p 公网端口号
```

1. [web url](http://localhost:9200)