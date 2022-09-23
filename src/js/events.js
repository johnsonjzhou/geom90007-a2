/**
  Handling of reactive event messages from Shiny
 */

const load_event_handlers = () => {
  // Open the About panel
  Shiny.addCustomMessageHandler("about_open", (message) => {
    const panel = document.querySelector("[data-value='About'].tab-pane");
    panel.classList.add("active");
  })
  
  // Close the About panel
  Shiny.addCustomMessageHandler("about_close", (message) => {
    const panel = document.querySelector("[data-value='About'].tab-pane");
    panel.classList.remove("active");
  })
}

export {
  load_event_handlers
};
