#Requires AutoHotkey v2.0
#Include RunPowerWriter.ahk
#Include ClickOpen.ahk
#Include OpenSelectFile.ahk

; 目标窗口的标题
PowerWriterTitle := "Power Writer"
; PowerWriter 程序路径
; PowerWriterPath := "D:\Users\zou\AppData\Local\ICWorkShop\plug-in\PowerWriter\PowerWriter.exe"
; 文件浏览器窗口
FileBrowserWindow := "Open file as..."
; 项目位置
; ProjectPath := "D:\sunricher\gf\pkgs\PKG"
SelectProjectTitle  := "PowerWriter® 数据加密和文件路径设置"
; 设置日志文件路径
logFilePath := A_ScriptDir "/logs/log_" A_Now ".log" ; 文件将存储在脚本目录下
Encode := "UTF-8"



ProjectPath := "D:\sunricher\gf\PKG"
PowerWriterPath := "D:\Users\Lenovo\AppData\Local\ICWorkShop\plug-in\PowerWriter\PowerWriter.exe"

Main()
{
    LogInfo("PowerWriterTitle: " . PowerWriterTitle)
    LogInfo("FileBrowserWindow: " . FileBrowserWindow)
    LogInfo("SelectProjectTitle: " . SelectProjectTitle)
    LogInfo("logFilePath: " . logFilePath)
    RunPowerWriter()
    ; 列出该目录下的所有 .pkg 文件并选择第 i 个
    loop files, ProjectPath "\*.pkg" {
        fullpath := A_LoopFileFullPath
        ; 点击第二个按钮（打开按钮）
        if(!ClickMenuOpenButton()) {
            continue
        }
        ; 点击选择路径
        OpenSelectFile()
        ; 选择pkg文件
        SelectFile(()=>{},fullpath)
        ; 等待检查
        if (WaitCheck(5000) == true)
        {
            MsgBox("Esc被按下")
            ExitApp()
            return
        }
    }
}

Main()