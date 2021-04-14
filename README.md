Team lcolladotor anonymous surveys
==================================

I followed the instructions by [Leslie Vosshall, PhD](https://twitter.com/leslievosshall) on [Twitter](https://twitter.com/leslievosshall/status/1371260850657460227?s=20) when adapting her survey to my team. I told my team that they should only think about the team when answering the questions and gave them about 2 or 3 weeks to respond. I then downloaded the responses after to a CSV file.

I manually edited the column names in the CSV file for the numerical questions by adding ` (1: something, 10: something else)` at the end of each column name. For example, `"How happy are you in the team? (1: unhappy, 10: bliss)"` became `"How happy are you in the team? (1: unhappy, 10: bliss)"`. In hindsight, I should have done that on the Google Form such that the CSV would automatically include this information. Plus, one of the 2021-03 respondents mentioned that the numbers changed meanings sometimes.

[`csv_to_Rmd.R`](csv_to_Rmd.R) uses [`glue`](https://cran.r-project.org/web/packages/glue/index.html) to create R Markdown files than are then rendered by [`bookdown`](https://cran.r-project.org/web/packages/bookdown/index.html) to create the HTML and PDF versions. I use a GitHub actions workflow modified from [`biocthis`](https://bioconductor.org/packages/biocthis) to update the HTML and PDF files automatically.
