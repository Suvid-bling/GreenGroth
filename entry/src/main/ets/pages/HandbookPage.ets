import { router } from '@kit.ArkUI';
import { PlantStorage } from '../database/PlantDatabase';
import { PlantInfo } from '../models/PlantInfo';
import { common } from '@kit.AbilityKit';
import { HandbookPageLayout } from '../../layout/pages/HandBookPageLayout';

@Entry
@Component
struct HandbookPage {
  @State plants: PlantInfo[] = []
  @State currentPage: number = 0
  @State itemsPerPage: number = 12
  @State totalPages: number = 0
  private scroller: Scroller = new Scroller()

  async aboutToAppear() {
    await this.loadPlants()
  }

  build() {
    Column() {
      HandbookPageLayout({
        plants: $plants,
        currentPage: $currentPage,
        totalPages: this.totalPages,
        itemsPerPage: this.itemsPerPage,
        scroller: this.scroller,
        onBackClick: (): void => this.handleBack(),
        onPlantClick: (infoCode: string): void => this.handlePlantClick(infoCode),
        onPrevPage: (): void => this.handlePrevPage(),
        onNextPage: (): void => this.handleNextPage()
      })
    }
    .width('100%')
    .height('100%')
  }

  // ==================== Backend Logic ====================

  /**
   * Load all plants from storage
   */
  async loadPlants() {
    try {
      const context = getContext(this) as common.UIAbilityContext
      await PlantStorage.init(context)
      this.plants = await PlantStorage.getAllPlants()
      this.totalPages = Math.ceil(this.plants.length / this.itemsPerPage)
      console.info(`📚 Loaded ${this.plants.length} plants, ${this.totalPages} pages`)
    } catch (err) {
      console.error('Failed to load plants:', JSON.stringify(err))
    }
  }

  /**
   * Navigate back
   */
  handleBack() {
    router.back()
  }

  /**
   * Navigate to plant wiki page
   */
  handlePlantClick(infoCode: string) {
    router.pushUrl({
      url: 'pages/WikiPage',
      params: { infoCode: infoCode }
    }).catch((err: Error) => {
      console.error('Navigation error:', err.message)
    })
  }

  /**
   * Go to previous page
   */
  handlePrevPage() {
    if (this.currentPage > 0) {
      this.currentPage--
    }
  }

  /**
   * Go to next page
   */
  handleNextPage() {
    if (this.currentPage < this.totalPages - 1) {
      this.currentPage++
    }
  }
}