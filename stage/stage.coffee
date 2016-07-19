$crystals = $ '.crystals'
for i in [3..80]
  nanobox.crystals.crystalize {uniqueNum:i+20, isHover:false, el:$crystals}

nanobox.crystals.crystalize {uniqueNum:20, isHover:false, el:$crystals}
