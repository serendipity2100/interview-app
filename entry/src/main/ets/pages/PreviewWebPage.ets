import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct PreviewWebPage {
  controller: webview.WebviewController = new webview.WebviewController();

  build() {

    Navigation() {
      // Web({ src: $rawfile('index.html'), controller: this.controller })
      Web({ src: 'https://www.baidu.com/', controller: this.controller }) // 💥💥需要在module.json5文件中开启网络权限
    }
    .titleMode(NavigationTitleMode.Mini)
    .title('隐私政策')

  }
}