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

# Instruction

1. Create a project directory (e.g. ~/RinDocker). Create 3 new subdirectories to 
store data, code and output files separately.
```bash
mkdir -p ~/RinDocker/{01_data,02_code,03_output}
```

2. Create an intermediate image containing most useful OS level tools and R packages
(myname/base-r-tidyverse:3.5.2). Customize the tools by editing '''Dockerfile_base''' file and 
R packages by editing '''02_code/install_packages.R''' file.
```bash
docker build --network=host -t myname/base-r-tidyverse:3.5.2 -f Dockerfile_base .
```

3. Create a project specific image (myname/project001) which will host R code for the analysis.
```bash
docker build -t myname/project001 -f Dockerfile .
# If something was wrong or myScript.R is changed,
# the above command should be executed again.
```

4. Run the R code in a disposable container
```bash
docker run -it --rm \
  -v ~/RinDocker/01_data:/01_data \
  -v ~/RinDocker/03_output:/03_output \
   myname/project001

# Change the owership of output files
sudo chown -R $USER:$USER 03_output/*
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

## myScript.R (under 02_code directory)

* Put the input files in /01_data directory
* Save the output files in /03_output directory

# To Do

* Make the R script independent of the Docker image
* Integrate packrat https://rstudio.github.io/packrat/

# References

* https://www.statworx.com/de/blog/running-your-r-script-in-docker/
