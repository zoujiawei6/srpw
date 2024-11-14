#Requires AutoHotkey v2.0

/**
 * 定义递归函数，查找按钮文本为“打开”的元素
 * @param element {Acc.IAccessible} 要递归查找的元素
 */
FindOpenButton(element) {
    ; MsgBox("检查子元素1：" . element.Name . " []" . element.Children.Length . " []" . element.Role)
    for child in element.Children {
        ; 检查子元素是否为按钮，并且文本是否为“打开”
        if (child.Role = "button" && child.Name = "打开") {
            MsgBox("找到目标按钮！")
            return child ; 返回找到的按钮
        }
        ; MsgBox("检查子元素2：" . child.Name . " " . child.Children.Length . " " . child.Role)

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
 */
GetHWnd(title := "") {
    if (title == "") {
        return
    }
    ; 等待窗口，超时则退出
    if !WinWait(title, , 10) {
        MsgBox("等待超时，未能成功启动 " . title)
        return
    }
    ; WinActivate(title) ; 激活窗口
    ; 等待文件浏览器窗口弹出并激活
    ; WinWaitActive(SelectProjectTitle, , 10)  ; "打开" 是文件浏览器窗口的标题，等待最多10秒
    if !WinActive(title) {
        MsgBox(title . " 窗口未能在指定时间内打开")
        return
    }
    ; 获取目标窗口句柄
    hWnd := WinExist(title)
    if (!hWnd) {
        MsgBox("找不到指定的窗口：" . title) ; 如果窗口不存在，显示错误信息
        return
    }
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
WaitCheck(Delay := 200, checkInterval := 50, KeyName:="Escape") {
    totalDelay := 0

    ; 如果是暂停状态，进入等待，不执行后续代码
    while(totalDelay < Delay) {
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