import webview from '@ohos.web.webview';

@Component
export struct WebImg {

  @Prop imageUrl: string = ''
  @Prop imgWidth: string | number = '100%'
  @Prop imgHeight: number = 200
  private webController: webview.WebviewController = new webview.WebviewController()

  // aboutToDisappear() {
  //     this.webController.clearHistory()
  // }

  build() {
    Web({
      src: `data:text/html,
        <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              * { margin: 0; padding: 0; }
              body {
                width: 100vw;
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                background: white;
              }
              img {
                max-width: 100%;
                max-height: 100%;
                object-fit: contain;
              }
            </style>
          </head>
          <body>
            <img src="${this.imageUrl}"
                 onerror="document.body.innerHTML='加载失败'" />
          </body>
        </html>`,
      controller: this.webController
    })
      .width(this.imgWidth)
      .height(this.imgHeight)
      .domStorageAccess(true)
      .backgroundColor('#FFFFFF')
  }
}