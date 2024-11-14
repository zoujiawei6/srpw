#Requires AutoHotkey v2.0

/**
 * 启动PowerWriter
 */
RunPowerWriter() {
    ; 使用管理员权限运行指定路径下的应用程序（此处为 PowerWriter.exe）
    Run(PowerWriterPath, "", "RunAs")

    ; 等待 PowerWriter 对话框窗口出现，结合窗口的类名和程序名来确保找到正确的窗口
    WinWait("ahk_exe PowerWriter.exe", , 10)

    ; 获取窗口的唯一ID
    winID := WinGetID("ahk_exe PowerWriter.exe")
    global winID  ; 确保 winID 是全局变量

    if winID  ; 确保窗口ID存在
    {
        WinActivate(winID)
        WinWaitActive(winID) ; 等待窗口激活
        
        ; 将窗口置于最顶层
        WinSetAlwaysOnTop(true, winID)
        WaitMoment() ; 等待一段时间确保窗口已置顶
        ; 后续代码
        WinMaximize("ahk_exe PowerWriter.exe")
    }
    else {
        MsgBox("窗口未找到！")
    }
}
