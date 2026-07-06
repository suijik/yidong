import { LogUtils } from '../../common/utils/LogUtils';
import { CampusNewsItem } from '../../model/CampusNews';
import { CourseItem } from '../../model/Course';
import { WeatherData } from '../../model/Weather';
import { QuickEntryItem } from '../../model/QuickEntry';
import {
  MOCK_ANNOUNCEMENTS, MOCK_WEATHER, MOCK_QUICK_ENTRIES,
  MOCK_CAMPUS_NEWS
} from '../../data/MockData';
import { CourseDataManager, CourseData } from '../../common/utils/CourseDataManager';
import { CourseScheduleView } from '../CourseSchedule/CourseScheduleView';
import { NotificationUtil } from '../../common/utils/NotificationUtil';
import { PreferencesUtil } from '../../common/utils/PreferencesUtil';
import { common } from '@kit.AbilityKit';

const TAG = 'Main';

interface NewsDetailParams {
  id: number;
  title: string;
  content: string;
  source: string;
  publishTime: string;
}

@Builder
export function MainBuilder(name: string, param: string) {
  Main()
}

@Component
export struct Main {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;

  @State selectedTab: number = 0;

  // Mock data
  @State announcements: CampusNewsItem[] = MOCK_ANNOUNCEMENTS;
  @State todayCourses: CourseItem[] = [];
  @State allCourses: CourseData[] = [];
  @State weatherData: WeatherData = MOCK_WEATHER;
  @State quickEntries: QuickEntryItem[] = MOCK_QUICK_ENTRIES;

  // Quick entry press animation state
  @State pressedEntryIndex: number = -1;

  // Tab1: Campus news
  @State activeCategory: number = 0;
  @State categoryList: string[] = ['校园公告', '校园资讯', '社团活动', '学术讲座', '校园地图'];
  @State campusNewsList: CampusNewsItem[] = MOCK_CAMPUS_NEWS;

  // Tab 4 state
  @State userNickname: string = '同学';
  @State userStudentId: string = '2024001001';
  @State userCollege: string = '计算机科学与技术学院';
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;
  @StorageProp('fontSizeLevel') fontSizeLevel: number = 1;

  // Tab 2: Study assistant state
  @State activeStudyTab: number = 0;
  @State studyTabList: string[] = ['课程表', '成绩查询', '图书馆检索', '学习资料'];
  @State currentWeek: number = 16;
  @State libraryQuery: string = '';
  @State libraryResults: string[] = [
    '数据结构与算法（第3版） - 吴伟民',
    '计算机网络：自顶向下方法 - 詹姆士·库罗斯',
    '操作系统概念 - 亚伯拉罕·西尔伯沙茨',
    '人工智能：现代方法 - 斯图尔特·罗素',
    '数据库系统概念 - 亚伯拉罕·西尔伯沙茨',
    '编译原理 - 阿尔弗雷德·艾侯',
    '计算机组成与设计 - 戴维·帕特森',
    '软件工程：实践者的研究方法 - 罗杰·普莱斯曼'
  ];
  @State libraryFavorites: string[] = [];

  // Card entrance animation
  @State cardOpacity1: number = 0;
  @State cardOffsetY1: number = 20;
  @State cardOpacity2: number = 0;
  @State cardOffsetY2: number = 20;
  @State cardOpacity3: number = 0;
  @State cardOffsetY3: number = 20;
  @State coursesVersion: number = 0;
  @StorageLink('courseRefreshVer') courseRefreshVer: number = 0;

  aboutToAppear(): void {
    // Fallback bottomRectHeight for previewer (gesture indicator + tab bar buffer)
    if (this.bottomRectHeight === 0) {
      AppStorage.setOrCreate('bottomRectHeight', 34);
    }

    // Initialize dark mode and font size if not set
    if (AppStorage.get('darkModeEnabled') === undefined) {
      AppStorage.setOrCreate('darkModeEnabled', false);
    }
    if (AppStorage.get('fontSizeLevel') === undefined) {
      AppStorage.setOrCreate('fontSizeLevel', 1);
    }

    // Load saved settings from Preferences
    const context: common.Context = getContext(this);
    PreferencesUtil.getCustom(context, 'darkModeEnabled').then((val: string | null) => {
      if (val !== null) {
        AppStorage.setOrCreate('darkModeEnabled', val === 'true');
      }
    });
    PreferencesUtil.getCustom(context, 'fontSizeLevel').then((val: string | null) => {
      if (val !== null) {
        AppStorage.setOrCreate('fontSizeLevel', parseInt(val));
      }
    });

    // Request notification permission on startup
    NotificationUtil.requestPermission();

    // Load courses from storage
    this.loadAllCourses();

    // Load library favorites
    this.loadLibraryFavorites();

    // Staggered card entrance animations
    setTimeout(() => {
      this.cardOpacity1 = 1;
      this.cardOffsetY1 = 0;
    }, 200);
    setTimeout(() => {
      this.cardOpacity2 = 1;
      this.cardOffsetY2 = 0;
    }, 350);
    setTimeout(() => {
      this.cardOpacity3 = 1;
      this.cardOffsetY3 = 0;
    }, 500);
  }

  onPageShow(): void {
    this.loadAllCourses();
    this.coursesVersion++;
    this.loadLibraryFavorites();
  }

  private loadAllCourses(): void {
    // 1. Try AppStorage first (fastest)
    const appData: CourseData[] = CourseDataManager.loadFromAppStorage();
    if (appData.length > 0) {
      this.allCourses = appData;
      this.updateTodayCourses(appData);
      return;
    }
    // 2. Fallback: async from Preferences, sync to AppStorage
    const context: common.Context = getContext(this);
    CourseDataManager.loadFromPreferences(context).then((prefData: CourseData[]) => {
      if (prefData.length > 0) {
        this.allCourses = prefData;
        this.updateTodayCourses(prefData);
      } else {
        this.allCourses = [];
        this.todayCourses = [];
      }
    }).catch(() => {
      this.allCourses = [];
      this.todayCourses = [];
    });
    // While waiting for Preferences, keep current state
  }

  private updateTodayCourses(courses: CourseData[]): void {
    const today: number = new Date().getDay();
    const dayMap: number[] = [0, 1, 2, 3, 4, 5, 6];
    const todayDay: number = dayMap[today];
    const todayList: CourseItem[] = [];
    for (const item of courses) {
      if (item.dayOfWeek === todayDay) {
        todayList.push({
          id: item.id,
          courseName: item.courseName,
          teacher: item.teacher,
          location: item.location,
          timeSlot: item.timeSlot,
          startTime: '',
          endTime: '',
          dayOfWeek: item.dayOfWeek,
          weeks: item.weeks
        } as CourseItem);
      }
    }
    this.todayCourses = todayList;
  }

  private loadLibraryFavorites(): void {
    const saved: Object | undefined = AppStorage.get('library_favorites');
    if (saved) {
      try {
        this.libraryFavorites = JSON.parse(saved as string) as string[];
        return;
      } catch (err) {
        LogUtils.error(TAG, '解析收藏数据失败', err);
      }
    }
    this.libraryFavorites = [];
  }

  private saveLibraryFavorites(): void {
    try {
      AppStorage.setOrCreate('library_favorites', JSON.stringify(this.libraryFavorites));
      const context: common.Context = getContext(this);
      PreferencesUtil.setCustom(context, 'library_favorites', JSON.stringify(this.libraryFavorites));
    } catch (err) {
      LogUtils.error(TAG, '保存收藏数据失败', err);
    }
  }

  private toggleFavorite(bookEntry: string): void {
    const index: number = this.libraryFavorites.indexOf(bookEntry);
    if (index !== -1) {
      this.libraryFavorites.splice(index, 1);
      this.libraryFavorites = [...this.libraryFavorites];
    } else {
      this.libraryFavorites = [...this.libraryFavorites, bookEntry];
    }
    this.saveLibraryFavorites();
  }

  getFilteredNews(): CampusNewsItem[] {
    if (this.activeCategory === 0) {
      return this.announcements;
    }
    if (this.activeCategory === 4) {
      return [];
    }
    return this.campusNewsList.filter((item: CampusNewsItem) => {
      return item.category === this.categoryList[this.activeCategory];
    });
  }

  /** 根据字体大小级别返回缩放后的标题字号 */
  titleSize(): number {
    return this.fontSizeLevel === 0 ? 28 : this.fontSizeLevel === 2 ? 36 : 32;
  }

  /** 根据字体大小级别返回缩放后的正文字号 */
  bodySize(): number {
    return this.fontSizeLevel === 0 ? 24 : this.fontSizeLevel === 2 ? 30 : 26;
  }

  /** 根据字体大小级别返回缩放后的辅助字号 */
  captionSize(): number {
    return this.fontSizeLevel === 0 ? 20 : this.fontSizeLevel === 2 ? 26 : 22;
  }

  @Builder
  Tab0() {
    Column() {
      SymbolGlyph($r('sys.symbol.house'))
        .fontSize(22)
        .fontColor([this.selectedTab === 0
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary')])
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
      Text('首页')
        .fontSize($r('app.float.text_size_caption'))
        .fontColor(this.selectedTab === 0
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary'))
        .margin({ top: 4 })
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
    }
    .width('100%').height(56)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.selectedTab = 0;
    })
  }

  @Builder
  Tab1() {
    Column() {
      SymbolGlyph($r('sys.symbol.doc'))
        .fontSize(22)
        .fontColor([this.selectedTab === 1
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary')])
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
      Text('校园信息')
        .fontSize($r('app.float.text_size_caption'))
        .fontColor(this.selectedTab === 1
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary'))
        .margin({ top: 4 })
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
    }
    .width('100%').height(56)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.selectedTab = 1;
    })
  }

  @Builder
  Tab2() {
    Column() {
      SymbolGlyph($r('sys.symbol.book'))
        .fontSize(22)
        .fontColor([this.selectedTab === 2
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary')])
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
      Text('学习助手')
        .fontSize($r('app.float.text_size_caption'))
        .fontColor(this.selectedTab === 2
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary'))
        .margin({ top: 4 })
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
    }
    .width('100%').height(56)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.selectedTab = 2;
    })
  }

  @Builder
  Tab3() {
    Column() {
      SymbolGlyph($r('sys.symbol.heart'))
        .fontSize(22)
        .fontColor([this.selectedTab === 3
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary')])
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
      Text('生活服务')
        .fontSize($r('app.float.text_size_caption'))
        .fontColor(this.selectedTab === 3
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary'))
        .margin({ top: 4 })
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
    }
    .width('100%').height(56)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.selectedTab = 3;
    })
  }

  @Builder
  Tab4() {
    Column() {
      SymbolGlyph($r('sys.symbol.person'))
        .fontSize(22)
        .fontColor([this.selectedTab === 4
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary')])
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
      Text('我的')
        .fontSize($r('app.float.text_size_caption'))
        .fontColor(this.selectedTab === 4
          ? $r('app.color.brand_primary')
          : $r('app.color.text_secondary'))
        .margin({ top: 4 })
        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
    }
    .width('100%').height(56)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.selectedTab = 4;
    })
  }

  build() {
    NavDestination() {
      Column() {
        // Status bar placeholder（背景与页面一致）
        Column()
          .width('100%')
          .height(this.topRectHeight)

        Tabs({
          barPosition: BarPosition.End,
          index: this.selectedTab
        }) {
          // ==================== Tab 0: 首页 ====================
          TabContent() {
            Column() {
              // Navigation bar
              Row() {
                Text('校园助手')
                  .fontSize(this.fontSizeLevel === 2 ? 36 : this.fontSizeLevel === 0 ? 28 : 32)
                  .fontWeight(600)
                  .fontColor($r('app.color.brand_primary'))
                Blank()
                Stack() {
                  SymbolGlyph($r('sys.symbol.bell'))
                    .fontSize(24)
                    .fontColor([$r('app.color.brand_primary')])
                  Circle()
                    .width(8)
                    .height(8)
                    .fill($r('app.color.accent_orange'))
                    .align(Alignment.TopEnd)
                    .offset({ x: 2, y: -2 })
                }
                .width(28)
                .height(28)
              }
              .width('100%')
              .height(56)
              .padding({
                left: $r('app.float.spacing_lg'),
                right: $r('app.float.spacing_lg')
              })

              // Search bar
              Row() {
                SymbolGlyph($r('sys.symbol.magnifyingglass'))
                  .fontSize(20)
                  .fontColor([$r('app.color.text_secondary')])
                TextInput({ placeholder: '搜索校园信息/课程/美食' })
                  .layoutWeight(1)
                  .height(40)
                  .backgroundColor(Color.Transparent)
                  .placeholderColor($r('app.color.text_secondary'))
                  .placeholderFont({ size: $r('app.float.text_size_caption') })
                  .padding({ left: 8 })
                SymbolGlyph($r('sys.symbol.mic'))
                  .fontSize(20)
                  .fontColor([$r('app.color.text_secondary')])
              }
              .width('100%')
              .height(44)
              .borderRadius(24)
              .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
              .padding({ left: 16, right: 16 })
              .margin({
                left: $r('app.float.spacing_lg'),
                right: $r('app.float.spacing_lg'),
                bottom: $r('app.float.spacing_px')
              })
              .shadow({
                radius: 8,
                color: 'rgba(0, 0, 0, 0.05)',
                offsetX: 0,
                offsetY: 2
              })

              // Scrollable content area（layoutWeight 填满剩余空间）
              Scroll() {
                Column() {
                    // ===== Quick Entry Grid: 3x3 + More =====
                  Column() {
                    // Row 1: items 0, 1, 2
                    Row() {
                      Column() {
                        this.QuickEntryItem(this.quickEntries[0], 0, this.pressedEntryIndex === 0)
                      }.width('33.33%').alignItems(HorizontalAlign.Center)
                      Column() {
                        this.QuickEntryItem(this.quickEntries[1], 1, this.pressedEntryIndex === 1)
                      }.width('33.33%').alignItems(HorizontalAlign.Center)
                      Column() {
                        this.QuickEntryItem(this.quickEntries[2], 2, this.pressedEntryIndex === 2)
                      }.width('33.33%').alignItems(HorizontalAlign.Center)
                    }
                    .width('100%')
                    .margin({ bottom: $r('app.float.spacing_px') })

                    // Row 2: items 3, 4, 5
                    Row() {
                      Column() {
                        this.QuickEntryItem(this.quickEntries[3], 3, this.pressedEntryIndex === 3)
                      }.width('33.33%').alignItems(HorizontalAlign.Center)
                      Column() {
                        this.QuickEntryItem(this.quickEntries[4], 4, this.pressedEntryIndex === 4)
                      }.width('33.33%').alignItems(HorizontalAlign.Center)
                      Column() {
                        this.QuickEntryItem(this.quickEntries[5], 5, this.pressedEntryIndex === 5)
                      }.width('33.33%').alignItems(HorizontalAlign.Center)
                    }
                    .width('100%')
                    .margin({ bottom: $r('app.float.spacing_px') })

                    // Row 3: items 6, 7, 8
                    Row() {
                      Column() {
                        this.QuickEntryItem(this.quickEntries[6], 6, this.pressedEntryIndex === 6)
                      }.width('33.33%').alignItems(HorizontalAlign.Center)
                      Column() {
                        this.QuickEntryItem(this.quickEntries[7], 7, this.pressedEntryIndex === 7)
                      }.width('33.33%').alignItems(HorizontalAlign.Center)
                      Column() {
                        this.QuickEntryItem(this.quickEntries[8], 8, this.pressedEntryIndex === 8)
                      }.width('33.33%').alignItems(HorizontalAlign.Center)
                    }
                    .width('100%')
                    .margin({ bottom: $r('app.float.spacing_px') })

                    // "更多功能" button
                    Row() {
                      Stack() {
                        Circle()
                          .width(36)
                          .height(36)
                          .fill('rgba(22, 119, 255, 0.08)')
                        SymbolGlyph($r('sys.symbol.ellipsis_circle'))
                          .fontSize(20)
                          .fontColor([$r('app.color.text_secondary')])
                      }
                      Text('更多功能')
                        .fontSize(this.captionSize())
                        .fontColor($r('app.color.text_secondary'))
                        .margin({ left: 8 })
                    }
                    .width('100%')
                    .height(48)
                    .borderRadius($r('app.float.radius_md'))
                    .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
                    .padding({ left: $r('app.float.spacing_px') })
                    .shadow({
                      radius: 8,
                      color: 'rgba(0, 0, 0, 0.05)',
                      offsetX: 0,
                      offsetY: 2
                    })
                  }
                  .width('100%')
                  .margin({ bottom: $r('app.float.spacing_md') })

                  // ===== Card 1: Campus Announcements =====
                  Column() {
                    Row() {
                      Text('校园公告')
                        .fontSize(this.titleSize())
                        .fontWeight(600)
                        .fontColor($r('app.color.brand_primary'))
                      Blank()
                      Text('更多')
                        .fontSize(this.captionSize())
                        .fontColor($r('app.color.brand_primary'))
                      SymbolGlyph($r('sys.symbol.chevron_right'))
                        .fontSize(20)
                        .fontColor([$r('app.color.brand_primary')])
                    }
                    .width('100%')
                    .margin({ bottom: $r('app.float.spacing_px') })

                    ForEach(this.announcements, (item: CampusNewsItem) => {
                      Row() {
                        // Colored accent bar
                        Column()
                          .width(3)
                          .height(40)
                          .borderRadius(2)
                          .backgroundColor($r('app.color.brand_primary'))

                        Column() {
                          Row() {
                            // Category badge
                            Text(item.category)
                              .fontSize($r('app.float.text_size_caption'))
                              .fontColor($r('app.color.brand_primary'))
                              .fontWeight(400)
                              .backgroundColor('rgba(22, 119, 255, 0.08)')
                              .borderRadius(4)
                              .padding({ left: 8, right: 8, top: 2, bottom: 2 })

                            Blank()

                            Text(item.publishTime.slice(5))
                              .fontSize($r('app.float.text_size_caption'))
                              .fontColor($r('app.color.text_secondary'))
                          }
                          .width('100%')

                          Text(item.title)
                            .fontSize($r('app.float.text_size_body'))
                            .fontColor($r('app.color.text_primary'))
                            .fontWeight(500)
                            .width('100%')
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                            .margin({ top: 4 })
                        }
                        .layoutWeight(1)
                        .alignItems(HorizontalAlign.Start)
                        .margin({ left: $r('app.float.spacing_px') })
                      }
                      .width('100%')
                      .padding({ top: 8, bottom: 8 })
                      .borderRadius(4)
                    }, (item: CampusNewsItem) => item.id.toString())
                  }
                  .width('100%')
                  .borderRadius($r('app.float.radius_md'))
                  .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
                  .padding($r('app.float.spacing_px'))
                  .margin({ bottom: $r('app.float.spacing_px') })
                  .shadow({
                    radius: 8,
                    color: 'rgba(0, 0, 0, 0.05)',
                    offsetX: 0,
                    offsetY: 2
                  })
                  .opacity(this.cardOpacity1)
                  .translate({ x: 0, y: this.cardOffsetY1 })
                  .animation({ duration: 350, curve: Curve.FastOutSlowIn })

                  // ===== Card 2: Today's Courses =====
                  Column() {
                    Row() {
                      Text('今日课程')
                        .fontSize(this.titleSize())
                        .fontWeight(600)
                        .fontColor($r('app.color.brand_primary'))
                      Blank()
                    }
                    .width('100%')
                    .margin({ bottom: $r('app.float.spacing_px') })

                    if (this.todayCourses.length > 0) {
                      ForEach(this.todayCourses, (course: CourseItem) => {
                        Row() {
                          // Day badge
                          Column() {
                            Text(this.getDayLabel(course.dayOfWeek))
                              .fontSize(11)
                              .fontColor(Color.White)
                              .fontWeight(600)
                          }
                          .width(56)
                          .height(28)
                          .backgroundColor($r('app.color.brand_primary'))
                          .borderRadius(14)
                          .alignItems(HorizontalAlign.Center)
                          .justifyContent(FlexAlign.Center)

                          // Time pill
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
                        .padding({ top: 10, bottom: 10 })
                        .borderRadius(8)
                        .backgroundColor('rgba(22, 119, 255, 0.03)')
                        .margin({ bottom: 8 })
                      }, (course: CourseItem) => course.id.toString())
                    } else {
                      Column() {
                        Text('今日无课程，好好休息吧～')
                          .fontSize($r('app.float.text_size_body'))
                          .fontColor($r('app.color.text_secondary'))
                      }
                      .width('100%')
                      .height(80)
                      .justifyContent(FlexAlign.Center)
                      .alignItems(HorizontalAlign.Center)
                    }
                  }
                  .width('100%')
                  .borderRadius($r('app.float.radius_md'))
                  .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
                  .padding($r('app.float.spacing_px'))
                  .margin({ bottom: $r('app.float.spacing_px') })
                  .shadow({
                    radius: 8,
                    color: 'rgba(0, 0, 0, 0.05)',
                    offsetX: 0,
                    offsetY: 2
                  })
                  .opacity(this.cardOpacity2)
                  .translate({ x: 0, y: this.cardOffsetY2 })
                  .animation({ duration: 350, curve: Curve.FastOutSlowIn })

                  // ===== Card 3: Weather =====
                  Column() {
                    Row() {
                      SymbolGlyph(this.weatherData.iconSymbol)
                        .fontSize(44)
                        .fontColor([$r('app.color.accent_orange')])

                      Column() {
                        Text(this.weatherData.temperature)
                          .fontSize($r('app.float.text_size_title_large'))
                          .fontColor($r('app.color.text_primary'))
                          .fontWeight(700)
                        Text(this.weatherData.condition)
                          .fontSize($r('app.float.text_size_body'))
                          .fontColor($r('app.color.text_secondary'))
                      }
                      .alignItems(HorizontalAlign.Start)
                      .margin({ left: $r('app.float.spacing_px') })

                      Blank()

                      Column() {
                        Row() {
                          Circle()
                            .width(8)
                            .height(8)
                            .fill($r('app.color.accent_orange'))
                          Text(' ' + this.weatherData.highTemp)
                            .fontSize($r('app.float.text_size_caption'))
                            .fontColor($r('app.color.text_primary'))
                        }

                        Row() {
                          Circle()
                            .width(8)
                            .height(8)
                            .fill($r('app.color.brand_primary'))
                          Text(' ' + this.weatherData.lowTemp)
                            .fontSize($r('app.float.text_size_caption'))
                            .fontColor($r('app.color.text_secondary'))
                        }
                        .margin({ top: 4 })
                      }
                      .alignItems(HorizontalAlign.End)
                    }
                    .width('100%')

                    // Location
                    Row() {
                      Text(this.weatherData.location)
                        .fontSize($r('app.float.text_size_caption'))
                        .fontColor($r('app.color.text_secondary'))
                        .margin({ left: 4 })
                    }
                    .width('100%')
                    .margin({ top: $r('app.float.spacing_px') })
                  }
                  .width('100%')
                  .borderRadius($r('app.float.radius_md'))
                  .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
                  .padding($r('app.float.spacing_px'))
                  .shadow({
                    radius: 8,
                    color: 'rgba(0, 0, 0, 0.05)',
                    offsetX: 0,
                    offsetY: 2
                  })
                  .opacity(this.cardOpacity3)
                  .translate({ x: 0, y: this.cardOffsetY3 })
                  .animation({ duration: 350, curve: Curve.FastOutSlowIn })
                }
                .width('100%')
                .padding({
                  left: $r('app.float.spacing_lg'),
                  right: $r('app.float.spacing_lg'),
                  bottom: $r('app.float.spacing_md')
                })
              }
              .width('100%')
              .layoutWeight(1)
          }
          .constraintSize({ minHeight: '100%', maxHeight: '100%' })
          .width('100%')
        }
        .tabBar(this.Tab0)
          TabContent() {
            Column() {
              // Title bar
              Row() {
                Text('校园信息')
                  .fontSize(this.titleSize())
                  .fontWeight(600)
                  .fontColor($r('app.color.text_primary'))
                Blank()
              }
              .width('100%')
              .padding({
                left: $r('app.float.spacing_lg'),
                right: $r('app.float.spacing_lg'),
                top: $r('app.float.spacing_md')
              })

              // Category tabs (horizontally scrollable)
              Scroll() {
                Row() {
                  ForEach(this.categoryList, (category: string, index: number) => {
                    Column() {
                      Text(category)
                        .fontSize($r('app.float.text_size_body'))
                        .fontColor(this.activeCategory === index
                          ? $r('app.color.brand_primary')
                          : $r('app.color.text_primary'))
                        .fontWeight(this.activeCategory === index ? 600 : 400)
                        .height(36)
                        .padding({ left: 16, right: 16 })
                        .onClick(() => {
                          this.activeCategory = index;
                        })

                      // Active underline indicator
                      if (this.activeCategory === index) {
                        Column()
                          .width(20)
                          .height(3)
                          .borderRadius(2)
                          .backgroundColor($r('app.color.brand_primary'))
                          .margin({ top: 2 })
                          .animation({ duration: 200, curve: Curve.FastOutSlowIn })
                      }
                    }
                    .alignItems(HorizontalAlign.Center)
                    .margin({ right: 4 })
                  }, (category: string) => category)
                }
                .padding({
                  left: $r('app.float.spacing_lg'),
                  right: $r('app.float.spacing_lg'),
                  top: $r('app.float.spacing_px'),
                  bottom: 0
                })
              }
              .width('100%')
              .scrollable(ScrollDirection.Horizontal)
              .scrollBar(BarState.Off)

              // Content list
              Scroll() {
                Column() {
                  if (this.activeCategory === 4) {
                    // Campus map placeholder
                    Column() {
                      Stack() {
                        Circle()
                          .width(80)
                          .height(80)
                          .fill('rgba(22, 119, 255, 0.06)')
                        SymbolGlyph($r('sys.symbol.map'))
                          .fontSize(36)
                          .fontColor([$r('app.color.brand_primary')])
                      }
                      Text('校园地图')
                        .fontSize($r('app.float.text_size_body'))
                        .fontColor($r('app.color.text_primary'))
                        .fontWeight(500)
                        .margin({ top: $r('app.float.spacing_px') })
                      Text('开发中，敬请期待...')
                        .fontSize($r('app.float.text_size_caption'))
                        .fontColor($r('app.color.text_secondary'))
                        .margin({ top: 4 })
                    }
                    .width('100%')
                    .height(300)
                    .justifyContent(FlexAlign.Center)
                    .alignItems(HorizontalAlign.Center)
                  } else {
                    if (this.getFilteredNews().length > 0) {
                      ForEach(this.getFilteredNews(), (item: CampusNewsItem) => {
                        Column() {
                          Row() {
                            // Image placeholder with icon
                            Stack() {
                              Column()
                                .width(88)
                                .height(88)
                                .borderRadius(8)
                                .backgroundColor('rgba(22, 119, 255, 0.06)')
                              SymbolGlyph($r('sys.symbol.doc_text'))
                                .fontSize(28)
                                .fontColor([$r('app.color.brand_primary')])
                                .opacity(0.3)
                            }
                            .width(88)
                            .height(88)

                            Column() {
                              Text(item.title)
                                .fontSize($r('app.float.text_size_body'))
                                .fontColor($r('app.color.text_primary'))
                                .fontWeight(500)
                                .maxLines(1)
                                .textOverflow({ overflow: TextOverflow.Ellipsis })

                              Row() {
                                Text(item.category)
                                  .fontSize($r('app.float.text_size_caption'))
                                  .fontColor($r('app.color.brand_primary'))
                                  .backgroundColor('rgba(22, 119, 255, 0.08)')
                                  .borderRadius(4)
                                  .padding({ left: 6, right: 6, top: 1, bottom: 1 })

                                Blank()

                                Text(item.source)
                                  .fontSize($r('app.float.text_size_caption'))
                                  .fontColor($r('app.color.text_secondary'))
                              }
                              .width('100%')
                              .margin({ top: 6 })

                              Text(item.publishTime)
                                .fontSize($r('app.float.text_size_caption'))
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ top: 2 })
                            }
                            .layoutWeight(1)
                            .alignItems(HorizontalAlign.Start)
                            .margin({ left: $r('app.float.spacing_px') })
                          }
                          .width('100%')
                        }
                        .width('100%')
                        .borderRadius($r('app.float.radius_md'))
                        .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
                        .padding($r('app.float.spacing_px'))
                        .margin({ bottom: $r('app.float.spacing_px') })
                        .shadow({
                          radius: 8,
                          color: 'rgba(0, 0, 0, 0.05)',
                          offsetX: 0,
                          offsetY: 2
                        })
                        .onClick(() => {
                          const params: NewsDetailParams = {
                            id: item.id,
                            title: item.title,
                            content: item.content,
                            source: item.source,
                            publishTime: item.publishTime
                          };
                          this.navPathStack.pushPathByName('CampusNewsDetail', params);
                        })
                      }, (item: CampusNewsItem) => item.id.toString())
                    } else {
                      // Empty state
                      Column() {
                        Stack() {
                          Circle()
                            .width(80)
                            .height(80)
                            .fill('rgba(22, 119, 255, 0.06)')
                          SymbolGlyph($r('sys.symbol.doc'))
                            .fontSize(36)
                            .fontColor([$r('app.color.text_secondary')])
                        }
                        Text('暂无相关内容')
                          .fontSize($r('app.float.text_size_body'))
                          .fontColor($r('app.color.text_secondary'))
                          .margin({ top: $r('app.float.spacing_px') })
                        Text('切换其他分类试试')
                          .fontSize($r('app.float.text_size_caption'))
                          .fontColor($r('app.color.text_secondary'))
                          .margin({ top: 4 })
                      }
                      .width('100%')
                      .height(300)
                      .justifyContent(FlexAlign.Center)
                      .alignItems(HorizontalAlign.Center)
                    }
                  }
                }
                .width('100%')
                .padding({
                  left: $r('app.float.spacing_lg'),
                  right: $r('app.float.spacing_lg'),
                  bottom: $r('app.float.spacing_md')
                })
              }
              .width('100%')
              .scrollBar(BarState.Off)
            }
            .constraintSize({ minHeight: '100%', maxHeight: '100%' })
            .padding({ bottom: 56 })
            .width('100%')
            .backgroundColor(this.darkModeEnabled ? '#16162A' : '#F5F7FA')
          }
          .tabBar(this.Tab1)

          // ==================== Tab 2: 学习助手 ====================
          TabContent() {
            Column() {
              // Title bar
              Row() {
                Text('学习助手')
                  .fontSize(this.titleSize())
                  .fontWeight(600)
                  .fontColor($r('app.color.text_primary'))
                Blank()
              }
              .width('100%')
              .padding({
                left: $r('app.float.spacing_lg'),
                right: $r('app.float.spacing_lg'),
                top: $r('app.float.spacing_md')
              })

              // Sub-tabs
              Row() {
                ForEach(this.studyTabList, (tab: string, index: number) => {
                  Column() {
                    Text(tab)
                      .fontSize(this.bodySize())
                      .fontColor(this.activeStudyTab === index
                        ? $r('app.color.brand_primary')
                        : $r('app.color.text_secondary'))
                      .fontWeight(this.activeStudyTab === index ? 600 : 400)
                      .maxLines(2)
                      .textAlign(TextAlign.Center)
                      .onClick(() => {
                        this.activeStudyTab = index;
                      })

                    if (this.activeStudyTab === index) {
                      Column()
                        .width(20)
                        .height(3)
                        .borderRadius(2)
                        .backgroundColor($r('app.color.brand_primary'))
                        .margin({ top: 2 })
                        .animation({ duration: 200, curve: Curve.FastOutSlowIn })
                    }
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Center)
                  .padding({ top: 12, bottom: 12 })
                }, (tab: string) => tab)
              }
              .width('100%')
              .padding({
                left: $r('app.float.spacing_lg'),
                right: $r('app.float.spacing_lg'),
                top: $r('app.float.spacing_px'),
                bottom: 0
              })
              .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
              .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
              .borderRadius({ topLeft: $r('app.float.radius_md'), topRight: $r('app.float.radius_md') })

              // Scroll 内容区（layoutWeight 填满剩余空间）
              Scroll() {
                Column() {
                  if (this.activeStudyTab === 0) {
                    // ===== 课程表 =====
                    CourseScheduleView({
                      allCourses: this.allCourses,
                      currentWeek: $currentWeek,
                      coursesVersion: this.coursesVersion,
                      navPathStack: this.navPathStack
                    })
                  } else if (this.activeStudyTab === 1) {
                    // ===== 成绩查询 =====
                    this.buildGradeView()
                  } else if (this.activeStudyTab === 2) {
                    // ===== 图书馆检索 =====
                    this.buildLibraryView()
                  } else {
                    // ===== 学习资料 =====
                    this.buildStudyMaterialsView()
                  }
                }
                .width('100%')
                .padding({
                  left: $r('app.float.spacing_lg'),
                  right: $r('app.float.spacing_lg'),
                  bottom: 16
                })
              }
              .width('100%')
              .layoutWeight(1)
              .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
              .borderRadius({
                bottomLeft: $r('app.float.radius_md'),
                bottomRight: $r('app.float.radius_md')
              })
            }
            .constraintSize({ minHeight: '100%', maxHeight: '100%' })
            .width('100%')
            .backgroundColor(this.darkModeEnabled ? '#16162A' : '#F5F7FA')
          }
          .tabBar(this.Tab2)

          // ==================== Tab 3: 生活服务 ====================
          TabContent() {
            Column() {
              // Title bar
              Row() {
                Text('生活服务')
                  .fontSize(this.titleSize())
                  .fontWeight(600)
                  .fontColor($r('app.color.text_primary'))
                Blank()
              }
              .width('100%')
              .padding({
                left: $r('app.float.spacing_lg'),
                right: $r('app.float.spacing_lg'),
                top: $r('app.float.spacing_md')
              })

              Scroll() {
                Column() {
                  // 2x2 Service category grid
                  Row() {
                    this.ServiceCard($r('sys.symbol.questionmark_circle'), '失物招领', $r('app.color.accent_orange'))
                    Row().width('2%')
                    this.ServiceCard($r('sys.symbol.cup'), '校园美食', $r('app.color.accent_orange'))
                  }
                  .width('100%')
                  .margin({ bottom: $r('app.float.spacing_px') })

                  Row() {
                    this.ServiceCard($r('sys.symbol.play_circle'), '音乐播放', $r('app.color.brand_primary'))
                    Row().width('2%')
                    this.ServiceCard($r('sys.symbol.gearshape'), '校园工具', $r('app.color.brand_primary'))
                  }
                  .width('100%')
                }
                .width('100%')
                .padding({
                  left: $r('app.float.spacing_lg'),
                  right: $r('app.float.spacing_lg'),
                  bottom: $r('app.float.spacing_md')
                })
              }
              .width('100%')
            }
            .constraintSize({ minHeight: '100%', maxHeight: '100%' })
            .padding({ bottom: 56 })
            .width('100%')
            .backgroundColor(this.darkModeEnabled ? '#16162A' : '#F5F7FA')
          }
          .tabBar(this.Tab3)

          // ==================== Tab 4: 我的 ====================
          TabContent() {
            Column() {
              // Title bar
              Row() {
                Text('我的')
                  .fontSize(this.titleSize())
                  .fontWeight(600)
                  .fontColor($r('app.color.text_primary'))
                Blank()
                SymbolGlyph($r('sys.symbol.gearshape'))
                  .fontSize(24)
                  .fontColor([$r('app.color.brand_primary')])
                  .onClick(() => {
                    LogUtils.info('Main', '点击设置');
                  })
              }
              .width('100%')
              .padding({
                left: $r('app.float.spacing_lg'),
                right: $r('app.float.spacing_lg'),
                top: $r('app.float.spacing_md')
              })

              Scroll() {
                Column() {
                  // ==== Profile Card ====
                  Row() {
                    // Avatar
                    Stack() {
                      Circle()
                        .width(72)
                        .height(72)
                        .fill($r('app.color.brand_primary'))
                        .opacity(0.1)
                      SymbolGlyph($r('sys.symbol.person'))
                        .fontSize(36)
                        .fontColor([$r('app.color.brand_primary')])
                    }
                    .width(72)
                    .height(72)

                    Column() {
                      Text(this.userNickname)
                        .fontSize($r('app.float.text_size_title_medium'))
                        .fontColor($r('app.color.text_primary'))
                        .fontWeight(600)
                      Text(this.userStudentId)
                        .fontSize($r('app.float.text_size_caption'))
                        .fontColor($r('app.color.text_secondary'))
                        .margin({ top: 4 })
                      Text(this.userCollege)
                        .fontSize($r('app.float.text_size_caption'))
                        .fontColor($r('app.color.text_secondary'))
                        .margin({ top: 2 })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .margin({ left: $r('app.float.spacing_px') })

                    Blank()

                    SymbolGlyph($r('sys.symbol.chevron_right'))
                      .fontSize(20)
                      .fontColor([$r('app.color.text_secondary')])
                  }
                  .width('100%')
                  .borderRadius($r('app.float.radius_md'))
                  .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
                  .padding($r('app.float.spacing_px'))
                  .shadow({
                    radius: 8,
                    color: 'rgba(0, 0, 0, 0.05)',
                    offsetX: 0,
                    offsetY: 2
                  })
                  .margin({ bottom: $r('app.float.spacing_px') })
                  .onClick(() => {
                    LogUtils.info('Main', '点击个人信息');
                  })

                  // ==== Function List ====
                  Column() {
                    this.FuncItem($r('sys.symbol.heart'), '我的收藏', 0)
                    this.DividerItem()
                    this.FuncItem($r('sys.symbol.checkmark'), '我的待办', 1)
                    this.DividerItem()
                    this.FuncItem($r('sys.symbol.calendar'), '我的课程', 2)
                    this.DividerItem()
                    this.FuncItem($r('sys.symbol.doc_text'), '我的成绩', 3)
                    this.DividerItem()
                    this.FuncItem($r('sys.symbol.questionmark_circle'), '失物发布', 4)
                    this.DividerItem()
                    this.FuncItem($r('sys.symbol.questionmark_circle'), '帮助中心', 5)
                    this.DividerItem()
                    this.FuncItem($r('sys.symbol.ellipsis_message_1'), '意见反馈', 6)
                  }
                  .width('100%')
                  .borderRadius($r('app.float.radius_md'))
                  .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
                  .padding({ left: 4, right: 4 })
                  .shadow({
                    radius: 8,
                    color: 'rgba(0, 0, 0, 0.05)',
                    offsetX: 0,
                    offsetY: 2
                  })
                  .margin({ bottom: $r('app.float.spacing_px') })

                  // ==== Settings Module ====
                  Column() {
                    // Dark mode toggle
                    Row() {
                      SymbolGlyph($r('sys.symbol.moon'))
                        .fontSize(22)
                        .fontColor([$r('app.color.brand_primary')])
                      Text('深色模式')
                        .fontSize(this.bodySize())
                        .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                        .margin({ left: $r('app.float.spacing_px') })
                      Blank()
                      Toggle({ type: ToggleType.Switch, isOn: this.darkModeEnabled })
                        .onChange((isOn: boolean) => {
                          this.darkModeEnabled = isOn;
                          const context: common.Context = getContext(this);
                          PreferencesUtil.setCustom(context, 'darkModeEnabled', isOn ? 'true' : 'false');
                        })
                    }
                    .width('100%')
                    .height(52)
                    .padding({ left: $r('app.float.spacing_px'), right: 4 })

                    this.DividerItem()

                    // Font size setting
                    Row() {
                      SymbolGlyph($r('sys.symbol.textformat'))
                        .fontSize(22)
                        .fontColor([$r('app.color.brand_primary')])
                      Text('字体大小')
                        .fontSize(this.bodySize())
                        .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                        .margin({ left: $r('app.float.spacing_px') })
                      Blank()
                      Row() {
                        Text('小')
                          .fontSize($r('app.float.text_size_caption'))
                          .fontColor($r('app.color.text_secondary'))
                          .margin({ right: 8 })
                        Radio({ value: 'small', group: 'fontSize' })
                          .checked(this.fontSizeLevel === 0)
                          .onChange(() => {
                            this.fontSizeLevel = 0;
                            const context: common.Context = getContext(this);
                            PreferencesUtil.setCustom(context, 'fontSizeLevel', '0');
                          })
                        Text('中')
                          .fontSize($r('app.float.text_size_caption'))
                          .fontColor($r('app.color.text_secondary'))
                          .margin({ left: 12, right: 8 })
                        Radio({ value: 'medium', group: 'fontSize' })
                          .checked(this.fontSizeLevel === 1)
                          .onChange(() => {
                            this.fontSizeLevel = 1;
                            const context: common.Context = getContext(this);
                            PreferencesUtil.setCustom(context, 'fontSizeLevel', '1');
                          })
                        Text('大')
                          .fontSize($r('app.float.text_size_caption'))
                          .fontColor($r('app.color.text_secondary'))
                          .margin({ left: 12, right: 8 })
                        Radio({ value: 'large', group: 'fontSize' })
                          .checked(this.fontSizeLevel === 2)
                          .onChange(() => {
                            this.fontSizeLevel = 2;
                            const context: common.Context = getContext(this);
                            PreferencesUtil.setCustom(context, 'fontSizeLevel', '2');
                          })
                      }
                    }
                    .width('100%')
                    .height(52)
                    .padding({ left: $r('app.float.spacing_px'), right: 4 })

                    this.DividerItem()

                    // Notification settings
                    Row() {
                      SymbolGlyph($r('sys.symbol.bell'))
                        .fontSize(22)
                        .fontColor([$r('app.color.brand_primary')])
                      Text('通知设置')
                        .fontSize(this.bodySize())
                        .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                        .margin({ left: $r('app.float.spacing_px') })
                      Blank()
                      SymbolGlyph($r('sys.symbol.chevron_right'))
                        .fontSize(20)
                        .fontColor([$r('app.color.text_secondary')])
                    }
                    .width('100%')
                    .height(52)
                    .padding({ left: $r('app.float.spacing_px'), right: $r('app.float.spacing_px') })
                    .onClick(() => {
                      LogUtils.info('Main', '点击通知设置');
                    })

                    this.DividerItem()

                    // Cache clearing
                    Row() {
                      SymbolGlyph($r('sys.symbol.trash'))
                        .fontSize(22)
                        .fontColor([$r('app.color.brand_primary')])
                      Text('清理缓存')
                        .fontSize(this.bodySize())
                        .fontColor($r('app.color.text_primary'))
                        .margin({ left: $r('app.float.spacing_px') })
                      Blank()
                      Text('12.5MB')
                        .fontSize($r('app.float.text_size_caption'))
                        .fontColor($r('app.color.text_secondary'))
                        .margin({ right: 8 })
                      Button('清理')
                        .height(30)
                        .fontSize($r('app.float.text_size_caption'))
                        .fontColor(Color.White)
                        .backgroundColor($r('app.color.accent_orange'))
                        .borderRadius($r('app.float.radius_md'))
                        .onClick(() => {
                          LogUtils.info('Main', '清理缓存');
                        })
                    }
                    .width('100%')
                    .height(52)
                    .padding({ left: $r('app.float.spacing_px'), right: $r('app.float.spacing_px') })
                  }
                  .width('100%')
                  .borderRadius($r('app.float.radius_md'))
                  .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#ffffff')
                  .shadow({
                    radius: 8,
                    color: 'rgba(0, 0, 0, 0.05)',
                    offsetX: 0,
                    offsetY: 2
                  })
                  .margin({ bottom: $r('app.float.spacing_md') })

                  // ==== About Section ====
                  Column() {
                    Text('版本号 V1.0.0（HarmonyOS NEXT）')
                      .fontSize($r('app.float.text_size_caption'))
                      .fontColor(this.darkModeEnabled ? '#a0a0b8' : '#86909C')
                    Text('福州理工学院 计算机学院 开发团队')
                      .fontSize(22)
                      .fontColor($r('app.color.text_secondary'))
                      .margin({ top: 4 })
                    Text('©2026 校通Plus 保留所有权利')
                      .fontSize(20)
                      .fontColor($r('app.color.text_secondary'))
                      .margin({ top: 2 })
                  }
                  .width('100%')
                  .alignItems(HorizontalAlign.Center)
                  .padding({ bottom: 30 })
                }
                .width('100%')
                .padding({
                  left: $r('app.float.spacing_lg'),
                  right: $r('app.float.spacing_lg'),
                  bottom: $r('app.float.spacing_md')
                })
              }
              .width('100%')
            }
            .constraintSize({ minHeight: '100%', maxHeight: '100%' })
            .padding({ bottom: 56 })
            .width('100%')
            .backgroundColor(this.darkModeEnabled ? '#16162A' : '#F5F7FA')
          }
          .tabBar(this.Tab4)
        }
        .vertical(false)
        .scrollable(false)
        .onChange((index: number) => {
          this.selectedTab = index;
        })
        .width('100%')
        .layoutWeight(1)
        .backgroundColor(this.darkModeEnabled ? '#1A1A2E' : '#F5F7FA')
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

  @Builder
  QuickEntryItem(item: QuickEntryItem, index: number, isPressed: boolean) {
    Column() {
      Stack() {
        Circle()
          .width(52)
          .height(52)
          .fill('rgba(22, 119, 255, 0.08)')
        SymbolGlyph(item.iconSymbol)
          .fontSize(24)
          .fontColor([$r('app.color.brand_primary')])
      }
      .scale({ x: isPressed ? 1.15 : 1, y: isPressed ? 1.15 : 1 })
      .animation({ duration: 200, curve: Curve.FastOutSlowIn })

      Text(item.label)
        .fontSize(this.captionSize())
        .fontColor(this.darkModeEnabled ? '#c0c0d8' : '#1D2129')
        .margin({ top: 6 })
    }
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.pressedEntryIndex = index;
      setTimeout(() => {
        if (this.pressedEntryIndex === index) {
          this.pressedEntryIndex = -1;
        }
      }, 200);
      // 导航到对应页面或切换Tab
      const route: string = item.routeName;
      if (route === 'Schedule') {
        this.selectedTab = 2;
        this.activeStudyTab = 0;
      } else if (route === 'GradeQuery') {
        this.selectedTab = 2;
        this.activeStudyTab = 1;
      } else if (route === 'Library') {
        this.selectedTab = 2;
        this.activeStudyTab = 2;
      } else if (route === 'CampusNotice') {
        this.selectedTab = 1;
        this.activeCategory = 0;
      } else if (route === 'CampusMap') {
        this.selectedTab = 1;
        this.activeCategory = 4;
      } else if (route === 'TodoReminder') {
        this.navPathStack.pushPathByName('TodoPage', null);
      } else if (route === 'LostFound') {
        this.navPathStack.pushPathByName('LostFound', null);
      } else if (route === 'CampusFood') {
        this.navPathStack.pushPathByName('CampusFood', null);
      } else if (route === 'MusicPlayer') {
        this.navPathStack.pushPathByName('MusicPlayer', null);
      }
    })
  }

  @Builder
  FuncItem(icon: Resource, label: string, index: number) {
    Row() {
      SymbolGlyph(icon)
        .fontSize(22)
        .fontColor([$r('app.color.brand_primary')])
      Text(label)
        .fontSize(this.bodySize())
        .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
        .margin({ left: $r('app.float.spacing_px') })
      Blank()
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontSize(20)
        .fontColor([this.darkModeEnabled ? '#6a6a8e' : '#86909C'])
    }
    .width('100%')
    .height(52)
    .padding({ left: $r('app.float.spacing_px'), right: $r('app.float.spacing_px') })
    .borderRadius(8)
    .onClick(() => {
      if (label === '我的待办') {
        this.navPathStack.pushPathByName('TodoPage', null);
      } else if (label === '我的收藏') {
        this.navPathStack.pushPathByName('MineFavorites', null);
      } else if (label === '我的课程') {
        this.selectedTab = 2;
        this.activeStudyTab = 0;
      } else if (label === '我的成绩') {
        this.selectedTab = 2;
        this.activeStudyTab = 1;
      } else if (label === '失物发布') {
        this.navPathStack.pushPathByName('LostFound', null);
      } else if (label === '我的设置') {
        LogUtils.info('Main', '点击设置');
      } else {
        LogUtils.info('Main', '点击功能: ' + label);
      }
    })
  }

  @Builder
  DividerItem() {
    Row()
      .width('100%')
      .height(0.5)
      .backgroundColor(this.darkModeEnabled ? '#2a2a4a' : '#E5E6EB')
      .margin({ left: $r('app.float.spacing_px'), right: $r('app.float.spacing_px') })
  }

  getDayLabel(day: number): string {
    return CourseDataManager.getDayLabel(day);
  }

  @Builder
  buildGradeView() {
    Column() {
      // Student info
      Row() {
        SymbolGlyph($r('sys.symbol.person'))
          .fontSize(22)
          .fontColor([$r('app.color.brand_primary')])
        Text(this.userNickname + '  |  ' + this.userStudentId)
          .fontSize($r('app.float.text_size_body'))
          .fontColor($r('app.color.text_primary'))
          .margin({ left: 8 })
        Blank()
      }
      .width('100%')
      .margin({ top: $r('app.float.spacing_px'), bottom: 4 })

      // Refresh button (separate row to avoid overflow)
      Row() {
        Blank()
        Button('刷新成绩')
          .height(32)
          .fontSize($r('app.float.text_size_caption'))
          .fontColor(Color.White)
          .backgroundColor($r('app.color.brand_primary'))
          .borderRadius($r('app.float.radius_md'))
          .onClick(() => {
            LogUtils.info('Main', '刷新成绩');
          })
      }
      .width('100%')
      .margin({ bottom: $r('app.float.spacing_px') })

      // Grade list header
      Row() {
        Text('课程名称')
          .layoutWeight(3)
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.text_secondary'))
          .fontWeight(500)
        Text('成绩')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.text_secondary'))
          .fontWeight(500)
        Text('绩点')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.text_secondary'))
          .fontWeight(500)
      }
      .width('100%')
      .padding({ bottom: 8 })

      // Grade items
      this.buildGradeRow('数据结构与算法', 92, 4.0)
      this.buildGradeRow('操作系统原理', 85, 3.7)
      this.buildGradeRow('大学英语（四）', 78, 3.3)
      this.buildGradeRow('线性代数', 88, 3.7)
      this.buildGradeRow('数字逻辑设计', 82, 3.3)

      // Summary
      Row() {
        Text('平均绩点：3.6  |  已修学分：18')
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.text_secondary'))
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: $r('app.float.spacing_px') })
    }
    .width('100%')
    .margin({ top: $r('app.float.spacing_px') })
  }

  @Builder
  buildGradeRow(courseName: string, score: number, gpa: number) {
    Row() {
      Text(courseName)
        .layoutWeight(3)
        .fontSize($r('app.float.text_size_body'))
        .fontColor($r('app.color.text_primary'))
      Text(score.toString())
        .layoutWeight(1)
        .fontSize($r('app.float.text_size_body'))
        .fontColor(score >= 90 ? $r('app.color.accent_green') : $r('app.color.text_primary'))
        .textAlign(TextAlign.Center)
      Text(gpa.toFixed(1))
        .layoutWeight(1)
        .fontSize($r('app.float.text_size_body'))
        .fontColor($r('app.color.text_primary'))
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
    .borderRadius(6)
  }

  @Builder
  buildLibraryView() {
    Column() {
      // Search bar
      Row() {
        TextInput({ placeholder: '请输入图书名称/作者/ISBN' })
          .layoutWeight(1)
          .height(44)
          .placeholderColor($r('app.color.text_secondary'))
          .placeholderFont({ size: $r('app.float.text_size_caption') })
          .padding({ left: $r('app.float.spacing_px') })
          .onChange((v: string) => {
            this.libraryQuery = v;
          })

        Button('搜索')
          .height(44)
          .fontSize($r('app.float.text_size_body'))
          .fontColor(Color.White)
          .backgroundColor($r('app.color.brand_primary'))
          .borderRadius($r('app.float.radius_md'))
          .margin({ left: $r('app.float.spacing_px') })
          .onClick(() => {
            LogUtils.info('Main', '搜索图书: ' + this.libraryQuery);
          })
      }
      .width('100%')
      .margin({ top: $r('app.float.spacing_px'), bottom: $r('app.float.spacing_px') })

      // Results list
      ForEach(this.libraryResults, (item: string) => {
        Row() {
          Stack() {
            Column()
              .width(56)
              .height(72)
              .borderRadius(6)
              .backgroundColor('rgba(22, 119, 255, 0.06)')
            SymbolGlyph($r('sys.symbol.book'))
              .fontSize(24)
              .fontColor([$r('app.color.brand_primary')])
              .opacity(0.4)
          }
          .width(56)
          .height(72)

          Column() {
            Text(item.split(' - ')[0])
              .fontSize($r('app.float.text_size_body'))
              .fontColor($r('app.color.text_primary'))
              .fontWeight(500)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width('100%')
            Text(item.split(' - ')[1] || '')
              .fontSize($r('app.float.text_size_caption'))
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .margin({ left: $r('app.float.spacing_px') })

          Button(this.libraryFavorites.indexOf(item) !== -1 ? '已收藏' : '收藏')
            .height(30)
            .fontSize($r('app.float.text_size_caption'))
            .fontColor(this.libraryFavorites.indexOf(item) !== -1
              ? Color.White
              : $r('app.color.accent_orange'))
            .backgroundColor(this.libraryFavorites.indexOf(item) !== -1
              ? $r('app.color.brand_primary')
              : (this.darkModeEnabled ? '#1e1e3a' : Color.White))
            .border({
              width: 1,
              color: this.libraryFavorites.indexOf(item) !== -1
                ? $r('app.color.brand_primary')
                : $r('app.color.accent_orange')
            })
            .borderRadius($r('app.float.radius_md'))
            .onClick(() => {
              this.toggleFavorite(item);
            })
        }
        .width('100%')
        .padding($r('app.float.spacing_px'))
        .borderRadius($r('app.float.radius_md'))
        .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
        .shadow({
          radius: 4,
          color: 'rgba(0, 0, 0, 0.03)',
          offsetX: 0,
          offsetY: 1
        })
        .margin({ bottom: 8 })
      }, (item: string) => item)
    }
    .width('100%')
    .margin({ top: $r('app.float.spacing_px') })
  }

  @Builder
  buildStudyMaterialsView() {
    Column() {
      // Folder grid: 2 columns
      Row() {
        this.buildFolderItem($r('sys.symbol.doc'), '课堂笔记')
        this.buildFolderItem($r('sys.symbol.doc_text'), '课后作业')
      }
      .width('100%')
      .margin({ bottom: $r('app.float.spacing_px') })

      Row() {
        this.buildFolderItem($r('sys.symbol.book'), '教材资料')
        this.buildFolderItem($r('sys.symbol.play_circle'), '教学视频')
      }
      .width('100%')
      .margin({ bottom: $r('app.float.spacing_px') })

      Row() {
        this.buildFolderItem($r('sys.symbol.doc'), '历年试题')
        this.buildFolderItem($r('sys.symbol.doc_text'), '实验报告')
      }
      .width('100%')
    }
    .width('100%')
    .margin({ top: $r('app.float.spacing_px') })
  }

  @Builder
  buildFolderItem(icon: Resource, label: string) {
    Row() {
      SymbolGlyph(icon)
        .fontSize(28)
        .fontColor([$r('app.color.brand_primary')])
      Text(label)
        .fontSize(this.bodySize())
        .fontColor(this.darkModeEnabled ? '#c0c0d8' : '#1D2129')
        .margin({ left: $r('app.float.spacing_px') })
      Blank()
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontSize(20)
        .fontColor([$r('app.color.text_secondary')])
    }
    .width('48%')
    .height(60)
    .borderRadius($r('app.float.radius_md'))
    .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
    .padding({ left: $r('app.float.spacing_px'), right: $r('app.float.spacing_px') })
    .shadow({
      radius: 4,
      color: 'rgba(0, 0, 0, 0.03)',
      offsetX: 0,
      offsetY: 1
    })
    .onClick(() => {
      LogUtils.info('Main', '打开资料: ' + label);
    })
  }

  @Builder
  ServiceCard(icon: Resource, label: string, color: Resource) {
    Column() {
      SymbolGlyph(icon)
        .fontSize(36)
        .fontColor([color])
      Text(label)
        .fontSize(this.bodySize())
        .fontColor(this.darkModeEnabled ? '#c0c0d8' : '#1D2129')
        .fontWeight(500)
        .margin({ top: $r('app.float.spacing_px') })
    }
    .width('49%')
    .height(120)
    .borderRadius($r('app.float.radius_md'))
    .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.05)',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      LogUtils.info('Main', '点击服务: ' + label);
      if (label === '失物招领') {
        this.navPathStack.pushPathByName('LostFound', null);
      } else if (label === '校园美食') {
        this.navPathStack.pushPathByName('CampusFood', null);
      } else if (label === '音乐播放') {
        this.navPathStack.pushPathByName('MusicPlayer', null);
      } else if (label === '校园工具') {
        this.navPathStack.pushPathByName('CampusTools', null);
      }
    })
  }
}
