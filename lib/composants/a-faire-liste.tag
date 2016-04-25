<a-faire-liste>

 <div each={ liste } class="{fait ? 'liste-element fait' : 'liste-element a-faire'}">
  <div class="liste-element-info">
   <div class="liste-element-texte">
    <p>{ text }</p>
   </div>
   <div class="liste-element-modif" onclick={ basculerMaj }>
    <span class="glyphicon glyphicon-pencil"></span>
   </div>
   <div class="liste-element-statut" onclick={ basculerFait }>
    <span class="{fait ? 'glyphicon glyphicon-remove' : 'glyphicon glyphicon-ok'}"></span>
   </div>
  </div>

  <div class="liste-element-maj" if={ maj }>
   <div class="liste-element-maj-input">
    <input class="form-control" id="liste-element-maj-input" type="text">
   </div>
   <div class="liste-element-maj-bouton" onclick={ mettreAJour }>
    <button class="btn btn-primary" id="liste-element-maj-bouton">OK</button>
   </div>
  </div>

 </div> 

 <script>
var ctx = this
ctx.modele = opts
ctx.liste = ctx.modele.data

ctx.basculerFait = function(e) {
 var index = ctx.liste.indexOf(e.item)
 ctx.modele.basculerFait(index)
}

ctx.basculerMaj = function(e) {
 if(e.item.maj) { e.item.maj = undefined }
 else {
  ctx.liste.forEach(function(element) { element.maj = undefined })
  e.item.maj = true
 }
}

ctx.mettreAJour = function(e) {
 var index = ctx.liste.indexOf(e.item)
 var input = document.getElementById('liste-element-maj-input')
 if(input.value) {
  ctx.modele.mettreAJour(index, input.value)
  input.value = ''
  e.item.maj = undefined
 }
}

ctx.modele.evt.on('ajout', function() { 
 ctx.liste = ctx.modele.data
 ctx.update() 
})

ctx.modele.evt.on('suppression', function() { 
 ctx.liste = ctx.modele.data
 ctx.update() 
})
 </script>

</a-faire-liste>
