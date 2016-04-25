# Riot

## Qu'est-ce qu'un composant?

Le dévéloppement par composants a été popularisé par la librairie [ReactJS](https://facebook.github.io/react/) de Facebook. Un composant est un élément HTML contenant la vue ainsi que les controleurs qui y sont associés. Dans notre application nous avons deux parties: 

* la liste ```<div id="liste">```
* le formulaire pour ajouter quelque chose à faire ou supprimer ce qui a été fait, ```<div id="formulaire">```. 

Une fois transformés en composants, le corps du document HTML ressemblera à ça:

```
<div id="contenu">
 <a-faire-liste></a-faire-liste>
 <a-faire-formulaire></a-faire-formulaire>
</div>
``` 

## Pourquoi Riot?

J'ai choisi d'utiliser Riot plutôt que React. D'une part parce que Riot est une librairie beaucoup plus légère. Et d'autre part parce que contrairement à React, qui une syntaxe bien à elle, Riot n'utilise que du javascript tout à fait classique.

### Mise en place

Créez un dossier ```4.riot``` et initialisez NPM.

```
$ npm init
```

Téléchargez les librairies ```riot``` et ```riotify```. ```riotify``` comme ```browserify-handlebars``` dans le [chapitre précédant](link_to_do) sert à convertir les fichiers ```.tag``` de riot en javascript lors de la construction du scripte final avec ```browserify```.

```
$ npm install riot riotify --save
```

Créez un fichier ```main.js``` et un dossier ```public``` à la racine du projet et ajoutez un scripte ```build``` à ```package.json```. Nous y ajoutons également un scripte ```watch``` qui met à jour ```public/script.js``` automatiquement pendant que nous nous travaillons dessus.

```
{
  "name": "4.riot",
  "version": "1.0.0",
  "description": "",
  "main": "main.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "build": "browserify main.js -o public/script.js -t riotify | minify public/script.js -o public/script.js",
    "watch": "watchify main.js -o public/script.js -t riotify"
  },
  "author": "idris-maps.com",
  "license": "GPL-2.0",
  "dependencies": {
    "riot": "^2.3.18",
    "riotify": "^1.0.0"
  }
}
```

Dans ```public```, ajoutez ```style.css``` du [chapitre "Mise en page"](link_to_do) et créez un fichier ```index.html``` comme suit.

```
<!doctype html>
<html>
 <head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Riot</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<!-- notre feuille de style -->
  <link rel="stylesheet" href="style.css">
 </head>
 <body>
  <div id="contenu">
   <h1>À faire</h1>
   <a-faire-liste></a-faire-liste>
   <a-faire-formulaire></a-faire-formulaire>
  </div>
  <script src="script.js"></script>
 </body>
</html>
```

Créez un dossier ```lib``` et copiez y ```Modele-a-faire.js``` du [chapitre 2](link_to_do) et créez un dossier ```composants```.

Notre dossier ```4.riot``` ressemble à ça:

```
4.riot
  -lib
    -composants
    Modele-a-faire.js
  -node_modules
    ...
  -public
    index.html
    style.css
  main.js
  package.json
```

### Le composant ```<a-faire-liste>```

Dans ```lib/composants```, créez un fichier ```a-faire-liste.tag```

```
<div class="liste-element a-faire">

 <div class="liste-element-info">
  <div class="liste-element-texte">
   <p>En cours de modification</p>
  </div>
  <div class="liste-element-modif">
   <span class="glyphicon glyphicon-pencil"></span>
  </div>
  <div class="liste-element-statut">
   <span class="glyphicon glyphicon-ok"></span>
  </div>
 </div>

 <div class="liste-element-maj">
  <div class="liste-element-maj-input">
   <input class="form-control" id="liste-element-maj-input" type="text">
  </div>
  <div class="liste-element-maj-bouton">
   <button class="btn btn-primary" id="liste-element-maj-bouton">OK</button>
  </div>
 </div>

</div> 
```

J'ai pris le HTML d'un des éléments de liste de ```index.html``` du [chapitre 1](link_to_do). Celui qui est en cours de modification.

Créez une balise ```<a-faire-liste>``` qui englobe tout le HTML et ajoutez y une balise ```<script>```.

```
<a-faire-liste>
 <!-- le HTML -->
 <script></script>
</a-faire-liste>
```

#### Boucle

Pour créer une boucle qui ajoute une balise ```<div class="liste-element a-faire">``` pour chaque élément du modèle, nous lui ajoutons ```each={ liste }```.

```
<div class="liste-element a-faire" each={ liste }>
```

#### Afficher une clé de chaque élément

Nous souhaitons avoir la clé ```text``` de l'élément à la place de ```En cours de modification```.

```
<p>En cours de modification</p>
```

devient

```
<p>{ text }</p>
```

#### Conditions

**Les classes de l'élément de la liste**

Si l'élément est ```fait``` nous voulons que les classes de la ```<div>``` soient ```class="liste-element fait"```, sinon ```class="liste-element a-faire"```.

```
<div class="liste-element a-faire" each={ liste }
```

devient

```
<div each= {liste} class="{fait ? 'liste-element fait' : 'liste-element a-faire'}">
```

**Les classes de l'icône pour basculer ```fait```**

De la même manière

```
<span class="glyphicon glyphicon-ok"></span>
```

devient

```
<span class="{fait ? 'glyphicon glyphicon-remove' : 'glyphicon glyphicon-ok'}"></span>
```

**Le formulaire de mise à jour**

Nous n'allons ajouter la balise ```<div class="liste-element-maj">``` que si l'élément est en cours de mise à jour.

```
<div if={ maj } class="liste-element-maj">
```

#### Le contexte du composant

Chaque composant a un contexte ```this``` à l'intérieur d'une balise ```<script>```. Nous allons le lier à une variable ```ctx```. 

Lors de la création du composant, nous allons lui passer le modèle. À l'intérieur du composant celui-ci sera accessible en tant que la variable ```opts```. 

Dans la vue nous avons défini la boucle ```each={ liste }```, le contexte doit donc avoir accès à notre liste qui dans le modèle est le dictionnaire ```data```

```
<script>
var ctx = this
ctx.modele = opts
ctx.liste = ctx.modele.data
</script>
```

Le fichier ```lib/composants/a-faire-liste.tag``` en entier:

```
<a-faire-liste>

 <div each={ liste } class="{fait ? 'liste-element fait' : 'liste-element a-faire'}">
  <div class="liste-element-info">
   <div class="liste-element-texte">
    <p>{ text }</p>
   </div>
   <div class="liste-element-modif">
    <span class="glyphicon glyphicon-pencil"></span>
   </div>
   <div class="liste-element-statut">
    <span class="{fait ? 'glyphicon glyphicon-remove' : 'glyphicon glyphicon-ok'}"></span>
   </div>
  </div>

  <div if={ maj } class="liste-element-maj">
   <div class="liste-element-maj-input">
    <input class="form-control" id="liste-element-maj-input" type="text">
   </div>
   <div class="liste-element-maj-bouton">
    <button class="btn btn-primary" id="liste-element-maj-bouton">OK</button>
   </div>
  </div>

 </div> 

 <script>
var ctx = this
ctx.modele = opts
ctx.liste = ctx.modele.data
 </script>

</a-faire-liste>
```

#### Monter le composant

Nous allons maintenant monter  ```<a-faire-liste>``` dans ```main.js```.

```
var riot = require('riot')
var Modele = require('./lib/Modele-a-faire')
var aFaireListe = require('./lib/composants/a-faire-liste.tag')

var modele = new Modele

riot.mount('a-faire-liste', modele)
```

Pour vérifiez que tout fonctionne, lancez le scripte ```watch```.

```
$ npm run watch
```

Et ouvrez ```public/index.html``` dans un navigateur.

#### Les contrôleurs du composant

Nous allons maintenant ajouter les contrôleurs.

**basculerFait**

Quand l'icône est clickée, basculer fait.

Dans le corps du composant:

```
<div class="liste-element-statut">
```

devient

```
<div class="liste-element-statut" onclick={ basculerFait }>
```

Dans la balise ```<script>``` du composant:

```
var ctx = this
ctx.modele = opts
ctx.liste = ctx.modele.data

ctx.basculerFait = function(e) {
 var index = ctx.liste.indexOf(e.item)
 ctx.modele.basculerFait(index)
}
```

L'événement ```onclick``` passe l'élément de la liste à la fonction. C'est le ```e```. Dans Riot, l'élément de la boucle est accessible par ```e.item```. Nous trouvons l'index de l'élément dans la liste et appelons la méthode ```.basculerFait()``` du modèle.

Si le scripte ```watch``` tourne encore, vous pouvez vérfier que tout marche dans le navigateur.

**basculerMaj**

Maintenant nous voulons montrer la balise ```<div class="liste-element-maj">``` quand nous clickons l'icône avec le crayon.

Dans le corps du composant:

```
<div class="liste-element-modif" onclick={ basculerMaj }>
```

Dans le scripte du composant:

```
ctx.basculerMaj = function(e) {
 if(e.item.maj) { e.item.maj = undefined }
 else {
  ctx.liste.forEach(function(element) { element.maj = undefined })
  e.item.maj = true
 }
}
```

Nous n'invoquons cette fois pas le modèle, parce que quel élément est en cours de modification ne le concerne pas. Le modèle représente les données sous-jacentes de l'application et ceci fait partie de la logique de présentation.

**mettreAJour**

Une fois le formulaire de mise à jour affiché, il faut que la clé ```text``` de l'élément soit modifiée lorsque le boutton est clické.

Dans le corps du composant:

```
<button class="btn btn-primary" onclick={ mettreAJour }>OK</button>
```

Dans le scripte du composant:

```
ctx.mettreAJour = function(e) {
 var index = ctx.liste.indexOf(e.item)
 var input = document.getElementById('liste-element-maj-input')
 if(input.value) {
  ctx.modele.mettreAJour(index, input.value)
  input.value = ''
  e.item.maj = undefined
 }
}
```

Testez dans le navigateur... 

## Le composant ```<a-faire-formulaire>```

Dans ```lib/composants```, créez un fichier ```a-faire-formulaire.tag```.

```
<a-faire-formulaire>
 <div class="ajouter">
  <div class="ajouter-input">
   <input id="ajouter-input" class="form-control" placeholder="À faire" type="text">
  </div>
  <div class="ajouter-bouton">
   <button id="ajouter-bouton" class="btn btn-primary">Ajouter</button>
  </div>
 </div>
 <div id="supprimer-fait">
  <button id="supprimer-fait-bouton" class="btn btn-danger">Supprimer ce qui a été fait</button>
 </div>
 <script></script>
</a-faire-formulaire>
```

J'ai ici repris le contenu de la ```<div id="formulaire">``` de ```index.html``` du [chapitre 1](link_to_do).

Dans le scripte du composant, je référence le contexte et le modèle.

```
var ctx = this
ctx.modele = opts
```

Dans ```main.js```, nous montons ce composant:

```
var riot = require('riot')
var Modele = require('./lib/Modele-a-faire')
var aFaireListe = require('./lib/composants/a-faire-liste.tag')
var aFaireFormulaire = require('./lib/composants/a-faire-formulaire.tag') // <- nouveau

var modele = new Modele

riot.mount('a-faire-liste', modele)
riot.mount('a-faire-formulaire', modele) // <- nouveau
```

### Les contrôleurs de ```<a-faire-formulaire>```:

**ajouter**

Dans le corps du composant

```
<button id="ajouter-bouton" class="btn btn-primary">Ajouter</button>
```

devient

```
<button id="ajouter-bouton" class="btn btn-primary" onclick={ ajouter }>Ajouter</button>
```

Dans le scripte du composant

```
ctx.ajouter = function() {
 var input = document.getElementById('ajouter-input')
 if(input.value) {
  ctx.modele.ajouter(input.value)
  input.value = ''
 }
}
```

**supprimerFait**

Dans le corps du composant:

```
<button id="supprimer-fait-bouton" class="btn btn-danger">Supprimer ce qui a été fait</button>
```

devient

```
<button id="supprimer-fait-bouton" class="btn btn-danger" onclick={ supprimerFait }>Supprimer ce qui a été fait</button>
```

Dans le scripte du composant

```
ctx.supprimerFait = function() {
 ctx.modele.supprimerFait()
}
```

Si ```watch``` tourne encore, ouvrons le navigateur pour voir si ça marche...

Non, ça ne marche pas. Le composant ```<a-faire-liste>``` ne sait pas que le modèle a changé. Nous allons faire en sorte que le modèle puisse l'informer quand il doit être mis à jour.

## Emettre un événement

Ouvrez ```lib/Model-a-faire.js```, en haut de la page, ajoutez:

```
var Event = require('events')
```

Nous n'avons pas besoin de télécharger la librairie ```event``` avec NPM, elle fait partie des fonctionnalités de base de Node. 

Créez une méthode "émetteur" ```evt``` dans le modèle:

```
ctx.evt = new Event
```

Quand un élément est ajouté, émettons un événement ```ajout```.

```
 ctx.ajouter = function(text) {
  ctx.data.push({text: text, fait: false})
  ctx.evt.emit('ajout')
 }
```

Quand les éléments ```fait``` sont supprimés émettons un événement ```suppression```.

```
 ctx.supprimerFait = function() {
  var aGarder = []
  ctx.data.forEach(function(element) {
   if(!element.fait) { aGarder.push(element) }
  })
  ctx.data = aGarder
  ctx.evt.emit('suppression')
 }
```

Dans le scripte du composant ```lib/composants/a-faire-liste.tag``` demandez au contexte ```ctx``` de se mettre à jour quand ces événements sont émis.

```
ctx.modele.evt.on('ajout', function() { 
 ctx.liste = ctx.modele.data
 ctx.update() 
})

ctx.modele.evt.on('suppression', function() { 
 ctx.liste = ctx.modele.data
 ctx.update() 
})
```

Si tout fonctionne comme il faut, arrêtez le scripte ```watch``` (```ctrl-C```) et lancez ```build``` pour créer l'application.

```
$ npm run build
```

## Conclusion

Dans ce chapitre nous avons amélioré la lisibilité du code de l'application en créant des composants qui contiennent une vue et les contrôleurs associés. La structure de l'application est modulaire. Nous pouvons réutiliser ces composants dans d'autres parties de l'application ou dans une tout autre application. Le modèle fait ce qu'il a à faire sans ce soucier de la manière dont les données sont présentée.

Nous avons vu comment l'utilisation de librairies externes comme **handlebars** et **riot** peuvent nous faciliter la vie. Dans le prochain chapitre nous allons utiliser le "framework" **angular** de Google.
