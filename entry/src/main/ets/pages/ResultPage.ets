// Result Page - Dynamic Discovery Style with Nature-Inspired Design
import { router } from '@kit.ArkUI';
import { PlantInfo } from '../models/PlantInfo';
import { WebImg } from '../utils/WebImg';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct ResultPage {
  @State plantData: PlantInfo[] = []

  // Entrance animations
  @State headerOpacity: number = 0
  @State headerOffset: number = -20
  @State imageScale: number = 0.9
  @State imageOpacity: number = 0
  @State listOpacity: number = 0
  @State listOffset: number = 40

  // Discovery reveal - cards appear one by one
  @State revealedCards: number = 0

  // Floating decorations
  @State floatY1: number = 0
  @State floatY2: number = 0
  @State floatRotate: number = 0
  @State selectedImage: string = ''

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>
    this.plantData = JSON.parse(params.plantResults) as PlantInfo[]
    this.selectedImage = params.selectedImage || '';

    this.playEntranceAnimations()
    this.startFloatingAnimations()
    this.startCardDiscovery()
  }

  playEntranceAnimations() {
    // Header
    setTimeout(() => {
      animateTo({ duration: 500, curve: Curve.EaseOut }, () => {
        this.headerOpacity = 1
        this.headerOffset = 0
      })
    }, 100)

    // Main image - zoom in reveal
    setTimeout(() => {
      animateTo({ duration: 700, curve: Curve.EaseOut }, () => {
        this.imageScale = 1
        this.imageOpacity = 1
      })
    }, 300)

    // List container
    setTimeout(() => {
      animateTo({ duration: 600, curve: Curve.EaseOut }, () => {
        this.listOpacity = 1
        this.listOffset = 0
      })
    }, 500)
  }

  startCardDiscovery() {
    // Reveal cards one by one with delay
    const revealNext = () => {
      if (this.revealedCards < this.plantData.length) {
        animateTo({ duration: 400, curve: Curve.EaseOut }, () => {
          this.revealedCards++
        })
        setTimeout(revealNext, 150)
      }
    }
    setTimeout(revealNext, 800)
  }

  startFloatingAnimations() {
    setInterval(() => {
      animateTo({ duration: 3000, curve: Curve.Smooth }, () => {
        this.floatY1 = this.floatY1 === 0 ? 15 : 0
        this.floatRotate = this.floatRotate === 0 ? 10 : 0
      })
    }, 3000)

    setTimeout(() => {
      setInterval(() => {
        animateTo({ duration: 2500, curve: Curve.Smooth }, () => {
          this.floatY2 = this.floatY2 === 0 ? -12 : 0
        })
      }, 2500)
    }, 1000)
  }

  build() {
    Stack() {
      // Background gradient
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 175,
          colors: [
            [0xFFFFFF, 0.0],
            [0xFCFDF9, 0.4],
            [0xF4F9F0, 0.7],
            [0xE8F5E9, 1.0]
          ]
        })

      // Floating decorations
      this.FloatingDecorations()

      // Main content
      Column() {
        this.HeaderSection()
        this.ImageSection()
        this.ResultListSection()
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  FloatingDecorations() {
    Stack() {
      Text('🌿')
        .fontSize(36)
        .opacity(0.08)
        .position({ x: '85%', y: '15%' })
        .translate({ y: this.floatY1 })
        .rotate({ angle: this.floatRotate })

      Text('🍃')
        .fontSize(28)
        .opacity(0.06)
        .position({ x: '5%', y: '45%' })
        .translate({ y: this.floatY2 })

      Text('🌸')
        .fontSize(24)
        .opacity(0.05)
        .position({ x: '90%', y: '70%' })
        .translate({ y: this.floatY1 })

      Circle()
        .width(180)
        .height(180)
        .fill(0x81C784)
        .opacity(0.03)
        .position({ x: '-10%', y: '-5%' })

      Circle()
        .width(120)
        .height(120)
        .fill(0xA5D6A7)
        .opacity(0.04)
        .position({ x: '80%', y: '85%' })
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.None)
  }

  @Builder
  HeaderSection() {
    Row() {
      // Back button
      Row() {
        Text('←')
          .fontSize(22)
          .fontColor('#2E5435')
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(165, 214, 167, 0.3)')
      .onClick(() => router.back())

      // Title with discovery icon
      Row({ space: 8 }) {
        Text('🔍')
          .fontSize(20)
        Text('识别结果')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1C1E')
      }

      // Wiki button
      Row() {
        Text('📖')
          .fontSize(18)
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(165, 214, 167, 0.3)')
      .onClick(() => {
        router.pushUrl({
          url: 'pages/WikiPage',
          params: { infoCode: this.plantData[0].InfoCode }
        })
      })
    }
    .width('100%')
    .height(56)
    .padding({ left: 8, right: 8 })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .opacity(this.headerOpacity)
    .translate({ y: this.headerOffset })
  }

  @Builder
  ImageSection() {
    Stack() {
      // Decorative frame
      Column()
        .width('92%')
        .height(235)
        .borderRadius(20)
        .border({ width: 2, color: '#C8E6C9' })
        .shadow({ radius: 12, color: 'rgba(76, 175, 80, 0.15)', offsetY: 4 })

      // Main image
      Column() {
        WebImg({
          imageUrl: this.plantData[0]?.ImageUrl || '',
          imgWidth: '100%',
          imgHeight: 220
        })
      }
      .width('88%')
      .height(220)
      .borderRadius(16)
      .clip(true)
      .backgroundColor('#F1F8E9')
    }
    .width('100%')
    .padding({ top: 8, bottom: 16 })
    .alignContent(Alignment.Center)
    .scale({ x: this.imageScale, y: this.imageScale })
    .opacity(this.imageOpacity)
  }

  @Builder
  ResultListSection() {
    Column() {
      // Discovery hint
      Row({ space: 6 }) {
        Text('🌱')
          .fontSize(14)
        Text(`发现 ${this.plantData.length} 种可能的植物`)
          .fontSize(13)
          .fontColor('#5F6368')
      }
      .width('100%')
      .padding({ left: 20, bottom: 12 })

      List({ space: 14 }) {
        ForEach(this.plantData, (plant: PlantInfo, index: number) => {
          ListItem() {
            this.PlantCard(plant, index)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16 })
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .layoutWeight(1)
    .opacity(this.listOpacity)
    .translate({ y: this.listOffset })
  }

  @Builder
  PlantCard(plant: PlantInfo, index: number) {
    Column() {
      // Card with nature-inspired border
      Column({ space: 12 }) {
        // Top section: Image + Basic info
        Row({ space: 14 }) {
          // Plant thumbnail with frame
          Stack() {
            Column()
              .width(76)
              .height(76)
              .borderRadius(14)
              .border({ width: 2, color: '#C8E6C9' })

            Image(this.selectedImage)
              .width(68)
              .height(68)
              .borderRadius(10)
              .objectFit(ImageFit.Cover)
              .backgroundColor('#F1F8E9')
          }

          // Plant info
          Column({ space: 6 }) {
            // Name row
            Row({ space: 8 }) {
              Text(plant.Name)
                .fontSize(17)
                .fontWeight(FontWeight.Medium)
                .fontColor('#2E5435')
                .letterSpacing(0.3)

              // Match score badge
              Row() {
                Text(`${plant.Score}%`)
                  .fontSize(11)
                  .fontColor('#2E7D32')
                  .fontWeight(FontWeight.Medium)
              }
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
              .borderRadius(10)
              .backgroundColor('#E8F5E9')
            }

            // Latin name
            Text(plant.LatinName)
              .fontSize(12)
              .fontColor('#6B7B6E')
              .fontStyle(FontStyle.Italic)
              .letterSpacing(0.5)

            // Alias
            if (plant.AliasName) {
              Text(`别名: ${plant.AliasName}`)
                .fontSize(11)
                .fontColor('#8B9D8F')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }

        // Divider - organic leaf line
        Row() {
          Row().width(40).height(1).backgroundColor('#C8E6C9')
          Text('🌿').fontSize(12).opacity(0.5).margin({ left: 8, right: 8 })
          Row().layoutWeight(1).height(1).backgroundColor('#E8F5E9')
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        // Bottom section: Classification + Flower language
        Column({ space: 10 }) {
          // Family & Genus
          Row({ space: 20 }) {
            Row({ space: 4 }) {
              Text('科')
                .fontSize(11)
                .fontColor('#9AA09C')
              Text(plant.Family)
                .fontSize(12)
                .fontColor('#5F6368')
            }

            Row({ space: 4 }) {
              Text('属')
                .fontSize(11)
                .fontColor('#9AA09C')
              Text(plant.Genus)
                .fontSize(12)
                .fontColor('#5F6368')
            }
          }

          // Flower language - special styling
          if (plant.hyyy) {
            Row({ space: 8 }) {
              Text('🌸')
                .fontSize(14)
              Text(plant.hyyy)
                .fontSize(12)
                .fontColor('#D4776C')
                .fontStyle(FontStyle.Italic)
                .letterSpacing(0.3)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .layoutWeight(1)
            }
            .width('100%')
            .padding(10)
            .borderRadius(10)
            .backgroundColor('#FDF8F7')
            .border({ width: 1, color: 'rgba(212, 119, 108, 0.2)' })
          }
        }

        // Action hint
        Row() {
          Text('点击查看详情')
            .fontSize(11)
            .fontColor('#A5D6A7')
          Text(' →')
            .fontSize(12)
            .fontColor('#A5D6A7')
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
      }
      .width('100%')
      .padding(16)
      .borderRadius(20)
      .backgroundColor('#FAFDF8')
      .border({ width: 1.5, color: 'rgba(165, 214, 167, 0.5)' })
      .shadow({
        radius: 8,
        color: 'rgba(46, 84, 53, 0.08)',
        offsetY: 3
      })
    }
    // Discovery animation - cards reveal one by one
    .opacity(index < this.revealedCards ? 1 : 0)
    .translate({ y: index < this.revealedCards ? 0 : 30 })
    .scale({ x: index < this.revealedCards ? 1 : 0.95, y: index < this.revealedCards ? 1 : 0.95 })
    .animation({
      duration: 400,
      curve: Curve.EaseOut
    })
    // Press feedback
    .stateStyles({
      pressed: {
        .scale({ x: 0.98, y: 0.98 })
        .backgroundColor('#F5FAF3')
      },
      normal: {
        .scale({ x: 1, y: 1 })
      }
    })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/WikiPage',
        params: { infoCode: plant.InfoCode }
      })
    })
  }
}
