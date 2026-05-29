
# Table of Contents



1.  [Présentation](#presentation)
2.  [Installer Emacs pour Linux](#emacs-pour-linux)
    1.  [Installer emacs selon la distribution.](#org058471c)
    2.  [On peut utiliser stow au lieu de copier les répertoires manuellement.](#orgf14f68a)
    3.  [Configuration Gpg .authinfo](#orgad07d4b)
    4.  [Fichiers à éditer](#org9251896)
3.  [Installer Emacs pour Windows](#installer-emacs-pour-windows)
    1.  [cmd.exe](#org1d004a8)
    2.  [powershell](#orgd68b862)
4.  [Configurer Emacs](#configurer-emacs)
    1.  [Fichiers et répertoires à copier depuis le dépôt](#org83d64c5)
    2.  [Configurer la variable HOME pour Windows](#configurer-home-pour-Windows)
    3.  [Ajouter %HOME%\\\\\\\\\bin au PATH](#ajouter-home-bin-au-path)
        1.  [Installer GPG](#installer-gpg)
        2.  [Générer une clé GPG](#generer-une-cle-gpg)
        3.  [Créer et chiffrer .authinfo](#creer-et-chiffrer-authinfo)
        4.  [Installer mplayer](#installer-mplayer)
        5.  [CMD](#orgd045b4d)
        6.  [PowerShell](#org771d275)
        7.  [Fichiers à éditer](#fichiers-a-editer)
5.  [Prise de notes Orgzly Emacs-Pour-Windows](#org7a1391f)
    1.  [Shéma de synnchronisation avec SyncThing](#org0ea11f2)
    2.  [Orglzly](#orgb283bc7)
    3.  [Denote](#orgb1bb3a5)
6.  [Notes](#notes-de-securite)
    1.  [](#org0c2c484)

<a id="presentation"></a>

Configuration Emacs pour Windows et Linux et WSL Linux.

<a id="emacs-pour-linux"></a>

<a id="org058471c"></a>

\\## Installer emacs selon la distribution.

<https://www.gnu.org/software/emacs/download.html>

<a id="orgf14f68a"></a>

\\## On peut utiliser stow au lieu de copier les répertoires manuellement.

<https://www.gnu.org/software/stow/>

cd stow-dotfiles && stow emacs

<a id="orgad07d4b"></a>

\\## Configuration Gpg .authinfo

-   [Générer une clé GPG](#generer-une-cle-gpg)
-   [Créer et chiffrer .authinfo](#creer-et-chiffrer-authinfo)

<a id="org9251896"></a>

\\## Fichiers à éditer

-   [Fichiers à éditer](#fichiers-a-editer)

<a id="installer-emacs-pour-windows"></a>

<https://www.gnu.org/software/emacs/download.html>

Vérifier l’installation dans cmd.exe / PowerShell :

emacs &#x2013;version

Si la commande n’est pas reconnue, ajouter Emacs au PATH :

<a id="org1d004a8"></a>

\\### cmd.exe

setx PATH "%PATH%;C:\Program Files\Emacs\bin"

Redémarrer le terminal ou windows.

<a id="orgd68b862"></a>

\\### powershell

[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\Program Files\Emacs\bin", [EnvironmentVariableTarget]::User)

Redémarrer le terminal ou windows.

<a id="configurer-emacs"></a>

<a id="org83d64c5"></a>

\\## Fichiers et répertoires à copier depuis le dépôt

-   emacs.d/early-init.el
-   emacs.d/init.el
-   emacs.d/elisp/
-   emacs.d/config/
-   emacs.d/sons/
-   emacs.d/images/ (optionnel)
    
    HOME/ ├── .authinfo.gpg ├── bin/ ├── GNU/ ├── .emacs.d/ ├── early-init.el ├── init.el ├── config/ ├── elisp/ └── sons/

<a id="configurer-home-pour-Windows"></a>

\\## Configurer la variable HOME pour Windows

Définir HOME vers votre dossier utilisateur (persistant).

1.  cmd.exe
    
    setx HOME "%USERPROFILE%"
    
    Redémarrer le terminal. Vérifier :
    
    echo %HOME%

2.  PowerShell
    
    [Environment]::SetEnvironmentVariable("HOME", $Env:USERPROFILE, "User")
    
    Redémarrer le terminal. Vérifier :
    
    echo $Env:HOME

<a id="ajouter-home-bin-au-path"></a>

\\## Ajouter %HOME%\\\\\\\\\bin au PATH

Créer le dossier :

mkdir %HOME%\bin

1.  cmd.exe
    
    setx PATH "%PATH%;%HOME%\bin"
    
    Redémarrer le terminal. Test du PATH
    
    echo %PATH%

2.  PowerShell
    
    [Environment]::SetEnvironmentVariable("Path", $Env:Path + ";" + "$Env:HOME\bin", "User")
    
    Redémarrer le terminal. Test du PATH
    
    $env:PATH

<a id="installer-gpg"></a>

\\### Installer GPG

Télécharger Gpg4win : <https://gpg4win.org/> Vérifier l’installation :

gpg &#x2013;version

<a id="generer-une-cle-gpg"></a>

\\### Générer une clé GPG

gpg &#x2013;full-generate-key

Recommandations :

-   Type : RSA and RSA
-   Taille : 4096 bits
-   Phrase secrète forte

Lister les clés :

gpg &#x2013;list-secret-keys

<a id="creer-et-chiffrer-authinfo"></a>

\\### Créer et chiffrer .authinfo

****(Pour Gmail : créer un mot de passe d’application sur accounts.google.com si nécessaire.)****

Créer le fichier : %HOME%\\\\\\\\.authinfo Exemple de contenu :

machine smtp.gmail.com login utilisateur@gmail.com password motdepasse port 587 machine imap.gmail.com login utilisateur@gmail.com password motdepasse port 993

Chiffrer le fichier (remplacez votre@email.com par votre UID GPG) :

gpg -e -r votre@email.com .authinfo

Sécuriser .authinfo.gpp

chmod 600 .authinfo.gpg

Supprimer le fichier en clair :

del .authinfo

********Conserver uniquement : .authinfo.gpg********

<a id="installer-mplayer"></a>

\\### Installer mplayer

-   Télécharger le binaire mplayer pour Windows.
-   Installer dans %USERPROFILE%\bin ou %HOME%\bin.

Ajouter au PATH si nécessaire :

<a id="orgd045b4d"></a>

\\### CMD

setx PATH "%PATH%;%HOME%\bin"

Redémarrer le terminal.

<a id="org771d275"></a>

\\### PowerShell

[Environment]::SetEnvironmentVariable("Path", $Env:Path + ";" + "$Env:HOME\bin", "User")

Redémarrer le terminal.

<a id="fichiers-a-editer"></a>

\\### Fichiers à éditer

-   %HOME%/.authinfo
-   %HOME%/.emacs.d/config/emms<sub>config.el</sub>
-   %HOME%/.emacs.d/config/gnus<sub>conf.el</sub>
-   %HOME%/.emacs.d/config/email.el
-   %HOME%/.emacs.d/config/meteo.el (coordonnées GPS)

&#x2013;

<a id="org7a1391f"></a>

-   Orgzly

Emacs possède une version Android, mais sur un téléphone c'est un peu petit. J'ai donc choisi Orgzly pour la prise de notes rapide que je synchronise avec SyncThing. <https://www.orgzly.com/>

-   Denote

<https://protesilaos.com/emacs/denote> Outils Emacs pour la prise de notes et l'orginisation.

-   my-os est défini dans early-init.el

<a id="org0ea11f2"></a>

\\## Shéma de synnchronisation avec SyncThing

\\\![img](graph<sub>prise</sub><sub>de</sub><sub>note.png</sub>)

<a id="orgb283bc7"></a>

\\## Orglzly

Télécharger: <https://www.orgzly.com/> La configuration se fait par l'interface

<a id="orgb1bb3a5"></a>

\\## Denote

Manuel: <https://protesilaos.com/emacs/denote>

Choix du répertoire de travail de Denote. \n Fonction pour décider quel sera le répertoire de destination des notes Denote.\n ⚠️ Attention my-os est défini dans early-init.el .

-   dans emacs.d/config/config/denote.el
    
    (defvar my-denote-directory (expand-file-name (cond ;; Windows natif ((eq my-os 'windows) (expand-file-name "Documents/Denote" home-dir))
    
    ;; WSL Linux ((and (symbolp my-os) (string-prefix-p "wsl-" (symbol-name my-os))) (expand-file-name (format "/mnt/c/Users/%s/Documents/Denote" my-windows-username)))
    
    ;; Linux natif ((eq my-os 'linux) (expand-file-name "Documents/Denote" home-dir))
    
    ;; fallback (t (expand-file-name "Documents/Denote" home-dir)))) "Répertoire Denote selon OS.")

<a id="notes-de-securite"></a>

Ne jamais committer :

-   .authinfo
-   .authinfo.gpg
-   Clés privées GPG
-   Clés ivy-youtube dans emms<sub>config</sub>
-   Les adresses mail dans gnus-conf.el et email.el

Ajouter au .gitignore :

****~ \\\*# \\#**** **emacs.d**.emacs.d/elpa/ **emacs.d**.emacs.d/eln-cache/ **emacs.d**.emacs.d/emms/ **emacs.d**.emacs.d/multisession/ **emacs.d**.emacs.d/request/ **emacs.d**.emacs.d/transient/ **emacs.d**.emacs.d/elfeed<sub>db</sub>/ **emacs.d**.emacs.d/games/ emacs.d/.emacs.d/request/

authinfo/.authinfo authinfo/.authinfo.gpg

emacs.d/.emacs.d/config/gnus-conf.el emacs.d/.emacs.d/donfig/email.el

<a id="org0c2c484"></a>

\\## A FAIRE

-   Installation des emoji et fonts.
-   Synchronisation Google Calendar avec le calendrier Emacs.
-   Import, Export des contacts.
-   Visiter Pompéi.

