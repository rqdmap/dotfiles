# Chezmoi 迁移计划（概要）

目标：将 rqdmap/dotfiles 从按分支区分多机配置，迁移为一个以 chezmoi 为源的单仓库多主机管理结构。

主要步骤：
1. 在本地从 dev 创建 refactor/chezmoi-structure 分支。
2. 添加 .chezmoi.toml，创建 .chezmoi/hosts/ 示例文件（arch.toml、mac.toml）。
3. 使用 `chezmoi add` 逐个把当前机器的 dotfiles 导入为模板，编辑模板去掉机密或 host-only 内容。
4. 推送 refactor 分支并在 GitHub 上创建 PR，目标分支为 main（或 dev -> 再合 main）。
5. 在多台测试机上使用 `chezmoi init --apply <repo>` 验证部署。
6. 处理 secrets（如有）并使用 `chezmoi encrypt`（gpg/age）。
7. 合并 PR，设置默认分支为 main，按需删除旧分支（archlinux/mac/mac2）。

注意事项：
- 先迁移低风险的配置（nvim、wezterm、git），再迁移 zsh 等对交互影响大的文件。
- 不要把明文 secrets 提交到仓库，使用加密或本地 .gitignore 的 local.override 文件。
- 在删除旧分支前，保留一段观察期（7–14 天），并在 GitHub 上发布变更说明。
