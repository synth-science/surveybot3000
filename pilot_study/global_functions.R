
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
