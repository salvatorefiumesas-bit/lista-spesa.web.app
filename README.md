# Lista Spesa 🛒

Lista della spesa condivisa per la famiglia, fatta in Flutter.

- **Catalogo per reparti**: scegli il prodotto (es. *Deodorante*) e poi la marca (*Dove, Nivea, Borotalco…*), ognuna con la sua immagine.
- **Si ordina da sola**: la lista è raggruppata per reparto (frutta e verdura, carne, latticini, pulizia casa…) nell'ordine del supermercato.
- **Condivisa in tempo reale**: uno aggiunge, l'altro vede subito e spunta ciò che mette nel carrello.
- **Funziona anche senza rete** al supermercato: si sincronizza quando torna il segnale.
- **Idee per pranzo e cena**: 153 piatti; scegli le persone e gli ingredienti vanno in lista con le dosi giuste.
- **Calorie e peso**: ogni prodotto si può prendere a pezzi o a peso (g/kg, ml/l) con le calorie calcolate.
- **Ricerca** per prodotto o per marca (scrivi "Dash" e trovi il detersivo), più prodotti e marche personali.

## Dove si usa

| Telefono | Come |
|---|---|
| **iPhone** | Apri il link in **Safari** → Condividi → **Aggiungi alla schermata Home**. L'app lo spiega da sola con un banner. |
| **Android** | Dal link nel browser tocca **Installa**, oppure installa l'APK (vedi sotto). |

Link dell'app: **https://salvatorefiumesas-bit.github.io/lista-spesa.web.app/**

## Da fare una volta sola

### 1. Attivare GitHub Pages
Repository → **Settings** → **Pages** → *Build and deployment* → Source: **GitHub Actions**.
Da quel momento ogni modifica su `main` pubblica l'app in automatico (scheda **Actions**).

### 2. Collegare Firebase (per condividere la lista)
Senza Firebase l'app funziona lo stesso, ma la lista resta solo sul telefono.

1. Vai su [console.firebase.google.com](https://console.firebase.google.com) → **Aggiungi progetto** (es. `lista-spesa`). Analytics non serve.
2. **Build → Authentication** → *Inizia* → scheda *Sign-in method* → attiva **Anonimo**.
3. **Build → Firestore Database** → *Crea database* → posizione `eur3 (europe-west)` → modalità produzione.
   Poi scheda **Regole**: incolla il contenuto di [`firestore.rules`](firestore.rules) e **Pubblica**.
4. **Impostazioni progetto** (ingranaggio) → *Le tue app* → icona **`</>`** (Web) → nome `Lista Spesa` → registra.
   Copia i valori di `firebaseConfig` (apiKey, authDomain, projectId, …).
5. (Per l'app Android) nella stessa pagina aggiungi un'app **Android** con pacchetto `app.listaspesa.lista_spesa` e copia l'**ID app**.
6. Incolla i valori in [`lib/firebase_config.dart`](lib/firebase_config.dart). Non sono segreti: la protezione la fanno le regole del punto 3.
7. Authentication → **Settings** → *Domini autorizzati* → aggiungi `salvatorefiumesas-bit.github.io`.

### 3. Condividere la lista
Sul primo telefono: icona delle persone in alto → **Crea la famiglia** → **Copia l'invito** e mandalo su WhatsApp.
Sul secondo telefono: apri il link, icona delle persone → scrivi il **codice** → **Entra**.

## App Android (APK)
Nella pagina del repository, a destra (o in fondo dal telefono): **Rilasci → App Android → lista-spesa.apk**.
Scaricalo dal telefono e aprilo (Android chiederà di consentire l'installazione da questa fonte).

## Sviluppo

```bash
flutter pub get
flutter run -d chrome        # versione web
flutter run                  # telefono Android collegato
flutter test
```

Struttura:

```
lib/
  main.dart              avvio, tema, schermata di benvenuto
  models.dart            Reparto, Prodotto, Voce della lista
  catalogo.dart          catalogo di base (prodotti e marche) e ricerca del reparto
  stato.dart             logica: lista, famiglia, prodotti personali
  archivio.dart          salvataggio: sul telefono o su Firestore
  firebase_config.dart   configurazione Firebase
  installa/              banner "Installa l'app" (iPhone/Android, solo web)
  ui/                    schermate
firestore.rules          regole di sicurezza del database
```

## Prossimi passi
- Foto delle marche (fotocamera) e immagini da Open Food Facts
- Scansione del codice a barre
- Ordine dei reparti personalizzato per il proprio supermercato
- Prodotti usati più spesso in cima
