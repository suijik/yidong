import { LogUtils } from '../../common/utils/LogUtils';

const TAG = 'Guide';

@Builder
export function GuideBuilder(name: string, param: string) {
  Guide()
}

@Component
export struct Guide {
  navPathStack: NavPathStack = new NavPathStack();
  @State currentIndex: number = 0;
  private swiperController: SwiperController = new SwiperController();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;

  // API 20 动画状态 (.animation() 修饰符驱动)
  @State btnOpacity: number = 0;
  @State btnOffsetY: number = 24;
  @State contentFadeIn: boolean = true;
  @State dotScale0: number = 1;
  @State dotScale1: number = 1;
  @State dotScale2: number = 1;

  private guideData: GuideItem[] = [
    {
      title: '校园信息，实时掌握',
      description: '校园公告、资讯、地图，一手了解校园动态'
    },
    {
      title: '学习助手，高效备考',
      description: '课程表、成绩查询、图书馆检索，助力学业提升'
    },
    {
      title: '生活服务，贴心相伴',
      description: '失物招领、校园美食、音乐播放，丰富校园生活'
    }
  ];

  aboutToAppear(): void {
    LogUtils.info(TAG, '引导页加载');
  }

  /**
   * 页面切换时触发动画：
   * - 第三页按钮——淡入 + 上移
   * - 当前指示器缩放
   */
  private onPageChange(index: number): void {
    this.currentIndex = index;

    // 重置按钮动画状态
    this.btnOpacity = 0;
    this.btnOffsetY = 24;
    if (index === 2) {
      setTimeout(() => {
        this.btnOpacity = 1;
        this.btnOffsetY = 0;
      }, 80);
    }

    // 内容淡入
    this.contentFadeIn = false;
    setTimeout(() => {
      this.contentFadeIn = true;
    }, 50);

    // 指示器缩放
    this.dotScale0 = index === 0 ? 1.3 : 1;
    this.dotScale1 = index === 1 ? 1.3 : 1;
    this.dotScale2 = index === 2 ? 1.3 : 1;
  }

  private navigateToLogin(): void {
    LogUtils.info(TAG, '点击立即进入，跳转登录页');
    try {
      if (this.navPathStack) {
        this.navPathStack.replacePathByName('Login', null);
      }
    } catch (err) {
      LogUtils.error(TAG, '跳转登录页失败', err);
    }
  }

  build() {
    NavDestination() {
      Stack() {
        // ==================== 背景层 ====================
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.bg_global'))

        // ==================== 主内容 ====================
        Column() {
          // 状态栏占位
          Column()
            .width('100%')
            .height(this.topRectHeight)

          // 左右滑动区域
          Swiper(this.swiperController) {
            ForEach(this.guideData, (item: GuideItem, index: number) => {
              // 单页布局：60% 引导图 + 40% 文字
              Column() {
                // ---- 上半部分（60%）：引导图 ----
                Row() {
                  Image(this.getGuideImage(index))
                    .width(360)
                    .height(300)
                    .objectFit(ImageFit.Contain)
                }
                .width('100%')
                .height('60%')
                .justifyContent(FlexAlign.Center)

                // ---- 下半部分（40%）：标题 + 说明 ----
                Column() {
                  // 标题（32sp，鸿蒙蓝，700）
                  Text(item.title)
                    .fontSize($r('app.float.text_size_title_large'))
                    .fontColor($r('app.color.brand_primary'))
                    .fontWeight(700)
                    .textAlign(TextAlign.Center)
                    .lineHeight(38)
                    .margin({ bottom: 12 })

                  // 说明文字（26sp，文字主色，行高 1.5 倍）
                  Text(item.description)
                    .fontSize($r('app.float.text_size_body'))
                    .fontColor($r('app.color.text_primary'))
                    .lineHeight(39)
                    .textAlign(TextAlign.Center)
                    .padding({ left: 32, right: 32 })
                }
                .width('100%')
                .height('40%')
                .justifyContent(FlexAlign.Start)
                .alignItems(HorizontalAlign.Center)
                .opacity(this.contentFadeIn ? 1 : 0)
                .animation({
                  duration: 350,
                  curve: Curve.FastOutSlowIn
                })
              }
              .width('100%')
              .height('100%')
            }, (item: GuideItem, index: number) => index.toString())
          }
          .index(this.currentIndex)
          .indicator(false)
          .loop(false)
          .duration(350)
          .curve(Curve.FastOutSlowIn)
          .onChange((index: number) => {
            this.onPageChange(index);
            LogUtils.infoFormat(TAG, '切换到第 %{public}d 页', index + 1);
          })
          .layoutWeight(1)
          .width('100%')

          // ==================== 底部固定区域 ====================
          Column() {
            // 立即进入按钮（仅第三页，80% 宽，48px 高，26sp）
            if (this.currentIndex === 2) {
              Button('立即进入')
                .width('80%')
                .height(48)
                .fontSize($r('app.float.text_size_body'))
                .fontWeight(FontWeight.Medium)
                .fontColor(Color.White)
                .backgroundColor($r('app.color.brand_primary'))
                .borderRadius($r('app.float.radius_md'))
                .shadow({
                  radius: 10,
                  color: 'rgba(22, 119, 255, 0.3)',
                  offsetX: 0,
                  offsetY: 4
                })
                .opacity(this.btnOpacity)
                .translate({ x: 0, y: this.btnOffsetY })
                .animation({
                  duration: 400,
                  curve: Curve.FastOutSlowIn
                })
                .onClick(() => {
                  this.navigateToLogin();
                })
            } else {
              // 占位保持布局稳定
              Column()
                .width('80%')
                .height(48)
            }

            // 间距
            Column()
              .height(20)

            // 页码指示器（3 个圆形，底部居中）
            Row() {
              // 第 1 个点
              Circle()
                .width(8)
                .height(8)
                .fill(this.currentIndex === 0
                  ? $r('app.color.brand_primary')
                  : Color.Transparent)
                .stroke(this.currentIndex === 0
                  ? $r('app.color.brand_primary')
                  : $r('app.color.border_light'))
                .strokeWidth(1.5)
                .margin({ left: 6, right: 6 })
                .scale({
                  x: this.currentIndex === 0 ? this.dotScale0 : 1,
                  y: this.currentIndex === 0 ? this.dotScale0 : 1
                })
                .animation({
                  duration: 300,
                  curve: Curve.FastOutSlowIn
                })
                .onClick(() => {
                  this.swiperController.changeIndex(0);
                  this.onPageChange(0);
                })

              // 第 2 个点
              Circle()
                .width(8)
                .height(8)
                .fill(this.currentIndex === 1
                  ? $r('app.color.brand_primary')
                  : Color.Transparent)
                .stroke(this.currentIndex === 1
                  ? $r('app.color.brand_primary')
                  : $r('app.color.border_light'))
                .strokeWidth(1.5)
                .margin({ left: 6, right: 6 })
                .scale({
                  x: this.currentIndex === 1 ? this.dotScale1 : 1,
                  y: this.currentIndex === 1 ? this.dotScale1 : 1
                })
                .animation({
                  duration: 300,
                  curve: Curve.FastOutSlowIn
                })
                .onClick(() => {
                  this.swiperController.changeIndex(1);
                  this.onPageChange(1);
                })

              // 第 3 个点
              Circle()
                .width(8)
                .height(8)
                .fill(this.currentIndex === 2
                  ? $r('app.color.brand_primary')
                  : Color.Transparent)
                .stroke(this.currentIndex === 2
                  ? $r('app.color.brand_primary')
                  : $r('app.color.border_light'))
                .strokeWidth(1.5)
                .margin({ left: 6, right: 6 })
                .scale({
                  x: this.currentIndex === 2 ? this.dotScale2 : 1,
                  y: this.currentIndex === 2 ? this.dotScale2 : 1
                })
                .animation({
                  duration: 300,
                  curve: Curve.FastOutSlowIn
                })
                .onClick(() => {
                  this.swiperController.changeIndex(2);
                  this.onPageChange(2);
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .padding({
            bottom: 20 + (this.bottomRectHeight || 0)
          })
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
    .onBackPressed(() => {
      // 仅第一页允许返回启动页
      if (this.currentIndex === 0) {
        return false;
      }
      this.swiperController.changeIndex(this.currentIndex - 1);
      this.onPageChange(this.currentIndex - 1);
      return true;
    })
    .onReady((ctx: NavDestinationContext) => {
      this.navPathStack = ctx.pathStack;
      LogUtils.info(TAG, 'onReady 完成');
    })
  }

  private getGuideImage(index: number): Resource {
    if (index === 0) {
      return $r('app.media.guide_1');
    } else if (index === 1) {
      return $r('app.media.guide_2');
    } else {
      return $r('app.media.guide_3');
    }
  }
}

interface GuideItem {
  title: string;
  description: string;
}
