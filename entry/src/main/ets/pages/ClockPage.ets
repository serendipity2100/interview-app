import { HmCalendar, HmCalendarSelectedDay } from '@ohmos/calendar'
import { request } from '../common/utils/request'
import { IClockData } from '../models/ClockModel'


// 需求: 实现渲染日历高亮
// 1. 定义一个高亮的数组 - 状态变量
// 2. 把状态变量传给日历组件
// 3. 把服务器给我的数据，更新到状态变量上

@Entry
@Component
export struct ClockPage {
  @StorageProp("topHeight") topHeight: number = 0
  @State totalClockinNumber: number = 0 //累计打卡
  @State clockinNumbers: number = 0 //连续打卡
  // 1. 定义一个高亮的数组 - 状态变量
  @State selectedDays: HmCalendarSelectedDay[] = []

  aboutToAppear(): void {
    this.getClockData()
  }

  async getClockData() {
    const res = await request<IClockData>({ url: 'hm/clockinInfo' })
    this.totalClockinNumber = res.data.data.totalClockinNumber
    this.clockinNumbers = res.data.data.clockinNumbers
    // 3. 把服务器给我的数据，更新到状态变量上
    this.selectedDays = res.data.data.clockins.map((item) => {
      return { date: item.createdAt } as HmCalendarSelectedDay
    })

  }

  build() {
    Navigation() {
      Column({ space: 16 }) {
        Row() {
          this.dayBuilder({ day: this.totalClockinNumber, text: '累计打卡' })
          this.dayBuilder({ day: this.clockinNumbers, text: '连续打卡' })
        }
        .padding({
          top: 10,
          bottom: 25,
          left: 16,
          right: 16
        })
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row() {
          HmCalendar({
            color: '#0094ff',
            // 2. 把状态变量传给日历组件
            selectedDays: this.selectedDays
          })
            .borderRadius(8)
            .border({ width: 0.5, color: '#ededed' })
            .shadow({ color: '#ededed', radius: 16 })

        }
        .padding({ left: 16, right: 16 })

      }
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.clocked_bg'))
      .backgroundImageSize({ width: '100%' })
    }
    .title('每日打卡')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight + 15 })

  }

  // 累计打卡、连续打卡公共布局
  @Builder
  dayBuilder(params: DayBuilderParams) {
    Column() {
      Row() {
        Text(params.day.toString())
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        Text('天')
          .fontSize(10)
          .fontColor($r('app.color.common_gray_01'))
          .margin({ bottom: 8, left: 10 })
      }
      .alignItems(VerticalAlign.Bottom)

      Text(params.text)
        .fontSize(10)
        .fontColor($r('app.color.common_gray_01'))
    }.margin({ right: 36 })
  }
}

interface DayBuilderParams {
  day: number
  text: string
}