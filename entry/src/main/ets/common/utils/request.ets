import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { iLoginUserModel } from '../../models/AccountModel';
import { promptAction, router } from '@kit.ArkUI';

export const instance = axios.create({
  baseURL: 'https://api-harmony-teach.itheima.net/'
})

export interface IRes<T> {
  /** 请求成功10000标志 */
  code: number;

  /** 返回数据 */
  data: T;

  /** 请求成功 */
  message: string;

  /** 请求成功标志 */
  success: boolean;
}

export function request<T = null, D = null>(config: AxiosRequestConfig<D>) {

  return instance<null, AxiosResponse<IRes<T>, null>, D>(config)
}


instance.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {

    const user = AppStorage.get('user') as iLoginUserModel
    if (user !== undefined) {
      // 💥删除bug
      config.headers.Authorization = `Bearer ${user.token}`
    }

    return config;

  },
  (error: AxiosError) => {
    return Promise.reject(error);
  }
);


instance.interceptors.response.use(
  (res: AxiosResponse) => {
    // http状态码 一定是2xx
    if (res.data.code !== 10000) {
      promptAction.showToast({ message: res.data.message })
      return Promise.reject(res)
    }
    return res;

  },
  (error: AxiosError) => {

    if (error.response?.status === 401) {
      promptAction.showToast({ message: '登录过期, 请重新登录' })

      setTimeout(() => {
        router.pushUrl({ url: 'pages/LoginPage' })
      }, 500)

      return
    }

    AlertDialog.show({ message: '接口调用失败' + JSON.stringify(error, null, 2), alignment: DialogAlignment.Center })
    return Promise.reject(error);
  }
);

