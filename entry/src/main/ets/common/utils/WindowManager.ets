import { window } from '@kit.ArkUI'

export class WindowManager {
  static async enableFullScreen() {

    const ctx = getContext()
    const win = await window.getLastWindow(ctx)
    win.setWindowLayoutFullScreen(true)

    const res = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
    AppStorage.setOrCreate('topHeight', px2vp(res.topRect.height))
  }

  static async disableFullScreen() {
    const ctx = getContext()
    const win = await window.getLastWindow(ctx)
    win.setWindowLayoutFullScreen(false)

    AppStorage.setOrCreate('topHeight', 0)
  }

  static async setStatusBarLight() {
    const win = await window.getLastWindow(getContext())
    win.setWindowSystemBarProperties({
      // 状态栏的背景颜色
      // statusBarColor:'',
      // 状态栏文字颜色
      statusBarContentColor: '#ffffff' // ❌
    })
  }

  static async setStatusBarDark() {
    const win = await window.getLastWindow(getContext())
    win.setWindowSystemBarProperties({
      // 状态栏的背景颜色
      // statusBarColor:'',
      // 状态栏文字颜色
      statusBarContentColor: '#000000' // ❌
    })
  }
}