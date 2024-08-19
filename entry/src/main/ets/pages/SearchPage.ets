import { router } from '@kit.ArkUI';

interface iRouterParams {
  keywordText: string
}

@Entry
@Component
struct SearchPage {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
    let params = router.getParams() as iRouterParams
    this.message = params.keywordText
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}