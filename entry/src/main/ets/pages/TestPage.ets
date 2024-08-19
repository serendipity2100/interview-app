// 掌握:
// API12之前, 首选项只能存的数据类型:  string boolean 还有string[]  number[] boolean[]
// API12之后, 目前没有什么限制
import { preferences } from '@kit.ArkData'

// 作用:
// 语法:
// 注意:
interface Person {
  name: string
  age: number
}

const zs: Person = {
  name: 'zs',
  age: 18
}

@Entry
@Component
struct Index {
  build() {

    Column() {
      Button('点我')
        .onClick(() => {
          const xxxFile = preferences.getPreferencesSync(getContext(this), { name: 'xxx2' })

          // 💥💥 API12中支持存入非字符串 数字 boolean 类型数据
          xxxFile.putSync('obj', zs)

          xxxFile.flush()
        })

      Button('读取')
        .onClick(() => {
          const xxxFile = preferences.getPreferencesSync(getContext(this), { name: 'xxx2' })

          const zs = xxxFile.getSync('obj', {})

          AlertDialog.show({ message: JSON.stringify(zs), alignment: DialogAlignment.Center })

        })
    }

  }
}