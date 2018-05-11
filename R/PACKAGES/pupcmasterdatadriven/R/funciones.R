#' @title Replicar string
#' @description La funcion rstring() devuelve un vector de num posiciones con el valor de la cadena s
#' @param s cadena a replicar
#' @param nun numero de veces a replicar la cadena s
#' @examples
#' rstring("mi cadena", 10)
#' @export
rstring<-function(s, num) {
  X<-c()
  for (i in 1:num) {
    X<-c(X, s)
  }
  return(X)
}

#' @title Eliminar variables
#' @description La funcion clearvariables() elimina todas las variables del entorno R
#' @examples
#' clearvariables()
#' @export
clearvariables<-function() {
  env <- parent.frame()
  rm(
    list = setdiff( ls(all.names=TRUE, env = env), lsf.str(all.names=TRUE, env = env)),
    envir = env
  )
}
