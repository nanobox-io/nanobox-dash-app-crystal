$crystals = $ '.crystals'
for i in [40..150] by 2
  nanobox.crystals.crystalize {uniqueNum:i+20, isHover:false, el:$crystals, height:i}
  nanobox.crystals.crystalize {uniqueNum:i+20, isHover:true, el:$crystals, height:i}
