squad_stats <- fread("premierleague.csv", skip = 1)
transfer_stats <- fread("transferdata.csv")

merged_stats <- merge(transfer_stats, squad_stats, by = "team") %>%
  arrange(Rk)
