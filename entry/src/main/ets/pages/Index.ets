import { router } from '@kit.ArkUI';
import { picker } from '@kit.CoreFileKit';
import { cameraPicker } from '@kit.CameraKit';
import { common } from '@kit.AbilityKit';
import { IndexLayout } from '../../layout/pages/IndexLayout';

@Entry
@Component
struct Index {
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  build() {
    Column() {
      IndexLayout({
        onCameraClick: (): Promise<void> => this.takePhoto(),
        onGalleryClick: (): Promise<void> => this.selectImage(),
        onHandbookClick: (): void => this.goToHandbook()
      })
    }
    .width('100%')
    .height('100%')
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

  goToHandbook() {
    router.pushUrl({ url: 'pages/HandbookPage' })
  }
}
