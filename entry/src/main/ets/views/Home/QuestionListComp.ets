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

  async aboutToAppear() {
    const res = await request<iListData>({
      url: 'hm/question/list',
      params: {
        questionBankType: 10,
        type: this.typeId
      }
    })

    this.questionList = res.data.data.rows

  }

  build() {
    Column() {
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
  }
}