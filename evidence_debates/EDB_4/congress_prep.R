# Evidence Debate 4 -- prep script
#
# Computes the real numbers this debate's evidence panels need, using the
# exact classification workflow from Lecture 14/15 (train/test split, a
# linear-probability-model classifier, sweep_thresholds()/compute_auc()).
#
# Run this once with the working directory set to this folder
# (evidence_debates/EDB_4/), then copy the printed numbers into the
# [FILL IN: ...] placeholders in index.html before deploying.

require(tidyverse)

sweep_thresholds <- function(probs, truth, thresholds = seq(0, 1, by = 0.02)) {
  out <- NULL
  for (t in thresholds) {
    pred_t <- ifelse(probs >= t, TRUE, FALSE)
    tp_t <- sum(pred_t == TRUE & truth == TRUE)
    fn_t <- sum(pred_t == FALSE & truth == TRUE)
    tn_t <- sum(pred_t == FALSE & truth == FALSE)
    fp_t <- sum(pred_t == TRUE & truth == FALSE)
    out <- bind_rows(out, tibble(
      threshold = t,
      sensitivity = tp_t / (tp_t + fn_t),
      specificity = tn_t / (tn_t + fp_t)
    ))
  }
  out
}

compute_auc <- function(roc_dat) {
  roc_sorted <- roc_dat %>%
    mutate(fpr = 1 - specificity) %>%
    drop_na(sensitivity, fpr) %>%
    arrange(fpr)
  sum(diff(roc_sorted$fpr) * (head(roc_sorted$sensitivity, -1) +
                                 tail(roc_sorted$sensitivity, -1)) / 2)
}

load_congress <- function(path) {
  read_csv(path, show_col_types = FALSE) %>%
    filter(chamber %in% c("House", "Senate")) %>%
    filter(party_code %in% c(100, 200)) %>%  # Democrats and Republicans only
    mutate(is_republican = party_code == 200) %>%
    select(bioname, chamber, is_republican, nominate_dim1, nominate_dim2) %>%
    drop_na()
}

# Fits isRepublican ~ dim1 + dim2 on a random half, evaluates accuracy (0.5
# cutoff) and AUC on the held-out half. Repeats 100 times and averages.
classify_party <- function(dat, n_reps = 100) {
  set.seed(123)
  results <- NULL
  for (i in 1:n_reps) {
    inds <- sample(1:nrow(dat), size = round(nrow(dat) / 2), replace = FALSE)
    train <- dat %>% slice(inds)
    test <- dat %>% slice(-inds)
    if (n_distinct(train$is_republican) < 2 || n_distinct(test$is_republican) < 2) next

    m <- lm(is_republican ~ nominate_dim1 + nominate_dim2, data = train)
    probs <- predict(m, newdata = test)
    pred_class <- ifelse(probs >= 0.5, TRUE, FALSE)
    acc <- mean(pred_class == test$is_republican, na.rm = TRUE)
    auc <- compute_auc(sweep_thresholds(probs, test$is_republican))

    results <- bind_rows(results, tibble(rep = i, accuracy = acc, auc = auc))
  }
  results %>% summarise(mean_accuracy = mean(accuracy, na.rm = TRUE),
                         mean_auc = mean(auc, na.rm = TRUE))
}

h97 <- load_congress("https://raw.githubusercontent.com/jbisbee1/DS1000_F2026/main/data/H097_members.csv")
h117 <- load_congress("https://raw.githubusercontent.com/jbisbee1/DS1000_F2026/main/data/H117_members.csv")

cat("=== 97th Congress (1981-1983), both chambers ===\n")
print(classify_party(h97))

cat("\n=== 117th Congress (2021-2023), both chambers ===\n")
print(classify_party(h117))

cat("\n=== 97th Congress, House only ===\n")
print(classify_party(h97 %>% filter(chamber == "House")))

cat("\n=== 97th Congress, Senate only ===\n")
print(classify_party(h97 %>% filter(chamber == "Senate")))

cat("\n=== 117th Congress, House only ===\n")
print(classify_party(h117 %>% filter(chamber == "House")))

cat("\n=== 117th Congress, Senate only ===\n")
print(classify_party(h117 %>% filter(chamber == "Senate")))

# Optional: save to CSV for easy copy/paste.
results_all <- bind_rows(
  classify_party(h97) %>% mutate(congress = "97th", chamber = "Both"),
  classify_party(h117) %>% mutate(congress = "117th", chamber = "Both"),
  classify_party(h97 %>% filter(chamber == "House")) %>% mutate(congress = "97th", chamber = "House"),
  classify_party(h97 %>% filter(chamber == "Senate")) %>% mutate(congress = "97th", chamber = "Senate"),
  classify_party(h117 %>% filter(chamber == "House")) %>% mutate(congress = "117th", chamber = "House"),
  classify_party(h117 %>% filter(chamber == "Senate")) %>% mutate(congress = "117th", chamber = "Senate")
)
write_csv(results_all, "assets/congress_classification_results.csv")
