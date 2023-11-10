SET NOCOUNT ON
GO

DROP TABLE IF EXISTS [dbo].[ContasReceber]
GO
DROP TABLE IF EXISTS [dbo].[Clientes]
GO
DROP TABLE IF EXISTS [dbo].[Empresas]
GO
DROP TABLE IF EXISTS [dbo].[FormasPagamentos]
GO

CREATE TABLE [dbo].[Clientes](
	[CodCliente] [int] NOT NULL,
	[Cliente] [varchar](80) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[CodCliente] ASC
	)
)
GO

CREATE TABLE [dbo].[ContasReceber](
	[ContaReceber] [int] IDENTITY(1001,1) NOT NULL,
	[CodEmpresa] [int] NULL,
	[Documento] [varchar](50) NULL,
	[CodCliente] [int] NULL,
	[Movimento] [date] NULL,
	[Vencimento] [date] NULL,
	[Valor] [money] NULL,
	[CodFormaPagamento] [int] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[ContaReceber] ASC
	)
)
GO

CREATE TABLE [dbo].[Empresas](
	[CodEmpresa] [int] IDENTITY(1,1) NOT NULL,
	[Empresa] [varchar](50) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[CodEmpresa] ASC
	)
)
GO

CREATE TABLE [dbo].[FormasPagamentos](
	[CodFormaPagamento] [int] NOT NULL,
	[FormaPagamento] [varchar](80) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[CodFormaPagamento] ASC
	)
)
GO

SET NOCOUNT OFF