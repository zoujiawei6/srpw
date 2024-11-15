#Requires AutoHotkey v2.0
#include Acc.ahk
#Include Utils.ahk

/**
 * 点击菜单栏的打开按钮
 */
ClickMenuOpenButton() {
    ; 等待窗口，超时则退出
    if !WinWait(PowerWriterTitle, , 10) {
        LogInfo("等待超时，未能成功启动 Power Writer。")
        return
    }

    ; 工具栏控件类名
    ToolbarClass := "ToolbarWindow321"

    ; 最大等待时间（秒）和检查间隔（毫秒）
    MaxWaitTime := 10
    CheckInterval := 200
    attempt := 0
    MaxAttempts := MaxWaitTime * 1000 / CheckInterval

    ; 循环等待工具栏控件可见
    toolbarHwnd := 0
    while (attempt < MaxAttempts) {
        toolbarHwnd := ControlGetHwnd(ToolbarClass, PowerWriterTitle)

        ; 确保找到控件句柄且控件可见
        if toolbarHwnd && ControlGetVisible(toolbarHwnd) {
            break
        }
        Sleep(CheckInterval)
        attempt++
    }

    ; 检查是否成功找到控件句柄
    if !toolbarHwnd {
        LogInfo("等待超时，未找到或控件不可见: " . ToolbarClass)
        return
    }

    ; 获取目标窗口句柄
    hWnd := WinExist(PowerWriterTitle)
    if !hWnd {
        LogInfo("未找到窗口！" . PowerWriterTitle)
        return
    }

    ; 获取 Acc 对象
    accUtil := Acc.ElementFromHandle(hWnd)
    
    ; 使用 ElementFromPath 按路径查找目标元素
    button := accUtil["4", "4", "4", "2"] ; 按层级路径查找“打开”按钮

    ; 检查是否找到按钮
    if (button) {
        button.DoDefaultAction() ; 执行默认动作（例如点击）
        LogInfo("ClickMenuOpenButton 点击按钮: " button.Name)
        return 1
    } else {
        LogInfo("未找到按钮！")
        return 0
    }
    return 0
}
