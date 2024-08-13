import { promptAction } from '@kit.ArkUI'

@Component
export struct Home {
  // onPageShow
  aboutToAppear(): void {
    console.log(' ---- -> 自定义组件创建 准备发请求 ',)
  }

  aboutToDisappear(): void {
    console.log(' -----> 自定义组件销毁 ',)
  }

  build() {
    Text('首页')
  }
}