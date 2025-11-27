// Google-Style Nature Plant Recognition UI
// Theme: Organic, relaxed, botanical garden feel with gentle animations

@Component
export struct IndexLayout {
  onCameraClick?: () => void
  onGalleryClick?: () => void
  onHandbookClick?: () => void

  // Animation states
  @State logoScale: number = 0.6
  @State logoOpacity: number = 0
  @State logoRotation: number = -15
  @State titleOffset: number = 30
  @State titleOpacity: number = 0
  @State subtitleOpacity: number = 0
  @State buttonGroupOpacity: number = 0
  @State buttonGroupOffset: number = 40
  @State footerOpacity: number = 0

  // Floating leaves animation states
  @State leaf1Y: number = -20
  @State leaf1Rotation: number = 0
  @State leaf2Y: number = -30
  @State leaf2Rotation: number = 15
  @State leaf3Y: number = -25
  @State leaf3Rotation: number = -10

  // Breathing glow effect
  @State glowRadius: number = 60
  @State glowOpacity: number = 0.15

  // Button hover states (simulated with press)
  @State cameraPressed: boolean = false
  @State galleryPressed: boolean = false
  @State handbookPressed: boolean = false

  aboutToAppear() {
    // Staggered entrance animations - Google style smooth easing
    setTimeout(() => {
      animateTo({
        duration: 900,
        curve: Curve.EaseOut
      }, () => {
        this.logoScale = 1
        this.logoOpacity = 1
        this.logoRotation = 0
      })
    }, 100)

    setTimeout(() => {
      animateTo({
        duration: 700,
        curve: Curve.EaseOut
      }, () => {
        this.titleOffset = 0
        this.titleOpacity = 1
      })
    }, 400)

    setTimeout(() => {
      animateTo({
        duration: 600,
        curve: Curve.EaseOut
      }, () => {
        this.subtitleOpacity = 1
      })
    }, 650)

    setTimeout(() => {
      animateTo({
        duration: 800,
        curve: Curve.EaseOut
      }, () => {
        this.buttonGroupOpacity = 1
        this.buttonGroupOffset = 0
      })
    }, 800)

    setTimeout(() => {
      animateTo({
        duration: 500,
        curve: Curve.EaseOut
      }, () => {
        this.footerOpacity = 1
      })
    }, 1200)

    // Start floating leaves animation loop
    this.startFloatingAnimation()

    // Start breathing glow effect
    this.startBreathingGlow()
  }

  startFloatingAnimation() {
    // Leaf 1 - slow drift
    setInterval(() => {
      animateTo({
        duration: 3000,
        curve: Curve.Smooth
      }, () => {
        this.leaf1Y = this.leaf1Y === -20 ? 20 : -20
        this.leaf1Rotation = this.leaf1Rotation === 0 ? 25 : 0
      })
    }, 3000)

    // Leaf 2 - medium drift
    setTimeout(() => {
      setInterval(() => {
        animateTo({
          duration: 2500,
          curve: Curve.Smooth
        }, () => {
          this.leaf2Y = this.leaf2Y === -30 ? 15 : -30
          this.leaf2Rotation = this.leaf2Rotation === 15 ? -20 : 15
        })
      }, 2500)
    }, 500)

    // Leaf 3 - fast drift
    setTimeout(() => {
      setInterval(() => {
        animateTo({
          duration: 2000,
          curve: Curve.Smooth
        }, () => {
          this.leaf3Y = this.leaf3Y === -25 ? 25 : -25
          this.leaf3Rotation = this.leaf3Rotation === -10 ? 30 : -10
        })
      }, 2000)
    }, 1000)
  }

  startBreathingGlow() {
    setInterval(() => {
      animateTo({
        duration: 2000,
        curve: Curve.Smooth
      }, () => {
        this.glowRadius = this.glowRadius === 60 ? 80 : 60
        this.glowOpacity = this.glowOpacity === 0.15 ? 0.25 : 0.15
      })
    }, 2000)
  }

  build() {
    Stack() {
      // Layer 1: Clean white-to-soft-green gradient (Google style minimal)
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 180,
          colors: [
            [0xFFFFFF, 0.0],
            [0xFAFDFA, 0.5],
            [0xF1F8E9, 0.85],
            [0xE8F5E9, 1.0]
          ]
        })

      // Layer 2: Subtle decorative floating leaves (organic feel)
      this.FloatingLeavesBackground()

      // Layer 3: Main Content - Google style centered layout
      Column() {
        Blank().flexGrow(0.8)

        // Logo with breathing glow
        this.LogoSection()

        Blank().height(24)

        // Title Section
        this.TitleSection()

        Blank().flexGrow(1)

        // Action Buttons - Google Material You style
        this.ButtonSection()

        Blank().height(32)

        // Footer tagline
        this.FooterSection()

        Blank().flexGrow(0.6)
      }
      .width('100%')
      .height('100%')
      .padding({ left: 24, right: 24 })
    }
  }

  @Builder
  FloatingLeavesBackground() {
    // Decorative floating leaf elements
    Stack() {
      // Leaf 1 - Top right
      Text('🌿')
        .fontSize(40)
        .opacity(0.12)
        .position({ x: '80%', y: '8%' })
        .rotate({ angle: this.leaf1Rotation })
        .translate({ y: this.leaf1Y })

      // Leaf 2 - Left side
      Text('🍃')
        .fontSize(32)
        .opacity(0.10)
        .position({ x: '5%', y: '25%' })
        .rotate({ angle: this.leaf2Rotation })
        .translate({ y: this.leaf2Y })

      // Leaf 3 - Bottom left
      Text('🌱')
        .fontSize(36)
        .opacity(0.08)
        .position({ x: '12%', y: '75%' })
        .rotate({ angle: this.leaf3Rotation })
        .translate({ y: this.leaf3Y })

      // Leaf 4 - Bottom right (static for balance)
      Text('🌿')
        .fontSize(28)
        .opacity(0.06)
        .position({ x: '85%', y: '68%' })
        .rotate({ angle: 45 })

      // Subtle circle decorations (Google style)
      Circle()
        .width(200)
        .height(200)
        .fill(0x4CAF50)
        .opacity(0.03)
        .position({ x: '-10%', y: '-5%' })

      Circle()
        .width(150)
        .height(150)
        .fill(0x81C784)
        .opacity(0.04)
        .position({ x: '75%', y: '85%' })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  LogoSection() {
    Stack() {
      // Breathing glow effect behind logo
      Circle()
        .width(160)
        .height(160)
        .fill(0x81C784)
        .opacity(this.glowOpacity)
        .blur(this.glowRadius)

      // Logo container with Google style elevation
      Column() {
        Image($r('app.media.startIcon'))
          .width(88)
          .height(88)
          .objectFit(ImageFit.Contain)
      }
      .width(120)
      .height(120)
      .borderRadius(28) // Google's rounded square style
      .backgroundColor(Color.White)
      .shadow({
        radius: 24,
        color: 'rgba(60, 64, 67, 0.15)',
        offsetY: 8
      })
      .justifyContent(FlexAlign.Center)
    }
    .scale({ x: this.logoScale, y: this.logoScale })
    .opacity(this.logoOpacity)
    .rotate({ angle: this.logoRotation })
  }

  @Builder
  TitleSection() {
    Column({ space: 8 }) {
      // Main title - Google Product Sans style
      Text('GreenGroth')
        .fontSize(32)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1F2937') // Dark gray, not pure black (Google style)
        .letterSpacing(0.5)
        .translate({ y: this.titleOffset })
        .opacity(this.titleOpacity)

      // Subtitle with accent color
      Text('植物识别与收藏')
        .fontSize(16)
        .fontWeight(FontWeight.Regular)
        .fontColor('#5F6368') // Google gray
        .letterSpacing(1)
        .opacity(this.subtitleOpacity)
    }
  }

  @Builder
  ButtonSection() {
    Column({ space: 16 }) {
      // Primary action row
      Row({ space: 12 }) {
        // Camera button - Google Blue accent (primary action)
        this.GoogleStyleButton(
          '📷',
          '拍照识别',
          '#1A73E8', // Google Blue
          '#E8F0FE', // Light blue bg
          () => this.onCameraClick?.(),
          1
        )

        // Gallery button - Google Green
        this.GoogleStyleButton(
          '🖼️',
          '相册选择',
          '#34A853', // Google Green
          '#E6F4EA', // Light green bg
          () => this.onGalleryClick?.(),
          2
        )
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)

      // Secondary action - Full width
      this.HandbookButton()
    }
    .width('100%')
    .opacity(this.buttonGroupOpacity)
    .translate({ y: this.buttonGroupOffset })
  }

  @Builder
  GoogleStyleButton(
    icon: string,
    label: string,
    accentColor: string,
    bgColor: string,
    action: () => void,
    index: number
  ) {
    Column({ space: 8 }) {
      // Icon circle
      Stack() {
        Circle()
          .width(56)
          .height(56)
          .fill(bgColor)

        Text(icon)
          .fontSize(24)
      }

      // Label
      Text(label)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#3C4043')
    }
    .width(140)
    .height(110)
    .padding(16)
    .borderRadius(20)
    .backgroundColor(Color.White)
    .shadow({
      radius: 8,
      color: 'rgba(60, 64, 67, 0.08)',
      offsetY: 2
    })
    .border({
      width: 1,
      color: 'rgba(60, 64, 67, 0.08)'
    })
    .stateStyles({
      pressed: {
        .backgroundColor('#F8F9FA')
        .scale({ x: 0.96, y: 0.96 })
      },
      normal: {
        .backgroundColor(Color.White)
        .scale({ x: 1, y: 1 })
      }
    })
    .onClick(() => {
      action()
    })
  }

  @Builder
  HandbookButton() {
    Row({ space: 16 }) {
      // Icon section
      Stack() {
        Circle()
          .width(48)
          .height(48)
          .fill('#FEF7E0') // Warm yellow bg

        Text('📚')
          .fontSize(22)
      }

      // Text section
      Column({ space: 2 }) {
        Text('我的植物图鉴')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#3C4043')

        Text('查看已收藏的植物')
          .fontSize(12)
          .fontColor('#5F6368')
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      // Arrow indicator
      Text('→')
        .fontSize(20)
        .fontColor('#9AA0A6')
    }
    .width('100%')
    .height(80)
    .padding({ left: 20, right: 20 })
    .borderRadius(20)
    .backgroundColor(Color.White)
    .shadow({
      radius: 12,
      color: 'rgba(60, 64, 67, 0.1)',
      offsetY: 4
    })
    .border({
      width: 1,
      color: 'rgba(60, 64, 67, 0.08)'
    })
    .stateStyles({
      pressed: {
        .backgroundColor('#F8F9FA')
        .scale({ x: 0.98, y: 0.98 })
      },
      normal: {
        .backgroundColor(Color.White)
        .scale({ x: 1, y: 1 })
      }
    })
    .onClick(() => {
      this.onHandbookClick?.()
    })
  }

  @Builder
  FooterSection() {
    Column({ space: 6 }) {
      // Decorative dots (Google style)
      Row({ space: 6 }) {
        ForEach(['#34A853', '#4285F4', '#FBBC05', '#EA4335'], (color: string) => {
          Circle()
            .width(6)
            .height(6)
            .fill(color)
        })
      }

      Text('探索自然  ·  记录美好  ·  认识世界')
        .fontSize(13)
        .fontColor('#9AA0A6')
        .fontWeight(FontWeight.Regular)
        .margin({ top: 12 })
    }
    .opacity(this.footerOpacity)
  }
}
