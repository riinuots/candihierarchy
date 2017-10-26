# \#candyhierarchy media question
Riinu Ots  
26-Oct 2017  



I started wrangling the annual candy hierarchy survey data (http://www.scq.ubc.ca/so-much-candy-data-seriously/) but the last, not candy related, question really caught my eye:

```
Q12: MEDIA
When you see the below image of the 4 different websites, click the one that would you most likely check out (please be honest). Hat tip to Kahan et al. (see https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2816803)
```

So this is a script that plots the click coordinates on the different news sections:

```r
library(tidyverse)
library(stringr)
library(png)
library(grid)

click_coordinates = read_csv("candyhierarchy2017.csv") %>% 
  select(coordinates = `Click Coordinates (x, y)`) %>% 
  filter(!is.na(coordinates)) %>% 
  separate(coordinates, into = c("x", "y"), sep = ",") %>% 
  mutate(x = str_replace(x, "\\(", "") %>% as.numeric()) %>% 
  mutate(y = str_replace(y, "\\)", "") %>% as.numeric()) %>% 
  mutate(panel = case_when(x<=50 & y <= 50 ~ "bottom-left",
                           x<=50 & y > 50  ~ "top-left",
                           x>50  & y <= 50 ~ "bottom-right",
                           x>50  & y > 50  ~ "top-right"))

img <- readPNG("news_selection.png")
g <- rasterGrob(img, interpolate=TRUE)

image_ratio = 755/586

click_coordinates %>% 
  mutate(y_scaled = image_ratio*y) %>% 
  ggplot(aes(x, y_scaled, colour = panel)) + 
  #annotation_custom(g, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf) +
  annotation_custom(g, xmin=0, xmax=100, ymin=0, ymax=image_ratio*100) +
  geom_point(alpha = 0.5, shape = 4, stroke = 1) +
  # coord_cartesian should replace the scale_y and scale_x in this use, but its expand doesn't trim 2/4 sides
  #coord_cartesian(xlim = c(0, 100), ylim = c(0, image_ratio*100), expand = FALSE) +
  scale_y_continuous(limits = c(0, image_ratio*100), expand = c(0, 0)) +
  scale_x_continuous(limits = c(0, 100), expand = c(0, 0)) +
  coord_fixed() +
  theme_void() +
  theme(legend.position = "none")
```

![](02_markdown_files/figure-html/unnamed-chunk-1-1.png)<!-- -->


```r
click_coordinates %>% 
  ggplot(aes(x = panel, fill = panel)) + 
  geom_bar() +
  theme(legend.position = "none") + # why isn't legend.position = "none" working on this one?!?
  theme_bw()
```

![](02_markdown_files/figure-html/unnamed-chunk-2-1.png)<!-- -->


The ads:

![](news_selection.png)


