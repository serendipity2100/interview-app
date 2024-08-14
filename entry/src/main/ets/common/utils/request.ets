import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { iLoginUserModel } from '../../models/AccountModel';
import { promptAction, router } from '@kit.ArkUI';

export const instance = axios.create({
  baseURL: 'https://api-harmony-teach.itheima.net/'
})


export function request<T = null, D = null>(config: AxiosRequestConfig<D>) {
  return instance<null, AxiosResponse<T, null>, D>(config)
}


// 拦截器:
// 本质: 钩子函数 - 自动执行
// 时机: 请求拦截器 - 请求前执行
// 时机: 响应拦截器 - 响应时执行

instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {

  const user = AppStorage.get('user') as iLoginUserModel

  if (user !== undefined) {
    config.headers.Authorization = `Bearer ${user.token.slice(10)}`
  }


  return config;
}, (error: AxiosError) => {
  return Promise.reject(error);
});


// 需求: 统一处理异常: 业务状态码不为10000的异常
instance.interceptors.response.use(
  (res: AxiosResponse) => {
    if (res.data.code !== 10000) {
      promptAction.showToast({ message: res.data.message })
      return Promise.reject(res)
    }

    return res;

  },
  (error: AxiosError) => {


    // 1. 把原本处理401的catch逻辑, 迁移到响应拦截器的异常处理中

    // 2. 添加可选链

    // 3. 删除每次调用时catch中的401逻辑
    if (error.response?.status === 401) {
      promptAction.showToast({ message: '登录过期, 请重新登录' })

      setTimeout(() => {
        router.pushUrl({ url: 'pages/LoginPage' })
      }, 500)

      return
    }

    AlertDialog.show({ message: '接口调用失败' + JSON.stringify(error, null, 2), alignment: DialogAlignment.Center })
    return Promise.reject(error);
  });