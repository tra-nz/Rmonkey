parse_single_answer <- function(answer){
  answer$tag_data <- NULL
  out <- dplyr::bind_rows(answer)
  
  return(out)
}

parse_answers <- function(question){
  out <- purrr::map_df(question$answers, parse_single_answer) %>%
    dplyr::mutate(question_id = question$id)
  
  return(out)
}

parse_page <- function(page){
  out <- purrr::map_df(page$questions, parse_answers)
  
  return(out)
}

parse_response <- function(response){
  out <- purrr::map_df(response$pages, parse_page) %>%
    dplyr::mutate(response_id = response$id,
                  collector_id = response$collector_id,
                  survey_id = response$survey_id,
                  recipient_id = response$recipient_id,
                  date_created = response$date_created, 
                  date_modified = response$date_modified, 
                  total_time = response$total_time,
                  collection_mode = response$collection_mode,
                  status = response$response_status,
                  ip_address = response$ip_address,
                  edit_url = response$edit_url,
                  analyse_url = response$analyze_url)
  
  return(out)
}

parse_respondent_list <- function(respondents){
  out <- purrr::map_df(respondents, parse_response)
  
  if(!("other_id" %in% names(out))) out$other_id <- NA_character_
  
  out <- out %>%
    # dplyr::mutate(subquestion_id = choice_id) %>%
    dplyr::rename(answerchoice_id = other_id,
                  answer_text = text,
                  subquestion_id = row_id ) %>%
    dplyr::mutate(choice_id = dplyr::coalesce(choice_id, answerchoice_id)) %>% ##-- When answerchoice_id is not NA, choice_id is NA
    dplyr::select(-answerchoice_id) %>%
    dplyr::select(survey_id, collector_id, recipient_id, date_created, date_modified, total_time, response_id, question_id, choice_id, subquestion_id, answer_text,
                  collection_mode, status, ip_address, edit_url, analyse_url)
  
  return(out)
}

get_ind_question_info <- function(question) {
  heading <- question$headings[[1]]$heading
  if(is.null(heading)) heading <- NA
  
  out <- dplyr::tibble(heading = heading,
                           question_id = question$id,
                           question_type = question$family,
                           question_subtype = question$subtype)
  
  return(out)
}

parse_page_of_questions <- function(page) {
  out <- purrr::map_df(page$questions, get_ind_question_info)
  
  return(out)
}

parse_answer_choices <- function(question) {
  if(!is.null(question$answers$other)){
    other <-  question$answers$other %>%
      dplyr::bind_rows() %>%
      dplyr::select(id, visible, text, position)
  } else{
    other <- NULL
  }
  
  if(!is.null(question$answers)){ # some basic Qs like comment box don't even have answer choices
    choices <- question$answers$choices %>%
      dplyr::bind_rows()
  } else {
    choices <- NULL
  }
  
  out <- dplyr::bind_rows(choices, other) %>%
    dplyr::mutate(question_id = question$id)
  
  if(!("weight" %in% names(out)))
    out <- out %>% dplyr::mutate(weight = rep(NA, dplyr::n()))
  
  return(out)
}

parse_page_for_choices <- function(page) {
  purrr::map_df(page$questions, parse_answer_choices)
}

parse_page_for_rows <- function(page) {
  out <- purrr::map_df(page$questions, parse_rows)
  
  return(out)
}

parse_rows <- function(question) {
  if(!is.null(question$answers$rows)){
    rows <- dplyr::bind_rows(question$answers$rows)
  } else {
    rows <- NULL
  }
  
  out <- dplyr::as_tibble(rows) %>%
    dplyr::mutate(question_id = question$id)
  
  return(out)
}
