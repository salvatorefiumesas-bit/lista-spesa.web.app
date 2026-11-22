import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Configurazione di Firebase (serve per condividere la lista tra due telefoni).
///
/// Come compilarla:
/// 1. console.firebase.google.com → crea un progetto (es. "lista-spesa").
/// 2. Impostazioni progetto → "Le tue app" → aggiungi un'app Web (icona </>)
///    e copia qui sotto i valori di `firebaseConfig`.
/// 3. (Per l'app Android) aggiungi anche un'app Android con pacchetto
///    `app.listaspesa.lista_spesa` e copia il suo "ID app" in [androidAppId].
///
/// Questi valori NON sono segreti: è normale che stiano nel codice pubblico.
/// La sicurezza la danno le regole di Firestore (file firestore.rules).
///
/// Finché [apiKey] è vuota l'app funziona lo stesso, ma la lista resta
/// solo sul telefono.
const apiKey = 'AIzaSyBw6XG5IUPQEHFUhmjJdfja-FvX8SYvWt4';
const authDomain = 'listaspesaapp-4a0aa.firebaseapp.com';
const projectId = 'listaspesaapp-4a0aa';
const storageBucket = 'listaspesaapp-4a0aa.firebasestorage.app';
const messagingSenderId = '837211278940';
const webAppId = '1:837211278940:web:ac147a6e0109ac4bb3a099';
const androidAppId = '';

bool get firebaseConfigurato =>
    apiKey.isNotEmpty &&
    projectId.isNotEmpty &&
    (kIsWeb
        ? webAppId.isNotEmpty
        : (androidAppId.isNotEmpty || webAppId.isNotEmpty));

FirebaseOptions get opzioniFirebase => FirebaseOptions(
  apiKey: apiKey,
  appId: kIsWeb || androidAppId.isEmpty ? webAppId : androidAppId,
  messagingSenderId: messagingSenderId,
  projectId: projectId,
  authDomain: authDomain.isEmpty ? null : authDomain,
  storageBucket: storageBucket.isEmpty ? null : storageBucket,
);
