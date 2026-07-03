import { StartBuilder } from './Start/Start';
import { GuideBuilder } from './Guide/Guide';
import { LoginBuilder } from './Login/Login';
import { MainBuilder } from './main/main';
import { CampusNewsDetailBuilder } from './CampusNewsDetail/CampusNewsDetail';

@Entry
@Component
struct Index {
  pageStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.pageStack.pushPath({ name: 'Start' })
  }

  @Builder
  PageMap(name: string, param: Object) {
    if (name === 'Start') {
      StartBuilder(name, '')
    } else if (name === 'Guide') {
      GuideBuilder(name, '')
    } else if (name === 'Login') {
      LoginBuilder(name, '')
    } else if (name === 'Main') {
      MainBuilder(name, '')
    } else if (name === 'CampusNewsDetail') {
      CampusNewsDetailBuilder(name, param)
    }
  }

  build() {
    Navigation(this.pageStack) {

    }
    .title('Main')
    .navDestination(this.PageMap)
  }
}
