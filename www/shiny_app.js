(()=>{"use strict";var e,a,t,n;e=function(e){var a=!(arguments.length>1&&void 0!==arguments[1])||arguments[1],t=document.querySelector("[data-value='Dimmer'].tab-pane");e&&e.classList.add("active"),e&&a&&t.classList.add("dim")},a=function(e){var a=!(arguments.length>1&&void 0!==arguments[1])||arguments[1],t=document.querySelector("[data-value='Dimmer'].tab-pane");e&&e.classList.remove("active"),e&&a&&t.classList.remove("dim")},t=function(e){e&&e.classList.add("underlay")},n=function(e){e&&e.classList.remove("underlay")},Shiny&&Shiny.addCustomMessageHandler("about_open",(function(a){var t=document.querySelector("[data-value='About'].tab-pane");e(t)})),Shiny&&Shiny.addCustomMessageHandler("about_close",(function(e){var t=document.querySelector("[data-value='About'].tab-pane");a(t)})),Shiny&&Shiny.addCustomMessageHandler("detail_open",(function(a){var t=document.querySelector("[data-value='Detail'].tab-pane");e(t)})),Shiny&&Shiny.addCustomMessageHandler("detail_close",(function(e){var t=document.querySelector("[data-value='Detail'].tab-pane");a(t)})),Shiny&&Shiny.addCustomMessageHandler("info_map_open",(function(a){var n=document.querySelector("[data-value='Info_Map'].tab-pane"),o=document.querySelector("[data-value='Detail'].tab-pane"),u=document.querySelector("[data-value='About'].tab-pane");e(n,!1),t(o),t(u)})),Shiny&&Shiny.addCustomMessageHandler("info_map_close",(function(e){var t=document.querySelector("[data-value='Info_Map'].tab-pane"),o=document.querySelector("[data-value='Detail'].tab-pane"),u=document.querySelector("[data-value='About'].tab-pane");a(t,!1),n(o),n(u)})),Shiny&&Shiny.addCustomMessageHandler("info_detail_open",(function(a){var n=document.querySelector("[data-value='Info_Detail'].tab-pane"),o=document.querySelector("[data-value='Detail'].tab-pane"),u=document.querySelector("[data-value='About'].tab-pane");e(n,!1),t(o),t(u)})),Shiny&&Shiny.addCustomMessageHandler("info_detail_close",(function(e){var t=document.querySelector("[data-value='Info_Detail'].tab-pane"),o=document.querySelector("[data-value='Detail'].tab-pane"),u=document.querySelector("[data-value='About'].tab-pane");a(t,!1),n(o),n(u)})),window.onload=function(){navigator.userAgent.includes("QtWebEngine")&&window.alert("For best effect, please use an external browser.")}})();
//# sourceMappingURL=shiny_app.js.map