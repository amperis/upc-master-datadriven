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

#--- especificando KEY de acceso a la cuenta de Shodan
Sys.setenv(SHODAN_API_KEY="CDQL6U2lc9WKTHCVHe4vxgz8dgO2SSnV")
packageVersion("shodan")
account_profile()

#--- cargado lista de dispositivos industriales a buscar en Shodan
csv <- read.csv(file="dispositivos_industriales.csv", head=TRUE, sep=";")
busquedas<-csv["cadena_busqueda"]

result<-shodan_search("A850 Telemetry Gateway")
result<-c(result$matches$ip_str,result$matches$isp)
result

result$matches$ip_str
result$matches$isp
result$matches$location$city
result$matches$location$longitude
result$matches$location$latitude
result$matches$location$country_name
result$matches$location$country_code3
result$matches$os
result$matches$org
result$matches$asn

for (i in 1:length(busquedas)) {
  print(busquedas[i])
}
