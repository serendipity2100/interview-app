// 接口返回数据的类型
import { AxiosResponse } from '@ohos/axios';
import { iLoginUserModel } from '../../models/AccountModel';
import { instance } from '../utils/request';

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

  // 需求: 实现发请求查询打卡天数
  // 1. cv类型
  // 2. AboutToAppear发请求
  async aboutToAppear() {
    try {
      // 3. 调用axios发送请求
      const res: AxiosResponse<IResModel> = await instance({
        url: 'hm/clockinInfo',
      })
      AlertDialog.show({ message: '成功:' + JSON.stringify(res, null, 2), alignment: DialogAlignment.Center })
    } catch (err) {
      // 4. 踩坑 - 会失败
      AlertDialog.show({ message: '失败:' + JSON.stringify(err, null, 2), alignment: DialogAlignment.Center })
    }

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
      }
    }
    .width((74))
    .height((28))
  }
}