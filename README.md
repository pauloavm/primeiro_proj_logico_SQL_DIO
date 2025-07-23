# Projeto de Banco de Dados para E-commerce

Este repositório contém o projeto de banco de dados para um cenário de e-commerce, desenvolvido como parte de um desafio de projeto. O objetivo foi criar um esquema lógico, implementá-lo com um script SQL, popular o banco com dados de exemplo e, finalmente, criar consultas complexas para extrair informações de negócio.

## Descrição do Projeto Lógico

O esquema do banco de dados foi projetado para suportar as operações essenciais de uma plataforma de e-commerce, incluindo o cadastro de clientes, catálogo de produtos, processamento de pedidos, múltiplos métodos de pagamento, controle de estoque e relacionamento com fornecedores e vendedores parceiros (marketplace).

### Refinamentos Implementados

O modelo foi refinado para incluir as seguintes regras de negócio:

1.  **Cliente PF e PJ:** A tabela `clients` foi modelada para aceitar tanto pessoas físicas (PF) quanto jurídicas (PJ). Uma `CONSTRAINT` garante que um cliente seja de um tipo ou de outro, mas nunca ambos.
    * Se `ClientType` = 'PF', o campo `CPF` deve ser preenchido.
    * Se `ClientType` = 'PJ', o campo `CNPJ` deve ser preenchido.

2.  **Múltiplos Métodos de Pagamento:** Um cliente pode ter vários métodos de pagamento cadastrados (Boleto, Cartão de Crédito, PIX), permitindo flexibilidade na hora da compra. A tabela `client_payment_method` gerencia essa relação.

3.  **Status e Rastreio da Entrega:** A tabela `orders` inclui campos para `DeliveryStatus` (ex: 'Enviado', 'Em Trânsito', 'Entregue') e `TrackingCode` (código de rastreio), permitindo que o cliente acompanhe o progresso da entrega.

### Diagrama Entidade-Relacionamento (EER)

Abaixo está uma representação visual do esquema do banco de dados.

```mermaid
erDiagram
    clients {
        int idClient PK
        varchar Address
        enum ClientType
        varchar Fname
        char Minit
        varchar Lname
        char CPF UK
        varchar SocialName
        char CNPJ UK
    }

    product {
        int idProduct PK
        varchar Pname
        bool classification_kids
        enum category
        float avaliação
        varchar size
    }

    orders {
        int idOrder PK
        int idOrderClient FK
        enum orderStatus
        varchar orderDescription
        float sendValue
        enum DeliveryStatus
        varchar TrackingCode
    }

    client_payment_method {
        int idPaymentMethod PK
        int idClient FK
        enum typePayment
        varchar CardNumber
        varchar CardHolderName
    }

    supplier {
        int idSupplier PK
        varchar SocialName
        char CNPJ UK
        char contact
    }

    seller {
        int idSeller PK
        varchar SocialName
        varchar AbstName
        char CNPJ UK
        char CPF UK
        varchar location
        char contact
    }

    productStorage {
        int idProdStorage PK
        varchar storageLocation
        int quantity
    }

    -- Relações
    clients ||--o{ orders : places
    clients ||--o{ client_payment_method : has
    orders }o--o{ client_payment_method : "order_payment"
    orders }o--o{ product : "productOrder"
    product }o--o{ seller : "productSeller"
    product }o--o{ supplier : "productSupplier"
    product }o--o{ productStorage : "storageLocation"
