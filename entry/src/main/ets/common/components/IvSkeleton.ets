@Preview
@Component
export struct IvSkeleton {
  @State translageX: string = '-100%' // 定义闪电效果的位置
  widthValue: number = 100
  heightValue: number = 28

  build() {
    Stack() {
      // 背景效果
      Text()
        .height(this.heightValue)
        .width(this.widthValue)
        .backgroundColor('rgba(0,0,0,0.5)')

      // 闪电效果
      Text()
        .height(this.heightValue)
        .width(this.widthValue)
        .translate({ x: this.translageX })// 控制闪电位置
        .onAppear(() => {
          // 当组件加载后，触发此函数，将translate的x轴位置改变到100%
          this.translageX = '100%'
        })
        .animation({
          duration: 1500, // 1.5秒内完成闪电动画
          iterations: -1  // 无限闪动动画
        })
        .linearGradient({
          // 闪电效果
          angle: 90,
          colors: [
            ['rgba(255,255,255,0)', 0],
            ['rgba(255,255,255,1)', 0.5],
            ['rgba(255,255,255,0)', 1]
          ]
        })

    }
  }
}