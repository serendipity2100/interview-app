import { HdTag } from '../common/components/HdTag'
import { promptAction, router } from '@kit.ArkUI'
import { request } from '../common/utils/request'
import { HdLoadingDialog } from '../common/components/HdLoading'
import { trackService } from '../common/utils/TrackService'

export interface QuestionDetail {
  id: string
  stem: string
  difficulty: number
  likeCount: number
  views: number
  readFlag: 0 | 1
  answer: string
  collectFlag: 0 | 1
  likeFlag: 0 | 1
  stage: Array<string>
}

//接收参数的实体
export interface ParamsType {
  id: number
}

export interface IBodyParms {
  id: string,
  type: number,
  optType: number
}


@Entry
@Component
export struct QuestionDetailPage {
  @State questionId: string = ''
  @State
  question: QuestionDetail = {} as QuestionDetail
  @StorageProp('topHeight') topHeight: number = 0
  dialog = new CustomDialogController({
    builder: HdLoadingDialog({ message: '加载中...' }),
    customStyle: true
  })

  aboutToAppear(): void {
    const params = router.getParams() as ParamsType
    this.loadData(params.id.toString())
  }

  async loadData(id: string) {

    this.dialog.open()
    const res = await request<QuestionDetail>({ url: 'hm/question/' + id })
    this.questionId = id
    this.question = res.data.data
    this.dialog.close()

    //   1. 记录开始时间
    trackService.start(id)
  }

  async aboutToDisappear() {
    // 2. 记录结束时间
    trackService.end()
  }

  // 题目所属标签
  @Builder
  tagBuilder(text: string, color: string = '#41B883') {
    Text(text)
      .fontSize(12)
      .padding(5)
      .backgroundColor($r('app.color.ih_bg_color'))
      .borderRadius(2)
      .fontColor(color)
      .margin({ right: 5 })
  }

  onToggle(xxx: 'pre' | 'next') {
    const idList = AppStorage.get('idList') as string[]
    const selfIndex = idList.findIndex((item) => {
      return item === this.questionId.toString()
    })

    if (xxx === 'pre' && selfIndex === 0) {
      promptAction.showToast({ message: '没有上一题了' })
      return
    }

    if (xxx === 'next' && selfIndex === idList.length - 1) {
      promptAction.showToast({ message: '没有下一题了' })
      return
    }

    let id = xxx === 'pre' ? idList[selfIndex - 1] : idList[selfIndex + 1]
    this.loadData(id)

  }

  // 上一题，下一题
  @Builder
  toggleBuilder() {
    Row() {
      Image($r("app.media.prev_black")).width((80))
        .onClick(() => {
          this.onToggle('pre')
        })
      Image($r("app.media.next_black")).width((80))
        .onClick(() => {
          this.onToggle('next')
        })
    }.width('100%').justifyContent(FlexAlign.SpaceAround)
  }

  build() {
    Navigation() {
      Flex({ direction: FlexDirection.Column }) {
        Column() {
          Column() {
            Row() {
              Text(this.question.stem).width('100%')
            }

            Row() {
              if (this.question.id) {
                HdTag({ difficulty: this.question.difficulty })
                ForEach(this.question.stage, (stage: string) => {
                  this.tagBuilder(stage)
                })
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End }) {
                  Image($r('app.media.icon_point')).width(24).bindMenu([
                    {
                      value: this.question.collectFlag === 1 ? '取消收藏' : '收藏',
                      action: async () => {
                        await request<null, IBodyParms>({
                          // 1. 判断调用哪个接口
                          url: this.question.collectFlag === 1 ? 'hm/question/unOpt' : 'hm/question/opt',
                          method: 'post',
                          data: {
                            id: this.questionId,
                            type: 0, // App项目写死0
                            optType: 2 // 点赞传1, 收藏传2
                          }
                        })


                        await this.loadData(this.questionId)
                        promptAction.showToast({ message: this.question.collectFlag === 1 ? '取消成功' : '收藏成功' })
                      }
                    },
                    {
                      value: this.question.likeFlag === 1 ? '取消点赞' : '点赞',
                      action: () => {
                        // 点赞和取消点赞业务逻辑代码
                        // this.opt(1,0)
                      }
                    }
                  ])
                }
                .layoutWeight(1)
              }
            }
            .height((40))
            .width('100%')
            .padding({ top: (15) })
          }.padding((15))
        }

        Divider()
          .strokeWidth((8))
          .color($r('app.color.ih_bg_color'))

        Column() {
          Scroll() {
            // RichText(this.question.answer)
            RichText(`
                      <html>
                      <body>
                        <div style="font-size:54px">${this.question.answer}</div>
                      <body>
                      </html>
                      `)
          }
          .padding((15))
          .layoutWeight(1)
          .onScroll((xOffset: number, yOffset: number) => {
            console.log('mylog->xOffset', xOffset + ' ' + yOffset)
          })
          .onScrollStop(() => {
            console.log('mylog->Scroll Stop')
          })
        }.layoutWeight(1)

      }
    }
    .padding({ top: this.topHeight })
    .title('题目详情')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .toolbarConfiguration(this.toggleBuilder())
  }
}