*** Settings ***
Resource  LoginAndOut.resource

*** Variables ***
${username}  Admin
${password}  123456
${header}    -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'

*** Test Cases ***
1用户登录成功
    ${res}=   Curl  '${BASE_URL}/api/v1/auth/'  ${header}  --data-raw 'username=${username}&password=${password}'
    对比值  ${res}  status  success
    对比值  ${res}  url     /dashboard

2错误的用户名失败
    ${res}=   Curl  '${BASE_URL}/api/v1/auth/'  ${header}  --data-raw 'username=${username}1&password=${password}'
    对比值  ${res}  status  fail
    对比值  ${res}  url     /
  
2错误的密码失败
    ${res}=   Curl  '${BASE_URL}/api/v1/auth/'  ${header}  --data-raw 'username=${username}&password=${password}1'
    对比值  ${res}  status  fail
    对比值  ${res}  url     /

*** Keywords ***

