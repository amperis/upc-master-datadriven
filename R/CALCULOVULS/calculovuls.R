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
dispositivos_industriales_vuls<-data.frame()
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
   dispositivos_industriales_vuls <- rbind(dispositivos_industriales_vuls,result_aux)
}

#--- guardando los resultado en local
save(dispositivos_industriales_vuls,file="./RESULTADOS/vuls_dispositivos_industriales.rda")

#--- buscamos las vulnerabilidades industriales que tienen los dispostivos industriales de data frame "dispostivos_shodan"
load("./RESULTADOS/vuls_dispositivos_industriales.rda")
dispositivos_industriales_shodan_vuls<-data.frame()
for (i in 1:nrow(dispositivos_shodan)) {
   aux_buscar_fabricante<-as.character(dispositivos_shodan[i,"v_fabricante"])
   aux_buscar_producto<-as.character(dispositivos_shodan[i,"v_producto"])
   aux_buscar_cadena_busqueda<-as.character(dispositivos_shodan[i,"v_cadena_busqueda"])  
   ip<-as.character(dispositivos_shodan[i,"aux.matches.ip_str"])
   long<-as.character(dispositivos_shodan[i,"aux.matches.location.longitude"])
   lati<-as.character(dispositivos_shodan[i,"aux.matches.location.latitude"])
   country<-as.character(dispositivos_shodan[i,"aux.matches.location.country_name"])
   country_code<-as.character(dispositivos_shodan[i,"aux.matches.location.country_code3"])
   
   filteraffects<-dplyr::filter(dispositivos_industriales_vuls, buscar_fabricante==aux_buscar_fabricante, buscar_producto==aux_buscar_producto, buscar_cadena_busqueda==aux_buscar_cadena_busqueda)
   vuls<-filteraffects$vuls
   print(paste(buscar_fabricante, buscar_producto,  buscar_cadena_busqueda, ip, long, lati, country, country_code, vuls, sep="|"))
   
   #--- construyo una tabla con los con los resultados obtenido
   result_aux<-data.frame(buscar_fabricante, buscar_producto,  buscar_cadena_busqueda, ip, long, lati, country, country_code, vuls)   
   dispositivos_industriales_shodan_vuls <- rbind(dispositivos_industriales_shodan_vuls,result_aux)
}

#--- guardando los resultado en local
save(dispositivos_industriales_shodan_vuls,file="./RESULTADOS/vuls_dispositivos_industriales_shodan.rda")
