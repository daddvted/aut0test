*** Settings ***
Library     Collections
Library     RequestsLibrary

Resource    common.robot

Suite Setup      Create Oauth2 Session   ${USERS_SESSION}     ${USERNAME}     ${PASSWORD}

*** Variables ***
${USERNAME}         zhangpeng
${PASSWORD}         zhangpeng
${USERS_SESSION}    current_session

*** Test Cases ***
[GET] /api/util/menu
    ${resp}=    Get Request     ${USERS_SESSION}     /api/util/menu
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data}
    Length Should Be    ${data}     4

[GET] /api/util/syncuser
    ${resp}=    Get Request     ${USERS_SESSION}     /api/util/syncuser
    Status Should Be    200     ${resp}

[GET] /api/util/syncmaillist
    ${resp}=    Get Request     ${USERS_SESSION}     /api/util/syncmaillist
    Status Should Be    200     ${resp}

[GET] /api/util/{dn}
    ${resp}=    Get Request     ${USERS_SESSION}     /api/users/me
    &{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data.dn}
    ${resp}=    Get Request     ${USERS_SESSION}     /api/util/${data.dn}
    &{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data}
    Should Be Equal     ${data.uid}     ${USERNAME}




