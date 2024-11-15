#Requires AutoHotkey v2.0

/**
 * 定义递归函数，查找按钮文本为“打开”的元素
 * @param element {Acc.IAccessible} 要递归查找的元素
 */
FindOpenButton(element) {
    for child in element.Children {
        ; 检查子元素是否为按钮，并且文本是否为“打开”
        if (child.Role = "button" && child.Name = "打开") {
            ; LogInfo("FindOpenButton 找到目标按钮！")
            return child ; 返回找到的按钮
        }

        ; 递归查找子元素的子集
        foundButton := FindOpenButton(child)
        if foundButton {
            return foundButton ; 如果找到目标按钮，则返回
        }
    }
    return ; 未找到按钮则返回空值
}

WaitMoment(Delay := 300) {
    Sleep(Delay) ; 等待一段时间确保窗口已置顶
}

/**
 * 等待并激活窗口，获取到句柄后返回
 * @param title 
 * @returns {Integer}
 */
GetHWnd(title := "") {
    if (title == "") {
        LogInfo("GetHWnd 标题为空" . title)
        return
    }
    ; 等待窗口，超时则退出
    if !WinWait(title, , 10) {
        LogInfo("等待超时，未能成功启动 " . title)
        return
    }
    ; WinActivate(title) ; 激活窗口
    ; 等待文件浏览器窗口弹出并激活
    ; WinWaitActive(SelectProjectTitle, , 10)  ; "打开" 是文件浏览器窗口的标题，等待最多10秒

    ; 获取目标窗口句柄
    hWnd := WinExist(title)
    if (!hWnd) {
        LogInfo("找不到指定的窗口: " . title) ; 如果窗口不存在，显示错误信息
        return
    }
    WinActive(title)
    return hWnd
}

/**
 * 点击WinTitle中的ControlClass后，判断WaitTitle窗口没有打开。
 * 如果没有打开，则尝试再次点击
 * @param WinTitle 
 * @param ControlClass 
 * @param WaitTitle 要等待弹出的窗口
 * @param MaxAttempts 尝试的最大次数
 * @param WaitTime 每次点击后等待的时间
 */
ClickControlWithCheck(WinTitle, ControlClass, WaitTitle, MaxAttempts := 5, WaitTime := 300) {
    attempt := 0
    success := False

    ; 获取控件的初始状态（例如文本、启用状态等）
    initialStatus := ControlGetText(ControlClass, WinTitle)

    ; 尝试点击直到成功或达到最大尝试次数
    while attempt < MaxAttempts {
        ; 执行点击
        ControlClick(ControlClass, WinTitle)
        Sleep(WaitTime) ; 等待控件响应
        if WinWait(WaitTitle, , 2) {
            success := True
            break ; 点击成功，退出循环
        }

        attempt++
    }

    return success
}

/**
 * 
 * @param {Acc.IAccessible} acc
 */
MouseClickCenter(accElement) {
    ; 获取元素的位置和尺寸
    location := accElement.Location

    ; 计算元素中心的 X 和 Y 坐标
    centerX := location.x + (location.w // 2)
    centerY := location.y + (location.h // 2)

    ; 移动鼠标到中心位置并点击左键
    MouseClick("L", centerX, centerY)
    LogInfo("点击位置" centerX " " centerY)
}

MouseControlClick(WinTitle, ControlClass) {
    hWnd := GetHWnd(WinTitle)
    if (!hWnd) {
        return
    }

    ; 获取按钮的坐标和大小
    ControlGetPos(&x, &y, &w, &h, ControlClass, WinTitle)

    ; 计算按钮中心位置
    centerX := x + (w // 2)
    centerY := y + (h // 2)

    ; 将鼠标移动到按钮中心并点击
    MouseClick('L', centerX, centerY)
}

/**
 * 等待并检查按键有没有被按下
 * @param Delay 总共等待多少秒
 * @param checkInterval 每 checkInterval 毫秒检查一次按键
 */
WaitCheck(Delay := 200, checkInterval := 50, KeyName := "Escape") {
    totalDelay := 0

    ; 如果是暂停状态，进入等待，不执行后续代码
    while (totalDelay < Delay) {
        if GetKeyState(KeyName, "P") {
            ToolTip("按下")
            return true
        }
        Sleep(checkInterval) ; 暂停期间短间隔检查
        totalDelay += checkInterval
    }

    return false
}

; 日志记录函数，接受日志消息参数并写入文件
LogInfo(message) {
    global logFilePath
    ; 格式化日志内容，包含时间戳
    logEntry := Format("[{}] {}{}", A_Now, message, "`r`n")
    ; 追加日志到文件
    FileAppend(logEntry, logFilePath, Encode)
}

/**
 * 循环检查窗口是否为可见状态
 * @param controlPath Acc控件路径，通过acc.ank获取
 * @param timeout 最大等待时间，以毫秒为单位
 */
WaitToVisit(controlPath, timeout := 5000) {
    hWnd := GetHWnd(PowerWriterTitle)
    if !hWnd {
        LogInfo("ReloadFirmware " PowerWriterTitle " 找不到此窗口" hWnd)
        return
    }

    ; 计时器（以毫秒为单位）
    startTime := A_TickCount

    ; 循环等待控件出现并变为可见
    while ((A_TickCount - startTime) < timeout) {
        try
        {
            ; 使用 Acc.ElementFromPath 尝试获取目标控件
            controlElement := Acc.ElementFromPath(controlPath, hWnd)

            ; 检查控件是否存在并可见
            if IsObject(controlElement) && !(controlElement.State & 32768) ; 32768 表示不可见
            {
                LogInfo("控件已弹出且可见: " controlPath)
                return true
            }
        }
        catch {
            ; 若控件未找到，则继续等待
        }

        ; 每100毫秒检查一次
        Sleep(100)
    }

    ; 若超过等待时间，未找到控件
    if ((A_TickCount - startTime) >= timeout) {
        LogInfo("等待超时，控件未弹出: " controlPath)
    }

    return true
}

/**
 * 提供一个oldVersion=49，newVersio=51，将name尾部的V49改为V51
 * @param name 
 * @param oldVersion 
 * @param newVersion 
 */
UpgradeVersionName(name, oldVersion, newVersion) {
    return RegExReplace(name, "V" oldVersion, "V" newVersion)
}

CloseMSPaintApp() {
    ; 尝试通过窗口标题关闭画图软件
    if WinExist("ahk_class MSPaintApp") {
        WinClose("ahk_class MSPaintApp") ; 优雅地关闭画图软件
        ; 如果窗口未响应，强制关闭
        if WinExist("ahk_class MSPaintApp") {
            WinKill("ahk_class MSPaintApp") ; 强制关闭
        }
        LogInfo("画图软件已关闭")
    } else {
        LogInfo("画图软件未运行")
    }
}

SavePrintScreen(savepath, filename) {
    SendEvent("{PrintScreen}")
    WaitMoment()
    
    ; 打开画图软件并等待窗口加载
    Run("mspaint.exe")
    WinWait("ahk_class MSPaintApp") ; 等待画图软件窗口出现

    SendEvent("^v")
    WaitMoment()
    SendEvent("^s")
    WaitMoment()
    SendText(filename)
    WaitMoment()
    SendEvent("^l")
    WaitMoment()
    SendText(savepath)
    WaitMoment(500)
    SendEvent("{Enter}")
    WaitMoment(500)
    hWnd := GetHWnd("保存为")
    if hWnd {
        saveButton := Acc.ElementFromPath("4,3,4")
        saveButton.Click()
        WaitMoment(500)
        ; MouseControlClick(hWnd, saveButton)
        ; ControlClick("ahk_id " hWnd " Button1")
        ; WaitMoment()
        ; SendEvent("{Enter}")
        ; WaitMoment()
        LogInfo("截图已保存到 " savepath)
    } else {
        LogInfo("未找到画图的“另存为”窗口")
    }
    CloseMSPaintApp()
    WaitMoment()

}
