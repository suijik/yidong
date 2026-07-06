import { StartBuilder } from './Start/Start';
import { GuideBuilder } from './Guide/Guide';
import { LoginBuilder } from './Login/Login';
import { MainBuilder } from './main/main';
import { CampusNewsDetailBuilder } from './CampusNewsDetail/CampusNewsDetail';
import { TodoPageBuilder } from './Todo/TodoPage';
import { LostFoundBuilder } from './LostFound/LostFound';
import { CampusFoodBuilder } from './CampusFood/CampusFood';
import { MusicPlayerBuilder } from './MusicPlayer/MusicPlayer';
import { CampusToolsBuilder } from './CampusTools/CampusTools';
import { CourseScheduleEditorBuilder } from './CourseSchedule/CourseScheduleEditor';
import { CourseDetailBuilder } from './CourseSchedule/CourseDetail';
import { MineFavoritesBuilder } from './Mine/MineFavorites';

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
    } else if (name === 'TodoPage') {
      TodoPageBuilder(name, '')
    } else if (name === 'LostFound') {
      LostFoundBuilder(name, '')
    } else if (name === 'CampusFood') {
      CampusFoodBuilder(name, '')
    } else if (name === 'MusicPlayer') {
      MusicPlayerBuilder(name, '')
    } else if (name === 'CampusTools') {
      CampusToolsBuilder(name, '')
    } else if (name === 'CourseScheduleEditor') {
      CourseScheduleEditorBuilder(name, '')
    } else if (name === 'CourseDetail') {
      CourseDetailBuilder(name, param)
    } else if (name === 'MineFavorites') {
      MineFavoritesBuilder(name, '')
    }
  }

  build() {
    Navigation(this.pageStack) {

    }
    .title('Main')
    .navDestination(this.PageMap)
  }
}
