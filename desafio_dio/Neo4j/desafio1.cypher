CREATE //Gêneros
      (:Genre {name: "Ação"}),
       (:Genre {name: "Ficção Científica"}),
       (:Genre {name: "Drama"});

CREATE //Series
  (s1:Series {title: "The Last of Us",       seasons: 1, startYear: 2023}),
  (s2:Series {title: "Succession",           seasons: 4, startYear: 2018}),
  (s3:Series {title: "The Boys",             seasons: 4, startYear: 2019}),
  (s4:Series {title: "House of the Dragon",  seasons: 2, startYear: 2022}),
  (s5:Series {title: "Severance",            seasons: 1, startYear: 2022}),
  (s6:Series {title: "Andor",                seasons: 1, startYear: 2022}),
  (s7:Series {title: "The Bear",             seasons: 3, startYear: 2022}),
  (s8:Series {title: "Silo",                 seasons: 1, startYear: 2023}),
  (s9:Series {title: "Shogun",               seasons: 1, startYear: 2024}),
  (s10:Series {title: "Fallout",             seasons: 1, startYear: 2024});

CREATE // Filmes
  (m1:Movie {title: "Oppenheimer",           year: 2023, duration: 180}),
  (m2:Movie {title: "Dune: Part Two",        year: 2024, duration: 166}),
  (m3:Movie {title: "Barbie",                year: 2023, duration: 114}),
  (m4:Movie {title: "Once Upon a Time in Hollywood", year: 2019, duration: 161}),
  (m5:Movie {title: "The Matrix Resurrections", year: 2021, duration: 148}),
  (m6:Movie {title: "Furiosa: A Mad Max Saga", year: 2024, duration: 148}),
  (m7:Movie {title: "Poor Things",           year: 2023, duration: 141}),
  (m8:Movie {title: "Dune",                  year: 2021, duration: 155}),
  (m9:Movie {title: "The Batman",            year: 2022, duration: 176}),
  (m10:Movie {title: "Inception",            year: 2010, duration: 148});

CREATE //Atores e Diretores

  // Atores
  (a1:Person  {name: "Keanu Reeves",         born: 1964}),
  (a2:Person  {name: "Scarlett Johansson",   born: 1984}),
  (a3:Person  {name: "Leonardo DiCaprio",    born: 1974}),
  (a4:Person  {name: "Margot Robbie",        born: 1990}),
  (a5:Person  {name: "Tom Hardy",            born: 1977}),
  (a6:Person  {name: "Zendaya",              born: 1996}),
  (a7:Person  {name: "Cillian Murphy",       born: 1976}),
  (a8:Person  {name: "Anya Taylor-Joy",      born: 1996}),
  (a9:Person  {name: "Timothée Chalamet",    born: 1995}),
  (a10:Person {name: "Florence Pugh",        born: 1996}),

  // Diretores
  (d1:Person {name: "Christopher Nolan",     born: 1970, role: "Director"}),
  (d2:Person {name: "Denis Villeneuve",      born: 1967, role: "Director"}),
  (d3:Person {name: "Greta Gerwig",          born: 1983, role: "Director"}),
  (d4:Person {name: "Quentin Tarantino",     born: 1963, role: "Director"}),
  (d5:Person {name: "Lana Wachowski",        born: 1965, role: "Director"}),
  (d6:Person {name: "James Gunn",            born: 1966, role: "Director"}),
  (d7:Person {name: "Yorgos Lanthimos",      born: 1973, role: "Director"}),
  (d8:Person {name: "Matt Reeves",           born: 1966, role: "Director"});



CREATE
  (:User {username: "cinefan_br",     name: "Ana Clara",     ratingStyle: "crítico"}),
  (:User {username: "maratonista99",  name: "João Pedro",    ratingStyle: "quantitativo"}),
  (:User {username: "scifi_louca",    name: "Mariana",       ratingStyle: "emocional"}),
  (:User {username: "barbiecore",     name: "Letícia",       ratingStyle: "visual"}),
  (:User {username: "nolan_addicted", name: "Rafael",        ratingStyle: "técnico"}),
  (:User {username: "vilanefã",        name: "Beatriz",       ratingStyle: "shipper"}),
  (:User {username: "tarantino4ever", name: "Gustavo",       ratingStyle: "diálogos"}),
  (:User {username: "cyberpunk2025",  name: "Sophia",        ratingStyle: "futurista"}),
  (:User {username: "dramaholic",     name: "Lucas",         ratingStyle: "profundo"}),
  (:User {username: "serieiro_sul",   name: "Camila",        ratingStyle: "binge"})


//Relacionamentos
//Genero: Filme e Serie
MATCH (g:Genre {name: "Ação"})
MATCH (m:Movie) WHERE m.title IN ["Oppenheimer", "Barbie", "Once Upon a Time in Hollywood", "Furiosa: A Mad Max Saga", "The Batman"]
MATCH (s:Series) WHERE s.title IN ["The Boys", "House of the Dragon", "The Last of Us"]
MERGE (m)-[:IN_GENRE]->(g) MERGE (s)-[:IN_GENRE]->(g);


MATCH (g:Genre {name: "Ficção Científica"})
MATCH (m:Movie) WHERE m.title IN ["Dune", "Dune: Part Two", "The Matrix Resurrections", "Inception"]
MATCH (s:Series) WHERE s.title IN ["Severance", "Andor", "Silo", "Fallout"]
MERGE (m)-[:IN_GENRE]->(g) MERGE (s)-[:IN_GENRE]->(g);

MATCH (g:Genre {name: "Drama"})
MATCH (m:Movie) WHERE m.title IN ["Oppenheimer", "Poor Things", "Barbie"]
MATCH (s:Series) WHERE s.title IN ["Succession", "The Bear", "Shogun"]
MERGE (m)-[:IN_GENRE]->(g) MERGE (s)-[:IN_GENRE]->(g);


//Diretor: Filme
MATCH (d:Person {name: "Christopher Nolan"}) 
MATCH (m:Movie {title: "Inception"})
MERGE (d)-[:DIRECTED]->(m);

MATCH (d:Person {name: "Denis Villeneuve"}) 
MATCH (m:Movie) WHERE m.title IN ["Dune", "Dune: Part Two"]
MERGE (d)-[:DIRECTED]->(m);

MATCH (d:Person {name: "Greta Gerwig"}) 
MATCH (m:Movie {title: "Barbie"})
MERGE (d)-[:DIRECTED]->(m);

MATCH (d:Person {name: "Quentin Tarantino"}) 
MATCH (m:Movie {title: "Once Upon a Time in Hollywood"})
MERGE (d)-[:DIRECTED]->(m);

MATCH (d:Person {name: "Lana Wachowski"}) 
MATCH (m:Movie {title: "The Matrix Resurrections"})
MERGE (d)-[:DIRECTED]->(m);

MATCH (d:Person {name: "James Gunn"})
MATCH (m:Movie {title: "Furiosa: A Mad Max Saga"})
MERGE (d)-[:DIRECTED]->(m);

MATCH (d:Person {name: "Yorgos Lanthimos"}) 
MATCH (m:Movie {title: "Poor Things"}) 
MERGE (d)-[:DIRECTED]->(m);

MATCH (d:Person {name: "Matt Reeves"}) 
MATCH (m:Movie {title: "The Batman"})
MERGE (d)-[:DIRECTED]->(m);


//Ator: Filme
MATCH (a:Person {name: "Keanu Reeves"})
MATCH (m:Movie {title: "The Matrix Resurrections"})
MERGE (a)-[:ACTED_IN]->(m);
MATCH (a:Person {name: "Scarlett Johansson"})
MATCH (m:Movie {title: "Oppenheimer"})
MERGE (a)-[:ACTED_IN]->(m);
MATCH (a:Person {name: "Leonardo DiCaprio"})
MATCH (m:Movie {title: "Once Upon a Time in Hollywood"})
MERGE (a)-[:ACTED_IN]->(m);

//Diretor: Serie
MATCH (d:Person {name: "Denis Villeneuve"}) 
MATCH (s:Series {title: "Dune: Part Two"})
MERGE (d)-[:DIRECTED]->(s);

//Ator: Serie
MATCH (a:Person {name: "Zendaya"})
MATCH (s:Series {title: "Dune: Part Two"})
MERGE (a)-[:ACTED_IN]->(s);

//usuarios avaliaram filmes e series
MATCH (u:User {username: "cinefan_br"})
MATCH (m:Movie {title: "Oppenheimer"})
MERGE (u)-[:RATED {rating: 9.5, review: "Um filme incrível que mistura história e emoção de forma magistral."}]->(m);
MATCH (u:User {username: "maratonista99"})
MATCH (s:Series {title: "The Last of Us"})   
MERGE (u)-[:RATED {rating: 9.0, review: "Uma série envolvente com personagens profundos e uma trama emocionante."}]->(s);
MATCH (u:User {username: "scifi_louca"})
MATCH (s:Series {title: "Andor"})
MERGE (u)-[:RATED {rating: 8.5, review: "Uma adição fantástica ao universo Star Wars, com uma narrativa sombria e cativante."}]->(s);
MATCH (u:User {username: "barbiecore"})
MATCH (m:Movie {title: "Barbie"})
MERGE (u)-[:RATED {rating: 7.5, review: "Um filme divertido e visualmente deslumbrante que celebra a cultura pop."}]->(m);