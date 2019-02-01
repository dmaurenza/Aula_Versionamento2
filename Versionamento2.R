# VERSIONAMENTO DE SCRIPT VIA GIT E GITHUB

# Tools > Global Options >  GIT
# Definir caminho de git = usr/bin/git

# Commit - Anotações do que foi feito de novo na nova versão. Data. Outras observações para cada versão. Cada Commit é uma versão. Detalhes do comitt mostram as alterações realizadas

library(ggplot2)

plot (mtcars$mpg, mtcars$disp)

ggplot(mtcars, aes(x = mpg, y = disp)) + geom_point()

# Adicionando texto para sincronizar com Github on line
# Previamente foi criado um repositorio na conta online.
# Criar um novo projeto, com a terceira opção (version control).
# Criar commit
