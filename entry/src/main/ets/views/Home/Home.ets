@Component
export struct Home {
  @StorageProp('topHeight')
  topHeight: number = 0

  build() {
    Column() {
      Text('')
        .width('100%')
        .height(this.topHeight)
      Text('首页')
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Pink)
    }

  }
}

