/**
  Handling of reactive event messages from Shiny
 */

/**
  Opens a tabPanel while adding effects
  @param {DOMElement} panel a DOM element representing a Shiny tabPanel
  @param {boolean} [dimmer=true] whether to toggle dimmer panel
  @return void
 */
const activate_panel = (panel, apply_dimmer = true) => {
  const dimmer = document.querySelector("[data-value='Dimmer'].tab-pane");
  panel && panel.classList.add("active");
  panel && apply_dimmer && dimmer.classList.add("dim");
}

/**
  Closes a tabPanel while adding effects
  @param {DOMElement} panel a DOM element representing a Shiny tabPanel
  @param {boolean} [dimmer=true] whether to toggle dimmer panel
  @return void
 */
const deactivate_panel = (panel, apply_dimmer = true) => {
  const dimmer = document.querySelector("[data-value='Dimmer'].tab-pane");
  panel && panel.classList.remove("active");
  panel && apply_dimmer && dimmer.classList.remove("dim");
}

/**
  Applys an "underlay" class to the "Detail" panel
  @param {DOMElement} panel a DOM element representing a Shiny tabPanel
  @return void
 */
const apply_underlay = (panel) => {
  panel && panel.classList.add("underlay");
}

/**
  Removes an "underlay" class to the "Detail" panel
  @param {DOMElement} panel a DOM element representing a Shiny tabPanel
  @return void
 */
  const restore_underlay = (panel) => {
    panel && panel.classList.remove("underlay");
  }

/**
  Loads and binds event handlers for Shiny custom messages
  @return void
 */
const load_event_handlers = () => {
  // Open the About panel
  Shiny && Shiny.addCustomMessageHandler("about_open", (message) => {
    const panel = document.querySelector("[data-value='About'].tab-pane");
    activate_panel(panel)
  })
  
  // Close the About panel
  Shiny && Shiny.addCustomMessageHandler("about_close", (message) => {
    const panel = document.querySelector("[data-value='About'].tab-pane");
    deactivate_panel(panel)
  })
  
  // Open the Detail panel
  Shiny && Shiny.addCustomMessageHandler("detail_open", (message) => {
    const panel = document.querySelector("[data-value='Detail'].tab-pane");
    activate_panel(panel)
  })
  
  // Close the Detail panel
  Shiny && Shiny.addCustomMessageHandler("detail_close", (message) => {
    const panel = document.querySelector("[data-value='Detail'].tab-pane");
    deactivate_panel(panel)
  })
  
  // Open the Info_Map panel
  Shiny && Shiny.addCustomMessageHandler("info_map_open", (message) => {
    const panel = document.querySelector("[data-value='Info_Map'].tab-pane");
    const detail = document.querySelector("[data-value='Detail'].tab-pane");
    const about = document.querySelector("[data-value='About'].tab-pane");
    activate_panel(panel, false);
    apply_underlay(detail);
    apply_underlay(about);
  })
  
  // Close the Info_Map panel
  Shiny && Shiny.addCustomMessageHandler("info_map_close", (message) => {
    const panel = document.querySelector("[data-value='Info_Map'].tab-pane");
    const detail = document.querySelector("[data-value='Detail'].tab-pane");
    const about = document.querySelector("[data-value='About'].tab-pane");
    deactivate_panel(panel, false);
    restore_underlay(detail);
    restore_underlay(about);
  })
  
  // Open the Info_Detail panel
  Shiny && Shiny.addCustomMessageHandler("info_detail_open", (message) => {
    const panel = document.querySelector("[data-value='Info_Detail'].tab-pane");
    const detail = document.querySelector("[data-value='Detail'].tab-pane");
    const about = document.querySelector("[data-value='About'].tab-pane");
    activate_panel(panel, false);
    apply_underlay(detail);
    apply_underlay(about);
  })
  
  // Close the Info_Detail panel
  Shiny && Shiny.addCustomMessageHandler("info_detail_close", (message) => {
    const panel = document.querySelector("[data-value='Info_Detail'].tab-pane");
    const detail = document.querySelector("[data-value='Detail'].tab-pane");
    const about = document.querySelector("[data-value='About'].tab-pane");
    deactivate_panel(panel, false);
    restore_underlay(detail);
    restore_underlay(about);
  })
}

export {
  load_event_handlers
};
