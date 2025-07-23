-- 2. QUERIES SQL PARA ANÁLISE
-- ---------------------------------------------------------------------

-- Pergunta 1: Quantos pedidos foram feitos por cada cliente?
-- (Usa: SELECT, JOIN, COUNT, GROUP BY)
SELECT 
    c.idClient,
    -- Expressão para gerar um atributo derivado (Nome Completo ou Razão Social)
    CASE 
        WHEN c.ClientType = 'PF' THEN CONCAT(c.Fname, ' ', c.Lname)
        ELSE c.SocialName
    END AS ClientName,
    COUNT(o.idOrder) AS NumberOfOrders
FROM 
    clients c
LEFT JOIN 
    orders o ON c.idClient = o.idOrderClient
GROUP BY 
    c.idClient, ClientName
ORDER BY
    NumberOfOrders DESC;

-- Explicação:
-- 1. SELECT: Seleciona o ID do cliente, um nome formatado e a contagem de pedidos.
-- 2. CASE...END: Cria uma coluna derivada "ClientName" que mostra o nome completo para PF e a razão social para PJ.
-- 3. LEFT JOIN: Une 'clients' com 'orders' para conectar clientes a seus pedidos. Usamos LEFT JOIN para incluir clientes que não fizeram pedidos.
-- 4. COUNT(o.idOrder): Conta o número de pedidos para cada cliente.
-- 5. GROUP BY: Agrupa os resultados por cliente para que o COUNT funcione corretamente.
-- 6. ORDER BY: Ordena o resultado para mostrar os clientes com mais pedidos primeiro.


-- Pergunta 2: Algum vendedor também é fornecedor?
-- (Usa: SELECT, JOIN, WHERE)
SELECT 
    s.SocialName AS SellerName,
    sp.SocialName AS SupplierName,
    s.CNPJ
FROM 
    seller s
INNER JOIN 
    supplier sp ON s.CNPJ = sp.CNPJ;

-- Explicação:
-- 1. INNER JOIN: Junta as tabelas 'seller' e 'supplier' usando o CNPJ como chave de ligação.
-- 2. A consulta retornará resultados apenas se houver um CNPJ que exista em ambas as tabelas, identificando a entidade que é tanto vendedor quanto fornecedor.


-- Pergunta 3: Relação de produtos, fornecedores e estoques.
-- (Usa: Múltiplos JOINs para criar uma visão complexa)
SELECT
    p.Pname AS ProductName,
    p.category AS Category,
    s.SocialName AS SupplierName,
    sl.location AS StorageLocationString,
    ps.quantity AS StockQuantity
FROM
    product p
LEFT JOIN productSupplier psup ON p.idProduct = psup.idPsProduct
LEFT JOIN supplier s ON psup.idPsSupplier = s.idSupplier
LEFT JOIN storageLocation sl ON p.idProduct = sl.idLproduct
LEFT JOIN productStorage ps ON sl.idLstorage = ps.idProdStorage
ORDER BY
    p.Pname;

-- Explicação:
-- 1. Múltiplos LEFT JOINs: A consulta conecta 5 tabelas para criar uma visão completa.
--    - 'product' -> 'productSupplier' (qual fornecedor fornece o produto)
--    - 'productSupplier' -> 'supplier' (nome do fornecedor)
--    - 'product' -> 'storageLocation' (onde o produto está no armazém)
--    - 'storageLocation' -> 'productStorage' (quantidade total naquele local de estoque)
-- 2. Isso permite ver, para cada produto, quem o fornece e onde ele está estocado.


-- Pergunta 4: Relação de nomes dos fornecedores e nomes dos produtos.
-- (Usa: SELECT, JOIN)
SELECT
    s.SocialName AS SupplierName,
    p.Pname AS ProductName,
    ps.quantity AS QuantitySupplied
FROM
    productSupplier ps
JOIN
    supplier s ON ps.idPsSupplier = s.idSupplier
JOIN
    product p ON ps.idPsProduct = p.idProduct
ORDER BY
    SupplierName, ProductName;

-- Explicação:
-- Uma consulta mais direta que foca em responder exatamente o que foi pedido, unindo as tabelas de ligação ('productSupplier') com as tabelas principais ('supplier', 'product').


-- Pergunta 5: Quais clientes PF fizeram mais de 1 pedido e tiveram status 'Confirmado'?
-- (Usa: WHERE, GROUP BY, HAVING)
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS ClientName,
    COUNT(o.idOrder) AS ConfirmedOrders
FROM 
    clients c
JOIN 
    orders o ON c.idClient = o.idOrderClient
WHERE 
    c.ClientType = 'PF' AND o.orderStatus = 'Confirmado'
GROUP BY 
    c.idClient, ClientName
HAVING 
    COUNT(o.idOrder) > 1;

-- Explicação:
-- 1. WHERE: Filtra os dados ANTES do agrupamento para considerar apenas clientes 'PF' e pedidos com status 'Confirmado'.
-- 2. GROUP BY: Agrupa os resultados por cliente.
-- 3. HAVING: Filtra os grupos DEPOIS do agrupamento, mostrando apenas os clientes que têm uma contagem de pedidos confirmados maior que 1.