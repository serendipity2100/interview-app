/** 返回数据 */
export interface IClockData {
  /** 连续签到天数 */
  clockinNumbers: number;

  /** 签到信息 */
  clockins: IClockin[];

  /** 当天是否签到 */
  flag: boolean;

  /** 累计签到天数 */
  totalClockinNumber: number;

}

export interface IClockin {
  /** 签到时间 */
  createdAt: string;
  id: string;
}