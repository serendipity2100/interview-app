import { window } from '@kit.ArkUI'
import { WindowManager } from '../../common/utils/WindowManager'

@Component
export struct Mine {
  async aboutToAppear() {
    WindowManager.setStatusBarLight()
  }

  async aboutToDisappear() {
    WindowManager.setStatusBarDark()
  }

  build() {
    Text('我的')
      .width('100%')
      .height('100%')// vp
      .backgroundColor(Color.Yellow)
  }
}