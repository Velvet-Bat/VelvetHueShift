How to use (hopefully this is enough of an explanation sorryy)
```lua
    --Example using texture files from avatar
function events.entity_init()
    BaseTexture = textures:getTextures()[2]
    BaseTextureEmissive = textures:getTextures()[6]
    MaskTexture = textures:getTextures()[7]

    --Define a spot to hueshift
    --Color is a vector3 using rgb values with a range of 0-1
    AssignShiftChannel(BaseTexture, MaskTexture, vec(1, 1, 1))
    --After all channels are defined you can then apply the masks
    ApplyHueMasks()
    --You can automatically generate an action wheel page
    --It can be assigned it by name
    action_wheel:newPage("Actions")

    AutoCreateActionWheel("Actions")
end
 ```
Generated Page:

<img src="https://github.com/Velvet-Bat/VelvetHueShift/assets/112919990/a34bb114-68ca-48b3-9f8d-674f30acddc5" width="200" height="200">

Page Contents: Scroll to set values

**You must click 'Close & Save' (the barrier icon) to sync with other players** 

<img src="https://github.com/Velvet-Bat/VelvetHueShift/assets/112919990/4b13028c-f83f-4b91-877d-553af6a6d373" width="200" height="200">

Additionally if you ever want to rename or change the item on the generated you can edit the ActionWheel array, note that lua arrays start at 1!
Something like this should be fine. You do need to include the ending ': 0', otherwise some weird text issues, I'm not that dedicated to fix them.
```lua
    ActionWheel[1]:title("Edited Name: 0")
    ActionWheel[1]:item("egg")
```
