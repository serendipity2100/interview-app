@Entry
@Component
struct Index {
  @State message: string = 'Hello HM';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .backgroundColor($r('app.color.common_main_color'))
    }
    .height('100%')
    .width('100%')
  }
}