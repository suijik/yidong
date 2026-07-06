/**
 * FloatingWindowUtil - 悬浮窗工具（应用内浮层实现）
 *
 * 替代 TYPE_FLOAT 和 PiP 方案
 * 使用应用内 Stack 浮层，无需任何特殊权限
 * 所有设备和模拟器均可使用
 */

import { common } from '@kit.AbilityKit';

const TAG = 'FloatingWindowUtil';

export enum FloatWindowState {
  NOT_CREATED,
  SHOWING,
  HIDDEN,
  UNSUPPORTED
}

/** 模块级单例 */
let instance: FloatingWindowUtil | null = null;

export class FloatingWindowUtil {
  private state: FloatWindowState = FloatWindowState.NOT_CREATED;
  private context: common.Context | null = null;
  private pendingTodoCount: number = 0;

  static getInstance(): FloatingWindowUtil {
    if (!instance) {
      instance = new FloatingWindowUtil();
    }
    return instance;
  }

  init(context: common.Context): void {
    this.context = context;
    console.info(TAG, '悬浮窗工具初始化（应用内浮层）');
  }

  async show(): Promise<boolean> {
    this.state = FloatWindowState.SHOWING;
    AppStorage.setOrCreate('floatWindowVisible', true);
    return true;
  }

  async hide(): Promise<void> {
    this.state = FloatWindowState.HIDDEN;
    AppStorage.setOrCreate('floatWindowVisible', false);
  }

  async destroy(): Promise<void> {
    this.state = FloatWindowState.NOT_CREATED;
    AppStorage.setOrCreate('floatWindowVisible', false);
  }

  setPendingTodoCount(count: number): void {
    this.pendingTodoCount = count;
    AppStorage.setOrCreate('floatPendingTodoCount', count);
  }

  getPendingTodoCount(): number {
    return this.pendingTodoCount;
  }

  getState(): FloatWindowState {
    return this.state;
  }

  async toggle(): Promise<boolean> {
    if (this.state === FloatWindowState.SHOWING) {
      await this.hide();
      return false;
    } else {
      await this.show();
      return true;
    }
  }

  getStateText(): string {
    switch (this.state) {
      case FloatWindowState.NOT_CREATED:
        return '未创建';
      case FloatWindowState.HIDDEN:
        return '已隐藏';
      case FloatWindowState.SHOWING:
        return '显示中';
      case FloatWindowState.UNSUPPORTED:
        return '设备不支持';
    }
  }
}
