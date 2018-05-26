# calculovuls
#
# Programa para el calculo de vulveravilidades industriales a partir de las fuentes de datos de dispositivos industriales y de 
# dispositivos encontrados en Shodan
#
# Requisitos de librerias instaladas:
# Info:


#--- carga de librerias
library(devtools)
library(xtable)
library(shodan)
library(pupcmasterdatadriven)
library(RCurl)

clearvariables()

#--- leyendo CSV de dispositivos industriales
dispositivos_industriales<-read.csv(text=getURL("https://raw.githubusercontent.com/amperis/upc-master-datadriven/master/R/SHODAN/FUENTESDATOS/dispositivos_industriales.csv"), head=TRUE, sep=";", stringsAsFactors = FALSE)

#--- leyendo CSV de dispositivos industriales en Shodan
dispositivos_shodan<-read.csv(text=getURL("https://raw.githubusercontent.com/amperis/upc-master-datadriven/master/R/SHODAN/FUENTESDATOS/resultado_busqueda_shodan.csv.copia.csv"), head=TRUE, sep=";", stringsAsFactors = FALSE)

#--- leyendo arhivos de CVEs
download.file(url = "https://github.com/r-net-tools/security.datasets/raw/master/net.security/sysdata.rda", destfile = sysdatarda <- tempfile())
load(sysdatarda)
cves <- netsec.data$datasets$cves


#--- buscamos las vulnerabilidades industriales que tienen los dispostivos industriales de data frame "dispostivos_industriales"
affects<-dplyr::select(cves,"affects")
result<-data.frame()
for (i in 1:nrow(dispositivos_industriales)) {
   buscar_fabricante<-as.character(dispositivos_industriales[i,"fabricante"])
   buscar_producto<-as.character(dispositivos_industriales[i,"producto"])
   buscar_cadena_busqueda<-as.character(dispositivos_industriales[i,"cadena_busqueda"])
   
   print(paste(buscar_fabricante, buscar_producto,sep="|"))
   vuls<-0
   if (buscar_producto!="Generic") {
      filteraffects<-dplyr::filter(affects, grepl(gsub(" ","_",buscar_producto),affects, ignore.case = TRUE))
      vuls<-nrow(filteraffects)
   } else {
     if (buscar_fabricante!="Generic") {
        filteraffects<-dplyr::filter(affects, grepl(gsub(" ","_",buscar_fabricante),affects, ignore.case = TRUE))
        vuls<-nrow(filteraffects)
     }
   }
   print(vuls)

   #--- construyo una tabla con los con los resultados obtenido
   result_aux<-data.frame(buscar_fabricante,buscar_producto, buscar_cadena_busqueda, vuls)   
   result <- rbind(result,result_aux)
}

#--- guardando los resultado en local
save(result,file="./RESULTADOS/vuls_dispositivos_industriales.rda")



