--1. Fazer resumo das venda analisadas
;WITH ResumoVendas AS(

	SELECT [SalesOrderDetail].[ProductID] AS cod_produto
	      ,SUM([SalesOrderDetail].[OrderQty])  AS qtd_pedido
	      ,SUM([SalesOrderDetail].[LineTotal]) AS total_item
	FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
	INNER JOIN [AdventureWorks2022].[Sales].[SalesOrderDetail]
		ON ([SalesOrderHeader].SalesOrderID = [SalesOrderDetail].SalesOrderDetailID)
	WHERE [SalesOrderHeader].[OrderDate] >= '20140101'
	GROUP BY [SalesOrderDetail].[ProductID] 

),
--2. Definir percentual de faturamento por item
PercFaturamento AS (

	SELECT
		cod_produto,
		qtd_pedido,
		total_item,
		SUM(total_item) OVER() AS total_acumulado,
		total_item / SUM(total_item) OVER() * 100 AS percentual
	FROM ResumoVendas

), 
--3. Percentual Acumulado
CurvaABC AS (

	SELECT
		cod_produto,
		qtd_pedido,
		total_item,
		total_acumulado,
		percentual,
		SUM(percentual) OVER(ORDER BY total_item DESC) AS percentual_acumulado
	FROM PercFaturamento

)
--4. Definindo curva
SELECT
	cod_produto,
	qtd_pedido,
	total_item,
	total_acumulado,
	percentual,
	percentual_acumulado,
	CASE WHEN percentual_acumulado <= 80 THEN 'A'
	 	 WHEN percentual_acumulado <= 95 THEN 'B'
		 ELSE 'C'
	END AS curva
FROM CurvaABC
