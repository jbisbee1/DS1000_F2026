# Regenerates the two figures added for the contrary-evidence stage of EDB_3.
# Run with the working directory set to evidence_debates/EDB_3/.
library(ggplot2)

dir.create("assets", showWarnings = FALSE)

# ---- Evidence D: contrary evidence -------------------------------------
# Atkin, Schoar & Shinde (2023, NBER WP 31515): RCT, data-entry workers, India; ~ -18%
# Gibbs, Mengel & Siemroth (2023, JPE Micro): IT professionals during Covid, before/after; -8% to -19%
d <- data.frame(
  study = factor(c("Atkin, Schoar & Shinde\nRandomized, data entry, India",
                   "Gibbs, Mengel & Siemroth\nBefore/after, IT firm, Covid-19"),
                 levels = c("Gibbs, Mengel & Siemroth\nBefore/after, IT firm, Covid-19",
                            "Atkin, Schoar & Shinde\nRandomized, data entry, India")),
  low  = c(-18, -19),
  high = c(-18, -8)
)
d$mid <- (d$low + d$high) / 2

p <- ggplot(d, aes(y = study)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_segment(aes(x = low, xend = high, yend = study), linewidth = 3, colour = "#c0392b", lineend = "round") +
  geom_point(aes(x = low), size = 4, colour = "#c0392b") +
  geom_point(aes(x = high), size = 4, colour = "#c0392b") +
  annotate("text", x = -18, y = 2.3, label = "-18%", size = 5) +
  annotate("text", x = -13.5, y = 1.3, label = "-8% to -19%\n(range reported)", size = 4.5) +
  scale_x_continuous(limits = c(-25, 5), breaks = seq(-25, 5, 5)) +
  coord_cartesian(ylim = c(0.6, 2.6)) +
  labs(x = "Change in productivity from working at home (%)", y = NULL,
       title = "Two studies that found productivity losses",
       subtitle = "Compare with CTrip (2015): +13%") +
  theme_classic(base_size = 14)
ggsave("assets/evidence_D_contrary.png", p, width = 9, height = 5, dpi = 160)

# ---- Evidence E: four-study comparison table ---------------------------
tab <- data.frame(
  Study = c("CTrip 2015", "Trip.com 2024", "Atkin et al. 2023", "Gibbs et al. 2023"),
  Workers = c("Call center", "Graduate engineers,\nmarketing, finance", "Data entry (India)", "IT professionals"),
  Treatment = c("Full WFH, 9 months", "Hybrid, 2 days home", "Full WFH", "Covid-19 forced WFH"),
  Design = c("Randomized", "Randomized", "Randomized", "Before/after, no control"),
  Result = c("+13% performance", "No performance loss;\nattrition 7.2% to 4.8%", "-18% output", "-8% to -19% productivity;\nhours up ~30%")
)
long <- data.frame(
  row = rep(rev(seq_len(nrow(tab))), times = 5),
  col = rep(seq_len(5), each = nrow(tab)),
  txt = unlist(lapply(tab, as.character))
)
long$hdr <- FALSE
hdr <- data.frame(row = 5, col = 1:5, txt = names(tab), hdr = TRUE)
long <- rbind(long, hdr)
q <- ggplot(long, aes(col, row, label = txt, fontface = ifelse(hdr, "bold", "plain"))) +
  geom_text(size = 4, lineheight = 0.95) +
  geom_hline(yintercept = 4.5) +
  scale_x_continuous(limits = c(0.5, 5.5)) +
  scale_y_continuous(limits = c(0.5, 5.6)) +
  labs(title = "Four studies, different workers and treatments") +
  theme_void(base_size = 14) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))
ggsave("assets/evidence_E_comparison.png", q, width = 14, height = 5.5, dpi = 130, bg = "white")
