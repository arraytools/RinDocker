This framework here provides a way to repeat an analysis of a code written in R.

# File Structure
```
$ tree ~/RinDocker
├── 01_data
│   └── us-500.csv
├── 02_code
│   ├── install_packages.R
│   └── myScript.R
├── 03_output
│   ├── myplot.png
│   └── plot_data.csv
├── Dockerfile
├── Dockerfile_base
└── Readme.md
```

# Shell Commands:
```bash
docker build --network=host -t myname/base-r-tidyverse:3.5.2 -f Dockerfile_base .

docker build -t myname/myimage .
# If something is wrong or myScript.R is changed,
# we need to run the following two commands again
#  docker rmi myname/myimage
#  docker build -t myname/myimage .

docker run -it --rm \
  -v ~/RinDocker/01_data:/01_data \
  -v ~/RinDocker/03_output:/03_output \
   myname/myimage
```

# File

## Dockerfile

We assume the intermediate docker image containing necessary packages for our analysis.
```
FROM myname/base-r-tidyverse:3.5.2

## create directories
RUN mkdir -p /01_data
RUN mkdir -p /02_code
RUN mkdir -p /03_output

## copy files
COPY 02_code/myScript.R /02_code/myScript.R

## run the script
CMD Rscript /02_code/myScript.R
```

## myScript.R

* Put the input files in /01_data directory
* Save the output files in /02_output directory

# To Do:

* Change the owner of the output from away root
* Make the script independent of the Docker image
* Integrate packrat https://rstudio.github.io/packrat/

# References:

* https://www.statworx.com/de/blog/running-your-r-script-in-docker/
