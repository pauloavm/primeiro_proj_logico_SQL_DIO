
---

### Persistência de Dados (INSERTs)

Antes de criar as queries, precisamos de dados. Abaixo estão os comandos `INSERT` para popular seu banco. Você pode salvar isso em um novo arquivo, como `queries.sql`, ou executar diretamente no seu cliente SQL após rodar o script de criação das tabelas.

**Observação:** Os comandos estão na ordem correta para respeitar as chaves estrangeiras.

```sql
-- =====================================================================
-- SCRIPT DE INSERÇÃO DE DADOS E QUERIES - E-COMMERCE
-- =====================================================================

-- Seleciona o banco de dados para uso
USE ecommerce;

-- 1. INSERÇÃO DE DADOS (PERSISTÊNCIA)
-- ---------------------------------------------------------------------

-- Inserindo Clientes (PF e PJ)
INSERT INTO clients (Fname, Minit, Lname, CPF, Address, ClientType) VALUES
('Maria', 'M', 'Silva', '12345678901', 'Rua das Flores 123, Cidade A', 'PF'),
('João', 'A', 'Santos', '98765432109', 'Avenida Principal 456, Cidade B', 'PF');

INSERT INTO clients (SocialName, CNPJ, Address, ClientType) VALUES
('Tech Eletrônicos LTDA', '12345678000199', 'Rua da Tecnologia 789, Cidade C', 'PJ'),
('Brinquedos Divertidos SA', '87654321000155', 'Avenida da Criança 101, Cidade D', 'PJ');

-- Inserindo Produtos
INSERT INTO product (Pname, classification_kids, category, avaliação, size) VALUES
('Fone de Ouvido Bluetooth', false, 'Eletrônico', 4.5, null),
('Carrinho de Controle Remoto', true, 'Brinquedos', 4.8, '25x15cm'),
('Camiseta Básica', false, 'Vestimenta', 4.2, 'M'),
('Notebook Pro', false, 'Eletrônico', 4.9, null),
('Cadeira de Escritório', false, 'Móveis', 4.6, '60x60x120cm');

-- Inserindo Fornecedores
INSERT INTO supplier (SocialName, CNPJ, contact) VALUES
('Eletrônicos do Vale', '11223344000155', '11987654321'),
('Fornecedora de Brinquedos Alegria', '55667788000144', '21987654321');

-- Inserindo Vendedores Terceirizados (Sellers)
INSERT INTO seller (SocialName, AbstName, CNPJ, location, contact) VALUES
('Loja do Zé', 'Zé Vendas', '99887766000133', 'Online', '31987654321'),
('Importados da Maria', null, '11223344000155', 'São Paulo', '11912345678'); -- CNPJ igual ao fornecedor

-- Inserindo em Estoque
INSERT INTO productStorage (storageLocation, quantity) VALUES
('Depósito 1, Rio de Janeiro', 1000),
('Depósito 2, São Paulo', 500);

-- Relacionando Produto/Fornecedor
INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity) VALUES
(1, 1, 500), -- Fornecedor 'Eletrônicos do Vale' fornece 'Fone de Ouvido'
(1, 4, 100), -- Fornecedor 'Eletrônicos do Vale' fornece 'Notebook Pro'
(2, 2, 800); -- Fornecedor 'Alegria' fornece 'Carrinho de Controle Remoto'

-- Relacionando Produto/Vendedor
INSERT INTO productSeller (idPseller, idPproduct, prodQuantity) VALUES
(1, 3, 50),  -- Vendedor 'Loja do Zé' vende 'Camiseta Básica'
(2, 1, 20);  -- Vendedor 'Importados da Maria' vende 'Fone de Ouvido'

-- Relacionando Produto/Estoque
INSERT INTO storageLocation (idLproduct, idLstorage, location) VALUES
(1, 1, 'Prateleira A1'), -- Fone de Ouvido no Depósito 1
(2, 2, 'Prateleira B5'), -- Carrinho no Depósito 2
(4, 2, 'Prateleira C3'); -- Notebook no Depósito 2

-- Inserindo Pedidos
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue) VALUES
(1, 'Confirmado', 'Compra de eletrônicos', 15.50),
(2, 'Em processamento', 'Compra de camiseta', 10.00),
(1, 'Confirmado', 'Segundo pedido da Maria', 20.00),
(3, 'Cancelado', 'Pedido corporativo', 50.00);

-- Relacionando Produto/Pedido
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus) VALUES
(1, 1, 1, 'Disponível'), -- Fone de ouvido no primeiro pedido
(4, 1, 1, 'Disponível'), -- Notebook no primeiro pedido
(3, 2, 2, 'Disponível'), -- 2 Camisetas no segundo pedido
(2, 3, 1, 'Disponível'); -- Carrinho no terceiro pedido