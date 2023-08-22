USE [electric_vehicle_population]
GO
/****** Object:  Table [dbo].[electric_vehicle_population]    Script Date: 8/19/2023 1:33:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[electric_vehicle_population](
	[vin] [nvarchar](255) NULL,
	[county] [nvarchar](255) NULL,
	[city] [nvarchar](255) NULL,
	[state] [nvarchar](255) NULL,
	[postal_code] [float] NULL,
	[model_year] [float] NULL,
	[make] [nvarchar](255) NULL,
	[model] [nvarchar](255) NULL,
	[electric_vehicle_type] [nvarchar](255) NULL,
	[clean_alternative_fuel_vehicle_eligibility] [nvarchar](255) NULL,
	[electric_range] [float] NULL,
	[base_MSRP] [float] NULL,
	[legislative_district] [float] NULL,
	[vehicle_DOL_ID] [float] NULL,
	[vehicle_location] [nvarchar](255) NULL,
	[electric_utility] [nvarchar](255) NULL,
	[census_tract_2020] [float] NULL
) ON [PRIMARY]
GO
