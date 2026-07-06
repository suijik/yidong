/**
 * CampusFood - 校园美食页面
 *
 * 功能：
 * - 食堂/餐厅列表
 * - 菜品展示与价格
 * - 分类筛选
 */

import { LogUtils } from '../../common/utils/LogUtils';

const TAG = 'CampusFood';

interface FoodItem {
  id: number;
  name: string;
  price: string;
  rating: number;
  location: string;
  category: string;
  description: string;
}

const FOOD_DATA: FoodItem[] = [
  { id: 1, name: '红烧肉套餐', price: '¥15', rating: 4.5, location: '一食堂二楼', category: '中餐', description: '入口即化的红烧肉，配时蔬和米饭' },
  { id: 2, name: '牛肉拉面', price: '¥12', rating: 4.3, location: '一食堂一楼', category: '面食', description: '手工拉面，牛肉汤底浓郁' },
  { id: 3, name: '麻辣香锅', price: '¥18', rating: 4.6, location: '二食堂三楼', category: '中餐', description: '自选菜品，麻辣鲜香' },
  { id: 4, name: '鸡排饭', price: '¥13', rating: 4.2, location: '二食堂二楼', category: '快餐', description: '酥脆鸡排配番茄酱和蔬菜沙拉' },
  { id: 5, name: '小笼包', price: '¥8', rating: 4.4, location: '一食堂一楼', category: '面食', description: '鲜肉小笼，汁多味美' },
  { id: 6, name: '石锅拌饭', price: '¥16', rating: 4.1, location: '二食堂二楼', category: '快餐', description: '韩式石锅拌饭配辣酱' },
  { id: 7, name: '酸菜鱼', price: '¥20', rating: 4.7, location: '二食堂三楼', category: '中餐', description: '鲜嫩鱼片配酸菜，开胃下饭' },
  { id: 8, name: '三明治套餐', price: '¥10', rating: 3.9, location: '西点屋', category: '西餐', description: '火腿三明治配牛奶' },
  { id: 9, name: '意大利面', price: '¥14', rating: 4.0, location: '西餐厅', category: '西餐', description: '番茄肉酱意大利面' },
  { id: 10, name: '煎饼果子', price: '¥6', rating: 4.3, location: '一食堂门口', category: '小吃', description: '现做煎饼，加蛋加火腿' },
  { id: 11, name: '烤冷面', price: '¥8', rating: 4.2, location: '二食堂门口', category: '小吃', description: '东北烤冷面，酸甜酱' },
  { id: 12, name: '奶茶', price: '¥8', rating: 4.5, location: '奶茶店', category: '饮品', description: '珍珠奶茶，可选糖度' }
];

const FOOD_CATEGORIES: string[] = ['全部', '中餐', '面食', '快餐', '西餐', '小吃', '饮品'];

@Builder
export function CampusFoodBuilder(name: string, param: string) {
  CampusFood()
}

@Component
export struct CampusFood {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;

  @State activeCategory: number = 0;

  aboutToAppear(): void {
    const dm: Object | undefined = AppStorage.get('darkModeEnabled');
    if (dm !== undefined) {
      this.darkModeEnabled = dm as boolean;
    }
  }

  getFilteredFood(): FoodItem[] {
    if (this.activeCategory === 0) return FOOD_DATA;
    return FOOD_DATA.filter((item) => item.category === FOOD_CATEGORIES[this.activeCategory]);
  }

  getStars(rating: number): string {
    const full = Math.floor(rating);
    return '★'.repeat(full) + '☆'.repeat(5 - full);
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
          Text('校园美食')
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

        // Category chips
        Scroll() {
          Row() {
            ForEach(FOOD_CATEGORIES, (category: string, index: number) => {
              Column() {
                Text(category)
                  .fontSize($r('app.float.text_size_caption'))
                  .fontColor(this.activeCategory === index
                    ? Color.White
                    : (this.darkModeEnabled ? '#c0c0d8' : '#1D2129'))
                  .fontWeight(this.activeCategory === index ? 600 : 400)
              }
              .height(30)
              .padding({ left: 16, right: 16 })
              .backgroundColor(this.activeCategory === index
                ? $r('app.color.brand_primary')
                : (this.darkModeEnabled ? '#1e1e3a' : Color.White))
              .borderRadius(15)
              .margin({ right: 8 })
              .justifyContent(FlexAlign.Center)
              .shadow({
                radius: 3,
                color: 'rgba(0, 0, 0, 0.03)',
                offsetX: 0,
                offsetY: 1
              })
              .onClick(() => {
                this.activeCategory = index;
              })
            }, (category: string) => category)
          }
          .padding({
            left: $r('app.float.spacing_lg'),
            right: $r('app.float.spacing_lg'),
            top: 4,
            bottom: 8
          })
        }
        .width('100%')
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)

        // Food grid: 2 columns
        if (this.getFilteredFood().length === 0) {
          Column() {
            Stack() {
              Circle()
                .width(72)
                .height(72)
                .fill('rgba(22, 119, 255, 0.06)')
              SymbolGlyph($r('sys.symbol.cup'))
                .fontSize(32)
                .fontColor([this.darkModeEnabled ? '#6a6a8e' : $r('app.color.text_secondary')])
            }
            Text('暂无该分类美食')
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
              ForEach(this.getFilteredFood(), (item: FoodItem) => {
                Row() {
                  // Left decorative block
                  Column()
                    .width(4)
                    .height('100%')
                    .backgroundColor($r('app.color.brand_primary'))
                    .borderRadius({ topLeft: 2, bottomLeft: 2 })

                  Column() {
                    // Name + price row
                    Row() {
                      Text(item.name)
                        .fontSize($r('app.float.text_size_body'))
                        .fontColor(this.darkModeEnabled ? '#e0e0f0' : '#1D2129')
                        .fontWeight(600)
                      Blank()
                      Text(item.price)
                        .fontSize($r('app.float.text_size_body'))
                        .fontColor($r('app.color.accent_orange'))
                        .fontWeight(700)
                    }
                    .width('100%')

                    // Rating
                    Text(this.getStars(item.rating))
                      .fontSize(12)
                      .fontColor($r('app.color.accent_orange'))
                      .margin({ top: 2 })

                    // Location
                    Row() {
                      SymbolGlyph($r('sys.symbol.map'))
                        .fontSize(12)
                        .fontColor([this.darkModeEnabled ? '#6a6a8e' : $r('app.color.text_secondary')])
                      Text(item.location)
                        .fontSize($r('app.float.text_size_caption'))
                        .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                        .margin({ left: 4 })
                    }
                    .width('100%')
                    .margin({ top: 6 })

                    // Description
                    Text(item.description)
                      .fontSize($r('app.float.text_size_caption'))
                      .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                      .width('100%')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .margin({ top: 2 })
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: $r('app.float.spacing_px') })
                }
                .width('100%')
                .height(110)
                .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
                .borderRadius($r('app.float.radius_md'))
                .shadow({
                  radius: 4,
                  color: 'rgba(0, 0, 0, 0.03)',
                  offsetX: 0,
                  offsetY: 1
                })
                .margin({ bottom: $r('app.float.spacing_px') })
              }, (item: FoodItem) => item.id.toString())
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
