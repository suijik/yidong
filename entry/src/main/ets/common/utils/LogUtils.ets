// common/utils/LogUtils.ets
import { hilog } from '@kit.PerformanceAnalysisKit';

// 统一配置：领域和日志前缀
const DOMAIN = 0x0000;
const GLOBAL_TAG = 'CampusAssistant';

/**
 * 日志工具类
 * 用法：
 *   LogUtils.info('StartPage', '页面加载成功');
 *   LogUtils.error('LoginPage', '登录失败', error);
 */
export class LogUtils {

  /**
   * 普通日志 (info 级别)
   * @param tag 标签（通常用页面名）
   * @param message 日志内容
   */
  static info(tag: string, message: string): void {
    hilog.info(DOMAIN, `${GLOBAL_TAG}:${tag}`, message);
  }

  /**
   * 带参数的 info 日志
   * @param tag 标签
   * @param format 格式化字符串，如 '用户ID: %{public}s'
   * @param args 参数
   */
  static infoFormat(tag: string, format: string, ...args: Object[]): void {
    hilog.info(DOMAIN, `${GLOBAL_TAG}:${tag}`, format, ...args);
  }

  /**
   * 调试日志 (debug 级别)
   */
  static debug(tag: string, message: string): void {
    hilog.debug(DOMAIN, `${GLOBAL_TAG}:${tag}`, message);
  }

  /**
   * 警告日志 (warn 级别)
   */
  static warn(tag: string, message: string): void {
    hilog.warn(DOMAIN, `${GLOBAL_TAG}:${tag}`, message);
  }

  /**
   * 错误日志 (error 级别)
   * @param tag 标签
   * @param message 错误消息
   * @param error 可选，错误对象
   */
  static error(tag: string, message: string, error?: Error | Object): void {
    if (error) {
      hilog.error(DOMAIN, `${GLOBAL_TAG}:${tag}`, '%{public}s, 详情: %{public}s', message, JSON.stringify(error));
    } else {
      hilog.error(DOMAIN, `${GLOBAL_TAG}:${tag}`, message);
    }
  }

  /**
   * 生命周期日志（专门用于跟踪组件生命周期）
   */
  static lifecycle(tag: string, method: string): void {
    hilog.info(DOMAIN, `${GLOBAL_TAG}:${tag}`, `🔄 [生命周期] ${method}`);
  }

  /**
   * 路由跳转日志
   */
  static navigation(tag: string, targetPage: string, status: string): void {
    hilog.info(DOMAIN, `${GLOBAL_TAG}:${tag}`, `🧭 [导航] 跳转到 ${targetPage} -> ${status}`);
  }
}