/**
 * CourseDataManager - 课程数据统一管理工具
 *
 * 功能：
 * - 统一读写 AppStorage + Preferences
 * - 课程周次判断工具
 * - 消除 main.ets 和编辑器之间的数据不一致
 */
import { PreferencesUtil } from './PreferencesUtil';
import { LogUtils } from './LogUtils';
import { common } from '@kit.AbilityKit';

const TAG = 'CourseDataManager';
const APPSTORAGE_KEY: string = 'saved_courses';
const PREFERENCES_KEY: string = 'saved_courses';

export interface CourseData {
  id: number;
  courseName: string;
  teacher: string;
  location: string;
  timeSlot: string;
  dayOfWeek: number;
  weeks: string;
}

export class CourseDataManager {

  /**
   * 判断课程是否在指定周次
   */
  static isCourseInWeek(weeksStr: string, week: number): boolean {
    const clean: string = weeksStr.replace('周', '').trim();
    const rangeMatch = clean.match(/^(\d+)-(\d+)$/);
    if (rangeMatch) {
      const start: number = parseInt(rangeMatch[1]);
      const end: number = parseInt(rangeMatch[2]);
      return week >= start && week <= end;
    }
    const singleMatch = clean.match(/^(\d+)$/);
    if (singleMatch) {
      return parseInt(singleMatch[1]) === week;
    }
    return clean === '';
  }

  /**
   * 获取星期标签
   */
  static getDayLabel(day: number): string {
    const labels: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    return labels[day] || '周日';
  }

  /**
   * 从 AppStorage 同步加载课程（最快路径）
   */
  static loadFromAppStorage(): CourseData[] {
    const saved: Object | undefined = AppStorage.get(APPSTORAGE_KEY);
    if (saved) {
      try {
        return JSON.parse(saved as string) as CourseData[];
      } catch (err) {
        LogUtils.error(TAG, '解析 AppStorage 课程数据失败', err);
      }
    }
    return [];
  }

  /**
   * 从 Preferences 加载课程（持久回退），并同步到 AppStorage
   */
  static async loadFromPreferences(context: common.Context): Promise<CourseData[]> {
    try {
      const data: string | null = await PreferencesUtil.getCustom(context, PREFERENCES_KEY);
      if (data) {
        const courses: CourseData[] = JSON.parse(data) as CourseData[];
        AppStorage.setOrCreate(APPSTORAGE_KEY, data);
        return courses;
      }
    } catch (err) {
      LogUtils.error(TAG, '从 Preferences 加载课程失败', err);
    }
    return [];
  }

  /**
   * 保存课程到 AppStorage + Preferences
   */
  static save(context: common.Context, courses: CourseData[]): void {
    try {
      const json: string = JSON.stringify(courses);
      AppStorage.setOrCreate(APPSTORAGE_KEY, json);
      PreferencesUtil.setCustom(context, PREFERENCES_KEY, json);
      // Signal refresh to all watching pages
      AppStorage.set('courseRefreshVer', Date.now());
    } catch (err) {
      LogUtils.error(TAG, '保存课程失败', err);
    }
  }

  /**
   * 获取默认初始课程（仅编辑器首次使用）
   */
  static getDefaultCourses(): CourseData[] {
    return [
      { id: 1601, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1602, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1605, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1606, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1608, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', dayOfWeek: 5, weeks: '1-16周' }
    ];
  }
}
