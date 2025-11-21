import { router } from '@kit.ArkUI';

@Entry
@Component
struct FailedResultPage {
  @State imageUri: string = ''
  @State errorMessage: string = '无法识别该植物'

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>
    this.imageUri = params.imageUri || ''
    this.errorMessage = params.errorMessage || '无法识别该植物'
  }

  build() {
    Column({ space: 20 }) {
      // Header
      Row() {
        Button('返回')
          .onClick(() => router.back())
        Text('识别失败')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)

      // Failed Image
      if (this.imageUri) {
        Image(this.imageUri)
          .width('80%')
          .height(200)
          .borderRadius(12)
          .objectFit(ImageFit.Cover)
      }

      // Error Message
      Column({ space: 12 }) {
        Image($r('app.media.startIcon'))
          .width(60)
          .height(60)
          .opacity(0.4)

        Text(this.errorMessage)
          .fontSize(16)
          .fontColor('#999')

        Text('建议:')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })

        Text('• 确保照片清晰\n• 拍摄植物的花朵或叶子\n• 光线充足\n• 尽量拍摄完整的植物特征')
          .fontSize(13)
          .fontColor('#666')
          .lineHeight(22)
      }
      .justifyContent(FlexAlign.Center)
      .layoutWeight(1)
      .margin({ bottom: 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}