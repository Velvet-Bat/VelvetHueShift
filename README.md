```lua
    --Example using texture files from avatar
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
 ```
Generated Page:
![javaw_1DfZqkHlWo](https://github.com/Velvet-Bat/VelvetHueShift/assets/112919990/a34bb114-68ca-48b3-9f8d-674f30acddc5)

Page Contents: **You must click 'Close & Save' to sync with the server** 
![image](https://github.com/Velvet-Bat/VelvetHueShift/assets/112919990/4b13028c-f83f-4b91-877d-553af6a6d373)

