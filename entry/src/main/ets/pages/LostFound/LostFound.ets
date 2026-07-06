/**
 * LostFound - 失物招领页面
 *
 * 功能：
 * - 失物/招领列表展示
 * - 失物/招领分类切换
 * - 联系方式查看
 */

import { LogUtils } from '../../common/utils/LogUtils';

const TAG = 'LostFound';

interface LostItem {
  id: number;
  type: 'lost' | 'found';
  title: string;
  description: string;
  location: string;
  contact: string;
  date: string;
  status: string;
}

const LOST_ITEMS: LostItem[] = [
  {
    id: 1, type: 'lost', title: '蓝色卡包',
    description: '内含学生证、银行卡数张，失主很着急',
    location: '教学楼A区3楼', contact: '王同学 138****5678', date: '2026-07-02', status: '寻找中'
  },
  {
    id: 2, type: 'lost', title: '黑色耳机仓',
    description: 'AirPods Pro 二代，左耳刻有姓名缩写"ZY"',
    location: '图书馆二楼', contact: '李同学 139****2345', date: '2026-07-01', status: '寻找中'
  },
  {
    id: 3, type: 'lost', title: '灰色笔记本电脑充电器',
    description: '联想65W Type-C充电器',
    location: '信息楼401', contact: '张老师 136****7890', date: '2026-06-30', status: '寻找中'
  },
  {
    id: 4, type: 'found', title: '捡到一串钥匙',
    description: '共5把钥匙，包含一把黑色U盘钥匙挂件',
    location: '食堂一楼', contact: '值班室 010-12345678', date: '2026-07-02', status: '待认领'
  },
  {
    id: 5, type: 'found', title: '捡到水杯一个',
    description: '白色膳魔师保温杯，杯身有贴纸',
    location: '操场看台', contact: '学生会办公室', date: '2026-07-01', status: '待认领'
  },
  {
    id: 6, type: 'found', title: '捡到学生证',
    description: '计算机学院 2024级 张三',
    location: '行政楼大厅', contact: '保卫处 010-87654321', date: '2026-06-29', status: '已认领'
  },
  {
    id: 7, type: 'found', title: '捡到钱包',
    description: '棕色钱包，内含少量现金及校园卡',
    location: '学生活动中心', contact: '广播站', date: '2026-06-28', status: '待认领'
  },
  {
    id: 8, type: 'lost', title: '白色运动水壶',
    description: '1L容量，瓶身有"Nike"标志',
    location: '体育馆更衣室', contact: '赵同学 137****4567', date: '2026-06-27', status: '寻找中'
  }
];

const FILTER_TABS: string[] = ['全部', '失物', '招领'];

@Builder
export function LostFoundBuilder(name: string, param: string) {
  LostFound()
}

@Component
export struct LostFound {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;

  @State activeFilter: number = 0;
  @State searchQuery: string = '';
  @State items: LostItem[] = [...LOST_ITEMS];

  // Publish form state
  @State showPublishForm: boolean = false;
  @State publishType: 'lost' | 'found' = 'lost';
  @State publishTitle: string = '';
  @State publishDescription: string = '';
  @State publishLocation: string = '';
  @State publishContact: string = '';
  @State publishing: boolean = false;

  aboutToAppear(): void {
    const dm: Object | undefined = AppStorage.get('darkModeEnabled');
    if (dm !== undefined) {
      this.darkModeEnabled = dm as boolean;
    }
  }

  getFilteredItems(): LostItem[] {
    let filtered = this.activeFilter === 1
      ? this.items.filter((item) => item.type === 'lost')
      : this.activeFilter === 2
        ? this.items.filter((item) => item.type === 'found')
        : this.items;

    if (this.searchQuery.trim()) {
      const q = this.searchQuery.trim().toLowerCase();
      filtered = filtered.filter((item) =>
        item.title.toLowerCase().includes(q) ||
        item.description.toLowerCase().includes(q) ||
        item.location.toLowerCase().includes(q)
      );
    }
    return filtered;
  }

  private publishItem(): void {
    if (!this.publishTitle.trim()) return;
    const newItem: LostItem = {
      id: Date.now(),
      type: this.publishType,
      title: this.publishTitle.trim(),
      description: this.publishDescription.trim() || '暂无详细描述',
      location: this.publishLocation.trim() || '未填写地点',
      contact: this.publishContact.trim() || '联系发布者',
      date: new Date().toISOString().slice(0, 10),
      status: this.publishType === 'lost' ? '寻找中' : '待认领'
    };
    this.items.unshift(newItem);
    this.items = [...this.items];
    // Reset form
    this.publishTitle = '';
    this.publishDescription = '';
    this.publishLocation = '';
    this.publishContact = '';
    this.showPublishForm = false;
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
          Text('失物招领')
            .fontSize($r('app.float.text_size_title_large'))
            .fontWeight(600)
            .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
            .margin({ left: 8 })
          Blank()
        }
        .width('100%')
        .height(56)
        .padding({
          left: $r('app.float.spacing_lg'),
          right: $r('app.float.spacing_lg')
        })

        // Filter tabs
        Row() {
          ForEach(FILTER_TABS, (option: string, index: number) => {
            Text(option)
              .fontSize($r('app.float.text_size_body'))
              .fontColor(this.activeFilter === index
                ? Color.White
                : (this.darkModeEnabled ? '#c0c0d8' : '#1D2129'))
              .fontWeight(this.activeFilter === index ? 600 : 400)
              .height(32)
              .padding({ left: 20, right: 20 })
              .backgroundColor(this.activeFilter === index
                ? $r('app.color.brand_primary')
                : (this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA'))
              .borderRadius(16)
              .margin({ right: 8 })
              .onClick(() => {
                this.activeFilter = index;
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

        // Search bar
        Row() {
          SymbolGlyph($r('sys.symbol.magnifyingglass'))
            .fontSize(18)
            .fontColor([this.darkModeEnabled ? '#6a6a8e' : $r('app.color.text_secondary')])
          TextInput({ placeholder: '搜索物品名称/地点...' })
            .layoutWeight(1)
            .height(36)
            .backgroundColor(Color.Transparent)
            .placeholderColor($r('app.color.text_secondary'))
            .placeholderFont({ size: $r('app.float.text_size_caption') })
            .padding({ left: 8 })
            .onChange((v: string) => {
              this.searchQuery = v;
            })
        }
        .width('100%')
        .height(40)
        .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
        .borderRadius(20)
        .padding({ left: 16, right: 16 })
        .margin({
          left: $r('app.float.spacing_lg'),
          right: $r('app.float.spacing_lg'),
          bottom: $r('app.float.spacing_px')
        })
        .shadow({
          radius: 4,
          color: 'rgba(0, 0, 0, 0.03)',
          offsetX: 0,
          offsetY: 1
        })

        // Publish button
        Row() {
          SymbolGlyph(this.showPublishForm ? $r('sys.symbol.chevron_down') : $r('sys.symbol.plus'))
            .fontSize(18)
            .fontColor([Color.White])
          Text(this.showPublishForm ? '收起发布' : '发布失物/招领')
            .fontSize(14)
            .fontColor(Color.White)
            .fontWeight(500)
            .margin({ left: 6 })
        }
        .width('100%')
        .height(40)
        .backgroundColor($r('app.color.brand_primary'))
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .margin({
          left: $r('app.float.spacing_lg'),
          right: $r('app.float.spacing_lg'),
          bottom: $r('app.float.spacing_px')
        })
        .onClick(() => {
          this.showPublishForm = !this.showPublishForm;
        })

        // Publish form
        if (this.showPublishForm) {
          Column() {
            // Type selector
            Row() {
              ForEach(['lost', 'found'], (type: string) => {
                Text(type === 'lost' ? '丢失物品' : '捡到物品')
                  .fontSize($r('app.float.text_size_body'))
                  .fontColor(this.publishType === type
                    ? Color.White
                    : (this.darkModeEnabled ? '#c0c0d8' : '#1D2129'))
                  .fontWeight(this.publishType === type ? 600 : 400)
                  .height(36)
                  .padding({ left: 20, right: 20 })
                  .backgroundColor(this.publishType === type
                    ? $r('app.color.brand_primary')
                    : (this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA'))
                  .borderRadius(18)
                  .onClick(() => {
                    this.publishType = type as 'lost' | 'found';
                  })
              }, (type: string) => type)
            }
            .width('100%')
            .margin({ bottom: 8 })

            TextInput({ placeholder: '物品名称 *' })
              .width('100%')
              .height(44)
              .placeholderColor($r('app.color.text_secondary'))
              .placeholderFont({ size: 15 })
              .padding({ left: 12, right: 12 })
              .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
              .borderRadius(8)
              .margin({ bottom: 8 })
              .onChange((v: string) => { this.publishTitle = v; })

            TextInput({ placeholder: '详细描述' })
              .width('100%')
              .height(44)
              .placeholderColor($r('app.color.text_secondary'))
              .placeholderFont({ size: 15 })
              .padding({ left: 12, right: 12 })
              .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
              .borderRadius(8)
              .margin({ bottom: 8 })
              .onChange((v: string) => { this.publishDescription = v; })

            TextInput({ placeholder: '地点（如: 教学楼A区3楼）' })
              .width('100%')
              .height(44)
              .placeholderColor($r('app.color.text_secondary'))
              .placeholderFont({ size: 15 })
              .padding({ left: 12, right: 12 })
              .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
              .borderRadius(8)
              .margin({ bottom: 8 })
              .onChange((v: string) => { this.publishLocation = v; })

            TextInput({ placeholder: '联系方式' })
              .width('100%')
              .height(44)
              .placeholderColor($r('app.color.text_secondary'))
              .placeholderFont({ size: 15 })
              .padding({ left: 12, right: 12 })
              .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
              .borderRadius(8)
              .margin({ bottom: 12 })
              .onChange((v: string) => { this.publishContact = v; })

            Button('确认发布')
              .width('100%')
              .height(44)
              .fontSize($r('app.float.text_size_body'))
              .fontColor(Color.White)
              .backgroundColor($r('app.color.brand_primary'))
              .borderRadius(8)
              .onClick(() => {
                this.publishItem();
              })
          }
          .width('100%')
          .padding(14)
          .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
          .borderRadius(8)
          .margin({
            left: $r('app.float.spacing_lg'),
            right: $r('app.float.spacing_lg'),
            bottom: $r('app.float.spacing_px')
          })
          .shadow({
            radius: 4,
            color: 'rgba(0, 0, 0, 0.05)',
            offsetX: 0,
            offsetY: 2
          })
        }

        // List or empty state
        if (this.getFilteredItems().length === 0) {
          Column() {
            Stack() {
              Circle()
                .width(72)
                .height(72)
                .fill('rgba(22, 119, 255, 0.06)')
              SymbolGlyph($r('sys.symbol.questionmark_circle'))
                .fontSize(32)
                .fontColor([this.darkModeEnabled ? '#6a6a8e' : $r('app.color.text_secondary')])
            }
            Text('暂无相关内容')
              .fontSize($r('app.float.text_size_body'))
              .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
              .margin({ top: 12 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          Scroll() {
            Column() {
              ForEach(this.getFilteredItems(), (item: LostItem) => {
                Column() {
                  Row() {
                    // Type badge
                    Column() {
                      Text(item.type === 'lost' ? '丢失' : '捡到')
                        .fontSize(12)
                        .fontColor(Color.White)
                        .fontWeight(500)
                    }
                    .width(40)
                    .height(22)
                    .backgroundColor(item.type === 'lost'
                      ? $r('app.color.accent_orange')
                      : $r('app.color.accent_green'))
                    .borderRadius(11)
                    .alignItems(HorizontalAlign.Center)
                    .justifyContent(FlexAlign.Center)

                    Blank()

                    Text(item.status)
                      .fontSize($r('app.float.text_size_caption'))
                      .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                  }
                  .width('100%')

                  Text(item.title)
                    .fontSize($r('app.float.text_size_body'))
                    .fontColor(this.darkModeEnabled ? '#e0e0f0' : $r('app.color.text_primary'))
                    .fontWeight(500)
                    .width('100%')
                    .margin({ top: 6 })

                  Text(item.description)
                    .fontSize($r('app.float.text_size_caption'))
                    .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                    .width('100%')
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .margin({ top: 4 })

                  Row() {
                    SymbolGlyph($r('sys.symbol.map'))
                      .fontSize(12)
                      .fontColor([this.darkModeEnabled ? '#6a6a8e' : $r('app.color.text_secondary')])
                    Text(item.location)
                      .fontSize($r('app.float.text_size_caption'))
                      .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                      .margin({ left: 4 })

                    Blank()

                    SymbolGlyph($r('sys.symbol.person'))
                      .fontSize(12)
                      .fontColor([$r('app.color.brand_primary')])
                    Text(item.contact)
                      .fontSize($r('app.float.text_size_caption'))
                      .fontColor($r('app.color.brand_primary'))
                      .margin({ left: 4 })
                  }
                  .width('100%')
                  .margin({ top: 8 })
                }
                .width('100%')
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
              }, (item: LostItem) => item.id.toString())
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

        // Bottom safe area
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
