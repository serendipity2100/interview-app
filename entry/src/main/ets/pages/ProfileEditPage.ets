import { iLoginUserModel } from '../models/AccountModel'
import { fileIo, picker } from '@kit.CoreFileKit'
import { emitter, request } from '@kit.BasicServicesKit'
import { request as axiosRequest } from '../common/utils/request'

import { http } from '@kit.NetworkKit'
import { promptAction } from '@kit.ArkUI'
import { HdLoadingDialog } from '../common/components/HdLoading'


@Entry
@Component
struct ProfileEditPage {
  // 获取登录用户数据
  @StorageProp('user') currentUser: iLoginUserModel = {} as iLoginUserModel
  // 获取安全区域高度数据
  @StorageProp("topHeight") topHeight: number = 0
  // 需求: 使用自定义弹窗组件提示上传进度

  // 4. 定义一个percent状态变量
  @State percent: string = '0%'
  // 1. 创建一个自定义弹窗组件控制器
  dialog = new CustomDialogController({
    // 5. 使用状态变量, 传给自定义弹窗组件.   ❌❌❌❌ @State这些装饰器, 只能更新build函数中摆出来的组件, 无法更新CustomDialog中的组件内容
    builder: HdLoadingDialog({ message: '上传进度为' + this.percent }),
    customStyle: true
  })

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
                  const xxxPicker = new picker.PhotoViewPicker()
                  const res = await xxxPicker.select({
                    MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
                    maxSelectNumber: 1
                  })

                  if (res.photoUris.length === 0) {
                    return
                  }

                  const context = getContext(this)
                  const cacheDir = context.cacheDir

                  const oldPath = res.photoUris[0]
                  const oldFile = fileIo.openSync(oldPath, fileIo.OpenMode.READ_ONLY)

                  const fileName = Date.now()
                  fileIo.copyFileSync(oldFile.fd, cacheDir + '/' + `${fileName}.jpg`)


                  // 2.上传前打开自定义弹窗
                  this.dialog.open()
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


                  task.on('fail', (err) => {
                    AlertDialog.show({ message: JSON.stringify(err, null, 2), alignment: DialogAlignment.Center })
                  })

                  task.on('progress', async (updatedSize, totalSize) => {

                    const percent = (updatedSize / totalSize * 100).toFixed(2) + '%'

                    // 💥自定义弹窗组件无法通过父传子更新数据
                    // 1. 使用emitter.emit('事件名',  {data: {键: 值}})
                    emitter.emit('updateMsg', {
                      data: {
                        xxx: `上传进度为${percent}`
                      }
                    })


                    if (updatedSize === totalSize) {
                      // 3. 上传成功后关闭
                      this.dialog.close()
                      const res = await axiosRequest<iLoginUserModel>({ url: 'hm/userInfo' })
                      this.currentUser.avatar = res.data.data.avatar
                    }

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