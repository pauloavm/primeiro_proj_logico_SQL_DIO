-- =====================================================================
-- SCRIPT COMPLETO PARA CRIAÇÃO DO BANCO DE DADOS E-COMMERCE
-- =====================================================================

-- 1. CRIAÇÃO E SELEÇÃO DO BANCO DE DADOS
-- ---------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;


-- 2. CRIAÇÃO DAS TABELAS PRINCIPAIS
-- ---------------------------------------------------------------------

-- Tabela de Clientes (com suporte para PF e PJ)
CREATE TABLE clients(
	idClient INT AUTO_INCREMENT PRIMARY KEY,
	Address VARCHAR(255),
	ClientType ENUM('PF', 'PJ') NOT NULL,
	Fname VARCHAR(10),
	Minit CHAR(3),
	Lname VARCHAR(20),
	CPF CHAR(11),
	SocialName VARCHAR(255),
	CNPJ CHAR(14),
	CONSTRAINT unique_cpf_client UNIQUE (CPF),
	CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
	CONSTRAINT chk_client_type CHECK (
		(ClientType = 'PF' AND CPF IS NOT NULL AND CNPJ IS NULL) OR
		(ClientType = 'PJ' AND CNPJ IS NOT NULL AND CPF IS NULL)
	)
);
ALTER TABLE clients AUTO_INCREMENT=1;

-- Tabela de Produtos
CREATE TABLE product(
	idProduct INT AUTO_INCREMENT PRIMARY KEY,
	Pname VARCHAR(255) NOT NULL,
	classification_kids BOOL DEFAULT FALSE,
	category ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') NOT NULL,
	avaliação FLOAT DEFAULT 0,
	size VARCHAR(10)
);
ALTER TABLE product AUTO_INCREMENT=1;

-- Tabela de Métodos de Pagamento do Cliente
CREATE TABLE client_payment_method(
	idPaymentMethod INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    typePayment ENUM('Boleto', 'Cartão de Crédito', 'PIX') NOT NULL,
    CardNumber VARCHAR(16),
    CardHolderName VARCHAR(255),
    CONSTRAINT fk_payment_method_client FOREIGN KEY (idClient) REFERENCES clients(idClient)
		ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabela de Pedidos (com campos de entrega)
CREATE TABLE orders(
	idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    DeliveryStatus ENUM('Aguardando Envio', 'Enviado', 'Em Trânsito', 'Entregue', 'Falha na Entrega') DEFAULT 'Aguardando Envio',
    TrackingCode VARCHAR(50),
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
			ON UPDATE CASCADE
);
ALTER TABLE orders AUTO_INCREMENT=1;

-- Tabela de Estoque
CREATE TABLE productStorage(
	idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);
ALTER TABLE productStorage AUTO_INCREMENT=1;

-- Tabela de Fornecedores
CREATE TABLE supplier(
	idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);
ALTER TABLE supplier AUTO_INCREMENT=1;

-- Tabela de Vendedores (Terceiros)
CREATE TABLE seller(
	idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(14),
    CPF CHAR(11),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);
ALTER TABLE seller AUTO_INCREMENT=1;


-- 3. CRIAÇÃO DAS TABELAS DE RELACIONAMENTO (MUITOS-PARA-MUITOS)
-- ---------------------------------------------------------------------

-- Tabela de Ligação: Pedido e Pagamento
CREATE TABLE order_payment(
	idOrder INT,
    idPaymentMethod INT,
    paymentValue FLOAT NOT NULL,
    PRIMARY KEY (idOrder, idPaymentMethod),
    CONSTRAINT fk_order_payment_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder),
    CONSTRAINT fk_order_payment_method FOREIGN KEY (idPaymentMethod) REFERENCES client_payment_method(idPaymentMethod)
);

-- Tabela de Ligação: Produto e Vendedor
CREATE TABLE productSeller(
	idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

-- Tabela de Ligação: Produto e Pedido
CREATE TABLE productOrder(
	idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

-- Tabela de Ligação: Produto e Estoque
CREATE TABLE storageLocation(
	idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);

-- Tabela de Ligação: Produto e Fornecedor
CREATE TABLE productSupplier(
	idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_prodcut FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

SELECT 'Banco de dados e-commerce criado com sucesso!' as Resultado;