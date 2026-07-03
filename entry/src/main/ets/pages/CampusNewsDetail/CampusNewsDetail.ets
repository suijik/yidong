@Builder
export function CampusNewsDetailBuilder(name: string, param: Object) {
  CampusNewsDetail({ newsParam: param as Record<string, Object> })
}

@Component
export struct CampusNewsDetail {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  newsParam: Record<string, Object> = {};

  @State newsId: number = 0;
  @State newsTitle: string = '';
  @State newsContent: string = '';
  @State newsSource: string = '';
  @State newsPublishTime: string = '';

  aboutToAppear(): void {
    if (this.newsParam) {
      this.newsId = this.newsParam['id'] as number;
      this.newsTitle = this.newsParam['title'] as string;
      this.newsContent = this.newsParam['content'] as string;
      this.newsSource = this.newsParam['source'] as string;
      this.newsPublishTime = this.newsParam['publishTime'] as string;
    }
  }

  build() {
    NavDestination() {
      Column() {
        // 状态栏占位（背景色与标题栏一致，避免色差）
        Column()
          .width('100%')
          .height(this.topRectHeight)

        // 手动标题栏（仿系统隐藏 title 的返回按钮样式：圆圈 + < 箭头）
        Row() {
          Stack() {
            Circle()
              .width(32)
              .height(32)
              .fill($r('app.color.bg_global'))
            SymbolGlyph($r('sys.symbol.chevron_left'))
              .fontSize(18)
              .fontColor([$r('app.color.text_primary')])
          }
          .onClick(() => {
            this.navPathStack.pop();
          })

          Blank()
        }
        .width('100%')
        .height(48)
        .padding({
          left: 8,
          right: $r('app.float.spacing_lg')
        })

        // 分割线
        Column()
          .width('100%')
          .height(1)
          .backgroundColor($r('app.color.border_light'))

        // 主内容区
        Column() {
          Scroll() {
            Column() {
              // 标题
              Text(this.newsTitle)
                .fontSize($r('app.float.text_size_title_large'))
                .fontColor($r('app.color.text_primary'))
                .fontWeight(700)
                .width('100%')
                .margin({ top: $r('app.float.spacing_px') })

              // 来源 + 时间
              Row() {
                Text(this.newsSource)
                  .fontSize($r('app.float.text_size_caption'))
                  .fontColor($r('app.color.brand_primary'))
                Blank()
                Text(this.newsPublishTime)
                  .fontSize($r('app.float.text_size_caption'))
                  .fontColor($r('app.color.text_secondary'))
              }
              .width('100%')
              .margin({ top: $r('app.float.spacing_px') })

              // 分割线
              Column()
                .width('100%')
                .height(1)
                .backgroundColor($r('app.color.border_light'))
                .margin({ top: $r('app.float.spacing_px'), bottom: $r('app.float.spacing_md') })

              // 正文
              Text(this.newsContent)
                .fontSize($r('app.float.text_size_body'))
                .fontColor($r('app.color.text_primary'))
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
        .layoutWeight(1)
        .backgroundColor($r('app.color.bg_global'))

        // 底部安全区域
        Column()
          .width('100%')
          .height(this.bottomRectHeight)
      }
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.navPathStack = ctx.pathStack;
    })
  }
}
