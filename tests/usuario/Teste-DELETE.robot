*** Settings ***

Resource    ../../resources/settings.robot
Resource    ../../resources/variables.robot
Resource    ../../resources/keywords.robot


*** Test Cases ***
TC01 - Deletar usuário cadastrado 
    ${Response}    Deletar usuário cadastrado 
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Equal As Strings    ${Response.json()["message"]}  Registro excluído com sucesso

TC02 - Deletar usuário inexistente 
    ${Response}    Deletar usuário inexistente
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Equal As Strings    ${Response.json()["message"]}  Nenhum registro excluído


