FROM myname/base-r-tidyverse:3.5.2

## create directories
RUN mkdir -p /01_data
RUN mkdir -p /02_code
RUN mkdir -p /03_output

## copy files
COPY 02_code/myScript.R /02_code/myScript.R

## run the script
CMD Rscript /02_code/myScript.R
