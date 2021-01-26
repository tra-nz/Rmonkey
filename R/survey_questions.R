#' @title survey_questions
#' 
#' @description Creates a data frame from the survey questions and answers
#' 
#' @param survey A sm_survey object, as retrieved by \code{surveylist()}.
#' 
#' @return A data frame with one row per question/subquestion/answer choice
#' 
#' @export

survey_questions <- function(survey) {
  sd <- survey_details(survey, question_details = TRUE)
  
  questions <- purrr::map_df(sd$pages, parse_page_of_questions) %>%
    dplyr::mutate(survey_id = sd$id)
  
  rows <- purrr::map_df(sd$pages, parse_page_for_rows) %>%
    dplyr::rename(subquestion_id = id) %>%
    dplyr::select(question_id, subquestion_id, subquestion_text = text, subquestion_position = position)
  
  full_questions <- dplyr::full_join(questions, rows, by = "question_id") %>%
    dplyr::select(survey_id, question_id, question_type, question_subtype, subquestion_id, heading, subquestion_text,page_position,question_position,subquestion_position) 
  
  return(full_questions)
}

#' @title survey_choices
#' 
#' @description Creates a data frame from the survey choices
#' 
#' @param survey A sm_survey object, as retrieved by \code{surveylist()}.
#' 
#' @return A data frame with one row per choice
#' 
#' @export 

survey_choices <- function(survey) {
  sd <- survey_details(survey, question_details = TRUE)
  
  out <- purrr::map_df(sd$pages, parse_page_for_choices) %>%
    dplyr::mutate(survey_id = sd$id) %>%
    dplyr::select(survey_id, question_id, choice_id = id, text, weight, choice_position,choice_other)
  
  return(out)
}
