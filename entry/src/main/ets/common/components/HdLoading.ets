import emitter from '@ohos.events.emitter'

@CustomDialog
export struct HdLoadingDialog {
  // 2. 加一个装饰
  @State
  message: string = ''
  controller: CustomDialogController

  // 3. 创建后使用emitter.on监听,  收消息
  aboutToAppear(): void {
    emitter.on('updateMsg', (res) => {
      this.message = res.data!.xxx
    })
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      LoadingProgress().width(30).height(30).color('#fff')
      if (this.message) {
        Text(this.message).fontSize((14)).fontColor('#fff')
      }
    }
    .width(150)
    .height(50)
    .padding(10)
    .backgroundColor('rgba(0,0,0,0.5)')
    .borderRadius(8)
  }
}