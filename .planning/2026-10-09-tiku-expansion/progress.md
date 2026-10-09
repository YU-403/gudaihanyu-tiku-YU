# Progress Log

## Session: 2026-10-09

### Phase 1: 需求与材料确认

- **Status:** complete
- **Started:** 2026-10-09
- Actions taken:
  - 通读项目：题库仓库、原始存档、quiz-complete skill（v2.11，与已安装版本逐字节一致）
  - 建立项目级 `AGENTS.md`（改动即提交 + 改动必测两条规范）
  - 核实本地 Git 版本：master @ df72252，20 次提交，工作区干净，**无远端**
  - 拆解用户给出的 16 章扩充清单，逐章定位材料
  - 登记 4 组 OCR Markdown + 3 份 PDF + 自建 RAG
  - 实测「章节」进入专题模式／知识点专项的机制
  - 与用户确认 11 项待定事项（题量、题型、全选率、命名、取材边界等）
- Files created/modified:
  - `D:\Desktop\临时\古汉语AI题库（最新版）\AGENTS.md`（新建，2854 字节）
  - `.planning/2026-10-09-tiku-expansion/task_plan.md`（新建）
  - `.planning/2026-10-09-tiku-expansion/findings.md`（新建）
  - `.planning/2026-10-09-tiku-expansion/progress.md`（本文件）

### Phase 2: 构建链路前置

- **Status:** pending
- Actions taken: 尚未开始
- Files created/modified: —

### Phase 3–7

- **Status:** pending

## Test Results

本阶段全部为只读核对，无代码变更，故未运行构建。

| Test | Input | Expected | Actual | Status |
|------|-------|----------|--------|--------|
| 题库源完整性 | 32 个 `.md` | 题块数 = 1122 | 1122 | ✅ |
| 成品题目数 | `index.html` 内嵌 JSON | 1122 | 1122（383 單選 / 369 不定項 / 370 判斷） | ✅ |
| 专题模式条目 | `section` 去重 | 32 | 32 | ✅ |
| 知识点标签 | `tag` 去重 | 382 | 382 | ✅ |
| skill 包一致性 | zip vs 已安装 skill，28 个非空文件 SHA256 | 全部一致 | 28/28 `SAME` | ✅ |
| 材料可达性 | 7 个参考路径 | 全部存在 | 全部存在 | ✅ |
| Git 工作区 | `git status --short` | 干净 | 干净（仅有本次新建的 `.planning/`） | ✅ |

## Error Log

| Timestamp | Error | Attempt | Resolution |
|-----------|-------|---------|------------|
| 2026-10-09 | PowerShell 中 `Select-String` 传多模式正则被解析为位置参数报错 | 1 | 改用 `rg` 或拆分为单模式调用 |
| 2026-10-09 | 误以为 `第02册` 是子目录（实为目录名的一部分）导致路径不存在 | 1 | 改为 `《古代汉语》（王力·校订重排本）第02册` 完整目录名 |
| 2026-10-09 | PowerShell `for` 循环结果直接管道报「空管道元素」 | 1 | 先收集到数组变量再管道 |

## 5-Question Reboot Check

| Question | Answer |
|----------|--------|
| Where am I? | Phase 1 完成、风格基准已定，Phase 2 待启动 |
| Where am I going? | 主题固化 → 首轮校准 → 通論 6 章 → 常用詞 3 章 → 文選 7 篇 → 重建终验 |
| What's the goal? | 16 个新章节出题并入题库，重建后在新章节在专题模式／知识点专项可见 |
| What have I learned? | 见 findings.md（机制实测、OCR 分档、标签惯例、材料清单） |
| What have I done? | 见上方 Phase 1 |

## Session: 2026-10-09（续）

### 风格基准与提炼方案确认

- **Status:** complete
- Actions taken:
  - 回答用户「出题风格与样板提示怎么做」的方案询问：以现有 1122 题为唯一样本，跑数据提炼口径
  - 预演句式统计（n = 1122），实测教材四册无练习题、题库零使用否定式设问
  - 用户确认暂无真题／教师练习题，按现有题目保持风格一贯性
  - 将「风格提炼 → 口径卡 → 6 道标杆题 → 首轮校准」展开进 Phase 3
- Files created/modified:
  - `.planning/2026-10-09-tiku-expansion/task_plan.md`（Phase 3 展开为 6 个子步骤，新增 3 条决策）
  - `.planning/2026-10-09-tiku-expansion/findings.md`（新增第八节：样本基准与句式预演）

## Session: 2026-10-09（Phase 2 执行）

### Phase 2: 构建链路前置

- **Status:** complete
- Actions taken:
  - 基线构建（v2.11、无主题），与已验收 index.html 做样式表差分 → 330 行新增 / 17 行替换
  - 抽成主题层 `_theme\石青.css`（365 行），修补 8 处「插入既有规则内部」的悬空声明
  - 首次方案 `--custom-css` 失败：注入点在样式表前部，覆盖类规则全被模板规则打败
  - 改为 `rebuild.ps1` 构建后追加；期间踩掉 `<style>` 提前闭合、PowerShell 编码两个坑
  - 修正重建暴露的两处「解析引用选项字母」（原本已指向错误选项）
  - 产物重建 + 全量验证 + 分批提交
- Files created/modified:
  - 新增 `_theme\石青.css`、`rebuild.ps1`、`rebuild.bat`
  - 修改 `index.html`（用新链路重建）、`通论部分\古代漢語-古漢語通論二/三-專題題集.md`（解析去字母化）

## Test Results（Phase 2）

| Test | 期望 | 实际 | Status |
|------|------|------|--------|
| 样式表语义比对（已验收 vs 新产物） | 值不同 = 0 | 0；新产物仅多 1 条被完全覆盖的 `background` 简写 | ✅ |
| 题目总数 | 1122 | 1122 | ✅ |
| 专题模式条目 | 32 | 32 | ✅ |
| 知识点标签 | 382 | 382 | ✅ |
| 存储前缀 | `quiz_gudaihanyu_` | `quiz_gudaihanyu_` | ✅ |
| 内联 JS 语法 | node --check 通过 | 通过（2 个 script 块） | ✅ |
| 判断题判定链路 | 按钮值集合 == 答案取值集合 | 相等（正确 / 错误） | ✅ |
| 构建告警「解析引字母」 | 0 条 | 0 条（修正前 2 条） | ✅ |
| 构建对账 | 1122 题全解析、ID 无重复 | 符合 | ✅ |
| 主题自检（rebuild.ps1 内建） | 通过 | 通过 | ✅ |

---

*Update this file after completing a phase, running validation, or encountering an error.*
