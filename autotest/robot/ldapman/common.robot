*** Settings ***
Library     Collections
Library     RequestsLibrary

*** Variables ***
${API_BACKEND}              http://172.16.66.6:8000
${TOKEN_API}            /api/token

*** Keywords ***
Get Oauth2 Token
    [Arguments]         ${username}     ${password}
    ${headers}=         Create Dictionary   Content-Type=application/x-www-form-urlencoded
    ${form_data}=       Create Dictionary   username=${username}    password=${password}
    Create Session      token_session     ${API_BACKEND}
    ${resp}=            Post Request    token_session   ${TOKEN_API}    data=${form_data}       headers=${headers}
    &{data}=            evaluate    json.loads("""${resp.text}""")  json
    [Return]            Bearer ${data.access_token}


Create Oauth2 Session
    [Arguments]         ${session_name}     ${username}     ${password}
    ${token}=           Get Oauth2 Token    ${username}     ${password}
    ${headers}=         Create Dictionary   Authorization=${token}
    Create Session      ${session_name}     ${API_BACKEND}      headers=${headers}

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
