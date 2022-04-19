library("glue")
library("stringr")
csvs <- dir(pattern = "\\.csv$", recursive = TRUE, full.names = TRUE)
names(csvs) <- basename(dirname(csvs))
csvs <- rev(csvs)

answers <- lapply(csvs, read.csv, check.names = FALSE)


lapply(seq_along(answers), function(i) {
    date <- gsub("\\./", "", dirname(csvs[i]))

    entries <- do.call(c, lapply(seq_along(answers[[i]]), function(j) {
        if(colnames(answers[[i]])[j] == "Timestamp") return(NULL)

        x <- answers[[i]][[j]]
        question <- colnames(answers[[i]])[j]
        year <- names(csvs)[i]

        if(is.character(x)) {
            ## Remove any redacted text
            x <- gsub("<redact>.*<\\/redact>", "", x)
            x <- sample(x)
            if(all(str_count(x, "\\w+") == 1)) {
                ## Cases where there are single word answers
                x <- paste0('"', paste0(x, collapse = '", "'), '"')
                res <- glue('
```{r "plot_<j>_<year>", echo = FALSE, message = FALSE}
library("ggplot2")
library("dplyr")
data.frame(x = c(<x>)) %>%
    count(x) %>%
    ggplot(aes(x = x, y = n)) + geom_bar(stat = "identity") +
    theme_bw(base_size = 20) + xlab("") + ylab("count")
```

', .open = "<", .close = ">")

                data.frame(x = x) %>% count(x) %>%
                    mutate(percent = round(n / sum(n) * 100, 2)) %>%
                    ggplot(aes(x = x, y = percent)) + geom_bar(stat = "identity") +
                    theme_bw(base_size = 20) + xlab(question)

            } else {
                res <- paste(glue("* {x}"), collapse = "\n")
            }
        } else {
            info <- paste0("1:", gsub(".*\\(1:|\\)", "", question))

        x <- toString(x)
        res <- glue('
```{r "plot_<j>_<year>", echo = FALSE}
library("ggplot2")
ggplot(data.frame(x = c(<x>)), aes(x = x)) + geom_bar() + theme_bw(base_size = 20) + xlab("<info>") + scale_x_continuous(breaks = 1:10, limits = c(0, 10.9))
```

', .open = "<", .close = ">")

        }

        question_only <- gsub(" \\(1:.*", "", question)
        final <- glue("## {question_only}

{res}

")
        return(final)
    }))

    entries_combined <- paste(entries, collapse = "\n")
    chapter_rmd <- glue("# Survey {date}

{entries_combined}")
    writeLines(chapter_rmd, paste0(sprintf("%02d", i), "_survey_", date, ".Rmd"))
})
