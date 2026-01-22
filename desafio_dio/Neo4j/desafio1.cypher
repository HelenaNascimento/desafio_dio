


CREATE (:Genre {name: "Ação"}),
       (:Genre {name: "Ficção Científica"}),
       (:Genre {name: "Drama"});

// =============================================
// Actor
// =============================================
CREATE
  (a1:Actor  {name: "Keanu Reeves"}),
  (a2:Actor  {name: "Scarlett Johansson"}),
  (a3:Actor  {name: "Leonardo DiCaprio"}),
  (a4:Actor  {name: "Margot Robbie"}),
  (a5:Actor  {name: "Tom Hardy"}),
  (a6:Actor  {name: "Zendaya"}),
  (a7:Actor  {name: "Cillian Murphy"}),
  (a8:Actor  {name: "Anya Taylor-Joy"}),
  (a9:Actor  {name: "Timothée Chalamet"}),
  (a10:Actor {name: "Florence Pugh"}),
  (d1:Actor {name: "Christopher Nolan"}),
  (d2:Actor {name: "Denis Villeneuve"}),
  (d3:Actor {name: "Greta Gerwig"}),
  (d4:Actor {name: "Quentin Tarantino"}),
  (d5:Actor {name: "Lana Wachowski"}),
  (d6:Actor {name: "James Gunn"}),
  (d7:Actor {name: "Yorgos Lanthimos"}),
  (d8:Actor {name: "Matt Reeves"});

// =============================================
// Movie
// =============================================
CREATE
  (m1:Movie {title: "Oppenheimer"}),
  (m2:Movie {title: "Dune: Part Two"}),
  (m3:Movie {title: "Barbie"}),
  (m4:Movie {title: "Once Upon a Time in Hollywood"}),
  (m5:Movie {title: "The Matrix Resurrections"}),
  (m6:Movie {title: "Furiosa: A Mad Max Saga"}),
  (m7:Movie {title: "Poor Things"}),
  (m8:Movie {title: "Dune"}),
  (m9:Movie {title: "The Batman"}),
  (m10:Movie {title: "Inception"});

// =============================================
// Series
// =============================================
CREATE
  (s1:Series {title: "The Last of Us"}),
  (s2:Series {title: "Succession"}),
  (s3:Series {title: "The Boys"}),
  (s4:Series {title: "House of the Dragon"}),
  (s5:Series {title: "Mr Robot"}),
  (s6:Series {title: "Andor"}),
  (s7:Series {title: "The Bear"}),
  (s8:Series {title: "Silo"}),
  (s9:Series {title: "Shogun"}),
  (s10:Series {title: "Fallout"});



// =============================================
// User
// =============================================
CREATE
  (:User {username: "cinefan_br",     name: "Ana Clara",     ratingStyle: "crítico"}),
  (:User {username: "maratonista99",  name: "João Pedro",    ratingStyle: "quantitativo"}),
  (:User {username: "scifi_louca",    name: "Mariana",       ratingStyle: "emocional"}),
  (:User {username: "barbiecore",     name: "Letícia",       ratingStyle: "visual"}),
  (:User {username: "nolan_addicted", name: "Rafael",        ratingStyle: "técnico"}),
  (:User {username: "vilanefã",       name: "Beatriz",       ratingStyle: "shipper"}),
  (:User {username: "tarantino4ever", name: "Gustavo",       ratingStyle: "diálogos"}),
  (:User {username: "cyberpunk2025",  name: "Sophia",        ratingStyle: "futurista"}),
  (:User {username: "dramaholic",     name: "Lucas",         ratingStyle: "profundo"}),
  (:User {username: "serieiro_sul",   name: "Camila",        ratingStyle: "binge"});

// =============================================
// RELACIONAMENTOS 
// =============================================
MATCH (g:Genre {name: "Ação"})
MATCH (m:Movie) WHERE m.title IN ["Oppenheimer", "Barbie", "Once Upon a Time in Hollywood", "Furiosa: A Mad Max Saga", "The Batman"]
MATCH (s:Series) WHERE s.title IN ["The Boys", "House of the Dragon", "The Last of Us"]
MERGE (m)-[:IN_GENRE]->(g) MERGE (s)-[:IN_GENRE]->(g);

MATCH (g:Genre {name: "Ficção Científica"})
MATCH (m:Movie) WHERE m.title IN ["Dune", "Dune: Part Two", "The Matrix Resurrections", "Inception"]
MATCH (s:Series) WHERE s.title IN ["Andor", "Silo", "Fallout"]
MERGE (m)-[:IN_GENRE]->(g) MERGE (s)-[:IN_GENRE]->(g);

MATCH (g:Genre {name: "Drama"})
MATCH (m:Movie) WHERE m.title IN ["Oppenheimer", "Poor Things", "Barbie"]
MATCH (s:Series) WHERE s.title IN ["Mr Robot", "Succession", "The Bear", "Shogun"]
MERGE (m)-[:IN_GENRE]->(g) MERGE (s)-[:IN_GENRE]->(g);

// =============================================
// DIREÇÃO
// =============================================
MATCH (d:Person {name: "Christopher Nolan"}), (m:Movie) WHERE m.title IN ["Oppenheimer", "Inception"]
CREATE (d)-[:DIRECTED]->(m);

MATCH (d:Person {name: "Denis Villeneuve"}), (m:Movie) WHERE m.title IN ["Dune: Part Two", "Dune"]
CREATE (d)-[:DIRECTED]->(m);

MATCH (d:Person {name: "Greta Gerwig"}), (m:Movie {title: "Barbie"}) CREATE (d)-[:DIRECTED]->(m);
MATCH (d:Person {name: "Quentin Tarantino"}), (m:Movie {title: "Once Upon a Time in Hollywood"}) CREATE (d)-[:DIRECTED]->(m);
MATCH (d:Person {name: "Lana Wachowski"}), (m:Movie {title: "The Matrix Resurrections"}) CREATE (d)-[:DIRECTED]->(m);
MATCH (d:Person {name: "Yorgos Lanthimos"}), (m:Movie {title: "Poor Things"}) CREATE (d)-[:DIRECTED]->(m);
MATCH (d:Person {name: "Matt Reeves"}), (m:Movie {title: "The Batman"}) CREATE (d)-[:DIRECTED]->(m);

// =============================================
MATCH (a:Person {name: "Cillian Murphy"}), (m:Movie {title: "Oppenheimer"}) CREATE (a)-[:ACTED_IN {role: "Lead"}]->(m);
MATCH (a:Person {name: "Zendaya"}), (m:Movie) WHERE m.title IN ["Dune: Part Two", "Dune"] CREATE (a)-[:ACTED_IN]->(m);
MATCH (a:Person {name: "Margot Robbie"}), (m:Movie {title: "Barbie"}) CREATE (a)-[:ACTED_IN {role: "Barbie"}]->(m);
MATCH (a:Person {name: "Leonardo DiCaprio"}), (m:Movie {title: "Once Upon a Time in Hollywood"}) CREATE (a)-[:ACTED_IN {role: "Rick Dalton"}]->(m);
MATCH (a:Person {name: "Keanu Reeves"}), (m:Movie {title: "The Matrix Resurrections"}) CREATE (a)-[:ACTED_IN {role: "Neo"}]->(m);
MATCH (a:Person {name: "Anya Taylor-Joy"}), (m:Movie {title: "Furiosa: A Mad Max Saga"}) CREATE (a)-[:ACTED_IN {role: "Furiosa"}]->(m);
MATCH (a:Person {name: "Florence Pugh"}), (m:Movie {title: "Poor Things"}) CREATE (a)-[:ACTED_IN {role: "Yelena"}]->(m);
MATCH (a:Person {name: "Tom Hardy"}), (m:Movie {title: "Dune"}) CREATE (a)-[:ACTED_IN]->(m);

// Séries
MATCH (a:Person {name: "Tom Hardy"}), (s:Series {title: "The Last of Us"}) CREATE (a)-[:ACTED_IN]->(s);
// Nota: "Dune: Prophecy" não foi criado na lista de séries acima, se quiser usar, crie o nó primeiro.

// =============================================
MATCH (u:User {username: "nolan_addicted"}), (m:Movie {title: "Oppenheimer"})
CREATE (u)-[:WATCHED {rating: 9.5, when: "2024-01"}]->(m);

MATCH (u:User {username: "barbiecore"}), (m:Movie {title: "Barbie"})
CREATE (u)-[:WATCHED {rating: 9.0, when: "2023-07"}]->(m);

MATCH (u:User {username: "scifi_louca"}), (m:Movie {title: "Dune: Part Two"}), (s:Series {title: "Silo"})
CREATE (u)-[:WATCHED {rating: 8.8}]->(m), (u)-[:WATCHED {rating: 8.4}]->(s);

// =============================================
MATCH (u:User {username: "nolan_addicted"}), (m:Movie), (s:Series)
WHERE m.title IN ["Inception", "Dune: Part Two", "The Matrix Resurrections"] 
   OR s.title IN ["Severance", "Silo"]
CREATE (u)-[:WATCHED {rating: 9.2, when: "2023-12"}]->(m),
       (u)-[:WATCHED {rating: 8.9, when: "2024-01"}]->(s);


MATCH (u:User {username: "maratonista99"}), (s:Series)
WHERE s.title IN ["The Boys", "House of the Dragon", "Fallout", "Succession", "The Bear"]
CREATE (u)-[:WATCHED {rating: 7.5}]->(s);


MATCH (u:User {username: "scifi_louca"}), (m:Movie), (s:Series)
WHERE m.title IN ["Dune", "Inception", "Furiosa: A Mad Max Saga"]
   OR s.title IN ["Andor", "Fallout", "Silo"]
CREATE (u)-[:WATCHED {rating: 9.5}]->(m),
       (u)-[:WATCHED {rating: 9.0}]->(s);


MATCH (u:User {username: "barbiecore"}), (m:Movie), (s:Series)
WHERE m.title IN ["Poor Things", "Once Upon a Time in Hollywood"]
   OR s.title IN ["Succession"]
CREATE (u)-[:WATCHED {rating: 8.5}]->(m),
       (u)-[:WATCHED {rating: 8.0}]->(s);


MATCH (u:User {username: "tarantino4ever"}), (m:Movie), (s:Series)
WHERE m.title IN ["Once Upon a Time in Hollywood", "Oppenheimer", "The Batman"]
   OR s.title IN ["Shogun", "The Bear"]
CREATE (u)-[:WATCHED {rating: 9.8}]->(m),
       (u)-[:WATCHED {rating: 9.0}]->(s);


MATCH (u:User {username: "vilanefã"}), (m:Movie)
WHERE m.title IN ["Dune", "Dune: Part Two"]
CREATE (u)-[:WATCHED {rating: 10.0, comment: "Obra prima!"}]->(m);


MATCH (u:User {username: "dramaholic"}), (m:Movie), (s:Series)
WHERE m.title IN ["Oppenheimer", "Poor Things"]
   OR s.title IN ["Succession", "The Last of Us", "Shogun"]
CREATE (u)-[:WATCHED {rating: 9.4}]->(m),
       (u)-[:WATCHED {rating: 9.7}]->(s);


MATCH (u:User {username: "serieiro_sul"}), (s:Series)
WHERE s.title IN ["The Last of Us", "The Bear", "Fallout", "House of the Dragon"]
CREATE (u)-[:WATCHED {rating: 8.5}]->(s);

MATCH (u:User {username: "cyberpunk2025"}), (m:Movie), (s:Series)
WHERE m.title IN ["The Matrix Resurrections", "Inception"]
   OR s.title IN ["Severance", "Silo", "Andor"]
CREATE (u)-[:WATCHED {rating: 8.7}]->(m),
       (u)-[:WATCHED {rating: 9.3}]->(s);


MATCH (u:User {username: "cinefan_br"}), (m:Movie), (s:Series)
WHERE m.title IN ["Barbie", "Oppenheimer", "Poor Things", "The Batman"]
   OR s.title IN ["Succession", "The Bear"]
CREATE (u)-[:WATCHED {rating: 6.5}]->(m), 
       (u)-[:WATCHED {rating: 8.0}]->(s);