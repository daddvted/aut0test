*** Settings ***
Documentation   Tests for Baidu Pan

Resource        ../resources/web.robot

Test Teardown   Close Browser

*** Variables ***
${BAIDU_PAN_URL}    http://pan.baidu.com

*** Test Cases ***
Login to Baidu Pan
    Open Browser To Page    ${BAIDU_PAN_URL}    百度网盘，让美好永远陪伴
#    Open Browser To Page    ${BAIDU_PAN_URL}    'abc'
