import { router } from '@kit.ArkUI'

@Component
export struct HdSearch {
  @State
  readonlyMode: boolean = true
  // 1. 先把ph变为状态变量
  @State ph: string = 'vue'
  // 2. 准备一个字符串数据 ['vue', 'react', 'javascript',  'html']
  list = ['vue', 'react', 'javascript', 'html']
  // 3. 准备一个默认的index = 0
  index = 0
  timeId = -1

  // 4. 创建后, 开启定时器,每秒+1, 修改数据
  aboutToAppear(): void {
    this.timeId = setInterval(() => {
      this.index++
      // 5. 找到最后一个元素, 重置index为0
      if (this.index > this.list.length - 1) {
        this.index = 0
      }
      this.ph = this.list[this.index]
    }, 1000)
  }

  // 6. 组件销毁时, 关闭定时器
  aboutToDisappear(): void {
    clearInterval(this.timeId)
  }

  bg: string = ''
  color: string = ''

  build() {
    Row() {
      Row({ space: 4 }) {
        Image($r("app.media.ic_common_search"))
          .width($r('app.float.hd_search_icon_size'))
          .aspectRatio(1)
          .fillColor(this.color || $r('app.color.common_gray_02'))
        Text(this.ph || $r('app.string.hd_search_placeholder'))
          .fontColor(this.color || $r('app.color.common_gray_02'))
          .fontSize($r('app.float.common_font14'))
      }
      .layoutWeight(1)
      .height($r('app.float.hd_search_height'))
      .backgroundColor(this.bg || $r('app.color.common_gray_border'))
      .borderRadius($r('app.float.hd_search_radius'))
      .justifyContent(FlexAlign.Center)
    }.onClick(() => {
      router.pushUrl({
        url: 'pages/SearchPage', params: { keywordText: 'xxx' }
      })
    })
  }
}