// Specimen Bookcase Style - Plant Handbook Layout Component
// Theme: Vintage botanical collection, wooden bookcase, pressed specimens

import { PlantInfo } from '../../ets/models/PlantInfo';

@Component
export struct HandbookPageLayout {
  // Data from parent
  @Link plants: PlantInfo[]
  @Link currentPage: number
  @Prop totalPages: number
  @Prop itemsPerPage: number
  scroller: Scroller = new Scroller()

  // Callbacks from parent
  onBackClick?: () => void
  onPlantClick?: (infoCode: string) => void
  onPrevPage?: () => void
  onNextPage?: () => void

  // Animation States
  @State headerOpacity: number = 0
  @State headerOffset: number = -20
  @State statsOpacity: number = 0
  @State gridOpacity: number = 0
  @State gridTranslateY: number = 30
  @State emptyStateScale: number = 0.85
  @State emptyStateOpacity: number = 0
  @State paginationOpacity: number = 0
  @State cardsVisible: boolean = false
  @State private prevPage: number = 0

  // Floating decorations
  @State floatY1: number = 0
  @State floatY2: number = 0
  @State floatRotate1: number = 0

  aboutToAppear() {
    this.playEntranceAnimations()
    this.startFloatingDecorations()
    setTimeout(() => { this.cardsVisible = true }, 500)
  }

  playEntranceAnimations() {
    setTimeout(() => {
      animateTo({ duration: 500, curve: Curve.EaseOut }, () => {
        this.headerOpacity = 1
        this.headerOffset = 0
      })
    }, 100)

    setTimeout(() => {
      animateTo({ duration: 400, curve: Curve.EaseOut }, () => {
        this.statsOpacity = 1
      })
    }, 350)

    setTimeout(() => {
      animateTo({ duration: 600, curve: Curve.EaseOut }, () => {
        this.gridOpacity = 1
        this.gridTranslateY = 0
      })
    }, 400)

    setTimeout(() => {
      animateTo({ duration: 700, curve: Curve.EaseOut }, () => {
        this.emptyStateScale = 1
        this.emptyStateOpacity = 1
      })
    }, 500)

    setTimeout(() => {
      animateTo({ duration: 400, curve: Curve.EaseOut }, () => {
        this.paginationOpacity = 1
      })
    }, 700)
  }

  startFloatingDecorations() {
    setInterval(() => {
      animateTo({ duration: 3500, curve: Curve.Smooth }, () => {
        this.floatY1 = this.floatY1 === 0 ? 12 : 0
        this.floatRotate1 = this.floatRotate1 === 0 ? 8 : 0
      })
    }, 3500)

    setTimeout(() => {
      setInterval(() => {
        animateTo({ duration: 2800, curve: Curve.Smooth }, () => {
          this.floatY2 = this.floatY2 === 0 ? -10 : 0
        })
      }, 2800)
    }, 800)
  }

  getCurrentPagePlants(): PlantInfo[] {
    const start = this.currentPage * this.itemsPerPage
    const end = start + this.itemsPerPage
    return this.plants.slice(start, end)
  }

  onPageChange() {
    this.cardsVisible = false
    setTimeout(() => { this.cardsVisible = true }, 80)
  }

  handlePrevPage() {
    if (this.currentPage > 0) {
      console.log('handlePrevPage called, currentPage:', this.currentPage)
      this.onPageChange()
      this.onPrevPage?.()
    }
  }

  handleNextPage() {
    if (this.currentPage < this.totalPages - 1) {
      this.onPageChange()
      this.onNextPage?.()
    }
  }

  handlePageClick(page: number) {
    if (page !== this.currentPage) {
      this.onPageChange()
      this.currentPage = page
    }
  }

  build() {
    Stack() {
      // Wooden bookcase background
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 180,
          colors: [
            [0xF5E6D3, 0.0],
            [0xEDE0D0, 0.3],
            [0xE8D8C4, 0.6],
            [0xDEC9AE, 1.0]
          ]
        })

      // Wood grain texture overlay
      this.WoodGrainOverlay()

      // Floating botanical elements
      this.FloatingDecorations()

      // Main content
      Column() {
        this.HeaderSection()

        if (this.plants.length === 0) {
          this.EmptySection()
        } else {
          this.StatsBar()
          this.BookcaseGrid()
          this.PaginationSection()
        }
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  WoodGrainOverlay() {
    Stack() {
      Column()
        .width('100%')
        .height(2)
        .backgroundColor('#D4B896')
        .opacity(0.3)
        .position({ y: '28%' })

      Column()
        .width('100%')
        .height(2)
        .backgroundColor('#D4B896')
        .opacity(0.25)
        .position({ y: '52%' })

      Column()
        .width('100%')
        .height(2)
        .backgroundColor('#D4B896')
        .opacity(0.2)
        .position({ y: '76%' })
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.None)
  }

  @Builder
  FloatingDecorations() {
    Stack() {
      Text('🍂')
        .fontSize(32)
        .opacity(0.12)
        .position({ x: '85%', y: '8%' })
        .translate({ y: this.floatY1 })
        .rotate({ angle: this.floatRotate1 })

      Text('🌾')
        .fontSize(28)
        .opacity(0.1)
        .position({ x: '5%', y: '40%' })
        .translate({ y: this.floatY2 })

      Text('🌰')
        .fontSize(22)
        .opacity(0.08)
        .position({ x: '88%', y: '60%' })
        .translate({ y: this.floatY1 })

      Circle()
        .width(150)
        .height(150)
        .fill(0xC9A66B)
        .opacity(0.06)
        .position({ x: '-8%', y: '-4%' })

      Circle()
        .width(100)
        .height(100)
        .fill(0xB8956E)
        .opacity(0.05)
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
          .fontColor('#5D4E37')
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(139, 90, 43, 0.15)')
      .stateStyles({
        pressed: { .backgroundColor('rgba(139, 90, 43, 0.25)') },
        normal: { .backgroundColor('rgba(139, 90, 43, 0.15)') }
      })
      .onClick(() => this.onBackClick?.())

      Row({ space: 8 }) {
        Text('📖')
          .fontSize(22)
        Column() {
          Text('植物标本集')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor('#4A3728')
            .letterSpacing(1)
          Text('Herbarium Collection')
            .fontSize(10)
            .fontColor('#8B7355')
            .fontStyle(FontStyle.Italic)
        }
        .alignItems(HorizontalAlign.Start)
      }

      Row() {
        Text('🔖')
          .fontSize(20)
          .opacity(0.6)
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(68)
    .padding({ left: 8, right: 8 })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor('rgba(210, 180, 140, 0.4)')
    .border({ width: { bottom: 2 }, color: '#C9A66B' })
    .opacity(this.headerOpacity)
    .translate({ y: this.headerOffset })
  }

  @Builder
  StatsBar() {
    Row() {
      Row({ space: 6 }) {
        Text('🏷️')
          .fontSize(14)
        Text(`收藏标本 ${this.plants.length} 件`)
          .fontSize(13)
          .fontColor('#6B5344')
          .fontStyle(FontStyle.Italic)
      }

      Row({ space: 4 }) {
        Text('第')
          .fontSize(12)
          .fontColor('#8B7355')
        Text(`${this.currentPage + 1}`)
          .fontSize(14)
          .fontColor('#5D4E37')
          .fontWeight(FontWeight.Medium)
        Text('页')
          .fontSize(12)
          .fontColor('#8B7355')
      }
      .padding({ left: 12, right: 12, top: 4, bottom: 4 })
      .borderRadius(4)
      .backgroundColor('rgba(201, 166, 107, 0.2)')
      .border({ width: 1, color: 'rgba(139, 90, 43, 0.3)' })
    }
    .width('100%')
    .padding({ left: 18, right: 18, top: 10, bottom: 8 })
    .justifyContent(FlexAlign.SpaceBetween)
    .opacity(this.statsOpacity)
  }

  @Builder
  EmptySection() {
    Column({ space: 16 }) {
      Stack() {
        Column()
          .width(120)
          .height(120)
          .borderRadius(8)
          .backgroundColor('rgba(255, 255, 255, 0.6)')
          .border({ width: 3, color: '#C9A66B' })
          .shadow({ radius: 12, color: 'rgba(90, 60, 30, 0.15)', offsetY: 4 })

        Column() {
          Text('🌿')
            .fontSize(48)
            .opacity(0.4)
        }
        .justifyContent(FlexAlign.Center)
      }

      Text('标本柜是空的')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#4A3728')
        .margin({ top: 12 })

      Text('去发现植物，收集您的第一件标本')
        .fontSize(13)
        .fontColor('#8B7355')
        .fontStyle(FontStyle.Italic)

      Button('开始采集')
        .width(130)
        .height(44)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFF8F0')
        .backgroundColor('#8B5A2B')
        .borderRadius(6)
        .margin({ top: 24 })
        .border({ width: 1, color: '#6B4423' })
        .shadow({ radius: 6, color: 'rgba(107, 68, 35, 0.3)', offsetY: 3 })
        .stateStyles({
          pressed: { .scale({ x: 0.96, y: 0.96 }) },
          normal: { .scale({ x: 1, y: 1 }) }
        })
        .onClick(() => this.onBackClick?.())
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .scale({ x: this.emptyStateScale, y: this.emptyStateScale })
    .opacity(this.emptyStateOpacity)
  }

  @Builder
  BookcaseGrid() {
    Stack() {
      // Layer 1: Book spine
      Column()
        .width(12)
        .height('96%')
        .linearGradient({
          angle: 0,
          colors: [
            [0x8B6914, 0.0],
            [0xA67C52, 0.3],
            [0x8B6914, 0.5],
            [0xA67C52, 0.7],
            [0x8B6914, 1.0]
          ]
        })
        .borderRadius({ topLeft: 4, bottomLeft: 4 })
        .position({ x: 0, y: '2%' })
        .shadow({ radius: 4, color: 'rgba(60, 40, 20, 0.4)', offsetX: 2 })

      // Layer 2: Page edge lines
      Column() {
        ForEach([1, 2, 3, 4, 5, 6, 7, 8], () => {
          Row()
            .width('100%')
            .height(1)
            .backgroundColor('#E8DCC8')
            .margin({ bottom: 1 })
        })
      }
      .width(8)
      .position({ x: 4, y: '40%' })
      .opacity(0.8)

      // Layer 3: Underlying page shadow
      Column()
        .width('94%')
        .height('96%')
        .backgroundColor('#F8F2E8')
        .borderRadius({ topRight: 6, bottomRight: 6 })
        .border({ width: { left: 2 }, color: 'rgba(201, 166, 107, 0.3)' })
        .position({ x: '4%', y: '2%' })
        .opacity(0.5)

      // Layer 4: Main page
      Stack() {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#FDF8F0')
          .borderRadius({ topRight: 6, bottomRight: 6, topLeft: 2, bottomLeft: 2 })
          .border({ width: { left: 1 }, color: '#D4C4A8' })
          .shadow({ radius: 6, color: 'rgba(90, 60, 30, 0.12)', offsetX: 2, offsetY: 3 })

        // Spine fold shadow
        Column()
          .width(20)
          .height('100%')
          .linearGradient({
            angle: 0,
            colors: [
              ['rgba(139, 105, 20, 0.15)', 0.0],
              ['rgba(139, 105, 20, 0.05)', 0.5],
              ['rgba(139, 105, 20, 0)', 1.0]
            ]
          })
          .position({ x: 0 })

        // Grid content
        Grid(this.scroller) {
          ForEach(this.getCurrentPagePlants(), (plant: PlantInfo, index: number) => {
            GridItem() {
              this.SpecimenCard(plant, index)
            }
          }, (plant: PlantInfo) => plant.InfoCode)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr 1fr')
        .rowsGap(12)
        .columnsGap(10)
        .padding({ left: 20, right: 12, top: 8, bottom: 24 })
        .width('100%')
        .height('100%')

        // Page number
        Row() {
          Text('— ')
            .fontSize(10)
            .fontColor('#B8A692')
          Text(`${this.currentPage + 1}`)
            .fontSize(12)
            .fontColor('#8B7355')
            .fontStyle(FontStyle.Italic)
          Text(' —')
            .fontSize(10)
            .fontColor('#B8A692')
        }
        .position({ x: '42%', y: '98%' })
      }
      .width('94%')
      .height('96%')
      .position({ x: '4%', y: '2%' })
      .gesture(
        PanGesture({ direction: PanDirection.Horizontal })
          .onActionEnd((event: GestureEvent) => {
            if (event.offsetX < -80 && this.currentPage < this.totalPages - 1) {
              this.handleNextPage()
            } else if (event.offsetX > 80 && this.currentPage > 0) {
              this.handlePrevPage()
            }
          })
      )
    }
    .width('100%')
    .layoutWeight(1)
    .padding({ left: 4, right: 8 })
    .opacity(this.gridOpacity)
    .translate({ y: this.gridTranslateY })
  }

  @Builder
  SpecimenCard(plant: PlantInfo, index: number) {
    Column({ space: 6 }) {
      Stack() {
        Column()
          .width('94%')
          .aspectRatio(1)
          .borderRadius(4)
          .backgroundColor('#A67C52')
          .shadow({ radius: 6, color: 'rgba(90, 60, 30, 0.25)', offsetY: 3 })

        Column()
          .width('88%')
          .aspectRatio(1)
          .borderRadius(2)
          .backgroundColor('#FDF8F0')
          .border({ width: 1, color: '#D4C4A8' })

        Stack() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#FAF6ED')

          Image(plant.LocalUrl || plant.ImageUrl)
            .alt($r('app.media.startIcon'))
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
            .syncLoad(false)
            .interpolation(ImageInterpolation.Medium)
            .sourceSize({ width: 280, height: 280 })

          this.PhotoCorners()

          Row() {
            Text(`#${(this.currentPage * this.itemsPerPage + index + 1).toString().padStart(3, '0')}`)
              .fontSize(8)
              .fontColor('#8B7355')
          }
          .padding({ left: 4, right: 4, top: 2, bottom: 2 })
          .backgroundColor('rgba(253, 248, 240, 0.9)')
          .border({ width: 1, color: '#D4C4A8' })
          .position({ right: 4, bottom: 4 })
        }
        .width('80%')
        .aspectRatio(1)
        .clip(true)
      }
      .width('100%')
      .alignContent(Alignment.Center)

      Column({ space: 2 }) {
        Text(plant.Name)
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor('#4A3728')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Center)
          .width('100%')

        Row()
          .width(20)
          .height(1)
          .backgroundColor('#C9A66B')
          .opacity(0.6)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ left: 4, right: 4 })
    }
    .width('100%')
    .padding(6)
    .borderRadius(6)
    .backgroundColor('rgba(253, 248, 240, 0.7)')
    .border({ width: 1, color: 'rgba(201, 166, 107, 0.4)' })
    .opacity(this.cardsVisible ? 1 : 0)
    .translate({ y: this.cardsVisible ? 0 : 16 })
    .animation({ duration: 350, curve: Curve.EaseOut, delay: index * 40 })
    .stateStyles({
      pressed: {
        .scale({ x: 0.96, y: 0.96 })
        .backgroundColor('rgba(253, 248, 240, 0.9)')
      },
      normal: { .scale({ x: 1, y: 1 }) }
    })
    .onClick(() => this.onPlantClick?.(plant.InfoCode))
  }

  @Builder
  PhotoCorners() {
    Row().width(12).height(12).backgroundColor('#C9A66B').opacity(0.7).position({ left: 0, top: 0 })
    Row().width(12).height(12).backgroundColor('#C9A66B').opacity(0.7).position({ right: 0, top: 0 })
    Row().width(12).height(12).backgroundColor('#C9A66B').opacity(0.7).position({ left: 0, bottom: 0 })
    Row().width(12).height(12).backgroundColor('#C9A66B').opacity(0.7).position({ right: 0, bottom: 0 })
  }

  @Builder
  PaginationSection() {
    Row({ space: 16 }) {
      this.PageButton('◀', this.currentPage == 0, (): void => this.handlePrevPage())

      Row({ space: 6 }) {
        ForEach(this.getPageChips(), (page: number) => {
          if (page === -1) {
            Text('···')
              .fontSize(14)
              .fontColor('#8B7355')
          } else {
            this.PageChip(page)
          }
        })
      }

      this.PageButton('▶', this.currentPage < this.totalPages - 1, (): void => this.handleNextPage())
    }
    .width('100%')
    .height(64)
    .padding({ left: 16, right: 16 })
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor('rgba(210, 180, 140, 0.5)')
    .border({ width: { top: 2 }, color: '#C9A66B' })
    .shadow({ radius: 8, color: 'rgba(90, 60, 30, 0.1)', offsetY: -2 })
    .opacity(this.paginationOpacity)
  }

  @Builder
  PageButton(icon: string, enabled: boolean, action: () => void) {
    Row() {
      Text(icon)
        .fontSize(16)
        .fontColor(enabled ? '#5D4E37' : '#B8A692')
    }
    .width(40)
    .height(34)
    .borderRadius(4)
    .backgroundColor(enabled ? 'rgba(201, 166, 107, 0.4)' : 'rgba(201, 166, 107, 0.15)')
    .border({ width: 1, color: enabled ? '#C9A66B' : 'rgba(201, 166, 107, 0.3)' })
    .justifyContent(FlexAlign.Center)
    .opacity(enabled ? 1 : 0.5)
    .stateStyles({
      pressed: { .scale({ x: 0.94, y: 0.94 }) },
      normal: { .scale({ x: 1, y: 1 }) }
    })
    .onClick(() => { if (enabled) action() })
  }

  @Builder
  PageChip(page: number) {
    Row() {
      Text(`${page + 1}`)
        .fontSize(13)
        .fontWeight(page === this.currentPage ? FontWeight.Medium : FontWeight.Regular)
        .fontColor(page === this.currentPage ? '#FDF8F0' : '#5D4E37')
    }
    .width(page === this.currentPage ? 32 : 26)
    .height(page === this.currentPage ? 32 : 26)
    .borderRadius(4)
    .backgroundColor(page === this.currentPage ? '#8B5A2B' : 'rgba(201, 166, 107, 0.25)')
    .border({ width: 1, color: page === this.currentPage ? '#6B4423' : 'rgba(201, 166, 107, 0.4)' })
    .justifyContent(FlexAlign.Center)
    .animation({ duration: 250, curve: Curve.EaseOut })
    .onClick(() => this.handlePageClick(page))
  }

  getPageChips(): number[] {
    const total = this.totalPages
    const current = this.currentPage

    if (total <= 5) {
      const pages: number[] = []
      for (let i = 0; i < total; i++) {
        pages.push(i)
      }
      return pages
    }

    if (current <= 2) {
      return [0, 1, 2, -1, total - 1]
    } else if (current >= total - 3) {
      return [0, -1, total - 3, total - 2, total - 1]
    } else {
      return [0, -1, current, -1, total - 1]
    }
  }
}
