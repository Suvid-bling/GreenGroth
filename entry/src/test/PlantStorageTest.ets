import { PlantStorage } from '../main/ets/database/PlantDatabase';
import { PlantInfo } from '../main/ets/models/PlantInfo';
import { common } from '@kit.AbilityKit';

export class PlantStorageTest {
  /**
   * Run all tests
   */
  static async runTests(context: common.UIAbilityContext): Promise<void> {
    console.info('========== PlantStorage Tests Start ==========');

    try {
      await PlantStorage.init(context);
      await PlantStorage.deletePlant('TEST001');
      await PlantStorageTest.testSavePlant();
      await PlantStorageTest.testDuplicateSave();
      await PlantStorageTest.testGetAllPlants();
      await PlantStorageTest.testDeletePlant();

      console.info('========== ✅ All Tests Passed ==========');
    } catch (err) {
      console.error('========== ❌ PlantStorageTest Failed ==========', JSON.stringify(err));
    }
  }

  /**
   * Test 1: Save new plant
   */
  private static async testSavePlant(): Promise<void> {
    const mockPlant: PlantInfo = {
      InfoCode: 'TEST001',
      Name: '测试植物',
      LatinName: 'Testus plantus',
      Score: '95',
      AliasName: '测试别名',
      AliasList: ['别名1', '别名2'],
      aliasList: ['alias1', 'alias2'],
      Family: '测试科',
      Genus: '测试属',
      ImageUrl: 'https://example.com/image.jpg',
      hyyy: '测试花语',
      LocalUrl: 'file:///test/path.jpg'
    };

    const saved = await PlantStorage.savePlant(mockPlant);
    if (saved) {
      console.info('✅ Test 1: Save plant - PASSED');
    } else {
      throw new Error('Test 1: Save plant - FAILED');
    }
  }

  /**
   * Test 2: Duplicate save should return false
   */
  private static async testDuplicateSave(): Promise<void> {
    const mockPlant: PlantInfo = {
      InfoCode: 'TEST001',
      Name: '测试植物',
      LatinName: 'Testus plantus',
      Score: '95',
      AliasName: '测试别名',
      AliasList: [],
      aliasList: [],
      Family: '测试科',
      Genus: '测试属',
      ImageUrl: 'https://example.com/image.jpg',
      hyyy: '测试花语',
      LocalUrl: ''
    };

    const saved = await PlantStorage.savePlant(mockPlant);
    if (!saved) {
      console.info('✅ Test 2: Duplicate prevention - PASSED');
    } else {
      throw new Error('Test 2: Duplicate prevention - FAILED');
    }
  }

  /**
   * Test 3: Get all plants
   */
  private static async testGetAllPlants(): Promise<void> {
    const plants = await PlantStorage.getAllPlants();
    if (plants.length > 0 && plants[0].InfoCode === 'TEST001') {
      console.info(`✅ Test 3: Get all plants - PASSED (${plants.length} plants)`);
    } else {
      throw new Error('Test 3: Get all plants - FAILED');
    }
  }

  /**
   * Test 4: Delete plant
   */
  private static async testDeletePlant(): Promise<void> {
    await PlantStorage.deletePlant('TEST001');
    const plants = await PlantStorage.getAllPlants();

    if (plants.length === 0) {
      console.info('✅ Test 4: Delete plant - PASSED');
    } else {
      throw new Error('Test 4: Delete plant - FAILED');
    }
  }
}