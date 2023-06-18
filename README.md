# Contrato inteligente de um financiamento coletivo

Projeto de um sistema de financiamento coletivo utilizando um contrato inteligente desenvolvido na linguagem Solidity.

## Começando

Essas instruções permitirão que você obtenha uma cópia do projeto em operação na sua máquina local para fins de desenvolvimento e teste.

## Requisitos

1. Clone este repositório: [crowdfunding_smart_contract](https://github.com/WilliamZottele/crowdfunding_smart_contract.git)

2. Abra o ambiente [Remix](https://remix.ethereum.org) em seu navegador.

3. No ambiente Remix, clique no botão "Open File" e selecione o arquivo do contrato inteligente (`crowdfundingcontract.sol`) localizado neste repositório.

4. Compile o contrato clicando no botão "Compile" no canto superior esquerdo.

5. Após a compilação bem-sucedida, você pode selecionar a opção de deploy Remix VM (Shanghai) no ambiente Remix (Que é uma opção usada para testes).

6. Para fazer o deploy do contrato basta definir os atributos fundingGoal que recebe a unidade Wei (10000000000000000000 Weis equivale a 10 Ethers) e a deadline em segundos.

7. O atributo de inicialização fundingGoal está em Wei e não em Ether. Portanto na hora de fazer o deploy do contrato pode ser utilizado o site [Ethereum Unit Converter](https://eth-converter.com/) para facilitar na hora de fazer a conversão para Ether.

---

**AVISO**: Este contrato inteligente foi desenvolvido como um trabalho de conclusão de curso e não deve ser usado em um ambiente de produção sem uma revisão completa de segurança e auditoria adequada. Use por sua própria conta e risco.
