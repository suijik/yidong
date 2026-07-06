/**
 * NotificationUtil - 通知推送工具
 *
 * HarmonyOS NEXT API 20 — @ohos.notificationManager
 * 简化版：直接使用 publish 发布通知
 */

import notificationManager from '@ohos.notificationManager';
import { common } from '@kit.AbilityKit';

const TAG = 'NotificationUtil';

export class NotificationUtil {
  private static isInitialized: boolean = false;
  private static context: common.Context | null = null;

  /**
   * 初始化通知模块
   */
  static async init(context: common.Context): Promise<void> {
    NotificationUtil.context = context;
    if (NotificationUtil.isInitialized) {
      return;
    }
    try {
      NotificationUtil.isInitialized = true;
      console.info(TAG, '通知模块初始化完成');
    } catch (err) {
      console.error(TAG, '通知初始化失败: ' + JSON.stringify(err));
    }
  }

  /**
   * 请求通知权限（系统弹窗）
   */
  static async requestPermission(): Promise<boolean> {
    try {
      await notificationManager.requestEnableNotification();
      console.info(TAG, '通知权限已请求');
      return true;
    } catch (err) {
      console.error(TAG, '请求通知权限失败: ' + JSON.stringify(err));
      return false;
    }
  }

  /**
   * 发布课程提醒通知
   */
  static async publishCourseReminder(
    courseName: string,
    time: string,
    location: string
  ): Promise<void> {
    const request = {
      id: Date.now(),
      content: {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: '课程提醒',
          text: courseName + ' · ' + time + ' · ' + location
        }
      }
    } as notificationManager.NotificationRequest;
    await NotificationUtil.publish(request);
  }

  /**
   * 发布待办提醒通知
   */
  static async publishTodoReminder(
    title: string,
    deadline: string,
    todoId: number
  ): Promise<void> {
    const request = {
      id: todoId,
      content: {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: '待办提醒',
          text: title + ' · 截止: ' + deadline
        }
      }
    } as notificationManager.NotificationRequest;
    await NotificationUtil.publish(request);
  }

  /**
   * 发布通用通知
   */
  static async publishGeneralNotification(
    title: string,
    text: string
  ): Promise<void> {
    const request = {
      id: Date.now(),
      content: {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: title,
          text: text
        }
      }
    } as notificationManager.NotificationRequest;
    await NotificationUtil.publish(request);
  }

  /**
   * 取消通知
   */
  static async cancelNotification(notificationId: number): Promise<void> {
    try {
      await notificationManager.cancel(notificationId);
    } catch (err) {
      console.error(TAG, '取消通知失败: ' + JSON.stringify(err));
    }
  }

  /**
   * 发布通知（内部）
   */
  private static async publish(
    request: notificationManager.NotificationRequest
  ): Promise<void> {
    try {
      await notificationManager.publish(request);
      console.info(TAG, '通知发布成功');
    } catch (err) {
      console.error(TAG, '通知发布失败: ' + JSON.stringify(err));
    }
  }
}
