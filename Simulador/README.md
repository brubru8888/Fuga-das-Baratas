# [Simple Simulator](#simple-simulator)
Para o presente trabalho, utilizamos o template .c do Simple Simulator do Professor Simões e, a partir disso, desenvolvemos o código da Máquina de controle. 
A máquina de controle, por sua vez, opera num switch case que transiciona entre ciclos de Busca, Decodificação e Execução, além de ciclos complementares como ciclo de Reset e Halt. 
Dentro de cada ciclo, utilizamos um switch case para tratar as instruções chamadas em cada estado. 


## Sumário
- [Estrutura do Código](#estrutura-do-código)
  - [Definições de Estados](#definições-de-estados)
  - [Decodificação de Instruções](#decodificação-de-instruções)
  - [Instruções utilizadas](#instruções-utilizadas)
  - [Operações Auxiliares](#operações-auxiliares)
  - [Detalhes dos Multiplexadores](#detalhes-dos-multiplexadores)
  - [Operações da ULA](#operações-da-ula)
- [Processamento de Arquivo CPU.MIF](#processamento-de-arquivo-cpu-mif)
  - [Funcionalidades](#funcionalidades)
    - [1. Função `le_arquivo`](#1-função-le_arquivo)
    - [2. Função `processa_linha`](#2-função-processa_linha)
    - [3. Função `pega_pedaco`](#3-função-pega_pedaco)


## [Estrutura do Código](#estrutura-do-código)

### [Definições de Estados](#definições-de-estados)

1. STATE_FETCH: Busca a próxima instrução na memória.
2. STATE_EXECUTE: Executa a instrução atual.
3. STATE_EXECUTE2: Um estado auxiliar usado em algumas instruções.
4. STATE_HALTED: Indica que a execução foi pausada ou encerrada.

### [Decodificação de Instruções](#decodificação-de-instruções)
As instruções são decodificadas com base no campo opcode.
Instruções incluem controle de fluxo (JMP, CALL), manipulação de pilha (PUSH, POP, RTS), manipulação de flags (SETC), e operações auxiliares (NOP, HALT, BREAKP).

Além disso, algumas instruções dependem do valor dos registradores de flags (FR), verificando condições como maior que, menor que, igual, overflow, etc.

### [Instruções utilizadas](#instruções-utilizadas)

1. **Definições de Estados**:
   - `STATE_FETCH`: Busca a próxima instrução na memória.
   - `STATE_EXECUTE`: Executa a instrução atual.
   - `STATE_EXECUTE2`: Um estado auxiliar usado em algumas instruções.
   - `STATE_HALTED`: Indica que a execução foi pausada ou encerrada.

2. **Decodificação de Instruções**:
   - As instruções são decodificadas com base no campo `opcode`.
   - Instruções incluem controle de fluxo (`JMP`, `CALL`), manipulação de pilha (`PUSH`, `POP`, `RTS`), manipulação de flags (`SETC`), e operações auxiliares (`NOP`, `HALT`, `BREAKP`).

3. **Execução Condicional**:
   - Algumas instruções dependem do valor dos registradores de flags (`FR`), verificando condições como maior que, menor que, igual, overflow, etc.

4. **Componentes do Sistema**:
   - **Multiplexadores (MUX)**: Seletam dados de diferentes origens para serem usados em operações ou armazenados.
   - **Unidade Lógica e Aritmética (ULA)**: Realiza operações lógicas e aritméticas, atualizando os registradores de flags conforme o resultado.

#### [Operações Auxiliares](#operações-auxiliares)
1. **`SETC`**: Define o valor do bit de Carry diretamente a partir da instrução.
2. **`HALT`**: Encerra a execução.
3. **`NOP`**: Não realiza nenhuma operação.
4. **`BREAKP`**: Pausa a execução aguardando uma entrada do usuário.

#### [Detalhes dos Multiplexadores](#detalhes-dos-multiplexadores)
1. **`selM1`**: Seleciona o endereço da memória a ser acessado.
   - Opções incluem `PC`, `MAR`, `M4`, `SP`.

2. **`selM2`**: Seleciona a origem dos dados para operações ou armazenamento.
   - Opções incluem `ULA`, `DATA_OUT`, `M4`, `SP`.

3. **`selM3`**: Seleciona os dados de entrada da ULA.
   - Pode ser um registrador geral ou os flags (`FR`).

4. **`selM5` e `selM6`**: Usados para direcionar valores para o `PC`, memória ou flags.

#### [Operações da ULA](#operações-da-ula)
A ULA realiza operações aritméticas e lógicas entre os valores selecionados por `selM3` e `M4`. O resultado é armazenado em `resultadoUla.result`, e os flags são atualizados em `resultadoUla.auxFR`.

## [Processamento de Arquivo CPU.MIF](#processamento-de-arquivo-cpu-mif)
Este módulo é responsável por processar dados provenientes de um arquivo CPU.MIF. Ele realiza a leitura, tratamento e armazenamento de informações em uma estrutura de memória. 

### [Funcionalidades](#funcionalidades)
#### [1. Função `le_arquivo`](#1-função-le_arquivo)
- **Descrição**:
  Lê o arquivo `TestaCPU.mif`, identifica o início dos dados relevantes, e armazena os valores processados em um vetor chamado `MEMORY`.
- **Detalhes**:
  - Abre o arquivo em modo de leitura.
  - Remove cabeçalhos não relevantes.
  - Processa cada linha do arquivo para extrair os dados codificados.
  - Armazena os dados no vetor `MEMORY` com tamanho definido por `TAMANHO_MEMORIA`.
  - Gera mensagens de erro para linhas inválidas.

#### [2. Função `processa_linha`](#2-função-processa_linha)
- **Descrição**:
  Processa uma linha completa do arquivo e retorna o valor numérico codificado.
- **Detalhes**:
  - Localiza a posição do separador `:` na linha.
  - Lê os 16 bits subsequentes como um número binário.
  - Retorna `-1` se a linha estiver em formato inválido.
- **Nota**:
  Assume que os números no arquivo estão representados no formato binário (`radix=BIN`).


#### [3. Função `pega_pedaco`](#3-função-pega_pedaco)
- **Descrição**:
  Extrai um subconjunto de bits de uma instrução (IR) entre as posições `a` e `b`.
- **Detalhes**:
  - Aplica operações de bitwise (`>>`, `&`) para isolar os bits desejados.
  - **Exemplo de uso**:
    ```c
    int registro = pega_pedaco(IR, 10, 7);
    ```
    Onde o trecho de interesse está nos bits entre as posições 7 e 10 (inclusive).
