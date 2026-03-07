# 📄 Documento de Requisitos: Clínica Pele de Seda

**Data:** 06/03/2026  
**Responsável:** Braian Soares Mesquita (Engenharia de Dados)  
**Versão:** 1.1 (Refinada para Modelagem Física)

## 1. Visão Geral do Negócio
A rede "Pele de Seda" opera atualmente com filiais físicas e possui plano de expansão. O sistema deve ser centralizado, permitindo a gestão unificada de clientes, profissionais, agendamentos (atendimentos) e controle de estoque.

## 2. Regras de Negócio (Business Rules)

### 2.1. Unidades e Especialistas
* **Filiais:** Cadastro independente das unidades.
* **Profissionais Volantes:** Especialistas atuam em várias filiais (Relacionamento N:N), controlados por escala.
* **Identificação:** Obrigatório CPF, CRM/COREN e Nome.

### 2.2. Gestão de Clientes
* **Cadastro Ágil:** Apenas Nome e Telefone são obrigatórios inicialmente.
* **Dados Complementares:** CPF e Endereço podem ser inseridos posteriormente.
* **Histórico Único:** O cliente possui um ID único independente da filial onde é atendido.

### 2.3. Catálogos e Vendas
* **Carrinho de Compras:** Um atendimento pode conter múltiplos Serviços e Produtos.
* **Estrutura:** Tabelas independentes para Serviços, Pacotes e Produtos.

### 2.4. Controle de Estoque Híbrido (Critical Path)
O sistema gerencia dois fluxos de baixa:
1.  **Venda Direta:** Baixa de unidade fechada (Produto lacrado).
2.  **Consumo Interno:** Baixa fracionada (ml/g) baseada no uso técnico durante o procedimento.
