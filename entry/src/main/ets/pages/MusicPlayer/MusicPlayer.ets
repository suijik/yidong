/**
 * MusicPlayer - 音乐播放页面
 *
 * 功能：
 * - 歌曲列表展示
 * - 播放/暂停控制
 * - 歌曲切换
 */

import { LogUtils } from '../../common/utils/LogUtils';

const TAG = 'MusicPlayer';

interface SongItem {
  id: number;
  title: string;
  artist: string;
  album: string;
  duration: string;
  isPlaying: boolean;
}

const SONG_LIST: SongItem[] = [
  { id: 1, title: '起风了', artist: '买辣椒也用券', album: '起风了', duration: '5:18', isPlaying: false },
  { id: 2, title: '光年之外', artist: 'G.E.M.邓紫棋', album: '光年之外', duration: '3:55', isPlaying: false },
  { id: 3, title: '平凡之路', artist: '朴树', album: '猎户星座', duration: '5:02', isPlaying: false },
  { id: 4, title: '夜空中最亮的星', artist: '逃跑计划', album: '世界', duration: '4:13', isPlaying: false },
  { id: 5, title: '稻香', artist: '周杰伦', album: '魔杰座', duration: '3:44', isPlaying: false },
  { id: 6, title: '后来', artist: '刘若英', album: '我等你', duration: '5:22', isPlaying: false },
  { id: 7, title: '追梦赤子心', artist: 'GALA', album: '追梦赤子心', duration: '5:21', isPlaying: false },
  { id: 8, title: '光阴的故事', artist: '罗大佑', album: '之乎者也', duration: '3:35', isPlaying: false },
  { id: 9, title: '岁月神偷', artist: '金玟岐', album: '完美世界', duration: '4:16', isPlaying: false }
];

@Builder
export function MusicPlayerBuilder(name: string, param: string) {
  MusicPlayer()
}

@Component
export struct MusicPlayer {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('darkModeEnabled') darkModeEnabled: boolean = false;

  @State songList: SongItem[] = SONG_LIST;
  @State currentSongId: number = -1;
  @State isPlaying: boolean = false;
  @State currentProgress: number = 0;
  @State currentDuration: number = 100;
  @State version: number = 0;
  @State currentSongObj: SongItem | null = null;
  private progressTimer: number = -1;

  aboutToAppear(): void {
    const dm: Object | undefined = AppStorage.get('darkModeEnabled');
    if (dm !== undefined) {
      this.darkModeEnabled = dm as boolean;
    }
  }

  aboutToDisappear(): void {
    this.clearTimer();
  }

  private clearTimer(): void {
    if (this.progressTimer !== -1) {
      clearInterval(this.progressTimer);
      this.progressTimer = -1;
    }
  }

  private parseDuration(duration: string): number {
    const parts: string[] = duration.split(':');
    return parseInt(parts[0]) * 60 + parseInt(parts[1]);
  }

  private startTimer(): void {
    this.clearTimer();
    if (this.currentSongObj) {
      this.currentDuration = this.parseDuration(this.currentSongObj.duration);
    }
    this.progressTimer = setInterval(() => {
      if (this.currentProgress < this.currentDuration) {
        this.currentProgress++;
      } else {
        this.clearTimer();
        this.isPlaying = false;
        this.nextSong();
      }
    }, 1000);
  }

  get currentSong(): SongItem | null {
    if (this.currentSongId === -1) return null;
    return this.songList.find((s) => s.id === this.currentSongId) || null;
  }

  getProgressText(): string {
    if (!this.currentSongObj) return '0:00';
    const min: number = Math.floor(this.currentProgress / 60);
    const sec: number = this.currentProgress % 60;
    return min + ':' + (sec < 10 ? '0' + sec : sec);
  }

  private playSong(id: number): void {
    // Pause all
    for (let i = 0; i < this.songList.length; i++) {
      this.songList[i].isPlaying = false;
    }
    this.currentSongId = id;
    this.isPlaying = true;
    this.currentProgress = 0;
    const song = this.songList.find((s) => s.id === id);
    if (song) {
      this.currentDuration = this.parseDuration(song.duration);
      song.isPlaying = true;
      this.currentSongObj = song;
    }
    this.songList = [...this.songList];
    this.version++;
    this.startTimer();
  }

  private togglePlayPause(): void {
    if (this.currentSongId === -1 && this.songList.length > 0) {
      this.playSong(this.songList[0].id);
      return;
    }
    this.isPlaying = !this.isPlaying;
    if (this.isPlaying) {
      this.startTimer();
    } else {
      this.clearTimer();
    }
    const song = this.songList.find((s) => s.id === this.currentSongId);
    if (song) {
      song.isPlaying = this.isPlaying;
      this.songList = [...this.songList];
      this.version++;
    }
  }

  private nextSong(): void {
    if (this.currentSongId === -1) {
      if (this.songList.length > 0) {
        this.playSong(this.songList[0].id);
      }
      return;
    }
    const currentIndex = this.songList.findIndex((s) => s.id === this.currentSongId);
    const nextIndex = (currentIndex + 1) % this.songList.length;
    this.playSong(this.songList[nextIndex].id);
  }

  private prevSong(): void {
    if (this.currentSongId === -1) {
      if (this.songList.length > 0) {
        this.playSong(this.songList[0].id);
      }
      return;
    }
    const currentIndex = this.songList.findIndex((s) => s.id === this.currentSongId);
    const prevIndex = (currentIndex - 1 + this.songList.length) % this.songList.length;
    this.playSong(this.songList[prevIndex].id);
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
          Text('音乐播放')
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

        // Now playing card
        Column() {
          Stack() {
            Circle()
              .width(96)
              .height(96)
              .fill(this.isPlaying
                ? $r('app.color.brand_primary')
                : (this.darkModeEnabled ? 'rgba(22, 119, 255, 0.15)' : 'rgba(22, 119, 255, 0.08)'))
            SymbolGlyph($r('sys.symbol.play_circle'))
              .fontSize(44)
              .fontColor([this.isPlaying
                ? Color.White
                : $r('app.color.brand_primary')])
          }
          .width(96)
          .height(96)
          .scale({ x: this.isPlaying ? 1.08 : 1, y: this.isPlaying ? 1.08 : 1 })
          .animation({ duration: 400, curve: Curve.FastOutSlowIn })

          if (this.currentSongObj) {
            Text(this.currentSongObj.title)
              .fontSize($r('app.float.text_size_title_medium'))
              .fontColor(this.darkModeEnabled ? '#e0e0f0' : $r('app.color.text_primary'))
              .fontWeight(600)
              .margin({ top: 16 })
            Text(this.currentSongObj.artist + ' · ' + this.currentSongObj.album)
              .fontSize($r('app.float.text_size_caption'))
              .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
              .margin({ top: 6 })
          } else {
            Text('未选择歌曲')
              .fontSize($r('app.float.text_size_title_medium'))
              .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
              .fontWeight(500)
              .margin({ top: 16 })
            Text('点击下方歌曲开始播放')
              .fontSize($r('app.float.text_size_caption'))
              .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
              .margin({ top: 6 })
          }

          // Progress bar
          if (this.currentSongObj) {
            Row() {
              Text(this.getProgressText())
                .fontSize(12)
                .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                .width(40)
                .textAlign(TextAlign.Start)

              Slider({
                value: this.currentProgress,
                min: 0,
                max: this.currentDuration,
                step: 1,
                style: SliderStyle.InSet
              })
                .layoutWeight(1)
                .height(20)
                .trackThickness(3)
                .blockColor($r('app.color.brand_primary'))
                .trackColor(this.darkModeEnabled ? '#2a2a4a' : '#E5E6EB')
                .selectedColor($r('app.color.brand_primary'))
                .onChange((value: number) => {
                  this.currentProgress = value;
                })

              Text(this.currentSongObj.duration)
                .fontSize(12)
                .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                .width(40)
                .textAlign(TextAlign.End)
            }
              .width('100%')
              .margin({ top: 12 })
          }

          // Player controls
          Row() {
            // Prev
            Stack() {
              Circle()
                .width(44)
                .height(44)
                .fill('rgba(22, 119, 255, 0.06)')
              SymbolGlyph($r('sys.symbol.chevron_left'))
                .fontSize(20)
                .fontColor([$r('app.color.brand_primary')])
            }
            .width(44)
            .height(44)
              .onClick(() => {
                this.prevSong();
              })

            // Play/Pause
            SymbolGlyph(this.isPlaying ? $r('sys.symbol.pause_circle') : $r('sys.symbol.play_circle'))
              .fontSize(52)
              .fontColor([$r('app.color.brand_primary')])
              .margin({ left: 40, right: 40 })
              .onClick(() => {
                this.togglePlayPause();
              })

            // Next
            Stack() {
              Circle()
                .width(44)
                .height(44)
                .fill('rgba(22, 119, 255, 0.06)')
              SymbolGlyph($r('sys.symbol.chevron_right'))
                .fontSize(20)
                .fontColor([$r('app.color.brand_primary')])
            }
            .width(44)
            .height(44)
              .onClick(() => {
                this.nextSong();
              })
          }
          .alignItems(VerticalAlign.Center)
          .margin({ top: 20 })
        }
        .width('100%')
        .padding(20)
        .backgroundColor(this.darkModeEnabled ? '#1e1e3a' : Color.White)
        .alignItems(HorizontalAlign.Center)
        .margin({
          left: $r('app.float.spacing_lg'),
          right: $r('app.float.spacing_lg'),
          bottom: $r('app.float.spacing_px')
        })
        .shadow({
          radius: 8,
          color: 'rgba(0, 0, 0, 0.05)',
          offsetX: 0,
          offsetY: 2
        })

        // Playlist header
        Row() {
          Text('播放列表')
            .fontSize($r('app.float.text_size_title_medium'))
            .fontWeight(600)
            .fontColor(this.darkModeEnabled ? '#e0e0f0' : $r('app.color.text_primary'))
          Blank()
          Text(this.songList.length + '首歌曲')
            .fontSize($r('app.float.text_size_caption'))
            .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
        }
        .width('100%')
        .padding({
          left: $r('app.float.spacing_lg'),
          right: $r('app.float.spacing_lg'),
          top: $r('app.float.spacing_px'),
          bottom: 6
        })

        // Song list
        Scroll() {
          Column() {
            ForEach(this.songList, (item: SongItem) => {
              Row() {
                Column() {
                  Text(item.id.toString())
                    .fontSize($r('app.float.text_size_caption'))
                    .fontColor(item.isPlaying
                      ? $r('app.color.brand_primary')
                      : (this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary')))
                    .fontWeight(500)
                }
                .width(28)
                .alignItems(HorizontalAlign.Center)

                Column() {
                  Text(item.title)
                    .fontSize($r('app.float.text_size_body'))
                    .fontColor(item.isPlaying
                      ? $r('app.color.brand_primary')
                      : (this.darkModeEnabled ? '#e0e0f0' : $r('app.color.text_primary')))
                    .fontWeight(item.isPlaying ? 600 : 400)
                    .width('100%')
                  Text(item.artist)
                    .fontSize($r('app.float.text_size_caption'))
                    .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                    .width('100%')
                    .margin({ top: 2 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 8 })

                // Playing indicator
                if (item.isPlaying) {
                  SymbolGlyph($r('sys.symbol.play_circle'))
                    .fontSize(16)
                    .fontColor([$r('app.color.brand_primary')])
                } else {
                  Text(item.duration)
                    .fontSize($r('app.float.text_size_caption'))
                    .fontColor(this.darkModeEnabled ? '#a0a0b8' : $r('app.color.text_secondary'))
                }
              }
              .width('100%')
              .padding(14)
              .backgroundColor(item.isPlaying
                ? 'rgba(22, 119, 255, 0.04)'
                : (this.darkModeEnabled ? '#1e1e3a' : Color.White))
              .borderRadius($r('app.float.radius_md'))
              .margin({ bottom: 6 })
              .onClick(() => {
                this.playSong(item.id);
              })
            }, (item: SongItem) => item.id.toString() + '_' + this.version)
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
