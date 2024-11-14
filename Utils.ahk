#Requires AutoHotkey v2.0

/**
 * 定义递归函数，查找按钮文本为“打开”的元素
 * @param element {Acc.IAccessible} 要递归查找的元素
 */
FindOpenButton(element) {
  ; MsgBox("检查子元素1：" . element.Name . " []" . element.Children.Length . " []" . element.Role)
  for child in element.Children {
      ; 检查子元素是否为按钮，并且文本是否为“打开”
      if (child.Role = "button" && child.Name = "打开" ) {
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

WaitMoment()
{
    Sleep(300) ; 等待一段时间确保窗口已置顶
}