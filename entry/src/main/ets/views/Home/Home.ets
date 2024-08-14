import { HdClockIn } from '../../common/components/HdClockIn'
import { HdSearch } from '../../common/components/HdSearch'

@Component
export struct Home {
  // 获取AppStorage中的数据
  @StorageProp("topHeight") topHeight: number = 0

  build() {
    Column() {
      Row() {
        // 1.0 搜索组件静态
        HdSearch()
          .layoutWeight(3) // 占3/4份
        // 2.0 打卡组件
        HdClockIn()
          .layoutWeight(1) //占1/4
      }

      // 3.0 轮播图
      Swiper() {
        Image($r('app.media.banner_qa'))
          .objectFit(ImageFit.Fill)
          .height(200)

        Image($r('app.media.banner_pj'))
          .objectFit(ImageFit.Fill)
          .height(200)

        Image($r('app.media.banner_ai'))
          .objectFit(ImageFit.Fill)
          .height(200)
      }
      .padding(10)
      .autoPlay(true)
      .indicator(DotIndicator.dot()
        .selectedColor(Color.White)
        .bottom(20))
    }
    .padding({ top: this.topHeight })
    .height('100%')
    .width('100%')
  }
}