// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//

import $ from 'jquery';
window.jQuery = $;
window.$ = $;

window.WOW = require('wowjs').WOW

import 'bootstrap'
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

$(document).ready(() => {
  let flash_message = $("#flash_message").data()
  if (flash_message["info"]) {
    $.Notification.notify('success','top right', 'Information', 
      flash_message["info"])
  } else if (flash_message["error"]) {
    $.Notification.notify('error','top right', 'Error', 
      flash_message["info"])
  }
});
