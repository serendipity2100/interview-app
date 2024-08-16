import { request } from '../../common/utils/request';
import { QuestionItem, QuestionItemComp } from './QuestionItemComp'

/**
 * 报文数据
 */
export interface iListData {
  /**
   * 总页数
   */
  pageTotal: number;

  /**
   * 数据集合
   */
  rows: QuestionItem[];

  /**
   * 总数
   */
  total: number;
}

// 3. cv定义响应data的类型


@Component
export struct QuestionListComp {
  // 2. 接收id
  @Prop typeId: number
  // 2. 定义状态变量
  @State questionList: QuestionItem[] = []

  async aboutToAppear() {
    // 4. 在List组件中发请求
    const res = await request<iListData>({
      url: 'hm/question/list', params: {
        questionBankType: 10,
        type: this.typeId
      }
    })

    // 4. 保存数据 列表渲染
    this.questionList = res.data.data.rows

  }

  build() {
    Column() {
      List() {
        // 5. 列表渲染
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
  }
}