import { promptAction, router } from '@kit.ArkUI'

// 登录-点击事件校验数据
// 1. 双向绑定 收集用户输入内容
// 2. 校验数据
// 3. 校验不通过 提示用户

@Entry
@Component
struct LoginPage {
  @State username: string = 'hmheima'
  @State password: string = 'Hmheima%123'
  @State isAgree: boolean = false

  onLogin() {
    if (this.username.trim() === '') {
      promptAction.showToast({ message: '请输入用户名' })
      return
    }

    if (this.password.trim() === '') {
      promptAction.showToast({ message: '请输入密码' })
      return
    }

    if (!this.isAgree) {
      promptAction.showToast({ message: '请勾选用户协议' })
      return
    }

    promptAction.showToast({ message: 'TODO登录接口' })
  }

  build() {
    Column() {
      // logo
      Column({ space: 10 }) {
        Image($r('app.media.icon'))
          .height(55)
          .aspectRatio(1)

        Text('面试宝典')
          .fontSize(28)
          .fontColor('#121826')

        Text('搞定企业面试真题，就用面试宝典')
          .fontSize(14)
          .fontColor('#6F6F6F')
      }
      .margin({ top: 170 })

      //  登录区域
      Column({ space: 20 }) {

        TextInput({ text: $$this.username })
          .backgroundColor(Color.White)
          .width('90%')
          .borderRadius(0)

        TextInput({ text: $$this.password })
          .type(InputType.Password)
          .backgroundColor(Color.White)
          .width('90%')

        Row() {
          Checkbox()
            .select(this.isAgree)
            .selectedColor('#FA6D1D')
            .onChange(value => {
              this.isAgree = value
            })

          Text('已阅读并同意')
            .fontSize(14)
            .fontColor($r('app.color.ih_gray_color'))
            .padding({ right: 4 })
          Text('用户协议')
            .fontSize(14)
            .padding({ right: 4 })
          Text('和')
            .fontSize(14)
            .fontColor($r('app.color.ih_gray_color'))
            .padding({ right: 4 })
          Text('隐私政策')
            .fontSize(14)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/PreviewWebPage'
              })
            })
        }
        .width('90%')

        Button() {
          Row() {
            LoadingProgress()
              .height(28)
              .aspectRatio(1)
              .color(Color.White)
            Text('登录')
          }
        }
        .borderRadius(4)
        .width(328)
        .height(45)
        .fontColor(Color.White)
        .linearGradient({
          angle: 135,
          colors: [
            ['#FCA21C', 0],
            ['#FA6D1D', 1]
          ]
        })
        .onClick(() => {
          this.onLogin()
        })

      }
      .margin({ top: 50 })

    }
    .width('100%')
    .height('100%')
  }
}