// FailedResultPage - Humorous & Friendly Error State
import { router } from '@kit.ArkUI';

@Entry
@Component
struct FailedResultPage {
  @State imageUri: string = ''
  @State errorMessage: string = '无法识别该植物'

  // Animation states
  @State headerOpacity: number = 0
  @State characterScale: number = 0.5
  @State characterOpacity: number = 0
  @State characterRotate: number = -10
  @State contentOpacity: number = 0
  @State contentOffset: number = 30
  @State tipsOpacity: number = 0

  // Character animations
  @State eyeBlink: boolean = false
  @State floatY: number = 0
  @State sweatDrop: number = 0

  // Floating decorations
  @State leafFloat1: number = 0
  @State leafFloat2: number = 0
  @State questionBounce: number = 0

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>
    this.imageUri = params.imageUri || ''
    this.errorMessage = params.errorMessage || '无法识别该植物'

    this.playEntranceAnimations()
    this.startCharacterAnimations()
    this.startFloatingAnimations()
  }

  playEntranceAnimations() {
    setTimeout(() => {
      animateTo({ duration: 500, curve: Curve.EaseOut }, () => {
        this.headerOpacity = 1
      })
    }, 100)

    // Character bounces in
    setTimeout(() => {
      animateTo({ duration: 700, curve: Curve.EaseOut }, () => {
        this.characterScale = 1
        this.characterOpacity = 1
        this.characterRotate = 0
      })
    }, 300)

    setTimeout(() => {
      animateTo({ duration: 500, curve: Curve.EaseOut }, () => {
        this.contentOpacity = 1
        this.contentOffset = 0
      })
    }, 600)

    setTimeout(() => {
      animateTo({ duration: 400, curve: Curve.EaseOut }, () => {
        this.tipsOpacity = 1
      })
    }, 900)
  }

  startCharacterAnimations() {
    // Eye blink
    setInterval(() => {
      this.eyeBlink = true
      setTimeout(() => { this.eyeBlink = false }, 150)
    }, 3000)

    // Gentle float
    setInterval(() => {
      animateTo({ duration: 1500, curve: Curve.Smooth }, () => {
        this.floatY = this.floatY === 0 ? -8 : 0
      })
    }, 1500)

    // Sweat drop animation
    setInterval(() => {
      animateTo({ duration: 800, curve: Curve.EaseIn }, () => {
        this.sweatDrop = 15
      })
      setTimeout(() => {
        this.sweatDrop = 0
      }, 900)
    }, 4000)
  }

  startFloatingAnimations() {
    setInterval(() => {
      animateTo({ duration: 2500, curve: Curve.Smooth }, () => {
        this.leafFloat1 = this.leafFloat1 === 0 ? 12 : 0
      })
    }, 2500)

    setTimeout(() => {
      setInterval(() => {
        animateTo({ duration: 2000, curve: Curve.Smooth }, () => {
          this.leafFloat2 = this.leafFloat2 === 0 ? -10 : 0
        })
      }, 2000)
    }, 800)

    // Question mark bounce
    setInterval(() => {
      animateTo({ duration: 600, curve: Curve.EaseOut }, () => {
        this.questionBounce = -10
      })
      setTimeout(() => {
        animateTo({ duration: 600, curve: Curve.EaseIn }, () => {
          this.questionBounce = 0
        })
      }, 600)
    }, 2000)
  }

  build() {
    Stack() {
      // Background
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 175,
          colors: [
            [0xFFFBF5, 0.0],
            [0xFFF8F0, 0.4],
            [0xFFF5EB, 0.7],
            [0xFFF0E0, 1.0]
          ]
        })

      // Floating decorations
      this.FloatingDecorations()

      // Main content
      Column({ space: 16 }) {
        this.HeaderSection()

        Scroll() {
          Column({ space: 20 }) {
            // Confused plant character
            this.ConfusedCharacter()

            // Failed image (if exists)
            if (this.imageUri && this.imageUri.length > 0) {
              this.FailedImageSection()
            }

            // Error message with humor
            this.ErrorMessageSection()

            // Tips section
            this.TipsSection()

            // Retry button
            this.RetryButton()

            Column().height(30)
          }
          .padding({ left: 20, right: 20 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  FloatingDecorations() {
    Stack() {
      // Confused leaves
      Text('🍂')
        .fontSize(28)
        .opacity(0.15)
        .position({ x: '8%', y: '15%' })
        .translate({ y: this.leafFloat1 })
        .rotate({ angle: 15 })

      Text('🍃')
        .fontSize(24)
        .opacity(0.12)
        .position({ x: '85%', y: '35%' })
        .translate({ y: this.leafFloat2 })
        .rotate({ angle: -20 })

      // Floating question marks
      Text('❓')
        .fontSize(20)
        .opacity(0.1)
        .position({ x: '75%', y: '12%' })
        .translate({ y: this.questionBounce })

      Text('❔')
        .fontSize(16)
        .opacity(0.08)
        .position({ x: '12%', y: '70%' })
        .translate({ y: this.leafFloat2 })

      // Soft circles
      Circle()
        .width(150)
        .height(150)
        .fill(0xFFB74D)
        .opacity(0.04)
        .position({ x: '-10%', y: '-5%' })

      Circle()
        .width(100)
        .height(100)
        .fill(0xFFCC80)
        .opacity(0.05)
        .position({ x: '80%', y: '85%' })
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
          .fontColor('#8B6914')
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(255, 193, 7, 0.2)')
      .stateStyles({
        pressed: { .backgroundColor('rgba(255, 193, 7, 0.4)') },
        normal: { .backgroundColor('rgba(255, 193, 7, 0.2)') }
      })
      .onClick(() => router.back())

      Row({ space: 8 }) {
        Text('识别失败')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#5D4E37')
      }

      Column().width(44)
    }
    .width('100%')
    .height(56)
    .padding({ left: 8, right: 8 })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .opacity(this.headerOpacity)
  }

  @Builder
  ConfusedCharacter() {
    Column() {
      Stack() {
        // Character body - a confused plant pot
        Column() {
          // Plant head with confused face
          Stack() {
            // Face background
            Circle()
              .width(90)
              .height(90)
              .fill('#8BC34A')
              .shadow({ radius: 8, color: 'rgba(139, 195, 74, 0.3)', offsetY: 4 })

            // Eyes
            Row({ space: 20 }) {
              // Left eye
              Column() {
                if (this.eyeBlink) {
                  Row()
                    .width(16)
                    .height(3)
                    .backgroundColor('#4E342E')
                    .borderRadius(2)
                } else {
                  Circle()
                    .width(14)
                    .height(14)
                    .fill('#4E342E')
                  Circle()
                    .width(5)
                    .height(5)
                    .fill(Color.White)
                    .position({ x: 8, y: 2 })
                }
              }

              // Right eye (looking confused - different direction)
              Column() {
                if (this.eyeBlink) {
                  Row()
                    .width(16)
                    .height(3)
                    .backgroundColor('#4E342E')
                    .borderRadius(2)
                } else {
                  Circle()
                    .width(14)
                    .height(14)
                    .fill('#4E342E')
                  Circle()
                    .width(5)
                    .height(5)
                    .fill(Color.White)
                    .position({ x: 2, y: 2 })
                }
              }
            }
            .margin({ top: -5 })

            // Confused swirl eyebrows
            Text('～')
              .fontSize(24)
              .fontColor('#4E342E')
              .position({ x: 20, y: 15 })
              .rotate({ angle: 10 })

            Text('～')
              .fontSize(24)
              .fontColor('#4E342E')
              .position({ x: 50, y: 15 })
              .rotate({ angle: -10 })

            // Wavy confused mouth
            Text('〰️')
              .fontSize(16)
              .position({ x: 32, y: 58 })

            // Sweat drop
            Text('💧')
              .fontSize(14)
              .position({ x: 78, y: 20 })
              .translate({ y: this.sweatDrop })
              .opacity(this.sweatDrop > 0 ? 1 : 0.7)

            // Leaf on top
            Text('🌱')
              .fontSize(20)
              .position({ x: 35, y: -15 })
          }
          .width(90)
          .height(90)

          // Pot body
          Stack() {
            // Pot shape
            Column()
              .width(70)
              .height(50)
              .backgroundColor('#D7CCC8')
              .borderRadius({ bottomLeft: 12, bottomRight: 12 })
              .border({ width: 2, color: '#BCAAA4' })

            // Pot rim
            Row()
              .width(80)
              .height(12)
              .backgroundColor('#BCAAA4')
              .borderRadius(4)
              .position({ y: -6 })

            // Pot face detail
            Text('···')
              .fontSize(16)
              .fontColor('#A1887F')
              .position({ x: 22, y: 18 })
          }
          .margin({ top: -8 })
        }

        // Floating question mark
        Text('❓')
          .fontSize(28)
          .position({ x: 85, y: -10 })
          .translate({ y: this.questionBounce })
      }
    }
    .scale({ x: this.characterScale, y: this.characterScale })
    .opacity(this.characterOpacity)
    .rotate({ angle: this.characterRotate })
    .translate({ y: this.floatY })
    .margin({ top: 10, bottom: 10 })
  }

  @Builder
  FailedImageSection() {
    Stack() {
      // Decorative frame
      Column()
        .width('78%')
        .height(175)
        .borderRadius(18)
        .border({ width: 2, color: '#FFCC80' })

      // Image with "failed" overlay
      Stack() {
        Image(this.imageUri)
          .width('100%')
          .height('100%')
          .borderRadius(14)
          .objectFit(ImageFit.Cover)

        // Subtle overlay
        Column()
          .width('100%')
          .height('100%')
          .borderRadius(14)
          .backgroundColor('rgba(0, 0, 0, 0.1)')

        // Confused emoji overlay
        Text('🤔')
          .fontSize(40)
          .opacity(0.8)
      }
      .width('72%')
      .height(165)
      .borderRadius(14)
    }
    .width('100%')
    .alignContent(Alignment.Center)
    .opacity(this.contentOpacity)
    .translate({ y: this.contentOffset })
  }

  @Builder
  ErrorMessageSection() {
    Column({ space: 10 }) {
      // Humorous message
      Text('哎呀，这是什么植物？')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor('#5D4E37')

      Text('我挠破脑袋也认不出来... ')
        .fontSize(14)
        .fontColor('#8D7B68')

      // Original error message in subtle style
      Row({ space: 6 }) {
        Text(this.errorMessage)
          .fontSize(12)
          .fontColor('#A99B8D')
      }
      .padding({ top: 8 })
    }
    .opacity(this.contentOpacity)
  }

  @Builder
  TipsSection() {
    Column({ space: 12 }) {
      // Tips header
      Row({ space: 8 }) {
        Text('💡')
          .fontSize(18)
        Text('小贴士')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#6D5D4B')
      }

      // Tips list with playful icons
      Column({ space: 10 }) {
        this.TipItem('拍清楚点，我近视眼~')
        this.TipItem('花朵叶子拍一拍')
        this.TipItem('光线足才看得清')
        this.TipItem('多拍些植物特征')
      }
    }
    .width('100%')
    .padding(16)
    .borderRadius(18)
    .backgroundColor('#FFFDF8')
    .border({ width: 1, color: 'rgba(255, 193, 7, 0.3)' })
    .shadow({ radius: 6, color: 'rgba(139, 119, 42, 0.08)', offsetY: 2 })
    .opacity(this.tipsOpacity)
  }

  @Builder
  TipItem(text: string) {
    Row({ space: 10 }) {
      Text(text)
        .fontSize(13)
        .fontColor('#6D5D4B')
    }
    .width('100%')
    .padding({ left: 4 })
  }

  @Builder
  RetryButton() {
    Button() {
      Row({ space: 8 }) {
        Text('再试一次')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
      }
    }
    .width('70%')
    .height(50)
    .backgroundColor('#8BC34A')
    .borderRadius(25)
    .shadow({ radius: 10, color: 'rgba(139, 195, 74, 0.4)', offsetY: 4 })
    .stateStyles({
      pressed: {
        .scale({ x: 0.96, y: 0.96 })
        .backgroundColor('#7CB342')
      },
      normal: {
        .scale({ x: 1, y: 1 })
      }
    })
    .onClick(() => router.pushUrl({ url: 'pages/Index' }))
    .margin({ top: 10 })
    .opacity(this.tipsOpacity)
  }
}
