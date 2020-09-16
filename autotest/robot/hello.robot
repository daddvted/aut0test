*** Settings ***
Documentation   This is desc
Library         OperatingSystem


*** Variables ***
${MESSAGE}      Hello, Ted


*** Test Cases ***
Hello Test
    [Documentation]     Hello desc
    Log     hello ted
My test
    [Documentation]     example test
    Log     ${MESSAGE}
    My Keyword      ${CURDIR}

Another Test
   Should Be Equal  ${MESSAGE}  Hello, Ted

*** Keywords ***
My Keyword
    [Arguments]     ${path}
    Directory Should Exist  ${path}