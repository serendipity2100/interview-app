import { promptAction, router } from '@kit.ArkUI'
import axios, { AxiosResponse } from '@ohos/axios'
import { instance } from '../common/utils/request'
import { ILoginBody, IResponseModel } from '../models/AccountModel'


// 登录-✅点击事件校验数据
// 登录-✅调用接口获取数据,
// 状态码-两种
// 1. http状态码:  2xx-5xxx 标记通信成功或失败
// 2. 业务状态码:  xxxx 由后端的文档, 成功的标识


@Entry
@Component
struct LoginPage {
  @State username: string = 'hmheima'
  @State password: string = 'Hmheima%123'
  @State isAgree: boolean = true

  async onLogin() {
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

    try {
      const res = await instance<null, AxiosResponse<IResponseModel, null>, ILoginBody>({
        url: 'hm/login',
        method: 'post',
        data: {
          username: this.username,
          password: this.password
        }
      })

      // 通信成功 并且 业务成功 🔜保存数据到AppStorage中, 跳转页面到首页  提示用户
      // 2. 处理业务失败的原因
      if (res.data.code !== 10000) {
        promptAction.showToast({ message: res.data.message })
        return
      }

      AlertDialog.show({ message: JSON.stringify(res, null, 2), alignment: DialogAlignment.Center })
      // 3. 处理登录业务成功后的逻辑
      promptAction.showToast({ message: '登录成功' })
      AppStorage.setOrCreate('user', res.data.data)
      setTimeout(() => {
        router.pushUrl({ url: 'pages/Index' })
      }, 500)

    } catch (err) {
      // 1. 提示通信失败的原因
      AlertDialog.show({ message: "错误: " + JSON.stringify(err, null, 2), alignment: DialogAlignment.Center })
    }


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