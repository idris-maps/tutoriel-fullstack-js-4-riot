var riot = require('riot')
var Modele = require('./lib/Modele-a-faire')
var aFaireListe = require('./lib/composants/a-faire-liste.tag')
var aFaireFormulaire = require('./lib/composants/a-faire-formulaire.tag')

var modele = new Modele

riot.mount('a-faire-liste', modele)
riot.mount('a-faire-formulaire', modele)
