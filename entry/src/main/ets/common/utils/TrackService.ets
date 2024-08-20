/***
 * TrackService文件作用:  把上报数据的业务逻辑抽取到一个类中去维护
 *
 * */

import { request } from './request';
import { promptAction } from '@kit.ArkUI';

export interface iTimeBody {
  timeList: iTimeItem[]
}

// 访问时长数据埋点接口要求的数据格式
export interface iTimeItem {
  /** 结束时间（毫秒） */
  endTime: number;

  /** 试题id */
  questionId: string;

  /** 开始时间(毫秒) */
  startTime: number;
}

class TrackService {
  timeItem: iTimeItem = {} as iTimeItem

  // 记录开始时间和id
  start(id: string) {
    this.timeItem.startTime = Date.now()
    this.timeItem.questionId = id
  }

  // 记录结束时间 并且上报服务器
  async end() {
    this.timeItem.endTime = Date.now()

    await request<null, iTimeBody>({
      url: 'hm/time/tracking',
      method: 'post',
      data: {
        timeList: [this.timeItem]
      }
    })

    promptAction.showToast({ message: '上报成功' })
  }
}

export const trackService = new TrackService()

