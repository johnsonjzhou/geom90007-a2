/**
  Scripts used in the Shiny app
 */

import { check_user_agent } from "./user_agent.js"

window.onload = () => {
  check_user_agent();
}