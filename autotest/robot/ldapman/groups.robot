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


[PUT] /api/groups/{group}/{subgroup}/{userid}
    ${resp}=    Put Request    ${SESSION}  /api/groups/${TEST_GROUP}/${TEST_SUBGROUP}/${TEST_USER}
    ${data}=    evaluate    json.loads("""${resp.text}""")   json
    Log     ${data}


[GET] /api/groups/{group}/{subgroup}/member
    ${resp}=    Get Request     ${SESSION}     /api/groups/${TEST_GROUP}/${TEST_SUBGROUP}/member
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    Length Should Be    ${data}     2
    FOR     ${user}      IN      @{data}
        &{u}=   Convert To Dictionary   ${user}
        Log     ${u.uid}
        Pass Execution If   '${TEST_USER}' == '${u.uid}'    Bingo
    END
    FAIL    Add user to subgroup failed

    

[DELTE] /api/groups/{group}/{subgroup}/{userid}
    ${resp}=    Delete Request    ${SESSION}  /api/groups/${TEST_GROUP}/${TEST_SUBGROUP}/${TEST_USER}
    Status Should Be    200     ${resp}

[DELETE] /api/groups/{group}/{subgroup}
    ${resp}=    Delete Request  ${SESSION}  /api/groups/${TEST_GROUP}/${TEST_SUBGROUP}
    Status Should Be    200     ${resp}

[DELETE] /api/groups/{group}
    ${resp}=    Delete Request  ${SESSION}  /api/groups/${TEST_GROUP}
    Status Should Be    200     ${resp}
