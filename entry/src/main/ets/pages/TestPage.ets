// 掌握: 首选项API的基本使用
import { preferences } from '@kit.ArkData'

// 作用: 持久化存储数据
// 语法: 1. 初始化(获取)首选项文件
// 语法: 2. 如何新增数据  如何 修改数据


@Entry
@Component
struct Index {
  build() {
    Button('存数据到硬盘中')
      .onClick(() => {
        // 1. 获取-首选项文件
        const xxxFile = preferences.getPreferencesSync(getContext(this), { name: 'xxx2' })

        // 2.新增一条数据到首选项文件中, 键值对结构
        xxxFile.putSync('list', ['张三', '李四'])

        // 注意:
        // 3. 💥💥把修改的数据, 同步到硬盘中 - 很容易忘记
        xxxFile.flush()

      })
  }
}