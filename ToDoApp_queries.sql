/* To Do App

-   Geef de query voor het aanmaken van een database voor deze app
    CREATE DATABANK to do

-   Leg uit welke datatypes je voor welke kolom zou gebruiken en waarom?
    id (INT), want je gebruikt hier enkel nummers (oplopend)
    name (VARCHAR(255)), want je kan hier een hele lange titel geven met tekst. De 255 is om het maximum aantal letters weer te geven.
    isCompleted (BOOLEAN), want het antwoord kan alleen maar juist of fout zijn
    deadline (DATE), want een deadline is altijd een datum dat je invoert
    created_at (TIMESTAMP), want hiermee kan je automatish het huidige tijdstip mee opslaan.
    priority (INT), want dit dient om de positie op te slagen en je kan dit het makkelijkste sorteren met een INT.

-   Geef de query voor het aanmaken van de tabel
    CREATE table ToDo (
    id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    isCompleted BOOLEAN NOT NULL DEFAULT FALSE,
    deadline DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    priority INT DEFAULT 0,
    PRIMARY KEY (id)
    );

-   Geef de query voor de extra kolom die aangeeft of er een melding verstuurd moet worden.
    ALTER TABLE todo ADD notification_sent BOOLEAN NOT NULL DEFAULT FALSE;

-   Geef de query voor de extra kolom waar je optioneel een kleur kan ingeven.
    ALTER TABLE todo ADD color VARCHAR(255) NULL;

-   Verwijder de kolom priority
    ALTER TABLE todo DROP COLUMN priority;

-   Hoe zou je dit aanpakken op de beste manier die we gezien hebben in de les en volgens de regels van een RDBMS
    Het gaat hier over een One-To-Many relatie. Ik zou een aparte tabel maken genaam Category. 
    In deze tabel sla ik de naam van elke categorie op in een kolom name, die verplicht moet ingevuld worden.
    Hierdoor kan ik voor elke to do een categorie koppelen via een nieuwe kolom genaam category_id in de todo tabel. 
    Deze kolom wordt een foreign key die verwijst naar de id van de category.
    
-   Geef alle queries die je gebruikt om de categorieën te implementeren in je database.
        *   CREATE TABLE category(
            id INT AUTO_INCREMENT,
            name VARCHAR(250) NOT NULL,
            PRIMARY KEY (id)
            );  
        
        *   ALTER TABLE todo ADD category_id INT NOT NULL;

        *   ALTER TABLE todo
            ADD CONSTRAINT FK_todo_category
            FOREIGN KEY (category_id) REFERENCES category(id);
   
   
-   Als een categorie verwijderd wordt moeten logischerwijs ook alle todo's van deze categorie verwijderd worden. Hoe zou je dat doen?
    ALTER TABLE todo
    ADD CONSTRAINT FK_todo_category
    FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE;


Subscriber toevoegen

-   Geef per tabel welke kolommen je zou gebruiken met welke types & beperkingen en waarom?
    Bij tabel subscriber:
    id (INT AUTO_INCREMENT): Dit is de primary key en is uniek per subscriber
    email (VARCHAR (255)) NOT NULL: Een email gaat nooit meer dan 255 karakters hebben. En een subcriber moet een geldig e-mailadres invoeren.
    phone_number (VARCHAR (20)) NOT NULL: Een telefoonnummer kan nooit meer dan 20 karakters hebben, anders is het niet geldig. 
    contact_method(ENUM ('email', 'phone', both') NOT NULL): Ik beperk het tot drie opties zodat het duidelijk is uit wat je kan kiezen en dat het niet NULL kan zijn.

    Bij tabel todo_subscriber
    todo_id (INT NOT NULL): Het verwijst naar de todo tabel
    subscriber_id (INT NOT NULL): Het verwijst naar de subscriber tabel

-   Geef alle queries die je gebruikt om de subscribers te implementeren in je database
        *   CREATE TABLE subscriber (
            id INT AUTO_INCREMENT,
            email VARCHAR (255) NOT NULL,
            phone_number VARCHAR (20) NOT NULL,
            contact_method ENUM ('email', 'phone', 'both') NOT NULL DEFAULT 'phone',
            PRIMARY KEY (id)
            );

        *   CREATE TABLE todo_subscriber (
            todo_id INT NOT NULL,
            subscriber_id INT NOT NULL,
            PRIMARY KEY (todo_id, subscriber_id),
            FOREIGN KEY (todo_id) REFERENCES todo(id) ON DELETE CASCADE,
            FOREIGN KEY (subscriber_id) REFERENCES subscriber(id) ON DELETE CASCADE
            );

-   Als een subscriber verwijderd word moeten de todo's blijven bestaan. Heb je daar opmerkingen over? Hoe zou je dat aanpakken?
    Ik zou enkel ON DELETE CASCADE achter de subscriber zetten.
    CREATE TABLE ToDo_Subscriber (
    todo_id INT NOT NULL,
    subscriber_id INT NOT NULL,
    PRIMARY KEY (todo_id, subscriber_id),
    FOREIGN KEY (todo_id) REFERENCES todo(id), 
    FOREIGN KEY (subscriber_id) REFERENCES subscriber(id) ON DELETE CASCADE);

-   Haal alle subscribers op voor een todo (Email van subscriber, Titel van todo)
    SELECT
    Subscriber.email AS subscriber_email,
    ToDo.name AS subscriber_todo
    FROM Subscriber
    INNER JOIN ToDo_Subscriber ON Subscriber.id = ToDo_Subscriber.subscriber_id
    INNER JOIN ToDo ON ToDo_Subscriber.todo_id = ToDo.id;
    
-   Haal alle subscribers op met hun todo. Als een subscriber geen todo heeft moet deze ook in het resultaat zitten.
    SELECT
    Subscriber.email AS subscriber_email,
    ToDo.name AS subscriber_todo
    FROM Subscriber
    LEFT JOIN ToDo_Subscriber ON Subscriber.id = ToDo_Subscriber.subscriber_id
    LEFT JOIN ToDo ON ToDo_Subscriber.todo_id = ToDo.id;
    
-   Haal todo's en hun categorie op. 
    SELECT
    ToDo.name AS todo_title,
    Category.name AS category_name
    FROM ToDo
    INNER JOIN Category ON ToDo.category_id = Category.id;

-   Haal alle todo's op ongeacht of ze een categorie hebben of niet. (Dan mag er NULL komen te staan)
    SELECT
    ToDo.name AS todo_title,
    Category.name AS category_name
    FROM ToDo
    LEFT JOIN Category ON ToDo.category_id = Category.id;
