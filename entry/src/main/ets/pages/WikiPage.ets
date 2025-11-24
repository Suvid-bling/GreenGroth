import { router } from '@kit.ArkUI';
import { PlantWikiInfo } from '../models/PlantWikiInfo';
import { PlantWikiStorage } from '../database/PlantWikiStorage';
import { common } from '@kit.AbilityKit';
import { WebImg } from '../utils/WebImg'

@Entry
@Component
struct WikiPage {
  @State wikiInfo: PlantWikiInfo | null = null
  @State infoCode: string = ''
  @State isLoading: boolean = true

  async aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.infoCode = params.infoCode || '';

    try {
      const context = getContext(this) as common.UIAbilityContext;
      await PlantWikiStorage.init(context);
      this.wikiInfo = await PlantWikiStorage.getWiki(this.infoCode);
      console.info(`Wiki loaded for: ${this.infoCode}`);
    } catch (err) {
      console.error('Failed to load wiki:', JSON.stringify(err));
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // Header
      Row() {
        Button('返回')
          .onClick(() => router.back())
        Text('植物百科')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.isLoading) {
        LoadingProgress()
          .width(50)
          .height(50)
          .margin({ top: 100 })
      } else if (!this.wikiInfo) {
        Column() {
          Text('暂无百科信息')
            .fontSize(16)
            .fontColor('#999')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column({ space: 16 }) {
            // Image Gallery
            // Image Gallery
            if (this.wikiInfo.images.length > 0) {
              Swiper() {
                ForEach(this.wikiInfo.images, (imgUrl: string) => {
                  WebImg({
                    imageUrl: imgUrl,
                    imgWidth: '100%',
                    imgHeight: 250
                  })
                })
              }
              .height(250)
              .autoPlay(true)
              .indicator(true)
              .borderRadius(8)
            }

            // Basic Info
            Column({ space: 8 }) {
              Text(this.wikiInfo.nameStd)
                .fontSize(24)
                .fontWeight(FontWeight.Bold)

              Text(this.wikiInfo.nameLt)
                .fontSize(14)
                .fontColor('#666')
                .fontStyle(FontStyle.Italic)

              Row({ space: 16 }) {
                Text(`科: ${this.wikiInfo.familyCn}`)
                  .fontSize(14)
                Text(`属: ${this.wikiInfo.genusCn}`)
                  .fontSize(14)
              }

              if (this.wikiInfo.alias) {
                Text(`别名: ${this.wikiInfo.alias}`)
                  .fontSize(14)
                  .fontColor('#666')
              }

              Text(this.wikiInfo.description)
                .fontSize(14)
                .lineHeight(22)
                .margin({ top: 8 })
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFF')
            .borderRadius(12)

            // Detailed Info Sections
            this.InfoSection('花语寓意', this.wikiInfo.info.hyyy)
            this.InfoSection('花开时节', this.wikiInfo.info.hksj)
            this.InfoSection('表型特征', this.wikiInfo.info.bxtz)
            this.InfoSection('分布地区', this.wikiInfo.info.fbdq)
            this.InfoSection('养护技术', this.wikiInfo.info.yhjs)
            this.InfoSection('价值功用', this.wikiInfo.info.jzgy)
            this.InfoSection('名称来历', this.wikiInfo.info.mcll)
            this.InfoSection('相关诗词', this.wikiInfo.info.xgsc)
          }
          .padding(16)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  InfoSection(title: string, content: string) {
    if (content) {
      Column({ space: 8 }) {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)

        Text(content)
          .fontSize(14)
          .lineHeight(22)
          .fontColor('#333')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFF')
      .borderRadius(12)
      .alignItems(HorizontalAlign.Start)
    }
  }
}
