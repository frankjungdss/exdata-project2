#!/usr/bin/R --verbose --quiet

#
# Get data
#

if (!file.exists("data/Source_Classification_Code.rds") || !file.exists("data/summarySCC_PM25.rds")) {
    if (!file.exists("data/NEI_data.zip")) {
        print("Downloading data ...")
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileUrl, destfile = "NEI_data.zip", method = "curl", quiet = TRUE)
    }
    unzip("data/NEI_data.zip", exdir="data", overwrite = TRUE)
}

#EOF
