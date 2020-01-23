import MainView from './main';
import PageIndexView from './page/show';
import SensorShowView from "./sensor/show";
import NotificationNewView from "./notification/new"
import NotificationEditView from "./notification/edit"
import EnergyManagementIndexView from "./energy_management/index"
import DryerDataHistoryView from "./process_data_history/dryer/data_history"
import WetPreBreakerDataHistoryView from "./process_data_history/wet_pre_breaker/data_history"
import IpalWaterInletDataHistoryView from "./process_data_history/ipat_water_inlet/data_history"

// Collection of specific view modules
const views = {
  PageIndexView,
  SensorShowView,
  NotificationNewView,
  NotificationEditView,
  EnergyManagementIndexView,
  DryerDataHistoryView,
  WetPreBreakerDataHistoryView,
  IpalWaterInletDataHistoryView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
