import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { iLoginUserModel } from '../../models/AccountModel';

export const instance = axios.create({
  baseURL: 'https://api-harmony-teach.itheima.net/'
})


export function request<T = null, D = null>(config: AxiosRequestConfig<D>) {
  return instance<null, AxiosResponse<T, null>, D>(config)
}


// 拦截器:
// 本质: 钩子函数 - 自动执行
// 时机: 请求拦截器 - 请求前执行

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


