# setwd("/media/user/Daniel/Banco dados/") # Talvez seja precipitado... mas podemos conversar sobre isso (https://www.tidyverse.org/articles/2017/12/workflow-vs-script/)

## caminhos das pastas

# Instaling packages ------------------------------------------------------
library(raster)
library(sp)
library(tidyverse)
library(maptools)
library(rgeos)
library(landscapemetrics)
# Downloading spatial datasets ------------------------------------------------

# Sites
thomas <- shapefile("./site.wgs84.shp")  # tive que mudar path
cris <- shapefile("./CBL.site.wgs84.shp")# tive que mudar path

# Mapbiomas
MA <- list.files("../Data/MapBiomas/", full.names = TRUE, pattern = 'MATAATLANTICA.tif$') %>% 
  stack() # tive que mudar path
names(MA) <- 2001:2017 # tive que mudar pq não estava com todaas as layers, eu acho...
names(MA) # vc deve ter percebido o 'X' no nome... caso queira saber mais: https://stackoverflow.com/questions/36844460/why-does-r-add-an-x-when-renaming-raster-stack-layers

# Preparing the dataset ----------------------------------------------------
# Defining the buffer of each point in the MA raster, for the related year of collection

buffer.thomas <- buffer(thomas, 8000, dissolve = F) # pelo fato de vc estar trabalhando com dados não projetados vc precisa informar o raio em graus decimais. O que é um problema pois o grau varia de acordo com a latitude: um mesmo grau é maior no equador e menor nos polos :/
# melhor projetar isso. Lembro de termos feito um exercício em algum treinamento anterior...
extent(buffer.thomas) # precisei ver o extent para responder a sua pergunta
buffer.cris <- buffer(cris, 8000, dissolve = F)
buffer.lista <- rbind(buffer.cris, buffer.thomas)
names(buffer.lista)

t <- gBuffer(thomas, byid = F, width = 8000) ## Dúvida - porque a diferença do formato e valores de "extent" entre o uso das duas funções (buffer vs gBuffer)
extent(t) # resposta está no warning

stack.buffer.MA <- list() # senti falta de comentario sobre o que se esta fazendo aqui :/
for(i in 1:length(buffer.lista)){
  # i=1 # só para testar com um unico valor
  stack.buffer.MA[[i]] <-crop( # as vezes fica mais legivel se quebramos as linhas de acordo com as funcoes....
    subset(MA, 
           paste("X",
                 as.data.frame(buffer.lista[i,"ano"]), # pq vc esta convertendo para data.frame?
                 # poderia ser:
                 #buffer.lista@data[i,"ano"]
                 # ficando
                 # paste0("X", buffer.lista@data[i,"ano"]) # o paste 0 nao add espaco... facilita para esses casos!
                 sep = "")),buffer.lista[i,]) %>% 
    mask(buffer.lista[i,])
} # parei de ver aqui.
# vc conseguiu rodar seu script? No meu PC, além de ter problema com o crop, paste e etc, eu não consegui rodar o crop pois vi que os dados seguem sendo spatialpointdataframe mesmo tendo sido feito buffer deles (e por tanto, esperava que fosse um poligono).... Acho qeu isso tem a ver com o fato de vc ter definido um raio de buffer que talvez não corresponda ao sistema cartográfico em que estão sod ados..

# Calculating landscape metrics -------------------------------------------
# Defining the classes for habitat and no_habitat
reclass <- as.factor(c(0, 3, 1,3,33,2))
reclass.matrix <- matrix(data = reclass, ncol = 3, nrow = 2, byrow = T)

stack.buffer.MA.reclass <- list()
for(i in 1:length(stack.buffer.MA)){
  stack.buffer.MA.reclass[[i]] <- reclassify(stack.buffer.MA[[i]], rcl =  reclass.matrix, include.lowest = T)  
}
stack.buffer.MA.reclass

# Landscape metrics
landscapemetrics::lsm_abbreviations_names %>% print(n = nrow(.)) #o ponto se refere ao elemento
# Área de cada classe (habitat = 1; no_habitat = 2) 
lsm_c_ca(stack.buffer.MA.reclass) %>% 
  print(n = nrow(.))

lsm_p_area(stack.buffer.MA.reclass) %>% 
  print(n = nrow(.)) %>% 
  head(n = 10)

# Como repetir o script da linha 26 até 51?








rm(list=ls())
