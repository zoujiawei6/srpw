#Requires AutoHotkey v2.0

SelectFile(callback, fullpath := "") {
    if (fullpath == "") {
        return
    }
    ; 获取文件浏览器窗口句柄
    hWndFileBrowser := GetHWnd(FileBrowserWindow)
    if (!hWndFileBrowser) {
        return
    }

    Send("!N")
    SendText(fullpath)  ; 输入文件名
    Send("!O")
    WaitMoment(1000)
    Send("{Enter}")

    ; WaitMoment(1000)

    ; ; 获取 Acc 对象
    ; accUtil := Acc.ElementFromHandle(hWnd)

    ; input := Acc.ElementFromPath("4,4,4", hWnd)
    ; ; 检查是否找到按钮
    ; if (input && input.Role == 42) {
    ;     input.Click()
    ;     WaitMoment()
    ;     SendText(fullpath) ; 输入文本
    ;     WaitMoment()
    ;     ; Send("{Enter}")
    ; } else {
    ;     MsgBox("未找到按钮！")
    ; }
}
