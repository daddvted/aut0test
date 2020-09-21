*** Settings ***
Library     Collections
Library     RequestsLibrary

Resource    common.robot

Suite Setup      Create Oauth2 Session      ${SESSION}      ${USERNAME}     ${PASSWORD}
Suite Teardown   Delete User    ${SESSION}  ${TEST_USER}

*** Variables ***
${USERNAME}             zhangpeng
${PASSWORD}             zhangpeng
${SESSION}              current_session
${TEST_USER}            lisi
${TEST_GROUP}           car
${TEST_DESC}            CAR
${TEST_SUBGROUP}        audi
${TEST_SUBGROUP_DESC}   AUDI

*** Test Cases ***
[GET] /api/groups/tree
    ${resp}=    Get Request     ${SESSION}     /api/groups/tree
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    Should Not Be Empty     ${data}

[POST] /api/groups/{group}
    # Delete Group  ${SESSION}    ${TEST_GROUP}
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{group}=   Create Dictionary  ou=${TEST_GROUP}     description=汽车
    ${resp}=    Post Request    ${SESSION}  /api/groups/${TEST_GROUP}    data=${group}   headers=${headers}
    Status Should Be    200     ${resp}

# [GET] /api/groups/{group}
#     ${resp}=    Get Request     ${SESSION}      /api/groups/${TEST_GROUP}
#     Status Should Be    200     ${resp}

[PUT] /api/groups/{group}
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{update}=   Create Dictionary   description=${TEST_DESC}
    ${resp}=    Put Request    ${SESSION}  /api/groups/${TEST_GROUP}    data=${update}   headers=${headers}
    Status Should Be    200     ${resp}

[GET] /api/groups/
    ${resp}=    Get Request     ${SESSION}     /api/groups/
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    ${len}=     Get Length  ${data}
    FOR     ${grp}      IN      @{data}
        &{g}=   Convert To Dictionary   ${grp}
        Pass Execution If   '${TEST_DESC}' == '${g.description}'    Bingo
    END
    FAIL    Group update failed

Create test user
    &{user}=    Create Dictionary   cn=李四     sn=李    givenName=四   admin=False     accountType=user
    Create User     ${SESSION}      ${TEST_USER}    &{user}


[POST] /api/groups/{group}/{subgroup}
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{subgroup}=    Create Dictionary   cn=${TEST_GROUP}     description=奥迪
    ${resp}=    Post Request    ${SESSION}  /api/groups/${TEST_GROUP}/${TEST_SUBGROUP}    data=${subgroup}   headers=${headers}
    Status Should Be    200     ${resp}


[GET] /api/groups/{group}
    ${resp}=    Get Request     ${SESSION}     /api/groups/${TEST_GROUP}
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data}
    Length Should Be     ${data}     1


[PUT] /api/groups/{group}/{subgroup}
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{update}=   Create Dictionary   description=${TEST_SUBGROUP_DESC}
    ${resp}=    Put Request    ${SESSION}  /api/groups/${TEST_GROUP}/${TEST_SUBGROUP}    data=${update}   headers=${headers}
    Status Should Be    200     ${resp}


[GET] /api/groups/{group}/{subgroup}
    ${resp}=    Get Request     ${SESSION}     /api/groups/${TEST_GROUP}/${TEST_SUBGROUP}
    &{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data.cn}
    Should Be Equal      ${data.cn}      ${TEST_SUBGROUP}







[GET] /api/groups/{group}/{subgroup}/member
    ${resp}=    Get Request     ${SESSION}     /api/groups/${TEST_GROUP}
    @{data}=    evaluate    json.loads("""${resp.text}""")   json


[DELETE] /api/groups/{group}/{subgroup}
    ${resp}=    Delete Request  ${SESSION}  /api/groups/${TEST_GROUP}/${TEST_SUBGROUP}
    Status Should Be    200     ${resp}


[DELETE] /api/groups/{group}
    ${resp}=    Delete Request  ${SESSION}  /api/groups/${TEST_GROUP}
    Status Should Be    200     ${resp}




# [GET] /api/users/memberof
#     ${resp}=    Get Request     ${SESSION}     /api/users/memberof
#     @{data}=    evaluate    json.loads("""${resp.text}""")   json
#     Log     ${data}
#     Should Not Be Empty     ${data}


# [POST] /api/users/{userid}
#     # Delete user in case user exists
#     Delete User     ${TEST_USER}

#     ${result}=  Create User     ${TEST_USER}
#     Status Should Be    200     ${result}

# [GET] /api/users/{userid}
#     &{user}=    Get User  ${TEST_USER}
#     Log     ${user.uid}
#     Should Be Equal     ${user.uid}     ${TEST_USER}

# Check Users Number
#     ${current_user_no}=     Get Users No
#     ${tmp}=     Evaluate    ${USERS_NO} + 1
#     Should Be Equal     ${current_user_no}  ${tmp}

# [PUT] /api/users/{userid}
#     &{headers}=     Create Dictionary   Content-Type=application/json
#     &{user}=    Create Dictionary   cn=zhangsan     sn=张    givenName=三   admin=False

#     ${resp}=    Put Request    ${SESSION}    /api/users/${TEST_USER}   data=${user}    headers=${headers}
#     Status Should Be    200     ${resp}

# Check User Attribute
#     ${user}=    Get User    ${TEST_USER}
#     Log     ${user.cn}
#     Should Be Equal     ${user.cn}  zhangsan

# [PUT] /api/users/{userid}/lock
#     ${resp}=    Put Request     ${SESSION}     /api/users/${TEST_USER}/lock
#     Status Should Be    200     ${resp}

# Check User Lock
#     &{user}=    Get User  ${TEST_USER}
#     Log     ${user}
#     Log     ${user.accountStatus}
#     Should Be Equal     ${user.accountStatus}   inactive

# [PUT] /api/users/{userid}/unlock
#     ${resp}=    Put Request     ${SESSION}     /api/users/${TEST_USER}/unlock
#     Status Should Be    200     ${resp}

# Check User Unlock
#     &{user}=    Get User  ${TEST_USER}
#     Log     ${user}
#     Log     ${user.accountStatus}
#     Should Be Equal     ${user.accountStatus}   active

# [PUT] /api/users/password
#     &{headers}=     Create Dictionary   Content-Type=application/json
#     &{password_update}=    Create Dictionary   old_password=${PASSWORD}  new_password=${NEW_PASSWORD}

#     ${resp}=    Put Request    ${SESSION}    /api/users/password   data=${password_update}    headers=${headers}
#     Status Should Be    200     ${resp}

# Verify Password
#     ${headers}=         Create Dictionary   Content-Type=application/x-www-form-urlencoded
#     ${form_data}=       Create Dictionary   username=${username}    password=${NEW_PASSWORD}
#     Create Session      token_session     ${API_BACKEND}
#     ${resp}=            Post Request    token_session   ${TOKEN_API}    data=${form_data}       headers=${headers}
#     Status Should Be    200     ${resp}

# Revert Passwod
#     &{headers}=     Create Dictionary   Content-Type=application/json
#     &{password_update}=    Create Dictionary   old_password=${NEW_PASSWORD}  new_password=${PASSWORD}

#     ${resp}=    Put Request    ${SESSION}    /api/users/password   data=${password_update}    headers=${headers}
#     Status Should Be    200     ${resp}

# [PUT] /api/users/{userid}/password/reset
#     ${resp}=    Put Request    ${SESSION}    /api/users/${TEST_USER}/password/reset
#     Status Should Be    200     ${resp}

# Verify User Password
#     ${headers}=         Create Dictionary   Content-Type=application/x-www-form-urlencoded
#     ${form_data}=       Create Dictionary   username=${TEST_USER}    password=12345678
#     Create Session      token_session     ${API_BACKEND}
#     ${resp}=            Post Request    token_session   ${TOKEN_API}    data=${form_data}       headers=${headers}
#     Status Should Be    200     ${resp}



# *** Keywords ***
# Create User
#     [Arguments]     ${uid}

#     &{headers}=     Create Dictionary   Content-Type=application/json
#     &{user}=    Create Dictionary   cn=张三     sn=张    givenName=三   admin=False     accountType=user

#     ${resp}=    Post Request    ${SESSION}    /api/users/${uid}   data=${user}    headers=${headers}
#     [Return]    ${resp}

# Get User
#     [Arguments]     ${uid}
#     ${resp}=    Get Request     ${SESSION}     /api/users/${uid}
#     &{data}=    evaluate    json.loads("""${resp.text}""")   json
#     [Return]    &{data}

# Delete User
#     [Arguments]     ${uid}
#     Log     ${uid}
#     ${resp}=    Delete Request      ${SESSION}    /api/users/${uid}
#     # Status Should Be    200     ${resp}


# Get Users No
#     ${resp}=    Get Request     ${SESSION}     /api/users
#     @{data}=    evaluate    json.loads("""${resp.text}""")   json
#     ${current_users}=   Get Length  ${data}
#     [Return]    ${current_users}
