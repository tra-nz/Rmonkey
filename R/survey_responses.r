#' @title survey_responses
#' 
#' @description Extracts data from the survey responses data set and formats it as a data frame for analysis
#' 
#' @param survey A sm_survey object, as retrieved by \code{surveylist()}.
#' 
#' @return A data frame with survey responses
#' 
#' @export

survey_responses <- function(survey) {
  sr <- get_responses(survey, bulk = TRUE, all_page = TRUE, per_page = 100)
  sr <- parse_respondent_list(sr)
  sq <- survey_questions(survey)
  sc <- survey_choices(survey)
  
  resp_full <- dplyr::left_join(sr, sc, by = c("survey_id", "choice_id", "question_id"))
  
  resp_full <- dplyr::left_join(resp_full, sq, by =  c("survey_id", "question_id", "subquestion_id")) %>%
    dplyr::mutate(question_type = dplyr::if_else(is.na(question_type), "open_ended", question_type),
                  question_subtype = dplyr::if_else(is.na(question_subtype), "single", question_subtype))
  
  resp_full <- resp_full %>%
    dplyr::mutate(answertext = dplyr::if_else(is.na(answertext), subquestion_text, answertext)) %>%
    dplyr::select(survey_id, collector_id, recipient_id, response_id, 
                  question_id, question_type, heading,
                  choice_id, 
                  subquestion_id, question_subtype, subquestion_text,
                  answertext)
  
  return(resp_full)
}