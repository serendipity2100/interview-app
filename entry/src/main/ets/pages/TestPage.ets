@Entry
@Component
struct PreDemo {
  @State keyword: string = ''
  @StorageProp('topHeight') topHeight: number = 0
  @State isDel: boolean = false

  aboutToAppear(): void {

  }

  build() {
    Column({ space: 15 }) {
      TextInput({ placeholder: '输入回车保存数据', text: $$this.keyword })
        .onSubmit(() => {
          AlertDialog.show({ message: this.keyword })
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
        ForEach([1, 2, 3, 4], (item: number) => {
          this.itemBuilder('文本' + item)
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