/* 
-   Van een serie wil ik volgende data kunnen bijhouden: Naam, Aantal seizoenen, Aantal afleveringen per seizoen (gemiddeld), De duur van een aflevering in seconden, 
    En op welke streamingdienst ze natuurlijk overal te bekijken is
    
    CREATE TABLE streaming_services (
    id INT AUTO_INCREMENT,  
    name VARCHAR (255) NOT NULL,    // je moet altijd een naam invullen
    monthly_price DECIMAL (5,2),    // max. 5 cijfers en max. 2 cijfers na de komma
    subscription_start DATE,
    is_active BOOLEAN,  // kan alleen true of false zijn
    PRIMARY KEY (id)
    ) ;

-   Een streamingdienst kan meerdere series hebben en een serie kan natuurlijk op meerdere platformen bestaan. Van een serie wil ik volgende data kunnen bijhouden: Naam, Aantal seizoenen, 
    Aantal afleveringen per seizoen (gemiddeld), De duur van een aflevering in seconden, En op welke streamingdienst ze natuurlijk overal te bekijken is

    CREATE TABLE series (id INT AUTO_INCREMENT,
    name VARCHAR (255) NOT NULL, // je moet altijd een naam invullen
    number_of_seasons INT,  
    episodes_per_season INT,
    episode_duration_seconds INT,
    PRIMARY KEY (id)
    ) ;

    +

    CREATE TABLE series_streaming_service (
    id INT AUTO_INCREMENT ,
    series_id INT NOT NULL,
    streaming_service_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (series_id) REFERENCES series(id),
    FOREIGN KEY (streaming_service_id) REFERENCES streaming_services(id)
    );  
    --> many-to-many relatie

-   Elke serie kan ook een rating krijgen. Een serie kan meerdere ratings hebben maar één rating hangt natuurlijk steeds vast aan maar één serie.Voor een rating wil ik volgende data
    kunnen bijhouden. De score op 5 (Kan ook bvb: 4 en een half zijn)

    CREATE TABLE ratings (
    id INT AUTO_INCREMENT,
    series_id INT NOT NULL, 
    score DECIMAL (2,1),    // max. 2 cijfers en max. 1 cijfer na de komma
    PRIMARY KEY (id),
    FOREIGN KEY (series_id) REFERENCES series(id)
    );
    --> one-to-many relatie
    
-   Er moeten ook gebruikers worden toegevoegd aan de database van elke gebruiker willen we het volgende opslagen: Email, username, volledige naam, of hij actief is of niet, 
    Hoelang hij al lid is van onze applicatie, Hoe oud de gebruiker is.

    CREATE TABLE users (
    id INT AUTO_INCREMENT,
    mail VARCHAR (255) UNIQUE,  // niemand heeft hetzelfde email adres
    username VARCHAR (255) NOT NULL UNIQUE, // niemand kan dezelfde username hebben
    full_name VARCHAR (255) NOT NULL,
    is_active BOOLEAN DEFAULT false, // als ze niets invullen gaat het automatisch op false gezet worden
    member_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP, // als er niets wordt ingevoerd gaan ze de huidige datum invullen
    age INT,
    PRIMARY KEY (id)
    );

-   Aan elke rating moet nu een gebruiker gelinkt worden. Een gebruiker kan meerdere ratings hebben maar één rating kan uiteraard maar één gebruiker hebben.

    ALTER TABLE ratings
    ADD COLUMN user_id INT NOT NULL,
    ADD CONSTRAINT FK_user FOREIGN KEY (user_id) REFERENCES users (id);
    --> one-to-one relatie

-   Alle ratings die 1 gebruiker heeft gegeven

    SELECT ratings.id, series.name AS series_name, ratings.score
    FROM ratings
    JOIN series ON ratings.series_id = series.id
    WHERE ratings.user_id = 1;

-   De gemiddelde rating van elke serie

    SELECT series.name AS series_name, AVG(ratings.score) AS average_rating     // AVG = het gemiddelde berekenen
    FROM ratings
    JOIN series ON ratings.series_id = series.id
    GROUP BY series.id, series.name;

*/