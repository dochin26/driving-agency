// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { application } from "./application"

// Import and register controllers
import DrivingRecordFormController from "./driving_record_form_controller"
import FlashController from "./flash_controller"
import GeolocationController from "./geolocation_controller"
import WaypointsController from "./waypoints_controller"

application.register("driving-record-form", DrivingRecordFormController)
application.register("flash", FlashController)
application.register("geolocation", GeolocationController)
application.register("waypoints", WaypointsController)
