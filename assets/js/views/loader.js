import MainView from './main';
import PageIndexView from './page/show';
import SensorShowView from "./sensor/show";

// Collection of specific view modules
const views = {
  PageIndexView,
  SensorShowView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
