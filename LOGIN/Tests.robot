*** Settings ***

Library    requests
Library    String

*** Variables ***
${ROST}    https://serverest.dev

#Rota
${LOGIN}    login

*** Keywords ***
Realizar login 
    [Arguments]    ${email}    ${password}
    &{body}    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST    url=${ROST}/${LOGIN}    json=&{body}
    RETURN    ${response}

*** Test Cases ***
TC01 - Login correto
    ${Response_case}    Realizar login   email=fulano@qa.com    password=teste
    Should Be Equal As Strings    ${Response_case.status_code}    200

TC02 - Login - e-mail fora do padrão
    ${Response}   Realizar login      email=mail.com    password=teste
    Should Be Equal As Numbers   ${Response.status_code}    400
    Should Be Equal    ${Response.json()["email"]}    email deve ser um email válido    

TC03 - Login - credenciais inválidas
    ${Response_senha}    Realizar login    email=fulano@qa.com    password=testp
    Should Be Equal As Numbers    ${Response_senha.status_code}    401
    Should Be Equal    ${Response_senha.json()["message"]}    Email e/ou senha inválidos
    ${Response_login}    Realizar login    email=vitor@teste.com    password=teste
    Should Be Equal As Numbers    ${Response_login.status_code}    401
    Should Be Equal    ${Response_senha.json()["message"]}    Email e/ou senha inválidos

TC04 - Login - Campos não preenchidos 
    ${Response}    Realizar login    email=  password=
    Should Be Equal As Numbers   ${Response.status_code}    400        
    Should Be Equal As Strings   ${Response.json()["email"]}     email não pode ficar em branco    
    Should Be Equal As Strings   ${Response.json()["password"]}     password não pode ficar em branco    
    
    