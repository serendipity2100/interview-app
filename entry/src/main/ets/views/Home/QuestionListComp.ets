import { HdLoadingDialog } from '../../common/components/HdLoading';
import { request } from '../../common/utils/request';
import { QuestionItem, QuestionItemComp } from './QuestionItemComp'
import { promptAction, router } from '@kit.ArkUI';

/** 试题列表响应数据类型 */
export interface iListData {
  /** 总页数 */
  pageTotal: number;

  /** 数据集合 */
  rows: QuestionItem[];

  /** 总数 */
  total: number;
}


@Component
export struct QuestionListComp {
  @Prop typeId: number
  @State questionList: QuestionItem[] = []
  @State isRefreshing: boolean = false
  page = 0
  isRequesting = false
  dialogController = new CustomDialogController({
    builder: HdLoadingDialog({
      message: '加载中...'
    }),
    customStyle: true
  })

  // 需求: 优化代码- 合并下拉刷新和触底加载更多
  // async onFresh() {
  //   const res = await request<iListData>({
  //     url: 'hm/question/list',
  //     params: {
  //       questionBankType: 10,
  //       type: this.typeId
  //     }
  //   });
  //
  //   this.questionList = res.data.data.rows;
  //
  // }

  async onLoadMore(isLoadMore: boolean) {

    if (isLoadMore === true) {
      //   加载更多
      promptAction.showToast({ message: '触底加载更多' })
    } else {
      //   下拉刷新
      promptAction.showToast({ message: '下拉刷新' })
    }

    this.isRequesting = true

    this.page++
    this.dialogController.open()
    const res = await request<iListData>({
      url: 'hm/question/list',
      params: {
        questionBankType: 10,
        type: this.typeId,
        page: this.page
      }
    });
    this.dialogController.close()
    this.questionList.push(...res.data.data.rows);

    this.isRequesting = false
  }

  build() {

    Refresh({ refreshing: $$this.isRefreshing }) {
      List() {
        ForEach(this.questionList, (item: QuestionItem) => {
          ListItem() {
            QuestionItemComp({
              item: item
            })
              .padding({ left: 10, right: 10 })
          }

        })
      }
      .onReachEnd(() => {
        if (this.isRequesting === false) {
          this.onLoadMore(true)
        }
      })
    }
    .onRefreshing(async () => {
      this.onLoadMore(false)
      router.pushUrl({ url: '/pages/ClockPage' })
    })

  }
}