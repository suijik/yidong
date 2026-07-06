/**
 * FloatContent - 悬浮窗内容页面
 *
 * 在悬浮窗中显示的紧凑卡片页面
 * 展示待办待办计数和快捷操作按钮
 */

import { FloatingWindowUtil, FloatWindowState } from '../../common/utils/FloatingWindowUtil';

@Entry
@Component
struct FloatContent {
  @StorageProp('floatPendingTodoCount') pendingTodoCount: number = 0;
  /** 是否展开模式 */
  @State isExpanded: boolean = false;

  build() {
    Column() {
      if (!this.isExpanded) {
        // ===== 收缩模式：仅显示待办计数图标 =====
        Stack() {
          Circle()
            .width(48)
            .height(48)
            .fill($r('app.color.brand_primary'))
            .shadow({
              radius: 8,
              color: 'rgba(22, 119, 255, 0.4)',
              offsetX: 0,
              offsetY: 4
            })

          SymbolGlyph($r('sys.symbol.checkmark'))
            .fontSize(22)
            .fontColor([Color.White])

          if (this.pendingTodoCount > 0) {
            Text(this.pendingTodoCount.toString())
              .fontSize(11)
              .fontColor(Color.White)
              .fontWeight(700)
              .backgroundColor($r('app.color.accent_orange'))
              .width(20)
              .height(20)
              .borderRadius(10)
              .textAlign(TextAlign.Center)
              .align(Alignment.TopEnd)
              .offset({ x: 8, y: -8 })
          }
        }
        .width(48)
        .height(48)
        .onAppear(() => {
          // 无待办时自动展开
          if (this.pendingTodoCount <= 0) {
            this.isExpanded = true;
          }
        })
      } else {
        // ===== 展开模式：显示详情和操作按钮 =====
        Column() {
          // 标题行
          Row() {
            Text('待办提醒')
              .fontSize(15)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(600)

            Blank()

            Text('收起')
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
              .onClick(() => {
                this.isExpanded = false;
              })
          }
          .width('100%')
          .margin({ bottom: 8 })

          // 内容区域
          if (this.pendingTodoCount > 0) {
            Scroll() {
              Column() {
                Text('您有 ' + this.pendingTodoCount.toString() + ' 条待办事项')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .width('100%')
                  .margin({ bottom: 8 })

                Button('查看全部待办')
                  .width('100%')
                  .height(32)
                  .fontSize(13)
                  .fontColor(Color.White)
                  .backgroundColor($r('app.color.brand_primary'))
                  .borderRadius(6)
                  .onClick(() => {
                    AppStorage.setOrCreate('floatNavigateToTodo', true);
                    this.hideFloatingWindow();
                  })
              }
              .width('100%')
            }
            .width('100%')
            .height(80)
          } else {
            Text('暂无待办事项')
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .width('100%')
              .height(60)
          }
        }
        .width('100%')
        .padding(12)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow({
      radius: 16,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 8
    })
  }

  private hideFloatingWindow(): void {
    const floatUtil = FloatingWindowUtil.getInstance();
    floatUtil.hide();
  }
}
