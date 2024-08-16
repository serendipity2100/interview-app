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

  async aboutToAppear() {
    await this.onFresh();

  }

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

  build() {
    // 1. 使用Refresh包住所有的代码
    // 2. 定义一个状态变量, 做双向
    // 3. 监听下拉刷新事件
    // 4. 重新发请求
    // 5. 关闭下拉刷新的开关变量
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
    }
    .onRefreshing(async () => {
      await this.onFresh()
      this.isRefreshing = false
    })

  }
}