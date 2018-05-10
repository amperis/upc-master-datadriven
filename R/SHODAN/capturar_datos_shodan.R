# capturar_datos_shodan
#
# Descarga de Shodan todas las IP de dispositivos industriales publicos en Internet
#
# Requisitos de librerias instaladas:
#   install_github("hrbrmstr/shodan")
#   devtools, ggplot2, xtable, maps, rworldmap, ggthemes
# Info:
#    https://github.com/hrbrmstr/shodan

#--- carga de librerias
library(devtools)
library(ggplot2)
library(xtable)
library(maps)
library(rworldmap)
library(ggthemes)
library(shodan)

rm(list=ls(all=TRUE))

#--- especificando KEY de acceso a la cuenta de Shodan
Sys.setenv(SHODAN_API_KEY="CDQL6U2lc9WKTHCVHe4vxgz8dgO2SSnV")
packageVersion("shodan")
account_profile()

rstring<-function(s, num) {
  X<-c()
  for (i in 1:num) {
     X<-c(X, s) 
  }
  return(X)
}

#--- cargado lista de dispositivos industriales a buscar en Shodan
csv <- read.csv(file="dispositivos_industriales.csv", head=TRUE, sep=";")

result<-data.frame()
for (i in 1:nrow(csv)) {
  fabricante<-as.character(csv[i,"fabricante"])
  producto<-as.character(csv[i,"producto"])
  cadena_busqueda<-as.character(csv[i,"cadena_busqueda"])
  print(cadena_busqueda)
  aux<-shodan_search(cadena_busqueda)
  Sys.sleep(2)
  v_fabricante<-rstring(fabricante,length(aux$matches$ip_str))
  v_producto<-rstring(producto,length(aux$matches$ip_str))
  v_cadena_busqueda<-rstring(cadena_busqueda,length(aux$matches$ip_str))
  result_cvs<-data.frame(v_fabricante, v_producto, v_cadena_busqueda, aux$matches$ip_str, aux$matches$isp, aux$matches$location$city, aux$matches$location$longitude, aux$matches$location$latitude, aux$matches$location$country_name, aux$matches$location$country_code3, aux$matches$os, aux$matches$org, aux$matches$asn )
  result <- rbind(result,result_cvs)
}

write.csv(result,file="resultado_busqueda_shodan.csv",quote=FALSE)





