/**
 * PiPUtil - 画中画工具
 *
 * 基于 HarmonyOS NEXT API 20 的 PiPWindow
 * 替代 TYPE_FLOAT 悬浮窗，在手机上可用
 *
 * 使用 customUIController + BuilderNode + NodeController
 * 显示自定义静态内容（待办提醒）
 */

import { PiPWindow, BuilderNode, FrameNode, NodeController, UIContext, XComponentController } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

const TAG = 'PiPUtil';

/** PiP 内容参数 */
class PiPParams {
  pendingCount: number = 0;

  constructor(count: number) {
    this.pendingCount = count;
  }
}

/** PiP 画中画内容 Builder */
@Builder
function PiPContentBuilder(params: PiPParams) {
  Column() {
    Row() {
      SymbolGlyph($r('sys.symbol.checkmark'))
        .fontSize(18)
        .fontColor([Color.White])
      Text('待办 ' + params.pendingCount.toString() + ' 项')
        .fontSize(14)
        .fontColor(Color.White)
        .margin({ left: 4 })
    }
    .alignItems(VerticalAlign.Center)
    .margin({ bottom: 4 })

    Text('点击查看详情')
      .fontSize(11)
      .fontColor('rgba(255, 255, 255, 0.7)')
  }
  .width('100%')
  .height('100%')
  .backgroundColor($r('app.color.brand_primary'))
  .borderRadius(8)
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
}

/** PiP 内容节点控制器 */
class PiPContentNodeController extends NodeController {
  private contentNode: BuilderNode<[PiPParams]> | null = null;
  private pendingCount: number = 0;

  setPendingCount(count: number): void {
    this.pendingCount = count;
    if (this.contentNode) {
      this.contentNode.update(new PiPParams(count));
    }
  }

  makeNode(context: UIContext): FrameNode | null {
    this.contentNode = new BuilderNode(context);
    this.contentNode.build(
      wrapBuilder<[PiPParams]>(PiPContentBuilder),
      new PiPParams(this.pendingCount)
    );
    return this.contentNode.getFrameNode();
  }
}

/** 模块级单例 */
let pipInstance: PiPUtil | null = null;

/**
 * PiP 工具类（单例）
 * 管理画中画的创建、启动、停止
 */
export class PiPUtil {
  private pipController: PiPWindow.PiPController | undefined;
  private nodeController: PiPContentNodeController = new PiPContentNodeController();
  private context: common.Context | null = null;

  /** 获取单例 */
  static getInstance(): PiPUtil {
    if (!pipInstance) {
      pipInstance = new PiPUtil();
    }
    return pipInstance;
  }

  /** 初始化（传入 Context） */
  init(context: common.Context): void {
    this.context = context;
  }

  /** 获取节点控制器 */
  getNodeController(): PiPContentNodeController {
    return this.nodeController;
  }

  /** 更新待办计数 */
  updatePendingCount(count: number): void {
    this.nodeController.setPendingCount(count);
  }

  /** 启动画中画 */
  async start(xcompController: XComponentController): Promise<boolean> {
    if (this.pipController) {
      console.info(TAG, 'PiP 已在运行中');
      return true;
    }

    if (!this.context) {
      console.error(TAG, 'Context 未初始化');
      return false;
    }

    try {
      const config: PiPWindow.PiPConfiguration = {
        context: this.context,
        componentController: xcompController,
        templateType: PiPWindow.PiPTemplateType.VIDEO_CALL,
        contentWidth: 240,
        contentHeight: 120,
        customUIController: this.nodeController
      } as PiPWindow.PiPConfiguration;

      this.pipController = await PiPWindow.create(config);
      await this.pipController.startPiP();
      console.info(TAG, '画中画启动成功');
      return true;
    } catch (err) {
      const bizErr: BusinessError = err as BusinessError;
      console.error(TAG, '画中画启动失败: code=' + bizErr.code + ', message=' + bizErr.message);
      return false;
    }
  }

  /** 停止画中画 */
  async stop(): Promise<void> {
    if (this.pipController) {
      try {
        await this.pipController.stopPiP();
        console.info(TAG, '画中画已停止');
      } catch (err) {
        console.error(TAG, '停止画中画失败');
      }
      this.pipController = undefined;
    }
  }

  /** 切换画中画 */
  async toggle(xcompController: XComponentController): Promise<boolean> {
    if (this.pipController) {
      await this.stop();
      return false;
    }
    return await this.start(xcompController);
  }

  /** 是否正在运行 */
  isActive(): boolean {
    return this.pipController !== undefined;
  }

  /** 销毁 */
  destroy(): void {
    this.stop();
  }
}
