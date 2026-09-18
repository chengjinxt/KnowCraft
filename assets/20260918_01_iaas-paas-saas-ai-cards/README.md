# IaaS、PaaS、SaaS 与 AI SaaS 知识卡片

## 卡片顺序

1. `01-iaas-paas-saas-basics.png`：用“租到哪一层”解释 IaaS、PaaS、SaaS 的基本概念与控制范围。
2. `02-shared-responsibility.png`：用技术栈矩阵说明 Shared Responsibility Model（共享责任模型）。
3. `03-choose-cloud-service-model.png`：从“用软件还是造软件”出发，给出 IaaS、PaaS、SaaS 的选型流程。
4. `04-traditional-to-ai-saas.png`：解释 Traditional SaaS、AI-enabled SaaS 与 AI-native / Agentic SaaS 的演进关系。
5. `05-ai-saas-architecture.png`：拆解 AI SaaS 从身份、编排、模型、RAG、记忆、工具到审计的受控执行链。
6. `06-ai-agent-shared-responsibility.png`：对比 IaaS Agent、PaaS Agent、SaaS Agent 的典型责任边界。
7. `07-ai-saas-risks-economics.png`：从质量、安全、隔离、成本、可靠性和治理六个维度检查 AI SaaS。

## 核心知识

- `IaaS (Infrastructure as a Service，基础设施即服务)` 提供计算、存储和网络等基础资源，客户通常还要管理操作系统、运行环境、应用和数据。
- `PaaS (Platform as a Service，平台即服务)` 把操作系统、运行时、中间件和扩缩容等能力托管起来，让客户更专注于代码、应用配置和数据。
- `SaaS (Software as a Service，软件即服务)` 交付可直接使用的完整应用，但客户仍要管理账号、权限、数据治理、配置和正确使用。
- 三种模式不是“低级到高级”的排名。越靠近 SaaS，供应商托管范围通常越大；越靠近 IaaS，客户控制力和运维责任通常越大。
- SaaS、PaaS、IaaS 可以组合：一个面向用户的 SaaS 产品，本身可以构建在 PaaS 和 IaaS 之上。
- `AI SaaS` 仍然属于 SaaS，不是 NIST 定义之外的第四种官方云服务模型。`AI-enabled（AI 增强型）`、`AI-native（AI 原生）` 和 `Agentic（智能体型）` 描述的是产品能力或架构形态。
- 传统 SaaS 以确定性的功能、表单和规则流程为主；AI SaaS 可以通过模型理解意图、检索依据、选择工具并协助完成任务，但输出和行动需要额外约束。
- `RAG (Retrieval-Augmented Generation，检索增强生成)` 用授权资料为模型补充上下文和依据，但不能保证输出绝对正确。
- `Agent（智能体）` 适合需要理解上下文、动态选择步骤或跨系统操作的任务。固定规则足以解决的流程，通常更便宜、稳定且容易审计。
- AI SaaS 的完整链路通常不止一个模型 API，还包括身份与租户上下文、编排器、模型网关、RAG、记忆、工具调用、安全护栏、可观测性和人工审批。
- `Authentication（认证）` 只能确认“你是谁”，不等于 `Tenant Isolation（租户隔离）`。原始数据、向量索引、提示上下文、记忆、工具凭据、日志和追踪数据都要做租户级隔离。
- 删除、付款、发布、授权等高风险或不可逆操作，应使用最小权限、参数校验、人工审批、幂等控制和审计日志。
- AI SaaS 的成本不仅是服务器，还可能包含输入/输出 Token、Embedding、检索、工具调用、重试、推理循环和 GPU；应关注 `Cost per Successful Task（每个成功任务成本）`。
- AI SaaS 可能从单一席位订阅扩展为按用量、按任务、按结果或混合计费，但这不是所有产品的统一答案。

## 技术边界

- 卡片中的责任矩阵是便于理解的典型模型。实际边界会因云产品、配置、合同、监管要求和是否调用外部模型而变化。
- SaaS 供应商运行应用，不代表客户不再承担身份、访问范围、数据治理、输出复核和合规使用责任。
- 模型输出具有概率性；温度、约束、结构化输出、检索和评测可以降低不确定性，但不能把生成式模型变成绝对正确的规则引擎。
- “Agent 可以自主完成任务”不等于允许它拥有无限权限。行动能力越强，权限隔离、预算、超时、审批和审计越重要。

## 官方参考

- [NIST SP 800-145: The NIST Definition of Cloud Computing](https://csrc.nist.gov/pubs/sp/800/145/final)
- [AWS: Types of Cloud Computing](https://aws.amazon.com/types-of-cloud-computing/)
- [Microsoft Learn: Shared responsibility in the cloud](https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility)
- [Microsoft Learn: Shared responsibility for AI agents](https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility-ai-agent)
- [Microsoft Learn: Shared responsibility for AI](https://learn.microsoft.com/en-us/compliance/assurance/assurance-artificial-intelligence)
- [Microsoft Learn: AI architecture design](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/ai-overview)
- [Microsoft Learn: Design and develop a RAG solution](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/rag/rag-agentic)
- [NIST AI 600-1: Generative AI Profile](https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence)
- [AWS SaaS Architecture Fundamentals: Tenant isolation](https://docs.aws.amazon.com/whitepapers/latest/saas-architecture-fundamentals/tenant-isolation.html)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`。
- 画面规格：3:4 竖版、浅色背景、高对比标题、圆角信息块，适合手机端阅读。
- 原创说明：未复制平台标识、品牌 Logo 或他人卡片模板。
- 修订说明：第 3 张首次生成时漏排第三个决策问题，已定向重做并补齐“需要自定义操作系统、网络或特殊运行环境？”。
- 技术检查：已核对中英文全称、责任边界、AI SaaS 定位、RAG 边界、租户隔离、安全审批与成本口径。
