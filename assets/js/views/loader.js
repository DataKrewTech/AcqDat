import MainView from './main';
import PageIndexView from './page/show';
import SensorShowView from "./sensor/show";
import NotificationNewView from "./notification/new"
import NotificationEditView from "./notification/edit"

// Collection of specific view modules
const views = {
  PageIndexView,
  SensorShowView,
  NotificationNewView,
  NotificationEditView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
