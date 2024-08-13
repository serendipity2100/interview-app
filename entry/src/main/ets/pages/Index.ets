import { Home } from '../views/Home/Home'
import { Interview } from '../views/Interview/Interview'
import { Mine } from '../views/Mine/Mine'
import { Project } from '../views/Project/Project'

@Entry
@Component
struct Index {
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
    Row() {
      Column() {
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
  }
}