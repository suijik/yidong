/**
 * CampusTools - 校园工具页面
 *
 * 功能：
 * - 工具卡片网格展示
 * - 常用校园工具快捷入口
 */

import { LogUtils } from '../../common/utils/LogUtils';

const TAG = 'CampusTools';

interface ToolItem {
  id: number;
  icon: Resource;
  label: string;
  description: string;
}

const TOOLS: ToolItem[] = [
  { id: 1, icon: $r('sys.symbol.textformat'), label: '计算器', description: '简单计算' },
  { id: 2, icon: $r('sys.symbol.calendar'), label: '校历查询', description: '学期安排' },
  { id: 3, icon: $r('sys.symbol.clock'), label: '作息时间', description: '上课时间表' },
  { id: 4, icon: $r('sys.symbol.map'), label: '校车时刻', description: '班车时间' },
  { id: 5, icon: $r('sys.symbol.map'), label: '校园导航', description: '楼宇位置' },
  { id: 6, icon: $r('sys.symbol.doc_text'), label: '课表导出', description: '导出课程表' },
  { id: 7, icon: $r('sys.symbol.message'), label: '常用电话', description: '紧急联系' },
  { id: 8, icon: $r('sys.symbol.doc'), label: '教务系统', description: '快速访问' }
];

@Builder
export function CampusToolsBuilder(name: string, param: string) {
  CampusTools()
}

@Component
export struct CampusTools {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;

  aboutToAppear(): void {
    const dm: Object | undefined = AppStorage.get('darkModeEnabled');
    if (dm !== undefined) {
      this.darkModeEnabled = dm as boolean;
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

        // Nav bar
        Row() {
          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontSize(24)
            .fontColor([$r('app.color.brand_primary')])
            .onClick(() => {
              this.navPathStack.pop();
            })
          Text('校园工具')
            .fontSize($r('app.float.text_size_title_large'))
            .fontWeight(600)
            .fontColor(this.darkModeEnabled ? '#e0e0f0' : $r('app.color.text_primary'))
            .margin({ left: 8 })
          Blank()
        }
        .width('100%')
        .height(56)
        .padding({
          left: $r('app.float.spacing_lg'),
          right: $r('app.float.spacing_lg')
        })

        // Banner
        Column() {
          Row() {
            SymbolGlyph($r('sys.symbol.gearshape'))
              .fontSize(28)
              .fontColor([Color.White])
            Column() {
              Text('校园工具箱')
                .fontSize($r('app.float.text_size_title_medium'))
                .fontColor(Color.White)
                .fontWeight(600)
              Text('常用校园工具，一触即达')
                .fontSize($r('app.float.text_size_caption'))
                .fontColor('rgba(255, 255, 255, 0.8)')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: $r('app.float.spacing_px') })
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor($r('app.color.brand_primary'))
        .borderRadius($r('app.float.radius_md'))
        .margin({
          left: $r('app.float.spacing_lg'),
          right: $r('app.float.spacing_lg'),
          bottom: $r('app.float.spacing_px')
        })

        // Tool grid: 2x4
        Scroll() {
          Column() {
            ForEach(TOOLS, (item: ToolItem) => {
              Row() {
                Stack() {
                  Circle()
                    .width(48)
                    .height(48)
                    .fill(this.darkModeEnabled ? 'rgba(22, 119, 255, 0.15)' : 'rgba(22, 119, 255, 0.08)')
                  SymbolGlyph(item.icon)
                    .fontSize(24)
                    .fontColor([$r('app.color.brand_primary')])
                }

                Column() {
                  Text(item.label)
                    .fontSize($r('app.float.text_size_body'))
                    .fontColor(this.darkModeEnabled ? '#e0e0f0' : $r('app.color.text_primary'))
                    .fontWeight(500)
                  Text(item.description)
                    .fontSize($r('app.float.text_size_caption'))
                    .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                .margin({ left: $r('app.float.spacing_px') })

                SymbolGlyph($r('sys.symbol.chevron_right'))
                  .fontSize(20)
                  .fontColor([this.darkModeEnabled ? '#6a6a8e' : $r('app.color.text_secondary')])
              }
              .width('100%')
              .height(68)
              .padding(14)
              .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
              .borderRadius($r('app.float.radius_md'))
              .shadow({
                radius: 4,
                color: 'rgba(0, 0, 0, 0.03)',
                offsetX: 0,
                offsetY: 1
              })
              .margin({ bottom: $r('app.float.spacing_px') })
              .onClick(() => {
                LogUtils.info(TAG, '点击工具: ' + item.label);
              })
            }, (item: ToolItem) => item.id.toString())
          }
          .width('100%')
          .constraintSize({ minHeight: '100%' })
          .padding({
            left: $r('app.float.spacing_lg'),
            right: $r('app.float.spacing_lg'),
            bottom: $r('app.float.spacing_md')
          })
        }
        .width('100%')
        .layoutWeight(1)

        // Bottom safe area
        Column()
          .width('100%')
          .height(this.bottomRectHeight)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.darkModeEnabled ? '#1A1A2E' : $r('app.color.bg_global'))
    }
    .hideBackButton(true)
    .onReady((ctx: NavDestinationContext) => {
      this.navPathStack = ctx.pathStack;
    })
  }
}
