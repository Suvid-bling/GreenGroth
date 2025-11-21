import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';

export class ImageUtils {
  /**
   * Process image: resize to 500x500, compress to JPEG, convert to base64
   * @param imagePath - Original image URI
   * @returns Base64 string without prefix
   */
  static async processImageToBase64(imagePath: string): Promise<string> {
    try {
      // 1. Open image file
      const file = fileIo.openSync(imagePath, fileIo.OpenMode.READ_ONLY);
      const imageSource = image.createImageSource(file.fd);

      // 2. Decode to PixelMap
      try {
        const pixelMap = await imageSource.createPixelMap({
          desiredSize: { width: 500, height: 500 },
          desiredPixelFormat: image.PixelMapFormat.RGB_888
        });
        console.debug("Actual PixelFormat:", pixelMap.getPixelFormat());
      } catch (err) {
        console.error("Format conversion failed:", err.code, err.message);
      }

      // 3. Pack to JPEG with 0.8 quality
      const imagePacker = image.createImagePacker();
      const packOpts: image.PackingOption = {
        format: 'image/jpeg',
        quality: 80  // 0.8 = 80%
      };

      const arrayBuffer = await imagePacker.packing(pixelMap, packOpts);

      // 4. Check size (should be < 512KB)
      if (arrayBuffer.byteLength > 512 * 1024) {
        console.warn('Image size exceeds 512KB:', arrayBuffer.byteLength);
      }

      // 5. Convert to Base64
      const uint8Array = new Uint8Array(arrayBuffer);
      const base64String = buffer.from(uint8Array).toString('base64');

      // 6. Remove prefix if exists
      const cleanBase64 = base64String.replace(/^data:image\/jpeg;base64,/, '');

      // Cleanup
      fileIo.closeSync(file);
      pixelMap.release();
      imagePacker.release();
      imageSource.release();

      return cleanBase64;

    } catch (err) {
      console.error('Image processing failed:', JSON.stringify(err));
      throw new Error('图片处理失败');
    }
  }

  /**
   * Get compressed image size in KB
   */
  static getBase64SizeKB(base64: string): number {
    return (base64.length * 0.75) / 1024;
  }
}