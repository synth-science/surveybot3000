library(tidyverse)
library(arrow)
library(jsonlite)

this_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(this_dir)

mapping = jsonlite::fromJSON(txt = "../validation_study/mapping.json")

df = mapping$instruments$scales %>% 
	dplyr::bind_rows() %>% 
	dplyr::select(scaleName, lowerItemIds, upperItemIds) %>% 
	tidyr::pivot_longer(cols = c("lowerItemIds", "upperItemIds")) %>% 
	dplyr::filter(lengths(value) > 0) %>% 
	tidyr::unnest(value) %>% 
	dplyr::select(-name) %>% 
  dplyr::left_join(
    y = mapping$instruments %>%
      bind_rows() %>%
      dplyr::select(instrumentName, items) %>%
      tidyr::unnest(items),
    by = c(value = "itemId")
  ) %>% 
	dplyr::select(value, instrumentName, itemStemText, scaleName) %>% 
	dplyr::rename(
		"variable" = "value", 
		"instrument" = "instrumentName", 
		"item_text" = "itemStemText",
		"scale" = "scaleName",
	)

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
