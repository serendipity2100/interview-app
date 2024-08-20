/** 返回数据 */
export interface iLoginUserModel {
  /** 用户头像地址 */
  avatar?: string;

  /** 连续打卡天数 */
  clockinNumbers: number;

  /** 用户id */
  id: string;

  /** 昵称 */
  nickName: string;

  /** token过期后，刷新token使用 */
  refreshToken: string;

  /** 分享加密串 */
  shareInfo: string;

  /** 后续交互使用的token */
  token: string;

  /** 学习时长，单位s */
  totalTime: number;

  /** 昵称 */
  username?: string;
}

export interface ILoginBody {
  /** 密码 */
  password: string;

  /** 用户名 */
  username: string;
}