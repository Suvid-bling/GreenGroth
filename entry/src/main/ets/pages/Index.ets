import { picker } from '@kit.CoreFileKit';
import { ImageUtils } from '../utils/ImageUtils'
import {PlantApiService} from '../services/PlantApiService'
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { PlantSave } from '../utils/PlantSave';
import { common } from '@kit.AbilityKit';
import { camera, cameraPicker } from '@kit.CameraKit';


@Entry
@Component
struct Index {
  @State selectedImage: string = ''
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
  private xComponentController: XComponentController = new XComponentController()
  private surfaceId: string = ''


  build() {
    Column({ space: 20 }) {
      // Header
      Text('植物识别')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 60 })

      // Image Preview Area
      if (this.selectedImage) {
        Image(this.selectedImage)
          .width('80%')
          .height(300)
          .borderRadius(12)
          .objectFit(ImageFit.Contain)
      } else {
        Column() {
          Image($r('app.media.startIcon'))
            .width(80)
            .height(80)
            .opacity(0.6)
          Text('拍照或选择植物照片')
            .fontSize(14)
            .fontColor('#999')
            .margin({ top: 12 })
        }
        .width('80%')
        .height(300)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F5F5F5')
        .borderRadius(12)
      }

      // Action Buttons
      Column({ space: 12 }) {
        Row({ space: 12 }) {
          Button('拍照')
            .width('38%')
            .height(50)
            .fontSize(16)
            .onClick(() => this.takePhoto())

          Button('相册')
            .width('38%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#52C41A')
            .onClick(() => this.selectImage())
        }
        .width('80%')
        .justifyContent(FlexAlign.SpaceBetween)

        Button('开始识别')
          .width('80%')
          .height(50)
          .fontSize(16)
          .enabled(this.selectedImage !== '')
          .backgroundColor(this.selectedImage ? '#1677FF' : '#CCC')
          .onClick(() => this.recognizePlant())

        Button('图鉴')
          .onClick(() => {
            router.pushUrl({ url: 'pages/HandbookPage' })
          })
      }
      .margin({ top: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  async selectImage() {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions()
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
      photoSelectOptions.maxSelectNumber = 1

      const photoViewPicker = new picker.PhotoViewPicker()
      const result = await photoViewPicker.select(photoSelectOptions)

      if (result && result.photoUris.length > 0) {
        this.selectedImage = result.photoUris[0]
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
          { cameraPosition: 1 }  // 1 = back camera, 2 = front camera
        );

      if (pickerResult && pickerResult.resultUri) {
        this.selectedImage = pickerResult.resultUri;
        console.info('📷 Photo captured:', this.selectedImage);
      }
    } catch (err) {
      console.error('拍照失败:', JSON.stringify(err));
    }
  }

  async recognizePlant() {
    if (!this.selectedImage) return

    try {
      const base64Image = await ImageUtils.processImageToBase64(this.selectedImage)
      const result = await PlantApiService.recognizePlant(base64Image)

      // Process: check → save image → save to storage
      await PlantSave.processPlant(
        result,
        this.selectedImage,
        this.context
      )
      console.info('✅ Plant processed')

      await router.pushUrl({
        url: 'pages/ResultPage',
        params: {
          plantResults: JSON.stringify([result])
        }
      })


    } catch (err) {
      console.error('识别失败:', err)
      await router.pushUrl({
        url: 'pages/FailedResultPage',
        params: {
          imageUri: this.selectedImage,
          errorMessage: err.message || '识别失败，请重试'
        }
      })
    }
  }
}