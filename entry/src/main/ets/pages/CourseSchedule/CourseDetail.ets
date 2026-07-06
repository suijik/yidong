/**
 * CourseDetail - 课程添加/编辑子页面
 *
 * 功能：
 * - 添加新课程（填写表单后保存）
 * - 编辑现有课程（预填数据后保存）
 */

import { PreferencesUtil } from '../../common/utils/PreferencesUtil';
import { LogUtils } from '../../common/utils/LogUtils';
import { CourseDataManager } from '../../common/utils/CourseDataManager';
import { common } from '@kit.AbilityKit';
import { TempCourse } from './CourseScheduleEditor';

const TAG = 'CourseDetail';

const DAY_LABELS: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
const TIME_SLOTS: string[] = ['1-2节', '3-4节', '5-6节', '6-7节', '7-8节', '晚课'];

@Builder
export function CourseDetailBuilder(name: string, param: Object) {
  CourseDetail({ pageParam: param as Record<string, Object> })
}

@Component
export struct CourseDetail {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;
  pageParam: Record<string, Object> = {};

  @State courseName: string = '';
  @State teacher: string = '';
  @State location: string = '';
  @State timeSlot: string = '1-2节';
  @State dayOfWeek: number = 1;
  @State weeks: string = '1-16周';
  @State isEditMode: boolean = false;
  private editId: number = -1;

  aboutToAppear(): void {
    const dm: Object | undefined = AppStorage.get('darkModeEnabled');
    if (dm !== undefined) {
      this.darkModeEnabled = dm as boolean;
    }
    const mode: Object | undefined = this.pageParam['mode'];
    if (mode === 'edit') {
      this.isEditMode = true;
      this.editId = this.pageParam['id'] as number;
      this.courseName = this.pageParam['courseName'] as string;
      this.teacher = this.pageParam['teacher'] as string;
      this.location = this.pageParam['location'] as string;
      this.timeSlot = this.pageParam['timeSlot'] as string;
      this.dayOfWeek = this.pageParam['dayOfWeek'] as number;
      this.weeks = this.pageParam['weeks'] as string;
    }
  }

  async saveCourse(): Promise<void> {
    if (!this.courseName.trim()) {
      return;
    }
    try {
      const context: common.Context = getContext(this);
      const data: string | null = await PreferencesUtil.getCustom(context, 'saved_courses');
      let courses: TempCourse[] = [];
      if (data) {
        courses = JSON.parse(data) as TempCourse[];
      }
      if (this.isEditMode) {
        const index: number = courses.findIndex((c: TempCourse) => c.id === this.editId);
        if (index !== -1) {
          courses[index] = {
            id: this.editId,
            courseName: this.courseName.trim(),
            teacher: this.teacher.trim(),
            location: this.location.trim(),
            timeSlot: this.timeSlot,
            dayOfWeek: this.dayOfWeek,
            weeks: this.weeks.trim() || '1-16周'
          };
        }
      } else {
        const maxId: number = courses.reduce((max: number, c: TempCourse) => c.id > max ? c.id : max, 0);
        courses.push({
          id: maxId + 1,
          courseName: this.courseName.trim(),
          teacher: this.teacher.trim(),
          location: this.location.trim(),
          timeSlot: this.timeSlot,
          dayOfWeek: this.dayOfWeek,
          weeks: this.weeks.trim() || '1-16周'
        });
      }
      CourseDataManager.save(context, courses);
      this.navPathStack.pop();
    } catch (err) {
      LogUtils.error(TAG, '保存课程失败', err);
    }
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
          Text(this.isEditMode ? '编辑课程' : '添加课程')
            .fontSize($r('app.float.text_size_title_large'))
            .fontWeight(600)
            .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
            .margin({ left: 8 })
          Blank()
        }
        .width('100%')
        .height(56)
        .padding({ left: $r('app.float.spacing_lg'), right: $r('app.float.spacing_lg') })

        // Form
        Scroll() {
          Column() {
            // 课程名称
            Column() {
              Text('课程名称 *')
                .fontSize($r('app.float.text_size_body'))
                .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                .fontWeight(500)
                .width('100%')
                .margin({ bottom: 6 })
              TextInput({ placeholder: '请输入课程名称', text: this.courseName })
                .width('100%')
                .height(48)
                .placeholderColor($r('app.color.text_secondary'))
                .placeholderFont({ size: $r('app.float.text_size_body') })
                .padding({ left: 16, right: 16 })
                .borderRadius($r('app.float.radius_md'))
                .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
                .onChange((v: string) => { this.courseName = v; })
            }
            .width('100%')
            .margin({ top: 16 })

            // 授课教师
            Column() {
              Text('授课教师')
                .fontSize($r('app.float.text_size_body'))
                .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                .fontWeight(500)
                .width('100%')
                .margin({ bottom: 6 })
              TextInput({ placeholder: '请输入授课教师', text: this.teacher })
                .width('100%')
                .height(48)
                .placeholderColor($r('app.color.text_secondary'))
                .placeholderFont({ size: $r('app.float.text_size_body') })
                .padding({ left: 16, right: 16 })
                .borderRadius($r('app.float.radius_md'))
                .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
                .onChange((v: string) => { this.teacher = v; })
            }
            .width('100%')
            .margin({ top: 12 })

            // 上课地点
            Column() {
              Text('上课地点')
                .fontSize($r('app.float.text_size_body'))
                .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                .fontWeight(500)
                .width('100%')
                .margin({ bottom: 6 })
              TextInput({ placeholder: '请输入上课地点', text: this.location })
                .width('100%')
                .height(48)
                .placeholderColor($r('app.color.text_secondary'))
                .placeholderFont({ size: $r('app.float.text_size_body') })
                .padding({ left: 16, right: 16 })
                .borderRadius($r('app.float.radius_md'))
                .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
                .onChange((v: string) => { this.location = v; })
            }
            .width('100%')
            .margin({ top: 12 })

            // 上课周次
            Column() {
              Text('上课周次')
                .fontSize($r('app.float.text_size_body'))
                .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                .fontWeight(500)
                .width('100%')
                .margin({ bottom: 6 })
              TextInput({ placeholder: '如: 1-16周', text: this.weeks })
                .width('100%')
                .height(48)
                .placeholderColor($r('app.color.text_secondary'))
                .placeholderFont({ size: $r('app.float.text_size_body') })
                .padding({ left: 16, right: 16 })
                .borderRadius($r('app.float.radius_md'))
                .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
                .onChange((v: string) => { this.weeks = v; })
            }
            .width('100%')
            .margin({ top: 12 })

            // 上课星期
            Column() {
              Text('上课星期')
                .fontSize($r('app.float.text_size_body'))
                .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                .fontWeight(500)
                .width('100%')
                .margin({ bottom: 8 })
              Row() {
                ForEach([1, 2, 3, 4, 5], (day: number) => {
                  Text(DAY_LABELS[day])
                    .fontSize($r('app.float.text_size_body'))
                    .fontColor(this.dayOfWeek === day
                      ? Color.White
                      : (this.darkModeEnabled ? '#c0c0d8' : '#1D2129'))
                    .fontWeight(this.dayOfWeek === day ? 600 : 400)
                    .height(40)
                    .layoutWeight(1)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(this.dayOfWeek === day
                      ? $r('app.color.brand_primary')
                      : (this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA'))
                    .borderRadius(8)
                    .margin({ right: 6 })
                    .onClick(() => {
                      this.dayOfWeek = day;
                    })
                }, (day: number) => day.toString())
              }
              .width('100%')
            }
            .width('100%')
            .margin({ top: 12 })

            // 上课节次
            Column() {
              Text('上课节次')
                .fontSize($r('app.float.text_size_body'))
                .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                .fontWeight(500)
                .width('100%')
                .margin({ bottom: 8 })
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(TIME_SLOTS, (slot: string) => {
                  Text(slot)
                    .fontSize($r('app.float.text_size_body'))
                    .fontColor(this.timeSlot === slot
                      ? Color.White
                      : (this.darkModeEnabled ? '#c0c0d8' : '#1D2129'))
                    .fontWeight(this.timeSlot === slot ? 600 : 400)
                    .height(40)
                    .width(80)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(this.timeSlot === slot
                      ? $r('app.color.brand_primary')
                      : (this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA'))
                    .borderRadius(8)
                    .margin({ right: 8, bottom: 8 })
                    .onClick(() => {
                      this.timeSlot = slot;
                    })
                }, (slot: string) => slot)
              }
              .width('100%')
            }
            .width('100%')
            .margin({ top: 12 })

            // Action buttons
            Row() {
              Button('取消')
                .layoutWeight(1)
                .height(48)
                .fontSize($r('app.float.text_size_body'))
                .fontColor($r('app.color.text_secondary'))
                .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
                .borderRadius($r('app.float.radius_md'))
                .onClick(() => {
                  this.navPathStack.pop();
                })

              Button(this.isEditMode ? '保存修改' : '确认添加')
                .layoutWeight(1)
                .height(48)
                .fontSize($r('app.float.text_size_body'))
                .fontColor(Color.White)
                .backgroundColor($r('app.color.brand_primary'))
                .borderRadius($r('app.float.radius_md'))
                .margin({ left: 12 })
                .onClick(() => {
                  this.saveCourse();
                })
            }
            .width('100%')
            .margin({ top: 24, bottom: 24 })
          }
          .width('100%')
          .padding({ left: 20, right: 20 })
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
