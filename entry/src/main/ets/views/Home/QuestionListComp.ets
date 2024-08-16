import { QuestionItem, QuestionItemComp } from './QuestionItemComp'

@Component
export struct QuestionListComp {
  build() {
    Column() {
      List() {
        ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9], (item:number) => {
          ListItem(){
            QuestionItemComp({
              item: {
                id: '1',
                stem: '请总结一下Vue2中生命周期函数有哪些'+item,
                difficulty: 3,
                likeCount: 10,
                views: 20,
                readFlag: 1
              } as QuestionItem
            })
              .padding({left:10,right:10})
          }

        })
      }

    }
  }
}