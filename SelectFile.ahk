#Requires AutoHotkey v2.0

SelectFile(i := 1) {
    i := 2  ; 指定选择第 i 个 .pkg 文件

    ; 等待文件浏览器窗口弹出并激活
    WinWaitActive(FileBrowserWindow, , 10)  ; "打开" 是文件浏览器窗口的标题，等待最多10秒
    if !WinActive(FileBrowserWindow) {
        MsgBox("文件浏览器窗口未能在指定时间内打开")
        return
    }

    ; 列出该目录下的所有 .pkg 文件并选择第 i 个
    loop files, ProjectPath "\*.pkg" {
        if (A_Index = i) {
            fullpath := A_LoopFileFullPath
            break
        }
    }

    ; 在文件浏览器中选择找到的文件
    if fullpath {
        Send("!N")
        SendText(fullpath)  ; 输入文件名
        Send("!O")
    }
    else {
        MsgBox("指定的 .pkg 文件不存在。")
        return
    }
}
