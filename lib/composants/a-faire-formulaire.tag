<a-faire-formulaire>
 <div class="ajouter">
  <div class="ajouter-input">
   <input id="ajouter-input" class="form-control" placeholder="À faire" type="text">
  </div>
  <div class="ajouter-bouton">
   <button id="ajouter-bouton" class="btn btn-primary" onclick={ ajouter }>Ajouter</button>
  </div>
 </div>
 <div id="supprimer-fait">
  <button id="supprimer-fait-bouton" class="btn btn-danger" onclick={ supprimerFait }>Supprimer ce qui a été fait</button>
 </div>
 <script>
var ctx = this
ctx.modele = opts

ctx.ajouter = function() {
 var input = document.getElementById('ajouter-input')
 if(input.value) {
  ctx.modele.ajouter(input.value)
  input.value = ''
 }
}

ctx.supprimerFait = function() {
 ctx.modele.supprimerFait()
}
 </script>
</a-faire-formulaire>
