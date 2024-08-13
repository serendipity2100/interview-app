@Component
export struct Home {
  // 2. 去到子组件中使用@StorageProp获取状态栏高度
  @StorageProp('topHeight')
  topHeight: number = 0

  build() {
    Column() {
      // 3. 设置padding或高度, 撑开状态栏
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

