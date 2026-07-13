###############################################################################
# server.R
#
# Server Logic
# Hospital LOS Scenario Dashboard
###############################################################################

app_server <- function(input,
                       output,
                       session,
                       app_data){

###############################################################################
# Load shared objects
###############################################################################

cohort <- app_data$cohort

model <- app_data$model

levels <- app_data$variable_levels

###############################################################################
# Populate drop-down menus
###############################################################################

observe({

updateSelectInput(
session,
"region",
choices = levels$region
)

updateSelectInput(
session,
"ownership",
choices = levels$ownership
)

updateSelectInput(
session,
"level",
choices = levels$hospital_level
)

})

###############################################################################
# Reset scenario
###############################################################################

observeEvent(input$resetScenario,{

updateSliderInput(session,"emergency",value=45)

updateSliderInput(session,"elderly",value=22)

updateSliderInput(session,"male",value=48)

updateSliderInput(session,"surgical",value=35)

updateNumericInput(session,"admissions",value=5000)

updateNumericInput(session,"beds",value=450)

})

###############################################################################
# Build scenario
###############################################################################

scenario_df <- eventReactive(

input$runScenario,

{

build_scenario(

cohort = cohort,

emergency = input$emergency,

elderly = input$elderly,

male = input$male,

surgical = input$surgical,

region = input$region,

ownership = input$ownership,

hospital_level = input$level,

monthly_admissions = input$admissions

)

}

)

###############################################################################
# Predict LOS
###############################################################################

prediction_df <- reactive({

req(scenario_df())

predict_los(

model = model,

newdata = scenario_df()

)

})

###############################################################################
# Calculate summary statistics
###############################################################################

scenario_summary <- reactive({

req(prediction_df())

calculate_summary(

prediction_df(),

beds = input$beds

)

})

###############################################################################
# KPI Boxes
###############################################################################

output$meanLOS <- renderText({

round(
scenario_summary()$mean_los,
2
)

})

output$bedDays <- renderText({

comma(
round(
scenario_summary()$bed_days
)
)

})

output$occupancy <- renderText({

paste0(

round(
scenario_summary()$occupancy,
1
),

"%"

)

})

output$longStay <- renderText({

comma(

scenario_summary()$long_stay

)

})

###############################################################################
# Baseline vs Scenario
###############################################################################

output$baselineScenarioPlot <- renderPlotly({

plot_baseline_vs_scenario(

baseline = cohort,

scenario = prediction_df()

)

})

###############################################################################
# LOS Distribution
###############################################################################

output$losDistribution <- renderPlotly({

plot_los_distribution(

prediction_df()

)

})

###############################################################################
# LOS Bar Plot
###############################################################################

output$losBar <- renderPlotly({

plot_los_bar(

prediction_df()

)

})

###############################################################################
# LOS Pie Chart
###############################################################################

output$losPie <- renderPlotly({

plot_los_pie(

prediction_df()

)

})

###############################################################################
# Bed Occupancy Plot
###############################################################################

output$occupancyPlot <- renderPlotly({

plot_bed_occupancy(

scenario_summary()

)

})

###############################################################################
# Bed-day Plot
###############################################################################

output$beddayPlot <- renderPlotly({

plot_bed_days(

scenario_summary()

)

})

###############################################################################
# Scenario Comparison Table
###############################################################################

output$scenarioTable <- DT::renderDT({

scenario_table(

baseline = cohort,

scenario = prediction_df()

)

})

###############################################################################
# Representative Cohort
###############################################################################

output$cohortTable <- DT::renderDT({

prediction_df()

})

###############################################################################
# Download Scenario Results
###############################################################################

output$downloadScenario <- downloadHandler(

filename = function(){

paste0(

"LOS_Scenario_",

Sys.Date(),

".csv"

)

},

content = function(file){

write.csv(

prediction_df(),

file,

row.names = FALSE

)

}

)

###############################################################################
# Download Summary
###############################################################################

output$downloadSummary <- downloadHandler(

filename = function(){

paste0(

"Scenario_Summary_",

Sys.Date(),

".csv"

)

},

content = function(file){

write.csv(

scenario_summary(),

file,

row.names = FALSE

)

}

)

}
