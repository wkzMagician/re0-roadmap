# Readmap

将研究资料组织成可编辑的阅读路线图：用节点归纳主题，用箭头表达学习前置关系，并记录每份资料的阅读进度。

你可以使用任意 LLM 生成路线图，手动保存为 JSON 文件，再在本地页面中阅读和调整。项目使用 React + Vite，路线图和阅读状态保存在本地文件中。

**快速开始：**启动应用，先浏览内置路线图；创建自己的路线图时，复制 [生成提示词](prompts/create-roadmap.md)，让 LLM 输出 JSON，然后按下文保存文件。

## 目录

- [启动应用](#启动应用)
- [创建自己的路线图](#创建自己的路线图)
- [阅读与编辑](#阅读与编辑)
- [更新已有路线图](#更新已有路线图)
- [JSON 格式](#json-格式)
- [常见问题](#常见问题)
- [项目结构与开发](#项目结构与开发)

## 启动应用

### 环境要求

安装 Node.js 20.19+（20.x）或 22.12+，以及 npm。首次安装依赖需要联网。

### 一键启动

| 系统 | 操作 |
| --- | --- |
| Windows | 双击 [start.bat](start.bat)。 |
| macOS / Linux | 在项目目录执行 `sh start.sh`。 |

脚本会在缺少 `node_modules` 时安装依赖，并打开浏览器。默认地址为 <http://127.0.0.1:5173>。使用期间保持终端窗口打开，按 Ctrl+C 停止服务。

### 手动启动

在项目目录执行：

```sh
npm ci
npm run dev -- --host 127.0.0.1 --port 5173 --strictPort --open
```

仓库附带一份 [Agent Systems 研究路线图](data/roadmaps/agent-systems-research-landscape-v1.json)，可以先用它熟悉界面。

## 创建自己的路线图

无需让 LLM 访问仓库，也无需自己编写 JSON 结构。生成在你选择的聊天工具中完成，文件由你手动创建。

### 1. 复制提示词并填写需求

打开 [prompts/create-roadmap.md](prompts/create-roadmap.md)，复制“提示词开始”与“提示词结束”之间的内容，填写研究主题、已有基础、学习目标、时间预算和已有资料，再发送给 LLM。

例如，你可以要求“已有 Python 和机器学习基础，用四周理解 Agent 的工具调用与规划，只使用我提供的论文”。明确资料范围能让结果更贴近实际需求。

提示词已包含完整结构、字段约束和示例。模型有必要时会先澄清需求，最终应只返回一个完整 JSON 对象。

### 2. 手动创建 JSON 文件

用 VS Code 或其他纯文本编辑器新建文件，粘贴模型输出，以 UTF-8（无 BOM）保存。

- 只保留从第一个 `{` 到最后一个 `}` 的 JSON 内容，不包含模型的解释或 Markdown 代码围栏。
- 文件名必须与 `meta.id` 完全一致，再加 `.json`。例如 `meta.id` 为 `agent-reading`，文件名就是 `agent-reading.json`。
- Windows 用户注意确认真实扩展名，避免保存成 `agent-reading.json.txt`。
- 新路线图使用新 ID，避免与已有文件重名。

### 3. 加载路线图

选择任意一种方式：

| 方式 | 操作 |
| --- | --- |
| 放入项目目录 | 将文件保存到 `data/roadmaps/`，刷新页面，在顶部下拉框中选择路线图。 |
| 从页面加载 | 将文件保存在任意位置，点击“加载 JSON”并选择该文件。 |

在本地开发服务运行时，页面加载的路线图会按 `meta.id` 写入 `data/roadmaps/<meta.id>.json`。相同 ID 会更新已有文件；从其他位置导入时，后续保存的是项目目录内的副本。

### 4. 检查内容

确认节点安排、资料链接和前置关系符合你的目标，再开始阅读。格式通过校验不代表论文真实或学习安排合理；尤其需要核对模型补充的资料。不能核实的链接可以留空字符串。

## 阅读与编辑

- 使用顶部下拉框切换路线图。
- 展开节点查看资料，记录已读状态；同一资料被多个节点引用时共享阅读状态。
- 使用页面的编辑功能调整路线图标题、节点、资料与前置依赖。
- 页面自动计算布局，无需手动填写坐标。

通过启动脚本或 `npm run dev` 运行时，网页编辑和阅读状态会自动写回当前路线图 JSON。离开页面或停止服务前，确认状态显示“JSON 已同步”。

JSON 文件就是你的路线图数据和阅读进度，可以自行备份或纳入版本管理。浏览器只记录最近选择的路线图，不负责持久保存阅读进度。

## 更新已有路线图

希望 LLM 补充新论文或重组主题时：

1. 等待页面显示“JSON 已同步”，备份当前 `data/roadmaps/<meta.id>.json`，然后关闭该页面，避免网页与外部编辑同时写入。
2. 复制 [生成提示词](prompts/create-roadmap.md)，将模式改为“更新”，粘贴现有完整 JSON，并描述本次修改要求。
3. 检查模型返回的完整 JSON：已有 ID 和已读资料的 `read: true` 应保留，新资料为 `read: false`。
4. 手动替换对应文件，重新打开或刷新页面，检查结果。

如果希望保留两个版本供比较，给副本设置新的 `meta.id` 和匹配的文件名。仅改变文件名会导致文件名与 ID 不一致，无法正常列入路线图库。

## JSON 格式

推荐统一使用顶层资料表，让多个节点复用同一份资料。下面是可直接保存为 `agent-reading.json` 的完整示例：

```json
{
  "meta": { "id": "agent-reading", "title": "Agent 阅读路线" },
  "resources": [
    {
      "id": "react",
      "title": "ReAct: Synergizing Reasoning and Acting in Language Models",
      "url": "https://arxiv.org/abs/2210.03629",
      "read": false
    },
    {
      "id": "voyager",
      "title": "Voyager: An Open-Ended Embodied Agent with Large Language Models",
      "url": "https://arxiv.org/abs/2305.16291",
      "read": false
    }
  ],
  "nodes": [
    { "id": "foundation", "title": "推理与行动", "resources": ["react"] },
    { "id": "application", "title": "具身应用", "resources": ["voyager"] }
  ],
  "edges": [{ "from": "foundation", "to": "application" }]
}
```

### 字段约束

| 字段 | 生成要求 |
| --- | --- |
| `meta` | 包含 `id` 和非空 `title`。ID 与文件名（不含 `.json`）完全一致，匹配 `^[a-z0-9][a-z0-9_-]{0,79}$`（程序不区分大小写，建议使用小写）。 |
| `resources` | 资料对象数组，每项包含 `id`、非空 `title`、字符串 `url`、布尔值 `read`。资料 ID 唯一，新资料的 `read` 为 `false`。无法核实 URL 时使用空字符串。 |
| `nodes` | 节点对象数组，每项包含唯一 `id`、非空 `title` 和 `resources` 资料 ID 数组。每个引用必须存在于资料表，同一资料可供多个节点引用。 |
| `edges` | `{ "from": "前置节点ID", "to": "后置节点ID" }` 数组。两端必须存在，禁止自环、重复边和循环依赖。无依赖时使用 `[]`。 |

所有 ID 使用稳定、无首尾空格的字符串。输出合法 JSON，不能包含注释、尾逗号或省略号。不添加坐标、层级、样式或摘要等字段：页面自动计算布局，保存时只保留上述结构。

依赖表示“理解后者需要先学习前者”，不要把主题相关性或发表年份直接当作依赖。图谱可以包含多个起点和独立分支。

更完整的实际数据见 [内置路线图](data/roadmaps/agent-systems-research-landscape-v1.json)。

## 常见问题

### 模型返回了说明文字或代码块，怎么办？

只复制完整 JSON 对象到文件。如果输出被截断，要求模型缩小路线图规模并重新输出完整 JSON，不要把带有省略号或不完整括号的内容直接保存。

### 文件放入目录后没有出现？

确认文件位于 `data/roadmaps/`，扩展名为 `.json`，文件名与 `meta.id` 完全一致，然后刷新页面。该目录的数据修改不会触发自动热更新。JSON 语法错误或结构不符合要求也可能导致文件无法显示。

### “加载 JSON”报错怎么办？

先检查页面错误提示，再检查 JSON 语法、重复 ID、不存在的资料引用和循环依赖。可以把完整 JSON 与错误提示交给 LLM，请它修复格式并保留原有 ID 和 `read` 状态。服务接收的请求体有约 2 MB 的大小限制，过大的路线图应拆分。

### 为什么显示只读模式或无法同步？

自动写回文件的 API 只在 Vite 开发服务中启用。请使用 `start.bat`、`sh start.sh` 或上文的 `npm run dev` 命令，并保持终端运行。`npm run preview` 和静态部署不提供该保存 API，不能依赖它们持久保存编辑或阅读进度。

### 启动时提示端口被占用？

启动脚本固定使用 5173 端口。如果已经启动过应用，先查看已有终端或打开对应地址；也可以停止占用端口的旧服务后重新启动。

## 项目结构与开发

```text
prompts/create-roadmap.md   可直接复制给 LLM 的生成与更新提示词
data/roadmaps/             路线图 JSON 和阅读状态
src/App.jsx                图谱展示、编辑、导入与进度管理
src/main.jsx               React 入口
styles.css                 页面样式
vite.config.js             本地 JSON 读写 API 与 Vite 配置
start.bat / start.sh        本地启动脚本
sources/                   研究资料笔记
```

常用命令：

| 命令 | 用途 |
| --- | --- |
| `npm ci` | 按锁文件安装依赖。 |
| `npm run dev` | 启动开发服务，支持本地 JSON 读写。 |
| `npm run build` | 构建静态页面到 `dist/`。 |
| `npm run preview` | 预览构建产物，不支持本地 JSON 写回。 |

直接在仓库内工作的 agent 也可使用 [生成提示词](prompts/create-roadmap.md) 中的格式规范，将完整 JSON 写入 `data/roadmaps/<meta.id>.json`，并在更新时保留已有 ID 和阅读状态。生成后检查引用完整性与依赖无环，再刷新页面验证。

提交变更前请阅读 [贡献约定](CONTRIBUTING.md)。
