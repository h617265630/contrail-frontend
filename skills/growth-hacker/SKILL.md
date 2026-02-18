---
name: growth-hacker
description: "Growth Hacker skill for rapid experimentation, creative problem-solving, and unconventional tactics to achieve exponential user growth with limited resources."
---

# Growth Hacker Skill

## Purpose

This skill focuses on the mindset, tactics, and execution methods of growth hacking - using creative, low-cost strategies to help businesses acquire and retain customers through rapid experimentation and data-driven iteration.

## When to Use This Skill

Use this skill when asked to:
- Find creative, low-cost growth tactics
- Design rapid growth experiments
- Identify unconventional growth opportunities
- Optimize conversion funnels with limited resources
- Build viral loops and referral mechanisms
- Implement growth hacks for early-stage products

## Core Growth Hacker Mindset

### Key Principles

1. **T-Shaped Skills** - Deep expertise in one area, broad knowledge across marketing, product, and analytics
2. **Data-Driven** - Every decision backed by metrics and experiments
3. **Resourceful** - Achieve maximum impact with minimal budget
4. **Rapid Iteration** - Move fast, test quickly, learn constantly
5. **Product-Focused** - Growth is built into the product, not just marketing
6. **Scalable** - Focus on tactics that can scale exponentially

### Growth Hacker vs Traditional Marketer

```typescript
interface GrowthHacker {
  focus: 'Product + Marketing Integration'
  budget: 'Minimal to Zero'
  timeline: 'Rapid experimentation (days/weeks)'
  metrics: 'Activation, Retention, Referral'
  approach: 'Data-driven, technical, creative'
  goal: 'Exponential growth'
}

interface TraditionalMarketer {
  focus: 'Brand awareness and campaigns'
  budget: 'Significant ad spend'
  timeline: 'Long-term campaigns (months)'
  metrics: 'Impressions, Reach, Brand lift'
  approach: 'Creative, strategic'
  goal: 'Linear growth'
}
```

## Classic Growth Hacks

### 1. Dropbox - Referral Program

**The Hack:**
- Give 500MB free storage for every friend referred
- Friend gets 500MB too (double-sided incentive)
- Result: 60% increase in signups, 3900% growth in 15 months

**Key Lessons:**
- Make referral valuable for both parties
- Integrate into product experience
- Track and optimize referral funnel

### 2. Airbnb - Craigslist Integration

**The Hack:**
- Automatically cross-post Airbnb listings to Craigslist
- Tap into existing massive user base
- Result: Explosive early growth

**Key Lessons:**
- Leverage existing platforms with your audience
- Find creative integration opportunities
- Provide value to both platforms

### 3. Hotmail - Email Signature

**The Hack:**
- Add "PS: I love you. Get your free email at Hotmail" to every email
- Viral spread through normal email usage
- Result: 12 million users in 18 months

**Key Lessons:**
- Built-in viral loop in core product usage
- Zero-cost distribution
- Simple, clear call-to-action

### 4. PayPal - Cash Incentives

**The Hack:**
- $10 for signing up + $10 for each referral
- Direct cash incentive for both parties
- Result: 7-10% daily growth, reached 100k users in weeks

**Key Lessons:**
- Sometimes direct incentives work best
- Calculate LTV to justify acquisition cost
- Time-limited to create urgency

## Growth Hacking Tactics Library

### Acquisition Tactics

**1. Content Marketing Hacks**
```typescript
interface ContentHack {
  tactic: string
  effort: 'Low' | 'Medium' | 'High'
  impact: 'Low' | 'Medium' | 'High'
  timeToResults: string
}

const contentHacks: ContentHack[] = [
  {
    tactic: 'Guest posting on high-traffic blogs',
    effort: 'Medium',
    impact: 'High',
    timeToResults: '2-4 weeks'
  },
  {
    tactic: 'Create viral infographics',
    effort: 'Medium',
    impact: 'Medium',
    timeToResults: '1-2 weeks'
  },
  {
    tactic: 'Answer questions on Quora/Reddit with product mentions',
    effort: 'Low',
    impact: 'Medium',
    timeToResults: 'Immediate'
  },
  {
    tactic: 'Create free tools/calculators that solve user problems',
    effort: 'High',
    impact: 'High',
    timeToResults: '4-8 weeks'
  }
]
```

**2. SEO Hacks**
- Programmatic SEO (generate thousands of landing pages)
- Steal competitor keywords with better content
- Build backlinks through broken link building
- Optimize for featured snippets and "People also ask"

**3. Social Media Hacks**
- Post at optimal times (use analytics)
- Engage with influencer posts early (first 10 comments)
- Use trending hashtags strategically
- Create shareable memes/content for your niche

**4. Partnership Hacks**
- Co-marketing with complementary products
- Integration partnerships for mutual growth
- Affiliate programs with performance incentives
- Cross-promotion with non-competing brands

### Activation Tactics

**1. Onboarding Optimization**
```javascript
// Example: Reduce friction in signup
const onboardingHacks = {
  socialLogin: 'One-click signup with Google/Facebook',
  progressBar: 'Show completion progress to reduce abandonment',
  deferredRegistration: 'Let users try before signing up',
  personalizedWelcome: 'Customize experience based on user intent',
  quickWins: 'Show immediate value in first session'
}
```

**2. First-Time User Experience**
- Interactive tutorials (not boring videos)
- Empty state design that guides action
- Personalized recommendations immediately
- Gamification of first tasks
- Success celebrations for early wins

### Retention Tactics

**1. Email Sequences**
```typescript
interface EmailSequence {
  day: number
  trigger: string
  goal: string
  content: string
}

const retentionEmails: EmailSequence[] = [
  {
    day: 0,
    trigger: 'Signup',
    goal: 'Activation',
    content: 'Welcome + quick start guide'
  },
  {
    day: 1,
    trigger: 'No activity',
    goal: 'Re-engagement',
    content: 'Did you know you can...?'
  },
  {
    day: 7,
    trigger: 'Active user',
    goal: 'Habit formation',
    content: 'Your weekly summary + tips'
  },
  {
    day: 30,
    trigger: 'Inactive',
    goal: 'Win-back',
    content: 'We miss you + new features'
  }
]
```

**2. Push Notification Hacks**
- Personalized based on user behavior
- Time-sensitive offers/updates
- Social proof (friends joined, trending content)
- Achievement unlocks and milestones

**3. In-App Engagement**
- Streak tracking (daily usage rewards)
- Leaderboards and competition
- Exclusive content for active users
- Community features (comments, likes, shares)

### Referral Tactics

**1. Referral Program Design**
```typescript
interface ReferralProgram {
  incentiveType: 'Credits' | 'Cash' | 'Features' | 'Content'
  referrerReward: string
  refereeReward: string
  sharingMechanism: string[]
  trackingMethod: string
}

const referralPrograms: ReferralProgram[] = [
  {
    incentiveType: 'Credits',
    referrerReward: '$10 credit',
    refereeReward: '$10 credit',
    sharingMechanism: ['Email', 'Social', 'Unique link'],
    trackingMethod: 'Referral code + cookies'
  },
  {
    incentiveType: 'Features',
    referrerReward: 'Premium feature unlock',
    refereeReward: 'Extended trial',
    sharingMechanism: ['In-app share button', 'Email invite'],
    trackingMethod: 'User ID tracking'
  }
]
```

**2. Viral Loop Mechanics**
- Make sharing core to product value
- Network effects (product better with more users)
- Social proof display (show who else uses it)
- Easy one-click sharing
- Track and display referral impact

### Revenue Tactics

**1. Pricing Hacks**
- Freemium with clear upgrade path
- Time-limited discounts for new users
- Annual plan discount (get cash upfront)
- Usage-based pricing (align with value)
- Anchor pricing (show expensive option first)

**2. Conversion Optimization**
- Exit-intent popups with offers
- Abandoned cart emails
- Social proof on pricing page
- Money-back guarantee to reduce risk
- Live chat for sales support

## Growth Hacking Toolkit

### Essential Tools

**Analytics & Tracking:**
- Google Analytics (free web analytics)
- Mixpanel/Amplitude (product analytics)
- Hotjar (heatmaps and recordings)
- Google Tag Manager (event tracking)

**A/B Testing:**
- Google Optimize (free A/B testing)
- Optimizely (enterprise testing)
- VWO (visual editor testing)

**Email Marketing:**
- Mailchimp (free tier for small lists)
- SendGrid (transactional emails)
- Customer.io (behavior-based emails)

**Social Media:**
- Buffer (scheduling)
- Hootsuite (management)
- BuzzSumo (content research)

**SEO:**
- Ahrefs/SEMrush (keyword research)
- Google Search Console (free SEO data)
- Screaming Frog (technical SEO)

**Landing Pages:**
- Unbounce (landing page builder)
- Instapage (conversion-focused)
- Webflow (design freedom)

## Growth Hacking Process

### 1. Identify Bottleneck

**Funnel Analysis:**
```
Visitors → Signups → Activated → Retained → Referrers → Revenue
  100%      20%        50%        30%        10%        5%
```

**Find the weakest link:**
- Calculate conversion rates at each stage
- Identify biggest drop-off
- Focus experiments on that stage

### 2. Generate Ideas

**Brainstorming Framework:**
- What are competitors doing?
- What worked in other industries?
- What's the unconventional approach?
- What can we automate?
- What can we make viral?

**ICE Scoring:**
```typescript
interface Idea {
  description: string
  impact: number // 1-10
  confidence: number // 1-10
  ease: number // 1-10
  iceScore: number // (I + C + E) / 3
}

function prioritizeIdeas(ideas: Idea[]): Idea[] {
  return ideas
    .map(idea => ({
      ...idea,
      iceScore: (idea.impact + idea.confidence + idea.ease) / 3
    }))
    .sort((a, b) => b.iceScore - a.iceScore)
}
```

### 3. Design Experiment

**Experiment Template:**
```markdown
## Experiment: [Name]

**Hypothesis:** We believe that [change] will result in [outcome] because [reasoning]

**Metrics:**
- Primary: [main success metric]
- Secondary: [supporting metrics]
- Guardrail: [metrics that shouldn't decrease]

**Setup:**
- Control: [current experience]
- Treatment: [new experience]
- Sample size: [number of users]
- Duration: [time period]

**Success Criteria:**
- [Metric] increases by [X]%
- Statistical significance: 95%
- No negative impact on [guardrail metrics]
```

### 4. Implement Quickly

**Speed Principles:**
- Use no-code tools when possible
- MVP approach (minimum viable test)
- Manual processes before automation
- Fake it before you build it

**Example: Testing Referral Program**
- Day 1: Manual tracking in spreadsheet
- Day 2: Simple form for referral submission
- Week 1: Basic automated tracking
- Month 1: Full-featured referral system

### 5. Analyze & Iterate

**Analysis Checklist:**
- [ ] Sufficient sample size reached
- [ ] Statistical significance achieved
- [ ] Segment analysis completed
- [ ] Unexpected behaviors identified
- [ ] Qualitative feedback collected

**Decision Matrix:**
- **Clear Win:** Ship to 100%, document playbook
- **Promising:** Iterate and retest
- **Inconclusive:** Extend test or redesign
- **Clear Loss:** Kill and move to next idea

## Growth Hacking Playbooks

### Playbook: Launch Day Spike

**Goal:** Generate maximum visibility and signups on launch day

**Tactics:**
1. Product Hunt launch (prepare community upvotes)
2. Hacker News post (genuine story, not promotional)
3. Reddit AMAs in relevant subreddits
4. Email to personal network
5. Social media coordinated posting
6. Press release to tech blogs
7. Exclusive launch offers

**Timeline:**
- 2 weeks before: Build email list, prepare assets
- 1 week before: Reach out to influencers
- Launch day: Execute all channels simultaneously
- Post-launch: Follow up, thank supporters, share metrics

### Playbook: Content-Led Growth

**Goal:** Build organic traffic through valuable content

**Tactics:**
1. Keyword research (find low-competition, high-value keywords)
2. Create comprehensive guides (10x better than competitors)
3. Optimize for featured snippets
4. Build internal linking structure
5. Promote on social media and communities
6. Update and refresh content regularly

**Content Types:**
- Ultimate guides (5000+ words)
- Comparison articles ([Product] vs [Competitor])
- How-to tutorials with screenshots
- Case studies with real results
- Free tools and calculators

### Playbook: Community-Driven Growth

**Goal:** Build engaged community that drives organic growth

**Tactics:**
1. Create exclusive community (Slack, Discord, Circle)
2. Provide unique value (insider tips, early access)
3. Facilitate peer connections
4. Host regular events (AMAs, workshops)
5. Recognize and reward active members
6. Enable user-generated content

**Community Flywheel:**
```
Great content → Engaged members → More content → More members → Network effects
```

## Common Growth Hacking Mistakes

1. **Focusing on vanity metrics** - Pageviews don't matter if users don't convert
2. **Ignoring retention** - Leaky bucket problem (acquiring users who churn immediately)
3. **Copying tactics without understanding** - What worked for Dropbox may not work for you
4. **Premature scaling** - Scaling broken funnels wastes money
5. **Not tracking properly** - Can't optimize what you don't measure
6. **Giving up too early** - Growth hacking requires persistence
7. **Unethical tactics** - Spam, fake reviews, misleading claims damage brand

## Ethical Growth Hacking

**Guidelines:**
- Be transparent about incentives
- Respect user privacy and data
- Don't spam or manipulate
- Provide genuine value
- Follow platform terms of service
- Build sustainable, not exploitative, growth

## Growth Hacking Checklist

**Foundation:**
- [ ] Analytics properly set up
- [ ] Conversion funnel mapped
- [ ] Baseline metrics established
- [ ] User personas defined
- [ ] Competitor analysis completed

**Acquisition:**
- [ ] SEO optimized
- [ ] Content strategy defined
- [ ] Social media presence established
- [ ] Referral program designed
- [ ] Partnership opportunities identified

**Activation:**
- [ ] Onboarding flow optimized
- [ ] Time to value minimized
- [ ] Empty states designed
- [ ] Quick wins identified
- [ ] Welcome email sequence created

**Retention:**
- [ ] Email automation set up
- [ ] Push notifications implemented
- [ ] Engagement loops designed
- [ ] Churn analysis completed
- [ ] Win-back campaigns created

**Referral:**
- [ ] Sharing mechanisms built
- [ ] Incentives defined
- [ ] Tracking implemented
- [ ] Social proof displayed
- [ ] Viral loops identified

**Revenue:**
- [ ] Pricing optimized
- [ ] Upgrade prompts designed
- [ ] Abandoned cart recovery set up
- [ ] Upsell opportunities identified
- [ ] Payment friction reduced

## Resources

**Books:**
- "Hacking Growth" by Sean Ellis & Morgan Brown
- "Traction" by Gabriel Weinberg & Justin Mares
- "Growth Hacker Marketing" by Ryan Holiday

**Communities:**
- GrowthHackers.com
- Reforge (premium)
- Indie Hackers
- r/GrowthHacking

**Blogs & Newsletters:**
- Andrew Chen's blog
- Brian Balfour's blog
- Neil Patel's blog
- Growth.Design case studies
