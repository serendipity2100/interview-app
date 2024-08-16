import { HdLoadingDialog } from '../../common/components/HdLoading';
import { request } from '../../common/utils/request';
import { QuestionItem, QuestionItemComp } from './QuestionItemComp'

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

  async onFresh() {
    const res = await request<iListData>({
      url: 'hm/question/list',
      params: {
        questionBankType: 10,
        type: this.typeId
      }
    });

    this.questionList = res.data.data.rows;

  }

  async onLoadMore() {
    if (this.isRequesting === true) {
      return
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
        this.onLoadMore()
      })
    }
    .onRefreshing(async () => {
      await this.onFresh()
      this.isRefreshing = false
    })

  }
}