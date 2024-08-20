/***
 * TrackService文件作用:  把上报数据的业务逻辑抽取到一个类中去维护
 *
 * */


import { request } from './request';
import { promptAction } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';

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
    const trackFile = preferences.getPreferencesSync(getContext(), { name: 'xxxTrackFile' })

    const list = trackFile.getSync('list', []) as iTimeItem[]

    list.push(this.timeItem)

    if (list.length === 5) {
      await request<null, iTimeBody>({
        url: 'hm/time/tracking',
        method: 'post',
        data: {
          timeList: list
        }
      })

      promptAction.showToast({ message: '上报成功' })
      trackFile.putSync('list', [])
      trackFile.flush()
    } else {
      trackFile.putSync('list', list)
      trackFile.flush()
    }

  }
}

export const trackService = new TrackService()

