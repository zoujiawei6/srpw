#Requires AutoHotkey v2.0
#Include RunPowerWriter.ahk
#Include ClickOpen.ahk
#Include OpenSelectFile.ahk

; 目标窗口的标题
PowerWriterTitle := "Power Writer"
; PowerWriter 程序路径
PowerWriterPath := "D:\Users\Lenovo\AppData\Local\ICWorkShop\plug-in\PowerWriter\PowerWriter.exe"
; 文件浏览器窗口
FileBrowserWindow := "Open file as..."
; 项目位置
; ProjectPath := "D:\sunricher\gf\pkgs\PKG"
; PowerWriterPath := "D:\Users\zou\AppData\Local\ICWorkShop\plug-in\PowerWriter\PowerWriter.exe"
ProjectPath := "D:\sunricher\gf\PKG"
global PowerWriterTitle
global PowerWriterPath
global FileBrowserWindow
global ProjectPath

Main()
{
    RunPowerWriter()
    ; 点击第二个按钮（打开按钮）
    ClickMenuOpenButton()
    ; 点击弹出的窗口中的选择路径按钮
    OpenSelectFile()
    SelectFile(5)
}

Main()