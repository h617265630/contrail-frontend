---
name: growth-plan
description: "Growth Plan skill for creating comprehensive, actionable growth roadmaps with clear goals, timelines, resource allocation, and success metrics."
---

# Growth Plan Skill

## Purpose

This skill provides a structured framework for creating detailed, executable growth plans that align teams, allocate resources effectively, and drive measurable business outcomes through systematic growth initiatives.

## When to Use This Skill

Use this skill when asked to:
- Create a comprehensive growth roadmap
- Develop quarterly or annual growth plans
- Align cross-functional teams around growth goals
- Allocate budget and resources for growth initiatives
- Define success metrics and KPIs for growth
- Plan growth experiments and prioritize initiatives

## Growth Plan Structure

### Executive Summary

**Key Components:**
```typescript
interface ExecutiveSummary {
  currentState: {
    users: number
    revenue: number
    growthRate: number
    keyMetrics: Record<string, number>
  }
  goals: {
    timeframe: string
    targetUsers: number
    targetRevenue: number
    targetGrowthRate: number
  }
  strategy: string
  keyInitiatives: string[]
  resourcesNeeded: {
    budget: number
    team: string[]
    tools: string[]
  }
}
```

### Market & Competitive Analysis

**Analysis Framework:**
1. **Target Market**
   - Total addressable market (TAM)
   - Serviceable addressable market (SAM)
   - Serviceable obtainable market (SOM)
   - Market trends and dynamics

2. **Customer Segments**
   - Primary personas
   - Pain points and needs
   - Current solutions they use
   - Willingness to pay

3. **Competitive Landscape**
   - Direct competitors
   - Indirect competitors
   - Competitive advantages
   - Market positioning

4. **SWOT Analysis**
   - Strengths
   - Weaknesses
   - Opportunities
   - Threats

## Growth Goals & Objectives

### OKR Framework

**Objective and Key Results Structure:**
```typescript
interface OKR {
  objective: string // Qualitative goal
  keyResults: KeyResult[]
  owner: string
  timeframe: 'Q1' | 'Q2' | 'Q3' | 'Q4'
}

interface KeyResult {
  metric: string
  baseline: number
  target: number
  current: number
  confidence: number // 1-10
}

// Example OKRs
const growthOKRs: OKR[] = [
  {
    objective: 'Achieve product-market fit and establish strong user retention',
    keyResults: [
      {
        metric: 'D30 Retention Rate',
        baseline: 15,
        target: 40,
        current: 15,
        confidence: 7
      },
      {
        metric: 'NPS Score',
        baseline: 25,
        target: 50,
        current: 25,
        confidence: 6
      },
      {
        metric: 'Weekly Active Users',
        baseline: 1000,
        target: 5000,
        current: 1000,
        confidence: 8
      }
    ],
    owner: 'Head of Product',
    timeframe: 'Q1'
  },
  {
    objective: 'Build scalable acquisition channels',
    keyResults: [
      {
        metric: 'Organic Traffic',
        baseline: 5000,
        target: 25000,
        current: 5000,
        confidence: 7
      },
      {
        metric: 'CAC (Customer Acquisition Cost)',
        baseline: 50,
        target: 30,
        current: 50,
        confidence: 6
      },
      {
        metric: 'Conversion Rate',
        baseline: 2,
        target: 5,
        current: 2,
        confidence: 8
      }
    ],
    owner: 'Head of Growth',
    timeframe: 'Q2'
  }
]
```

### North Star Metric

**Definition:**
The single metric that best captures the core value delivered to customers.

**Examples by Product Type:**
- **Social Network:** Daily Active Users (DAU)
- **SaaS:** Weekly Active Users × Feature Adoption
- **E-commerce:** Number of purchases per month
- **Marketplace:** Gross Merchandise Value (GMV)
- **Content Platform:** Time spent consuming content

**North Star Framework:**
```typescript
interface NorthStarMetric {
  metric: string
  definition: string
  currentValue: number
  targetValue: number
  timeframe: string
  inputMetrics: string[] // Metrics that drive the North Star
  why: string // Why this metric matters
}

const northStar: NorthStarMetric = {
  metric: 'Weekly Learning Paths Completed',
  definition: 'Number of learning paths that users complete each week',
  currentValue: 150,
  targetValue: 1000,
  timeframe: '6 months',
  inputMetrics: [
    'New user signups',
    'Activation rate',
    'Path creation rate',
    'Resource engagement',
    'Retention rate'
  ],
  why: 'Completed paths indicate users are getting core value from the product'
}
```

## Growth Initiatives Roadmap

### Initiative Prioritization

**RICE Framework:**
```typescript
interface Initiative {
  name: string
  description: string
  reach: number // How many users affected per time period
  impact: number // 0.25 (minimal) to 3 (massive)
  confidence: number // 0-100%
  effort: number // Person-months
  riceScore?: number
}

function calculateRICE(initiative: Initiative): number {
  return (initiative.reach * initiative.impact * initiative.confidence) / initiative.effort
}

// Example initiatives
const initiatives: Initiative[] = [
  {
    name: 'Referral Program Launch',
    description: 'Implement double-sided incentive referral program',
    reach: 1000, // 1000 users will see it per quarter
    impact: 2, // High impact
    confidence: 80, // 80% confidence
    effort: 2, // 2 person-months
    riceScore: 0
  },
  {
    name: 'Onboarding Redesign',
    description: 'Streamline signup and first-time user experience',
    reach: 5000, // All new users
    impact: 1.5, // Medium-high impact
    confidence: 90,
    effort: 3,
    riceScore: 0
  }
].map(i => ({ ...i, riceScore: calculateRICE(i) }))
```

### Quarterly Roadmap Template

**Q1 Focus: Foundation & Product-Market Fit**

```markdown
## Q1 Growth Plan (Jan - Mar)

### Theme: Establish Core Value & Retention

### Key Initiatives

#### 1. Onboarding Optimization
- **Goal:** Increase activation rate from 30% to 50%
- **Owner:** Product Team
- **Timeline:** Jan 1 - Feb 15
- **Resources:** 1 PM, 2 Engineers, 1 Designer
- **Budget:** $0 (internal resources)
- **Success Metrics:**
  - Activation rate: 30% → 50%
  - Time to first value: 10 min → 5 min
  - D1 retention: 40% → 55%

**Tactics:**
- [ ] Simplify signup flow (remove unnecessary fields)
- [ ] Add interactive product tour
- [ ] Implement progress indicators
- [ ] Create personalized welcome experience
- [ ] A/B test different onboarding flows

**Milestones:**
- Week 1-2: Research & design
- Week 3-4: Development
- Week 5-6: Testing & iteration
- Week 7-8: Full rollout

#### 2. Content Marketing Engine
- **Goal:** Build organic traffic foundation
- **Owner:** Marketing Team
- **Timeline:** Jan 1 - Mar 31
- **Resources:** 1 Content Lead, 2 Writers
- **Budget:** $5,000 (tools + freelancers)
- **Success Metrics:**
  - Organic traffic: 5k → 15k monthly
  - Blog posts published: 0 → 24
  - Backlinks acquired: 0 → 50

**Tactics:**
- [ ] Keyword research and content strategy
- [ ] Publish 2 comprehensive guides per week
- [ ] Guest post on 5 high-authority sites
- [ ] Build email newsletter
- [ ] Optimize for featured snippets

#### 3. Retention Loop Implementation
- **Goal:** Improve D30 retention from 15% to 30%
- **Owner:** Product + Growth
- **Timeline:** Feb 1 - Mar 31
- **Resources:** 1 PM, 1 Engineer, 1 Growth Marketer
- **Budget:** $2,000 (email tools)
- **Success Metrics:**
  - D7 retention: 35% → 50%
  - D30 retention: 15% → 30%
  - Email open rate: > 30%

**Tactics:**
- [ ] Design email drip campaign
- [ ] Implement push notifications
- [ ] Add streak tracking feature
- [ ] Create weekly digest email
- [ ] Build re-engagement campaigns

### Budget Allocation
- Personnel: $60,000 (salaries)
- Tools & Software: $3,000
- Content & Marketing: $5,000
- Paid Experiments: $2,000
- **Total: $70,000**

### Risk Mitigation
- **Risk:** Low activation rate persists
  - **Mitigation:** Run user interviews, iterate quickly
- **Risk:** Content doesn't drive traffic
  - **Mitigation:** Focus on high-intent keywords, promote on social
- **Risk:** Retention improvements don't materialize
  - **Mitigation:** Analyze cohorts, identify power users, replicate their behavior
```

### Annual Growth Plan Structure

**12-Month Roadmap:**

```typescript
interface AnnualGrowthPlan {
  year: number
  vision: string
  annualGoals: {
    users: number
    revenue: number
    arr: number // Annual Recurring Revenue
    churnRate: number
  }
  quarters: QuarterPlan[]
  budgetAllocation: BudgetAllocation
  teamGrowth: TeamGrowthPlan
}

interface QuarterPlan {
  quarter: 'Q1' | 'Q2' | 'Q3' | 'Q4'
  theme: string
  focus: string[]
  initiatives: Initiative[]
  milestones: Milestone[]
  budget: number
}

interface Milestone {
  name: string
  date: string
  description: string
  successCriteria: string[]
}

// Example Annual Plan
const annualPlan: AnnualGrowthPlan = {
  year: 2026,
  vision: 'Become the leading learning path platform with 100k active users',
  annualGoals: {
    users: 100000,
    revenue: 1200000,
    arr: 1000000,
    churnRate: 5
  },
  quarters: [
    {
      quarter: 'Q1',
      theme: 'Foundation',
      focus: ['Product-market fit', 'Core retention', 'Content foundation'],
      initiatives: [], // Filled with detailed initiatives
      milestones: [
        {
          name: 'Achieve 50% activation rate',
          date: '2026-03-31',
          description: 'Half of signups complete onboarding and create first path',
          successCriteria: ['Activation rate >= 50%', 'NPS > 40']
        }
      ],
      budget: 70000
    },
    {
      quarter: 'Q2',
      theme: 'Acquisition',
      focus: ['SEO scaling', 'Paid channels', 'Partnerships'],
      initiatives: [],
      milestones: [
        {
          name: 'Reach 50k monthly organic visitors',
          date: '2026-06-30',
          description: 'Organic traffic becomes primary acquisition channel',
          successCriteria: ['50k monthly visitors', 'CAC < $30']
        }
      ],
      budget: 100000
    },
    {
      quarter: 'Q3',
      theme: 'Monetization',
      focus: ['Premium features', 'Pricing optimization', 'Upsell flows'],
      initiatives: [],
      milestones: [
        {
          name: 'Launch premium tier',
          date: '2026-09-30',
          description: 'Premium subscription generating $50k MRR',
          successCriteria: ['1000 paid users', '$50k MRR', 'LTV:CAC > 3']
        }
      ],
      budget: 80000
    },
    {
      quarter: 'Q4',
      theme: 'Scale',
      focus: ['Viral growth', 'International expansion', 'Enterprise'],
      initiatives: [],
      milestones: [
        {
          name: 'Reach 100k users',
          date: '2026-12-31',
          description: 'Hit annual user goal with sustainable growth',
          successCriteria: ['100k total users', '$100k MRR', 'Viral coefficient > 0.5']
        }
      ],
      budget: 150000
    }
  ],
  budgetAllocation: {
    personnel: 300000,
    marketing: 80000,
    tools: 20000,
    experiments: 0
  },
  teamGrowth: {
    q1: ['Hire Growth Marketer'],
    q2: ['Hire Content Lead', 'Hire Engineer'],
    q3: ['Hire Product Manager'],
    q4: ['Hire Sales Lead']
  }
}
```

## Channel Strategy

### Channel Planning Framework

```typescript
interface ChannelPlan {
  channel: string
  stage: 'Experiment' | 'Scale' | 'Optimize' | 'Maintain'
  budget: number
  expectedCAC: number
  expectedVolume: number
  owner: string
  tactics: string[]
  metrics: string[]
}

const channelPlans: ChannelPlan[] = [
  {
    channel: 'SEO / Content Marketing',
    stage: 'Scale',
    budget: 30000,
    expectedCAC: 5,
    expectedVolume: 6000,
    owner: 'Content Lead',
    tactics: [
      'Publish 2 blog posts per week',
      'Build backlinks through guest posting',
      'Optimize for featured snippets',
      'Create pillar content and topic clusters'
    ],
    metrics: ['Organic traffic', 'Keyword rankings', 'Backlinks', 'Conversion rate']
  },
  {
    channel: 'Paid Search (Google Ads)',
    stage: 'Experiment',
    budget: 10000,
    expectedCAC: 40,
    expectedVolume: 250,
    owner: 'Growth Marketer',
    tactics: [
      'Test high-intent keywords',
      'Optimize landing pages',
      'A/B test ad copy',
      'Implement conversion tracking'
    ],
    metrics: ['CPC', 'CTR', 'Conversion rate', 'CAC', 'ROAS']
  },
  {
    channel: 'Referral Program',
    stage: 'Scale',
    budget: 15000,
    expectedCAC: 15,
    expectedVolume: 1000,
    owner: 'Product Manager',
    tactics: [
      'Double-sided incentive program',
      'In-app referral prompts',
      'Email referral campaigns',
      'Track and optimize referral funnel'
    ],
    metrics: ['Referral rate', 'Viral coefficient', 'Referral conversion', 'CAC']
  }
]
```

## Budget & Resource Allocation

### Budget Planning Template

```typescript
interface GrowthBudget {
  total: number
  breakdown: {
    personnel: {
      amount: number
      percentage: number
      roles: { role: string; cost: number }[]
    }
    marketing: {
      amount: number
      percentage: number
      channels: { channel: string; budget: number }[]
    }
    tools: {
      amount: number
      percentage: number
      tools: { tool: string; cost: number }[]
    }
    experiments: {
      amount: number
      percentage: number
      allocation: string
    }
  }
}

const quarterlyBudget: GrowthBudget = {
  total: 100000,
  breakdown: {
    personnel: {
      amount: 60000,
      percentage: 60,
      roles: [
        { role: 'Growth Lead', cost: 30000 },
        { role: 'Content Marketer', cost: 20000 },
        { role: 'Growth Engineer', cost: 10000 }
      ]
    },
    marketing: {
      amount: 30000,
      percentage: 30,
      channels: [
        { channel: 'SEO/Content', budget: 10000 },
        { channel: 'Paid Search', budget: 10000 },
        { channel: 'Social Media', budget: 5000 },
        { channel: 'Partnerships', budget: 5000 }
      ]
    },
    tools: {
      amount: 5000,
      percentage: 5,
      tools: [
        { tool: 'Analytics (Mixpanel)', cost: 1000 },
        { tool: 'A/B Testing (Optimizely)', cost: 1500 },
        { tool: 'Email (SendGrid)', cost: 500 },
        { tool: 'SEO (Ahrefs)', cost: 1000 },
        { tool: 'Other tools', cost: 1000 }
      ]
    },
    experiments: {
      amount: 5000,
      percentage: 5,
      allocation: 'Rapid testing budget for new growth experiments'
    }
  }
}
```

## Metrics & Reporting

### Growth Dashboard

**Key Metrics to Track:**

```typescript
interface GrowthDashboard {
  date: string
  acquisition: {
    newUsers: number
    traffic: number
    conversionRate: number
    cac: number
    topChannels: { channel: string; users: number }[]
  }
  activation: {
    activationRate: number
    timeToValue: number
    onboardingCompletionRate: number
  }
  retention: {
    d1: number
    d7: number
    d30: number
    churnRate: number
    activeUsers: { dau: number; wau: number; mau: number }
  }
  referral: {
    referralRate: number
    viralCoefficient: number
    referralConversion: number
  }
  revenue: {
    mrr: number
    arr: number
    arpu: number
    ltv: number
    ltvCacRatio: number
  }
}
```

### Weekly Growth Review Template

```markdown
# Weekly Growth Review - Week of [Date]

## Summary
- **North Star Metric:** [Current value] ([+/- %] vs last week)
- **Key Win:** [Biggest achievement]
- **Key Challenge:** [Biggest blocker]

## Metrics Performance

### Acquisition
- New users: [X] ([+/- %])
- Traffic: [X] ([+/- %])
- Conversion rate: [X]% ([+/- %])
- Top channel: [Channel name]

### Activation
- Activation rate: [X]% ([+/- %])
- Time to value: [X] min

### Retention
- D7 retention: [X]% ([+/- %])
- Churn rate: [X]%

### Experiments
- **Running:** [List active experiments]
- **Completed:** [List completed experiments with results]
- **Planned:** [List upcoming experiments]

## Insights & Learnings
1. [Key insight from data]
2. [User feedback or behavior pattern]
3. [Competitive intelligence]

## Action Items
- [ ] [Action item 1] - Owner: [Name] - Due: [Date]
- [ ] [Action item 2] - Owner: [Name] - Due: [Date]

## Blockers
- [Blocker 1] - Needs: [What's needed to unblock]
```

## Risk Management

### Growth Risks & Mitigation

```typescript
interface GrowthRisk {
  risk: string
  probability: 'Low' | 'Medium' | 'High'
  impact: 'Low' | 'Medium' | 'High'
  mitigation: string[]
  owner: string
}

const growthRisks: GrowthRisk[] = [
  {
    risk: 'Paid acquisition channels become too expensive',
    probability: 'Medium',
    impact: 'High',
    mitigation: [
      'Build organic channels in parallel',
      'Improve conversion rates to justify higher CAC',
      'Diversify across multiple paid channels',
      'Focus on LTV improvement'
    ],
    owner: 'Head of Growth'
  },
  {
    risk: 'Product changes negatively impact retention',
    probability: 'Medium',
    impact: 'High',
    mitigation: [
      'Always A/B test major changes',
      'Monitor retention metrics closely',
      'Have rollback plan ready',
      'Collect user feedback proactively'
    ],
    owner: 'Product Manager'
  },
  {
    risk: 'Competitors copy successful tactics',
    probability: 'High',
    impact: 'Medium',
    mitigation: [
      'Build sustainable competitive advantages',
      'Focus on product differentiation',
      'Move fast and iterate quickly',
      'Build strong brand and community'
    ],
    owner: 'CEO'
  }
]
```

## Growth Plan Template

```markdown
# [Product Name] Growth Plan - [Year/Quarter]

## Executive Summary
- **Current State:** [Key metrics]
- **Goals:** [Targets for period]
- **Strategy:** [High-level approach]
- **Budget:** [Total budget]

## Market Analysis
### Target Market
- TAM: [Total addressable market]
- SAM: [Serviceable addressable market]
- SOM: [Serviceable obtainable market]

### Customer Segments
1. [Segment 1]: [Description]
2. [Segment 2]: [Description]

### Competitive Landscape
- Direct competitors: [List]
- Our advantages: [List]

## Goals & Objectives
### North Star Metric
- **Metric:** [Name]
- **Current:** [Value]
- **Target:** [Value]
- **Timeline:** [Date]

### OKRs
#### Objective 1: [Name]
- KR1: [Metric] from [X] to [Y]
- KR2: [Metric] from [X] to [Y]
- KR3: [Metric] from [X] to [Y]

## Growth Initiatives
### Initiative 1: [Name]
- **Goal:** [Specific goal]
- **Owner:** [Name]
- **Timeline:** [Dates]
- **Budget:** [Amount]
- **Tactics:** [List]
- **Success Metrics:** [List]

### Initiative 2: [Name]
[Same structure]

## Channel Strategy
### Channel 1: [Name]
- **Stage:** [Experiment/Scale/Optimize]
- **Budget:** [Amount]
- **Expected CAC:** [Amount]
- **Expected Volume:** [Number]
- **Tactics:** [List]

## Budget & Resources
### Budget Breakdown
- Personnel: [Amount] ([%])
- Marketing: [Amount] ([%])
- Tools: [Amount] ([%])
- Experiments: [Amount] ([%])
- **Total:** [Amount]

### Team
- Current: [List roles]
- Hiring plan: [List new roles and timeline]

## Metrics & Reporting
### Key Metrics
- [Metric 1]: [Target]
- [Metric 2]: [Target]
- [Metric 3]: [Target]

### Reporting Cadence
- Daily: [What to monitor]
- Weekly: [What to review]
- Monthly: [What to analyze]

## Risks & Mitigation
1. **Risk:** [Description]
   - **Mitigation:** [Plan]

## Timeline & Milestones
- [Date]: [Milestone]
- [Date]: [Milestone]
- [Date]: [Milestone]

## Success Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
```

## Best Practices

1. **Set Realistic Goals** - Ambitious but achievable
2. **Focus on Few Initiatives** - Better to execute 3 well than 10 poorly
3. **Align Cross-Functionally** - Get buy-in from all teams
4. **Review Regularly** - Weekly metrics review, monthly plan adjustment
5. **Document Learnings** - Build institutional knowledge
6. **Stay Flexible** - Adjust plan based on data and market changes
7. **Celebrate Wins** - Recognize team achievements

## Resources

- "Playing to Win" by A.G. Lafley
- "Good Strategy Bad Strategy" by Richard Rumelt
- "Measure What Matters" by John Doerr (OKRs)
- Reforge Growth Strategy course
