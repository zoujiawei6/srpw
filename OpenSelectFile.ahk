#Requires AutoHotkey v2.0
#Include Acc.ahk
#Include SelectFile.ahk

/**
 * 点击弹出的窗口中的选择路径按钮
 */
OpenSelectFile() {
    ClassNN := "Button1" ; 设置控件的 ClassNN

    ; 定义变量用于存储控件坐标和大小
    x := 0
    y := 0
    width := 0
    height := 0

    ; 确保窗口存在并处于激活状态
    if WinExist(WinTitle) ; 检查窗口是否存在
    {
        WinActivate(WinTitle) ; 激活窗口
        
        ; 获取控件句柄
        hwndButton := ControlGetHwnd(ClassNN, WinTitle)
        if !hwndButton
        {
            MsgBox("无法找到指定的控件: " . ClassNN)
            return
        }

        WinActivate("PowerWriter® 数据加密和文件路径设置") ; 激活窗口
        ControlClick("选择路径", "PowerWriter® 数据加密和文件路径设置") ; 点击按钮
    }
    else {
        MsgBox("找不到指定的窗口：" . WinTitle) ; 如果窗口不存在，显示错误信息
    }
}
