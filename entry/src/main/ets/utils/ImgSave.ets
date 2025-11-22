import { fileIo } from '@kit.CoreFileKit';
import { ImageUtils } from './ImageUtils';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';

export class ImgSave {
  /**
   * Save image to app's local files directory
   * @param sourceUri - Original image URI from picker/camera
   * @param context - Application context (get from UIAbility)
   * @returns Local file URI of saved image
   */
  static async saveImage(sourceUri: string, context: common.UIAbilityContext): Promise<string> {
    try {
      // 1. Get app's files directory
      const filesDir = context.filesDir;
      const timestamp = Date.now();
      const fileName = `plant_${timestamp}.jpg`;
      const destPath = `${filesDir}/${fileName}`;

      console.info(`Saving image to: ${destPath}`);

      // 2. Open source file
      const sourceFile = fileIo.openSync(sourceUri, fileIo.OpenMode.READ_ONLY);

      // 3. Create ImageSource and decode to PixelMap
      const imageSource = image.createImageSource(sourceFile.fd);
      const pixelMap = await imageSource.createPixelMap({
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888
      });

      // 4. Pack to JPEG
      const imagePacker = image.createImagePacker();
      const packOpts: image.PackingOption = {
        format: 'image/jpeg',
        quality: 90
      };
      const arrayBuffer = await imagePacker.packing(pixelMap, packOpts);

      // 5. Write to destination
      const destFile = fileIo.openSync(destPath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      fileIo.writeSync(destFile.fd, arrayBuffer);

      // 6. Cleanup
      fileIo.closeSync(sourceFile);
      fileIo.closeSync(destFile);
      pixelMap.release();
      imagePacker.release();
      imageSource.release();

      console.info(`✅ Image saved successfully: ${destPath}`);
      return `file://${destPath}`;

    } catch (err) {
      console.error('❌ Save image failed:', JSON.stringify(err));
      throw new Error('图片保存失败');
    }
  }

  /**
   * Delete saved image
   * @param imageUri - Local file URI to delete
   */
  static deleteImage(imageUri: string): void {
    try {
      if (fileIo.accessSync(imageUri)) {
        fileIo.unlinkSync(imageUri);
        console.info(`🗑️ Image deleted: ${imageUri}`);
      }
    } catch (err) {
      console.error('Delete image failed:', JSON.stringify(err));
    }
  }

  /**
   * Check if file exists
   */
  static fileExists(imageUri: string): boolean {
    try {
      return fileIo.accessSync(imageUri);
    } catch {
      return false;
    }
  }
}