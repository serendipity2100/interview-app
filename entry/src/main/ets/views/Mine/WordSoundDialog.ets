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

    const player = await media.createAVPlayer()

    player.url = `http://dict.youdao.com/dictvoice?audio=${this.wordEn}&type=1`

    player.on('stateChange', (state) => {

      if (state === 'initialized') {
        player.prepare()
      }

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