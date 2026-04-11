# Did Betting Early-Season Underdogs Ever Actually Work?

Spencer's theory starts from a sensible market-learning idea: early in a
season, sportsbooks and bettors may still be leaning too hard on preseason
priors. If that is true, some teams priced as underdogs should really be closer
to even-money propositions, and underdog payouts can turn small probability
mistakes into meaningful returns.

I tested that idea using public closing moneyline archives for the NFL, NBA,
NHL, and MLB from `2011` through `2021`. The cleaned panel contains `53,453`
games across `44` league-seasons. The replication package for the analysis
lives in the repository at
[`explorations/spencer-underdog-betting/replication/`](https://github.com/jakerbrown/claude-code-my-workflow/tree/main/explorations/spencer-underdog-betting/replication).

## The short answer

Not really, at least not in a strong, cross-league sense.

The best naive pooled rule in the package is "bet every underdog in the first
3 calendar weeks." It still comes in slightly negative:

- ROI `-0.4%`
- `5,901` bets
- 95% bootstrap CI `[-4.0%, 3.4%]`

So the data do not support a robust claim that early underdogs reliably made
money after vig.

## The more interesting answer

Early underdogs still look **better than the obvious alternatives**.

Compared with the first-3-weeks underdog rule:

- all underdogs over the likely-regular-season proxy lost `1.8%`
- early favorites lost `4.1%`
- a random team in the same early window lost about `2.4%`
- randomizing underdog timing also looked worse than the actual early window

That pattern is consistent with a weak early-season informational effect. It is
not, by itself, diagnostic of that mechanism, and it is not large enough to
become a dependable positive betting edge once bookmaker hold and sampling
uncertainty are accounted for.

![ROI by window](/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/spencer-underdog-betting/output/fig_roi_by_window.png)

## League differences matter

The strategy is not evenly distributed across the four leagues.

- MLB: `+3.9%`
- NFL: `+1.8%`
- NBA: `-0.4%`
- NHL: `-8.2%`

The partial-pooling model shrinks those raw league estimates back toward a
slightly negative pooled mean, which is exactly what you would expect if the
league splits contain signal but also a lot of noise.

![Forest plot](/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/spencer-underdog-betting/output/fig_forest_plot.png)

The cleanest interpretation is:

- MLB shows the strongest positive hint.
- NFL is directionally positive but too noisy to lean on heavily.
- NBA is basically flat.
- NHL is clearly bad for this strategy.

## The key metric is calibration, not just ROI

Underdogs always pay more when they win, so raw ROI can confuse payout
asymmetry with actual mispricing. A better diagnostic is whether underdogs win
more often than the no-vig market price implies.

For pooled early 3-week underdogs:

- realized win rate: `40.45%`
- average no-vig implied win probability: `39.70%`
- calibration gap: `+0.75` percentage points

That is a favorable sign, but it is small.

![Calibration plot](/Users/jacobbrown/Documents/GitHub/claude-codex-my-workflow/explorations/spencer-underdog-betting/output/fig_calibration.png)

League-level calibration gaps tell the same story:

- MLB: `+2.14` points
- NFL: `+2.69` points
- NBA: `+0.65` points
- NHL: `-2.15` points

So the data look more like mild early underpricing in MLB and NFL than like a
broad market failure everywhere.

## Did a more refined version work better?

The most promising variant was focusing on bigger underdogs in the first 3
weeks:

- `big_dog_3w`: ROI `+4.2%`

But that result is still too noisy to treat as established fact. The interval
is wide, the NHL contribution is sharply negative, and the result emerges only
after looking across several reasonable variants. Once you worry about
multiple-testing, it becomes much more plausible that this is a fragile lead
than a genuine stable edge.

## Kelly sizing does not save it

I also ran a leave-one-season-out half-Kelly exercise using predicted win
probabilities from a simple logistic model. If the edge were large and stable,
careful sizing should help.

It barely changes the answer:

- half-Kelly, 2 weeks: `+0.1%`
- half-Kelly, 3 weeks: `+0.2%`

That is basically breakeven.

## What the simulation adds

The market-learning simulation says early underdogs **can** be profitable if:

- the market updates slowly from preseason beliefs
- favorites carry a public-bias premium

That mechanism is plausible, but the observed data are only directionally
compatible with it. The simulation supports the theory's logic more than it
supports a claim of large historical profits.

## Bottom line

Spencer's strategy was substantively plausible. In relative terms, it looks
better than generic underdog betting and better than early favorites. But the
evidence does not justify a strong historical claim that early-season
underdogs made money across the major U.S. leagues.

My best summary is:

- weak support for a small early informational effect
- strongest hints in MLB and maybe NFL
- no robust cross-league betting edge
- too much uncertainty to recommend belief in a durable profitable strategy
