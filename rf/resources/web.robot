*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported Selenium2Library.
Library           Selenium2Library

*** Variables ***
${DEFAULT_BROWSER}        Firefox
${DELAY}                  1

*** Keywords ***
Open Browser To Page
    [Arguments]     ${url}      ${page title}       ${browser}=${DEFAULT_BROWSER}
    Open Browser    ${url}      ${browser}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Title Should Be     ${page title}

Go To Login Page
    Go To    ${LOGIN URL}
    Login Page Should Be Open

Input Username
    [Arguments]    ${username}
    Input Text    username_field    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    password_field    ${password}

Submit Credentials
    Click Button    login_button

Welcome Page Should Be Open
    Location Should Be    ${WELCOME URL}
    Title Should Be    Welcome Page