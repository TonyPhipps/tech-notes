#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; AFK Prevention & Auto-Walk Script for AutoHotkey v2 (Targeting Fortnite)
; Toggle Anti-AFK Routine: Press [F8]
; Toggle Auto-Walk Forward: Press [F7]
; Exit Script:             Press [F12]
; ==============================================================================

SetTitleMatchMode(2) ; Match title anywhere in the window name
global TargetWindow := "Fortnite"
global IsAfkActive := false
global IsWalking := false

F8:: {
    global IsAfkActive
    IsAfkActive := !IsAfkActive
    if (IsAfkActive) {
        ToolTip("Anti-AFK Started (Targeting Fortnite)")
        SetTimer(ToolTip, -2000)
        SetTimer(PerformAntiAfkActions, 1000)
    } else {
        ToolTip("Anti-AFK Stopped")
        SetTimer(ToolTip, -2000)
        SetTimer(PerformAntiAfkActions, 0)
    }
}

F7:: {
    global IsWalking
    IsWalking := !IsWalking
    if (IsWalking) {
        if WinExist(TargetWindow) {
            ControlSend("{w down}",, TargetWindow)
            ToolTip("Auto-Walk Enabled")
        } else {
            ToolTip("Error: Fortnite window not found")
            IsWalking := false
        }
        SetTimer(ToolTip, -2000)
    } else {
        if WinExist(TargetWindow)
            ControlSend("{w up}",, TargetWindow)
        ToolTip("Auto-Walk Disabled")
        SetTimer(ToolTip, -2000)
    }
}

F12:: {
    ; Release 'w' if Auto-Walk was running when exiting
    if (IsWalking && WinExist(TargetWindow))
        ControlSend("{w up}",, TargetWindow)
    ToolTip("Exiting Script")
    Sleep(1000)
    ExitApp()
}

PerformAntiAfkActions() {
    static nextActionTime := 0
    
    if (A_TickCount < nextActionTime)
        return
    
    ; Verify Fortnite is running before sending commands
    if !WinExist(TargetWindow)
        return

    ; Select a random action (1 to 4)
    action := Random(1, 4)
    
    switch action {
        case 1:
            ; Tap Jump (Space)
            ControlSend("{Space down}",, TargetWindow)
            Sleep(Random(50, 100))
            ControlSend("{Space up}",, TargetWindow)
            
        case 2:
            ; Strafe Left/Right briefly
            key := (Random(1, 2) = 1) ? "a" : "d"
            ControlSend("{" key " down}",, TargetWindow)
            Sleep(Random(150, 300))
            ControlSend("{" key " up}",, TargetWindow)
            
        case 3:
            ; Tap Crouch (Ctrl)
            ControlSend("{Ctrl down}",, TargetWindow)
            Sleep(Random(50, 100))
            ControlSend("{Ctrl up}",, TargetWindow)
            
        case 4:
            ; Relative mouse movement (Requires Fortnite window focus)
            if WinActive(TargetWindow) {
                xOffset := Random(-40, 40)
                yOffset := Random(-20, 20)
                MouseMove(xOffset, yOffset, 10, "R")
            }
    }
    
    ; Schedule the next action with a randomized interval (5 to 12 seconds)
    nextActionTime := A_TickCount + Random(5000, 12000)
}