--CRIANDO SP
CREATE PROCEDURE uspVendasAgrupamentos(
	@tipoAgrupamento VARCHAR(12),
	@movimentoIni DATE,
	@movimentoFim DATE
)
AS
BEGIN

	--DECLARE @tipoAgrupamento VARCHAR(12) = 'Vendedor' --Produto --Vendedor
	--DECLARE @movimentoIni DATE
	--DECLARE @movimentoFim DATE
	
	--SET @movimentoIni = '20200101'
	--SET @movimentoFim = '20201231'

	IF(@tipoAgrupamento = 'Empresa')
	BEGIN
	
		SELECT 
			emp.Nome AS Empresa,
			SUM(vd.VendaLiquida) AS VendaLiquida
		FROM Vendas vd
		INNER JOIN Empresas emp 
			ON vd.Empresa = emp.Empresa
		WHERE emp.Ativa = 1
		AND vd.Movimento >= @movimentoIni
		AND vd.Movimento <= @movimentoFim
		GROUP BY
			emp.Nome
	
	END ELSE 
	IF(@tipoAgrupamento = 'Produto')
	BEGIN
	
		SELECT 
			prd.Descricao AS Descricao,
			SUM(vd.VendaLiquida) AS VendaLiquida
		FROM Vendas vd
		INNER JOIN Produtos prd 
			ON vd.Produto = prd.Produto
		WHERE vd.Movimento >= @movimentoIni
		AND vd.Movimento <= @movimentoFim
		GROUP BY
			prd.Descricao
	
	END ELSE
	BEGIN
	
		SELECT 
			Vendedores.Nome,
			SUM(Vendas.VendaLiquida) AS VendaLiquida
		FROM Vendas
		LEFT JOIN Vendedores
			ON Vendas.Vendedor = Vendedores.Vendedor
		WHERE Vendas.Movimento >= @movimentoIni
		AND Vendas.Movimento <= @movimentoFim
		GROUP BY
			Vendedores.Nome
	
	END


END

GO


--EXECUTANDO SP
EXEC uspVendasAgrupamentos
	@tipoAgrupamento = 'Vendedor',
	@movimentoIni = '20200101',
	@movimentoFim = '20200301'