# Minitalk - Projet 42

## 📚 Description

**Minitalk** est un projet de l'école 42 qui consiste à réaliser une communication entre deux programmes via des signaux UNIX. Le but est d'implémenter un client et un serveur capables d'échanger des messages en utilisant uniquement les signaux `SIGUSR1` et `SIGUSR2`.

Le serveur reçoit des signaux envoyés par le client, les interprète et affiche le message sur la sortie standard.

---

## 🛠️ Fonctionnalités

- Communication inter-processus (IPC) via signaux UNIX
- Envoi de chaînes de caractères du client vers le serveur
- Affichage du message reçu côté serveur
- Gestion des erreurs de base

---

## 📂 Fichiers

- `server.c` : Code source du serveur
- `client.c` : Code source du client
- `minitalk.h` : Fichier d'en-tête
- `Makefile` : Compilation du projet

---

## 🚀 Utilisation

### 1. Compilation

```bash
make
```

### 2. Lancement du serveur

```bash
./server
```

Le serveur affiche son PID à l'écran. Notez ce PID, il est nécessaire pour le client.

### 3. Envoi d'un message depuis le client

```bash
./client <PID_du_serveur> "Votre message ici"
```

Exemple :
```bash
./client 12345 "Hello, World!"
```

---

## 📝 Contraintes

- Utilisation exclusive des signaux `SIGUSR1` et `SIGUSR2`
- Pas de communication via sockets, pipes, etc.
- Gestion correcte des erreurs (PID invalide, message vide...)

---

## 💡 Astuces & Ressources

- Consultez la documentation sur les signaux (`man 7 signal`)
- Utilisez les fonctions `kill()`, `signal()` ou `sigaction()`
- Pensez à synchroniser l’envoi/réception des bits

---

## 👤 Auteur

Projet réalisé par [bhyant](https://github.com/bhyant) dans le cadre du cursus 42.

