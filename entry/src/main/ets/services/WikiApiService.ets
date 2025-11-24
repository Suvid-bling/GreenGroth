import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { WikiApiResponse, PlantWikiInfo } from '../models/PlantWikiInfo';
import { PlantWikiStorage } from '../database/PlantWikiStorage';

const HOST = 'http://plantgw.nongbangzhu.cn';
const PATH = '/plant/info';
const APPCODE = '0d2e43e575d94b12a01f0cae13459521';

export class WikiApiService {

  private static async callApi(infoCode: string): Promise<WikiApiResponse> {
    return new Promise((resolve, reject) => {
      const httpRequest = http.createHttp();
      const requestData = `code=${encodeURIComponent(infoCode)}`;

      httpRequest.request(HOST + PATH, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': `APPCODE ${APPCODE}`,
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        },
        extraData: requestData,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 30000,
        readTimeout: 30000
      }, (err: BusinessError, data: http.HttpResponse) => {
        if (!err && data.responseCode === 200) {
          try {
            const jsonString = data.result as string;
            console.info(`📄 Raw JSON: ${jsonString}`);

            const result = JSON.parse(jsonString) as WikiApiResponse;
            console.info(`✅ Status: ${result.status}, Name: ${result.result?.nameStd}`);
            console.info(`📊 Full Result: ${JSON.stringify(result.result)}`);

            httpRequest.destroy();
            resolve(result);
          } catch (parseErr) {
            httpRequest.destroy();
            reject(new Error('解析响应失败'));
          }
        } else {
          httpRequest.destroy();
          reject(new Error(`请求失败: ${data?.responseCode}`));
        }
      });
    });
  }

  static async fetchAndSaveWiki(infoCode: string): Promise<PlantWikiInfo | null> {

    try {
      const existing = await PlantWikiStorage.getWiki(infoCode);
      if (existing) return existing;

      const apiResponse = await WikiApiService.callApi(infoCode);
      if (apiResponse.status !== 0 || !apiResponse.result) return null;

      await PlantWikiStorage.saveWiki(infoCode, apiResponse.result);
      console.info(`💾 Wiki saved: ${apiResponse.result.nameStd}`);

      return apiResponse.result;
    } catch (err) {
      console.error('❌ Fetch wiki failed:', JSON.stringify(err));
      return null;
    }
  }
}