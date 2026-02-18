---
name: growth-strategy
description: "Growth Strategy skill for developing comprehensive growth frameworks, identifying growth opportunities, and implementing data-driven growth initiatives for products and platforms."
---

# Growth Strategy Skill

## Purpose

This skill provides a structured approach to developing and executing growth strategies for digital products, focusing on sustainable user acquisition, activation, retention, and revenue growth.

## When to Use This Skill

Use this skill when asked to:
- Develop a comprehensive growth strategy for a product or platform
- Identify growth opportunities and bottlenecks in user funnels
- Design experiments to test growth hypotheses
- Analyze growth metrics and KPIs
- Create growth roadmaps and prioritization frameworks

## Core Concepts

### Growth Framework

The AARRR (Pirate Metrics) framework:

1. **Acquisition** - How users find your product
2. **Activation** - First user experience and "aha moment"
3. **Retention** - Users coming back and engaging
4. **Referral** - Users recommending your product
5. **Revenue** - Monetization and business model

### Key Growth Metrics

```typescript
interface GrowthMetrics {
  // Acquisition
  traffic: number
  signups: number
  costPerAcquisition: number
  
  // Activation
  activationRate: number
  timeToValue: number
  
  // Retention
  dayNRetention: Record<number, number> // D1, D7, D30
  churnRate: number
  
  // Referral
  viralCoefficient: number
  referralRate: number
  
  // Revenue
  ltv: number // Lifetime Value
  arpu: number // Average Revenue Per User
  ltvCacRatio: number
}
```

## Growth Strategy Development Process

### 1. Situation Analysis

**Current State Assessment:**
- User demographics and behavior patterns
- Product-market fit indicators
- Competitive landscape
- Current growth metrics baseline

**Tools:**
- User cohort analysis
- Funnel analysis
- Market research
- Competitor benchmarking

### 2. Growth Opportunity Identification

**High-Impact Areas:**
- Conversion rate optimization at each funnel stage
- Viral loops and referral mechanisms
- Content marketing and SEO
- Paid acquisition channels
- Product-led growth features
- Partnership and integration opportunities

**Prioritization Framework:**
- ICE Score (Impact × Confidence × Ease)
- Expected value calculation
- Resource requirements
- Time to impact

### 3. Hypothesis Formation

**Growth Hypothesis Template:**
```
We believe that [specific change]
Will result in [expected outcome]
For [target user segment]
We will measure this by [specific metric]
```

**Example:**
```
We believe that adding a personalized onboarding flow
Will result in 20% increase in D7 retention
For new users who sign up via organic search
We will measure this by tracking D7 retention rate
```

### 4. Experiment Design

**A/B Test Structure:**
- Control group (current experience)
- Treatment group (new experience)
- Sample size calculation
- Success criteria
- Duration and timeline

**Key Considerations:**
- Statistical significance threshold (typically 95%)
- Minimum detectable effect
- Segmentation strategy
- Instrumentation and tracking

### 5. Implementation & Execution

**Technical Requirements:**
- Feature flags for experiment control
- Analytics instrumentation
- User segmentation logic
- Performance monitoring

**Rollout Strategy:**
- Gradual rollout (5% → 25% → 50% → 100%)
- Monitoring for negative impacts
- Rollback procedures

### 6. Analysis & Iteration

**Metrics to Track:**
- Primary success metric
- Secondary metrics (guardrail metrics)
- Segment-level performance
- Statistical significance

**Decision Framework:**
- Ship: Clear winner with statistical significance
- Iterate: Promising but needs refinement
- Kill: No impact or negative results
- Scale: Successful, expand to more users

## Growth Channels Strategy

### Organic Channels

**SEO & Content Marketing:**
- Keyword research and content strategy
- Technical SEO optimization
- Link building and authority
- Content distribution

**Social Media:**
- Platform selection based on audience
- Content calendar and posting strategy
- Community engagement
- Influencer partnerships

**Viral & Referral:**
- Referral program design
- Incentive structure
- Sharing mechanics
- Viral loop optimization

### Paid Channels

**Paid Acquisition:**
- Channel selection (Google Ads, Facebook, LinkedIn, etc.)
- Budget allocation
- Creative testing
- Bid optimization
- Attribution modeling

**Retargeting:**
- Audience segmentation
- Creative personalization
- Frequency capping
- Cross-channel coordination

## Growth Playbooks

### Playbook 1: Onboarding Optimization

**Goal:** Increase activation rate by improving first-time user experience

**Tactics:**
1. Reduce time to value
2. Progressive disclosure of features
3. Personalized onboarding flows
4. Interactive tutorials
5. Quick wins and early success

**Metrics:**
- Activation rate
- Time to first value
- Feature adoption rate

### Playbook 2: Retention Loop

**Goal:** Build habit-forming product experiences

**Tactics:**
1. Email/push notification strategy
2. In-app engagement triggers
3. Gamification elements
4. Social proof and community
5. Regular content updates

**Metrics:**
- D1, D7, D30 retention
- Session frequency
- Feature stickiness

### Playbook 3: Referral Engine

**Goal:** Create sustainable viral growth

**Tactics:**
1. Double-sided incentives
2. Easy sharing mechanisms
3. Social proof display
4. Referral tracking and attribution
5. Referrer recognition

**Metrics:**
- Viral coefficient (K-factor)
- Referral conversion rate
- Referrer engagement

## Growth Stack & Tools

**Analytics:**
- Google Analytics / Mixpanel / Amplitude
- Cohort analysis tools
- Funnel visualization
- User session recording

**Experimentation:**
- A/B testing platforms (Optimizely, VWO)
- Feature flags (LaunchDarkly)
- Statistical analysis tools

**Marketing Automation:**
- Email marketing (SendGrid, Mailchimp)
- Push notifications (OneSignal)
- In-app messaging (Intercom)

**Attribution:**
- Multi-touch attribution platforms
- UTM tracking
- Conversion tracking

## Best Practices

1. **Data-Driven Decision Making**
   - Always measure before and after
   - Use statistical significance
   - Avoid vanity metrics

2. **Focus on North Star Metric**
   - Single metric that matters most
   - Aligns team around growth
   - Reflects true product value

3. **Rapid Experimentation**
   - Run multiple experiments in parallel
   - Fail fast, learn faster
   - Document learnings

4. **Cross-Functional Collaboration**
   - Product, engineering, marketing alignment
   - Regular growth meetings
   - Shared OKRs

5. **Sustainable Growth**
   - Balance short-term wins with long-term health
   - Monitor unit economics
   - Avoid growth at all costs mentality

## Common Pitfalls to Avoid

- Optimizing for vanity metrics
- Ignoring retention while focusing on acquisition
- Not segmenting users properly
- Running too many experiments simultaneously
- Declaring winners too early (insufficient data)
- Neglecting qualitative feedback
- Over-relying on paid acquisition

## Growth Strategy Template

```markdown
# Growth Strategy for [Product Name]

## Executive Summary
- Current state
- Growth goals
- Key initiatives

## Market Analysis
- Target audience
- Market size
- Competitive landscape

## Growth Goals
- 6-month targets
- 12-month targets
- Key metrics

## Growth Initiatives
1. [Initiative 1]
   - Objective
   - Tactics
   - Expected impact
   - Resources needed
   - Timeline

2. [Initiative 2]
   ...

## Experimentation Roadmap
- Q1 experiments
- Q2 experiments
- ...

## Budget & Resources
- Channel budget allocation
- Team requirements
- Tool stack

## Success Metrics & KPIs
- North Star Metric
- Primary metrics
- Secondary metrics

## Risk Mitigation
- Potential challenges
- Contingency plans
```

## Implementation Checklist

- [ ] Define North Star Metric
- [ ] Set up analytics and tracking
- [ ] Establish baseline metrics
- [ ] Identify top 3 growth opportunities
- [ ] Design first experiment
- [ ] Implement feature flags and A/B testing
- [ ] Create growth dashboard
- [ ] Schedule weekly growth reviews
- [ ] Document learnings and playbooks
- [ ] Scale winning experiments

## Resources & Further Reading

- "Hacking Growth" by Sean Ellis
- "Lean Analytics" by Alistair Croll
- "Traction" by Gabriel Weinberg
- Reforge Growth Series
- Andrew Chen's blog on growth
