import { preferences } from '@kit.ArkData'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct PreDemo {
  @State list: string[] = []
  @State keyword: string = ''
  @StorageProp('topHeight') topHeight: number = 0
  @State isDel: boolean = false
  historyFile = preferences.getPreferencesSync(getContext(this), { name: 'history' })

  aboutToAppear(): void {
    this.list = this.historyFile.getSync('list', []) as string[]

  }

  build() {
    Column({ space: 15 }) {
      TextInput({ placeholder: '输入回车保存数据', text: $$this.keyword })
        .onSubmit(() => {
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
          this.keyword = ''
        })

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
    }
    .padding(15)
  }

  @Builder
  itemBuilder(text: string) {
    Row({ space: 20 }) {
      Text(text)
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