/**
  Handling of reactive event messages from Shiny
 */

/**
  Opens a tabPanel while adding effects
  @param panel a DOM element representing a Shiny tabPanel
  @return void
 */
const activate_panel = (panel) => {
  const dimmer = document.querySelector("[data-value='Dimmer'].tab-pane");
  panel && panel.classList.add("active");
  panel && dimmer.classList.add("dim");
}

/**
  Closes a tabPanel while adding effects
  @param panel a DOM element representing a Shiny tabPanel
  @return void
 */
const deactivate_panel = (panel) => {
  const dimmer = document.querySelector("[data-value='Dimmer'].tab-pane");
  panel && panel.classList.remove("active");
  panel && dimmer.classList.remove("dim");
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
  
  // Close the About panel
  Shiny && Shiny.addCustomMessageHandler("detail_close", (message) => {
    const panel = document.querySelector("[data-value='Detail'].tab-pane");
    deactivate_panel(panel)
  })
}

export {
  load_event_handlers
};
