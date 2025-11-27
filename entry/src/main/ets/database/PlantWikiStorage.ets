import { preferences } from '@kit.ArkData';
import { PlantWikiInfo } from '../models/PlantWikiInfo';
import { common } from '@kit.AbilityKit';

const PREF_NAME = 'plant_wiki_records';
const KEY_WIKI = 'saved_wiki';

export class PlantWikiStorage {
  private static pref: preferences.Preferences | null = null;

  static async init(context: common.UIAbilityContext): Promise<void> {
    PlantWikiStorage.pref = await preferences.getPreferences(context, PREF_NAME);
    console.info('✅ Wiki storage initialized');
  }

  static async saveWiki(infoCode: string, wikiInfo: PlantWikiInfo): Promise<boolean> {
    if (!PlantWikiStorage.pref) throw new Error('Storage not initialized');

    const allWiki = await PlantWikiStorage.getAllWiki();

    if (allWiki[infoCode]) {
      console.info(`Wiki ${infoCode} already exists`);
      return false;
    }

    allWiki[infoCode] = wikiInfo;
    await PlantWikiStorage.pref.put(KEY_WIKI, JSON.stringify(allWiki));
    await PlantWikiStorage.pref.flush();
    console.info(`✅ Wiki saved: ${wikiInfo.nameStd}`);
    return true;
  }

  static async getWiki(infoCode: string): Promise<PlantWikiInfo | null> {
    if (!PlantWikiStorage.pref) throw new Error('Storage not initialized');

    const allWiki = await PlantWikiStorage.getAllWiki();
    return allWiki[infoCode] || null;
  }

  static async getAllWiki(): Promise<Record<string, PlantWikiInfo>> {
    if (!PlantWikiStorage.pref) throw new Error('Storage not initialized');

    const data = await PlantWikiStorage.pref.get(KEY_WIKI, '{}');
    return JSON.parse(data as string) as Record<string, PlantWikiInfo>;
  }

  static async deleteWiki(infoCode: string): Promise<boolean> {
    if (!PlantWikiStorage.pref) throw new Error('Storage not initialized');

    const allWiki = await PlantWikiStorage.getAllWiki();
    const filtered: Record<string, PlantWikiInfo> = {};

    Object.keys(allWiki).forEach((key: string) => {
      if (key !== infoCode) {
        filtered[key] = allWiki[key];
      }
    });

    await PlantWikiStorage.pref.put(KEY_WIKI, JSON.stringify(filtered));
    await PlantWikiStorage.pref.flush();
    console.info(`🗑️ Wiki deleted: ${infoCode}`);
    return true;
  }
}