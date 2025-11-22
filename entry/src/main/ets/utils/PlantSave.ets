import { PlantStorage } from '../database/PlantDatabase';
import { ImgSave } from './ImgSave';
import { PlantInfo } from '../models/PlantInfo';
import { common } from '@kit.AbilityKit';

export class PlantSave {
  /**
   * Check if InfoCode exists in storage
   */
  static async checkExists(infoCode: string): Promise<boolean> {
    const allPlants = await PlantStorage.getAllPlants();
    return allPlants.some(p => p.InfoCode === infoCode);
  }

  /**
   * Save image and add LocalUrl to result
   */
  static async saveImageAndAddUrl(
    plant: PlantInfo,
    sourceImageUri: string,
    context: common.UIAbilityContext
  ): Promise<PlantInfo> {
    const localUri = await ImgSave.saveImage(sourceImageUri, context);
    plant.LocalUrl = localUri;
    console.info(`📷 Image saved: ${localUri}`);
    return plant;
  }

  /**
   * Save plant info to storage
   */
  static async saveToStorage(plant: PlantInfo): Promise<boolean> {
    const saved = await PlantStorage.savePlant(plant);
    if (saved) {
      console.info(`💾 Plant saved: ${plant.Name} (${plant.InfoCode})`);
    }
    return saved;
  }

  /**
   * Manage: check, save image if new, save to storage
   */
  static async processPlant(
    plant: PlantInfo,
    sourceImageUri: string,
    context: common.UIAbilityContext
  ): Promise<PlantInfo> {
    const exists = await PlantSave.checkExists(plant.InfoCode);

    if (!exists) {
      await PlantSave.saveImageAndAddUrl(plant, sourceImageUri, context);
      await PlantSave.saveToStorage(plant);
    } else {
      console.info(`ℹ️ Plant already exists: ${plant.InfoCode}`);
    }

    return plant;
  }
}