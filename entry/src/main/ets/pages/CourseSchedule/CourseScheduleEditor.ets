/**
 * CourseScheduleEditor - 课程表列表页
 *
 * 功能：
 * - 按星期分组展示课程
 * - 每门课显示星期+节次+名称+教师+地点+周次
 * - 编辑：跳转 CourseDetail 子页面
 * - 删除：直接删除
 * - 添加：跳转 CourseDetail 子页面
 */

import { PreferencesUtil } from '../../common/utils/PreferencesUtil';
import { LogUtils } from '../../common/utils/LogUtils';
import { CourseDataManager } from '../../common/utils/CourseDataManager';
import { common } from '@kit.AbilityKit';

const TAG = 'CourseScheduleEditor';

export interface TempCourse {
  id: number;
  courseName: string;
  teacher: string;
  location: string;
  timeSlot: string;
  dayOfWeek: number;
  weeks: string;
}

const DAY_LABELS: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

interface CourseDetailParam {
  mode: string;
  id?: number;
  courseName?: string;
  teacher?: string;
  location?: string;
  timeSlot?: string;
  dayOfWeek?: number;
  weeks?: string;
}

@Builder
export function CourseScheduleEditorBuilder(name: string, param: string) {
  CourseScheduleEditor()
}

@Component
export struct CourseScheduleEditor {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;

  @State courses: TempCourse[] = [];
  @State version: number = 0;

  aboutToAppear(): void {
    const dm: Object | undefined = AppStorage.get('darkModeEnabled');
    if (dm !== undefined) {
      this.darkModeEnabled = dm as boolean;
    }
    this.loadCourses();
  }

  onPageShow(): void {
    setTimeout(() => {
      const saved: Object | undefined = AppStorage.get('saved_courses');
      if (saved) {
        this.courses = JSON.parse(saved as string) as TempCourse[];
        this.version++;
      }
    }, 50);
  }

  async loadCourses(): Promise<void> {
    try {
      const context: common.Context = getContext(this);
      const data: string | null = await PreferencesUtil.getCustom(context, 'saved_courses');
      if (data) {
        AppStorage.setOrCreate('saved_courses', data);
        this.courses = JSON.parse(data) as TempCourse[];
      } else {
        this.courses = CourseDataManager.getDefaultCourses();
        CourseDataManager.save(context, this.courses);
      }
      this.version++;
    } catch (err) {
      LogUtils.error(TAG, '加载课程失败', err);
    }
  }

  saveCourses(): void {
    const context: common.Context = getContext(this);
    CourseDataManager.save(context, this.courses);
  }

  deleteCourse(id: number): void {
    const index: number = this.courses.findIndex((c: TempCourse) => c.id === id);
    if (index !== -1) {
      this.courses.splice(index, 1);
      this.courses = [...this.courses];
      this.version++;
      this.saveCourses();
    }
  }

  getCoursesForDay(day: number): TempCourse[] {
    return this.courses.filter((c: TempCourse) => c.dayOfWeek === day);
  }

  private openAddPage(): void {
    const params: CourseDetailParam = { mode: 'add' };
    this.navPathStack.pushPathByName('CourseDetail', params);
  }

  private openEditPage(course: TempCourse): void {
    const params: CourseDetailParam = {
      mode: 'edit',
      id: course.id,
      courseName: course.courseName,
      teacher: course.teacher,
      location: course.location,
      timeSlot: course.timeSlot,
      dayOfWeek: course.dayOfWeek,
      weeks: course.weeks
    };
    this.navPathStack.pushPathByName('CourseDetail', params);
  }

  build() {
    NavDestination() {
      Column() {
        // Status bar
        Column()
          .width('100%')
          .height(this.topRectHeight)
          .backgroundColor(this.darkModeEnabled ? '#16162A' : '#F5F7FA')

        // Title bar
        Row() {
          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontSize(24)
            .fontColor([$r('app.color.brand_primary')])
            .onClick(() => {
              this.navPathStack.pop();
            })
          Text('课程表')
            .fontSize($r('app.float.text_size_title_large'))
            .fontWeight(600)
            .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
            .margin({ left: 8 })
          Blank()
        }
        .width('100%')
        .height(56)
        .padding({ left: $r('app.float.spacing_lg'), right: $r('app.float.spacing_lg') })

        // Course list
        Scroll() {
          Column() {
            ForEach(DAY_LABELS, (dayLabel: string, index: number) => {
              Column() {
                // Day section header
                Row() {
                  Row() {
                    Text(dayLabel)
                      .fontSize(14)
                      .fontColor(Color.White)
                      .fontWeight(700)
                  }
                  .height(26)
                  .padding({ left: 14, right: 14 })
                  .backgroundColor($r('app.color.brand_primary'))
                  .borderRadius(13)
                  .alignItems(VerticalAlign.Center)
                  .justifyContent(FlexAlign.Center)
                  Blank()
                  Text(this.getCoursesForDay(index).length + '门课')
                    .fontSize(12)
                    .fontColor(this.darkModeEnabled ? '#a0a0b8' : '#86909C')
                }
                .width('100%')
                .margin({ top: 12, bottom: 8 })

                // Course cards for this day
                ForEach(this.getCoursesForDay(index), (course: TempCourse) => {
                  Column() {
                    // Top row: time badge + actions
                    Row() {
                      // Time slot badge only
                      Row() {
                        Text(course.timeSlot)
                          .fontSize(12)
                          .fontColor(Color.White)
                          .fontWeight(500)
                      }
                      .height(24)
                      .padding({ left: 10, right: 10 })
                      .backgroundColor($r('app.color.accent_orange'))
                      .borderRadius(12)
                      .margin({ left: 6 })
                      .alignItems(VerticalAlign.Center)
                      .justifyContent(FlexAlign.Center)

                      Blank()

                      // Edit button
                      Text('编辑')
                        .fontSize(13)
                        .fontColor($r('app.color.brand_primary'))
                        .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                        .borderRadius(4)
                        .backgroundColor('rgba(22, 119, 255, 0.08)')
                        .onClick(() => {
                          this.openEditPage(course);
                        })

                      // Delete button
                      Text('删除')
                        .fontSize(13)
                        .fontColor($r('app.color.accent_orange'))
                        .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                        .borderRadius(4)
                        .backgroundColor('rgba(255, 125, 0, 0.08)')
                        .margin({ left: 6 })
                        .onClick(() => {
                          this.deleteCourse(course.id);
                        })
                    }
                    .width('100%')

                    // Course name
                    Text(course.courseName)
                      .fontSize($r('app.float.text_size_body'))
                      .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                      .fontWeight(600)
                      .width('100%')
                      .margin({ top: 8 })

                    // Details: teacher | location | weeks
                    Text(course.teacher + ' | ' + course.location + ' | ' + course.weeks)
                      .fontSize($r('app.float.text_size_caption'))
                      .fontColor(this.darkModeEnabled ? '#a0a0b8' : '#86909C')
                      .width('100%')
                      .margin({ top: 4 })
                  }
                  .width('100%')
                  .padding(14)
                  .borderRadius($r('app.float.radius_md'))
                  .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
                  .margin({ bottom: 8 })
                  .shadow({
                    radius: 4,
                    color: 'rgba(0, 0, 0, 0.04)',
                    offsetX: 0,
                    offsetY: 1
                  })
                }, (course: TempCourse) => course.id.toString() + '_' + this.version)

                if (this.getCoursesForDay(index).length === 0) {
                  Text('暂无课程')
                    .fontSize($r('app.float.text_size_caption'))
                    .fontColor(this.darkModeEnabled ? '#6a6a8e' : '#86909C')
                    .height(32)
                    .margin({ bottom: 8 })
                }
              }
              .width('100%')
            }, (dayLabel: string) => dayLabel)

            // Add course button
            Button('+ 添加课程')
              .width('100%')
              .height(48)
              .fontSize($r('app.float.text_size_body'))
              .fontColor(Color.White)
              .backgroundColor($r('app.color.brand_primary'))
              .borderRadius($r('app.float.radius_md'))
              .margin({ top: 4, bottom: 24 })
              .onClick(() => {
                this.openAddPage();
              })
          }
          .width('100%')
          .padding({ left: 20, right: 20, bottom: 8 })
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.darkModeEnabled ? '#1A1A2E' : '#F5F7FA')
    }
    .hideBackButton(true)
    .onReady((ctx: NavDestinationContext) => {
      this.navPathStack = ctx.pathStack;
    })
  }
}
