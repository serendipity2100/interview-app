// 掌握: 日历组件的基本使用
// 作用: 
// 语法: 
// 注意:
// 1. 创建一个自定义弹窗组件
// 2. 在要使用的组件中, 创建弹窗控制器

import { HmCalendar } from '@ohmos/calendar'
import { promptAction } from '@kit.ArkUI'
import { HdLoading } from '../common/components/HdLoading'

@Entry
@Component
struct Index {
  // 2. new 创建控制器
  xxx = new CustomDialogController({
    // 表示如何渲染弹出层
    builder: HdLoading(),
    // 自定义样式
    customStyle: true,
    // alignment: DialogAlignment.TopStart
  })

  build() {
    Button('点我打开')
      .onClick(() => {
        // 3. 调用控制器的open方法
        this.xxx.open()
      })

  }
}