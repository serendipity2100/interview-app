import { iLoginUserModel } from '../models/AccountModel'
import { fileIo, picker } from '@kit.CoreFileKit'
import { request } from '@kit.BasicServicesKit'
import { http } from '@kit.NetworkKit'


@Entry
@Component
struct ProfileEditPage {
  // 获取登录用户数据
  @StorageProp('user') currentUser: iLoginUserModel = {} as iLoginUserModel
  // 获取安全区域高度数据
  @StorageProp("topHeight") topHeight: number = 0

  build() {
    Navigation() {
      Stack() {
        List() {
          ListItem() {
            Row() {
              Text('头像')
              // 回显用户头像
              Image(this.currentUser.avatar)
                .width((40))
                .width((40))
                .borderRadius((40))
                .border({ width: 0.5, color: '#e4e4e4' })
                .onClick(async () => {
                  // 1. ✅打开相册  选择图片(url路径)
                  const xxxPicker = new picker.PhotoViewPicker()
                  const res = await xxxPicker.select({
                    MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
                    maxSelectNumber: 1
                  })

                  // 0. 使用return防止if 嵌套
                  if (res.photoUris.length === 0) {
                    return
                  }

                  const context = getContext(this)
                  const cacheDir = context.cacheDir

                  // ✅ 2. 拷贝图片到缓存目录
                  const oldPath = res.photoUris[0]
                  const oldFile = fileIo.openSync(oldPath, fileIo.OpenMode.READ_ONLY)

                  const fileName = Date.now()
                  fileIo.copyFileSync(oldFile.fd, cacheDir + '/' + `${fileName}.jpg`)

                  // 3. request.uploadFile
                  const task = await request.uploadFile(context, {
                    url: 'https://api-harmony-teach.itheima.net/hm/userInfo/avatar',
                    header: {
                      'content-type': 'multipart/form-data',
                      Authorization: `Bearer ${this.currentUser.token}`
                    },
                    method: http.RequestMethod.POST,
                    files: [{
                      filename: `${fileName}.jpg`,
                      uri: `internal://cache/${fileName}.jpg`,
                      name: 'file',
                      type: 'jpg'
                    }],
                    data: []
                  })

                  task.on('complete', () => {
                    AlertDialog.show({ message: '上传成功', alignment: DialogAlignment.Center })
                  })

                  task.on('fail', (err) => {
                    AlertDialog.show({ message: JSON.stringify(err, null, 2), alignment: DialogAlignment.Center })
                  })

                })
            }.width('100%').height((60)).justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Text('昵称')
              // 回显用户昵称
              TextInput({ text: this.currentUser.nickName || '昵称' })
                .textAlign(TextAlign.End)
                .layoutWeight(1)
                .padding(0)
                .height((60))
                .backgroundColor(Color.Transparent)
                .borderRadius(0)
                .onSubmit(() => {
                  // 修改昵称 this.updateNickName()

                })
            }.width('100%').height(60).justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .height('100%')
        .padding({
          left: (45),
          right: (45),
          top: (15),
          bottom: (15)
        })
        .divider({ strokeWidth: 0.5, color: '#f5f5f5' })

      }.width('100%')
      .height('100%')
    }
    .padding({ top: this.topHeight + 10 })
    .title('完善个人信息')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .linearGradient({
      colors: [['#FFB071', 0], ['#f3f4f5', 0.3], ['#f3f4f5', 1]]
    })
  }
}