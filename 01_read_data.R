library(tidyverse)
library(stringr)

orig_data = read_csv("candyhierarchy2017.csv") %>% 
  select(-X114)

mydata = orig_data %>% 
  select(-`Click Coordinates (x, y)`) %>% 
  gather(question, answer, -`Internal ID`) %>% 
  separate(question, into = c("question_n", "question"), sep = ":|\\|")


# questions list shows that only Q6 and Q12 needed "gathering"
questions_list = mydata %>% 
  count(question_n, question) %>% 
  select(-n)





