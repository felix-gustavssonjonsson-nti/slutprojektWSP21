# Projektplan

## 0. Plan of action (plan inför de kommande veckorna)

v.9 Grunderna
Få in någon slags bas för alla de 5 sidorna med CRUD 

v.10 
Startsidan - klart och packa

v.11 
Inloggning

v.12 
Profil 

v.13
Upload 

v.14
misc/ menus or other things missing / header 

v.15 
bug fixing, titta igenom matris och uppfyll de sista som saknas eller glömts

v.16
Buffer/inlämning

Databas

## 1. Projektbeskrivning (Beskriv vad sidan ska kunna göra).
Blocket liknande sida där man kan köpa och sälja saker. Man ska kunna skapa konton, logga in och sen lägga up saker att sälja. Dessa saker ska kunnas ändras när man väl lagt upp något. 
Extra kan vara att man ska kunna tagga sina artiklar man lagt upp för att lättare hitta saker när man ska köpa något 

## 2. Vyer (visa bildskisser på dina sidor).
startsida/hemsida (bilder tillkommer snart)

skapa konto/logga in 

profil 

lägga upp artikel/kombineras med att edita 

visa allt 

en popup för sökinställningar.

## 3. Databas med ER-diagram (Bild på ER-diagram).
![er-diagram](er-diagram.jpg)

är inte 100% säker det blev helt rätt men det är en start 

## 4. Arkitektur (Beskriv filer och mappar - vad gör/innehåller de?).


En mapp för artikel relaterade slim filer, där exempelvis slim filen till en specifiks artikels content finns, och edit.slim till att redigera ens artiklen.
Inom content.slim kan man både redigera eller ta bort artiklen om man är användaren som lagt upp den. 

Den andra user mappen inngehåller allt relaterat till användaren, här ligger exempelvis login och registrerings formen
och profil sidan för alla användare som visar deras personliga information. 

Utöver det finns admin.slim som endast admin användare kan nå. Där kan man ge och ta bort admin från alla registrerade användare samt lägga till nya tags/kategorier
som används för artiklarna användare lägger upp. 

layout.slim är basen för sidan och innehåller bland annat nav baren och fottern.

publish.slim innehåller formen som tillåter användaren att lägga upp artiklar. 

start.slim är landing pagen för hemsidan, här visas hela listan på artiklar som lagts upp och kan klickas på. Artiklarna leder till content.slim 
och visar upp den specifika artiklens information. 




