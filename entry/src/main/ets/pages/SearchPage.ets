import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData'
import { promptAction } from '@kit.ArkUI'
import { QuestionListComp } from '../views/Home/QuestionListComp';
import { FilterParams } from '../views/Home/QuestionFilterComp';

interface iRouterParams {
  keywordText: string
}

// 需求: 实现点击搜索
// 需求: 优化一个小问题
@Entry
@Component
struct SearchPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State isInput: boolean = false
  @State list: string[] = []

  aboutToAppear(): void {
    let params = router.getParams() as iRouterParams
    this.keyword = params.keywordText

    this.list = this.historyFile.getSync('list', []) as string[]
    this.onSubmit()

  }

  @State keyword: string = ''
  @State isDel: boolean = false
  historyFile = preferences.getPreferencesSync(getContext(this), { name: 'history' })

  onSubmit() {
    if (this.keyword.trim() === '') {
      promptAction.showToast({ message: '请先输入搜索的内容' })
      return
    }

    const oldIndex = this.list.findIndex(item => item === this.keyword)

    if (oldIndex !== -1) {
      this.list.splice(oldIndex, 1)
    }

    this.list.unshift(this.keyword)
    this.historyFile.putSync('list', this.list)
    this.historyFile.flush()


    this.isInput = false
  }

  build() {
    Navigation() {
      Column({ space: 15 }) {
        TextInput({ placeholder: '输入回车保存数据', text: $$this.keyword })
          .onSubmit(() => {
            this.onSubmit()
          })
          .onClick(() => this.isInput = true)

        if (this.isInput) {
          Row() {
            Text('搜索记录').fontSize(20).fontWeight(800)

            Row() {

              if (this.isDel) {
                Text('全部删除')
                  .onClick(() => {
                    this.list = []
                    this.historyFile.putSync('list', [])
                    this.historyFile.flush()
                  })
                Text(' | ')
                Text('取消删除')
                  .onClick(() => this.isDel = false)
              } else {
                Image($r('app.media.ic_common_delete'))
                  .height(28)
                  .onClick(() => this.isDel = true)
              }

            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.list, (item: string) => {
              this.itemBuilder(item)
            })
          }
        } else {
          QuestionListComp({
            keyword: this.keyword
          })
        }

      }
      .padding(15)
    }
    .titleMode(NavigationTitleMode.Mini)
    .title('搜索页面')
    .padding({ top: this.topHeight })

  }

  @Builder
  itemBuilder(text: string) {
    Row({ space: 20 }) {
      Text(text)
        .onClick(() => {
          //   点击事件
          this.keyword = text
          // 1. 更新keyword, 执行onSubmit
          this.onSubmit()
        })
      if (this.isDel) {
        Text('x')
          .height(30)
          .onClick(() => {
            const index = this.list.findIndex(v => v === text)
            this.list.splice(index, 1)
            this.historyFile.putSync('list', this.list)
            this.historyFile.flush()
          })
      }

    }
    .margin({ right: 10, top: 10 })
    .padding({
      left: 15,
      right: 15,
      top: 5,
      bottom: 5
    })
    .backgroundColor('rgba(0,0,0,0.05)')
    .borderRadius(20)
  }
}