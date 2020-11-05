*** Settings ***
Resource  UserManagement.resource

*** Variables ***
${username}   name12
${fullname}   name12

${header}     -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Cookie: session=${SESSION}'

*** Test Cases ***
01新建用户成功
    ${res}  curl  '${BASE_URL}/api/v1/user/'  ${header}  --data-raw 'fullname=${fullname}&username=${username}&email=222&password=222&method=create'
    对比值  ${res}  status  success
    [Teardown]  删除用户  ${username}
    
02新建重名用户失败
    Log  新建第一个用户
    ${res}  curl  '${BASE_URL}/api/v1/user/'  ${header}  --data-raw 'fullname=${fullname}&username=${username}&email=222&password=222&method=create'
    对比值  ${res}  status  success
    Log  新建第重名用户
    ${res}  curl  '${BASE_URL}/api/v1/user/'  ${header}  --data-raw 'fullname=${fullname}&username=${username}&email=222&password=222&method=create'
    对比值  ${res}  status  fail
    [Teardown]  删除用户  ${username}
    
03删除用户
    Log  新建一个用户
    ${res}  curl  '${BASE_URL}/api/v1/user/'  ${header}  --data-raw 'fullname=${fullname}&username=${username}&email=222&password=222&method=create'
    对比值  ${res}  status  success
    Log  删除用户
    ${res}  curl  '${BASE_URL}/api/v1/user/'  ${header}  --data-raw 'method=delete&username=${username}'
    对比值  ${res}  status  success
*** Keywords ***
删除用户
    [Arguments]  ${username}
    ${res}  curl  '${BASE_URL}/api/v1/user/'  ${header}  --data-raw 'method=delete&username=${username}'
    对比值  ${res}  status  success
