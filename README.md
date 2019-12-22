<!-- README.md is generated from README.Rmd. Please edit that file -->

Rmonkey provides access to Survey Monkey, for the complete integration
of survey data collection and analysis into a single, easily
reproducible workflow. It used to be on CRAN. SurveyMoneky broke the
package when they changed their API, and it’s only on GitHub for now as
it comes back to life.

It is a simplified version of Rmonkey package. You may also see
<a href="https://github.com/cloudyr/Rmonkey" class="uri">https://github.com/cloudyr/Rmonkey</a>,
<a href="https://github.com/sfirke/Rmonkey" class="uri">https://github.com/sfirke/Rmonkey</a>
and
<a href="https://github.com/sfirke/Rmonkey" class="uri">https://github.com/sfirke/Rmonkey</a>.

It is now working for getting surveys from Survey Monkey.

-   Is it going to work for all cases? No! However it was usefull for me
    :)
-   Can you update functions to make it more general? Sure!

Installation
------------

Rmonkey is available on GitHub:

``` r
devtools::install_github("douglasmesquita/Rmonkey")
```

Setup
-----

To use Rmonkey, the user must have a Survey Monkey account, a Mashery
Survey Monkey Developer account, and a registered API application. To
create a Survey Monkey account, visit
<a href="https://www.surveymonkey.com/user/sign-in/" class="uri">https://www.surveymonkey.com/user/sign-in/</a>.
You’ll need to get an OAuth token (*provide more detailed
instructions*).

Once everything is registered, you can load your token with:

``` r
# Use your OAuth token here
options(sm_oauth_token = "yourtoken")
```

Using Rmonkey
-------------

### Retrieving survey responses

First get a list of surveys in your account and fetch the one you want
by name:

``` r
s <- survey_list(per_page = 200) # increase the per_page if your survey is really old and you give a lot of surveys
```

Then get the responses from that survey into a data.frame:

``` r
dat <- survey_responses(test_survey)
dat
```
