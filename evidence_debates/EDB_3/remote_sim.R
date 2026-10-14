# Simulates the two datasets behind EDB_3 (Meridian Services, a fictional firm),
# bootstraps every estimate students see, and writes figures + assets/edb3_results.js.
# Run with the working directory set to evidence_debates/EDB_3/.
library(ggplot2)
library(jsonlite)
dir.create("assets", showWarnings = FALSE)

# ---- Data-generating process (known truth) ------------------------------
jobs      <- c("Call center", "Data entry", "Analyst")
job_share <- c(0.50, 0.25, 0.25)
eff_min   <- c(5, -2, 3)     # % change in minutes worked per shift from WFH
eff_pm    <- c(2, -2, 1)     # % change in output per minute from WFH
eff_out   <- ((1 + eff_min/100) * (1 + eff_pm/100) - 1) * 100
TRUE_ATE  <- sum(job_share * eff_out)   # true average effect on output per shift

draw_outcomes <- function(job, wfh, prior_z = 0) {
  j <- match(job, jobs)
  minutes <- 100 + eff_min[j] * wfh + rnorm(length(job), 0, 8)
  permin  <- 100 + eff_pm[j]  * wfh + 8 * prior_z + rnorm(length(job), 0, 10)
  data.frame(minutes = minutes, per_minute = permin, output = minutes * permin / 100)
}

boot_diff <- function(d, y, g = "wfh", B = 1000) {
  replicate(B, {
    s <- d[sample(nrow(d), replace = TRUE), ]
    mean(s[[y]][s[[g]] == 1]) - mean(s[[y]][s[[g]] == 0])
  })
}
summ <- function(x) list(est = mean(x), lo = unname(quantile(x, .025)), hi = unname(quantile(x, .975)),
                         conf = mean(x > 0) * 100)

# ---- Dataset 1: observational firm records (employees chose WFH) -------
set.seed(1000)
N <- 1200
obs <- data.frame(id = 1:N,
                  job = sample(jobs, N, replace = TRUE, prob = job_share))
obs$prior_z <- rnorm(N)
obs$prior_pctile <- pmin(99, pmax(1, round(pnorm(obs$prior_z) * 100)))
obs$wfh <- rbinom(N, 1, plogis(-0.6 + 1.0 * obs$prior_z))
obs <- cbind(obs, draw_outcomes(obs$job, obs$wfh, obs$prior_z))
obs$quintile <- cut(obs$prior_pctile, c(0, 20, 40, 60, 80, 100), labels = paste0("Q", 1:5))

fair_est <- function(d) {   # within-quintile differences, weighted by quintile size
  w <- tapply(rep(1, nrow(d)), d$quintile, sum)
  dif <- sapply(levels(d$quintile), function(q) {
    s <- d[d$quintile == q, ]
    mean(s$output[s$wfh == 1]) - mean(s$output[s$wfh == 0])
  })
  sum(dif * w[names(dif)]) / sum(w)
}

# ---- Dataset 2: randomized experiment among volunteers ------------------
# Search for a seed whose realized estimates teach cleanly (a simulation, not a cherry-picked study).
ok <- function(e) {
  f <- function(y, g) { m <- lm(reformulate(g, y), e); confint(m)[2, ] }
  o <- f("output", "wfh"); mn <- f("minutes", "wfh"); pm <- f("per_minute", "wfh")
  de <- confint(lm(output ~ wfh, e[e$job == "Data entry", ]))[2, ]
  cc <- confint(lm(output ~ wfh, e[e$job == "Call center", ]))[2, ]
  o[1] > 0.5 && o[2] < 7 && mn[1] > 0.3 && pm[1] < 0 && pm[2] > 0 && de[1] < 0 && de[2] > 0 && cc[1] > 0
}
for (sd in 1:500) {
  set.seed(sd)
  n <- 300
  ex <- data.frame(id = 1:n, job = rep(jobs, times = n * job_share), wfh = rep(0:1, length.out = n))
  ex$wfh <- ave(ex$wfh, ex$job, FUN = function(x) sample(x))
  ex$prior_z <- rnorm(n)
  ex <- cbind(ex, draw_outcomes(ex$job, ex$wfh, ex$prior_z))
  if (ok(ex)) break
}
cat("experiment seed:", sd, "\n")

# ---- Bootstraps ----------------------------------------------------------
set.seed(2026)
b_naive <- boot_diff(obs, "output")
b_fair  <- replicate(1000, fair_est(obs[sample(N, replace = TRUE), ]))
b_exp   <- boot_diff(ex, "output")
b_min   <- boot_diff(ex, "minutes")
b_pm    <- boot_diff(ex, "per_minute")
b_job   <- lapply(jobs, function(j) boot_diff(ex[ex$job == j, ], "output"))
names(b_job) <- jobs

grp <- function(d, y) sapply(0:1, function(w) c(n = sum(d$wfh == w), mean = mean(d[[y]][d$wfh == w]), sd = sd(d[[y]][d$wfh == w])))
g1 <- grp(obs, "output")
share_q <- tapply(obs$wfh, obs$quintile, mean) * 100
rd <- function(l) lapply(l, function(v) if (is.numeric(v)) round(v, 1) else v)

RES <- list(
  true_ate = round(TRUE_ATE, 2),
  n_obs = N, n_exp = n,
  obs_groups = list(office = rd(as.list(g1[, 1])), wfh = rd(as.list(g1[, 2]))),
  naive = rd(summ(b_naive)), fair = rd(summ(b_fair)),
  share_q = round(share_q),
  exp = rd(summ(b_exp)), minutes = rd(summ(b_min)), per_minute = rd(summ(b_pm)),
  jobs = lapply(b_job, function(b) rd(summ(b))),
  jobs_n = as.list(table(ex$job))
)
writeLines(paste0("const RES = ", toJSON(RES, auto_unbox = TRUE, digits = 4), ";"), "assets/edb3_results.js")
write.csv(obs[, c("id", "job", "prior_pctile", "wfh", "output")], "assets/edb3_firm_records.csv", row.names = FALSE)
write.csv(ex[, c("id", "job", "wfh", "minutes", "per_minute", "output")], "assets/edb3_experiment.csv", row.names = FALSE)
print(RES)

# ---- Figures ------------------------------------------------------------
gold <- "#cfae70"; dark <- "#333333"
bootplot <- function(b, title, xlab, file, h = 4) {
  s <- summ(b)
  p <- ggplot(data.frame(b = b), aes(b)) +
    geom_histogram(bins = 40, fill = gold, colour = "white") +
    geom_vline(xintercept = 0, linetype = "dashed") +
    labs(title = title, x = xlab, y = "Number of resamples (of 1,000)") +
    theme_classic(base_size = 14)
  ggsave(file, p, width = 8, height = h, dpi = 150, bg = "white")
}
bootplot(b_naive, "Stage 1: raw gap, WFH minus office", "Difference in mean output index (WFH - office)", "assets/sim1_boot_naive.png")
bootplot(b_fair,  "Stage 2: gap within prior-performance quintiles", "Weighted difference in mean output index", "assets/sim2_boot_fair.png")
bootplot(b_exp,   "Stage 3: randomized experiment", "Difference in mean output index (WFH - office)", "assets/sim3_boot_exp.png")

# Stage 1 distribution
p1 <- ggplot(obs, aes(factor(wfh, labels = c("Office", "WFH (chose it)")), output)) +
  geom_boxplot(fill = gold, outlier.alpha = .3) +
  labs(x = NULL, y = "Output per shift (office average of 100)", title = "Output per shift by work arrangement") +
  theme_classic(base_size = 14)
ggsave("assets/sim1_distribution.png", p1, width = 7, height = 4.5, dpi = 150, bg = "white")

# Stage 2 selection
p2 <- ggplot(data.frame(q = names(share_q), s = as.numeric(share_q)), aes(q, s)) +
  geom_col(fill = gold) + geom_text(aes(label = paste0(round(s), "%")), vjust = -.4, size = 5) +
  scale_y_continuous(limits = c(0, 100)) +
  labs(x = "Prior-year performance quintile (Q1 = lowest, Q5 = highest)", y = "% who chose WFH",
       title = "Who chose to work from home?") + theme_classic(base_size = 14)
ggsave("assets/sim2_selection.png", p2, width = 7.5, height = 4.5, dpi = 150, bg = "white")

# Stage 4 outcomes
o <- do.call(rbind, lapply(list(list("Minutes worked per shift", b_min), list("Output per minute", b_pm),
                                list("Output per shift", b_exp)), function(z) {
  s <- summ(z[[2]]); data.frame(outcome = z[[1]], est = s$est, lo = s$lo, hi = s$hi)
}))
o$outcome <- factor(o$outcome, levels = rev(o$outcome))
p4 <- ggplot(o, aes(est, outcome)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = .15, linewidth = 1.2, colour = dark) +
  geom_point(size = 4, colour = "#c0392b") +
  labs(x = "Effect of WFH (index points; office = 100). Bars: middle 95% of bootstrap resamples", y = NULL,
       title = "Three ways to measure 'productivity' in the same experiment") + theme_classic(base_size = 13)
ggsave("assets/sim4_outcomes.png", p4, width = 9, height = 4, dpi = 150, bg = "white")

# Stage 5 subgroups
sj <- do.call(rbind, lapply(jobs, function(j) { s <- summ(b_job[[j]]); data.frame(job = j, est = s$est, lo = s$lo, hi = s$hi) }))
sj <- rbind(sj, data.frame(job = "All workers (pooled)", est = RES$exp$est, lo = RES$exp$lo, hi = RES$exp$hi))
sj$job <- factor(sj$job, levels = rev(sj$job))
p5 <- ggplot(sj, aes(est, job)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = .15, linewidth = 1.2, colour = dark) +
  geom_point(size = 4, colour = "#c0392b") +
  labs(x = "Effect on output per shift (index points). Bars: middle 95% of bootstrap resamples", y = NULL,
       title = "The experiment, job type by job type") + theme_classic(base_size = 13)
ggsave("assets/sim5_jobs.png", p5, width = 9, height = 4, dpi = 150, bg = "white")

# ---- Embedded copy of the CSVs so the in-page R panel does not depend on fetch() ----
csv_txt <- function(f) paste(readLines(f), collapse = "\n")
writeLines(paste0("const EDB3_CSV = ",
                  toJSON(list(firm = csv_txt("assets/edb3_firm_records.csv"),
                              experiment = csv_txt("assets/edb3_experiment.csv")), auto_unbox = TRUE), ";"),
           "assets/edb3_data.js")
