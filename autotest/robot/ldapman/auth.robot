*** Settings ***
#Library     Collections
Library     RequestsLibrary

*** Variables ***
${BACKEND}              http://172.16.66.6:8000
${TOKEN_API}            /api/token

*** Keywords ***
Get Oauth2 Token
    [Arguments]         ${username}     ${password}
    ${headers}=         Create Dictionary   Content-Type=application/x-www-form-urlencoded
    ${form_data}=       Create Dictionary   username=${username}    password=${password}
    Create Session      token_session     ${BACKEND}
    ${resp}=            Post Request    token_session   ${TOKEN_API}    data=${form_data}       headers=${headers}
    &{data}=            evaluate    json.loads("""${resp.text}""")  json
    [Return]            Bearer ${data.access_token}


Create Oauth2 Session
    [Arguments]         ${session_name}     ${username}     ${password}
    ${token}=           Get Oauth2 Token    ${username}     ${password}
    ${headers}=         Create Dictionary   Authorization=${token}
    Create Session      ${session_name}     ${BACKEND}  headers=${headers}