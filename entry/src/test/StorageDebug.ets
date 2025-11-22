import { PlantStorage } from '../main/ets/database/PlantDatabase';
import { common } from '@kit.AbilityKit';

export class StorageDebug {
  /**
   * Print all plants in storage
   */
  static async printAllPlants(context: common.UIAbilityContext): Promise<void> {
    console.info('========== Storage Debug Start ==========');

    try {
      await PlantStorage.init(context);
      const plants = await PlantStorage.getAllPlants();

      console.info(`📊 Total plants in storage: ${plants.length}`);

      if (plants.length === 0) {
        console.info('❌ Storage is empty');
      } else {
        plants.forEach((plant, index) => {
          console.info(`\n--- Plant #${index + 1} ---`);
          console.info(`InfoCode: ${plant.InfoCode}`);
          console.info(`Name: ${plant.Name}`);
          console.info(`LatinName: ${plant.LatinName}`);
          console.info(`Score: ${plant.Score}`);
          console.info(`Family: ${plant.Family}`);
          console.info(`Genus: ${plant.Genus}`);
          console.info(`LocalUrl: ${plant.LocalUrl || 'N/A'}`);
          console.info(`AliasName: ${plant.AliasName || 'N/A'}`);
        });
      }

      console.info('\n========== Storage Debug End ==========');
    } catch (err) {
      console.error('❌ Debug failed:', JSON.stringify(err));
    }
  }

  /**
   * Clear all plants from storage
   */
  static async clearAll(context: common.UIAbilityContext): Promise<void> {
    console.info('🗑️ Clearing all storage...');

    try {
      await PlantStorage.init(context);
      const plants = await PlantStorage.getAllPlants();

      for (const plant of plants) {
        await PlantStorage.deletePlant(plant.InfoCode);
      }

      console.info(`✅ Cleared ${plants.length} plants`);
    } catch (err) {
      console.error('❌ Clear failed:', JSON.stringify(err));
    }
  }
}