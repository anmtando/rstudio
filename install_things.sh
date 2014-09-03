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
sudo apt-get update  -y
# sudo apt-get upgrade  -y
sudo apt-get install -y
# sudo apt-get -f install -y
sudo apt-get install libcurl4-gnutls-dev -y
sudo apt-get install libcurl4-openssl-dev -y
sudo apt-get install libcurl4-nss-dev -y
sudo apt-get install libopenblas-base -y
sudo apt-get install libxml2-dev -y
sudo apt-get install make -y
sudo apt-get install gcc -y
sudo apt-get install git -y
sudo apt-get install pandoc -y
sudo apt-get install libjpeg62 -y
sudo apt-get install unzip -y
sudo apt-get install curl -y
sudo apt-get install littler -y
sudo apt-get install openjdk-7-* -y
sudo apt-get install gedit -y
sudo apt-get install jags -y
sudo apt-get install imagemagick -y
# sudo apt-get install mysql-server -y

# for Texlive with Lubuntu (making PDFs)
# these are BIG, not recommended if you're short on disk space!
# sudo add-apt-repository ppa:texlive-backports/ppa
# sudo apt-get update
# sudo apt-get install texlive-latex-base -y
# sudo apt-get install texlive-fonts-recommended -y
# sudo apt-get install texlive-latex-extra -y

# a few handy FOSS items for drawing, graphics and maps
# sudo apt-get install inkscape -y
# sudo apt-get install gimp -y
# sudo apt-add-repository ppa:ubuntugis/ppa
# sudo apt-get update
# sudo apt-get install qgis -y

# also a few things in case we use python 
# from http://faculty.washington.edu/rjl/uwhpsc-coursera/vm.html
#sudo apt-get install liblzma-dev -y
#sudo apt-get install ipython -y
#sudo apt-get install ipython-notebook -y 
#sudo apt-get install python-pandas -y
#sudo apt-get install python-numpy -y
#sudo apt-get install python-scipy -y
#sudo apt-get install python-matplotlib -y
#sudo apt-get install python-dev -y
#sudo apt-get install python-sphinx -y
#sudo apt-get install gfortran -y
#sudo apt-get install openmpi-bin -y
#sudo apt-get install liblapack-dev -y
#sudo apt-get install thunar -y
#sudo apt-get install gitk -y
#sudo apt-get install docdiff -y
#sudo apt-get install python-setuptools -y

echo "edit the sources file to prepare to install R"
# see http://cran.r-project.org/bin/linux/ubuntu/README
sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list' # if Lubuntu

echo "get keys to install R"
# sudo apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480 # if Debian
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 # if Lubuntu
 
echo "install R and some helpers"
sudo apt-get update
sudo apt-get install r-base  -y
sudo apt-get install r-base-dev -y
sudo apt-get install r-cran-xml  -y
sudo apt-get install r-cran-rjava -y
sudo R CMD javareconf # for rJava

echo "install RStudio from the web"
# use daily build to get rmarkdown & latest goodies
# do update the URL from time to time to make sure it's fresh
URL='https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-0.98.1028-amd64.deb'; FILE=`mktemp`; sudo wget "$URL" -qO $FILE && sudo dpkg -i $FILE; rm $FILE
 
echo "start R and install commonly used packages"
# http://stackoverflow.com/q/4090169/1036500
# Make an R script file to use in a moment...
LOADSTUFF="options(repos=structure(c(CRAN='http://cran.rstudio.com/')))
update.packages(checkBuilt = TRUE, ask = FALSE)
packages <- c('codetools', 'Rcpp', 'devtools', 'knitr', 'ggplot2', 'data.table', 'plyr', 'dplyr', 'XML', 'RCurl') 
# just some of my most often used ones
install.packages(packages)
# and some from github
devtools::install_git(c('https://github.com/rstudio/rmarkdown.git', 'https://github.com/rstudio/packrat', 'https://github.com/hadley/reshape'))" # close the R script

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
# clean up by deleting the temp file
rm /tmp/loadstuff.sh 
 
# done.
echo "all done"
echo "type 'sudo rstudio' in the terminal to start RStudio"