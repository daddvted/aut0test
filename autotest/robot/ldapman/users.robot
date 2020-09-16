*** Settings ***
Library     Collections
Library     RequestsLibrary

Resource    auth.robot

Test Setup  Create Oauth2 Session   ${USERS_SESSION}     ${USERNAME}     ${PASSWORD}

*** Variables ***
${USERNAME}         zhangpeng
${PASSWORD}         zhangpeng
${USERS_SESSION}     current_session

*** Test Cases ***
Test GET /api/users/me
    ${resp}=    Get Request     ${USERS_SESSION}     /api/users/me
    &{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data.uid}
    Should Be Equal     ${data.uid}     ${USERNAME}

Test GET /api/users
    ${resp}=    Get Request     ${USERS_SESSION}     /api/users
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    ${current_users}=   Get Length  ${data}
    Set Global Variable     ${USERS_NO}     ${current_users}

Test GET /api/users/memberof
    ${resp}=    Get Request     ${USERS_SESSION}     /api/users/memberof
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    Should Not Be Empty     ${data}


Test POST /api/users/{userid}
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{user}=    Create Dictionary   cn=张三     sn=张    givenName=三   admin=False     accountType=user
    ${resp}=    Post Request    ${USERS_SESSION}    /api/users/zhangsan     data=${user}    headers=${headers}
    Log     ${resp}
    # Log     ${user}
    # Log     ${USERS_NO}

