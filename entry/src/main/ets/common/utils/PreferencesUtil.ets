import { preferences } from '@kit.ArkData';
import { LogUtils } from './LogUtils';

const TAG = 'PreferencesUtil';

interface UserData {
  account: string;
  password: string;
}

export class PreferencesUtil {
  /**
   * 保存用户登录凭证
   */
  static async saveUser(context: Context, account: string, password: string): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(context, 'app_preferences');
      await dataPreferences.put('user_account', account);
      await dataPreferences.put('user_password', password);
      await dataPreferences.flush();
      LogUtils.info(TAG, '用户信息保存成功');
    } catch (err) {
      LogUtils.error(TAG, '保存用户信息失败', err);
    }
  }

  /**
   * 获取用户登录凭证
   */
  static async getUser(context: Context): Promise<UserData | null> {
    try {
      const dataPreferences = await preferences.getPreferences(context, 'app_preferences');
      const account = await dataPreferences.get('user_account', '');
      const password = await dataPreferences.get('user_password', '');
      if (!account) {
        return null;
      }
      return { account: account as string, password: password as string };
    } catch (err) {
      LogUtils.error(TAG, '获取用户信息失败', err);
      return null;
    }
  }

  /**
   * 清除用户登录凭证
   */
  static async removeUser(context: Context): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(context, 'app_preferences');
      await dataPreferences.delete('user_account');
      await dataPreferences.delete('user_password');
      await dataPreferences.flush();
      LogUtils.info(TAG, '用户信息清除成功');
    } catch (err) {
      LogUtils.error(TAG, '清除用户信息失败', err);
    }
  }

  /**
   * 保存记住密码
   */
  static async saveRememberedCredentials(context: Context, account: string, password: string): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(context, 'app_preferences');
      await dataPreferences.put('remember_account', account);
      await dataPreferences.put('remember_password', password);
      await dataPreferences.flush();
      LogUtils.info(TAG, '记住密码保存成功');
    } catch (err) {
      LogUtils.error(TAG, '保存记住密码失败', err);
    }
  }

  /**
   * 获取记住的密码
   */
  static async getRememberedCredentials(context: Context): Promise<UserData | null> {
    try {
      const dataPreferences = await preferences.getPreferences(context, 'app_preferences');
      const account = await dataPreferences.get('remember_account', '');
      const password = await dataPreferences.get('remember_password', '');
      if (!account) {
        return null;
      }
      return { account: account as string, password: password as string };
    } catch (err) {
      LogUtils.error(TAG, '获取记住密码失败', err);
      return null;
    }
  }

  /**
   * 清除记住的密码
   */
  static async clearRememberedCredentials(context: Context): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(context, 'app_preferences');
      await dataPreferences.delete('remember_account');
      await dataPreferences.delete('remember_password');
      await dataPreferences.flush();
      LogUtils.info(TAG, '记住密码清除成功');
    } catch (err) {
      LogUtils.error(TAG, '清除记住密码失败', err);
    }
  }

  /**
   * 获取自定义键值
   */
  static async getCustom(context: Context, key: string): Promise<string | null> {
    try {
      const dataPreferences = await preferences.getPreferences(context, 'app_preferences');
      const value = await dataPreferences.get(key, '');
      return value as string || null;
    } catch (err) {
      LogUtils.error(TAG, '获取自定义键值失败', err);
      return null;
    }
  }

  /**
   * 设置自定义键值
   */
  static async setCustom(context: Context, key: string, value: string): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(context, 'app_preferences');
      await dataPreferences.put(key, value);
      await dataPreferences.flush();
      LogUtils.info(TAG, '自定义键值保存成功: ' + key);
    } catch (err) {
      LogUtils.error(TAG, '保存自定义键值失败', err);
    }
  }
}
