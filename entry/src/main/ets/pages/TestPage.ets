import { preferences } from '@kit.ArkData'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct PreDemo {
  // 1. 定义状态变量list, 并使用list做列表渲染
  @State list: string[] = []
  @State keyword: string = ''
  @StorageProp('topHeight') topHeight: number = 0
  @State isDel: boolean = false
  historyFile = preferences.getPreferencesSync(getContext(this), { name: 'history' })

  aboutToAppear(): void {
    // 2. 创建后，获取持久化存储的搜索记录，保存到list上
    this.list = this.historyFile.getSync('list', []) as string[]

  }

  build() {
    Column({ space: 15 }) {
      TextInput({ placeholder: '输入回车保存数据', text: $$this.keyword })
        .onSubmit(() => {
          // 3. 提交事件中-非空校验
          if (this.keyword.trim() === '') {
            promptAction.showToast({ message: '请先输入搜索的内容' })
            return
          }
          // 4. 提交事件中-非重复控制-TODO
          // 5. 持久化list到首选项中
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
        // 2.2
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
            AlertDialog.show({ message: '删除' + text })
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