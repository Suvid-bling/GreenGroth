import { router } from '@kit.ArkUI';
import { picker } from '@kit.CoreFileKit';
import { cameraPicker } from '@kit.CameraKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  build() {
    Column({ space: 30 }) {
      // Logo/Title
      Column({ space: 12 }) {
        Image($r('app.media.startIcon'))
          .width(120)
          .height(120)

        Text('植物识别')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1677FF')
      }
      .margin({ top: 100 })

      // Action Buttons
      Column({ space: 16 }) {
        Row({ space: 12 }) {
          Button('拍照')
            .width('40%')
            .height(60)
            .fontSize(18)
            .backgroundColor('#1677FF')
            .onClick(() => this.takePhoto())

          Button('相册')
            .width('40%')
            .height(60)
            .fontSize(18)
            .backgroundColor('#52C41A')
            .onClick(() => this.selectImage())
        }
        .width('85%')
        .justifyContent(FlexAlign.SpaceEvenly)

        Button('我的图鉴')
          .width('85%')
          .height(60)
          .fontSize(18)
          .backgroundColor('#FF9500')
          .onClick(() => {
            router.pushUrl({ url: 'pages/HandbookPage' })
          })
      }
      .margin({ top: 60 })

      Text('拍照识别植物，了解植物知识')
        .fontSize(14)
        .fontColor('#999')
        .margin({ top: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .justifyContent(FlexAlign.Center)
  }

  async selectImage() {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions()
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
      photoSelectOptions.maxSelectNumber = 1

      const photoViewPicker = new picker.PhotoViewPicker()
      const result = await photoViewPicker.select(photoSelectOptions)

      if (result && result.photoUris.length > 0) {
        await router.pushUrl({
          url: 'pages/RecognizePage',
          params: { selectedImage: result.photoUris[0] }
        })
      }
    } catch (err) {
      console.error('选择图片失败:', JSON.stringify(err))
    }
  }

  async takePhoto() {
    try {
      const pickerResult: cameraPicker.PickerResult =
        await cameraPicker.pick(
          this.context,
          [cameraPicker.PickerMediaType.PHOTO],
          { cameraPosition: 1 }
        );

      if (pickerResult && pickerResult.resultUri) {
        await router.pushUrl({
          url: 'pages/RecognizePage',
          params: { selectedImage: pickerResult.resultUri }
        })
      }
    } catch (err) {
      console.error('拍照失败:', JSON.stringify(err));
    }
  }
}
