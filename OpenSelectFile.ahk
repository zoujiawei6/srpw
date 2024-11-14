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
        hwndButton := ControlGetHwnd(ClassNN, PowerWriterTitle)
        if !hwndButton
        {
            MsgBox("无法找到指定的控件: " . ClassNN)
            return
        }

        WinTitle  := "PowerWriter® 数据加密和文件路径设置"
        WinActivate(WinTitle) ; 激活窗口
        WinWaitActive(WinTitle,,10)
        WaitMoment()
        ControlClick("选择路径", WinTitle) ; 点击按钮
    }
    else {
        MsgBox("找不到指定的窗口：" . WinTitle) ; 如果窗口不存在，显示错误信息
    }
}
