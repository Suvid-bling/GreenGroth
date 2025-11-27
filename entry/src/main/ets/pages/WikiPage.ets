// WikiPage - Google Material Style with Nature Theme & Dynamic Effects
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

  // Animation states
  @State headerOpacity: number = 0
  @State headerOffset: number = -20
  @State imageOpacity: number = 0
  @State imageScale: number = 0.95
  @State basicInfoOpacity: number = 0
  @State basicInfoOffset: number = 25

  // Section reveal tracking
  @State revealedSections: number = 0

  // Floating decorations
  @State floatY1: number = 0
  @State floatY2: number = 0
  @State floatRotate: number = 0

  // Parallax scroll effect
  @State scrollY: number = 0

  async aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.infoCode = params.infoCode || '';

    this.startFloatingAnimations()
    this.playEntranceAnimations()

    try {
      const context = getContext(this) as common.UIAbilityContext;
      await PlantWikiStorage.init(context);
      this.wikiInfo = await PlantWikiStorage.getWiki(this.infoCode);
      console.info(`Wiki loaded for: ${this.infoCode}`);

      // Start section reveal after data loads
      setTimeout((): void => this.revealSections(), 600)
    } catch (err) {
      console.error('Failed to load wiki:', JSON.stringify(err));
    } finally {
      this.isLoading = false
    }
  }

  playEntranceAnimations() {
    setTimeout(() => {
      animateTo({ duration: 500, curve: Curve.EaseOut }, () => {
        this.headerOpacity = 1
        this.headerOffset = 0
      })
    }, 100)

    setTimeout(() => {
      animateTo({ duration: 700, curve: Curve.EaseOut }, () => {
        this.imageOpacity = 1
        this.imageScale = 1
      })
    }, 250)

    setTimeout(() => {
      animateTo({ duration: 600, curve: Curve.EaseOut }, () => {
        this.basicInfoOpacity = 1
        this.basicInfoOffset = 0
      })
    }, 450)
  }

  revealSections() {
    const revealNext = () => {
      if (this.revealedSections < 10) {
        animateTo({ duration: 350, curve: Curve.EaseOut }, () => {
          this.revealedSections++
        })
        setTimeout(revealNext, 120)
      }
    }
    revealNext()
  }

  startFloatingAnimations() {
    setInterval(() => {
      animateTo({ duration: 3500, curve: Curve.Smooth }, () => {
        this.floatY1 = this.floatY1 === 0 ? 15 : 0
        this.floatRotate = this.floatRotate === 0 ? 8 : 0
      })
    }, 3500)

    setTimeout(() => {
      setInterval(() => {
        animateTo({ duration: 2800, curve: Curve.Smooth }, () => {
          this.floatY2 = this.floatY2 === 0 ? -12 : 0
        })
      }, 2800)
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
            [0xFCFDF9, 0.3],
            [0xF4F9F0, 0.65],
            [0xE8F5E9, 1.0]
          ]
        })

      // Floating decorations
      this.FloatingDecorations()

      // Main content
      Column() {
        this.HeaderSection()

        if (this.isLoading) {
          this.LoadingState()
        } else if (!this.wikiInfo) {
          this.EmptyState()
        } else {
          this.ContentSection()
        }
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  FloatingDecorations() {
    Stack() {
      Text('🌿')
        .fontSize(34)
        .opacity(0.07)
        .position({ x: '85%', y: '8%' })
        .translate({ y: this.floatY1 })
        .rotate({ angle: this.floatRotate })

      Text('🍃')
        .fontSize(26)
        .opacity(0.05)
        .position({ x: '3%', y: '40%' })
        .translate({ y: this.floatY2 })

      Text('🌸')
        .fontSize(22)
        .opacity(0.04)
        .position({ x: '88%', y: '65%' })
        .translate({ y: this.floatY1 })

      Circle()
        .width(160)
        .height(160)
        .fill(0x81C784)
        .opacity(0.03)
        .position({ x: '-8%', y: '-4%' })

      Circle()
        .width(100)
        .height(100)
        .fill(0xA5D6A7)
        .opacity(0.035)
        .position({ x: '82%', y: '88%' })
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
        Text('📖')
          .fontSize(20)
        Text('植物百科')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1C1E')
      }

      // Bookmark/share placeholder
      Row() {
        Text('❤️')
          .fontSize(18)
          .opacity(0.6)
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .justifyContent(FlexAlign.Center)
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
  LoadingState() {
    Column({ space: 16 }) {
      LoadingProgress()
        .width(44)
        .height(44)
        .color('#34A853')
      Text('加载植物百科...')
        .fontSize(14)
        .fontColor('#5F6368')
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  EmptyState() {
    Column({ space: 12 }) {
      Stack() {
        Circle()
          .width(120)
          .height(120)
          .fill(0x81C784)
          .opacity(0.1)
          .blur(30)

        Column() {
          Text('🌱')
            .fontSize(48)
        }
        .width(88)
        .height(88)
        .borderRadius(22)
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.Center)
        .shadow({ radius: 16, color: 'rgba(60, 64, 67, 0.1)', offsetY: 4 })
      }

      Text('暂无百科信息')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1C1E')
        .margin({ top: 12 })

      Text('该植物的详细资料正在收集中')
        .fontSize(13)
        .fontColor('#5F6368')
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  ContentSection() {
    Scroll() {
      Column({ space: 16 }) {
        // Image Gallery
        if (this.wikiInfo!.images.length > 0) {
          this.ImageGallery()
        }

        // Basic Info Card
        this.BasicInfoCard()

        // Detail Sections with icons
        this.InfoSection('🌸', '花语寓意', this.wikiInfo!.info.hyyy, 0)
        this.InfoSection('📅', '花开时节', this.wikiInfo!.info.hksj, 1)
        this.InfoSection('🌿', '表型特征', this.wikiInfo!.info.bxtz, 2)
        this.InfoSection('🗺️', '分布地区', this.wikiInfo!.info.fbdq, 3)
        this.InfoSection('💧', '养护技术', this.wikiInfo!.info.yhjs, 4)
        this.InfoSection('✨', '价值功用', this.wikiInfo!.info.jzgy, 5)
        this.InfoSection('📜', '名称来历', this.wikiInfo!.info.mcll, 6)
        this.InfoSection('🎋', '相关诗词', this.wikiInfo!.info.xgsc, 7)

        // Bottom spacing
        Column().height(24)
      }
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }

  @Builder
  ImageGallery() {
    Stack() {
      // Decorative frame
      Column()
        .width('98%')
        .height(235)
        .borderRadius(20)
        .border({ width: 2, color: '#C8E6C9' })
        .shadow({ radius: 12, color: 'rgba(76, 175, 80, 0.12)', offsetY: 4 })

      // Swiper
      Swiper() {
        ForEach(this.wikiInfo!.images, (imgUrl: string) => {
          Column() {
            WebImg({
              imageUrl: imgUrl,
              imgWidth: '100%',
              imgHeight: 220
            })
          }
          .width('100%')
          .height(220)
          .borderRadius(16)
          .clip(true)
          .backgroundColor('#F1F8E9')
        })
      }
      .width('94%')
      .height(220)
      .borderRadius(16)
      .autoPlay(true)
      .interval(4000)
      .indicator(
        new DotIndicator()
          .selectedColor('#34A853')
          .color('rgba(165, 214, 167, 0.6)')
      )
    }
    .width('100%')
    .padding({ top: 4, bottom: 8 })
    .alignContent(Alignment.Center)
    .opacity(this.imageOpacity)
    .scale({ x: this.imageScale, y: this.imageScale })
  }

  @Builder
  BasicInfoCard() {
    Column({ space: 12 }) {
      // Name section
      Column({ space: 6 }) {
        Text(this.wikiInfo!.nameStd)
          .fontSize(26)
          .fontWeight(FontWeight.Medium)
          .fontColor('#2E5435')
          .letterSpacing(0.5)

        Text(this.wikiInfo!.nameLt)
          .fontSize(14)
          .fontColor('#6B7B6E')
          .fontStyle(FontStyle.Italic)
          .letterSpacing(0.8)
      }

      // Divider
      Row() {
        Row().width(50).height(2).backgroundColor('#A5D6A7').borderRadius(1)
        Text('🌿').fontSize(14).opacity(0.5).margin({ left: 10, right: 10 })
        Row().layoutWeight(1).height(1).backgroundColor('#E8F5E9')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // Classification chips
      Row({ space: 10 }) {
        this.ClassificationChip('科', this.wikiInfo!.familyCn)
        this.ClassificationChip('属', this.wikiInfo!.genusCn)
      }

      // Alias
      if (this.wikiInfo!.alias) {
        Row({ space: 6 }) {
          Text('别名')
            .fontSize(12)
            .fontColor('#9AA09C')
          Text(this.wikiInfo!.alias)
            .fontSize(13)
            .fontColor('#5F6368')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }

      // Description
      if (this.wikiInfo!.description) {
        Text(this.wikiInfo!.description)
          .fontSize(14)
          .fontColor('#3C4043')
          .lineHeight(24)
          .letterSpacing(0.2)
          .margin({ top: 4 })
      }
    }
    .width('100%')
    .padding(18)
    .borderRadius(20)
    .backgroundColor('#FAFDF8')
    .border({ width: 1.5, color: 'rgba(165, 214, 167, 0.4)' })
    .shadow({ radius: 8, color: 'rgba(46, 84, 53, 0.06)', offsetY: 3 })
    .opacity(this.basicInfoOpacity)
    .translate({ y: this.basicInfoOffset })
  }

  @Builder
  ClassificationChip(label: string, value: string) {
    Row({ space: 6 }) {
      Text(label)
        .fontSize(11)
        .fontColor('#7CB342')
        .fontWeight(FontWeight.Medium)

      Text(value)
        .fontSize(13)
        .fontColor('#2E5435')
    }
    .padding({ left: 12, right: 12, top: 6, bottom: 6 })
    .borderRadius(14)
    .backgroundColor('#E8F5E9')
    .border({ width: 1, color: 'rgba(124, 179, 66, 0.3)' })
  }

  @Builder
  InfoSection(icon: string, title: string, content: string, index: number) {
    if (content && content.length > 0) {
      Column({ space: 10 }) {
        // Title row with icon
        Row({ space: 10 }) {
          Row() {
            Text(icon)
              .fontSize(16)
          }
          .width(32)
          .height(32)
          .borderRadius(10)
          .backgroundColor('#E8F5E9')
          .justifyContent(FlexAlign.Center)

          Text(title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#2E5435')
            .letterSpacing(0.3)
        }

        // Content
        Text(content)
          .fontSize(14)
          .fontColor('#3C4043')
          .lineHeight(24)
          .letterSpacing(0.2)
          .width('100%')
      }
      .width('100%')
      .padding(16)
      .borderRadius(18)
      .backgroundColor('#FAFDF8')
      .border({ width: 1, color: 'rgba(165, 214, 167, 0.35)' })
      .shadow({ radius: 6, color: 'rgba(46, 84, 53, 0.05)', offsetY: 2 })
      .alignItems(HorizontalAlign.Start)
      // Staggered reveal animation
      .opacity(index < this.revealedSections ? 1 : 0)
      .translate({ y: index < this.revealedSections ? 0 : 20 })
      .animation({
        duration: 350,
        curve: Curve.EaseOut
      })
    }
  }
}
