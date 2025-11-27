// RecognizePage - Nature-Inspired Design with Dynamic Effects
import { ImageUtils } from '../utils/ImageUtils'
import { PlantApiService } from '../services/PlantApiService'
import { router } from '@kit.ArkUI';
import { PlantSave } from '../utils/PlantSave';
import { common } from '@kit.AbilityKit';


@Entry
@Component
struct RecognizePage {
  @State selectedImage: string = ''
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  // Animation states
  @State headerOpacity: number = 0
  @State headerOffset: number = -20
  @State imageOpacity: number = 0
  @State imageScale: number = 0.92
  @State buttonOpacity: number = 0
  @State buttonOffset: number = 25

  // Floating decorations
  @State floatY1: number = 0
  @State floatY2: number = 0
  @State floatRotate: number = 0

  // Empty state animation
  @State emptyIconFloat: number = 0

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.selectedImage = params.selectedImage || '';

    this.playEntranceAnimations()
    this.startFloatingAnimations()
  }

  playEntranceAnimations() {
    setTimeout(() => {
      animateTo({ duration: 500, curve: Curve.EaseOut }, () => {
        this.headerOpacity = 1
        this.headerOffset = 0
      })
    }, 100)

    setTimeout(() => {
      animateTo({ duration: 600, curve: Curve.EaseOut }, () => {
        this.imageOpacity = 1
        this.imageScale = 1
      })
    }, 250)

    setTimeout(() => {
      animateTo({ duration: 500, curve: Curve.EaseOut }, () => {
        this.buttonOpacity = 1
        this.buttonOffset = 0
      })
    }, 450)
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
          this.emptyIconFloat = this.emptyIconFloat === 0 ? -8 : 0
        })
      }, 2500)
    }, 800)
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
            [0xFCFDF9, 0.35],
            [0xF4F9F0, 0.65],
            [0xE8F5E9, 1.0]
          ]
        })

      // Floating decorations
      this.FloatingDecorations()

      // Main content
      Column() {
        this.HeaderSection()

        Column({ space: 24 }) {
          this.ImagePreviewSection()
          this.ActionSection()
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding({ bottom: 60 })
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
        .position({ x: '85%', y: '10%' })
        .translate({ y: this.floatY1 })
        .rotate({ angle: this.floatRotate })

      Text('🍃')
        .fontSize(28)
        .opacity(0.06)
        .position({ x: '5%', y: '30%' })
        .translate({ y: this.floatY2 })

      Text('🌱')
        .fontSize(24)
        .opacity(0.05)
        .position({ x: '88%', y: '65%' })
        .translate({ y: this.floatY1 })

      Text('🌸')
        .fontSize(22)
        .opacity(0.04)
        .position({ x: '8%', y: '80%' })
        .translate({ y: this.floatY2 })

      Circle()
        .width(180)
        .height(180)
        .fill(0x81C784)
        .opacity(0.035)
        .position({ x: '-10%', y: '-5%' })

      Circle()
        .width(120)
        .height(120)
        .fill(0xA5D6A7)
        .opacity(0.04)
        .position({ x: '80%', y: '88%' })
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.None)
  }

  @Builder
  HeaderSection() {
    Row() {
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
      .stateStyles({
        pressed: { .backgroundColor('rgba(165, 214, 167, 0.5)') },
        normal: { .backgroundColor('rgba(165, 214, 167, 0.3)') }
      })
      .onClick(() => router.back())

      Row({ space: 8 }) {
        Text('🔬')
          .fontSize(20)
        Text('植物识别')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1C1E')
      }

      Column().width(44)
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
  ImagePreviewSection() {
    Stack() {
      // Outer decorative frame
      Column()
        .width('88%')
        .height(310)
        .borderRadius(24)
        .border({ width: 2, color: '#C8E6C9' })
        .shadow({ radius: 16, color: 'rgba(76, 175, 80, 0.12)', offsetY: 6 })

      if (this.selectedImage) {
        // Image preview
        Image(this.selectedImage)
          .width('84%')
          .height(295)
          .borderRadius(20)
          .objectFit(ImageFit.Cover)
      } else {
        // Empty state
        Column({ space: 14 }) {
          Stack() {
            Circle()
              .width(90)
              .height(90)
              .fill(0x81C784)
              .opacity(0.1)

            Text('🌿')
              .fontSize(44)
              .translate({ y: this.emptyIconFloat })
          }

          Text('等待识别图片')
            .fontSize(16)
            .fontColor('#2E5435')
            .fontWeight(FontWeight.Medium)

          Text('拍摄或选择一张植物照片')
            .fontSize(13)
            .fontColor('#6B7B6E')
        }
        .width('84%')
        .height(295)
        .borderRadius(20)
        .backgroundColor('#FAFDF8')
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .alignContent(Alignment.Center)
    .opacity(this.imageOpacity)
    .scale({ x: this.imageScale, y: this.imageScale })
  }

  @Builder
  ActionSection() {
    Column({ space: 16 }) {
      // Recognize button
      Button() {
        Row({ space: 10 }) {
          Text('🔍')
            .fontSize(20)
          Text('开始识别')
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        }
      }
      .width('75%')
      .height(54)
      .backgroundColor(this.selectedImage ? '#34A853' : '#A5D6A7')
      .borderRadius(27)
      .enabled(this.selectedImage !== '')
      .shadow({
        radius: this.selectedImage ? 12 : 6,
        color: this.selectedImage ? 'rgba(52, 168, 83, 0.4)' : 'rgba(165, 214, 167, 0.3)',
        offsetY: 4
      })
      .stateStyles({
        pressed: {
          .scale({ x: 0.96, y: 0.96 })
          .backgroundColor('#2E9549')
        },
        normal: {
          .scale({ x: 1, y: 1 })
        }
      })
      .onClick(() => this.recognizePlant())

      // Hint text
      if (!this.selectedImage) {
        Row({ space: 6 }) {
          Text('💡')
            .fontSize(12)
          Text('请先选择或拍摄植物照片')
            .fontSize(12)
            .fontColor('#8B9D8F')
        }
      }
    }
    .opacity(this.buttonOpacity)
    .translate({ y: this.buttonOffset })
  }

  // Original function - unchanged
  async recognizePlant() {
    if (!this.selectedImage) return

    try {
      const base64Image = await ImageUtils.processImageToBase64(this.selectedImage)
      const result = await PlantApiService.recognizePlant(base64Image)

      await PlantSave.processPlant(
        result,
        this.selectedImage,
        this.context
      )
      console.info('✅ Plant processed')

      await router.pushUrl({
        url: 'pages/ResultPage',
        params: {
          plantResults: JSON.stringify([result]),
          selectedImage: this.selectedImage
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
