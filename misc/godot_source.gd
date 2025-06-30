extends RefCounted


# GLOBAL VARIABLES
var gameover: int
var ended: int
var time: int
var tcount: int 
var frate: int = 60 
var timer: int
var keytim: int
var segtim: int
var randy: int
# Arrays
var iGraph: Array = [0, 1, 2]
var iDir: Array
var iState: Array
var iScore: Array
var iTScore: Array
var iX: Array
var iY: Array
# data for level
var level_left: int = 8
var level_right: int = 808

#////// GRAPHICS ///////////////////
var g_logo: BB.BBImage
var g_cvg: BB.BBImage
var g_bg: BB.BBImage
var g_icon1: BB.BBImage
var g_icon2: BB.BBImage
var g_icon3: BB.BBImage
var g_icon4: BB.BBImage
var g_items: Array[BB.BBImage]

#anim arrays
var aWalk: Array = [1, 0, 2, 0]
#//var arrays
var pGraph: Array
var pX: Array
var pY: Array
var pZ: Array
var pDir: Array
var pFlipper: Array
var pDelay: Array
var pStep: Array
var pFrame: Array
var pSpeed: Array
var pState: Array
var pReady: Array
var pControl: Array
var pLeft: Array
var pRight: Array
var pUp: Array
var pDown: Array
var pButtA: Array
var pFo: Array
var pAtt: Array
var pTX: Array
var pOccupy: Array
var pHealth: Array
var pSHit: Array
var pSPain: Array
var pSLose: Array

#;SOUND
var chTheme: BB.BBSoundChannel
var sTheme: BB.BBSound
var sWin: BB.BBSound
var sLose: BB.BBSound

# Font
var font1: BB.BBFont
var font2: BB.BBFont


func entry() -> void:
	BB.Graphics(800, 600, 16, 1)
	BB.SetBuffer(BB.BackBuffer)
	BB.AutoMidHandle(true)
	
	g_logo = BB.LoadImage("gfx/logo.bmp")	
	g_cvg = BB.LoadImage("gfx/cvglogo.bmp")	
	g_bg = BB.LoadImage("gfx/bg1.bmp")
	g_icon1 = BB.LoadImage("gfx/icontime.bmp")
	g_icon2 = BB.LoadImage("gfx/iconmoney.bmp")
	g_icon3 = BB.LoadImage("gfx/iconcomp.bmp")
	g_icon4 = BB.LoadImage("gfx/iconstaff.bmp")
	g_items = BB.LoadAnimImage("gfx/items.bmp",120,120,0,3)

	pGraph.resize(4)
	pX.resize(4)
	pY.resize(4)
	pZ.resize(4)
	pDir.resize(4)
	pFlipper.resize(4)
	pDelay.resize(4)
	pStep.resize(4)
	pFrame.resize(4)
	pSpeed.resize(4)
	pState.resize(4)
	pReady.resize(4)
	pControl.resize(4)
	pLeft.resize(4)
	pRight.resize(4)
	pUp.resize(4)
	pDown.resize(4)
	pButtA.resize(4)
	pFo.resize(4)
	pAtt.resize(4)
	pTX.resize(4)
	pOccupy.resize(4)
	pHealth.resize(4)
	pSHit.resize(4)
	pSPain.resize(4)
	pSLose.resize(4)

	#;//////// INIT PLAYERS ////////
	#1
	pGraph[0] = BB.LoadAnimImage("gfx/dom.bmp",120,120,0,24)
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
	pTX[0] = BB.Rnd(level_left, level_right)
	pOccupy[0] = 0
	pHealth[0] = 5
	pSHit[0] = BB.LoadSound("sfx/Hit_Dom.wav")
	pSPain[0] = BB.LoadSound("sfx/Pain_Dom.wav")
	pSLose[0] = BB.LoadSound("sfx/Win_Lose.wav")
	#;2
	pGraph[1] = BB.LoadAnimImage("gfx/finance.bmp",120,120,0,12)
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
	pTX[1] = BB.Rnd(level_left, level_right)
	pOccupy[1] = 0
	pHealth[1] = 5
	pSHit[1] = BB.LoadSound("sfx/Hit_Cash.wav")
	pSPain[1] = BB.LoadSound("sfx/Pain_Cash.wav")
	pSLose[1] = BB.LoadSound("sfx/Win_Cash.wav")
	#;3
	pGraph[2] = BB.LoadAnimImage("gfx/comp.bmp",120,120,0,12)
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
	pTX[2] = BB.Rnd(level_left, level_right)
	pOccupy[2] = 0
	pHealth[2] = 5
	pSHit[2] = BB.LoadSound("sfx/Hit_Comp.wav")
	pSPain[2] = BB.LoadSound("sfx/Pain_Comp.wav")
	pSLose[2] = BB.LoadSound("sfx/Win_Comp.wav")
	#;4
	pGraph[3] = BB.LoadAnimImage("gfx/staff.bmp",120,120,0,12)
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
	pTX[3] = BB.Rnd(level_left, level_right)
	pOccupy[3] = 0
	pHealth[3] = 5
	pSHit[3] = BB.LoadSound("sfx/Hit_Staff.wav")
	pSPain[3] = BB.LoadSound("sfx/Pain_Staff.wav")
	pSLose[3] = BB.LoadSound("sfx/Win_Staff.wav")

	# Sound
	sTheme = BB.LoadSound("sfx/Theme.wav")
	sWin = BB.LoadSound("sfx/Win.wav")
	sLose = BB.LoadSound("sfx/Lose.wav")

	# TEXT
	font1 = BB.LoadFont("helvetica", 15, 1, 0, 0)
	font2 = BB.LoadFont("helvetica", 35, 1, 0, 0)
	title()

func title() -> void:
	keytim = 0
	gameover = 0
	ended = 0
	var pitcher: int = 22_000
	BB.LoopSound(sTheme)
	chTheme = BB.PlaySound(sTheme)
	
	for cyc in 4:
		pReady[cyc] = 1
		
	while true:
		var rando = BB.Rnd(1, 3)
		keytim += 1
		BB.ChannelPitch(chTheme, pitcher)
		# sort out the screen values
		BB.ClsColor(0, 0, 0)
		BB.MaskImage(g_logo, 255, 0, 255)
		BB.Cls()
		if keytim > 20:
			if BB.KeyDown(1):
				BB.End()
				
		if BB.KeyDown(203):
			pitcher -= 50
		if BB.KeyDown(205):
			pitcher += 50
			
		BB.DrawImage(g_cvg, 400, 300)
		BB.DrawImage(g_logo, 400, 100)
		BB.SetFont(font2)
		BB.BBColor(255, BB.Rnd(0, 255), 0)
		BB.Text(400, 460, "Press Enter", 1, 1)
		BB.SetFont(font1)
		BB.BBColor(55, 55, 55)
		BB.Text(400, 570, \
				"The characters and events portrayed in this game are fictitious.",
				1, 1)
		BB.Text(400, 586, "Any similarities to real life are purely coincidental...",
				1, 1)
		BB.Flip()
		if BB.KeyDown(28):
			break
	main()


func main() -> void:
	pass
	
	
