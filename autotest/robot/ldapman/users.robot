*** Settings ***
Library     Collections
Library     RequestsLibrary

Resource    common.robot

Suite Setup      Create Oauth2 Session   ${SESSION}     ${USERNAME}     ${PASSWORD}
Suite Teardown   Delete User    ${SESSION}  ${TEST_USER}

*** Variables ***
${USERNAME}         zhangpeng
${PASSWORD}         zhangpeng
${SESSION}    current_session
${TEST_USER}        zhangsan
${NEW_PASSWORD}     P@ssw0rd

*** Test Cases ***
# Debug
#     &{result}=      HTTP Request    method=GET  api=/api/users/me   session=${SESSION}
#     Log     ${result}

[GET] /api/users/me
    ${resp}=    Get Request     ${SESSION}     /api/users/me
    &{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data.uid}
    Should Be Equal     ${data.uid}     ${USERNAME}


[GET] /api/users/
    ${resp}=    Get Request     ${SESSION}     /api/users/
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    # ${current_users}=   Get Length  ${data}
    # Log     ${current_users}
    Should Not Be Empty      ${data}
    # Set Global Variable     ${USERS_NO}     ${current_users}


[GET] /api/users/memberof
    ${resp}=    Get Request     ${SESSION}     /api/users/memberof
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data}
    Should Not Be Empty     ${data}


[POST] /api/users/{userid}
    # Delete user in case user exists
    Delete User     ${SESSION}     ${TEST_USER}

    &{user}=    Create Dictionary   cn=张三     sn=张    givenName=三   admin=False     accountType=user
    ${resp}=    Create User     ${SESSION}  zhangsan   &{user}
    Status Should Be    200     ${resp}


[GET] /api/users/{userid}
    &{user}=    Get User    ${SESSION}  ${TEST_USER}
    Log     ${user.uid}
    Should Be Equal     ${user.uid}     ${TEST_USER}


# Check Users Number
#     ${current_user_no}=     Get Users Number  ${SESSION}
#     Log     ${current_user_no}
#     ${tmp}=     Evaluate    ${USERS_NO} + 1
#     Should Be Equal     ${current_user_no}  ${tmp}


[PUT] /api/users/{userid}
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{user}=    Create Dictionary   cn=zhangsan     sn=张    givenName=三   admin=False
    ${resp}=    Put Request    ${SESSION}    /api/users/${TEST_USER}   data=${user}    headers=${headers}
    Status Should Be    200     ${resp}


Check User Attribute
    ${user}=    Get User    ${SESSION}    ${TEST_USER}
    Log     ${user.cn}
    Should Be Equal     ${user.cn}  zhangsan


[PUT] /api/users/{userid}/lock
    ${resp}=    Put Request     ${SESSION}     /api/users/${TEST_USER}/lock
    Status Should Be    200     ${resp}


Check User Lock
    &{user}=    Get User    ${SESSION}  ${TEST_USER}
    Log     ${user}
    Log     ${user.accountStatus}
    Should Be Equal     ${user.accountStatus}   inactive


[PUT] /api/users/{userid}/unlock
    ${resp}=    Put Request     ${SESSION}     /api/users/${TEST_USER}/unlock
    Status Should Be    200     ${resp}


Check User Unlock
    &{user}=    Get User    ${SESSION}  ${TEST_USER}
    Log     ${user}
    Log     ${user.accountStatus}
    Should Be Equal     ${user.accountStatus}   active


[PUT] /api/users/password
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{password_update}=    Create Dictionary   old_password=${PASSWORD}  new_password=${NEW_PASSWORD}

    ${resp}=    Put Request    ${SESSION}    /api/users/password   data=${password_update}    headers=${headers}
    Status Should Be    200     ${resp}


Verify Password
    ${headers}=         Create Dictionary   Content-Type=application/x-www-form-urlencoded
    ${form_data}=       Create Dictionary   username=${username}    password=${NEW_PASSWORD}
    Create Session      token_session     ${API_BACKEND}
    ${resp}=            Post Request    token_session   ${TOKEN_API}    data=${form_data}       headers=${headers}
    Status Should Be    200     ${resp}


Revert Passwod
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{password_update}=    Create Dictionary   old_password=${NEW_PASSWORD}  new_password=${PASSWORD}

    ${resp}=    Put Request    ${SESSION}    /api/users/password   data=${password_update}    headers=${headers}
    Status Should Be    200     ${resp}


[PUT] /api/users/{userid}/password/reset
    ${resp}=    Put Request    ${SESSION}    /api/users/${TEST_USER}/password/reset
    Status Should Be    200     ${resp}


Verify User Password
    ${headers}=         Create Dictionary   Content-Type=application/x-www-form-urlencoded
    ${form_data}=       Create Dictionary   username=${TEST_USER}    password=12345678
    Create Session      token_session     ${API_BACKEND}
    ${resp}=            Post Request    token_session   ${TOKEN_API}    data=${form_data}       headers=${headers}
    Status Should Be    200     ${resp}
