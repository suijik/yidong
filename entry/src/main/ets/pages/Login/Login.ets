import { LogUtils } from '../../common/utils/LogUtils';
import { PreferencesUtil } from '../../common/utils/PreferencesUtil';

const TAG = 'Login';

/** 测试账号 */
const TEST_ACCOUNT: string = '2024001001';
const TEST_PASSWORD: string = '123456';

@Builder
export function LoginBuilder(name: string, param: string) {
  Login()
}

@Component
export struct Login {
  navPathStack: NavPathStack = new NavPathStack();
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;

  // Tab 状态
  @State currentTab: number = 0;
  @State tabContentOpacity: number = 1;

  // 登录表单
  @State loginAccount: string = '';
  @State loginPassword: string = '';
  @State loginProgressValue: number = 0;
  @State isLoggingIn: boolean = false;

  // 注册表单
  @State regName: string = '';
  @State regStudentId: string = '';
  @State regPassword: string = '';
  @State regConfirmPassword: string = '';
  @State regCaptcha: string = '';
  @State isRegistering: boolean = false;

  // 验证码倒计时
  @State captchaCountdown: number = 0;
  private captchaTimer: number = -1;
  private loginProgressTimer: number = -1;

  // 登录验证错误信息
  @State loginError: string = '';
  @State regError: string = '';

  // Toast
  @State toastMessage: string = '';
  @State toastOpacity: number = 0;
  private toastTimer: number = -1;

  aboutToDisappear(): void {
    this.clearCaptchaTimer();
    this.stopLoginProgress();
    this.clearToast();
  }

  // ==================== 表单验证 ====================

  private isLoginFormValid(): boolean {
    return this.loginAccount.length > 0 && this.loginPassword.length >= 6;
  }

  private isRegisterFormValid(): boolean {
    return this.regName.length > 0
      && this.regStudentId.length === 10
      && this.regPassword.length >= 6
      && this.regConfirmPassword.length >= 6
      && this.regPassword === this.regConfirmPassword
      && this.regCaptcha.length > 0;
  }

  // ==================== Tab 切换 ====================

  private switchTab(index: number): void {
    if (index === this.currentTab) {
      return;
    }
    this.tabContentOpacity = 0;
    this.loginError = '';
    this.regError = '';
    setTimeout(() => {
      this.currentTab = index;
      this.tabContentOpacity = 1;
    }, 150);
  }

  // ==================== 验证码 ====================

  private startCaptchaCountdown(): void {
    if (this.captchaCountdown > 0) {
      return;
    }
    this.captchaCountdown = 60;
    this.captchaTimer = setInterval(() => {
      this.captchaCountdown--;
      if (this.captchaCountdown <= 0) {
        this.clearCaptchaTimer();
      }
    }, 1000);
  }

  private clearCaptchaTimer(): void {
    if (this.captchaTimer !== -1) {
      clearInterval(this.captchaTimer);
      this.captchaTimer = -1;
    }
  }

  private startLoginProgress(): void {
    this.loginProgressValue = 0;
    this.loginProgressTimer = setInterval(() => {
      this.loginProgressValue = (this.loginProgressValue + 0.05) % 1;
    }, 30);
  }

  private stopLoginProgress(): void {
    if (this.loginProgressTimer !== -1) {
      clearInterval(this.loginProgressTimer);
      this.loginProgressTimer = -1;
    }
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

  // ==================== 登录 ====================

  private async handleLogin(): Promise<void> {
    if (!this.isLoginFormValid() || this.isLoggingIn) {
      return;
    }
    this.isLoggingIn = true;
    this.loginError = '';
    this.startLoginProgress();

    LogUtils.info(TAG, '正在登录...');

    // 模拟网络请求
    await this.delay(1500);

    // 校验：学号 10 位数字，密码 6 位以上
    if (!/^\d{10}$/.test(this.loginAccount)) {
      this.loginError = '请输入正确的10位学号';
      this.stopLoginProgress();
      this.isLoggingIn = false;
      return;
    }

    // 验证账号密码 - 测试账号
    if (this.loginAccount === TEST_ACCOUNT && this.loginPassword === TEST_PASSWORD) {
      LogUtils.info(TAG, '测试账号登录成功');
      this.stopLoginProgress();
      this.isLoggingIn = false;
      this.showToast('登录成功');
      setTimeout(() => {
        this.navPathStack.replacePathByName('Main', null);
      }, 500);
      return;
    }

    // 验证账号密码 - 已注册用户
    try {
      const hostContext = this.getUIContext().getHostContext();
      if (hostContext) {
        const userData = await PreferencesUtil.getUser(hostContext);
        if (userData && userData.account === this.loginAccount && userData.password === this.loginPassword) {
          LogUtils.info(TAG, '登录成功，准备跳转');
          this.stopLoginProgress();
      this.isLoggingIn = false;
          this.showToast('登录成功');
          setTimeout(() => {
            this.navPathStack.replacePathByName('Main', null);
          }, 500);
          return;
        }
      }
    } catch (err) {
      LogUtils.error(TAG, '获取用户信息失败', err);
    }

    // 登录失败
    this.loginError = '学号或密码错误，请重新输入';
    this.stopLoginProgress();
    this.isLoggingIn = false;
  }

  // ==================== 注册 ====================

  private async handleRegister(): Promise<void> {
    if (!this.isRegisterFormValid() || this.isRegistering) {
      return;
    }
    this.isRegistering = true;
    this.regError = '';

    LogUtils.info(TAG, '正在注册...');

    // 模拟网络请求
    await this.delay(1500);

    // 简单校验
    if (!/^\d{10}$/.test(this.regStudentId)) {
      this.regError = '学号必须为10位数字';
      this.isRegistering = false;
      return;
    }

    LogUtils.info(TAG, '注册成功');
    this.isRegistering = false;

    // 保存用户注册信息
    try {
      const hostContext = this.getUIContext().getHostContext();
      if (hostContext) {
        await PreferencesUtil.saveUser(hostContext, this.regStudentId, this.regPassword);
        LogUtils.info(TAG, '注册信息已保存');
      }
    } catch (err) {
      LogUtils.error(TAG, '保存注册信息失败', err);
    }

    this.showToast('注册成功，请登录');
    this.clearForm();
    // 切换到登录页并填入账号
    setTimeout(() => {
      this.currentTab = 0;
      this.loginAccount = this.regStudentId;
    }, 300);
  }

  // ==================== 工具方法 ====================

  private delay(ms: number): Promise<void> {
    return new Promise<void>((resolve) => {
      setTimeout(() => {
        resolve();
      }, ms);
    });
  }

  private clearForm(): void {
    this.regName = '';
    this.regStudentId = '';
    this.regPassword = '';
    this.regConfirmPassword = '';
    this.regCaptcha = '';
    this.clearCaptchaTimer();
    this.captchaCountdown = 0;
  }

  // ==================== 构建 ====================

  build() {
    NavDestination() {
      Column() {
        // 状态栏占位
        Column()
          .width('100%')
          .height(this.topRectHeight)
          .backgroundColor($r('app.color.bg_global'))

      Column() {
        // ==================== Logo 区域 ====================
        Column() {
          Text('校通Plus')
            .fontSize($r('app.float.text_size_title_medium'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.brand_primary'))
            .margin({ bottom: 8 })

          Text('校园生活，由此开始')
            .fontSize($r('app.float.text_size_body'))
            .fontColor($r('app.color.text_secondary'))
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 24, bottom: 24 })

            // ==================== Tab 栏 ====================
            Row() {
              Column() {
                Text('登录')
                  .fontSize($r('app.float.text_size_body'))
                  .fontColor(this.currentTab === 0
                    ? $r('app.color.brand_primary')
                    : $r('app.color.text_secondary'))
                  .fontWeight(this.currentTab === 0 ? FontWeight.Medium : FontWeight.Regular)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)
              .padding({ bottom: 10 })
              .onClick(() => {
                this.switchTab(0);
              })

              Column() {
                Text('注册')
                  .fontSize($r('app.float.text_size_body'))
                  .fontColor(this.currentTab === 1
                    ? $r('app.color.brand_primary')
                    : $r('app.color.text_secondary'))
                  .fontWeight(this.currentTab === 1 ? FontWeight.Medium : FontWeight.Regular)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)
              .padding({ bottom: 10 })
              .onClick(() => {
                this.switchTab(1);
              })
            }
            .width('100%')
            .borderRadius($r('app.float.radius_md'))
            .backgroundColor(Color.White)
            .padding({ top: 12 })

            // Tab 底部指示线（带动画滑动）
            Row() {
              Row()
                .width('50%')
                .height(3)
                .backgroundColor($r('app.color.brand_primary'))
                .borderRadius(2)
                .translate({
                  x: this.currentTab === 0 ? 0 : '100%'
                })
                .animation({
                  duration: 250,
                  curve: Curve.FastOutSlowIn
                })
            }
            .width('100%')
            .margin({ bottom: 24 })

            // ==================== 表单区域 ====================
            Column() {
              if (this.currentTab === 0) {
                this.buildLoginForm();
              } else {
                this.buildRegisterForm();
              }
            }
            .width('100%')
            .opacity(this.tabContentOpacity)
            .animation({
              duration: 200,
              curve: Curve.FastOutSlowIn
            })

            // ==================== 社交登录 ====================
            this.buildSocialLogin()

            // ==================== Toast ====================
            Text(this.toastMessage)
              .fontSize($r('app.float.text_size_body'))
              .fontColor(Color.White)
              .backgroundColor($r('app.color.text_primary'))
              .borderRadius($r('app.float.radius_md'))
              .padding({ left: 24, right: 24, top: 10, bottom: 10 })
              .opacity(this.toastOpacity)
              .animation({ duration: 250, curve: Curve.FastOutSlowIn })
              .alignSelf(ItemAlign.Center)
              .margin({ bottom: 16 })

            // 底部安全区域
            Column()
              .width('100%')
              .height(this.bottomRectHeight)
          }
          .width('100%')
          .layoutWeight(1)
          .backgroundColor($r('app.color.bg_global'))
          .padding({ left: $r('app.float.spacing_lg'), right: $r('app.float.spacing_lg') })
        }
        .width('100%')
        .height('100%')
    }
    .hideBackButton(true)
    .onReady((ctx: NavDestinationContext) => {
      this.navPathStack = ctx.pathStack;
    })
  }

  // ==================== 登录表单 ====================

  @Builder
  buildLoginForm() {
    Column() {
      // ---- 学号输入框 ----
      Row() {
        Stack() {
          Circle()
            .width(32)
            .height(32)
            .fill($r('app.color.brand_primary'))
            .opacity(0.1)
          SymbolGlyph($r('sys.symbol.person'))
            .fontSize(20)
            .fontColor([$r('app.color.brand_primary')])
        }
        .width(36)
        .height(48)
        .alignContent(Alignment.Center)
        .margin({ right: 12 })

        TextInput({ placeholder: '请输入学号/手机号' })
          .type(InputType.Number)
          .layoutWeight(1)
          .backgroundColor('transparent')
          .onChange((v: string) => {
            this.loginAccount = v;
            this.loginError = '';
          })
      }
      .width('100%')
      .height(48)
      .borderRadius($r('app.float.radius_md'))
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 16 })

      // ---- 密码输入框 ----
      Row() {
        Stack() {
          Circle()
            .width(32)
            .height(32)
            .fill($r('app.color.brand_primary'))
            .opacity(0.1)
          SymbolGlyph($r('sys.symbol.lock'))
            .fontSize(20)
            .fontColor([$r('app.color.brand_primary')])
        }
        .width(36)
        .height(48)
        .alignContent(Alignment.Center)
        .margin({ right: 12 })

        TextInput({ placeholder: '请输入密码' })
          .type(InputType.Password)
          .layoutWeight(1)
          .backgroundColor('transparent')
          .onChange((v: string) => {
            this.loginPassword = v;
            this.loginError = '';
          })
      }
      .width('100%')
      .height(48)
      .borderRadius($r('app.float.radius_md'))
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 12 })
      .margin({ bottom: 16 })

      // 错误信息
      if (this.loginError) {
        Text(this.loginError)
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.accent_orange'))
          .width('100%')
          .margin({ bottom: 8 })
      }

      // 登录按钮
      Button() {
        if (this.isLoggingIn) {
          Row() {
            Progress({
              value: this.loginProgressValue,
              total: 1,
              type: ProgressType.Ring
            })
              .width(20)
              .height(20)
              .color(Color.White)
              .backgroundColor('rgba(255, 255, 255, 0.3)')
              .style({ strokeWidth: 3 })
              .margin({ right: 8 })
            Text('登录中...')
              .fontSize($r('app.float.text_size_body'))
              .fontColor(Color.White)
          }
        } else {
          Text('登 录')
            .fontSize($r('app.float.text_size_body'))
            .fontColor(Color.White)
        }
      }
      .width('100%')
      .height(48)
      .backgroundColor(this.isLoginFormValid()
        ? $r('app.color.brand_primary')
        : $r('app.color.brand_primary_disabled'))
      .borderRadius($r('app.float.radius_md'))
      .enabled(this.isLoginFormValid() && !this.isLoggingIn)
      .onClick(() => {
        this.handleLogin();
      })
      .margin({ top: 8, bottom: 16 })

      // 底部链接行
      Row() {
        Text('忘记密码？')
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.text_secondary'))

        Blank()

        Text('注册账号')
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.brand_primary'))
          .onClick(() => {
            this.switchTab(1);
          })
      }
      .width('100%')
    }
    .width('100%')
  }

  // ==================== 注册表单 ====================

  @Builder
  buildRegisterForm() {
    Column() {
      // ---- 姓名输入框 ----
      Row() {
        Stack() {
          Circle()
            .width(32)
            .height(32)
            .fill($r('app.color.brand_primary'))
            .opacity(0.1)
          SymbolGlyph($r('sys.symbol.person'))
            .fontSize(20)
            .fontColor([$r('app.color.brand_primary')])
        }
        .width(36)
        .height(48)
        .alignContent(Alignment.Center)
        .margin({ right: 12 })

        TextInput({ placeholder: '请输入姓名' })
          .layoutWeight(1)
          .backgroundColor('transparent')
          .onChange((v: string) => {
            this.regName = v;
            this.regError = '';
          })
      }
      .width('100%')
      .height(48)
      .borderRadius($r('app.float.radius_md'))
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 16 })

      // ---- 学号输入框 ----
      Row() {
        Stack() {
          Circle()
            .width(32)
            .height(32)
            .fill($r('app.color.brand_primary'))
            .opacity(0.1)
          SymbolGlyph($r('sys.symbol.person'))
            .fontSize(20)
            .fontColor([$r('app.color.brand_primary')])
        }
        .width(36)
        .height(48)
        .alignContent(Alignment.Center)
        .margin({ right: 12 })

        TextInput({ placeholder: '请输入10位学号' })
          .type(InputType.Number)
          .layoutWeight(1)
          .backgroundColor('transparent')
          .onChange((v: string) => {
            this.regStudentId = v;
            this.regError = '';
          })
      }
      .width('100%')
      .height(48)
      .borderRadius($r('app.float.radius_md'))
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 16 })

      // ---- 密码输入框 ----
      Row() {
        Stack() {
          Circle()
            .width(32)
            .height(32)
            .fill($r('app.color.brand_primary'))
            .opacity(0.1)
          SymbolGlyph($r('sys.symbol.lock'))
            .fontSize(20)
            .fontColor([$r('app.color.brand_primary')])
        }
        .width(36)
        .height(48)
        .alignContent(Alignment.Center)
        .margin({ right: 12 })

        TextInput({ placeholder: '请输入密码（至少6位）' })
          .type(InputType.Password)
          .layoutWeight(1)
          .backgroundColor('transparent')
          .onChange((v: string) => {
            this.regPassword = v;
            this.regError = '';
          })
      }
      .width('100%')
      .height(48)
      .borderRadius($r('app.float.radius_md'))
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 12 })
      .margin({ bottom: 16 })

      // ---- 确认密码输入框 ----
      Row() {
        Stack() {
          Circle()
            .width(32)
            .height(32)
            .fill($r('app.color.brand_primary'))
            .opacity(0.1)
          SymbolGlyph($r('sys.symbol.checkmark'))
            .fontSize(20)
            .fontColor([$r('app.color.brand_primary')])
        }
        .width(36)
        .height(48)
        .alignContent(Alignment.Center)
        .margin({ right: 12 })

        TextInput({ placeholder: '请再次输入密码' })
          .type(InputType.Password)
          .layoutWeight(1)
          .backgroundColor('transparent')
          .onChange((v: string) => {
            this.regConfirmPassword = v;
            this.regError = '';
          })
      }
      .width('100%')
      .height(48)
      .borderRadius($r('app.float.radius_md'))
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 12 })
      .margin({ bottom: 16 })

      // ---- 验证码输入框 ----
      Row() {
        Stack() {
          Circle()
            .width(32)
            .height(32)
            .fill($r('app.color.brand_primary'))
            .opacity(0.1)
        }
        .width(36)
        .height(48)
        .alignContent(Alignment.Center)
        .margin({ right: 12 })

        TextInput({ placeholder: '请输入验证码' })
          .layoutWeight(1)
          .backgroundColor('transparent')
          .onChange((v: string) => {
            this.regCaptcha = v;
            this.regError = '';
          })

        Button() {
          if (this.captchaCountdown > 0) {
            Text(this.captchaCountdown + 's后重试')
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
          } else {
            Text('获取验证码')
              .fontSize(13)
              .fontColor($r('app.color.brand_primary'))
          }
        }
        .height(34)
        .borderRadius(6)
        .backgroundColor(Color.White)
        .padding({ left: 10, right: 10 })
        .enabled(this.captchaCountdown <= 0)
        .onClick(() => {
          this.startCaptchaCountdown();
        })
      }
      .width('100%')
      .height(48)
      .borderRadius($r('app.float.radius_md'))
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 8 })
      .margin({ bottom: 16 })

      // 错误信息
      if (this.regError) {
        Text(this.regError)
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.accent_orange'))
          .width('100%')
          .margin({ bottom: 8 })
      }

      // 注册按钮
      Button() {
        if (this.isRegistering) {
          Row() {
            Progress({
              value: 0.3,
              total: 1,
              type: ProgressType.Ring
            })
              .width(20)
              .height(20)
              .color(Color.White)
              .backgroundColor('rgba(255, 255, 255, 0.3)')
              .style({ strokeWidth: 3 })
              .margin({ right: 8 })
            Text('注册中...')
              .fontSize($r('app.float.text_size_body'))
              .fontColor(Color.White)
          }
        } else {
          Text('注 册')
            .fontSize($r('app.float.text_size_body'))
            .fontColor(Color.White)
        }
      }
      .width('100%')
      .height(48)
      .backgroundColor(this.isRegisterFormValid()
        ? $r('app.color.brand_primary')
        : $r('app.color.brand_primary_disabled'))
      .borderRadius($r('app.float.radius_md'))
      .enabled(this.isRegisterFormValid() && !this.isRegistering)
      .onClick(() => {
        this.handleRegister();
      })
      .margin({ top: 8, bottom: 16 })

      // 底部提示
      Text('已有账号？去登录')
        .fontSize($r('app.float.text_size_caption'))
        .fontColor($r('app.color.brand_primary'))
        .onClick(() => {
          this.switchTab(0);
        })
    }
    .width('100%')
  }

  // ==================== 社交登录 ====================

  @Builder
  buildSocialLogin() {
    Column() {
      // 分割线
      Row() {
        Row()
          .height(1)
          .layoutWeight(1)
          .backgroundColor($r('app.color.border_light'))

        Text(' 其他登录方式 ')
          .fontSize($r('app.float.text_size_caption'))
          .fontColor($r('app.color.text_secondary'))
          .margin({ left: 12, right: 12 })

        Row()
          .height(1)
          .layoutWeight(1)
          .backgroundColor($r('app.color.border_light'))
      }
      .width('100%')
      .margin({ top: 32, bottom: 24 })

      // 社交图标
      Row() {
        // 微信
        Stack() {
          Circle()
            .width(48)
            .height(48)
            .fill(Color.White)
            .stroke($r('app.color.border_light'))
            .strokeWidth(1.5)
          SymbolGlyph($r('sys.symbol.message'))
            .fontSize(24)
            .fontColor(['#07C160'])
        }
        .width(48)
        .height(48)
        .onClick(() => {
          LogUtils.info(TAG, '点击微信登录');
        })
        .margin({ left: 16, right: 16 })

        // QQ
        Stack() {
          Circle()
            .width(48)
            .height(48)
            .fill(Color.White)
            .stroke($r('app.color.border_light'))
            .strokeWidth(1.5)
          SymbolGlyph($r('sys.symbol.ellipsis_message_1'))
            .fontSize(24)
            .fontColor(['#12B7F5'])
        }
        .width(48)
        .height(48)
        .onClick(() => {
          LogUtils.info(TAG, '点击QQ登录');
        })
        .margin({ left: 16, right: 16 })

      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: $r('app.float.spacing_md') })
    }
    .width('100%')
  }
}
