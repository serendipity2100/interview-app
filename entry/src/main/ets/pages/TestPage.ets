// 掌握: 首选项API的基本使用
import { preferences } from '@kit.ArkData'

// 作用: 持久化存储数据
// 语法: 1. 初始化(获取)首选项文件
// 语法: 2. 如何新增数据  如何 修改数据
// 注意:
//  修改数据putSyne 和 删除数据deleteSync  只会修改内存中数据 💥💥 不能忘记调用flush()方法, 同步到硬盘中

@Entry
@Component
struct Index {
  xxxFile = preferences.getPreferencesSync(getContext(this), { name: 'xxx2' })

  build() {
    Column() {
      Button('存数据到硬盘中')
        .onClick(() => {
          // 1. 获取-首选项文件

          // 2.新增一条数据到首选项文件中, 键值对结构
          this.xxxFile.putSync('list', ['张三', '李四'])

          // 注意:
          // 3. 💥💥把修改的数据, 同步到硬盘中 - 很容易忘记
          this.xxxFile.flush()

        })

      Button('获取数据')
        .onClick(() => {
          // this.xxxFile.getSync('键名', 默认值)
          const list = this.xxxFile.getSync('list', [])
          AlertDialog.show({ message: JSON.stringify(list,), alignment: DialogAlignment.Center })
        })
      Button('删除数据')
        .onClick(() => {
          this.xxxFile.deleteSync('list')
          this.xxxFile.flush()
        })

      Button('修改数据')
        .onClick(() => {
          //   1. 获取旧数据
          const arr = this.xxxFile.getSync('list', []) as string[]

          //   2. 修改旧数据
          arr[0] = 'zs'

          //   3. 调用put方法覆盖旧数据
          this.xxxFile.putSync('list', arr)

          this.xxxFile.flush()

        })
    }

  }
}