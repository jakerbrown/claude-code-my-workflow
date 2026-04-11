# scripts directory guidance

This directory is for reproducible, non-experimental project code.

## Standards

- Use relative paths from the repository root.
- Load packages near the top of the script.
- Use `set.seed()` once near the top for stochastic code.
- Save heavy intermediate outputs in durable formats such as RDS when useful to
  downstream rendering.
- Keep functions small, named, and documented.
- Prefer code that runs cleanly from a fresh clone via `Rscript`.

## Workflow

- If work is exploratory or uncertain, start in `explorations/` instead.
- For production scripts, verify by actually running the script or the relevant
  entry point.
- Document expected outputs and where they land.
- Use `r-reviewer` when the task is important enough to justify a dedicated code
  review.
