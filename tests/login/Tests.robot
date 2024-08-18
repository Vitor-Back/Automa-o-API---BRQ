*** Settings ***

Resource    ../../resources/settings.robot
Resource    ../../resources/variables.robot
Resource    ../../resources/keywords.robot


*** Test Cases ***
TC01 - Login correto
    ${Response_case}    Realizar login   
    Should Be Equal As Numbers    ${Response_case.status_code}    200
    Should Be Equal As Strings     ${Response_case.json()["message"]}    Login realizado com sucesso  

TC02 - Login - e-mail fora do padrão
    ${Response}   Realizar login email fora do padrão
    Should Be Equal As Numbers   ${Response.status_code}    400
    Should Be Equal    ${Response.json()["email"]}    email deve ser um email válido    

TC03 - Login - credenciais inválidas
    ${Response_senha}    Login com credenciais inválidas  
    Should Be Equal As Numbers    ${Response_senha.status_code}    401
    Should Be Equal    ${Response_senha.json()["message"]}    Email e/ou senha inválidos


TC04 - Login - Campos em branco  
    ${Response}    Login com campos em branco 
    Should Be Equal As Numbers   ${Response.status_code}    400        
    Should Be Equal As Strings   ${Response.json()["email"]}     email não pode ficar em branco    
    Should Be Equal As Strings   ${Response.json()["password"]}     password não pode ficar em branco    

    
    