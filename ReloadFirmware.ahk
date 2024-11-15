#Requires AutoHotkey v2.0

OpenFileMenu() {
    ; 使用快捷键打开“文件”菜单
    Send("{Alt}")
    WaitMoment()
    Send("F")
    WaitMoment()

    ; 等待菜单栏显示
    if (WaitToVisit("3,1,1") == false) {
        return
    } else {
        LogInfo("ReloadFirmware 已成功打开文件菜单栏")
    }
}

/**
 * 
 * @param {Integer} hWnd 
 * @returns {Acc.IAccessible}
 */
GetSecondRow(hWnd) {
    ; 获取第二行
    secondRow := Acc.ElementFromPath("4,1,4,7,4,4,4,2", hWnd)
    if (!secondRow || secondRow.Name == "") {
        LogInfo("ReloadFirmware 列表项不存在或为空")
        return
    }
    return secondRow
}

DeleteFirmware(hWnd) {
    ; 删除固件按钮
    deleteFirmware := Acc.ElementFromPath("4,1,4,7,4,6,4", hWnd)
    if (!deleteFirmware || deleteFirmware.Name == "") {
        LogInfo("ReloadFirmware 列表项不存在或为空")
        return
    }
    deleteFirmware.Click()

    ; 等待删除固件成功的弹窗
    WaitMoment(500)
    ; 关闭弹窗
    Send("{Enter}")
    WaitMoment()
    LogInfo("ReloadFirmware 已成功进行删除固件操作")
}

AddFirmware(hWnd) {
    ; 添加固件按钮
    addFirmware := Acc.ElementFromPath("4,1,4,7,4,5,4", hWnd)
    if (!addFirmware || addFirmware.Name == "") {
        LogInfo("ReloadFirmware 列表项不存在或为空")
        return
    }
    addFirmware.Click()
    ; 获取文件浏览器窗口句柄
    hWndFileBrowser := GetHWnd(FileBrowserWindow)
    if (!hWndFileBrowser) {
        LogInfo("ReloadFirmware 文件浏览器 窗口未找到")
        return
    }

    SendText(FirmwarePath)
    WaitMoment()
    Send("{Enter}")
}

SelectFirmware(hWnd) {
    hWndFirmwareTitle := "Power Writer® 多固件文档选择器"
    ; 获取多固件文档选择器窗口句柄
    hWndFirmwareBrowser := GetHWnd(hWndFirmwareTitle)
    if (!hWndFirmwareBrowser) {
        LogInfo("ReloadFirmware 多固件文档选择器 窗口未找到")
        return
    }

    Send("{Tab}{Down}")
    WaitMoment()
    Send("{Tab}{Tab}{Enter}")
    WaitMoment()
    Send("{Enter}")
    WaitMoment()
    Send("{Enter}")

    secondRow := GetSecondRow(hWnd)
    if (!secondRow) {
        return
    }
    if (!InStr(secondRow.Name, NewVersion ".hex")) {
        LogInfo("ReloadFirmware 列表版本号不正确: " secondRow.Name)
        return
    }
    LogInfo("ReloadFirmware 行信息 Name: " secondRow.Name)
    LogInfo("ReloadFirmware 行信息 Description: " secondRow.Description)
}

SaveAsPkgFirmware(filename) {
    ; 使用快捷键打开“文件”菜单
    OpenFileMenu()

    ; 使用快捷键点击“另存为”
    Send("{Down}{Down}{Down}{Enter}")

    ; 文件另存为窗口
    hWndSpt := GetHWnd(SelectProjectTitle)
    if (!hWndSpt) {
        LogInfo("找不到指定的窗口: " . SelectProjectTitle) ; 如果窗口不存在，显示错误信息
        return
    }

    WinActivate(SelectProjectTitle)
    WinWaitActive(SelectProjectTitle, , 10)

    ; 使用tab激活文件名输入框
    Send("{Tab}")
    WaitMoment()
    Send("{Enter}")
    WaitMoment()
    SendText(SaveAsPath "\" filename) ; 输入文本
    WaitMoment()
    Send("{Enter}")
    ; 确认另存为
    WaitMoment(500)
    Send("{Enter}")
    LogInfo("ReloadFirmware 已进行文件另存为操作")
    LogInfo("ReloadFirmware 文件名中的版本号已更新: " filename)
}

SaveAsZpkgFirmware(filename) {

    OpenFileMenu()
    Send("{Down}{Down}{Down}{Down}{Down}{Enter}{Enter}")

    ; 获取文件浏览器窗口句柄
    hWndFileBrowser := GetHWnd(SelectProjectTitle)
    if (!hWndFileBrowser) {
        LogInfo("ReloadFirmware 文件浏览器 窗口未找到")
        return
    }

    ; 4,12,4
    randomSecButton := Acc.ElementFromPath("4,12,4", hWndFileBrowser)
    if (!randomSecButton || randomSecButton.Name != "随机生成" || randomSecButton.Role != 43) {
        LogInfo("ReloadFirmware 随机选择按钮未找到")
        return
    }
    randomSecButton.Click()
    LogInfo("ReloadFirmware 已进行随机生成项目密码操作")

    SendEvent("{Tab}{Tab}")
    WaitMoment(500)
    SendEvent("{Enter}")
    WaitMoment(500)
    SendEvent("{Enter}")
    WaitMoment()
    SendEvent("{Alt}s")
    WaitMoment()
    
    SavePrintScreen(CheckImageSavePath "\", filename "_" A_Now ".png")
    SendEvent("{Enter}")
    LogInfo("ReloadFirmware 已进行zpkg文件的保存操作")
}

; 重新载入固件
ReloadFirmware(filename) {
    if (!InStr(filename, "V" OldVersion)) {
        LogInfo("ReloadFirmware " filename " 中的版本号，不符合要求: V" OldVersion)
        return
    }
    filename := UpgradeVersionName(filename, OldVersion, NewVersion)
    hWnd := GetHWnd(PowerWriterTitle)
    if !hWnd {
        LogInfo("ReloadFirmware " PowerWriterTitle " 找不到此窗口" hWnd)
        return
    }

    secondRow := GetSecondRow(hWnd)
    if (!secondRow) {
        return
    }

    rowName := secondRow.Name

    if (!RegExMatch(rowName, "\.hex$")) {
        LogInfo("ReloadFirmware 列表项不以.hex结尾请检查: " rowName)
        return
    }
    if (!(secondRow.State & Acc.State.Selected)) {
        LogInfo("列没有被选中" rowName)
        return
    }
    if (!InStr(rowName, OldVersion)) {
        LogInfo("ReloadFirmware 列名中的版本号不正确" rowName "所需版本号: " OldVersion)
        ExitApp()
        return
    }

    ; 使用 Select 方法选择此行
    ; secondRow.Select(Acc.SelectionFlag.TakeSelection)
    ; secondRow.Click()
    LogInfo("ReloadFirmware 选中的列表项: " rowName)
    WaitMoment()

    DeleteFirmware(hWnd)
    AddFirmware(hWnd)
    SelectFirmware(hWnd)
    SaveAsPkgFirmware(filename)
    SaveAsZpkgFirmware(filename)
}
