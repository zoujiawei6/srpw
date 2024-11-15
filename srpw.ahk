#Requires AutoHotkey v2.0
#Include RunPowerWriter.ahk
#Include ClickOpen.ahk
#Include OpenSelectFile.ahk
#Include ReloadFirmware.ahk

OldVersion := "49"
NewVersion := "51"
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
logFilePath := A_ScriptDir "\logs\log_" A_Now ".log" ; 文件将存储在脚本目录下
; 日志文件编码
Encode := "UTF-8"
; 另存为路径
; SaveAsPath := "D:\sunricher\gf\pkgs\PKG\PKG-51"
; 固件路径
; FirmwarePath := "D:\sunricher\gf\pkgs\PKG\HEX\SR-2303EA-5CH-CM135_dali207_app_2024110410_51.hex"
; 用于校验用的图片的保存路径
; CheckImageSavePath := "D:\sunricher\gf\pkgs\checks\PKG-51"


; 笔记本环境配
ProjectPath := "D:\sunricher\gf\PKG"
PowerWriterPath := "D:\Users\Lenovo\AppData\Local\ICWorkShop\plug-in\PowerWriter\PowerWriter.exe"
SaveAsPath := "D:\sunricher\gf\PKG\V51"
FirmwarePath := "D:\sunricher\gf\PKG\HEX\SR-2303EA-5CH-CM135_dali207_app_2024110410_51.hex"
CheckImageSavePath := "D:\sunricher\gf\checks\PKG-51"

Main()
{
    LogInfo("PowerWriterTitle: " . PowerWriterTitle)
    LogInfo("FileBrowserWindow: " . FileBrowserWindow)
    LogInfo("SelectProjectTitle: " . SelectProjectTitle)
    DirCreate(CheckImageSavePath)
    ; 切换到英文输入法  0409 是英语语言代码； 0804 是中文语言代码
    DllCall("LoadKeyboardLayout", "Str", "0409", "UInt", 1)

    ; 测试代码
    ; loop files, ProjectPath "\*.pkg" {
    ;     fileName := A_LoopFileName
    ;     ReloadFirmware(fileName)
    ;     break
    ; }
    now := A_Now
    
    RunPowerWriter()
    ; 列出该目录下的所有 .pkg 文件并选择第 i 个
    loop files, ProjectPath "\*.pkg" {
        startTime := A_Now
        fullPath := A_LoopFileFullPath
        fileName := A_LoopFileName
        FileAppend(fileName, A_ScriptDir "\logs\files_log_" now ".txt", Encode)
        LogInfo("正在处理文件 " . fileName . " ...")
        
        ; 点击第二个按钮（打开按钮）
        if(!ClickMenuOpenButton()) {
            continue
        }
        ; 点击选择路径
        OpenSelectFile()
        ; 选择pkg文件
        SelectFile(()=>{},fullPath)
        ReloadFirmware(fileName)
        
        endTime := A_Now
        LogInfo("本次用时: " . (endTime - startTime))
        LogInfo("`r`n`r`n`r`n")

        ; 暂歇两秒,否则电脑压力太大
        WaitMoment(2000)
        ; break
        
        ; 等待检查
        ; if (WaitCheck(5000) == true)
        ; {
        ;     LogInfo("Esc被按下")
        ;     ExitApp()
        ;     return
        ; }
    }
}

Main()