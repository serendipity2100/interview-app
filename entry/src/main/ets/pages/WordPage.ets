import { promptAction } from '@kit.ArkUI'
import { util } from '@kit.ArkTS'


export interface WordItem {
  zh: string
  en: string
  code: string
}

@Entry
@Component
export struct WordPage {
  @StorageProp('topHeight') topHeight: number = 0
  @State
  showTypeSheet: boolean = false // 控制当前阶段分类弹框
  @State
  showCodeSheet: boolean = false // 控制当前单词详细代码弹框
  @State
  currentType: string = 'CSS3' // 当前阶段名称
  @State
  loading: boolean = false
  // 单词数据
  @State
  words: Record<string, WordItem[]> = {
    'HTML5': [
      {
        "en": "strong",
        "zh": "加粗标签",
        "code": "<strong>加粗内容</strong>"
      }
    ],
    'CSS3': [
      {
        "en": "color",
        "zh": "字体颜色",
        "code": "color: red;"
      }
    ],
    '鸿蒙': [
      {
        "en": "color",
        "zh": "字体颜色",
        "code": "color: red;"
      }
    ],
    'arkTS': [
      {
        "en": "color",
        "zh": "字体颜色",
        "code": "color: red;"
      }
    ],
    '安卓': [
      {
        "en": "color",
        "zh": "字体颜色",
        "code": "color: red;"
      }
    ]
  }
  currentCode: string = ''
  scroller = new Scroller()

  async aboutToAppear() {

    const context = getContext(this)
    const res = await context.resourceManager.getRawFileContent('word.json')

    const decoder = new util.TextDecoder()
    const xxx = decoder.decodeWithStream(res)
    this.words = JSON.parse(xxx)

  }

  // 单词分类弹窗
  @Builder
  typeSheetBuilder() {
    Column() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(Object.keys(this.words), (key: string, index) => {
          Button() {
            Text(key)
              .fontSize(14)
              .fontColor(key === this.currentType ? $r('app.color.common_green') : $r('app.color.common_gray_01'))
          }
          .backgroundColor($r('app.color.common_gray_bg'))
          .padding({
            top: 6,
            right: 12,
            bottom: 6,
            left: 12
          })
          .margin({ right: 12, bottom: 12 })
          .onClick(() => {
            this.currentType = key
            this.showTypeSheet = false
            this.scroller.scrollTo({ yOffset: 0, xOffset: 0 })
          })
        })
      }
    }
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 34
    })
  }

  // 弹出单词用法弹窗
  @Builder
  codeSheetBuilder() {
    Stack() {
      Text("使用WebView动态高亮显示单词用法")
    }
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 34
    })
  }

  build() {
    Navigation() {
      Column() {
        Row() {
          Column({ space: 4 }) {
            Text('开发常用词汇')
            Text(`共 ${this.words[this.currentType]?.length} 个单词`)
              .fontSize(12)
              .fontColor($r('app.color.common_gray_03'))
          }
          .alignItems(HorizontalAlign.Start)

          Row() {
            Text(this.currentType)
              .fontSize(12)
              .fontColor($r('app.color.common_gray_01'))
            Image($r('sys.media.ohos_ic_public_arrow_down'))
              .width(16)
              .aspectRatio(1)
              .fillColor($r('app.color.common_gray_01'))
          }
          .onClick(() => this.showTypeSheet = true)
          .bindSheet($$this.showTypeSheet, this.typeSheetBuilder(), {
            height: 200,
            title: { title: '选择分类' }
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(16)
        .border({ width: { top: $r('app.float.common_border_width') }, color: $r('app.color.common_gray_bg') })

        Divider()
          .strokeWidth(8)
          .color($r('app.color.common_gray_bg'))

        List({ scroller: this.scroller }) {
          ForEach(this.words[this.currentType], (wordItem: WordItem) => {

            ListItem() {
              Row({ space: 6 }) {
                Image($r('sys.media.ohos_ic_public_sound'))
                  .width(20)
                  .aspectRatio(1)
                  .alignSelf(ItemAlign.Start)
                  .fillColor($r('app.color.common_gray_03'))
                  .onClick(() => {
                    // 开启弹框读单词
                  })
                Column({ space: 10 }) {
                  Text(wordItem.en)
                    .fontWeight(FontWeight.Bold)
                  Text(wordItem.zh)
                    .fontSize(14)
                    .fontColor($r('app.color.common_gray_03'))
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Column({ space: 10 }) {
                  Row() {
                    Text('详细代码')
                      .fontSize(12)
                      .fontColor(wordItem.code ? $r('app.color.common_gray_01') : '#dddddd')
                    Image($r('sys.media.ohos_ic_public_arrow_right'))
                      .width(16)
                      .aspectRatio(1)
                      .fillColor(wordItem.code ? $r('app.color.common_gray_01') : '#dddddd')
                  }
                  // .alignSelf(ItemAlign.End)
                  .onClick(() => {
                    // 点击打开详细代码半模态框
                    this.showCodeSheet = true
                  })
                }
              }
              .padding(16)
            }
          })
        }
        .divider({
          strokeWidth: $r('app.float.common_border_width'),
          color: $r('app.color.common_gray_bg')
        })
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .bindSheet($$this.showCodeSheet, this.codeSheetBuilder, {
        height: 500,
        title: { title: '详细代码' }
      })
    }
    .title('常用单词')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
  }
}