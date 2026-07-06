/**
 * TodoPage - 待办事项页面
 *
 * 功能：
 * - 待办列表展示（添加/完成/删除）
 * - 通知提醒（推送通知到系统通知栏）
 */

import { NotificationUtil } from '../../common/utils/NotificationUtil';
import { PreferencesUtil } from '../../common/utils/PreferencesUtil';
import { LogUtils } from '../../common/utils/LogUtils';

const TAG = 'TodoPage';

/** 待办项数据结构 */
interface TodoItem {
  id: number;
  title: string;
  deadline: string;
  isCompleted: boolean;
  hasReminder: boolean;
  createdAt: string;
}

@Builder
export function TodoPageBuilder(name: string, param: string) {
  TodoPage()
}

@Component
export struct TodoPage {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;

  // 待办列表
  @State todoList: TodoItem[] = [];
  // 新增待办输入
  @State newTodoTitle: string = '';
  @State newTodoDeadline: string = '';
  @State showAddInput: boolean = false;
  // 筛选: 0=全部, 1=未完成, 2=已完成
  @State filterIndex: number = 0;
  filterOptions: string[] = ['全部', '未完成', '已完成'];
  // 强制刷新版本号
  @State version: number = 0;

  // Toast
  @State toastMessage: string = '';
  @State toastOpacity: number = 0;
  private toastTimer: number = -1;

  aboutToAppear(): void {
    if (this.topRectHeight === 0) {
      AppStorage.setOrCreate('topRectHeight', 42);
    }
    if (this.bottomRectHeight === 0) {
      AppStorage.setOrCreate('bottomRectHeight', 34);
    }
    this.loadTodoList();
  }

  aboutToDisappear(): void {
    this.clearToast();
  }

  /** 加载本地待办数据 */
  private loadTodoList(): void {
    try {
      const saved = AppStorage.get<string>('todoList');
      if (saved) {
        const rawArray = JSON.parse(saved) as Record<string, Object>[];
        this.todoList = rawArray.map((item: Record<string, Object>) => {
          return {
            id: item['id'] as number,
            title: item['title'] as string,
            deadline: item['deadline'] as string,
            isCompleted: item['isCompleted'] as boolean,
            hasReminder: item['hasReminder'] as boolean,
            createdAt: item['createdAt'] as string
          } as TodoItem;
        }) as TodoItem[];
      } else {
        // 默认示例数据
        this.todoList = [
          { id: 1, title: '完成数据结构作业', deadline: '今天 18:00', isCompleted: false, hasReminder: false, createdAt: '2026-07-01' },
          { id: 2, title: '复习操作系统考试', deadline: '明天 10:00', isCompleted: false, hasReminder: false, createdAt: '2026-07-02' },
          { id: 3, title: '提交实验报告', deadline: '7月5日', isCompleted: false, hasReminder: false, createdAt: '2026-07-03' },
          { id: 4, title: '借阅《计算机网络》', deadline: '7月10日', isCompleted: true, hasReminder: false, createdAt: '2026-06-28' }
        ];
        this.saveTodoList();
      }
    } catch (err) {
      LogUtils.error(TAG, '加载待办数据失败', err);
    }
  }

  /** 保存待办数据到本地 */
  private saveTodoList(): void {
    try {
      AppStorage.setOrCreate('todoList', JSON.stringify(this.todoList));
    } catch (err) {
      LogUtils.error(TAG, '保存待办数据失败', err);
    }
  }

  /** 获取筛选后的待办列表 */
  private getFilteredTodos(): TodoItem[] {
    if (this.filterIndex === 0) return this.todoList;
    if (this.filterIndex === 1) return this.todoList.filter((item) => !item.isCompleted);
    return this.todoList.filter((item) => item.isCompleted);
  }

  /** 添加新待办 */
  private addTodo(): void {
    const title = this.newTodoTitle.trim();
    if (!title) {
      this.showToast('请输入待办标题');
      return;
    }
    const deadline = this.newTodoDeadline.trim() || '未设置截止时间';

    const newItem: TodoItem = {
      id: Date.now(),
      title: title,
      deadline: deadline,
      isCompleted: false,
      hasReminder: false,
      createdAt: new Date().toISOString().slice(0, 10)
    };

    this.todoList = [newItem, ...this.todoList];
    this.version++;
    this.saveTodoList();
    this.showToast('添加成功');
    this.newTodoTitle = '';
    this.newTodoDeadline = '';
    this.showAddInput = false;
  }

  /** 切换待办完成状态 */
  private toggleTodo(item: TodoItem): void {
    const todo = this.todoList.find((t) => t.id === item.id);
    if (todo) {
      todo.isCompleted = !todo.isCompleted;
      this.todoList = [...this.todoList];
      this.version++;
      this.saveTodoList();
    }
  }

  /** 删除待办 */
  private deleteTodo(item: TodoItem): void {
    this.todoList = this.todoList.filter((t) => t.id !== item.id);
    this.version++;
    this.saveTodoList();
    if (item.hasReminder) {
      NotificationUtil.cancelNotification(item.id);
    }
    this.showToast('已删除');
  }

  /** 设置待办提醒（推送通知） */
  private async setReminder(item: TodoItem): Promise<void> {
    if (item.hasReminder) {
      await NotificationUtil.cancelNotification(item.id);
      item.hasReminder = false;
      this.todoList = [...this.todoList];
      this.version++;
      this.showToast('已取消提醒');
    } else {
      await NotificationUtil.publishTodoReminder(
        item.title,
        item.deadline,
        item.id
      );
      item.hasReminder = true;
      this.todoList = [...this.todoList];
      this.version++;
      this.showToast('已设置提醒');
    }
    this.saveTodoList();
  }

  // ==================== Toast ====================

  private showToast(msg: string): void {
    this.clearToast();
    this.toastMessage = msg;
    this.toastOpacity = 1;
    this.toastTimer = setTimeout(() => {
      this.toastOpacity = 0;
    }, 2000);
  }

  private clearToast(): void {
    if (this.toastTimer !== -1) {
      clearTimeout(this.toastTimer);
      this.toastTimer = -1;
    }
    this.toastOpacity = 0;
  }

  // ==================== 构建 UI ====================

  build() {
    NavDestination() {
      Column() {
        // 状态栏占位（与首页一致）
        Column()
          .width('100%')
          .height(this.topRectHeight)
          .backgroundColor(this.darkModeEnabled ? '#16162A' : '#F5F7FA')

        // 导航栏（与首页一致）
        Row() {
          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontSize(24)
            .fontColor([$r('app.color.brand_primary')])
            .onClick(() => {
              this.navPathStack.pop();
            })

          Text('我的待办')
            .fontSize($r('app.float.text_size_title_large'))
            .fontWeight(600)
            .fontColor($r('app.color.text_primary'))
            .margin({ left: 8 })

          Blank()
        }
        .width('100%')
        .height(56)
        .padding({
          left: $r('app.float.spacing_lg'),
          right: $r('app.float.spacing_lg')
        })

        // 筛选栏
        Row() {
          ForEach(this.filterOptions, (option: string, index: number) => {
            Text(option)
              .fontSize($r('app.float.text_size_body'))
              .fontColor(this.filterIndex === index
                ? Color.White
                : (this.darkModeEnabled ? '#c0c0d8' : '#1D2129'))
              .fontWeight(this.filterIndex === index ? 600 : 400)
              .height(32)
              .padding({ left: 16, right: 16 })
              .backgroundColor(this.filterIndex === index
                ? $r('app.color.brand_primary')
                : (this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA'))
              .borderRadius(16)
              .margin({ right: 8 })
              .onClick(() => {
                this.filterIndex = index;
              })
          }, (option: string) => option)
        }
        .width('100%')
        .padding({
          left: $r('app.float.spacing_lg'),
          right: $r('app.float.spacing_lg'),
          top: 4,
          bottom: 8
        })

        // 添加待办区域
        if (this.showAddInput) {
          Column() {
            Row() {
              TextInput({ placeholder: '输入待办事项' })
                .layoutWeight(1)
                .height(44)
                .placeholderColor($r('app.color.text_secondary'))
                .placeholderFont({ size: 15 })
                .padding({ left: 12, right: 12 })
                .onChange((v: string) => {
                  this.newTodoTitle = v;
                })

              Button('添加')
                .height(44)
                .fontSize(15)
                .fontColor(Color.White)
                .backgroundColor($r('app.color.brand_primary'))
                .borderRadius(8)
                .margin({ left: 8 })
                .onClick(() => {
                  this.addTodo();
                })
            }
            .width('100%')

            TextInput({ placeholder: '截止时间（可选，如: 明天 18:00）' })
              .width('100%')
              .height(36)
              .placeholderColor($r('app.color.text_secondary'))
              .placeholderFont({ size: 13 })
              .padding({ left: 12, right: 12 })
              .margin({ top: 8 })
              .onChange((v: string) => {
                this.newTodoDeadline = v;
              })
          }
          .width('100%')
          .padding(12)
          .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
          .borderRadius(8)
          .shadow({
            radius: 4,
            color: 'rgba(0, 0, 0, 0.05)',
            offsetX: 0,
            offsetY: 2
          })
          .margin({
            left: $r('app.float.spacing_lg'),
            right: $r('app.float.spacing_lg'),
            bottom: 8
          })
        }

        // 添加按钮（快捷）
        if (!this.showAddInput) {
          Row() {
            SymbolGlyph($r('sys.symbol.plus'))
              .fontSize(20)
              .fontColor([$r('app.color.brand_primary')])
            Text('添加待办事项')
              .fontSize($r('app.float.text_size_body'))
              .fontColor($r('app.color.brand_primary'))
              .margin({ left: 8 })
            Blank()
          }
          .width('100%')
          .height(44)
          .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
          .borderRadius(8)
          .padding({ left: 16, right: 16 })
          .shadow({
            radius: 4,
            color: 'rgba(0, 0, 0, 0.03)',
            offsetX: 0,
            offsetY: 1
          })
          .margin({
            left: $r('app.float.spacing_lg'),
            right: $r('app.float.spacing_lg'),
            bottom: 8
          })
          .onClick(() => {
            this.showAddInput = true;
          })
        }

        // 待办列表 — 空状态居中显示，有内容时 Scroll
        if (this.getFilteredTodos().length === 0) {
          Column() {
            Stack() {
              Circle()
                .width(72)
                .height(72)
                .fill('rgba(22, 119, 255, 0.06)')
              SymbolGlyph($r('sys.symbol.checkmark'))
                .fontSize(32)
                .fontColor([$r('app.color.text_secondary')])
            }
            Text('暂无待办事项')
              .fontSize($r('app.float.text_size_body'))
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 12 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          Scroll() {
            Column() {
              ForEach(this.getFilteredTodos(), (item: TodoItem) => {
                Row() {
                  // 完成/未完成勾选
                  Circle()
                    .width(22)
                    .height(22)
                    .fill(item.isCompleted
                      ? $r('app.color.accent_green')
                      : (this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA'))
                    .stroke(item.isCompleted
                      ? $r('app.color.accent_green')
                      : (this.darkModeEnabled ? '#2a2a4a' : '#E5E6EB'))
                    .strokeWidth(1.5)

                  if (item.isCompleted) {
                    SymbolGlyph($r('sys.symbol.checkmark'))
                      .fontSize(12)
                      .fontColor([Color.White])
                      .offset({ x: -22, y: 0 })
                  }

                  Column() {
                    Text(item.title)
                      .fontSize($r('app.float.text_size_body'))
                      .fontColor(item.isCompleted
                        ? $r('app.color.text_secondary')
                        : $r('app.color.text_primary'))
                      .fontWeight(item.isCompleted ? 400 : 500)
                      .decoration({
                        type: item.isCompleted ? TextDecorationType.LineThrough : TextDecorationType.None
                      })
                      .width('100%')

                    Row() {
                      SymbolGlyph($r('sys.symbol.clock'))
                        .fontSize(12)
                        .fontColor([$r('app.color.text_secondary')])
                      Text(item.deadline)
                        .fontSize(12)
                        .fontColor($r('app.color.text_secondary'))
                        .margin({ left: 4 })
                    }
                    .width('100%')
                    .margin({ top: 4 })
                    .alignItems(VerticalAlign.Center)
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 10 })

                  // 操作按钮
                  Row() {
                    SymbolGlyph($r('sys.symbol.bell'))
                      .fontSize(18)
                      .fontColor([item.hasReminder
                        ? $r('app.color.accent_orange')
                        : $r('app.color.text_secondary')])
                      .onClick(() => {
                        this.setReminder(item);
                      })

                    SymbolGlyph($r('sys.symbol.trash'))
                      .fontSize(18)
                      .fontColor([$r('app.color.text_secondary')])
                      .margin({ left: 12 })
                      .onClick(() => {
                        this.deleteTodo(item);
                      })
                  }
                  .alignItems(VerticalAlign.Center)
                }
                .width('100%')
                .padding(14)
                .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
                .shadow({
                  radius: 4,
                  color: 'rgba(0, 0, 0, 0.03)',
                  offsetX: 0,
                  offsetY: 1
                })
                .margin({ bottom: 8 })
                .onClick(() => {
                  this.toggleTodo(item);
                })
              }, (item: TodoItem) => item.id.toString() + '_' + this.version)
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
        }

        // Toast 反馈
        if (this.toastMessage.length > 0) {
          Text(this.toastMessage)
            .fontSize(14)
            .fontColor(Color.White)
            .height(36)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .backgroundColor('rgba(0, 0, 0, 0.8)')
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .margin({ bottom: 16 })
            .alignSelf(ItemAlign.Center)
            .opacity(this.toastOpacity)
            .animation({
              duration: 300,
              curve: Curve.Friction
            })
        }

        // 底部安全区域
        Column()
          .width('100%')
          .height(this.bottomRectHeight)
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
}
