#' @title survey_responses
#' 
#' @description Extracts data from the survey responses data set and formats it as a data frame for analysis
#' 
#' @param survey A sm_survey object, as retrieved by \code{surveylist()}.
#' @param start_created_at Date string used to select surveys created after this date. By default is NULL.
#' @param end_created_at Date string used to select surveys modified before this date. By default is NULL.
#' @param start_modified_at Date string used to select surveys last modified after this date. By default is NULL.
#' @param end_modified_at Date string used to select surveys modified before this date. By default is NULL.
#' 
#' @return A data frame with survey responses
#' 
#' @export

survey_responses <- function(survey,                          
                             start_created_at = NULL,
                             end_created_at = NULL,
                             start_modified_at = NULL,
                             end_modified_at = NULL) {
  sr <- get_responses(survey, bulk = TRUE, all_page = TRUE, per_page = 100,                         
                      start_created_at = start_created_at,
                      end_created_at = end_created_at,
                      start_modified_at = start_modified_at,
                      end_modified_at = end_modified_at)
  sr <- parse_respondent_list(sr)
  sq <- survey_questions(survey)
  sc <- survey_choices(survey)
  
  resp_full <- dplyr::left_join(sr, sc, by = c("survey_id", "choice_id", "question_id")) %>%
    # mutate(subquestion_id = if_else(is.na(subquestion_id), question_id, subquestion_id)) %>%
    dplyr::mutate(answer_text = dplyr::if_else(is.na(answer_text), text, answer_text)) 
    
  resp_full <- dplyr::left_join(resp_full, sq, by =  c("survey_id", "question_id", "subquestion_id")) %>%
    dplyr::mutate(question_type = dplyr::if_else(is.na(question_type), "open_ended", question_type),
                  question_subtype = dplyr::if_else(is.na(question_subtype), "single", question_subtype))
  
  resp_full <- resp_full %>%
    dplyr::mutate(answer_text = dplyr::if_else(is.na(answer_text), subquestion_text, answer_text)) %>%
    dplyr::select(survey_id, collector_id, recipient_id, date_created, date_modified, total_time, response_id, 
                  question_id, question_type, heading, question_position,
                  subquestion_id, question_subtype, subquestion_text, subquestion_position,
                  choice_id, choice_other, choice_position, answer_text, 
                  collection_mode,status, ip_address, edit_url, analyse_url,page_position)
  
  return(resp_full)
}