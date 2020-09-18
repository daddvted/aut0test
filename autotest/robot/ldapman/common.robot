*** Settings ***
Library     Collections
Library     RequestsLibrary

*** Variables ***
${API_BACKEND}          http://172.16.66.6:8000
${TOKEN_API}            /api/token

*** Keywords ***
Get Oauth2 Token
    [Arguments]         ${username}     ${password}
    ${headers}=         Create Dictionary   Content-Type=application/x-www-form-urlencoded
    ${form_data}=       Create Dictionary   username=${username}    password=${password}
    Create Session      token_session     ${API_BACKEND}
    ${resp}=            Post Request    token_session   ${TOKEN_API}    data=${form_data}       headers=${headers}
    Status Should Be    200     ${resp}
    &{data}=            evaluate    json.loads("""${resp.text}""")  json
    [Return]            Bearer ${data.access_token}


Create Oauth2 Session
    [Arguments]         ${session}      ${username}     ${password}
    ${token}=           Get Oauth2 Token    ${username}     ${password}
    ${headers}=         Create Dictionary   Authorization=${token}
    Create Session      ${session}      ${API_BACKEND}      headers=${headers}
    # [Return]            ${session}


Create User
    [Arguments]      ${session}     ${uid}    &{user}

    &{headers}=     Create Dictionary   Content-Type=application/json

    ${resp}=    Post Request    ${session}    /api/users/${uid}   data=${user}    headers=${headers}
    [Return]    ${resp}


Delete User
    [Arguments]     ${session}      ${uid}
    Log     ${uid}
    ${resp}=    Delete Request      ${session}    /api/users/${uid}
    # Status Should Be    200     ${resp}


Get User
    [Arguments]     ${session}     ${uid}
    ${resp}=    Get Request     ${session}     /api/users/${uid}
    &{data}=    evaluate    json.loads("""${resp.text}""")   json
    [Return]    &{data}


Get Users Number
    [Arguments]     ${session}
    ${resp}=    Get Request     ${session}     /api/users/
    @{data}=    evaluate    json.loads("""${resp.text}""")   json
    ${current_users}=   Get Length  ${data}
    [Return]    ${current_users}

Delete Group
    [Arguments]     ${session}      ${group}
    ${resp}=    Delete Request  ${session}  /api/groups/${group}
    # Status Should Be    200     ${resp}


# HTTP Request
#     [Arguments]     &{kwargs}
#     Dictionary Should Contain Key   ${kwargs}   session
#     Dictionary Should Contain Key   ${kwargs}   method
#     Dictionary Should Contain Key   ${kwargs}   url
#     ${response}=    Run Keyword if      '${kwargs["method"]}' == 'GET'     Send Simple Request    ${kwargs["session"]}    ${kwargs["url"]}
#     #&{response}=    Run Keyword if      '${kwargs["method"]}' == 'DELETE'     Send Simple Request    ${kwargs["session"]}    ${kwargs["url"]}
#     Log     ${response.status_code}
#     [Return]    ${response}

# Send Simple Request
#     [Documentation]     Send HTTP Request like: GET, DELETE etc.
#     [Arguments]     ${session}      ${api}
#     ${resp}=    Get Request     ${session}     ${api}
#     [Return]    ${resp}

# Send Complex Request
#     [Documentation]     Send HTTP Request like: POST, PUT etc.
