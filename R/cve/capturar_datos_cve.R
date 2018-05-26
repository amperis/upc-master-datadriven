# capturar_datos_cve
#
# Info:
#    https://github.com/hrbrmstr/shodan

#--- carga de librerias
library(devtools)
library(xtable)
library(pupcmasterdatadriven)

clearvariables()

URL <- "https://cve.mitre.org/data/downloads/allitems.csv"
download.file(URL, destfile = "./FUENTESDATOS/allcve.csv", method="curl")

entradas<-read.csv(file="./FUENTESDATOS/allcve.csv", head=FALSE, sep=",", skip=10)
#head(entradas, n = 15)
