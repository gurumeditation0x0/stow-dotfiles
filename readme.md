- [Notes de sécurité](#notes-de-securite)
- [Présentation](#presentation)
- [Emacs pour Windows](#emacs-pour-windows)
  - [Installer Emacs pour Windows](#installer-emacs-pour-windows)
  - [Configurer Emacs](#configurer-emacs)
    - [Fichiers et répertoires à copier depuis le dépôt](#org689268e)
  - [Configurer la variable HOME](#configurer-home)
    - [Ajouter %HOME%\\\bin au PATH](#ajouter-home-bin-au-path)
  - [Installer GPG](#installer-gpg)
    - [Générer une clé GPG](#generer-une-cle-gpg)
    - [Créer et chiffrer .authinfo](#creer-et-chiffrer-authinfo)
  - [Installer mplayer](#installer-mplayer)
    - [CMD](#org62ea411)
    - [PowerShell](#org9903d95)
  - [9. Fichiers à éditer](#fichiers-a-editer)



<a id="notes-de-securite"></a>

# Notes de sécurité

Ne jamais committer :

-   .authinfo
-   .authinfo.gpg
-   Clés privées GPG
-   Clés ivy-youtube dans emms<sub>config</sub>
-   Les adresses mail dans gnus-conf.el et email.el

Ajouter au .gitignore :

-   .authinfo
-   gnus-conf.el
-   email.el
-   emms<sub>config</sub>


<a id="presentation"></a>

# Présentation


<a id="emacs-pour-windows"></a>

# Emacs pour Windows

-   Installer Emacs sous Windows
-   Répertoires et fichiers à copier
-   Configurer la variable d’environnement HOME
-   Ajouter HOME\bin au PATH
-   Installer et configurer GnuPG (GPG)
-   Créer et chiffrer un fichier .authinfo.gpg
-   Mplayer


<a id="installer-emacs-pour-windows"></a>

## Installer Emacs pour Windows

<https://www.gnu.org/software/emacs/download.html>

Vérifier l’installation dans cmd.exe / PowerShell :

```shell
emacs --version
```

Si la commande n’est pas reconnue, ajouter Emacs au PATH :

```shell
setx PATH "%PATH%;C:\Program Files\Emacs\bin"
```

```powershell
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\Program Files\Emacs\bin", [EnvironmentVariableTarget]::User)
```

Redémarrer le terminal.


<a id="configurer-emacs"></a>

## Configurer Emacs


<a id="org689268e"></a>

### Fichiers et répertoires à copier depuis le dépôt

-   emacs.d/early-init.el
-   emacs.d/init.el
-   emacs.d/elisp/
-   emacs.d/config/
-   emacs.d/sons/
-   emacs.d/images/ (optionnel)

```
HOME/
   ├── .authinfo.gpg
   ├── bin/
   ├── GNU/
   ├── .emacs.d/
          ├── early-init.el
          ├── init.el
          ├── config/
          ├── elisp/
          └── sons/
```


<a id="configurer-home"></a>

## Configurer la variable HOME

Définir HOME vers votre dossier utilisateur (persistant).

1.  cmd.exe

    ```shell
    setx HOME "%USERPROFILE%"
    ```
    
    Redémarrer le terminal. Vérifier :
    
    ```shell
    echo %HOME%
    ```

2.  PowerShell

    ```powershell
    [Environment]::SetEnvironmentVariable("HOME", $Env:USERPROFILE, "User")
    ```
    
    Redémarrer le terminal. Vérifier :
    
    ```powershell
    echo $Env:HOME
    ```


<a id="ajouter-home-bin-au-path"></a>

### Ajouter %HOME%\\\bin au PATH

Créer le dossier :

```shell
mkdir %HOME%\bin
```

1.  cmd.exe

    ```shell
    setx PATH "%PATH%;%HOME%\bin"
    ```
    
    Redémarrer le terminal. Test du PATH
    
    ```shell
    echo %PATH%
    ```

2.  PowerShell

    ```powershell
    [Environment]::SetEnvironmentVariable("Path", $Env:Path + ";" + "$Env:HOME\bin", "User")
    ```
    
    Redémarrer le terminal. Test du PATH
    
    ```powershell
    $env:PATH
    ```


<a id="installer-gpg"></a>

## Installer GPG

Télécharger Gpg4win : <https://gpg4win.org/> Vérifier l’installation :

```shell
gpg --version
```


<a id="generer-une-cle-gpg"></a>

### Générer une clé GPG

```shell
gpg --full-generate-key
```

Recommandations :

-   Type : RSA and RSA
-   Taille : 4096 bits
-   Phrase secrète forte

Lister les clés :

```shell
gpg --list-secret-keys
```


<a id="creer-et-chiffrer-authinfo"></a>

### Créer et chiffrer .authinfo

*(Pour Gmail : créer un mot de passe d’application sur accounts.google.com si nécessaire.)*

Créer le fichier : %HOME%\\.authinfo Exemple de contenu :

```
machine smtp.gmail.com login utilisateur@gmail.com password motdepasse port 587
machine imap.gmail.com login utilisateur@gmail.com password motdepasse port 993
```

Chiffrer le fichier (remplacez votre@email.com par votre UID GPG) :

```shell
gpg -e -r votre@email.com .authinfo
```

Sécuriser .authinfo.gpp

```shell
chmod 600 .authinfo.gpg
```

Supprimer le fichier en clair :

```shell
del .authinfo
```

**Conserver uniquement : .authinfo.gpg**


<a id="installer-mplayer"></a>

## Installer mplayer

-   Télécharger le binaire mplayer pour Windows.
-   Installer dans %USERPROFILE%\bin ou %HOME%\bin.

Ajouter au PATH si nécessaire :


<a id="org62ea411"></a>

### CMD

```shell
setx PATH "%PATH%;%HOME%\bin"
```

Redémarrer le terminal.


<a id="org9903d95"></a>

### PowerShell

```powershell
[Environment]::SetEnvironmentVariable("Path", $Env:Path + ";" + "$Env:HOME\bin", "User")
```

Redémarrer le terminal.


<a id="fichiers-a-editer"></a>

## 9. Fichiers à éditer

-   %HOME%/.authinfo
-   %HOME%/.emacs.d/config/emms<sub>config.el</sub>
-   %HOME%/.emacs.d/config/gnus<sub>conf.el</sub>
-   %HOME%/.emacs.d/config/email.el
-   %HOME%/.emacs.d/config/meteo.el (coordonnées GPS)

&#x2013;
