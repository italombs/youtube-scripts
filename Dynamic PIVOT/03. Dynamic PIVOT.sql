--1. Criar query como as informações que vamos precisar
--2. Identificar coluna onde estão os valores que será apicado o PIVOT
--3. Remover linhas duplicadas da coluna que será feito o PIVOT
--4. Transformar linhas em texto concatenado
--5. Montar/Executar PIVOT

-------------------------------------------------------------------------------

--1. Criar query como as informações que vamos precisar

DECLARE @dataCorte DATE = '20181231'

DROP TABLE IF EXISTS #ContasReceberPVT

SELECT
	CR.CodEmpresa,
	YEAR(CR.Vencimento) AS AnoVencimento,
	CR.Valor,
	FP.FormaPagamento
INTO #ContasReceberPVT
FROM ContasReceber CR
INNER JOIN FormasPagamentos FP
	ON (CR.CodFormaPagamento = FP.CodFormaPagamento)
WHERE CR.Vencimento >= @dataCorte

--2. Identificar coluna onde estão os valores que será apicado o PIVOT

-->> AnoVencimento <<--

--3. Remover linhas duplicadas da coluna que será feito o PIVOT

/*
SELECT
	DISTINCT
	AnoVencimento
FROM #ContasReceberPVT
*/

--4. Transformar linhas em texto concatenado

DECLARE @pvt NVARCHAR(MAX) = ''

SELECT @pvt += CONCAT(',[',X.AnoVencimento,']')
FROM(

	--3. Remover linhas duplicadas da coluna que será feito o PIVOT
	SELECT
		DISTINCT
		AnoVencimento
	FROM #ContasReceberPVT

) X ORDER BY AnoVencimento

SET @pvt = STUFF(@pvt,1,1,'')

--5. Montar/Executar PIVOT
DECLARE @sqlCommand NVARCHAR(MAX)

SET @sqlCommand = 
N'SELECT * FROM #ContasReceberPVT PVT
  PIVOT (SUM(Valor) FOR AnoVencimento IN(' + @pvt + ')) AS PVT_AnoVencimento'

EXECUTE(@sqlCommand)