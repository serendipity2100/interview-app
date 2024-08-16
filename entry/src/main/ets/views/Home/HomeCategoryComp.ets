import { request } from '../../common/utils/request'
import { IQuestionType } from '../../models/CategoryModel'
import { FilterParams, QuestionFilterComp } from './QuestionFilterComp'
import { QuestionListComp } from './QuestionListComp'
import { promptAction } from '@kit.ArkUI'

@Component
export struct HomeCategoryComp {
  @State
  questionTypeList: IQuestionType[] = []
  @State index: number = 0
  @State isShow: boolean = false
  @State filterParams: FilterParams = new FilterParams()

  aboutToAppear(): void {
    this.loadTypeData()
  }

  async loadTypeData() {
    const res = await request<IQuestionType[]>({ url: 'hm/question/type' })
    this.questionTypeList = res.data.data
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
          // 1. 更新params.index到this.index
          this.index = params.index
          this.isShow = false
        },

        params: this.filterParams
      })
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) { //设置堆叠位置为右上角
      Tabs({ index: this.index }) {
        ForEach(this.questionTypeList, (item: IQuestionType, index: number) => {
          TabContent() {
            QuestionListComp({ typeId: item.id })
          }.tabBar(this.TabItemBuilder(item, index))
        })
      }
      .height(450)
      .divider({
        strokeWidth: $r('app.float.common_border_width'),
        color: $r('app.color.common_gray_border')
      }) //设置tabbar下面的横线样式
      .barMode(BarMode.Scrollable) // 设置tabs可以滚动
      .barHeight(44)
      .onChange((index) => {
        promptAction.showToast({ message: '你点的索引是' + index })
        this.index = index
        //   3. 改变选中项时, 更新filterParams
        this.filterParams.index = index
      })

      Row() {
        // 过滤条件按钮
        Image($r('app.media.ic_home_filter'))
          .width(22)
          .height(44)
          .objectFit(ImageFit.Contain)// 设置图片按照容器大小填满
          .onClick(() => {
            this.isShow = true
          })
      }
      .width(54)
      .height(44)
      .justifyContent(FlexAlign.Center) // 图片居中对齐
      .backgroundColor(Color.White) // 设置背景色位白色，使过滤条件图标能遮盖住tabbar的文字
      .bindSheet($$this.isShow, this.renderFilter(), {
        height: 400,
        showClose: false
      })
    }
  }
}