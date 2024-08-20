/***
 * TrackService文件作用:  把上报数据的业务逻辑抽取到一个类中去维护
 *
 * */

// 需求: 累计够5条记录, 上报一次

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
    // 1. 获取首选项文件
    const trackFile = preferences.getPreferencesSync(getContext(), { name: 'xxxTrackFile' })

    // 2. 获取之前存储的上报数据
    const list = trackFile.getSync('list', []) as iTimeItem[]

    // 3. 把最新的数据, 添加到数组中
    list.push(this.timeItem)

    // 4. 判断数组的长度是否够5条
    if (list.length === 5) {
      await request<null, iTimeBody>({
        url: 'hm/time/tracking',
        method: 'post',
        data: {
          timeList: list
        }
      })

      promptAction.showToast({ message: '上报成功' })
      // 4.2上报后清空 首选项
      trackFile.putSync('list', [])
      trackFile.flush()
    } else {
      // 6. 如果不够, 把数据存入首选项
      trackFile.putSync('list', list)
      trackFile.flush()
    }

    // 5. 如果够5条上报数据


  }
}

export const trackService = new TrackService()

