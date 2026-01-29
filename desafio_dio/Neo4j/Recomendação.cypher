Importação do arquivo Music e Users

//Criar o nodes Genre

UNWIND [
  'Jazz',
  'Punk',
  'Country',
  'Folk',
  'Reggae',
  'Rap',
  'Blues',
  'New Age',
  'Latin',
  'RnB',
  'Pop',
  'Metal',
  'Eletronic'
] AS genreName
MERGE (:Genre {genre: genreName});

MATCH (m:Music) 
MATCH (g:Genre)
WHERE m.genre = g.genre
MERGE (m)-[:Pertence]->(g)

MATCH (u:Users)
MATCH (m:Music)
WHERE u.trackId = m.trackId
MATCH (g:Genre {genre: m.genre})
MERGE (u)-[:LIKED]->(g)



//Recomendação

MATCH (u1:Users {userId: "10b36f3857a49f3566d0ecae42b698e217233b4d"})-[:OUVIU]->(m:Music)<-[:OUVIU]-(u2:Users)
WITH u1, u2, COUNT(m) AS intersecao
MATCH (u1)-[:LIKED]->(m1:Music)
WITH u1, u2, intersecao, COLLECT(DISTINCT m1) AS musicas1
MATCH (u2)-[:LIKED]->(m2:Music)
WITH u1, u2, intersecao, musicas1, COLLECT(DISTINCT m2) AS musicas2
WITH u1, u2, intersecao, musicas1 + [x IN musicas2 WHERE NOT x IN musicas1] AS uniao
RETURN u2.userId, (1.0 * intersecao / SIZE(uniao)) AS similaridade
ORDER BY similaridade DESC
LIMIT 5