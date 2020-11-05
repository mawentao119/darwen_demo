*** Settings ***
Resource	./000_public_user_resources.txt

Test Teardown	Delete All Sessions


*** Variables ***
${method}    create
${success_msg}    成功
${fail_msg}    失败


*** Test Cases ***
Create User Success
    ${result}=    Create User Session   testchen    testchen_new    123456    123@33.com
    Dictionary Should Contain Value		${result}    ${success_msg}

Create User Fail
    ${result}=    Create User Session    testchen    testchen11    123456    123@33.com
    Dictionary Should Contain Value		${result}    ${fail_msg}

