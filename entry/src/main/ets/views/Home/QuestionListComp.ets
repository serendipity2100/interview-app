import { request } from '../../common/utils/request';
import { QuestionItem, QuestionItemComp } from './QuestionItemComp'
import { promptAction } from '@kit.ArkUI';

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
  // 1. 定义变量, 表示是否正在请求中
  isRequesting = false

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
    // 4. 判断如果正在请求, 不许再次发请求
    if (this.isRequesting === true) {
      return
    }

    // 2. 每次请求前, 标记正在请求
    this.isRequesting = true

    this.page++
    console.log('请求的页数 -----> ', this.page)
    const res = await request<iListData>({
      url: 'hm/question/list',
      params: {
        questionBankType: 10,
        type: this.typeId,
        page: this.page
      }
    });
    this.questionList.push(...res.data.data.rows);

    // 3. 每次请求后, 标记请求结束
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