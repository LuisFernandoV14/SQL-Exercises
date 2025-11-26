# NoSQL

* Primeiras influências: Google (BigTable) e Amazon (Dynamo)
<br>

* O nome NoSQL é acidental. E o nome NoSQL não tem uma definição específica, só características comuns.
* Alguns defendem que o nome NoSQL seja para "Not Only SQL" (Não Apenas SQL), mas isso é meio polêmico.
<br>

* Características comuns: 
  * Não utilizam modelo relacional;
  * Tem uma boa execução em clusters;
  * Código aberto;
  * Século XXI;
  * Não tem esquema;

#### O NoSQL é dividido em duas principais classes de banco de dados:
 
* Banco de dados orientados a agregados
  * Modelo chave-valor (Riak, Redis)
  * Modelo de documentos (MongoDB, CouchDB)
  * Modelo família de colunas (Cassandra, Apache HBase)
 
* Banco de dados de grafos (Neo4j)
  * (útil com dados com relacionamentos complexos, que é um ponto fraco do NoSQL);


##### Um agregado é <b> um conjunto de objetos relacionados, não normalizado, tratados com uma unidade. </b>

## Sobre o MongoDB

* O MongoDB é um banco de dados NoSQL, modelo de documentos.
* Voltando ao exemplo de um pedidos com várias informações, todas as "tabelas" seriam tratadas como uma única coleção, um agregado. Para fazer um relatório, basta retornar um aquivo, o agregado. Isso resolve o problema 1 de banco de dados relacionais. <br>
* Além disso, todos os dados de um agragado são armazenados <b> juntos</b>, num mesmo nodo, o que o torna muito compatível com a clusterização.
<br>

* Entretanto, também há um ponto negativo, a maioria dos bancos de dados NoSQL, como é o caso do MongoDB, não tem todo o suporte para transações ACID, assim como banco de dados relacionais. 
