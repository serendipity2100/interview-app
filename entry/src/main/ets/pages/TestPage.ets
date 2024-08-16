// 掌握: 日历组件的基本使用
// 作用: 
// 语法: 
// 注意:

import { HmCalendar } from '@ohmos/calendar'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  build() {
    Column() {
      HmCalendar({
        color: '#f00',
        text: '已签到',
        // 控制高亮的日期
        selectedDays: [
          { date: '2024-08-01' },
          { date: '2024-01-10' },
          { date: '2024-01-20' },
        ],
        onClickDate: (date) => {
          promptAction.showToast({ message: date })
        },
        onChangeMonth: (month) => {
          promptAction.showToast({ message: month })
        }
      })
        .borderRadius(8)
        .border({ width: 0.5, color: '#ededed' })
        .shadow({ color: '#ededed', radius: 16 })
    }

  }
}