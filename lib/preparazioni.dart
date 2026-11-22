/// Procedimento di ogni piatto, passo per passo.
/// Formato: una riga con l'id della ricetta, poi un passo per riga.
/// Le ricette sono separate da una riga vuota.
final Map<String, List<String>> preparazioni = _leggi('''
carbonara
Metti a bollire abbondante acqua salata per la pasta.
Taglia il guanciale a listarelle e rosolalo in padella senza olio finché è croccante; spegni il fuoco.
In una ciotola sbatti le uova con il pecorino e tanto pepe macinato fresco.
Cuoci gli spaghetti al dente e tieni da parte un mestolo di acqua di cottura.
Scola la pasta nella padella del guanciale (a fuoco spento), aggiungi le uova e mescola velocemente con un po' di acqua di cottura finché diventa una crema. Servi subito con altro pecorino.

amatriciana
Taglia il guanciale a listarelle e rosolalo in padella senza olio finché è dorato; toglilo e tienilo da parte.
Sfuma con il vino bianco, poi aggiungi i pelati schiacciati e cuoci 15 minuti a fuoco medio; aggiusta di sale.
Rimetti il guanciale nel sugo.
Cuoci la pasta in acqua salata, scolala al dente e saltala nel sugo.
Servi con abbondante pecorino grattugiato.

cacio-pepe
Tosta il pepe macinato grosso in una padella asciutta per un minuto.
Cuoci gli spaghetti in poca acqua salata (così resta più amidosa) e tieni da parte due mestoli di acqua di cottura.
In una ciotola mescola il pecorino grattugiato fine con un po' di acqua di cottura tiepida fino a ottenere una crema.
Scola la pasta nella padella con il pepe, aggiungi un goccio d'acqua, togli dal fuoco e unisci la crema di pecorino mescolando velocemente.
Servi subito.

aglio-olio
Cuoci gli spaghetti in abbondante acqua salata.
Intanto scalda l'olio in padella con l'aglio a fettine e il peperoncino, a fuoco basso, senza far bruciare l'aglio.
Scola la pasta al dente e saltala nella padella con un mestolo di acqua di cottura.
Finisci con il prezzemolo tritato e servi subito.

pomodoro-basilico
Scalda l'olio in un tegame, aggiungi la passata e un pizzico di sale.
Cuoci a fuoco medio-basso per 15 minuti; alla fine aggiungi qualche foglia di basilico.
Cuoci la pasta in acqua salata, scolala al dente e saltala nel sugo.
Servi con grana grattugiato e basilico fresco.

pesto
Cuoci la pasta in abbondante acqua salata.
In una ciotola stempera il pesto con un paio di cucchiai di acqua di cottura.
Scola la pasta al dente, condiscila con il pesto (a fuoco spento, il pesto non va cotto) e mescola.
Servi con un po' di grana.

norma
Taglia le melanzane a cubetti, salale e lasciale riposare 20 minuti; poi asciugale.
Friggile nell'olio di semi caldo finché sono dorate e mettile su carta da cucina.
Cuoci la passata in un tegame con un filo d'olio e il basilico per 15 minuti.
Cuoci la pasta, scolala e condiscila con il sugo e metà delle melanzane.
Servi con le melanzane rimaste sopra e la ricotta (salata se la trovi) grattugiata o sbriciolata.

arrabbiata
In una padella scalda l'olio con l'aglio schiacciato e il peperoncino.
Aggiungi i pelati schiacciati, sala e cuoci 15 minuti a fuoco medio; togli l'aglio.
Cuoci le penne in acqua salata, scolale al dente e saltale nel sugo.
Finisci con prezzemolo tritato.

puttanesca
Scalda l'olio con l'aglio e le acciughe, finché le acciughe si sciolgono.
Aggiungi i pelati, le olive e i capperi sciacquati; cuoci 15 minuti.
Cuoci gli spaghetti in acqua poco salata (olive e capperi sono già sapidi).
Scola e salta la pasta nel sugo per un minuto. Servi subito.

pasta-fagioli
Trita carota, sedano e cipolla e soffriggili nell'olio con la pancetta a cubetti.
Aggiungi i fagioli scolati e la passata; copri con acqua calda (circa 250 ml a persona) e cuoci 15 minuti.
Frulla metà dei fagioli e rimettili nella pentola per rendere la zuppa cremosa; aggiusta di sale.
Cuoci la pasta direttamente nella zuppa, aggiungendo acqua se serve.
Lascia riposare 5 minuti e servi con un filo d'olio a crudo.

pasta-ceci
Scalda l'olio con l'aglio e il rosmarino, poi aggiungi i ceci scolati e la passata.
Copri con acqua calda (circa 250 ml a persona) e cuoci 15 minuti; togli aglio e rosmarino.
Frulla una parte dei ceci e rimettila nella pentola.
Cuoci la pasta nella zuppa mescolando spesso; aggiusta di sale.
Servi con un filo d'olio e pepe.

pasta-patate
Soffriggi la cipolla tritata e la pancetta nell'olio.
Aggiungi le patate a cubetti e i pelati; copri con acqua calda e cuoci 15 minuti.
Aggiungi la pasta e cuocila nel tegame mescolando spesso e aggiungendo acqua calda se serve.
A fine cottura, a fuoco spento, unisci la provola a cubetti e mescola finché fila.

vongole
Sciacqua bene le vongole e lasciale in acqua fredda salata per un'ora perché perdano la sabbia.
In una padella grande scalda l'olio con l'aglio, aggiungi le vongole, sfuma con il vino e copri: in pochi minuti si aprono.
Togli metà dei gusci e filtra il sughetto se c'è sabbia.
Cuoci gli spaghetti molto al dente e finisci la cottura in padella con il sughetto delle vongole.
Servi con prezzemolo tritato e un filo d'olio.

scoglio
Pulisci i frutti di mare (o usa il misto già pulito).
In una padella grande scalda l'olio con l'aglio, aggiungi i frutti di mare e sfuma con il vino.
Aggiungi i pomodorini tagliati a metà e cuoci 8-10 minuti.
Cuoci gli spaghetti al dente e saltali nel sugo con un po' di acqua di cottura.
Finisci con prezzemolo tritato.

pasta-tonno
Soffriggi la cipolla tritata nell'olio.
Aggiungi la passata e cuoci 10 minuti, poi unisci il tonno sgocciolato e i capperi.
Cuoci la pasta in acqua salata, scolala e saltala nel sugo per un minuto.

pasta-zucchine
Taglia le zucchine a rondelle sottili o a cubetti.
Soffriggi la cipolla nell'olio, aggiungi le zucchine e cuoci 10 minuti finché sono morbide; sala.
Cuoci la pasta, scolala e saltala con le zucchine e un po' di acqua di cottura.
Finisci con grana e basilico.

zucchine-gamberi
Taglia le zucchine a cubetti e falle saltare nell'olio con l'aglio per 6-7 minuti.
Aggiungi i gamberi sgusciati e cuoci 2-3 minuti; sala e togli l'aglio.
Cuoci la pasta al dente e saltala in padella con un po' di acqua di cottura.
Finisci con prezzemolo tritato.

funghi-salsiccia
Spella la salsiccia e sbriciolala in padella con un filo d'olio; rosolala.
Aggiungi i funghi a fettine e l'aglio, cuoci 8-10 minuti; sala.
Unisci la panna e lascia addensare un paio di minuti.
Cuoci la pasta, scolala e saltala nel condimento.

panna-prosciutto
Cuoci i piselli in padella con un filo d'acqua per 5 minuti.
Aggiungi il prosciutto cotto a dadini e la panna; scalda per 2 minuti.
Cuoci la pasta, scolala e mescolala con il condimento.
Servi con grana grattugiato.

pasta-salmone
Fai appassire la cipolla tritata finemente in padella con un filo d'olio.
Aggiungi il salmone affumicato a striscioline e cuoci un minuto.
Unisci la panna e scalda finché si addensa leggermente; pepe a piacere.
Cuoci la pasta, scolala e saltala nella salsa.

pasta-broccoli
Dividi i broccoli in cimette e cuocile nell'acqua bollente salata per 5 minuti.
Nella stessa acqua butta la pasta.
Intanto in padella scalda l'olio con aglio, acciughe e peperoncino.
Scola pasta e broccoli insieme e saltali in padella, schiacciando un po' i broccoli per fare una crema.

cime-rapa
Pulisci le cime di rapa tenendo foglie tenere e cimette.
Cuoci le cime nell'acqua salata per 5 minuti, poi aggiungi le orecchiette nella stessa pentola.
In padella scalda l'olio con l'aglio e le acciughe finché si sciolgono.
Scola orecchiette e cime insieme e saltale in padella per un minuto.

bolognese
Trita carota, sedano e cipolla e soffriggili nell'olio a fuoco basso per 10 minuti.
Aggiungi il macinato e rosolalo bene; sfuma con il vino rosso.
Unisci la passata, sala e cuoci a fuoco bassissimo con il coperchio per almeno 1 ora e mezza, aggiungendo acqua calda se si asciuga.
Cuoci le tagliatelle, scolale e condiscile con il ragù. Servi con grana.

lasagne
Prepara il ragù: soffritto di carota, sedano e cipolla nell'olio, aggiungi il macinato, rosola, poi la passata; cuoci almeno 45 minuti.
Accendi il forno a 180 °C.
In una pirofila fai uno strato di besciamella, poi alterna sfoglie, ragù, besciamella e grana.
Finisci con ragù, besciamella e abbondante grana.
Cuoci 35-40 minuti finché la superficie è dorata; lascia riposare 10 minuti prima di tagliare.

tortellini-panna
Cuoci i tortellini in acqua salata secondo la confezione.
In padella scalda la panna con il prosciutto cotto a dadini.
Scola i tortellini e saltali nella panna per un minuto.
Servi con grana grattugiato.

ravioli-burro
Cuoci i ravioli in acqua salata, a bollore leggero.
In padella sciogli il burro con le foglie di salvia finché profuma (senza bruciare).
Scola i ravioli e saltali delicatamente nel burro.
Servi con grana grattugiato.

gnocchi-pomodoro
Accendi il forno a 200 °C.
Cuoci la passata con un filo d'olio e basilico per 10 minuti; sala.
Cuoci gli gnocchi in acqua salata: sono pronti quando salgono a galla.
Condiscili con il sugo, mettili in una pirofila con la mozzarella a cubetti e gratina 10 minuti.

gnocchi-gorgonzola
In padella sciogli il gorgonzola nella panna a fuoco basso.
Cuoci gli gnocchi in acqua salata e scolali quando salgono a galla.
Saltali nella crema di gorgonzola.
Servi con la frutta secca tritata grossolanamente sopra.

milanese
Sciogli il dado in acqua calda e tieni il brodo in caldo.
Fai appassire la cipolla tritata con metà del burro, aggiungi il riso e tostalo 2 minuti.
Sfuma con il vino bianco, poi aggiungi un mestolo di brodo alla volta mescolando.
A metà cottura unisci lo zafferano sciolto in poco brodo.
Dopo circa 18 minuti, a fuoco spento, manteca con il burro rimasto e il grana. Lascia riposare un minuto.

risotto-funghi
Prepara il brodo con il dado e tienilo caldo.
Fai saltare i funghi a fettine con un filo d'olio per 5 minuti e tienili da parte.
Fai appassire la cipolla nel burro, tosta il riso e sfuma con il vino.
Cuoci aggiungendo brodo un mestolo alla volta; a metà cottura unisci i funghi.
A fuoco spento manteca con grana e una noce di burro.

risotto-zucca
Prepara il brodo con il dado e tienilo caldo.
Fai appassire la cipolla nel burro, aggiungi la zucca a cubetti e cuocila 5 minuti.
Aggiungi il riso, tostalo, poi cuoci con il brodo un mestolo alla volta: la zucca si sfalda e fa la crema.
A fuoco spento manteca con il grana.

risotto-mare
Apri i frutti di mare in padella con un filo d'olio e coperchio; filtra e tieni il liquido.
Prepara un brodo leggero con acqua calda e il liquido dei frutti di mare.
In un tegame scalda l'olio con l'aglio, tosta il riso e sfuma con il vino.
Cuoci aggiungendo brodo un mestolo alla volta; negli ultimi 3 minuti unisci i frutti di mare.
Finisci con prezzemolo e un filo d'olio.

risotto-asparagi
Prepara il brodo con il dado e tienilo caldo.
Taglia gli asparagi a rondelle tenendo da parte le punte.
Fai appassire la cipolla nel burro, aggiungi i gambi di asparago e il riso; tosta 2 minuti.
Cuoci con il brodo un mestolo alla volta; a metà aggiungi le punte.
A fuoco spento manteca con il grana.

pasta-forno
Accendi il forno a 200 °C.
Rosola il macinato con un filo d'olio, aggiungi la passata e cuoci 20 minuti; sala.
Cuoci la pasta molto al dente e condiscila con il ragù.
In una pirofila alterna pasta, mozzarella a cubetti e grana; finisci con grana.
Cuoci 20 minuti finché si forma la crosticina.

pasta-fredda
Cuoci la pasta in acqua salata, scolala al dente e passala sotto l'acqua fredda; condiscila con un filo d'olio.
Taglia pomodorini e mozzarella a pezzetti.
Unisci tonno sgocciolato, olive, pomodorini, mozzarella e basilico.
Mescola tutto con la pasta, aggiusta di sale e olio. Tieni in frigo fino al momento di servire.

pomodorini-burrata
Taglia i pomodorini a metà e falli saltare in padella con l'olio per 5 minuti; sala.
Cuoci la pasta, scolala e saltala con i pomodorini.
Servi con la burrata a pezzi sopra, basilico e un filo d'olio a crudo.

piselli-pancetta
Soffriggi la cipolla nell'olio con la pancetta a cubetti.
Aggiungi i piselli con un mestolo d'acqua e cuoci 8-10 minuti; sala.
Cuoci la pasta, scolala e saltala con i piselli e un po' di acqua di cottura.
Servi con grana.

pasta-integrale-verdure
Taglia zucchine e peperoni a cubetti e i pomodorini a metà.
Saltali in padella con l'olio per 10 minuti; sala.
Cuoci la pasta integrale, scolala e mescolala alle verdure.
Finisci con basilico e un filo d'olio.

pasta-lenticchie
Trita carota, sedano e cipolla e soffriggili nell'olio.
Aggiungi le lenticchie sciacquate e i pelati; copri con acqua (circa 400 ml a persona) e cuoci 30-35 minuti.
Quando le lenticchie sono morbide aggiungi la pasta e cuocila nella zuppa, aggiungendo acqua se serve.
Aggiusta di sale e servi con un filo d'olio.

cotoletta
Batti leggermente le fettine di vitello.
Passale nell'uovo sbattuto e poi nel pangrattato, premendo bene.
Scalda il burro in una padella larga e cuoci le cotolette 3-4 minuti per lato finché sono dorate.
Mettile su carta da cucina, sala e servi con spicchi di limone.

pollo-patate
Accendi il forno a 200 °C.
Taglia le patate a spicchi e mettile in teglia con le cosce di pollo.
Condisci con olio, sale, pepe, rosmarino e aglio in camicia; mescola bene.
Cuoci 50-55 minuti girando a metà, finché la pelle del pollo è croccante.

pollo-piastra
Scalda bene una piastra o una padella antiaderente.
Ungi il petto di pollo con poco olio e cuocilo 4-5 minuti per lato (se è spesso, taglialo a metà).
Sala a fine cottura e condisci con succo di limone ed erbe aromatiche.

pollo-limone
Taglia il petto di pollo a striscioline e infarinale.
Rosolale nel burro a fuoco vivace per 5 minuti.
Aggiungi il succo di limone e un po' d'acqua, cuoci 2 minuti finché si forma una salsina; sala.
Servi con la scorza di limone grattugiata.

pollo-curry
Cuoci il riso basmati in acqua salata e scolalo.
Taglia il pollo a bocconcini e rosolalo nell'olio con la cipolla tritata.
Aggiungi il curry, mescola un minuto, poi la panna e un po' d'acqua; cuoci 10 minuti.
Servi il pollo con la sua salsa accanto al riso.

scaloppine
Batti le fette di carne e infarinale.
Scalda il burro in padella e rosola le scaloppine un minuto per lato.
Aggiungi il succo di limone e un goccio d'acqua, cuoci un altro minuto finché la salsa si addensa; sala.
Servi subito con la salsina.

saltimbocca
Su ogni fettina di vitello appoggia mezza fetta di prosciutto crudo e una foglia di salvia; fermali con uno stuzzicadenti.
Scalda il burro in padella e cuoci i saltimbocca 2 minuti dal lato della carne e 1 minuto dal lato del prosciutto.
Sfuma con il vino bianco e lascia addensare il fondo.
Servi con il loro sughetto.

polpette-sugo
Mescola il macinato con uovo, pangrattato, grana, sale e pepe.
Forma delle polpette grandi come una noce.
In un tegame scalda l'olio con la passata, sala e porta a bollore.
Metti le polpette nel sugo e cuoci a fuoco basso con il coperchio per 25-30 minuti, girandole ogni tanto.

hamburger-patatine
Cuoci le patatine in forno come indicato sulla confezione.
Cuoci l'hamburger in padella o piastra ben calda 3-4 minuti per lato; negli ultimi secondi appoggia la fetta di formaggio.
Scalda il panino tagliato a metà.
Componi: panino, insalata, hamburger con formaggio, pomodoro e ketchup. Servi con le patatine.

arrosto-tacchino
Accendi il forno a 180 °C.
Rosola l'arrosto in una pentola con l'olio su tutti i lati, poi sfuma con il vino.
Mettilo in teglia con le patate a spicchi, rosmarino, sale e pepe.
Cuoci 50-60 minuti, bagnando ogni tanto con il fondo di cottura.
Lascia riposare 10 minuti prima di tagliarlo a fette.

tacchino-limone
Taglia il petto di tacchino a fette sottili e infarinale.
Scalda l'olio in padella e cuoci le fette 2 minuti per lato.
Aggiungi il succo di limone e un po' d'acqua, lascia addensare la salsa; sala.
Servi subito con la salsina.

salsiccia-tacchino-friarielli
Pulisci le cime di rapa (friarielli) e sbollentale 3 minuti in acqua salata; scolale.
Rosola le salsicce di tacchino in padella con un filo d'olio per 10 minuti.
Aggiungi aglio, peperoncino e i friarielli; cuoci altri 10 minuti mescolando.
Aggiusta di sale e servi caldo.

burger-tacchino
Scalda una padella antiaderente con un filo d'olio.
Cuoci i burger di tacchino 4-5 minuti per lato (devono essere ben cotti dentro).
Intanto prepara l'insalata con i pomodori, condisci con olio e sale.
Servi i burger con l'insalata.

salsiccia-patate
Accendi il forno a 200 °C.
Taglia le patate a spicchi e mettile in teglia con olio, sale e rosmarino.
Cuoci 20 minuti, poi aggiungi le salsicce bucherellate.
Cuoci altri 25 minuti girando a metà, finché tutto è dorato.

bistecca
Togli la bistecca dal frigo 30 minuti prima.
Scalda bene la griglia o la padella e cuoci la bistecca 2-4 minuti per lato secondo lo spessore e la cottura che preferisci.
Sala solo a fine cottura e lascia riposare 2 minuti.
Servi con l'insalata condita con olio e sale.

tagliata
Scalda una piastra o una padella di ghisa.
Cuoci la carne 3-4 minuti per lato, lasciandola rosa dentro; lascia riposare 5 minuti.
Tagliala a fette oblique e adagiala sulla rucola.
Completa con scaglie di grana, sale grosso, olio e qualche goccia di aceto balsamico.

spezzatino
Rosola i pezzi di manzo nell'olio a fuoco vivo finché sono dorati.
Aggiungi la cipolla tritata, poi sfuma con il vino rosso.
Unisci la passata e un bicchiere d'acqua, sala e cuoci con il coperchio a fuoco basso per 1 ora.
Aggiungi i piselli e cuoci altri 15-20 minuti, finché la carne è tenera.

brasato
Rosola il pezzo di manzo nell'olio su tutti i lati.
Aggiungi carota, sedano e cipolla a pezzi e il vino rosso.
Cuoci con il coperchio a fuoco bassissimo per 2-2 ore e mezza, girando ogni tanto e aggiungendo acqua se serve.
Togli la carne, frulla le verdure con il fondo per fare la salsa e servi la carne a fette con la salsa.

bollito
Metti in una pentola grande acqua, carota, sedano, cipolla e un pizzico di sale; porta a bollore.
Immergi la carne nell'acqua bollente e cuoci a fuoco basso per 2-2 ore e mezza, schiumando ogni tanto.
Nell'ultima mezz'ora aggiungi le patate.
Servi la carne a fette con le verdure; il brodo si può usare per una minestra.

ossobuco
Incidi il bordo degli ossibuchi per non farli arricciare e infarinali.
Rosolali nel burro, poi aggiungi carota, sedano e cipolla tritati.
Sfuma con il vino bianco, aggiungi un po' d'acqua calda e cuoci coperto a fuoco basso per 1 ora e mezza.
Alla fine cospargi con prezzemolo tritato e scorza di limone grattugiata (gremolada).

braciole
Togli le braciole dal frigo 20 minuti prima.
Scalda bene una griglia o padella e cuoci 4-5 minuti per lato.
Condisci con olio, sale e rosmarino a fine cottura.

lonza-latte
Lega la lonza con lo spago e infarinala leggermente.
Rosolala nel burro su tutti i lati.
Copri con il latte, sala e cuoci a fuoco basso con il coperchio socchiuso per 45-50 minuti.
Frulla il fondo per ottenere una salsa liscia e servi la carne a fette con la salsa.

costine
Accendi il forno a 180 °C.
Condisci le costine con olio, sale, pepe e rosmarino; mettile in teglia con le patate a spicchi.
Copri con alluminio e cuoci 40 minuti.
Togli l'alluminio, alza a 200 °C e cuoci altri 25 minuti finché sono dorate.

involtini
Rosola gli involtini in padella con l'olio su tutti i lati.
Aggiungi la passata e un po' d'acqua, sala.
Cuoci con il coperchio a fuoco basso per 25-30 minuti, girandoli a metà.

cordon-bleu
Cuoci i cordon bleu in padella con un filo d'olio, 4-5 minuti per lato a fuoco medio, oppure in forno come da confezione.
Prepara l'insalata e condiscila con olio e sale.
Servi i cordon bleu caldi con l'insalata.

coniglio
Rosola i pezzi di coniglio nell'olio finché sono dorati.
Aggiungi cipolla tritata e rosmarino, poi sfuma con il vino rosso.
Unisci i pelati e le olive, sala e cuoci coperto a fuoco basso per 50 minuti, aggiungendo acqua se serve.

fegato
Affetta le cipolle molto sottili e falle appassire in olio e burro a fuoco basso per 20 minuti.
Alza il fuoco, aggiungi il fegato a striscioline e cuoci 2-3 minuti (non di più, altrimenti indurisce).
Sfuma con il vino bianco, sala alla fine e servi subito.

polpettone
Accendi il forno a 180 °C.
Mescola il macinato con uovo, pangrattato, grana, sale e pepe.
Stendi l'impasto, mettici sopra il prosciutto cotto e arrotolalo dandogli la forma di un salame.
Mettilo in teglia con le patate a spicchi e un filo d'olio; cuoci 50 minuti, girandolo a metà.

wurstel-patatine
Cuoci le patatine in forno come indicato sulla confezione.
Incidi i würstel e cuocili in padella o sulla piastra 5-6 minuti.
Servi con le patatine e la senape.

spiedini-verdure
Taglia zucchine e melanzane a fette e i peperoni a falde.
Grigliale su una piastra ben calda, poi condiscile con olio e sale.
Cuoci gli spiedini sulla piastra 10-12 minuti, girandoli spesso.
Servi gli spiedini con le verdure grigliate.

agnello
Accendi il forno a 200 °C.
Metti l'agnello in teglia con le patate a spicchi, aglio in camicia, rosmarino, olio, sale e pepe.
Cuoci 60-70 minuti girando a metà, finché è dorato.
Lascia riposare 5 minuti prima di servire.

carpaccio
Disponi le fette di carne su un piatto in un solo strato.
Condisci con succo di limone, olio, sale e pepe e lascia riposare 5 minuti.
Completa con rucola e scaglie di grana.

vitello-tonnato
Cuoci la carne in acqua bollente salata con un po' di sedano e carota per 1 ora; lasciala raffreddare nel brodo.
Frulla tonno, maionese, capperi e acciughe con qualche cucchiaio di brodo fino a ottenere una salsa liscia.
Taglia la carne a fette sottilissime e coprile con la salsa.
Lascia riposare in frigo almeno un'ora prima di servire.

roast-beef
Riscalda leggermente il roast beef (se già cotto) o servilo a temperatura ambiente.
Taglia le patate a spicchi e cuocile in forno a 200 °C con olio, sale e rosmarino per 40 minuti.
Servi il roast beef a fette sottili con le patate e il suo sugo.

pollo-arrosto
Compra il pollo arrosto già cotto in rosticceria.
Taglia le patate a spicchi e cuocile in forno a 200 °C con olio e sale per 40 minuti (o prendile già pronte).
Riscalda il pollo in forno per 10 minuti e servilo con le patate.

salmone-forno
Accendi il forno a 200 °C.
Taglia le patate a fettine sottili, condiscile con olio e sale e cuocile in teglia per 20 minuti.
Appoggia il salmone sulle patate, condisci con olio, sale, erbe e fettine di limone.
Cuoci altri 15 minuti.

orata
Accendi il forno a 200 °C.
Metti in teglia le patate a fettine con olio e sale; cuoci 15 minuti.
Aggiungi l'orata pulita (sale e erbe nella pancia), i pomodorini e le olive.
Cuoci altri 25 minuti. Servi con un filo d'olio a crudo.

merluzzo-umido
Scalda l'olio con l'aglio, aggiungi i pelati, le olive e i capperi; cuoci 10 minuti.
Adagia i filetti di merluzzo nel sugo, copri e cuoci 8-10 minuti a fuoco basso.
Aggiusta di sale e servi con un po' di prezzemolo.

calamari-fritti
Pulisci i calamari e tagliali ad anelli; asciugali bene.
Passali nella farina e scuoti l'eccesso.
Friggili pochi alla volta nell'olio di semi ben caldo (170 °C) per 2 minuti.
Scolali su carta da cucina, sala e servi con spicchi di limone.

gamberoni
Scalda l'olio in una padella larga con l'aglio.
Aggiungi i gamberoni e cuocili 2 minuti per lato a fuoco vivace.
Sala, aggiungi succo di limone e prezzemolo tritato e servi subito.

pesce-spada
Scalda bene una piastra.
Ungi leggermente le fette di pesce spada e cuocile 2-3 minuti per lato.
Condisci con un'emulsione di olio, succo di limone, origano e sale.

tonno-scottato
Scalda molto bene una padella antiaderente.
Ungi il trancio di tonno e cuocilo 1 minuto per lato: dentro deve restare rosa.
Taglialo a fette e condiscilo con salsa di soia e un filo d'olio.

polpo-patate
Immergi il polpo nell'acqua bollente e cuocilo 40-50 minuti (è pronto quando una forchetta entra facilmente); lascialo intiepidire nell'acqua.
Lessa le patate a cubetti per 15 minuti.
Taglia il polpo a pezzi e mescolalo con le patate.
Condisci con olio, limone, aglio tritato, prezzemolo e sale.

cozze
Pulisci le cozze: raschia il guscio e togli il "filo" (bisso).
In una pentola grande scalda l'olio con l'aglio, aggiungi le cozze e sfuma con il vino.
Copri e cuoci a fuoco vivace finché si aprono (5 minuti); scarta quelle chiuse.
Servi con prezzemolo, il loro sughetto e il pane tostato.

seppie-piselli
Pulisci le seppie e tagliale a listarelle.
Soffriggi la cipolla nell'olio, aggiungi le seppie e cuocile 5 minuti.
Aggiungi la passata e un po' d'acqua, cuoci coperto 20 minuti.
Unisci i piselli e cuoci altri 15 minuti; sala.

baccala
Se è secco, tieni il baccalà in ammollo 2-3 giorni cambiando l'acqua (o compralo già ammollato).
Soffriggi la cipolla nell'olio, aggiungi i pelati e le olive; cuoci 10 minuti.
Taglia il baccalà a pezzi e adagialo nel sugo; cuoci coperto 15-20 minuti.
Assaggia prima di salare: il baccalà è già sapido.

bastoncini-pure
Lessa le patate con la buccia per 30 minuti, sbucciale e schiacciale.
Mescolale sul fuoco con il latte caldo e il burro fino a ottenere un purè morbido; sala.
Cuoci i bastoncini in forno o in padella come indicato sulla confezione.
Servi i bastoncini con il purè.

trota
Accendi il forno a 200 °C.
Metti la trota pulita su carta forno, con sale, erbe e fettine di limone nella pancia.
Condisci con un filo d'olio e chiudi il cartoccio.
Cuoci 20-25 minuti.

alici
Accendi il forno a 200 °C.
Pulisci le alici togliendo testa e lisca e aprendole a libro.
Mettile in una teglia unta, cospargile con pangrattato mescolato ad aglio e prezzemolo tritati.
Condisci con un filo d'olio e sale; cuoci 10-12 minuti.

platessa
Passa i filetti nell'uovo sbattuto e poi nel pangrattato.
Scalda l'olio in padella e cuoci i filetti 2-3 minuti per lato finché sono dorati.
Scolali su carta da cucina, sala e servi con spicchi di limone.

insalata-mare
Cuoci i frutti di mare in acqua bollente salata per 5-10 minuti (o aprili in padella); scolali.
Taglia sedano e carota a pezzetti piccoli.
Mescola tutto e condisci con olio, succo di limone, prezzemolo, sale e pepe.
Lascia insaporire in frigo almeno 30 minuti.

poke
Cuoci il riso, scolalo e lascialo raffreddare.
Taglia il salmone (freschissimo o abbattuto) a cubetti e marinalo 10 minuti nella salsa di soia.
Taglia avocado e cetriolo a cubetti.
Componi la ciotola: riso sotto, poi salmone, avocado, cetriolo e mais. Condisci con altra salsa di soia.

sgombro-forno
Accendi il forno a 200 °C.
Metti lo sgombro pulito in teglia con i pomodorini a metà.
Condisci con olio, sale e origano.
Cuoci 20-25 minuti.

zuppa-pesce
Scalda l'olio con l'aglio in un tegame largo e aggiungi i pelati; cuoci 10 minuti.
Aggiungi un bicchiere d'acqua, poi il merluzzo a pezzi e cuoci 5 minuti.
Unisci i frutti di mare, copri e cuoci altri 5 minuti finché si aprono.
Servi con fette di pane tostato.

frittata-zucchine
Taglia le zucchine a rondelle sottili e cuocile in padella con l'olio per 8 minuti; sala.
Sbatti le uova con il grana e un pizzico di sale.
Versa le uova sulle zucchine e cuoci a fuoco basso con il coperchio per 6-8 minuti.
Gira la frittata aiutandoti con un piatto e cuoci ancora 2-3 minuti.

frittata-patate
Taglia le patate a fettine sottili e la cipolla a fette.
Cuocile in padella con l'olio a fuoco medio per 15 minuti, finché sono morbide; sala.
Versa le uova sbattute sopra e cuoci coperto a fuoco basso per 8 minuti.
Gira la frittata con un piatto e cuoci altri 3 minuti.

uova-pomodoro
Scalda l'olio in padella, aggiungi la passata e il basilico; sala e cuoci 10 minuti.
Fai dei piccoli incavi nel sugo e rompici dentro le uova.
Copri e cuoci a fuoco basso 6-8 minuti, finché l'albume è rappreso.
Servi con il pane per fare la scarpetta.

parmigiana
Taglia le melanzane a fette di mezzo centimetro, salale e lasciale riposare 30 minuti; asciugale.
Friggile nell'olio di semi caldo finché sono dorate e scolale su carta da cucina.
Cuoci la passata con il basilico per 10 minuti; accendi il forno a 180 °C.
In una pirofila alterna strati di sugo, melanzane, mozzarella e grana; finisci con sugo e grana.
Cuoci 30-35 minuti e lascia riposare almeno 15 minuti prima di servire.

peperoni-ripieni
Accendi il forno a 180 °C.
Taglia i peperoni a metà e togli semi e filamenti.
Mescola macinato, uovo, pangrattato, grana, sale e pepe e riempi i peperoni.
Mettili in teglia con un filo d'olio e cuoci 45 minuti.

zucchine-ripiene
Accendi il forno a 180 °C.
Taglia le zucchine a metà per lungo e svuotale con un cucchiaino; trita la polpa.
Mescola polpa, macinato, uovo, pangrattato, grana e sale; riempi le zucchine.
Mettile in teglia con la passata e un filo d'olio e cuoci 35-40 minuti.

polenta-salsiccia
Porta a bollore acqua salata (circa 4 volte il peso della farina) e versa la polenta a pioggia mescolando.
Cuoci mescolando spesso per il tempo indicato sulla confezione (da 5 minuti per l'istantanea a 45 per quella tradizionale).
Intanto rosola le salsicce a pezzi in padella con un filo d'olio, aggiungi la passata e cuoci 20 minuti.
Servi la polenta calda con le salsicce e il sugo sopra.

cous-cous
Taglia zucchine, peperoni e melanzane a cubetti e saltali in padella con l'olio per 10 minuti; aggiungi i ceci scolati e sala.
Metti il cous cous in una ciotola e versaci sopra lo stesso volume di acqua bollente salata; copri per 5 minuti.
Sgrana il cous cous con una forchetta e un filo d'olio.
Mescolalo con le verdure e i ceci. Si mangia caldo o freddo.

chili
Soffriggi cipolla e peperone a cubetti nell'olio.
Aggiungi il macinato e rosolalo, poi le spezie (chili, cumino, paprika).
Unisci i pelati e i fagioli scolati, sala e cuoci a fuoco basso per 30 minuti.
Servi con le tortillas scaldate in padella.

wrap-pollo
Taglia il pollo a striscioline e cuocilo in padella con un filo d'olio per 6-8 minuti; sala.
Scalda le tortillas in padella pochi secondi per lato.
Farcisci ogni tortilla con lattuga, pomodoro a fette, pollo, formaggio e salsa.
Arrotola chiudendo i bordi e taglia a metà.

mozzarella-carrozza
Taglia la mozzarella a fette e lasciala scolare su carta da cucina.
Fai dei sandwich di pancarrè e mozzarella, premendo bene i bordi.
Passali nella farina, poi nell'uovo sbattuto con il latte e un pizzico di sale.
Friggili nell'olio caldo 2 minuti per lato e scolali su carta da cucina.

tofu-verdure
Cuoci il riso basmati e scolalo.
Taglia il tofu a cubetti e rosolalo in padella con l'olio finché è dorato.
Aggiungi broccoli a cimette e carote a bastoncini, cuoci 6-8 minuti mescolando.
Condisci con la salsa di soia e servi con il riso.

hummus-verdure
Taglia carote e cetrioli a bastoncini.
Metti l'hummus in una ciotola con un filo d'olio e un pizzico di paprika sopra.
Servi con le verdure e il pane tostato da intingere.

uova-sode-spinaci
Metti le uova in acqua fredda, porta a bollore e cuoci 9 minuti; raffreddale in acqua fredda e sgusciale.
Cuoci gli spinaci in padella con un filo d'olio per 5 minuti; sala.
Servi le uova tagliate a metà sugli spinaci, con il pane.

quinoa-verdure
Sciacqua la quinoa e cuocila in acqua salata per 15 minuti; scolala.
Taglia zucchine a cubetti e saltale in padella con l'olio per 6 minuti.
Mescola quinoa, zucchine, pomodorini a metà e feta a cubetti.
Condisci con olio e sale. Buona anche fredda.

minestrone
Metti il minestrone in una pentola con acqua (circa 300 ml a persona) e un pizzico di sale.
Cuoci 20 minuti dal bollore.
Aggiungi la pasta corta e cuocila nel minestrone.
Servi con un filo d'olio e grana.

zuppa-lenticchie
Trita carota, sedano e cipolla e soffriggili nell'olio.
Aggiungi le lenticchie sciacquate e i pelati, copri con acqua (circa 400 ml a persona).
Cuoci 35-40 minuti a fuoco basso finché sono morbide; sala.
Servi con il pane tostato e un filo d'olio.

vellutata-zucca
Soffriggi la cipolla nell'olio, aggiungi zucca e patate a cubetti.
Copri con il brodo (acqua e dado) e cuoci 20-25 minuti.
Frulla tutto con il frullatore a immersione e aggiungi la panna.
Servi con pepe e, se ti piacciono, crostini.

passato-verdure
Taglia carote, patate, zucchine e cipolla a pezzi.
Mettile in pentola con il dado e copri d'acqua; cuoci 30 minuti.
Frulla tutto fino a ottenere una crema e aggiusta di sale.
Servi con un filo d'olio a crudo.

pastina-brodo
Porta a bollore l'acqua con il dado (circa 300 ml a persona).
Aggiungi la pastina e cuocila il tempo indicato sulla confezione.
Servi con grana grattugiato.

tortellini-brodo
Porta a bollore l'acqua con il dado (o usa brodo di carne fatto in casa).
Cuoci i tortellini nel brodo per il tempo indicato sulla confezione.
Servi con il brodo e grana grattugiato.

zuppa-legumi
Sciacqua il farro (o l'orzo).
Soffriggi carota, sedano e cipolla tritati nell'olio, aggiungi farro, fagioli e ceci scolati.
Copri con acqua (circa 400 ml a persona), sala e cuoci 30-40 minuti finché il farro è morbido.
Servi con un filo d'olio e pepe.

vellutata-piselli
Soffriggi la cipolla nell'olio, aggiungi i piselli e le patate a cubetti.
Copri con il brodo (acqua e dado) e cuoci 20 minuti.
Frulla fino a ottenere una crema liscia; aggiusta di sale.

zuppa-pane
Scalda l'olio con l'aglio, aggiungi la passata e il basilico; cuoci 10 minuti.
Aggiungi il pane raffermo a pezzi e un po' d'acqua calda.
Cuoci 15-20 minuti mescolando finché il pane si sfalda e diventa una crema; sala.
Servi tiepida con olio a crudo e basilico.

caprese
Taglia pomodori e mozzarella a fette.
Alternali su un piatto con le foglie di basilico.
Condisci con olio, sale e origano.

insalatona-tonno
Rassoda l'uovo: 9 minuti dal bollore, poi raffreddalo e taglialo a spicchi.
In una ciotola metti l'insalata, i pomodori a pezzi, il tonno sgocciolato e il mais.
Aggiungi l'uovo e condisci con olio e sale.

greca
Taglia pomodori e cetrioli a pezzi e la cipolla ad anelli sottili.
Mescolali con le olive in una ciotola.
Aggiungi la feta a cubetti o in un unico pezzo sopra.
Condisci con olio, origano e poco sale.

caesar
Cuoci il pollo alla piastra 4-5 minuti per lato e taglialo a fette.
Taglia il pane a cubetti e tostalo in padella o in forno.
Spezzetta la lattuga, aggiungi pollo e crostini.
Condisci con la maionese allungata con un po' di succo di limone e grana grattugiato (salsa Caesar veloce).

insalata-riso
Cuoci il riso in acqua salata, scolalo al dente e passalo sotto l'acqua fredda.
Taglia würstel e formaggio a cubetti.
Mescola il riso con würstel, formaggio, tonno, sottaceti e mais.
Condisci con olio e lascia riposare in frigo almeno 30 minuti.

insalata-pollo
Cuoci il petto di pollo alla piastra e taglialo a striscioline.
Taglia l'avocado a cubetti e i pomodorini a metà.
Mescola tutto con l'insalata.
Condisci con olio, limone e sale.

insalata-salmone
Metti la rucola in un piatto.
Aggiungi il salmone affumicato a striscioline e l'avocado a fette.
Condisci con olio, succo di limone e pepe.

bresaola-rucola
Disponi le fette di bresaola su un piatto.
Metti sopra la rucola e le scaglie di grana.
Condisci con olio, succo di limone e pepe.

margherita
Accendi il forno al massimo (250 °C) con la teglia dentro.
Stendi la base su carta forno; condiscila con la passata, un pizzico di sale e un filo d'olio.
Cuoci 8 minuti, poi aggiungi la mozzarella a pezzetti ben scolata.
Cuoci altri 5-7 minuti e completa con basilico fresco.

capricciosa
Accendi il forno al massimo (250 °C).
Stendi la base, condiscila con la passata, sale e olio; cuoci 8 minuti.
Aggiungi mozzarella, prosciutto cotto, funghi, carciofini e olive.
Cuoci altri 6-8 minuti.

pizza-surgelata
Accendi il forno alla temperatura indicata sulla confezione (di solito 220 °C).
Togli la pizza dalla plastica e mettila direttamente sulla griglia del forno.
Cuoci il tempo indicato (in genere 10-12 minuti). Se vuoi aggiungi basilico o un filo d'olio.

torta-spinaci
Accendi il forno a 180 °C.
Cuoci gli spinaci in padella per 5 minuti, strizzali bene e tritali.
Mescolali con ricotta, uovo, grana e sale.
Stendi la sfoglia in una teglia, versa il ripieno, ripiega i bordi e cuoci 35-40 minuti.

quiche
Accendi il forno a 180 °C.
Rosola la pancetta in padella senza olio.
Sbatti uova e panna con sale e pepe, aggiungi l'emmental grattugiato e la pancetta.
Stendi la pasta in una teglia, versa il ripieno e cuoci 35-40 minuti finché è dorata.

piadina
Scalda una padella antiaderente.
Scalda la piadina un minuto per lato.
Spalma lo stracchino su metà piadina, aggiungi crudo e rucola, piega a metà e servi subito.

toast
Componi il toast: pancarrè, formaggio, prosciutto, formaggio, pancarrè.
Spalma un velo di burro all'esterno.
Cuoci nella tostiera o in padella 2-3 minuti per lato, finché il formaggio fila.

focaccia-farcita
Scalda la focaccia in forno caldo 3-4 minuti.
Tagliala a metà e farciscila con la mortadella.

panino-tacchino
Taglia il pane a metà e spalma un velo di maionese.
Farcisci con lattuga, fesa di tacchino e pomodoro a fette.

patate-forno
Accendi il forno a 200 °C.
Taglia le patate a spicchi o a cubetti, sciacquale e asciugale.
Condiscile in teglia con olio, sale e rosmarino.
Cuoci 40-45 minuti girandole a metà, finché sono croccanti.

pure
Lessa le patate con la buccia in acqua salata per 30 minuti (finché una forchetta entra facilmente).
Sbucciale ancora calde e schiacciale con lo schiacciapatate.
Rimettile sul fuoco con il latte caldo e il burro, mescolando finché sono morbide.
Aggiusta di sale e aggiungi il grana.

insalata-mista
Lava e asciuga l'insalata.
Aggiungi pomodori a pezzi e carote grattugiate o a rondelle.
Condisci con olio, aceto e sale al momento di servire.

verdure-grigliate
Taglia zucchine e melanzane a fette di mezzo centimetro e i peperoni a falde.
Scalda bene una piastra e griglia le verdure 2-3 minuti per lato.
Condiscile con olio, sale e, se ti piace, aglio e menta o basilico.

spinaci-burro
Lava gli spinaci (se freschi) e cuocili in padella con poca acqua per 3-5 minuti; strizzali.
Ripassali nel burro per 2 minuti; sala.
Servi con un po' di grana.

fagiolini-patate
Spunta i fagiolini e taglia le patate a cubetti.
Lessali insieme in acqua salata per 15-20 minuti.
Scolali e condiscili con olio, sale e, se ti piace, aglio o prezzemolo.

peperonata
Taglia i peperoni a falde e la cipolla a fette.
Falli appassire nell'olio in un tegame per 10 minuti.
Aggiungi i pelati, sala e cuoci coperto a fuoco basso per 25-30 minuti.

caponata
Taglia le melanzane a cubetti e friggile nell'olio di semi; scolale.
In un tegame fai appassire cipolla e sedano a pezzetti, aggiungi i pelati, le olive e i capperi; cuoci 10 minuti.
Aggiungi l'aceto e lo zucchero e lascia evaporare 2 minuti.
Unisci le melanzane, mescola e lascia raffreddare: è più buona il giorno dopo.

carciofi
Pulisci i carciofi togliendo le foglie dure e le punte; tagliali a spicchi e mettili in acqua e limone.
Scalda l'olio con l'aglio, aggiungi i carciofi scolati e un po' d'acqua.
Cuoci coperto 15-20 minuti finché sono teneri; sala e aggiungi prezzemolo.

funghi-trifolati
Pulisci i funghi con un panno umido e affettali.
Scalda l'olio con l'aglio e aggiungi i funghi a fuoco vivace.
Cuoci 10 minuti finché perdono e riassorbono l'acqua; sala e aggiungi prezzemolo.

cavolfiore-gratinato
Accendi il forno a 200 °C.
Lessa le cimette di cavolfiore in acqua salata per 8 minuti; scolale.
Mettile in una pirofila, coprile con la besciamella, il grana e il pangrattato.
Gratina 15-20 minuti finché la superficie è dorata.

finocchi-gratinati
Accendi il forno a 200 °C.
Taglia i finocchi a spicchi e lessali 8 minuti in acqua salata; scolali.
Mettili in una pirofila con la besciamella e il grana.
Gratina 15-20 minuti.

patatine
Accendi il forno alla temperatura indicata sulla confezione (di solito 220 °C).
Distribuisci le patatine su una teglia con carta forno in un solo strato.
Cuoci il tempo indicato girandole a metà; sala alla fine.

broccoli-padella
Dividi i broccoli in cimette e sbollentale 4 minuti in acqua salata.
Saltale in padella con olio, aglio e peperoncino per 5 minuti.
Aggiusta di sale e servi.

tiramisu
Prepara il caffè e lascialo raffreddare.
Sbatti i tuorli con lo zucchero finché sono chiari e spumosi, poi aggiungi il mascarpone.
Monta gli albumi a neve e uniscili delicatamente alla crema.
Inzuppa velocemente i biscotti nel caffè e alterna in una pirofila strati di biscotti e crema.
Finisci con il cacao e lascia in frigo almeno 4 ore. (Usa uova freschissime o pastorizzate.)

torta-mele
Accendi il forno a 180 °C e imburra una tortiera.
Sbatti uova e zucchero finché sono spumosi, aggiungi il burro fuso e il latte.
Unisci farina e lievito setacciati e metà delle mele a pezzetti.
Versa nella tortiera, copri con le mele rimaste a fettine e cuoci 40-45 minuti (fai la prova stecchino).

macedonia
Lava e taglia la frutta a pezzetti.
Mettila in una ciotola con il succo di limone e lo zucchero.
Mescola e lascia riposare in frigo 30 minuti.

yogurt-frutta
Lascia scongelare i frutti di bosco a temperatura ambiente (o usali freschi).
Metti lo yogurt in una ciotola, aggiungi la frutta e il miele.

pancake
Sbatti l'uovo con il latte e lo zucchero, poi aggiungi il burro fuso.
Unisci farina e lievito e mescola finché non ci sono grumi.
Scalda una padella antiaderente appena unta e versa un mestolino di impasto alla volta.
Quando compaiono le bollicine giralo e cuoci un altro minuto. Servi con il miele.
''');

Map<String, List<String>> _leggi(String testo) {
  final out = <String, List<String>>{};
  for (final blocco in testo.trim().split(RegExp(r'\n\s*\n'))) {
    final righe = blocco
        .split('\n')
        .map((r) => r.trim())
        .where((r) => r.isNotEmpty)
        .toList();
    if (righe.length > 1) out[righe.first] = righe.sublist(1);
  }
  return out;
}
