import axios, { AxiosRequestConfig, AxiosResponse } from '@ohos/axios'

export const instance = axios.create({
  baseURL: 'https://api-harmony-teach.itheima.net/'
})


// 1. 迁移函数到request文件中

// 3. 给泛型设置初始类型
export function request<T = null, D = null>(config: AxiosRequestConfig<D>) {
  return instance<null, AxiosResponse<T, null>, D>(config)
}
