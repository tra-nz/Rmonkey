#' @title find_survey_by_id
#' 
#' @description Get responses for a SurveyMonkey survey
#' 
#' @param id A numeric survey monkey survey_id of the survey to be returned
#' @param s A sm_survey object, as retrieved by \code{surveylist()}.
#' 
#' @return A single of object of class {sm_response}
#' 
#' @export

find_survey_by_id = function (id, s){
  s[sapply(s,function(x) { 
    x$id[[1]] == id
  })][[1]]
}