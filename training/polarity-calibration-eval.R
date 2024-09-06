# This script evaluates the effectiveness of the `polarity calibration` 
# fine-tuning stage. For details, see Supplementary Note 6

library(tidyverse)
library(arrow)

base_path = rstudioapi::getSourceEditorContext()$path
this_dir = dirname(base_path)

df = arrow::read_feather(
  file = file.path(this_dir, "polarity-calibration-eval.feather")
)
  
validation_summary_negatives = df %>% 
  dplyr::filter(true_polarity == -1) %>% 
  dplyr::group_by(model) %>% 
  dplyr::summarize(
    n = n(),
    correct = sum(is_valid),
    incorrect = sum(!is_valid)
  ) %>% 
  print()

validation_summary_negatives[2:3, 3:4] %>% 
  unlist() %>% 
  chisq.test() %>% 
  print()

validation_summary_positives = df %>% 
  dplyr::filter(true_polarity == 1) %>% 
  dplyr::group_by(model) %>% 
  dplyr::summarize(
    n = n(),
    correct = sum(is_valid),
    incorrect = sum(!is_valid)
  ) %>% 
  print()

validation_summary_positives[2:3, 3:4] %>% 
  unlist() %>% 
  chisq.test() %>% 
  print()