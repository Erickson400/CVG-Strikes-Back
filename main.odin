package main


import "core:fmt"
import "core:math"
import rl "vendor:raylib"


main :: proc() {
    rl.InitWindow(800, 600, "CVG Strikes Back")
    rl.InitAudioDevice()
    rl.SetExitKey(rl.KeyboardKey.KEY_NULL)
    rl.SetTargetFPS(60)

    game_entry()
    destroy_game()

    rl.CloseAudioDevice()
    rl.CloseWindow()
}