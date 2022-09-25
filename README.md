# Nutrition and Food Security around the world

![Screenshot][screenshot]

This is an interactive `R/Shiny` dashboard 
that showcases select data from the report 
The State of Food Security and Nutrition in the World 2022 (SOFI) 
accessible from [FAO][fao_sofi] or [UNICEF][unicef_sofi] with additional 
supporting data obtained from the UNICEF [data warehouse][unicef_data].

## Views

1. [Map View][map_view]
2. [Details View][detail_view]

## Run App

### Requirements

This app makes extensive use of the CSS property `backdrop-filter` 
which is not supported by the native browser within RStudio. 

For the optimal visual experience, please view the running application 
in a modern browser. `Google Chrome` would be preferred, although would 
also work in `Firefox` and `Safari`.

### Install dependencies
```R
source("./R/libraries.R")
```

### Running the Shiny App
```R
# ./app.R
shiny::shinyApp(ui, server)
```

## Building

### Directory tree
```
root
  |- data: data sources for the dash board
  |- doc: documentation
  |- R: supporting R scripts for the app
  |- src: supporting non-R source files and assets
  |- www: production non-R files and assets for use by the app
```

### Building supporting (non-R) source files (optional)
Non-R source files are built using `webpack`, 
transforming from `./src` to `./www`.  
```bash
# install node module
npm install

# build
npm run build
```

## Developed by
Johnson Zhou  

Assignment 2  
GEOM90007 Information Visualisation  
University of Melbourne  

Email: [zhoujj@student.unimelb.edu.au][email]  
Email: [johnson.zhou@simplyuseful.io][email2]  
Github: [https://github.com/johnsonjzhou/geom90007-a2][github]  

> Material presented in this dashboard do not imply the expression of any 
> opinion on part of the Developer or the University of Melbourne. 
> The responsibility for the interpretation and use of the material 
> lies with the user. 
> In no event shall the Developer or the University of Melbourne be liable 
> for damages arising from its use. 

[email]: mailto:zhoujj@student.unimelb.edu.au
[email2]: mailto:johnson.zhou@simplyuseful.io
[github]: https://github.com/johnsonjzhou/geom90007-a2

[screenshot]: ./doc/screenshot.png
[map_view]: ./src/md/map_view.md
[detail_view]: ./src/md/detail_view.md

[fao_sofi]: https://www.fao.org/publications/sofi/2022/en/
[unicef_sofi]: https://data.unicef.org/resources/sofi-2022/
[unicef_data]: https://data.unicef.org/topic/nutrition/malnutrition/