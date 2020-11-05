*** Settings ***
Documentation     Demo_Project资源文件
Library      ../lib/curl.py

*** Variables ***

${SESSION}  eyJfaWQiOiI2OTQ2YmE3MTg5OTY0MGY3MmYzZjhkZjk4NzllZGIyMyIsInVzZXJuYW1lIjoiQWRtaW4ifQ.X4Gr5g.iPhwYsCFdjOyy3Ibo0wlBgRE0kk

${BASE_URL}    http://127.0.0.1:8082

*** Keywords ***
对比值
    [Documentation]     抽取CURL的返回和预期对比
    [Tags]  操作符
    [Arguments]    ${res}    ${item}    ${exp}    ${exptype}=unicode
    ${r}=    Expect json    ${res}    ${item}    ${exp}    ${exptype}
    Should be true    ${r}
    [return]      ${r}
取得值
    [Documentation]     取得返回json中的特定内容
    [Tags]  操作符
    [Arguments]    ${res}    ${item}    ${type}=str
    ${val}=    Get Result    ${res}    ${item}    ${type}
    [return]     ${val}