// 1. 创建一个弹出层组件

@CustomDialog
export struct HdLoading {
  // 💥必须定义属性和控制类型
  controller: CustomDialogController

  build() {
    Text('我是被弹出来的内容')
      .backgroundColor(Color.Pink)
      .padding(5)
      .onClick(() => {
        this.controller.close()
      })
  }
}

