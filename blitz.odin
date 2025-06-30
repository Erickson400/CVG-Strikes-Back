package main
// Mediator between the game code and raylib

import rl "vendor:raylib"


AnimImage :: distinct [dynamic]rl.Image
AnimTextures :: distinct [dynamic]rl.Texture2D


graphics :: proc(width, height: i32, fullscreen: bool) {
    rl.SetWindowSize(width, height)
    config: rl.ConfigFlags
    if fullscreen {
        config = {.FULLSCREEN_MODE}
    }
    rl.SetWindowState(config)
}
load_anim_image :: proc(filename: cstring) -> AnimImage{
    FRAME_SIZE :: 120
    sprite_sheet := rl.LoadImage(filename)
    h_count := int(sprite_sheet.width / FRAME_SIZE)
    v_count := int(sprite_sheet.height / FRAME_SIZE)
    
    anim_image: AnimImage = make(AnimImage, 0, 24)
    for y in 0..<v_count {
        for x in 0..<h_count {
            rect := rl.Rectangle{f32(x*FRAME_SIZE), f32(y*FRAME_SIZE), FRAME_SIZE, FRAME_SIZE}
            frame := rl.ImageFromImage(sprite_sheet, rect)
            append(&anim_image, frame)
        }   
    }
    return anim_image
}
destroy_anim_image :: proc(anim_image: AnimImage) {
    delete(anim_image)
}
mask_anim_image :: proc(anim_image: ^AnimImage) {
    for i in 0..<len(anim_image) {
       format_and_mask_image(&anim_image[i])
    }
}
load_anim_texture_from_anim_image :: proc(anim_image: AnimImage) -> AnimTextures{
    textures := make(AnimTextures, 0, 24)
    for i in 0..<len(anim_image) {
        append(&textures, rl.LoadTextureFromImage(anim_image[i]))
    }
    return textures
}
destroy_anim_texture :: proc(anim_image_textures: AnimTextures) {
    for i in 0..<len(anim_image_textures) {
        rl.UnloadTexture(anim_image_textures[i])
    }
    delete(anim_image_textures)
}
format_and_mask_image :: proc (image: ^rl.Image) {
    rl.ImageFormat(image, rl.PixelFormat.UNCOMPRESSED_R8G8B8A8)
    rl.ImageColorReplace(image, rl.Color{255, 0, 255, 255}, rl.BLANK)
}
