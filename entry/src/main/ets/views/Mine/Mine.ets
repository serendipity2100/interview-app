import { window } from '@kit.ArkUI'

@Component
export struct Mine {
  async aboutToAppear() {
    const win = await window.getLastWindow(getContext(this))
    win.setWindowSystemBarProperties({
      // 状态栏的背景颜色
      // statusBarColor:'',
      // 状态栏文字颜色
      statusBarContentColor: '#ffffff' // ❌
    })
  }

  async aboutToDisappear() {
    const win = await window.getLastWindow(getContext(this))
    win.setWindowSystemBarProperties({
      // 状态栏的背景颜色
      // statusBarColor:'',
      // 状态栏文字颜色
      statusBarContentColor: '#000'
    })
  }

  build() {
    Text('我的')
      .width('100%')
      .height('100%')// vp
      .backgroundColor(Color.Yellow)
  }
}