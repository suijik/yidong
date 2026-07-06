import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { NotificationUtil } from '../common/utils/NotificationUtil';
import { FloatingWindowUtil } from '../common/utils/FloatingWindowUtil';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    // 销毁悬浮窗
    FloatingWindowUtil.getInstance().destroy();
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');

      // Get window avoid areas for safe area insets
      windowStage.getMainWindow().then((win: window.Window) => {
        try {
          const systemArea: window.AvoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
          AppStorage.setOrCreate('topRectHeight', systemArea.topRect.height);
          AppStorage.setOrCreate('bottomRectHeight', systemArea.bottomRect.height);
        } catch (e) {
          hilog.error(DOMAIN, 'testTag', 'Failed to get avoid area. Cause: %{public}s', JSON.stringify(e));
        }
      }).catch((err: Error) => {
        hilog.error(DOMAIN, 'testTag', 'Failed to get main window. Cause: %{public}s', JSON.stringify(err));
      });

      // 初始化通知模块
      try {
        NotificationUtil.init(this.context);
      } catch (e) {
        hilog.error(DOMAIN, 'testTag', 'Failed to init notification. Cause: %{public}s', JSON.stringify(e));
      }

      // 初始化悬浮窗工具
      try {
        FloatingWindowUtil.getInstance().init(this.context);
      } catch (e) {
        hilog.error(DOMAIN, 'testTag', 'Failed to init floating window. Cause: %{public}s', JSON.stringify(e));
      }
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
