-- Creacion de la BD.
CREATE DATABASE pokedex;
USE pokedex;

-- Limpieza de las tablas antes de insertar
DROP TABLE IF EXISTS Pertenece;
DROP TABLE IF EXISTS MovimientoAprendido;
DROP TABLE IF EXISTS PokemonAtrapado;
DROP TABLE IF EXISTS Agrupacion;
DROP TABLE IF EXISTS Entrenador;

DROP TABLE IF EXISTS Baya;
DROP TABLE IF EXISTS Comida;
DROP TABLE IF EXISTS Naturaleza;
DROP TABLE IF EXISTS Sabor;

DROP TABLE IF EXISTS Huevos, Habitat, Ventaja, Aprendizaje, Evolucion,
     GrupoHuevo, Movimiento, Zona, Pokemon, HabilidadPasiva, Tipo;

-- Info de Pokemon
CREATE TABLE Tipo(
       Nombre VARCHAR(20),

       CONSTRAINT tipo_pk PRIMARY KEY (Nombre)
);

CREATE TABLE Zona(
       Id INT AUTO_INCREMENT,
       Nombre VARCHAR(30),

       CONSTRAINT zona_pk PRIMARY KEY (Id)
);

CREATE TABLE HabilidadPasiva(
       Nombre VARCHAR(30),
       Descripcion VARCHAR(256),

       CONSTRAINT pasiva_pk PRIMARY KEY (Nombre)
);

CREATE TABLE Pokemon(
       Numero INT,
       Nombre VARCHAR(30) NOT NULL,
       Altura FLOAT NOT NULL,
       Peso FLOAT NOT NULL,
       Descripcion VARCHAR(256) NOT NULL,
       Clase VARCHAR(30) NOT NULL,
       Tipo1 VARCHAR(20) NOT NULL,
       Tipo2 VARCHAR(20) DEFAULT NULL,
       Pasiva1 VARCHAR(30) NOT NULL,
       Pasiva2 VARCHAR(30) DEFAULT NULL,

       CONSTRAINT poke_pk PRIMARY KEY (Numero),
       CONSTRAINT elemento1 FOREIGN KEY (Tipo1) REFERENCES Tipo(Nombre) ON UPDATE CASCADE,
       CONSTRAINT elemento2 FOREIGN KEY (Tipo2) REFERENCES Tipo(Nombre) ON UPDATE CASCADE,
       CONSTRAINT primeraPasiva FOREIGN KEY (pasiva1) REFERENCES HabilidadPasiva(Nombre) ON UPDATE CASCADE,
       CONSTRAINT segundaPasiva FOREIGN KEY (pasiva2) REFERENCES HabilidadPasiva(Nombre) ON UPDATE CASCADE
);

CREATE TABLE Evolucion(
       NumeroOrigen INT,
       NumeroDestino INT,
       Metodo VARCHAR(30) NOT NULL,

       CONSTRAINT evol_pk PRIMARY KEY (NumeroOrigen, NumeroDestino),
       CONSTRAINT origen FOREIGN KEY (NumeroOrigen) REFERENCES Pokemon(Numero) ON UPDATE CASCADE,
       CONSTRAINT destino FOREIGN KEY (NumeroDestino) REFERENCES Pokemon(Numero) ON UPDATE CASCADE
);

CREATE TABLE Movimiento(
       Nombre VARCHAR(30),
       PP INT DEFAULT 40,
       Categoria VARCHAR(50) NOT NULL,
       Aprendizaje VARCHAR(30) NOT NULL,
       Tipo VARCHAR(30),

       CONSTRAINT mov_pk PRIMARY KEY (Nombre),
       CONSTRAINT tipoMovimiento FOREIGN KEY (Tipo) REFERENCES Tipo(Nombre) ON UPDATE CASCADE
       
);

CREATE TABLE GrupoHuevo(
       Nombre VARCHAR(30) PRIMARY KEY
);

CREATE TABLE Huevos(
       Numero INT,
       Grupo VARCHAR(30),

       CONSTRAINT eggs_pk PRIMARY KEY (Numero, Grupo),
       CONSTRAINT pokeHuevo FOREIGN KEY (Numero) REFERENCES Pokemon(Numero) ON UPDATE CASCADE,
       CONSTRAINT huevo FOREIGN KEY (Grupo) REFERENCES GrupoHuevo(Nombre) ON UPDATE CASCADE
);

CREATE TABLE Aprendizaje(
       Numero INT,
       Movimiento VARCHAR(30),

       CONSTRAINT learn_pk PRIMARY KEY (Numero, Movimiento),
       CONSTRAINT pokeMov FOREIGN KEY (Numero) REFERENCES Pokemon(Numero) ON UPDATE CASCADE,
       CONSTRAINT mov FOREIGN KEY (Movimiento) REFERENCES Movimiento(Nombre) ON UPDATE CASCADE
);

CREATE TABLE Ventaja(
       TipoVentaja VARCHAR(20),
       TipoDesventaja VARCHAR(20),
       Efecto VARCHAR(30) NOT NULL,

       CONSTRAINT ventaja_pk PRIMARY KEY (TipoVentaja, TipoDesventaja),
       CONSTRAINT elemVentaja FOREIGN KEY (TipoVentaja) REFERENCES Tipo(Nombre) ON UPDATE CASCADE,
       CONSTRAINT elemDesventaja FOREIGN KEY (TipoDesventaja) REFERENCES Tipo(Nombre) ON UPDATE CASCADE
);

CREATE TABLE Habitat(
       Numero INT,
       Zona INT,

       CONSTRAINT hab_pk PRIMARY KEY (Numero, Zona),
       CONSTRAINT pokeZona FOREIGN KEY (Numero) REFERENCES Pokemon(Numero) ON UPDATE CASCADE,
       CONSTRAINT lugar FOREIGN KEY (Zona) REFERENCES Zona(Id) ON UPDATE CASCADE
);

-- Alimentos
CREATE TABLE Sabor(
       Tipo VARCHAR(30) PRIMARY KEY
);

CREATE TABLE Comida(
       Id INT,
       Tipo VARCHAR(30),
       Efecto VARCHAR(256),
       Sabor VARCHAR(30),

       CONSTRAINT food_pk PRIMARY KEY (Id),
       CONSTRAINT foodFlavor FOREIGN KEY (Sabor) REFERENCES Sabor(Tipo)
);

CREATE TABLE Baya(
       Id INT,
       Nombre VARCHAR(30),
       Efecto VARCHAR(256),
       Sabor VARCHAR(30),

       CONSTRAINT berry_pk PRIMARY KEY (Id),
       CONSTRAINT berryFlavor FOREIGN KEY (Sabor) REFERENCES Sabor(Tipo)
);

CREATE TABLE Naturaleza(
       Nombre VARCHAR(30),
       Gusto VARCHAR(30),
       Disgusto VARCHAR(30),

       CONSTRAINT nature_pk PRIMARY KEY (Nombre),
       CONSTRAINT likes FOREIGN KEY (Gusto) REFERENCES Sabor(Tipo),
       CONSTRAINT dislikes FOREIGN KEY (Disgusto) REFERENCES Sabor(Tipo)
);

-- Entrenadores
CREATE TABLE Entrenador(
       Id INT,
       Nombre VARCHAR(30) NOT NULL,
       Medallas INT DEFAULT 0,

       CONSTRAINT trainer_id PRIMARY KEY (Id)
);

CREATE TABLE Agrupacion(
       Id INT,
       Nombre VARCHAR(30) NOT NULL,

       CONSTRAINT org_id PRIMARY KEY (Id)
);

CREATE TABLE PokemonAtrapado(
       Id INT,
       Nombre VARCHAR(30) NOT NULL,
       Numero INT NOT NULL,
       Naturaleza VARCHAR(30),
       Habilidad VARCHAR(30),
       Genero VARCHAR(10) NOT NULL,
       HP INT,
       Atk INT,
       Def INT,
       SpAtk INT,
       SpDef INT,
       Velocidad INT,
       Nivel INT NOT NULL DEFAULT 1,
       Experiencia INT NOT NULL DEFAULT 0,
       IdEntrenador INT NOT NULL,
       AtrapadoEn INT NOT NULL,

       CONSTRAINT trapped_pk PRIMARY KEY (Id),
       CONSTRAINT poke_number FOREIGN KEY (Numero) REFERENCES Pokemon(Numero),
       CONSTRAINT nature_value FOREIGN KEY (Naturaleza) REFERENCES Naturaleza(Nombre),
       CONSTRAINT skill FOREIGN KEY (Habilidad) REFERENCES HabilidadPasiva(Nombre),
       CONSTRAINT trainer_fk FOREIGN KEY (IdEntrenador) REFERENCES Entrenador(Id),
       CONSTRAINT catch_fk FOREIGN KEY (AtrapadoEn) REFERENCES Zona(Id) ON UPDATE CASCADE
);
    
CREATE TABLE MovimientoAprendido(
       Id INT,
       Nombre VARCHAR(30),

       CONSTRAINT learned_pk PRIMARY KEY (Id, Nombre),
       CONSTRAINT thePoke_id_fk FOREIGN KEY (Id) REFERENCES PokemonAtrapado(Id),
       CONSTRAINT theMove_id_fk FOREIGN KEY (Nombre) REFERENCES Movimiento(Nombre)
);

CREATE TABLE Pertenece(
       IdEntrenador INT,
       IdAgrupacion INT,
       Posicion VARCHAR(30),

       CONSTRAINT affiliation_pk PRIMARY KEY (IdEntrenador, IdAgrupacion),
       CONSTRAINT trainerId_fk FOREIGN KEY (IdEntrenador) REFERENCES Entrenador(Id),
       CONSTRAINT orgId_fk FOREIGN KEY (IdAgrupacion) REFERENCES Agrupacion(Id)
);


INSERT INTO Tipo
VALUES
	("Normal"),
	("Fire"),
	("Fighting"),
 	("Water"),
	("Flying"),
 	("Grass"),
	("Poison"),
 	("Electric"),
	("Ground"),
 	("Psychic"),
	("Rock"),
 	("Ice"),
	("Bug"),
 	("Dragon"),
	("Ghost"),
 	("Dark"),
	("Steel"),
 	("Fairy");

INSERT INTO Zona (Nombre) VALUES ("Route 101"),
       ("Route 102"),
       ("Route 103"),
       ("Route 104"),
       ("Route 105"),
       ("Route 106"),
       ("Route 107"),
       ("Route 108"),
       ("Route 109"),
       ("Route 110"),
       ("Route 111"),
       ("Route 112"),
       ("Route 113"),
       ("Route 114"),
       ("Route 115"),
       ("Route 116"),
       ("Route 117"),
       ("Route 118"),
       ("Route 119"),
       ("Route 120"),
       ("Route 121"),
       ("Route 122"),
       ("Route 123"),
       ("Route 124"),
       ("Route 125"),
       ("Route 126"),
       ("Route 127"),
       ("Route 128"),
       ("Route 129"),
       ("Route 130"),
       ("Route 131"),
       ("Route 132"),
       ("Route 133"),
       ("Route 134"),
       ("Mt. Pyre"),
       ("Cave of Origin");

INSERT INTO HabilidadPasiva VALUES ("Air Lock", "Eliminates the effects of weather."),
        ("Arena Trap", "Prevents opposing Pokemon from fleeing."),
        ("Battle Armor", "Hard armor protects the Pokemon from critical hits."),
        ("Blaze", "Powers up Fire-type moves when the Pokemon's HP is low."),
        ("Cacophony", "Avoids sound-based moves."),
        ("Chlorophyll", "Boosts the Pokemon's Speed stat in harsh sunlight."),
        ("Clear Body", "Prevents other Pokemon's moves or Abilities from lowering the Pokemon's stats."),
        ("Cloud Nine", "Eliminates the effects of weather."),
        ("Color Change", "The Pokemon's type becomes the type of the move used on it."),
        ("Compound Eyes", "The Pokemon's compound eyes boost its accuracy."),
        ("Cute Charm", "Contact with the Pokemon may cause infatuation."),
        ("Damp", "Prevents the use of explosive moves, such as Self-Destruct, by dampening its surroundings."),
        ("Drizzle", "The Pokemon makes it rain when it enters a battle."),
        ("Drought", "Turns the sunlight harsh when the Pokemon enters a battle."),
        ("Early Bird", "The Pokemon awakens from sleep twice as fast as other Pokemon."),
        ("Effect Spore", "Contact with the Pokemon may inflict poison, sleep, or paralysis on its attacker."),
        ("Flame Body", "Contact with the Pokemon may burn the attacker."),
        ("Flash Fire", "Powers up the Pokemon's Fire-type moves if it's hit by one."),
        ("Forecast", "The Pokemon transforms with the weather to change its type to Water, Fire, or Ice."),
        ("Guts", "It's so gutsy that having a status condition boosts the Pokemon's Attack stat."),
        ("Huge Power", "Doubles the Pokemon's Attack stat."),
        ("Hustle", "Boosts the Attack stat, but lowers accuracy."),
        ("Hyper Cutter", "The Pokemon's proud of its powerful pincers. They prevent other Pokemon from lowering its Attack stat."),
        ("Illuminate", "Raises the likelihood of meeting wild Pokemon by illuminating the surroundings."),
        ("Immunity", "The immune system of the Pokemon prevents it from getting poisoned."),
        ("Inner Focus", "The Pokemon's intensely focused, and that protects the Pokemon from flinching."),
        ("Insomnia", "The Pokemon is suffering from insomnia and cannot fall asleep."),
        ("Intimidate", "The Pokemon intimidates opposing Pokemon upon entering battle, lowering their Attack stat."),
        ("Keen Eye", "Keen eyes prevent other Pokemon from lowering this Pokemon's accuracy."),
        ("Levitate", "By floating in the air, the Pokemon receives full immunity to all Ground-type moves."),
        ("Lightning Rod", "The Pokemon draws in all Electric-type moves. Instead of being hit by Electric-type moves, it boosts its Sp. Atk."),
        ("Limber", "Its limber body protects the Pokemon from paralysis."),
        ("Liquid Ooze", "The oozed liquid has a strong stench, which damages attackers using any draining move."),
        ("Magma Armor", "The Pokemon is covered with hot magma, which prevents the Pokemon from becoming frozen."),
        ("Magnet Pull", "Prevents Steel-type Pokemon from escaping using its magnetic force."),
        ("Marvel Scale", "The Pokemon's marvelous scales boost the Defense stat if it has a status condition."),
        ("Minus", "Boosts the Sp. Atk stat of the Pokemon if an ally with the Plus or Minus Ability is also in battle."),
        ("Natural Cure", "All status conditions heal when the Pokemon switches out."),
        ("Oblivious", "The Pokemon is oblivious, and that keeps it from being infatuated or falling for taunts."),
        ("Overgrow", "Powers up Grass-type moves when the Pokemon's HP is low."),
        ("Own Tempo", "This Pokemon has its own tempo, and that prevents it from becoming confused."),
        ("Pickup", "The Pokemon may pick up the item an opposing Pokemon used during a battle. It may pick up items outside of battle, too."),
        ("Plus", "Boosts the Sp. Atk stat of the Pokemon if an ally with the Plus or Minus Ability is also in battle."),
        ("Poison Point", "Contact with the Pokemon may poison the attacker."),
        ("Pressure", "By putting pressure on the opposing Pokemon, it raises their PP usage."),
        ("Pure Power", "Using its pure power, the Pokemon doubles its Attack stat."),
        ("Rain Dish", "The Pokemon gradually regains HP in rain."),
        ("Rock Head", "Protects the Pokemon from recoil damage."),
        ("Rough Skin", "This Pokemon inflicts damage with its rough skin to the attacker on contact."),
        ("Run Away", "Enables a sure getaway from wild Pokemon."),
        ("Sand Stream", "The Pokemon summons a sandstorm when it enters a battle."),
        ("Sand Veil", "Boosts the Pokemon's evasiveness in a sandstorm."),
        ("Serene Grace", "Boosts the likelihood of additional effects occurring when attacking."),
        ("Shadow Tag", "This Pokemon steps on the opposing Pokemon's shadow to prevent it from escaping."),
        ("Shed Skin", "The Pokemon may heal its own status conditions by shedding its skin."),
        ("Shell Armor", "A hard shell protects the Pokemon from critical hits."),
        ("Shield Dust", "This Pokemon's dust blocks the additional effects of attacks taken."),
        ("Soundproof", "Soundproofing gives the Pokemon full immunity to all sound-based moves."),
        ("Speed Boost", "Its Speed stat is boosted every turn."),
        ("Static", "The Pokemon is charged with static electricity, so contact with it may cause paralysis."),
        ("Stench", "By releasing stench when attacking, this Pokemon may cause the target to flinch."),
        ("Sticky Hold", "Items held by the Pokemon are stuck fast and cannot be removed by other Pokemon."),
        ("Sturdy", "It cannot be knocked out with one hit. One-hit KO moves cannot knock it out, either."),
        ("Suction Cups", "This Pokemon uses suction cups to stay in one spot to negate all moves and items that force switching out."),
        ("Swarm", "Powers up Bug-type moves when the Pokemon's HP is low."),
        ("Swift Swim", "Boosts the Pokemon's Speed stat in rain."),
        ("Synchronize", "The attacker will receive the same status condition if it inflicts a burn, poison, or paralysis to the Pokemon."),
        ("Thick Fat", "The Pokemon is protected by a layer of thick fat, which halves the damage taken from Fire- and Ice-type moves."),
        ("Torrent", "Powers up Water-type moves when the Pokemon's HP is low."),
        ("Trace", "When it enters a battle, the Pokemon copies an opposing Pokemon's Ability."),
        ("Truant", "The Pokemon can't use a move if it had used a move on the previous turn."),
        ("Vital Spirit", "The Pokemon is full of vitality, and that prevents it from falling asleep."),
        ("Volt Absorb", "Restores HP if hit by an Electric-type move instead of taking damage."),
        ("Water Absorb", "Restores HP if hit by a Water-type move instead of taking damage."),
        ("Water Veil", "The Pokemon is covered with a water veil, which prevents the Pokemon from getting a burn."),
        ("White Smoke", "The Pokemon is protected by its white smoke, which prevents other Pokemon from lowering its stats."),
        ("Wonder Guard", "Its mysterious power only lets supereffective moves hit the Pokemon.");

INSERT INTO Pokemon VALUES (001, "Treecko", 0.5, 5.0, "", "", "Grass", NULL, "Overgrow", NULL),
(002, "Grovyle", 0.9, 21.6, "", "", "Grass", NULL, "Overgrow", NULL),
(003, "Sceptile", 1.7, 52.2, "", "", "Grass", NULL, "Overgrow", NULL),
(004, "Torchic", 0.4, 2.5, "", "", "Fire", NULL, "Blaze", NULL),
(005, "Combusken", 0.9, 19.5, "", "", "Fire ", "Fighting", "Blaze", NULL),
(006, "Blaziken", 1.9, 52.0, "", "", "Fire ", "Fighting", "Blaze", NULL),
(007, "Mudkip", 0.4, 7.6, "", "", "Water", NULL, "Torrent", NULL),
(008, "Marshtomp", 0.7, 28.0, "", "", "Water ", "Ground", "Torrent", NULL),
(009, "Swampert", 1.5, 81.9, "", "", "Water ", "Ground", "Torrent", NULL),
(010, "Poochyena", 0.5, 13.6, "", "", "Dark", NULL, "Run Away", NULL),
(011, "Mightyena", 1.0, 37.0, "", "", "Dark", NULL, "Intimidate", NULL),
(012, "Zigzagoon", 0.4, 17.5, "", "", "Normal", NULL, "Pickup", NULL),
(013, "Linoone", 0.5, 32.5, "", "", "Normal", NULL, "Pickup", NULL),
(014, "Wurmple", 0.3, 3.6, "", "", "Bug", NULL, "Shield Dust", NULL),
(015, "Silcoon", 0.6, 10.0, "", "", "Bug", NULL, "Shed Skin", NULL),
(016, "Beautifly", 1.0, 28.4, "", "", "Bug ", "Flying", "Swarm", NULL),
(017, "Cascoon", 0.7, 11.5, "", "", "Bug", NULL, "Shed Skin", NULL),
(018, "Dustox", 1.2, 31.6, "", "", "Bug ", "Poison", "Shield Dust", NULL),
(019, "Lotad", 0.5, 2.6, "", "", "Water ", "Grass", "Rain Dish", "Swift Swim"),
(020, "Lombre", 1.2, 32.5, "", "", "Water ", "Grass", "Rain Dish", "Swift Swim"),
(021, "Ludicolo", 1.5, 55.0, "", "", "Water ", "Grass", "Rain Dish", "Swift Swim"),
(022, "Seedot", 0.5, 4.0, "", "", "Grass", NULL, "Chlorophyll", "Early Bird"),
(023, "Nuzleaf", 1.0, 28.0, "", "", "Grass ", "Dark", "Chlorophyll", "Early Bird"),
(024, "Shiftry", 1.3, 59.6, "", "", "Grass ", "Dark", "Chlorophyll", "Early Bird"),
(025, "Taillow", 0.3, 2.3, "", "", "Normal ", "Flying", "Guts", NULL),
(026, "Swellow", 0.7, 19.8, "", "", "Normal ", "Flying", "Guts", NULL),
(027, "Wingull", 0.6, 9.5, "", "", "Water ", "Flying", "Keen Eye", NULL),
(028, "Pelipper", 1.2, 28.0, "", "", "Water ", "Flying", "Keen Eye", NULL),
(029, "Ralts", 0.4, 6.6, "", "", "Psychic", NULL, "Synchronize", "Trace"),
(030, "Kirlia", 0.8, 20.2, "", "", "Psychic", NULL, "Synchronize", "Trace"),
(031, "Gardevoir", 1.6, 48.4, "", "", "Psychic", NULL, "Synchronize", "Trace"),
(032, "Surskit", 0.5, 1.7, "", "", "Bug ", "Water", "Swift Swim", NULL),
(033, "Masquerain", 0.8, 3.6, "", "", "Bug ", "Flying", "Intimidate", NULL),
(034, "Shroomish", 0.4, 4.5, "", "", "Grass", NULL, "Effect Spore", NULL),
(035, "Breloom", 1.2, 39.2, "", "", "Grass ", "Fighting", "Effect Spore", NULL),
(036, "Slakoth", 0.8, 24.0, "", "", "Normal", NULL, "Truant", NULL),
(037, "Vigoroth", 1.4, 46.5, "", "", "Normal", NULL, "Vital Spirit", NULL),
(038, "Slaking", 2.0, 130.5, "", "", "Normal", NULL, "Truant", NULL),
(039, "Abra", 0.9, 19.5, "", "", "Psychic", NULL, "Inner Focus", "Synchronize"),
(040, "Kadabra", 1.3, 56.5, "", "", "Psychic", NULL, "Inner Focus", "Synchronize"),
(041, "Alakazam", 1.5, 48.0, "", "", "Psychic", NULL, "Inner Focus", "Synchronize"),
(042, "Nincada", 0.5, 5.5, "", "", "Bug ", "Ground", "Compound Eyes", NULL),
(043, "Ninjask", 0.8, 12.0, "", "", "Bug ", "Flying", "Speed Boost", NULL),
(044, "Shedinja", 0.8, 1.2, "", "", "Bug ", "Ghost", "Wonder Guard", NULL),
(045, "Whismur", 0.6, 16.3, "", "", "Normal", NULL, "Soundproof", NULL),
(046, "Loudred", 1.0, 40.5, "", "", "Normal", NULL, "Soundproof", NULL),
(047, "Exploud", 1.5, 84.0, "", "", "Normal", NULL, "Soundproof", NULL),
(048, "Makuhita", 1.0, 86.4, "", "", "Fighting", NULL, "Guts", "Thick Fat"),
(049, "Hariyama", 2.3, 253.8, "", "", "Fighting", NULL, "Guts", "Thick Fat"),
(050, "Goldeen", 0.6, 15.0, "", "", "Water", NULL, "Swift Swim", "Water Veil"),
(051, "Seaking", 1.3, 39.0, "", "", "Water", NULL, "Swift Swim", "Water Veil"),
(052, "Magikarp", 0.9, 10.0, "", "", "Water", NULL, "Swift Swim", NULL),
(053, "Gyarados", 6.5, 235.0, "", "", "Water ", "Flying", "Intimidate", NULL),
(054, "Azurill", 0.2, 2.0, "", "", "Normal", NULL, "Huge Power", "Thick Fat"),
(055, "Marill", 0.4, 8.5, "", "", "Water", NULL, "Huge Power", "Thick Fat"),
(056, "Azumarill", 0.8, 28.5, "", "", "Water", NULL, "Huge Power", "Thick Fat"),
(057, "Geodude", 0.4, 20.0, "", "", "Rock ", "Ground", "Rock Head", "Sturdy"),
(058, "Graveler", 1.0, 105.0, "", "", "Rock ", "Ground", "Rock Head", NULL),
(059, "Golem", 1.4, 300.0, "", "", "Rock ", "Ground", "Rock Head", "Sturdy"),
(060, "Nosepass", 1.0, 97.0, "", "", "Rock", NULL, "Magnet Pull", "Sturdy"),
(061, "Skitty", 0.6, 11.0, "", "", "Normal", NULL, "Cute Charm", NULL),
(062, "Delcatty", 1.1, 32.6, "", "", "Normal", NULL, "Cute Charm", NULL),
(063, "Zubat", 0.8, 7.5, "", "", "Poison ", "Flying", "Inner Focus", NULL),
(064, "Golbat", 1.6, 55.0, "", "", "Poison ", "Flying", "Inner Focus", NULL),
(065, "Crobat", 1.8, 75.0, "", "", "Poison ", "Flying", "Inner Focus", NULL),
(066, "Tentacool", 0.9, 45.5, "", "", "Water ", "Poison", "Clear Body", "Liquid Ooze"),
(067, "Tentacruel", 1.6, 55.0, "", "", "Water ", "Poison", "Clear Body", "Liquid Ooze"),
(068, "Sableye", 0.5, 11.0, "", "", "Dark ", "Ghost", "Keen Eye", NULL),
(069, "Mawile", 0.6, 11.5, "", "", "Steel", NULL, "Hyper Cutter", "Intimidate"),
(070, "Aron", 0.4, 60.0, "", "", "Steel ", "Rock", "Rock Head", "Sturdy"),
(071, "Lairon", 0.9, 120.0, "", "", "Steel ", "Rock", "Rock Head", "Sturdy"),
(072, "Aggron", 2.1, 360.0, "", "", "Steel ", "Rock", "Rock Head", "Sturdy"),
(073, "Machop", 0.8, 19.5, "", "", "Fighting", NULL, "Guts", NULL),
(074, "Machoke", 1.5, 70.5, "", "", "Fighting", NULL, "Guts", NULL),
(075, "Machamp", 1.6, 130.0, "", "", "Fighting", NULL, "Guts", NULL),
(076, "Meditite", 0.6, 11.2, "", "", "Fighting ", "Psychic", "Pure Power", NULL),
(077, "Medicham", 1.3, 31.5, "", "", "Fighting ", "Psychic", "Pure Power", NULL),
(078, "Electrike", 0.6, 15.2, "", "", "Electric", NULL, "Lightning Rod", "Static"),
(079, "Manectric", 1.5, 40.2, "", "", "Electric", NULL, "Lightning Rod", "Static"),
(080, "Plusle", 0.4, 4.2, "", "", "Electric", NULL, "Plus", NULL),
(081, "Minun", 0.4, 4.2, "", "", "Electric", NULL, "Minus", NULL),
(082, "Magnemite", 0.3, 6.0, "", "", "Electric ", "Steel", "Magnet Pull", "Sturdy"),
(083, "Magneton", 1.0, 60.0, "", "", "Electric ", "Steel", "Magnet Pull", "Sturdy"),
(084, "Voltorb", 0.5, 10.4, "", "", "Electric", NULL, "Soundproof", "Static"),
(085, "Electrode", 1.2, 66.6, "", "", "Electric", NULL, "Soundproof", "Static"),
(086, "Volbeat", 0.7, 17.7, "", "", "Bug", NULL, "Illuminate", "Swarm"),
(087, "Illumise", 0.6, 17.7, "", "", "Bug", NULL, "Oblivious", NULL),
(088, "Oddish", 0.5, 5.4, "", "", "Grass ", "Poison", "Chlorophyll", NULL),
(089, "Gloom", 0.8, 8.6, "", "", "Grass ", "Poison", "Chlorophyll", NULL),
(090, "Vileplume", 1.2, 18.6, "", "", "Grass ", "Poison", "Chlorophyll", NULL),
(091, "Bellossom", 0.4, 5.8, "", "", "Grass", NULL, "Chlorophyll", NULL),
(092, "Doduo", 1.4, 39.2, "", "", "Normal ", "Flying", "Early Bird", "Run Away"),
(093, "Dodrio", 1.8, 85.2, "", "", "Normal ", "Flying", "Early Bird", "Run Away"),
(094, "Roselia", 0.3, 2.0, "", "", "Grass ", "Poison", "Natural Cure", "Poison Point"),
(095, "Gulpin", 0.4, 10.3, "", "", "Poison", NULL, "Liquid Ooze", "Sticky Hold"),
(096, "Swalot", 1.7, 80.0, "", "", "Poison", NULL, "Liquid Ooze", NULL),
(097, "Carvanha", 0.8, 20.8, "", "", "Water ", "Dark", "Rough Skin", NULL),
(098, "Sharpedo", 1.8, 88.8, "", "", "Water ", "Dark", "Rough Skin", NULL),
(099, "Wailmer", 2.0, 130.0, "", "", "Water", NULL, "Oblivious", "Water Veil"),
(100, "Wailord", 14.5, 398.0, "", "", "Water", NULL, "Oblivious", "Water Veil"),
(101, "Numel", 0.7, 24.0, "", "", "Fire ", "Ground", "Oblivious", NULL),
(102, "Camerupt", 1.9, 220.0, "", "", "Fire ", "Ground", "Magma Armor", NULL),
(103, "Slugma", 0.7, 35.0, "", "", "Fire", NULL, "Flame Body", "Magma Armor"),
(104, "Magcargo", 0.8, 55.0, "", "", "Fire ", "Rock", "Flame Body", "Magma Armor"),
(105, "Torkoal", 0.5, 80.4, "", "", "Fire", NULL, "White Smoke", NULL),
(106, "Grimer", 0.9, 30.0, "", "", "Poison", NULL, "Stench", "Sticky Hold"),
(107, "Muk", 1.2, 30.0, "", "", "Poison", NULL, "Stench", "Sticky Hold"),
(108, "Koffing", 0.6, 1.0, "", "", "Poison", NULL, "Levitate", NULL),
(109, "Weezing", 1.2, 9.5, "", "", "Poison", NULL, "Levitate", NULL),
(110, "Spoink", 0.7, 30.6, "", "", "Psychic", NULL, "Own Tempo", "Thick Fat"),
(111, "Grumpig", 0.9, 71.5, "", "", "Psychic", NULL, "Own Tempo", "Thick Fat"),
(112, "Sandshrew", 0.6, 12.0, "", "", "Ground", NULL, "Sand Veil", NULL),
(113, "Sandslash", 1.0, 29.5, "", "", "Ground", NULL, "Sand Veil", NULL),
(114, "Spinda", 1.1, 5.0, "", "", "Normal", NULL, "Own Tempo", NULL),
(115, "Skarmory", 1.7, 50.5, "", "", "Steel ", "Flying", "Keen Eye", "Sturdy"),
(116, "Trapinch", 0.7, 15.0, "", "", "Ground", NULL, "Arena Trap", "Hyper Cutter"),
(117, "Vibrava", 1.1, 15.3, "", "", "Ground ", "Dragon", "Levitate", NULL),
(118, "Flygon", 2.0, 82.0, "", "", "Ground ", "Dragon", "Levitate", NULL),
(119, "Cacnea", 0.4, 51.3, "", "", "Grass", NULL, "Sand Veil", NULL),
(120, "Cacturne", 1.3, 77.4, "", "", "Grass ", "Dark", "Sand Veil", NULL),
(121, "Swablu", 0.4, 1.2, "", "", "Normal ", "Flying", "Natural Cure", NULL),
(122, "Altaria", 1.1, 20.6, "", "", "Dragon ", "Flying", "Natural Cure", NULL),
(123, "Zangoose", 1.3, 40.3, "", "", "Normal", NULL, "Immunity", NULL),
(124, "Seviper", 2.7, 52.5, "", "", "Poison", NULL, "Shed Skin", NULL),
(125, "Lunatone", 1.0, 168.0, "", "", "Rock ", "Psychic", "Levitate", NULL),
(126, "Solrock", 1.2, 154.0, "", "", "Rock ", "Psychic", "Levitate", NULL),
(127, "Barboach", 0.4, 1.9, "", "", "Water ", "Ground", "Oblivious", NULL),
(128, "Whiscash", 0.9, 23.6, "", "", "Water ", "Ground", "Oblivious", NULL),
(129, "Corphish", 0.6, 11.5, "", "", "Water", NULL, "Hyper Cutter", "Shell Armor"),
(130, "Crawdaunt", 1.1, 32.8, "", "", "Water ", "Dark", "Hyper Cutter", "Shell Armor"),
(131, "Baltoy", 0.5, 21.5, "", "", "Ground ", "Psychic", "Levitate", NULL),
(132, "Claydol", 1.5, 108.0, "", "", "Ground ", "Psychic", "Levitate", NULL),
(133, "Lileep", 1.0, 23.8, "", "", "Rock ", "Grass", "Suction Cups", NULL),
(134, "Cradily", 1.5, 60.4, "", "", "Rock ", "Grass", "Suction Cups", NULL),
(135, "Anorith", 0.7, 12.5, "", "", "Rock ", "Bug", "Battle Armor", NULL),
(136, "Armaldo", 1.5, 68.2, "", "", "Rock ", "Bug", "Battle Armor", NULL),
(137, "Igglybuff", 0.3, 1.0, "", "", "Normal", NULL, "Cute Charm", NULL),
(138, "Jigglypuff", 0.5, 5.5, "", "", "Normal", NULL, "Cute Charm", NULL),
(139, "Wigglytuff", 1.0, 12.0, "", "", "Normal", NULL, "Cute Charm", NULL),
(140, "Feebas", 0.6, 7.4, "", "", "Water", NULL, "Swift Swim", NULL),
(141, "Milotic", 6.2, 162.0, "", "", "Water", NULL, "Marvel Scale", NULL),
(142, "Castform", 0.3, 0.8, "", "", "Normal", NULL, "Forecast", NULL),
(143, "Staryu", 0.8, 34.5, "", "", "Water", NULL, "Illuminate", "Natural Cure"),
(144, "Starmie", 1.1, 80.0, "", "", "Water ", "Psychic", "Illuminate", "Natural Cure"),
(145, "Kecleon", 1.0, 22.0, "", "", "Normal", NULL, "Color Change", NULL),
(146, "Shuppet", 0.6, 2.3, "", "", "Ghost", NULL, "Insomnia", NULL),
(147, "Banette", 1.1, 12.5, "", "", "Ghost", NULL, "Insomnia", NULL),
(148, "Duskull", 0.8, 15.0, "", "", "Ghost", NULL, "Levitate", NULL),
(149, "Dusclops", 1.6, 30.6, "", "", "Ghost", NULL, "Pressure", NULL),
(150, "Tropius", 2.0, 100.0, "", "", "Grass ", "Flying", "Chlorophyll", NULL),
(151, "Chimecho", 0.6, 1.0, "", "", "Psychic", NULL, "Levitate", NULL),
(152, "Absol", 1.2, 47.0, "", "", "Dark", NULL, "Pressure", NULL),
(153, "Vulpix", 0.6, 9.9, "", "", "Fire", NULL, "Flash Fire", NULL),
(154, "Ninetales", 1.1, 19.9, "", "", "Fire", NULL, "Flash Fire", NULL),
(155, "Pichu", 0.3, 2.0, "", "", "Electric", NULL, "Static", NULL),
(156, "Pikachu", 0.4, 6.0, "", "", "Electric", NULL, "Static", NULL),
(157, "Raichu", 0.8, 30.0, "", "", "Electric", NULL, "Static", NULL),
(158, "Psyduck", 0.8, 19.6, "", "", "Water", NULL, "Cloud Nine", "Damp"),
(159, "Golduck", 1.7, 76.6, "", "", "Water", NULL, "Cloud Nine", "Damp"),
(160, "Wynaut", 0.6, 14.0, "", "", "Psychic", NULL, "Shadow Tag", NULL),
(161, "Wobbuffet", 1.3, 28.5, "", "", "Psychic", NULL, "Shadow Tag", NULL),
(162, "Natu", 0.2, 2.0, "", "", "Psychic ", "Flying", "Early Bird", "Synchronize"),
(163, "Xatu", 1.5, 15.0, "", "", "Psychic ", "Flying", "Early Bird", "Synchronize"),
(164, "Girafarig", 1.5, 41.5, "", "", "Normal ", "Psychic", "Inner Focus", NULL),
(165, "Phanpy", 0.5, 33.5, "", "", "Ground", NULL, "Pickup", NULL),
(166, "Donphan", 1.1, 120.0, "", "", "Ground", NULL, "Sturdy", NULL),
(167, "Pinsir", 1.5, 55.0, "", "", "Bug", NULL, "Hyper Cutter", NULL),
(168, "Heracross", 1.5, 54.0, "", "", "Bug ", "Fighting", "Guts", "Swarm"),
(169, "Rhyhorn", 1.0, 115.0, "", "", "Ground ", "Rock", "Lightning Rod", "Rock Head"),
(170, "Rhydon", 1.9, 120.0, "", "", "Ground ", "Rock", "Lightning Rod", "Rock Head"),
(171, "Snorunt", 0.7, 16.8, "", "", "Ice", NULL, "Inner Focus", NULL),
(172, "Glalie", 1.5, 256.5, "", "", "Ice", NULL, "Inner Focus", NULL),
(173, "Spheal", 0.8, 39.5, "", "", "Ice ", "Water", "Thick Fat", NULL),
(174, "Sealeo", 1.1, 87.6, "", "", "Ice ", "Water", "Thick Fat", NULL),
(175, "Walrein", 1.4, 150.6, "", "", "Ice ", "Water", "Thick Fat", NULL),
(176, "Clamperl", 0.4, 52.5, "", "", "Water", NULL, "Shell Armor", NULL),
(177, "Huntail", 1.7, 27.0, "", "", "Water", NULL, "Swift Swim", NULL),
(178, "Gorebyss", 1.8, 22.6, "", "", "Water", NULL, "Swift Swim", NULL),
(179, "Relicanth", 1.0, 23.4, "", "", "Water ", "Rock", "Rock Head", "Swift Swim"),
(180, "Corsola", 0.6, 5.0, "", "", "Water ", "Rock", "Hustle", "Natural Cure"),
(181, "Chinchou", 0.5, 12.0, "", "", "Water ", "Electric", "Illuminate", "Volt Absorb"),
(182, "Lanturn", 1.2, 22.5, "", "", "Water ", "Electric", "Illuminate", "Volt Absorb"),
(183, "Luvdisc", 0.6, 8.7, "", "", "Water", NULL, "Swift Swim", NULL),
(184, "Horsea", 0.4, 8.0, "", "", "Water", NULL, "Swift Swim", NULL),
(185, "Seadra", 1.2, 25.0, "", "", "Water", NULL, "Poison Point", NULL),
(186, "Kingdra", 1.8, 152.0, "", "", "Water ", "Dragon", "Swift Swim", NULL),
(187, "Bagon", 0.6, 42.1, "", "", "Dragon", NULL, "Rock Head", NULL),
(188, "Shelgon", 1.1, 110.5, "", "", "Dragon", NULL, "Rock Head", NULL),
(189, "Salamence", 1.5, 102.6, "", "", "Dragon ", "Flying", "Intimidate", NULL),
(190, "Beldum", 0.6, 95.2, "", "", "Steel ", "Psychic", "Clear Body", NULL),
(191, "Metang", 1.2, 202.5, "", "", "Steel ", "Psychic", "Clear Body", NULL),
(192, "Metagross", 1.6, 550.0, "", "", "Steel ", "Psychic", "Clear Body", NULL),
(193, "Regirock", 1.7, 230.0, "", "", "Rock", NULL, "Clear Body", NULL),
(194, "Regice", 1.8, 175.0, "", "", "Ice", NULL, "Clear Body", NULL),
(195, "Registeel", 1.9, 205.0, "", "", "Steel", NULL, "Clear Body", NULL),
(196, "Latias", 1.4, 40.0, "", "", "Dragon ", "Psychic", "Levitate", NULL),
(197, "Latios", 2.0, 60.0, "", "", "Dragon ", "Psychic", "Levitate", NULL),
(198, "Kyogre", 4.5, 352.0, "", "", "Water", NULL, "Drizzle", NULL),
(199, "Groudon", 3.5, 950.0, "", "", "Ground", NULL, "Drought", NULL),
(200, "Rayquaza", 7.0, 206.5, "", "", "Dragon ", "Flying", "Air Lock", NULL),
(201, "Jirachi", 0.3, 1.1, "", "", "Steel ", "Psychic", "Serene Grace", NULL);


INSERT INTO Sabor VALUES ("Spicy"),
       ("Dry"),
       ("Sweet"),
       ("Bitter"),
       ("Sour");

INSERT INTO Naturaleza VALUES ("Adamant", "Spicy", "Dry"),
("Bashful", "Spicy", "Spicy"),
("Bold", "Sour", "Spicy"),
("Brave", "Spicy", "Sweet"),
("Calm", "Bitter", "Spicy"),
("Careful", "Bitter", "Dry"),
("Docile", "Dry", "Dry"),
("Gentle", "Bitter", "Sour"),
("Hardy", "Sweet", "Sweet"),
("Hasty", "Sweet", "Sour"),
("Impish", "Sour", "Dry"),
("Jolly", "Sweet", "Dry"),
("Lax", "Sour", "Bitter"),
("Lonely", "Spicy", "Sour"),
("Mild", "Dry", "Sour"),
("Modest", "Dry", "Spicy"),
("Naive", "Sweet", "Bitter"),
("Naughty", "Spicy", "Bitter"),
("Quiet", "Dry", "Sweet"),
("Quirky", "Bitter", "Bitter"),
("Rash", "Dry", "Bitter"),
("Relaxed", "Sour", "Sweet"),
("Sassy", "Bitter", "Sweet"),
("Serious", "Sour", "Sour"),
("Timid", "Sweet", "Spicy");

INSERT INTO Baya VALUES (01, "Cheri Berry", "Heals Paralysis", "Spicy"),
(02, "Chesto Berry", "Heals Sleeping", "Dry"),
(03, "Pecha Berry", "Heals Poison", "Sweet"),
(04, "Rawst Berry", "Heals Burn", "Bitter"),
(05, "Aspear Berry", "Heals Frozen Status", "Sour"),
(06, "Leppa Berry", "Recovers 10PP to an attack", "Spicy"),
(07, "Oran Berry", "Recovers 10HP", NULL),
(08, "Persim Berry", "Heals Confusion", NULL),
(09, "Lum Berry", "Heals Any Status Condition", NULL),
(10, "Sitrus Berry", "Recovers 30HP", NULL),
(11, "Figy Berry", "Recovers 1/8 HP and confuses any Pokemon that doesnt like Spicy Flavour", "Spicy"),
(12, "Wiki Berry", "Recovers 1/8 HP and confuses any Pokemon that doesnt like Dry Flavour", "Dry"),
(13, "Mago Berry", "Recovers 1/8 HP and confuses any Pokemon that doesnt like Sweet Flavour", "Sweet"),
(14, "Aguav Berry", "Recovers 1/8 HP and confuses any Pokemon that doesnt like Bitter Flavour", "Bitter"),
(15, "Iapapa Berry", "Recovers 1/8 HP and confuses any Pokemon that doesnt like Sour Flavour", "Sour"),
(16, "Razz Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Dry"),
(17, "Bluk Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Sweet"),
(18, "Nanab Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Bitter"),
(19, "Wepear Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Sour"),
(20, "Pinap Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Spicy"),
(21, "Pomeg Berry", "Lowers Effort Points for HP by 10 Points", NULL),
(22, "Kelpsy Berry", "Lowers Effort Points for Attack by 10 Points", NULL),
(23, "Qualot Berry", "Lowers Effort Points for Defense by 10 Points", NULL),
(24, "Hondew Berry", "Lowers Effort Points for Special Attack by 10 Points", NULL),
(25, "Grepa Berry", "Lowers Effort Points for Special Defense by 10 Points", NULL),
(26, "Tamato Berry", "Lowers Effort Points for Speed by 10 Points", NULL),
(27, "Cornn Berry", "Plant in the Earth to grow Berries for Pokeblocks", NULL),
(28, "Magost Berry", "Plant in the Earth to grow Berries for Pokeblocks", NULL),
(29, "Rabuta Berry", "Plant in the Earth to grow Berries for Pokeblocks", NULL),
(30, "Nomel Berry", "Plant in the Earth to grow Berries for Pokeblocks", NULL),
(31, "Spelon Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Spicy"),
(32, "Pamtre Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Dry"),
(33, "Watmel Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Sweet"),
(34, "Durin Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Bitter"),
(35, "Belue Berry", "Plant in the Earth to grow Berries for Pokeblocks", "Sour"),
(36, "Liechi Berry", "Raises Attack when HP is below 1/3", NULL),
(37, "Ganlon Berry", "Raises Defense when HP is below 1/3", NULL),
(38, "Salac Berry", "Raises Speed when HP is below 1/3", NULL),
(39, "Petaya Berry", "Raises Special Attack when HP is below 1/3", NULL),
(40, "Apicot Berry", "Raises Special Defense when HP is below 1/3", NULL),
(41, "Lansat Berry", "Raises Critical Hit Ratio when HP is below 1/3", NULL),
(42, "Starf Berry", "Raises Any Stat when HP is below 1/3", NULL),
(43, "Enigma Berry", "Morphs into E-Reader Berries", NULL);

-- Entrenadores
INSERT INTO Entrenador VALUES (33448, "Kiara", 2),
       (736, "Kindler Bernie", 3),
       (1560, "Bug Maniac Brent", 1),
       (5, "Leader Winona", 8),
       (5409, "Archie", 6),
       (6901, "Andy", 0),
       (10490, "Maria", 0),
       (60241, "Kindra", 0),
       (22687, "Lao", 0),
       (5099, "Valerie", 2),
       (2466, "Javier", 5),
       (4932, "Vicho", 6),
       (6666, "Gonzalo", 0);

INSERT INTO Agrupacion VALUES (1, "Team Aqua"),
       (2, "Fortree Gym");

INSERT INTO Pertenece VALUES (5409, 1, "Leader"),
       (6901, 1, "Grunt"),
       (10490, 1, "Grunt"),
       (22687, 1, "Grunt"),
       (5, 2, "Gym Leader");

-- Bichos de Kiara
INSERT INTO PokemonAtrapado VALUES
       (1, "Grovyle", 2, "Timid", "Overgrow", "Male",
       56, 32, 27, 45, 34, 50, 20, 5903,
       33448,
       1),
       (2, "Zigzagoon", 12, "Timid", "Pickup", "Female",
       31, 11, 14, 15, 15, 22, 12, 1781,
       33448,
       2),
       (3, "Ralts", 29, "Docile", "Trace", "Female",
       41, 18, 17, 23, 18, 23, 17, 7242,
       33448,
       2);

-- Bichos de Bernie
INSERT INTO PokemonAtrapado VALUES
       (4, "Slugma", 103, "Adamant", "Flame Body", "Male",
       47, 26, 24, 31, 24, 17, 18, 4913,
       736, 13),
       (5, "Wingull", 27, "Hardy", "Keen Eye", "Female",
       47, 21, 21, 30, 21, 41, 18, 4913,
       736, 15);

-- Bichos de Kindra
INSERT INTO PokemonAtrapado VALUES
       (6, "Duskull", 148, "Gentle", "Levitate", "Male", 63, 39, 63, 33, 77, 30, 31, 23833, 60241, 35),
       (7, "Shuppet", 146, "Calm", "Insomnia", "Female", 77, 54, 36, 53, 38, 42, 31, 23833, 60241, 35);

-- Bichos de Archie
INSERT INTO PokemonAtrapado VALUES
       (8, "Mightyena", 11, "Serious", "Intimidate", "Male", 121, 91, 75, 66, 66, 75, 41, 68921, 5409, 2),
       (9, "Crobat", 65, "Hardy", "Inner Focus", "Male", 133, 91, 83, 75, 83, 124, 41, 68921, 5409, 36),
       (10, "Sharpedo", 98, "Hardy", "Rough Skin", "Male", 126, 121, 52, 100, 52, 100, 43, 99383, 5409, 3);

-- Bichos de Vicho
INSERT INTO PokemonAtrapado VALUES
       (11, "Treecko", 1, "Adamant", "Air Lock", "Male", 122, 21, 55, 36, 46, 76, 31, 295814, 4932, 1),
       (12, "Grovyle", 2, "Bashful", "Arena Trap", "Male", 31, 54, 36, 56, 27, 67, 48243, 4932, 2),
       (13, "Sceptile", 3, "Bold", "Battle Armor", "Female", 21, 55, 36, 46, 46, 24, 92756, 4932, 3),
       (14, "Torchic", 4, "Brave", "Blaze", "Female", 123, 90, 89, 56, 66, 55, 19, 19264, 4932, 4),

-- Bichos de Javier
INSERT INTO PokemonAtrapado VALUES
       (15, "Combusken", 5, "Calm", "Cacophony", "Male", 124, 18, 99, 16, 58, 83, 10, 29733, 2466, 5),
       (16, "Blaziken", 6, "Careful", "Chlorophyll", "Male", 124, 27, 33, 19, 38, 86, 12, 29494, 2466, 6),
       (17, "Mudkip", 7, "Docile", "Clear Body", "Female", 125, 38, 22, 27, 26, 46, 29, 20492, 2466, 7),
       (18, "Marshtomp", 8, "Docile", "Cloud Nine", "Female", 125, 191, 67, 29, 35, 36, 41, 10292, 2466, 8),
       
-- Bichos de Gonza
INSERT INTO PokemonAtrapado VALUES
       (19, "Swampert", 9, "Hardy", "Color Change", "Male", 126, 79, 74, 24, 98, 23, 10, 29582, 6666, 9),
       (20, "Poochyena", 10, "Hasty", "Compound Eyes", "Male", 127, 87, 71, 34, 51, 43, 67, 10382, 6666, 10),
       (21, "Mightyena", 11, "Impish", "Cute Charm", "Female", 128, 21, 57, 97, 32, 15, 26, 29472, 6666, 11),
       (22, "Zigzagoon", 12, "Jolly", "Damp", "Female", 129, 91, 24, 66, 25, 75, 15, 90182, 12),











