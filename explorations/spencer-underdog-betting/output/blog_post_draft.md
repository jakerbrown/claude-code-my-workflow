# Did Betting Early-Season Underdogs Ever Actually Work?

Spencer's theory is intuitive. At the beginning of a season, the market still
does not know exactly who is good, who is bad, and which preseason narratives
were wrong. If sportsbooks and bettors are still leaning too hard on stale
priors, some teams priced as underdogs should really be closer to coin flips.
And because underdogs pay more when they win, even a modest amount of
mispricing could, in principle, turn into positive expected return.

That story is plausible. The harder question is whether it was true often
enough, across leagues and through bookmaker vig, to show up in real historical
moneyline data.

I built a cross-league game panel covering the NFL, NBA, NHL, and MLB from
`2011` through `2021` using public sportsbook archives with closing moneylines
and final scores. The final cleaned panel contains `53,453` games across `44`
league-seasons. The package, code, and source memo live in the replication
folder: [`../replication/`](../replication/).

## The Strategy Definitions

The baseline strategy is deliberately naive:

- bet `$100` on every underdog
- use closing moneyline odds
- focus on the very beginning of each season

I fixed four early-season definitions before reviewing the output tables for
this project:

1. First 2 calendar weeks.
2. First 3 calendar weeks.
3. First 5 games played by the underdog.
4. First 10 percent of the team-season proxy.

I also compared the rule with obvious benchmarks:

- betting all underdogs over the likely-regular-season proxy
- betting favorites in the same early windows
- betting a random team in each early game
- betting underdogs later in the season
- permuting underdog timing within season to see whether the actual early
  window looks special

## Main Result

The best naive pooled rule was "bet every early underdog for the first 3
weeks." It still did not make compelling money.

![ROI by window](/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/spencer-underdog-betting/output/fig_roi_by_window.png)

Pooled results:

- First 2 weeks: ROI `-1.2%`
- First 3 weeks: ROI `-0.4%`
- First 5 games: ROI `-1.0%`
- First 10 percent of season: ROI `-0.7%`

The first-3-weeks rule placed `5,901` bets and produced a `95%` bootstrap
interval of roughly `[-4.0%, 3.4%]`. That interval is important. It means the
historical sample is consistent with mild gains, but also with ordinary losses.
The evidence is not strong enough to call this a proven positive edge.

## Better Than the Alternatives, But Still Not a Gold Mine

Where Spencer's idea looks strongest is in relative, not absolute, terms.

Compared with the obvious baselines:

- all underdogs over the likely-regular-season proxy lost `1.8%`
- early favorites lost about `4.1%`
- a random team in the same early window lost about `2.4%` on average
- permuted underdog timing also looked worse than the actual early window

So early underdogs were less bad than generic underdog betting. That pattern is
consistent with a small early-season informational story that mostly gets eaten
by vig and variance, though it is not diagnostic of that mechanism on its own.

## The League Split

The story is not the same in every league.

![Forest plot](/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/spencer-underdog-betting/output/fig_forest_plot.png)

Early 3-week underdog ROI by league:

- MLB: `+3.9%`
- NFL: `+1.8%`
- NBA: `-0.4%`
- NHL: `-8.2%`

The partial-pooling estimates shrink those league-specific returns back toward
roughly zero, especially for NFL and MLB. That matters because the raw split is
too noisy to interpret as four independent truths.

The cleanest substantive read is:

- MLB shows the most interesting positive hint.
- NFL is directionally positive but very uncertain because the sample is small.
- NBA looks close to efficient.
- NHL looks actively hostile to the strategy.

That does **not** line up cleanly with any one simple theory like "shorter
seasons help" or "roster continuity helps." If there is a real mechanism, it
is more nuanced than one league characteristic.

## Was the Market Actually Underpricing Early Underdogs?

Raw ROI can be misleading because underdogs are paid more when they win. A
better diagnostic is to compare realized upset frequency with the no-vig
implied probability.

For pooled early 3-week underdogs:

- realized win rate: `40.45%`
- average no-vig implied win probability: `39.70%`
- calibration gap: `+0.75` percentage points

![Calibration plot](/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/spencer-underdog-betting/output/fig_calibration.png)

That is a real but small gap. It says early underdogs won slightly more often
than the de-vigged closing prices implied, but not by enough to create a large,
stable profit margin after transaction costs.

League-level calibration gaps sharpen the picture:

- MLB: `+2.14` points
- NFL: `+2.69` points
- NBA: `+0.65` points
- NHL: `-2.15` points

Again, the same pattern appears: some positive early underdog drift in MLB and
NFL, little in NBA, and negative drift in NHL.

## A More Refined Version?

The most interesting refined variant is to focus on bigger underdogs in the
first 3 weeks. That bucket shows a pooled ROI of `+4.2%`.

That is the kind of result that can encourage overclaiming. The
problem is that the confidence interval is still wide, the NHL contribution is
strongly negative, and the result appears only after looking across several
reasonable strategy variants. Once you remember multiple-testing risk, this
looks more like a lead than a conclusion.

By contrast, modest underdogs in the first 3 weeks were clearly bad:

- `modest_dog_3w`: ROI `-3.4%`

So if there is any real edge here, it seems concentrated in the tail of the
underdog distribution rather than in generic "small dog" pricing.

## Kelly Sizing Does Not Rescue the Story

I also ran a simple out-of-sample half-Kelly exercise using leave-one-season-out
predicted win probabilities. If there were a meaningful exploitable edge, a
careful staking rule should improve the picture.

It barely does:

- half-Kelly, 2 weeks: `+0.1%`
- half-Kelly, 3 weeks: `+0.2%`

That is basically breakeven. It is another reason to think the true edge, if
it exists at all, is small.

## A Market-Learning Simulation

The historical data alone cannot tell us exactly why the strategy underperforms
or occasionally shines. So I added a simple market-learning simulation with:

- preseason priors about team strength
- slow or fast market updating
- a public premium on favorites

In that toy model, early underdogs can become profitable if the market learns
slowly and favorites are overpriced. That mechanism is plausible. But the
historical results are only directionally compatible with that mechanism; the
simulation is too stylized to claim a quantitative match.

So the simulation supports the logic of Spencer's theory, but not a strong
empirical claim that the edge was large in the observed data.

## Bottom Line

Spencer's idea was plausible, and the historical record suggests it was
directionally smarter than betting underdogs indiscriminately all year.

But the strongest empirical statement I think the data support is this:

> Early-season underdogs historically looked slightly less overpriced than
> underdogs in general, but not reliably profitable enough to count as a robust
> cross-league betting edge.

If I had to summarize the verdict:

- Did naive early underdogs make money historically? Probably not in a robust
  cross-league sense.
- Was the strategy better than generic underdog betting? Yes.
- Is there a weak hint of early-season underdog underpricing in MLB and maybe
  NFL? Also yes.
- Should a serious bettor trust this as a durable edge? Not on this evidence.

## Replication

The code-only replication package for this post lives here:

- [`../replication/`](../replication/)

It contains:

- download scripts for the public raw data
- the analysis pipeline
- the R robustness script
- dependency declarations
- a one-command rebuild script
