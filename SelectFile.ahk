#Requires AutoHotkey v2.0

SelectFile(i := 1) {
    i := 2  ; 指定选择第 i 个 .pkg 文件

    ; 等待文件浏览器窗口弹出并激活
    WinWaitActive(FileBrowserWindow, , 10)  ; "打开" 是文件浏览器窗口的标题，等待最多10秒

    if !WinActive(FileBrowserWindow) {
        MsgBox("文件浏览器窗口未能在指定时间内打开")
    }

    ; 将 ProjectPath 路径粘贴到地址栏，并导航到该路径
    ; 激活地址栏，添加延时
    Send("{Alt down}d{Alt up}")
    Sleep(500) ; 增加短暂延时
    SendText(ProjectPath)  ; 输入目标路径
    Send("{Enter}")  ; 导航到目标路径
    Sleep(1000)  ; 等待目录加载

    ; 列出该目录下的所有 .pkg 文件并选择第 i 个
    loop files, ProjectPath "\*.pkg" {
        if (A_Index = i) {
            fileName := A_LoopFileName
            break
        }
    }

    ; 在文件浏览器中选择找到的文件
    if fileName {
        Send("{Tab}")  ; 转移焦点到文件列表
        Send("^f")  ; 打开搜索框
        Sleep(200)
        SendText(fileName)  ; 输入文件名
        Send("{Enter}")  ; 选择文件
    }
    else {
        MsgBox("指定的 .pkg 文件不存在。")
        return
    }
}
