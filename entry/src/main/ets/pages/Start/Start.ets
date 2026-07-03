import { preferences } from '@kit.ArkData';
import { window } from '@kit.ArkUI';
import { LogUtils } from '../../common/utils/LogUtils'

const TAG = 'StartPage';

@Builder
export function StartBuilder(name: string, param: string) {
  Start()
}

@Component
export struct Start {
  navPathStack: NavPathStack = new NavPathStack();

  @State progressValue: number = 0;
  private progressTimer: number = -1;
  private countdownTimer: number = -1;
  private hasNavigated: boolean = false;

  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;

  aboutToAppear(): void {
    LogUtils.info('TEST_TAG', '========== 启动页加载了 ==========');
    this.setImmersiveWindow();
    this.startCountdown();
    this.startProgressAnimation();
  }

  aboutToDisappear(): void {
    this.clearTimers();
  }

  private async setImmersiveWindow(): Promise<void> {
    try {
      const hostContext = this.getUIContext().getHostContext();

      if(!hostContext) {
        console.error('获取 HostContext 失败：组件未挂载或宿主 Ability 已销毁');
        return
      }

      const mainWindow = await window.getLastWindow(hostContext);

      await mainWindow.setWindowLayoutFullScreen(true);
      const uiContext = this.getUIContext();
      const systemAvoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const topHeightPx = systemAvoidArea.topRect.height;
      const topHeight = uiContext.px2vp(topHeightPx);
      AppStorage.setOrCreate('topRectHeight', topHeight);

      const navAvoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      const bottomHeightPx = navAvoidArea.bottomRect.height;
      //  正确写法：同样通过 uiContext 调用
      const bottomHeight = uiContext.px2vp(bottomHeightPx);
      AppStorage.setOrCreate('bottomRectHeight', bottomHeight);

      // 监听窗口区域变化
      mainWindow.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          const newTopHeightPx = data.area.topRect.height;
          //  监听回调中也通过 uiContext 调用
          const newTopHeight = uiContext.px2vp(newTopHeightPx);
          AppStorage.setOrCreate('topRectHeight', newTopHeight);
        } else if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          const newBottomHeightPx = data.area.bottomRect.height;
          const newBottomHeight = uiContext.px2vp(newBottomHeightPx);
          AppStorage.setOrCreate('bottomRectHeight', newBottomHeight);
        }
      });

      console.info('沉浸式窗口设置成功');
    } catch (err) {
      console.error('沉浸式窗口设置失败：' + JSON.stringify(err));
    }
  }

  private startCountdown(): void {
    this.countdownTimer = setTimeout(() => {
      if (!this.hasNavigated) {
        this.checkAndNavigate();
      }
    }, 3000);
  }

  private startProgressAnimation(): void {
    const totalDuration = 3000;
    const interval = 30;
    const step = interval / totalDuration;

    this.progressTimer = setInterval(() => {
      if (this.progressValue < 1) {
        this.progressValue += step;
        if (this.progressValue > 1) {
          this.progressValue = 1;
        }
      } else {
        this.clearProgressTimer();
      }
    }, interval);
  }

  private async checkAndNavigate(): Promise<void> {
    /*
    try {
      // 获取偏好存储
      const hostContext = this.getUIContext().getHostContext();
      if (!hostContext) {
        LogUtils.info(TAG, '获取存储失败')
        this.navigateToLoginPage();
        return;
      }
      LogUtils.info(TAG, '获取存储成功')
      const dataPreferences = await preferences.getPreferences(hostContext, 'app_preferences');
      // 获取是否首次启动，默认为 true
      const isFirstLaunch = await dataPreferences.get('isFirstLaunch', true);

      if (true) {
        // 首次启动：设置为 false，然后跳转引导页
        await dataPreferences.put('isFirstLaunch', false);
        await dataPreferences.flush();
        this.navigateToGuidePage();
      } else {
        // 非首次启动：直接跳转首页
        this.navigateToLoginPage();
      }
    } catch (err) {
      LogUtils.error(TAG, '沉浸式窗口设置失败', err);
      // 出错时默认跳转首页
      this.navigateToLoginPage();
    }*/
    this.navigateToMainPage();
  }

  private skipSplash(): void {
    if (this.hasNavigated) {
      return;
    }
    this.hasNavigated = true;
    this.clearTimers();
    this.navigateToMainPage();
  }

  private navigateToMainPage(): void {
    try {
      if (this.navPathStack) {
        this.navPathStack.replacePathByName('Main', null);
      }
    } catch (err) {
      console.error('页面跳转失败：' + JSON.stringify(err));
    }
  }

  private navigateToLoginPage(): void {
    try {
      if (this.navPathStack) {
        this.navPathStack.replacePathByName('Login', null);
      }
    } catch (err) {
      console.error('页面跳转失败：' + JSON.stringify(err));
    }
  }

  private navigateToGuidePage(): void {
    try {
      if (this.navPathStack) {
        // 使用 replace 替换当前页面，防止返回启动页
        LogUtils.info(TAG,'跳转引导页成功')
        this.navPathStack.replacePathByName('Guide', null);
      }
    } catch (err) {
      console.error('跳转引导页失败：' + JSON.stringify(err));
    }
  }

  private clearTimers(): void {
    if (this.progressTimer !== -1) {
      clearInterval(this.progressTimer);
      this.progressTimer = -1;
    }
    if (this.countdownTimer !== -1) {
      clearTimeout(this.countdownTimer);
      this.countdownTimer = -1;
    }
  }

  private clearProgressTimer(): void {
    if (this.progressTimer !== -1) {
      clearInterval(this.progressTimer);
      this.progressTimer = -1;
    }
  }

  build() {
    NavDestination() {
      Stack() {
        // 渐变背景
        Column()
          .width('100%')
          .height('100%')
          .linearGradient({
            angle: 135,
            colors: [
              ['#1677FF', 0.0],
              ['#4096FF', 1.0]
            ]
          })

        // 主内容
        Column() {
          // Logo区域 - 使用文字替代图片
          Column() {
            // 使用圆形背景 + 文字图标作为临时 Logo
            Column() {
              // 书本图标符号（使用文字模拟）
              Text('📚')
                .fontSize(64)
                .margin({ bottom: 8 })

              // 校园建筑符号
              Text('🏛️')
                .fontSize(64)
            }
            .width(120)
            .height(120)
            .borderRadius(60)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .margin({ bottom: 30 })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.End)

          Column() {
            Text('高校校园助手')
              .fontSize(36)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ bottom: 12 })

            Text('HarmonyOS NEXT 版')
              .fontSize(24)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
              .opacity(0.9)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

          Column() {
            Row() {
              Text('开发团队')
                .fontSize(22)
                .fontColor(Color.White)
                .opacity(0.8)
                .margin({ right: 12 })

              Progress({
                value: this.progressValue,
                total: 1,
                type: ProgressType.Ring
              })
                .width(24)
                .height(24)
                .color(Color.White)
                .backgroundColor('rgba(255, 255, 255, 0.3)')
                .style({
                  strokeWidth: 3,
                })
            }
            .margin({ bottom: 30 })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.End)
        }
        .width('100%')
        .height('100%')
        .padding({
          top: this.topRectHeight,
          bottom: this.bottomRectHeight
        })
      }
      .width('100%')
      .height('100%')
      .onClick(() => {
        this.skipSplash();
      })
    }
    .hideBackButton(true)
    .onReady((ctx: NavDestinationContext) => {
      this.navPathStack = ctx.pathStack;
    })
  }
}