import { preferences } from '@kit.ArkData'
import { BusinessError } from '@kit.BasicServicesKit'

@Entry
@Component
struct TestPage {
  @State keyword: string = ''
  @StorageProp('topHeight') topHeight: number = 0
  @State searchList: string[] = []
  preInstance = preferences.getPreferencesSync(getContext(this), { name: 'testStore' })

  aboutToAppear(): void {
    this.searchList = this.preInstance.getSync('searchList', []) as string[]
  }

  @Builder
  itemBuilder(text: string) {
    Row({ space: 20 }) {
      Text(text)
      Text('x')
        .height(30)
        .onClick(() => {
          this.searchList = this.searchList.filter(item => item != text)
          this.preInstance.putSync('searchList', this.searchList)
          this.preInstance.flush()
        })
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

  build() {
    Column({ space: 15 }) {
      // 1. 搜索关键字
      TextInput({ placeholder: '输入回车保存数据', text: $$this.keyword })
        .onSubmit(() => {
          const temp = this.keyword.trim()
          if (temp && this.searchList.indexOf(temp) === -1) {
            this.searchList.unshift(temp)
          }
          this.preInstance.putSync('searchList', this.searchList)
          this.preInstance.flush()
        })

      // 2. 关键字列表
      Row() {
        Text('搜索记录').fontSize(20).fontWeight(800)

        Row() {
          Text('全部删除')
            .onClick(() => {
              this.preInstance.deleteSync('searchList')
              this.preInstance.flush()
              this.searchList = []
            })
          Text(' | ')
          Text('取消删除')

          Image($r('app.media.ic_common_delete'))
            .height(28)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      //   3. 关键字列表
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.searchList, (item: string) => {
          this.itemBuilder(item)
        })
      }

      Button('删除首选项文件store1')
        .onClick(() => {
          preferences.deletePreferences(getContext(), 'store1', (err: BusinessError) => {
            if (err) {
              console.error("Failed to delete preferences. code =" + err.code + ", message =" + err.message);
              return;
            }
            console.info("Succeeded in deleting preferences.");
          })
        })

      Button('删除首选项文件testStore')
        .onClick(() => {
          preferences.deletePreferences(getContext(), 'testStore', (err: BusinessError) => {
            if (err) {
              console.error("Failed to delete preferences. code =" + err.code + ", message =" + err.message);
              return;
            }
            console.info("Succeeded in deleting preferences.");
          })
        })
    }
    .padding(15)
  }
}