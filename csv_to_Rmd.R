library("glue")
csvs <- dir(pattern = "\\.csv$", recursive = TRUE, full.names = TRUE)

answers <- lapply(csvs, read.csv, check.names = FALSE)


lapply(seq_along(answers), function(i) {
    date <- gsub("\\./", "", dirname(csvs[i]))

    entries <- do.call(c, lapply(seq_along(answers[[i]]), function(j) {
        if(colnames(answers[[i]])[j] == "Timestamp") return(NULL)

        x <- answers[[i]][[j]]
        question <- colnames(answers[[i]])[j]

        if(is.character(x)) {
            ## Remove any redacted text
            x <- gsub("<redact>.*<\\/redact>", "", x)
            x <- sample(x)
            res <- paste(glue("* {x}"), collapse = "\n")
        } else {
            info <- paste0("1:", gsub(".*\\(1:|\\)", "", question))

        x <- toString(x)
        res <- glue('
```{r "plot_<j>", echo = FALSE}
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
    writeLines(chapter_rmd, paste0("survey_", date, ".Rmd"))
})
