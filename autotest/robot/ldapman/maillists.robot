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
${TEST_USER}            wanger
${TEST_MAILLIST}        spacex
${TEST_MAILLIST_CN}     SPACEX

*** Test Cases ***
[POST] /api/maillists/{maillist}
    # Delete Group  ${SESSION}    ${TEST_GROUP}
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{maillist}=   Create Dictionary  cn=邮件列表
    ${resp}=    Post Request    ${SESSION}  /api/maillists/${TEST_MAILLIST}    data=${maillist}   headers=${headers}
    Status Should Be    200     ${resp}


[PUT] /api/maillists/{maillist}
    &{headers}=     Create Dictionary   Content-Type=application/json
    &{update}=   Create Dictionary   cn=${TEST_MAILLIST_CN}
    ${resp}=    Put Request    ${SESSION}  /api/maillists/${TEST_MAILLIST}    data=${update}   headers=${headers}
    Status Should Be    200     ${resp}

[GET] /api/maillists/
    ${resp}=    Get Request     ${SESSION}     /api/maillists/
    &{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data}
    Dictionary Should Contain Key   ${data}     ${TEST_MAILLIST}_group
    ${ml}=      Get From Dictionary     ${data}     ${TEST_MAILLIST}_group
    Log     ${ml}
    Should Be Equal     ${ml.cn}    ${TEST_MAILLIST_CN}


Create test user
    &{user}=    Create Dictionary   cn=王二     sn=王    givenName=二   admin=False     accountType=user
    Create User     ${SESSION}      ${TEST_USER}    &{user}


[PUT] /api/maillists/{maillist}/{userid}
    ${resp}=    Put Request     ${SESSION}     /api/maillists/${TEST_MAILLIST}/${TEST_USER}
    Status Should Be    200     ${resp}

[GET] /api/maillists/{maillist}/member
    ${resp}=    Get Request     ${SESSION}     /api/maillists/${TEST_MAILLIST}/member
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data}
    Length Should Be     ${data}     1
    &{user}=    Convert To Dictionary    ${data}[0]
    Should Be Equal     ${user.uid}     ${TEST_USER}

[DELTE] /api/maillists/{maillist}/{userid}
    ${resp}=    Delete Request    ${SESSION}  /api/maillists/${TEST_MAILLIST}/${TEST_USER}
    Status Should Be    200     ${resp}

Check maillist member after deletion
    ${resp}=    Get Request     ${SESSION}     /api/maillists/${TEST_MAILLIST}/member
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    Should Be Empty     ${data}


[DELETE] /api/maillists/{maillist}
    ${resp}=    Delete Request  ${SESSION}  /api/maillists/${TEST_MAILLIST}
    Status Should Be    200     ${resp}
