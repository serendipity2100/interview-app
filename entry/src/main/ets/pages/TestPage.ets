// 掌握: 
import { IvSkeleton } from '../common/components/IvSkeleton'


@Entry
@Component
struct Index {
  build() {
    Column() {
      Row({ space: 20 }) {
        IvSkeleton({ widthValue: 50, heightValue: 50 })
        Column({ space: 5 }) {
          IvSkeleton({ widthValue: 100, heightValue: 15 })
          IvSkeleton({ widthValue: 70, heightValue: 15 })
        }
        .width(200)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

    }

  }
}