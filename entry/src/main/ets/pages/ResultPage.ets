import { router } from '@kit.ArkUI';
import { PlantInfo } from '../models/PlantInfo';
import { WebImg } from '../utils/WebImg';

@Entry
@Component
struct ResultPage {
  @State plantData: PlantInfo[] = []

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>
    this.plantData = JSON.parse(params.plantResults) as PlantInfo[]
  }

  build() {
    Column() {
      // Header
      Row() {
        Button('返回')
          .onClick(() => router.back())
        Button('查看百科')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/WikiPage',
              params: { infoCode: this.plantData[0].InfoCode }
            })
          })
        Text('识别结果')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)

      // Use API ImageUrl instead of local imageUri
      WebImg({
        imageUrl: this.plantData[0].ImageUrl,
        imgWidth: '100%',
        imgHeight: 250
      })

      // Results List
      List({ space: 12 }) {
        ForEach(this.plantData, (plant: PlantInfo) => {
          ListItem() {
            this.PlantCard(plant)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  PlantCard(plant: PlantInfo) {
    Column({ space: 8 }) {
      Row({ space: 12 }) {
        Image(plant.LocalUrl)
          .width(80)
          .height(80)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)

        Column({ space: 4 }) {
          Text(plant.Name)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          Text(plant.LatinName)
            .fontSize(12)
            .fontColor('#666')
            .fontStyle(FontStyle.Italic)
          Text(`匹配度: ${plant.Score}%`)
            .fontSize(12)
            .fontColor('#52C41A')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }

      if (plant.AliasName) {
        Text(`别名: ${plant.AliasName}`)
          .fontSize(13)
          .fontColor('#666')
      }

      Row({ space: 16 }) {
        Text(`科: ${plant.Family}`)
          .fontSize(13)
        Text(`属: ${plant.Genus}`)
          .fontSize(13)
          .fontColor('#999')
      }

      if (plant.hyyy) {
        Text(`花语: ${plant.hyyy}`)
          .fontSize(13)
          .fontColor('#FF6B6B')
          .padding(8)
          .backgroundColor('#FFF0F0')
          .borderRadius(6)
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFF')
    .borderRadius(12)
    .shadow({ radius: 4, color: '#1000', offsetY: 2 })
  }
}