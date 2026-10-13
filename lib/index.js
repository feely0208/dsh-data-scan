import { createPlugin, pkgRootFrom } from '@deepwhale-cn/dsh-guard-core/plugin';

export const { name, inject, apply } = createPlugin({
  name: 'data-scan',
  pkgRoot: pkgRootFrom(import.meta.url),
  skillFile: 'skill/data-scan.md',
  binFile: 'bin/cli.mjs',
  description: '扫出代码和配置里的身份证、银行卡、手机号 —— 带校验位验证，不误报',
  whenToUse: 'TODO：写清什么时候该用（用户会说的话也列上）',
});
