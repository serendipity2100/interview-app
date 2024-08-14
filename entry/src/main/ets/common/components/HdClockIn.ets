// 接口返回数据的类型
import { iLoginUserModel } from '../../models/AccountModel';
import { request } from '../utils/request';
import { promptAction } from '@kit.ArkUI';

export interface IResModel {
  /** 请求成功 10000 标志  */
  code: number;

  /** 返回数据  */
  data: IData;

  /** 请求成功  */
  message: string;

  /** 请求成功标志  */
  success: boolean;
}

// 返回数据
export interface IData {
  /** 连续签到天数  */
  clockinNumbers: number;
}


@Component
export struct HdClockIn {
  @Prop
  clockCount: number = 0
  @StorageProp('user')
  userInfo: iLoginUserModel = {} as iLoginUserModel

  async aboutToAppear() {

    try {
      // 4. 改造打卡组件中的调用方式
      const res = await request<IResModel>({
        url: 'hm/clockinInfo',
        headers: {
          Authorization: `Bearer ${this.userInfo.token}`
        }
      })

      if (res.data.code !== 10000) {
        promptAction.showToast({ message: res.data.message })
        return
      }

      this.clockCount = res.data.data.clockinNumbers

    } catch (err) {
      AlertDialog.show({ message: '失败:' + JSON.stringify(err, null, 2), alignment: DialogAlignment.Center })
    }

  }

  async onClock() {
    // 4. 改造打卡组件中的调用方式
    const res = await request<IResModel>({
      url: 'hm/clockin',
      method: 'post',
      headers: {
        Authorization: `Bearer ${this.userInfo.token}`
      }
    })

    if (res.data.code !== 10000) {
      promptAction.showToast({ message: res.data.message })
      return
    }

    // 4. 更新打卡功能
    this.clockCount = res.data.data.clockinNumbers
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      Image(this.clockCount > 0 ? $r('app.media.clocked') : $r('app.media.unclock'))
        .objectFit(ImageFit.Fill)
      if (this.clockCount > 0) {
        Column() {
          Text('已连续打卡')
            .fontSize(8)
          Text() {
            Span(this.clockCount.toString())
              .fontWeight(600)
              .fontSize(12)
            Span(' 天')
              .fontSize(10)
          }
        }
        .width('50')
      } else {
        Text('打卡')
          .width('50')
          .textAlign(TextAlign.Center)
          .fontSize((18))
          .fontWeight(500)
          .fontColor('#333C4F')
          .margin({ bottom: (4) })
          .onClick(() => {
            this.onClock()
          })
      }
    }
    .width((74))
    .height((28))
  }
}