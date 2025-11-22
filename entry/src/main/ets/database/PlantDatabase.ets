import { preferences } from '@kit.ArkData';
import { PlantInfo } from '../models/PlantInfo';
import { common } from '@kit.AbilityKit';

const PREF_NAME = 'plant_records';
const KEY_PLANTS = 'saved_plants';

export class PlantStorage {
  private static pref: preferences.Preferences | null = null;

  static async init(context: common.UIAbilityContext): Promise<void> {
    PlantStorage.pref = await preferences.getPreferences(context, PREF_NAME);
    console.info('✅ Storage initialized');
  }

  static async savePlant(plant: PlantInfo): Promise<boolean> {
    if (!PlantStorage.pref) throw new Error('Storage not initialized');

    const plants = await PlantStorage.getAllPlants();

    // Check if InfoCode exists
    if (plants.some(p => p.InfoCode === plant.InfoCode)) {
      console.info(`Plant ${plant.InfoCode} already exists`);
      return false;
    }

    plants.push(plant);
    await PlantStorage.pref.put(KEY_PLANTS, JSON.stringify(plants));
    await PlantStorage.pref.flush();
    console.info(`✅ Saved: ${plant.Name}`);
    return true;
  }

  static async getAllPlants(): Promise<PlantInfo[]> {
    if (!PlantStorage.pref) throw new Error('Storage not initialized');

    const data = await PlantStorage.pref.get(KEY_PLANTS, '[]');
    return JSON.parse(data as string) as PlantInfo[];
  }

  static async deletePlant(infoCode: string): Promise<boolean> {
    if (!PlantStorage.pref) throw new Error('Storage not initialized');

    const plants = await PlantStorage.getAllPlants();
    const filtered = plants.filter(p => p.InfoCode !== infoCode);

    await PlantStorage.pref.put(KEY_PLANTS, JSON.stringify(filtered));
    await PlantStorage.pref.flush();
    console.info(`🗑️ Deleted: ${infoCode}`);
    return true;
  }
}