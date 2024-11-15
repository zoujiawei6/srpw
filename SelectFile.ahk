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
    WaitMoment(500)
    Send("{Enter}")
    LogInfo("SelectFile 已选择好要修改的文件: " fullpath)
}
