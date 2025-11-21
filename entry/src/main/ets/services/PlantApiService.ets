import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ApiResponse, PlantInfo } from '../models/PlantInfo';

const HOST = 'http://plantgw.nongbangzhu.cn';
const PATH = '/plant/recognize2';
const APPCODE = '0d2e43e575d94b12a01f0cae13459521';

export class PlantApiService {
  /**
   * 1. API handle function
   */
  private static async callApi(imgBase64: string): Promise<ApiResponse> {
    return new Promise((resolve, reject) => {
      const httpRequest = http.createHttp();
      const requestData = `img_base64=${encodeURIComponent(imgBase64)}`;

      console.log('Request data length:', requestData.length);

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
        console.log('Response code:', data?.responseCode);

        if (!err && data.responseCode === 200) {
          try {
            const result = JSON.parse(data.result as string) as ApiResponse;
            console.log('✅ API Result:', JSON.stringify(result));
            httpRequest.destroy();
            resolve(result);
          } catch (parseErr) {
            console.error('❌ 解析失败:', parseErr);
            httpRequest.destroy();
            reject(new Error('解析响应失败'));
          }
        } else {
          console.error('❌ 失败:', data?.result);
          httpRequest.destroy();
          reject(new Error(`请求失败: ${data?.responseCode}`));
        }
      });
    });
  }

  /**
   * 2. Response clean function
   */
  private static cleanResponse(response: ApiResponse): PlantInfo | null {
    if (response.Status !== 0 || !response.Result || response.Result.length === 0) {
      return null;
    }

    const topResult = response.Result[0];
    const score = parseFloat(topResult.Score);

    if (score < 50) {
      return null;
    }

    return topResult;
  }

  /**
   * 3. Manage function
   */
  static async recognizePlant(imgBase64: string): Promise<PlantInfo> {
    const apiResponse = await PlantApiService.callApi(imgBase64); // 显式类名
    const cleanedResult = PlantApiService.cleanResponse(apiResponse); //

    if (!cleanedResult) {
      throw new Error('无法识别该植物');

    }

    return cleanedResult;
  }
}