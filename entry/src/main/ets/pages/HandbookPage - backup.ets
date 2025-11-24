import { router } from '@kit.ArkUI';
import { PlantStorage } from '../database/PlantDatabase';
import { PlantInfo } from '../models/PlantInfo';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct HandbookPage {
  @State plants: PlantInfo[] = []
  private scroller: Scroller = new Scroller()

  async aboutToAppear() {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      await PlantStorage.init(context);
      this.plants = await PlantStorage.getAllPlants();
      console.info(`📚 Loaded ${this.plants.length} plants`);
    } catch (err) {
      console.error('Failed to load plants:', JSON.stringify(err));
    }
  }

  build() {
    Column() {
      // Header
      Row() {
        Button('返回')
          .onClick(() => router.back())
        Text('植物图鉴')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.plants.length === 0) {
        // Empty state
        Column() {
          Image($r('app.media.startIcon'))
            .width(80)
            .height(80)
            .opacity(0.3)
          Text('还没有收藏植物')
            .fontSize(16)
            .fontColor('#999')
            .margin({ top: 20 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        // Grid: 3 columns with lazy loading
        Grid(this.scroller) {
          ForEach(this.plants, (plant: PlantInfo) => {
            GridItem() {
              this.PlantCard(plant)
            }
          }, (plant: PlantInfo) => plant.InfoCode)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsGap(16)
        .columnsGap(16)
        .padding(16)
        .width('100%')
        .layoutWeight(1)
        .cachedCount(3)  // Only cache 1 row (3 items) ahead/behind
        .enableScrollInteraction(true)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  PlantCard(plant: PlantInfo) {
    Column({ space: 8 }) {
      // Square image with memory optimization
      Image(plant.LocalUrl || plant.ImageUrl)
        .alt($r('app.media.startIcon'))
        .width('100%')
        .aspectRatio(1)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
        .backgroundColor('#E0E0E0')
        .interpolation(ImageInterpolation.Low)  // Lower quality = less memory
        .renderMode(ImageRenderMode.Original)
        .syncLoad(false)  // Critical: async loading
        .sourceSize({ width: 200, height: 200 })  // Decode at smaller size
        .onError(() => {
          console.error(`Failed to load: ${plant.Name}`);
        })

      // Name
      Text(plant.Name)
        .fontSize(14)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .width('100%')
    }
    .width('100%')
    .onClick(() => {
      router.pushUrl({
        url: 'pages/ResultPage',
        params: { plantResults: JSON.stringify([plant]) }
      }).catch((err: Error) => {
        console.error('Navigation error:', err.message);
      });
    })
  }
}
