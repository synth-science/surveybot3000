library(tidyverse)
library(arrow)
library(jsonlite)

this_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(this_dir)

mapping = jsonlite::fromJSON(txt = "../validation_study/mapping.json")

df = mapping$dataset$instruments$scales %>% 
  sapply(unlist) %>% 
  bind_rows() %>% 
  dplyr::mutate(
    scale = mapping$dataset$instruments$scales %>%
      names()
  )  %>% 
  tidyr::pivot_longer(cols = -scale, values_to = "variable") %>% 
  dplyr::select(-name) %>% 
  dplyr::filter(!is.na(variable)) %>% 
  dplyr::left_join(
    y = mapping$dataset$instruments %>% 
      bind_rows() %>% 
      dplyr::select(name, items) %>% 
      tidyr::unnest(items), 
    by = "variable"
  ) %>% 
  dplyr::select(variable, name, item_text, scale) %>%
  dplyr::rename("instrument" = "name")

df_wide = df %>% 
  dplyr::group_by(variable, instrument, item_text) %>%
  dplyr::mutate(
    scale_number = row_number() - 1
  ) %>%
  dplyr::ungroup() %>%
  tidyr::pivot_wider(
    names_from = scale_number,
    names_prefix = "scale",
    values_from = scale
  )

df_wide %>% 
  arrow::write_feather("../validation_study/mapping.feather")
