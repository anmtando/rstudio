# set cran repo so the user doesn't have to
options(repos=structure(c(CRAN='http://cran.rstudio.com/')))
# update installed pacakges
update.packages(checkBuilt = TRUE, ask = FALSE)
# make a list of additional packages to install
packages <- c('codetools', 'Rcpp', 'devtools', 'knitr', 'ggplot2', 'plyr', 'dplyr', 'XML', 'RCurl', 'readxl', 'tidyr')
# install that list
install.packages(packages)
# and some from github
devtools::install_git(c('https://github.com/rstudio/rmarkdown.git', 'https://github.com/hadley/reshape'))" 
message("All done installing additional packages")
# end
 