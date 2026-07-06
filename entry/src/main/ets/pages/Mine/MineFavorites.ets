/**
 * MineFavorites - 我的收藏页面
 *
 * 功能：
 * - 展示已收藏的图书列表
 * - 取消收藏
 */

import { PreferencesUtil } from '../../common/utils/PreferencesUtil';
import { LogUtils } from '../../common/utils/LogUtils';
import { common } from '@kit.AbilityKit';

const TAG = 'MineFavorites';

@Builder
export function MineFavoritesBuilder(name: string, param: string) {
  MineFavorites()
}

@Component
export struct MineFavorites {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;

  @State favoriteBooks: string[] = [];
  @State version: number = 0;

  aboutToAppear(): void {
    const dm: Object | undefined = AppStorage.get('darkModeEnabled');
    if (dm !== undefined) {
      this.darkModeEnabled = dm as boolean;
    }
    this.loadFavorites();
  }

  private loadFavorites(): void {
    const saved: Object | undefined = AppStorage.get('library_favorites');
    if (saved) {
      try {
        this.favoriteBooks = JSON.parse(saved as string) as string[];
        this.version++;
        return;
      } catch (err) {
        LogUtils.error(TAG, '解析收藏数据失败', err);
      }
    }
    this.favoriteBooks = [];
  }

  private async removeFavorite(bookEntry: string): Promise<void> {
    const index: number = this.favoriteBooks.indexOf(bookEntry);
    if (index !== -1) {
      this.favoriteBooks.splice(index, 1);
      this.favoriteBooks = [...this.favoriteBooks];
      this.version++;
      this.saveFavorites();
    }
  }

  private saveFavorites(): void {
    try {
      AppStorage.setOrCreate('library_favorites', JSON.stringify(this.favoriteBooks));
      const context: common.Context = getContext(this);
      PreferencesUtil.setCustom(context, 'library_favorites', JSON.stringify(this.favoriteBooks));
    } catch (err) {
      LogUtils.error(TAG, '保存收藏数据失败', err);
    }
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
          Text('我的收藏')
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

        // Content
        if (this.favoriteBooks.length === 0) {
          // Empty state
          Column() {
            Stack() {
              Circle()
                .width(72)
                .height(72)
                .fill('rgba(22, 119, 255, 0.06)')
              SymbolGlyph($r('sys.symbol.heart'))
                .fontSize(32)
                .fontColor([$r('app.color.text_secondary')])
            }
            Text('暂无收藏的图书')
              .fontSize($r('app.float.text_size_body'))
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 12 })
            Text('在图书馆检索中收藏图书')
              .fontSize($r('app.float.text_size_caption'))
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 4 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          Scroll() {
            Column() {
              ForEach(this.favoriteBooks, (item: string) => {
                Row() {
                  // Book icon
                  Stack() {
                    Column()
                      .width(56)
                      .height(72)
                      .borderRadius(6)
                      .backgroundColor('rgba(22, 119, 255, 0.06)')
                    SymbolGlyph($r('sys.symbol.book'))
                      .fontSize(24)
                      .fontColor([$r('app.color.brand_primary')])
                      .opacity(0.4)
                  }
                  .width(56)
                  .height(72)

                  // Book info
                  Column() {
                    Text(item.split(' - ')[0])
                      .fontSize($r('app.float.text_size_body'))
                      .fontColor(this.darkModeEnabled ? '#e0e0f0' : $r('app.color.text_primary'))
                      .fontWeight(500)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .width('100%')
                    Text(item.split(' - ')[1] || '')
                      .fontSize($r('app.float.text_size_caption'))
                      .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                      .margin({ top: 4 })
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: $r('app.float.spacing_px') })

                  // Unfavorite button
                  Button('取消收藏')
                    .height(30)
                    .fontSize($r('app.float.text_size_caption'))
                    .fontColor($r('app.color.text_secondary'))
                    .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : '#F5F7FA')
                    .border({ width: 1, color: this.darkModeEnabled ? '#2a2a4a' : '#E5E6EB' })
                    .borderRadius($r('app.float.radius_md'))
                    .onClick(() => {
                      this.removeFavorite(item);
                    })
                }
                .width('100%')
                .padding($r('app.float.spacing_px'))
                .borderRadius($r('app.float.radius_md'))
                .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
                .shadow({
                  radius: 4,
                  color: 'rgba(0, 0, 0, 0.03)',
                  offsetX: 0,
                  offsetY: 1
                })
                .margin({ bottom: 8 })
              }, (item: string) => item + '_' + this.version)
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
