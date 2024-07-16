
# Carregar o pacman

if (!require("pacman")) install.packages("pacman")

library(pacman)

# Carregar pacotes necessários com pacman
p_load(readxl, openxlsx)


##########################################################################################

##########################            ALTERAR           ##################################

setwd("C:") #Diretório

file_path <- "./" # File path

sheet_name <- "Planilha1"

matriz <- as.matrix(read_excel(file_path, sheet = sheet_name))

# Definindo o número de linhas a serem sorteadas (menor que linhas únicas da planilha)

num_linhas = 5


# Número de vezes para executar o programa (apenas conjuntos únicos - output)


n_amostra = 30


##########################################################################################


# Função para checar se duas linhas têm elementos em comum

tem_elementos_comuns <- function(linha1, linha2) {
  
  return(length(intersect(linha1, linha2)) > 0)
  
}

# Função para sortear linhas sem elementos em comum

sortear_linhas_unicas <- function(matriz, num_linhas) {
  
  linhas_sorteadas <- list()
  
  n <- nrow(matriz)
  
  # Sorteando a primeira linha
  
  primeira_linha <- sample(1:n, 1)
  
  linhas_sorteadas[[1]] <- matriz[primeira_linha,]
  
  # Sorteando as demais linhas
  
  while(length(linhas_sorteadas) < num_linhas) {
    
    nova_linha_index <- sample(setdiff(1:n, sapply(linhas_sorteadas, function(l) which(duplicated(rbind(matriz, l))))), 1)
    
    nova_linha <- matriz[nova_linha_index,]
    
    # Verificando se a nova linha tem elementos em comum com as linhas já sorteadas
    
    tem_comum <- FALSE
    
    for(linha in linhas_sorteadas) {
      
      if(tem_elementos_comuns(linha, nova_linha)) {
        tem_comum <- TRUE
        break
      }
    }
    
    # Se não tem elementos comuns, adicionar à lista
    if(!tem_comum) {
      
      linhas_sorteadas[[length(linhas_sorteadas) + 1]] <- nova_linha
    }
  }
  
  return(do.call(rbind, linhas_sorteadas))
}


# Chamando a função para sortear as linhas

linhas_sorteadas <- sortear_linhas_unicas(matriz, num_linhas)

print(linhas_sorteadas)

dt <- list()

# Executando o sorteio 20 vezes
for (i in 1:n_amostra) {
  
  linhas_sorteadas <- sortear_linhas_unicas(matriz, num_linhas)
  
  # Adicionar o data frame gerado à lista
  dt[[i]] <- data.frame("Valores" = sort(c(linhas_sorteadas), decreasing = TRUE))
}



# Combinar todos os data frames da lista em um único data frame

resultados <- do.call(cbind, lapply(dt, function(x) data.frame(x)))


# Renomear as colunas para refletir as amostras

colnames(resultados) <- paste("Amostra", 1:n_amostra, sep = "_")


resultados_unicos <- resultados[, !duplicated(as.list(resultados))]


# Exportando para um arquivo Excel

write.xlsx(resultados_unicos, file = "pajs_unicos.xlsx", sheetName = "PAJS Únicos", rowNames = FALSE)

print("Exportação concluída com sucesso.")
