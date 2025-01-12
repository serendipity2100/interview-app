import { HdLoadingDialog } from '../../common/components/HdLoading';
import { request } from '../../common/utils/request';
import { QuestionItem, QuestionItemComp } from './QuestionItemComp';
import { router } from '@kit.ArkUI';
import { FilterParams } from './QuestionFilterComp';

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
  // 1. 设置初始值, 优化外部父组件, 不需要传值
  @Prop typeId: number = 0
  @Prop selfIndex: number = 0
  @Prop @Watch('onSort') params: FilterParams = new FilterParams()
  keyword = ''

  onSort() {
    this.onLoadMore(false)
  }

  async onLoadMore(isLoadMore: boolean) {

    if (this.selfIndex !== this.params.index) {
      return
    }

    if (isLoadMore === true) {
      this.isRequesting = true
      this.page++
    } else {
      this.page = 1
    }

    this.dialogController.open()

    const res = await request<iListData>({
      url: 'hm/question/list',
      params: {
        questionBankType: 10,
        type: this.typeId,
        page: this.page,
        sort: this.params.sort, // 0
        keyword: this.keyword
      }
    });

    this.dialogController.close()

    if (isLoadMore === true) {
      // 触底加载更多
      this.questionList.push(...res.data.data.rows);
      this.isRequesting = false

    } else {
      // 下拉刷新
      this.questionList = res.data.data.rows
      // 关闭下拉刷新状态
      this.isRefreshing = false
    }

    const idList = this.questionList.map(item => item.id)
    AppStorage.setOrCreate('idList', idList)

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
          .onClick(() => {
            router.pushUrl({
              url: 'pages/QuestionDetailPage',
              params: {
                id: item.id
              }
            })
          })

        })
      }
      .onReachEnd(() => {

        // 2.
        if (this.questionList.length > 0 && this.questionList.length < 10) {
          return
        }

        console.log('触底了 -----> ',)
        if (this.isRequesting === false) {
          this.onLoadMore(true)
        }
      })
    }
    .onRefreshing(async () => {
      this.onLoadMore(false)
    })

  }
}