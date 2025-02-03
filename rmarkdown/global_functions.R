
find_reverse_items_by_first_item <- function(rs, first_item_key) {
  # negatively correlated with first item
  items <- rs[-1, 1]
  if(first_item_key == 1) {
    reversed <- which(items < 0) + 1
  } else {
    reversed <- c(1, which(items > 0)  + 1)
  }
  reverse_keyed_items <- colnames(rs)[reversed]
  reverse_keyed_items
}

randomly_choose_items_for_reversion <- function(items) {
  rev <- floor(length(items)/2)
  sample(items, size = rev)
}

reverse_items <- function(rs, reverse_keyed_items) {
  # Reverse the correlations for the reverse-keyed items
  for (item in reverse_keyed_items) {
    # Get the index of the reverse-keyed item
    item_index <- which(rownames(rs) == item)

    # Reverse the correlations
    rs[item_index, ] <- rs[item_index, ] * -1
    rs[, item_index] <- rs[, item_index] * -1

    # Since the diagonal is the correlation of the item with itself, set it back to 1
    rs[item_index, item_index] <- 1
  }
  rs
}
longcor <- function(df) {
  df %>%
    cor(use = "p") %>%
    reshape2::melt() %>%
    dplyr::left_join(
      Hmisc::rcorr(as.matrix(df))$n %>%
        reshape2::melt() %>%
        dplyr::rename(pairwise_n = value),
      by = c("Var1", "Var2")) %>%
      dplyr::rename(
        empirical_r = "value",
        variable_1 = Var1,
        variable_2 = Var2
      ) %>%
      dplyr::mutate(empirical_r_se = (1 - empirical_r^2)/sqrt(pairwise_n - 3))
}

join_pairwise_correlation = function(df_human, df_machine) {
  item_pairs = combn(x = names(df_human), m = 2) %>%
    t() %>%
    as.data.frame()
  colnames(item_pairs) <- c("variable_1", "variable_2")

  df_  =
    item_pairs %>%
    left_join(
      df_human %>%
        cor(use = "p") %>%
        reshape2::melt() %>%
        dplyr::left_join(
          Hmisc::rcorr(as.matrix(df_human))$n %>%
            reshape2::melt() %>%
            dplyr::rename(pairwise_n = value),
          by = c("Var1", "Var2")
        ) %>%
        dplyr::left_join(
          y = df_machine %>%
            cor(use = "p") %>%
            reshape2::melt(),
          by = c("Var1", "Var2")
        ) %>%
        dplyr::rename(
          empirical_r = "value.x",
          synthetic_r = "value.y",
          variable_1 = Var1,
          variable_2 = Var2
        ) %>%
        dplyr::filter(variable_1 != variable_2),
      by = c("variable_1", "variable_2"))

  df_ <- df_ %>%
    dplyr::mutate(empirical_r_se = (1 - empirical_r^2)/sqrt(pairwise_n - 3))
  return(df_)
}


predict_manifest_scores = function(human_data, machine_data, mapping_data, scale_data) {
  human_data <- human_data %>%
    haven::zap_labels()
  human_cor = human_data %>%
    cor(use = "p")

  machine_cor = machine_data %>%
    cor(use = "p")

  mapping_data <- mapping_data %>%
    rename(scale_0 = scale0,
           scale_1 = scale1)
  scale_data <- scale_data %>% select(-keyed)
  items_by_scale <- bind_rows(
    scale_data %>% filter(scale_1 == "") %>% left_join(mapping_data %>% select(-scale_1), by = c("instrument", "scale_0")),
    scale_data %>% filter(scale_1 != "") %>% left_join(mapping_data, by = c("instrument", "scale_0", "scale_1"))
  )

  scale_data = items_by_scale %>%
    dplyr::group_by(scale) %>%
    dplyr::summarize(
      items = list(variable),
      reverse_keyed_items = list(variable[keyed == -1])
    )


  scale_pairs = combn(x = scale_data$scale, m = 2) %>%
    t() %>%
    as_tibble()

  # no pairs between subscales and their parents
  scale_pairs <- scale_pairs %>%
    filter(! str_detect(V1, fixed(V2))) %>%
    filter(! str_detect(V2, fixed(V1))) %>%
    as.matrix()

  manifest_scores = tibble()

  calculate_row_means = function(data_, scale_data_) {
    data_ %>%
      dplyr::select(
        scale_data_$items %>%
          unlist() %>%
          dplyr::all_of()
      ) %>%
      dplyr::mutate_at(
        .vars = scale_data_$reverse_keyed_items %>%
          unlist(),
        .funs = function(x) max(., na.rm = TRUE) + 1 - x
      ) %>%
      rowMeans(na.rm = TRUE)
  }

  for (i in seq_len(nrow(scale_pairs))) {
    scale_a = scale_pairs[i, 1]
    scale_b = scale_pairs[i, 2]

    scale_data_a = scale_data %>%
      dplyr::filter(scale == scale_a)

    scale_data_b = scale_data %>%
      dplyr::filter(scale == scale_b)

    human_a = calculate_row_means(human_data, scale_data_a)
    human_b = calculate_row_means(human_data, scale_data_b)
    machine_a = calculate_row_means(machine_data, scale_data_a)
    machine_b = calculate_row_means(machine_data, scale_data_b)

    human_cor <- broom::tidy(cor.test(human_a, human_b))
    manifest_scores = manifest_scores %>%
      dplyr::bind_rows(
        tibble(
          scale_a = scale_a,
          scale_b = scale_b,
          empirical_r = human_cor$estimate,
          pairwise_n = human_cor$parameter + 2,
          empirical_r_se = (1 - empirical_r^2)/sqrt(pairwise_n - 3),
          synthetic_r = cor(machine_a, machine_b, use = "p")
        )
      )
  }
  return(manifest_scores)
}

