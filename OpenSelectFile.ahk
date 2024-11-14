#Requires AutoHotkey v2.0
#Include Acc.ahk
#Include SelectFile.ahk

/**
 * 点击弹出的窗口中的选择路径按钮
 */
OpenSelectFile() {
    ClassNN := "Button1" ; 设置控件的 ClassNN

    ; 确保窗口存在并处于激活状态
    if WinExist(PowerWriterTitle) ; 检查窗口是否存在
    {
        WinActivate(PowerWriterTitle) ; 激活窗口

        ; 获取控件句柄
        hWndButton := ControlGetHwnd(ClassNN, PowerWriterTitle)
        if !hWndButton {
            LogInfo("无法找到指定的控件: " . ClassNN)
            return
        }

        WinActivate(SelectProjectTitle) ; 激活窗口
        WinWaitActive(SelectProjectTitle, , 10)
        ; WaitMoment(500)
        MouseControlClick(SelectProjectTitle, "选择路径") ; 点击按钮
        ; ControlClick("选择路径", SelectProjectTitle) ; 点击按钮
        ; MouseClick()
        ; ClickControlWithCheck(SelectProjectTitle, "选择路径", FileBrowserWindow) ; 点击按钮
    }
    else {
        LogInfo("找不到指定的窗口：" . PowerWriterTitle) ; 如果窗口不存在，显示错误信息
    }
}
