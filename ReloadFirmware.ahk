#Requires AutoHotkey v2.0

; 重新载入固件
;
ReloadFirmware(filename) {
    hWnd := GetHWnd(PowerWriterTitle)
    if !hWnd {
        LogInfo("ReloadFirmware " PowerWriterTitle " 找不到此窗口" hWnd)
        return
    }

    secondRow := Acc.ElementFromPath("4,1,4,7,4,4,4,2", hWnd)
    if (!secondRow || secondRow.Name == "") {
        LogInfo("ReloadFirmware 列表项不存在或为空")
        return
    }

    rowName := secondRow.Name

    if (!RegExMatch(rowName, "\.hex$")) {
        LogInfo("列表项不以.hex结尾请检查: " rowName)
        return
    }
    if (!(secondRow.State & Acc.State.Selected))
    {
        LogInfo("列没有被选中" rowName)
        return
    }
    if (!InStr(rowName, OldVersion))
    {
        LogInfo("列名中的版本号不正确" rowName "所需版本号: " OldVersion)
        return
    }
    
    ; 使用 Select 方法选择此行
    ; secondRow.Select(Acc.SelectionFlag.TakeSelection)
    ; secondRow.Click()
    LogInfo("选中列表项: " rowName)

    WaitMoment()

    ; 删除固件按钮
    deleteFirmware := Acc.ElementFromPath("4,1,4,7,4,6,4", hWnd)
    if (!deleteFirmware || deleteFirmware.Name == "") {
        LogInfo("ReloadFirmware 列表项不存在或为空")
        return
    }
    deleteFirmware.Click()

    ; WaitMoment(3000)
    
    WaitMoment(1000)
    Send("{Enter}")
    WaitMoment()
    
    ; 使用快捷键打开“文件”菜单
    Send("{Alt}")
    WaitMoment()
    Send("F")
    WaitMoment()

    if (WaitToVisit("3,1,1") == false)
    {
        return
    }

    ; 使用快捷键点击“另存为”
    Send("{Down}{Down}{Down}{Enter}")
    ; WaitMoment(500)
    
    hWndSpt := GetHWnd(SelectProjectTitle)
    if (!hWndSpt) {
        LogInfo("找不到指定的窗口: " . SelectProjectTitle) ; 如果窗口不存在，显示错误信息
        return
    }
    
    WinActivate(SelectProjectTitle)
    WinWaitActive(SelectProjectTitle, , 10)

    Send("{Tab}")
    WaitMoment()
    Send("{Enter}")
    WaitMoment()
    SendText(SaveAsPath filename) ; 输入文本
    WaitMoment()
    Send("{Enter}")
    WaitMoment()
    Send("{Enter}")
    
    ; input := Acc.ElementFromPath("4,4,4", hWnd)
    ; ; 检查是否找到按钮
    ; if (input && input.Role == 42) {
    ;     input.Click()
    ;     WaitMoment()
    ;     WaitMoment()
    ; } else {
    ;     MsgBox("未找到按钮！")
    ; }
}
