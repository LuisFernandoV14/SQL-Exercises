# Problemas

Antes de começar,  é importante destacar que o MongoDB é um banco de dados orientado <i> a documentos </i> (JSON / BSON), diferente do MySQL, que é relacional.

## Primeiro problema - Incompatibilidade de impedância

É um problema que banco de dados relacionais apresentam.

* Em um modelo relacional, as entidades são divididas em <i> tabelas</i>. <br>
* Isso dificulta operações mais complexas, como por exemplo, montar um relatório com as informações de um pedido. <br>
* Caso um pedido seja constituído por várias tabelas (como "clientes", "produtos", "endereços", etc.) seria necessário juntar essas tabelas (através do JOIN).
* Um programa que lê essas operações tem que <b> constantemente </b> traduzir o modelo relacional para o modelo de objetos associados em memória. <br>
* Fora isso, junções e transações são operações pesadas, que degradam a performance da aplicação. <br>

## Segundo problema - Grande volume de dados e acessos

É um problema que banco de dados relacionais apresentam.

* Um modo de resolver o problema de incapacidade de lidar com um grande volume de dados e acesso é comprar computadores maiores e mais potentes. (escala vertical) <br>
* O problema com essa solução é que é inviável para certas equipes, devido ao alto preço de periféricos novos. <br>
* Uma solução mais econômica são os clusters, computadores formados por outros computadores, menores (escala horizontal). <br>
* Um cluster apresenta uma maior confibialidade, um crescimento menos limitado e a capacidade de criar máquinas virtuais (virtualização). <br>
* Por que isso é importante? Banco de dados relacionais não foram otimizados para trabalhar com clusters, e em empresas grandes usar cluster não é uma decisão negociável.
