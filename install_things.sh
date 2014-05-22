#!/bin/bash

# Marwick Lab Computational Environment Setup
 
# this script can be run from the terminal with the next line (minus the #)
# bash install_things.sh

# you will need to enter your password at a few points, so keep an eye on it while it runs.

# in case we need to step through:
# set -x
# trap read debug
 
## Need this for Debian but not Lubuntu 
## Make self su: http://stackoverflow.com/a/15067345/1036500
# install sudo to ensure we get access to everything
# su -c "aptitude install sudo"
# su root
## Here we assume your username is ben ... do edit this line if you chose a different username!
# sudo adduser ben sudo
 
echo "install a few dependancies for our workflow"
sudo apt-get update && sudo apt-get upgrade && sudo apt-get install
sudo apt-get -f install -y
sudo apt-get install libcurl4-gnutls-dev libopenblas-base libxml2-dev make gcc git-core texlive biblatex pandoc libjpeg62 unzip curl littler openjdk-7-*

# also a few things in case we use python 
# from http://faculty.washington.edu/rjl/uwhpsc-coursera/vm.html
sudo apt-get install jockey-gtk xdm ipython ipython-notebook python-pandas python-numpy python-scipy python-matplotlib python-dev python-sphinx gfortran openmpi-bin liblapack-dev thunar xfce4-terminal gedit gitk docdiff imagemagick python-setuptools -y

echo "edit the sources file to prepare to install R"
sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/debian wheezy-cran3/" >> /etc/apt/sources.list'
 
echo "get keys to install R"
sudo apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480
 
echo "install R and some helpers"
sudo apt-get install r-base r-base-dev r-cran-xml  r-cran-rjava -y
sudo R CMD javareconf # for rJava
 
echo "install RStudio from the web"
# use daily build to get rmarkdown & latest goodies
# do update the URL from time to time to make sure it's fresh
sudo apt-get update && sudo apt-get install 
URL='https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-0.98.797-amd64.deb'; FILE=`mktemp`; sudo wget "$URL" -qO $FILE && sudo dpkg -i $FILE; rm $FILE
 
echo "start R and install commonly used packages"
# http://stackoverflow.com/q/4090169/1036500
# Make an R script file to use in a moment...
LOADSTUFF="options(repos=structure(c(CRAN='http://cran.rstudio.com/')))
update.packages(checkBuilt = TRUE, ask = FALSE)
# check to see if packages are installed. 
# Install them if they are not, then load them into the R session.
 ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% names(installed.packages()[,3]))]
    if (length(new.pkg)) 
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}
 
# usage
packages <- c('codetools', 'Rcpp', 'devtools', 'knitr', 'ggplot2', 'data.table', 'dplyr', 'plyr', 'reshape2', 'XML', 'RCurl') 
# just some of my most often used ones
ipak(packages)"

# put that R code into an R script file
FILENAME1="loadstuff.r"
sudo echo "$LOADSTUFF" > /tmp/$FILENAME1

# Make a shell file that contains instructions in bash for running that R script file
# from the command line. There may be a simpler way, but nothing I tried worked.
NEWBASH='#!/usr/bin/env 
sudo Rscript /tmp/loadstuff.r'
FILENAME2="loadstuff.sh"

# put that bash code into a shell script file
sudo echo "$NEWBASH" > /tmp/$FILENAME2

# run the bash file to exectute the R code and install the packages
sh /tmp/loadstuff.sh
 
# done.
echo "all done"
echo "type 'sudo rstudio' in the terminal to start RStudio"