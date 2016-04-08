---
title: Laboration 4
       Introduktion till Linux och små nätverk
author:
- name: Anders Jackson
  affiliation: Högskolan i Gävle
  email:
date: 2015-04-17
abstract:
...


Inlämningsuppgift fyra
================================================================================

Denna inlämningsuppgift består av två delar.

* Ni skall titta på hur ert lokala nätverk är uppbyggt med IP-nummer, nätmask,
  router etc.
* Ni skall skapa konfigurationsfiler i ett fiktivt nätverk utifrån givna
  premisser.


Del ett
--------------------------------------------------------------------------------
När man tittar på och analyserar ett lokalt nätverk, så behöver man veta några
saker. Dessa är följande

* Vilket nätadress som ett nät har. Det avgörs av den höga delen av en
  IP-adress.
* Var gränsen mellan nätadress och nodadress i en IP-adress går, dvs hur många
  av de 32 bitarna i en IPv4-adress som är nätadressen. Nodadressen kan även
  kallas maskinnummer.
* Vilken adress som routern har och som skall användas för att komma ut på
  internet.
* Hur maskiner i ett nätverk får sina IP-adresser.
* Vilken MAC-adress som en maskin har.

Den informationen hittar vi på några olika ställen och med några olika kommandon.


### IP-nummer
För att veta vilket IP-nummer som en maskin så kan man titta på två ställen i
en Debian Linux-dator. Om maskinen har fast adress, så tittar man enklast i
`/etc/network/interfaces`. Då kommer adressen att stå inskrivet för det
nätverksgränssnitt som datorn är ansluten till det lokala nätverket med. Det
syns med det s.k. stanza med värdet `static` och adressen hittas efter nyckeln
`address`.

Men om stanzat har värdet `dhcp`, så innebär det att det finns en maskin med
ett `DHCP`-program på nätverket som håller reda på använda adresser och delar
ut lediga till maskiner som vill ha nya adresser. Detta program brukar köras i
den router som finns på det lokala nätverket.

Men om er nätverksenhet inte nämns alls i `/etc/network/interfaces` då? Jo, då
hanteras den troligen av ett program som heter `NetworkManager` (förkortas
normalt NM). Det installeras vanligtvis bara i grafiska miljöer och används
sällan/aldrig när man har en server med fast ip-adress.

Hur tar man då reda på vilken IP-adress man har på en maskin? Det finns två
kommandon som är vanliga. Dels det nya `ip`, och dels det gamla `ifconfig`. Vi
skall använda `ip address show`, men ni får gärna jämföra med
`ifconfig`-kommandot, men skall använda `ip`.

#### Uppgift:
Ni skall ta reda på vilken IP-adress som maskinen har samt hur den får sin
adressen utifrån att använda kommandot `ip` och titta i loggar, exempelvis
`/var/log/messages`. Ange hur ni får tag på det, jag skall kunna se vad ni
hämtat datat ifrån.


### Nät- och Nodnummer
IP-adressen delas upp i två delar, nätadressen och nodadressen. För att veta
var gränsen går mellan nätadressen, som är lika hos alla maskiner i samma
nätverk, och nodadressen som är unikt för varje maskin i det lokala nätverket,
så kan man ange hur många bitar som nätadressen består av.

Det finns två sätt att ange detta på. Dels med något som kallas CIDR vilket
anges efter nätverkets IP-nummer, dels med något som kallas nätmask vilket
varje bit i adressen som motsvarar nätverkets adress sätts till ett. De är helt
likvärdiga, men man brukar föredra att använda CIDR, eftersom den är kortare
samt lite enklare att förstå.

För att se vilket nät man är ansluten till kan man dels se det med kommandot
`ip route list` (eller det äldre kommandot `route`) men även med `ip address
show`.

#### Uppgift:
Ange vilken nätadress som ni har. Ni skall använda CIDR och även ange
nätmasken. Ni skall visa var ni fått informationen ifrån.


### Routeradresser
För att nå andra nätverk och Internet, så kommer datorer som inte sitter på
samma nätverk som mottagaren skicka datat till en speciell dator som har en
funktion som heter router, vägväljare eller vägvisare. Dessa datorer brukar
kalla router. Det är dess uppgift att skicka data till rätt maskin, eller i
vart fall åt rätt håll för att komma till mottagaren. För att se vilka routrar
som en maskin känner till, och vilka nätverk de når, så använder man kommandot
`ip route list` (eller det äldre `route`). Den kan även när man har statisk
adress anges i `/etc/network/interfaces`.

#### Uppgift:
Vilka routrar känner er maskin till och vilken är den router som är
standardroutern (default router)?


### MAC-adresser
Datorer använder normalt Ethernet för att kommunicera med varandra. I ett
Ethernet har varje nätverkskort en unik 6-byte lång adress som kallas Media
Access Control Address (MAC address).  Denna adress används när datorer på
lägsta nivå skickar data mellan varandra. Detta data skickas normalt i paket om
42 till 1500 bytes.

För att skicka mer data, så delas datat upp i flera paket som skickas över och
sätts samman igen på mottagarsidan. När man exempelvis byter nätverkskort i en
dator, så byter datorn även MAC- adress. För att man bland annat inte skall
behöva ändra adress överallt där man vill prata med samma dator efter bytet så
använder man IP-adressen, som är en logisk adress. Så till varje MAC- adress
hör en IP-adress. Den aktuella informationen spar varje dator i en tabell. Den
tabellen med grannarna i det lokala nätverket kan man se med kommandot `ip
neighbour show` (eller det gamla kommandot `arp`).

För att denna tabell skall få innehåll, så måste de maskiner man är intresserad
av kontaktas. Detta kan man göra med kommandot `ping`. Så för att se hur det
fungerar så kan man först titta på tabellen, sedan göra `ping` mot en maskin
som inte finns i tabellen för att sedan titta på innehållet efter `ping`.

#### Uppgift:
Vilka MAC- och IP-adresser har de andra maskinerna som finns på datorns
nätverk.


Del två
--------------------------------------------------------------------------------
Här antar vi att ni har två maskiner, **m1** och **m2**, som är anslutna till
samma lokala nätverk.  Nätverket har en router, med namnet `router`, med
adressen `192.168.133.193/25`. Antag att maskinen **m1** har nodadressen `10`
och maskin **m2** har nodadressen `20` i samma nät som routern ovan. Maskin
**m1** skall ha statisk inställning av nätverket `eth0` och maskinen **m2**
skall ha dynamisk (`dhcp`) inställning av nätverket på `eth0`.

#### Uppgift:
Hur skulle ni skriva `/etc/network/interface` för respektive maskin **m1** och
**m2**?  Ange hur ni har kommit fram till innehållet i filen.


Rapporten
--------------------------------------------------------------------------------
Den rapport som ni skriver skall innehålla ett försättsblad som innehåller
laborationens namn, datum, ert namn, födelsedatum/personnummer samt
datorpostadress (på högskolan).

Rapporten skall vara skriven så att jag kan förstå att ni förstått samt ser vad
ni gjort. Ingen roman behövs dock. Det borde räcka med 4-7 sidor totalt med
text som den här laborationsunderlaget.  Följande delar/rubriker kan vara bra
att ha i rapporten.

1. Försättsblad
2. Innehållsförteckning (ej nödvändig)
3. Inledning: Ni beskriver problemet och vilka frågor som skall besvaras
4. Genomförande: Här beskriver ni hur ni har löst laborationen
5. Slutsatser: Här beskriver ni svaren på frågorna i Inledning:en
6. Övrigt: Om ni vill lägga till något som inte får plats i Slutsatser
7. Bilagor: Här lägger ni stora bilder och programlistningar samt relevanta
   konfigurationsfiler.

Rapporten, i PDF-format och eventuellt tillhörande filer laddas upp i BlackBoard.


Om uppgiften och forum
--------------------------------------------------------------------------------
Om ni får problem, så ställ frågor i forumet som finns i BlackBoard. Att lära
sig att administrera datorer handlar om att i forum kunna ställa rätt frågor,
så det kan ni gärna öva på här.

När ni ställer en fråga, så skall ni beskriva vad ni vill göra, vad ni har
gjort samt vad ni förväntat er skall ske samt vad som skett. Om ni beskriver
för dåligt, så kommer ni att få frågor om mer information. Tänk på att de som
läser era frågor inte har sett vad ni gjort, så det är ert ansvar att förklara
så att de andra förstår ert problem och kan besvara frågan.

Ni får även gärna svara på frågor i BlackBoard, där medstudenter förklarat vad
de försökt med och vad som inte gått som de tänkt. Begär mer information om ni
inte har fått tillräckligt med information så att ni förstått vad som frågats
efter. Samt i den här kursen så begär att få veta vad de som ställer frågan har
gjort innan ni svarar.


Lycka till!
Anders Jackson


Referenser
--------------------------------------------------------------------------------

#### Debian paketinformation
<http://wiki.debian.org/> (Debians officiella Wiki-dokumentation)  

#### Wikipedialänkar
<http://en.wikipedia.org/wiki/IPv4_subnetting_reference> (IPv4 subnätverk)  
<http://en.wikipedia.org/wiki/CIDR_notation> (Classless Inter-Domain Routing (CIDR))  
<http://en.wikipedia.org/wiki/Ethernet> (Utseende på Ethernet)  
<http://en.wikipedia.org/wiki/MAC_address> (Media Access Control Address)  

#### Nätverksstandarder (RFC-dokument)
<http://tools.ietf.org/html/rfc5735> (Speciella IPv4 nätverk)  
<http://tools.ietf.org/html/rfc1918> (Privata nätverk)  
<http://tools.ietf.org/html/rfc3927> (Länklokala nätverk, dvs bara i ett LAN)  
<http://tools.ietf.org/html/rfc2317> (Standarddokumentet för CIDR)  

