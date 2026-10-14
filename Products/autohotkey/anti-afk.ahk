#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; AFK Prevention Script for AutoHotkey v2
; Toggle ON/OFF: Press [F8]
; Exit Script:   Press [F12]
; ==============================================================================

global IsActive := false

F8:: {
    global IsActive
    IsActive := !IsActive
    if (IsActive) {
        ToolTip("Anti-AFK Started")
        SetTimer(ToolTip, -2000)
        SetTimer(PerformAntiAfkActions, 1000)
    } else {
        ToolTip("Anti-AFK Stopped")
        SetTimer(ToolTip, -2000)
        SetTimer(PerformAntiAfkActions, 0)
    }
}

F12:: {
    ToolTip("Exiting Script")
    Sleep(1000)
    ExitApp()
}

PerformAntiAfkActions() {
    ; Static counter to space out actions randomly
    static nextActionTime := 0
    
    if (A_TickCount < nextActionTime)
        return
    
    ; Select a random action (1 to 4)
    action := Random(1, 4)
    
    switch action {
        case 1:
            ; Tap Jump (Space)
            Send("{Space down}")
            Sleep(Random(50, 100))
            Send("{Space up}")
            
        case 2:
            ; Strafe Left/Right briefly
            key := (Random(1, 2) = 1) ? "a" : "d"
            Send("{" key " down}")
            Sleep(Random(150, 300))
            Send("{" key " up}")
            
        case 3:
            ; Tap Crouch (Ctrl)
            Send("{Ctrl down}")
            Sleep(Random(50, 100))
            Send("{Ctrl up}")
            
        case 4:
            ; Slight relative mouse movement (Camera rotation)
            xOffset := Random(-40, 40)
            yOffset := Random(-20, 20)
            MouseMove(xOffset, yOffset, 10, "R")
    }
    
    ; Schedule the next action with a randomized interval (e.g., 5 to 12 seconds)
    nextActionTime := A_TickCount + Random(5000, 12000)
}