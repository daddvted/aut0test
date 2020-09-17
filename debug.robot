*** Settings ***

*** Test Cases ***
My Test
    ${a}    ${b}    ${c}=   Get Three
    Log Many    ${a}   ${b}    ${c}


*** Keywords ***
Get Three
    [return]    1  2   3
