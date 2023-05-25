# Real-time quarterly fiscal dataset

[![Licence](https://img.shields.io/badge/Licence-EUPL--1.2-001489)](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12)
[![GFS](https://img.shields.io/github/actions/workflow/status/ThomasFaria/real-time-fiscal-dataset/pipeline-GFS.yaml?label=GFS
)](https://github.com/ThomasFaria/real-time-fiscal-dataset)
[![MNA](https://img.shields.io/github/actions/workflow/status/ThomasFaria/real-time-fiscal-dataset/pipeline-MNA.yaml?label=MNA&style=flat)](https://github.com/ThomasFaria/real-time-fiscal-dataset)

## Database (updated March 2023)

The dataset is automatically updated every quarter. Data are fetch from Government Finance Statistics (GFS) database and from Main National Accounts (MNA) database using dbnomics.
One can download the data in 2 different formats:

- parquet format: https://minio.lab.sspcloud.fr/tfaria/public/real-time-fiscal-database.parquet
- CSV format: https://minio.lab.sspcloud.fr/tfaria/public/real-time-fiscal-database.csv

The following table presents a comprehensive list of variables that exist in the dataset:

| Name      | Retrieval code |
| ----------- | ----------- |
|Government expenditure related to compensation of employees| GFS.Q.N.*.W0.S13.S1.N.D.D1._Z._Z._T.XDC._Z.S.V.N._T|
|Current taxes on income, wealth, etc.| GFS.Q.N.*.W0.S13.S1.N.C.D5._Z._Z._Z.XDC._Z.S.V.N._T|
|Government gross fixed capital formation | GFS.Q.N.*.W0.S13.S1.N.D.P51G._Z._Z._T.XDC._Z.S.V.N._T|
|Intermediate consumption | GFS.Q.N.*.W0.S13.S1.C.D.D41._Z._Z._T.XDC._Z.S.V.N._T|
|Government interest expenditure | GFS.Q.N.*.W0.S13.S1.C.D.D41._Z._Z._T.XDC._Z.S.V.N._T|
|Total capital expenditure| GFS.Q.N.*.W0.S13.S1.P.D.OKE._Z._Z._T.XDC._Z.S.V.N._T|
|Capital transfers | GFS.Q.N.*.W0.S13.S1.P.C.D9._Z._Z._Z.XDC._Z.S.V.N._T|
|Net social contributions  |GFS.Q.N.*.W0.S13.S1.N.C.D61._Z._Z._Z.XDC._Z.S.V.N._T|
|Net lending (pos) / net borrowing (neg) - Balance |GFS.Q.N.*.W0.S13.S1._Z.B.B9._Z._Z._Z.XDC._Z.S.V.N._T|
|Social benefits other than social transfers in kind | GFS.Q.N.*.W0.S13.S1.N.D.D62._Z._Z._T.XDC._Z.S.V.N._T|
|Government social transfers in kind (purchased market production) | GFS.Q.N.*.W0.S13.S1.N.D.D632._Z._Z._T.XDC._Z.S.V.N._T|
|Taxes on production and imports |GFS.Q.N.*.W0.S13.S1.N.C.D2._Z._Z._Z.XDC._Z.S.V.N._T|
|Government total expenditure| GFS.Q.N.*.W0.S13.S1.P.D OTE._Z._Z._T.XDC._Z.S.V.N._T|
|Government total revenue** |GFS.Q.N.*.W0.S13.S1.P.C.OTR._Z._Z._Z.XDC._Z.S.V.N._T|
|Gross domestic product at market prices| namq_10_gdp.Q.CP_MEUR.NSA.B1GQ.*|
|Household and NPISH final consumption expenditure | namq_10_gdp.Q.CP_MEUR.NSA.P31_S14_S15.*|
|Gross capital formation | namq_10_gdp.Q.CP_MEUR.NSA.P5G.*|
|Exports of goods and services | namq_10_gdp.Q.CP_MEUR.NSA.P6.*|
|Final consumption expenditure of general government| namq_10_gdp.Q.CP_MEUR.NSA.P3_S13.*|
|Compensation of employees| namq_10_gdp.Q.CP_MEUR.NSA.D1.*|

The asterisk refers to the ISO-2 country code position (i.e. "DE", "FR", "IT"...).

## Licence

This work is licenced under the [European Union Public Licence 1.2](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12).
