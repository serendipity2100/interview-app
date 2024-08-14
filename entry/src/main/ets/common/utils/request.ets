import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { iLoginUserModel } from '../../models/AccountModel';
import { promptAction } from '@kit.ArkUI';

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

// 1. 拦截器配置在实例对象上
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {

  // 💥每次发请求前, 自动在这里添加token到请求头上
  // 2. 先获取token
  const user = AppStorage.get('user') as iLoginUserModel

  // 3. 判断user是不是undefined
  if (user !== undefined) {
    // 4. 添加token到请求头上
    // 5. 删除所有接口中传参的token, 测试接口正常
    config.headers.Authorization = `Bearer ${user.token}`
  }

  // console.log('请求前触发了, 可以看到请求的参数 -----> ', JSON.stringify(config))

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
    // 失败时自定执行的回调

    // 1. 统一提示接口错误

    // 2. 去组件中把接口调用的alert提示都删除掉
    AlertDialog.show({ message: '接口调用失败' + JSON.stringify(error, null, 2), alignment: DialogAlignment.Center })
    return Promise.reject(error);
  });