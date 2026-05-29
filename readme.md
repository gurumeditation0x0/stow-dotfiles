
# Table of Contents

1.  [Présentation](#presentation)
2.  [Installer Emacs pour Linux](#emacs-pour-linux)
    1.  [Installer emacs selon la distribution.](#orgfd4166b)
    2.  [On peut utiliser stow au lieu de copier les répertoires manuellement.](#org5b301c1)
    3.  [Configuration Gpg  .authinfo](#orge961892)
    4.  [Fichiers à éditer](#org512f3cd)
3.  [Installer Emacs pour Windows](#installer-emacs-pour-windows)
        1.  [cmd.exe](#org641e6a7)
        2.  [powershell](#org5ac0874)
4.  [Configurer Emacs](#configurer-emacs)
    1.  [Fichiers et répertoires à copier depuis le dépôt](#org4068c44)
    2.  [Configurer la variable HOME pour Windows](#configurer-home-pour-Windows)
    3.  [Ajouter %HOME%\\\bin au PATH](#ajouter-home-bin-au-path)
        1.  [Installer GPG](#installer-gpg)
        2.  [Générer une clé GPG](#generer-une-cle-gpg)
        3.  [Créer et chiffrer .authinfo](#creer-et-chiffrer-authinfo)
        4.  [Installer mplayer](#installer-mplayer)
        5.  [CMD](#org3c17ed6)
        6.  [PowerShell](#org21cf4c7)
        7.  [Fichiers à éditer](#fichiers-a-editer)
5.  [Prise de notes Orgzly Emacs-Pour-Windows](#org4f42a23)
    1.  [Shéma de synnchronisation avec SyncThing](#org6357eae)
    2.  [Orglzly](#orgf8d71ff)
    3.  [Denote](#org49c76f2)
6.  [Notes](#notes-de-securite)
    1.  [](#orgc2e365e)



<a id="presentation"></a>

# Présentation

Configuration Emacs pour Windows et Linux et WSL Linux. 


<a id="emacs-pour-linux"></a>

# Installer Emacs pour Linux


<a id="orgfd4166b"></a>

## Installer emacs selon la distribution.

<https://www.gnu.org/software/emacs/download.html>


<a id="org5b301c1"></a>

## On peut utiliser stow au lieu de copier les répertoires manuellement.

<https://www.gnu.org/software/stow/>

    cd stow-dotfiles && 
    stow emacs


<a id="orge961892"></a>

## Configuration Gpg  .authinfo

-   [Générer une clé GPG](#generer-une-cle-gpg)
-   [Créer et chiffrer .authinfo](#creer-et-chiffrer-authinfo)


<a id="org512f3cd"></a>

## Fichiers à éditer

-   [Fichiers à éditer](#fichiers-a-editer)


<a id="installer-emacs-pour-windows"></a>

# Installer Emacs pour Windows

<https://www.gnu.org/software/emacs/download.html>

Vérifier l’installation dans cmd.exe / PowerShell :

    emacs --version

Si la commande n’est pas reconnue, ajouter Emacs au PATH :


<a id="org641e6a7"></a>

### cmd.exe

    setx PATH "%PATH%;C:\Program Files\Emacs\bin"

Redémarrer le terminal ou windows.


<a id="org5ac0874"></a>

### powershell

    [Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\Program Files\Emacs\bin", [EnvironmentVariableTarget]::User)

Redémarrer le terminal ou windows.


<a id="configurer-emacs"></a>

# Configurer Emacs


<a id="org4068c44"></a>

## Fichiers et répertoires à copier depuis le dépôt

-   emacs.d/early-init.el
-   emacs.d/init.el
-   emacs.d/elisp/
-   emacs.d/config/
-   emacs.d/sons/
-   emacs.d/images/ (optionnel)

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


<a id="configurer-home-pour-Windows"></a>

## Configurer la variable HOME pour Windows

Définir HOME vers votre dossier utilisateur (persistant).

1.  cmd.exe

        setx HOME "%USERPROFILE%"
    
    Redémarrer le terminal.
    Vérifier :
    
        echo %HOME%

2.  PowerShell

        [Environment]::SetEnvironmentVariable("HOME", $Env:USERPROFILE, "User")
    
    Redémarrer le terminal.
    Vérifier :
    
        echo $Env:HOME


<a id="ajouter-home-bin-au-path"></a>

## Ajouter %HOME%\\\bin au PATH

Créer le dossier :

    mkdir %HOME%\bin

1.  cmd.exe

        setx PATH "%PATH%;%HOME%\bin"
    
    Redémarrer le terminal.
    Test du PATH
    
        echo %PATH%

2.  PowerShell

        [Environment]::SetEnvironmentVariable("Path", $Env:Path + ";" + "$Env:HOME\bin", "User")
    
    Redémarrer le terminal.
    Test du PATH
    
        $env:PATH


<a id="installer-gpg"></a>

### Installer GPG

Télécharger Gpg4win : <https://gpg4win.org/>
Vérifier l’installation :

    gpg --version


<a id="generer-une-cle-gpg"></a>

### Générer une clé GPG

    gpg --full-generate-key

Recommandations :

-   Type : RSA and RSA
-   Taille : 4096 bits
-   Phrase secrète forte

Lister les clés :

    gpg --list-secret-keys


<a id="creer-et-chiffrer-authinfo"></a>

### Créer et chiffrer .authinfo

*(Pour Gmail : créer un mot de passe d’application sur accounts.google.com si nécessaire.)*

Créer le fichier : %HOME%\\.authinfo
Exemple de contenu :

    machine smtp.gmail.com login utilisateur@gmail.com password motdepasse port 587
    machine imap.gmail.com login utilisateur@gmail.com password motdepasse port 993

Chiffrer le fichier (remplacez votre@email.com par votre UID GPG) :

    gpg -e -r votre@email.com .authinfo

Sécuriser .authinfo.gpp

    chmod 600 .authinfo.gpg

Supprimer le fichier en clair :

    del .authinfo

**Conserver uniquement : .authinfo.gpg**


<a id="installer-mplayer"></a>

### Installer mplayer

-   Télécharger le binaire mplayer pour Windows.
-   Installer dans %USERPROFILE%\bin ou %HOME%\bin.

Ajouter au PATH si nécessaire :


<a id="org3c17ed6"></a>

### CMD

    setx PATH "%PATH%;%HOME%\bin"

Redémarrer le terminal.


<a id="org21cf4c7"></a>

### PowerShell

    [Environment]::SetEnvironmentVariable("Path", $Env:Path + ";" + "$Env:HOME\bin", "User")

Redémarrer le terminal.


<a id="fichiers-a-editer"></a>

### Fichiers à éditer

    - %HOME%/.authinfo
    - %HOME%/.emacs.d/config/emms_config.el
    - %HOME%/.emacs.d/config/gnus_conf.el
    - %HOME%/.emacs.d/config/email.el
    - %HOME%/.emacs.d/config/meteo.el (coordonnées GPS)

&#x2013;


<a id="org4f42a23"></a>

# Prise de notes Orgzly Emacs-Pour-Windows

-   Orgzly

Emacs possède une version Android, mais sur un téléphone c'est un peu petit. J'ai donc choisi Orgzly pour la prise de notes rapide que je synchronise avec SyncThing.
<https://www.orgzly.com/>

-   Denote

<https://protesilaos.com/emacs/denote>
Outils Emacs pour la prise de notes et l'orginisation.

-   my-os est défini dans early-init.el


<a id="org6357eae"></a>

## Shéma de synnchronisation avec SyncThing

![img](graph_prise_de_note.png)


<a id="orgf8d71ff"></a>

## Orglzly

Télécharger:
<https://www.orgzly.com/>
La configuration se fait par l'interface


<a id="org49c76f2"></a>

## Denote

Manuel:
<https://protesilaos.com/emacs/denote>

Choix du répertoire de travail de Denote. \n
Fonction pour décider quel sera le répertoire de destination des notes Denote.\n
⚠️ Attention my-os est défini dans early-init.el .

-   dans emacs.d/config/config/denote.el

    (defvar my-denote-directory
      (expand-file-name
       (cond
        ;; Windows natif
        ((eq my-os 'windows)
         (expand-file-name "Documents/Denote" home-dir))
    
        ;; WSL Linux
        ((and (symbolp my-os)
              (string-prefix-p "wsl-" (symbol-name my-os)))
         (expand-file-name
          (format "/mnt/c/Users/%s/Documents/Denote"
                  my-windows-username)))
    
        ;; Linux natif
        ((eq my-os 'linux)
         (expand-file-name "Documents/Denote" home-dir))
    
        ;; fallback
        (t
         (expand-file-name "Documents/Denote" home-dir))))
      "Répertoire Denote selon OS.")


<a id="notes-de-securite"></a>

# Notes

Ne jamais committer :

    - .authinfo
    - .authinfo.gpg
    - Clés privées GPG
    - Clés ivy-youtube dans emms_config
    - Les adresses mail dans gnus-conf.el et email.el
    
    Ajouter au .gitignore :
    
    *~
    *#
    #*
    /emacs.d/.emacs.d/elpa/
    /emacs.d/.emacs.d/eln-cache/
    /emacs.d/.emacs.d/emms/
    /emacs.d/.emacs.d/multisession/
    /emacs.d/.emacs.d/request/
    /emacs.d/.emacs.d/transient/
    /emacs.d/.emacs.d/elfeed_db/
    /emacs.d/.emacs.d/games/
    emacs.d/.emacs.d/request/
    
    authinfo/.authinfo
    authinfo/.authinfo.gpg
    
    emacs.d/.emacs.d/config/gnus-conf.el
    emacs.d/.emacs.d/donfig/email.el


<a id="orgc2e365e"></a>

## A FAIRE 

-   Installation des emoji et fonts.
-   Synchronisation Google Calendar avec le calendrier Emacs.
-   Import, Export des contacts.
-   Visiter Pompéi.

