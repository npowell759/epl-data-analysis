library(rvest)
library(dplyr)

link = "https://www.transfermarkt.co.uk/premier-league/transfers/wettbewerb/GB1/plus/?saison_id=2019"
page = read_html(link)

team = page %>% html_nodes("h2 a") %>% html_text() %>% .[21:40]

expenditure = page %>% html_nodes(".transfer-einnahmen-ausgaben.redtext") %>% html_text() %>% 
  gsub("\n\t\tExpenditure: £", "", .) %>% gsub("m\t\t\t\t\t\t", "", .) %>% as.numeric(.)

income = page %>% html_nodes(".transfer-einnahmen-ausgaben.greentext") %>% html_text() %>%
  gsub("\n\t\t\t\t\t\tIncome: £", "", .) %>% gsub("m\t\t\t\t\t\t\t", "", .) %>%
  gsub("Th.\t\t\t\t\t\t\t", "", .) %>% as.numeric(.)

income[19] = income[19] / 1000

net_spend <- income - expenditure

largest_in <- page %>% html_nodes(".responsive-table:nth-child(2) tr:nth-child(1) .rechts a") %>% html_text() %>%
  gsub("£", "", .) %>% gsub("m", "", .) %>% as.numeric(.)

largest_out <- page %>% html_nodes(".responsive-table:nth-child(4) tr:nth-child(1) .rechts a") %>% html_text() %>%
  gsub("£", "", .) %>% gsub("m", "", .) %>% gsub("Loan fee:", "", .) %>% gsub("Th.", "", .) %>% as.numeric(.)

largest_out[c(18, 19)] = largest_out[c(18, 19)] / 1000

transferspending <- data.frame(team, expenditure, income, net_spend, largest_in, largest_out, stringsAsFactors = FALSE)

write.csv(transferspending, "transferdata.csv", fileEncoding="Windows-1252", row.names=FALSE)
