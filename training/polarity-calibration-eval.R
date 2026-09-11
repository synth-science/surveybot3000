# This script evaluates the effectiveness of the `polarity calibration` 
# fine-tuning stage. For details, see Supplementary Note 6

library(tidyverse)
library(arrow)

base_path = rstudioapi::getSourceEditorContext()$path
this_dir = dirname(base_path)

df = arrow::read_feather(
  file = file.path(this_dir, "polarity-calibration-eval.feather")
)

compare_model_accuracy = function(df_polarity) {
  paired_validity = df_polarity %>%
    dplyr::filter(model %in% c("A", "B")) %>%
    dplyr::select(
      genre,
      sentence_a,
      sentence_b,
      true_polarity,
      model,
      is_valid
    ) %>%
    tidyr::pivot_wider(
      names_from = model,
      values_from = is_valid
    )
  
  paired_table = matrix(
    c(
      sum(!paired_validity$A & !paired_validity$B),
      sum(paired_validity$A & !paired_validity$B),
      sum(!paired_validity$A & paired_validity$B),
      sum(paired_validity$A & paired_validity$B)
    ),
    nrow = 2,
    dimnames = list(
      "Model A" = c("incorrect", "correct"),
      "Model B" = c("incorrect", "correct")
    )
  )
  
  print(paired_table)
  print(stats::mcnemar.test(paired_table))
  
  discordant = paired_table["incorrect", "correct"] +
    paired_table["correct", "incorrect"]
  if (discordant <= 25) {
    print(stats::binom.test(
      paired_table["incorrect", "correct"],
      discordant,
      p = 0.5
    ))
  }
}
  
validation_summary_negatives = df %>% 
  dplyr::filter(true_polarity == -1) %>% 
  dplyr::group_by(model) %>% 
  dplyr::summarize(
    n = n(),
    correct = sum(is_valid),
    incorrect = sum(!is_valid)
  ) %>% 
  print()

df %>%
  dplyr::filter(true_polarity == -1) %>%
  compare_model_accuracy()

validation_summary_positives = df %>% 
  dplyr::filter(true_polarity == 1) %>% 
  dplyr::group_by(model) %>% 
  dplyr::summarize(
    n = n(),
    correct = sum(is_valid),
    incorrect = sum(!is_valid)
  ) %>% 
  print()

df %>%
  dplyr::filter(true_polarity == 1) %>%
  compare_model_accuracy()
