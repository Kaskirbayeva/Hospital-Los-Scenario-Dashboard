###############################################################################
# scenario.R
#
# Scenario Engine
#
# Hospital LOS Scenario Dashboard
#
# Modifies a representative cohort according to user-defined
# "what-if" scenarios before prediction.
###############################################################################

library(dplyr)

###############################################################################
# Build scenario
###############################################################################

build_scenario <- function(
    cohort,
    emergency = NULL,
    elderly = NULL,
    male = NULL,
    surgical = NULL,
    region = NULL,
    ownership = NULL,
    hospital_level = NULL,
    monthly_admissions = NULL){

  df <- cohort

  set.seed(123)

###############################################################################
# Resize cohort
###############################################################################

  if(!is.null(monthly_admissions)){

    if(monthly_admissions > nrow(df)){

      df <- df %>%
        slice_sample(
          n = monthly_admissions,
          replace = TRUE
        )

    }else{

      df <- df %>%
        slice_sample(
          n = monthly_admissions,
          replace = FALSE
        )

    }

  }

###############################################################################
# Emergency admissions
###############################################################################

  if(!is.null(emergency)){

    target <- emergency/100

    current <- mean(df$admission == "Emergency")

    if(target > current){

      need <- round((target-current)*nrow(df))

      idx <- which(df$admission != "Emergency")

      idx <- sample(idx,min(length(idx),need))

      df$admission[idx] <- "Emergency"

    }

    if(target < current){

      need <- round((current-target)*nrow(df))

      idx <- which(df$admission == "Emergency")

      idx <- sample(idx,min(length(idx),need))

      df$admission[idx] <- "Elective"

    }

  }

###############################################################################
# Elderly patients
###############################################################################

  if(!is.null(elderly)){

    target <- elderly/100

    current <- mean(df$age >= 65)

    if(target > current){

      need <- round((target-current)*nrow(df))

      idx <- which(df$age < 65)

      idx <- sample(idx,min(length(idx),need))

      df$age[idx] <- sample(
        65:95,
        length(idx),
        replace = TRUE
      )

    }

    if(target < current){

      need <- round((current-target)*nrow(df))

      idx <- which(df$age >= 65)

      idx <- sample(idx,min(length(idx),need))

      df$age[idx] <- sample(
        18:64,
        length(idx),
        replace = TRUE
      )

    }

  }

###############################################################################
# Male patients
###############################################################################

  if(!is.null(male)){

    target <- male/100

    current <- mean(df$sex == "Male")

    if(target > current){

      need <- round((target-current)*nrow(df))

      idx <- which(df$sex != "Male")

      idx <- sample(idx,min(length(idx),need))

      df$sex[idx] <- "Male"

    }

    if(target < current){

      need <- round((current-target)*nrow(df))

      idx <- which(df$sex == "Male")

      idx <- sample(idx,min(length(idx),need))

      df$sex[idx] <- "Female"

    }

  }

###############################################################################
# Surgical admissions
###############################################################################

  if(!is.null(surgical)){

    if("surgical" %in% names(df)){

      target <- surgical/100

      current <- mean(df$surgical == "Yes")

      if(target > current){

        need <- round((target-current)*nrow(df))

        idx <- which(df$surgical != "Yes")

        idx <- sample(idx,min(length(idx),need))

        df$surgical[idx] <- "Yes"

      }

      if(target < current){

        need <- round((current-target)*nrow(df))

        idx <- which(df$surgical == "Yes")

        idx <- sample(idx,min(length(idx),need))

        df$surgical[idx] <- "No"

      }

    }

  }

###############################################################################
# Region
###############################################################################

  if(!is.null(region)){

    if(region != ""){

      df$region <- region

    }

  }

###############################################################################
# Ownership
###############################################################################

  if(!is.null(ownership)){

    if("ownership" %in% names(df)){

      if(ownership != ""){

        df$ownership <- ownership

      }

    }

  }

###############################################################################
# Hospital level
###############################################################################

  if(!is.null(hospital_level)){

    if("hospital_level" %in% names(df)){

      if(hospital_level != ""){

        df$hospital_level <- hospital_level

      }

    }

  }

###############################################################################
# Scenario metadata
###############################################################################

  attr(df,"scenario") <- list(

    emergency = emergency,

    elderly = elderly,

    male = male,

    surgical = surgical,

    region = region,

    ownership = ownership,

    hospital_level = hospital_level,

    admissions = monthly_admissions,

    timestamp = Sys.time()

  )

###############################################################################
# Return modified cohort
###############################################################################

  return(df)

}

###############################################################################
# Scenario summary
###############################################################################

scenario_description <- function(df){

  tibble(

    Variable = c(

      "Emergency admissions",

      "Patients ≥65 years",

      "Male patients",

      "Admissions"

    ),

    Value = c(

      round(100*mean(df$admission=="Emergency"),1),

      round(100*mean(df$age>=65),1),

      round(100*mean(df$sex=="Male"),1),

      nrow(df)

    )

  )

}

###############################################################################
# End of scenario.R
###############################################################################
