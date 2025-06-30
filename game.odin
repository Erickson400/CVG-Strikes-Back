package main
/////////////////////////// CVG STRIKES BACK! ///////////////////////////

import rl "vendor:raylib"
import "core:fmt"
import "core:mem"


// GLOBAL VARIABLES
gameover: int
ended: int
time: int
tcount: int
timer: int
keytim: int
segtim: int
randy: int
// Arrays
iGraph: [3]int = {0, 1, 2}
iDir: [3]int
iState: [3]int
iScore: [3]int
iTScore: [3]int
iX: [3]int
iY: [3]int
// data for level
level_left: int = 8
level_right: int = 808

//////// GRAPHICS ///////////////////
g_logo: rl.Image
g_cvg: rl.Image
g_bg: rl.Image
g_icon1: rl.Image
g_icon2: rl.Image
g_icon3: rl.Image
g_icon4: rl.Image
g_items: AnimImage

//anim arrays
aWalk: [4]int = {1, 0, 2, 0}
////var arrays
pGraph:[4]AnimImage
pX:[4]int
pY:[4]int
pZ:[4]int
pDir:[4]int
pFlipper:[4]int
pDelay:[4]int
pStep:[4]int
pFrame:[4]int
pSpeed:[4]int
pState:[4]int
pReady:[4]int
pControl:[4]int
pLeft:[4]int
pRight:[4]int
pUp:[4]int
pDown:[4]int
pButtA:[4]int
pFo:[4]int
pAtt:[4]int
pTX:[4]int
pOccupy:[4]int
pHealth:[4]int
pSHit:[4]rl.Sound
pSPain:[4]rl.Sound
pSLose:[4]rl.Sound

//;SOUND
chTheme: rl.Sound
sTheme: rl.Sound
sWin: rl.Sound
sLose: rl.Sound

// Font
font1: rl.Font
font2: rl.Font


game_entry :: proc() {
    graphics(800, 600, true)

    // Initialize images
    g_logo = rl.LoadImage("gfx/logo.bmp")
    g_cvg = rl.LoadImage("gfx/cvglogo.bmp")	
    g_bg = rl.LoadImage("gfx/bg1.bmp")
    g_icon1 = rl.LoadImage("gfx/icontime.bmp")
    g_icon2 = rl.LoadImage("gfx/iconmoney.bmp")
    g_icon3 = rl.LoadImage("gfx/iconcomp.bmp")
    g_icon4 = rl.LoadImage("gfx/iconstaff.bmp")
    g_items = load_anim_image("gfx/items.bmp")

    //////// INIT PLAYERS ////////
	//1
	pGraph[0] = load_anim_image("gfx/dom.bmp")
	pX[0] = 100
	pY[0] = 390
	pZ[0] = -1
	pFlipper[0] = 12
	pDir[0] = 0
	pDelay[0] = 0
	pStep[0] = 0
	pFrame[0] = 1
	pSpeed[0] = 2
	pState[0] = 0
	pReady[0] = 1
	pControl[0] = 1
	pAtt[0] = 1
	pTX[0] = int(rl.GetRandomValue(i32(level_left), i32(level_right)))
	pOccupy[0] = 0
	pHealth[0] = 5
	pSHit[0] = rl.LoadSound("sfx/hit_dom.wav")
	pSPain[0] = rl.LoadSound("sfx/pain_dom.wav")
	pSLose[0] = rl.LoadSound("sfx/win_lose.wav")
	//;2
	pGraph[1] = load_anim_image("gfx/finance.bmp")
	pX[1] = 300
	pY[1] = 390
	pZ[1] = 0
	pFlipper[1] = 6
	pDir[1] = 0
	pDelay[1] = 0
	pStep[1] = 0
	pFrame[1] = 0
	pSpeed[1] = 2
	pState[1] = 0
	pReady[1] = 1
	pControl[1] = 0
	pAtt[1] = 1
	pTX[1] = int(rl.GetRandomValue(i32(level_left), i32(level_right)))
	pOccupy[1] = 0
	pHealth[1] = 5
	pSHit[1] = rl.LoadSound("sfx/hit_cash.wav")
	pSPain[1] = rl.LoadSound("sfx/pain_cash.wav")
	pSLose[1] = rl.LoadSound("sfx/win_cash.wav")
	//;3
	pGraph[2] = load_anim_image("gfx/comp.bmp")
	pX[2] = 400
	pY[2] = 390
	pZ[2] = 1
	pFlipper[2] = 6
	pDir[2] = 0
	pDelay[2] = 0
	pStep[2] = 0
	pFrame[2] = 0
	pSpeed[2] = 2
	pState[2] = 0
	pReady[2] = 1
	pControl[2] = 0
	pAtt[2] = 1
	pTX[2] = int(rl.GetRandomValue(i32(level_left), i32(level_right)))
	pOccupy[2] = 0
	pHealth[2] = 5
	pSHit[2] = rl.LoadSound("sfx/hit_comp.wav")
	pSPain[2] = rl.LoadSound("sfx/pain_comp.wav")
	pSLose[2] = rl.LoadSound("sfx/win_comp.wav")
	//;4
	pGraph[3] = load_anim_image("gfx/staff.bmp")
	pX[3] = 500
	pY[3] = 390
	pZ[3] = 1
	pFlipper[3] = 6
	pDir[3] = 0
	pDelay[3] = 0
	pStep[3] = 0
	pFrame[3] = 0
	pSpeed[3] = 2
	pState[3] = 0
	pReady[3] = 1
	pControl[3] = 0
	pAtt[3] = 1
	pTX[3] = int(rl.GetRandomValue(i32(level_left), i32(level_right)))
	pOccupy[3] = 0
	pHealth[3] = 5
	pSHit[3] = rl.LoadSound("sfx/hit_staff.wav")
	pSPain[3] = rl.LoadSound("sfx/pain_staff.wav")
	pSLose[3] = rl.LoadSound("sfx/win_staff.wav")

	// Sound
	sTheme = rl.LoadSound("sfx/theme.wav")
	sWin = rl.LoadSound("sfx/win.wav")
	sLose = rl.LoadSound("sfx/lose.wav")

	// TEXT
	font1 = rl.LoadFontEx("misc/helvetica.otf", 15, nil, 0)
	font2 = rl.LoadFontEx("misc/helvetica.otf", 35, nil, 0)

	title()
}
destroy_game :: proc() {
	// Unload images
	rl.UnloadImage(g_logo)
    rl.UnloadImage(g_cvg)	
    rl.UnloadImage(g_bg)
    rl.UnloadImage(g_icon1)
    rl.UnloadImage(g_icon2)
    rl.UnloadImage(g_icon3)
    rl.UnloadImage(g_icon4)
	destroy_anim_image(g_items)
	for i in 0..<4 {
		destroy_anim_image(pGraph[i])
	}

	// Unload sounds
	for i in 0..<4 {
		rl.UnloadSound(pSHit[i])
		rl.UnloadSound(pSPain[i])
		rl.UnloadSound(pSLose[i])
	}
	rl.UnloadSound(sTheme)
	rl.UnloadSound(sWin)
	rl.UnloadSound(sLose)

	// Unload fonts
	rl.UnloadFont(font1)
	rl.UnloadFont(font2)
}
title :: proc() {
	keytim = 0
	gameover = 0
	ended = 0
	pitcher: f32 = 1

	for i in 0..<4 {
		pReady[i] = 1
	}

	render_texture := rl.LoadRenderTexture(800, 600)
	g_cvg_tex := rl.LoadTextureFromImage(g_cvg)
	g_logo_tex := rl.LoadTextureFromImage(g_logo)
	defer rl.UnloadTexture(g_cvg_tex)
	defer rl.UnloadTexture(g_logo_tex)
	defer rl.UnloadRenderTexture(render_texture)

	// Title game loop
	for !rl.WindowShouldClose() {
		// Loop theme
		if !rl.IsSoundPlaying(sTheme) {
            rl.PlaySound(sTheme)
        }

		// rando := rl.GetRandomValue(0, 3)
		keytim += 1
		rl.SetSoundPitch(sTheme, pitcher)
		format_and_mask_image(&g_logo)
		if keytim > 20 {
			if rl.IsKeyDown(rl.KeyboardKey.ESCAPE) {
				return
			}
		}
		if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
			pitcher -= 0.005
		} else if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
			pitcher += 0.005
		}

		// Draw Title scene to RenderTexture
		rl.BeginTextureMode(render_texture)
		{
			rl.ClearBackground(rl.BLACK)
			rl.DrawTexture(g_cvg_tex, 400 - g_cvg_tex.width/2, 300 - g_cvg_tex.height/2, rl.WHITE)
			rl.DrawTexture(g_logo_tex, 400 - g_logo_tex.width/2, 100 - g_logo_tex.height/2, rl.WHITE)
			color := rl.Color{255, u8(rl.GetRandomValue(0,255)), 0, 255}
			rl.DrawTextPro(font2, "Press Enter", {400, 460}, {110, 7}, 0, f32(font2.baseSize), 1, color)
			color = rl.Color{55, 55, 55, 255}
			rl.DrawTextPro(font1, "The characters and events portrayed in this game are fictitious.", {400, 570}, {472/2, 7}, 0, f32(font1.baseSize), 1, color)
			rl.DrawTextPro(font1, "Any similarities to real life are purely coincidental...", {400, 586}, {367/2, 7}, 0, f32(font1.baseSize), 1, color)
		}
		rl.EndTextureMode()


		rl.BeginDrawing()
		{
			rl.DrawTexturePro(
				render_texture.texture, 
				rl.Rectangle{0, f32(render_texture.texture.height), f32(render_texture.texture.width), -f32(render_texture.texture.height)},
				rl.Rectangle{0, 0, f32(rl.GetRenderWidth()), f32(rl.GetRenderHeight())},
				{0, 0}, 0, rl.WHITE)
		}
		rl.EndDrawing()
		
		if rl.IsKeyDown(rl.KeyboardKey.ENTER) {
			break
		}
	}
	gameplay()
}
gameplay :: proc() {
	for i in 0..<3 {
		iScore[i] = 0
		iTScore[i] = 0
	}
	for _ in 0..<9 {
		rando := rl.GetRandomValue(0, 2)
		iTScore[rando] += 1
	}
	
	// Sort out the screen values
	format_and_mask_image(&g_bg)
	format_and_mask_image(&g_icon1)
	format_and_mask_image(&g_icon2)
	format_and_mask_image(&g_icon3)
	format_and_mask_image(&g_icon4)
	mask_anim_image(&g_items)
	for i in 0..<4 {
		mask_anim_image(&pGraph[i])
	}
	pX[0], pX[1], pX[2], pX[3] = 120, 400, 450, 500
	
	// SEGMENT ssssssssssssssssssssssssss
	segtim = 0
	pFrame[0] = 6
	
	render_texture := rl.LoadRenderTexture(800, 600)
	defer rl.UnloadRenderTexture(render_texture)
	g_bg_tex := rl.LoadTextureFromImage(g_bg)
	defer rl.UnloadTexture(g_bg_tex)
	pGraph_tex := [4]AnimTextures{
		load_anim_texture_from_anim_image(pGraph[0]),
		load_anim_texture_from_anim_image(pGraph[1]),
		load_anim_texture_from_anim_image(pGraph[2]),
		load_anim_texture_from_anim_image(pGraph[3]),
	}
	defer destroy_anim_texture(pGraph_tex[0])
	defer destroy_anim_texture(pGraph_tex[1])
	defer destroy_anim_texture(pGraph_tex[2])
	defer destroy_anim_texture(pGraph_tex[3])

	g_items_tex := load_anim_texture_from_anim_image(g_items)
	defer destroy_anim_texture(g_items_tex)

	g_icon1_tex := rl.LoadTextureFromImage(g_icon1)
	g_icon2_tex := rl.LoadTextureFromImage(g_icon2)
	g_icon3_tex := rl.LoadTextureFromImage(g_icon3)
	g_icon4_tex := rl.LoadTextureFromImage(g_icon4)
	defer rl.UnloadTexture(g_icon1_tex)
	defer rl.UnloadTexture(g_icon2_tex)
	defer rl.UnloadTexture(g_icon3_tex)
	defer rl.UnloadTexture(g_icon4_tex)

	// Start segment loop
	for !rl.WindowShouldClose() {
		defer free_all(context.temp_allocator)
		rl.BeginTextureMode(render_texture)
		rl.ClearBackground(rl.WHITE)
		rl.DrawTexture(g_bg_tex, 0, 0, rl.WHITE)

		segtim += 1
		pDir[0], pDir[1], pDir[2], pDir[3] = 0, pFlipper[1], pFlipper[1], pFlipper[1]
		
		// Dom talk
		if segtim < 400 {
			randy := rl.GetRandomValue(0, 4)
			if randy == 0 {
				pFrame[0] = int(rl.GetRandomValue(6, 7))
			}
			pFrame[1], pFrame[2], pFrame[3] = 0, 0, 0
			rl.DrawTextEx(font1, "We want     bags of cash,", {90, 260}, f32(font1.baseSize), 1, rl.WHITE)
			rl.DrawTextEx(font1, "we need     computers, and", {90, 280}, f32(font1.baseSize), 1, rl.WHITE)
			rl.DrawTextEx(font1, "we want     new teachers!", {90, 300}, f32(font1.baseSize), 1, rl.WHITE)
			rl.DrawTextEx(font1, fmt.ctprint(iTScore[0]), {165, 260}, f32(font1.baseSize), 1, rl.Color{255, 205, 0, 255})
			rl.DrawTextEx(font1, fmt.ctprint(iTScore[1]), {165, 280}, f32(font1.baseSize), 1, rl.Color{255, 205, 0, 255})
			rl.DrawTextEx(font1, fmt.ctprint(iTScore[2]), {165, 300}, f32(font1.baseSize), 1, rl.Color{255, 205, 0, 255})
		}

		// Enemy talk
		if segtim >= 400 {
			pFrame[0] = 0
			pFrame[1], pFrame[2], pFrame[3] = 3, 3, 3
			rl.DrawTextEx(font1, "Hahahaha!", {408, 280}, f32(font1.baseSize), 1, rl.WHITE)
			rl.DrawTextEx(font1, "SCREW YOU!", {405, 300}, f32(font1.baseSize), 1, rl.WHITE)
		}

		// Display
		rl.DrawTexture(pGraph_tex[0][pFrame[0] + pDir[0]], 120, 390, rl.WHITE)
		rl.DrawTexture(pGraph_tex[1][pFrame[1] + pDir[1]], i32(pX[1]), 390, rl.WHITE)
		rl.DrawTexture(pGraph_tex[2][pFrame[2] + pDir[2]], i32(pX[2]), 390, rl.WHITE)
		rl.DrawTexture(pGraph_tex[3][pFrame[3] + pDir[3]], i32(pX[3]), 390, rl.WHITE)

		rl.EndTextureMode()

		rl.BeginDrawing()
		{
			rl.DrawTexturePro(
				render_texture.texture, 
				rl.Rectangle{0, f32(render_texture.texture.height), f32(render_texture.texture.width), -f32(render_texture.texture.height)},
				rl.Rectangle{0, 0, f32(rl.GetRenderWidth()), f32(rl.GetRenderHeight())},
				{0, 0}, 0, rl.WHITE)
		}
		rl.EndDrawing()
		if segtim > 600 {
			break // Enter game
		}
	}
	rl.StopSound(sTheme)

	// GAME gggggggggggggggggggggggggggg
	stime: f32 = 0
	for !rl.WindowShouldClose() {
		defer free_all(context.temp_allocator)
		rl.BeginTextureMode(render_texture)
		rl.ClearBackground(rl.WHITE)
		rl.DrawTexture(g_bg_tex, 0, 0, rl.WHITE)

		// TIME
		stime += rl.GetFrameTime()
		time = int(stime)

		////////////////FIND GAME END///////////////
		if time > 60 {
			time = 60
			gameover = 1
		}

		if time >= 60 && iScore[0] >= iTScore[0] && iScore[1] >= iTScore[1] && iScore[2] >= iTScore[2] {
			gameover = 2
		}

		if gameover > 0 {
			for i in 0..<4 {
				pReady[i] = 0
			}
			if gameover == 1 {
				pFrame[0], pFrame[1], pFrame[2], pFrame[3] = 8, 0, 0, 0
				rl.DrawTextEx(font2, "CVG is SCREWED!", {244, 283}, f32(font2.baseSize), 1, rl.RED)
				rl.DrawTextEx(font1, "Press ESC", {362, 313}, f32(font1.baseSize), 1, rl.BLACK)
				if ended == 0 {
					rl.PlaySound(sLose)
					ended = 1
				}
			}
			if gameover == 2 {
				pFrame[0], pFrame[1], pFrame[2], pFrame[3] = 9, 5, 5, 5
				rl.DrawTextEx(font2, "CVG is SAVED!", {285, 283}, f32(font2.baseSize), 1, rl.GREEN)
				rl.DrawTextEx(font1, "Press ESC", {362, 313}, f32(font1.baseSize), 1, rl.BLACK)
				if ended == 0 {
					rl.PlaySound(sWin)
					ended = 1
				}
			}
		}
		
		///////////// CONTROL LOOP ////////////////////
		if gameover == 0 {
			// Find input
			for i in 0..<4 {
				pLeft[i], pRight[i], pUp[i], pDown[i], pButtA[i] = 0, 0, 0, 0, 0
				// keyboard
				if pControl[i] == 1 {
					if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
						pLeft[i] = 1
					}
					if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
						pRight[i] = 1
					}
					if rl.IsKeyDown(rl.KeyboardKey.DOWN) {
						pDown[i] = 1
					}
					if rl.IsKeyDown(rl.KeyboardKey.SPACE) {
						pButtA[i] = 1
					}
				}
				// CPU
				if pControl[i] == 0 {
					randy := rl.GetRandomValue(0, 20)
					if randy == 1 {
						pTX[i] = int(rl.GetRandomValue(i32(level_left), i32(level_right)))
						pAtt[i] = int(rl.GetRandomValue(0, 2))
					}
					if pAtt[i] == 0 {
						pFrame[i] = 0
					}
					if pAtt[i] == 1 {
						image_width: int = int(pGraph[i][0].width)
						if pX[i] + image_width > pTX[i] {
							pLeft[i] = 1
						}
						if pX[i] + image_width < pTX[i] {
							pRight[i] = 1
						}
						if pX[i] + image_width > pTX[i] - 10 && pX[i] + image_width < pTX[i] + 10 {
							pLeft[i], pRight[i], pAtt[i] = 0, 0, 0
						}
					}
					if pAtt[i] == 2 {
						pButtA[i] = 1
						pAtt[i] = 0
					}
				}
			}

			// translate input
			for i in 0..<4 {
				// ready loop rrrrrrrrrrrrrrrrrrrrr
				if pReady[i] == 1 {
					if pRight[i] == 1 || pLeft[i] == 1 || pDown[i] == 1 || pUp[i] == 1 {
						if i == 0{
							fmt.println("moving", stime)
						}
						
						pDelay[i] += 1
						if pDelay[i] > 7 {
							pStep[i] += 1
							if pStep[i] > 3 {
								pStep[i] = 0
							}
							pFrame[i] = aWalk[pStep[i]]
							pDelay[i] = 0
						}
					}
					// Movement
					if pLeft[i] == 1 {
						pDir[i] = pFlipper[i]
						pX[i] -= pSpeed[i]
					}
					if pRight[i] == 1 {
						pDir[i] = 0
						pX[i] += pSpeed[i]
					}
					// Punch
					if pButtA[i] == 1 {
						pState[i] = 10
					}
				}
				// rrrrrrrrrrrrrrrrrrrrrrrrrrrr
	 			// STATES sssssssssssssssssssss
				// 1 - Hurt
				if pState[i] == 1 {
					pReady[i] = 0
					pDelay[i] += 1
					pFrame[i] = 5
					pZ[i] = -1
					if pDelay[i] > 20 {
						pFrame[i] = 0
					}
					if pDelay[i] > 28 {
						pZ[i] = 0
						pReady[i] = 1
						pDelay[i] = 0
						pState[i] = 0
					}
				}
				// 10 - Punching
				if pState[i] == 10 {
					pReady[i] = 0
					pDelay[i] += 1
					pFrame[i] = 3
					if pDelay[i] > 10 {
						if pDelay[i] < 15 {
							if pDir[i] == 0 {
								pX[i] += 1
							} else {
								pX[i] -= 1
							}
						}
						pFrame[i] = 4
						pZ[i] = 1
						for v in 0..<4 {
							// facing someone?
							pFo[i] = 0
							if pX[i] < pX[v] && pDir[i] == 0 {
								pFo[i] = v
							}
							if pX[i] > pX[v] && pDir[i] == pFlipper[i] {
								pFo[i] = v
							}
							// contact?
							if pX[i] < pX[v] + 41 && pX[i] > pX[v] - 41 && pFo[i] == v && v != i && pOccupy[i] == 0 {
								rl.PlaySound(pSHit[i])
								rl.PlaySound(pSPain[v])
								if pDir[i] == 0 {
									pX[v] += 10
								}
								if pDir[i] == pFlipper[i] {
									pX[v] -= 10
								}
								pOccupy[i] = 1
								pState[v] = 1
								if pControl[i] == 0 && v == 0 {
									pHealth[v] -= 1
								}
								if pControl[i] == 1 {
									pHealth[v] -= 1
								}
							}
						}
					}
					if pDelay[i] > 25 {
						pFrame[i] = 0
						pZ[i] = -1
					}
					if pDelay[i] > 31 {
						pReady[i], pDelay[i], pState[i], pOccupy[i] = 1, 0, 0, 0
					}
				}
				//ssssssssssssssssssssssssssssss
	 			//value checks
				if pX[i] < level_left {
					pX[i] = level_left
				}
				if pX[i] > level_right {
					pX[i] = level_right
				}
			}

			///////////////// DISPLAY /////////////////////
			for plane in -1..=1 {
				for i in 0..<4 {
					if pZ[i] == plane {
						rl.DrawTexture(pGraph_tex[i][pFrame[i] + pDir[i]], i32(pX[i]), i32(pY[i]), rl.WHITE)
					}
				}
			}

			// ITEM KNOCKERS
			if pHealth[0] < 1 {
				randy := rl.GetRandomValue(1, 2)
				pHealth[0] = int(rl.GetRandomValue(3, 6))
				if iScore[randy] > 0 {
					iState[randy] = 1
					iScore[randy] -= 1
				} else {
					iState[randy] = 0
				}
				iX[randy] = pX[0]
				iY[randy] = pY[0] - 30
				if pDir[0] == 0 {
					iDir[randy] = -2
				} else {
					iDir[randy] = 2
				}
				rl.PlaySound(pSLose[0])
			}
			if pHealth[1] < 1 {
				pHealth[1] = int(rl.GetRandomValue(6, 8))
				iState[0] = 1
				iScore[0] += 1
				iX[0] = pX[1]
				iY[0] = pY[1] - 30
				if pDir[1] == 0 {
					iDir[0] = -2
				} else {
					iDir[0] = 2
				}
				rl.PlaySound(pSLose[1])
			}
			if pHealth[2] < 1 {
				pHealth[2] = int(rl.GetRandomValue(6, 8))
				iState[1] = 1
				iScore[1] += 1
				iX[1] = pX[2]
				iY[1] = pY[2] - 30
				if pDir[2] == 0 {
					iDir[1] = -2
				} else {
					iDir[1] = 2
				}
				rl.PlaySound(pSLose[2])
			}
			if pHealth[3] < 1 {
				pHealth[3] = int(rl.GetRandomValue(6, 8))
				iState[2] = 1
				iScore[2] += 1
				iX[2] = pX[3]
				iY[2] = pY[3] - 30
				if pDir[3] == 0 {
					iDir[2] = -2
				} else {
					iDir[1] = 2
				}
				rl.PlaySound(pSLose[3])
			}
			for i in 0..<3 {
				if iState[i] == 1 {
					iX[i] += iDir[i]
					iY[i] -= 5
					if iY[i] < 280 {
						iState[i] = 2
					}
				}
				if iState[i] == 2 {
					iX[i] += iDir[i]
					iY[i] += 4
					if iY[i] > 450 {
						iState[i] = 0
					}
				}
				if iState[i] > 0 {
					rl.DrawTexture(g_items_tex[iGraph[i]], i32(iX[i]), i32(iY[i]), rl.WHITE)
				}
			}
			// COLOURS
			if rl.IsKeyDown(rl.KeyboardKey.LEFT_CONTROL) {
				for cnt in 1..<20 {
					color := rl.Color{u8(rl.GetRandomValue(100, 255)), u8(rl.GetRandomValue(100, 255)), 0, 255}
					rl.DrawEllipse(i32(pX[0] + 60), i32(pY[0] + 60), 5, 5, color)
				}
			}
			if rl.IsKeyDown(rl.KeyboardKey.ONE) {
				for i in 1..<4 {
					pTX[i] = int(rl.GetRandomValue(i32(level_left), i32(level_right)))
					pAtt[i] = int(rl.GetRandomValue(0, 2))
				}
			}
		}
		// icons
		time_icon_midsize := [2]i32{g_icon1.width/2, g_icon1.height/2} 
		icon_midsize := [2]i32{g_icon2.width/2, g_icon2.height/2} 
		rl.DrawTexture(g_icon1_tex, 100 - time_icon_midsize.x, 560 - time_icon_midsize.y, rl.WHITE )
		rl.DrawTexture(g_icon2_tex, 300 - icon_midsize.x, 560 - icon_midsize.y, rl.WHITE )
		rl.DrawTexture(g_icon3_tex, 500 - icon_midsize.x, 560 - icon_midsize.y, rl.WHITE )
		rl.DrawTexture(g_icon4_tex, 700 - icon_midsize.x, 560 - icon_midsize.y, rl.WHITE )
		// TEXT
		font1_offset := rl.Vector2{4, 4}
		font2_offset := rl.Vector2{10, 14}
		color := rl.Color{255, 255, 0, 255} if iScore[0] < iTScore[0] else rl.Color{0, 255, 0, 255}
		rl.DrawTextEx(font2, fmt.ctprint(iScore[0]), {310, 550} - font2_offset, f32(font2.baseSize), 1, color)
		color = rl.Color{255, 255, 0, 255} if iScore[1] < iTScore[1] else rl.Color{0, 255, 0, 255}
		rl.DrawTextEx(font2, fmt.ctprint(iScore[1]), {510, 550} - font2_offset, f32(font2.baseSize), 1, color)
		color = rl.Color{255, 255, 0, 255} if iScore[2] < iTScore[2] else rl.Color{0, 255, 0, 255}
		rl.DrawTextEx(font2, fmt.ctprint(iScore[2]), {710, 550} - font2_offset, f32(font2.baseSize), 1, color)

		rl.DrawTextEx(font1, fmt.ctprint(iTScore[0]), {330, 550} - font1_offset, f32(font1.baseSize), 1, rl.BLACK)
		rl.DrawTextEx(font1, fmt.ctprint(iTScore[1]), {530, 550} - font1_offset, f32(font1.baseSize), 1, rl.BLACK)
		rl.DrawTextEx(font1, fmt.ctprint(iTScore[2]), {730, 550} - font1_offset, f32(font1.baseSize), 1, rl.BLACK)
		
		if time < 30 {
			color = rl.Color{0, 255, 0, 255}
		}
		if time >= 30 {
			color = rl.Color{255, 255, 0, 255}
		}
		if time >= 50 {
			color = rl.Color{255, 0, 0, 255}
		}
		offset := rl.Vector2{23, 15} if 60 - time >= 10 else rl.Vector2{10, 15}
		rl.DrawTextEx(font2, fmt.ctprint(60 - time), {101, 551} - offset, f32(font2.baseSize), 1, color)

		rl.EndTextureMode()

		rl.BeginDrawing()
		{
			rl.DrawTexturePro(
				render_texture.texture, 
				rl.Rectangle{0, f32(render_texture.texture.height), f32(render_texture.texture.width), -f32(render_texture.texture.height)},
				rl.Rectangle{0, 0, f32(rl.GetRenderWidth()), f32(rl.GetRenderHeight())},
				{0, 0}, 0, rl.WHITE)
		}
		rl.EndDrawing()

		if rl.IsKeyDown(rl.KeyboardKey.ESCAPE) {
			title()
		}
	}
	


}



