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

// 需求: 触底加载更多
// 1. 拼接数据到数组的后面
// 2. 监听触底


@Component
export struct QuestionListComp {
  @Prop typeId: number
  @State questionList: QuestionItem[] = []
  @State isRefreshing: boolean = false
  // 1. 定义变量page
  page = 0

  // 5. 不再需要AboutToAppear发请求
  // async aboutToAppear() {
  //   await this.onFresh();
  // }

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

    // 3.  page++  发请求,传参page
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

    // 4. 拼接数据
    this.questionList.push(...res.data.data.rows);
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
        // 2. 监听触底事件

        this.onLoadMore()
      })
    }
    .onRefreshing(async () => {
      await this.onFresh()
      this.isRefreshing = false
    })

  }
}