# capturar_datos_shodan
#
# Programa para la descarga de Shodan todas las IP de dispositivos industriales publicos en Internet.
# Para ello utilizamos un listado de modelos de dispositovos industriales y realizamos una busqueda en Shodan
# por cada uno de ellos.
#
# Requisitos de librerias instaladas:
#   install_github("hrbrmstr/shodan")
#   devtools, ggplot2, xtable, maps, rworldmap, ggthemes
#   pupcmasterdatadriven
# Info:
#    https://github.com/hrbrmstr/shodan

#--- carga de librerias
library(devtools)
library(xtable)
library(shodan)
library(pupcmasterdatadriven)

clearvariables()

#--- especificando KEY de acceso a la cuenta de Shodan
Sys.setenv(SHODAN_API_KEY="CDQL6U2lc9WKTHCVHe4vxgz8dgO2SSnV")
packageVersion("shodan")
account_profile()

#--- cargado lista de dispositivos industriales a buscar en Shodan
csv <- read.csv(file="./FUENTESDATOS/dispositivos_industriales.csv", head=TRUE, sep=";", stringsAsFactors = FALSE)

result<-data.frame()

#--- recorrecmos cada fila del CSV
for (i in 1:nrow(csv)) {
  
  #--- leyendo datos del CSV
  fabricante<-as.character(csv[i,"fabricante"])
  producto<-as.character(csv[i,"producto"])
  cadena_busqueda<-as.character(csv[i,"cadena_busqueda"])
  
  #--- realizamos la busqueda dentro de Shodan
  print(cadena_busqueda)
  aux<-shodan_search(cadena_busqueda)
  print(aux$total)
  Sys.sleep(1)
  
  #--- si encontramos algo en Shodan
  if (aux$total > 0) {
     v_fabricante<-rstring(fabricante,length(aux$matches$ip_str))
     v_producto<-rstring(producto,length(aux$matches$ip_str))
     v_cadena_busqueda<-rstring(cadena_busqueda,length(aux$matches$ip_str))
     
     #--- construyo una tabla con los datos obtenidos
     result_cvs<-data.frame(v_fabricante, v_producto, v_cadena_busqueda, aux$matches$ip_str, aux$matches$isp, aux$matches$location$city, aux$matches$location$longitude, aux$matches$location$latitude, aux$matches$location$country_name, aux$matches$location$country_code3, aux$matches$os, aux$matches$org, aux$matches$asn )
     
     #--- adjunto los datos obtenidos a los anteriores
     result <- rbind(result,result_cvs)
  }
}

#--- guardo todos mis datos en un CSV
write.table(result,file="./FUENTESDATOS/resultado_busqueda_shodan.csv",quote=FALSE, sep=";", row.names = FALSE)







