/**
 * CourseScheduleView - 课程表视图组件
 *
 * 独立 @Component，通过 @Prop/@Link 接收数据，保证响应式重渲染。
 * 替代 main.ets 中不稳定的 @Builder 方案。
 */
import { CourseDataManager, CourseData } from '../../common/utils/CourseDataManager';

@Component
export struct CourseScheduleView {
  @Prop allCourses: CourseData[] = [];
  @Link currentWeek: number;
  @Prop coursesVersion: number = 0;
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;
  navPathStack: NavPathStack = new NavPathStack();

  getWeekCourses(): CourseData[] {
    return this.allCourses.filter((c: CourseData) =>
      CourseDataManager.isCourseInWeek(c.weeks, this.currentWeek)
    );
  }

  getDayLabel(day: number): string {
    return CourseDataManager.getDayLabel(day);
  }

  build() {
    Column() {
      // Week selector
      Row() {
        Text('〈')
          .fontSize($r('app.float.text_size_body'))
          .fontColor($r('app.color.brand_primary'))
          .onClick(() => {
            if (this.currentWeek > 1) {
              this.currentWeek--;
            }
          })

        Blank()

        Text('2025-2026 第' + this.currentWeek + '周')
          .fontSize($r('app.float.text_size_body'))
          .fontColor($r('app.color.text_primary'))
          .fontWeight(500)

        Blank()

        Text('〉')
          .fontSize($r('app.float.text_size_body'))
          .fontColor($r('app.color.brand_primary'))
          .onClick(() => {
            if (this.currentWeek < 20) {
              this.currentWeek++;
            }
          })
      }
      .width('100%')
      .height(44)
      .padding({ left: $r('app.float.spacing_px'), right: $r('app.float.spacing_px') })
      .margin({ top: $r('app.float.spacing_px'), bottom: $r('app.float.spacing_px') })

      // Force re-render when allCourses or coursesVersion changes
      // (allCourses drives getWeekCourses(), coursesVersion drives ForEach key)
      Text(this.allCourses.length + '_' + this.coursesVersion)
        .visibility(Visibility.None)
        .height(0)
        .width(0)

      // Course cards for current week
      ForEach(this.getWeekCourses(), (course: CourseData) => {
        Row() {
          // Day badge
          Column() {
            Text(this.getDayLabel(course.dayOfWeek))
              .fontSize($r('app.float.text_size_caption'))
              .fontColor(Color.White)
              .fontWeight(600)
          }
          .width(56)
          .height(28)
          .backgroundColor($r('app.color.brand_primary'))
          .borderRadius(14)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)

          // Time slot badge
          Column() {
            Text(course.timeSlot)
              .fontSize($r('app.float.text_size_caption'))
              .fontColor(Color.White)
              .fontWeight(500)
          }
          .width(56)
          .height(28)
          .backgroundColor($r('app.color.accent_orange'))
          .borderRadius(14)
          .margin({ left: 6 })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Column() {
            Text(course.courseName)
              .fontSize($r('app.float.text_size_body'))
              .fontColor($r('app.color.text_primary'))
              .fontWeight(500)
            Text(course.location + ' | ' + course.teacher)
              .fontSize($r('app.float.text_size_caption'))
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 2 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .margin({ left: $r('app.float.spacing_px') })
        }
        .width('100%')
        .padding($r('app.float.spacing_px'))
        .borderRadius(8)
        .backgroundColor('rgba(22, 119, 255, 0.03)')
        .margin({ bottom: 8 })
      }, (course: CourseData) => course.id.toString() + '_' + this.coursesVersion)

      if (this.getWeekCourses().length === 0) {
        Text('本周暂无课程')
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.text_secondary'))
          .height(40)
          .width('100%')
          .textAlign(TextAlign.Center)
      }

      // Edit schedule button
      Button('编辑课程表')
        .width('100%')
        .height(40)
        .fontSize($r('app.float.text_size_body'))
        .fontColor($r('app.color.brand_primary'))
        .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
        .borderRadius($r('app.float.radius_md'))
        .border({ width: 1, color: $r('app.color.brand_primary') })
        .margin({ top: $r('app.float.spacing_px') })
        .onClick(() => {
          this.navPathStack.pushPathByName('CourseScheduleEditor', null);
        })
    }
    .width('100%')
    .margin({ top: $r('app.float.spacing_px') })
  }
}
