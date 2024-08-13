import { Home } from '../views/Home/Home'
import { Interview } from '../views/Interview/Interview'
import { Mine } from '../views/Mine/Mine'
import { Project } from '../views/Project/Project'
import { window } from '@kit.ArkUI'

// 沉浸式模式-全屏-显示问题
// 1. 非全屏进入到全屏 会有一个闪烁问题✅
// 2. 部分界面需要全屏

// 把所有的界面直接设置为全屏
// 把不需要全屏的界面, 用盒子撑开状态栏高度即可


@Entry
@Component
struct Index {
  async aboutToAppear() {

    const ctx = getContext(this)
    const win = await window.getLastWindow(ctx)
    win.setWindowLayoutFullScreen(true)

    const res = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
    // 1. 初始化AppStorage
    AppStorage.setOrCreate('topHeight', px2vp(res.topRect.height))

  }

  @State currentIndex: number = 0

  @Builder
  tabBuilder(text: string, icon: ResourceStr, selectedIcon: ResourceStr, index: number) {
    Column({ space: 5 }) {
      Image(this.currentIndex === index ? selectedIcon : icon)
        .height(28)
        .aspectRatio(1)
      Text(text)
    }
  }

  build() {
    Tabs({ index: $$this.currentIndex }) {
      TabContent() {
        if (this.currentIndex === 0) {
          Home()
        }

      }.tabBar(this.tabBuilder('首页', $r('app.media.home'), $r('app.media.home_select'), 0))

      TabContent() {
        if (this.currentIndex === 1) {
          Project()
        }

      }.tabBar(this.tabBuilder('项目', $r('app.media.tabbar_project'), $r('app.media.ic_tabbar_project_select'), 1))

      TabContent() {
        if (this.currentIndex === 2) {
          Interview()

        }

      }.tabBar(this.tabBuilder('面经', $r('app.media.interview'), $r('app.media.interview_select'), 2))

      TabContent() {
        if (this.currentIndex === 3) {
          Mine()
        }

      }.tabBar(this.tabBuilder('我的', $r('app.media.tabbar_mine'), $r('app.media.ic_tabbar_mine_select'), 3))

    }
    .animationDuration(0) // 去掉切换动画
    .barPosition(BarPosition.End) // tabs在底部显示
  }
}