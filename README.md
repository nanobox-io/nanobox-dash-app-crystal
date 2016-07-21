## Installation
`bower install nanobox-io/nanobox-dash-app-crystal --save `

## Usage


```coffeescript
# (coffeescript)

###
uniqueNum - Each shape is random, but needs to be repeatable.
            Therefore, pass in a unique number so the shape
            will be drawn the same each time

isHover   - Pass in true to get back an image that is the
            colored state of the crystal

el        - The jquery element to attach the crystal to

height    - The height of the generated image
###

nanobox.crystals.crystalize {uniqueNum:20, isHover:false, el:$('#some-element'), height: 40 }
```
