import { media } from '@kit.MediaKit';

@CustomDialog
export struct WordSoundDialog {
  controller: CustomDialogController // 必须要有的
  wordEn: string = '' // 英文单词
  wordZh: string = '' // 中文解释
  @State isGreen: boolean = false // 用来控制颜色切换的
  timer: number = -1
  streamId: number = -1

  async aboutToAppear() {
    //   1. 创建一个播放器
    const player = await media.createAVPlayer() // 创建成功后默认是闲置状态

    //   2. 给播放器设置MP3的资源路径 url地址
    player.url = `http://dict.youdao.com/dictvoice?audio=${this.wordEn}&type=1` // mp3下载成功后, 会变成初始状态

    //   3. 💥💥监听状态的变化,
    player.on('stateChange', (state) => {


      // 4. 进入初始状态后, 才可以调用准备函数
      if (state === 'initialized') {
        player.prepare() //  prepare()会让播放器进入 准备状态prepared
      }

      // 5. 进入准备状态后, 才可以调用播放函数play()
      if (state === 'prepared') {
        player.loop = true
        player.play()
      }

    })

  }

  aboutToDisappear(): void {
    console.log('销毁了 -----> ', this.wordZh)
  }

  build() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text(this.wordEn)
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(500)
        Image($r('app.media.icon_public_search'))
          .width(20)
          .aspectRatio(1)
          .fillColor(this.isGreen ? $r('app.color.common_green') : Color.White)
          .onAppear(() => {
            clearInterval(this.timer) // 清除之前的定时器
            this.timer = setInterval(() => { //新开一个定时器
              this.isGreen = !this.isGreen
            }, 500)
          })
          .onDisAppear(() => {
            clearInterval(this.timer) //清除定时器
          })
          .animation({ duration: 300 })
      }

      Text(this.wordZh)
        .fontColor(Color.White)
    }
    .constraintSize({ minWidth: 175 })
    .padding({ left: 16, right: 16 })
    .height(90)
    .borderRadius(45)
    .backgroundColor('#8f000000')
    .justifyContent(FlexAlign.Center)
  }
}