import { Logger } from '../common/utils/Logger';

@Entry
@Component
struct Index {
  @State message: string = 'Hello HM';

  build() {
    Column() {
      Button('黄色警告日志')
        .onClick(() => {
          Logger.warn('xxx', '警告', 'hello')
          Logger.error('xxx', '警告', 'hello')
          Logger.info('xxx', '警告', 'hello')

        })
    }
  }
}