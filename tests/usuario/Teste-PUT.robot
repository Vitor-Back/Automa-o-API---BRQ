*** Settings ***

Resource    ../../resources/settings.robot
Resource    ../../resources/variables.robot
Resource    ../../resources/keywords.robot



*** Test Cases ***
TC01 - Editar usuário cadastrado
    ${Response}    Editar cadastro existente 
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Equal As Strings    ${Response.json()["message"]}    Registro alterado com sucesso
    

    ${Response}    Editar cadastro inexistente
    Should Be Equal As Numbers    ${Response.status_code}    201
    Should Be Equal As Strings    ${Response.json()["message"]}    Cadastro realizado com sucesso

    ${Response}    Editar usuário para e-mail ja cadastrado 
    Should Be Equal As Numbers    ${Response.status_code}    400
    Should Be Equal As Strings    ${Response.json()["message"]}     Este email já está sendo usado  
    