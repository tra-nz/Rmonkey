#' @title find_survey_by_name
#' 
#' @description Get responses for a SurveyMonkey survey
#' 
#' @param name A string of name of the survey to be returned
#' @param s A sm_survey object, as retrieved by \code{surveylist()}.
#' 
#' @return A single of object of class {sm_response}
#' 
#' @export

find_survey_by_name = function (name, s){
  s[sapply(s,function(x) {
    # print(x$title)  
    x$title[[1]] == name
  })][[1]]
}