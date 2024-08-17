import { request } from '../../common/utils/request'
import { IQuestionType } from '../../models/CategoryModel'
import { FilterParams, QuestionFilterComp } from './QuestionFilterComp'
import { QuestionListComp } from './QuestionListComp'
import { promptAction } from '@kit.ArkUI'
import { IvSkeleton } from '../../common/components/IvSkeleton'

@Component
export struct HomeCategoryComp {
  @State
  questionTypeList: IQuestionType[] = []
  @State index: number = 0
  @State isShow: boolean = false
  @State filterParams: FilterParams = new FilterParams()
  @State isLoading: boolean = false

  aboutToAppear(): void {
    this.loadTypeData()
  }

  async loadTypeData() {
    this.isLoading = true
    const res = await request<IQuestionType[]>({ url: 'hm/question/type' })
    this.questionTypeList = res.data.data
    setTimeout(() => {
      this.isLoading = false
    }, 1000)
  }

  @Builder
  TabItemBuilder(q: IQuestionType, index: number) {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(q.name)
          .fontSize(15)
          .height(43)
          .fontColor(this.index === index ? Color.Black : Color.Gray)
        Text()
          .width(this.index === index ? 20 : 0)
          .height(2)
          .backgroundColor(Color.Black)
          .animation({ duration: this.index === index ? 300 : 0 })
      }
      .padding({ left: index === 0 ? 16 : 0, })

      if (q.displayNewestFlag === 1) {
        Image($r("app.media.ic_home_new"))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .margin({ left: 4 })
      }
    }
    .padding({ right: this.questionTypeList.length === index + 1 ? 54 : 16 })
  }

  @Builder
  renderFilter() {
    Column() {
      QuestionFilterComp({
        questionTypeList: this.questionTypeList,

        onSubmit: (params) => {
          promptAction.showToast({ message: JSON.stringify(params, null, 2) })
          this.index = params.index
          this.isShow = false
          this.filterParams = params

        },

        params: this.filterParams
      })
    }
  }

  build() {

    if (this.isLoading) {
      ForEach(Array.from({ length: 9 }), () => {
        Row({ space: 10 }) {
          IvSkeleton({ widthValue: 100, heightValue: 25 })
          IvSkeleton({ widthValue: 100, heightValue: 25 })
          IvSkeleton({ widthValue: 100, heightValue: 25 })
        }
        .margin({ top: 10, bottom: 20 })
      })
    } else {
      Stack({ alignContent: Alignment.TopEnd }) {
        Tabs({ index: this.index }) {
          ForEach(this.questionTypeList, (item: IQuestionType, index: number) => {
            TabContent() {

              QuestionListComp({
                typeId: item.id,
                params: this.filterParams,
                selfIndex: index

              })
            }.tabBar(this.TabItemBuilder(item, index))
          })
        }
        .height(450)
        .divider({
          strokeWidth: $r('app.float.common_border_width'),
          color: $r('app.color.common_gray_border')
        })
        .barMode(BarMode.Scrollable)
        .barHeight(44)
        .onChange((index) => {
          promptAction.showToast({ message: '你点的索引是' + index })
          this.index = index
          this.filterParams.index = index
        })

        Row() {
          // 过滤条件按钮
          Image($r('app.media.ic_home_filter'))
            .width(22)
            .height(44)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.isShow = true
            })
        }
        .width(54)
        .height(44)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)
        .bindSheet($$this.isShow, this.renderFilter(), {
          height: 400,
          showClose: false
        })
      }
    }

  }
}