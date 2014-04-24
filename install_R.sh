#!/bin/bash

# this script can be run from the terminal with bash install_R.sh
# step through
set -x
trap read debug

# Make self su: http://stackoverflow.com/a/15067345/1036500
# install sudo
aptitude install sudo
# su root
adduser ben sudo

echo "install a few dependancies for our workflow"
sudo apt-get update && sudo apt-get install
sudo apt-get install libcurl4-gnutls-dev libopenblas-base libxml2-dev make gcc git-core texlive biblatex pandoc libjpeg62 unzip curl

echo "edit the sources file to prepare to install R"
sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/debian wheezy-cran3/" >> /etc/apt/sources.list'

echo "get keys to install R"
sudo apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480

echo "install R and some helpers"
sudo apt-get install r-base r-base-dev r-cran-xml 

echo "install RStudio from the web"
# use daily build to get rmarkdown & latest goodies
sudo apt-get update && sudo apt-get install 
URL='https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-0.98.797-amd64.deb'; FILE=`mktemp`; sudo wget "$URL" -qO $FILE && sudo dpkg -i $FILE; rm $FILE

echo "all done"
echo "type 'sudo rstudio' in the terminal to start RStudio"