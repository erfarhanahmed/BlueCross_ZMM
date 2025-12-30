* report zbcllmm_purchase_register no standard page heading line-size 1000.
 REPORT ZPREG_ALL_GSTHSN_NEW NO STANDARD PAGE HEADING LINE-SIZE 1000.
*Report developed by Jyotsna
 TABLES : BSEG,
          BSE_CLR,
          BKPF,
          LFA1,
          T007S,
          BSET,
          J_1IMOVEND,
          EKKO,
          T161T,
          ADR6,
          RSEG,
          EKKN,
          T001W,
          J_1IEXCDTL,
          MARA,
          VBRK,
          J_1IMOCUST,
          EKPO,
          VBRP,
          KNA1,
          ADRC,
          T005S,
          T005U,
          KNVI,
          T003T,
          T134G,
          SKAT,
          BSEC,
          MKPF,
          MSEG,
          EKBE,
          MARC,
          ZPREGHSN,
          ZPREG_ISD,
          ZPREG_DOC_CAT,
          VBFA,
          BSAD,
          BSID,
          BSIS,
          ZPREG_REMISD,
          BSAS.


 TYPE-POOLS:  SLIS.

 DATA: G_REPID     LIKE SY-REPID,
       FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV,
       WA_FIELDCAT LIKE LINE OF FIELDCAT,
       SORT        TYPE SLIS_T_SORTINFO_ALV,
       WA_SORT     LIKE LINE OF SORT,
       LAYOUT      TYPE SLIS_LAYOUT_ALV,
       LI_SORT     TYPE SLIS_T_SORTINFO_ALV.

 TYPES : BEGIN OF TYP_KONV,
           KNUMV TYPE KONV-KNUMV,
           KPOSN TYPE KONV-KPOSN,
           KSCHL TYPE KONV-KSCHL,
           KWERT TYPE KONV-KWERT,
           KBETR TYPE KONV-KBETR,
           KAWRT TYPE KONV-KAWRT,
         END OF TYP_KONV.

 TYPES: BEGIN OF TYP_T001W,
          WERKS TYPE T001W-WERKS,
          KUNNR TYPE T001W-KUNNR,
        END OF TYP_T001W.

 DATA : IT_BKPF     TYPE TABLE OF BKPF,
        WA_BKPF     TYPE BKPF,
        IT_BKPF11   TYPE TABLE OF BKPF,
        WA_BKPF11   TYPE BKPF,
        IT_BKPF1    TYPE TABLE OF BKPF,
        WA_BKPF1    TYPE BKPF,
        IT_BSEG     TYPE TABLE OF BSEG,
        WA_BSEG     TYPE BSEG,
        IT_BSEG1    TYPE TABLE OF BSEG,
        WA_BSEG1    TYPE BSEG,
        IT_BSEGI1   TYPE TABLE OF BSEG,
        WA_BSEGI1   TYPE BSEG,
        IT_BSEG11   TYPE TABLE OF BSEG,
        WA_BSEG11   TYPE BSEG,
        IT_BSEG121  TYPE TABLE OF BSEG,
        WA_BSEG121  TYPE BSEG,
        IT_BSEG12   TYPE TABLE OF BSEG,
        WA_BSEG12   TYPE BSEG,
        IT_BSEG13   TYPE TABLE OF BSEG,
        WA_BSEG13   TYPE BSEG,
        IT_BSEG2    TYPE TABLE OF BSEG,
        WA_BSEG2    TYPE BSEG,
        IT_BSEG3    TYPE TABLE OF BSEG,
        WA_BSEG3    TYPE BSEG,
*       it_bseg11 type table of bseg,
*       wa_bseg11 type bseg,
        IT_VBRK     TYPE TABLE OF VBRK,
        WA_VBRK     TYPE VBRK,
        IT_VBRP     TYPE TABLE OF VBRP,
        WA_VBRP     TYPE VBRP,
        IT_KONV     TYPE TABLE OF TYP_KONV,
        WA_KONV     TYPE TYP_KONV,
        IT_VBRK1    TYPE TABLE OF VBRK,
        WA_VBRK1    TYPE VBRK,
        IT_VBRP1    TYPE TABLE OF VBRP,
        WA_VBRP1    TYPE VBRP,
        IT_BSET     TYPE TABLE OF BSET,
        WA_BSET     TYPE BSET,
        IT_BSET5ING TYPE TABLE OF BSET,
        WA_BSET5ING TYPE BSET,
        IT_BSET8    TYPE TABLE OF BSET,
        WA_BSET8    TYPE BSET,
        IT_BSET1    TYPE TABLE OF BSET,
        WA_BSET1    TYPE BSET,
        IT_T001W    TYPE TABLE OF TYP_T001W,
        WA_T001W    TYPE TYP_T001W,
        IT_RSEG     TYPE TABLE OF RSEG,
        WA_RSEG     TYPE RSEG,
        IT_T005U    TYPE TABLE OF T005U,
        WA_T005U    TYPE T005U,
        IT_BSE_CLR  TYPE TABLE OF BSE_CLR,
        WA_BSE_CLR  TYPE BSE_CLR.
 DATA : A  TYPE I.
 DATA : AWKEY TYPE BKPF-AWKEY.
 TYPES : BEGIN OF ITAP11,
           BELNR     TYPE BSEG-BELNR,
           GJAHR     TYPE BSEG-GJAHR,
           TXGRP     TYPE BSEG-TXGRP,
*           STEUC      TYPE MARC-STEUC,
*           MENGE      TYPE BSEG-MENGE,
*           MEINS      TYPE BSEG-MEINS,
           MWSKZ     TYPE BSEG-MWSKZ,
           HWSTE     TYPE BSET-HWSTE,
           HWBAS     TYPE BSET-HWBAS,
*           RATE(10)   TYPE C,
*           VENDOR     TYPE T001W-KUNNR,
*           VENDOREG   TYPE T001W-REGIO,

           DMBTR     TYPE BSET-HWBAS,
           STATUS(4) TYPE C,
           SGST      TYPE BSET-HWSTE,
           UGST      TYPE BSET-HWSTE,
           CGST      TYPE BSET-HWSTE,
           IGST      TYPE BSET-HWSTE,
           CESS      TYPE BSET-HWSTE,
           SIG(1)    TYPE C,
           BUZEI     TYPE BSET-BUZEI,
           HKONT     TYPE BSEG-HKONT,
         END OF ITAP11.

 TYPES : BEGIN OF ITAP1,
           BELNR      TYPE BSEG-BELNR,
           GJAHR      TYPE BSEG-GJAHR,
           TXGRP      TYPE BSEG-TXGRP,
           STEUC      TYPE MARC-STEUC,
*           menge      TYPE bseg-menge,
           MENGE(15)  TYPE C,
           MEINS      TYPE BSEG-MEINS,
           MWSKZ      TYPE BSEG-MWSKZ,
*   dmbtr type bseg-dmbtr,
           BUDAT      TYPE BKPF-BUDAT,
*   skfbt type p decimals 2,
           XMWST      TYPE BKPF-XMWST,
*   lifnr type bseg-lifnr,
           BLDAT      TYPE BKPF-BLDAT,
           XBLNR      TYPE BKPF-XBLNR,
           XREVERSAL  TYPE BKPF-XREVERSAL,
           KUNAG      TYPE VBRK-KUNAG,
           VBELN      TYPE VBRK-VBELN,
           TCODE      TYPE BKPF-TCODE,

           BLART      TYPE BKPF-BLART,
           HWSTE      TYPE BSET-HWSTE,
           HWBAS      TYPE BSET-HWBAS,
           RATE(10)   TYPE C,
           VENDOR     TYPE T001W-KUNNR,
           VENDOREG   TYPE T001W-REGIO,

           DMBTR      TYPE BSEG-DMBTR,
           LIFNR      TYPE BSEG-LIFNR,
           BUPLA      TYPE BSEG-BUPLA,
           GSBER      TYPE BSEG-GSBER,
           VENREG     TYPE T001W-REGIO,
           NAME1      TYPE LFA1-NAME1,
           ORT01      TYPE LFA1-ORT01,
           TDS        TYPE BSEG-DMBTR,
           STCD3      TYPE LFA1-STCD3,
           VEN_CLASS  TYPE J_1IMOVEND-VEN_CLASS,
           VEN_CL(30) TYPE C,
           PAN        TYPE J_1IMOVEND-J_1IPANNO,
           STATUS(4)  TYPE C,
           USNAM      TYPE BKPF-USNAM,
*   KTOSL(3) TYPE C,

           ADR1       TYPE ADRC-NAME1,
           ADR2       TYPE ADRC-NAME2,
           ADR3       TYPE ADRC-NAME3,
           ADR4       TYPE ADRC-NAME4,
           ADR5       TYPE ADRC-STR_SUPPL1,
           ADR6       TYPE ADRC-STR_SUPPL2,
           SGTXT      TYPE BSEG-SGTXT,
           BELNR_CLR  TYPE BSE_CLR-BELNR_CLR,
           GJAHR_CLR  TYPE BSE_CLR-GJAHR_CLR,
           AUGDT      TYPE BSEG-AUGDT,
           PERIOD     TYPE I,

           SGST       TYPE BSET-HWSTE,
           UGST       TYPE BSET-HWSTE,
           CGST       TYPE BSET-HWSTE,
           IGST       TYPE BSET-HWSTE,
           CESS       TYPE BSET-HWSTE,
           CGSTC(10)  TYPE C,
           IGSTC(10)  TYPE C,
           OTHR       TYPE BSET-HWSTE,
           SCODE(40)  TYPE C,
           IS         TYPE T005U-BEZEI,
           MBLNR      TYPE MKPF-MBLNR,
           AWKEY      TYPE BKPF-AWKEY,
           HKONT      TYPE BSEG-HKONT,
           MKPF_BUDAT TYPE SY-DATUM,
           RECP       TYPE BKPF-BELNR,
           RECP_DT    TYPE BKPF-BUDAT,
           RECPYR     TYPE BKPF-GJAHR,
           KOSTL      TYPE BSEG-KOSTL,
           WERKS      TYPE MSEG-WERKS,
           ZHWSTE(10) TYPE C,
           COUNT(3)   TYPE C,
           SIG(1)     TYPE C,
           KTOSL      TYPE BSET-KTOSL,
           RSTAT(8)   TYPE C,
           BUZEI      TYPE BSET-BUZEI,
****            " SOC By CK
           EBELN      TYPE EKPO-EBELN,
           BSART      TYPE EKKO-BSART,
           TYPE       TYPE CHAR20,
*****            " EOC By CK

         END OF ITAP1.
 DATA : RRP2 TYPE I,
        RRP3 TYPE I,
        RRP4 TYPE I.
 TYPES : BEGIN OF ITAP2,
           BELNR      TYPE BSEG-BELNR,
           GJAHR      TYPE BSEG-GJAHR,
           TXGRP      TYPE BSEG-TXGRP,
           STEUC      TYPE MARC-STEUC,
           MENGE      TYPE BSEG-MENGE,
           MEINS      TYPE BSEG-MEINS,
           MWSKZ      TYPE BSEG-MWSKZ,
*   dmbtr type bseg-dmbtr,
           BUDAT      TYPE BKPF-BUDAT,
*   skfbt type p decimals 2,
           XMWST      TYPE BKPF-XMWST,
*   lifnr type bseg-lifnr,
           BLDAT      TYPE BKPF-BLDAT,
           XBLNR      TYPE BKPF-XBLNR,
           XREVERSAL  TYPE BKPF-XREVERSAL,
           KUNAG      TYPE VBRK-KUNAG,
           VBELN      TYPE VBRK-VBELN,
           TCODE      TYPE BKPF-TCODE,
           BLART      TYPE BKPF-BLART,
           HWSTE      TYPE BSET-HWSTE,
           HWBAS      TYPE BSET-HWBAS,
           RATE(10)   TYPE C,
           VENDOR     TYPE T001W-KUNNR,
           VENDOREG   TYPE T001W-REGIO,

           DMBTR      TYPE BSEG-DMBTR,
           LIFNR      TYPE BSEG-LIFNR,
           BUPLA      TYPE BSEG-BUPLA,
           GSBER      TYPE BSEG-GSBER,
           VENREG     TYPE T001W-REGIO,
           NAME1      TYPE LFA1-NAME1,
           ORT01      TYPE LFA1-ORT01,
           TDS        TYPE BSEG-DMBTR,
           STCD3      TYPE LFA1-STCD3,
           VEN_CLASS  TYPE J_1IMOVEND-VEN_CLASS,
           VEN_CL(30) TYPE C,
           PAN        TYPE J_1IMOVEND-J_1IPANNO,
           STATUS(4)  TYPE C,
           USNAM      TYPE BKPF-USNAM,
*   KTOSL(3) TYPE C,

           ADR1       TYPE ADRC-NAME1,
           ADR2       TYPE ADRC-NAME2,
           ADR3       TYPE ADRC-NAME3,
           ADR4       TYPE ADRC-NAME4,
           ADR5       TYPE ADRC-STR_SUPPL1,
           ADR6       TYPE ADRC-STR_SUPPL2,
           SGTXT      TYPE BSEG-SGTXT,
           BELNR_CLR  TYPE BSE_CLR-BELNR_CLR,
           GJAHR_CLR  TYPE BSE_CLR-GJAHR_CLR,
           AUGDT      TYPE BSEG-AUGDT,
           PERIOD     TYPE I,
           SGST(10)   TYPE C,
           UGST(10)   TYPE C,
           CGST(10)   TYPE C,
           IGST(10)   TYPE C,
           CESS(10)   TYPE C,

           OTHR       TYPE BSET-HWSTE,
           SCODE(40)  TYPE C,
           IS         TYPE T005U-BEZEI,
           MBLNR      TYPE MKPF-MBLNR,
           AWKEY      TYPE BKPF-AWKEY,
           HKONT      TYPE BSEG-HKONT,
           MKPF_BUDAT TYPE SY-DATUM,
           RECP       TYPE BKPF-BELNR,
           RECP_DT    TYPE BKPF-BUDAT,
           RECPYR     TYPE BKPF-GJAHR,
         END OF ITAP2.

 TYPES : BEGIN OF CANC3,
           TEXT(50)   TYPE C,
           LINE       TYPE C,
           BELNR      TYPE BSEG-BELNR,
           GJAHR      TYPE BSEG-GJAHR,
           TXGRP      TYPE BSEG-TXGRP,
           STEUC      TYPE MARC-STEUC,
           MENGE      TYPE BSEG-MENGE,
           MEINS      TYPE BSEG-MEINS,
           MWSKZ      TYPE BSEG-MWSKZ,
           BUDAT      TYPE BKPF-BUDAT,
           XMWST      TYPE BKPF-XMWST,
           BLDAT      TYPE BKPF-BLDAT,
           XBLNR      TYPE BKPF-XBLNR,
           XREVERSAL  TYPE BKPF-XREVERSAL,
           KUNAG      TYPE VBRK-KUNAG,
           VBELN      TYPE VBRK-VBELN,
           TCODE      TYPE BKPF-TCODE,
           BLART      TYPE BKPF-BLART,
           HWSTE      TYPE BSET-HWSTE,
           HWBAS      TYPE BSET-HWBAS,
           RATE(10)   TYPE C,
           VENDOR     TYPE T001W-KUNNR,
           VENDOREG   TYPE T001W-REGIO,

           DMBTR      TYPE BSEG-DMBTR,
           LIFNR      TYPE BSEG-LIFNR,
           BUPLA      TYPE BSEG-BUPLA,
           GSBER      TYPE BSEG-GSBER,
           VENREG     TYPE T001W-REGIO,
           NAME1      TYPE LFA1-NAME1,
           ORT01      TYPE LFA1-ORT01,
           TDS        TYPE BSEG-DMBTR,
           STCD3      TYPE LFA1-STCD3,
           VEN_CLASS  TYPE J_1IMOVEND-VEN_CLASS,
           VEN_CL(30) TYPE C,
           PAN        TYPE J_1IMOVEND-J_1IPANNO,
           STATUS(4)  TYPE C,
           USNAM      TYPE BKPF-USNAM,
           ADR1       TYPE ADRC-NAME1,
           ADR2       TYPE ADRC-NAME2,
           ADR3       TYPE ADRC-NAME3,
           ADR4       TYPE ADRC-NAME4,
           ADR5       TYPE ADRC-STR_SUPPL1,
           ADR6       TYPE ADRC-STR_SUPPL2,
           SGTXT      TYPE BSEG-SGTXT,
           BELNR_CLR  TYPE BSE_CLR-BELNR_CLR,
           GJAHR_CLR  TYPE BSE_CLR-GJAHR_CLR,
           AUGDT      TYPE BSEG-AUGDT,
           PERIOD     TYPE I,

           SGST       TYPE BSET-HWSTE,
           UGST       TYPE BSET-HWSTE,
           CGST       TYPE BSET-HWSTE,
           IGST       TYPE BSET-HWSTE,
           CESS       TYPE BSET-HWSTE,
           OTHR       TYPE BSET-HWSTE,
           SCODE(40)  TYPE C,
           IS         TYPE T005U-BEZEI,
           MBLNR      TYPE MKPF-MBLNR,
           AWKEY      TYPE BKPF-AWKEY,
           HKONT      TYPE BSEG-HKONT,
           MKPF_BUDAT TYPE SY-DATUM,
           RECP       TYPE BKPF-BELNR,
           RECP_DT    TYPE BKPF-BUDAT,
           RECPYR     TYPE BKPF-GJAHR,
           WERKS      TYPE MSEG-WERKS,
           COUNT(3)   TYPE C,
           SIG(1)     TYPE C,
           RSTAT(10)  TYPE C,
           KOSTL      TYPE BSEG-KOSTL,
           MJAHR      TYPE MSEG-MJAHR,
           EBELN      TYPE EKPO-EBELN,
           XBLNR_MKPF TYPE MSEG-XBLNR_MKPF,
           SMBLN      TYPE MSEG-SMBLN,
           FKDAT      TYPE VBRK-FKDAT,
           NMBLNR     TYPE MSEG-MBLNR,
           NBUDAT     TYPE BKPF-BUDAT,
         END OF CANC3.

 TYPES : BEGIN OF ALV1,
           TEXT(50)   TYPE C,
           LINE       TYPE C,
           BELNR      TYPE BSEG-BELNR,
           GJAHR      TYPE BSEG-GJAHR,
           BUZEI      TYPE BSEG-BUZEI,
           TXGRP      TYPE BSEG-TXGRP,
           STEUC      TYPE MARC-STEUC,
           MENGE      TYPE BSEG-MENGE,
           MEINS      TYPE BSEG-MEINS,
           MWSKZ      TYPE BSEG-MWSKZ,
*   dmbtr type bseg-dmbtr,
           BUDAT      TYPE BKPF-BUDAT,
*   skfbt type p decimals 2,
           XMWST      TYPE BKPF-XMWST,
*   lifnr type bseg-lifnr,
           BLDAT      TYPE BKPF-BLDAT,
           XBLNR      TYPE BKPF-XBLNR,
           XREVERSAL  TYPE BKPF-XREVERSAL,
           KUNAG      TYPE VBRK-KUNAG,
           VBELN      TYPE VBRK-VBELN,
           TCODE      TYPE BKPF-TCODE,
           BLART      TYPE BKPF-BLART,
           HWSTE      TYPE BSET-HWSTE,
           HWBAS      TYPE BSET-HWBAS,
           RATE(10)   TYPE C,
           VENDOR     TYPE T001W-KUNNR,
           VENDOREG   TYPE T001W-REGIO,

           DMBTR      TYPE BSEG-DMBTR,
           LIFNR      TYPE BSEG-LIFNR,
           BUPLA      TYPE BSEG-BUPLA,
           GSBER      TYPE BSEG-GSBER,
           VENREG     TYPE T001W-REGIO,
           NAME1      TYPE LFA1-NAME1,
           ORT01      TYPE LFA1-ORT01,
           TDS        TYPE BSEG-DMBTR,
           STCD3      TYPE LFA1-STCD3,
           VEN_CLASS  TYPE J_1IMOVEND-VEN_CLASS,
           VEN_CL(30) TYPE C,
           PAN        TYPE J_1IMOVEND-J_1IPANNO,
           STATUS(4)  TYPE C,
           USNAM      TYPE BKPF-USNAM,
*   KTOSL(3) TYPE C,

           ADR1       TYPE ADRC-NAME1,
           ADR2       TYPE ADRC-NAME2,
           ADR3       TYPE ADRC-NAME3,
           ADR4       TYPE ADRC-NAME4,
           ADR5       TYPE ADRC-STR_SUPPL1,
           ADR6       TYPE ADRC-STR_SUPPL2,
           SGTXT      TYPE BSEG-SGTXT,
           BELNR_CLR  TYPE BSE_CLR-BELNR_CLR,
           GJAHR_CLR  TYPE BSE_CLR-GJAHR_CLR,
           AUGDT      TYPE BSEG-AUGDT,
           PERIOD     TYPE I,

           SGST       TYPE BSET-HWSTE,
           UGST       TYPE BSET-HWSTE,
           CGST       TYPE BSET-HWSTE,
           IGST       TYPE BSET-HWSTE,
           CESS       TYPE BSET-HWSTE,
           OTHR       TYPE BSET-HWSTE,
           SCODE(40)  TYPE C,
           IS         TYPE T005U-BEZEI,
           MBLNR      TYPE MKPF-MBLNR,
           AWKEY      TYPE BKPF-AWKEY,
           HKONT      TYPE BSEG-HKONT,
           MKPF_BUDAT TYPE SY-DATUM,
           RECP       TYPE BKPF-BELNR,
           RECP_DT    TYPE BKPF-BUDAT,
           RECPYR     TYPE BKPF-GJAHR,
           WERKS      TYPE MSEG-WERKS,
           COUNT(3)   TYPE C,
           SIG(1)     TYPE C,
           RSTAT(10)  TYPE C,
           KOSTL      TYPE BSEG-KOSTL,
           KUNNR      TYPE T001W-KUNNR,
           GRN        TYPE MKPF-MBLNR,
           GRNDT      TYPE MKPF-BUDAT,
****            " SOC By CK
           EBELN      TYPE EKPO-EBELN,
           BSART      TYPE EKKO-BSART,
           TYPE       TYPE CHAR20,
*****            " EOC By CK
         END OF ALV1.

 DATA: IT_BKPF2 TYPE TABLE OF BKPF,
       WA_BKPF2 TYPE BKPF,
       IT_RSEG2 TYPE TABLE OF RSEG,
       WA_RSEG2 TYPE RSEG.

 TYPES : BEGIN OF ALV2,
           TEXT(50)   TYPE C,
           LINE       TYPE C,
           BELNR      TYPE BSEG-BELNR,
           GJAHR      TYPE BSEG-GJAHR,
           TXGRP      TYPE BSEG-TXGRP,
           STEUC      TYPE MARC-STEUC,
           MENGE      TYPE BSEG-MENGE,
           MEINS      TYPE BSEG-MEINS,
           MWSKZ      TYPE BSEG-MWSKZ,
*   dmbtr type bseg-dmbtr,
           BUDAT      TYPE BKPF-BUDAT,
*   skfbt type p decimals 2,
           XMWST      TYPE BKPF-XMWST,
*   lifnr type bseg-lifnr,
           BLDAT      TYPE BKPF-BLDAT,
           XBLNR      TYPE BKPF-XBLNR,
           XREVERSAL  TYPE BKPF-XREVERSAL,
           KUNAG      TYPE VBRK-KUNAG,
           VBELN      TYPE VBRK-VBELN,
           TCODE      TYPE BKPF-TCODE,
*   BUDAT TYPE BKPF-BUDAT,
           BLART      TYPE BKPF-BLART,
           HWSTE      TYPE BSET-HWSTE,
           HWBAS      TYPE BSET-HWBAS,
           RATE(10)   TYPE C,
           VENDOR     TYPE T001W-KUNNR,
           VENDOREG   TYPE T001W-REGIO,

           DMBTR      TYPE BSEG-DMBTR,
           LIFNR      TYPE BSEG-LIFNR,
           BUPLA      TYPE BSEG-BUPLA,
           GSBER      TYPE BSEG-GSBER,
           VENREG     TYPE T001W-REGIO,
           NAME1      TYPE LFA1-NAME1,
           ORT01      TYPE LFA1-ORT01,
           TDS        TYPE BSEG-DMBTR,
           STCD3      TYPE LFA1-STCD3,
           VEN_CLASS  TYPE J_1IMOVEND-VEN_CLASS,
           VEN_CL(30) TYPE C,
           PAN        TYPE J_1IMOVEND-J_1IPANNO,
           STATUS(4)  TYPE C,
           USNAM      TYPE BKPF-USNAM,
*   KTOSL(3) TYPE C,

           ADR1       TYPE ADRC-NAME1,
           ADR2       TYPE ADRC-NAME2,
           ADR3       TYPE ADRC-NAME3,
           ADR4       TYPE ADRC-NAME4,
           ADR5       TYPE ADRC-STR_SUPPL1,
           ADR6       TYPE ADRC-STR_SUPPL2,
           SGTXT      TYPE BSEG-SGTXT,
           BELNR_CLR  TYPE BSE_CLR-BELNR_CLR,
           GJAHR_CLR  TYPE BSE_CLR-GJAHR_CLR,
           AUGDT      TYPE BSEG-AUGDT,
           PERIOD     TYPE I,

           SGST       TYPE BSET-HWSTE,
           UGST       TYPE BSET-HWSTE,
           CGST       TYPE BSET-HWSTE,
           IGST       TYPE BSET-HWSTE,
           CESS       TYPE BSET-HWSTE,
           OTHR       TYPE BSET-HWSTE,
           SCODE(40)  TYPE C,
           IS         TYPE T005U-BEZEI,
           MBLNR      TYPE MKPF-MBLNR,
           AWKEY      TYPE BKPF-AWKEY,
           HKONT      TYPE BSEG-HKONT,
           MKPF_BUDAT TYPE SY-DATUM,
           RECP       TYPE BKPF-BELNR,
           RECP_DT    TYPE BKPF-BUDAT,
           RECPYR     TYPE BKPF-GJAHR,
           WERKS      TYPE MSEG-WERKS,
           COUNT(3)   TYPE C,
           SIG(1)     TYPE C,
           RSTAT(10)  TYPE C,
           KOSTL      TYPE BSEG-KOSTL,
           KUNNR      TYPE T001W-KUNNR,

           TYP1(10)   TYPE C,
           TYP2(10)   TYPE C,
           TYP3(40)   TYPE C,
           TYP4(10)   TYPE C,
           TYP5(10)   TYPE C,
           TYP6(10)   TYPE C,
           STAT(1)    TYPE C,

         END OF ALV2.

 TYPES : BEGIN OF ITAB1,
           BELNR      TYPE BSEG-BELNR,
           GJAHR      TYPE BSEG-GJAHR,
           TAX        TYPE BSET-HWSTE,
           MWSKZ      TYPE BSEG-MWSKZ,
           BUDAT      TYPE BKPF-BUDAT,
           XMWST      TYPE BKPF-XMWST,
           BLDAT      TYPE BKPF-BLDAT,
           XBLNR      TYPE BKPF-XBLNR,
           XREVERSAL  TYPE BKPF-XREVERSAL,
           KUNAG      TYPE VBRK-KUNAG,
           VBELN      TYPE VBRK-VBELN,
           MENGE      TYPE VBRP-FKIMG,
           MEINS      TYPE VBRP-MEINS,
           TCODE      TYPE BKPF-TCODE,
           BLART      TYPE BKPF-BLART,
           HWSTE      TYPE BSET-HWSTE,
           HWBAS      TYPE BSET-HWBAS,
           RATE(10)   TYPE C,
           VENDOR     TYPE T001W-KUNNR,
           VENDOREG   TYPE T001W-REGIO,
           DMBTR      TYPE BSEG-DMBTR,
           LIFNR      TYPE BSEG-LIFNR,
           BUPLA      TYPE BSEG-BUPLA,
           GSBER      TYPE BSEG-GSBER,
           VENREG     TYPE T001W-REGIO,
           NAME1      TYPE LFA1-NAME1,
           ORT01      TYPE LFA1-ORT01,
           TDS        TYPE BSEG-DMBTR,
           STCD3      TYPE LFA1-STCD3,
           VEN_CLASS  TYPE J_1IMOVEND-VEN_CLASS,
           VEN_CL(30) TYPE C,
           PAN        TYPE J_1IMOVEND-J_1IPANNO,
           STATUS(4)  TYPE C,
           USNAM      TYPE BKPF-USNAM,
           ADR1       TYPE ADRC-NAME1,
           ADR2       TYPE ADRC-NAME2,
           ADR3       TYPE ADRC-NAME3,
           ADR4       TYPE ADRC-NAME4,
           ADR5       TYPE ADRC-STR_SUPPL1,
           ADR6       TYPE ADRC-STR_SUPPL2,
           SGTXT      TYPE BSEG-SGTXT,
           BELNR_CLR  TYPE BSE_CLR-BELNR_CLR,
           GJAHR_CLR  TYPE BSE_CLR-GJAHR_CLR,
           AUGDT      TYPE BSEG-AUGDT,
           PERIOD     TYPE I,

           SGST       TYPE BSET-HWSTE,
           UGST       TYPE BSET-HWSTE,
           CGST       TYPE BSET-HWSTE,
           IGST       TYPE BSET-HWSTE,
           CESS       TYPE BSET-HWSTE,
           OTHR       TYPE BSET-HWSTE,
           SCODE(40)  TYPE C,
           IS         TYPE T005U-BEZEI,
           MBLNR      TYPE MKPF-MBLNR,
           AWKEY      TYPE BKPF-AWKEY,
           STEUC      TYPE MARC-STEUC,
           NETWR      TYPE VBRP-NETWR,
           MWSBP      TYPE VBRP-MWSBP,
           JOCG       TYPE P DECIMALS 2,
           JOSG       TYPE P DECIMALS 2,
           JOIG       TYPE P DECIMALS 2,
           JOUG       TYPE P DECIMALS 2,
           TAXABLE    TYPE P DECIMALS 2,
           MKPF_BUDAT TYPE SY-DATUM,
           RSTAT(10)  TYPE C,
           HKONT      TYPE BSEG-HKONT,
           SIG(1)     TYPE C,
           KOSTL      TYPE BSEG-KOSTL,
           VGBEL      TYPE VBRP-VGBEL,
         END OF ITAB1.

 DATA : XBLNR1 TYPE MKPF-XBLNR,
        VGBEL1 TYPE VBRP-VGBEL.

 TYPES : BEGIN OF INV1,
           BELNR      TYPE BKPF-BELNR,
           GJAHR      TYPE BKPF-GJAHR,
           VBELN      TYPE VBRK-VBELN,
           GSBER      TYPE BSEG-GSBER,
           TCODE      TYPE BKPF-TCODE,
           BUDAT      TYPE BKPF-BUDAT,
           BLDAT      TYPE BKPF-BLDAT,
           BLART      TYPE BKPF-BLART,
           XBLNR      TYPE BKPF-XBLNR,
           BUPLA      TYPE VBRK-REGIO,
           VENDOR     TYPE T001W-KUNNR,
           VENDOREG   TYPE T001W-REGIO,
           DMBTR      TYPE VBRK-NETWR,
           NAME1      TYPE KNA1-NAME1,
           ORT01      TYPE KNA1-ORT01,
           STCD3      TYPE KNA1-STCD3,
           USNAM      TYPE BKPF-USNAM,
           SGTXT      TYPE BSEG-SGTXT,
           VEN_CLASS  TYPE J_1IMOVEND-VEN_CLASS,
           VEN_CL(30) TYPE C,
           PAN        TYPE J_1IMOCUST-J_1IPANNO,
           VGBEL      TYPE VBRP-VGBEL,
           AUBEL      TYPE VBRP-AUBEL,
           AUPOS      TYPE VBRP-AUPOS,
           NETWR      TYPE VBRP-NETWR,
           MWSBP      TYPE VBRP-MWSBP,
           MENGE      TYPE VBRP-FKIMG,
           MEINS      TYPE VBRP-VRKME,
           JOCG       TYPE P DECIMALS 2,
           JOSG       TYPE P DECIMALS 2,
           JOIG       TYPE P DECIMALS 2,
           JOUG       TYPE P DECIMALS 2,
           TAXABLE    TYPE P DECIMALS 2,
           RATE(10)   TYPE C,
           STEUC      TYPE MARC-STEUC,
         END OF INV1.

 TYPES : BEGIN OF IITAX1,
           BELNR     TYPE BKPF-BELNR,
           GJAHR     TYPE BKPF-GJAHR,
           TXGRP     TYPE BSET-TXGRP,
           HWSTE     TYPE BSET-HWSTE,
           HWBAS     TYPE BSET-HWBAS,
           DMBTR     TYPE BSET-HWBAS,
           KTOSL     TYPE BSET-KTOSL,
           RATE(10)  TYPE C,
           TAX       TYPE BSET-HWSTE,
*     KTOSL(3) TYPE C,
*     MWSKZ TYPE BSET-MWSKZ,
           SGST      TYPE BSET-HWSTE,
           CGST      TYPE BSET-HWSTE,
           IGST      TYPE BSET-HWSTE,
           UGST      TYPE BSET-HWSTE,
           CESS      TYPE BSET-HWSTE,
           OTHR      TYPE BSET-HWSTE,
           MWSKZ     TYPE BSET-MWSKZ,
           SIG(1)    TYPE C,
           STATUS(4) TYPE C,
           BUZEI     TYPE BSET-BUZEI,
           HKONT     TYPE BSEG-HKONT,
         END OF IITAX1.


 TYPES : BEGIN OF ITAX1,
           BELNR     TYPE BKPF-BELNR,
           GJAHR     TYPE BKPF-GJAHR,
           TXGRP     TYPE BSET-TXGRP,
           HWSTE     TYPE BSET-HWSTE,
           HWBAS     TYPE BSET-HWBAS,
           KTOSL     TYPE BSET-KTOSL,
           RATE(10)  TYPE C,
           TAX       TYPE BSET-HWSTE,
*     KTOSL(3) TYPE C,
*     MWSKZ TYPE BSET-MWSKZ,
           SGST      TYPE BSET-HWSTE,
           CGST      TYPE BSET-HWSTE,
           IGST      TYPE BSET-HWSTE,
           UGST      TYPE BSET-HWSTE,
           CESS      TYPE BSET-HWSTE,
           OTHR      TYPE BSET-HWSTE,
           MWSKZ     TYPE BSET-MWSKZ,
           SIG(1)    TYPE C,
           STATUS(4) TYPE C,
           BUZEI     TYPE BSET-BUZEI,
         END OF ITAX1.

 TYPES : BEGIN OF TDS1,
           BELNR TYPE BKPF-BELNR,
           GJAHR TYPE BKPF-GJAHR,
           DMBTR TYPE BSEG-DMBTR,
         END OF TDS1.

 TYPES : BEGIN OF REG1,
           BELNR TYPE BKPF-BELNR,
           GJAHR TYPE BKPF-GJAHR,
           BUPLA TYPE BSEG-BUPLA,
         END OF REG1.

 TYPES : BEGIN OF GL1,
           BELNR TYPE BSEG-BELNR,
           GJAHR TYPE BSEG-GJAHR,
           HKONT TYPE BSEG-HKONT,
           DMBTR TYPE BSEG-DMBTR,
         END OF GL1.

 TYPES : BEGIN OF GL2,
           BELNR TYPE BSEG-BELNR,
           GJAHR TYPE BSEG-GJAHR,
           HKONT TYPE BSEG-HKONT,
           DMBTR TYPE BSEG-DMBTR,
           TXT50 TYPE SKAT-TXT50,
           TCODE TYPE BKPF-TCODE,
           BUDAT TYPE BKPF-BUDAT,
           BLDAT TYPE BKPF-BLDAT,
           BLART TYPE BKPF-BLART,
           XBLNR TYPE BKPF-XBLNR,
           BUPLA TYPE VBRK-REGIO,
           VBELN TYPE VBRK-VBELN,
           GSBER TYPE BSEG-GSBER,
         END OF GL2.

 TYPES : BEGIN OF NTAX1,
           BELNR TYPE BSEG-BELNR,
           GJAHR TYPE BSEG-GJAHR,
         END OF NTAX1.

 TYPES : BEGIN OF NTAX2,
           BELNR TYPE BSEG-BELNR,
           GJAHR TYPE BSEG-GJAHR,
           SGST  TYPE P DECIMALS 2,
           CGST  TYPE P DECIMALS 2,
           IGST  TYPE P DECIMALS 2,
           UGST  TYPE P DECIMALS 2,
           OTHR  TYPE P DECIMALS 2,
           TAX   TYPE P DECIMALS 2,
         END OF NTAX2.

 TYPES : BEGIN OF RCM1,
           BELNR TYPE BSEG-BELNR,
           GJAHR TYPE BSEG-GJAHR,
           SGST  TYPE P DECIMALS 2,
           CGST  TYPE P DECIMALS 2,
           IGST  TYPE P DECIMALS 2,
           UGST  TYPE P DECIMALS 2,
           CESS  TYPE P DECIMALS 2,
           OTHR  TYPE P DECIMALS 2,
           TAX   TYPE P DECIMALS 2,
           MWSKZ TYPE BSET-MWSKZ,
         END OF RCM1.

 TYPES : BEGIN OF QTY1,
           VBELN TYPE VBRP-VBELN,
           FKIMG TYPE P,
         END OF QTY1.

 TYPES : BEGIN OF QTY11,
           BELNR  TYPE BKPF-BELNR,
           GJAHR  TYPE BKPF-GJAHR,
           AWKEY1 TYPE RSEG-BELNR,
           AWKEY2 TYPE RSEG-GJAHR,
         END OF QTY11.

 TYPES : BEGIN OF QTY12,
           BELNR  TYPE BKPF-BELNR,
           GJAHR  TYPE BKPF-GJAHR,
           AWKEY1 TYPE RSEG-BELNR,
           AWKEY2 TYPE RSEG-GJAHR,
           QTY    TYPE P,
         END OF QTY12.

 TYPES : BEGIN OF TAX5,
           BELNR TYPE BKPF-BELNR,
           GJAHR TYPE BKPF-GJAHR,
           HWSTE TYPE BSET-HWSTE,
           IGST  TYPE BSET-HWSTE,
           CGST  TYPE BSET-HWSTE,
           SGST  TYPE BSET-HWSTE,
           UGST  TYPE BSET-HWSTE,
           CESS  TYPE BSET-HWSTE,
         END OF TAX5.

 TYPES: BEGIN OF VAL1,
          BELNR TYPE BSEG-BELNR,
          GJAHR TYPE BSEG-GJAHR,
          DMBTR TYPE BSEG-DMBTR,
        END OF VAL1.

 TYPES: BEGIN OF GL3,
          BELNR TYPE BSEG-BELNR,
          GJAHR TYPE BSEG-GJAHR,
          HKONT TYPE BSEG-HKONT,
        END OF GL3.

 TYPES: BEGIN OF CANC1,
          BUDAT      TYPE MKPF-BUDAT,
          MBLNR      TYPE MSEG-MBLNR,
          MJAHR      TYPE MSEG-MJAHR,
          XBLNR_MKPF TYPE MSEG-XBLNR_MKPF,
          SMBLN      TYPE MSEG-SMBLN,
          EBELN      TYPE MSEG-EBELN,
          NBUDAT     TYPE MKPF-BUDAT,
          NMBLNR     TYPE MSEG-MBLNR,
        END OF CANC1.

 TYPES: BEGIN OF CANC2,
          BUDAT      TYPE MKPF-BUDAT,
          MBLNR      TYPE MSEG-MBLNR,
          MJAHR      TYPE MSEG-MJAHR,
          XBLNR_MKPF TYPE MSEG-XBLNR_MKPF,
          SMBLN      TYPE MSEG-SMBLN,
          VBELN      TYPE VBRK-VBELN,
          FKDAT      TYPE VBRK-FKDAT,
          EBELN      TYPE MSEG-EBELN,
          NBUDAT     TYPE MKPF-BUDAT,
          NMBLNR     TYPE MSEG-MBLNR,
        END OF CANC2.

 TYPES: BEGIN OF HS1,
          BUPLA    TYPE BSEG-BUPLA,
          STEUC    TYPE MARC-STEUC,
          MENGE    TYPE MSEG-MENGE,
          MEINS    TYPE MSEG-MEINS,
          HWBAS    TYPE BSET-HWBAS,
          HWBAS1   TYPE BSET-HWBAS,
          IGST     TYPE BSET-HWSTE,
          SGST     TYPE BSET-HWSTE,
          CGST     TYPE BSET-HWSTE,
          UGST     TYPE BSET-HWSTE,
          CESS     TYPE BSET-HWSTE,
          RATE(10) TYPE C,
        END OF HS1.

 TYPES : BEGIN OF TAK1,
           BELNR   TYPE BSET-BELNR,
           GJAHR   TYPE BSEG-GJAHR,
           HWSTE   TYPE BSET-HWSTE,
           SIGN(1) TYPE C,
         END OF TAK1.

 TYPES : BEGIN OF TAK4,
           BELNR     TYPE BSET-BELNR,
           GJAHR     TYPE BSEG-GJAHR,
           MWSKZ     TYPE BSEG-MWSKZ,
           TXGRP     TYPE BSEG-TXGRP,
           DMBTR     TYPE BSEG-DMBTR,
           HKONT     TYPE BSEG-HKONT,
           SGST      TYPE BSET-HWSTE,
           CGST      TYPE BSET-HWSTE,
           IGST      TYPE BSET-HWSTE,
           CESS      TYPE BSET-HWSTE,
           UGST      TYPE BSET-HWSTE,
           HWBAS     TYPE BSET-HWBAS,
           HWSTE     TYPE BSET-HWSTE,
           STATUS(3) TYPE C,

         END OF TAK4.

 TYPES : BEGIN OF IMP1,
           BELNR TYPE BSEG-BELNR,
           GJAHR TYPE BSEG-GJAHR,
           EBELN TYPE BSEG-EBELN,
           EBELP TYPE BSEG-EBELP,
         END OF IMP1.

 TYPES : BEGIN OF IMP2,
           EBELN TYPE BSEG-EBELN,
           EBELP TYPE BSEG-EBELP,
         END OF IMP2.

 TYPES : BEGIN OF IMP3,
           BELNR  TYPE BSEG-BELNR,
           GJAHR  TYPE BSEG-GJAHR,
           EBELN  TYPE BSEG-EBELN,
           EBELP  TYPE BSEG-EBELP,
           DMBTR  TYPE BSEG-DMBTR,
           LIFNR  TYPE BSEG-LIFNR,
           STEUC  TYPE MARC-STEUC,
           FIDOC  TYPE BKPF-BELNR,
           FIYEAR TYPE BKPF-GJAHR,
           BUDAT  TYPE BKPF-BUDAT,
           TCODE  TYPE BKPF-TCODE,
           BUPLA  TYPE BSEG-BUPLA,
         END OF IMP3.

 TYPES : BEGIN OF IMP4,
           BELNR     TYPE BSEG-BELNR,
           GJAHR     TYPE BSEG-GJAHR,
           HWSTE     TYPE BSEG-DMBTR,
           HWBAS     TYPE BSEG-DMBTR,
           STEUC     TYPE MARC-STEUC,
           KTOSL     TYPE BSEG-KTOSL,
           KBETR(10) TYPE C,
           BUPLA     TYPE BSET-BUPLA,
         END OF IMP4.

 TYPES : BEGIN OF IMP5,
           BELNR     TYPE BSEG-BELNR,
           GJAHR     TYPE BSEG-GJAHR,
           HWSTE     TYPE BSEG-DMBTR,
           HWBAS     TYPE BSEG-DMBTR,
           STEUC     TYPE MARC-STEUC,
           KTOSL     TYPE BSEG-KTOSL,
           KBETR(10) TYPE C,
           LIFNR     TYPE BSEG-LIFNR,
           VALUE     TYPE BSEG-DMBTR,
           BUDAT     TYPE BKPF-BUDAT,
           TCODE     TYPE BKPF-TCODE,
           BUPLA     TYPE BSET-BUPLA,
           EBELN     TYPE BSEG-EBELN,
           EBELP     TYPE BSEG-EBELP,
         END OF IMP5.

 TYPES : BEGIN OF IMP6,
           BELNR     TYPE BSEG-BELNR,
           GJAHR     TYPE BSEG-GJAHR,
           HWBAS(18) TYPE C,
           JIM       TYPE BSEG-DMBTR,
           JII       TYPE BSEG-DMBTR,
           JIC       TYPE BSEG-DMBTR,
           JIS       TYPE BSEG-DMBTR,
           OTH       TYPE BSEG-DMBTR,
           STEUC     TYPE MARC-STEUC,
           KTOSL     TYPE BSEG-KTOSL,
           KBETR(10) TYPE C,
           LIFNR     TYPE BSEG-LIFNR,
           VALUE     TYPE BSEG-DMBTR,
           BUDAT     TYPE BKPF-BUDAT,
           TCODE     TYPE BKPF-TCODE,
           BUPLA     TYPE BSET-BUPLA,
           EBELN     TYPE BSEG-EBELN,
           EBELP     TYPE BSEG-EBELP,
           BLDAT     TYPE BKPF-BLDAT,
           XBLNR     TYPE BKPF-XBLNR,
           SCODE(40) TYPE C,
         END OF IMP6.

 TYPES : BEGIN OF IMV1,
           BELNR TYPE BSEG-BELNR,
           GJAHR TYPE BSEG-GJAHR,
           DMBTR TYPE BSEG-DMBTR,
         END OF IMV1.

 TYPES : BEGIN OF JTAB1,
           BELNR TYPE BSEG-BELNR,
           GJAHR TYPE BSEG-GJAHR,
           HWSTE TYPE BSET-HWSTE,
         END OF JTAB1.

 TYPES : BEGIN OF GRN1,
           BELNR  TYPE BSEG-BELNR,
           GJAHR  TYPE BSEG-GJAHR,
           BELNR1 TYPE BSEG-BELNR,
           GJAHR1 TYPE BSEG-GJAHR,
         END OF GRN1.

 DATA : IT_TAB1    TYPE TABLE OF ITAB1,
        WA_TAB1    TYPE ITAB1,
        IT_TAB2    TYPE TABLE OF ITAB1,
        WA_TAB2    TYPE ITAB1,
        IT_TAB3    TYPE TABLE OF ITAB1,
        WA_TAB3    TYPE ITAB1,
        IT_TAB4    TYPE TABLE OF ITAB1,
        WA_TAB4    TYPE ITAB1,
        IT_INV1    TYPE TABLE OF INV1,
        WA_INV1    TYPE INV1,
        IT_TAX1    TYPE TABLE OF ITAX1,
        WA_TAX1    TYPE ITAX1,
        IT_NOTAX1  TYPE TABLE OF ITAX1,
        WA_NOTAX1  TYPE ITAX1,
        IT_INOTAX1 TYPE TABLE OF IITAX1,
        WA_INOTAX1 TYPE IITAX1,
        IT_INOTAX2 TYPE TABLE OF IITAX1,
        WA_INOTAX2 TYPE IITAX1,
        IT_RC1     TYPE TABLE OF ITAX1,
        WA_RC1     TYPE ITAX1,
        IT_NRC1    TYPE TABLE OF ITAX1,
        WA_NRC1    TYPE ITAX1,
        IT_TDS1    TYPE TABLE OF TDS1,
        WA_TDS1    TYPE TDS1,
        IT_VAL1    TYPE TABLE OF VAL1,
        WA_VAL1    TYPE VAL1,
        IT_VAL2    TYPE TABLE OF VAL1,
        WA_VAL2    TYPE VAL1,
        IT_REG1    TYPE TABLE OF REG1,
        WA_REG1    TYPE REG1,
        IT_GL1     TYPE TABLE OF GL1,
        WA_GL1     TYPE GL1,
        IT_GL2     TYPE TABLE OF GL2,
        WA_GL2     TYPE GL2,
        IT_NTAX1   TYPE TABLE OF NTAX1,
        WA_NTAX1   TYPE NTAX1,
        IT_INTAX1  TYPE TABLE OF NTAX1,
        WA_INTAX1  TYPE NTAX1,
        IT_INTAX2  TYPE TABLE OF NTAX1,
        WA_INTAX2  TYPE NTAX1,
        IT_NTAX3   TYPE TABLE OF NTAX1,
        WA_NTAX3   TYPE NTAX1,
        IT_VAL3    TYPE TABLE OF VAL1,
        WA_VAL3    TYPE VAL1,
        IT_VAL4    TYPE TABLE OF VAL1,
        WA_VAL4    TYPE VAL1,
        IT_NTAX2   TYPE TABLE OF NTAX2,
        WA_NTAX2   TYPE NTAX2,
        IT_RCM1    TYPE TABLE OF RCM1,
        WA_RCM1    TYPE RCM1,
        IT_QTY1    TYPE TABLE OF QTY1,
        WA_QTY1    TYPE QTY1,
        IT_QTY11   TYPE TABLE OF QTY11,
        WA_QTY11   TYPE QTY11,
        IT_QTY12   TYPE TABLE OF QTY12,
        WA_QTY12   TYPE QTY12,
        IT_TAP1    TYPE TABLE OF ITAP11,
        WA_TAP1    TYPE ITAP11,
        IT_TAPX1   TYPE TABLE OF ITAP11,
        WA_TAPX1   TYPE ITAP11,
        IT_TAP2    TYPE TABLE OF ITAP1,
        WA_TAP2    TYPE ITAP1,
        IT_TAS1    TYPE TABLE OF ITAP1,
        WA_TAS1    TYPE ITAP1,
        IT_TAS2    TYPE TABLE OF ITAP1,
        WA_TAS2    TYPE ITAP1,
        IT_TAS21   TYPE TABLE OF ITAP1,
        WA_TAS21   TYPE ITAP1,
        IT_TAS3    TYPE TABLE OF ITAP1,
        WA_TAS3    TYPE ITAP1,
        IT_TAI1    TYPE TABLE OF ITAP1,
        WA_TAI1    TYPE ITAP1,
        IT_TAJ1    TYPE TABLE OF ITAP1,
        WA_TAJ1    TYPE ITAP1,
        IT_TAJI1   TYPE TABLE OF ITAP1,
        WA_TAJI1   TYPE ITAP1,
        IT_TASP1   TYPE TABLE OF ITAP1,
        WA_TASP1   TYPE ITAP1,
        IT_TACC1   TYPE TABLE OF ITAP1,
        WA_TACC1   TYPE ITAP1,
        IT_JRC1    TYPE TABLE OF ITAP1,
        WA_JRC1    TYPE ITAP1,
        IT_ISD1    TYPE TABLE OF ITAP1,
        WA_ISD1    TYPE ITAP1,
        IT_INGISD1 TYPE TABLE OF ITAP1,
        WA_INGISD1 TYPE ITAP1,
        IT_TAS31   TYPE TABLE OF ITAP1,
        WA_TAS31   TYPE ITAP1,
        IT_TAS32   TYPE TABLE OF VAL1,
        WA_TAS32   TYPE VAL1,
        IT_TAS33   TYPE TABLE OF VAL1,
        WA_TAS33   TYPE VAL1,
        IT_TAS4    TYPE TABLE OF ITAP1,
        WA_TAS4    TYPE ITAP1,
        IT_TAC1    TYPE TABLE OF ITAP1,
        WA_TAC1    TYPE ITAP1,
        IT_TAS5    TYPE TABLE OF ITAP1,
        WA_TAS5    TYPE ITAP1,
        IT_TAS51   TYPE TABLE OF ITAP1,
        WA_TAS51   TYPE ITAP1,
        IT_TAS52   TYPE TABLE OF ITAP1,
        WA_TAS52   TYPE ITAP1,
        IT_TAS5ING TYPE TABLE OF ITAP1,
        WA_TAS5ING TYPE ITAP1,
        IT_TAS6    TYPE TABLE OF ITAP1,
        WA_TAS6    TYPE ITAP1,
        IT_TAS7    TYPE TABLE OF ITAP1,
        WA_TAS7    TYPE ITAP1,
        IT_TAS9    TYPE TABLE OF ITAP1,
        WA_TAS9    TYPE ITAP1,
        IT_TAS10   TYPE TABLE OF ITAP1,
        WA_TAS10   TYPE ITAP1,
        IT_TAS8    TYPE TABLE OF ITAP1,
        WA_TAS8    TYPE ITAP1,
        IT_NTAP1   TYPE TABLE OF ITAB1,
        WA_NTAP1   TYPE ITAB1,
        IT_NTAP2   TYPE TABLE OF ITAB1,
        WA_NTAP2   TYPE ITAB1,
        IT_NTAP3   TYPE TABLE OF ITAB1,
        WA_NTAP3   TYPE ITAB1,
        IT_TAR1    TYPE TABLE OF ITAB1,
        WA_TAR1    TYPE ITAB1,
        IT_TAR2    TYPE TABLE OF ITAB1,
        WA_TAR2    TYPE ITAB1,
        IT_TAR3    TYPE TABLE OF ITAB1,
        WA_TAR3    TYPE ITAB1,
        IT_TAX5ING TYPE TABLE OF TAX5,
        WA_TAX5ING TYPE TAX5,
        IT_TAX8    TYPE TABLE OF TAX5,
        WA_TAX8    TYPE TAX5,
        IT_ALV1    TYPE TABLE OF ALV1,
        WA_ALV1    TYPE ALV1,
        IT_ALV2    TYPE TABLE OF ALV2,
        WA_ALV2    TYPE ALV2,

        IT_RRP2    TYPE TABLE OF ALV1,
        WA_RRP2    TYPE ALV1,
        IT_RRP3    TYPE TABLE OF ALV1,
        WA_RRP3    TYPE ALV1,
        IT_RRP4    TYPE TABLE OF ALV1,
        WA_RRP4    TYPE ALV1,

        IT_GL3     TYPE TABLE OF GL3,
        WA_GL3     TYPE GL3,
        IT_CANC1   TYPE TABLE OF CANC1,
        WA_CANC1   TYPE CANC1,
        IT_CANC2   TYPE TABLE OF CANC2,
        WA_CANC2   TYPE CANC2,
        IT_CANC3   TYPE TABLE OF CANC3,
        WA_CANC3   TYPE CANC3,
        IT_CANC11  TYPE TABLE OF CANC1,
        WA_CANC11  TYPE CANC1,
        IT_CANC12  TYPE TABLE OF CANC2,
        WA_CANC12  TYPE CANC2,
        IT_HS1     TYPE TABLE OF HS1,
        WA_HS1     TYPE HS1,
        IT_HS2     TYPE TABLE OF HS1,
        WA_HS2     TYPE HS1,
        IT_TAK1    TYPE TABLE OF TAK1,
        WA_TAK1    TYPE TAK1,
        IT_TAK2    TYPE TABLE OF TAK1,
        WA_TAK2    TYPE TAK1,
        IT_TAK3    TYPE TABLE OF TAK1,
        WA_TAK3    TYPE TAK1,
        IT_TAK4    TYPE TABLE OF TAK4,
        WA_TAK4    TYPE TAK4,
        IT_TAK5    TYPE TABLE OF TAK4,
        WA_TAK5    TYPE TAK4,
        IT_IMP1    TYPE TABLE OF IMP1,
        WA_IMP1    TYPE IMP1,
        IT_IMP2    TYPE TABLE OF IMP2,
        WA_IMP2    TYPE IMP2,
        IT_IMP3    TYPE TABLE OF IMP3,
        WA_IMP3    TYPE IMP3,
        IT_IMP4    TYPE TABLE OF IMP4,
        WA_IMP4    TYPE IMP4,
        IT_IMP5    TYPE TABLE OF IMP5,
        WA_IMP5    TYPE IMP5,
        IT_IMP6    TYPE TABLE OF IMP6,
        WA_IMP6    TYPE IMP6,
        IT_IMP7    TYPE TABLE OF IMP6,
        WA_IMP7    TYPE IMP6,
        IT_IMP1A   TYPE TABLE OF IMP3,
        WA_IMP1A   TYPE IMP3,
        IT_IMP2A   TYPE TABLE OF IMP3,
        WA_IMP2A   TYPE IMP3,
        IT_IMV1    TYPE TABLE OF IMV1,
        WA_IMV1    TYPE IMV1,
        IT_JTAB1   TYPE TABLE OF JTAB1,
        WA_JTAB1   TYPE JTAB1.
 DATA: IT_GRN1 TYPE TABLE OF GRN1,
       WA_GRN1 TYPE GRN1.

 DATA : IT_MKPF  TYPE TABLE OF MKPF,
        WA_MKPF  TYPE MKPF,
        IT_MKPF1 TYPE TABLE OF MKPF,
        WA_MKPF1 TYPE MKPF,
        IT_MSEG  TYPE TABLE OF MSEG,
        WA_MSEG  TYPE MSEG,
        IT_MSEG1 TYPE TABLE OF MSEG,
        WA_MSEG1 TYPE MSEG.

 DATA : COUNT TYPE I,
        TTAX  TYPE BSET-HWSTE,
        TTAX1 TYPE BSET-HWSTE.

 DATA : V1    TYPE BSET-HWBAS,
        V2    TYPE BSET-HWBAS,
        A1    TYPE BSET-HWSTE,
        GJAHR TYPE BSET-GJAHR.
 DATA: ING TYPE I.

 DATA : DOC       TYPE BKPF-XBLNR,
        TAXRATE   TYPE BSET-KBETR,
        PERIOD    TYPE I,
        SCODE(40) TYPE C,
        REG1      TYPE T005U-BEZEI,
        REG2      TYPE T005U-BEZEI,
        BUPLA     TYPE BSEG-BUPLA,
        GSBER     TYPE BSEG-GSBER,
        RATE      TYPE P DECIMALS 2,
        TAX1      TYPE P DECIMALS 2,
        TAX2      TYPE P DECIMALS 2,
        TAX3      TYPE P DECIMALS 2,
        TAX4      TYPE P DECIMALS 2,
        TAX5      TYPE P DECIMALS 2,
        TAX6      TYPE P DECIMALS 2,
        TAX7      TYPE P DECIMALS 2,
        TAX8      TYPE P DECIMALS 2,
        TAX9      TYPE P DECIMALS 2,
        TAX10     TYPE P DECIMALS 2,
        TAX       TYPE P DECIMALS 2,
        PDATE     TYPE SY-DATUM,
        VAL1      TYPE P DECIMALS 2,
        VAL2      TYPE P DECIMALS 2,
        VAL3      TYPE P DECIMALS 2,
        YEAR(4)   TYPE C,
        YEAR1(4)  TYPE C.

 DATA : VAL4  TYPE BSEG-DMBTR,
        VAL5  TYPE BSEG-DMBTR,
        VAL6  TYPE BSEG-DMBTR,
        VAL7  TYPE BSEG-DMBTR,
        VAL8  TYPE BSEG-DMBTR,
        VAL9  TYPE BSEG-DMBTR,
        VAL10 TYPE BSEG-DMBTR,
        VAL11 TYPE BSEG-DMBTR,
        VAL12 TYPE BSEG-DMBTR,
        VAL13 TYPE BSEG-DMBTR.
 DATA : NDATE1 TYPE SY-DATUM,
        DT1    TYPE SY-DATUM.
 DATA  : TOT TYPE VBRK-NETWR.

 SELECTION-SCREEN BEGIN OF BLOCK MERKMALE WITH FRAME TITLE TEXT-002.
   SELECT-OPTIONS : S_BUDAT FOR VBRK-FKDAT.
   SELECT-OPTIONS : BUSPLACE FOR BSEG-BUPLA.


 SELECTION-SCREEN END OF BLOCK MERKMALE.
 SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.

   SELECT-OPTIONS : PLANT FOR T001W-WERKS.

   PARAMETERS : R11   RADIOBUTTON GROUP R1,
                R12   RADIOBUTTON GROUP R1,
                R12N1 RADIOBUTTON GROUP R1,
                R12HS RADIOBUTTON GROUP R1,
                R16   RADIOBUTTON GROUP R1,
                R13   RADIOBUTTON GROUP R1,
                R13D  RADIOBUTTON GROUP R1,
                R17   RADIOBUTTON GROUP R1,
                R14   RADIOBUTTON GROUP R1,
                R15   RADIOBUTTON GROUP R1.

   SELECT-OPTIONS : HSN FOR BSEG-HSN_SAC.

   PARAMETERS : RP1 RADIOBUTTON GROUP R1,
                RP2 RADIOBUTTON GROUP R1,
                RP3 RADIOBUTTON GROUP R1,
                RP4 RADIOBUTTON GROUP R1.
 SELECTION-SCREEN END OF BLOCK MERKMALE1.

 INITIALIZATION.
   G_REPID = SY-REPID.

 START-OF-SELECTION.
   SELECT * FROM T005U INTO TABLE IT_T005U WHERE SPRAS EQ 'EN'
      AND LAND1 EQ 'IN' AND BLAND IN BUSPLACE.
   NDATE1+6(2) = '01'.
   NDATE1+4(2) = '04'.
   NDATE1+0(4) = '2018'.
   break ctplabap.
   IF R13 EQ 'X' OR R13D EQ 'X'.
     PERFORM FORM1_11.
     IF R13 EQ 'X'.
       PERFORM DETAILS1.
     ENDIF.
   ELSEIF R17 EQ 'X'.
     PERFORM FORM1_12.
     PERFORM DETAILS1.
   ELSEIF R14 EQ 'X' OR R15 EQ 'X'.
     PERFORM TRANSFER1.
*   ELSEIF R15 EQ 'X'.
*     PERFORM TRANSFER2.
   ELSEIF R16 EQ 'X'.
     PERFORM FORM1_1CC.
     PERFORM DETAILS1.
   ELSEIF RP1 EQ 'X'.
     PERFORM IMPORT.
   ELSEIF RP2 EQ 'X' OR RP3 EQ 'X'.
     PERFORM FORM1_1.
   ELSE.
     PERFORM FORM1_1.
     PERFORM TRANSFER.
   ENDIF.
   IF R11 EQ 'X'.
     PERFORM PROCESS.
   ELSEIF R12 EQ 'X'  OR R12N1 EQ 'X' OR R12HS EQ 'X'
     OR RP2 EQ 'X' OR RP3 EQ 'X' OR RP4 EQ 'X'.
     PERFORM DETAILS.
   ENDIF.
 FORM TRANSFER.
   PDATE = S_BUDAT-LOW.
   PDATE+0(4) = S_BUDAT-LOW+0(4) - 1.

   SELECT WERKS KUNNR FROM T001W INTO TABLE IT_T001W
     WHERE WERKS IN PLANT.
   IF SY-SUBRC NE 0.
     MESSAGE ' NO DATA' TYPE 'E'.
     EXIT.
   ENDIF.
   LOOP AT IT_T001W INTO WA_T001W.
     IF WA_T001W-WERKS EQ '2000'.
       WA_T001W-WERKS = '2000'.
       WA_T001W-KUNNR = 'GHAZIABAD'.
       COLLECT WA_T001W INTO IT_T001W .
       CLEAR WA_T001W.
     ENDIF.
   ENDLOOP.

   SELECT * FROM VBRK INTO TABLE IT_VBRK FOR ALL ENTRIES
      IN IT_T001W WHERE KUNAG EQ IT_T001W-KUNNR AND
     FKDAT GE PDATE AND FKDAT LE S_BUDAT-HIGH AND REGIO
      IN BUSPLACE AND MWSBK GT 0 AND FKSTO NE 'X'
     AND FKART NE 'S1'.
   IF SY-SUBRC EQ 0.
     SELECT * FROM VBRP INTO TABLE IT_VBRP FOR ALL ENTRIES
       IN IT_VBRK WHERE VBELN = IT_VBRK-VBELN.
   ENDIF.
   IF IT_VBRK IS NOT INITIAL.
     SELECT KNUMV KPOSN KSCHL KWERT KBETR KAWRT
       FROM KONV INTO TABLE IT_KONV FOR ALL ENTRIES IN IT_VBRK
       WHERE KNUMV = IT_VBRK-KNUMV
       AND KSCHL IN ('JOCG','JOSG','JOIG','JOUG').
   ENDIF.

   SORT IT_KONV BY KNUMV KPOSN KSCHL.

   IF IT_VBRK IS NOT INITIAL.
     LOOP AT IT_VBRP INTO WA_VBRP.
       READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRP-VBELN.
       IF SY-SUBRC EQ 0.
         CLEAR : DOC.
         DOC =  WA_VBRK-VBELN.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
            AND BLART IN ('RV','EA') AND AWKEY EQ DOC .
*           AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM MARC WHERE MATNR EQ
             WA_VBRP-MATNR AND WERKS EQ WA_VBRP-WERKS AND STEUC IN HSN.
           IF SY-SUBRC EQ 0.
             WA_INV1-STEUC = MARC-STEUC.
*           endif.
             WA_INV1-BELNR = BKPF-BELNR.
             WA_INV1-GJAHR = BKPF-GJAHR.
             WA_INV1-USNAM = BKPF-USNAM.
             WA_INV1-TCODE = BKPF-TCODE.
             WA_INV1-BUDAT = BKPF-BUDAT.
             WA_INV1-BLDAT = BKPF-BLDAT.
             WA_INV1-BLART = BKPF-BLART.
             SELECT SINGLE * FROM KNVI WHERE KUNNR EQ WA_VBRK-KUNAG
                AND ALAND EQ 'IN' AND TATYP EQ 'JOCG'.
             IF SY-SUBRC EQ 0.
               IF KNVI-TAXKD EQ '0'.
                 WA_INV1-VEN_CLASS = KNVI-TAXKD.
                 WA_INV1-VEN_CL = 'Registered'.
               ENDIF.
             ENDIF.
             SELECT SINGLE * FROM J_1IMOCUST WHERE KUNNR EQ WA_VBRK-KUNAG.
             IF SY-SUBRC EQ 0.
               WA_INV1-PAN = J_1IMOCUST-J_1IPANNO.
             ENDIF.
             SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
               BELNR EQ BKPF-BELNR AND GJAHR = BKPF-GJAHR.
             IF SY-SUBRC EQ 0.
               WA_INV1-GSBER = BSEG-GSBER.
               WA_INV1-SGTXT = BSEG-SGTXT.
             ENDIF.
             WA_INV1-XBLNR = BKPF-XBLNR.
             WA_INV1-BUPLA = WA_VBRK-REGIO.
             WA_INV1-VBELN = WA_VBRK-VBELN.
             WA_INV1-NETWR = WA_VBRP-NETWR.
             WA_INV1-MWSBP = WA_VBRP-MWSBP.
             WA_INV1-DMBTR = WA_VBRP-NETWR + WA_VBRP-MWSBP.
             WA_INV1-MENGE = WA_VBRP-FKIMG.
             WA_INV1-MEINS = WA_VBRP-VRKME.
             WA_INV1-GSBER = WA_VBRP-GSBER.
***************************************************************************************************
             READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV
              KPOSN = WA_VBRP-POSNR KSCHL = 'JOCG' BINARY SEARCH.
             IF SY-SUBRC EQ 0.
               WA_INV1-JOCG = WA_KONV-KWERT.
               WA_INV1-TAXABLE = WA_KONV-KAWRT.
               WA_INV1-RATE =  ( WA_KONV-KBETR / 10 ) * 2.
             ENDIF.
             READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV
              KPOSN = WA_VBRP-POSNR KSCHL = 'JOSG' BINARY SEARCH.
             IF SY-SUBRC EQ 0.
               WA_INV1-JOSG = WA_KONV-KWERT.
               WA_INV1-TAXABLE = WA_KONV-KAWRT.
             ENDIF.
             READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV
             KPOSN = WA_VBRP-POSNR KSCHL = 'JOIG' BINARY SEARCH.
             IF SY-SUBRC EQ 0.
               WA_INV1-JOIG = WA_KONV-KWERT.
               WA_INV1-TAXABLE = WA_KONV-KAWRT.
               WA_INV1-RATE =  WA_KONV-KBETR / 10 .
             ENDIF.
             READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV
             KPOSN = WA_VBRP-POSNR KSCHL = 'JOUG' BINARY SEARCH.
             IF SY-SUBRC EQ 0.
               WA_INV1-JOUG = WA_KONV-KWERT.
               WA_INV1-TAXABLE = WA_KONV-KAWRT.
             ENDIF.
***************************************************************************************************

             WA_INV1-VGBEL = WA_VBRP-VGBEL.
             WA_INV1-AUBEL = WA_VBRP-AUBEL.
             WA_INV1-AUPOS = WA_VBRP-AUPOS.
             SELECT SINGLE * FROM T001W WHERE WERKS EQ WA_VBRP-WERKS.
             IF SY-SUBRC EQ 0.
               WA_INV1-VENDOR = T001W-KUNNR.
               WA_INV1-VENDOREG = T001W-REGIO.
               WA_INV1-NAME1 = T001W-NAME1.
               WA_INV1-ORT01 = T001W-ORT01.
               SELECT SINGLE * FROM KNA1 WHERE KUNNR EQ T001W-KUNNR.
               IF SY-SUBRC EQ 0.
                 WA_INV1-STCD3 = KNA1-STCD3.
               ENDIF.
             ENDIF.
*                 endif.
             COLLECT WA_INV1 INTO IT_INV1.
             CLEAR WA_INV1.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDLOOP.
   ENDIF.


   LOOP AT IT_INV1 INTO WA_INV1.
     IF WA_INV1-BLART GE 'A1' AND WA_INV1-BLART LE 'A4'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART GE 'B6' AND WA_INV1-BLART LE 'B9'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART GE 'C1' AND WA_INV1-BLART LE 'D9'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART GE 'DA' AND WA_INV1-BLART LE 'DE'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART GE 'F1' AND WA_INV1-BLART LE 'IA'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART GE 'K1' AND WA_INV1-BLART LE 'K4'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART GE 'L1' AND WA_INV1-BLART LE 'LL'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART GE 'N1' AND WA_INV1-BLART LE 'NL'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART GE 'P1' AND WA_INV1-BLART LE 'RA'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART GE 'U1' AND WA_INV1-BLART LE 'U4'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART EQ 'DZ'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART EQ 'MA'.
       DELETE IT_INV1.
     ENDIF.
     IF WA_INV1-BLART EQ 'ZA'.
       DELETE IT_INV1.
     ENDIF.
   ENDLOOP.


   IF IT_INV1 IS NOT INITIAL.
     LOOP AT IT_INV1 INTO WA_INV1.
       SELECT SINGLE * FROM MKPF WHERE BUDAT IN S_BUDAT AND
         XBLNR EQ WA_INV1-VGBEL AND VGART IN ('WE','WF').
       IF SY-SUBRC EQ 0.
         WA_TAR1-MBLNR = MKPF-MBLNR.
         WA_TAR1-MKPF_BUDAT = MKPF-BUDAT.
         WA_TAR1-TCODE = WA_INV1-TCODE.
         WA_TAR1-BLART = WA_INV1-BLART.
         WA_TAR1-BELNR = WA_INV1-BELNR.
         WA_TAR1-USNAM = WA_INV1-USNAM.
         WA_TAR1-GJAHR = WA_INV1-GJAHR.
         WA_TAR1-BUDAT = WA_INV1-BUDAT.
         WA_TAR1-BLDAT = WA_INV1-BLDAT.
         WA_TAR1-VBELN = WA_INV1-VBELN.
         WA_TAR1-STEUC = WA_INV1-STEUC.
         WA_TAR1-XBLNR = WA_INV1-XBLNR.
         WA_TAR1-BUPLA = WA_INV1-BUPLA.
         WA_TAR1-GSBER = WA_INV1-GSBER.
         WA_TAR1-VENDOR = WA_INV1-VENDOR.
         WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
         WA_TAR1-DMBTR = WA_INV1-DMBTR.
         WA_TAR1-NETWR = WA_INV1-NETWR.
         WA_TAR1-MWSBP = WA_INV1-MWSBP.
         WA_TAR1-JOIG = WA_INV1-JOIG.
         WA_TAR1-JOSG = WA_INV1-JOSG.
         WA_TAR1-JOCG = WA_INV1-JOCG.
         WA_TAR1-JOUG = WA_INV1-JOUG.
         WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
         WA_TAR1-MENGE = WA_INV1-MENGE.
         WA_TAR1-MEINS = WA_INV1-MEINS.
         WA_TAR1-RATE = WA_INV1-RATE.
         COLLECT WA_TAR1 INTO IT_TAR1.
         CLEAR WA_TAR1.
********************************
       ELSE.
         CLEAR: VGBEL1.
         VGBEL1 = WA_INV1-VGBEL.
         SHIFT VGBEL1 LEFT DELETING LEADING '0'.

*************************************************new condition on 20.10.21**********************

         SELECT SINGLE * FROM EKBE WHERE EBELN EQ WA_INV1-AUBEL AND
            EBELP EQ WA_INV1-AUPOS AND BEWTP EQ 'E' AND BUDAT GE S_BUDAT-LOW
              AND BUDAT LE S_BUDAT-HIGH AND VBELN_ST EQ WA_INV1-VGBEL.
         IF SY-SUBRC EQ 0.
           WA_TAR1-MBLNR = EKBE-BELNR.
           WA_TAR1-MKPF_BUDAT = EKBE-BUDAT.
           WA_TAR1-TCODE = WA_INV1-TCODE.
           WA_TAR1-BLART = WA_INV1-BLART.
           WA_TAR1-BELNR = WA_INV1-BELNR.
           WA_TAR1-USNAM = WA_INV1-USNAM.
           WA_TAR1-GJAHR = WA_INV1-GJAHR.
           WA_TAR1-BUDAT = WA_INV1-BUDAT.
           WA_TAR1-BLDAT = WA_INV1-BLDAT.
           WA_TAR1-VBELN = WA_INV1-VBELN.
           WA_TAR1-STEUC =   WA_INV1-STEUC.
           WA_TAR1-XBLNR = WA_INV1-XBLNR.
           WA_TAR1-BUPLA = WA_INV1-BUPLA.
           WA_TAR1-GSBER = WA_INV1-GSBER.
           WA_TAR1-VENDOR = WA_INV1-VENDOR.
           WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
           WA_TAR1-DMBTR = WA_INV1-DMBTR.
           WA_TAR1-NETWR = WA_INV1-NETWR.
           WA_TAR1-RATE = WA_INV1-RATE.
           WA_TAR1-MWSBP = WA_INV1-MWSBP.
           WA_TAR1-JOIG = WA_INV1-JOIG.
           WA_TAR1-JOSG = WA_INV1-JOSG.
           WA_TAR1-JOCG = WA_INV1-JOCG.
           WA_TAR1-JOUG = WA_INV1-JOUG.
           WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
           WA_TAR1-MENGE = WA_INV1-MENGE.
           WA_TAR1-MEINS = WA_INV1-MEINS.
           COLLECT WA_TAR1 INTO IT_TAR1.
           CLEAR WA_TAR1.
         ELSE.
***************************************************************************************************

           SELECT SINGLE * FROM MKPF WHERE BUDAT IN S_BUDAT AND
              XBLNR EQ VGBEL1 AND VGART IN ('WE','WF').
           IF SY-SUBRC EQ 0.
             WA_TAR1-MBLNR = MKPF-MBLNR.
             WA_TAR1-MKPF_BUDAT = MKPF-BUDAT.
             WA_TAR1-TCODE = WA_INV1-TCODE.
             WA_TAR1-BLART = WA_INV1-BLART.
             WA_TAR1-BELNR = WA_INV1-BELNR.
             WA_TAR1-USNAM = WA_INV1-USNAM.
             WA_TAR1-GJAHR = WA_INV1-GJAHR.
             WA_TAR1-BUDAT = WA_INV1-BUDAT.
             WA_TAR1-BLDAT = WA_INV1-BLDAT.
             WA_TAR1-VBELN = WA_INV1-VBELN.
             WA_TAR1-STEUC = WA_INV1-STEUC.
             WA_TAR1-XBLNR = WA_INV1-XBLNR.
             WA_TAR1-BUPLA = WA_INV1-BUPLA.
             WA_TAR1-GSBER = WA_INV1-GSBER.
             WA_TAR1-VENDOR = WA_INV1-VENDOR.
             WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
             WA_TAR1-DMBTR = WA_INV1-DMBTR.
             WA_TAR1-NETWR = WA_INV1-NETWR.
             WA_TAR1-MWSBP = WA_INV1-MWSBP.
             WA_TAR1-JOIG = WA_INV1-JOIG.
             WA_TAR1-JOSG = WA_INV1-JOSG.
             WA_TAR1-JOCG = WA_INV1-JOCG.
             WA_TAR1-JOUG = WA_INV1-JOUG.
             WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
             WA_TAR1-MENGE = WA_INV1-MENGE.
             WA_TAR1-MEINS = WA_INV1-MEINS.
             WA_TAR1-RATE = WA_INV1-RATE.
             COLLECT WA_TAR1 INTO IT_TAR1.
             CLEAR WA_TAR1.

******************************************************
           ELSE.
             SELECT SINGLE * FROM MKPF WHERE BUDAT IN S_BUDAT AND XBLNR EQ WA_INV1-VGBEL .

             IF SY-SUBRC EQ 0.
               SELECT SINGLE * FROM MSEG WHERE MBLNR EQ MKPF-MBLNR AND MJAHR EQ MKPF-MJAHR.
               IF SY-SUBRC EQ 0.

                 SELECT SINGLE * FROM EKBE WHERE EBELN EQ MSEG-EBELN AND
                   EBELP EQ MSEG-EBELP AND BEWTP EQ 'E' AND
                   ELIKZ EQ 'X' AND BUDAT GE S_BUDAT-LOW
                   AND BUDAT LE S_BUDAT-HIGH.
                 IF SY-SUBRC EQ 0.

                   WA_TAR1-MBLNR = EKBE-BELNR.
                   WA_TAR1-MKPF_BUDAT = EKBE-BUDAT.
                   WA_TAR1-TCODE = WA_INV1-TCODE.
                   WA_TAR1-BLART = WA_INV1-BLART.
                   WA_TAR1-BELNR = WA_INV1-BELNR.
                   WA_TAR1-USNAM = WA_INV1-USNAM.
                   WA_TAR1-GJAHR = WA_INV1-GJAHR.
                   WA_TAR1-BUDAT = WA_INV1-BUDAT.
                   WA_TAR1-BLDAT = WA_INV1-BLDAT.
                   WA_TAR1-VBELN = WA_INV1-VBELN.
                   WA_TAR1-STEUC = WA_INV1-STEUC.
                   WA_TAR1-XBLNR = WA_INV1-XBLNR.
                   WA_TAR1-BUPLA = WA_INV1-BUPLA.
                   WA_TAR1-GSBER = WA_INV1-GSBER.
                   WA_TAR1-VENDOR = WA_INV1-VENDOR.
                   WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
                   WA_TAR1-DMBTR = WA_INV1-DMBTR.
                   WA_TAR1-NETWR = WA_INV1-NETWR.
                   WA_TAR1-RATE = WA_INV1-RATE.
                   WA_TAR1-MWSBP = WA_INV1-MWSBP.
                   WA_TAR1-JOIG = WA_INV1-JOIG.
                   WA_TAR1-JOSG = WA_INV1-JOSG.
                   WA_TAR1-JOCG = WA_INV1-JOCG.
                   WA_TAR1-JOUG = WA_INV1-JOUG.
                   WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
                   WA_TAR1-MENGE = WA_INV1-MENGE.
                   WA_TAR1-MEINS = WA_INV1-MEINS.
                   COLLECT WA_TAR1 INTO IT_TAR1.
                   CLEAR WA_TAR1.
                 ELSE.

**************************************
                   SELECT SINGLE * FROM MKPF WHERE BUDAT IN
                     S_BUDAT AND XBLNR EQ WA_INV1-VBELN AND
                     VGART IN ('WE','WF').
                   IF SY-SUBRC EQ 0.
                     WA_TAR1-MBLNR = MKPF-MBLNR.
                     WA_TAR1-MKPF_BUDAT = MKPF-BUDAT.
                     WA_TAR1-TCODE = WA_INV1-TCODE.
                     WA_TAR1-BLART = WA_INV1-BLART.
                     WA_TAR1-BELNR = WA_INV1-BELNR.
                     WA_TAR1-USNAM = WA_INV1-USNAM.
                     WA_TAR1-GJAHR = WA_INV1-GJAHR.
                     WA_TAR1-BUDAT = WA_INV1-BUDAT.
                     WA_TAR1-BLDAT = WA_INV1-BLDAT.
                     WA_TAR1-VBELN = WA_INV1-VBELN.
                     WA_TAR1-STEUC = WA_INV1-STEUC.
                     WA_TAR1-XBLNR = WA_INV1-XBLNR.
                     WA_TAR1-BUPLA = WA_INV1-BUPLA.
                     WA_TAR1-GSBER = WA_INV1-GSBER.
                     WA_TAR1-VENDOR = WA_INV1-VENDOR.
                     WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
                     WA_TAR1-DMBTR = WA_INV1-DMBTR.
                     WA_TAR1-NETWR = WA_INV1-NETWR.
                     WA_TAR1-MWSBP = WA_INV1-MWSBP.
                     WA_TAR1-JOIG = WA_INV1-JOIG.
                     WA_TAR1-JOSG = WA_INV1-JOSG.
                     WA_TAR1-JOCG = WA_INV1-JOCG.
                     WA_TAR1-JOUG = WA_INV1-JOUG.
                     WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
                     WA_TAR1-MENGE = WA_INV1-MENGE.
                     WA_TAR1-MEINS = WA_INV1-MEINS.
                     WA_TAR1-RATE = WA_INV1-RATE.
                     COLLECT WA_TAR1 INTO IT_TAR1.
                     CLEAR WA_TAR1.
                   ELSE.
                     CLEAR : XBLNR1.
                     XBLNR1 = WA_INV1-VBELN.
                     SHIFT XBLNR1 LEFT DELETING LEADING '0'.
                     SELECT SINGLE * FROM MKPF WHERE BUDAT IN S_BUDAT
                       AND XBLNR EQ XBLNR1 AND VGART IN ('WE','WF').
                     IF SY-SUBRC EQ 0.

                       WA_TAR1-MBLNR = MKPF-MBLNR.
                       WA_TAR1-MKPF_BUDAT = MKPF-BUDAT.
                       WA_TAR1-TCODE = WA_INV1-TCODE.
                       WA_TAR1-BLART = WA_INV1-BLART.
                       WA_TAR1-BELNR = WA_INV1-BELNR.
                       WA_TAR1-USNAM = WA_INV1-USNAM.
                       WA_TAR1-GJAHR = WA_INV1-GJAHR.
                       WA_TAR1-BUDAT = WA_INV1-BUDAT.
                       WA_TAR1-BLDAT = WA_INV1-BLDAT.
                       WA_TAR1-VBELN = WA_INV1-VBELN.
                       WA_TAR1-STEUC = WA_INV1-STEUC.
                       WA_TAR1-XBLNR = WA_INV1-XBLNR.
                       WA_TAR1-BUPLA = WA_INV1-BUPLA.
                       WA_TAR1-GSBER = WA_INV1-GSBER.
                       WA_TAR1-VENDOR = WA_INV1-VENDOR.
                       WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
                       WA_TAR1-DMBTR = WA_INV1-DMBTR.
                       WA_TAR1-NETWR = WA_INV1-NETWR.
                       WA_TAR1-MWSBP = WA_INV1-MWSBP.
                       WA_TAR1-JOIG = WA_INV1-JOIG.
                       WA_TAR1-JOSG = WA_INV1-JOSG.
                       WA_TAR1-JOCG = WA_INV1-JOCG.
                       WA_TAR1-JOUG = WA_INV1-JOUG.
                       WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
                       WA_TAR1-MENGE = WA_INV1-MENGE.
                       WA_TAR1-MEINS = WA_INV1-MEINS.
                       WA_TAR1-RATE = WA_INV1-RATE.
                       COLLECT WA_TAR1 INTO IT_TAR1.
                       CLEAR WA_TAR1.
                     ELSE.
**************************************
                       SELECT SINGLE * FROM MKPF WHERE BUDAT IN S_BUDAT AND XBLNR
                         EQ WA_INV1-VBELN AND VGART IN ('WE','WF').
                       IF SY-SUBRC EQ 0.
                         WA_TAR1-MBLNR = MKPF-MBLNR.
                         WA_TAR1-MKPF_BUDAT = MKPF-BUDAT.
                         WA_TAR1-TCODE = WA_INV1-TCODE.
                         WA_TAR1-BLART = WA_INV1-BLART.
                         WA_TAR1-BELNR = WA_INV1-BELNR.
                         WA_TAR1-USNAM = WA_INV1-USNAM.
                         WA_TAR1-GJAHR = WA_INV1-GJAHR.
                         WA_TAR1-BUDAT = WA_INV1-BUDAT.
                         WA_TAR1-BLDAT = WA_INV1-BLDAT.
                         WA_TAR1-VBELN = WA_INV1-VBELN.
                         WA_TAR1-STEUC = WA_INV1-STEUC.
                         WA_TAR1-XBLNR = WA_INV1-XBLNR.
                         WA_TAR1-BUPLA = WA_INV1-BUPLA.
                         WA_TAR1-GSBER = WA_INV1-GSBER.
                         WA_TAR1-VENDOR = WA_INV1-VENDOR.
                         WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
                         WA_TAR1-DMBTR = WA_INV1-DMBTR.
                         WA_TAR1-NETWR = WA_INV1-NETWR.
                         WA_TAR1-MWSBP = WA_INV1-MWSBP.
                         WA_TAR1-JOIG = WA_INV1-JOIG.
                         WA_TAR1-JOSG = WA_INV1-JOSG.
                         WA_TAR1-JOCG = WA_INV1-JOCG.
                         WA_TAR1-JOUG = WA_INV1-JOUG.
                         WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
                         WA_TAR1-MENGE = WA_INV1-MENGE.
                         WA_TAR1-MEINS = WA_INV1-MEINS.
                         WA_TAR1-RATE = WA_INV1-RATE.
                         COLLECT WA_TAR1 INTO IT_TAR1.
                         CLEAR WA_TAR1.
                       ENDIF.
**********************************************
                     ENDIF.
                   ENDIF.
*******************************************

                 ENDIF.
               ENDIF.
             ELSE.
************************** migo receipt**************************

               SELECT SINGLE * FROM EKBE WHERE EBELN EQ WA_INV1-AUBEL AND
                  EBELP EQ WA_INV1-AUPOS AND BEWTP EQ 'E' AND
                 VBELN_ST EQ WA_INV1-VGBEL AND
                  BUDAT GE S_BUDAT-LOW AND BUDAT LE S_BUDAT-HIGH.  "8.6.22
               IF SY-SUBRC EQ 0.
                 WA_TAR1-MBLNR = EKBE-BELNR.
                 WA_TAR1-MKPF_BUDAT = EKBE-BUDAT.
                 WA_TAR1-TCODE = WA_INV1-TCODE.
                 WA_TAR1-BLART = WA_INV1-BLART.
                 WA_TAR1-BELNR = WA_INV1-BELNR.
                 WA_TAR1-USNAM = WA_INV1-USNAM.
                 WA_TAR1-GJAHR = WA_INV1-GJAHR.
                 WA_TAR1-BUDAT = WA_INV1-BUDAT.
                 WA_TAR1-BLDAT = WA_INV1-BLDAT.
                 WA_TAR1-VBELN = WA_INV1-VBELN.
                 WA_TAR1-STEUC =   WA_INV1-STEUC.
                 WA_TAR1-XBLNR = WA_INV1-XBLNR.
                 WA_TAR1-BUPLA = WA_INV1-BUPLA.
                 WA_TAR1-GSBER = WA_INV1-GSBER.
                 WA_TAR1-VENDOR = WA_INV1-VENDOR.
                 WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
                 WA_TAR1-DMBTR = WA_INV1-DMBTR.
                 WA_TAR1-NETWR = WA_INV1-NETWR.
                 WA_TAR1-RATE = WA_INV1-RATE.
                 WA_TAR1-MWSBP = WA_INV1-MWSBP.
                 WA_TAR1-JOIG = WA_INV1-JOIG.
                 WA_TAR1-JOSG = WA_INV1-JOSG.
                 WA_TAR1-JOCG = WA_INV1-JOCG.
                 WA_TAR1-JOUG = WA_INV1-JOUG.
                 WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
                 WA_TAR1-MENGE = WA_INV1-MENGE.
                 WA_TAR1-MEINS = WA_INV1-MEINS.
                 COLLECT WA_TAR1 INTO IT_TAR1.
                 CLEAR WA_TAR1.
               ELSE.
*************** new condition **************

                 SELECT SINGLE * FROM MKPF WHERE BUDAT IN S_BUDAT AND XBLNR
                    EQ WA_INV1-VBELN AND VGART IN ('WE','WF').
                 IF SY-SUBRC EQ 0.
                   WA_TAR1-MBLNR = MKPF-MBLNR.
                   WA_TAR1-MKPF_BUDAT = MKPF-BUDAT.
                   WA_TAR1-TCODE = WA_INV1-TCODE.
                   WA_TAR1-BLART = WA_INV1-BLART.
                   WA_TAR1-BELNR = WA_INV1-BELNR.
                   WA_TAR1-USNAM = WA_INV1-USNAM.
                   WA_TAR1-GJAHR = WA_INV1-GJAHR.
                   WA_TAR1-BUDAT = WA_INV1-BUDAT.
                   WA_TAR1-BLDAT = WA_INV1-BLDAT.
                   WA_TAR1-VBELN = WA_INV1-VBELN.
                   WA_TAR1-STEUC = WA_INV1-STEUC.
                   WA_TAR1-XBLNR = WA_INV1-XBLNR.
                   WA_TAR1-BUPLA = WA_INV1-BUPLA.
                   WA_TAR1-GSBER = WA_INV1-GSBER.
                   WA_TAR1-VENDOR = WA_INV1-VENDOR.
                   WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
                   WA_TAR1-DMBTR = WA_INV1-DMBTR.
                   WA_TAR1-NETWR = WA_INV1-NETWR.
                   WA_TAR1-MWSBP = WA_INV1-MWSBP.
                   WA_TAR1-JOIG = WA_INV1-JOIG.
                   WA_TAR1-JOSG = WA_INV1-JOSG.
                   WA_TAR1-JOCG = WA_INV1-JOCG.
                   WA_TAR1-JOUG = WA_INV1-JOUG.
                   WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
                   WA_TAR1-MENGE = WA_INV1-MENGE.
                   WA_TAR1-MEINS = WA_INV1-MEINS.
                   WA_TAR1-RATE = WA_INV1-RATE.
                   COLLECT WA_TAR1 INTO IT_TAR1.
                   CLEAR WA_TAR1.
                 ELSE.
                   CLEAR : XBLNR1.
                   XBLNR1 = WA_INV1-VBELN.
                   SHIFT XBLNR1 LEFT DELETING LEADING '0'.
                   SELECT SINGLE * FROM MKPF WHERE BUDAT IN S_BUDAT
                     AND XBLNR EQ XBLNR1 AND VGART IN ('WE','WF').
                   IF SY-SUBRC EQ 0.
                     WA_TAR1-MBLNR = MKPF-MBLNR.
                     WA_TAR1-MKPF_BUDAT = MKPF-BUDAT.
                     WA_TAR1-TCODE = WA_INV1-TCODE.
                     WA_TAR1-BLART = WA_INV1-BLART.
                     WA_TAR1-BELNR = WA_INV1-BELNR.
                     WA_TAR1-USNAM = WA_INV1-USNAM.
                     WA_TAR1-GJAHR = WA_INV1-GJAHR.
                     WA_TAR1-BUDAT = WA_INV1-BUDAT.
                     WA_TAR1-BLDAT = WA_INV1-BLDAT.
                     WA_TAR1-VBELN = WA_INV1-VBELN.
                     WA_TAR1-STEUC = WA_INV1-STEUC.
                     WA_TAR1-XBLNR = WA_INV1-XBLNR.
                     WA_TAR1-BUPLA = WA_INV1-BUPLA.
                     WA_TAR1-GSBER = WA_INV1-GSBER.
                     WA_TAR1-VENDOR = WA_INV1-VENDOR.
                     WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
                     WA_TAR1-DMBTR = WA_INV1-DMBTR.
                     WA_TAR1-NETWR = WA_INV1-NETWR.
                     WA_TAR1-MWSBP = WA_INV1-MWSBP.
                     WA_TAR1-JOIG = WA_INV1-JOIG.
                     WA_TAR1-JOSG = WA_INV1-JOSG.
                     WA_TAR1-JOCG = WA_INV1-JOCG.
                     WA_TAR1-JOUG = WA_INV1-JOUG.
                     WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
                     WA_TAR1-MENGE = WA_INV1-MENGE.
                     WA_TAR1-MEINS = WA_INV1-MEINS.
                     WA_TAR1-RATE = WA_INV1-RATE.
                     COLLECT WA_TAR1 INTO IT_TAR1.
                     CLEAR WA_TAR1.
                   ELSE.

***********************new1*****************************

                     CLEAR : XBLNR1.
                     XBLNR1 = WA_INV1-VBELN.
                     UNPACK XBLNR1 TO XBLNR1.
                     SELECT SINGLE * FROM MKPF WHERE BUDAT IN S_BUDAT
                        AND XBLNR EQ XBLNR1 AND VGART IN ('WE','WF').
                     IF SY-SUBRC EQ 0.
                       WA_TAR1-MBLNR = MKPF-MBLNR.
                       WA_TAR1-MKPF_BUDAT = MKPF-BUDAT.
                       WA_TAR1-TCODE = WA_INV1-TCODE.
                       WA_TAR1-BLART = WA_INV1-BLART.
                       WA_TAR1-BELNR = WA_INV1-BELNR.
                       WA_TAR1-USNAM = WA_INV1-USNAM.
                       WA_TAR1-GJAHR = WA_INV1-GJAHR.
                       WA_TAR1-BUDAT = WA_INV1-BUDAT.
                       WA_TAR1-BLDAT = WA_INV1-BLDAT.
                       WA_TAR1-VBELN = WA_INV1-VBELN.
                       WA_TAR1-STEUC = WA_INV1-STEUC.
                       WA_TAR1-XBLNR = WA_INV1-XBLNR.
                       WA_TAR1-BUPLA = WA_INV1-BUPLA.
                       WA_TAR1-GSBER = WA_INV1-GSBER.
                       WA_TAR1-VENDOR = WA_INV1-VENDOR.
                       WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
                       WA_TAR1-DMBTR = WA_INV1-DMBTR.
                       WA_TAR1-NETWR = WA_INV1-NETWR.
                       WA_TAR1-MWSBP = WA_INV1-MWSBP.
                       WA_TAR1-JOIG = WA_INV1-JOIG.
                       WA_TAR1-JOSG = WA_INV1-JOSG.
                       WA_TAR1-JOCG = WA_INV1-JOCG.
                       WA_TAR1-JOUG = WA_INV1-JOUG.
                       WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
                       WA_TAR1-MENGE = WA_INV1-MENGE.
                       WA_TAR1-MEINS = WA_INV1-MEINS.
                       WA_TAR1-RATE = WA_INV1-RATE.
                       COLLECT WA_TAR1 INTO IT_TAR1.
                       CLEAR WA_TAR1.
                     ENDIF.
********************************************************

                   ENDIF.
                 ENDIF.

*                 ENDIF.
***********************************
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDLOOP.
   ENDIF.


   LOOP AT IT_TAR1 INTO WA_TAR1.

     WA_TAR2-BELNR = WA_TAR1-BELNR.

     WA_TAR2-GJAHR = WA_TAR1-GJAHR.

     WA_TAR2-VBELN = WA_TAR1-VBELN.
     WA_TAR2-STEUC = WA_TAR1-STEUC.
     WA_TAR2-MENGE = WA_TAR1-MENGE.
     WA_TAR2-MEINS = WA_TAR1-MEINS.
     WA_TAR2-DMBTR = WA_TAR1-DMBTR.
     WA_TAR2-NETWR = WA_TAR1-NETWR.
     WA_TAR2-MWSBP = WA_TAR1-MWSBP.
     WA_TAR2-JOIG = WA_TAR1-JOIG.
     WA_TAR2-JOSG = WA_TAR1-JOSG.
     WA_TAR2-JOCG = WA_TAR1-JOCG.
     WA_TAR2-JOUG = WA_TAR1-JOUG.
     WA_TAR2-RATE = WA_TAR1-RATE.
     WA_TAR2-TAXABLE = WA_TAR1-TAXABLE.
     COLLECT WA_TAR2 INTO IT_TAR2.
     CLEAR WA_TAR2.
   ENDLOOP.

   SORT IT_TAR2 BY BELNR STEUC.

   LOOP AT IT_TAR2 INTO WA_TAR2.

     WA_TAR3-BELNR = WA_TAR2-BELNR.
     WA_TAR3-VBELN = WA_TAR2-VBELN.
     WA_TAR3-STEUC = WA_TAR2-STEUC.
     WA_TAR3-MENGE = WA_TAR2-MENGE.
     WA_TAR3-MEINS = WA_TAR2-MEINS.
     WA_TAR3-DMBTR = WA_TAR2-DMBTR.
     WA_TAR3-HWSTE = WA_TAR2-MWSBP.
     WA_TAR3-HWBAS = WA_TAR2-TAXABLE.
     WA_TAR3-IGST = WA_TAR2-JOIG.
     WA_TAR3-CGST = WA_TAR2-JOCG.
     WA_TAR3-SGST = WA_TAR2-JOSG.
     WA_TAR3-UGST = WA_TAR2-JOUG.
     WA_TAR3-RATE = WA_TAR2-RATE.
     READ TABLE IT_TAR1 INTO WA_TAR1 WITH KEY
             BELNR = WA_TAR2-BELNR
             GJAHR = WA_TAR2-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAR3-TCODE = WA_TAR1-TCODE.
       WA_TAR3-XBLNR = WA_TAR1-XBLNR.
       WA_TAR3-MBLNR = WA_TAR1-MBLNR.
       WA_TAR3-MKPF_BUDAT = WA_TAR1-MKPF_BUDAT.
       WA_TAR3-USNAM = WA_TAR1-USNAM.
       WA_TAR3-BUDAT = WA_TAR1-BUDAT.
       WA_TAR3-BLDAT = WA_TAR1-BLDAT.
       WA_TAR3-XBLNR = WA_TAR1-XBLNR.
       WA_TAR3-BUPLA = WA_TAR1-BUPLA.
       WA_TAR3-BLART = WA_TAR1-BLART.
       WA_TAR3-VENDOR = WA_TAR1-VENDOR.
       WA_TAR3-VENDOREG = WA_TAR1-VENDOREG.
       WA_TAR3-GSBER = WA_TAR1-GSBER.
     ENDIF.
     COLLECT WA_TAR3 INTO IT_TAR3.
     CLEAR WA_TAR3.
   ENDLOOP.

   LOOP AT IT_TAR3 INTO WA_TAR3.
***     SOC By CK
      WA_TAS3-BELNR = WA_TAR3-BELNR.
***     SOC By CK
     WA_TAS3-BELNR = WA_TAR3-BELNR.
     WA_TAS3-VBELN = WA_TAR3-VBELN.
     WA_TAS3-STEUC = WA_TAR3-STEUC.
     WA_TAS3-MENGE = WA_TAR3-MENGE.
     WA_TAS3-MEINS = WA_TAR3-MEINS.
     WA_TAS3-DMBTR = WA_TAR3-DMBTR.
*  WA_TAS3-,WA_TAR3-NETWR,
     WA_TAS3-HWSTE = WA_TAR3-HWSTE.
     WA_TAS3-HWBAS = WA_TAR3-HWBAS.
     WA_TAS3-IGST = WA_TAR3-IGST.
     WA_TAS3-CGST = WA_TAR3-CGST.
     WA_TAS3-SGST = WA_TAR3-SGST.
     WA_TAS3-UGST = WA_TAR3-UGST.
     WA_TAS3-RATE = WA_TAR3-RATE.

     SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
       BELNR EQ WA_TAR3-BELNR AND GJAHR = WA_TAR3-GJAHR AND
        HSN_SAC = WA_TAR3-STEUC.
     IF SY-SUBRC EQ 0.
       WA_TAS3-MWSKZ = BSEG-MWSKZ.
     ENDIF.

     WA_TAS3-TCODE = WA_TAR3-TCODE.
     WA_TAS3-GSBER = WA_TAR3-GSBER.
     WA_TAS3-XBLNR = WA_TAR3-XBLNR.
     WA_TAS3-MBLNR = WA_TAR3-MBLNR.
     SELECT SINGLE * FROM MSEG WHERE
        MBLNR EQ WA_TAR3-MBLNR AND
        WERKS NE SPACE.
     IF SY-SUBRC EQ 0.
       WA_TAS3-WERKS = MSEG-WERKS.
     ENDIF.
     WA_TAS3-MKPF_BUDAT = WA_TAR3-MKPF_BUDAT.
     WA_TAS3-USNAM = WA_TAR3-USNAM.
     WA_TAS3-BUDAT = WA_TAR3-BUDAT.
     WA_TAS3-BLDAT = WA_TAR3-BLDAT.
     WA_TAS3-XBLNR = WA_TAR3-XBLNR.
     WA_TAS3-BUPLA = WA_TAR3-BUPLA.
     WA_TAS3-BLART = WA_TAR3-BLART.
     WA_TAS3-LIFNR = WA_TAR3-VENDOR.
     SELECT SINGLE * FROM T001W WHERE
            KUNNR EQ WA_TAR3-VENDOR.
     IF SY-SUBRC EQ 0.
       WA_TAS3-NAME1 = T001W-NAME1.
       WA_TAS3-ORT01 = T001W-ORT01.
       WA_TAS3-VENREG = T001W-REGIO.
     ENDIF.
     SELECT SINGLE * FROM KNA1 WHERE KUNNR EQ WA_TAR3-VENDOR.
     IF SY-SUBRC EQ 0.
       WA_TAS3-STCD3 = KNA1-STCD3.
       WA_TAS3-SCODE = KNA1-STCD3+0(2).

       CLEAR : SCODE.
       SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN' AND
          BLAND EQ WA_TAS3-VENREG.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN' AND
           LAND1 EQ 'IN' AND BLAND EQ WA_TAS3-VENREG.
         IF SY-SUBRC EQ 0.
           CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
           WA_TAS3-SCODE = SCODE.
         ENDIF.
       ENDIF.

       SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER EQ KNA1-ADRNR.
       IF SY-SUBRC EQ 0.
         WA_TAS3-ADR1 = ADRC-NAME1.
         WA_TAS3-ADR2 = ADRC-NAME2.
         WA_TAS3-ADR3 = ADRC-NAME3.
         WA_TAS3-ADR4 = ADRC-NAME4.
         WA_TAS3-ADR5 = ADRC-STR_SUPPL1.
         WA_TAS3-ADR6 = ADRC-STR_SUPPL2.
       ENDIF.
       SELECT SINGLE * FROM KNVI WHERE KUNNR EQ WA_TAR3-VENDOR
         AND ALAND EQ 'IN' AND TATYP EQ 'JOCG'.
       IF SY-SUBRC EQ 0.
         IF KNVI-TAXKD EQ '0'.
           WA_TAS3-VEN_CLASS = KNVI-TAXKD.
           WA_TAS3-VEN_CL = 'Registered'.
         ENDIF.
       ENDIF.
       SELECT SINGLE * FROM J_1IMOCUST WHERE KUNNR EQ WA_TAR3-VENDOR.
       IF SY-SUBRC EQ 0.
         WA_TAS3-PAN = J_1IMOCUST-J_1IPANNO.
       ENDIF.
     ENDIF.

***************************************
     SELECT SINGLE * FROM VBRK WHERE VBELN EQ WA_TAS3-VBELN.
     IF SY-SUBRC EQ 0.
       IF VBRK-FKDAT+4(2) GE '04'.
         YEAR = VBRK-FKDAT+0(4).
       ELSE.
         YEAR = VBRK-FKDAT+0(4) - 1.
       ENDIF.
     ENDIF.
*    WRITE : / '*',WA_TAB5-VBELN.
     SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000' AND
       GJAHR EQ YEAR AND BLART EQ 'RE' AND
         TCODE IN ( 'J_1IG_INV','MB0A' )
        AND XBLNR EQ WA_TAS3-VBELN.
     IF SY-SUBRC EQ 0.
       WA_TAS3-RECP = BKPF-BELNR.
       WA_TAS3-RECP_DT = BKPF-BUDAT.
       WA_TAS3-RECPYR = BKPF-GJAHR.
     ELSE.
       SELECT SINGLE * FROM VBRK WHERE VBELN = WA_TAS3-VBELN.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000' AND
           GJAHR EQ YEAR AND BLART EQ 'RE' AND TCODE
           IN ( 'J_1IG_INV', 'MB0A' ) AND XBLNR EQ VBRK-XBLNR.
         IF SY-SUBRC EQ 0.
           WA_TAS3-RECP = BKPF-BELNR.
           WA_TAS3-RECP_DT = BKPF-BUDAT.
           WA_TAS3-RECPYR = BKPF-GJAHR.
         ENDIF.
       ENDIF.
     ENDIF.

     COLLECT WA_TAS3 INTO IT_TAS3.
     CLEAR WA_TAS3.
   ENDLOOP.

   LOOP AT IT_TAS3 INTO WA_TAS3.
*
     SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000' AND
       BELNR EQ WA_TAS3-BELNR AND GJAHR = WA_TAS3-GJAHR
       AND XREVERSAL NE ' '.
     IF SY-SUBRC EQ 0.
       WA_TAS3-RSTAT = 'REVERSED'.
       MODIFY IT_TAS3 FROM WA_TAS3 TRANSPORTING RSTAT.
     ENDIF.
   ENDLOOP.
 ENDFORM.                    "transfer


*&---------------------------------------------------------------------*
*&      Form  form1_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM FORM1_11.
   CLEAR : IT_BKPF,WA_BKPF.
*   IF nskpv = 'X'.
   SELECT * FROM BKPF INTO TABLE IT_BKPF WHERE
     BUDAT IN S_BUDAT AND  TCODE IN
     ( 'MIRO','MR8M','FB60','FB08','FBCJ','FB01',
       'FB65', 'FB50', 'FB05', 'FBR2','FBVB','ZBCLLR0001' ) .
*     AND XREVERSAL EQ ' '.
   IF SY-SUBRC EQ 0.
     SELECT * FROM BSEG INTO TABLE IT_BSEG FOR ALL
       ENTRIES IN IT_BKPF WHERE BUKRS EQ '1000' AND
       BELNR EQ IT_BKPF-BELNR AND
       GJAHR = IT_BKPF-GJAHR AND HSN_SAC IN HSN.
*          AND BUPLA IN BUSPLACE.
   ENDIF.

   LOOP AT IT_BKPF INTO WA_BKPF.
     IF WA_BKPF-BLART GE 'A1' AND WA_BKPF-BLART LE 'A6'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.

     ENDIF.
     IF WA_BKPF-BLART GE 'B6' AND WA_BKPF-BLART LE 'B9'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'C1' AND WA_BKPF-BLART LE 'D9'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'DA' AND WA_BKPF-BLART LE 'DE'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'F1' AND WA_BKPF-BLART LE 'IA'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'K1' AND WA_BKPF-BLART LE 'K4'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'L1' AND WA_BKPF-BLART LE 'LL'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'N1' AND WA_BKPF-BLART LE 'NL'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.

     IF WA_BKPF-BUDAT GE NDATE1.
       IF WA_BKPF-BLART GE 'P1' AND WA_BKPF-BLART LE 'PR'.
         MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
         COLLECT WA_BKPF11 INTO IT_BKPF11.
         DELETE IT_BKPF.
       ENDIF.
       IF WA_BKPF-BLART EQ 'RA'.
         MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
         COLLECT WA_BKPF11 INTO IT_BKPF11.
         DELETE IT_BKPF.
       ENDIF.
     ELSE.
       IF WA_BKPF-BLART GE 'P1' AND WA_BKPF-BLART LE 'RA'.
         MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
         COLLECT WA_BKPF11 INTO IT_BKPF11.
         DELETE IT_BKPF.
       ENDIF.
     ENDIF.

     IF WA_BKPF-BLART GE 'U1' AND WA_BKPF-BLART LE 'U4'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'DZ'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'MA'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'ZA'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'S1'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'SA'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.

     IF WA_BKPF-GRPID EQ 'F-51GSTCLR' AND
        WA_BKPF-TCODE EQ 'FB05' AND WA_BKPF-BLART EQ 'AB'.
       MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
       COLLECT WA_BKPF11 INTO IT_BKPF11.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'AB' AND WA_BKPF-TCODE EQ 'FB01'.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_BKPF-BELNR AND
         GJAHR EQ WA_BKPF-GJAHR AND KOART EQ 'D'
         AND HKONT EQ '0000002416'.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
            AND BELNR EQ WA_BKPF-BELNR AND GJAHR EQ WA_BKPF-GJAHR
           AND KOART EQ 'K' AND HKONT EQ '0000001501'.
         IF SY-SUBRC EQ 0.
           MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
           COLLECT WA_BKPF11 INTO IT_BKPF11.
           DELETE IT_BKPF.
         ENDIF.
       ENDIF.
     ENDIF.
   ENDLOOP.

   LOOP AT IT_BKPF11 INTO WA_BKPF11.
     IF WA_BKPF11-TCODE EQ 'FB08'.
       SELECT SINGLE * FROM BKPF WHERE BELNR EQ WA_BKPF11-STBLG
         AND GJAHR EQ WA_BKPF11-STJAH AND TCODE EQ 'J_1IG_INV'.
       IF SY-SUBRC EQ 0.
         DELETE IT_BKPF11 WHERE BELNR EQ WA_BKPF11-BELNR AND
         GJAHR = WA_BKPF11-GJAHR.
       ENDIF.
     ENDIF.
   ENDLOOP.

   IF IT_BKPF11 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG11 FOR ALL ENTRIES
        IN IT_BKPF11 WHERE BUKRS EQ '1000' AND
        BELNR EQ IT_BKPF11-BELNR AND GJAHR = IT_BKPF11-GJAHR
       AND HKONT GE '0000001588' AND HKONT LE '0000002830'.
   ENDIF.

   LOOP AT IT_BSEG11 INTO WA_BSEG11.
     IF WA_BSEG11-HKONT GE '0000001601' AND WA_BSEG11-HKONT LE '0000002799'.
       DELETE IT_BSEG11 WHERE BELNR = WA_BSEG11-BELNR AND
       GJAHR = WA_BSEG11-GJAHR AND HKONT = WA_BSEG11-HKONT.
     ENDIF.
   ENDLOOP.
   IF R13D EQ 'X'.
     PERFORM DETAILJV.
   ELSE.

     LOOP AT IT_BSEG11 INTO WA_BSEG11.
       READ TABLE IT_BKPF11 INTO WA_BKPF11 WITH KEY
       BELNR = WA_BSEG11-BELNR GJAHR = WA_BSEG11-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAB1-TCODE = WA_BKPF11-TCODE.
         WA_TAB1-BLART = WA_BKPF11-BLART.
         WA_TAB1-BELNR = WA_BKPF11-BELNR.
         WA_TAB1-AWKEY = WA_BKPF11-AWKEY.
         WA_TAB1-GJAHR = WA_BKPF11-GJAHR.
         WA_TAB1-BUDAT = WA_BKPF11-BUDAT.
         WA_TAB1-BLDAT = WA_BKPF11-BLDAT.
         WA_TAB1-XBLNR = WA_BKPF11-XBLNR.
         WA_TAB1-GSBER = WA_BSEG11-GSBER.
         WA_TAB1-STEUC = WA_BSEG11-HSN_SAC.
         WA_TAB1-MENGE = WA_BSEG11-MENGE.
         WA_TAB1-MEINS = WA_BSEG11-MEINS.
         WA_TAB1-MWSKZ = WA_BSEG11-MWSKZ.
         WA_TAB1-KOSTL = WA_BSEG11-KOSTL.
         IF WA_BSEG11-SHKZG EQ 'H'.
           WA_BSEG11-DMBTR = WA_BSEG11-DMBTR * ( - 1 ).
         ENDIF.
         WA_TAB1-DMBTR = WA_BSEG11-DMBTR.
         IF WA_BSEG11-SHKZG EQ 'H'.
           WA_TAB1-SIG = 'A'.
         ELSE.
           WA_TAB1-SIG = 'B'.
         ENDIF.
         WA_TAB1-HKONT = WA_BSEG11-HKONT.
         WA_TAB1-USNAM = WA_BKPF11-USNAM.
         WA_TAB1-BUPLA = WA_BSEG11-BUPLA.
************  business plave for LLM***********************

*********************************************************


***************************************
*       ******************  business place for LLM  - MAH ALWAYS **********************
         DT1+6(2) = '01'.
         DT1+4(2) = '04'.
         DT1+0(4) = '2017'.
         IF S_BUDAT-LOW GE DT1.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
             BELNR = WA_BKPF11-BELNR AND GJAHR = WA_BKPF11-GJAHR
             AND EBELP NE SPACE.
           IF SY-SUBRC EQ 0.
             SELECT SINGLE * FROM EKKO WHERE EBELN EQ BSEG-EBELN
               AND BSART EQ 'ZS'.
             IF SY-SUBRC EQ 0.
               WA_TAB1-BUPLA = 'MAH'.
             ENDIF.
           ENDIF.
         ENDIF.
******************************************

         COLLECT WA_TAB1 INTO IT_TAB1.
         CLEAR WA_TAB1.
*       ENDIF.
*       ENDIF.
       ENDIF.
     ENDLOOP.



     PERFORM TDS.
     PERFORM TOTVALUE.

*   LOOP AT IT_TAB1 INTO WA_TAB1.
*     WRITE : / 'ATT',WA_TAB1-BELNR,WA_TAB1-GJAHR,WA_TAB1-DMBTR,WA_TAB1-HKONT.
*   ENDLOOP.



     LOOP AT IT_TAB1 INTO WA_TAB1.
       CLEAR : RATE.
       WA_TAS1-BELNR = WA_TAB1-BELNR.
       WA_TAS1-GJAHR = WA_TAB1-GJAHR.
*     WA_TAS1-TXGRP = WA_TAB1-TXGRP.
       WA_TAS1-MWSKZ = WA_TAB1-MWSKZ.
*     WA_TAS1-BUZEI = WA_TAB1-BUZEI.
       WA_TAS1-HKONT = WA_TAB1-HKONT.
       WA_TAS1-HWBAS = 0.
       WA_TAS1-HWSTE = WA_TAB1-DMBTR.
       WA_TAS1-DMBTR = WA_TAB1-DMBTR.
       IF WA_TAB1-HKONT EQ '0000028010' OR
          WA_TAB1-HKONT EQ '0000028060' OR
          WA_TAB1-HKONT EQ '0000028140' OR
          WA_TAB1-HKONT EQ '0000028150' OR
          WA_TAB1-HKONT EQ '0000028180' OR
          WA_TAB1-HKONT EQ '0000028220' OR
          WA_TAB1-HKONT EQ '0000028270' OR
          WA_TAB1-HKONT EQ '0000015880' .
          WA_TAS1-SGST = WA_TAB1-DMBTR.
       ELSEIF WA_TAB1-HKONT EQ '0000028020' OR
         WA_TAB1-HKONT EQ '0000028070' OR
         WA_TAB1-HKONT EQ '0000028130' OR
         WA_TAB1-HKONT EQ '0000028160' OR
         WA_TAB1-HKONT EQ '0000028190' OR
         WA_TAB1-HKONT EQ '0000028230' OR
         WA_TAB1-HKONT EQ '0000028280' OR
         WA_TAB1-HKONT EQ '0000015890' .
         WA_TAS1-CGST = WA_TAB1-DMBTR.
       ELSEIF WA_TAB1-HKONT EQ '0000028030' OR
         WA_TAB1-HKONT EQ '0000028080' OR
         WA_TAB1-HKONT EQ '0000028100' OR
         WA_TAB1-HKONT EQ '0000028110' OR
         WA_TAB1-HKONT EQ '0000028120' OR
         WA_TAB1-HKONT EQ '0000028170' OR
         WA_TAB1-HKONT EQ '0000028200' OR
         WA_TAB1-HKONT EQ '0000028240' OR
         WA_TAB1-HKONT EQ '0000028290' OR
         WA_TAB1-HKONT EQ '0000015900'.
         WA_TAS1-IGST = WA_TAB1-DMBTR.
       ELSEIF WA_TAB1-HKONT EQ '0000028050' OR
         WA_TAB1-HKONT EQ '0000028210' OR
         WA_TAB1-HKONT EQ '0000028250' OR
         WA_TAB1-HKONT EQ '0000028300' OR
         WA_TAB1-HKONT EQ '0000015920'.
         WA_TAS1-CESS = WA_TAB1-DMBTR.
       ELSEIF WA_TAB1-HKONT EQ '0000028040' OR
              WA_TAB1-HKONT EQ '0000028090' OR
              WA_TAB1-HKONT EQ '0000015910'.
              WA_TAS1-UGST = WA_TAB1-DMBTR.
       ENDIF.
       WA_TAS1-SIG = WA_TAB1-SIG.
       IF WA_TAB1-HKONT GE '0000015880' AND
          WA_TAB1-HKONT LE '0000015920'.
         WA_TAS1-STATUS = 'RCM'.
       ELSE.
         WA_TAS1-STATUS = SPACE.
       ENDIF.
       WA_TAS1-TCODE = WA_TAB1-TCODE.
       WA_TAS1-BLART = WA_TAB1-BLART.
       WA_TAS1-AWKEY = WA_TAB1-AWKEY.
       WA_TAS1-BUDAT = WA_TAB1-BUDAT.
       WA_TAS1-BLDAT = WA_TAB1-BLDAT.
       WA_TAS1-XBLNR = WA_TAB1-XBLNR.
       WA_TAS1-GSBER = WA_TAB1-GSBER.
       WA_TAS1-USNAM = WA_TAB1-USNAM.
       WA_TAS1-BUPLA = WA_TAB1-BUPLA.
       WA_TAS1-SIG = WA_TAB1-SIG.
       WA_TAS1-KOSTL = WA_TAB1-KOSTL.
       COLLECT WA_TAS1 INTO IT_TAS1.
       CLEAR WA_TAS1.
     ENDLOOP.
***************  NO TAX********************
     SORT IT_TAS1 BY BELNR GJAHR TXGRP.
     LOOP AT IT_TAS1 INTO WA_TAS1.
       CLEAR : VAL1, VAL2,VAL3,DOC.
       WA_TAS2-GJAHR = WA_TAS1-GJAHR.
       WA_TAS2-BELNR = WA_TAS1-BELNR.
       WA_TAS2-TXGRP = WA_TAS1-TXGRP.
       WA_TAS2-HKONT = WA_TAS1-HKONT.
       WA_TAS2-MWSKZ = WA_TAS1-MWSKZ.
       WA_TAS2-BUZEI = WA_TAS1-BUZEI.
       WA_TAS2-STATUS = WA_TAS1-STATUS.
       WA_TAS2-STEUC = WA_TAS1-STEUC.
       WA_TAS2-MENGE = WA_TAS1-MENGE.
       WA_TAS2-MEINS = WA_TAS1-MEINS.
       WA_TAS2-HWBAS = WA_TAS1-HWBAS.
       WA_TAS2-HWSTE = WA_TAS1-HWSTE.
       WA_TAS2-DMBTR = WA_TAS1-DMBTR.
       WA_TAS2-SGST = WA_TAS1-SGST.
       WA_TAS2-CGST = WA_TAS1-CGST.
       WA_TAS2-UGST = WA_TAS1-UGST.
       WA_TAS2-IGST = WA_TAS1-IGST.
       WA_TAS2-CESS = WA_TAS1-CESS.
       WA_TAS2-SIG = WA_TAS1-SIG.
       WA_TAS2-RATE = WA_TAS1-RATE.
       WA_TAS2-KOSTL = WA_TAS1-KOSTL.
       WA_TAS2-GSBER = WA_TAS1-GSBER.
       WA_TAS2-BUPLA = WA_TAS1-BUPLA.
       ON CHANGE OF WA_TAS1-BELNR.
         READ TABLE IT_TDS1 INTO WA_TDS1 WITH KEY
                     BELNR = WA_TAS1-BELNR
                     GJAHR = WA_TAS1-GJAHR.
         IF SY-SUBRC EQ 0.
           WA_TAS2-TDS = WA_TDS1-DMBTR.
         ENDIF.
       ENDON.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
                       BELNR = WA_TAS1-BELNR AND
                       GJAHR = WA_TAS1-GJAHR AND
                       KOART EQ 'K'.
       IF SY-SUBRC EQ 0.
         WA_TAS2-LIFNR = BSEG-LIFNR.
         SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ BSEG-LIFNR.
         IF SY-SUBRC EQ 0.
           WA_TAS2-VENREG = LFA1-REGIO.
           WA_TAS2-NAME1 = LFA1-NAME1.
           WA_TAS2-ORT01 = LFA1-ORT01.
           WA_TAS2-STCD3 = LFA1-STCD3.
           WA_TAS2-PAN =  LFA1-J_1IPANNO.
           IF LFA1-VEN_CLASS EQ ' '.
             WA_TAS2-VEN_CL = 'Registered'.
           ELSEIF LFA1-VEN_CLASS EQ '0'.
             WA_TAS2-VEN_CL = 'Not Registered'.
           ELSEIF LFA1-VEN_CLASS EQ '1'.
             WA_TAS2-VEN_CL = 'Compounding Scheme'.
           ELSEIF LFA1-VEN_CLASS EQ '2'.
             WA_TAS2-VEN_CL = 'Special Economic Zone'.
           ENDIF.
           WA_TAS2-VEN_CLASS = LFA1-VEN_CLASS.
           CLEAR : SCODE.
           SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN'
                               AND BLAND EQ WA_TAS2-VENREG.
           IF SY-SUBRC EQ 0.
             SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN' AND
                       LAND1 EQ 'IN' AND BLAND EQ WA_TAS2-VENREG.
             IF SY-SUBRC EQ 0.
               CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
               WA_TAS2-SCODE = SCODE.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.

       IF WA_TAS2-LIFNR EQ '0000000001'.
         SELECT SINGLE * FROM BSEC WHERE BUKRS EQ '1000'
                AND BELNR EQ WA_TAS1-BELNR AND
                GJAHR EQ WA_TAS1-GJAHR.
         IF SY-SUBRC EQ 0.
           WA_TAS2-NAME1 = BSEC-NAME1.
           WA_TAS2-ORT01 = BSEC-ORT01.
           WA_TAS2-VENREG = BSEC-REGIO.
           WA_TAS2-STCD3 = BSEC-STCD3.
           CLEAR : SCODE.
           SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN'
                            AND BLAND EQ WA_TAS2-VENREG.
           IF SY-SUBRC EQ 0.
             SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN' AND
                    LAND1 EQ 'IN' AND BLAND EQ WA_TAS2-VENREG.
             IF SY-SUBRC EQ 0.
               CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
               WA_TAS2-SCODE = SCODE.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
       COLLECT WA_TAS2 INTO IT_TAS2.
       CLEAR WA_TAS2.
     ENDLOOP.

     SORT IT_TAB1 BY GJAHR BELNR.
     IT_BSEG121[] = IT_BSEG11[].
     DELETE IT_BSEG12 WHERE BUPLA EQ SPACE.

     SORT IT_TAS2 BY BELNR GJAHR TXGRP.

     IF IT_TAS2 IS NOT INITIAL.
       SELECT * FROM BSE_CLR INTO TABLE IT_BSE_CLR FOR
          ALL ENTRIES IN IT_TAS2 WHERE BUKRS_CLR EQ 'BCLL'
          AND BUKRS EQ '1000' AND BELNR EQ IT_TAS2-BELNR
          AND GJAHR EQ IT_TAS2-GJAHR.
     ENDIF.
     SORT IT_BSE_CLR DESCENDING BY BELNR_CLR.

     LOOP AT IT_BSE_CLR  INTO WA_BSE_CLR.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000' AND
                   BELNR EQ WA_BSE_CLR-BELNR AND
                   GJAHR = WA_BSE_CLR-GJAHR AND
                   XREVERSAL NE SPACE.
       IF SY-SUBRC EQ 0.
         DELETE IT_BSE_CLR WHERE BELNR_CLR EQ BKPF-BELNR
                  AND GJAHR_CLR EQ BKPF-GJAHR.
       ENDIF.
     ENDLOOP.


     LOOP AT IT_TAS2 INTO WA_TAS2 WHERE BUPLA IN BUSPLACE.
       IF WA_TAS2-TCODE EQ 'FBCJ' AND WA_TAS2-LIFNR EQ '0000000001'.

       ELSE.
         WA_TAS3-GJAHR = WA_TAS2-GJAHR.
         WA_TAS3-BELNR = WA_TAS2-BELNR.
         WA_TAS3-TXGRP = WA_TAS2-TXGRP.
         WA_TAS3-MWSKZ = WA_TAS2-MWSKZ.
         WA_TAS3-BUZEI = WA_TAS2-BUZEI.
         WA_TAS3-STATUS = WA_TAS2-STATUS.
         WA_TAS3-STEUC = WA_TAS2-STEUC.
         WA_TAS3-MENGE = WA_TAS2-MENGE.
         WA_TAS3-MEINS = WA_TAS2-MEINS.
         WA_TAS3-HWBAS = WA_TAS2-HWBAS.
         WA_TAS3-HWSTE = WA_TAS2-HWSTE.
         WA_TAS3-DMBTR = WA_TAS2-DMBTR.

         WA_TAS3-SGST = WA_TAS2-SGST.
         WA_TAS3-CGST = WA_TAS2-CGST.
         WA_TAS3-UGST = WA_TAS2-UGST.
         WA_TAS3-IGST = WA_TAS2-IGST.
         WA_TAS3-CESS = WA_TAS2-CESS.
         WA_TAS3-SIG = WA_TAS2-SIG.
         WA_TAS3-RATE = WA_TAS2-RATE.

         WA_TAS3-TDS = WA_TAS2-TDS.
         WA_TAS3-TCODE = WA_TAS2-TCODE.
         WA_TAS3-BLART = WA_TAS2-BLART.
         WA_TAS3-AWKEY = WA_TAS2-AWKEY.
         WA_TAS3-BUDAT = WA_TAS2-BUDAT.
         WA_TAS3-BLDAT = WA_TAS2-BLDAT.
         WA_TAS3-XBLNR = WA_TAS2-XBLNR.
         WA_TAS3-GSBER = WA_TAS2-GSBER.
         WA_TAS3-USNAM = WA_TAS2-USNAM.
         WA_TAS3-BUPLA = WA_TAS2-BUPLA.
         WA_TAS3-LIFNR = WA_TAS2-LIFNR.
         WA_TAS3-VENREG = WA_TAS2-VENREG.
         WA_TAS3-NAME1 = WA_TAS2-NAME1.
         WA_TAS3-ORT01 = WA_TAS2-ORT01.
         WA_TAS3-STCD3 = WA_TAS2-STCD3.
         WA_TAS3-VEN_CLASS = WA_TAS2-VEN_CLASS.
         WA_TAS3-PAN = WA_TAS2-PAN.
         WA_TAS3-VEN_CL = WA_TAS2-VEN_CL.
         WA_TAS3-SCODE = WA_TAS2-SCODE.
*
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
                        BELNR = WA_TAS2-BELNR AND
                        GJAHR = WA_TAS2-GJAHR AND
                        EBELP NE SPACE.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM EKPO WHERE EBELN EQ BSEG-EBELN
                       AND EBELP EQ BSEG-EBELP.
           IF SY-SUBRC EQ 0.
             WA_TAS3-WERKS = EKPO-WERKS.
           ENDIF.
         ENDIF.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
                    BELNR = WA_TAS2-BELNR AND
                    GJAHR = WA_TAS2-GJAHR AND
                    TXGRP = WA_TAS2-TXGRP.
         IF SY-SUBRC EQ 0.
           WA_TAS3-SGTXT = BSEG-SGTXT.
         ELSE.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                     AND BELNR = WA_TAS2-BELNR
                     AND GJAHR = WA_TAS2-GJAHR.
           IF SY-SUBRC EQ 0.
             WA_TAS3-SGTXT = BSEG-SGTXT.
           ENDIF.
         ENDIF.
         IF WA_TAS3-SGTXT EQ '                    '.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                        AND BELNR = WA_TAS2-BELNR
                        AND GJAHR = WA_TAS2-GJAHR
                        AND SGTXT NE SPACE.
           IF SY-SUBRC EQ 0.
             WA_TAS3-SGTXT = BSEG-SGTXT.
           ENDIF.
         ENDIF.

         READ TABLE IT_BSE_CLR INTO WA_BSE_CLR WITH KEY
                         BUKRS_CLR = 'BCLL'
                         BELNR = WA_TAS3-BELNR
                         GJAHR = WA_TAS3-GJAHR.
         IF SY-SUBRC EQ 0.
           WA_TAS3-BELNR_CLR = WA_BSE_CLR-BELNR_CLR.
           WA_TAS3-GJAHR_CLR = WA_BSE_CLR-GJAHR_CLR.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                       AND BELNR EQ WA_BSE_CLR-BELNR_CLR
                       AND GJAHR EQ WA_BSE_CLR-GJAHR_CLR
                       AND AUGDT NE 0.
           IF SY-SUBRC EQ 0.
             WA_TAS3-AUGDT = BSEG-AUGDT.
           ENDIF.
         ENDIF.

         IF WA_TAS2-HKONT EQ SPACE.
           IF WA_TAS2-TCODE EQ 'FBCJ'.

           ELSE.
             SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                       AND BELNR = WA_TAS2-BELNR
                       AND GJAHR = WA_TAS2-GJAHR
                       AND TXGRP = WA_TAS2-TXGRP
                       AND KOART EQ 'A'.
             IF SY-SUBRC EQ 0.
               WA_TAS3-HKONT = BSEG-HKONT.
               WA_TAS3-KOSTL = BSEG-KOSTL.
             ELSE.
               SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                          AND BELNR = WA_TAS2-BELNR
                          AND GJAHR = WA_TAS2-GJAHR
                          AND TXGRP = WA_TAS2-TXGRP
                          AND KTOSL EQ '   '.
               IF SY-SUBRC EQ 0.
                 WA_TAS3-HKONT = BSEG-HKONT.
                 WA_TAS3-KOSTL = BSEG-KOSTL.
               ENDIF.
             ENDIF.
           ENDIF.
         ELSE.
           WA_TAS3-HKONT = WA_TAS2-HKONT.
           WA_TAS3-KOSTL = WA_TAS2-KOSTL.
         ENDIF.
*       IF WA_TAS3-KOSTL EQ SPACE.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                   AND BELNR = WA_TAS2-BELNR
                   AND GJAHR = WA_TAS2-GJAHR
                   AND TXGRP = WA_TAS2-TXGRP
                   AND KOSTL NE SPACE.
         IF SY-SUBRC EQ 0.
           WA_TAS3-KOSTL = BSEG-KOSTL.
         ELSE.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                   AND BELNR = WA_TAS2-BELNR
                   AND GJAHR = WA_TAS2-GJAHR
                   AND KOSTL NE SPACE.
           IF SY-SUBRC EQ 0.
             WA_TAS3-KOSTL = BSEG-KOSTL.
           ENDIF.
         ENDIF.

         COLLECT WA_TAS3 INTO IT_TAS3.
         CLEAR WA_TAS3.
       ENDIF.
     ENDLOOP.
********************

   ENDIF.
 ENDFORM.

 FORM TOP.
   DATA : REG(50) TYPE C.
   LOOP AT IT_T005U INTO WA_T005U.
     CONCATENATE REG WA_T005U-BLAND ', ' INTO REG.
   ENDLOOP.

   DATA: COMMENT    TYPE SLIS_T_LISTHEADER,
         WA_COMMENT LIKE LINE OF COMMENT.
   DATA : YEAR(4)  TYPE C,
          MONTH(2) TYPE C,
          DATE(2)  TYPE C,
          A(10)    TYPE C,
          DOT(1)   TYPE C.

   WA_COMMENT-TYP = 'A'.
   YEAR = S_BUDAT-LOW+0(4).
   MONTH = S_BUDAT-LOW+4(2).
   DATE = S_BUDAT-LOW+6(2).
   DOT = '.'.
   CONCATENATE  DATE MONTH YEAR INTO A SEPARATED BY '.'.
   WA_COMMENT-TYP = 'S'.
   WA_COMMENT-KEY = 'FROM'.
   WA_COMMENT-INFO = A .
   WA_COMMENT-INFO+30(2) = 'TO'.
   YEAR = S_BUDAT-HIGH+0(4).
   MONTH = S_BUDAT-HIGH+4(2).
   DATE = S_BUDAT-HIGH+6(2).
   DOT = '.'.
   CONCATENATE  DATE MONTH YEAR INTO A SEPARATED BY '.'.
   WA_COMMENT-INFO+45(10) = A .
   APPEND WA_COMMENT TO COMMENT.
   CLEAR WA_COMMENT.

   IF R11 EQ 'X' OR R12 EQ 'X' OR R12N1 EQ 'X'.

     WA_COMMENT-TYP = 'A'.
     WA_COMMENT-INFO = 'TCODES CONCIDERED IN PROGRAM ARE : MIRO, MR8M, FB60, FB08'.
     APPEND WA_COMMENT TO COMMENT.
     CLEAR WA_COMMENT.

     WA_COMMENT-TYP = 'A'.
     WA_COMMENT-INFO = 'FB01, FB65, FB50, FB05, FBR2, VF01, VF02, FBVB'.
     APPEND WA_COMMENT TO COMMENT.
     CLEAR WA_COMMENT.

     WA_COMMENT-TYP = 'A'.
     WA_COMMENT-INFO+1(6) = 'Region'.
     WA_COMMENT-INFO+8(52) = REG.
     APPEND WA_COMMENT TO COMMENT.
     CLEAR WA_COMMENT.

   ENDIF.


   CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
     EXPORTING
       IT_LIST_COMMENTARY = COMMENT.

   CLEAR COMMENT.

 ENDFORM.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
 FORM USER_COMM USING UCOMM LIKE SY-UCOMM
                      SELFIELD TYPE SLIS_SELFIELD.



   CASE SELFIELD-FIELDNAME.
     WHEN 'BELNR'.
       SET PARAMETER ID 'BLN' FIELD SELFIELD-VALUE.
       CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
     WHEN 'VBELN1'.
       SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
       CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
     WHEN 'VBELN'.
       SET PARAMETER ID 'VF' FIELD SELFIELD-VALUE.
       CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
     WHEN 'MBLNR'.
       SET PARAMETER ID 'MBN' FIELD SELFIELD-VALUE.
       CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.
     WHEN 'EBELN'.
       SET PARAMETER ID 'BES' FIELD SELFIELD-VALUE.
       CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
     WHEN OTHERS.
   ENDCASE.
 ENDFORM.                    "USER_COMM


**********************MAIN LOOP*****************
*&---------------------------------------------------------------------*
*&      Form  PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM PROCESS .
   LOOP AT IT_TAS3 INTO WA_TAS3.
     WA_TAS4-BELNR = WA_TAS3-BELNR.
     WA_TAS4-GJAHR = WA_TAS3-GJAHR.
     WA_TAS4-TCODE = WA_TAS3-TCODE.
     WA_TAS4-USNAM = WA_TAS3-USNAM.
     WA_TAS4-BUPLA = WA_TAS3-BUPLA.
     WA_TAS4-BLART = WA_TAS3-BLART.
     WA_TAS4-STATUS = WA_TAS3-STATUS.
     WA_TAS4-GSBER = WA_TAS3-GSBER.
     WA_TAS4-BLDAT = WA_TAS3-BLDAT.
     WA_TAS4-BUDAT = WA_TAS3-BUDAT.
     WA_TAS4-GJAHR = WA_TAS3-GJAHR.
     WA_TAS4-DMBTR = WA_TAS3-DMBTR.
     WA_TAS4-MWSKZ = WA_TAS3-MWSKZ.
     WA_TAS4-HWBAS = WA_TAS3-HWBAS.
     WA_TAS4-HWSTE = WA_TAS3-HWSTE.
     WA_TAS4-CESS = WA_TAS3-CESS.
     WA_TAS4-IGST = WA_TAS3-IGST.
     WA_TAS4-SGST = WA_TAS3-SGST.
     WA_TAS4-UGST = WA_TAS3-UGST.
     WA_TAS4-CGST = WA_TAS3-CGST.
     WA_TAS4-SIG = WA_TAS3-SIG.
     WA_TAS4-RATE = WA_TAS3-RATE.
     WA_TAS4-TDS = WA_TAS3-TDS.
     WA_TAS4-BELNR_CLR = WA_TAS3-BELNR_CLR.
     WA_TAS4-AUGDT = WA_TAS3-AUGDT.
     WA_TAS4-XBLNR = WA_TAS3-XBLNR.
     WA_TAS4-VBELN = WA_TAS3-VBELN.
     WA_TAS4-STEUC = WA_TAS3-STEUC.
     WA_TAS4-MENGE = WA_TAS3-MENGE.
     WA_TAS4-MEINS = WA_TAS3-MEINS.
     WA_TAS4-HKONT = WA_TAS3-HKONT.
     WA_TAS4-LIFNR = WA_TAS3-LIFNR.
     WA_TAS4-NAME1 = WA_TAS3-NAME1.
     WA_TAS4-ORT01 = WA_TAS3-ORT01.
     WA_TAS4-VENREG = WA_TAS3-VENREG.
     WA_TAS4-STCD3 = WA_TAS3-STCD3.
     WA_TAS4-SGTXT = WA_TAS3-SGTXT.
     WA_TAS4-SCODE = WA_TAS3-SCODE.
     WA_TAS4-VEN_CL = WA_TAS3-VEN_CL.
     WA_TAS4-PAN = WA_TAS3-PAN.
     WA_TAS4-MBLNR = WA_TAS3-MBLNR.
     WA_TAS4-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
     WA_TAS4-RECP = WA_TAS3-RECP.
     WA_TAS4-RECP_DT = WA_TAS3-RECP_DT.
     WA_TAS4-RSTAT = WA_TAS3-RSTAT.
****** SOC by CK
     IF WA_TAS3-TCODE = 'MIRO' OR WA_TAS3-TCODE = 'MR8M'.

       IF     WA_TAS3-EBELN IS INITIAL   . .
         SELECT SINGLE EBELN FROM BSEG INTO WA_TAS4-EBELN
                WHERE BELNR = WA_TAS3-BELNR AND
                GJAHR = WA_TAS3-GJAHR  AND BUZID = 'W'.
       ELSE.
         WA_TAS4-EBELN = WA_TAS3-EBELN.
       ENDIF.

       IF WA_TAS4-EBELN IS NOT INITIAL.
         SELECT SINGLE BSART FROM EKKO INTO WA_TAS4-BSART
                              WHERE EBELN = WA_TAS4-EBELN .
         IF SY-SUBRC IS  INITIAL.
           CASE WA_TAS4-BSART.
             WHEN 'ZCAP'.  WA_TAS4-TYPE      = 'Capital Goods'   .
             WHEN 'ZSRV'.  WA_TAS4-TYPE      = 'SERVICE'   .
             WHEN OTHERS.
               IF WA_TAS4-STEUC+(1) = '9'  .
                 WA_TAS4-TYPE      = 'SERVICE'   .
               ELSE.
                 WA_TAS4-TYPE      = 'Goods'.
               ENDIF.
           ENDCASE.
         ENDIF.
       ENDIF.
     ENDIF.
****** SOE by CK
     COLLECT WA_TAS4 INTO IT_TAS4.
     CLEAR WA_TAS4.
   ENDLOOP.

   WA_FIELDCAT-FIELDNAME = 'TCODE'.
   WA_FIELDCAT-SELTEXT_L = 'TCODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'USNAM'.
   WA_FIELDCAT-SELTEXT_L = 'USER'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BUPLA'.
   WA_FIELDCAT-SELTEXT_L = 'BUS.PLACE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BLART'.
   WA_FIELDCAT-SELTEXT_L = 'DOC TYPE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STATUS'.
   WA_FIELDCAT-SELTEXT_L = 'STATUS'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'GSBER'.
   WA_FIELDCAT-SELTEXT_L = 'BUS.AREA'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BELNR'.
   WA_FIELDCAT-SELTEXT_L = 'DOC NO.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RSTAT'.
   WA_FIELDCAT-SELTEXT_L = 'REVERSE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BLDAT'.
   WA_FIELDCAT-SELTEXT_L = 'DOCUMENT DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BUDAT'.
   WA_FIELDCAT-SELTEXT_L = 'POSTING DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'GJAHR'.
   WA_FIELDCAT-SELTEXT_L = 'YEAR'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'DMBTR'.
   WA_FIELDCAT-SELTEXT_L = 'TOT AMOUNT'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MWSKZ'.
   WA_FIELDCAT-SELTEXT_L = 'TAX CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWBAS'.
   WA_FIELDCAT-SELTEXT_L = 'TAXABLE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWSTE'.
   WA_FIELDCAT-SELTEXT_L = 'TAX AMT'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'IGST'.
   WA_FIELDCAT-SELTEXT_L = 'IGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGST'.
   WA_FIELDCAT-SELTEXT_L = 'SGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'UGST'.
   WA_FIELDCAT-SELTEXT_L = 'UGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CGST'.
   WA_FIELDCAT-SELTEXT_L = 'CGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CESS'.
   WA_FIELDCAT-SELTEXT_L = 'CESS'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RATE'.
   WA_FIELDCAT-SELTEXT_L = 'TAX RATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TDS'.
   WA_FIELDCAT-SELTEXT_L = 'TDS AMOUNT'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BELNR_CLR'.
   WA_FIELDCAT-SELTEXT_L = 'CLEARING DOC'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'AUGDT'.
   WA_FIELDCAT-SELTEXT_L = 'CLEARING DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'XBLNR'.
   WA_FIELDCAT-SELTEXT_L = 'REF NO'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'VBELN'.
   WA_FIELDCAT-SELTEXT_L = 'INVOIVE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STEUC'.
   WA_FIELDCAT-SELTEXT_L = 'HSN/SAC CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.
*
   WA_FIELDCAT-FIELDNAME = 'MENGE'.
   WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MEINS'.
   WA_FIELDCAT-SELTEXT_L = 'UOM'.
   APPEND WA_FIELDCAT TO FIELDCAT.
*
   WA_FIELDCAT-FIELDNAME = 'HKONT'.
   WA_FIELDCAT-SELTEXT_L = 'GL CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'KOSTL'.
   WA_FIELDCAT-SELTEXT_L = 'COST CENTER'.
   APPEND WA_FIELDCAT TO FIELDCAT.
********** SOC Added by CK
  IF R11 = 'X'.
    WA_FIELDCAT-FIELDNAME = 'EBELN'.
    WA_FIELDCAT-SELTEXT_L = 'Purchase Doc'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'BSART'.
    WA_FIELDCAT-SELTEXT_L = 'PO Type'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'TYPE'.
    WA_FIELDCAT-SELTEXT_L = 'TYPE(G/S/C)'.
    APPEND WA_FIELDCAT TO FIELDCAT.
  ENDIF.

*  ********** SOE Added by CK

   WA_FIELDCAT-FIELDNAME = 'LIFNR'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'NAME1'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR NAME'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'ORT01'.
   WA_FIELDCAT-SELTEXT_L = 'PLACE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'VENREG'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR REGION'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STCD3'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR GSTN'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGTXT'.
   WA_FIELDCAT-SELTEXT_L = 'TEXT'.
   APPEND WA_FIELDCAT TO FIELDCAT.


   WA_FIELDCAT-FIELDNAME = 'SCODE'.
   WA_FIELDCAT-SELTEXT_L = 'STATE CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'VEN_CL'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR CLASS'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'PAN'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR PAN NO.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MBLNR'.
   WA_FIELDCAT-SELTEXT_L = 'INVOICE GRN'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MKPF_BUDAT'.
   WA_FIELDCAT-SELTEXT_L = 'INV GRN DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RECP'.
   WA_FIELDCAT-SELTEXT_L = 'J_1IG_INV'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RECP_DT'.
   WA_FIELDCAT-SELTEXT_L = 'J_1IG_INV DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'PURCHASE REGISTER FOR FB60 & MIRO'.


   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_TAS4
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.
 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM DETAIL .
   IF IT_TAB1 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG1 FOR
       ALL ENTRIES IN IT_TAB1 WHERE BUKRS EQ '1000'
       AND BELNR = IT_TAB1-BELNR
       AND GJAHR = IT_TAB1-GJAHR.
   ENDIF.
   IF IT_BSEG1 IS NOT INITIAL.
     LOOP AT IT_BSEG1 INTO WA_BSEG1.
       IF WA_BSEG1-SHKZG EQ 'S'.
         WA_BSEG1-DMBTR = WA_BSEG1-DMBTR * ( - 1 ).
       ENDIF.
       WA_GL1-BELNR = WA_BSEG1-BELNR.
       WA_GL1-GJAHR = WA_BSEG1-GJAHR.
       WA_GL1-HKONT = WA_BSEG1-HKONT.
       WA_GL1-DMBTR = WA_BSEG1-DMBTR.
       COLLECT WA_GL1 INTO IT_GL1.
       CLEAR WA_GL1.

     ENDLOOP.
   ENDIF.

   LOOP AT IT_GL1 INTO WA_GL1.
     WA_GL2-BELNR = WA_GL1-BELNR.
     WA_GL2-GJAHR = WA_GL1-GJAHR.
     WA_GL2-HKONT = WA_GL1-HKONT.
     WA_GL2-DMBTR = WA_GL1-DMBTR.
     SELECT SINGLE * FROM SKAT WHERE SPRAS EQ 'EN'
        AND KTOPL EQ '1000'
        AND SAKNR EQ WA_GL1-HKONT.
     IF SY-SUBRC EQ 0.
       WA_GL2-TXT50 = SKAT-TXT50.
     ENDIF.
     READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY
                BELNR = WA_GL1-BELNR
                GJAHR = WA_GL1-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_GL2-TCODE = WA_TAB1-TCODE.
       WA_GL2-BLART = WA_TAB1-BLART.
       WA_GL2-BELNR = WA_TAB1-BELNR.
       WA_GL2-GJAHR = WA_TAB1-GJAHR.
       WA_GL2-BUDAT = WA_TAB1-BUDAT.
       WA_GL2-BUPLA = WA_TAB1-BUPLA.
       WA_GL2-GSBER = WA_TAB1-GSBER.
       WA_GL2-XBLNR = WA_TAB1-XBLNR.
       WA_GL2-VBELN = WA_TAB1-VBELN.
     ENDIF.
     COLLECT WA_GL2 INTO IT_GL2.
     CLEAR WA_GL2.
   ENDLOOP.


   WA_FIELDCAT-FIELDNAME = 'TCODE'.
   WA_FIELDCAT-SELTEXT_L = 'TCODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'USNAM'.
   WA_FIELDCAT-SELTEXT_L = 'USER'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BUPLA'.
   WA_FIELDCAT-SELTEXT_L = 'BUS.PLACE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BLART'.
   WA_FIELDCAT-SELTEXT_L = 'DOC TYPE'.
   APPEND WA_FIELDCAT TO FIELDCAT.


   WA_FIELDCAT-FIELDNAME = 'GSBER'.
   WA_FIELDCAT-SELTEXT_L = 'BUS.AREA'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BELNR'.
   WA_FIELDCAT-SELTEXT_L = 'DOC NO.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HKONT'.
   WA_FIELDCAT-SELTEXT_L = 'GL '.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TXT50'.
   WA_FIELDCAT-SELTEXT_L = 'GL DESCRIPTION'.
   APPEND WA_FIELDCAT TO FIELDCAT.


   WA_FIELDCAT-FIELDNAME = 'BLDAT'.
   WA_FIELDCAT-SELTEXT_L = 'DOCUMENT DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BUDAT'.
   WA_FIELDCAT-SELTEXT_L = 'POSTING DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'GJAHR'.
   WA_FIELDCAT-SELTEXT_L = 'YEAR'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'DMBTR'.
   WA_FIELDCAT-SELTEXT_L = 'TOT AMOUNT'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'PURCHASE REGISTER FOR FB60 & MIRO'.


   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IT_FIELDCAT             = FIELDCAT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_GL2
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.


 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM INV .
   IF IT_TAB2  IS NOT INITIAL.
     SELECT * FROM VBRK INTO TABLE IT_VBRK1 FOR
       ALL ENTRIES IN IT_TAB2 WHERE
        VBELN EQ IT_TAB2-VBELN.
     IF SY-SUBRC EQ 0.
       SELECT * FROM VBRP INTO TABLE IT_VBRP1
          FOR ALL ENTRIES IN IT_VBRK1 WHERE
           VBELN EQ IT_VBRK1-VBELN.
     ENDIF.
   ENDIF.
   LOOP AT IT_VBRP1 INTO WA_VBRP1.
     WA_QTY1-VBELN = WA_VBRP1-VBELN.
     WA_QTY1-FKIMG = WA_VBRP1-FKIMG.
     COLLECT WA_QTY1 INTO IT_QTY1.
     CLEAR WA_QTY1.
   ENDLOOP.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MMDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM MMDOC .
   LOOP AT IT_TAB1 INTO WA_TAB1.
     WA_QTY11-BELNR = WA_TAB1-BELNR.
     WA_QTY11-GJAHR = WA_TAB1-GJAHR.
     WA_QTY11-AWKEY1 = WA_TAB1-AWKEY+0(10).
     WA_QTY11-AWKEY2 = WA_TAB1-AWKEY+10(4).
     COLLECT WA_QTY11 INTO IT_QTY11.
     CLEAR WA_QTY11.
   ENDLOOP.
   IF IT_QTY11 IS NOT INITIAL.
     SELECT * FROM RSEG  INTO TABLE IT_RSEG FOR
       ALL ENTRIES IN IT_QTY11 WHERE
       BELNR EQ IT_QTY11-AWKEY1 AND
       GJAHR EQ IT_QTY11-AWKEY2.
   ENDIF.

   LOOP AT IT_RSEG INTO WA_RSEG.
     READ TABLE IT_QTY11 INTO WA_QTY11 WITH
           KEY AWKEY1 = WA_RSEG-BELNR
               AWKEY2 = WA_RSEG-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_QTY12-AWKEY1 = WA_QTY11-AWKEY1.
       WA_QTY12-AWKEY2 = WA_QTY11-AWKEY2.
       WA_QTY12-BELNR = WA_QTY11-BELNR.
       WA_QTY12-GJAHR = WA_QTY11-GJAHR.
       WA_QTY12-QTY = WA_RSEG-MENGE.
       COLLECT WA_QTY12 INTO IT_QTY12.
       CLEAR WA_QTY12.
     ENDIF.
   ENDLOOP.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TAX1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM TAX1 .
   IF IT_TAP1 IS NOT INITIAL.
     SELECT * FROM BSET INTO TABLE IT_BSET FOR
        ALL ENTRIES IN IT_TAP1 WHERE
        BUKRS EQ '1000' AND
        BELNR EQ IT_TAP1-BELNR
       AND GJAHR EQ IT_TAP1-GJAHR.
*       AND MWSKZ NE 'V0'.
   ENDIF.

   LOOP AT IT_BSET INTO WA_BSET.
     IF WA_BSET-KTOSL NE 'VS1'.
       WA_TAX1-BELNR = WA_BSET-BELNR.
       WA_TAX1-GJAHR = WA_BSET-GJAHR.
       WA_TAX1-TXGRP = WA_BSET-TXGRP.
       WA_TAX1-MWSKZ = WA_BSET-MWSKZ.

*     WA_TAX1-KTOSL = WA_BSET-KTOSL.
       IF WA_BSET-SHKZG EQ 'H'.
         WA_BSET-HWSTE = WA_BSET-HWSTE * ( - 1 ).
         WA_BSET-HWBAS = WA_BSET-HWBAS * ( - 1 ).
       ENDIF.

       IF WA_BSET-KTOSL EQ 'JIC'.
         WA_TAX1-CGST = WA_BSET-HWSTE.
         WA_TAX1-HWBAS = WA_BSET-HWBAS.
         WA_TAX1-HWSTE = WA_BSET-HWSTE.
       ELSEIF WA_BSET-KTOSL EQ 'JIS'.
         WA_TAX1-SGST = WA_BSET-HWSTE.
         WA_TAX1-HWSTE = WA_BSET-HWSTE.
       ELSEIF WA_BSET-KTOSL EQ 'JIU'.
         WA_TAX1-UGST = WA_BSET-HWSTE.
         WA_TAX1-HWSTE = WA_BSET-HWSTE.
       ELSEIF WA_BSET-KTOSL EQ 'JII'.
         IF WA_BSET-MWSKZ NE 'V0'.
           WA_TAX1-IGST = WA_BSET-HWSTE.
           WA_TAX1-HWBAS = WA_BSET-HWBAS.
           WA_TAX1-HWSTE = WA_BSET-HWSTE.
         ENDIF.
       ELSEIF WA_BSET-KTOSL EQ 'JIM'.
         WA_TAX1-IGST = WA_BSET-HWSTE.
         WA_TAX1-HWBAS = WA_BSET-HWBAS.
         WA_TAX1-HWSTE = WA_BSET-HWSTE.
       ELSEIF WA_BSET-KTOSL EQ 'JCI'.
         WA_TAX1-CESS = WA_BSET-HWSTE.
*         WA_TAX1-HWBAS = WA_BSET-HWBAS.
         WA_TAX1-HWSTE = WA_BSET-HWSTE.
       ENDIF.
       IF WA_BSET-HWSTE LT 0.
         WA_TAX1-SIG = 'A'.
       ELSE.
         WA_TAX1-SIG = 'B'.
       ENDIF.
       COLLECT WA_TAX1 INTO IT_TAX1.
       CLEAR WA_TAX1.
     ENDIF.
   ENDLOOP.

   LOOP AT IT_BSET INTO WA_BSET.
     IF WA_BSET-KTOSL NE 'VS1'.
       WA_RC1-BELNR = WA_BSET-BELNR.
       WA_RC1-GJAHR = WA_BSET-GJAHR.
       WA_RC1-TXGRP = WA_BSET-TXGRP.
       WA_RC1-MWSKZ = WA_BSET-MWSKZ.
       IF WA_BSET-SHKZG EQ 'H'.
         WA_BSET-HWSTE = WA_BSET-HWSTE * ( - 1 ).
         WA_BSET-HWBAS = WA_BSET-HWBAS * ( - 1 ).
       ENDIF.
       IF WA_BSET-KTOSL EQ 'JRC'.
         WA_RC1-CGST = WA_BSET-HWSTE.
         WA_RC1-HWSTE = WA_BSET-HWSTE.
         WA_RC1-HWBAS = WA_BSET-HWBAS.
       ELSEIF WA_BSET-KTOSL EQ 'JRS'.
         WA_RC1-SGST = WA_BSET-HWSTE.
         WA_RC1-HWSTE = WA_BSET-HWSTE.
       ELSEIF WA_BSET-KTOSL EQ 'JRU'.
         WA_RC1-UGST = WA_BSET-HWSTE.
         WA_RC1-HWSTE = WA_BSET-HWSTE.
       ELSEIF WA_BSET-KTOSL EQ 'JRI'.
         WA_RC1-IGST = WA_BSET-HWSTE.
         WA_RC1-HWSTE = WA_BSET-HWSTE.
         WA_RC1-HWBAS = WA_BSET-HWBAS.
       ELSEIF WA_BSET-KTOSL EQ 'JII'.
         WA_RC1-IGST = WA_BSET-HWSTE.
         WA_RC1-HWSTE = WA_BSET-HWSTE.
         WA_RC1-HWBAS = WA_BSET-HWBAS.
       ELSEIF WA_BSET-KTOSL EQ 'JCR'.
         WA_RC1-CESS = WA_BSET-HWSTE.
         WA_RC1-HWSTE = WA_BSET-HWSTE.
       ENDIF.
       IF WA_BSET-HWSTE LT 0.
         WA_RC1-SIG = 'A'.
       ELSE.
         WA_RC1-SIG = 'B'.
       ENDIF.

       COLLECT WA_RC1 INTO IT_RC1.
       CLEAR WA_RC1.
     ENDIF.
   ENDLOOP.

   DELETE IT_RC1 WHERE HWSTE EQ 0.

   LOOP AT IT_RC1 INTO WA_RC1.
     READ TABLE IT_RC1 INTO WA_RC1 WITH KEY
                   BELNR = WA_RC1-BELNR
                   GJAHR  = WA_RC1-GJAHR
                   TXGRP = WA_RC1-TXGRP.
     IF SY-SUBRC EQ 0.
       WA_RC1-HWSTE = WA_RC1-HWBAS.
       MODIFY IT_RC1 FROM WA_RC1 TRANSPORTING HWBAS.
     ENDIF.
   ENDLOOP.
 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NOTAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*&---------------------------------------------------------------------*
*&      Form  TDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM TDS .
   LOOP AT IT_BSEG INTO WA_BSEG WHERE QSSKZ NE '  '  AND QSSKZ NE 'XX'.

     IF WA_BSEG-SHKZG EQ 'S'.
       WA_BSEG-DMBTR = WA_BSEG-DMBTR * ( - 1 ).
     ENDIF.
     WA_TDS1-BELNR = WA_BSEG-BELNR.
     WA_TDS1-GJAHR = WA_BSEG-GJAHR.
     WA_TDS1-DMBTR = WA_BSEG-DMBTR.
     COLLECT WA_TDS1 INTO IT_TDS1.
     CLEAR WA_TDS1.
   ENDLOOP.
 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TOTVALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM TOTVALUE .
   LOOP AT IT_BSEG INTO WA_BSEG WHERE SHKZG EQ 'H'.
     WA_VAL1-BELNR = WA_BSEG-BELNR.
     WA_VAL1-GJAHR = WA_BSEG-GJAHR.
     WA_VAL1-DMBTR = WA_BSEG-DMBTR.
     COLLECT WA_VAL1 INTO IT_VAL1.
     CLEAR WA_VAL1.
   ENDLOOP.
 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM DETAILS .

   SORT IT_TAS3 BY BUDAT BELNR BUZEI.
   IT_TAS21[] = IT_TAS2.
   DELETE IT_TAS21 WHERE HWBAS EQ 0.
   SORT IT_TAS21 DESCENDING BY HWBAS.


   SORT IT_TAS3 BY TCODE BELNR.

*********************** NEW LOGIC FOR MANULA J_1IG_INV - DELETE FOR INTRA STATE************************** "26.9.2019
   LOOP AT IT_TAS3 INTO WA_TAS3 WHERE BLART EQ 'RE'.
     IF WA_TAS3-TCODE EQ 'FB05' OR WA_TAS3-TCODE EQ 'FB08'.
       WA_JTAB1-BELNR = WA_TAS3-BELNR.
       WA_JTAB1-GJAHR = WA_TAS3-GJAHR.
       WA_JTAB1-HWSTE = WA_TAS3-HWSTE.
       COLLECT WA_JTAB1 INTO IT_JTAB1.
       CLEAR WA_JTAB1.
     ENDIF.
   ENDLOOP.
   DELETE IT_JTAB1 WHERE HWSTE NE 0.
   LOOP AT IT_TAS3 INTO WA_TAS3 WHERE BLART EQ 'RE'.
     IF WA_TAS3-TCODE EQ 'FB05' OR WA_TAS3-TCODE EQ 'FB08'.
       READ TABLE IT_JTAB1 INTO WA_JTAB1 WITH KEY
                BELNR = WA_TAS3-BELNR
                GJAHR = WA_TAS3-GJAHR.
       IF SY-SUBRC EQ 0.
         DELETE IT_TAS3 WHERE BELNR = WA_JTAB1-BELNR AND
                              GJAHR = WA_JTAB1-GJAHR.
       ENDIF.
     ENDIF.
   ENDLOOP.
*********************************************************


   LOOP AT IT_TAS3 INTO WA_TAS3 .

     IF WA_TAS3-TCODE EQ 'VF01' OR WA_TAS3-TCODE = 'VF02'.
       WA_TAS4-BELNR = WA_TAS3-BELNR.
       WA_TAS4-GJAHR = WA_TAS3-GJAHR.
       WA_TAS4-TXGRP = WA_TAS3-TXGRP.
       WA_TAS4-TCODE = WA_TAS3-TCODE.
       WA_TAS4-USNAM = WA_TAS3-USNAM.
       WA_TAS4-BUPLA = WA_TAS3-BUPLA.
       WA_TAS4-BLART = WA_TAS3-BLART.
       WA_TAS4-STATUS = WA_TAS3-STATUS.
       WA_TAS4-GSBER = WA_TAS3-GSBER.
       WA_TAS4-BLDAT = WA_TAS3-BLDAT.
       WA_TAS4-BUDAT = WA_TAS3-BUDAT.
       WA_TAS4-GJAHR = WA_TAS3-GJAHR.
       WA_TAS4-DMBTR = WA_TAS3-DMBTR.
       WA_TAS4-MWSKZ = WA_TAS3-MWSKZ.
       WA_TAS4-HWBAS = WA_TAS3-HWBAS.
       WA_TAS4-HWSTE = WA_TAS3-HWSTE.
       WA_TAS4-CESS = WA_TAS3-CESS.
       WA_TAS4-IGST = WA_TAS3-IGST.
       WA_TAS4-SGST = WA_TAS3-SGST.
       WA_TAS4-UGST = WA_TAS3-UGST.
       WA_TAS4-CGST = WA_TAS3-CGST.
       WA_TAS4-SIG = WA_TAS3-SIG.
       WA_TAS4-RATE = WA_TAS3-RATE.
       WA_TAS4-TDS = WA_TAS3-TDS.
       WA_TAS4-BELNR_CLR = WA_TAS3-BELNR_CLR.
       WA_TAS4-AUGDT = WA_TAS3-AUGDT.
       WA_TAS4-XBLNR = WA_TAS3-XBLNR.
       WA_TAS4-VBELN = WA_TAS3-VBELN.
       WA_TAS4-STEUC = WA_TAS3-STEUC.
       WA_TAS4-MENGE = WA_TAS3-MENGE.
       WA_TAS4-MEINS = WA_TAS3-MEINS.
       WA_TAS4-HKONT = WA_TAS3-HKONT.
       WA_TAS4-LIFNR = WA_TAS3-LIFNR.
       WA_TAS4-NAME1 = WA_TAS3-NAME1.
       WA_TAS4-ORT01 = WA_TAS3-ORT01.
       WA_TAS4-VENREG = WA_TAS3-VENREG.
       WA_TAS4-STCD3 = WA_TAS3-STCD3.
       WA_TAS4-SGTXT = WA_TAS3-SGTXT.
       WA_TAS4-SCODE = WA_TAS3-SCODE.
       WA_TAS4-VEN_CL = WA_TAS3-VEN_CL.
       WA_TAS4-PAN = WA_TAS3-PAN.
       WA_TAS4-MBLNR = WA_TAS3-MBLNR.
       WA_TAS4-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
       WA_TAS4-RECP = WA_TAS3-RECP.
       WA_TAS4-RECP_DT = WA_TAS3-RECP_DT.
       WA_TAS4-RSTAT = WA_TAS3-RSTAT.

       COLLECT WA_TAS4 INTO IT_TAS4.
       CLEAR WA_TAS4.
     ELSE.
*********************** MANUAL J_1IG_INV by FB05, DOC TYPE - RE**************
       IF WA_TAS3-TCODE EQ 'FB05' AND WA_TAS3-BLART = 'RE'.
         WA_TAS4-BELNR = WA_TAS3-BELNR.
         WA_TAS4-GJAHR = WA_TAS3-GJAHR.
         WA_TAS4-TCODE = WA_TAS3-TCODE.
         WA_TAS4-USNAM = WA_TAS3-USNAM.
         WA_TAS4-BUPLA = WA_TAS3-BUPLA.
         WA_TAS4-BLART = WA_TAS3-BLART.
         WA_TAS4-STATUS = WA_TAS3-STATUS.
         WA_TAS4-GSBER = WA_TAS3-GSBER.
         WA_TAS4-BLDAT = WA_TAS3-BLDAT.
         WA_TAS4-BUDAT = WA_TAS3-BUDAT.
         WA_TAS4-GJAHR = WA_TAS3-GJAHR.
         WA_TAS4-DMBTR = WA_TAS3-DMBTR.
         WA_TAS4-MWSKZ = WA_TAS3-MWSKZ.
         WA_TAS4-HWBAS = WA_TAS3-HWBAS.
         WA_TAS4-HWSTE = WA_TAS3-HWSTE.
         WA_TAS4-CESS = WA_TAS3-CESS.
         WA_TAS4-IGST = WA_TAS3-IGST.
         WA_TAS4-SGST = WA_TAS3-SGST.
         WA_TAS4-UGST = WA_TAS3-UGST.
         WA_TAS4-CGST = WA_TAS3-CGST.
         WA_TAS4-SIG = WA_TAS3-SIG.
         WA_TAS4-RATE = WA_TAS3-RATE.
         WA_TAS4-TDS = WA_TAS3-TDS.
         WA_TAS4-BELNR_CLR = WA_TAS3-BELNR_CLR.
         WA_TAS4-AUGDT = WA_TAS3-AUGDT.
         WA_TAS4-XBLNR = WA_TAS3-XBLNR.
         WA_TAS4-VBELN = WA_TAS3-VBELN.
         WA_TAS4-STEUC = WA_TAS3-STEUC.
         WA_TAS4-MENGE = WA_TAS3-MENGE.
         WA_TAS4-MEINS = WA_TAS3-MEINS.
         WA_TAS4-HKONT = WA_TAS3-HKONT.
         WA_TAS4-LIFNR = WA_TAS3-LIFNR.
         WA_TAS4-NAME1 = WA_TAS3-NAME1.
         WA_TAS4-ORT01 = WA_TAS3-ORT01.
         WA_TAS4-VENREG = WA_TAS3-VENREG.
         WA_TAS4-STCD3 = WA_TAS3-STCD3.
         WA_TAS4-SGTXT = WA_TAS3-SGTXT.
         WA_TAS4-SCODE = WA_TAS3-SCODE.
         WA_TAS4-VEN_CL = WA_TAS3-VEN_CL.
         WA_TAS4-PAN = WA_TAS3-PAN.
         WA_TAS4-MBLNR = WA_TAS3-MBLNR.
         WA_TAS4-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
         WA_TAS4-RECP = WA_TAS3-RECP.
         WA_TAS4-RECP_DT = WA_TAS3-RECP_DT.
         WA_TAS4-RSTAT = WA_TAS3-RSTAT.

         COLLECT WA_TAS4 INTO IT_TAS4.
         CLEAR WA_TAS4.

***********************************************************************
       ELSE.
********************* ISD ENTRIES ************************************
         SELECT SINGLE * FROM ZPREG_ISD WHERE
            BELNR EQ WA_TAS3-BELNR AND
            GJAHR = WA_TAS3-GJAHR.
         IF SY-SUBRC EQ 0.

           WA_ISD1-BELNR = WA_TAS3-BELNR.
           WA_ISD1-GJAHR = WA_TAS3-GJAHR.
           WA_ISD1-TCODE = WA_TAS3-TCODE.
           WA_ISD1-USNAM = WA_TAS3-USNAM.
           WA_ISD1-BUPLA = WA_TAS3-BUPLA.
           WA_ISD1-BLART = WA_TAS3-BLART.
           WA_ISD1-STATUS = WA_TAS3-STATUS.
           WA_ISD1-GSBER = WA_TAS3-GSBER.
           WA_ISD1-BLDAT = WA_TAS3-BLDAT.
           WA_ISD1-BUDAT = WA_TAS3-BUDAT.
           WA_ISD1-GJAHR = WA_TAS3-GJAHR.
           WA_ISD1-DMBTR = WA_TAS3-DMBTR.
           WA_ISD1-MWSKZ = WA_TAS3-MWSKZ.
           WA_ISD1-HWBAS = WA_TAS3-HWBAS.
           WA_ISD1-HWSTE = WA_TAS3-HWSTE.
           WA_ISD1-CESS = WA_TAS3-CESS.
           WA_ISD1-IGST = WA_TAS3-IGST.
           WA_ISD1-SGST = WA_TAS3-SGST.
           WA_ISD1-UGST = WA_TAS3-UGST.
           WA_ISD1-CGST = WA_TAS3-CGST.
           WA_ISD1-SIG = WA_TAS3-SIG.
           WA_ISD1-RATE = WA_TAS3-RATE.
           WA_ISD1-TDS = WA_TAS3-TDS.
           WA_ISD1-BELNR_CLR = WA_TAS3-BELNR_CLR.
           WA_ISD1-AUGDT = WA_TAS3-AUGDT.
           WA_ISD1-XBLNR = WA_TAS3-XBLNR.
           WA_ISD1-VBELN = WA_TAS3-VBELN.
           WA_ISD1-STEUC = WA_TAS3-STEUC.
           WA_ISD1-MENGE = WA_TAS3-MENGE.
           WA_ISD1-MEINS = WA_TAS3-MEINS.
           WA_ISD1-HKONT = WA_TAS3-HKONT.
           WA_ISD1-LIFNR = WA_TAS3-LIFNR.
           WA_ISD1-NAME1 = WA_TAS3-NAME1.
           WA_ISD1-ORT01 = WA_TAS3-ORT01.
           WA_ISD1-VENREG = WA_TAS3-VENREG.
           WA_ISD1-STCD3 = WA_TAS3-STCD3.
           WA_ISD1-SGTXT = WA_TAS3-SGTXT.
           WA_ISD1-SCODE = WA_TAS3-SCODE.
           WA_ISD1-VEN_CL = WA_TAS3-VEN_CL.
           WA_ISD1-PAN = WA_TAS3-PAN.
           WA_ISD1-MBLNR = WA_TAS3-MBLNR.
           WA_ISD1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
           WA_ISD1-RECP = WA_TAS3-RECP.
           WA_ISD1-RECP_DT = WA_TAS3-RECP_DT.
           WA_ISD1-RSTAT = WA_TAS3-RSTAT.

****************************************


           COLLECT WA_ISD1 INTO IT_ISD1.
           CLEAR WA_ISD1.

         ELSE.

********************** ISD GL - 2818,2819,2820 ************************************************
           SELECT SINGLE * FROM BSIS WHERE BUKRS EQ '1000' AND
             HKONT IN ( '0000028180','0000028190',
                        '0000028200' ,'0000028210' )
             AND BELNR EQ WA_TAS3-BELNR AND GJAHR EQ WA_TAS3-GJAHR.
           IF SY-SUBRC EQ 0.

             SELECT SINGLE * FROM ZPREG_REMISD WHERE
                        BELNR EQ WA_TAS3-BELNR AND
                        GJAHR EQ WA_TAS3-GJAHR.
             IF SY-SUBRC EQ 0.
               WA_TAS7-BELNR = WA_TAS3-BELNR.
               WA_TAS7-GJAHR = WA_TAS3-GJAHR.
               WA_TAS7-TCODE = WA_TAS3-TCODE.
               WA_TAS7-USNAM = WA_TAS3-USNAM.
               WA_TAS7-BUPLA = WA_TAS3-BUPLA.
               WA_TAS7-BLART = WA_TAS3-BLART.
               WA_TAS7-STATUS = WA_TAS3-STATUS.
               WA_TAS7-GSBER = WA_TAS3-GSBER.
               WA_TAS7-BLDAT = WA_TAS3-BLDAT.
               WA_TAS7-BUDAT = WA_TAS3-BUDAT.
               WA_TAS7-GJAHR = WA_TAS3-GJAHR.
               WA_TAS7-DMBTR = WA_TAS3-DMBTR.
               WA_TAS7-MWSKZ = WA_TAS3-MWSKZ.
               WA_TAS7-HWBAS = WA_TAS3-HWBAS.
               WA_TAS7-HWSTE = WA_TAS3-HWSTE.
               WA_TAS7-CESS = WA_TAS3-CESS.
               WA_TAS7-IGST = WA_TAS3-IGST.
               WA_TAS7-SGST = WA_TAS3-SGST.
               WA_TAS7-UGST = WA_TAS3-UGST.
               WA_TAS7-CGST = WA_TAS3-CGST.
               WA_TAS7-SIG = WA_TAS3-SIG.
               WA_TAS7-RATE = WA_TAS3-RATE.
               WA_TAS7-TDS = WA_TAS3-TDS.
               WA_TAS7-BELNR_CLR = WA_TAS3-BELNR_CLR.
               WA_TAS7-AUGDT = WA_TAS3-AUGDT.
               WA_TAS7-XBLNR = WA_TAS3-XBLNR.
               WA_TAS7-VBELN = WA_TAS3-VBELN.
               WA_TAS7-STEUC = WA_TAS3-STEUC.
               WA_TAS7-MENGE = WA_TAS3-MENGE.
               WA_TAS7-MEINS = WA_TAS3-MEINS.
               WA_TAS7-HKONT = WA_TAS3-HKONT.
               WA_TAS7-LIFNR = WA_TAS3-LIFNR.
               WA_TAS7-NAME1 = WA_TAS3-NAME1.
               WA_TAS7-ORT01 = WA_TAS3-ORT01.
               WA_TAS7-VENREG = WA_TAS3-VENREG.
               WA_TAS7-STCD3 = WA_TAS3-STCD3.
               WA_TAS7-SGTXT = WA_TAS3-SGTXT.
               WA_TAS7-SCODE = WA_TAS3-SCODE.
               WA_TAS7-VEN_CL = WA_TAS3-VEN_CL.
               WA_TAS7-PAN = WA_TAS3-PAN.
               WA_TAS7-MBLNR = WA_TAS3-MBLNR.
               WA_TAS7-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
               WA_TAS7-RECP = WA_TAS3-RECP.
               WA_TAS7-RECP_DT = WA_TAS3-RECP_DT.
               WA_TAS7-RSTAT = WA_TAS3-RSTAT.
               COLLECT WA_TAS7 INTO IT_TAS7.
               CLEAR WA_TAS7.

             ELSE.
               WA_ISD1-BELNR = WA_TAS3-BELNR.
               WA_ISD1-GJAHR = WA_TAS3-GJAHR.
               WA_ISD1-TCODE = WA_TAS3-TCODE.
               WA_ISD1-USNAM = WA_TAS3-USNAM.
               WA_ISD1-BUPLA = WA_TAS3-BUPLA.
               WA_ISD1-BLART = WA_TAS3-BLART.
               WA_ISD1-STATUS = WA_TAS3-STATUS.
               WA_ISD1-GSBER = WA_TAS3-GSBER.
               WA_ISD1-BLDAT = WA_TAS3-BLDAT.
               WA_ISD1-BUDAT = WA_TAS3-BUDAT.
               WA_ISD1-GJAHR = WA_TAS3-GJAHR.
               WA_ISD1-DMBTR = WA_TAS3-DMBTR.
               WA_ISD1-MWSKZ = WA_TAS3-MWSKZ.
               WA_ISD1-HWBAS = WA_TAS3-HWBAS.
               WA_ISD1-HWSTE = WA_TAS3-HWSTE.
               WA_ISD1-CESS = WA_TAS3-CESS.
               WA_ISD1-IGST = WA_TAS3-IGST.
               WA_ISD1-SGST = WA_TAS3-SGST.
               WA_ISD1-UGST = WA_TAS3-UGST.
               WA_ISD1-CGST = WA_TAS3-CGST.
               WA_ISD1-SIG = WA_TAS3-SIG.
               WA_ISD1-RATE = WA_TAS3-RATE.
               WA_ISD1-TDS = WA_TAS3-TDS.
               WA_ISD1-BELNR_CLR = WA_TAS3-BELNR_CLR.
               WA_ISD1-AUGDT = WA_TAS3-AUGDT.
               WA_ISD1-XBLNR = WA_TAS3-XBLNR.
               WA_ISD1-VBELN = WA_TAS3-VBELN.
               WA_ISD1-STEUC = WA_TAS3-STEUC.
               WA_ISD1-MENGE = WA_TAS3-MENGE.
               WA_ISD1-MEINS = WA_TAS3-MEINS.
               WA_ISD1-HKONT = WA_TAS3-HKONT.
               WA_ISD1-LIFNR = WA_TAS3-LIFNR.
               WA_ISD1-NAME1 = WA_TAS3-NAME1.
               WA_ISD1-ORT01 = WA_TAS3-ORT01.
               WA_ISD1-VENREG = WA_TAS3-VENREG.
               WA_ISD1-STCD3 = WA_TAS3-STCD3.
               WA_ISD1-SGTXT = WA_TAS3-SGTXT.
               WA_ISD1-SCODE = WA_TAS3-SCODE.
               WA_ISD1-VEN_CL = WA_TAS3-VEN_CL.
               WA_ISD1-PAN = WA_TAS3-PAN.
               WA_ISD1-MBLNR = WA_TAS3-MBLNR.
               WA_ISD1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
               WA_ISD1-RECP = WA_TAS3-RECP.
               WA_ISD1-RECP_DT = WA_TAS3-RECP_DT.
               WA_ISD1-RSTAT = WA_TAS3-RSTAT.
*********************


               COLLECT WA_ISD1 INTO IT_ISD1.
               CLEAR WA_ISD1.
             ENDIF.
           ELSE.
             SELECT SINGLE * FROM BSAS WHERE BUKRS EQ '1000'
                  AND HKONT IN ( '0000028180','0000028190',
                                 '0000028200' ,'0000028210' )
           AND BELNR EQ WA_TAS3-BELNR AND
                    GJAHR EQ WA_TAS3-GJAHR.  "added on 19.12.22
             IF SY-SUBRC EQ 0.

               WA_ISD1-BELNR = WA_TAS3-BELNR.
               WA_ISD1-GJAHR = WA_TAS3-GJAHR.
               WA_ISD1-TCODE = WA_TAS3-TCODE.
               WA_ISD1-USNAM = WA_TAS3-USNAM.
               WA_ISD1-BUPLA = WA_TAS3-BUPLA.
               WA_ISD1-BLART = WA_TAS3-BLART.
               WA_ISD1-STATUS = WA_TAS3-STATUS.
               WA_ISD1-GSBER = WA_TAS3-GSBER.
               WA_ISD1-BLDAT = WA_TAS3-BLDAT.
               WA_ISD1-BUDAT = WA_TAS3-BUDAT.
               WA_ISD1-GJAHR = WA_TAS3-GJAHR.
               WA_ISD1-DMBTR = WA_TAS3-DMBTR.
               WA_ISD1-MWSKZ = WA_TAS3-MWSKZ.
               WA_ISD1-HWBAS = WA_TAS3-HWBAS.
               WA_ISD1-HWSTE = WA_TAS3-HWSTE.
               WA_ISD1-CESS = WA_TAS3-CESS.
               WA_ISD1-IGST = WA_TAS3-IGST.
               WA_ISD1-SGST = WA_TAS3-SGST.
               WA_ISD1-UGST = WA_TAS3-UGST.
               WA_ISD1-CGST = WA_TAS3-CGST.
               WA_ISD1-SIG = WA_TAS3-SIG.
               WA_ISD1-RATE = WA_TAS3-RATE.
               WA_ISD1-TDS = WA_TAS3-TDS.
               WA_ISD1-BELNR_CLR = WA_TAS3-BELNR_CLR.
               WA_ISD1-AUGDT = WA_TAS3-AUGDT.
               WA_ISD1-XBLNR = WA_TAS3-XBLNR.
               WA_ISD1-VBELN = WA_TAS3-VBELN.
               WA_ISD1-STEUC = WA_TAS3-STEUC.
               WA_ISD1-MENGE = WA_TAS3-MENGE.
               WA_ISD1-MEINS = WA_TAS3-MEINS.
               WA_ISD1-HKONT = WA_TAS3-HKONT.
               WA_ISD1-LIFNR = WA_TAS3-LIFNR.
               WA_ISD1-NAME1 = WA_TAS3-NAME1.
               WA_ISD1-ORT01 = WA_TAS3-ORT01.
               WA_ISD1-VENREG = WA_TAS3-VENREG.
               WA_ISD1-STCD3 = WA_TAS3-STCD3.
               WA_ISD1-SGTXT = WA_TAS3-SGTXT.
               WA_ISD1-SCODE = WA_TAS3-SCODE.
               WA_ISD1-VEN_CL = WA_TAS3-VEN_CL.
               WA_ISD1-PAN = WA_TAS3-PAN.
               WA_ISD1-MBLNR = WA_TAS3-MBLNR.
               WA_ISD1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
               WA_ISD1-RECP = WA_TAS3-RECP.
               WA_ISD1-RECP_DT = WA_TAS3-RECP_DT.
               WA_ISD1-RSTAT = WA_TAS3-RSTAT.
*********************


               COLLECT WA_ISD1 INTO IT_ISD1.
               CLEAR WA_ISD1.
             ELSE.
               SELECT SINGLE * FROM BSIS WHERE BUKRS EQ '1000'
                                           AND HKONT IN ( '0000028330',
                                                          '0000028340',
                                                          '0000028350' )
            AND BELNR EQ WA_TAS3-BELNR AND GJAHR EQ WA_TAS3-GJAHR.
               IF SY-SUBRC EQ 0.
                 SELECT SINGLE * FROM ZPREG_REMISD WHERE
                         BELNR EQ WA_TAS3-BELNR AND
                         GJAHR EQ WA_TAS3-GJAHR. "17.5.22
                 IF SY-SUBRC EQ 0.
                   WA_TAS5ING-BELNR = WA_TAS3-BELNR.
                   WA_TAS5ING-GJAHR = WA_TAS3-GJAHR.
                   WA_TAS5ING-TCODE = WA_TAS3-TCODE.
                   WA_TAS5ING-USNAM = WA_TAS3-USNAM.
                   WA_TAS5ING-BUPLA = WA_TAS3-BUPLA.
                   WA_TAS5ING-BLART = WA_TAS3-BLART.
                   WA_TAS5ING-STATUS = WA_TAS3-STATUS.
                   WA_TAS5ING-GSBER = WA_TAS3-GSBER.
                   WA_TAS5ING-BLDAT = WA_TAS3-BLDAT.
                   WA_TAS5ING-BUDAT = WA_TAS3-BUDAT.
                   WA_TAS5ING-GJAHR = WA_TAS3-GJAHR.
                   WA_TAS5ING-DMBTR = WA_TAS3-DMBTR.
                   WA_TAS5ING-MWSKZ = WA_TAS3-MWSKZ.
                   WA_TAS5ING-HWBAS = WA_TAS3-HWBAS.
                   WA_TAS5ING-HWSTE = WA_TAS3-HWSTE.
                   WA_TAS5ING-CESS = WA_TAS3-CESS.
                   WA_TAS5ING-IGST = WA_TAS3-IGST.
                   WA_TAS5ING-SGST = WA_TAS3-SGST.
                   WA_TAS5ING-UGST = WA_TAS3-UGST.
                   WA_TAS5ING-CGST = WA_TAS3-CGST.
                   WA_TAS5ING-SIG = WA_TAS3-SIG.
                   WA_TAS5ING-RATE = WA_TAS3-RATE.
                   WA_TAS5ING-TDS = WA_TAS3-TDS.
                   WA_TAS5ING-BELNR_CLR = WA_TAS3-BELNR_CLR.
                   WA_TAS5ING-AUGDT = WA_TAS3-AUGDT.
                   WA_TAS5ING-XBLNR = WA_TAS3-XBLNR.
                   WA_TAS5ING-VBELN = WA_TAS3-VBELN.
                   WA_TAS5ING-STEUC = WA_TAS3-STEUC.
                   WA_TAS5ING-MENGE = WA_TAS3-MENGE.
                   WA_TAS5ING-MEINS = WA_TAS3-MEINS.
                   WA_TAS5ING-HKONT = WA_TAS3-HKONT.
                   WA_TAS5ING-LIFNR = WA_TAS3-LIFNR.
                   WA_TAS5ING-NAME1 = WA_TAS3-NAME1.
                   WA_TAS5ING-ORT01 = WA_TAS3-ORT01.
                   WA_TAS5ING-VENREG = WA_TAS3-VENREG.
                   WA_TAS5ING-STCD3 = WA_TAS3-STCD3.
                   WA_TAS5ING-SGTXT = WA_TAS3-SGTXT.
                   WA_TAS5ING-SCODE = WA_TAS3-SCODE.
                   WA_TAS5ING-VEN_CL = WA_TAS3-VEN_CL.
                   WA_TAS5ING-PAN = WA_TAS3-PAN.
                   WA_TAS5ING-MBLNR = WA_TAS3-MBLNR.
                   WA_TAS5ING-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                   WA_TAS5ING-RECP = WA_TAS3-RECP.
                   WA_TAS5ING-RECP_DT = WA_TAS3-RECP_DT.
                   WA_TAS5ING-RSTAT = WA_TAS3-RSTAT.
                   COLLECT WA_TAS5ING INTO IT_TAS5ING.
                   CLEAR WA_TAS5ING.

                 ELSE.
                   WA_INGISD1-BELNR = WA_TAS3-BELNR.
                   WA_INGISD1-GJAHR = WA_TAS3-GJAHR.
                   WA_INGISD1-TCODE = WA_TAS3-TCODE.
                   WA_INGISD1-USNAM = WA_TAS3-USNAM.
                   WA_INGISD1-BUPLA = WA_TAS3-BUPLA.
                   WA_INGISD1-BLART = WA_TAS3-BLART.
                   WA_INGISD1-STATUS = WA_TAS3-STATUS.
                   WA_INGISD1-GSBER = WA_TAS3-GSBER.
                   WA_INGISD1-BLDAT = WA_TAS3-BLDAT.
                   WA_INGISD1-BUDAT = WA_TAS3-BUDAT.
                   WA_INGISD1-GJAHR = WA_TAS3-GJAHR.
                   WA_INGISD1-DMBTR = WA_TAS3-DMBTR.
                   WA_INGISD1-MWSKZ = WA_TAS3-MWSKZ.
                   WA_INGISD1-HWBAS = WA_TAS3-HWBAS.
                   WA_INGISD1-HWSTE = WA_TAS3-HWSTE.
                   WA_INGISD1-CESS = WA_TAS3-CESS.
                   WA_INGISD1-IGST = WA_TAS3-IGST.
                   WA_INGISD1-SGST = WA_TAS3-SGST.
                   WA_INGISD1-UGST = WA_TAS3-UGST.
                   WA_INGISD1-CGST = WA_TAS3-CGST.
                   WA_INGISD1-SIG = WA_TAS3-SIG.
                   WA_INGISD1-RATE = WA_TAS3-RATE.
                   WA_INGISD1-TDS = WA_TAS3-TDS.
                   WA_INGISD1-BELNR_CLR = WA_TAS3-BELNR_CLR.
                   WA_INGISD1-AUGDT = WA_TAS3-AUGDT.
                   WA_INGISD1-XBLNR = WA_TAS3-XBLNR.
                   WA_INGISD1-VBELN = WA_TAS3-VBELN.
                   WA_INGISD1-STEUC = WA_TAS3-STEUC.
                   WA_INGISD1-MENGE = WA_TAS3-MENGE.
                   WA_INGISD1-MEINS = WA_TAS3-MEINS.
                   WA_INGISD1-HKONT = WA_TAS3-HKONT.
                   WA_INGISD1-LIFNR = WA_TAS3-LIFNR.
                   WA_INGISD1-NAME1 = WA_TAS3-NAME1.
                   WA_INGISD1-ORT01 = WA_TAS3-ORT01.
                   WA_INGISD1-VENREG = WA_TAS3-VENREG.
                   WA_INGISD1-STCD3 = WA_TAS3-STCD3.
                   WA_INGISD1-SGTXT = WA_TAS3-SGTXT.
                   WA_INGISD1-SCODE = WA_TAS3-SCODE.
                   WA_INGISD1-VEN_CL = WA_TAS3-VEN_CL.
                   WA_INGISD1-PAN = WA_TAS3-PAN.
                   WA_INGISD1-MBLNR = WA_TAS3-MBLNR.
                   WA_INGISD1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                   WA_INGISD1-RECP = WA_TAS3-RECP.
                   WA_INGISD1-RECP_DT = WA_TAS3-RECP_DT.
                   WA_INGISD1-RSTAT = WA_TAS3-RSTAT.
*********************


                   COLLECT WA_INGISD1 INTO IT_INGISD1.
                   CLEAR WA_INGISD1.
                 ENDIF.

               ELSE.

********************** SALES PROMOTION *****************************
                 SELECT SINGLE * FROM ZPREG_DOC_CAT WHERE
                               BELNR EQ WA_TAS3-BELNR AND
                               GJAHR EQ WA_TAS3-GJAHR AND
                               BLART EQ 'SP'.
                 IF SY-SUBRC EQ 0.
                   WA_TASP1-BELNR = WA_TAS3-BELNR.
                   WA_TASP1-GJAHR = WA_TAS3-GJAHR.
                   WA_TASP1-TCODE = WA_TAS3-TCODE.
                   WA_TASP1-USNAM = WA_TAS3-USNAM.
                   WA_TASP1-BUPLA = WA_TAS3-BUPLA.
                   WA_TASP1-BLART = WA_TAS3-BLART.
                   WA_TASP1-STATUS = WA_TAS3-STATUS.
                   WA_TASP1-GSBER = WA_TAS3-GSBER.
                   WA_TASP1-BLDAT = WA_TAS3-BLDAT.
                   WA_TASP1-BUDAT = WA_TAS3-BUDAT.
                   WA_TASP1-GJAHR = WA_TAS3-GJAHR.
                   WA_TASP1-DMBTR = WA_TAS3-DMBTR.
                   WA_TASP1-MWSKZ = WA_TAS3-MWSKZ.
                   WA_TASP1-HWBAS = WA_TAS3-HWBAS.
                   WA_TASP1-HWSTE = WA_TAS3-HWSTE.
                   WA_TASP1-CESS = WA_TAS3-CESS.
                   WA_TASP1-IGST = WA_TAS3-IGST.
                   WA_TASP1-SGST = WA_TAS3-SGST.
                   WA_TASP1-UGST = WA_TAS3-UGST.
                   WA_TASP1-CGST = WA_TAS3-CGST.
                   WA_TASP1-SIG = WA_TAS3-SIG.
                   WA_TASP1-RATE = WA_TAS3-RATE.
                   WA_TASP1-TDS = WA_TAS3-TDS.
                   WA_TASP1-BELNR_CLR = WA_TAS3-BELNR_CLR.
                   WA_TASP1-AUGDT = WA_TAS3-AUGDT.
                   WA_TASP1-XBLNR = WA_TAS3-XBLNR.
                   WA_TASP1-VBELN = WA_TAS3-VBELN.
                   WA_TASP1-STEUC = WA_TAS3-STEUC.
                   WA_TASP1-MENGE = WA_TAS3-MENGE.
                   WA_TASP1-MEINS = WA_TAS3-MEINS.
                   WA_TASP1-HKONT = WA_TAS3-HKONT.
                   WA_TASP1-LIFNR = WA_TAS3-LIFNR.
                   WA_TASP1-NAME1 = WA_TAS3-NAME1.
                   WA_TASP1-ORT01 = WA_TAS3-ORT01.
                   WA_TASP1-VENREG = WA_TAS3-VENREG.
                   WA_TASP1-STCD3 = WA_TAS3-STCD3.
                   WA_TASP1-SGTXT = WA_TAS3-SGTXT.
                   WA_TASP1-SCODE = WA_TAS3-SCODE.
                   WA_TASP1-VEN_CL = WA_TAS3-VEN_CL.
                   WA_TASP1-PAN = WA_TAS3-PAN.
                   WA_TASP1-MBLNR = WA_TAS3-MBLNR.
                   WA_TASP1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                   WA_TASP1-RECP = WA_TAS3-RECP.
                   WA_TASP1-RECP_DT = WA_TAS3-RECP_DT.
                   WA_TASP1-RSTAT = WA_TAS3-RSTAT.
**************************
                   COLLECT WA_TASP1 INTO IT_TASP1.
                   CLEAR WA_TASP1.
                 ELSE.


                   SELECT SINGLE * FROM ZPREG_DOC_CAT WHERE
                                BELNR EQ WA_TAS3-BELNR AND
                                GJAHR EQ WA_TAS3-GJAHR AND
                                BLART EQ 'CC'.
                   IF SY-SUBRC EQ 0.
                     WA_TACC1-BELNR = WA_TAS3-BELNR.
                     WA_TACC1-GJAHR = WA_TAS3-GJAHR.
                     WA_TACC1-TCODE = WA_TAS3-TCODE.
                     WA_TACC1-USNAM = WA_TAS3-USNAM.
                     WA_TACC1-BUPLA = WA_TAS3-BUPLA.
                     WA_TACC1-BLART = WA_TAS3-BLART.
                     WA_TACC1-STATUS = WA_TAS3-STATUS.
                     WA_TACC1-GSBER = WA_TAS3-GSBER.
                     WA_TACC1-BLDAT = WA_TAS3-BLDAT.
                     WA_TACC1-BUDAT = WA_TAS3-BUDAT.
                     WA_TACC1-GJAHR = WA_TAS3-GJAHR.
                     WA_TACC1-DMBTR = WA_TAS3-DMBTR.
                     WA_TACC1-MWSKZ = WA_TAS3-MWSKZ.
                     WA_TACC1-HWBAS = WA_TAS3-HWBAS.
                     WA_TACC1-HWSTE = WA_TAS3-HWSTE.
                     WA_TACC1-CESS = WA_TAS3-CESS.
                     WA_TACC1-IGST = WA_TAS3-IGST.
                     WA_TACC1-SGST = WA_TAS3-SGST.
                     WA_TACC1-UGST = WA_TAS3-UGST.
                     WA_TACC1-CGST = WA_TAS3-CGST.
                     WA_TACC1-SIG = WA_TAS3-SIG.
                     WA_TACC1-RATE = WA_TAS3-RATE.
                     WA_TACC1-TDS = WA_TAS3-TDS.
                     WA_TACC1-BELNR_CLR = WA_TAS3-BELNR_CLR.
                     WA_TACC1-AUGDT = WA_TAS3-AUGDT.
                     WA_TACC1-XBLNR = WA_TAS3-XBLNR.
                     WA_TACC1-VBELN = WA_TAS3-VBELN.
                     WA_TACC1-STEUC = WA_TAS3-STEUC.
                     WA_TACC1-MENGE = WA_TAS3-MENGE.
                     WA_TACC1-MEINS = WA_TAS3-MEINS.
                     WA_TACC1-HKONT = WA_TAS3-HKONT.
                     WA_TACC1-LIFNR = WA_TAS3-LIFNR.
                     WA_TACC1-NAME1 = WA_TAS3-NAME1.
                     WA_TACC1-ORT01 = WA_TAS3-ORT01.
                     WA_TACC1-VENREG = WA_TAS3-VENREG.
                     WA_TACC1-STCD3 = WA_TAS3-STCD3.
                     WA_TACC1-SGTXT = WA_TAS3-SGTXT.
                     WA_TACC1-SCODE = WA_TAS3-SCODE.
                     WA_TACC1-VEN_CL = WA_TAS3-VEN_CL.
                     WA_TACC1-PAN = WA_TAS3-PAN.
                     WA_TACC1-MBLNR = WA_TAS3-MBLNR.
                     WA_TACC1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                     WA_TACC1-RECP = WA_TAS3-RECP.
                     WA_TACC1-RECP_DT = WA_TAS3-RECP_DT.
                     WA_TACC1-RSTAT = WA_TAS3-RSTAT.

                     COLLECT WA_TACC1 INTO IT_TACC1.
                     CLEAR WA_TACC1.
                   ELSE.

****************************
                     IF WA_TAS3-STATUS EQ 'JRC'.

                       WA_JRC1-BELNR = WA_TAS3-BELNR.
                       WA_JRC1-GJAHR = WA_TAS3-GJAHR.
                       WA_JRC1-TCODE = WA_TAS3-TCODE.
                       WA_JRC1-USNAM = WA_TAS3-USNAM.
                       WA_JRC1-BUPLA = WA_TAS3-BUPLA.
                       WA_JRC1-BLART = WA_TAS3-BLART.
                       WA_JRC1-STATUS = WA_TAS3-STATUS.
                       WA_JRC1-GSBER = WA_TAS3-GSBER.
                       WA_JRC1-BLDAT = WA_TAS3-BLDAT.
                       WA_JRC1-BUDAT = WA_TAS3-BUDAT.
                       WA_JRC1-GJAHR = WA_TAS3-GJAHR.
                       WA_JRC1-DMBTR = WA_TAS3-DMBTR.
                       WA_JRC1-MWSKZ = WA_TAS3-MWSKZ.
                       WA_JRC1-HWBAS = WA_TAS3-HWBAS.
                       WA_JRC1-HWSTE = WA_TAS3-HWSTE.
                       WA_JRC1-CESS = WA_TAS3-CESS.
                       WA_JRC1-IGST = WA_TAS3-IGST.
                       WA_JRC1-SGST = WA_TAS3-SGST.
                       WA_JRC1-UGST = WA_TAS3-UGST.
                       WA_JRC1-CGST = WA_TAS3-CGST.
                       WA_JRC1-SIG = WA_TAS3-SIG.
                       WA_JRC1-RATE = WA_TAS3-RATE.
                       WA_JRC1-TDS = WA_TAS3-TDS.
                       WA_JRC1-BELNR_CLR = WA_TAS3-BELNR_CLR.
                       WA_JRC1-AUGDT = WA_TAS3-AUGDT.
                       WA_JRC1-XBLNR = WA_TAS3-XBLNR.
                       WA_JRC1-VBELN = WA_TAS3-VBELN.
                       WA_JRC1-STEUC = WA_TAS3-STEUC.
                       WA_JRC1-MENGE = WA_TAS3-MENGE.
                       WA_JRC1-MEINS = WA_TAS3-MEINS.
                       WA_JRC1-HKONT = WA_TAS3-HKONT.
                       WA_JRC1-LIFNR = WA_TAS3-LIFNR.
                       WA_JRC1-NAME1 = WA_TAS3-NAME1.
                       WA_JRC1-ORT01 = WA_TAS3-ORT01.
                       WA_JRC1-VENREG = WA_TAS3-VENREG.
                       WA_JRC1-STCD3 = WA_TAS3-STCD3.
                       WA_JRC1-SGTXT = WA_TAS3-SGTXT.
                       WA_JRC1-SCODE = WA_TAS3-SCODE.
                       WA_JRC1-VEN_CL = WA_TAS3-VEN_CL.
                       WA_JRC1-PAN = WA_TAS3-PAN.
                       WA_JRC1-MBLNR = WA_TAS3-MBLNR.
                       WA_JRC1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                       WA_JRC1-RECP = WA_TAS3-RECP.
                       WA_JRC1-RECP_DT = WA_TAS3-RECP_DT.
                       WA_JRC1-RSTAT = WA_TAS3-RSTAT.

*************************
                       COLLECT WA_JRC1 INTO IT_JRC1.
                       CLEAR WA_JRC1.
                     ELSE.
*******************************

                       IF ( WA_TAS3-MWSKZ GE 'O1' AND
                            WA_TAS3-MWSKZ LE 'OZ' ) OR
                            WA_TAS3-MWSKZ EQ 'IE'.

                         WA_TAS5ING-BELNR = WA_TAS3-BELNR.
                         WA_TAS5ING-GJAHR = WA_TAS3-GJAHR.
                         WA_TAS5ING-TCODE = WA_TAS3-TCODE.
                         WA_TAS5ING-USNAM = WA_TAS3-USNAM.
                         WA_TAS5ING-BUPLA = WA_TAS3-BUPLA.
                         WA_TAS5ING-BLART = WA_TAS3-BLART.
                         WA_TAS5ING-STATUS = WA_TAS3-STATUS.
                         WA_TAS5ING-GSBER = WA_TAS3-GSBER.
                         WA_TAS5ING-BLDAT = WA_TAS3-BLDAT.
                         WA_TAS5ING-BUDAT = WA_TAS3-BUDAT.
                         WA_TAS5ING-GJAHR = WA_TAS3-GJAHR.
                         WA_TAS5ING-DMBTR = WA_TAS3-DMBTR.
                         WA_TAS5ING-MWSKZ = WA_TAS3-MWSKZ.
                         WA_TAS5ING-HWBAS = WA_TAS3-HWBAS.
                         WA_TAS5ING-HWSTE = WA_TAS3-HWSTE.
                         WA_TAS5ING-CESS = WA_TAS3-CESS.
                         WA_TAS5ING-IGST = WA_TAS3-IGST.
                         WA_TAS5ING-SGST = WA_TAS3-SGST.
                         WA_TAS5ING-UGST = WA_TAS3-UGST.
                         WA_TAS5ING-CGST = WA_TAS3-CGST.
                         WA_TAS5ING-SIG = WA_TAS3-SIG.
                         WA_TAS5ING-RATE = WA_TAS3-RATE.
                         WA_TAS5ING-TDS = WA_TAS3-TDS.
                         WA_TAS5ING-BELNR_CLR = WA_TAS3-BELNR_CLR.
                         WA_TAS5ING-AUGDT = WA_TAS3-AUGDT.
                         WA_TAS5ING-XBLNR = WA_TAS3-XBLNR.
                         WA_TAS5ING-VBELN = WA_TAS3-VBELN.
                         WA_TAS5ING-STEUC = WA_TAS3-STEUC.
                         WA_TAS5ING-MENGE = WA_TAS3-MENGE.
                         WA_TAS5ING-MEINS = WA_TAS3-MEINS.
                         WA_TAS5ING-HKONT = WA_TAS3-HKONT.
                         WA_TAS5ING-LIFNR = WA_TAS3-LIFNR.
                         WA_TAS5ING-NAME1 = WA_TAS3-NAME1.
                         WA_TAS5ING-ORT01 = WA_TAS3-ORT01.
                         WA_TAS5ING-VENREG = WA_TAS3-VENREG.
                         WA_TAS5ING-STCD3 = WA_TAS3-STCD3.
                         WA_TAS5ING-SGTXT = WA_TAS3-SGTXT.
                         WA_TAS5ING-SCODE = WA_TAS3-SCODE.
                         WA_TAS5ING-VEN_CL = WA_TAS3-VEN_CL.
                         WA_TAS5ING-PAN = WA_TAS3-PAN.
                         WA_TAS5ING-MBLNR = WA_TAS3-MBLNR.
                         WA_TAS5ING-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                         WA_TAS5ING-RECP = WA_TAS3-RECP.
                         WA_TAS5ING-RECP_DT = WA_TAS3-RECP_DT.
                         WA_TAS5ING-RSTAT = WA_TAS3-RSTAT.
********************************
                         COLLECT WA_TAS5ING INTO IT_TAS5ING.
                         CLEAR WA_TAS5ING.
                       ELSE.
                         IF WA_TAS3-STATUS EQ 'ING'.
                           WA_TAJI1-BELNR = WA_TAS3-BELNR.
                           WA_TAJI1-GJAHR = WA_TAS3-GJAHR.
                           WA_TAJI1-TCODE = WA_TAS3-TCODE.
                           WA_TAJI1-USNAM = WA_TAS3-USNAM.
                           WA_TAJI1-BUPLA = WA_TAS3-BUPLA.
                           WA_TAJI1-BLART = WA_TAS3-BLART.
                           WA_TAJI1-STATUS = WA_TAS3-STATUS.
                           WA_TAJI1-GSBER = WA_TAS3-GSBER.
                           WA_TAJI1-BLDAT = WA_TAS3-BLDAT.
                           WA_TAJI1-BUDAT = WA_TAS3-BUDAT.
                           WA_TAJI1-GJAHR = WA_TAS3-GJAHR.
                           WA_TAJI1-DMBTR = WA_TAS3-DMBTR.
                           WA_TAJI1-MWSKZ = WA_TAS3-MWSKZ.
                           WA_TAJI1-HWBAS = WA_TAS3-HWBAS.
                           WA_TAJI1-HWSTE = WA_TAS3-HWSTE.
                           WA_TAJI1-CESS = WA_TAS3-CESS.
                           WA_TAJI1-IGST = WA_TAS3-IGST.
                           WA_TAJI1-SGST = WA_TAS3-SGST.
                           WA_TAJI1-UGST = WA_TAS3-UGST.
                           WA_TAJI1-CGST = WA_TAS3-CGST.
                           WA_TAJI1-SIG = WA_TAS3-SIG.
                           WA_TAJI1-RATE = WA_TAS3-RATE.
                           WA_TAJI1-TDS = WA_TAS3-TDS.
                           WA_TAJI1-BELNR_CLR = WA_TAS3-BELNR_CLR.
                           WA_TAJI1-AUGDT = WA_TAS3-AUGDT.
                           WA_TAJI1-XBLNR = WA_TAS3-XBLNR.
                           WA_TAJI1-VBELN = WA_TAS3-VBELN.
                           WA_TAJI1-STEUC = WA_TAS3-STEUC.
                           WA_TAJI1-MENGE = WA_TAS3-MENGE.
                           WA_TAJI1-MEINS = WA_TAS3-MEINS.
                           WA_TAJI1-HKONT = WA_TAS3-HKONT.
                           WA_TAJI1-LIFNR = WA_TAS3-LIFNR.
                           WA_TAJI1-NAME1 = WA_TAS3-NAME1.
                           WA_TAJI1-ORT01 = WA_TAS3-ORT01.
                           WA_TAJI1-VENREG = WA_TAS3-VENREG.
                           WA_TAJI1-STCD3 = WA_TAS3-STCD3.
                           WA_TAJI1-SGTXT = WA_TAS3-SGTXT.
                           WA_TAJI1-SCODE = WA_TAS3-SCODE.
                           WA_TAJI1-VEN_CL = WA_TAS3-VEN_CL.
                           WA_TAJI1-PAN = WA_TAS3-PAN.
                           WA_TAJI1-MBLNR = WA_TAS3-MBLNR.
                           WA_TAJI1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                           WA_TAJI1-RECP = WA_TAS3-RECP.
                           WA_TAJI1-RECP_DT = WA_TAS3-RECP_DT.
                           WA_TAJI1-RSTAT = WA_TAS3-RSTAT.

*************************
                           COLLECT WA_TAJI1 INTO IT_TAJI1.
                           CLEAR WA_TAJI1.
                         ELSE.
************************ jv passed ****************************************
                           IF WA_TAS3-BLART EQ 'J1' OR
                              WA_TAS3-BLART EQ 'J2' OR
                              WA_TAS3-BLART EQ 'AX' OR
                              WA_TAS3-BLART EQ 'AB'.

                             WA_TAJ1-BELNR = WA_TAS3-BELNR.
                             WA_TAJ1-GJAHR = WA_TAS3-GJAHR.
                             WA_TAJ1-TCODE = WA_TAS3-TCODE.
                             WA_TAJ1-USNAM = WA_TAS3-USNAM.
                             WA_TAJ1-BUPLA = WA_TAS3-BUPLA.
                             WA_TAJ1-BLART = WA_TAS3-BLART.
                             WA_TAJ1-STATUS = WA_TAS3-STATUS.
                             WA_TAJ1-GSBER = WA_TAS3-GSBER.
                             WA_TAJ1-BLDAT = WA_TAS3-BLDAT.
                             WA_TAJ1-BUDAT = WA_TAS3-BUDAT.
                             WA_TAJ1-GJAHR = WA_TAS3-GJAHR.
                             WA_TAJ1-DMBTR = WA_TAS3-DMBTR.
                             WA_TAJ1-MWSKZ = WA_TAS3-MWSKZ.
                             WA_TAJ1-HWBAS = WA_TAS3-HWBAS.
                             WA_TAJ1-HWSTE = WA_TAS3-HWSTE.
                             WA_TAJ1-CESS = WA_TAS3-CESS.
                             WA_TAJ1-IGST = WA_TAS3-IGST.
                             WA_TAJ1-SGST = WA_TAS3-SGST.
                             WA_TAJ1-UGST = WA_TAS3-UGST.
                             WA_TAJ1-CGST = WA_TAS3-CGST.
                             WA_TAJ1-SIG = WA_TAS3-SIG.
                             WA_TAJ1-RATE = WA_TAS3-RATE.
                             WA_TAJ1-TDS = WA_TAS3-TDS.
                             WA_TAJ1-BELNR_CLR = WA_TAS3-BELNR_CLR.
                             WA_TAJ1-AUGDT = WA_TAS3-AUGDT.
                             WA_TAJ1-XBLNR = WA_TAS3-XBLNR.
                             WA_TAJ1-VBELN = WA_TAS3-VBELN.
                             WA_TAJ1-STEUC = WA_TAS3-STEUC.
                             WA_TAJ1-MENGE = WA_TAS3-MENGE.
                             WA_TAJ1-MEINS = WA_TAS3-MEINS.
                             WA_TAJ1-HKONT = WA_TAS3-HKONT.
                             WA_TAJ1-LIFNR = WA_TAS3-LIFNR.
                             WA_TAJ1-NAME1 = WA_TAS3-NAME1.
                             WA_TAJ1-ORT01 = WA_TAS3-ORT01.
                             WA_TAJ1-VENREG = WA_TAS3-VENREG.
                             WA_TAJ1-STCD3 = WA_TAS3-STCD3.
                             WA_TAJ1-SGTXT = WA_TAS3-SGTXT.
                             WA_TAJ1-SCODE = WA_TAS3-SCODE.
                             WA_TAJ1-VEN_CL = WA_TAS3-VEN_CL.
                             WA_TAJ1-PAN = WA_TAS3-PAN.
                             WA_TAJ1-MBLNR = WA_TAS3-MBLNR.
                             WA_TAJ1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                             WA_TAJ1-RECP = WA_TAS3-RECP.
                             WA_TAJ1-RECP_DT = WA_TAS3-RECP_DT.
                             WA_TAJ1-RSTAT = WA_TAS3-RSTAT.

*************************
                             COLLECT WA_TAJ1 INTO IT_TAJ1.
                             CLEAR WA_TAJ1.
**************** IMPORT ************************************
                           ELSE.
                             IF WA_TAS3-LIFNR GE '0000025000' AND
                                WA_TAS3-LIFNR LE '0000025999'.

                               WA_TAI1-BELNR = WA_TAS3-BELNR.
                               WA_TAI1-GJAHR = WA_TAS3-GJAHR.
                               WA_TAI1-TCODE = WA_TAS3-TCODE.
                               WA_TAI1-USNAM = WA_TAS3-USNAM.
                               WA_TAI1-BUPLA = WA_TAS3-BUPLA.
                               WA_TAI1-BLART = WA_TAS3-BLART.
                               WA_TAI1-STATUS = WA_TAS3-STATUS.
                               WA_TAI1-GSBER = WA_TAS3-GSBER.
                               WA_TAI1-BLDAT = WA_TAS3-BLDAT.
                               WA_TAI1-BUDAT = WA_TAS3-BUDAT.
                               WA_TAI1-GJAHR = WA_TAS3-GJAHR.
                               WA_TAI1-DMBTR = WA_TAS3-DMBTR.
                               WA_TAI1-MWSKZ = WA_TAS3-MWSKZ.
                               WA_TAI1-HWBAS = WA_TAS3-HWBAS.
                               WA_TAI1-HWSTE = WA_TAS3-HWSTE.
                               WA_TAI1-CESS = WA_TAS3-CESS.
                               WA_TAI1-IGST = WA_TAS3-IGST.
                               WA_TAI1-SGST = WA_TAS3-SGST.
                               WA_TAI1-UGST = WA_TAS3-UGST.
                               WA_TAI1-CGST = WA_TAS3-CGST.
                               WA_TAI1-SIG = WA_TAS3-SIG.
                               WA_TAI1-RATE = WA_TAS3-RATE.
                               WA_TAI1-TDS = WA_TAS3-TDS.
                               WA_TAI1-BELNR_CLR = WA_TAS3-BELNR_CLR.
                               WA_TAI1-AUGDT = WA_TAS3-AUGDT.
                               WA_TAI1-XBLNR = WA_TAS3-XBLNR.
                               WA_TAI1-VBELN = WA_TAS3-VBELN.
                               WA_TAI1-STEUC = WA_TAS3-STEUC.
                               WA_TAI1-MENGE = WA_TAS3-MENGE.
                               WA_TAI1-MEINS = WA_TAS3-MEINS.
                               WA_TAI1-HKONT = WA_TAS3-HKONT.
                               WA_TAI1-LIFNR = WA_TAS3-LIFNR.
                               WA_TAI1-NAME1 = WA_TAS3-NAME1.
                               WA_TAI1-ORT01 = WA_TAS3-ORT01.
                               WA_TAI1-VENREG = WA_TAS3-VENREG.
                               WA_TAI1-STCD3 = WA_TAS3-STCD3.
                               WA_TAI1-SGTXT = WA_TAS3-SGTXT.
                               WA_TAI1-SCODE = WA_TAS3-SCODE.
                               WA_TAI1-VEN_CL = WA_TAS3-VEN_CL.
                               WA_TAI1-PAN = WA_TAS3-PAN.
                               WA_TAI1-MBLNR = WA_TAS3-MBLNR.
                               WA_TAI1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                               WA_TAI1-RECP = WA_TAS3-RECP.
                               WA_TAI1-RECP_DT = WA_TAS3-RECP_DT.
                               WA_TAI1-RSTAT = WA_TAS3-RSTAT.
***********************
                               COLLECT WA_TAI1 INTO IT_TAI1.
                               CLEAR WA_TAI1.
                             ELSE.
************** CAPITAL GOODS****************************
                               IF  WA_TAS3-HKONT GE '0000020000' AND
                                   WA_TAS3-HKONT LE '0000020300'.
                                 WA_TAC1-BELNR = WA_TAS3-BELNR.
                                 WA_TAC1-GJAHR = WA_TAS3-GJAHR.
                                 WA_TAC1-TCODE = WA_TAS3-TCODE.
                                 WA_TAC1-USNAM = WA_TAS3-USNAM.
                                 WA_TAC1-BUPLA = WA_TAS3-BUPLA.
                                 WA_TAC1-BLART = WA_TAS3-BLART.
                                 WA_TAC1-STATUS = WA_TAS3-STATUS.
                                 WA_TAC1-GSBER = WA_TAS3-GSBER.
                                 WA_TAC1-BLDAT = WA_TAS3-BLDAT.
                                 WA_TAC1-BUDAT = WA_TAS3-BUDAT.
                                 WA_TAC1-GJAHR = WA_TAS3-GJAHR.
                                 WA_TAC1-DMBTR = WA_TAS3-DMBTR.
                                 WA_TAC1-MWSKZ = WA_TAS3-MWSKZ.
                                 WA_TAC1-HWBAS = WA_TAS3-HWBAS.
                                 WA_TAC1-HWSTE = WA_TAS3-HWSTE.
                                 WA_TAC1-CESS = WA_TAS3-CESS.
                                 WA_TAC1-IGST = WA_TAS3-IGST.
                                 WA_TAC1-SGST = WA_TAS3-SGST.
                                 WA_TAC1-UGST = WA_TAS3-UGST.
                                 WA_TAC1-CGST = WA_TAS3-CGST.
                                 WA_TAC1-SIG = WA_TAS3-SIG.
                                 WA_TAC1-RATE = WA_TAS3-RATE.
                                 WA_TAC1-TDS = WA_TAS3-TDS.
                                 WA_TAC1-BELNR_CLR = WA_TAS3-BELNR_CLR.
                                 WA_TAC1-AUGDT = WA_TAS3-AUGDT.
                                 WA_TAC1-XBLNR = WA_TAS3-XBLNR.
                                 WA_TAC1-VBELN = WA_TAS3-VBELN.
                                 WA_TAC1-STEUC = WA_TAS3-STEUC.
                                 WA_TAC1-MENGE = WA_TAS3-MENGE.
                                 WA_TAC1-MEINS = WA_TAS3-MEINS.
                                 WA_TAC1-HKONT = WA_TAS3-HKONT.
                                 WA_TAC1-LIFNR = WA_TAS3-LIFNR.
                                 WA_TAC1-NAME1 = WA_TAS3-NAME1.
                                 WA_TAC1-ORT01 = WA_TAS3-ORT01.
                                 WA_TAC1-VENREG = WA_TAS3-VENREG.
                                 WA_TAC1-STCD3 = WA_TAS3-STCD3.
                                 WA_TAC1-SGTXT = WA_TAS3-SGTXT.
                                 WA_TAC1-SCODE = WA_TAS3-SCODE.
                                 WA_TAC1-VEN_CL = WA_TAS3-VEN_CL.
                                 WA_TAC1-PAN = WA_TAS3-PAN.
                                 WA_TAC1-MBLNR = WA_TAS3-MBLNR.
                                 WA_TAC1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                                 WA_TAC1-RECP = WA_TAS3-RECP.
                                 WA_TAC1-RECP_DT = WA_TAS3-RECP_DT.
                                 WA_TAC1-RSTAT = WA_TAS3-RSTAT.
*************************************
                                 COLLECT WA_TAC1 INTO IT_TAC1.
                                 CLEAR WA_TAC1.
**********************************************************
                               ELSE.
                                 IF ( WA_TAS3-MWSKZ GE 'O1' AND
                                      WA_TAS3-MWSKZ LE 'OZ' ) OR
                                      WA_TAS3-MWSKZ EQ 'IE'.

                                   WA_TAS5ING-BELNR = WA_TAS3-BELNR.
                                   WA_TAS5ING-GJAHR = WA_TAS3-GJAHR.
                                   WA_TAS5ING-TCODE = WA_TAS3-TCODE.
                                   WA_TAS5ING-USNAM = WA_TAS3-USNAM.
                                   WA_TAS5ING-BUPLA = WA_TAS3-BUPLA.
                                   WA_TAS5ING-BLART = WA_TAS3-BLART.
                                   WA_TAS5ING-STATUS = WA_TAS3-STATUS.
                                   WA_TAS5ING-GSBER = WA_TAS3-GSBER.
                                   WA_TAS5ING-BLDAT = WA_TAS3-BLDAT.
                                   WA_TAS5ING-BUDAT = WA_TAS3-BUDAT.
                                   WA_TAS5ING-GJAHR = WA_TAS3-GJAHR.
                                   WA_TAS5ING-DMBTR = WA_TAS3-DMBTR.
                                   WA_TAS5ING-MWSKZ = WA_TAS3-MWSKZ.
                                   WA_TAS5ING-HWBAS = WA_TAS3-HWBAS.
                                   WA_TAS5ING-HWSTE = WA_TAS3-HWSTE.
                                   WA_TAS5ING-CESS = WA_TAS3-CESS.
                                   WA_TAS5ING-IGST = WA_TAS3-IGST.
                                   WA_TAS5ING-SGST = WA_TAS3-SGST.
                                   WA_TAS5ING-UGST = WA_TAS3-UGST.
                                   WA_TAS5ING-CGST = WA_TAS3-CGST.
                                   WA_TAS5ING-SIG = WA_TAS3-SIG.
                                   WA_TAS5ING-RATE = WA_TAS3-RATE.
                                   WA_TAS5ING-TDS = WA_TAS3-TDS.
                                   WA_TAS5ING-BELNR_CLR = WA_TAS3-BELNR_CLR.
                                   WA_TAS5ING-AUGDT = WA_TAS3-AUGDT.
                                   WA_TAS5ING-XBLNR = WA_TAS3-XBLNR.
                                   WA_TAS5ING-VBELN = WA_TAS3-VBELN.
                                   WA_TAS5ING-STEUC = WA_TAS3-STEUC.
                                   WA_TAS5ING-MENGE = WA_TAS3-MENGE.
                                   WA_TAS5ING-MEINS = WA_TAS3-MEINS.
                                   WA_TAS5ING-HKONT = WA_TAS3-HKONT.
                                   WA_TAS5ING-LIFNR = WA_TAS3-LIFNR.
                                   WA_TAS5ING-NAME1 = WA_TAS3-NAME1.
                                   WA_TAS5ING-ORT01 = WA_TAS3-ORT01.
                                   WA_TAS5ING-VENREG = WA_TAS3-VENREG.
                                   WA_TAS5ING-STCD3 = WA_TAS3-STCD3.
                                   WA_TAS5ING-SGTXT = WA_TAS3-SGTXT.
                                   WA_TAS5ING-SCODE = WA_TAS3-SCODE.
                                   WA_TAS5ING-VEN_CL = WA_TAS3-VEN_CL.
                                   WA_TAS5ING-PAN = WA_TAS3-PAN.
                                   WA_TAS5ING-MBLNR = WA_TAS3-MBLNR.
                                   WA_TAS5ING-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                                   WA_TAS5ING-RECP = WA_TAS3-RECP.
                                   WA_TAS5ING-RECP_DT = WA_TAS3-RECP_DT.
                                   WA_TAS5ING-RSTAT = WA_TAS3-RSTAT.

********************************
                                   COLLECT WA_TAS5ING INTO IT_TAS5ING.
                                   CLEAR WA_TAS5ING.
                                 ELSE.
*********************** RCM LIABILITY8888888888888
                                   IF WA_TAS3-TCODE EQ 'MIRO' OR WA_TAS3-TCODE EQ 'MR8M'.
                                     SELECT SINGLE * FROM RSEG WHERE
                                        BELNR EQ WA_TAS3-BELNR AND
                                        GJAHR EQ WA_TAS3-GJAHR AND
                                        TBTKZ EQ 'X' AND
                                        SHKZG EQ 'H'.
                                     IF SY-SUBRC EQ 0.

                                       WA_TAS9-BELNR = WA_TAS3-BELNR.
                                       WA_TAS9-GJAHR = WA_TAS3-GJAHR.
                                       WA_TAS9-TCODE = WA_TAS3-TCODE.
                                       WA_TAS9-USNAM = WA_TAS3-USNAM.
                                       WA_TAS9-BUPLA = WA_TAS3-BUPLA.
                                       WA_TAS9-BLART = WA_TAS3-BLART.
                                       WA_TAS9-STATUS = WA_TAS3-STATUS.
                                       WA_TAS9-GSBER = WA_TAS3-GSBER.
                                       WA_TAS9-BLDAT = WA_TAS3-BLDAT.
                                       WA_TAS9-BUDAT = WA_TAS3-BUDAT.
                                       WA_TAS9-GJAHR = WA_TAS3-GJAHR.
                                       WA_TAS9-DMBTR = WA_TAS3-DMBTR.
                                       WA_TAS9-MWSKZ = WA_TAS3-MWSKZ.
                                       WA_TAS9-HWBAS = WA_TAS3-HWBAS.
                                       WA_TAS9-HWSTE = WA_TAS3-HWSTE.
                                       WA_TAS9-CESS = WA_TAS3-CESS.
                                       WA_TAS9-IGST = WA_TAS3-IGST.
                                       WA_TAS9-SGST = WA_TAS3-SGST.
                                       WA_TAS9-UGST = WA_TAS3-UGST.
                                       WA_TAS9-CGST = WA_TAS3-CGST.
                                       WA_TAS9-SIG = WA_TAS3-SIG.
                                       WA_TAS9-RATE = WA_TAS3-RATE.
                                       WA_TAS9-TDS = WA_TAS3-TDS.
                                       WA_TAS9-BELNR_CLR = WA_TAS3-BELNR_CLR.
                                       WA_TAS9-AUGDT = WA_TAS3-AUGDT.
                                       WA_TAS9-XBLNR = WA_TAS3-XBLNR.
                                       WA_TAS9-VBELN = WA_TAS3-VBELN.
                                       WA_TAS9-STEUC = WA_TAS3-STEUC.
                                       WA_TAS9-MENGE = WA_TAS3-MENGE.
                                       WA_TAS9-MEINS = WA_TAS3-MEINS.
                                       WA_TAS9-HKONT = WA_TAS3-HKONT.
                                       WA_TAS9-LIFNR = WA_TAS3-LIFNR.
                                       WA_TAS9-NAME1 = WA_TAS3-NAME1.
                                       WA_TAS9-ORT01 = WA_TAS3-ORT01.
                                       WA_TAS9-VENREG = WA_TAS3-VENREG.
                                       WA_TAS9-STCD3 = WA_TAS3-STCD3.
                                       WA_TAS9-SGTXT = WA_TAS3-SGTXT.
                                       WA_TAS9-SCODE = WA_TAS3-SCODE.
                                       WA_TAS9-VEN_CL = WA_TAS3-VEN_CL.
                                       WA_TAS9-PAN = WA_TAS3-PAN.
                                       WA_TAS9-MBLNR = WA_TAS3-MBLNR.
                                       WA_TAS9-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                                       WA_TAS9-RECP = WA_TAS3-RECP.
                                       WA_TAS9-RECP_DT = WA_TAS3-RECP_DT.
                                       WA_TAS9-RSTAT = WA_TAS3-RSTAT.
************************************
                                       COLLECT WA_TAS9 INTO IT_TAS9.
                                       CLEAR WA_TAS9.
                                     ELSE.
                                       WA_TAS10-BELNR = WA_TAS3-BELNR.
                                       WA_TAS10-GJAHR = WA_TAS3-GJAHR.
                                       WA_TAS10-TXGRP = WA_TAS3-TXGRP.  "22.7.21
                                       WA_TAS10-TCODE = WA_TAS3-TCODE.
                                       WA_TAS10-USNAM = WA_TAS3-USNAM.
                                       WA_TAS10-BUPLA = WA_TAS3-BUPLA.
                                       WA_TAS10-BLART = WA_TAS3-BLART.
                                       WA_TAS10-STATUS = WA_TAS3-STATUS.
                                       WA_TAS10-GSBER = WA_TAS3-GSBER.
                                       WA_TAS10-BLDAT = WA_TAS3-BLDAT.
                                       WA_TAS10-BUDAT = WA_TAS3-BUDAT.
                                       WA_TAS10-GJAHR = WA_TAS3-GJAHR.
                                       WA_TAS10-DMBTR = WA_TAS3-DMBTR.
                                       WA_TAS10-MWSKZ = WA_TAS3-MWSKZ.
                                       WA_TAS10-HWBAS = WA_TAS3-HWBAS.
                                       WA_TAS10-HWSTE = WA_TAS3-HWSTE.
                                       WA_TAS10-CESS = WA_TAS3-CESS.
                                       WA_TAS10-IGST = WA_TAS3-IGST.
                                       WA_TAS10-SGST = WA_TAS3-SGST.
                                       WA_TAS10-UGST = WA_TAS3-UGST.
                                       WA_TAS10-CGST = WA_TAS3-CGST.
                                       WA_TAS10-SIG = WA_TAS3-SIG.
                                       WA_TAS10-RATE = WA_TAS3-RATE.
                                       WA_TAS10-TDS = WA_TAS3-TDS.
                                       WA_TAS10-BELNR_CLR = WA_TAS3-BELNR_CLR.
                                       WA_TAS10-AUGDT = WA_TAS3-AUGDT.
                                       WA_TAS10-XBLNR = WA_TAS3-XBLNR.
                                       WA_TAS10-VBELN = WA_TAS3-VBELN.
                                       WA_TAS10-STEUC = WA_TAS3-STEUC.
                                       WA_TAS10-MENGE = WA_TAS3-MENGE.
                                       WA_TAS10-MEINS = WA_TAS3-MEINS.
                                       WA_TAS10-HKONT = WA_TAS3-HKONT.
                                       WA_TAS10-LIFNR = WA_TAS3-LIFNR.
                                       WA_TAS10-NAME1 = WA_TAS3-NAME1.
                                       WA_TAS10-ORT01 = WA_TAS3-ORT01.
                                       WA_TAS10-VENREG = WA_TAS3-VENREG.
                                       WA_TAS10-STCD3 = WA_TAS3-STCD3.
                                       WA_TAS10-SGTXT = WA_TAS3-SGTXT.
                                       WA_TAS10-SCODE = WA_TAS3-SCODE.
                                       WA_TAS10-VEN_CL = WA_TAS3-VEN_CL.
                                       WA_TAS10-PAN = WA_TAS3-PAN.
                                       WA_TAS10-MBLNR = WA_TAS3-MBLNR.
                                       WA_TAS10-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                                       WA_TAS10-RECP = WA_TAS3-RECP.
                                       WA_TAS10-RECP_DT = WA_TAS3-RECP_DT.
                                       WA_TAS10-RSTAT = WA_TAS3-RSTAT.
**************************************
                                       COLLECT WA_TAS10 INTO IT_TAS10.
                                       CLEAR WA_TAS10.
                                     ENDIF.
                                   ELSE.
                                     READ TABLE IT_TAS2 INTO WA_TAS2 WITH
                                     KEY BELNR = WA_TAS3-BELNR
                                         GJAHR = WA_TAS3-GJAHR
                                         TXGRP = WA_TAS3-TXGRP
                                         STATUS = 'RCM'.
                                     IF SY-SUBRC EQ 0.
                                       WA_TAS5-BELNR = WA_TAS3-BELNR.
                                       WA_TAS5-GJAHR = WA_TAS3-GJAHR.
                                       WA_TAS5-TCODE = WA_TAS3-TCODE.
                                       WA_TAS5-USNAM = WA_TAS3-USNAM.
                                       WA_TAS5-BUPLA = WA_TAS3-BUPLA.
                                       WA_TAS5-BLART = WA_TAS3-BLART.
                                       WA_TAS5-STATUS = WA_TAS3-STATUS.
                                       WA_TAS5-GSBER = WA_TAS3-GSBER.
                                       WA_TAS5-BLDAT = WA_TAS3-BLDAT.
                                       WA_TAS5-BUDAT = WA_TAS3-BUDAT.
                                       WA_TAS5-GJAHR = WA_TAS3-GJAHR.
                                       WA_TAS5-DMBTR = WA_TAS3-DMBTR.
                                       WA_TAS5-MWSKZ = WA_TAS3-MWSKZ.
                                       WA_TAS5-HWBAS = WA_TAS3-HWBAS.
                                       WA_TAS5-HWSTE = WA_TAS3-HWSTE.
                                       WA_TAS5-CESS = WA_TAS3-CESS.
                                       WA_TAS5-IGST = WA_TAS3-IGST.
                                       WA_TAS5-SGST = WA_TAS3-SGST.
                                       WA_TAS5-UGST = WA_TAS3-UGST.
                                       WA_TAS5-CGST = WA_TAS3-CGST.
                                       WA_TAS5-SIG = WA_TAS3-SIG.
                                       WA_TAS5-RATE = WA_TAS3-RATE.
                                       WA_TAS5-TDS = WA_TAS3-TDS.
                                       WA_TAS5-BELNR_CLR = WA_TAS3-BELNR_CLR.
                                       WA_TAS5-AUGDT = WA_TAS3-AUGDT.
                                       WA_TAS5-XBLNR = WA_TAS3-XBLNR.
                                       WA_TAS5-VBELN = WA_TAS3-VBELN.
                                       WA_TAS5-STEUC = WA_TAS3-STEUC.
                                       WA_TAS5-MENGE = WA_TAS3-MENGE.
                                       WA_TAS5-MEINS = WA_TAS3-MEINS.
                                       WA_TAS5-HKONT = WA_TAS3-HKONT.
                                       WA_TAS5-LIFNR = WA_TAS3-LIFNR.
                                       WA_TAS5-NAME1 = WA_TAS3-NAME1.
                                       WA_TAS5-ORT01 = WA_TAS3-ORT01.
                                       WA_TAS5-VENREG = WA_TAS3-VENREG.
                                       WA_TAS5-STCD3 = WA_TAS3-STCD3.
                                       WA_TAS5-SGTXT = WA_TAS3-SGTXT.
                                       WA_TAS5-SCODE = WA_TAS3-SCODE.
                                       WA_TAS5-VEN_CL = WA_TAS3-VEN_CL.
                                       WA_TAS5-PAN = WA_TAS3-PAN.
                                       WA_TAS5-MBLNR = WA_TAS3-MBLNR.
                                       WA_TAS5-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                                       WA_TAS5-RECP = WA_TAS3-RECP.
                                       WA_TAS5-RECP_DT = WA_TAS3-RECP_DT.
                                       WA_TAS5-RSTAT = WA_TAS3-RSTAT.
*********************************************
                                       COLLECT WA_TAS5 INTO IT_TAS5.
                                       CLEAR WA_TAS5.
                                     ELSE.
                                       WA_TAS7-BELNR = WA_TAS3-BELNR.
                                       WA_TAS7-GJAHR = WA_TAS3-GJAHR.
                                       WA_TAS7-TCODE = WA_TAS3-TCODE.
                                       WA_TAS7-USNAM = WA_TAS3-USNAM.
                                       WA_TAS7-BUPLA = WA_TAS3-BUPLA.
                                       WA_TAS7-BLART = WA_TAS3-BLART.
                                       WA_TAS7-STATUS = WA_TAS3-STATUS.
                                       WA_TAS7-GSBER = WA_TAS3-GSBER.
                                       WA_TAS7-BLDAT = WA_TAS3-BLDAT.
                                       WA_TAS7-BUDAT = WA_TAS3-BUDAT.
                                       WA_TAS7-GJAHR = WA_TAS3-GJAHR.
                                       WA_TAS7-DMBTR = WA_TAS3-DMBTR.
                                       WA_TAS7-MWSKZ = WA_TAS3-MWSKZ.
                                       WA_TAS7-HWBAS = WA_TAS3-HWBAS.
                                       WA_TAS7-HWSTE = WA_TAS3-HWSTE.
                                       WA_TAS7-CESS = WA_TAS3-CESS.
                                       WA_TAS7-IGST = WA_TAS3-IGST.
                                       WA_TAS7-SGST = WA_TAS3-SGST.
                                       WA_TAS7-UGST = WA_TAS3-UGST.
                                       WA_TAS7-CGST = WA_TAS3-CGST.
                                       WA_TAS7-SIG = WA_TAS3-SIG.
                                       WA_TAS7-RATE = WA_TAS3-RATE.
                                       WA_TAS7-TDS = WA_TAS3-TDS.
                                       WA_TAS7-BELNR_CLR = WA_TAS3-BELNR_CLR.
                                       WA_TAS7-AUGDT = WA_TAS3-AUGDT.
                                       WA_TAS7-XBLNR = WA_TAS3-XBLNR.
                                       WA_TAS7-VBELN = WA_TAS3-VBELN.
                                       WA_TAS7-STEUC = WA_TAS3-STEUC.
                                       WA_TAS7-MENGE = WA_TAS3-MENGE.
                                       WA_TAS7-MEINS = WA_TAS3-MEINS.
                                       WA_TAS7-HKONT = WA_TAS3-HKONT.
                                       WA_TAS7-LIFNR = WA_TAS3-LIFNR.
                                       WA_TAS7-NAME1 = WA_TAS3-NAME1.
                                       WA_TAS7-ORT01 = WA_TAS3-ORT01.
                                       WA_TAS7-VENREG = WA_TAS3-VENREG.
                                       WA_TAS7-STCD3 = WA_TAS3-STCD3.
                                       WA_TAS7-SGTXT = WA_TAS3-SGTXT.
                                       WA_TAS7-SCODE = WA_TAS3-SCODE.
                                       WA_TAS7-VEN_CL = WA_TAS3-VEN_CL.
                                       WA_TAS7-PAN = WA_TAS3-PAN.
                                       WA_TAS7-MBLNR = WA_TAS3-MBLNR.
                                       WA_TAS7-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
                                       WA_TAS7-RECP = WA_TAS3-RECP.
                                       WA_TAS7-RECP_DT = WA_TAS3-RECP_DT.
                                       WA_TAS7-RSTAT = WA_TAS3-RSTAT.
                                       COLLECT WA_TAS7 INTO IT_TAS7.
                                       CLEAR WA_TAS7.
                                     ENDIF.
                                   ENDIF.
                                 ENDIF.
                               ENDIF.
                             ENDIF.
                           ENDIF.
                         ENDIF.
                       ENDIF.
                     ENDIF.
                   ENDIF.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.
   ENDLOOP.

   LOOP AT IT_TAS5 INTO WA_TAS5.
     CLEAR : RRP2,RRP3,RRP4.
     IF WA_TAS5-MWSKZ EQ 'V0' OR WA_TAS5-HWSTE EQ 0.
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.
       RRP4 = 1.
     ELSEIF  WA_TAS5-MWSKZ EQ 'R1' OR
             WA_TAS5-MWSKZ EQ 'R2' OR
             WA_TAS5-MWSKZ EQ 'R3' OR
             WA_TAS5-MWSKZ EQ 'R4' OR
             WA_TAS5-MWSKZ EQ 'R5' or
             WA_TAS5-MWSKZ EQ 'R6' OR
             WA_TAS5-MWSKZ EQ 'R7' OR
             WA_TAS5-MWSKZ EQ 'R8'.
**************************************************
       RRP3 = 1.
       IF  WA_TAS5-HWSTE GT 0.  "changes om 9.6.2019
         WA_ALV1-TEXT = 'H. ITC AVAILABLE ON EXPENSES(RCM) INELIGIBLE'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000' AND
           BELNR EQ WA_TAS5-BELNR AND
           GJAHR = WA_TAS5-GJAHR AND
           XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'B. RCM LIABILITY'.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS5-BELNR
           AND GJAHR = WA_TAS5-GJAHR
           AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAS5-BELNR
             AND GJAHR = WA_TAS5-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'B. RCM LIABILITY'.
           ENDIF.
         ENDIF.
       ELSE.
         WA_ALV1-TEXT = 'B. RCM LIABILITY'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS5-BELNR
           AND GJAHR = WA_TAS5-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'H. ITC AVAILABLE ON EXPENSES(RCM) INELIGIBLE'.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAS5-BELNR
             AND GJAHR = WA_TAS5-GJAHR
             AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAS5-BELNR
             AND GJAHR = WA_TAS5-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'H. ITC AVAILABLE ON EXPENSES(RCM) INELIGIBLE'.
           ENDIF.
         ENDIF.
       ENDIF.
**********************************************************
     ELSE.
       RRP3 = 1.
       IF WA_TAS5-HWSTE LT 0.
         WA_ALV1-TEXT = 'B. RCM LIABILITY'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS5-BELNR
           AND GJAHR = WA_TAS5-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'H. ITC AVAILABLE ON EXPENSES(RCM)'.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS5-BELNR
           AND GJAHR = WA_TAS5-GJAHR
           AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAS5-BELNR
             AND GJAHR = WA_TAS5-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'H. ITC AVAILABLE ON EXPENSES(RCM)'.
           ENDIF.
         ENDIF.
       ELSE.
         WA_ALV1-TEXT = 'H. ITC AVAILABLE ON EXPENSES(RCM)'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS5-BELNR
           AND GJAHR = WA_TAS5-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'B. RCM LIABILITY'.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS5-BELNR
           AND GJAHR = WA_TAS5-GJAHR
           AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAS5-BELNR
             AND GJAHR = WA_TAS5-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'B. RCM LIABILITY'.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.

     WA_ALV1-BUDAT = WA_TAS5-BUDAT.
     WA_ALV1-TCODE = WA_TAS5-TCODE.
     WA_ALV1-USNAM = WA_TAS5-USNAM.
     WA_ALV1-BUPLA = WA_TAS5-BUPLA.
     WA_ALV1-GSBER = WA_TAS5-GSBER.
     WA_ALV1-BELNR = WA_TAS5-BELNR.
     WA_ALV1-BLDAT = WA_TAS5-BLDAT.
     WA_ALV1-XBLNR = WA_TAS5-XBLNR.
     WA_ALV1-VBELN = WA_TAS5-VBELN.
     WA_ALV1-STEUC = WA_TAS5-STEUC.
     WA_ALV1-MENGE = WA_TAS5-MENGE.
     WA_ALV1-MEINS = WA_TAS5-MEINS.
     WA_ALV1-GJAHR = WA_TAS5-GJAHR.
     WA_ALV1-HKONT = WA_TAS5-HKONT.
     WA_ALV1-LIFNR = WA_TAS5-LIFNR.
     WA_ALV1-NAME1 = WA_TAS5-NAME1.
     WA_ALV1-MWSKZ = WA_TAS5-MWSKZ.
     WA_ALV1-DMBTR = WA_TAS5-DMBTR.
     WA_ALV1-HWBAS = WA_TAS5-HWBAS.
     WA_ALV1-HWSTE = WA_TAS5-HWSTE.
     WA_ALV1-IGST = WA_TAS5-IGST.
     WA_ALV1-SGST = WA_TAS5-SGST.
     WA_ALV1-UGST = WA_TAS5-UGST.
     WA_ALV1-CGST = WA_TAS5-CGST.
     WA_ALV1-SIG = WA_TAS5-SIG.
     WA_ALV1-RATE = WA_TAS5-RATE.
     WA_ALV1-CESS = WA_TAS5-CESS.
     WA_ALV1-TDS = WA_TAS5-TDS.
     WA_ALV1-BELNR_CLR = WA_TAS5-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TAS5-AUGDT.
     WA_ALV1-ORT01 = WA_TAS5-ORT01.
     WA_ALV1-VENREG = WA_TAS5-VENREG.
     WA_ALV1-STCD3 = WA_TAS5-STCD3.
     WA_ALV1-SGTXT = WA_TAS5-SGTXT.
     WA_ALV1-SCODE = WA_TAS5-SCODE.
     WA_ALV1-VEN_CL = WA_TAS5-VEN_CL.
     WA_ALV1-PAN = WA_TAS5-PAN.
     WA_ALV1-MBLNR = WA_TAS5-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TAS5-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TAS5-RECP.
     WA_ALV1-RECP_DT = WA_TAS5-RECP_DT.
     WA_ALV1-RSTAT = WA_TAS5-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
*     CLEAR WA_ALV1.

     IF RRP2 EQ 1.
       WA_RRP2-TEXT = WA_ALV1-TEXT.
       WA_RRP2-BUDAT = WA_TAS5-BUDAT.
       WA_RRP2-TCODE = WA_TAS5-TCODE.
       WA_RRP2-USNAM = WA_TAS5-USNAM.
       WA_RRP2-BUPLA = WA_TAS5-BUPLA.
       WA_RRP2-GSBER = WA_TAS5-GSBER.
       WA_RRP2-BELNR = WA_TAS5-BELNR.
       WA_RRP2-BLDAT = WA_TAS5-BLDAT.
       WA_RRP2-XBLNR = WA_TAS5-XBLNR.
       WA_RRP2-VBELN = WA_TAS5-VBELN.
       WA_RRP2-STEUC = WA_TAS5-STEUC.
       WA_RRP2-MENGE = WA_TAS5-MENGE.
       WA_RRP2-MEINS = WA_TAS5-MEINS.
       WA_RRP2-GJAHR = WA_TAS5-GJAHR.
       WA_RRP2-HKONT = WA_TAS5-HKONT.
       WA_RRP2-LIFNR = WA_TAS5-LIFNR.
       WA_RRP2-NAME1 = WA_TAS5-NAME1.
       WA_RRP2-MWSKZ = WA_TAS5-MWSKZ.
       WA_RRP2-DMBTR = WA_TAS5-DMBTR.
       WA_RRP2-HWBAS = WA_TAS5-HWBAS.
       WA_RRP2-HWSTE = WA_TAS5-HWSTE.
       WA_RRP2-IGST = WA_TAS5-IGST.
       WA_RRP2-SGST = WA_TAS5-SGST.
       WA_RRP2-UGST = WA_TAS5-UGST.
       WA_RRP2-CGST = WA_TAS5-CGST.
       WA_RRP2-SIG = WA_TAS5-SIG.
       WA_RRP2-RATE = WA_TAS5-RATE.
       WA_RRP2-CESS = WA_TAS5-CESS.
       WA_RRP2-TDS = WA_TAS5-TDS.
       WA_RRP2-BELNR_CLR = WA_TAS5-BELNR_CLR.
       WA_RRP2-AUGDT = WA_TAS5-AUGDT.
       WA_RRP2-ORT01 = WA_TAS5-ORT01.
       WA_RRP2-VENREG = WA_TAS5-VENREG.
       WA_RRP2-STCD3 = WA_TAS5-STCD3.
       WA_RRP2-SGTXT = WA_TAS5-SGTXT.
       WA_RRP2-SCODE = WA_TAS5-SCODE.
       WA_RRP2-VEN_CL = WA_TAS5-VEN_CL.
       WA_RRP2-PAN = WA_TAS5-PAN.
       WA_RRP2-MBLNR = WA_TAS5-MBLNR.
       WA_RRP2-MKPF_BUDAT = WA_TAS5-MKPF_BUDAT.
       WA_RRP2-RECP = WA_TAS5-RECP.
       WA_RRP2-RECP_DT = WA_TAS5-RECP_DT.
       WA_RRP2-RSTAT = WA_TAS5-RSTAT.
       COLLECT WA_RRP2 INTO IT_RRP2.
       CLEAR WA_RRP2.

     ELSEIF RRP3 EQ 1.
       WA_RRP3-TEXT = WA_ALV1-TEXT.
       WA_RRP3-BUDAT = WA_TAS5-BUDAT.
       WA_RRP3-TCODE = WA_TAS5-TCODE.
       WA_RRP3-USNAM = WA_TAS5-USNAM.
       WA_RRP3-BUPLA = WA_TAS5-BUPLA.
       WA_RRP3-GSBER = WA_TAS5-GSBER.
       WA_RRP3-BELNR = WA_TAS5-BELNR.
       WA_RRP3-BLDAT = WA_TAS5-BLDAT.
       WA_RRP3-XBLNR = WA_TAS5-XBLNR.
       WA_RRP3-VBELN = WA_TAS5-VBELN.
       WA_RRP3-STEUC = WA_TAS5-STEUC.
       WA_RRP3-MENGE = WA_TAS5-MENGE.
       WA_RRP3-MEINS = WA_TAS5-MEINS.
       WA_RRP3-GJAHR = WA_TAS5-GJAHR.
       WA_RRP3-HKONT = WA_TAS5-HKONT.
       WA_RRP3-LIFNR = WA_TAS5-LIFNR.
       WA_RRP3-NAME1 = WA_TAS5-NAME1.
       WA_RRP3-MWSKZ = WA_TAS5-MWSKZ.
       WA_RRP3-DMBTR = WA_TAS5-DMBTR.
       WA_RRP3-HWBAS = WA_TAS5-HWBAS.
       WA_RRP3-HWSTE = WA_TAS5-HWSTE.
       WA_RRP3-IGST = WA_TAS5-IGST.
       WA_RRP3-SGST = WA_TAS5-SGST.
       WA_RRP3-UGST = WA_TAS5-UGST.
       WA_RRP3-CGST = WA_TAS5-CGST.
       WA_RRP3-SIG = WA_TAS5-SIG.
       WA_RRP3-RATE = WA_TAS5-RATE.
       WA_RRP3-CESS = WA_TAS5-CESS.
       WA_RRP3-TDS = WA_TAS5-TDS.
       WA_RRP3-BELNR_CLR = WA_TAS5-BELNR_CLR.
       WA_RRP3-AUGDT = WA_TAS5-AUGDT.
       WA_RRP3-ORT01 = WA_TAS5-ORT01.
       WA_RRP3-VENREG = WA_TAS5-VENREG.
       WA_RRP3-STCD3 = WA_TAS5-STCD3.
       WA_RRP3-SGTXT = WA_TAS5-SGTXT.
       WA_RRP3-SCODE = WA_TAS5-SCODE.
       WA_RRP3-VEN_CL = WA_TAS5-VEN_CL.
       WA_RRP3-PAN = WA_TAS5-PAN.
       WA_RRP3-MBLNR = WA_TAS5-MBLNR.
       WA_RRP3-MKPF_BUDAT = WA_TAS5-MKPF_BUDAT.
       WA_RRP3-RECP = WA_TAS5-RECP.
       WA_RRP3-RECP_DT = WA_TAS5-RECP_DT.
       WA_RRP3-RSTAT = WA_TAS5-RSTAT.
       COLLECT WA_RRP3 INTO IT_RRP3.
       CLEAR WA_RRP3.

     ELSEIF RRP4 EQ 1.
       WA_RRP4-TEXT = WA_ALV1-TEXT.
       WA_RRP4-BUDAT = WA_TAS5-BUDAT.
       WA_RRP4-TCODE = WA_TAS5-TCODE.
       WA_RRP4-USNAM = WA_TAS5-USNAM.
       WA_RRP4-BUPLA = WA_TAS5-BUPLA.
       WA_RRP4-GSBER = WA_TAS5-GSBER.
       WA_RRP4-BELNR = WA_TAS5-BELNR.
       WA_RRP4-BLDAT = WA_TAS5-BLDAT.
       WA_RRP4-XBLNR = WA_TAS5-XBLNR.
       WA_RRP4-VBELN = WA_TAS5-VBELN.
       WA_RRP4-STEUC = WA_TAS5-STEUC.
       WA_RRP4-MENGE = WA_TAS5-MENGE.
       WA_RRP4-MEINS = WA_TAS5-MEINS.
       WA_RRP4-GJAHR = WA_TAS5-GJAHR.
       WA_RRP4-HKONT = WA_TAS5-HKONT.
       WA_RRP4-LIFNR = WA_TAS5-LIFNR.
       WA_RRP4-NAME1 = WA_TAS5-NAME1.
       WA_RRP4-MWSKZ = WA_TAS5-MWSKZ.
       WA_RRP4-DMBTR = WA_TAS5-DMBTR.
       WA_RRP4-HWBAS = WA_TAS5-HWBAS.
       WA_RRP4-HWSTE = WA_TAS5-HWSTE.
       WA_RRP4-IGST = WA_TAS5-IGST.
       WA_RRP4-SGST = WA_TAS5-SGST.
       WA_RRP4-UGST = WA_TAS5-UGST.
       WA_RRP4-CGST = WA_TAS5-CGST.
       WA_RRP4-SIG = WA_TAS5-SIG.
       WA_RRP4-RATE = WA_TAS5-RATE.
       WA_RRP4-CESS = WA_TAS5-CESS.
       WA_RRP4-TDS = WA_TAS5-TDS.
       WA_RRP4-BELNR_CLR = WA_TAS5-BELNR_CLR.
       WA_RRP4-AUGDT = WA_TAS5-AUGDT.
       WA_RRP4-ORT01 = WA_TAS5-ORT01.
       WA_RRP4-VENREG = WA_TAS5-VENREG.
       WA_RRP4-STCD3 = WA_TAS5-STCD3.
       WA_RRP4-SGTXT = WA_TAS5-SGTXT.
       WA_RRP4-SCODE = WA_TAS5-SCODE.
       WA_RRP4-VEN_CL = WA_TAS5-VEN_CL.
       WA_RRP4-PAN = WA_TAS5-PAN.
       WA_RRP4-MBLNR = WA_TAS5-MBLNR.
       WA_RRP4-MKPF_BUDAT = WA_TAS5-MKPF_BUDAT.
       WA_RRP4-RECP = WA_TAS5-RECP.
       WA_RRP4-RECP_DT = WA_TAS5-RECP_DT.
       WA_RRP4-RSTAT = WA_TAS5-RSTAT.
       COLLECT WA_RRP4 INTO IT_RRP4.
       CLEAR WA_RRP4.

     ENDIF.

***************************
     CLEAR WA_ALV1.

   ENDLOOP.
***************** IMPORT GOODS *******************************

   LOOP AT IT_TAI1 INTO WA_TAI1.
     CLEAR : RRP4,RRP2,RRP3.
     IF WA_TAI1-MWSKZ EQ 'V0' OR WA_TAI1-HWSTE EQ 0.
       WA_ALV1-TEXT =  'A. EXPS WITHOUT GST'.
       RRP4 = 1.
       WA_ALV1-BUDAT = WA_TAI1-BUDAT.
       WA_ALV1-TCODE = WA_TAI1-TCODE.
       WA_ALV1-USNAM = WA_TAI1-USNAM.
       WA_ALV1-BUPLA = WA_TAI1-BUPLA.
       WA_ALV1-GSBER = WA_TAI1-GSBER.
       WA_ALV1-BELNR = WA_TAI1-BELNR.
       WA_ALV1-BLDAT = WA_TAI1-BLDAT.
       WA_ALV1-XBLNR = WA_TAI1-XBLNR.
       WA_ALV1-VBELN = WA_TAI1-VBELN.
       WA_ALV1-STEUC = WA_TAI1-STEUC.
       WA_ALV1-MENGE = WA_TAI1-MENGE.
       WA_ALV1-MEINS = WA_TAI1-MEINS.
       WA_ALV1-GJAHR = WA_TAI1-GJAHR.
       WA_ALV1-HKONT = WA_TAI1-HKONT.
       WA_ALV1-LIFNR = WA_TAI1-LIFNR.
       WA_ALV1-NAME1 = WA_TAI1-NAME1.
       WA_ALV1-MWSKZ = WA_TAI1-MWSKZ.
       WA_ALV1-DMBTR = WA_TAI1-DMBTR.
       WA_ALV1-HWBAS = WA_TAI1-HWBAS.
       WA_ALV1-HWSTE = WA_TAI1-HWSTE.
       WA_ALV1-IGST = WA_TAI1-IGST.
       WA_ALV1-SGST = WA_TAI1-SGST.
       WA_ALV1-UGST = WA_TAI1-UGST.
       WA_ALV1-CGST = WA_TAI1-CGST.
       WA_ALV1-SIG = WA_TAI1-SIG.
       WA_ALV1-RATE = WA_TAI1-RATE.
       WA_ALV1-CESS = WA_TAI1-CESS.
       WA_ALV1-TDS = WA_TAI1-TDS.
       WA_ALV1-BELNR_CLR = WA_TAI1-BELNR_CLR.
       WA_ALV1-AUGDT = WA_TAI1-AUGDT.
       WA_ALV1-ORT01 = WA_TAI1-ORT01.
       WA_ALV1-VENREG = WA_TAI1-VENREG.
       WA_ALV1-STCD3 = WA_TAI1-STCD3.
       WA_ALV1-SGTXT = WA_TAI1-SGTXT.
       WA_ALV1-SCODE = WA_TAI1-SCODE.
       WA_ALV1-VEN_CL = WA_TAI1-VEN_CL.
       WA_ALV1-PAN = WA_TAI1-PAN.
       WA_ALV1-MBLNR = WA_TAI1-MBLNR.
       WA_ALV1-MKPF_BUDAT = WA_TAI1-MKPF_BUDAT.
       WA_ALV1-RECP = WA_TAI1-RECP.
       WA_ALV1-RECP_DT = WA_TAI1-RECP_DT.
       WA_ALV1-RSTAT = WA_TAI1-RSTAT.
       COLLECT WA_ALV1 INTO IT_ALV1.
*       CLEAR WA_ALV1.
     ELSE.
       IF WA_TAI1-HWSTE GT 0.
         WA_ALV1-TEXT = 'K. IMPORT OF SERVICES'.
         RRP2 = 1.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAI1-BELNR
           AND GJAHR = WA_TAI1-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'M. RCM LIABILITY ON IMPORT OF SERVICES'.
           RRP2 = 0.
           RRP3 = 1.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAI1-BELNR
           AND GJAHR = WA_TAI1-GJAHR
           AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAI1-BELNR
             AND GJAHR = WA_TAI1-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'M. RCM LIABILITY ON IMPORT OF SERVICES'.
             RRP2 = 0.
             RRP3 = 1.
           ENDIF.
         ENDIF.
       ELSE.
         WA_ALV1-TEXT = 'M. RCM LIABILITY ON IMPORT OF SERVICES'.
         RRP2 = 0.
         RRP3 = 1.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAI1-BELNR
           AND GJAHR = WA_TAI1-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'K. IMPORT OF SERVICES'.
           RRP2 = 1.
           RRP3 = 0.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAI1-BELNR
           AND GJAHR = WA_TAI1-GJAHR
           AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAI1-BELNR
             AND GJAHR = WA_TAI1-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'K. IMPORT OF SERVICES'.
             RRP2 = 1.
             RRP3 = 0.
           ENDIF.
         ENDIF.
       ENDIF.

       WA_ALV1-BUDAT = WA_TAI1-BUDAT.
       WA_ALV1-TCODE = WA_TAI1-TCODE.
       WA_ALV1-USNAM = WA_TAI1-USNAM.
       WA_ALV1-BUPLA = WA_TAI1-BUPLA.
       WA_ALV1-GSBER = WA_TAI1-GSBER.
       WA_ALV1-BELNR = WA_TAI1-BELNR.
       WA_ALV1-BLDAT = WA_TAI1-BLDAT.
       WA_ALV1-XBLNR = WA_TAI1-XBLNR.
       WA_ALV1-VBELN = WA_TAI1-VBELN.
       WA_ALV1-STEUC = WA_TAI1-STEUC.
       WA_ALV1-MENGE = WA_TAI1-MENGE.
       WA_ALV1-MEINS = WA_TAI1-MEINS.
       WA_ALV1-GJAHR = WA_TAI1-GJAHR.
       WA_ALV1-HKONT = WA_TAI1-HKONT.
       WA_ALV1-LIFNR = WA_TAI1-LIFNR.
       WA_ALV1-NAME1 = WA_TAI1-NAME1.
       WA_ALV1-MWSKZ = WA_TAI1-MWSKZ.
       WA_ALV1-DMBTR = WA_TAI1-DMBTR.
       WA_ALV1-HWBAS = WA_TAI1-HWBAS.
       WA_ALV1-HWSTE = WA_TAI1-HWSTE.
       WA_ALV1-IGST = WA_TAI1-IGST.
       WA_ALV1-SGST = WA_TAI1-SGST.
       WA_ALV1-UGST = WA_TAI1-UGST.
       WA_ALV1-CGST = WA_TAI1-CGST.
       WA_ALV1-SIG = WA_TAI1-SIG.
       WA_ALV1-RATE = WA_TAI1-RATE.
       WA_ALV1-CESS = WA_TAI1-CESS.
       WA_ALV1-TDS = WA_TAI1-TDS.
       WA_ALV1-BELNR_CLR = WA_TAI1-BELNR_CLR.
       WA_ALV1-AUGDT = WA_TAI1-AUGDT.
       WA_ALV1-ORT01 = WA_TAI1-ORT01.
       WA_ALV1-VENREG = WA_TAI1-VENREG.
       WA_ALV1-STCD3 = WA_TAI1-STCD3.
       WA_ALV1-SGTXT = WA_TAI1-SGTXT.
       WA_ALV1-SCODE = WA_TAI1-SCODE.
       WA_ALV1-VEN_CL = WA_TAI1-VEN_CL.
       WA_ALV1-PAN = WA_TAI1-PAN.
       WA_ALV1-MBLNR = WA_TAI1-MBLNR.
       WA_ALV1-MKPF_BUDAT = WA_TAI1-MKPF_BUDAT.
       WA_ALV1-RECP = WA_TAI1-RECP.
       WA_ALV1-RECP_DT = WA_TAI1-RECP_DT.
       WA_ALV1-RSTAT = WA_TAI1-RSTAT.
       IF WA_TAI1-HWSTE LT 0.
         WA_ALV1-SIG = 'A'.
       ELSE.
         WA_ALV1-SIG = 'B'.
       ENDIF.
       COLLECT WA_ALV1 INTO IT_ALV1.
*       CLEAR WA_ALV1.
*       endif.
     ENDIF.

****************************************
     IF RRP2 EQ 1.
       WA_RRP2-TEXT = WA_ALV1-TEXT.
       WA_RRP2-BUDAT = WA_TAI1-BUDAT.
       WA_RRP2-TCODE = WA_TAI1-TCODE.
       WA_RRP2-USNAM = WA_TAI1-USNAM.
       WA_RRP2-BUPLA = WA_TAI1-BUPLA.
       WA_RRP2-GSBER = WA_TAI1-GSBER.
       WA_RRP2-BELNR = WA_TAI1-BELNR.
       WA_RRP2-BLDAT = WA_TAI1-BLDAT.
       WA_RRP2-XBLNR = WA_TAI1-XBLNR.
       WA_RRP2-VBELN = WA_TAI1-VBELN.
       WA_RRP2-STEUC = WA_TAI1-STEUC.
       WA_RRP2-MENGE = WA_TAI1-MENGE.
       WA_RRP2-MEINS = WA_TAI1-MEINS.
       WA_RRP2-GJAHR = WA_TAI1-GJAHR.
       WA_RRP2-HKONT = WA_TAI1-HKONT.
       WA_RRP2-LIFNR = WA_TAI1-LIFNR.
       WA_RRP2-NAME1 = WA_TAI1-NAME1.
       WA_RRP2-MWSKZ = WA_TAI1-MWSKZ.
       WA_RRP2-DMBTR = WA_TAI1-DMBTR.
       WA_RRP2-HWBAS = WA_TAI1-HWBAS.
       WA_RRP2-HWSTE = WA_TAI1-HWSTE.
       WA_RRP2-IGST = WA_TAI1-IGST.
       WA_RRP2-SGST = WA_TAI1-SGST.
       WA_RRP2-UGST = WA_TAI1-UGST.
       WA_RRP2-CGST = WA_TAI1-CGST.
       WA_RRP2-SIG = WA_TAI1-SIG.
       WA_RRP2-RATE = WA_TAI1-RATE.
       WA_RRP2-CESS = WA_TAI1-CESS.
       WA_RRP2-TDS = WA_TAI1-TDS.
       WA_RRP2-BELNR_CLR = WA_TAI1-BELNR_CLR.
       WA_RRP2-AUGDT = WA_TAI1-AUGDT.
       WA_RRP2-ORT01 = WA_TAI1-ORT01.
       WA_RRP2-VENREG = WA_TAI1-VENREG.
       WA_RRP2-STCD3 = WA_TAI1-STCD3.
       WA_RRP2-SGTXT = WA_TAI1-SGTXT.
       WA_RRP2-SCODE = WA_TAI1-SCODE.
       WA_RRP2-VEN_CL = WA_TAI1-VEN_CL.
       WA_RRP2-PAN = WA_TAI1-PAN.
       WA_RRP2-MBLNR = WA_TAI1-MBLNR.
       WA_RRP2-MKPF_BUDAT = WA_TAI1-MKPF_BUDAT.
       WA_RRP2-RECP = WA_TAI1-RECP.
       WA_RRP2-RECP_DT = WA_TAI1-RECP_DT.
       WA_RRP2-RSTAT = WA_TAI1-RSTAT.
       IF WA_TAI1-HWSTE LT 0.
         WA_RRP2-SIG = 'A'.
       ELSE.
         WA_RRP2-SIG = 'B'.
       ENDIF.
       COLLECT WA_RRP2 INTO IT_RRP2.
       CLEAR WA_RRP2.

     ELSEIF RRP3 EQ 1.

       WA_RRP3-TEXT = WA_ALV1-TEXT.
       WA_RRP3-BUDAT = WA_TAI1-BUDAT.
       WA_RRP3-TCODE = WA_TAI1-TCODE.
       WA_RRP3-USNAM = WA_TAI1-USNAM.
       WA_RRP3-BUPLA = WA_TAI1-BUPLA.
       WA_RRP3-GSBER = WA_TAI1-GSBER.
       WA_RRP3-BELNR = WA_TAI1-BELNR.
       WA_RRP3-BLDAT = WA_TAI1-BLDAT.
       WA_RRP3-XBLNR = WA_TAI1-XBLNR.
       WA_RRP3-VBELN = WA_TAI1-VBELN.
       WA_RRP3-STEUC = WA_TAI1-STEUC.
       WA_RRP3-MENGE = WA_TAI1-MENGE.
       WA_RRP3-MEINS = WA_TAI1-MEINS.
       WA_RRP3-GJAHR = WA_TAI1-GJAHR.
       WA_RRP3-HKONT = WA_TAI1-HKONT.
       WA_RRP3-LIFNR = WA_TAI1-LIFNR.
       WA_RRP3-NAME1 = WA_TAI1-NAME1.
       WA_RRP3-MWSKZ = WA_TAI1-MWSKZ.
       WA_RRP3-DMBTR = WA_TAI1-DMBTR.
       WA_RRP3-HWBAS = WA_TAI1-HWBAS.
       WA_RRP3-HWSTE = WA_TAI1-HWSTE.
       WA_RRP3-IGST = WA_TAI1-IGST.
       WA_RRP3-SGST = WA_TAI1-SGST.
       WA_RRP3-UGST = WA_TAI1-UGST.
       WA_RRP3-CGST = WA_TAI1-CGST.
       WA_RRP3-SIG = WA_TAI1-SIG.
       WA_RRP3-RATE = WA_TAI1-RATE.
       WA_RRP3-CESS = WA_TAI1-CESS.
       WA_RRP3-TDS = WA_TAI1-TDS.
       WA_RRP3-BELNR_CLR = WA_TAI1-BELNR_CLR.
       WA_RRP3-AUGDT = WA_TAI1-AUGDT.
       WA_RRP3-ORT01 = WA_TAI1-ORT01.
       WA_RRP3-VENREG = WA_TAI1-VENREG.
       WA_RRP3-STCD3 = WA_TAI1-STCD3.
       WA_RRP3-SGTXT = WA_TAI1-SGTXT.
       WA_RRP3-SCODE = WA_TAI1-SCODE.
       WA_RRP3-VEN_CL = WA_TAI1-VEN_CL.
       WA_RRP3-PAN = WA_TAI1-PAN.
       WA_RRP3-MBLNR = WA_TAI1-MBLNR.
       WA_RRP3-MKPF_BUDAT = WA_TAI1-MKPF_BUDAT.
       WA_RRP3-RECP = WA_TAI1-RECP.
       WA_RRP3-RECP_DT = WA_TAI1-RECP_DT.
       WA_RRP3-RSTAT = WA_TAI1-RSTAT.
       IF WA_TAI1-HWSTE LT 0.
         WA_RRP3-SIG = 'A'.
       ELSE.
         WA_RRP3-SIG = 'B'.
       ENDIF.
       COLLECT WA_RRP3 INTO IT_RRP3.
       CLEAR WA_RRP3.
     ELSEIF RRP4 EQ 1.
       WA_RRP4-TEXT = WA_ALV1-TEXT.
       WA_RRP4-BUDAT = WA_TAI1-BUDAT.
       WA_RRP4-TCODE = WA_TAI1-TCODE.
       WA_RRP4-USNAM = WA_TAI1-USNAM.
       WA_RRP4-BUPLA = WA_TAI1-BUPLA.
       WA_RRP4-GSBER = WA_TAI1-GSBER.
       WA_RRP4-BELNR = WA_TAI1-BELNR.
       WA_RRP4-BLDAT = WA_TAI1-BLDAT.
       WA_RRP4-XBLNR = WA_TAI1-XBLNR.
       WA_RRP4-VBELN = WA_TAI1-VBELN.
       WA_RRP4-STEUC = WA_TAI1-STEUC.
       WA_RRP4-MENGE = WA_TAI1-MENGE.
       WA_RRP4-MEINS = WA_TAI1-MEINS.
       WA_RRP4-GJAHR = WA_TAI1-GJAHR.
       WA_RRP4-HKONT = WA_TAI1-HKONT.
       WA_RRP4-LIFNR = WA_TAI1-LIFNR.
       WA_RRP4-NAME1 = WA_TAI1-NAME1.
       WA_RRP4-MWSKZ = WA_TAI1-MWSKZ.
       WA_RRP4-DMBTR = WA_TAI1-DMBTR.
       WA_RRP4-HWBAS = WA_TAI1-HWBAS.
       WA_RRP4-HWSTE = WA_TAI1-HWSTE.
       WA_RRP4-IGST = WA_TAI1-IGST.
       WA_RRP4-SGST = WA_TAI1-SGST.
       WA_RRP4-UGST = WA_TAI1-UGST.
       WA_RRP4-CGST = WA_TAI1-CGST.
       WA_RRP4-SIG = WA_TAI1-SIG.
       WA_RRP4-RATE = WA_TAI1-RATE.
       WA_RRP4-CESS = WA_TAI1-CESS.
       WA_RRP4-TDS = WA_TAI1-TDS.
       WA_RRP4-BELNR_CLR = WA_TAI1-BELNR_CLR.
       WA_RRP4-AUGDT = WA_TAI1-AUGDT.
       WA_RRP4-ORT01 = WA_TAI1-ORT01.
       WA_RRP4-VENREG = WA_TAI1-VENREG.
       WA_RRP4-STCD3 = WA_TAI1-STCD3.
       WA_RRP4-SGTXT = WA_TAI1-SGTXT.
       WA_RRP4-SCODE = WA_TAI1-SCODE.
       WA_RRP4-VEN_CL = WA_TAI1-VEN_CL.
       WA_RRP4-PAN = WA_TAI1-PAN.
       WA_RRP4-MBLNR = WA_TAI1-MBLNR.
       WA_RRP4-MKPF_BUDAT = WA_TAI1-MKPF_BUDAT.
       WA_RRP4-RECP = WA_TAI1-RECP.
       WA_RRP4-RECP_DT = WA_TAI1-RECP_DT.
       WA_RRP4-RSTAT = WA_TAI1-RSTAT.
       IF WA_TAI1-HWSTE LT 0.
         WA_RRP4-SIG = 'A'.
       ELSE.
         WA_RRP4-SIG = 'B'.
       ENDIF.
       COLLECT WA_RRP4 INTO IT_RRP4.
       CLEAR WA_RRP4.

     ENDIF.
     CLEAR WA_ALV1.
*****************************************
   ENDLOOP.



****************** capital goods**************

   LOOP AT IT_TAC1 INTO WA_TAC1.
     CLEAR : A1,GJAHR,RRP2,RRP3,RRP4.
     IF WA_TAC1-MWSKZ EQ 'V0' OR WA_TAC1-HWSTE EQ 0.
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.
       RRP4 = 1.
     ELSEIF WA_TAC1-STATUS EQ 'RCM'.
       RRP3 = 1.
       IF WA_TAC1-HWSTE LT 0.
         WA_ALV1-TEXT = 'B. RCM LIABILITY'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAC1-BELNR
           AND GJAHR = WA_TAC1-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           IF ( WA_TAC1-MWSKZ GE 'O1' AND
                WA_TAC1-MWSKZ LE 'OZ' ) OR
                WA_TAC1-MWSKZ EQ 'IE'.
             WA_ALV1-TEXT = 'R. CAPITAL GOODS ITC NOT AVAILABLE(RCM)'.
           ELSE.
             WA_ALV1-TEXT = 'Q. CAPITAL GOODS ITC AVAILABLE(RCM)'.
           ENDIF.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000' AND
           BELNR EQ WA_TAC1-BELNR AND
           GJAHR = WA_TAC1-GJAHR AND
           XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAC1-BELNR
             AND GJAHR = WA_TAC1-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             IF ( WA_TAC1-MWSKZ GE 'O1' AND
                  WA_TAC1-MWSKZ LE 'OZ' ) OR
                  WA_TAC1-MWSKZ EQ 'IE'.
               WA_ALV1-TEXT = 'R. CAPITAL GOODS ITC NOT AVAILABLE(RCM)'.
             ELSE.
               WA_ALV1-TEXT = 'Q. CAPITAL GOODS ITC AVAILABLE(RCM)'.
             ENDIF.
           ENDIF.
         ENDIF.
       ELSE.
         IF ( WA_TAC1-MWSKZ GE 'O1' AND
              WA_TAC1-MWSKZ LE 'OZ' ) OR
              WA_TAC1-MWSKZ EQ 'IE'.
           WA_ALV1-TEXT = 'R. CAPITAL GOODS ITC NOT AVAILABLE(RCM)'.
         ELSE.
           WA_ALV1-TEXT = 'Q. CAPITAL GOODS ITC AVAILABLE(RCM)'.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
                 AND BELNR EQ WA_TAC1-BELNR
                 AND GJAHR = WA_TAC1-GJAHR
                 AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'B. RCM LIABILITY'.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAC1-BELNR
           AND GJAHR = WA_TAC1-GJAHR
           AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAC1-BELNR
             AND GJAHR = WA_TAC1-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'B. RCM LIABILITY'.
           ENDIF.
         ENDIF.
       ENDIF.
     ELSE.
       RRP4 = 1.
       IF ( WA_TAC1-MWSKZ GE 'O1' AND
            WA_TAC1-MWSKZ LE 'OZ' ) OR
            WA_TAC1-MWSKZ EQ 'IE'.
         WA_ALV1-TEXT = 'I. CAPITAL GOODS ITC NOT AVAILABLE'.
       ELSE.
         WA_ALV1-TEXT = 'J. CAPITAL GOODS ITC AVAILABLE'.
       ENDIF.
     ENDIF.
     WA_ALV1-BUDAT = WA_TAC1-BUDAT.
     WA_ALV1-TCODE = WA_TAC1-TCODE.
     WA_ALV1-USNAM = WA_TAC1-USNAM.
     WA_ALV1-BUPLA = WA_TAC1-BUPLA.
     WA_ALV1-GSBER = WA_TAC1-GSBER.
     WA_ALV1-BELNR = WA_TAC1-BELNR.
     WA_ALV1-BLDAT = WA_TAC1-BLDAT.
*    WA_TAC1-BLART,WA_TAC1-STATUS,WA_TAC1-GSBER,WA_TAC1-BELNR,WA_TAC1-BLDAT,
     WA_ALV1-XBLNR = WA_TAC1-XBLNR.
     WA_ALV1-VBELN = WA_TAC1-VBELN.
     WA_ALV1-STEUC = WA_TAC1-STEUC.
     WA_ALV1-MENGE = WA_TAC1-MENGE.
     WA_ALV1-MEINS = WA_TAC1-MEINS.
     WA_ALV1-GJAHR = WA_TAC1-GJAHR.
     WA_ALV1-HKONT = WA_TAC1-HKONT.
     WA_ALV1-LIFNR = WA_TAC1-LIFNR.
     WA_ALV1-NAME1 = WA_TAC1-NAME1.
     WA_ALV1-MWSKZ = WA_TAC1-MWSKZ.
     WA_ALV1-DMBTR = WA_TAC1-DMBTR.
     WA_ALV1-HWBAS = WA_TAC1-HWBAS.
     WA_ALV1-HWSTE = WA_TAC1-HWSTE.
     WA_ALV1-IGST = WA_TAC1-IGST.
     WA_ALV1-SGST = WA_TAC1-SGST.
     WA_ALV1-UGST = WA_TAC1-UGST.
     WA_ALV1-CGST = WA_TAC1-CGST.
     WA_ALV1-SIG = WA_TAC1-SIG.
     WA_ALV1-RATE = WA_TAC1-RATE.
     WA_ALV1-CESS = WA_TAC1-CESS.
     WA_ALV1-TDS = WA_TAC1-TDS.
     WA_ALV1-BELNR_CLR = WA_TAC1-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TAC1-AUGDT.
     WA_ALV1-ORT01 = WA_TAC1-ORT01.
     WA_ALV1-VENREG = WA_TAC1-VENREG.
     WA_ALV1-STCD3 = WA_TAC1-STCD3.
     WA_ALV1-SGTXT = WA_TAC1-SGTXT.
     WA_ALV1-SCODE = WA_TAC1-SCODE.
     WA_ALV1-VEN_CL = WA_TAC1-VEN_CL.
     WA_ALV1-PAN = WA_TAC1-PAN.
     WA_ALV1-MBLNR = WA_TAC1-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TAC1-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TAC1-RECP.
     WA_ALV1-RECP_DT = WA_TAC1-RECP_DT.
     WA_ALV1-RSTAT = WA_TAC1-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
*     CLEAR WA_ALV1.
*******************************

     IF RRP2 EQ 1.
       WA_RRP2-TEXT = WA_ALV1-TEXT.
       WA_RRP2-BUDAT = WA_TAC1-BUDAT.
       WA_RRP2-TCODE = WA_TAC1-TCODE.
       WA_RRP2-USNAM = WA_TAC1-USNAM.
       WA_RRP2-BUPLA = WA_TAC1-BUPLA.
       WA_RRP2-GSBER = WA_TAC1-GSBER.
       WA_RRP2-BELNR = WA_TAC1-BELNR.
       WA_RRP2-BLDAT = WA_TAC1-BLDAT.
       WA_RRP2-XBLNR = WA_TAC1-XBLNR.
       WA_RRP2-VBELN = WA_TAC1-VBELN.
       WA_RRP2-STEUC = WA_TAC1-STEUC.
       WA_RRP2-MENGE = WA_TAC1-MENGE.
       WA_RRP2-MEINS = WA_TAC1-MEINS.
       WA_RRP2-GJAHR = WA_TAC1-GJAHR.
       WA_RRP2-HKONT = WA_TAC1-HKONT.
       WA_RRP2-LIFNR = WA_TAC1-LIFNR.
       WA_RRP2-NAME1 = WA_TAC1-NAME1.
       WA_RRP2-MWSKZ = WA_TAC1-MWSKZ.
       WA_RRP2-DMBTR = WA_TAC1-DMBTR.
       WA_RRP2-HWBAS = WA_TAC1-HWBAS.
       WA_RRP2-HWSTE = WA_TAC1-HWSTE.
       WA_RRP2-IGST = WA_TAC1-IGST.
       WA_RRP2-SGST = WA_TAC1-SGST.
       WA_RRP2-UGST = WA_TAC1-UGST.
       WA_RRP2-CGST = WA_TAC1-CGST.
       WA_RRP2-SIG = WA_TAC1-SIG.
       WA_RRP2-RATE = WA_TAC1-RATE.
       WA_RRP2-CESS = WA_TAC1-CESS.
       WA_RRP2-TDS = WA_TAC1-TDS.
       WA_RRP2-BELNR_CLR = WA_TAC1-BELNR_CLR.
       WA_RRP2-AUGDT = WA_TAC1-AUGDT.
       WA_RRP2-ORT01 = WA_TAC1-ORT01.
       WA_RRP2-VENREG = WA_TAC1-VENREG.
       WA_RRP2-STCD3 = WA_TAC1-STCD3.
       WA_RRP2-SGTXT = WA_TAC1-SGTXT.
       WA_RRP2-SCODE = WA_TAC1-SCODE.
       WA_RRP2-VEN_CL = WA_TAC1-VEN_CL.
       WA_RRP2-PAN = WA_TAC1-PAN.
       WA_RRP2-MBLNR = WA_TAC1-MBLNR.
       WA_RRP2-MKPF_BUDAT = WA_TAC1-MKPF_BUDAT.
       WA_RRP2-RECP = WA_TAC1-RECP.
       WA_RRP2-RECP_DT = WA_TAC1-RECP_DT.
       WA_RRP2-RSTAT = WA_TAC1-RSTAT.
       COLLECT WA_RRP2 INTO IT_RRP2.
       CLEAR WA_RRP2.
     ELSEIF RRP3 EQ 1.

       WA_RRP3-TEXT = WA_ALV1-TEXT.
       WA_RRP3-BUDAT = WA_TAC1-BUDAT.
       WA_RRP3-TCODE = WA_TAC1-TCODE.
       WA_RRP3-USNAM = WA_TAC1-USNAM.
       WA_RRP3-BUPLA = WA_TAC1-BUPLA.
       WA_RRP3-GSBER = WA_TAC1-GSBER.
       WA_RRP3-BELNR = WA_TAC1-BELNR.
       WA_RRP3-BLDAT = WA_TAC1-BLDAT.
       WA_RRP3-XBLNR = WA_TAC1-XBLNR.
       WA_RRP3-VBELN = WA_TAC1-VBELN.
       WA_RRP3-STEUC = WA_TAC1-STEUC.
       WA_RRP3-MENGE = WA_TAC1-MENGE.
       WA_RRP3-MEINS = WA_TAC1-MEINS.
       WA_RRP3-GJAHR = WA_TAC1-GJAHR.
       WA_RRP3-HKONT = WA_TAC1-HKONT.
       WA_RRP3-LIFNR = WA_TAC1-LIFNR.
       WA_RRP3-NAME1 = WA_TAC1-NAME1.
       WA_RRP3-MWSKZ = WA_TAC1-MWSKZ.
       WA_RRP3-DMBTR = WA_TAC1-DMBTR.
       WA_RRP3-HWBAS = WA_TAC1-HWBAS.
       WA_RRP3-HWSTE = WA_TAC1-HWSTE.
       WA_RRP3-IGST = WA_TAC1-IGST.
       WA_RRP3-SGST = WA_TAC1-SGST.
       WA_RRP3-UGST = WA_TAC1-UGST.
       WA_RRP3-CGST = WA_TAC1-CGST.
       WA_RRP3-SIG = WA_TAC1-SIG.
       WA_RRP3-RATE = WA_TAC1-RATE.
       WA_RRP3-CESS = WA_TAC1-CESS.
       WA_RRP3-TDS = WA_TAC1-TDS.
       WA_RRP3-BELNR_CLR = WA_TAC1-BELNR_CLR.
       WA_RRP3-AUGDT = WA_TAC1-AUGDT.
       WA_RRP3-ORT01 = WA_TAC1-ORT01.
       WA_RRP3-VENREG = WA_TAC1-VENREG.
       WA_RRP3-STCD3 = WA_TAC1-STCD3.
       WA_RRP3-SGTXT = WA_TAC1-SGTXT.
       WA_RRP3-SCODE = WA_TAC1-SCODE.
       WA_RRP3-VEN_CL = WA_TAC1-VEN_CL.
       WA_RRP3-PAN = WA_TAC1-PAN.
       WA_RRP3-MBLNR = WA_TAC1-MBLNR.
       WA_RRP3-MKPF_BUDAT = WA_TAC1-MKPF_BUDAT.
       WA_RRP3-RECP = WA_TAC1-RECP.
       WA_RRP3-RECP_DT = WA_TAC1-RECP_DT.
       WA_RRP3-RSTAT = WA_TAC1-RSTAT.
       COLLECT WA_RRP3 INTO IT_RRP3.
       CLEAR WA_RRP3.

     ELSEIF RRP4 EQ 1.

       WA_RRP4-TEXT = WA_ALV1-TEXT.
       WA_RRP4-BUDAT = WA_TAC1-BUDAT.
       WA_RRP4-TCODE = WA_TAC1-TCODE.
       WA_RRP4-USNAM = WA_TAC1-USNAM.
       WA_RRP4-BUPLA = WA_TAC1-BUPLA.
       WA_RRP4-GSBER = WA_TAC1-GSBER.
       WA_RRP4-BELNR = WA_TAC1-BELNR.
       WA_RRP4-BLDAT = WA_TAC1-BLDAT.
       WA_RRP4-XBLNR = WA_TAC1-XBLNR.
       WA_RRP4-VBELN = WA_TAC1-VBELN.
       WA_RRP4-STEUC = WA_TAC1-STEUC.
       WA_RRP4-MENGE = WA_TAC1-MENGE.
       WA_RRP4-MEINS = WA_TAC1-MEINS.
       WA_RRP4-GJAHR = WA_TAC1-GJAHR.
       WA_RRP4-HKONT = WA_TAC1-HKONT.
       WA_RRP4-LIFNR = WA_TAC1-LIFNR.
       WA_RRP4-NAME1 = WA_TAC1-NAME1.
       WA_RRP4-MWSKZ = WA_TAC1-MWSKZ.
       WA_RRP4-DMBTR = WA_TAC1-DMBTR.
       WA_RRP4-HWBAS = WA_TAC1-HWBAS.
       WA_RRP4-HWSTE = WA_TAC1-HWSTE.
       WA_RRP4-IGST = WA_TAC1-IGST.
       WA_RRP4-SGST = WA_TAC1-SGST.
       WA_RRP4-UGST = WA_TAC1-UGST.
       WA_RRP4-CGST = WA_TAC1-CGST.
       WA_RRP4-SIG = WA_TAC1-SIG.
       WA_RRP4-RATE = WA_TAC1-RATE.
       WA_RRP4-CESS = WA_TAC1-CESS.
       WA_RRP4-TDS = WA_TAC1-TDS.
       WA_RRP4-BELNR_CLR = WA_TAC1-BELNR_CLR.
       WA_RRP4-AUGDT = WA_TAC1-AUGDT.
       WA_RRP4-ORT01 = WA_TAC1-ORT01.
       WA_RRP4-VENREG = WA_TAC1-VENREG.
       WA_RRP4-STCD3 = WA_TAC1-STCD3.
       WA_RRP4-SGTXT = WA_TAC1-SGTXT.
       WA_RRP4-SCODE = WA_TAC1-SCODE.
       WA_RRP4-VEN_CL = WA_TAC1-VEN_CL.
       WA_RRP4-PAN = WA_TAC1-PAN.
       WA_RRP4-MBLNR = WA_TAC1-MBLNR.
       WA_RRP4-MKPF_BUDAT = WA_TAC1-MKPF_BUDAT.
       WA_RRP4-RECP = WA_TAC1-RECP.
       WA_RRP4-RECP_DT = WA_TAC1-RECP_DT.
       WA_RRP4-RSTAT = WA_TAC1-RSTAT.
       COLLECT WA_RRP4 INTO IT_RRP4.
       CLEAR WA_RRP4.
     ENDIF.

**********************************
     CLEAR WA_ALV1.
   ENDLOOP.
*************** ISD ENTRIES *****************************

   LOOP AT IT_ISD1 INTO WA_ISD1.
     CLEAR : A1,GJAHR.
     WA_ALV1-TEXT = 'O. ISD ENTRIES'.
     WA_ALV1-BUDAT = WA_ISD1-BUDAT.
     WA_ALV1-TCODE = WA_ISD1-TCODE.
     WA_ALV1-USNAM = WA_ISD1-USNAM.
     WA_ALV1-BUPLA = WA_ISD1-BUPLA.
     WA_ALV1-GSBER = WA_ISD1-GSBER.
     WA_ALV1-BELNR = WA_ISD1-BELNR.
     WA_ALV1-BLDAT = WA_ISD1-BLDAT.
     WA_ALV1-XBLNR = WA_ISD1-XBLNR.
     WA_ALV1-VBELN = WA_ISD1-VBELN.
     WA_ALV1-STEUC = WA_ISD1-STEUC.
     WA_ALV1-MENGE = WA_ISD1-MENGE.
     WA_ALV1-MEINS = WA_ISD1-MEINS.
     WA_ALV1-GJAHR = WA_ISD1-GJAHR.
     WA_ALV1-HKONT = WA_ISD1-HKONT.
     WA_ALV1-LIFNR = WA_ISD1-LIFNR.
     WA_ALV1-NAME1 = WA_ISD1-NAME1.
     WA_ALV1-MWSKZ = WA_ISD1-MWSKZ.
     WA_ALV1-DMBTR = WA_ISD1-DMBTR.
     WA_ALV1-HWBAS = WA_ISD1-HWBAS.
     WA_ALV1-HWSTE = WA_ISD1-HWSTE.
     WA_ALV1-IGST = WA_ISD1-IGST.
     WA_ALV1-SGST = WA_ISD1-SGST.
     WA_ALV1-UGST = WA_ISD1-UGST.
     WA_ALV1-CGST = WA_ISD1-CGST.
     WA_ALV1-SIG = WA_ISD1-SIG.
     WA_ALV1-RATE = WA_ISD1-RATE.
     WA_ALV1-CESS = WA_ISD1-CESS.
     WA_ALV1-TDS = WA_ISD1-TDS.
     WA_ALV1-BELNR_CLR = WA_ISD1-BELNR_CLR.
     WA_ALV1-AUGDT = WA_ISD1-AUGDT.
     WA_ALV1-ORT01 = WA_ISD1-ORT01.
     WA_ALV1-VENREG = WA_ISD1-VENREG.
     WA_ALV1-STCD3 = WA_ISD1-STCD3.
     WA_ALV1-SGTXT = WA_ISD1-SGTXT.
     WA_ALV1-SCODE = WA_ISD1-SCODE.
     WA_ALV1-VEN_CL = WA_ISD1-VEN_CL.
     WA_ALV1-PAN = WA_ISD1-PAN.
     WA_ALV1-MBLNR = WA_ISD1-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_ISD1-MKPF_BUDAT.
     WA_ALV1-RECP = WA_ISD1-RECP.
     WA_ALV1-RECP_DT = WA_ISD1-RECP_DT.
     WA_ALV1-RSTAT = WA_ISD1-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
     CLEAR WA_ALV1.
*******************************
     WA_RRP4-TEXT = 'O. ISD ENTRIES'.
     WA_RRP4-BUDAT = WA_ISD1-BUDAT.
     WA_RRP4-TCODE = WA_ISD1-TCODE.
     WA_RRP4-USNAM = WA_ISD1-USNAM.
     WA_RRP4-BUPLA = WA_ISD1-BUPLA.
     WA_RRP4-GSBER = WA_ISD1-GSBER.
     WA_RRP4-BELNR = WA_ISD1-BELNR.
     WA_RRP4-BLDAT = WA_ISD1-BLDAT.
     WA_RRP4-XBLNR = WA_ISD1-XBLNR.
     WA_RRP4-VBELN = WA_ISD1-VBELN.
     WA_RRP4-STEUC = WA_ISD1-STEUC.
     WA_RRP4-MENGE = WA_ISD1-MENGE.
     WA_RRP4-MEINS = WA_ISD1-MEINS.
     WA_RRP4-GJAHR = WA_ISD1-GJAHR.
     WA_RRP4-HKONT = WA_ISD1-HKONT.
     WA_RRP4-LIFNR = WA_ISD1-LIFNR.
     WA_RRP4-NAME1 = WA_ISD1-NAME1.
     WA_RRP4-MWSKZ = WA_ISD1-MWSKZ.
     WA_RRP4-DMBTR = WA_ISD1-DMBTR.
     WA_RRP4-HWBAS = WA_ISD1-HWBAS.
     WA_RRP4-HWSTE = WA_ISD1-HWSTE.
     WA_RRP4-IGST = WA_ISD1-IGST.
     WA_RRP4-SGST = WA_ISD1-SGST.
     WA_RRP4-UGST = WA_ISD1-UGST.
     WA_RRP4-CGST = WA_ISD1-CGST.
     WA_RRP4-SIG = WA_ISD1-SIG.
     WA_RRP4-RATE = WA_ISD1-RATE.
     WA_RRP4-CESS = WA_ISD1-CESS.
     WA_RRP4-TDS = WA_ISD1-TDS.
     WA_RRP4-BELNR_CLR = WA_ISD1-BELNR_CLR.
     WA_RRP4-AUGDT = WA_ISD1-AUGDT.
     WA_RRP4-ORT01 = WA_ISD1-ORT01.
     WA_RRP4-VENREG = WA_ISD1-VENREG.
     WA_RRP4-STCD3 = WA_ISD1-STCD3.
     WA_RRP4-SGTXT = WA_ISD1-SGTXT.
     WA_RRP4-SCODE = WA_ISD1-SCODE.
     WA_RRP4-VEN_CL = WA_ISD1-VEN_CL.
     WA_RRP4-PAN = WA_ISD1-PAN.
     WA_RRP4-MBLNR = WA_ISD1-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_ISD1-MKPF_BUDAT.
     WA_RRP4-RECP = WA_ISD1-RECP.
     WA_RRP4-RECP_DT = WA_ISD1-RECP_DT.
     WA_RRP4-RSTAT = WA_ISD1-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.

   ENDLOOP.

************ISD IELIGIBLE ENTRIES********************



   LOOP AT IT_INGISD1 INTO WA_INGISD1.
     CLEAR : A1,GJAHR.

     IF WA_INGISD1-MWSKZ EQ 'V0' OR WA_INGISD1-HWSTE EQ 0.
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.

     ELSEIF WA_INGISD1-HWSTE LT 0.
       WA_ALV1-TEXT = 'O. ISD INELIGIBLE ENTRIES - '.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_INGISD1-BELNR
         AND GJAHR EQ WA_INGISD1-GJAHR
         AND XREVERSAL EQ '2'.
       IF SY-SUBRC EQ 0.
         WA_ALV1-TEXT = 'O. ISD INELIGIBLE ENTRIES + '.
       ENDIF.
       IF WA_INGISD1-TCODE EQ 'MR8M'.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_INGISD1-BELNR
           AND GJAHR EQ WA_INGISD1-GJAHR
           AND KOART EQ 'K'
           AND SHKZG EQ 'S'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'O. ISD INELIGIBLE ENTRIES + '.
         ENDIF.
       ENDIF.
     ELSE.
       WA_ALV1-TEXT = 'O. ISD INELIGIBLE ENTRIES + '.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_INGISD1-BELNR
         AND GJAHR EQ WA_INGISD1-GJAHR
         AND XREVERSAL EQ '2'.
       IF SY-SUBRC EQ 0.
         WA_ALV1-TEXT = 'O. ISD INELIGIBLE ENTRIES - '.
       ENDIF.
       IF WA_INGISD1-TCODE EQ 'MR8M'.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_INGISD1-BELNR
           AND GJAHR EQ WA_INGISD1-GJAHR
           AND KOART EQ 'K'
           AND SHKZG EQ 'S'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'O. ISD INELIGIBLE ENTRIES - '.
         ENDIF.
       ENDIF.
     ENDIF.

     WA_ALV1-BUDAT = WA_INGISD1-BUDAT.
     WA_ALV1-TCODE = WA_INGISD1-TCODE.
     WA_ALV1-USNAM = WA_INGISD1-USNAM.
     WA_ALV1-BUPLA = WA_INGISD1-BUPLA.
     WA_ALV1-GSBER = WA_INGISD1-GSBER.
     WA_ALV1-BELNR = WA_INGISD1-BELNR.
     WA_ALV1-BLDAT = WA_INGISD1-BLDAT.
     WA_ALV1-XBLNR = WA_INGISD1-XBLNR.
     WA_ALV1-VBELN = WA_INGISD1-VBELN.
     WA_ALV1-STEUC = WA_INGISD1-STEUC.
     WA_ALV1-MENGE = WA_INGISD1-MENGE.
     WA_ALV1-MEINS = WA_INGISD1-MEINS.
     WA_ALV1-GJAHR = WA_INGISD1-GJAHR.
     WA_ALV1-HKONT = WA_INGISD1-HKONT.
     WA_ALV1-LIFNR = WA_INGISD1-LIFNR.
     WA_ALV1-NAME1 = WA_INGISD1-NAME1.
     WA_ALV1-MWSKZ = WA_INGISD1-MWSKZ.
     WA_ALV1-DMBTR = WA_INGISD1-DMBTR.
     WA_ALV1-HWBAS = WA_INGISD1-HWBAS.
     WA_ALV1-HWSTE = WA_INGISD1-HWSTE.
     WA_ALV1-IGST = WA_INGISD1-IGST.
     WA_ALV1-SGST = WA_INGISD1-SGST.
     WA_ALV1-UGST = WA_INGISD1-UGST.
     WA_ALV1-CGST = WA_INGISD1-CGST.
     WA_ALV1-SIG = WA_INGISD1-SIG.
     WA_ALV1-RATE = WA_INGISD1-RATE.
     WA_ALV1-CESS = WA_INGISD1-CESS.
     WA_ALV1-TDS = WA_INGISD1-TDS.
     WA_ALV1-BELNR_CLR = WA_INGISD1-BELNR_CLR.
     WA_ALV1-AUGDT = WA_INGISD1-AUGDT.
     WA_ALV1-ORT01 = WA_INGISD1-ORT01.
     WA_ALV1-VENREG = WA_INGISD1-VENREG.
     WA_ALV1-STCD3 = WA_INGISD1-STCD3.
     WA_ALV1-SGTXT = WA_INGISD1-SGTXT.
     WA_ALV1-SCODE = WA_INGISD1-SCODE.
     WA_ALV1-VEN_CL = WA_INGISD1-VEN_CL.
     WA_ALV1-PAN = WA_INGISD1-PAN.
     WA_ALV1-MBLNR = WA_INGISD1-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_INGISD1-MKPF_BUDAT.
     WA_ALV1-RECP = WA_INGISD1-RECP.
     WA_ALV1-RECP_DT = WA_INGISD1-RECP_DT.
     WA_ALV1-RSTAT = WA_INGISD1-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
     CLEAR WA_ALV1.
*******************************
     WA_RRP4-TEXT = WA_ALV1-TEXT.
     WA_RRP4-BUDAT = WA_INGISD1-BUDAT.
     WA_RRP4-TCODE = WA_INGISD1-TCODE.
     WA_RRP4-USNAM = WA_INGISD1-USNAM.
     WA_RRP4-BUPLA = WA_INGISD1-BUPLA.
     WA_RRP4-GSBER = WA_INGISD1-GSBER.
     WA_RRP4-BELNR = WA_INGISD1-BELNR.
     WA_RRP4-BLDAT = WA_INGISD1-BLDAT.
     WA_RRP4-XBLNR = WA_INGISD1-XBLNR.
     WA_RRP4-VBELN = WA_INGISD1-VBELN.
     WA_RRP4-STEUC = WA_INGISD1-STEUC.
     WA_RRP4-MENGE = WA_INGISD1-MENGE.
     WA_RRP4-MEINS = WA_INGISD1-MEINS.
     WA_RRP4-GJAHR = WA_INGISD1-GJAHR.
     WA_RRP4-HKONT = WA_INGISD1-HKONT.
     WA_RRP4-LIFNR = WA_INGISD1-LIFNR.
     WA_RRP4-NAME1 = WA_INGISD1-NAME1.
     WA_RRP4-MWSKZ = WA_INGISD1-MWSKZ.
     WA_RRP4-DMBTR = WA_INGISD1-DMBTR.
     WA_RRP4-HWBAS = WA_INGISD1-HWBAS.
     WA_RRP4-HWSTE = WA_INGISD1-HWSTE.
     WA_RRP4-IGST = WA_INGISD1-IGST.
     WA_RRP4-SGST = WA_INGISD1-SGST.
     WA_RRP4-UGST = WA_INGISD1-UGST.
     WA_RRP4-CGST = WA_INGISD1-CGST.
     WA_RRP4-SIG = WA_INGISD1-SIG.
     WA_RRP4-RATE = WA_INGISD1-RATE.
     WA_RRP4-CESS = WA_INGISD1-CESS.
     WA_RRP4-TDS = WA_INGISD1-TDS.
     WA_RRP4-BELNR_CLR = WA_INGISD1-BELNR_CLR.
     WA_RRP4-AUGDT = WA_INGISD1-AUGDT.
     WA_RRP4-ORT01 = WA_INGISD1-ORT01.
     WA_RRP4-VENREG = WA_INGISD1-VENREG.
     WA_RRP4-STCD3 = WA_INGISD1-STCD3.
     WA_RRP4-SGTXT = WA_INGISD1-SGTXT.
     WA_RRP4-SCODE = WA_INGISD1-SCODE.
     WA_RRP4-VEN_CL = WA_INGISD1-VEN_CL.
     WA_RRP4-PAN = WA_INGISD1-PAN.
     WA_RRP4-MBLNR = WA_INGISD1-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_INGISD1-MKPF_BUDAT.
     WA_RRP4-RECP = WA_INGISD1-RECP.
     WA_RRP4-RECP_DT = WA_INGISD1-RECP_DT.
     WA_RRP4-RSTAT = WA_INGISD1-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.

   ENDLOOP.

****************** JV PASSED.***********************
   LOOP AT IT_JRC1 INTO WA_JRC1.
     CLEAR : A1,GJAHR,RRP2,RRP3,RRP4.
     IF WA_JRC1-HWSTE LT 0.
       WA_ALV1-TEXT = 'T. JV PASSED (RCM LIABILITY)'.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_JRC1-BELNR
         AND GJAHR EQ WA_JRC1-GJAHR
         AND XREVERSAL EQ '2'.
       IF SY-SUBRC EQ 0.
         IF ( WA_JRC1-HKONT GE '0000028150' AND
              WA_JRC1-HKONT LE '0000028170' ) OR
            ( WA_JRC1-HKONT GE '00000400000' AND
              WA_JRC1-HKONT LE '0000049990' ).
           WA_ALV1-TEXT = 'T. JV PASSED (RCM INELIGIBLE)'.
         ELSE.
           WA_ALV1-TEXT = 'T. JV PASSED (RCM ELIGIBLE)'.
         ENDIF.
       ENDIF.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_JRC1-BELNR
         AND GJAHR EQ WA_JRC1-GJAHR
         AND XREVERSAL EQ ' '.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_JRC1-BELNR
           AND GJAHR = WA_JRC1-GJAHR
           AND BUZEI EQ '001'
           AND KOART EQ 'K'
           AND SHKZG EQ 'S' .
         IF SY-SUBRC EQ 0.
           IF ( WA_JRC1-HKONT GE '0000028150' AND
                WA_JRC1-HKONT LE '0000028170' ) OR
              ( WA_JRC1-HKONT GE '00000400000' AND
                WA_JRC1-HKONT LE '0000049990' ).
             WA_ALV1-TEXT = 'T. JV PASSED (RCM INELIGIBLE)'.
           ELSE.
             WA_ALV1-TEXT = 'T. JV PASSED (RCM ELIGIBLE)'.
           ENDIF.
         ENDIF.
       ENDIF.
     ELSE.
       IF ( WA_JRC1-HKONT GE '0000028150' AND
            WA_JRC1-HKONT LE '0000028170' ) OR
          ( WA_JRC1-HKONT GE '00000400000' AND
            WA_JRC1-HKONT LE '0000049990' ).
         WA_ALV1-TEXT = 'T. JV PASSED (RCM INELIGIBLE)'.
       ELSE.
         WA_ALV1-TEXT = 'T. JV PASSED (RCM ELIGIBLE)'.
       ENDIF.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_JRC1-BELNR
         AND GJAHR EQ WA_JRC1-GJAHR
         AND XREVERSAL EQ '2'.
       IF SY-SUBRC EQ 0.
         WA_ALV1-TEXT = 'T. JV PASSED (RCM LIABILITY)'.
       ENDIF.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_JRC1-BELNR
         AND GJAHR EQ WA_JRC1-GJAHR
         AND XREVERSAL EQ ' '.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_JRC1-BELNR
           AND GJAHR = WA_JRC1-GJAHR
           AND BUZEI EQ '001'
           AND KOART EQ 'K'
           AND SHKZG EQ 'S' .
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'T. JV PASSED (RCM LIABILITY)'.
         ENDIF.
       ENDIF.
     ENDIF.
     WA_ALV1-BUDAT = WA_JRC1-BUDAT.
     WA_ALV1-TCODE = WA_JRC1-TCODE.
     WA_ALV1-USNAM = WA_JRC1-USNAM.
     WA_ALV1-BUPLA = WA_JRC1-BUPLA.
     WA_ALV1-GSBER = WA_JRC1-GSBER.
     WA_ALV1-BELNR = WA_JRC1-BELNR.
     WA_ALV1-BLDAT = WA_JRC1-BLDAT.
     WA_ALV1-XBLNR = WA_JRC1-XBLNR.
     WA_ALV1-VBELN = WA_JRC1-VBELN.
     WA_ALV1-STEUC = WA_JRC1-STEUC.
     WA_ALV1-MENGE = WA_JRC1-MENGE.
     WA_ALV1-MEINS = WA_JRC1-MEINS.
     WA_ALV1-GJAHR = WA_JRC1-GJAHR.
     WA_ALV1-HKONT = WA_JRC1-HKONT.
     WA_ALV1-LIFNR = WA_JRC1-LIFNR.
     WA_ALV1-NAME1 = WA_JRC1-NAME1.
     WA_ALV1-MWSKZ = WA_JRC1-MWSKZ.
     WA_ALV1-DMBTR = WA_JRC1-DMBTR.
     WA_ALV1-HWBAS = WA_JRC1-HWBAS.
     WA_ALV1-HWSTE = WA_JRC1-HWSTE.
     WA_ALV1-IGST = WA_JRC1-IGST.
     WA_ALV1-SGST = WA_JRC1-SGST.
     WA_ALV1-UGST = WA_JRC1-UGST.
     WA_ALV1-CGST = WA_JRC1-CGST.
     WA_ALV1-SIG = WA_JRC1-SIG.
     WA_ALV1-RATE = WA_JRC1-RATE.
     WA_ALV1-CESS = WA_JRC1-CESS.
     WA_ALV1-TDS = WA_JRC1-TDS.
     WA_ALV1-BELNR_CLR = WA_JRC1-BELNR_CLR.
     WA_ALV1-AUGDT = WA_JRC1-AUGDT.
     WA_ALV1-ORT01 = WA_JRC1-ORT01.
     WA_ALV1-VENREG = WA_JRC1-VENREG.
     WA_ALV1-STCD3 = WA_JRC1-STCD3.
     WA_ALV1-SGTXT = WA_JRC1-SGTXT.
     WA_ALV1-SCODE = WA_JRC1-SCODE.
     WA_ALV1-VEN_CL = WA_JRC1-VEN_CL.
     WA_ALV1-PAN = WA_JRC1-PAN.
     WA_ALV1-MBLNR = WA_JRC1-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_JRC1-MKPF_BUDAT.
     WA_ALV1-RECP = WA_JRC1-RECP.
     WA_ALV1-RECP_DT = WA_JRC1-RECP_DT.
     WA_ALV1-RSTAT = WA_JRC1-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
*     CLEAR WA_ALV1.
**************************
     WA_RRP3-TEXT = WA_ALV1-TEXT.
     WA_RRP3-BUDAT = WA_JRC1-BUDAT.
     WA_RRP3-TCODE = WA_JRC1-TCODE.
     WA_RRP3-USNAM = WA_JRC1-USNAM.
     WA_RRP3-BUPLA = WA_JRC1-BUPLA.
     WA_RRP3-GSBER = WA_JRC1-GSBER.
     WA_RRP3-BELNR = WA_JRC1-BELNR.
     WA_RRP3-BLDAT = WA_JRC1-BLDAT.
     WA_RRP3-XBLNR = WA_JRC1-XBLNR.
     WA_RRP3-VBELN = WA_JRC1-VBELN.
     WA_RRP3-STEUC = WA_JRC1-STEUC.
     WA_RRP3-MENGE = WA_JRC1-MENGE.
     WA_RRP3-MEINS = WA_JRC1-MEINS.
     WA_RRP3-GJAHR = WA_JRC1-GJAHR.
     WA_RRP3-HKONT = WA_JRC1-HKONT.
     WA_RRP3-LIFNR = WA_JRC1-LIFNR.
     WA_RRP3-NAME1 = WA_JRC1-NAME1.
     WA_RRP3-MWSKZ = WA_JRC1-MWSKZ.
     WA_RRP3-DMBTR = WA_JRC1-DMBTR.
     WA_RRP3-HWBAS = WA_JRC1-HWBAS.
     WA_RRP3-HWSTE = WA_JRC1-HWSTE.
     WA_RRP3-IGST = WA_JRC1-IGST.
     WA_RRP3-SGST = WA_JRC1-SGST.
     WA_RRP3-UGST = WA_JRC1-UGST.
     WA_RRP3-CGST = WA_JRC1-CGST.
     WA_RRP3-SIG = WA_JRC1-SIG.
     WA_RRP3-RATE = WA_JRC1-RATE.
     WA_RRP3-CESS = WA_JRC1-CESS.
     WA_RRP3-TDS = WA_JRC1-TDS.
     WA_RRP3-BELNR_CLR = WA_JRC1-BELNR_CLR.
     WA_RRP3-AUGDT = WA_JRC1-AUGDT.
     WA_RRP3-ORT01 = WA_JRC1-ORT01.
     WA_RRP3-VENREG = WA_JRC1-VENREG.
     WA_RRP3-STCD3 = WA_JRC1-STCD3.
     WA_RRP3-SGTXT = WA_JRC1-SGTXT.
     WA_RRP3-SCODE = WA_JRC1-SCODE.
     WA_RRP3-VEN_CL = WA_JRC1-VEN_CL.
     WA_RRP3-PAN = WA_JRC1-PAN.
     WA_RRP3-MBLNR = WA_JRC1-MBLNR.
     WA_RRP3-MKPF_BUDAT = WA_JRC1-MKPF_BUDAT.
     WA_RRP3-RECP = WA_JRC1-RECP.
     WA_RRP3-RECP_DT = WA_JRC1-RECP_DT.
     WA_RRP3-RSTAT = WA_JRC1-RSTAT.
     COLLECT WA_RRP3 INTO IT_RRP3.
     CLEAR WA_RRP3.

***********************
     CLEAR WA_ALV1.
   ENDLOOP.

**********************
   LOOP AT IT_TAJI1 INTO WA_TAJI1.
     CLEAR : A1,GJAHR.
     WA_ALV1-TEXT = 'S. JV PASSED (INELIGIBLE)'.
     WA_ALV1-BUDAT = WA_TAJI1-BUDAT.
     WA_ALV1-TCODE = WA_TAJI1-TCODE.
     WA_ALV1-USNAM = WA_TAJI1-USNAM.
     WA_ALV1-BUPLA = WA_TAJI1-BUPLA.
     WA_ALV1-GSBER = WA_TAJI1-GSBER.
     WA_ALV1-BELNR = WA_TAJI1-BELNR.
     WA_ALV1-BLDAT = WA_TAJI1-BLDAT.
     WA_ALV1-XBLNR = WA_TAJI1-XBLNR.
     WA_ALV1-VBELN = WA_TAJI1-VBELN.
     WA_ALV1-STEUC = WA_TAJI1-STEUC.
     WA_ALV1-MENGE = WA_TAJI1-MENGE.
     WA_ALV1-MEINS = WA_TAJI1-MEINS.
     WA_ALV1-GJAHR = WA_TAJI1-GJAHR.
     WA_ALV1-HKONT = WA_TAJI1-HKONT.
     WA_ALV1-LIFNR = WA_TAJI1-LIFNR.
     WA_ALV1-NAME1 = WA_TAJI1-NAME1.
     WA_ALV1-MWSKZ = WA_TAJI1-MWSKZ.
     WA_ALV1-DMBTR = WA_TAJI1-DMBTR.
     WA_ALV1-HWBAS = WA_TAJI1-HWBAS.
     WA_ALV1-HWSTE = WA_TAJI1-HWSTE.
     WA_ALV1-IGST = WA_TAJI1-IGST.
     WA_ALV1-SGST = WA_TAJI1-SGST.
     WA_ALV1-UGST = WA_TAJI1-UGST.
     WA_ALV1-CGST = WA_TAJI1-CGST.
     WA_ALV1-SIG = WA_TAJI1-SIG.
     WA_ALV1-RATE = WA_TAJI1-RATE.
     WA_ALV1-CESS = WA_TAJI1-CESS.
     WA_ALV1-TDS = WA_TAJI1-TDS.
     WA_ALV1-BELNR_CLR = WA_TAJI1-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TAJI1-AUGDT.
     WA_ALV1-ORT01 = WA_TAJI1-ORT01.
     WA_ALV1-VENREG = WA_TAJI1-VENREG.
     WA_ALV1-STCD3 = WA_TAJI1-STCD3.
     WA_ALV1-SGTXT = WA_TAJI1-SGTXT.
     WA_ALV1-SCODE = WA_TAJI1-SCODE.
     WA_ALV1-VEN_CL = WA_TAJI1-VEN_CL.
     WA_ALV1-PAN = WA_TAJI1-PAN.
     WA_ALV1-MBLNR = WA_TAJI1-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TAJI1-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TAJI1-RECP.
     WA_ALV1-RECP_DT = WA_TAJI1-RECP_DT.
     WA_ALV1-RSTAT = WA_TAJI1-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
     CLEAR WA_ALV1.
***************

     WA_RRP4-TEXT = 'S. JV PASSED (INELIGIBLE)'.
     WA_RRP4-BUDAT = WA_TAJI1-BUDAT.
     WA_RRP4-TCODE = WA_TAJI1-TCODE.
     WA_RRP4-USNAM = WA_TAJI1-USNAM.
     WA_RRP4-BUPLA = WA_TAJI1-BUPLA.
     WA_RRP4-GSBER = WA_TAJI1-GSBER.
     WA_RRP4-BELNR = WA_TAJI1-BELNR.
     WA_RRP4-BLDAT = WA_TAJI1-BLDAT.
     WA_RRP4-XBLNR = WA_TAJI1-XBLNR.
     WA_RRP4-VBELN = WA_TAJI1-VBELN.
     WA_RRP4-STEUC = WA_TAJI1-STEUC.
     WA_RRP4-MENGE = WA_TAJI1-MENGE.
     WA_RRP4-MEINS = WA_TAJI1-MEINS.
     WA_RRP4-GJAHR = WA_TAJI1-GJAHR.
     WA_RRP4-HKONT = WA_TAJI1-HKONT.
     WA_RRP4-LIFNR = WA_TAJI1-LIFNR.
     WA_RRP4-NAME1 = WA_TAJI1-NAME1.
     WA_RRP4-MWSKZ = WA_TAJI1-MWSKZ.
     WA_RRP4-DMBTR = WA_TAJI1-DMBTR.
     WA_RRP4-HWBAS = WA_TAJI1-HWBAS.
     WA_RRP4-HWSTE = WA_TAJI1-HWSTE.
     WA_RRP4-IGST = WA_TAJI1-IGST.
     WA_RRP4-SGST = WA_TAJI1-SGST.
     WA_RRP4-UGST = WA_TAJI1-UGST.
     WA_RRP4-CGST = WA_TAJI1-CGST.
     WA_RRP4-SIG = WA_TAJI1-SIG.
     WA_RRP4-RATE = WA_TAJI1-RATE.
     WA_RRP4-CESS = WA_TAJI1-CESS.
     WA_RRP4-TDS = WA_TAJI1-TDS.
     WA_RRP4-BELNR_CLR = WA_TAJI1-BELNR_CLR.
     WA_RRP4-AUGDT = WA_TAJI1-AUGDT.
     WA_RRP4-ORT01 = WA_TAJI1-ORT01.
     WA_RRP4-VENREG = WA_TAJI1-VENREG.
     WA_RRP4-STCD3 = WA_TAJI1-STCD3.
     WA_RRP4-SGTXT = WA_TAJI1-SGTXT.
     WA_RRP4-SCODE = WA_TAJI1-SCODE.
     WA_RRP4-VEN_CL = WA_TAJI1-VEN_CL.
     WA_RRP4-PAN = WA_TAJI1-PAN.
     WA_RRP4-MBLNR = WA_TAJI1-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_TAJI1-MKPF_BUDAT.
     WA_RRP4-RECP = WA_TAJI1-RECP.
     WA_RRP4-RECP_DT = WA_TAJI1-RECP_DT.
     WA_RRP4-RSTAT = WA_TAJI1-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.
**************
   ENDLOOP.
**********************************************
   IF IT_TAJ1 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEGI1
       FOR ALL ENTRIES IN IT_TAJ1 WHERE
       BUKRS EQ '1000'
       AND BELNR EQ IT_TAJ1-BELNR
       AND GJAHR EQ IT_TAJ1-GJAHR
       AND HKONT GE '0000002801'
       AND HKONT LE '0000002810'.
   ENDIF.
   LOOP AT IT_TAJ1 INTO WA_TAJ1.
     CLEAR : A1,GJAHR,RRP2,RRP3,RRP4.
     IF WA_TAJ1-MWSKZ EQ 'V0' OR WA_TAJ1-HWSTE EQ 0.
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.
       RRP4 = 1.
     ELSE.
       RRP3 = 1.
       IF WA_TAJ1-STATUS EQ 'RCM'.
         IF WA_TAJ1-HWSTE LT 0.
           WA_ALV1-TEXT = 'N. JV PASSED RCM LIABILITY'.
           SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAJ1-BELNR
             AND GJAHR EQ WA_TAJ1-GJAHR
             AND XREVERSAL EQ '2'.
           IF SY-SUBRC EQ 0.
             READ TABLE IT_BSEGI1 INTO WA_BSEGI1 WITH
             KEY BELNR = WA_TAJ1-BELNR
                 GJAHR = WA_TAJ1-GJAHR.
             IF SY-SUBRC EQ 0.
               WA_ALV1-TEXT = 'N. JV PASSED RCM LIABILITY ELIGIBLE'.
             ELSE.
               WA_ALV1-TEXT = 'N. JV PASSED RCM INLIABILITY'.
             ENDIF.
           ENDIF.
           SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
                  AND BELNR EQ WA_TAJ1-BELNR
                  AND GJAHR EQ WA_TAJ1-GJAHR
                  AND XREVERSAL EQ ' '.
           IF SY-SUBRC EQ 0.
             SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
               AND BELNR EQ WA_TAJ1-BELNR
               AND GJAHR = WA_TAJ1-GJAHR
               AND BUZEI EQ '001'
               AND KOART EQ 'K'
               AND SHKZG EQ 'S' .
             IF SY-SUBRC EQ 0.
               READ TABLE IT_BSEGI1 INTO WA_BSEGI1 WITH
               KEY BELNR = WA_TAJ1-BELNR
                   GJAHR = WA_TAJ1-GJAHR.
               IF SY-SUBRC EQ 0.
                 WA_ALV1-TEXT = 'N. JV PASSED RCM LIABILITY ELIGIBLE'.
               ELSE.
                 WA_ALV1-TEXT = 'N. JV PASSED RCM INLIABILITY'.
               ENDIF.
             ENDIF.
           ENDIF.
         ELSE.
           READ TABLE IT_BSEGI1 INTO WA_BSEGI1 WITH KEY
           BELNR = WA_TAJ1-BELNR
           GJAHR = WA_TAJ1-GJAHR.
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'N. JV PASSED RCM LIABILITY ELIGIBLE'.
           ELSE.
             WA_ALV1-TEXT = 'N. JV PASSED RCM INLIABILITY'.
           ENDIF.
           SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAJ1-BELNR
             AND GJAHR EQ WA_TAJ1-GJAHR
             AND XREVERSAL EQ '2'.
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'N. JV PASSED RCM LIABILITY'.
           ENDIF.
           SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAJ1-BELNR
             AND GJAHR EQ WA_TAJ1-GJAHR
             AND XREVERSAL EQ ' '.
           IF SY-SUBRC EQ 0.
             SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
               AND BELNR EQ WA_TAJ1-BELNR
               AND GJAHR = WA_TAJ1-GJAHR
               AND BUZEI EQ '001'
               AND KOART EQ 'K'
               AND SHKZG EQ 'S' .
             IF SY-SUBRC EQ 0.
               WA_ALV1-TEXT = 'N. JV PASSED RCM LIABILITY'.
             ENDIF.
           ENDIF.
         ENDIF.
       ELSE.
         WA_ALV1-TEXT = 'N. JV PASSED'.
         RRP3 = 0.
         RRP4 = 1.
       ENDIF.
     ENDIF.
     WA_ALV1-BUDAT = WA_TAJ1-BUDAT.
     WA_ALV1-TCODE = WA_TAJ1-TCODE.
     WA_ALV1-USNAM = WA_TAJ1-USNAM.
     WA_ALV1-BUPLA = WA_TAJ1-BUPLA.
     WA_ALV1-GSBER = WA_TAJ1-GSBER.
     WA_ALV1-BELNR = WA_TAJ1-BELNR.
     WA_ALV1-BLDAT = WA_TAJ1-BLDAT.
     WA_ALV1-XBLNR = WA_TAJ1-XBLNR.
     WA_ALV1-VBELN = WA_TAJ1-VBELN.
     WA_ALV1-STEUC = WA_TAJ1-STEUC.
     WA_ALV1-MENGE = WA_TAJ1-MENGE.
     WA_ALV1-MEINS = WA_TAJ1-MEINS.
     WA_ALV1-GJAHR = WA_TAJ1-GJAHR.
     WA_ALV1-HKONT = WA_TAJ1-HKONT.
     WA_ALV1-LIFNR = WA_TAJ1-LIFNR.
     WA_ALV1-NAME1 = WA_TAJ1-NAME1.
     WA_ALV1-MWSKZ = WA_TAJ1-MWSKZ.
     WA_ALV1-DMBTR = WA_TAJ1-DMBTR.
     WA_ALV1-HWBAS = WA_TAJ1-HWBAS.
     WA_ALV1-HWSTE = WA_TAJ1-HWSTE.
     WA_ALV1-IGST = WA_TAJ1-IGST.
     WA_ALV1-SGST = WA_TAJ1-SGST.
     WA_ALV1-UGST = WA_TAJ1-UGST.
     WA_ALV1-CGST = WA_TAJ1-CGST.
     WA_ALV1-SIG = WA_TAJ1-SIG.
     WA_ALV1-RATE = WA_TAJ1-RATE.
     WA_ALV1-CESS = WA_TAJ1-CESS.
     WA_ALV1-TDS = WA_TAJ1-TDS.
     WA_ALV1-BELNR_CLR = WA_TAJ1-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TAJ1-AUGDT.
     WA_ALV1-ORT01 = WA_TAJ1-ORT01.
     WA_ALV1-VENREG = WA_TAJ1-VENREG.
     WA_ALV1-STCD3 = WA_TAJ1-STCD3.
     WA_ALV1-SGTXT = WA_TAJ1-SGTXT.
     WA_ALV1-SCODE = WA_TAJ1-SCODE.
     WA_ALV1-VEN_CL = WA_TAJ1-VEN_CL.
     WA_ALV1-PAN = WA_TAJ1-PAN.
     WA_ALV1-MBLNR = WA_TAJ1-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TAJ1-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TAJ1-RECP.
     WA_ALV1-RECP_DT = WA_TAJ1-RECP_DT.
     WA_ALV1-RSTAT = WA_TAJ1-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
*     CLEAR WA_ALV1.
****************************************
     IF RRP3 EQ 1.
       WA_RRP3-TEXT = WA_ALV1-TEXT.
       WA_RRP3-BUDAT = WA_TAJ1-BUDAT.
       WA_RRP3-TCODE = WA_TAJ1-TCODE.
       WA_RRP3-USNAM = WA_TAJ1-USNAM.
       WA_RRP3-BUPLA = WA_TAJ1-BUPLA.
       WA_RRP3-GSBER = WA_TAJ1-GSBER.
       WA_RRP3-BELNR = WA_TAJ1-BELNR.
       WA_RRP3-BLDAT = WA_TAJ1-BLDAT.
       WA_RRP3-XBLNR = WA_TAJ1-XBLNR.
       WA_RRP3-VBELN = WA_TAJ1-VBELN.
       WA_RRP3-STEUC = WA_TAJ1-STEUC.
       WA_RRP3-MENGE = WA_TAJ1-MENGE.
       WA_RRP3-MEINS = WA_TAJ1-MEINS.
       WA_RRP3-GJAHR = WA_TAJ1-GJAHR.
       WA_RRP3-HKONT = WA_TAJ1-HKONT.
       WA_RRP3-LIFNR = WA_TAJ1-LIFNR.
       WA_RRP3-NAME1 = WA_TAJ1-NAME1.
       WA_RRP3-MWSKZ = WA_TAJ1-MWSKZ.
       WA_RRP3-DMBTR = WA_TAJ1-DMBTR.
       WA_RRP3-HWBAS = WA_TAJ1-HWBAS.
       WA_RRP3-HWSTE = WA_TAJ1-HWSTE.
       WA_RRP3-IGST = WA_TAJ1-IGST.
       WA_RRP3-SGST = WA_TAJ1-SGST.
       WA_RRP3-UGST = WA_TAJ1-UGST.
       WA_RRP3-CGST = WA_TAJ1-CGST.
       WA_RRP3-SIG = WA_TAJ1-SIG.
       WA_RRP3-RATE = WA_TAJ1-RATE.
       WA_RRP3-CESS = WA_TAJ1-CESS.
       WA_RRP3-TDS = WA_TAJ1-TDS.
       WA_RRP3-BELNR_CLR = WA_TAJ1-BELNR_CLR.
       WA_RRP3-AUGDT = WA_TAJ1-AUGDT.
       WA_RRP3-ORT01 = WA_TAJ1-ORT01.
       WA_RRP3-VENREG = WA_TAJ1-VENREG.
       WA_RRP3-STCD3 = WA_TAJ1-STCD3.
       WA_RRP3-SGTXT = WA_TAJ1-SGTXT.
       WA_RRP3-SCODE = WA_TAJ1-SCODE.
       WA_RRP3-VEN_CL = WA_TAJ1-VEN_CL.
       WA_RRP3-PAN = WA_TAJ1-PAN.
       WA_RRP3-MBLNR = WA_TAJ1-MBLNR.
       WA_RRP3-MKPF_BUDAT = WA_TAJ1-MKPF_BUDAT.
       WA_RRP3-RECP = WA_TAJ1-RECP.
       WA_RRP3-RECP_DT = WA_TAJ1-RECP_DT.
       WA_RRP3-RSTAT = WA_TAJ1-RSTAT.
       COLLECT WA_RRP3 INTO IT_RRP3.
       CLEAR WA_RRP3.

     ELSEIF RRP4 EQ 1.

       WA_RRP4-TEXT = WA_ALV1-TEXT.
       WA_RRP4-BUDAT = WA_TAJ1-BUDAT.
       WA_RRP4-TCODE = WA_TAJ1-TCODE.
       WA_RRP4-USNAM = WA_TAJ1-USNAM.
       WA_RRP4-BUPLA = WA_TAJ1-BUPLA.
       WA_RRP4-GSBER = WA_TAJ1-GSBER.
       WA_RRP4-BELNR = WA_TAJ1-BELNR.
       WA_RRP4-BLDAT = WA_TAJ1-BLDAT.
       WA_RRP4-XBLNR = WA_TAJ1-XBLNR.
       WA_RRP4-VBELN = WA_TAJ1-VBELN.
       WA_RRP4-STEUC = WA_TAJ1-STEUC.
       WA_RRP4-MENGE = WA_TAJ1-MENGE.
       WA_RRP4-MEINS = WA_TAJ1-MEINS.
       WA_RRP4-GJAHR = WA_TAJ1-GJAHR.
       WA_RRP4-HKONT = WA_TAJ1-HKONT.
       WA_RRP4-LIFNR = WA_TAJ1-LIFNR.
       WA_RRP4-NAME1 = WA_TAJ1-NAME1.
       WA_RRP4-MWSKZ = WA_TAJ1-MWSKZ.
       WA_RRP4-DMBTR = WA_TAJ1-DMBTR.
       WA_RRP4-HWBAS = WA_TAJ1-HWBAS.
       WA_RRP4-HWSTE = WA_TAJ1-HWSTE.
       WA_RRP4-IGST = WA_TAJ1-IGST.
       WA_RRP4-SGST = WA_TAJ1-SGST.
       WA_RRP4-UGST = WA_TAJ1-UGST.
       WA_RRP4-CGST = WA_TAJ1-CGST.
       WA_RRP4-SIG = WA_TAJ1-SIG.
       WA_RRP4-RATE = WA_TAJ1-RATE.
       WA_RRP4-CESS = WA_TAJ1-CESS.
       WA_RRP4-TDS = WA_TAJ1-TDS.
       WA_RRP4-BELNR_CLR = WA_TAJ1-BELNR_CLR.
       WA_RRP4-AUGDT = WA_TAJ1-AUGDT.
       WA_RRP4-ORT01 = WA_TAJ1-ORT01.
       WA_RRP4-VENREG = WA_TAJ1-VENREG.
       WA_RRP4-STCD3 = WA_TAJ1-STCD3.
       WA_RRP4-SGTXT = WA_TAJ1-SGTXT.
       WA_RRP4-SCODE = WA_TAJ1-SCODE.
       WA_RRP4-VEN_CL = WA_TAJ1-VEN_CL.
       WA_RRP4-PAN = WA_TAJ1-PAN.
       WA_RRP4-MBLNR = WA_TAJ1-MBLNR.
       WA_RRP4-MKPF_BUDAT = WA_TAJ1-MKPF_BUDAT.
       WA_RRP4-RECP = WA_TAJ1-RECP.
       WA_RRP4-RECP_DT = WA_TAJ1-RECP_DT.
       WA_RRP4-RSTAT = WA_TAJ1-RSTAT.
       COLLECT WA_RRP4 INTO IT_RRP4.
       CLEAR WA_RRP4.
     ENDIF.

******************************************

     CLEAR WA_ALV1.
   ENDLOOP.

******************************

   LOOP AT IT_TAS5ING INTO WA_TAS5ING .
     CLEAR : A1,GJAHR,RRP2,RRP3,RRP4.
     IF WA_TAS5ING-MWSKZ EQ 'V0' OR WA_TAS5ING-HWSTE EQ 0.
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.
     ELSE.
       IF WA_TAS5ING-HWSTE LT 0. "16.9.2019
         WA_ALV1-TEXT = 'C. ITC NOT AVAILABLE ON EXPENSES -'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS5ING-BELNR
           AND GJAHR EQ WA_TAS5ING-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'C. ITC NOT AVAILABLE ON EXPENSES +'.
         ENDIF.

**********************************7.2.21
         IF WA_TAS5ING-TCODE EQ 'MR8M'.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAS5ING-BELNR
             AND GJAHR EQ WA_TAS5ING-GJAHR
             AND KOART EQ 'K'
             AND SHKZG EQ 'S'.
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'C. ITC NOT AVAILABLE ON EXPENSES +'.
           ENDIF.
         ENDIF.
*******************************

       ELSE.
         WA_ALV1-TEXT = 'C. ITC NOT AVAILABLE ON EXPENSES +'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS5ING-BELNR
           AND GJAHR EQ WA_TAS5ING-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'C. ITC NOT AVAILABLE ON EXPENSES -'.
         ENDIF.
****************************************************************7.2.21
         IF WA_TAS5ING-TCODE EQ 'MR8M'.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAS5ING-BELNR
             AND GJAHR EQ WA_TAS5ING-GJAHR
             AND KOART EQ 'K'
             AND SHKZG EQ 'S'.
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'C. ITC NOT AVAILABLE ON EXPENSES -'.
           ENDIF.
         ENDIF.
************************
       ENDIF.
*       WA_ALV1-TEXT = 'C. ITC NOT AVAILABLE ON EXPENSES'.
     ENDIF.
     WA_ALV1-BUDAT = WA_TAS5ING-BUDAT.
     WA_ALV1-TCODE = WA_TAS5ING-TCODE.
     WA_ALV1-USNAM = WA_TAS5ING-USNAM.
     WA_ALV1-BUPLA = WA_TAS5ING-BUPLA.
     WA_ALV1-GSBER = WA_TAS5ING-GSBER.
     WA_ALV1-BELNR = WA_TAS5ING-BELNR.
     WA_ALV1-BLDAT = WA_TAS5ING-BLDAT.
     WA_ALV1-XBLNR = WA_TAS5ING-XBLNR.
     WA_ALV1-VBELN = WA_TAS5ING-VBELN.
     WA_ALV1-STEUC = WA_TAS5ING-STEUC.
     WA_ALV1-MENGE = WA_TAS5ING-MENGE.
     WA_ALV1-MEINS = WA_TAS5ING-MEINS.
     WA_ALV1-GJAHR = WA_TAS5ING-GJAHR.
     WA_ALV1-HKONT = WA_TAS5ING-HKONT.
     WA_ALV1-LIFNR = WA_TAS5ING-LIFNR.
     WA_ALV1-NAME1 = WA_TAS5ING-NAME1.
     WA_ALV1-MWSKZ = WA_TAS5ING-MWSKZ.
     WA_ALV1-DMBTR = WA_TAS5ING-DMBTR.
     WA_ALV1-HWBAS = WA_TAS5ING-HWBAS.
     WA_ALV1-HWSTE = WA_TAS5ING-HWSTE.
     WA_ALV1-IGST = WA_TAS5ING-IGST.
     WA_ALV1-SGST = WA_TAS5ING-SGST.
     WA_ALV1-UGST = WA_TAS5ING-UGST.
     WA_ALV1-CGST = WA_TAS5ING-CGST.
     WA_ALV1-SIG = WA_TAS5ING-SIG.
     WA_ALV1-RATE = WA_TAS5ING-RATE.
     WA_ALV1-CESS = WA_TAS5ING-CESS.
     WA_ALV1-TDS = WA_TAS5ING-TDS.
     WA_ALV1-BELNR_CLR = WA_TAS5ING-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TAS5ING-AUGDT.
     WA_ALV1-ORT01 = WA_TAS5ING-ORT01.
     WA_ALV1-VENREG = WA_TAS5ING-VENREG.
     WA_ALV1-STCD3 = WA_TAS5ING-STCD3.
     WA_ALV1-SGTXT = WA_TAS5ING-SGTXT.
     WA_ALV1-SCODE = WA_TAS5ING-SCODE.
     WA_ALV1-VEN_CL = WA_TAS5ING-VEN_CL.
     WA_ALV1-PAN = WA_TAS5ING-PAN.
     WA_ALV1-MBLNR = WA_TAS5ING-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TAS5ING-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TAS5ING-RECP.
     WA_ALV1-RECP_DT = WA_TAS5ING-RECP_DT.
     WA_ALV1-RSTAT = WA_TAS5ING-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
*     CLEAR WA_ALV1.
*******************************
     GJAHR = WA_TAS5ING-GJAHR.

*********************************************
     WA_RRP4-TEXT = WA_ALV1-TEXT.
     WA_RRP4-BUDAT = WA_TAS5ING-BUDAT.
     WA_RRP4-TCODE = WA_TAS5ING-TCODE.
     WA_RRP4-USNAM = WA_TAS5ING-USNAM.
     WA_RRP4-BUPLA = WA_TAS5ING-BUPLA.
     WA_RRP4-GSBER = WA_TAS5ING-GSBER.
     WA_RRP4-BELNR = WA_TAS5ING-BELNR.
     WA_RRP4-BLDAT = WA_TAS5ING-BLDAT.
     WA_RRP4-XBLNR = WA_TAS5ING-XBLNR.
     WA_RRP4-VBELN = WA_TAS5ING-VBELN.
     WA_RRP4-STEUC = WA_TAS5ING-STEUC.
     WA_RRP4-MENGE = WA_TAS5ING-MENGE.
     WA_RRP4-MEINS = WA_TAS5ING-MEINS.
     WA_RRP4-GJAHR = WA_TAS5ING-GJAHR.
     WA_RRP4-HKONT = WA_TAS5ING-HKONT.
     WA_RRP4-LIFNR = WA_TAS5ING-LIFNR.
     WA_RRP4-NAME1 = WA_TAS5ING-NAME1.
     WA_RRP4-MWSKZ = WA_TAS5ING-MWSKZ.
     WA_RRP4-DMBTR = WA_TAS5ING-DMBTR.
     WA_RRP4-HWBAS = WA_TAS5ING-HWBAS.
     WA_RRP4-HWSTE = WA_TAS5ING-HWSTE.
     WA_RRP4-IGST = WA_TAS5ING-IGST.
     WA_RRP4-SGST = WA_TAS5ING-SGST.
     WA_RRP4-UGST = WA_TAS5ING-UGST.
     WA_RRP4-CGST = WA_TAS5ING-CGST.
     WA_RRP4-SIG = WA_TAS5ING-SIG.
     WA_RRP4-RATE = WA_TAS5ING-RATE.
     WA_RRP4-CESS = WA_TAS5ING-CESS.
     WA_RRP4-TDS = WA_TAS5ING-TDS.
     WA_RRP4-BELNR_CLR = WA_TAS5ING-BELNR_CLR.
     WA_RRP4-AUGDT = WA_TAS5ING-AUGDT.
     WA_RRP4-ORT01 = WA_TAS5ING-ORT01.
     WA_RRP4-VENREG = WA_TAS5ING-VENREG.
     WA_RRP4-STCD3 = WA_TAS5ING-STCD3.
     WA_RRP4-SGTXT = WA_TAS5ING-SGTXT.
     WA_RRP4-SCODE = WA_TAS5ING-SCODE.
     WA_RRP4-VEN_CL = WA_TAS5ING-VEN_CL.
     WA_RRP4-PAN = WA_TAS5ING-PAN.
     WA_RRP4-MBLNR = WA_TAS5ING-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_TAS5ING-MKPF_BUDAT.
     WA_RRP4-RECP = WA_TAS5ING-RECP.
     WA_RRP4-RECP_DT = WA_TAS5ING-RECP_DT.
     WA_RRP4-RSTAT = WA_TAS5ING-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.

********************************************

     CLEAR WA_ALV1.
   ENDLOOP.
********************


   LOOP AT IT_TAS7 INTO WA_TAS7.
     IF WA_TAS7-HWSTE EQ 0 .  "13.8.2019
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.
       WA_ALV1-BUDAT = WA_TAS7-BUDAT.
       WA_ALV1-TCODE = WA_TAS7-TCODE.
       WA_ALV1-USNAM = WA_TAS7-USNAM.
       WA_ALV1-BUPLA = WA_TAS7-BUPLA.
       WA_ALV1-GSBER = WA_TAS7-GSBER.
       WA_ALV1-BELNR = WA_TAS7-BELNR.
       WA_ALV1-BLDAT = WA_TAS7-BLDAT.
       WA_ALV1-XBLNR = WA_TAS7-XBLNR.
       WA_ALV1-VBELN = WA_TAS7-VBELN.
       WA_ALV1-STEUC = WA_TAS7-STEUC.
       WA_ALV1-MENGE = WA_TAS7-MENGE.
       WA_ALV1-MEINS = WA_TAS7-MEINS.
       WA_ALV1-GJAHR = WA_TAS7-GJAHR.
       WA_ALV1-HKONT = WA_TAS7-HKONT.
       WA_ALV1-LIFNR = WA_TAS7-LIFNR.
       WA_ALV1-NAME1 = WA_TAS7-NAME1.
       WA_ALV1-MWSKZ = WA_TAS7-MWSKZ.
       WA_ALV1-DMBTR = WA_TAS7-DMBTR.
       WA_ALV1-HWBAS = WA_TAS7-HWBAS.
       WA_ALV1-HWSTE = WA_TAS7-HWSTE.
       WA_ALV1-IGST = WA_TAS7-IGST.
       WA_ALV1-SGST = WA_TAS7-SGST.
       WA_ALV1-UGST = WA_TAS7-UGST.
       WA_ALV1-CGST = WA_TAS7-CGST.
       WA_ALV1-SIG = WA_TAS7-SIG.
       WA_ALV1-RATE = WA_TAS7-RATE.
       WA_ALV1-CESS = WA_TAS7-CESS.
       WA_ALV1-TDS = WA_TAS7-TDS.
       WA_ALV1-BELNR_CLR = WA_TAS7-BELNR_CLR.
       WA_ALV1-AUGDT = WA_TAS7-AUGDT.
       WA_ALV1-ORT01 = WA_TAS7-ORT01.
       WA_ALV1-VENREG = WA_TAS7-VENREG.
       WA_ALV1-STCD3 = WA_TAS7-STCD3.
       WA_ALV1-SGTXT = WA_TAS7-SGTXT.
       WA_ALV1-SCODE = WA_TAS7-SCODE.
       WA_ALV1-VEN_CL = WA_TAS7-VEN_CL.
       WA_ALV1-PAN = WA_TAS7-PAN.
       WA_ALV1-MBLNR = WA_TAS7-MBLNR.
       WA_ALV1-MKPF_BUDAT = WA_TAS7-MKPF_BUDAT.
       WA_ALV1-RECP = WA_TAS7-RECP.
       WA_ALV1-RECP_DT = WA_TAS7-RECP_DT.
       WA_ALV1-RSTAT = WA_TAS7-RSTAT.
       COLLECT WA_ALV1 INTO IT_ALV1.
*       CLEAR WA_ALV1.

*****************************
     ELSE.

       IF WA_TAS7-HWSTE GT 0.
         WA_ALV1-TEXT = 'D. ITC AVAILABLE ON EXPENSES'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS7-BELNR
           AND GJAHR = WA_TAS7-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'F. ITC AVAILABLE ON INVENTORY PURCHASES- DEBIT/CREDIT NOTE'.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS7-BELNR
           AND GJAHR = WA_TAS7-GJAHR AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAS7-BELNR
             AND GJAHR = WA_TAS7-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'F. ITC AVAILABLE ON INVENTORY PURCHASES- DEBIT/CREDIT NOTE'.
           ENDIF.
         ENDIF.
       ELSE.
         WA_ALV1-TEXT = 'F. ITC AVAILABLE ON INVENTORY PURCHASES- DEBIT/CREDIT NOTE'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS7-BELNR
           AND GJAHR = WA_TAS7-GJAHR
           AND XREVERSAL EQ '2'.
         IF SY-SUBRC EQ 0.
           WA_ALV1-TEXT = 'D. ITC AVAILABLE ON EXPENSES'.
         ENDIF.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS7-BELNR
           AND GJAHR = WA_TAS7-GJAHR
           AND XREVERSAL EQ ' '.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_TAS7-BELNR
             AND GJAHR = WA_TAS7-GJAHR
             AND BUZEI EQ '001'
             AND KOART EQ 'K'
             AND SHKZG EQ 'S' .
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'D. ITC AVAILABLE ON EXPENSES'.
           ENDIF.
         ENDIF.
       ENDIF.

       WA_ALV1-BUDAT = WA_TAS7-BUDAT.
       WA_ALV1-TCODE = WA_TAS7-TCODE.
       WA_ALV1-USNAM = WA_TAS7-USNAM.
       WA_ALV1-BUPLA = WA_TAS7-BUPLA.
       WA_ALV1-GSBER = WA_TAS7-GSBER.
       WA_ALV1-BELNR = WA_TAS7-BELNR.
       WA_ALV1-BLDAT = WA_TAS7-BLDAT.
       WA_ALV1-XBLNR = WA_TAS7-XBLNR.
       WA_ALV1-VBELN = WA_TAS7-VBELN.
       WA_ALV1-STEUC = WA_TAS7-STEUC.
       WA_ALV1-MENGE = WA_TAS7-MENGE.
       WA_ALV1-MEINS = WA_TAS7-MEINS.
       WA_ALV1-GJAHR = WA_TAS7-GJAHR.
       WA_ALV1-HKONT = WA_TAS7-HKONT.
       WA_ALV1-LIFNR = WA_TAS7-LIFNR.
       WA_ALV1-NAME1 = WA_TAS7-NAME1.
       WA_ALV1-MWSKZ = WA_TAS7-MWSKZ.
       WA_ALV1-DMBTR = WA_TAS7-DMBTR.
       WA_ALV1-HWBAS = WA_TAS7-HWBAS.
       WA_ALV1-HWSTE = WA_TAS7-HWSTE.
       WA_ALV1-IGST = WA_TAS7-IGST.
       WA_ALV1-SGST = WA_TAS7-SGST.
       WA_ALV1-UGST = WA_TAS7-UGST.
       WA_ALV1-CGST = WA_TAS7-CGST.
       WA_ALV1-SIG = WA_TAS7-SIG.
       WA_ALV1-RATE = WA_TAS7-RATE.
       WA_ALV1-CESS = WA_TAS7-CESS.
       WA_ALV1-TDS = WA_TAS7-TDS.
       WA_ALV1-BELNR_CLR = WA_TAS7-BELNR_CLR.
       WA_ALV1-AUGDT = WA_TAS7-AUGDT.
       WA_ALV1-ORT01 = WA_TAS7-ORT01.
       WA_ALV1-VENREG = WA_TAS7-VENREG.
       WA_ALV1-STCD3 = WA_TAS7-STCD3.
       WA_ALV1-SGTXT = WA_TAS7-SGTXT.
       WA_ALV1-SCODE = WA_TAS7-SCODE.
       WA_ALV1-VEN_CL = WA_TAS7-VEN_CL.
       WA_ALV1-PAN = WA_TAS7-PAN.
       WA_ALV1-MBLNR = WA_TAS7-MBLNR.
       WA_ALV1-MKPF_BUDAT = WA_TAS7-MKPF_BUDAT.
       WA_ALV1-RECP = WA_TAS7-RECP.
       WA_ALV1-RECP_DT = WA_TAS7-RECP_DT.
       WA_ALV1-RSTAT = WA_TAS7-RSTAT.
       COLLECT WA_ALV1 INTO IT_ALV1.
*       CLEAR WA_ALV1.
     ENDIF.

*******************************************
     WA_RRP4-TEXT = WA_ALV1-TEXT.
     WA_RRP4-BUDAT = WA_TAS7-BUDAT.
     WA_RRP4-TCODE = WA_TAS7-TCODE.
     WA_RRP4-USNAM = WA_TAS7-USNAM.
     WA_RRP4-BUPLA = WA_TAS7-BUPLA.
     WA_RRP4-GSBER = WA_TAS7-GSBER.
     WA_RRP4-BELNR = WA_TAS7-BELNR.
     WA_RRP4-BLDAT = WA_TAS7-BLDAT.
     WA_RRP4-XBLNR = WA_TAS7-XBLNR.
     WA_RRP4-VBELN = WA_TAS7-VBELN.
     WA_RRP4-STEUC = WA_TAS7-STEUC.
     WA_RRP4-MENGE = WA_TAS7-MENGE.
     WA_RRP4-MEINS = WA_TAS7-MEINS.
     WA_RRP4-GJAHR = WA_TAS7-GJAHR.
     WA_RRP4-HKONT = WA_TAS7-HKONT.
     WA_RRP4-LIFNR = WA_TAS7-LIFNR.
     WA_RRP4-NAME1 = WA_TAS7-NAME1.
     WA_RRP4-MWSKZ = WA_TAS7-MWSKZ.
     WA_RRP4-DMBTR = WA_TAS7-DMBTR.
     WA_RRP4-HWBAS = WA_TAS7-HWBAS.
     WA_RRP4-HWSTE = WA_TAS7-HWSTE.
     WA_RRP4-IGST = WA_TAS7-IGST.
     WA_RRP4-SGST = WA_TAS7-SGST.
     WA_RRP4-UGST = WA_TAS7-UGST.
     WA_RRP4-CGST = WA_TAS7-CGST.
     WA_RRP4-SIG = WA_TAS7-SIG.
     WA_RRP4-RATE = WA_TAS7-RATE.
     WA_RRP4-CESS = WA_TAS7-CESS.
     WA_RRP4-TDS = WA_TAS7-TDS.
     WA_RRP4-BELNR_CLR = WA_TAS7-BELNR_CLR.
     WA_RRP4-AUGDT = WA_TAS7-AUGDT.
     WA_RRP4-ORT01 = WA_TAS7-ORT01.
     WA_RRP4-VENREG = WA_TAS7-VENREG.
     WA_RRP4-STCD3 = WA_TAS7-STCD3.
     WA_RRP4-SGTXT = WA_TAS7-SGTXT.
     WA_RRP4-SCODE = WA_TAS7-SCODE.
     WA_RRP4-VEN_CL = WA_TAS7-VEN_CL.
     WA_RRP4-PAN = WA_TAS7-PAN.
     WA_RRP4-MBLNR = WA_TAS7-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_TAS7-MKPF_BUDAT.
     WA_RRP4-RECP = WA_TAS7-RECP.
     WA_RRP4-RECP_DT = WA_TAS7-RECP_DT.
     WA_RRP4-RSTAT = WA_TAS7-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.
************************************
     CLEAR WA_ALV1.
   ENDLOOP.


   LOOP AT IT_TAS10 INTO WA_TAS10.
     IF WA_TAS10-HWSTE EQ 0 OR WA_TAS10-MWSKZ EQ 'V0'.
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.
     ELSE.
       IF WA_TAS10-BLART EQ 'R1' OR
          WA_TAS10-BLART EQ 'R2' OR
          WA_TAS10-BLART EQ 'R3'.
         WA_ALV1-TEXT = 'F. ITC AVAILABLE ON INVENTORY PURCHASES- DEBIT/CREDIT NOTE'.
       ELSE.
         WA_ALV1-TEXT = 'E. ITC AVAILABLE ON INVENTORY PURCHASES'.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAS10-BELNR
           AND GJAHR EQ WA_TAS10-GJAHR .
         IF SY-SUBRC EQ 0.
           CLEAR : DOC.
           DOC = BKPF-AWKEY+0(10).
           SELECT SINGLE * FROM RSEG WHERE BELNR EQ DOC
             AND GJAHR EQ WA_TAS3-GJAHR
             AND TBTKZ EQ 'X'
             AND SHKZG EQ 'H'.
           IF SY-SUBRC EQ 0.
             WA_ALV1-TEXT = 'F. ITC AVAILABLE ON INVENTORY PURCHASES- DEBIT/CREDIT NOTE'.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.
     WA_ALV1-BUDAT = WA_TAS10-BUDAT.
     WA_ALV1-TCODE = WA_TAS10-TCODE.
     WA_ALV1-USNAM = WA_TAS10-USNAM.
     WA_ALV1-BUPLA = WA_TAS10-BUPLA.
     WA_ALV1-GSBER = WA_TAS10-GSBER.
     WA_ALV1-BELNR = WA_TAS10-BELNR.
     WA_ALV1-BLDAT = WA_TAS10-BLDAT.
     WA_ALV1-XBLNR = WA_TAS10-XBLNR.
     WA_ALV1-VBELN = WA_TAS10-VBELN.
     WA_ALV1-STEUC = WA_TAS10-STEUC.
     WA_ALV1-MENGE = WA_TAS10-MENGE.
     WA_ALV1-MEINS = WA_TAS10-MEINS.
     WA_ALV1-GJAHR = WA_TAS10-GJAHR.
     WA_ALV1-HKONT = WA_TAS10-HKONT.
     WA_ALV1-LIFNR = WA_TAS10-LIFNR.
     WA_ALV1-NAME1 = WA_TAS10-NAME1.
     WA_ALV1-MWSKZ = WA_TAS10-MWSKZ.
     WA_ALV1-DMBTR = WA_TAS10-DMBTR.
     WA_ALV1-HWBAS = WA_TAS10-HWBAS.
     WA_ALV1-HWSTE = WA_TAS10-HWSTE.
     WA_ALV1-IGST = WA_TAS10-IGST.
     WA_ALV1-SGST = WA_TAS10-SGST.
     WA_ALV1-UGST = WA_TAS10-UGST.
     WA_ALV1-CGST = WA_TAS10-CGST.
     WA_ALV1-SIG = WA_TAS10-SIG.
     WA_ALV1-RATE = WA_TAS10-RATE.
     WA_ALV1-CESS = WA_TAS10-CESS.
     WA_ALV1-TDS = WA_TAS10-TDS.
     WA_ALV1-BELNR_CLR = WA_TAS10-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TAS10-AUGDT.
     WA_ALV1-ORT01 = WA_TAS10-ORT01.
     WA_ALV1-VENREG = WA_TAS10-VENREG.
     WA_ALV1-STCD3 = WA_TAS10-STCD3.
     WA_ALV1-SGTXT = WA_TAS10-SGTXT.
     WA_ALV1-SCODE = WA_TAS10-SCODE.
     WA_ALV1-VEN_CL = WA_TAS10-VEN_CL.
     WA_ALV1-PAN = WA_TAS10-PAN.
     WA_ALV1-MBLNR = WA_TAS10-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TAS10-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TAS10-RECP.
     WA_ALV1-RECP_DT = WA_TAS10-RECP_DT.
     WA_ALV1-RSTAT = WA_TAS10-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
*     CLEAR WA_ALV1.
***************************************************
     WA_RRP4-TEXT = WA_ALV1-TEXT.
     WA_RRP4-BUDAT = WA_TAS10-BUDAT.
     WA_RRP4-TCODE = WA_TAS10-TCODE.
     WA_RRP4-USNAM = WA_TAS10-USNAM.
     WA_RRP4-BUPLA = WA_TAS10-BUPLA.
     WA_RRP4-GSBER = WA_TAS10-GSBER.
     WA_RRP4-BELNR = WA_TAS10-BELNR.
     WA_RRP4-BLDAT = WA_TAS10-BLDAT.
     WA_RRP4-XBLNR = WA_TAS10-XBLNR.
     WA_RRP4-VBELN = WA_TAS10-VBELN.
     WA_RRP4-STEUC = WA_TAS10-STEUC.
     WA_RRP4-MENGE = WA_TAS10-MENGE.
     WA_RRP4-MEINS = WA_TAS10-MEINS.
     WA_RRP4-GJAHR = WA_TAS10-GJAHR.
     WA_RRP4-HKONT = WA_TAS10-HKONT.
     WA_RRP4-LIFNR = WA_TAS10-LIFNR.
     WA_RRP4-NAME1 = WA_TAS10-NAME1.
     WA_RRP4-MWSKZ = WA_TAS10-MWSKZ.
     WA_RRP4-DMBTR = WA_TAS10-DMBTR.
     WA_RRP4-HWBAS = WA_TAS10-HWBAS.
     WA_RRP4-HWSTE = WA_TAS10-HWSTE.
     WA_RRP4-IGST = WA_TAS10-IGST.
     WA_RRP4-SGST = WA_TAS10-SGST.
     WA_RRP4-UGST = WA_TAS10-UGST.
     WA_RRP4-CGST = WA_TAS10-CGST.
     WA_RRP4-SIG = WA_TAS10-SIG.
     WA_RRP4-RATE = WA_TAS10-RATE.
     WA_RRP4-CESS = WA_TAS10-CESS.
     WA_RRP4-TDS = WA_TAS10-TDS.
     WA_RRP4-BELNR_CLR = WA_TAS10-BELNR_CLR.
     WA_RRP4-AUGDT = WA_TAS10-AUGDT.
     WA_RRP4-ORT01 = WA_TAS10-ORT01.
     WA_RRP4-VENREG = WA_TAS10-VENREG.
     WA_RRP4-STCD3 = WA_TAS10-STCD3.
     WA_RRP4-SGTXT = WA_TAS10-SGTXT.
     WA_RRP4-SCODE = WA_TAS10-SCODE.
     WA_RRP4-VEN_CL = WA_TAS10-VEN_CL.
     WA_RRP4-PAN = WA_TAS10-PAN.
     WA_RRP4-MBLNR = WA_TAS10-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_TAS10-MKPF_BUDAT.
     WA_RRP4-RECP = WA_TAS10-RECP.
     WA_RRP4-RECP_DT = WA_TAS10-RECP_DT.
     WA_RRP4-RSTAT = WA_TAS10-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.

******************************************************
     CLEAR WA_ALV1.
   ENDLOOP.

******************************************
   LOOP AT IT_TAS9 INTO WA_TAS9.
     IF WA_TAS9-HWSTE EQ 0 OR WA_TAS9-MWSKZ EQ 'V0'.
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.
     ELSE.
       WA_ALV1-TEXT = 'F. ITC AVAILABLE ON INVENTORY PURCHASES- DEBIT/CREDIT NOTE'.
     ENDIF.
     WA_ALV1-BUDAT = WA_TAS9-BUDAT.
     WA_ALV1-TCODE = WA_TAS9-TCODE.
     WA_ALV1-USNAM = WA_TAS9-USNAM.
     WA_ALV1-BUPLA = WA_TAS9-BUPLA.
     WA_ALV1-GSBER = WA_TAS9-GSBER.
     WA_ALV1-BELNR = WA_TAS9-BELNR.
     WA_ALV1-BLDAT = WA_TAS9-BLDAT.
     WA_ALV1-XBLNR = WA_TAS9-XBLNR.
     WA_ALV1-VBELN = WA_TAS9-VBELN.
     WA_ALV1-STEUC = WA_TAS9-STEUC.
     WA_ALV1-MENGE = WA_TAS9-MENGE.
     WA_ALV1-MEINS = WA_TAS9-MEINS.
     WA_ALV1-GJAHR = WA_TAS9-GJAHR.
     WA_ALV1-HKONT = WA_TAS9-HKONT.
     WA_ALV1-LIFNR = WA_TAS9-LIFNR.
     WA_ALV1-NAME1 = WA_TAS9-NAME1.
     WA_ALV1-MWSKZ = WA_TAS9-MWSKZ.
     WA_ALV1-DMBTR = WA_TAS9-DMBTR.
     WA_ALV1-HWBAS = WA_TAS9-HWBAS.
     WA_ALV1-HWSTE = WA_TAS9-HWSTE.
     WA_ALV1-IGST = WA_TAS9-IGST.
     WA_ALV1-SGST = WA_TAS9-SGST.
     WA_ALV1-UGST = WA_TAS9-UGST.
     WA_ALV1-CGST = WA_TAS9-CGST.
     WA_ALV1-SIG = WA_TAS9-SIG.
     WA_ALV1-RATE = WA_TAS9-RATE.
     WA_ALV1-CESS = WA_TAS9-CESS.
     WA_ALV1-TDS = WA_TAS9-TDS.
     WA_ALV1-BELNR_CLR = WA_TAS9-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TAS9-AUGDT.
     WA_ALV1-ORT01 = WA_TAS9-ORT01.
     WA_ALV1-VENREG = WA_TAS9-VENREG.
     WA_ALV1-STCD3 = WA_TAS9-STCD3.
     WA_ALV1-SGTXT = WA_TAS9-SGTXT.
     WA_ALV1-SCODE = WA_TAS9-SCODE.
     WA_ALV1-VEN_CL = WA_TAS9-VEN_CL.
     WA_ALV1-PAN = WA_TAS9-PAN.
     WA_ALV1-MBLNR = WA_TAS9-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TAS9-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TAS9-RECP.
     WA_ALV1-RECP_DT = WA_TAS9-RECP_DT.
     WA_ALV1-RSTAT = WA_TAS9-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.

***************************************************
     WA_RRP4-TEXT = WA_ALV1-TEXT.
     WA_RRP4-BUDAT = WA_TAS9-BUDAT.
     WA_RRP4-TCODE = WA_TAS9-TCODE.
     WA_RRP4-USNAM = WA_TAS9-USNAM.
     WA_RRP4-BUPLA = WA_TAS9-BUPLA.
     WA_RRP4-GSBER = WA_TAS9-GSBER.
     WA_RRP4-BELNR = WA_TAS9-BELNR.
     WA_RRP4-BLDAT = WA_TAS9-BLDAT.
     WA_RRP4-XBLNR = WA_TAS9-XBLNR.
     WA_RRP4-VBELN = WA_TAS9-VBELN.
     WA_RRP4-STEUC = WA_TAS9-STEUC.
     WA_RRP4-MENGE = WA_TAS9-MENGE.
     WA_RRP4-MEINS = WA_TAS9-MEINS.
     WA_RRP4-GJAHR = WA_TAS9-GJAHR.
     WA_RRP4-HKONT = WA_TAS9-HKONT.
     WA_RRP4-LIFNR = WA_TAS9-LIFNR.
     WA_RRP4-NAME1 = WA_TAS9-NAME1.
     WA_RRP4-MWSKZ = WA_TAS9-MWSKZ.
     WA_RRP4-DMBTR = WA_TAS9-DMBTR.
     WA_RRP4-HWBAS = WA_TAS9-HWBAS.
     WA_RRP4-HWSTE = WA_TAS9-HWSTE.
     WA_RRP4-IGST = WA_TAS9-IGST.
     WA_RRP4-SGST = WA_TAS9-SGST.
     WA_RRP4-UGST = WA_TAS9-UGST.
     WA_RRP4-CGST = WA_TAS9-CGST.
     WA_RRP4-SIG = WA_TAS9-SIG.
     WA_RRP4-RATE = WA_TAS9-RATE.
     WA_RRP4-CESS = WA_TAS9-CESS.
     WA_RRP4-TDS = WA_TAS9-TDS.
     WA_RRP4-BELNR_CLR = WA_TAS9-BELNR_CLR.
     WA_RRP4-AUGDT = WA_TAS9-AUGDT.
     WA_RRP4-ORT01 = WA_TAS9-ORT01.
     WA_RRP4-VENREG = WA_TAS9-VENREG.
     WA_RRP4-STCD3 = WA_TAS9-STCD3.
     WA_RRP4-SGTXT = WA_TAS9-SGTXT.
     WA_RRP4-SCODE = WA_TAS9-SCODE.
     WA_RRP4-VEN_CL = WA_TAS9-VEN_CL.
     WA_RRP4-PAN = WA_TAS9-PAN.
     WA_RRP4-MBLNR = WA_TAS9-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_TAS9-MKPF_BUDAT.
     WA_RRP4-RECP = WA_TAS9-RECP.
     WA_RRP4-RECP_DT = WA_TAS9-RECP_DT.
     WA_RRP4-RSTAT = WA_TAS9-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.
****************************************************
     CLEAR WA_ALV1.
   ENDLOOP.

   LOOP AT IT_TAS4 INTO WA_TAS4.
     SELECT SINGLE * FROM VBRK WHERE VBELN EQ WA_TAS4-VBELN
       AND FKART EQ 'ZSMT'.  "27.11.2019
     IF SY-SUBRC EQ 0.
       WA_ALV1-TEXT = 'G. 2.ITC NOT AVAILABLE ON BR TRF RECEIPT'.
       WA_RRP4-TEXT = 'G. 2.ITC NOT AVAILABLE ON BR TRF RECEIPT'.
     ELSE.
       WA_ALV1-TEXT = 'G. 1.ITC AVAILABLE ON BR TRF RECEIPT'.
       WA_RRP4-TEXT = 'G. 1.ITC AVAILABLE ON BR TRF RECEIPT'.
     ENDIF.
     WA_ALV1-BUDAT = WA_TAS4-BUDAT.
     WA_ALV1-TCODE = WA_TAS4-TCODE.
     WA_ALV1-USNAM = WA_TAS4-USNAM.
     WA_ALV1-BUPLA = WA_TAS4-BUPLA.
     WA_ALV1-GSBER = WA_TAS4-GSBER.
     WA_ALV1-BELNR = WA_TAS4-BELNR.
     WA_ALV1-BLDAT = WA_TAS4-BLDAT.
     WA_ALV1-XBLNR = WA_TAS4-XBLNR.
     WA_ALV1-VBELN = WA_TAS4-VBELN.
     WA_ALV1-STEUC = WA_TAS4-STEUC.
     WA_ALV1-MENGE = WA_TAS4-MENGE.
     WA_ALV1-MEINS = WA_TAS4-MEINS.
     WA_ALV1-GJAHR = WA_TAS4-GJAHR.
     WA_ALV1-HKONT = WA_TAS4-HKONT.
     WA_ALV1-LIFNR = WA_TAS4-LIFNR.
     WA_ALV1-NAME1 = WA_TAS4-NAME1.
     WA_ALV1-MWSKZ = WA_TAS4-MWSKZ.
     WA_ALV1-DMBTR = WA_TAS4-DMBTR.
     WA_ALV1-HWBAS = WA_TAS4-HWBAS.
     WA_ALV1-HWSTE = WA_TAS4-HWSTE.
     WA_ALV1-IGST = WA_TAS4-IGST.
     WA_ALV1-SGST = WA_TAS4-SGST.
     WA_ALV1-UGST = WA_TAS4-UGST.
     WA_ALV1-CGST = WA_TAS4-CGST.
     WA_ALV1-SIG = WA_TAS4-SIG.
     WA_ALV1-RATE = WA_TAS4-RATE.
     WA_ALV1-CESS = WA_TAS4-CESS.
     WA_ALV1-TDS = WA_TAS4-TDS.
     WA_ALV1-BELNR_CLR = WA_TAS4-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TAS4-AUGDT.
     WA_ALV1-ORT01 = WA_TAS4-ORT01.
     WA_ALV1-VENREG = WA_TAS4-VENREG.
     WA_ALV1-STCD3 = WA_TAS4-STCD3.
     WA_ALV1-SGTXT = WA_TAS4-SGTXT.
     WA_ALV1-SCODE = WA_TAS4-SCODE.
     WA_ALV1-VEN_CL = WA_TAS4-VEN_CL.
     WA_ALV1-PAN = WA_TAS4-PAN.
     WA_ALV1-MBLNR = WA_TAS4-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TAS4-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TAS4-RECP.
     WA_ALV1-RECP_DT = WA_TAS4-RECP_DT.
     WA_ALV1-RSTAT = WA_TAS4-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
     CLEAR WA_ALV1.


*     wa_rrp4-text = 'G. ITC AVAILABLE ON BR TRF RECEIPT'.
     WA_RRP4-BUDAT = WA_TAS4-BUDAT.
     WA_RRP4-TCODE = WA_TAS4-TCODE.
     WA_RRP4-USNAM = WA_TAS4-USNAM.
     WA_RRP4-BUPLA = WA_TAS4-BUPLA.
     WA_RRP4-GSBER = WA_TAS4-GSBER.
     WA_RRP4-BELNR = WA_TAS4-BELNR.
     WA_RRP4-BLDAT = WA_TAS4-BLDAT.
     WA_RRP4-XBLNR = WA_TAS4-XBLNR.
     WA_RRP4-VBELN = WA_TAS4-VBELN.
     WA_RRP4-STEUC = WA_TAS4-STEUC.
     WA_RRP4-MENGE = WA_TAS4-MENGE.
     WA_RRP4-MEINS = WA_TAS4-MEINS.
     WA_RRP4-GJAHR = WA_TAS4-GJAHR.
     WA_RRP4-HKONT = WA_TAS4-HKONT.
     WA_RRP4-LIFNR = WA_TAS4-LIFNR.
     WA_RRP4-NAME1 = WA_TAS4-NAME1.
     WA_RRP4-MWSKZ = WA_TAS4-MWSKZ.
     WA_RRP4-DMBTR = WA_TAS4-DMBTR.
     WA_RRP4-HWBAS = WA_TAS4-HWBAS.
     WA_RRP4-HWSTE = WA_TAS4-HWSTE.
     WA_RRP4-IGST = WA_TAS4-IGST.
     WA_RRP4-SGST = WA_TAS4-SGST.
     WA_RRP4-UGST = WA_TAS4-UGST.
     WA_RRP4-CGST = WA_TAS4-CGST.
     WA_RRP4-SIG = WA_TAS4-SIG.
     WA_RRP4-RATE = WA_TAS4-RATE.
     WA_RRP4-CESS = WA_TAS4-CESS.
     WA_RRP4-TDS = WA_TAS4-TDS.
     WA_RRP4-BELNR_CLR = WA_TAS4-BELNR_CLR.
     WA_RRP4-AUGDT = WA_TAS4-AUGDT.
     WA_RRP4-ORT01 = WA_TAS4-ORT01.
     WA_RRP4-VENREG = WA_TAS4-VENREG.
     WA_RRP4-STCD3 = WA_TAS4-STCD3.
     WA_RRP4-SGTXT = WA_TAS4-SGTXT.
     WA_RRP4-SCODE = WA_TAS4-SCODE.
     WA_RRP4-VEN_CL = WA_TAS4-VEN_CL.
     WA_RRP4-PAN = WA_TAS4-PAN.
     WA_RRP4-MBLNR = WA_TAS4-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_TAS4-MKPF_BUDAT.
     WA_RRP4-RECP = WA_TAS4-RECP.
     WA_RRP4-RECP_DT = WA_TAS4-RECP_DT.
     WA_RRP4-RSTAT = WA_TAS4-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.
   ENDLOOP.

************************  SALES PROMOTION**************

   LOOP AT IT_TASP1 INTO WA_TASP1.
     CLEAR : A1,GJAHR.
     IF WA_TASP1-MWSKZ EQ 'V0' OR WA_TASP1-HWSTE EQ 0.
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.
     ELSE.
       WA_ALV1-TEXT = 'P. SALES PROMOTION'.
     ENDIF.
     WA_ALV1-BUDAT = WA_TASP1-BUDAT.
     WA_ALV1-TCODE = WA_TASP1-TCODE.
     WA_ALV1-USNAM = WA_TASP1-USNAM.
     WA_ALV1-BUPLA = WA_TASP1-BUPLA.
     WA_ALV1-GSBER = WA_TASP1-GSBER.
     WA_ALV1-BELNR = WA_TASP1-BELNR.
     WA_ALV1-BLDAT = WA_TASP1-BLDAT.
     WA_ALV1-XBLNR = WA_TASP1-XBLNR.
     WA_ALV1-VBELN = WA_TASP1-VBELN.
     WA_ALV1-STEUC = WA_TASP1-STEUC.
     WA_ALV1-MENGE = WA_TASP1-MENGE.
     WA_ALV1-MEINS = WA_TASP1-MEINS.
     WA_ALV1-GJAHR = WA_TASP1-GJAHR.
     WA_ALV1-HKONT = WA_TASP1-HKONT.
     WA_ALV1-LIFNR = WA_TASP1-LIFNR.
     WA_ALV1-NAME1 = WA_TASP1-NAME1.
     WA_ALV1-MWSKZ = WA_TASP1-MWSKZ.
     WA_ALV1-DMBTR = WA_TASP1-DMBTR.
     WA_ALV1-HWBAS = WA_TASP1-HWBAS.
     WA_ALV1-HWSTE = WA_TASP1-HWSTE.
     WA_ALV1-IGST = WA_TASP1-IGST.
     WA_ALV1-SGST = WA_TASP1-SGST.
     WA_ALV1-UGST = WA_TASP1-UGST.
     WA_ALV1-CGST = WA_TASP1-CGST.
     WA_ALV1-SIG = WA_TASP1-SIG.
     WA_ALV1-RATE = WA_TASP1-RATE.
     WA_ALV1-CESS = WA_TASP1-CESS.
     WA_ALV1-TDS = WA_TASP1-TDS.
     WA_ALV1-BELNR_CLR = WA_TASP1-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TASP1-AUGDT.
     WA_ALV1-ORT01 = WA_TASP1-ORT01.
     WA_ALV1-VENREG = WA_TASP1-VENREG.
     WA_ALV1-STCD3 = WA_TASP1-STCD3.
     WA_ALV1-SGTXT = WA_TASP1-SGTXT.
     WA_ALV1-SCODE = WA_TASP1-SCODE.
     WA_ALV1-VEN_CL = WA_TASP1-VEN_CL.
     WA_ALV1-PAN = WA_TASP1-PAN.
     WA_ALV1-MBLNR = WA_TASP1-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TASP1-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TASP1-RECP.
     WA_ALV1-RECP_DT = WA_TASP1-RECP_DT.
     WA_ALV1-RSTAT = WA_TASP1-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
     CLEAR WA_ALV1.
************************************


     IF WA_TASP1-MWSKZ EQ 'V0' OR WA_TASP1-HWSTE EQ 0.
       WA_RRP4-TEXT = 'A. EXPS WITHOUT GST'.
     ELSE.
       WA_RRP4-TEXT = 'P. SALES PROMOTION'.
     ENDIF.
     WA_RRP4-BUDAT = WA_TASP1-BUDAT.
     WA_RRP4-TCODE = WA_TASP1-TCODE.
     WA_RRP4-USNAM = WA_TASP1-USNAM.
     WA_RRP4-BUPLA = WA_TASP1-BUPLA.
     WA_RRP4-GSBER = WA_TASP1-GSBER.
     WA_RRP4-BELNR = WA_TASP1-BELNR.
     WA_RRP4-BLDAT = WA_TASP1-BLDAT.
     WA_RRP4-XBLNR = WA_TASP1-XBLNR.
     WA_RRP4-VBELN = WA_TASP1-VBELN.
     WA_RRP4-STEUC = WA_TASP1-STEUC.
     WA_RRP4-MENGE = WA_TASP1-MENGE.
     WA_RRP4-MEINS = WA_TASP1-MEINS.
     WA_RRP4-GJAHR = WA_TASP1-GJAHR.
     WA_RRP4-HKONT = WA_TASP1-HKONT.
     WA_RRP4-LIFNR = WA_TASP1-LIFNR.
     WA_RRP4-NAME1 = WA_TASP1-NAME1.
     WA_RRP4-MWSKZ = WA_TASP1-MWSKZ.
     WA_RRP4-DMBTR = WA_TASP1-DMBTR.
     WA_RRP4-HWBAS = WA_TASP1-HWBAS.
     WA_RRP4-HWSTE = WA_TASP1-HWSTE.
     WA_RRP4-IGST = WA_TASP1-IGST.
     WA_RRP4-SGST = WA_TASP1-SGST.
     WA_RRP4-UGST = WA_TASP1-UGST.
     WA_RRP4-CGST = WA_TASP1-CGST.
     WA_RRP4-SIG = WA_TASP1-SIG.
     WA_RRP4-RATE = WA_TASP1-RATE.
     WA_RRP4-CESS = WA_TASP1-CESS.
     WA_RRP4-TDS = WA_TASP1-TDS.
     WA_RRP4-BELNR_CLR = WA_TASP1-BELNR_CLR.
     WA_RRP4-AUGDT = WA_TASP1-AUGDT.
     WA_RRP4-ORT01 = WA_TASP1-ORT01.
     WA_RRP4-VENREG = WA_TASP1-VENREG.
     WA_RRP4-STCD3 = WA_TASP1-STCD3.
     WA_RRP4-SGTXT = WA_TASP1-SGTXT.
     WA_RRP4-SCODE = WA_TASP1-SCODE.
     WA_RRP4-VEN_CL = WA_TASP1-VEN_CL.
     WA_RRP4-PAN = WA_TASP1-PAN.
     WA_RRP4-MBLNR = WA_TASP1-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_TASP1-MKPF_BUDAT.
     WA_RRP4-RECP = WA_TASP1-RECP.
     WA_RRP4-RECP_DT = WA_TASP1-RECP_DT.
     WA_RRP4-RSTAT = WA_TASP1-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.

*******************************
     GJAHR = WA_TASP1-GJAHR.
   ENDLOOP.


************************  CROSS CHARG**************

   LOOP AT IT_TACC1 INTO WA_TACC1.
     CLEAR : A1,GJAHR.
     IF WA_TACC1-MWSKZ EQ 'V0' OR WA_TACC1-HWSTE EQ 0.
       WA_ALV1-TEXT = 'A. EXPS WITHOUT GST'.
     ELSE.
       WA_ALV1-TEXT = 'Q. CROSS CHARGE'.
     ENDIF.
     WA_ALV1-BUDAT = WA_TACC1-BUDAT.
     WA_ALV1-TCODE = WA_TACC1-TCODE.
     WA_ALV1-USNAM = WA_TACC1-USNAM.
     WA_ALV1-BUPLA = WA_TACC1-BUPLA.
     WA_ALV1-GSBER = WA_TACC1-GSBER.
     WA_ALV1-BELNR = WA_TACC1-BELNR.
     WA_ALV1-BLDAT = WA_TACC1-BLDAT.
     WA_ALV1-XBLNR = WA_TACC1-XBLNR.
     WA_ALV1-VBELN = WA_TACC1-VBELN.
     WA_ALV1-STEUC = WA_TACC1-STEUC.
     WA_ALV1-MENGE = WA_TACC1-MENGE.
     WA_ALV1-MEINS = WA_TACC1-MEINS.
     WA_ALV1-GJAHR = WA_TACC1-GJAHR.
     WA_ALV1-HKONT = WA_TACC1-HKONT.
     WA_ALV1-LIFNR = WA_TACC1-LIFNR.
     WA_ALV1-NAME1 = WA_TACC1-NAME1.
     WA_ALV1-MWSKZ = WA_TACC1-MWSKZ.
     WA_ALV1-DMBTR = WA_TACC1-DMBTR.
     WA_ALV1-HWBAS = WA_TACC1-HWBAS.
     WA_ALV1-HWSTE = WA_TACC1-HWSTE.
     WA_ALV1-IGST = WA_TACC1-IGST.
     WA_ALV1-SGST = WA_TACC1-SGST.
     WA_ALV1-UGST = WA_TACC1-UGST.
     WA_ALV1-CGST = WA_TACC1-CGST.
     WA_ALV1-SIG = WA_TACC1-SIG.
     WA_ALV1-RATE = WA_TACC1-RATE.
     WA_ALV1-CESS = WA_TACC1-CESS.
     WA_ALV1-TDS = WA_TACC1-TDS.
     WA_ALV1-BELNR_CLR = WA_TACC1-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TACC1-AUGDT.
     WA_ALV1-ORT01 = WA_TACC1-ORT01.
     WA_ALV1-VENREG = WA_TACC1-VENREG.
     WA_ALV1-STCD3 = WA_TACC1-STCD3.
     WA_ALV1-SGTXT = WA_TACC1-SGTXT.
     WA_ALV1-SCODE = WA_TACC1-SCODE.
     WA_ALV1-VEN_CL = WA_TACC1-VEN_CL.
     WA_ALV1-PAN = WA_TACC1-PAN.
     WA_ALV1-MBLNR = WA_TACC1-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TACC1-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TACC1-RECP.
     WA_ALV1-RECP_DT = WA_TACC1-RECP_DT.
     WA_ALV1-RSTAT = WA_TACC1-RSTAT.
     COLLECT WA_ALV1 INTO IT_ALV1.
     CLEAR WA_ALV1.

******************************

     IF WA_TACC1-MWSKZ EQ 'V0' OR WA_TACC1-HWSTE EQ 0.
       WA_RRP4-TEXT = 'A. EXPS WITHOUT GST'.
     ELSE.
       WA_RRP4-TEXT = 'Q. CROSS CHARGE'.
     ENDIF.
     WA_RRP4-BUDAT = WA_TACC1-BUDAT.
     WA_RRP4-TCODE = WA_TACC1-TCODE.
     WA_RRP4-USNAM = WA_TACC1-USNAM.
     WA_RRP4-BUPLA = WA_TACC1-BUPLA.
     WA_RRP4-GSBER = WA_TACC1-GSBER.
     WA_RRP4-BELNR = WA_TACC1-BELNR.
     WA_RRP4-BLDAT = WA_TACC1-BLDAT.
     WA_RRP4-XBLNR = WA_TACC1-XBLNR.
     WA_RRP4-VBELN = WA_TACC1-VBELN.
     WA_RRP4-STEUC = WA_TACC1-STEUC.
     WA_RRP4-MENGE = WA_TACC1-MENGE.
     WA_RRP4-MEINS = WA_TACC1-MEINS.
     WA_RRP4-GJAHR = WA_TACC1-GJAHR.
     WA_RRP4-HKONT = WA_TACC1-HKONT.
     WA_RRP4-LIFNR = WA_TACC1-LIFNR.
     WA_RRP4-NAME1 = WA_TACC1-NAME1.
     WA_RRP4-MWSKZ = WA_TACC1-MWSKZ.
     WA_RRP4-DMBTR = WA_TACC1-DMBTR.
     WA_RRP4-HWBAS = WA_TACC1-HWBAS.
     WA_RRP4-HWSTE = WA_TACC1-HWSTE.
     WA_RRP4-IGST = WA_TACC1-IGST.
     WA_RRP4-SGST = WA_TACC1-SGST.
     WA_RRP4-UGST = WA_TACC1-UGST.
     WA_RRP4-CGST = WA_TACC1-CGST.
     WA_RRP4-SIG = WA_TACC1-SIG.
     WA_RRP4-RATE = WA_TACC1-RATE.
     WA_RRP4-CESS = WA_TACC1-CESS.
     WA_RRP4-TDS = WA_TACC1-TDS.
     WA_RRP4-BELNR_CLR = WA_TACC1-BELNR_CLR.
     WA_RRP4-AUGDT = WA_TACC1-AUGDT.
     WA_RRP4-ORT01 = WA_TACC1-ORT01.
     WA_RRP4-VENREG = WA_TACC1-VENREG.
     WA_RRP4-STCD3 = WA_TACC1-STCD3.
     WA_RRP4-SGTXT = WA_TACC1-SGTXT.
     WA_RRP4-SCODE = WA_TACC1-SCODE.
     WA_RRP4-VEN_CL = WA_TACC1-VEN_CL.
     WA_RRP4-PAN = WA_TACC1-PAN.
     WA_RRP4-MBLNR = WA_TACC1-MBLNR.
     WA_RRP4-MKPF_BUDAT = WA_TACC1-MKPF_BUDAT.
     WA_RRP4-RECP = WA_TACC1-RECP.
     WA_RRP4-RECP_DT = WA_TACC1-RECP_DT.
     WA_RRP4-RSTAT = WA_TACC1-RSTAT.
     COLLECT WA_RRP4 INTO IT_RRP4.
     CLEAR WA_RRP4.
*******************************
     GJAHR = WA_TACC1-GJAHR.
   ENDLOOP.

   LOOP AT IT_ALV1 INTO WA_ALV1.
     SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
       AND BELNR EQ WA_ALV1-BELNR
       AND GJAHR EQ WA_ALV1-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_ALV1-BLART = BKPF-BLART.
       MODIFY IT_ALV1 FROM WA_ALV1 TRANSPORTING BLART.
*       CLEAR WA_ALV1.
     ENDIF.
     READ TABLE IT_TAS3 INTO WA_TAS3 WITH KEY MBLNR = WA_ALV1-MBLNR.
     IF SY-SUBRC EQ 0.
       SELECT SINGLE * FROM T001W WHERE WERKS EQ WA_TAS3-WERKS.
       IF SY-SUBRC EQ 0.
         WA_ALV1-KUNNR = T001W-KUNNR.
       ENDIF.
       WA_ALV1-WERKS = WA_TAS3-WERKS.
       MODIFY IT_ALV1 FROM WA_ALV1 TRANSPORTING WERKS KUNNR.
*       CLEAR WA_ALV1.
     ENDIF.
     CLEAR WA_ALV1.
   ENDLOOP.

**************************************************


   IF R12HS EQ 'X'.
     PERFORM DETAILHS.

   ELSEIF RP2 EQ 'X'.
     PERFORM IMPSER.
   ELSEIF RP3 EQ 'X'.
     PERFORM RCM.
   ELSEIF RP4 EQ 'X'.
     PERFORM NEWREG.
   ELSEIF R12N1 EQ 'X'.
     PERFORM DETAILFORM.

   ELSE.

*************GRN*******************************
     IF IT_ALV1 IS NOT INITIAL.
       SELECT * FROM BKPF INTO TABLE IT_BKPF2 FOR ALL
         ENTRIES IN IT_ALV1 WHERE BUKRS EQ '1000'
         AND BELNR EQ IT_ALV1-BELNR
         AND GJAHR EQ IT_ALV1-GJAHR .
     ENDIF.
     IF IT_BKPF2 IS NOT INITIAL.
       LOOP AT IT_BKPF2 INTO WA_BKPF2.
         WA_GRN1-BELNR = WA_BKPF2-BELNR.
         WA_GRN1-GJAHR = WA_BKPF2-GJAHR.
         WA_GRN1-BELNR1 = WA_BKPF2-AWKEY+0(10).
         WA_GRN1-GJAHR1 = WA_BKPF2-AWKEY+10(4).
         COLLECT WA_GRN1 INTO IT_GRN1.
         CLEAR WA_GRN1.
       ENDLOOP.
     ENDIF.
     IF IT_GRN1 IS NOT INITIAL.
       SELECT * FROM RSEG INTO TABLE IT_RSEG2 FOR ALL
         ENTRIES IN IT_GRN1 WHERE BELNR EQ IT_GRN1-BELNR1
         AND GJAHR EQ IT_GRN1-GJAHR1.
     ENDIF.
     SORT IT_RSEG2 DESCENDING BY LFBNR.
     LOOP AT IT_ALV1 INTO WA_ALV1.
*    ****** SOC by CK
       IF R12 = 'X'.


         IF WA_ALV1-TCODE = 'MIRO' OR WA_ALV1-TCODE = 'MR8M'.

           IF     WA_ALV1-EBELN IS INITIAL   . .
             SELECT SINGLE EBELN FROM BSEG INTO WA_ALV1-EBELN
               WHERE BELNR = WA_ALV1-BELNR
               AND GJAHR = WA_ALV1-GJAHR
               AND BUZID = 'W'...
           ENDIF.

           IF WA_ALV1-EBELN IS NOT INITIAL.
             SELECT SINGLE BSART FROM EKKO INTO WA_ALV1-BSART
               WHERE EBELN = WA_ALV1-EBELN .
             IF SY-SUBRC IS  INITIAL.
               CASE WA_ALV1-BSART.
                 WHEN 'ZCAP'.  WA_ALV1-TYPE      = 'Capital Goods'   .
                 WHEN 'ZSRV'.  WA_ALV1-TYPE      = 'SERVICE'   .
                 WHEN OTHERS.
                   IF WA_ALV1-STEUC+(1) = '9'  .
                     WA_ALV1-TYPE      = 'SERVICE'   .
                   ELSE.
                     WA_ALV1-TYPE      = 'Goods'.
                   ENDIF.
               ENDCASE.
               MODIFY IT_ALV1 FROM WA_ALV1 TRANSPORTING EBELN BSART TYPE.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
****** SOE by CK
*       write : / wa_alv1-belnr,wa_alv1-gjahr,wa_alv1-mblnr.
       READ TABLE IT_GRN1 INTO WA_GRN1 WITH KEY BELNR = WA_ALV1-BELNR
                                                GJAHR = WA_ALV1-GJAHR.
       IF SY-SUBRC EQ 0.
         READ TABLE IT_RSEG2 INTO WA_RSEG2 WITH KEY BELNR = WA_GRN1-BELNR1
                                                   GJAHR = WA_GRN1-GJAHR1.
         IF SY-SUBRC EQ 0.
*           write : wa_rseg2-lfbnr,wa_rseg2-lfgja.
           SELECT SINGLE * FROM MKPF WHERE
             MBLNR EQ WA_RSEG2-LFBNR
             AND MJAHR EQ WA_RSEG2-LFGJA .
           IF SY-SUBRC EQ 0.
*             write : mkpf-budat.
             WA_ALV1-GRN = WA_RSEG2-LFBNR.
             WA_ALV1-GRNDT = MKPF-BUDAT.
             MODIFY IT_ALV1 FROM WA_ALV1 TRANSPORTING GRN GRNDT.
             CLEAR WA_ALV1.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDLOOP.

************************************************************

     SORT IT_ALV1 BY TEXT BELNR.

     WA_FIELDCAT-FIELDNAME = 'TEXT'.
     WA_FIELDCAT-SELTEXT_L = 'TEXT'.
     WA_FIELDCAT-DO_SUM = 'X'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BUDAT'.
     WA_FIELDCAT-SELTEXT_L = 'POSTING DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'TCODE'.
     WA_FIELDCAT-SELTEXT_L = 'TCODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'USNAM'.
     WA_FIELDCAT-SELTEXT_L = 'USER'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BUPLA'.
     WA_FIELDCAT-SELTEXT_L = 'BUS.PLACE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'GSBER'.
     WA_FIELDCAT-SELTEXT_L = 'BUS.ARE'.
     APPEND WA_FIELDCAT TO FIELDCAT.


     WA_FIELDCAT-FIELDNAME = 'BELNR'.
     WA_FIELDCAT-SELTEXT_L = 'DOC NO.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'RSTAT'.
     WA_FIELDCAT-SELTEXT_L = 'REVERSE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BLDAT'.
     WA_FIELDCAT-SELTEXT_L = 'DOCUMENT DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BLART'.
     WA_FIELDCAT-SELTEXT_L = 'DOC TYPE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'XBLNR'.
     WA_FIELDCAT-SELTEXT_L = 'BILL NO.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'VBELN'.
     WA_FIELDCAT-SELTEXT_L = 'INVOICE NO.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'STEUC'.
     WA_FIELDCAT-SELTEXT_L = 'HSN/SAC CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

********** SOC Added by CK

     IF R12 = 'X'.
       WA_FIELDCAT-FIELDNAME = 'EBELN'.
       WA_FIELDCAT-SELTEXT_L = 'Purchase Doc'.
       APPEND WA_FIELDCAT TO FIELDCAT.

       WA_FIELDCAT-FIELDNAME = 'BSART'.
       WA_FIELDCAT-SELTEXT_L = 'PO Type'.
       APPEND WA_FIELDCAT TO FIELDCAT.

       WA_FIELDCAT-FIELDNAME = 'TYPE'.
       WA_FIELDCAT-SELTEXT_L = 'TYPE(G/S/C)'.
       APPEND WA_FIELDCAT TO FIELDCAT.
     ENDIF.
*  ********** SOE Added by CK

     WA_FIELDCAT-FIELDNAME = 'MENGE'.
     WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MEINS'.
     WA_FIELDCAT-SELTEXT_L = 'UOM'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'GJAHR'.
     WA_FIELDCAT-SELTEXT_L = 'YEAR'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'HKONT'.
     WA_FIELDCAT-SELTEXT_L = 'GL CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'LIFNR'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'NAME1'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR NAME'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MWSKZ'.
     WA_FIELDCAT-SELTEXT_L = 'TAX CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'DMBTR'.
     WA_FIELDCAT-SELTEXT_L = 'TOT AMOUNT'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'HWBAS'.
     WA_FIELDCAT-SELTEXT_L = 'TAXABLE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'HWSTE'.
     WA_FIELDCAT-SELTEXT_L = 'TAX AMT'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'IGST'.
     WA_FIELDCAT-SELTEXT_L = 'IGST'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'SGST'.
     WA_FIELDCAT-SELTEXT_L = 'SGST'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'UGST'.
     WA_FIELDCAT-SELTEXT_L = 'UGST'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'CGST'.
     WA_FIELDCAT-SELTEXT_L = 'CGST'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'CESS'.
     WA_FIELDCAT-SELTEXT_L = 'CESS'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'RATE'.
     WA_FIELDCAT-SELTEXT_L = 'TAX RATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'TDS'.
     WA_FIELDCAT-SELTEXT_L = 'TDS AMOUNT'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BELNR_CLR'.
     WA_FIELDCAT-SELTEXT_L = 'CLEARING DOC'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'AUGDT'.
     WA_FIELDCAT-SELTEXT_L = 'CLEARING DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'ORT01'.
     WA_FIELDCAT-SELTEXT_L = 'PLACE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'VENREG'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR REGION'.
     APPEND WA_FIELDCAT TO FIELDCAT.


     WA_FIELDCAT-FIELDNAME = 'STCD3'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR GSTN'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'SGTXT'.
     WA_FIELDCAT-SELTEXT_L = 'TEXT'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'SCODE'.
     WA_FIELDCAT-SELTEXT_L = 'STATE CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'VEN_CL'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR CLASS'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'PAN'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR PAN NO.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MBLNR'.
     WA_FIELDCAT-SELTEXT_L = 'INVOICE GRN'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MKPF_BUDAT'.
     WA_FIELDCAT-SELTEXT_L = 'INV GRN DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'RECP'.
     WA_FIELDCAT-SELTEXT_L = 'J_1IG_INV'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'RECP_DT'.
     WA_FIELDCAT-SELTEXT_L = 'J_1IG_INV DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'WERKS'.
     WA_FIELDCAT-SELTEXT_L = 'RECP PLANT'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'KUNNR'.
     WA_FIELDCAT-SELTEXT_L = 'RECP LOC'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'GRN'.
     WA_FIELDCAT-SELTEXT_L = 'GRN DOC'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'GRNDT'.
     WA_FIELDCAT-SELTEXT_L = 'GRN POSTING DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     PERFORM SORT CHANGING LI_SORT.

     LAYOUT-ZEBRA = 'X'.
     LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
     LAYOUT-WINDOW_TITLEBAR  = 'PURCHASE REGISTER FOR FB60 & MIRO'.


     CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
       EXPORTING
         I_CALLBACK_PROGRAM      = G_REPID
         I_CALLBACK_USER_COMMAND = 'USER_COMM'
         I_CALLBACK_TOP_OF_PAGE  = 'TOP'
         IS_LAYOUT               = LAYOUT
         IT_FIELDCAT             = FIELDCAT
         IT_SORT                 = LI_SORT
         I_SAVE                  = 'A'
       TABLES
         T_OUTTAB                = IT_ALV1
       EXCEPTIONS
         PROGRAM_ERROR           = 1
         OTHERS                  = 2.
     IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
     ENDIF.

   ENDIF.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_SORT  text
*----------------------------------------------------------------------*
 FORM SORT CHANGING PI_SORT TYPE SLIS_T_SORTINFO_ALV.
   DATA:  LW_SORT TYPE SLIS_SORTINFO_ALV.



   LW_SORT-FIELDNAME = 'TEXT'. "sort depending on which field
   LW_SORT-UP = 'X'. "ascending sequence
   LW_SORT-SUBTOT = 'X'.
   APPEND LW_SORT TO PI_SORT.
   CLEAR LW_SORT.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NOTAX1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM NOTAX1.

   IF IT_TAB1 IS NOT INITIAL.
     LOOP AT IT_TAB1 INTO WA_TAB1.
       READ TABLE IT_TAP1 INTO WA_TAP1 WITH KEY
       BELNR = WA_TAB1-BELNR
       GJAHR = WA_TAB1-GJAHR.
       IF SY-SUBRC EQ 4.
*       WRITE : /'N', WA_TAB1-BELNR,WA_TAB1-GJAHR.
         WA_NTAX1-BELNR = WA_TAB1-BELNR.
         WA_NTAX1-GJAHR = WA_TAB1-GJAHR.
         COLLECT WA_NTAX1 INTO IT_NTAX1.
         CLEAR WA_NTAX1.
       ENDIF.
     ENDLOOP.
   ENDIF.

   CLEAR : IT_BSEG1,WA_BSEG1.
   IF IT_NTAX1 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG1 FOR ALL
        ENTRIES IN IT_NTAX1 WHERE
        BUKRS EQ '1000' AND
        BELNR EQ IT_NTAX1-BELNR AND
        GJAHR = IT_NTAX1-GJAHR .
   ENDIF.

   IF IT_BSEG1 IS NOT INITIAL.
     LOOP AT IT_BSEG1 INTO WA_BSEG1 .

       CLEAR : TAX1,TAX2,TAX3,TAX4,TAX5,
               TAX6,TAX7,TAX8,TAX9,TAX10,TAX.
       WA_NOTAX1-BELNR = WA_BSEG1-BELNR.
       WA_NOTAX1-GJAHR = WA_BSEG1-GJAHR.
       WA_NOTAX1-MWSKZ = WA_BSEG1-MWSKZ.
       WA_NOTAX1-TXGRP = WA_BSEG1-TXGRP.
       WA_NOTAX1-BUZEI = WA_BSEG1-BUZEI.
       IF WA_BSEG1-SHKZG EQ 'H'.
         WA_BSEG1-DMBTR = WA_BSEG1-DMBTR * ( - 1 ).
       ENDIF.

       IF WA_BSEG1-HKONT EQ '0000028010' OR
          WA_BSEG1-HKONT EQ '0000015880' OR
          WA_BSEG1-HKONT EQ '0000028060'.
          WA_NOTAX1-SGST = WA_BSEG1-DMBTR.
          TAX1 = WA_BSEG1-DMBTR.
       ELSEIF WA_BSEG1-HKONT EQ '0000028020' OR
              WA_BSEG1-HKONT EQ '0000015890' OR
              WA_BSEG1-HKONT EQ '0000028070'.
         WA_NOTAX1-CGST = WA_BSEG1-DMBTR.
         TAX2 = WA_BSEG1-DMBTR.
         WA_NOTAX1-HWBAS = WA_BSEG1-DMBTR.
       ELSEIF WA_BSEG1-HKONT EQ '0000028030' OR
              WA_BSEG1-HKONT EQ '0000015900' OR
              WA_BSEG1-HKONT EQ '0000028080' OR
              WA_BSEG1-HKONT EQ '0000028100'
         OR WA_BSEG1-HKONT EQ '0000028110'.
         WA_NOTAX1-IGST = WA_BSEG1-DMBTR.
         TAX3 = WA_BSEG1-DMBTR.
         WA_NOTAX1-HWBAS = WA_BSEG1-DMBTR.
       ELSEIF WA_BSEG1-HKONT EQ '0000028040' OR
              WA_BSEG1-HKONT EQ '0000015910' OR
              WA_BSEG1-HKONT EQ '0000028090'.
         WA_NOTAX1-UGST = WA_BSEG1-DMBTR.
         TAX4 = WA_BSEG1-DMBTR.
       ELSEIF WA_BSEG1-HKONT EQ '0000028050' OR
              WA_BSEG1-HKONT EQ '0000015920'.
         WA_NOTAX1-CESS = WA_BSEG1-DMBTR.
         TAX5 = WA_BSEG1-DMBTR.
       ENDIF.
       IF WA_BSEG1-DMBTR LT 0.
         WA_NOTAX1-SIG = 'A'.
       ELSE.
         WA_NOTAX1-SIG = 'B'.
       ENDIF.
       TAX = TAX1 + TAX2 + TAX3 + TAX4 + TAX5 .
       WA_NOTAX1-TAX = TAX.
       WA_NOTAX1-HWSTE = TAX.
       COLLECT WA_NOTAX1 INTO IT_NOTAX1.
       CLEAR WA_NOTAX1.
     ENDLOOP.
   ENDIF.
   DELETE IT_NOTAX1 WHERE TAX EQ 0.
   IF IT_NOTAX1 IS NOT INITIAL.
     LOOP AT IT_NOTAX1 INTO WA_NOTAX1.
       READ TABLE IT_BSEG1 INTO WA_BSEG1 WITH KEY
       BELNR = WA_NOTAX1-BELNR
       GJAHR = WA_NOTAX1-GJAHR
       HKONT = '0000015880'.
       IF SY-SUBRC EQ 0.
         WA_NOTAX1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSEG1 INTO WA_BSEG1 WITH KEY
       BELNR = WA_NOTAX1-BELNR
       GJAHR = WA_NOTAX1-GJAHR
       HKONT = '0000015890'.
       IF SY-SUBRC EQ 0.
         WA_NOTAX1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSEG1 INTO WA_BSEG1 WITH KEY
       BELNR = WA_NOTAX1-BELNR
       GJAHR = WA_NOTAX1-GJAHR
       HKONT = '0000015900'.
       IF SY-SUBRC EQ 0.
         WA_NOTAX1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSEG1 INTO WA_BSEG1 WITH KEY
       BELNR = WA_NOTAX1-BELNR
       GJAHR = WA_NOTAX1-GJAHR
       HKONT = '0000015910'.
       IF SY-SUBRC EQ 0.
         WA_NOTAX1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSEG1 INTO WA_BSEG1 WITH KEY
       BELNR = WA_NOTAX1-BELNR
       GJAHR = WA_NOTAX1-GJAHR
       HKONT = '0000015920'.
       IF SY-SUBRC EQ 0.
         WA_NOTAX1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSEG1 INTO WA_BSEG1 WITH KEY
       BELNR = WA_NOTAX1-BELNR
       GJAHR = WA_NOTAX1-GJAHR
       BUZEI = '001'.
       IF SY-SUBRC EQ 0.
         IF WA_NOTAX1-HWSTE LT 0.
           WA_BSEG1-DMBTR = WA_BSEG1-DMBTR * ( - 1 ).
         ENDIF.
         WA_NOTAX1-HWBAS = WA_BSEG1-DMBTR.
       ELSE.
         READ TABLE IT_BSEG1 INTO WA_BSEG1 WITH KEY
         BELNR = WA_NOTAX1-BELNR
         GJAHR = WA_NOTAX1-GJAHR
         KOART = 'K'.
         IF SY-SUBRC EQ 0.
           IF WA_NOTAX1-HWSTE LT 0.
             WA_BSEG1-DMBTR = WA_BSEG1-DMBTR * ( - 1 ).
           ENDIF.
           WA_NOTAX1-HWBAS = WA_BSEG1-DMBTR.
         ENDIF.
       ENDIF.
       MODIFY IT_NOTAX1 FROM WA_NOTAX1 TRANSPORTING STATUS HWBAS.
       CLEAR WA_NOTAX1.
     ENDLOOP.
   ENDIF.

   IF IT_NOTAX1 IS NOT INITIAL.
     LOOP AT IT_NOTAX1 INTO WA_NOTAX1.
       WA_TAP1-BELNR = WA_NOTAX1-BELNR.
       WA_TAP1-GJAHR = WA_NOTAX1-GJAHR.
       WA_TAP1-HWBAS = WA_NOTAX1-HWBAS.
       WA_TAP1-HWSTE = WA_NOTAX1-HWSTE.
       WA_TAP1-TXGRP = WA_NOTAX1-TXGRP.
       WA_TAP1-HKONT = SPACE.
       WA_TAP1-BUZEI = WA_NOTAX1-BUZEI.
       WA_TAP1-MWSKZ = WA_NOTAX1-MWSKZ.
       WA_TAP1-IGST = WA_NOTAX1-IGST.
       WA_TAP1-CGST = WA_NOTAX1-CGST.
       WA_TAP1-SGST = WA_NOTAX1-SGST.
       WA_TAP1-UGST = WA_NOTAX1-UGST.
       WA_TAP1-CESS = WA_NOTAX1-CESS.
       WA_TAP1-STATUS = WA_NOTAX1-STATUS.
       WA_TAP1-SIG = WA_NOTAX1-SIG.
       WA_TAP1-DMBTR = WA_TAP1-HWBAS + WA_TAP1-HWSTE.
       COLLECT WA_TAP1 INTO IT_TAP1.
       CLEAR WA_TAP1.
     ENDLOOP.
   ENDIF.
   LOOP AT IT_TAB1 INTO WA_TAB1.
     READ TABLE IT_TAP1 INTO WA_TAP1 WITH KEY
     BELNR = WA_TAB1-BELNR
     GJAHR = WA_TAB1-GJAHR.
     IF SY-SUBRC EQ 4.

*       WRITE :/ 'S3',WA_TAB1-BELNR.
       WA_NTAX3-BELNR = WA_TAB1-BELNR.
       WA_NTAX3-GJAHR = WA_TAB1-GJAHR.
       COLLECT WA_NTAX3 INTO IT_NTAX3.
       CLEAR WA_NTAX3.
     ENDIF.
   ENDLOOP.

   IF IT_NTAX3 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG2 FOR ALL
       ENTRIES IN IT_NTAX3 WHERE BUKRS EQ '1000' AND
       BELNR EQ IT_NTAX3-BELNR AND
       GJAHR = IT_NTAX3-GJAHR AND
       KOART EQ 'K'.
   ENDIF.
   IF IT_NTAX3 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG3 FOR ALL
       ENTRIES IN IT_NTAX3 WHERE BUKRS EQ '1000'
       AND BELNR EQ IT_NTAX3-BELNR
       AND GJAHR = IT_NTAX3-GJAHR
       AND SHKZG EQ 'H'.
   ENDIF.

   LOOP AT IT_BSEG2 INTO WA_BSEG2.
     WA_VAL3-BELNR = WA_BSEG2-BELNR.
     WA_VAL3-GJAHR = WA_BSEG2-GJAHR.
     IF WA_BSEG2-SHKZG EQ 'S'.
       WA_BSEG2-DMBTR = WA_BSEG2-DMBTR * ( - 1 ).
     ENDIF.
     WA_VAL3-DMBTR = WA_BSEG2-DMBTR.
     COLLECT WA_VAL3 INTO IT_VAL3.
     CLEAR WA_VAL3.
   ENDLOOP.

   LOOP AT IT_BSEG3 INTO WA_BSEG3.
     WA_VAL4-BELNR = WA_BSEG3-BELNR.
     WA_VAL4-GJAHR = WA_BSEG3-GJAHR.
     WA_VAL4-DMBTR = WA_BSEG3-DMBTR.
     COLLECT WA_VAL4 INTO IT_VAL4.
     CLEAR WA_VAL4.
   ENDLOOP.

   LOOP AT IT_NTAX3 INTO WA_NTAX3.
     READ TABLE IT_TAP1 INTO WA_TAP1 WITH KEY
     BELNR = WA_NTAX3-BELNR
     GJAHR = WA_NTAX3-GJAHR.
     IF SY-SUBRC EQ 4.
*       WRITE :/ 'S3',WA_NTAX3-BELNR.
       WA_TAP1-BELNR = WA_NTAX3-BELNR.
       WA_TAP1-GJAHR = WA_NTAX3-GJAHR.
       READ TABLE IT_VAL3 INTO WA_VAL3 WITH KEY
       BELNR = WA_NTAX3-BELNR
       GJAHR = WA_NTAX3-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAP1-DMBTR = WA_VAL3-DMBTR.
         WA_TAP1-HWBAS = WA_VAL3-DMBTR.
       ELSE.
         READ TABLE IT_VAL4 INTO WA_VAL4 WITH KEY
         BELNR = WA_NTAX3-BELNR
         GJAHR = WA_NTAX3-GJAHR.
         IF SY-SUBRC EQ 0.
           WA_TAP1-DMBTR = WA_VAL4-DMBTR.
           WA_TAP1-HWBAS = WA_VAL4-DMBTR.
           SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_NTAX3-BELNR
             AND GJAHR = WA_NTAX3-GJAHR
             AND XREVERSAL EQ '2'.
           IF SY-SUBRC EQ 0.
             WA_TAP1-DMBTR = WA_TAP1-DMBTR * ( - 1 ).
             WA_TAP1-HWBAS = WA_TAP1-HWBAS * ( - 1 ).
           ENDIF.
         ENDIF.
       ENDIF.

       IF WA_TAP1-HWSTE LT 0.
         WA_TAP1-SIG = 'A'.
       ELSE.
         WA_TAP1-SIG = 'B'.
       ENDIF.
       WA_TAP1-HWSTE = 0.
       WA_TAP1-MWSKZ = ' '.
       WA_TAP1-BUZEI = 0.
       WA_TAP1-HKONT = SPACE.
       WA_TAP1-IGST = 0.
       WA_TAP1-CGST = 0.
       WA_TAP1-SGST = 0.
       WA_TAP1-CESS = 0.
       WA_TAP1-UGST = 0.
       WA_TAP1-STATUS = '   '.
       COLLECT WA_TAP1 INTO IT_TAP1.
       CLEAR WA_TAP1.
     ENDIF.
   ENDLOOP.

   LOOP AT IT_TAP1 INTO WA_TAP1 .  "04.07.2023
     READ TABLE IT_INOTAX1 INTO WA_INOTAX1 WITH KEY
      BELNR = WA_TAP1-BELNR
      GJAHR = WA_TAP1-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAP1-MWSKZ = WA_INOTAX1-MWSKZ.
       MODIFY IT_TAP1 FROM WA_TAP1 TRANSPORTING MWSKZ.
       CLEAR WA_TAP1.
     ENDIF.
   ENDLOOP.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NOTAX2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INOTAX1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM INOTAX1 .

   IF IT_TAB1 IS NOT INITIAL.
     LOOP AT IT_TAB1 INTO WA_TAB1.
       READ TABLE IT_TAP1 INTO WA_TAP1 WITH KEY
       BELNR = WA_TAB1-BELNR
       GJAHR = WA_TAB1-GJAHR.
       IF SY-SUBRC EQ 4.
*       WRITE : /'N', WA_TAB1-BELNR,WA_TAB1-GJAHR.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAB1-BELNR
           AND GJAHR = WA_TAB1-GJAHR
           AND HKONT IN ( '0000028150',
                          '0000028160',
                          '0000028170' ).
         IF SY-SUBRC EQ 0.
           WA_INTAX1-BELNR = WA_TAB1-BELNR.
           WA_INTAX1-GJAHR = WA_TAB1-GJAHR.
           COLLECT WA_INTAX1 INTO IT_INTAX1.
           CLEAR WA_INTAX1.
         ENDIF.
       ENDIF.
     ENDLOOP.
   ENDIF.
   SORT IT_INTAX1 BY BELNR GJAHR.
   DELETE ADJACENT DUPLICATES FROM IT_INTAX1 COMPARING BELNR GJAHR.
*   LOOP AT IT_INTAX1 INTO WA_INTAX1.
*     WRITE :  / '111',WA_INTAX1-BELNR,WA_INTAX1-GJAHR.
*   ENDLOOP.

   CLEAR : IT_BSEG11,WA_BSEG11.
   IF IT_INTAX1 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG11 FOR ALL
       ENTRIES IN IT_INTAX1 WHERE BUKRS EQ '1000'
       AND BELNR EQ IT_INTAX1-BELNR
       AND GJAHR = IT_INTAX1-GJAHR.
   ENDIF.



   IF IT_INTAX1 IS NOT INITIAL.
     LOOP AT IT_INTAX1 INTO WA_INTAX1.
       LOOP AT IT_BSEG11 INTO WA_BSEG11 WHERE
          BELNR = WA_INTAX1-BELNR AND
          GJAHR = WA_INTAX1-GJAHR.
         IF ( WA_BSEG11-HKONT EQ '0000028150' OR
              WA_BSEG11-HKONT EQ '0000028160' OR
              WA_BSEG11-HKONT EQ '0000028170' )
           OR ( WA_BSEG11-HKONT GE '0000040000'
            AND WA_BSEG11-HKONT LE '0000049990').
           IF WA_BSEG11-SHKZG EQ 'H'.
             WA_BSEG11-DMBTR = WA_BSEG11-DMBTR * ( - 1 ).
             WA_INOTAX1-SIG = 'B'.
           ELSEIF WA_BSEG11-SHKZG EQ 'S'.

             WA_INOTAX1-SIG = 'A'.
           ENDIF.
           WA_INOTAX1-BELNR = WA_BSEG11-BELNR.
           WA_INOTAX1-GJAHR = WA_BSEG11-GJAHR.
           WA_INOTAX1-MWSKZ = WA_BSEG11-MWSKZ.
           WA_INOTAX1-TXGRP = WA_BSEG11-TXGRP.
           WA_INOTAX1-HKONT = WA_BSEG11-HKONT.
           WA_INOTAX1-DMBTR = WA_BSEG11-DMBTR.
           WA_INOTAX1-HWBAS = 0.
           WA_INOTAX1-STATUS = 'ING'.
           IF WA_BSEG11-HKONT EQ '0000028150'.
             WA_INOTAX1-SGST = WA_BSEG11-DMBTR.
             WA_INOTAX1-HWSTE = WA_BSEG11-DMBTR.
           ELSEIF WA_BSEG11-HKONT EQ '0000028160'.
             WA_INOTAX1-CGST = WA_BSEG11-DMBTR.
             WA_INOTAX1-HWSTE = WA_BSEG11-DMBTR.
           ELSEIF WA_BSEG11-HKONT EQ '0000028170'.
             WA_INOTAX1-IGST = WA_BSEG11-DMBTR.
             WA_INOTAX1-HWSTE = WA_BSEG11-DMBTR.
           ENDIF.
           WA_INOTAX1-CESS = 0.
           COLLECT WA_INOTAX1 INTO IT_INOTAX1.
           CLEAR WA_INOTAX1.
         ENDIF.
       ENDLOOP.
     ENDLOOP.
   ENDIF.

   IF IT_INOTAX1 IS NOT INITIAL.
     LOOP AT IT_INOTAX1 INTO WA_INOTAX1.
       WA_TAPX1-BELNR = WA_INOTAX1-BELNR.
       WA_TAPX1-GJAHR = WA_INOTAX1-GJAHR.
       WA_TAPX1-HWBAS = 0.
       WA_TAPX1-HWSTE = WA_INOTAX1-HWSTE.
       WA_TAPX1-TXGRP = WA_INOTAX1-TXGRP.
       WA_TAPX1-BUZEI = WA_INOTAX1-BUZEI.
       WA_TAPX1-MWSKZ = WA_INOTAX1-MWSKZ.
       WA_TAPX1-HKONT = WA_INOTAX1-HKONT.
       WA_TAPX1-IGST = WA_INOTAX1-IGST.
       WA_TAPX1-CGST = WA_INOTAX1-CGST.
       WA_TAPX1-SGST = WA_INOTAX1-SGST.
       WA_TAPX1-UGST = 0.
       WA_TAPX1-CESS = 0.
       WA_TAPX1-STATUS = WA_INOTAX1-STATUS.
       WA_TAPX1-SIG = WA_INOTAX1-SIG.
       WA_TAPX1-DMBTR = WA_INOTAX1-DMBTR.
       COLLECT WA_TAPX1 INTO IT_TAPX1.
       CLEAR WA_TAPX1.
     ENDLOOP.
   ENDIF.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INOTAX2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM INOTAX2 .

   IF IT_TAB1 IS NOT INITIAL.
     LOOP AT IT_TAB1 INTO WA_TAB1.
       READ TABLE IT_TAP1 INTO WA_TAP1 WITH KEY
       BELNR = WA_TAB1-BELNR
       GJAHR = WA_TAB1-GJAHR.
       IF SY-SUBRC EQ 4.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_TAB1-BELNR
           AND GJAHR = WA_TAB1-GJAHR
           AND HKONT GE '0000015880'
           AND HKONT LE '0000015920'.
         IF SY-SUBRC EQ 0.
           WA_INTAX2-BELNR = WA_TAB1-BELNR.
           WA_INTAX2-GJAHR = WA_TAB1-GJAHR.
           COLLECT WA_INTAX2 INTO IT_INTAX2.
           CLEAR WA_INTAX2.
         ENDIF.
       ENDIF.
     ENDLOOP.
   ENDIF.
   SORT IT_INTAX2 BY BELNR GJAHR.
   DELETE ADJACENT DUPLICATES FROM IT_INTAX2 COMPARING BELNR GJAHR.
   CLEAR : IT_BSEG12,WA_BSEG12.
   IF IT_INTAX2 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG12 FOR ALL
       ENTRIES IN IT_INTAX2 WHERE
       BUKRS EQ '1000' AND
       BELNR EQ IT_INTAX2-BELNR AND
       GJAHR = IT_INTAX2-GJAHR.
   ENDIF.

   IF IT_INTAX2 IS NOT INITIAL.
     LOOP AT IT_INTAX2 INTO WA_INTAX2.

       LOOP AT IT_BSEG12 INTO WA_BSEG12 WHERE BELNR = WA_INTAX2-BELNR
         AND GJAHR = WA_INTAX2-GJAHR
         AND HKONT GE '0000015880'
         AND HKONT LE '0000015920'.
         WA_BSEG12-DMBTR = WA_BSEG12-DMBTR * ( - 1 ).
         WA_INOTAX2-BELNR = WA_BSEG12-BELNR.
         WA_INOTAX2-GJAHR = WA_BSEG12-GJAHR.
         WA_INOTAX2-MWSKZ = WA_BSEG12-MWSKZ.
         WA_INOTAX2-TXGRP = WA_BSEG12-TXGRP.
         WA_INOTAX2-HKONT = WA_BSEG12-HKONT.
         WA_INOTAX2-DMBTR = WA_BSEG12-DMBTR.
         WA_INOTAX2-HWBAS = 0.
         WA_INOTAX2-STATUS = 'JRC'.
         IF WA_BSEG12-HKONT EQ '0000015880'.
           WA_INOTAX2-SGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000015890'.
           WA_INOTAX2-CGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000015900'.
           WA_INOTAX2-IGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000015910'.
           WA_INOTAX2-UGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000015920'.
           WA_INOTAX2-CESS = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ENDIF.
         COLLECT WA_INOTAX2 INTO IT_INOTAX2.
         CLEAR WA_INOTAX2.
       ENDLOOP.
       LOOP AT IT_BSEG12 INTO WA_BSEG12 WHERE
          BELNR = WA_INTAX2-BELNR AND
          GJAHR = WA_INTAX2-GJAHR AND
          SHKZG EQ 'H' AND
          HKONT GE '0000028150' AND
          HKONT LE '0000028170'.
         WA_INOTAX2-BELNR = WA_BSEG12-BELNR.
         WA_INOTAX2-GJAHR = WA_BSEG12-GJAHR.
         WA_INOTAX2-MWSKZ = WA_BSEG12-MWSKZ.
         WA_INOTAX2-TXGRP = WA_BSEG12-TXGRP.
         WA_INOTAX2-HKONT = WA_BSEG12-HKONT.
         WA_INOTAX2-DMBTR = WA_BSEG12-DMBTR.
         WA_INOTAX2-HWBAS = 0.
         WA_INOTAX2-STATUS = 'JRC'.
         IF WA_BSEG12-HKONT EQ '0000028150'.
           WA_INOTAX2-SGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000028160'.
           WA_INOTAX2-CGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000028170'.
           WA_INOTAX2-IGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ENDIF.
         WA_INOTAX2-UGST = 0.
         WA_INOTAX2-CESS = 0.
         COLLECT WA_INOTAX2 INTO IT_INOTAX2.
         CLEAR WA_INOTAX2.
       ENDLOOP.

       LOOP AT IT_BSEG12 INTO WA_BSEG12 WHERE
         BELNR = WA_INTAX2-BELNR AND
         GJAHR = WA_INTAX2-GJAHR AND
         SHKZG EQ 'S' AND
         HKONT GE '0000040000' AND
         HKONT LE '0000049990'.
         WA_INOTAX2-BELNR = WA_BSEG12-BELNR.
         WA_INOTAX2-GJAHR = WA_BSEG12-GJAHR.
         WA_INOTAX2-MWSKZ = WA_BSEG12-MWSKZ.
         WA_INOTAX2-TXGRP = WA_BSEG12-TXGRP.
         WA_INOTAX2-HKONT = WA_BSEG12-HKONT.
         WA_INOTAX2-DMBTR = WA_BSEG12-DMBTR.
         WA_INOTAX2-HWBAS = 0.
         WA_INOTAX2-STATUS = 'JRC'.

         WA_INOTAX2-HWSTE = 0.
         WA_INOTAX2-SGST = 0.
         WA_INOTAX2-CGST = 0.
         WA_INOTAX2-IGST = 0.
         WA_INOTAX2-UGST = 0.
         WA_INOTAX2-CESS = 0.
         COLLECT WA_INOTAX2 INTO IT_INOTAX2.
         CLEAR WA_INOTAX2.
       ENDLOOP.

       LOOP AT IT_BSEG12 INTO WA_BSEG12 WHERE
         BELNR = WA_INTAX2-BELNR AND
         GJAHR = WA_INTAX2-GJAHR AND
         HKONT GE '0000028010' AND
         HKONT LE '0000028100'.
         WA_INOTAX2-BELNR = WA_BSEG12-BELNR.
         WA_INOTAX2-GJAHR = WA_BSEG12-GJAHR.
         WA_INOTAX2-MWSKZ = WA_BSEG12-MWSKZ.
         WA_INOTAX2-TXGRP = WA_BSEG12-TXGRP.
         WA_INOTAX2-HKONT = WA_BSEG12-HKONT.
         WA_INOTAX2-DMBTR = WA_BSEG12-DMBTR.
         WA_INOTAX2-HWBAS = 0.
         WA_INOTAX2-STATUS = 'JRC'.
         IF WA_BSEG12-HKONT EQ '0000028010' OR
            WA_BSEG12-HKONT EQ '0000028060'.
           WA_INOTAX2-SGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000028020' OR
           WA_BSEG12-HKONT EQ '0000028070'.
           WA_INOTAX2-CGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000028030' OR
           WA_BSEG12-HKONT EQ '0000028080'.
           WA_INOTAX2-IGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000028040' OR
           WA_BSEG12-HKONT EQ '0000028090'.
           WA_INOTAX2-UGST = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ELSEIF WA_BSEG12-HKONT EQ '0000028050'.
           WA_INOTAX2-CESS = WA_BSEG12-DMBTR.
           WA_INOTAX2-HWSTE = WA_BSEG12-DMBTR.
         ENDIF.
         COLLECT WA_INOTAX2 INTO IT_INOTAX2.
         CLEAR WA_INOTAX2.
       ENDLOOP.

     ENDLOOP.
   ENDIF.

   IF IT_INOTAX2 IS NOT INITIAL.
     LOOP AT IT_INOTAX2 INTO WA_INOTAX2.
       WA_TAP1-BELNR = WA_INOTAX2-BELNR.
       WA_TAP1-GJAHR = WA_INOTAX2-GJAHR.
       WA_TAP1-HWBAS = 0.
       WA_TAP1-HWSTE = WA_INOTAX2-HWSTE.
       WA_TAP1-TXGRP = WA_INOTAX2-TXGRP.
       WA_TAP1-BUZEI = WA_INOTAX2-BUZEI.
       WA_TAP1-MWSKZ = WA_INOTAX2-MWSKZ.
       WA_TAP1-HKONT = WA_INOTAX2-HKONT.
       WA_TAP1-IGST = WA_INOTAX2-IGST.
       WA_TAP1-CGST = WA_INOTAX2-CGST.
       WA_TAP1-SGST = WA_INOTAX2-SGST.
       WA_TAP1-UGST = WA_INOTAX2-UGST.
       WA_TAP1-CESS = WA_INOTAX2-CESS.
       WA_TAP1-STATUS = WA_INOTAX2-STATUS.
       WA_TAP1-SIG = WA_INOTAX2-SIG.
       WA_TAP1-DMBTR = WA_INOTAX2-DMBTR.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_INOTAX2-BELNR
         AND GJAHR = WA_INOTAX2-GJAHR
         AND XREVERSAL EQ '2'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-HWBAS = WA_TAP1-HWBAS * ( - 1 ).
         WA_TAP1-HWSTE = WA_TAP1-HWSTE * ( - 1 ).
         WA_TAP1-IGST = WA_TAP1-IGST * ( - 1 ).
         WA_TAP1-CGST = WA_TAP1-CGST * ( - 1 ).
         WA_TAP1-SGST = WA_TAP1-SGST * ( - 1 ).
         WA_TAP1-UGST = WA_TAP1-UGST * ( - 1 ).
         WA_TAP1-CESS = WA_TAP1-CESS * ( - 1 ).
         WA_TAP1-DMBTR = WA_TAP1-DMBTR * ( - 1 ).
       ENDIF.
       COLLECT WA_TAP1 INTO IT_TAP1.
       CLEAR WA_TAP1.
     ENDLOOP.

   ENDIF.
 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM FORM1_1 .

   CLEAR : IT_BKPF,WA_BKPF.
*   IF nskpv = 'X'.
   SELECT * FROM BKPF INTO TABLE IT_BKPF WHERE
     BUDAT IN S_BUDAT AND  TCODE IN
     ( 'MIRO','MR8M','FB60','FB08','FBCJ',
       'FB01', 'FB65', 'FB50', 'FB05',
       'FBR2','FBVB' ,'ZBCLLR0001' ) .
   IF SY-SUBRC EQ 0.
     SELECT * FROM BSEG INTO TABLE IT_BSEG FOR
       ALL ENTRIES IN IT_BKPF
       WHERE BUKRS EQ '1000' AND
       BELNR EQ IT_BKPF-BELNR AND
       GJAHR = IT_BKPF-GJAHR AND HSN_SAC IN HSN.
   ENDIF.

   LOOP AT IT_BKPF INTO WA_BKPF .
     IF WA_BKPF-BLART GE 'A1' AND WA_BKPF-BLART LE 'A6'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'B6' AND WA_BKPF-BLART LE 'B9'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'C1' AND WA_BKPF-BLART LE 'D9'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'DA' AND WA_BKPF-BLART LE 'DE'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'F1' AND WA_BKPF-BLART LE 'IA'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'K1' AND WA_BKPF-BLART LE 'K4'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'L1' AND WA_BKPF-BLART LE 'LL'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'N1' AND WA_BKPF-BLART LE 'NL'.
       DELETE IT_BKPF.
     ENDIF.

     IF WA_BKPF-BUDAT GE NDATE1.
       IF WA_BKPF-BLART GE 'P1' AND WA_BKPF-BLART LE 'PR'.
         DELETE IT_BKPF.
       ENDIF.
       IF WA_BKPF-BLART EQ 'RA'.
         DELETE IT_BKPF.
       ENDIF.
     ELSE.
       IF WA_BKPF-BLART GE 'P1' AND WA_BKPF-BLART LE 'RA'.
         DELETE IT_BKPF.
       ENDIF.
     ENDIF.

     IF WA_BKPF-BLART GE 'U1' AND WA_BKPF-BLART LE 'U4'.
       DELETE IT_BKPF.
     ENDIF.



     IF WA_BKPF-BLART EQ 'DZ'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'MA'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'ZA'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'S1'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'SA'.
       DELETE IT_BKPF.
     ENDIF.


     IF WA_BKPF-BLART GE 'J1' AND WA_BKPF-BLART LE 'J9'.
       SELECT SINGLE * FROM BSEG WHERE
          BUKRS EQ '1000' AND
         BELNR EQ WA_BKPF-BELNR AND
         GJAHR EQ WA_BKPF-GJAHR AND
          LIFNR GE '0000010000' AND
          LIFNR LE '0000029999'.

       IF SY-SUBRC EQ 0.

       ELSE.
         DELETE IT_BKPF.
       ENDIF.
     ENDIF.

     IF WA_BKPF-GRPID EQ 'F-51GSTCLR' AND
       WA_BKPF-TCODE EQ 'FB05' AND
       WA_BKPF-BLART EQ 'AB'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'AB' AND WA_BKPF-TCODE EQ 'FB01'.
       SELECT SINGLE * FROM BSEG WHERE
         BUKRS EQ '1000' AND
         BELNR EQ WA_BKPF-BELNR AND
         GJAHR EQ WA_BKPF-GJAHR AND
         KOART EQ 'D' AND HKONT EQ
         '0000024160'.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM BSEG WHERE
            BUKRS EQ '1000' AND
           BELNR EQ WA_BKPF-BELNR AND
           GJAHR EQ WA_BKPF-GJAHR AND
           KOART EQ 'K' AND HKONT EQ
          '0000015010'.
         IF SY-SUBRC EQ 0.
           DELETE IT_BKPF.
         ENDIF.
       ENDIF.
     ENDIF.
   ENDLOOP.
   LOOP AT IT_BKPF INTO WA_BKPF.
     IF WA_BKPF-TCODE EQ 'FB08'.
       SELECT SINGLE * FROM BKPF WHERE
          BELNR EQ WA_BKPF-STBLG AND
          GJAHR EQ WA_BKPF-STJAH AND
         TCODE EQ 'J_1IG_INV'.
       IF SY-SUBRC EQ 0.
         DELETE IT_BKPF WHERE BELNR EQ WA_BKPF-BELNR
         AND GJAHR = WA_BKPF-GJAHR.
       ENDIF.
     ENDIF.
   ENDLOOP.

************* delete doc where grn is also done & manual j_1ig_inv is also done******
   LOOP AT IT_BKPF INTO WA_BKPF.
     IF WA_BKPF-TCODE EQ 'FB05' AND WA_BKPF-BLART EQ 'RE'.
       SELECT SINGLE * FROM VBRK WHERE
          VBELN EQ WA_BKPF-XBLNR AND
          FKART IN ('ZSTO','ZSTI','ZPMT',
                    'ZRMT','ZSCT','ZSAM','ZSMT').
       IF SY-SUBRC EQ 0.
         DELETE IT_BKPF WHERE BELNR EQ WA_BKPF-BELNR
                AND GJAHR = WA_BKPF-GJAHR.
       ENDIF.
     ENDIF.
   ENDLOOP.
**********************************************************************************

   LOOP AT IT_BKPF INTO WA_BKPF WHERE
          BLART GE 'J1' AND BLART LE 'J9'.
     SELECT SINGLE * FROM BSEG WHERE
            BUKRS EQ '1000' AND
            BELNR EQ WA_BKPF-BELNR AND
            GJAHR EQ WA_BKPF-GJAHR AND
            HKONT GT '0000015880' AND
       HKONT LE '0000015990'.
     IF SY-SUBRC EQ 0.
     ELSE.
       SELECT SINGLE * FROM BSEG WHERE
         BUKRS EQ '1000' AND
         BELNR EQ WA_BKPF-BELNR AND
         GJAHR EQ WA_BKPF-GJAHR AND
         HKONT GT '0000028010'
         AND HKONT LE '0000028300'.
       IF SY-SUBRC EQ 0.
       ELSE.
         DELETE IT_BKPF WHERE BELNR EQ WA_BKPF-BELNR
         AND GJAHR = WA_BKPF-GJAHR.
       ENDIF.
     ENDIF.
   ENDLOOP.

   LOOP AT IT_BKPF INTO WA_BKPF.
*WRITE : / 'a',WA_BKPF-BELNR.
     READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
                       BELNR = WA_BKPF-BELNR
                       GJAHR = WA_BKPF-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAB1-TCODE = WA_BKPF-TCODE.
       WA_TAB1-BLART = WA_BKPF-BLART.
       WA_TAB1-BELNR = WA_BKPF-BELNR.
       WA_TAB1-AWKEY = WA_BKPF-AWKEY.
       WA_TAB1-GJAHR = WA_BKPF-GJAHR.
       WA_TAB1-BUDAT = WA_BKPF-BUDAT.
       WA_TAB1-BLDAT = WA_BKPF-BLDAT.
       WA_TAB1-XBLNR = WA_BKPF-XBLNR.
       WA_TAB1-GSBER = WA_BSEG-GSBER.
*       WA_TAB1-DMBTR = WA_BSEG-DMBTR.
       WA_TAB1-USNAM = WA_BKPF-USNAM.
************  business plave for LLM***********************

*********************************************************

       READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
                               BELNR = WA_BKPF-BELNR
                               GJAHR = WA_BKPF-GJAHR
                               HKONT = '0000015200' .
       IF SY-SUBRC EQ 0.
         WA_TAB1-BUPLA = WA_BSEG-BUPLA.
       ELSE.
         READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
                          BELNR = WA_BKPF-BELNR
                          GJAHR = WA_BKPF-GJAHR
                          HKONT = '0000026050' .
         IF SY-SUBRC EQ 0.
           WA_TAB1-BUPLA = WA_BSEG-BUPLA.
         ELSE.
           READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
                           BELNR = WA_BKPF-BELNR
                           GJAHR = WA_BKPF-GJAHR
                           HKONT = '0000026120'.
           IF SY-SUBRC EQ 0.
             WA_TAB1-BUPLA = WA_BSEG-BUPLA.
           ELSE.
             READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
                           BELNR = WA_BKPF-BELNR
                           GJAHR = WA_BKPF-GJAHR
                           HKONT = '0000040490'.
             IF SY-SUBRC EQ 0.
               WA_TAB1-BUPLA = WA_BSEG-BUPLA.
             ELSE.

***********************************
               READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
                          BELNR = WA_BKPF-BELNR
                          GJAHR = WA_BKPF-GJAHR
                          BUZID = 'T'.
               IF SY-SUBRC EQ 0.
                 WA_TAB1-BUPLA = WA_BSEG-BUPLA.
                 WA_TAB1-GSBER = WA_BSEG-GSBER.
               ELSE.
*****************************************
                 READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
                            BELNR = WA_BKPF-BELNR
                            GJAHR = WA_BKPF-GJAHR.
                 IF SY-SUBRC EQ 0.
                   WA_TAB1-BUPLA = WA_BSEG-BUPLA.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
       IF WA_BKPF-BELNR EQ '0000006510'
          AND WA_BKPF-GJAHR EQ '2018'.
          WA_TAB1-BUPLA = 'MAH'.
       ENDIF.
***************************************
*       ******************  business place for LLM  - MAH ALWAYS **********************
       DT1+6(2) = '01'.
       DT1+4(2) = '04'.
       DT1+0(4) = '2017'.
       IF S_BUDAT-LOW GE DT1.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                      AND BELNR = WA_BKPF-BELNR
                      AND GJAHR = WA_BKPF-GJAHR AND
                      EBELP NE SPACE.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM EKKO WHERE EBELN EQ BSEG-EBELN AND BSART EQ 'ZS'.
           IF SY-SUBRC EQ 0.
             WA_TAB1-BUPLA = 'MAH'.
           ENDIF.
         ENDIF.
       ENDIF.
******************************************
       COLLECT WA_TAB1 INTO IT_TAB1.
       CLEAR WA_TAB1.
     ENDIF.
   ENDLOOP.

   PERFORM TDS.
   PERFORM TOTVALUE.
   IF IT_TAB1 IS NOT INITIAL.
     SELECT * FROM BSET INTO TABLE IT_BSET
       FOR ALL ENTRIES IN IT_TAB1 WHERE
       BUKRS EQ '1000' AND
       BELNR EQ IT_TAB1-BELNR AND
       GJAHR EQ IT_TAB1-GJAHR.
   ENDIF.
   clear : wa_bseg.
   IF IT_BSET IS NOT INITIAL.
     LOOP AT IT_BSET INTO WA_BSET.
       READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY
                  BELNR = WA_BSET-BELNR
                  GJAHR = WA_BSET-GJAHR.
       IF SY-SUBRC EQ 0.

         IF WA_BSET-SHKZG EQ 'H'.
           WA_BSET-HWSTE = WA_BSET-HWSTE * ( - 1 ).
           WA_BSET-HWBAS = WA_BSET-HWBAS * ( - 1 ).
         ENDIF.
         WA_TAP1-BELNR = WA_TAB1-BELNR.
         WA_TAP1-GJAHR = WA_TAB1-GJAHR.
         WA_TAP1-TXGRP = WA_BSET-TXGRP.
         WA_TAP1-HKONT = SPACE.
         WA_TAP1-BUZEI = WA_BSET-BUZEI.
         WA_TAP1-MWSKZ = WA_BSET-MWSKZ.
         WA_TAP1-TXGRP = WA_BSET-TXGRP.
         IF WA_BSET-KTOSL EQ 'JIC' OR
            WA_BSET-KTOSL EQ 'JRC'.
           WA_TAP1-CGST = WA_BSET-HWSTE.
           WA_TAP1-HWBAS = WA_BSET-HWBAS.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
           clear : wa_bseg.
          ELSEIF WA_BSET-KTOSL EQ 'JIS' OR
                 WA_BSET-KTOSL EQ 'JRS'.
           WA_TAP1-SGST = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.

         ELSEIF WA_BSET-KTOSL EQ 'JIU' OR
                WA_BSET-KTOSL EQ 'JRU'.
           WA_TAP1-UGST = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ELSEIF WA_BSET-KTOSL EQ 'JII' OR
               WA_BSET-KTOSL EQ 'JRI'.
           IF WA_BSET-MWSKZ NE 'V0'.
             WA_TAP1-IGST = WA_BSET-HWSTE.
             WA_TAP1-HWBAS = WA_BSET-HWBAS.
             WA_TAP1-HWSTE = WA_BSET-HWSTE.
           ENDIF.
         ELSEIF WA_BSET-KTOSL EQ 'JIM'.
           WA_TAP1-IGST = WA_BSET-HWSTE.
           WA_TAP1-HWBAS = WA_BSET-HWBAS.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ELSEIF WA_BSET-KTOSL EQ 'JCI' OR
                WA_BSET-KTOSL EQ 'JCR'.
           WA_TAP1-CESS = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
***Added by bk on 21.11.2025
         ELSEIF WA_BSET-KSCHL EQ 'JICN'.
           WA_TAP1-CGST  = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ELSEIF WA_BSET-KSCHL EQ 'JISN'.
           WA_TAP1-SGST  = WA_BSET-HWSTE.
           WA_TAP1-HWBAS = WA_BSET-HWBAS.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
***Added by bk on 21.11.2025
***Added by bk on 21.11.2025
         ELSEIF WA_BSET-KSCHL EQ 'JCRN'.
           WA_TAP1-CGST  = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ELSEIF WA_BSET-KSCHL EQ 'JSRN'.
           WA_TAP1-SGST  = WA_BSET-HWSTE.
           WA_TAP1-HWBAS = WA_BSET-HWBAS.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
***Added by bk on 21.11.2025
         ENDIF.

         IF WA_BSET-HWSTE LT 0.
           WA_TAP1-SIG = 'A'.
         ELSE.
           WA_TAP1-SIG = 'B'.
         ENDIF.
         IF WA_BSET-KTOSL EQ 'JRI' OR
            WA_BSET-KTOSL EQ 'JRC'.
*           break-point.
           READ TABLE IT_BSET INTO WA_BSET WITH KEY
                      BELNR = WA_TAB1-BELNR
                      GJAHR = WA_TAB1-GJAHR
                      TXGRP = WA_TAP1-TXGRP.
           IF SY-SUBRC EQ 0.
             IF WA_TAP1-HWSTE LT 0.
               WA_TAP1-HWBAS = WA_BSET-HWBAS * ( - 1 ).
             ELSE.
               WA_TAP1-HWBAS = WA_BSET-HWBAS.
             ENDIF.
           ENDIF.
         ENDIF.
         CLEAR : ING.
         READ TABLE IT_BKPF INTO WA_BKPF WITH KEY
                     BELNR = WA_TAP1-BELNR
                     GJAHR = WA_TAP1-GJAHR .
         IF SY-SUBRC EQ 0.
           IF WA_BKPF-TCODE EQ 'MIRO' OR WA_BKPF-TCODE EQ 'MR8M'.
           ELSE.
             SELECT SINGLE * FROM BSET WHERE BUKRS EQ '1000'
               AND BELNR = WA_TAP1-BELNR AND
               GJAHR = WA_TAP1-GJAHR AND
               TAXPS EQ WA_BSET-TAXPS
               AND KTOSL IN ( 'JRC', 'JRS','JRI' ).
             IF SY-SUBRC EQ 0.
               ING = 1.
             ENDIF.
           ENDIF.
         ENDIF.
         IF ING EQ 1.
           WA_TAP1-DMBTR = WA_TAP1-HWBAS.
         ELSE.
           WA_TAP1-DMBTR = WA_TAP1-HWBAS + WA_TAP1-HWSTE.
         ENDIF.
         COLLECT WA_TAP1 INTO IT_TAP1.
         CLEAR WA_TAP1.
       ENDIF.
     ENDLOOP.
   ENDIF.
*   ******   rcm tax********************************
***************************************************
   CLEAR : TTAX,TTAX1.
*   DELETE IT_TAP1 WHERE HWBAS EQ 0.
   IF IT_TAP1 IS NOT INITIAL.
     LOOP AT IT_TAP1 INTO WA_TAP1.
       TTAX = TTAX + WA_TAP1-HWSTE.
       TTAX1 = TTAX1 + WA_TAP1-IGST +
               WA_TAP1-CGST + WA_TAP1-SGST +
               WA_TAP1-UGST + WA_TAP1-CESS.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                     BELNR = WA_TAP1-BELNR
                     GJAHR = WA_TAP1-GJAHR
                     TXGRP = WA_TAP1-TXGRP
                     HKONT = '0000015880'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                   BELNR = WA_TAP1-BELNR
                   GJAHR = WA_TAP1-GJAHR
                   TXGRP = WA_TAP1-TXGRP
                   HKONT = '0000015890'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                       BELNR = WA_TAP1-BELNR
                       GJAHR = WA_TAP1-GJAHR
                       TXGRP = WA_TAP1-TXGRP
                       HKONT = '0000015900'.
       IF SY-SUBRC EQ  0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                    BELNR = WA_TAP1-BELNR
                    GJAHR = WA_TAP1-GJAHR
                    TXGRP = WA_TAP1-TXGRP
                    HKONT = '0000015910'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                    BELNR = WA_TAP1-BELNR
                    GJAHR = WA_TAP1-GJAHR
                    TXGRP = WA_TAP1-TXGRP
                    HKONT = '0000015920'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.

       MODIFY IT_TAP1 FROM WA_TAP1 TRANSPORTING STATUS.
       CLEAR WA_TAP1.
     ENDLOOP.
   ENDIF.
*   EXIT.
   IF TTAX NE TTAX1.
     WRITE : / '*************** DIFFERANCE IN TAX **********************'.
   ENDIF.
   sort it_tap1 by belnr gjahr.
   PERFORM NONTAXGL.  "concideR gst gl even if system has calculated tax.. if tax is zero.
   LOOP AT IT_TAP1 INTO WA_TAP1 WHERE DMBTR NE 0.
     READ TABLE IT_TAK4 INTO WA_TAK4 WITH KEY
             BELNR = WA_TAP1-BELNR
             GJAHR = WA_TAP1-GJAHR
             TXGRP = WA_TAP1-TXGRP.
     IF SY-SUBRC EQ 0.
       WA_TAK5-BELNR = WA_TAP1-BELNR.
       WA_TAK5-GJAHR = WA_TAP1-GJAHR.
       WA_TAK5-TXGRP = WA_TAP1-TXGRP.
       WA_TAK5-MWSKZ = WA_TAP1-MWSKZ.
       WA_TAK5-HKONT = WA_TAP1-HKONT.
       WA_TAK5-STATUS = WA_TAP1-STATUS.
       WA_TAK5-DMBTR = WA_TAP1-DMBTR.
       WA_TAK5-HWBAS = WA_TAP1-HWBAS.
       WA_TAK5-SGST = WA_TAP1-SGST.
       WA_TAK5-CGST = WA_TAP1-CGST.
       WA_TAK5-IGST = WA_TAP1-IGST.
       WA_TAK5-CESS = WA_TAP1-CESS.
       WA_TAK5-UGST = WA_TAP1-UGST.
       WA_TAK5-HWSTE = WA_TAP1-HWSTE.
       COLLECT WA_TAK5 INTO IT_TAK5.
       CLEAR WA_TAK5.

     ENDIF..
   ENDLOOP.

   LOOP AT IT_TAP1 INTO WA_TAP1 WHERE DMBTR NE 0.
     READ TABLE IT_TAK4 INTO WA_TAK4 WITH KEY
              BELNR = WA_TAP1-BELNR
              GJAHR = WA_TAP1-GJAHR.
     IF SY-SUBRC EQ 0.
       READ TABLE IT_TAK4 INTO WA_TAK4 WITH KEY
              BELNR = WA_TAP1-BELNR
              GJAHR = WA_TAP1-GJAHR
              TXGRP = WA_TAP1-TXGRP.
       IF SY-SUBRC EQ 4.
         WA_TAK5-BELNR = WA_TAP1-BELNR.
         WA_TAK5-GJAHR = WA_TAP1-GJAHR.
         WA_TAK5-TXGRP = WA_TAP1-TXGRP.
         WA_TAK5-MWSKZ = WA_TAP1-MWSKZ.
         WA_TAK5-HKONT = WA_TAP1-HKONT.
         WA_TAK5-STATUS = WA_TAP1-STATUS.
         WA_TAK5-DMBTR = WA_TAP1-DMBTR.
         WA_TAK5-HWBAS = WA_TAP1-HWBAS.
         WA_TAK5-SGST = WA_TAP1-SGST.
         WA_TAK5-CGST = WA_TAP1-CGST.
         WA_TAK5-IGST = WA_TAP1-IGST.
         WA_TAK5-CESS = WA_TAP1-CESS.
         WA_TAK5-UGST = WA_TAP1-UGST.
         WA_TAK5-HWSTE = WA_TAP1-HWSTE.
         COLLECT WA_TAK5 INTO IT_TAK5.
         CLEAR WA_TAK5.
       ENDIF.
     ENDIF.
   ENDLOOP.

   LOOP AT IT_TAP1 INTO WA_TAP1 .
     READ TABLE IT_TAK4 INTO WA_TAK4 WITH KEY
            BELNR = WA_TAP1-BELNR
            GJAHR = WA_TAP1-GJAHR.
     IF SY-SUBRC EQ 0.
       DELETE IT_TAP1 WHERE BELNR EQ WA_TAP1-BELNR
                        AND GJAHR = WA_TAP1-GJAHR .
     ENDIF.
   ENDLOOP.

   LOOP AT IT_TAK5 INTO WA_TAK5.
     WA_TAP1-BELNR = WA_TAK5-BELNR.
     WA_TAP1-GJAHR = WA_TAK5-GJAHR.
     WA_TAP1-TXGRP = WA_TAK5-TXGRP.
     WA_TAP1-MWSKZ = WA_TAK5-MWSKZ.
     WA_TAP1-HKONT = WA_TAK5-HKONT.
     WA_TAP1-STATUS = WA_TAK5-STATUS.
     WA_TAP1-DMBTR = WA_TAK5-DMBTR.
     WA_TAP1-HWBAS = WA_TAK5-HWBAS.
     WA_TAP1-SGST = WA_TAK5-SGST.
     WA_TAP1-CGST = WA_TAK5-CGST.
     WA_TAP1-IGST = WA_TAK5-IGST.
     WA_TAP1-CESS = WA_TAK5-CESS.
     WA_TAP1-UGST = WA_TAK5-UGST.
     WA_TAP1-HWSTE = WA_TAK5-HWSTE.
     COLLECT WA_TAP1 INTO IT_TAP1.
     CLEAR WA_TAP1.
   ENDLOOP.

   LOOP AT IT_TAP1 INTO WA_TAP1.
     READ TABLE IT_TAK4 INTO WA_TAK4 WITH KEY
           BELNR = WA_TAP1-BELNR
           GJAHR = WA_TAP1-GJAHR
           TXGRP = WA_TAP1-TXGRP.
     IF SY-SUBRC EQ 0.
       WA_TAP1-BELNR = WA_TAP1-BELNR.
       WA_TAP1-GJAHR = WA_TAP1-GJAHR.
       WA_TAP1-TXGRP = WA_TAP1-TXGRP.
       WA_TAP1-MWSKZ = WA_TAP1-MWSKZ.
       WA_TAP1-HKONT = WA_TAP1-HKONT.
       WA_TAP1-STATUS = WA_TAK4-STATUS.
       WA_TAP1-DMBTR = 0.
       WA_TAP1-HWBAS = 0.
       WA_TAP1-SGST = WA_TAK4-SGST.
       WA_TAP1-CGST = WA_TAK4-CGST.
       WA_TAP1-IGST = WA_TAK4-IGST.
       WA_TAP1-CESS = WA_TAK4-CESS.
       WA_TAP1-UGST = WA_TAK4-UGST.
       WA_TAP1-HWSTE = WA_TAK4-HWSTE.
       COLLECT WA_TAP1 INTO IT_TAP1.
       CLEAR WA_TAP1.
     ENDIF.
   ENDLOOP.

*************************************************
   PERFORM INOTAX2.
   PERFORM INOTAX1.
   PERFORM NOTAX1.

   SORT IT_TAB1 BY BELNR GJAHR.
   DELETE ADJACENT DUPLICATES FROM IT_TAB1 COMPARING BELNR GJAHR.

   LOOP AT IT_TAP1 INTO WA_TAP1.
     READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY
             BELNR = WA_TAP1-BELNR
             GJAHR = WA_TAP1-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAP2-BELNR = WA_TAB1-BELNR.
       WA_TAP2-GJAHR = WA_TAB1-GJAHR.
       WA_TAP2-BUPLA = WA_TAB1-BUPLA.
       WA_TAP2-TCODE = WA_TAB1-TCODE.
       WA_TAP2-BLART = WA_TAB1-BLART.
       WA_TAP2-AWKEY = WA_TAB1-AWKEY.
       WA_TAP2-BUDAT = WA_TAB1-BUDAT.
       WA_TAP2-BLDAT = WA_TAB1-BLDAT.
       WA_TAP2-XBLNR = WA_TAB1-XBLNR.
       WA_TAP2-GSBER = WA_TAB1-GSBER.
       WA_TAP2-USNAM = WA_TAB1-USNAM .
       WA_TAP2-TXGRP = WA_TAP1-TXGRP.
       WA_TAP2-HKONT = WA_TAP1-HKONT.
       WA_TAP2-DMBTR = WA_TAP1-DMBTR.
       WA_TAP2-HWBAS = WA_TAP1-HWBAS.
       WA_TAP2-HWSTE = WA_TAP1-HWSTE.
       WA_TAP2-MWSKZ = WA_TAP1-MWSKZ.
       WA_TAP2-BUZEI = WA_TAP1-BUZEI.
       WA_TAP2-IGST = WA_TAP1-IGST.
       WA_TAP2-CGST = WA_TAP1-CGST.
       WA_TAP2-SGST = WA_TAP1-SGST.
       WA_TAP2-UGST = WA_TAP1-UGST.
       WA_TAP2-CESS = WA_TAP1-CESS.
       WA_TAP2-STATUS = WA_TAP1-STATUS.
       IF WA_TAP1-HWSTE LT 0.
         WA_TAP2-SIG = 'A'.
       ELSE.
         WA_TAP2-SIG = 'B'.
       ENDIF.
       COLLECT WA_TAP2 INTO IT_TAP2.
       CLEAR WA_TAP2.
     ENDIF.
   ENDLOOP.


   LOOP AT IT_TAPX1 INTO WA_TAPX1.
     READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY
                  BELNR = WA_TAPX1-BELNR
                  GJAHR = WA_TAPX1-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAP2-BELNR = WA_TAB1-BELNR.
       WA_TAP2-GJAHR = WA_TAB1-GJAHR.
       WA_TAP2-BUPLA = WA_TAB1-BUPLA.
       WA_TAP2-TCODE = WA_TAB1-TCODE.
       WA_TAP2-BLART = WA_TAB1-BLART.
       WA_TAP2-AWKEY = WA_TAB1-AWKEY.
       WA_TAP2-BUDAT = WA_TAB1-BUDAT.
       WA_TAP2-BLDAT = WA_TAB1-BLDAT.
       WA_TAP2-XBLNR = WA_TAB1-XBLNR.
       WA_TAP2-GSBER = WA_TAB1-GSBER.
       WA_TAP2-USNAM = WA_TAB1-USNAM .
       WA_TAP2-TXGRP = WA_TAPX1-TXGRP.
       WA_TAP2-HKONT = WA_TAPX1-HKONT.
*       WA_TAP2-KTOSL = WA_TAPX1-KTOSL.
       WA_TAP2-DMBTR = WA_TAPX1-DMBTR.
       WA_TAP2-HWBAS = WA_TAPX1-HWBAS.
       WA_TAP2-HWSTE = WA_TAPX1-HWSTE.
       WA_TAP2-MWSKZ = WA_TAPX1-MWSKZ.
       WA_TAP2-BUZEI = WA_TAPX1-BUZEI.
       WA_TAP2-IGST = WA_TAPX1-IGST.
       WA_TAP2-CGST = WA_TAPX1-CGST.
       WA_TAP2-SGST = WA_TAPX1-SGST.
       WA_TAP2-UGST = WA_TAPX1-UGST.
       WA_TAP2-CESS = WA_TAPX1-CESS.
       WA_TAP2-STATUS = WA_TAPX1-STATUS.
       IF WA_TAPX1-HWSTE LT 0.
         WA_TAP2-SIG = 'A'.
       ELSE.
         WA_TAP2-SIG = 'B'.
       ENDIF.
       COLLECT WA_TAP2 INTO IT_TAP2.
       CLEAR WA_TAP2.
     ENDIF.
   ENDLOOP.

*************************************

   SORT IT_TAP2 BY GJAHR BELNR TXGRP.
   LOOP AT IT_TAP2 INTO WA_TAP2.
     CLEAR : RATE.
     WA_TAS1-BELNR = WA_TAP2-BELNR.
     WA_TAS1-GJAHR = WA_TAP2-GJAHR.
     WA_TAS1-TXGRP = WA_TAP2-TXGRP.
     WA_TAS1-MWSKZ = WA_TAP2-MWSKZ.
     WA_TAS1-BUZEI = WA_TAP2-BUZEI.
     WA_TAS1-HKONT = WA_TAP2-HKONT.
     WA_TAS1-HWBAS = WA_TAP2-HWBAS.
     WA_TAS1-HWSTE = WA_TAP2-HWSTE.
     WA_TAS1-DMBTR = WA_TAP2-DMBTR.
     WA_TAS1-SGST = WA_TAP2-SGST.
     WA_TAS1-CGST = WA_TAP2-CGST.
     WA_TAS1-IGST = WA_TAP2-IGST.
     WA_TAS1-CESS = WA_TAP2-CESS.
     WA_TAS1-UGST = WA_TAP2-UGST.
     WA_TAS1-SIG = WA_TAP2-SIG.
     WA_TAS1-STATUS = WA_TAP2-STATUS.
     READ TABLE IT_BSET INTO WA_BSET WITH KEY
                BELNR = WA_TAP2-BELNR
                GJAHR = WA_TAP2-GJAHR
                TXGRP = WA_TAP2-TXGRP
                KTOSL = 'JIC'.
     IF SY-SUBRC EQ 0.
       RATE = ( WA_BSET-KBETR / 10 ) * 2.
     ELSE.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                BELNR = WA_TAP2-BELNR
                GJAHR = WA_TAP2-GJAHR
                TXGRP = WA_TAP2-TXGRP.
       IF SY-SUBRC EQ 0.
         RATE = ( WA_BSET-KBETR / 10 ).
       ENDIF.
     ENDIF.
     WA_TAS1-RATE = RATE.
     SELECT SINGLE * FROM BSEG WHERE
        BUKRS EQ '1000' AND BELNR EQ WA_TAP2-BELNR
        AND GJAHR = WA_TAP2-GJAHR AND
        TXGRP = WA_TAP2-TXGRP AND HSN_SAC NE '          '.
     IF SY-SUBRC EQ 0.
       WA_TAS1-STEUC = BSEG-HSN_SAC.
       WA_TAS1-MENGE = BSEG-MENGE.
       WA_TAS1-MEINS = BSEG-MEINS.
     ELSE.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
          AND BELNR EQ WA_TAP2-BELNR AND
         GJAHR = WA_TAP2-GJAHR AND TXGRP = WA_TAP2-TXGRP.
       IF SY-SUBRC EQ 0.
         WA_TAS1-MENGE = BSEG-MENGE.
         WA_TAS1-MEINS = BSEG-MEINS.
       ENDIF.
     ENDIF.
     SELECT SINGLE * FROM ZPREGHSN WHERE
        GJAHR EQ WA_TAP2-GJAHR AND
        BELNR EQ WA_TAP2-BELNR AND
        BUZEI = WA_TAP2-TXGRP.
     IF SY-SUBRC EQ 0.
       WA_TAS1-STEUC = ZPREGHSN-HSN_SAC.
     ENDIF.
     IF WA_TAP2-HWSTE LT 0.
       WA_TAS1-SIG = 'A'.
     ELSE.
       WA_TAS1-SIG = 'B'.
     ENDIF.
     COLLECT WA_TAS1 INTO IT_TAS1.
     CLEAR WA_TAS1.
   ENDLOOP.
***************  NO TAX********************


   SORT IT_TAS1 BY BELNR GJAHR TXGRP.

   LOOP AT IT_TAS1 INTO WA_TAS1.
     CLEAR : VAL1, VAL2,VAL3,DOC.
     WA_TAS2-GJAHR = WA_TAS1-GJAHR.
     WA_TAS2-BELNR = WA_TAS1-BELNR.
     WA_TAS2-TXGRP = WA_TAS1-TXGRP.
     WA_TAS2-HKONT = WA_TAS1-HKONT.
     WA_TAS2-MWSKZ = WA_TAS1-MWSKZ.
     WA_TAS2-BUZEI = WA_TAS1-BUZEI.
     WA_TAS2-STATUS = WA_TAS1-STATUS.
     WA_TAS2-STEUC = WA_TAS1-STEUC.
     WA_TAS2-MENGE = WA_TAS1-MENGE.
     WA_TAS2-MEINS = WA_TAS1-MEINS.
     WA_TAS2-HWBAS = WA_TAS1-HWBAS.
     WA_TAS2-HWSTE = WA_TAS1-HWSTE.
     WA_TAS2-DMBTR = WA_TAS1-DMBTR.
     WA_TAS2-SGST = WA_TAS1-SGST.
     WA_TAS2-CGST = WA_TAS1-CGST.
     WA_TAS2-UGST = WA_TAS1-UGST.
     WA_TAS2-IGST = WA_TAS1-IGST.
     WA_TAS2-CESS = WA_TAS1-CESS.
     WA_TAS2-SIG = WA_TAS1-SIG.
     WA_TAS2-RATE = WA_TAS1-RATE.

     ON CHANGE OF WA_TAS1-BELNR.
       READ TABLE IT_TDS1 INTO WA_TDS1 WITH KEY
       BELNR = WA_TAS1-BELNR GJAHR = WA_TAS1-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAS2-TDS = WA_TDS1-DMBTR.
       ENDIF.
     ENDON.
     READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY
      BELNR = WA_TAS1-BELNR GJAHR = WA_TAS1-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAS2-TCODE = WA_TAB1-TCODE.
       WA_TAS2-BLART = WA_TAB1-BLART.
       WA_TAS2-AWKEY = WA_TAB1-AWKEY.
       WA_TAS2-BUDAT = WA_TAB1-BUDAT.
       WA_TAS2-BLDAT = WA_TAB1-BLDAT.
       WA_TAS2-XBLNR = WA_TAB1-XBLNR.
       WA_TAS2-GSBER = WA_TAB1-GSBER.
       WA_TAS2-USNAM = WA_TAB1-USNAM.
       WA_TAS2-BUPLA = WA_TAB1-BUPLA.
     ENDIF.
     SELECT SINGLE * FROM BSEG WHERE
       BUKRS EQ '1000' AND BELNR = WA_TAS1-BELNR
       AND GJAHR = WA_TAS1-GJAHR AND KOART EQ 'K'.
     IF SY-SUBRC EQ 0.
       WA_TAS2-LIFNR = BSEG-LIFNR.
       SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ BSEG-LIFNR.
       IF SY-SUBRC EQ 0.
         WA_TAS2-VENREG = LFA1-REGIO.
         WA_TAS2-NAME1 = LFA1-NAME1.
         WA_TAS2-ORT01 = LFA1-ORT01.
         WA_TAS2-STCD3 = LFA1-STCD3.

         IF LFA1-VEN_CLASS EQ ' '.
           WA_TAS2-VEN_CL = 'Registered'.
         ELSEIF LFA1-VEN_CLASS EQ '0'.
           WA_TAS2-VEN_CL = 'Not Registered'.
         ELSEIF LFA1-VEN_CLASS EQ '1'.
           WA_TAS2-VEN_CL = 'Compounding Scheme'.
         ELSEIF LFA1-VEN_CLASS EQ '2'.
           WA_TAS2-VEN_CL = 'Special Economic Zone'.
         ENDIF.
         WA_TAS2-VEN_CLASS = LFA1-VEN_CLASS.
         WA_TAS2-PAN = LFA1-J_1IPANNO.

         CLEAR : SCODE.
         SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN'
               AND BLAND EQ WA_TAS2-VENREG.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN'
              AND LAND1 EQ 'IN' AND BLAND EQ WA_TAS2-VENREG.
           IF SY-SUBRC EQ 0.
             CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
             WA_TAS2-SCODE = SCODE.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.

     IF WA_TAS2-LIFNR EQ '0000000001'.
       SELECT SINGLE * FROM BSEC WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_TAS1-BELNR AND GJAHR EQ WA_TAS1-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAS2-NAME1 = BSEC-NAME1.
         WA_TAS2-ORT01 = BSEC-ORT01.
         WA_TAS2-VENREG = BSEC-REGIO.
         WA_TAS2-STCD3 = BSEC-STCD3.
         CLEAR : SCODE.
         SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN'
               AND BLAND EQ WA_TAS2-VENREG.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN'
             AND LAND1 EQ 'IN' AND BLAND EQ WA_TAS2-VENREG.
           IF SY-SUBRC EQ 0.
             CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
             WA_TAS2-SCODE = SCODE.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.

     READ TABLE IT_BKPF INTO WA_BKPF WITH KEY
      BELNR = WA_TAS1-BELNR GJAHR = WA_TAS1-GJAHR.
     IF SY-SUBRC EQ 0.
       SELECT SINGLE * FROM RSEG WHERE BELNR EQ
         WA_BKPF-AWKEY+0(10) AND GJAHR EQ WA_BKPF-AWKEY+10(4).
       IF SY-SUBRC EQ 0.
         CONCATENATE RSEG-LFBNR RSEG-LFGJA INTO DOC.
         SELECT SINGLE * FROM BKPF WHERE
             BUKRS EQ '1000' AND AWKEY EQ DOC.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
              AND BELNR EQ BKPF-BELNR
              AND GJAHR = BKPF-GJAHR.
           IF SY-SUBRC EQ 0.
             IF WA_TAS2-HKONT EQ SPACE.
               WA_TAS2-HKONT = BSEG-HKONT.
             ENDIF.
             WA_TAS2-KOSTL = BSEG-KOSTL.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.
     COLLECT WA_TAS2 INTO IT_TAS2.
     CLEAR WA_TAS2.
   ENDLOOP.

   SORT IT_TAS2 BY BELNR GJAHR TXGRP.
   IF IT_TAS2 IS NOT INITIAL.
     SELECT * FROM BSE_CLR INTO TABLE IT_BSE_CLR
       FOR ALL ENTRIES IN IT_TAS2 WHERE
       BUKRS_CLR EQ 'BCLL' AND BUKRS EQ '1000'
       AND BELNR EQ IT_TAS2-BELNR
       AND GJAHR EQ IT_TAS2-GJAHR.
   ENDIF.
   SORT IT_BSE_CLR DESCENDING BY BELNR_CLR.

   LOOP AT IT_BSE_CLR  INTO WA_BSE_CLR.
     SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
        AND BELNR EQ WA_BSE_CLR-BELNR AND
        GJAHR = WA_BSE_CLR-GJAHR AND XREVERSAL NE SPACE.
     IF SY-SUBRC EQ 0.
       DELETE IT_BSE_CLR WHERE BELNR_CLR EQ BKPF-BELNR
       AND GJAHR_CLR EQ BKPF-GJAHR.
     ENDIF.
   ENDLOOP.


   LOOP AT IT_TAS2 INTO WA_TAS2 WHERE BUPLA IN BUSPLACE.
     IF WA_TAS2-TCODE EQ 'FBCJ' AND WA_TAS2-LIFNR EQ '0000000001'.

     ELSE.

       WA_TAS3-GJAHR = WA_TAS2-GJAHR.
       WA_TAS3-BELNR = WA_TAS2-BELNR.
       WA_TAS3-TXGRP = WA_TAS2-TXGRP.
       WA_TAS3-MWSKZ = WA_TAS2-MWSKZ.
       WA_TAS3-BUZEI = WA_TAS2-BUZEI.
       WA_TAS3-STATUS = WA_TAS2-STATUS.
       WA_TAS3-STEUC = WA_TAS2-STEUC.
       WA_TAS3-MENGE = WA_TAS2-MENGE.
       WA_TAS3-MEINS = WA_TAS2-MEINS.
       WA_TAS3-HWBAS = WA_TAS2-HWBAS.
       WA_TAS3-HWSTE = WA_TAS2-HWSTE.
       WA_TAS3-DMBTR = WA_TAS2-DMBTR.

       WA_TAS3-SGST = WA_TAS2-SGST.
       WA_TAS3-CGST = WA_TAS2-CGST.
       WA_TAS3-UGST = WA_TAS2-UGST.
       WA_TAS3-IGST = WA_TAS2-IGST.
       WA_TAS3-CESS = WA_TAS2-CESS.
       WA_TAS3-SIG = WA_TAS2-SIG.
       WA_TAS3-RATE = WA_TAS2-RATE.

       WA_TAS3-TDS = WA_TAS2-TDS.
       WA_TAS3-TCODE = WA_TAS2-TCODE.
       WA_TAS3-BLART = WA_TAS2-BLART.
       WA_TAS3-AWKEY = WA_TAS2-AWKEY.
       WA_TAS3-BUDAT = WA_TAS2-BUDAT.
       WA_TAS3-BLDAT = WA_TAS2-BLDAT.
       WA_TAS3-XBLNR = WA_TAS2-XBLNR.
       WA_TAS3-GSBER = WA_TAS2-GSBER.
       WA_TAS3-USNAM = WA_TAS2-USNAM.
       WA_TAS3-BUPLA = WA_TAS2-BUPLA.
       WA_TAS3-LIFNR = WA_TAS2-LIFNR.
       WA_TAS3-VENREG = WA_TAS2-VENREG.
       WA_TAS3-NAME1 = WA_TAS2-NAME1.
       WA_TAS3-ORT01 = WA_TAS2-ORT01.
       WA_TAS3-STCD3 = WA_TAS2-STCD3.
       WA_TAS3-VEN_CLASS = WA_TAS2-VEN_CLASS.
       WA_TAS3-PAN = WA_TAS2-PAN.
       WA_TAS3-VEN_CL = WA_TAS2-VEN_CL.
       WA_TAS3-SCODE = WA_TAS2-SCODE.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR = WA_TAS2-BELNR AND
         GJAHR = WA_TAS2-GJAHR AND EBELP NE SPACE.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM EKPO WHERE EBELN EQ BSEG-EBELN
                         AND EBELP EQ BSEG-EBELP.
         IF SY-SUBRC EQ 0.
           WA_TAS3-WERKS = EKPO-WERKS.
         ENDIF.
       ENDIF.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR = WA_TAS2-BELNR AND
         GJAHR = WA_TAS2-GJAHR AND TXGRP = WA_TAS2-TXGRP.
       IF SY-SUBRC EQ 0.
         WA_TAS3-SGTXT = BSEG-SGTXT.
       ELSE.
         SELECT SINGLE * FROM BSEG WHERE BUKRS
           EQ '1000' AND BELNR = WA_TAS2-BELNR
           AND GJAHR = WA_TAS2-GJAHR.
         IF SY-SUBRC EQ 0.
           WA_TAS3-SGTXT = BSEG-SGTXT.
         ENDIF.
       ENDIF.
       IF WA_TAS3-SGTXT EQ '                    '.
         SELECT SINGLE * FROM BSEG WHERE
           BUKRS EQ '1000' AND BELNR = WA_TAS2-BELNR
            AND GJAHR = WA_TAS2-GJAHR AND SGTXT NE SPACE.
         IF SY-SUBRC EQ 0.
           WA_TAS3-SGTXT = BSEG-SGTXT.
         ENDIF.
       ENDIF.

       READ TABLE IT_BSE_CLR INTO WA_BSE_CLR WITH KEY
                     BUKRS_CLR = 'BCLL'
                     BELNR = WA_TAS3-BELNR
                     GJAHR = WA_TAS3-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAS3-BELNR_CLR = WA_BSE_CLR-BELNR_CLR.
         WA_TAS3-GJAHR_CLR = WA_BSE_CLR-GJAHR_CLR.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND BELNR EQ  WA_BSE_CLR-BELNR_CLR AND
           GJAHR EQ WA_BSE_CLR-GJAHR_CLR.
         IF SY-SUBRC EQ 0.
           WA_TAS3-AUGDT = BKPF-BUDAT.
         ENDIF.
       ENDIF.

       IF WA_TAS2-HKONT EQ SPACE.
         IF WA_TAS2-TCODE EQ 'FBCJ'.
         ELSE.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR = WA_TAS2-BELNR AND
             GJAHR = WA_TAS2-GJAHR AND TXGRP = WA_TAS2-TXGRP
             AND KOART EQ 'A'.
           IF SY-SUBRC EQ 0.
             WA_TAS3-HKONT = BSEG-HKONT.
             WA_TAS3-KOSTL = BSEG-KOSTL.
           ELSE.
             SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                AND BELNR = WA_TAS2-BELNR AND GJAHR = WA_TAS2-GJAHR
               AND TXGRP = WA_TAS2-TXGRP AND KTOSL EQ SPACE
               AND KOART NE 'K'.
             IF SY-SUBRC EQ 0.
               WA_TAS3-HKONT = BSEG-HKONT.
               WA_TAS3-KOSTL = BSEG-KOSTL.
             ELSE.
               SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                 AND BELNR = WA_TAS2-BELNR AND GJAHR = WA_TAS2-GJAHR
                 AND KTOSL EQ SPACE AND KOART NE 'K'.
               IF SY-SUBRC EQ 0.
                 WA_TAS3-HKONT = BSEG-HKONT.
                 WA_TAS3-KOSTL = BSEG-KOSTL.
               ENDIF.

             ENDIF.
           ENDIF.
         ENDIF.
       ELSE.
         WA_TAS3-HKONT = WA_TAS2-HKONT.
         WA_TAS3-KOSTL = WA_TAS2-KOSTL.
       ENDIF.
       IF WA_TAS3-KOSTL EQ SPACE.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
           BELNR = WA_TAS2-BELNR AND GJAHR = WA_TAS2-GJAHR
           AND KOSTL NE SPACE.
         IF SY-SUBRC EQ 0.
           WA_TAS3-KOSTL = BSEG-KOSTL.
         ENDIF.
       ENDIF.

       COLLECT WA_TAS3 INTO IT_TAS3.
       CLEAR WA_TAS3.
     ENDIF.
   ENDLOOP.
********************


 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DETAILS1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM DETAILS1 .

   LOOP AT IT_TAS3 INTO WA_TAS3.
     IF R16 NE 'X'.
       IF WA_TAS3-HKONT GE '0000015880' AND
          WA_TAS3-HKONT LE '0000015920'.
          WA_ALV1-TEXT = 'JV PASSED RCM'.
       ELSEIF WA_TAS3-HKONT GE '0000028150' AND
              WA_TAS3-HKONT LE '0000028170'.
              WA_ALV1-TEXT = 'JV PASSED (INELIGIBLE)'.
       ELSE.
         WA_ALV1-TEXT = 'JV PASSED (ELIGIBLE)'.
       ENDIF.
     ELSE.
       WA_ALV1-TEXT = 'COST CENTER ENTRIES'.
     ENDIF.
     WA_ALV1-BUDAT = WA_TAS3-BUDAT.
     WA_ALV1-TCODE = WA_TAS3-TCODE.
     WA_ALV1-USNAM = WA_TAS3-USNAM.
     WA_ALV1-BUPLA = WA_TAS3-BUPLA.
     WA_ALV1-GSBER = WA_TAS3-GSBER.
     WA_ALV1-BELNR = WA_TAS3-BELNR.
     WA_ALV1-BLDAT = WA_TAS3-BLDAT.
     WA_ALV1-XBLNR = WA_TAS3-XBLNR.
     WA_ALV1-VBELN = WA_TAS3-VBELN.
     WA_ALV1-STEUC = WA_TAS3-STEUC.
     WA_ALV1-MENGE = WA_TAS3-MENGE.
     WA_ALV1-MEINS = WA_TAS3-MEINS.
     WA_ALV1-GJAHR = WA_TAS3-GJAHR.
     WA_ALV1-HKONT = WA_TAS3-HKONT.
     WA_ALV1-LIFNR = WA_TAS3-LIFNR.
     WA_ALV1-NAME1 = WA_TAS3-NAME1.
     WA_ALV1-MWSKZ = WA_TAS3-MWSKZ.
     WA_ALV1-DMBTR = WA_TAS3-DMBTR.
     WA_ALV1-HWBAS = WA_TAS3-HWBAS.
     WA_ALV1-HWSTE = WA_TAS3-HWSTE.
     WA_ALV1-IGST = WA_TAS3-IGST.
     WA_ALV1-SGST = WA_TAS3-SGST.
     WA_ALV1-UGST = WA_TAS3-UGST.
     WA_ALV1-CGST = WA_TAS3-CGST.
     WA_ALV1-SIG = WA_TAS3-SIG.
     WA_ALV1-RATE = WA_TAS3-RATE.
     WA_ALV1-CESS = WA_TAS3-CESS.
     WA_ALV1-TDS = WA_TAS3-TDS.
     WA_ALV1-BELNR_CLR = WA_TAS3-BELNR_CLR.
     WA_ALV1-AUGDT = WA_TAS3-AUGDT.
     WA_ALV1-ORT01 = WA_TAS3-ORT01.
     WA_ALV1-VENREG = WA_TAS3-VENREG.
     WA_ALV1-STCD3 = WA_TAS3-STCD3.
     WA_ALV1-SGTXT = WA_TAS3-SGTXT.
     WA_ALV1-SCODE = WA_TAS3-SCODE.
     WA_ALV1-VEN_CL = WA_TAS3-VEN_CL.
     WA_ALV1-PAN = WA_TAS3-PAN.
     WA_ALV1-MBLNR = WA_TAS3-MBLNR.
     WA_ALV1-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
     WA_ALV1-RECP = WA_TAS3-RECP.
     WA_ALV1-RECP_DT = WA_TAS3-RECP_DT.
     WA_ALV1-RSTAT = WA_TAS3-RSTAT.
     WA_ALV1-KOSTL = WA_TAS3-KOSTL.
     COLLECT WA_ALV1 INTO IT_ALV1.
     CLEAR WA_ALV1.

***************************
*     ENDIF.
   ENDLOOP.
***************** IMPORT GOODS *******************************


   SORT IT_ALV1 BY TEXT BELNR.

   WA_FIELDCAT-FIELDNAME = 'TEXT'.
   WA_FIELDCAT-SELTEXT_L = 'TEXT'.
   WA_FIELDCAT-DO_SUM = 'X'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BUDAT'.
   WA_FIELDCAT-SELTEXT_L = 'POSTING DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TCODE'.
   WA_FIELDCAT-SELTEXT_L = 'TCODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'USNAM'.
   WA_FIELDCAT-SELTEXT_L = 'USER'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BUPLA'.
   WA_FIELDCAT-SELTEXT_L = 'BUS.PLACE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'GSBER'.
   WA_FIELDCAT-SELTEXT_L = 'BUS.ARE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BELNR'.
   WA_FIELDCAT-SELTEXT_L = 'DOC NO.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'KOSTL'.
   WA_FIELDCAT-SELTEXT_L = 'COST CENTER'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RSTAT'.
   WA_FIELDCAT-SELTEXT_L = 'REVERSE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BLDAT'.
   WA_FIELDCAT-SELTEXT_L = 'DOCUMENT DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'XBLNR'.
   WA_FIELDCAT-SELTEXT_L = 'BILL NO.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'VBELN'.
   WA_FIELDCAT-SELTEXT_L = 'INVOICE NO.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STEUC'.
   WA_FIELDCAT-SELTEXT_L = 'HSN/SAC CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MENGE'.
   WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MEINS'.
   WA_FIELDCAT-SELTEXT_L = 'UOM'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'GJAHR'.
   WA_FIELDCAT-SELTEXT_L = 'YEAR'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HKONT'.
   WA_FIELDCAT-SELTEXT_L = 'GL CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'LIFNR'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'NAME1'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR NAME'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MWSKZ'.
   WA_FIELDCAT-SELTEXT_L = 'TAX CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'DMBTR'.
   WA_FIELDCAT-SELTEXT_L = 'TOT AMOUNT'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWBAS'.
   WA_FIELDCAT-SELTEXT_L = 'TAXABLE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWSTE'.
   WA_FIELDCAT-SELTEXT_L = 'TAX AMT'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'IGST'.
   WA_FIELDCAT-SELTEXT_L = 'IGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGST'.
   WA_FIELDCAT-SELTEXT_L = 'SGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'UGST'.
   WA_FIELDCAT-SELTEXT_L = 'UGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CGST'.
   WA_FIELDCAT-SELTEXT_L = 'CGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CESS'.
   WA_FIELDCAT-SELTEXT_L = 'CESS'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RATE'.
   WA_FIELDCAT-SELTEXT_L = 'TAX RATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TDS'.
   WA_FIELDCAT-SELTEXT_L = 'TDS AMOUNT'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BELNR_CLR'.
   WA_FIELDCAT-SELTEXT_L = 'CLEARING DOC'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'AUGDT'.
   WA_FIELDCAT-SELTEXT_L = 'CLEARING DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'ORT01'.
   WA_FIELDCAT-SELTEXT_L = 'PLACE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'VENREG'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR REGION'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STCD3'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR GSTN'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGTXT'.
   WA_FIELDCAT-SELTEXT_L = 'TEXT'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SCODE'.
   WA_FIELDCAT-SELTEXT_L = 'STATE CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'VEN_CL'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR CLASS'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'PAN'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR PAN NO.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MBLNR'.
   WA_FIELDCAT-SELTEXT_L = 'INVOICE GRN'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MKPF_BUDAT'.
   WA_FIELDCAT-SELTEXT_L = 'INV GRN DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RECP'.
   WA_FIELDCAT-SELTEXT_L = 'J_1IG_INV'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RECP_DT'.
   WA_FIELDCAT-SELTEXT_L = 'J_1IG_INV DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'WERKS'.
   WA_FIELDCAT-SELTEXT_L = 'PLANT'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   PERFORM SORT CHANGING LI_SORT.

   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'PURCHASE REGISTER FOR FB60 & MIRO'.


   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       IT_SORT                 = LI_SORT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_ALV1
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.


 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TRANSFER1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM TRANSFER1 .
   SELECT * FROM MKPF INTO TABLE IT_MKPF
     WHERE VGART IN ('WE','WF')
     AND BUDAT IN S_BUDAT.
   IF SY-SUBRC EQ 0.
     SELECT * FROM MSEG INTO TABLE IT_MSEG FOR ALL
       ENTRIES IN IT_MKPF WHERE
       MBLNR EQ IT_MKPF-MBLNR AND
       MJAHR EQ IT_MKPF-MJAHR AND
       BWART EQ '102'.

   ENDIF.

   LOOP AT IT_MSEG INTO WA_MSEG.
     READ TABLE IT_MKPF INTO WA_MKPF WITH KEY MBLNR = WA_MSEG-MBLNR.
     IF SY-SUBRC EQ 0.
       SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_MSEG-EBELN
                                      AND BSART EQ 'ZUB'.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM EKPO WHERE EBELN EQ WA_MSEG-EBELN
           AND EBELP EQ WA_MSEG-EBELP
           AND LOEKZ EQ SPACE.
         IF SY-SUBRC EQ 0.
           WA_CANC1-BUDAT = WA_MKPF-BUDAT.
           WA_CANC1-MBLNR = WA_MSEG-MBLNR.
           WA_CANC1-EBELN = WA_MSEG-EBELN.
           WA_CANC1-MJAHR = WA_MSEG-MJAHR.
           WA_CANC1-XBLNR_MKPF = WA_MSEG-XBLNR_MKPF.
           WA_CANC1-SMBLN = WA_MSEG-SMBLN.

           SELECT SINGLE * FROM MSEG WHERE EBELN EQ WA_MSEG-EBELN
             AND EBELP EQ WA_MSEG-EBELP
             AND MBLNR GT WA_MSEG-MBLNR
             AND SMBLN EQ SPACE
             AND BWART EQ '101'.
           IF SY-SUBRC EQ 0.
             WA_CANC1-NMBLNR = MSEG-MBLNR.
             SELECT SINGLE * FROM MKPF WHERE MBLNR EQ MSEG-MBLNR
                AND MJAHR EQ MSEG-MJAHR.
             IF SY-SUBRC EQ 0.
               WA_CANC1-NBUDAT = MKPF-BUDAT.
             ENDIF.
           ENDIF.
           COLLECT WA_CANC1 INTO IT_CANC1.
           CLEAR WA_CANC1.
         ENDIF.
       ENDIF.
     ENDIF.
   ENDLOOP.

   SORT IT_CANC1 BY MBLNR MJAHR EBELN NMBLNR.
   DELETE ADJACENT DUPLICATES FROM IT_CANC1 COMPARING
                        MBLNR MJAHR EBELN NMBLNR.
   IF R15 EQ 'X'.
     PERFORM TRANSFER2.
   ELSE.
     LOOP AT IT_CANC1 INTO WA_CANC1.
       WA_CANC2-BUDAT = WA_CANC1-BUDAT.
       WA_CANC2-MBLNR = WA_CANC1-MBLNR.
       WA_CANC2-NBUDAT = WA_CANC1-NBUDAT.
       WA_CANC2-NMBLNR = WA_CANC1-NMBLNR.
       WA_CANC2-MJAHR = WA_CANC1-MJAHR.
       WA_CANC2-XBLNR_MKPF = WA_CANC1-XBLNR_MKPF.
       WA_CANC2-SMBLN = WA_CANC1-SMBLN.
       WA_CANC2-EBELN = WA_CANC1-EBELN.
       SELECT SINGLE * FROM VBFA WHERE VBELV EQ WA_CANC1-XBLNR_MKPF
                                        AND VBTYP_N EQ 'M'.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM VBRK WHERE VBELN EQ VBFA-VBELN
                         AND FKSTO NE 'X'.
         IF SY-SUBRC EQ 0.
           WA_CANC2-VBELN = VBRK-VBELN.
           WA_CANC2-FKDAT = VBRK-FKDAT.
         ENDIF.
       ENDIF.
       COLLECT WA_CANC2 INTO IT_CANC2 .
       CLEAR WA_CANC2.
     ENDLOOP.
****************** GRL DETAIL *******************************************
     IF IT_CANC2 IS NOT INITIAL.
       SELECT * FROM VBRK INTO TABLE IT_VBRK FOR ALL
         ENTRIES IN IT_CANC2 WHERE
         VBELN EQ IT_CANC2-VBELN.
       IF SY-SUBRC EQ 0.
         SELECT * FROM VBRP INTO TABLE IT_VBRP FOR ALL
           ENTRIES IN IT_VBRK WHERE
           VBELN = IT_VBRK-VBELN.
       ENDIF.
     ENDIF.

     IF IT_VBRK IS NOT INITIAL.
       SELECT KNUMV KPOSN KSCHL KWERT KBETR KAWRT
         FROM KONV INTO TABLE IT_KONV FOR
         ALL ENTRIES IN IT_VBRK WHERE KNUMV = IT_VBRK-KNUMV
         AND KSCHL IN ('JOCG','JOSG','JOIG','JOUG').
     ENDIF.
     SORT IT_KONV BY KNUMV KPOSN KSCHL.
     IF IT_VBRK IS NOT INITIAL.
       LOOP AT IT_VBRP INTO WA_VBRP.
         READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRP-VBELN.
         IF SY-SUBRC EQ 0.
           CLEAR : DOC.
           DOC =  WA_VBRK-VBELN.
           SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
                           AND BLART IN ('RV','EA')
                           AND AWKEY EQ DOC .
           IF SY-SUBRC EQ 0.
             SELECT SINGLE * FROM MARC WHERE
                        MATNR EQ WA_VBRP-MATNR
                    AND WERKS EQ WA_VBRP-WERKS
                    AND STEUC IN HSN.
             IF SY-SUBRC EQ 0.
               WA_INV1-STEUC = MARC-STEUC.
*           endif.
               WA_INV1-BELNR = BKPF-BELNR.
               WA_INV1-GJAHR = BKPF-GJAHR.
               WA_INV1-USNAM = BKPF-USNAM.
               WA_INV1-TCODE = BKPF-TCODE.
               WA_INV1-BUDAT = BKPF-BUDAT.
               WA_INV1-BLDAT = BKPF-BLDAT.
               WA_INV1-BLART = BKPF-BLART.
               SELECT SINGLE * FROM KNVI WHERE
                          KUNNR EQ WA_VBRK-KUNAG AND
                          ALAND EQ 'IN' AND
                          TATYP EQ 'JOCG'.
               IF SY-SUBRC EQ 0.
                 IF KNVI-TAXKD EQ '0'.
                   WA_INV1-VEN_CLASS = KNVI-TAXKD.
                   WA_INV1-VEN_CL = 'Registered'.
                 ENDIF.
               ENDIF.
               SELECT SINGLE * FROM J_1IMOCUST WHERE KUNNR EQ WA_VBRK-KUNAG.
               IF SY-SUBRC EQ 0.
                 WA_INV1-PAN = J_1IMOCUST-J_1IPANNO.
               ENDIF.
               SELECT SINGLE * FROM BSEG WHERE
                         BUKRS EQ '1000' AND
                         BELNR EQ BKPF-BELNR AND
                 GJAHR = BKPF-GJAHR.
               IF SY-SUBRC EQ 0.
                 WA_INV1-GSBER = BSEG-GSBER.
                 WA_INV1-SGTXT = BSEG-SGTXT.
               ENDIF.
               WA_INV1-XBLNR = BKPF-XBLNR.
               WA_INV1-BUPLA = WA_VBRK-REGIO.
               WA_INV1-VBELN = WA_VBRK-VBELN.
               WA_INV1-NETWR = WA_VBRP-NETWR.
               WA_INV1-MWSBP = WA_VBRP-MWSBP.
               WA_INV1-DMBTR = WA_VBRP-NETWR + WA_VBRP-MWSBP.
               WA_INV1-MENGE = WA_VBRP-FKIMG.
               WA_INV1-MEINS = WA_VBRP-VRKME.
               WA_INV1-GSBER = WA_VBRP-GSBER.
***************************************************************************************************
               READ TABLE IT_KONV INTO WA_KONV WITH KEY
                               KNUMV = WA_VBRK-KNUMV
                               KPOSN = WA_VBRP-POSNR
                               KSCHL = 'JOCG' BINARY SEARCH.
               IF SY-SUBRC EQ 0.
                 WA_INV1-JOCG = WA_KONV-KWERT.
                 WA_INV1-TAXABLE = WA_KONV-KAWRT.
                 WA_INV1-RATE =  ( WA_KONV-KBETR / 10 ) * 2.
               ENDIF.
               READ TABLE IT_KONV INTO WA_KONV WITH KEY
                          KNUMV = WA_VBRK-KNUMV
                          KPOSN = WA_VBRP-POSNR
                          KSCHL = 'JOSG' BINARY SEARCH.
               IF SY-SUBRC EQ 0.
                 WA_INV1-JOSG = WA_KONV-KWERT.
                 WA_INV1-TAXABLE = WA_KONV-KAWRT.
               ENDIF.
               READ TABLE IT_KONV INTO WA_KONV WITH KEY
                         KNUMV = WA_VBRK-KNUMV
                         KPOSN = WA_VBRP-POSNR
                         KSCHL = 'JOIG' BINARY SEARCH.
               IF SY-SUBRC EQ 0.
                 WA_INV1-JOIG = WA_KONV-KWERT.
                 WA_INV1-TAXABLE = WA_KONV-KAWRT.
                 WA_INV1-RATE =  WA_KONV-KBETR / 10 .
               ENDIF.
               READ TABLE IT_KONV INTO WA_KONV WITH KEY
                          KNUMV = WA_VBRK-KNUMV
                          KPOSN = WA_VBRP-POSNR
                          KSCHL = 'JOUG' BINARY SEARCH.
               IF SY-SUBRC EQ 0.
                 WA_INV1-JOUG = WA_KONV-KWERT.
                 WA_INV1-TAXABLE = WA_KONV-KAWRT.
               ENDIF.
               WA_INV1-VGBEL = WA_VBRP-VGBEL.
               WA_INV1-AUBEL = WA_VBRP-AUBEL.
               WA_INV1-AUPOS = WA_VBRP-AUPOS.
               SELECT SINGLE * FROM T001W WHERE WERKS EQ WA_VBRP-WERKS.
               IF SY-SUBRC EQ 0.
                 WA_INV1-VENDOR = T001W-KUNNR.
                 WA_INV1-VENDOREG = T001W-REGIO.
                 WA_INV1-NAME1 = T001W-NAME1.
                 WA_INV1-ORT01 = T001W-ORT01.
                 SELECT SINGLE * FROM KNA1 WHERE KUNNR EQ T001W-KUNNR.
                 IF SY-SUBRC EQ 0.
                   WA_INV1-STCD3 = KNA1-STCD3.
                 ENDIF.
               ENDIF.
*                 endif.
               COLLECT WA_INV1 INTO IT_INV1.
               CLEAR WA_INV1.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDLOOP.
     ENDIF.
***************************************
     IF IT_INV1 IS NOT INITIAL.
       LOOP AT IT_INV1 INTO WA_INV1.
         READ TABLE IT_CANC2 INTO WA_CANC2 WITH KEY
                        VBELN = WA_INV1-VBELN.
         IF SY-SUBRC EQ 0.
           WA_TAR1-MBLNR = WA_CANC2-MBLNR.
           WA_TAR1-MKPF_BUDAT = WA_CANC2-BUDAT.
           WA_TAR1-TCODE = WA_INV1-TCODE.
           WA_TAR1-BLART = WA_INV1-BLART.
           WA_TAR1-BELNR = WA_INV1-BELNR.
           WA_TAR1-USNAM = WA_INV1-USNAM.
           WA_TAR1-GJAHR = WA_INV1-GJAHR.
           WA_TAR1-BUDAT = WA_INV1-BUDAT.
           WA_TAR1-BLDAT = WA_INV1-BLDAT.
           WA_TAR1-VBELN = WA_INV1-VBELN.
           WA_TAR1-STEUC = WA_INV1-STEUC.
           WA_TAR1-XBLNR = WA_INV1-XBLNR.
           WA_TAR1-BUPLA = WA_INV1-BUPLA.
           WA_TAR1-GSBER = WA_INV1-GSBER.
           WA_TAR1-VENDOR = WA_INV1-VENDOR.
           WA_TAR1-VENDOREG = WA_INV1-VENDOREG.
           WA_TAR1-DMBTR = WA_INV1-DMBTR.
           WA_TAR1-NETWR = WA_INV1-NETWR.
           WA_TAR1-MWSBP = WA_INV1-MWSBP.
           WA_TAR1-JOIG = WA_INV1-JOIG.
           WA_TAR1-JOSG = WA_INV1-JOSG.
           WA_TAR1-JOCG = WA_INV1-JOCG.
           WA_TAR1-JOUG = WA_INV1-JOUG.
           WA_TAR1-TAXABLE = WA_INV1-TAXABLE.
           WA_TAR1-MENGE = WA_INV1-MENGE.
           WA_TAR1-MEINS = WA_INV1-MEINS.
           WA_TAR1-RATE = WA_INV1-RATE.
           COLLECT WA_TAR1 INTO IT_TAR1.
           CLEAR WA_TAR1.
         ENDIF.
       ENDLOOP.
     ENDIF.

     LOOP AT IT_TAR1 INTO WA_TAR1.
       WA_TAR2-BELNR = WA_TAR1-BELNR.
       WA_TAR2-GJAHR = WA_TAR1-GJAHR.
       WA_TAR2-VBELN = WA_TAR1-VBELN.
       WA_TAR2-STEUC = WA_TAR1-STEUC.
       WA_TAR2-MENGE = WA_TAR1-MENGE * ( - 1 ).
       WA_TAR2-MEINS = WA_TAR1-MEINS.
       WA_TAR2-DMBTR = WA_TAR1-DMBTR * ( - 1 ).
       WA_TAR2-NETWR = WA_TAR1-NETWR * ( - 1 ).
       WA_TAR2-MWSBP = WA_TAR1-MWSBP * ( - 1 ).
       WA_TAR2-JOIG = WA_TAR1-JOIG * ( - 1 ).
       WA_TAR2-JOSG = WA_TAR1-JOSG * ( - 1 ).
       WA_TAR2-JOCG = WA_TAR1-JOCG * ( - 1 ).
       WA_TAR2-JOUG = WA_TAR1-JOUG * ( - 1 ).
       WA_TAR2-RATE = WA_TAR1-RATE.
       WA_TAR2-TAXABLE = WA_TAR1-TAXABLE * ( - 1 ).
       COLLECT WA_TAR2 INTO IT_TAR2.
       CLEAR WA_TAR2.
     ENDLOOP.

     SORT IT_TAR2 BY BELNR STEUC.

     LOOP AT IT_TAR2 INTO WA_TAR2.
       WA_TAR3-BELNR = WA_TAR2-BELNR.
       WA_TAR3-VBELN = WA_TAR2-VBELN.
       WA_TAR3-STEUC = WA_TAR2-STEUC.
       WA_TAR3-MENGE = WA_TAR2-MENGE.
       WA_TAR3-MEINS = WA_TAR2-MEINS.
       WA_TAR3-DMBTR = WA_TAR2-DMBTR.
*  WA_TAR3-,WA_TAR2-NETWR,
       WA_TAR3-HWSTE = WA_TAR2-MWSBP.
       WA_TAR3-HWBAS = WA_TAR2-TAXABLE.
       WA_TAR3-IGST = WA_TAR2-JOIG.
       WA_TAR3-CGST = WA_TAR2-JOCG.
       WA_TAR3-SGST = WA_TAR2-JOSG.
       WA_TAR3-UGST = WA_TAR2-JOUG.
       WA_TAR3-RATE = WA_TAR2-RATE.
       READ TABLE IT_TAR1 INTO WA_TAR1 WITH KEY
               BELNR = WA_TAR2-BELNR
               GJAHR = WA_TAR2-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAR3-TCODE = WA_TAR1-TCODE.
         WA_TAR3-XBLNR = WA_TAR1-XBLNR.
         WA_TAR3-MBLNR = WA_TAR1-MBLNR.
         WA_TAR3-MKPF_BUDAT = WA_TAR1-MKPF_BUDAT.
         WA_TAR3-USNAM = WA_TAR1-USNAM.
         WA_TAR3-BUDAT = WA_TAR1-BUDAT.
         WA_TAR3-BLDAT = WA_TAR1-BLDAT.
         WA_TAR3-XBLNR = WA_TAR1-XBLNR.
         WA_TAR3-BUPLA = WA_TAR1-BUPLA.
         WA_TAR3-BLART = WA_TAR1-BLART.
         WA_TAR3-VENDOR = WA_TAR1-VENDOR.
         WA_TAR3-VENDOREG = WA_TAR1-VENDOREG.
         WA_TAR3-GSBER = WA_TAR1-GSBER.
       ENDIF.
       COLLECT WA_TAR3 INTO IT_TAR3.
       CLEAR WA_TAR3.
     ENDLOOP.

     LOOP AT IT_TAR3 INTO WA_TAR3.
       WA_TAS3-BELNR = WA_TAR3-BELNR.
       WA_TAS3-VBELN = WA_TAR3-VBELN.
       WA_TAS3-STEUC = WA_TAR3-STEUC.
       WA_TAS3-MENGE = WA_TAR3-MENGE.
       WA_TAS3-MEINS = WA_TAR3-MEINS.
       WA_TAS3-DMBTR = WA_TAR3-DMBTR.
       WA_TAS3-HWSTE = WA_TAR3-HWSTE.
       WA_TAS3-HWBAS = WA_TAR3-HWBAS.
       WA_TAS3-IGST = WA_TAR3-IGST.
       WA_TAS3-CGST = WA_TAR3-CGST.
       WA_TAS3-SGST = WA_TAR3-SGST.
       WA_TAS3-UGST = WA_TAR3-UGST.
       WA_TAS3-RATE = WA_TAR3-RATE.

       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_TAR3-BELNR
         AND GJAHR = WA_TAR3-GJAHR
         and HSN_SAC = WA_TAR3-STEUC.
       IF SY-SUBRC EQ 0.
         WA_TAS3-MWSKZ = BSEG-MWSKZ.
       ENDIF.
       WA_TAS3-TCODE = WA_TAR3-TCODE.
       WA_TAS3-GSBER = WA_TAR3-GSBER.
       WA_TAS3-XBLNR = WA_TAR3-XBLNR.
       WA_TAS3-MBLNR = WA_TAR3-MBLNR.
       SELECT SINGLE * FROM MSEG WHERE MBLNR EQ WA_TAR3-MBLNR
                  AND WERKS NE SPACE.
       IF SY-SUBRC EQ 0.
         WA_TAS3-WERKS = MSEG-WERKS.
       ENDIF.
       WA_TAS3-MKPF_BUDAT = WA_TAR3-MKPF_BUDAT.
       WA_TAS3-USNAM = WA_TAR3-USNAM.
       WA_TAS3-BUDAT = WA_TAR3-BUDAT.
       WA_TAS3-BLDAT = WA_TAR3-BLDAT.
       WA_TAS3-XBLNR = WA_TAR3-XBLNR.
       WA_TAS3-BUPLA = WA_TAR3-BUPLA.
       WA_TAS3-BLART = WA_TAR3-BLART.
       WA_TAS3-LIFNR = WA_TAR3-VENDOR.
       SELECT SINGLE * FROM T001W WHERE KUNNR EQ WA_TAR3-VENDOR.
       IF SY-SUBRC EQ 0.
         WA_TAS3-NAME1 = T001W-NAME1.
         WA_TAS3-ORT01 = T001W-ORT01.
         WA_TAS3-VENREG = T001W-REGIO.
       ENDIF.
       SELECT SINGLE * FROM KNA1 WHERE KUNNR EQ WA_TAR3-VENDOR.
       IF SY-SUBRC EQ 0.
         WA_TAS3-STCD3 = KNA1-STCD3.
         WA_TAS3-SCODE = KNA1-STCD3+0(2).

         CLEAR : SCODE.
         SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN'
           AND BLAND EQ WA_TAS3-VENREG.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN'
             AND LAND1 EQ 'IN'
             AND BLAND EQ WA_TAS3-VENREG.
           IF SY-SUBRC EQ 0.
             CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
             WA_TAS3-SCODE = SCODE.
           ENDIF.
         ENDIF.

         SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER EQ KNA1-ADRNR.
         IF SY-SUBRC EQ 0.
           WA_TAS3-ADR1 = ADRC-NAME1.
           WA_TAS3-ADR2 = ADRC-NAME2.
           WA_TAS3-ADR3 = ADRC-NAME3.
           WA_TAS3-ADR4 = ADRC-NAME4.
           WA_TAS3-ADR5 = ADRC-STR_SUPPL1.
           WA_TAS3-ADR6 = ADRC-STR_SUPPL2.
         ENDIF.
         SELECT SINGLE * FROM KNVI WHERE KUNNR EQ WA_TAR3-VENDOR
           AND ALAND EQ 'IN'
           AND TATYP EQ 'JOCG'.
         IF SY-SUBRC EQ 0.
           IF KNVI-TAXKD EQ '0'.
             WA_TAS3-VEN_CLASS = KNVI-TAXKD.
             WA_TAS3-VEN_CL = 'Registered'.
           ENDIF.
         ENDIF.
         SELECT SINGLE * FROM J_1IMOCUST WHERE KUNNR EQ WA_TAR3-VENDOR.
         IF SY-SUBRC EQ 0.
           WA_TAS3-PAN = J_1IMOCUST-J_1IPANNO.
         ENDIF.
       ENDIF.

***************************************
       SELECT SINGLE * FROM VBRK WHERE VBELN EQ WA_TAS3-VBELN.
       IF SY-SUBRC EQ 0.
         IF VBRK-FKDAT+4(2) GE '04'.
           YEAR = VBRK-FKDAT+0(4).
         ELSE.
           YEAR = VBRK-FKDAT+0(4) - 1.
         ENDIF.
       ENDIF.
*    WRITE : / '*',WA_TAB5-VBELN.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
         AND GJAHR EQ YEAR
         AND BLART EQ 'RE'
         AND TCODE IN ( 'J_1IG_INV','MB0A' )
         AND XBLNR EQ WA_TAS3-VBELN.
       IF SY-SUBRC EQ 0.
         WA_TAS3-RECP = BKPF-BELNR.
         WA_TAS3-RECP_DT = BKPF-BUDAT.
         WA_TAS3-RECPYR = BKPF-GJAHR.
       ELSE.
         SELECT SINGLE * FROM VBRK WHERE VBELN = WA_TAS3-VBELN.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
             AND GJAHR EQ YEAR
             AND BLART EQ 'RE'
             AND TCODE IN ( 'J_1IG_INV', 'MB0A' )
             AND XBLNR EQ VBRK-XBLNR.
           IF SY-SUBRC EQ 0.
             WA_TAS3-RECP = BKPF-BELNR.
             WA_TAS3-RECP_DT = BKPF-BUDAT.
             WA_TAS3-RECPYR = BKPF-GJAHR.
           ENDIF.
         ENDIF.
       ENDIF.

       COLLECT WA_TAS3 INTO IT_TAS3.
       CLEAR WA_TAS3.
     ENDLOOP.

     LOOP AT IT_TAS3 INTO WA_TAS3.
*
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_TAS3-BELNR
         AND GJAHR = WA_TAS3-GJAHR
         AND XREVERSAL NE ' '.
       IF SY-SUBRC EQ 0.
         WA_TAS3-RSTAT = 'REVERSED'.
         MODIFY IT_TAS3 FROM WA_TAS3 TRANSPORTING RSTAT.
       ENDIF.
     ENDLOOP.

     LOOP AT IT_TAS3 INTO WA_TAS3.
       WA_TAS4-BELNR = WA_TAS3-BELNR.
       WA_TAS4-GJAHR = WA_TAS3-GJAHR.
       WA_TAS4-TCODE = WA_TAS3-TCODE.
       WA_TAS4-USNAM = WA_TAS3-USNAM.
       WA_TAS4-BUPLA = WA_TAS3-BUPLA.
       WA_TAS4-BLART = WA_TAS3-BLART.
       WA_TAS4-STATUS = WA_TAS3-STATUS.
       WA_TAS4-GSBER = WA_TAS3-GSBER.
       WA_TAS4-BLDAT = WA_TAS3-BLDAT.
       WA_TAS4-BUDAT = WA_TAS3-BUDAT.
       WA_TAS4-GJAHR = WA_TAS3-GJAHR.
       WA_TAS4-DMBTR = WA_TAS3-DMBTR.
       WA_TAS4-MWSKZ = WA_TAS3-MWSKZ.
       WA_TAS4-HWBAS = WA_TAS3-HWBAS.
       WA_TAS4-HWSTE = WA_TAS3-HWSTE.
       WA_TAS4-CESS = WA_TAS3-CESS.
       WA_TAS4-IGST = WA_TAS3-IGST.
       WA_TAS4-SGST = WA_TAS3-SGST.
       WA_TAS4-UGST = WA_TAS3-UGST.
       WA_TAS4-CGST = WA_TAS3-CGST.
       WA_TAS4-SIG = WA_TAS3-SIG.
       WA_TAS4-RATE = WA_TAS3-RATE.
       WA_TAS4-TDS = WA_TAS3-TDS.
       WA_TAS4-BELNR_CLR = WA_TAS3-BELNR_CLR.
       WA_TAS4-AUGDT = WA_TAS3-AUGDT.
       WA_TAS4-XBLNR = WA_TAS3-XBLNR.
       WA_TAS4-VBELN = WA_TAS3-VBELN.
       WA_TAS4-STEUC = WA_TAS3-STEUC.
       WA_TAS4-MENGE = WA_TAS3-MENGE.
       WA_TAS4-MEINS = WA_TAS3-MEINS.
       WA_TAS4-HKONT = WA_TAS3-HKONT.
       WA_TAS4-LIFNR = WA_TAS3-LIFNR.
       WA_TAS4-NAME1 = WA_TAS3-NAME1.
       WA_TAS4-ORT01 = WA_TAS3-ORT01.
       WA_TAS4-VENREG = WA_TAS3-VENREG.
       WA_TAS4-STCD3 = WA_TAS3-STCD3.
       WA_TAS4-SGTXT = WA_TAS3-SGTXT.
       WA_TAS4-SCODE = WA_TAS3-SCODE.
       WA_TAS4-VEN_CL = WA_TAS3-VEN_CL.
       WA_TAS4-PAN = WA_TAS3-PAN.
       WA_TAS4-MBLNR = WA_TAS3-MBLNR.
       WA_TAS4-MKPF_BUDAT = WA_TAS3-MKPF_BUDAT.
       WA_TAS4-RECP = WA_TAS3-RECP.
       WA_TAS4-RECP_DT = WA_TAS3-RECP_DT.
       WA_TAS4-RSTAT = WA_TAS3-RSTAT.

       COLLECT WA_TAS4 INTO IT_TAS4.
       CLEAR WA_TAS4.
     ENDLOOP.

     LOOP AT IT_CANC2 INTO WA_CANC2.
       LOOP AT IT_TAS4 INTO WA_TAS4 WHERE VBELN = WA_CANC2-VBELN.
         WA_CANC3-BUDAT = WA_CANC2-BUDAT.
         WA_CANC3-MBLNR = WA_CANC2-MBLNR.
         WA_CANC3-MJAHR = WA_CANC2-MJAHR.
         WA_CANC3-EBELN = WA_CANC2-EBELN.
         WA_CANC3-XBLNR_MKPF = WA_CANC2-XBLNR_MKPF.
         WA_CANC3-SMBLN = WA_CANC2-SMBLN.
         WA_CANC3-VBELN = WA_CANC2-VBELN.
         WA_CANC3-FKDAT = WA_CANC2-FKDAT.
         WA_CANC3-NMBLNR = WA_CANC2-NMBLNR.
         WA_CANC3-NBUDAT = WA_CANC2-NBUDAT.
         SELECT SINGLE * FROM VBRK WHERE
           VBELN EQ WA_CANC2-VBELN
           AND FKART EQ 'ZSMT'.  "27.11.2019
         IF SY-SUBRC EQ 0.
           WA_CANC3-TEXT = 'G. 2.ITC NOT AVAILABLE ON BR TRF RECEIPT'.
         ELSE.
           WA_CANC3-TEXT = 'G. 1.ITC AVAILABLE ON BR TRF RECEIPT'.
         ENDIF.
         WA_CANC3-BUDAT = WA_TAS4-BUDAT.
         WA_CANC3-TCODE = WA_TAS4-TCODE.
         WA_CANC3-USNAM = WA_TAS4-USNAM.
         WA_CANC3-BUPLA = WA_TAS4-BUPLA.
         WA_CANC3-GSBER = WA_TAS4-GSBER.
         WA_CANC3-BELNR = WA_TAS4-BELNR.
         WA_CANC3-BLDAT = WA_TAS4-BLDAT.
         WA_CANC3-XBLNR = WA_TAS4-XBLNR.
         WA_CANC3-VBELN = WA_TAS4-VBELN.
         WA_CANC3-STEUC = WA_TAS4-STEUC.
         WA_CANC3-MENGE = WA_TAS4-MENGE.
         WA_CANC3-MEINS = WA_TAS4-MEINS.
         WA_CANC3-GJAHR = WA_TAS4-GJAHR.
         WA_CANC3-HKONT = WA_TAS4-HKONT.
         WA_CANC3-LIFNR = WA_TAS4-LIFNR.
         WA_CANC3-NAME1 = WA_TAS4-NAME1.
         WA_CANC3-MWSKZ = WA_TAS4-MWSKZ.
         WA_CANC3-DMBTR = WA_TAS4-DMBTR.
         WA_CANC3-HWBAS = WA_TAS4-HWBAS.
         WA_CANC3-HWSTE = WA_TAS4-HWSTE.
         WA_CANC3-IGST = WA_TAS4-IGST.
         WA_CANC3-SGST = WA_TAS4-SGST.
         WA_CANC3-UGST = WA_TAS4-UGST.
         WA_CANC3-CGST = WA_TAS4-CGST.
         WA_CANC3-SIG = WA_TAS4-SIG.
         WA_CANC3-RATE = WA_TAS4-RATE.
         WA_CANC3-CESS = WA_TAS4-CESS.
         WA_CANC3-TDS = WA_TAS4-TDS.
         WA_CANC3-BELNR_CLR = WA_TAS4-BELNR_CLR.
         WA_CANC3-AUGDT = WA_TAS4-AUGDT.
         WA_CANC3-ORT01 = WA_TAS4-ORT01.
         WA_CANC3-VENREG = WA_TAS4-VENREG.
         WA_CANC3-STCD3 = WA_TAS4-STCD3.
         WA_CANC3-SGTXT = WA_TAS4-SGTXT.
         WA_CANC3-SCODE = WA_TAS4-SCODE.
         WA_CANC3-VEN_CL = WA_TAS4-VEN_CL.
         WA_CANC3-PAN = WA_TAS4-PAN.
         WA_CANC3-MBLNR = WA_TAS4-MBLNR.
         WA_CANC3-MKPF_BUDAT = WA_TAS4-MKPF_BUDAT.
         WA_CANC3-RECP = WA_TAS4-RECP.
         WA_CANC3-RECP_DT = WA_TAS4-RECP_DT.
         WA_CANC3-RSTAT = WA_TAS4-RSTAT.
         COLLECT WA_CANC3 INTO IT_CANC3.
         CLEAR WA_CANC3.
       ENDLOOP.
     ENDLOOP.

***********************************************

     LOOP AT IT_CANC2 INTO WA_CANC2.
       READ TABLE IT_TAS4 INTO WA_TAS4 WITH KEY VBELN = WA_CANC2-VBELN.
       IF SY-SUBRC EQ 4.

         WA_CANC3-BUDAT = WA_CANC2-BUDAT.
         WA_CANC3-MBLNR = WA_CANC2-MBLNR.
         WA_CANC3-MJAHR = WA_CANC2-MJAHR.
         WA_CANC3-EBELN = WA_CANC2-EBELN.
         WA_CANC3-XBLNR_MKPF = WA_CANC2-XBLNR_MKPF.
         WA_CANC3-SMBLN = WA_CANC2-SMBLN.
         WA_CANC3-VBELN = WA_CANC2-VBELN.
         WA_CANC3-FKDAT = WA_CANC2-FKDAT.
         WA_CANC3-NMBLNR = WA_CANC2-NMBLNR.
         WA_CANC3-NBUDAT = WA_CANC2-NBUDAT.
         COLLECT WA_CANC3 INTO IT_CANC3.
         CLEAR WA_CANC3.
       ENDIF.
     ENDLOOP.
******************************************************************

     WA_FIELDCAT-FIELDNAME = 'BUDAT'.
     WA_FIELDCAT-SELTEXT_L = 'REV. GRN DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MBLNR'.
     WA_FIELDCAT-SELTEXT_L = 'REV. GRN'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MJAHR'.
     WA_FIELDCAT-SELTEXT_L = 'REV. GRN YEAR'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'EBELN'.
     WA_FIELDCAT-SELTEXT_L = 'P.O.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'XBLNR_MKPF'.
     WA_FIELDCAT-SELTEXT_L = 'DELIVERY REF.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'SMBLN'.
     WA_FIELDCAT-SELTEXT_L = 'REF GRN'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'VBELN'.
     WA_FIELDCAT-SELTEXT_L = 'INVOICE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'FKDAT'.
     WA_FIELDCAT-SELTEXT_L = 'INV. DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'NMBLNR'.
     WA_FIELDCAT-SELTEXT_L = 'NEW GRN'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'NBUDAT'.
     WA_FIELDCAT-SELTEXT_L = 'NEW GRN DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

*****************************************************
     SORT IT_ALV1 BY TEXT BELNR.

     WA_FIELDCAT-FIELDNAME = 'TEXT'.
     WA_FIELDCAT-SELTEXT_L = 'TEXT'.
     WA_FIELDCAT-DO_SUM = 'X'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BUDAT'.
     WA_FIELDCAT-SELTEXT_L = 'POSTING DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'TCODE'.
     WA_FIELDCAT-SELTEXT_L = 'TCODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'USNAM'.
     WA_FIELDCAT-SELTEXT_L = 'USER'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BUPLA'.
     WA_FIELDCAT-SELTEXT_L = 'BUS.PLACE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'GSBER'.
     WA_FIELDCAT-SELTEXT_L = 'BUS.ARE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BELNR'.
     WA_FIELDCAT-SELTEXT_L = 'DOC NO.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'RSTAT'.
     WA_FIELDCAT-SELTEXT_L = 'REVERSE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BLDAT'.
     WA_FIELDCAT-SELTEXT_L = 'DOCUMENT DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'XBLNR'.
     WA_FIELDCAT-SELTEXT_L = 'BILL NO.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'VBELN'.
     WA_FIELDCAT-SELTEXT_L = 'INVOICE NO.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'STEUC'.
     WA_FIELDCAT-SELTEXT_L = 'HSN/SAC CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MENGE'.
     WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MEINS'.
     WA_FIELDCAT-SELTEXT_L = 'UOM'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'GJAHR'.
     WA_FIELDCAT-SELTEXT_L = 'YEAR'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'HKONT'.
     WA_FIELDCAT-SELTEXT_L = 'GL CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'LIFNR'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'NAME1'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR NAME'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MWSKZ'.
     WA_FIELDCAT-SELTEXT_L = 'TAX CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'DMBTR'.
     WA_FIELDCAT-SELTEXT_L = 'TOT AMOUNT'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'HWBAS'.
     WA_FIELDCAT-SELTEXT_L = 'TAXABLE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'HWSTE'.
     WA_FIELDCAT-SELTEXT_L = 'TAX AMT'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'IGST'.
     WA_FIELDCAT-SELTEXT_L = 'IGST'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'SGST'.
     WA_FIELDCAT-SELTEXT_L = 'SGST'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'UGST'.
     WA_FIELDCAT-SELTEXT_L = 'UGST'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'CGST'.
     WA_FIELDCAT-SELTEXT_L = 'CGST'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'CESS'.
     WA_FIELDCAT-SELTEXT_L = 'CESS'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'RATE'.
     WA_FIELDCAT-SELTEXT_L = 'TAX RATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'TDS'.
     WA_FIELDCAT-SELTEXT_L = 'TDS AMOUNT'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'BELNR_CLR'.
     WA_FIELDCAT-SELTEXT_L = 'CLEARING DOC'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'AUGDT'.
     WA_FIELDCAT-SELTEXT_L = 'CLEARING DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'ORT01'.
     WA_FIELDCAT-SELTEXT_L = 'PLACE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'VENREG'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR REGION'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'STCD3'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR GSTN'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'SGTXT'.
     WA_FIELDCAT-SELTEXT_L = 'TEXT'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'SCODE'.
     WA_FIELDCAT-SELTEXT_L = 'STATE CODE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'VEN_CL'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR CLASS'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'PAN'.
     WA_FIELDCAT-SELTEXT_L = 'VENDOR PAN NO.'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MBLNR'.
     WA_FIELDCAT-SELTEXT_L = 'INVOICE GRN'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'MKPF_BUDAT'.
     WA_FIELDCAT-SELTEXT_L = 'INV GRN DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'RECP'.
     WA_FIELDCAT-SELTEXT_L = 'J_1IG_INV'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'RECP_DT'.
     WA_FIELDCAT-SELTEXT_L = 'J_1IG_INV DATE'.
     APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'WERKS'.
     WA_FIELDCAT-SELTEXT_L = 'PLANT'.
     APPEND WA_FIELDCAT TO FIELDCAT.


*******************************************************

*   PERFORM SORT CHANGING LI_SORT.

     LAYOUT-ZEBRA = 'X'.
     LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
     LAYOUT-WINDOW_TITLEBAR  = 'REVERSED GRN DETAILS'.


     CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
       EXPORTING
         I_CALLBACK_PROGRAM      = G_REPID
         I_CALLBACK_USER_COMMAND = 'USER_COMM'
         I_CALLBACK_TOP_OF_PAGE  = 'TOP'
         IS_LAYOUT               = LAYOUT
         IT_FIELDCAT             = FIELDCAT
         I_SAVE                  = 'A'
       TABLES
         T_OUTTAB                = IT_CANC3
       EXCEPTIONS
         PROGRAM_ERROR           = 1
         OTHERS                  = 2.
     IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
     ENDIF.

   ENDIF.
 ENDFORM.                    "transfer

*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TRANSFER2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM TRANSFER2 .
   SELECT * FROM MKPF INTO TABLE IT_MKPF1 WHERE
     VGART IN ('WE','WF')
     AND BUDAT IN S_BUDAT.
   IF SY-SUBRC EQ 0.
     SELECT * FROM MSEG INTO TABLE IT_MSEG1 FOR ALL
       ENTRIES IN IT_MKPF1 WHERE
       MBLNR EQ IT_MKPF1-MBLNR
       AND MJAHR EQ IT_MKPF1-MJAHR
       AND BWART EQ '101'.
   ENDIF.

   LOOP AT IT_MSEG1 INTO WA_MSEG1.
     READ TABLE IT_MKPF1 INTO WA_MKPF1 WITH KEY MBLNR = WA_MSEG1-MBLNR.
     IF SY-SUBRC EQ 0.
       SELECT SINGLE * FROM EKKO WHERE
         EBELN EQ WA_MSEG1-EBELN
         AND BSART EQ 'ZUB'.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM EKPO WHERE
           EBELN EQ WA_MSEG1-EBELN
           AND EBELP EQ WA_MSEG1-EBELP
           AND LOEKZ EQ SPACE.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM MSEG WHERE
             EBELN EQ WA_MSEG1-EBELN
             AND EBELP EQ WA_MSEG1-EBELP
             AND MBLNR NE WA_MSEG1-MBLNR AND
             SMBLN EQ SPACE
             AND BWART EQ '101'
             AND XBLNR_MKPF = WA_MSEG1-XBLNR_MKPF.
           IF SY-SUBRC EQ 0.
             READ TABLE IT_CANC1 INTO WA_CANC1 WITH KEY MBLNR = MSEG-MBLNR.
             IF SY-SUBRC EQ 4.
               READ TABLE IT_CANC1 INTO WA_CANC1 WITH KEY NMBLNR = MSEG-MBLNR.
               IF SY-SUBRC EQ 4.
                 SELECT SINGLE * FROM MSEG WHERE EBELN EQ WA_MSEG1-EBELN
                   AND EBELP EQ WA_MSEG1-EBELP
                   AND BWART EQ '102'
                   AND XBLNR_MKPF = WA_MSEG1-XBLNR_MKPF.
                 IF SY-SUBRC EQ 4.
                   WA_CANC11-BUDAT = WA_MKPF1-BUDAT.
                   WA_CANC11-MBLNR = WA_MSEG1-MBLNR.
                   WA_CANC11-EBELN = WA_MSEG1-EBELN.
                   WA_CANC11-MJAHR = WA_MSEG1-MJAHR.
                   WA_CANC11-XBLNR_MKPF = WA_MSEG1-XBLNR_MKPF.
                   WA_CANC11-SMBLN = WA_MSEG1-SMBLN.
                   WA_CANC11-NMBLNR = MSEG-MBLNR.
                   SELECT SINGLE * FROM MKPF WHERE MBLNR EQ MSEG-MBLNR
                      AND MJAHR EQ MSEG-MJAHR.
                   IF SY-SUBRC EQ 0.
                     WA_CANC11-NBUDAT = MKPF-BUDAT.
                   ENDIF.
                   COLLECT WA_CANC11 INTO IT_CANC11.
                   CLEAR WA_CANC11.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.
   ENDLOOP.
   SORT IT_CANC11 BY MBLNR MJAHR EBELN NMBLNR.
   DELETE ADJACENT DUPLICATES FROM IT_CANC11 COMPARING
                   MBLNR MJAHR EBELN NMBLNR.

   LOOP AT IT_CANC11 INTO WA_CANC11.
     WA_CANC12-BUDAT = WA_CANC11-BUDAT.
     WA_CANC12-MBLNR = WA_CANC11-MBLNR.
     WA_CANC12-NBUDAT = WA_CANC11-NBUDAT.
     WA_CANC12-NMBLNR = WA_CANC11-NMBLNR.
     WA_CANC12-MJAHR = WA_CANC11-MJAHR.
     WA_CANC12-XBLNR_MKPF = WA_CANC11-XBLNR_MKPF.
     WA_CANC12-SMBLN = WA_CANC11-SMBLN.
     WA_CANC12-EBELN = WA_CANC11-EBELN.
     SELECT SINGLE * FROM VBFA WHERE VBELV EQ WA_CANC11-XBLNR_MKPF
        AND VBTYP_N EQ 'M'.
     IF SY-SUBRC EQ 0.
       SELECT SINGLE * FROM VBRK WHERE VBELN EQ VBFA-VBELN
         AND FKSTO NE 'X'.
       IF SY-SUBRC EQ 0.
         WA_CANC12-VBELN = VBRK-VBELN.
         WA_CANC12-FKDAT = VBRK-FKDAT.
       ENDIF.
     ENDIF.

     COLLECT WA_CANC12 INTO IT_CANC12 .
     CLEAR WA_CANC12.
   ENDLOOP.

   WA_FIELDCAT-FIELDNAME = 'BUDAT'.
   WA_FIELDCAT-SELTEXT_L = 'GRN DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MBLNR'.
   WA_FIELDCAT-SELTEXT_L = 'GRN'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MJAHR'.
   WA_FIELDCAT-SELTEXT_L = 'GRN YEAR'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'EBELN'.
   WA_FIELDCAT-SELTEXT_L = 'P.O.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'XBLNR_MKPF'.
   WA_FIELDCAT-SELTEXT_L = 'DELIVERY REF.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SMBLN'.
   WA_FIELDCAT-SELTEXT_L = 'REF GRN'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'VBELN'.
   WA_FIELDCAT-SELTEXT_L = 'INVOICE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'FKDAT'.
   WA_FIELDCAT-SELTEXT_L = 'INV. DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'NMBLNR'.
   WA_FIELDCAT-SELTEXT_L = 'PARTIAL GRN'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'NBUDAT'.
   WA_FIELDCAT-SELTEXT_L = 'PARTIAL GRN DATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.
   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'PARTIAL GRN DETAILS'.


   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_CANC12
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1_1CC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM FORM1_1CC .


   CLEAR : IT_BKPF,WA_BKPF.
*   IF nskpv = 'X'.
   SELECT * FROM BKPF INTO TABLE IT_BKPF WHERE
     BUDAT IN S_BUDAT AND
     TCODE IN ( 'MIRO','MR8M','FB60', 'FB08',
                'FBCJ','FB01','FB65', 'FB50',
                'FB05', 'FBR2','FBVB','ZBCLLR0001' ) .
   IF SY-SUBRC EQ 0.
     SELECT * FROM BSEG INTO TABLE IT_BSEG FOR ALL
       ENTRIES IN IT_BKPF WHERE BUKRS EQ '1000' AND
       BELNR EQ IT_BKPF-BELNR AND
       GJAHR = IT_BKPF-GJAHR AND
       HSN_SAC IN HSN.
  ENDIF.

   LOOP AT IT_BKPF INTO WA_BKPF.
     IF WA_BKPF-BLART GE 'A1' AND WA_BKPF-BLART LE 'A6'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'B6' AND WA_BKPF-BLART LE 'B9'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'C1' AND WA_BKPF-BLART LE 'D9'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'DA' AND WA_BKPF-BLART LE 'DE'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'F1' AND WA_BKPF-BLART LE 'IA'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'K1' AND WA_BKPF-BLART LE 'K4'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'L1' AND WA_BKPF-BLART LE 'LL'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART GE 'N1' AND WA_BKPF-BLART LE 'NL'.
       DELETE IT_BKPF.
     ENDIF.

     IF WA_BKPF-BUDAT GE NDATE1.
       IF WA_BKPF-BLART GE 'P1' AND WA_BKPF-BLART LE 'PR'.
         DELETE IT_BKPF.
       ENDIF.
       IF WA_BKPF-BLART EQ 'RA'.
         DELETE IT_BKPF.
       ENDIF.
     ELSE.
       IF WA_BKPF-BLART GE 'P1' AND WA_BKPF-BLART LE 'RA'.
         DELETE IT_BKPF.
       ENDIF.
     ENDIF.

     IF WA_BKPF-BLART GE 'U1' AND WA_BKPF-BLART LE 'U4'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'DZ'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'MA'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'ZA'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'S1'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'SA'.
       DELETE IT_BKPF.
     ENDIF.

     IF WA_BKPF-GRPID EQ 'F-51GSTCLR' AND
        WA_BKPF-TCODE EQ 'FB05' AND
        WA_BKPF-BLART EQ 'AB'.
       DELETE IT_BKPF.
     ENDIF.
     IF WA_BKPF-BLART EQ 'AB' AND WA_BKPF-TCODE EQ 'FB01'.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_BKPF-BELNR
         AND GJAHR EQ WA_BKPF-GJAHR
         AND KOART EQ 'D' AND HKONT EQ '0000024160'.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_BKPF-BELNR
           AND GJAHR EQ WA_BKPF-GJAHR
           AND KOART EQ 'K'
           AND HKONT EQ '0000015010'.
         IF SY-SUBRC EQ 0.
           DELETE IT_BKPF.
         ENDIF.
       ENDIF.
     ENDIF.


   ENDLOOP.


   LOOP AT IT_BKPF INTO WA_BKPF.
     IF WA_BKPF-TCODE EQ 'FB08'.
       SELECT SINGLE * FROM BKPF WHERE BELNR EQ WA_BKPF-STBLG
         AND GJAHR EQ WA_BKPF-STJAH
         AND TCODE EQ 'J_1IG_INV'.
       IF SY-SUBRC EQ 0.
         DELETE IT_BKPF WHERE BELNR EQ WA_BKPF-BELNR
         AND GJAHR = WA_BKPF-GJAHR.
       ENDIF.
     ENDIF.
   ENDLOOP.

   LOOP AT IT_BKPF INTO WA_BKPF.
     READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
     BELNR = WA_BKPF-BELNR
     GJAHR = WA_BKPF-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAB1-TCODE = WA_BKPF-TCODE.
       WA_TAB1-BLART = WA_BKPF-BLART.
       WA_TAB1-BELNR = WA_BKPF-BELNR.
       WA_TAB1-AWKEY = WA_BKPF-AWKEY.
       WA_TAB1-GJAHR = WA_BKPF-GJAHR.
       WA_TAB1-BUDAT = WA_BKPF-BUDAT.
       WA_TAB1-BLDAT = WA_BKPF-BLDAT.
       WA_TAB1-XBLNR = WA_BKPF-XBLNR.
       WA_TAB1-GSBER = WA_BSEG-GSBER.
       WA_TAB1-USNAM = WA_BKPF-USNAM.
************  business plave for LLM***********************
*********************************************************

       READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
              BELNR = WA_BKPF-BELNR
              GJAHR = WA_BKPF-GJAHR
              HKONT = '0000015200' .
       IF SY-SUBRC EQ 0.
         WA_TAB1-BUPLA = WA_BSEG-BUPLA.
       ELSE.
         READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
            BELNR = WA_BKPF-BELNR
            GJAHR = WA_BKPF-GJAHR
            HKONT = '0000026050' .
         IF SY-SUBRC EQ 0.
           WA_TAB1-BUPLA = WA_BSEG-BUPLA.
         ELSE.
           READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
           BELNR = WA_BKPF-BELNR
           GJAHR = WA_BKPF-GJAHR
           HKONT = '0000026120'.
           IF SY-SUBRC EQ 0.
             WA_TAB1-BUPLA = WA_BSEG-BUPLA.
           ELSE.
             READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
             BELNR = WA_BKPF-BELNR
             GJAHR = WA_BKPF-GJAHR
             HKONT = '0000040490'.
             IF SY-SUBRC EQ 0.
               WA_TAB1-BUPLA = WA_BSEG-BUPLA.
             ELSE.

***********************************
               READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
               BELNR = WA_BKPF-BELNR
               GJAHR = WA_BKPF-GJAHR
               BUZID = 'T'.
               IF SY-SUBRC EQ 0.
                 WA_TAB1-BUPLA = WA_BSEG-BUPLA.
                 WA_TAB1-GSBER = WA_BSEG-GSBER.
               ELSE.
*****************************************
                 READ TABLE IT_BSEG INTO WA_BSEG WITH KEY
                 BELNR = WA_BKPF-BELNR
                 GJAHR = WA_BKPF-GJAHR.
                 IF SY-SUBRC EQ 0.
                   WA_TAB1-BUPLA = WA_BSEG-BUPLA.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
       IF WA_BKPF-BELNR EQ '0000006510' AND WA_BKPF-GJAHR EQ '2018'.
         WA_TAB1-BUPLA = 'MAH'.
       ENDIF.
***************************************
       DT1+6(2) = '01'.
       DT1+4(2) = '04'.
       DT1+0(4) = '2017'.
       IF S_BUDAT-LOW GE DT1.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR = WA_BKPF-BELNR
           AND GJAHR = WA_BKPF-GJAHR
           AND EBELP NE SPACE.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM EKKO WHERE EBELN EQ BSEG-EBELN
             AND BSART EQ 'ZS'.
           IF SY-SUBRC EQ 0.
             WA_TAB1-BUPLA = 'MAH'.
           ENDIF.
         ENDIF.
       ENDIF.
******************************************
       COLLECT WA_TAB1 INTO IT_TAB1.
       CLEAR WA_TAB1.
*       ENDIF.
*       ENDIF.
     ENDIF.
   ENDLOOP.

   PERFORM TDS.
   PERFORM TOTVALUE.
   IF IT_TAB1 IS NOT INITIAL.
     SELECT * FROM BSET INTO TABLE IT_BSET FOR ALL
       ENTRIES IN IT_TAB1 WHERE BUKRS EQ '1000'
       AND BELNR EQ IT_TAB1-BELNR
       AND GJAHR EQ IT_TAB1-GJAHR.
   ENDIF.

   IF IT_BSET IS NOT INITIAL.
     LOOP AT IT_BSET INTO WA_BSET.
       READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY
                     BELNR = WA_BSET-BELNR
                     GJAHR = WA_BSET-GJAHR.
       IF SY-SUBRC EQ 0.
         IF WA_BSET-SHKZG EQ 'H'.
           WA_BSET-HWSTE = WA_BSET-HWSTE * ( - 1 ).
           WA_BSET-HWBAS = WA_BSET-HWBAS * ( - 1 ).
         ENDIF.
         WA_TAP1-BELNR = WA_TAB1-BELNR.
         WA_TAP1-GJAHR = WA_TAB1-GJAHR.
         WA_TAP1-TXGRP = WA_BSET-TXGRP.
         WA_TAP1-HKONT = SPACE.
         WA_TAP1-BUZEI = WA_BSET-BUZEI.
         WA_TAP1-MWSKZ = WA_BSET-MWSKZ.
         WA_TAP1-TXGRP = WA_BSET-TXGRP.
         IF WA_BSET-KTOSL EQ 'JIC' OR WA_BSET-KTOSL EQ 'JRC'.
           WA_TAP1-CGST = WA_BSET-HWSTE.
           WA_TAP1-HWBAS = WA_BSET-HWBAS.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ELSEIF WA_BSET-KTOSL EQ 'JIS' OR WA_BSET-KTOSL EQ 'JRS'.
           WA_TAP1-SGST = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ELSEIF WA_BSET-KTOSL EQ 'JIU' OR WA_BSET-KTOSL EQ 'JRU'.
           WA_TAP1-UGST = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ELSEIF WA_BSET-KTOSL EQ 'JII' OR WA_BSET-KTOSL EQ 'JRI'.
           IF WA_BSET-MWSKZ NE 'V0'.
             WA_TAP1-IGST = WA_BSET-HWSTE.
             WA_TAP1-HWBAS = WA_BSET-HWBAS.
             WA_TAP1-HWSTE = WA_BSET-HWSTE.
           ENDIF.
         ELSEIF WA_BSET-KTOSL EQ 'JIM'.
           WA_TAP1-IGST = WA_BSET-HWSTE.
           WA_TAP1-HWBAS = WA_BSET-HWBAS.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ELSEIF WA_BSET-KTOSL EQ 'JCI' OR WA_BSET-KTOSL EQ 'JCR'.
           WA_TAP1-CESS = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
***Added by bk on 21.11.2025
          ELSEIF WA_BSET-KSCHL EQ 'JICN'.
           WA_TAP1-CGST = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ELSEIF WA_BSET-KSCHL EQ 'JISN'.
           WA_TAP1-SGST = WA_BSET-HWSTE.
           WA_TAP1-HWBAS = WA_BSET-HWBAS.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
***Added by bk on 21.11.2025
         ELSEIF WA_BSET-KSCHL EQ 'JCRN'.
           WA_TAP1-CGST  = WA_BSET-HWSTE.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.

         ELSEIF WA_BSET-KSCHL EQ 'JSRN'.
           WA_TAP1-SGST  = WA_BSET-HWSTE.
           WA_TAP1-HWBAS = WA_BSET-HWBAS.
           WA_TAP1-HWSTE = WA_BSET-HWSTE.
         ENDIF.

         IF WA_BSET-HWSTE LT 0.
           WA_TAP1-SIG = 'A'. ELSEIF WA_BSET-KSCHL EQ 'JICN'.
         ELSE.
           WA_TAP1-SIG = 'B'.
         ENDIF.
         IF WA_BSET-KTOSL EQ 'JRI' OR WA_BSET-KTOSL EQ 'JRC'.
           READ TABLE IT_BSET INTO WA_BSET WITH KEY
                       BELNR = WA_TAB1-BELNR
                       GJAHR = WA_TAB1-GJAHR
                       TXGRP = WA_TAP1-TXGRP.
           IF SY-SUBRC EQ 0.
             IF WA_TAP1-HWSTE LT 0.
               WA_TAP1-HWBAS = WA_BSET-HWBAS * ( - 1 ).
             ELSE.
               WA_TAP1-HWBAS = WA_BSET-HWBAS.
             ENDIF.
           ENDIF.
         ENDIF.
         WA_TAP1-DMBTR = WA_TAP1-HWBAS + WA_TAP1-HWSTE.
         COLLECT WA_TAP1 INTO IT_TAP1.
         CLEAR WA_TAP1.
       ENDIF.
     ENDLOOP.
   ENDIF.
*   ******   rcm tax********************************

***************************************************
   CLEAR : TTAX,TTAX1.
   IF IT_TAP1 IS NOT INITIAL.
     LOOP AT IT_TAP1 INTO WA_TAP1.
       TTAX = TTAX + WA_TAP1-HWSTE.
       TTAX1 = TTAX1 + WA_TAP1-IGST + WA_TAP1-CGST +
               WA_TAP1-SGST + WA_TAP1-UGST +
               WA_TAP1-CESS.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                      BELNR = WA_TAP1-BELNR
                      GJAHR = WA_TAP1-GJAHR
                      TXGRP = WA_TAP1-TXGRP
                      HKONT = '0000015880'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                  BELNR = WA_TAP1-BELNR
                  GJAHR = WA_TAP1-GJAHR
                  TXGRP = WA_TAP1-TXGRP
                  HKONT = '0000015890'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                      BELNR = WA_TAP1-BELNR
                      GJAHR = WA_TAP1-GJAHR
                      TXGRP = WA_TAP1-TXGRP
                      HKONT = '0000015900'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                      BELNR = WA_TAP1-BELNR
                      GJAHR = WA_TAP1-GJAHR
                      TXGRP = WA_TAP1-TXGRP
                      HKONT = '0000015910'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                               BELNR = WA_TAP1-BELNR
                               GJAHR = WA_TAP1-GJAHR
                               TXGRP = WA_TAP1-TXGRP
                               HKONT = '0000015920'.
       IF SY-SUBRC EQ 0.
         WA_TAP1-STATUS = 'RCM'.
       ENDIF.
       MODIFY IT_TAP1 FROM WA_TAP1 TRANSPORTING STATUS.
       CLEAR WA_TAP1.
     ENDLOOP.
   ENDIF.
*   EXIT.
   IF TTAX NE TTAX1.
     WRITE : / '*************** DIFFERANCE IN TAX **********************'.
   ENDIF.
*   BREAK-POINT  .
   PERFORM INOTAX2.
   PERFORM INOTAX1.
   PERFORM NOTAX1.
   SORT IT_TAB1 BY BELNR GJAHR.

   DELETE ADJACENT DUPLICATES FROM IT_TAB1 COMPARING BELNR GJAHR.

   LOOP AT IT_TAP1 INTO WA_TAP1.
     READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY
     BELNR = WA_TAP1-BELNR
     GJAHR = WA_TAP1-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAP2-BELNR = WA_TAB1-BELNR.
       WA_TAP2-GJAHR = WA_TAB1-GJAHR.
       WA_TAP2-BUPLA = WA_TAB1-BUPLA.
       WA_TAP2-TCODE = WA_TAB1-TCODE.
       WA_TAP2-BLART = WA_TAB1-BLART.
       WA_TAP2-AWKEY = WA_TAB1-AWKEY.
       WA_TAP2-BUDAT = WA_TAB1-BUDAT.
       WA_TAP2-BLDAT = WA_TAB1-BLDAT.
       WA_TAP2-XBLNR = WA_TAB1-XBLNR.
       WA_TAP2-GSBER = WA_TAB1-GSBER.
       WA_TAP2-USNAM = WA_TAB1-USNAM .
       WA_TAP2-TXGRP = WA_TAP1-TXGRP.
       WA_TAP2-HKONT = WA_TAP1-HKONT.
       WA_TAP2-DMBTR = WA_TAP1-DMBTR.
       WA_TAP2-HWBAS = WA_TAP1-HWBAS.
       WA_TAP2-HWSTE = WA_TAP1-HWSTE.
       WA_TAP2-MWSKZ = WA_TAP1-MWSKZ.
       WA_TAP2-BUZEI = WA_TAP1-BUZEI.
       WA_TAP2-IGST = WA_TAP1-IGST.
       WA_TAP2-CGST = WA_TAP1-CGST.
       WA_TAP2-SGST = WA_TAP1-SGST.
       WA_TAP2-UGST = WA_TAP1-UGST.
       WA_TAP2-CESS = WA_TAP1-CESS.
       WA_TAP2-STATUS = WA_TAP1-STATUS.
       IF WA_TAP1-HWSTE LT 0.
         WA_TAP2-SIG = 'A'.
       ELSE.
         WA_TAP2-SIG = 'B'.
       ENDIF.
       COLLECT WA_TAP2 INTO IT_TAP2.
       CLEAR WA_TAP2.
     ENDIF.
   ENDLOOP.
************************* ADDITIONAL*************
   LOOP AT IT_TAPX1 INTO WA_TAPX1.

     READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY
     BELNR = WA_TAPX1-BELNR
     GJAHR = WA_TAPX1-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAP2-BELNR = WA_TAB1-BELNR.
       WA_TAP2-GJAHR = WA_TAB1-GJAHR.
       WA_TAP2-BUPLA = WA_TAB1-BUPLA.
       WA_TAP2-TCODE = WA_TAB1-TCODE.
       WA_TAP2-BLART = WA_TAB1-BLART.
       WA_TAP2-AWKEY = WA_TAB1-AWKEY.
       WA_TAP2-BUDAT = WA_TAB1-BUDAT.
       WA_TAP2-BLDAT = WA_TAB1-BLDAT.
       WA_TAP2-XBLNR = WA_TAB1-XBLNR.
       WA_TAP2-GSBER = WA_TAB1-GSBER.
       WA_TAP2-USNAM = WA_TAB1-USNAM .
       WA_TAP2-TXGRP = WA_TAPX1-TXGRP.
       WA_TAP2-HKONT = WA_TAPX1-HKONT.
*       WA_TAP2-KTOSL = WA_TAPX1-KTOSL.
       WA_TAP2-DMBTR = WA_TAPX1-DMBTR.
       WA_TAP2-HWBAS = WA_TAPX1-HWBAS.
       WA_TAP2-HWSTE = WA_TAPX1-HWSTE.
       WA_TAP2-MWSKZ = WA_TAPX1-MWSKZ.
       WA_TAP2-BUZEI = WA_TAPX1-BUZEI.
       WA_TAP2-IGST = WA_TAPX1-IGST.
       WA_TAP2-CGST = WA_TAPX1-CGST.
       WA_TAP2-SGST = WA_TAPX1-SGST.
       WA_TAP2-UGST = WA_TAPX1-UGST.
       WA_TAP2-CESS = WA_TAPX1-CESS.
       WA_TAP2-STATUS = WA_TAPX1-STATUS.
       IF WA_TAPX1-HWSTE LT 0.
         WA_TAP2-SIG = 'A'.
       ELSE.
         WA_TAP2-SIG = 'B'.
       ENDIF.
       COLLECT WA_TAP2 INTO IT_TAP2.
       CLEAR WA_TAP2.
     ENDIF.
   ENDLOOP.

*************************************

   SORT IT_TAP2 BY GJAHR BELNR TXGRP.
   LOOP AT IT_TAP2 INTO WA_TAP2.
     CLEAR : RATE.
     WA_TAS1-BELNR = WA_TAP2-BELNR.
     WA_TAS1-GJAHR = WA_TAP2-GJAHR.
     WA_TAS1-TXGRP = WA_TAP2-TXGRP.
     WA_TAS1-MWSKZ = WA_TAP2-MWSKZ.
     WA_TAS1-BUZEI = WA_TAP2-BUZEI.
     WA_TAS1-HKONT = WA_TAP2-HKONT.
     WA_TAS1-HWBAS = WA_TAP2-HWBAS.
     WA_TAS1-HWSTE = WA_TAP2-HWSTE.
     WA_TAS1-DMBTR = WA_TAP2-DMBTR.
     WA_TAS1-SGST = WA_TAP2-SGST.
     WA_TAS1-CGST = WA_TAP2-CGST.
     WA_TAS1-IGST = WA_TAP2-IGST.
     WA_TAS1-CESS = WA_TAP2-CESS.
     WA_TAS1-UGST = WA_TAP2-UGST.
     WA_TAS1-SIG = WA_TAP2-SIG.
     WA_TAS1-STATUS = WA_TAP2-STATUS.
     READ TABLE IT_BSET INTO WA_BSET WITH KEY
                    BELNR = WA_TAP2-BELNR
                    GJAHR = WA_TAP2-GJAHR
                    TXGRP = WA_TAP2-TXGRP
                    KTOSL = 'JIC'.
     IF SY-SUBRC EQ 0.
       RATE = ( WA_BSET-KBETR / 10 ) * 2.
     ELSE.
       READ TABLE IT_BSET INTO WA_BSET WITH KEY
                      BELNR = WA_TAP2-BELNR
                      GJAHR = WA_TAP2-GJAHR
                      TXGRP = WA_TAP2-TXGRP.
       IF SY-SUBRC EQ 0.
         RATE = ( WA_BSET-KBETR / 10 ).
       ENDIF.
     ENDIF.
     WA_TAS1-RATE = RATE.
     SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                                 AND BELNR EQ WA_TAP2-BELNR
                                 AND GJAHR = WA_TAP2-GJAHR
                                 AND TXGRP = WA_TAP2-TXGRP AND HSN_SAC NE '          '.
     IF SY-SUBRC EQ 0.
       WA_TAS1-STEUC = BSEG-HSN_SAC.
       WA_TAS1-MENGE = BSEG-MENGE.
       WA_TAS1-MEINS = BSEG-MEINS.
     ELSE.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                            AND BELNR EQ WA_TAP2-BELNR
                            AND GJAHR = WA_TAP2-GJAHR
                            AND TXGRP = WA_TAP2-TXGRP.
       IF SY-SUBRC EQ 0.
         WA_TAS1-MENGE = BSEG-MENGE.
         WA_TAS1-MEINS = BSEG-MEINS.
       ENDIF.
     ENDIF.
     SELECT SINGLE * FROM ZPREGHSN WHERE GJAHR EQ WA_TAP2-GJAHR
                                   AND BELNR EQ WA_TAP2-BELNR
                                   AND BUZEI = WA_TAP2-TXGRP.
     IF SY-SUBRC EQ 0.
       WA_TAS1-STEUC = ZPREGHSN-HSN_SAC.
     ENDIF.
     IF WA_TAP2-HWSTE LT 0.
       WA_TAS1-SIG = 'A'.
     ELSE.
       WA_TAS1-SIG = 'B'.
     ENDIF.
     COLLECT WA_TAS1 INTO IT_TAS1.
     CLEAR WA_TAS1.
   ENDLOOP.
***************  NO TAX********************
   SORT IT_TAS1 BY BELNR GJAHR TXGRP.

   LOOP AT IT_TAS1 INTO WA_TAS1.
     CLEAR : VAL1, VAL2,VAL3,DOC.
     WA_TAS2-GJAHR = WA_TAS1-GJAHR.
     WA_TAS2-BELNR = WA_TAS1-BELNR.
     WA_TAS2-TXGRP = WA_TAS1-TXGRP.
     WA_TAS2-HKONT = WA_TAS1-HKONT.
     WA_TAS2-MWSKZ = WA_TAS1-MWSKZ.
     WA_TAS2-BUZEI = WA_TAS1-BUZEI.
     WA_TAS2-STATUS = WA_TAS1-STATUS.
     WA_TAS2-STEUC = WA_TAS1-STEUC.
     WA_TAS2-MENGE = WA_TAS1-MENGE.
     WA_TAS2-MEINS = WA_TAS1-MEINS.
     WA_TAS2-HWBAS = WA_TAS1-HWBAS.
     WA_TAS2-HWSTE = WA_TAS1-HWSTE.
     WA_TAS2-DMBTR = WA_TAS1-DMBTR.
     WA_TAS2-SGST = WA_TAS1-SGST.
     WA_TAS2-CGST = WA_TAS1-CGST.
     WA_TAS2-UGST = WA_TAS1-UGST.
     WA_TAS2-IGST = WA_TAS1-IGST.
     WA_TAS2-CESS = WA_TAS1-CESS.
     WA_TAS2-SIG = WA_TAS1-SIG.
     WA_TAS2-RATE = WA_TAS1-RATE.

     ON CHANGE OF WA_TAS1-BELNR.
       READ TABLE IT_TDS1 INTO WA_TDS1 WITH KEY
       BELNR = WA_TAS1-BELNR
       GJAHR = WA_TAS1-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAS2-TDS = WA_TDS1-DMBTR.
       ENDIF.
     ENDON.

     READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY
                   BELNR = WA_TAS1-BELNR
                   GJAHR = WA_TAS1-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAS2-TCODE = WA_TAB1-TCODE.
       WA_TAS2-BLART = WA_TAB1-BLART.
       WA_TAS2-AWKEY = WA_TAB1-AWKEY.
       WA_TAS2-BUDAT = WA_TAB1-BUDAT.
       WA_TAS2-BLDAT = WA_TAB1-BLDAT.
       WA_TAS2-XBLNR = WA_TAB1-XBLNR.
       WA_TAS2-GSBER = WA_TAB1-GSBER.
       WA_TAS2-USNAM = WA_TAB1-USNAM.
       WA_TAS2-BUPLA = WA_TAB1-BUPLA.
     ENDIF.
     SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                          AND BELNR = WA_TAS1-BELNR
                          AND GJAHR = WA_TAS1-GJAHR
                          AND KOART EQ 'K'.
     IF SY-SUBRC EQ 0.
       WA_TAS2-LIFNR = BSEG-LIFNR.
       SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ BSEG-LIFNR.
       IF SY-SUBRC EQ 0.
         WA_TAS2-VENREG = LFA1-REGIO.
         WA_TAS2-NAME1 = LFA1-NAME1.
         WA_TAS2-ORT01 = LFA1-ORT01.
         WA_TAS2-STCD3 = LFA1-STCD3.

         IF LFA1-VEN_CLASS EQ ' '.
           WA_TAS2-VEN_CL = 'Registered'.
         ELSEIF LFA1-VEN_CLASS EQ '0'.
           WA_TAS2-VEN_CL = 'Not Registered'.
         ELSEIF LFA1-VEN_CLASS EQ '1'.
           WA_TAS2-VEN_CL = 'Compounding Scheme'.
         ELSEIF LFA1-VEN_CLASS EQ '2'.
           WA_TAS2-VEN_CL = 'Special Economic Zone'.
         ENDIF.
         WA_TAS2-VEN_CLASS = LFA1-VEN_CLASS.
         WA_TAS2-PAN = LFA1-J_1IPANNO.

         CLEAR : SCODE.
         SELECT SINGLE * FROM T005S WHERE LAND1 EQ
                        'IN' AND BLAND EQ WA_TAS2-VENREG.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN'
                           AND LAND1 EQ 'IN' AND
                               BLAND EQ WA_TAS2-VENREG.
           IF SY-SUBRC EQ 0.
             CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
             WA_TAS2-SCODE = SCODE.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.

     IF WA_TAS2-LIFNR EQ '0000000001'.
       SELECT SINGLE * FROM BSEC WHERE BUKRS EQ '1000'
                       AND BELNR EQ WA_TAS1-BELNR
                       AND GJAHR EQ WA_TAS1-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAS2-NAME1 = BSEC-NAME1.
         WA_TAS2-ORT01 = BSEC-ORT01.
         WA_TAS2-VENREG = BSEC-REGIO.
         WA_TAS2-STCD3 = BSEC-STCD3.
         CLEAR : SCODE.
         SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN'
                        AND BLAND EQ WA_TAS2-VENREG.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN'
                        AND LAND1 EQ 'IN' AND BLAND EQ WA_TAS2-VENREG.
           IF SY-SUBRC EQ 0.
             CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
             WA_TAS2-SCODE = SCODE.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.

     READ TABLE IT_BKPF INTO WA_BKPF WITH KEY
                   BELNR = WA_TAS1-BELNR
                   GJAHR = WA_TAS1-GJAHR.
     IF SY-SUBRC EQ 0.
       SELECT SINGLE * FROM RSEG WHERE
                 BELNR EQ WA_BKPF-AWKEY+0(10)
             AND GJAHR EQ WA_BKPF-AWKEY+10(4).
       IF SY-SUBRC EQ 0.
         CONCATENATE RSEG-LFBNR RSEG-LFGJA INTO DOC.
         SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000' AND AWKEY EQ DOC.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR EQ BKPF-BELNR AND GJAHR = BKPF-GJAHR.
           IF SY-SUBRC EQ 0.
             IF WA_TAS2-HKONT EQ SPACE.
               WA_TAS2-HKONT = BSEG-HKONT.
             ENDIF.
             WA_TAS2-KOSTL = BSEG-KOSTL.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.
     COLLECT WA_TAS2 INTO IT_TAS2.
     CLEAR WA_TAS2.
   ENDLOOP.

   SORT IT_TAS2 BY BELNR GJAHR TXGRP.


   IF IT_TAS2 IS NOT INITIAL.
     SELECT * FROM BSE_CLR INTO TABLE IT_BSE_CLR
       FOR ALL ENTRIES IN IT_TAS2
       WHERE BUKRS_CLR EQ 'BCLL' AND
       BUKRS EQ '1000' AND BELNR EQ IT_TAS2-BELNR
       AND GJAHR EQ IT_TAS2-GJAHR.
   ENDIF.
   SORT IT_BSE_CLR DESCENDING BY BELNR_CLR.

   LOOP AT IT_BSE_CLR  INTO WA_BSE_CLR.
     SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
             AND BELNR EQ WA_BSE_CLR-BELNR AND
             GJAHR = WA_BSE_CLR-GJAHR AND XREVERSAL NE SPACE.
     IF SY-SUBRC EQ 0.
       DELETE IT_BSE_CLR WHERE BELNR_CLR EQ BKPF-BELNR
                           AND GJAHR_CLR EQ BKPF-GJAHR.
     ENDIF.
   ENDLOOP.


   LOOP AT IT_TAS2 INTO WA_TAS2 WHERE BUPLA IN BUSPLACE .
     IF WA_TAS2-TCODE EQ 'FBCJ' AND WA_TAS2-LIFNR EQ '0000000001'.

     ELSE.
       WA_TAS3-GJAHR = WA_TAS2-GJAHR.
       WA_TAS3-BELNR = WA_TAS2-BELNR.
       WA_TAS3-TXGRP = WA_TAS2-TXGRP.
       WA_TAS3-MWSKZ = WA_TAS2-MWSKZ.
       WA_TAS3-BUZEI = WA_TAS2-BUZEI.
       WA_TAS3-STATUS = WA_TAS2-STATUS.
       WA_TAS3-STEUC = WA_TAS2-STEUC.
       WA_TAS3-MENGE = WA_TAS2-MENGE.
       WA_TAS3-MEINS = WA_TAS2-MEINS.
       WA_TAS3-HWBAS = WA_TAS2-HWBAS.
       WA_TAS3-HWSTE = WA_TAS2-HWSTE.
       WA_TAS3-DMBTR = WA_TAS2-DMBTR.
       WA_TAS3-SGST = WA_TAS2-SGST.
       WA_TAS3-CGST = WA_TAS2-CGST.
       WA_TAS3-UGST = WA_TAS2-UGST.
       WA_TAS3-IGST = WA_TAS2-IGST.
       WA_TAS3-CESS = WA_TAS2-CESS.
       WA_TAS3-SIG = WA_TAS2-SIG.
       WA_TAS3-RATE = WA_TAS2-RATE.

       WA_TAS3-TDS = WA_TAS2-TDS.
       WA_TAS3-TCODE = WA_TAS2-TCODE.
       WA_TAS3-BLART = WA_TAS2-BLART.
       WA_TAS3-AWKEY = WA_TAS2-AWKEY.
       WA_TAS3-BUDAT = WA_TAS2-BUDAT.
       WA_TAS3-BLDAT = WA_TAS2-BLDAT.
       WA_TAS3-XBLNR = WA_TAS2-XBLNR.
       WA_TAS3-GSBER = WA_TAS2-GSBER.
       WA_TAS3-USNAM = WA_TAS2-USNAM.
       WA_TAS3-BUPLA = WA_TAS2-BUPLA.
       WA_TAS3-LIFNR = WA_TAS2-LIFNR.
       WA_TAS3-VENREG = WA_TAS2-VENREG.
       WA_TAS3-NAME1 = WA_TAS2-NAME1.
       WA_TAS3-ORT01 = WA_TAS2-ORT01.
       WA_TAS3-STCD3 = WA_TAS2-STCD3.
       WA_TAS3-VEN_CLASS = WA_TAS2-VEN_CLASS.
       WA_TAS3-PAN = WA_TAS2-PAN.
       WA_TAS3-VEN_CL = WA_TAS2-VEN_CL.
       WA_TAS3-SCODE = WA_TAS2-SCODE.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                AND BELNR = WA_TAS2-BELNR AND
                    GJAHR = WA_TAS2-GJAHR AND
                    EBELP NE SPACE.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM EKPO WHERE
                   EBELN EQ BSEG-EBELN
               AND EBELP EQ BSEG-EBELP.
         IF SY-SUBRC EQ 0.
           WA_TAS3-WERKS = EKPO-WERKS.
         ENDIF.
       ENDIF.
       SELECT SINGLE * FROM BSEG WHERE
                  BUKRS EQ '1000' AND
                  BELNR = WA_TAS2-BELNR AND
                  GJAHR = WA_TAS2-GJAHR AND
                  TXGRP = WA_TAS2-TXGRP.
       IF SY-SUBRC EQ 0.
         WA_TAS3-SGTXT = BSEG-SGTXT.
       ELSE.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR = WA_TAS2-BELNR AND GJAHR = WA_TAS2-GJAHR.
         IF SY-SUBRC EQ 0.
           WA_TAS3-SGTXT = BSEG-SGTXT.
         ENDIF.
       ENDIF.
       IF WA_TAS3-SGTXT EQ '                    '.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
                       BELNR = WA_TAS2-BELNR AND
                       GJAHR = WA_TAS2-GJAHR AND
                       SGTXT NE SPACE.
         IF SY-SUBRC EQ 0.
           WA_TAS3-SGTXT = BSEG-SGTXT.
         ENDIF.
       ENDIF.
       READ TABLE IT_BSE_CLR INTO WA_BSE_CLR WITH KEY
                BUKRS_CLR = 'BCLL'
                BELNR = WA_TAS3-BELNR
                GJAHR = WA_TAS3-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAS3-BELNR_CLR = WA_BSE_CLR-BELNR_CLR.
         WA_TAS3-GJAHR_CLR = WA_BSE_CLR-GJAHR_CLR.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                         AND BELNR EQ WA_BSE_CLR-BELNR_CLR
                         AND GJAHR EQ WA_BSE_CLR-GJAHR_CLR
                         AND AUGDT NE 0.
         IF SY-SUBRC EQ 0.
           WA_TAS3-AUGDT = BSEG-AUGDT.
         ENDIF.
       ENDIF.

       IF WA_TAS2-HKONT EQ SPACE.
         IF WA_TAS2-TCODE EQ 'FBCJ'.
         ELSE.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                                 AND BELNR = WA_TAS2-BELNR AND
                                     GJAHR = WA_TAS2-GJAHR AND
                                     TXGRP = WA_TAS2-TXGRP AND
                                     KOART EQ 'A'.
           IF SY-SUBRC EQ 0.
             WA_TAS3-HKONT = BSEG-HKONT.
             WA_TAS3-KOSTL = BSEG-KOSTL.
           ELSE.
             SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                                 AND BELNR = WA_TAS2-BELNR AND
                                 GJAHR = WA_TAS2-GJAHR AND
                                 TXGRP = WA_TAS2-TXGRP AND
                                 KTOSL EQ '   '.
             IF SY-SUBRC EQ 0.
               WA_TAS3-HKONT = BSEG-HKONT.
               WA_TAS3-KOSTL = BSEG-KOSTL.
             ENDIF.
           ENDIF.
         ENDIF.
       ELSE.
         WA_TAS3-HKONT = WA_TAS2-HKONT.
         WA_TAS3-KOSTL = WA_TAS2-KOSTL.
       ENDIF.
*       IF WA_TAS3-KOSTL EQ SPACE.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
                     BELNR = WA_TAS2-BELNR
                     AND GJAHR = WA_TAS2-GJAHR
                     AND TXGRP = WA_TAS2-TXGRP
                     AND KOSTL NE SPACE.
       IF SY-SUBRC EQ 0.
         WA_TAS3-KOSTL = BSEG-KOSTL.
       ELSE.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
                           AND BELNR = WA_TAS2-BELNR
                           AND GJAHR = WA_TAS2-GJAHR
                           AND KOSTL NE SPACE.
         IF SY-SUBRC EQ 0.
           WA_TAS3-KOSTL = BSEG-KOSTL.
         ENDIF.
       ENDIF.

       COLLECT WA_TAS3 INTO IT_TAS3.
       CLEAR WA_TAS3.
     ENDIF.
   ENDLOOP.
********************
 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1_12
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM FORM1_12 .

   CLEAR : IT_BKPF,WA_BKPF.
*   IF nskpv = 'X'.
   SELECT * FROM BKPF INTO TABLE IT_BKPF WHERE
     BUDAT IN S_BUDAT AND  TCODE IN ( 'MIRO','MR8M','FB60',
                                      'FB08','FBCJ','FB01',
                                      'FB65', 'FB50', 'FB05',
                                      'FBR2','FBVB','ZBCLLR0001' ) .
*     AND XREVERSAL EQ ' '.
   IF SY-SUBRC EQ 0.
     SELECT * FROM BSEG INTO TABLE IT_BSEG FOR ALL
       ENTRIES IN IT_BKPF WHERE BUKRS EQ '1000' AND
       BELNR EQ IT_BKPF-BELNR AND
       GJAHR = IT_BKPF-GJAHR AND
       HSN_SAC IN HSN.
   ENDIF.

   LOOP AT IT_BKPF INTO WA_BKPF.
     IF WA_BKPF-BLART GE 'J1' AND WA_BKPF-BLART LE 'J9'.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_BKPF-BELNR
         AND GJAHR EQ WA_BKPF-GJAHR
         AND LIFNR NE SPACE.
       IF SY-SUBRC EQ 4.
         MOVE-CORRESPONDING WA_BKPF TO WA_BKPF11.
         COLLECT WA_BKPF11 INTO IT_BKPF11.
         DELETE IT_BKPF.
       ENDIF.
     ENDIF.
   ENDLOOP.

   IF IT_BKPF11 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG11 FOR
       ALL ENTRIES IN IT_BKPF11 WHERE BUKRS EQ '1000'
        and BELNR EQ IT_BKPF11-BELNR
        AND GJAHR = IT_BKPF11-GJAHR
        AND HKONT GE '0000015880'
        AND HKONT LE '0000028300'.
   ENDIF.

   LOOP AT IT_BSEG11 INTO WA_BSEG11.
     IF WA_BSEG11-HKONT GE '0000016010' AND
        WA_BSEG11-HKONT LE '0000027990'.
       DELETE IT_BSEG11 WHERE BELNR = WA_BSEG11-BELNR
       AND GJAHR = WA_BSEG11-GJAHR
       AND HKONT = WA_BSEG11-HKONT.
     ENDIF.
   ENDLOOP.

   LOOP AT IT_BSEG11 INTO WA_BSEG11.
     READ TABLE IT_BKPF11 INTO WA_BKPF11 WITH KEY
     BELNR = WA_BSEG11-BELNR
     GJAHR = WA_BSEG11-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAB1-TCODE = WA_BKPF11-TCODE.
       WA_TAB1-BLART = WA_BKPF11-BLART.
       WA_TAB1-BELNR = WA_BKPF11-BELNR.
       WA_TAB1-AWKEY = WA_BKPF11-AWKEY.
       WA_TAB1-GJAHR = WA_BKPF11-GJAHR.
       WA_TAB1-BUDAT = WA_BKPF11-BUDAT.
       WA_TAB1-BLDAT = WA_BKPF11-BLDAT.
       WA_TAB1-XBLNR = WA_BKPF11-XBLNR.
       WA_TAB1-GSBER = WA_BSEG11-GSBER.
       WA_TAB1-STEUC = WA_BSEG11-HSN_SAC.
       WA_TAB1-MENGE = WA_BSEG11-MENGE.
       WA_TAB1-MEINS = WA_BSEG11-MEINS.
       WA_TAB1-MWSKZ = WA_BSEG11-MWSKZ.
       WA_TAB1-KOSTL = WA_BSEG11-KOSTL.
       IF WA_BSEG11-SHKZG EQ 'H'.
         WA_BSEG11-DMBTR = WA_BSEG11-DMBTR * ( - 1 ).
       ENDIF.
       WA_TAB1-DMBTR = WA_BSEG11-DMBTR.
       IF WA_BSEG11-SHKZG EQ 'H'.
         WA_TAB1-SIG = 'A'.
       ELSE.
         WA_TAB1-SIG = 'B'.
       ENDIF.
       WA_TAB1-HKONT = WA_BSEG11-HKONT.
       WA_TAB1-USNAM = WA_BKPF11-USNAM.
       WA_TAB1-BUPLA = WA_BSEG11-BUPLA.
************  business plave for LLM***********************

*********************************************************


***************************************
*       ******************  business place for LLM  - MAH ALWAYS **********************
       DT1+6(2) = '01'.
       DT1+4(2) = '04'.
       DT1+0(4) = '2017'.
       IF S_BUDAT-LOW GE DT1.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR = WA_BKPF11-BELNR
           AND GJAHR = WA_BKPF11-GJAHR
           AND EBELP NE SPACE.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM EKKO WHERE EBELN EQ BSEG-EBELN AND BSART EQ 'ZS'.
           IF SY-SUBRC EQ 0.
             WA_TAB1-BUPLA = 'MAH'.
           ENDIF.
         ENDIF.
       ENDIF.
******************************************
       COLLECT WA_TAB1 INTO IT_TAB1.
       CLEAR WA_TAB1.
*       ENDIF.
*       ENDIF.
     ENDIF.
   ENDLOOP.

   PERFORM TDS.
   PERFORM TOTVALUE.

   LOOP AT IT_TAB1 INTO WA_TAB1.
     CLEAR : RATE.
     WA_TAS1-BELNR = WA_TAB1-BELNR.
     WA_TAS1-GJAHR = WA_TAB1-GJAHR.
     WA_TAS1-MWSKZ = WA_TAB1-MWSKZ.
     WA_TAS1-HKONT = WA_TAB1-HKONT.
     WA_TAS1-HWBAS = 0.
     WA_TAS1-HWSTE = WA_TAB1-DMBTR.
     WA_TAS1-DMBTR = WA_TAB1-DMBTR.
     IF WA_TAB1-HKONT EQ '0000028010' OR
        WA_TAB1-HKONT EQ '0000028060' OR
        WA_TAB1-HKONT EQ '0000028140' OR
        WA_TAB1-HKONT EQ '0000028150' OR
        WA_TAB1-HKONT EQ '0000028180' OR
        WA_TAB1-HKONT EQ '0000028220' OR
        WA_TAB1-HKONT EQ '0000028270' OR
        WA_TAB1-HKONT EQ '0000015880' .
        WA_TAS1-SGST = WA_TAB1-DMBTR.
     ELSEIF WA_TAB1-HKONT EQ '0000028020' OR
            WA_TAB1-HKONT EQ '0000028070' OR
            WA_TAB1-HKONT EQ '0000028130' OR
            WA_TAB1-HKONT EQ '0000028160' OR
            WA_TAB1-HKONT EQ '0000028190' OR
            WA_TAB1-HKONT EQ '0000028230' OR
            WA_TAB1-HKONT EQ '0000028280' OR
            WA_TAB1-HKONT EQ '0000015890' .
            WA_TAS1-CGST = WA_TAB1-DMBTR.
     ELSEIF WA_TAB1-HKONT EQ '0000028030' OR
            WA_TAB1-HKONT EQ '0000028080' OR
            WA_TAB1-HKONT EQ '0000028100' OR
            WA_TAB1-HKONT EQ '0000028110' OR
            WA_TAB1-HKONT EQ '0000028120' OR
            WA_TAB1-HKONT EQ '0000028170' OR
            WA_TAB1-HKONT EQ '0000028200' OR
            WA_TAB1-HKONT EQ '0000028240' OR
            WA_TAB1-HKONT EQ '0000028290' OR
            WA_TAB1-HKONT EQ '0000015900'.
            WA_TAS1-IGST = WA_TAB1-DMBTR.
     ELSEIF WA_TAB1-HKONT EQ '0000028050' OR
            WA_TAB1-HKONT EQ '0000028210' OR
            WA_TAB1-HKONT EQ '0000028250' OR
            WA_TAB1-HKONT EQ '0000028300' OR
            WA_TAB1-HKONT EQ '0000015920'.
            WA_TAS1-CESS = WA_TAB1-DMBTR.
     ELSEIF WA_TAB1-HKONT EQ '0000028040' OR
            WA_TAB1-HKONT EQ '0000028090' OR
            WA_TAB1-HKONT EQ '0000015910'.
            WA_TAS1-UGST = WA_TAB1-DMBTR.
     ENDIF.
     WA_TAS1-SIG = WA_TAB1-SIG.
     IF WA_TAB1-HKONT GE '0000015880' AND
        WA_TAB1-HKONT LE '0000015920'.
        WA_TAS1-STATUS = 'RCM'.
     ELSE.
       WA_TAS1-STATUS = SPACE.
     ENDIF.
     WA_TAS1-TCODE = WA_TAB1-TCODE.
     WA_TAS1-BLART = WA_TAB1-BLART.
     WA_TAS1-AWKEY = WA_TAB1-AWKEY.
     WA_TAS1-BUDAT = WA_TAB1-BUDAT.
     WA_TAS1-BLDAT = WA_TAB1-BLDAT.
     WA_TAS1-XBLNR = WA_TAB1-XBLNR.
     WA_TAS1-GSBER = WA_TAB1-GSBER.
     WA_TAS1-USNAM = WA_TAB1-USNAM.
     WA_TAS1-BUPLA = WA_TAB1-BUPLA.
     WA_TAS1-SIG = WA_TAB1-SIG.
     WA_TAS1-KOSTL = WA_TAB1-KOSTL.
     COLLECT WA_TAS1 INTO IT_TAS1.
     CLEAR WA_TAS1.
   ENDLOOP.
***************  NO TAX********************
   SORT IT_TAS1 BY BELNR GJAHR TXGRP.
   LOOP AT IT_TAS1 INTO WA_TAS1.
     CLEAR : VAL1, VAL2,VAL3,DOC.
     WA_TAS2-GJAHR = WA_TAS1-GJAHR.
     WA_TAS2-BELNR = WA_TAS1-BELNR.
     WA_TAS2-TXGRP = WA_TAS1-TXGRP.
     WA_TAS2-HKONT = WA_TAS1-HKONT.
     WA_TAS2-MWSKZ = WA_TAS1-MWSKZ.
     WA_TAS2-BUZEI = WA_TAS1-BUZEI.
     WA_TAS2-STATUS = WA_TAS1-STATUS.
     WA_TAS2-STEUC = WA_TAS1-STEUC.
     WA_TAS2-MENGE = WA_TAS1-MENGE.
     WA_TAS2-MEINS = WA_TAS1-MEINS.
     WA_TAS2-HWBAS = WA_TAS1-HWBAS.
     WA_TAS2-HWSTE = WA_TAS1-HWSTE.
     WA_TAS2-DMBTR = WA_TAS1-DMBTR.
     WA_TAS2-SGST = WA_TAS1-SGST.
     WA_TAS2-CGST = WA_TAS1-CGST.
     WA_TAS2-UGST = WA_TAS1-UGST.
     WA_TAS2-IGST = WA_TAS1-IGST.
     WA_TAS2-CESS = WA_TAS1-CESS.
     WA_TAS2-SIG = WA_TAS1-SIG.
     WA_TAS2-RATE = WA_TAS1-RATE.
     WA_TAS2-KOSTL = WA_TAS1-KOSTL.
     WA_TAS2-GSBER = WA_TAS1-GSBER.
     WA_TAS2-BUPLA = WA_TAS1-BUPLA.
     ON CHANGE OF WA_TAS1-BELNR.
       READ TABLE IT_TDS1 INTO WA_TDS1 WITH KEY
               BELNR = WA_TAS1-BELNR
               GJAHR = WA_TAS1-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAS2-TDS = WA_TDS1-DMBTR.
       ENDIF.
     ENDON.
     SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
          AND BELNR = WA_TAS1-BELNR
          AND GJAHR = WA_TAS1-GJAHR
          AND KOART EQ 'K'.
     IF SY-SUBRC EQ 0.
       WA_TAS2-LIFNR = BSEG-LIFNR.
       SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ BSEG-LIFNR.
       IF SY-SUBRC EQ 0.
         WA_TAS2-VENREG = LFA1-REGIO.
         WA_TAS2-NAME1 = LFA1-NAME1.
         WA_TAS2-ORT01 = LFA1-ORT01.
         WA_TAS2-STCD3 = LFA1-STCD3.
         CLEAR : SCODE.
         SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN'
           AND BLAND EQ WA_TAS2-VENREG.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN' AND
               LAND1 EQ 'IN' AND
               BLAND EQ WA_TAS2-VENREG.
           IF SY-SUBRC EQ 0.
             CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
             WA_TAS2-SCODE = SCODE.
           ENDIF.
         ENDIF.
         SELECT SINGLE * FROM J_1IMOVEND WHERE LIFNR EQ BSEG-LIFNR.
         IF SY-SUBRC EQ 0.
           IF J_1IMOVEND-VEN_CLASS EQ ' '.
             WA_TAS2-VEN_CL = 'Registered'.
           ELSEIF J_1IMOVEND-VEN_CLASS EQ '0'.
             WA_TAS2-VEN_CL = 'Not Registered'.
           ELSEIF J_1IMOVEND-VEN_CLASS EQ '1'.
             WA_TAS2-VEN_CL = 'Compounding Scheme'.
           ELSEIF J_1IMOVEND-VEN_CLASS EQ '2'.
             WA_TAS2-VEN_CL = 'Special Economic Zone'.
           ENDIF.
           WA_TAS2-VEN_CLASS = J_1IMOVEND-VEN_CLASS.
           WA_TAS2-PAN = J_1IMOVEND-J_1IPANNO.
         ENDIF.
       ENDIF.
     ENDIF.

     IF WA_TAS2-LIFNR EQ '0000000001'.
       SELECT SINGLE * FROM BSEC WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_TAS1-BELNR
         AND GJAHR EQ WA_TAS1-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAS2-NAME1 = BSEC-NAME1.
         WA_TAS2-ORT01 = BSEC-ORT01.
         WA_TAS2-VENREG = BSEC-REGIO.
         WA_TAS2-STCD3 = BSEC-STCD3.
         CLEAR : SCODE.
         SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN'
           AND BLAND EQ WA_TAS2-VENREG.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN'
             AND LAND1 EQ 'IN'
             AND BLAND EQ WA_TAS2-VENREG.
           IF SY-SUBRC EQ 0.
             CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
             WA_TAS2-SCODE = SCODE.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.
     COLLECT WA_TAS2 INTO IT_TAS2.
     CLEAR WA_TAS2.
   ENDLOOP.

   SORT IT_TAB1 BY GJAHR BELNR.
   IT_BSEG121[] = IT_BSEG11[].
   DELETE IT_BSEG12 WHERE BUPLA EQ SPACE.

   SORT IT_TAS2 BY BELNR GJAHR TXGRP.

   IF IT_TAS2 IS NOT INITIAL.
     SELECT * FROM BSE_CLR INTO TABLE IT_BSE_CLR FOR ALL
       ENTRIES IN IT_TAS2 WHERE BUKRS_CLR EQ 'BCLL'
       AND BUKRS EQ '1000'
       AND BELNR EQ IT_TAS2-BELNR
       AND GJAHR EQ IT_TAS2-GJAHR.
   ENDIF.
   SORT IT_BSE_CLR DESCENDING BY BELNR_CLR.

   LOOP AT IT_BSE_CLR  INTO WA_BSE_CLR.
     SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
       AND BELNR EQ WA_BSE_CLR-BELNR
       AND GJAHR = WA_BSE_CLR-GJAHR AND XREVERSAL NE SPACE.
     IF SY-SUBRC EQ 0.
       DELETE IT_BSE_CLR WHERE BELNR_CLR EQ BKPF-BELNR
       AND GJAHR_CLR EQ BKPF-GJAHR.
     ENDIF.
   ENDLOOP.


   LOOP AT IT_TAS2 INTO WA_TAS2 WHERE BUPLA IN BUSPLACE.
     IF WA_TAS2-TCODE EQ 'FBCJ' AND WA_TAS2-LIFNR EQ '0000000001'.

     ELSE.
       WA_TAS3-GJAHR = WA_TAS2-GJAHR.
       WA_TAS3-BELNR = WA_TAS2-BELNR.
       WA_TAS3-TXGRP = WA_TAS2-TXGRP.
       WA_TAS3-MWSKZ = WA_TAS2-MWSKZ.
       WA_TAS3-BUZEI = WA_TAS2-BUZEI.
       WA_TAS3-STATUS = WA_TAS2-STATUS.
       WA_TAS3-STEUC = WA_TAS2-STEUC.
       WA_TAS3-MENGE = WA_TAS2-MENGE.
       WA_TAS3-MEINS = WA_TAS2-MEINS.
       WA_TAS3-HWBAS = WA_TAS2-HWBAS.
       WA_TAS3-HWSTE = WA_TAS2-HWSTE.
       WA_TAS3-DMBTR = WA_TAS2-DMBTR.

       WA_TAS3-SGST = WA_TAS2-SGST.
       WA_TAS3-CGST = WA_TAS2-CGST.
       WA_TAS3-UGST = WA_TAS2-UGST.
       WA_TAS3-IGST = WA_TAS2-IGST.
       WA_TAS3-CESS = WA_TAS2-CESS.
       WA_TAS3-SIG = WA_TAS2-SIG.
       WA_TAS3-RATE = WA_TAS2-RATE.

       WA_TAS3-TDS = WA_TAS2-TDS.
       WA_TAS3-TCODE = WA_TAS2-TCODE.
       WA_TAS3-BLART = WA_TAS2-BLART.
       WA_TAS3-AWKEY = WA_TAS2-AWKEY.
       WA_TAS3-BUDAT = WA_TAS2-BUDAT.
       WA_TAS3-BLDAT = WA_TAS2-BLDAT.
       WA_TAS3-XBLNR = WA_TAS2-XBLNR.
       WA_TAS3-GSBER = WA_TAS2-GSBER.
       WA_TAS3-USNAM = WA_TAS2-USNAM.
       WA_TAS3-BUPLA = WA_TAS2-BUPLA.
       WA_TAS3-LIFNR = WA_TAS2-LIFNR.
       WA_TAS3-VENREG = WA_TAS2-VENREG.
       WA_TAS3-NAME1 = WA_TAS2-NAME1.
       WA_TAS3-ORT01 = WA_TAS2-ORT01.
       WA_TAS3-STCD3 = WA_TAS2-STCD3.
       WA_TAS3-VEN_CLASS = WA_TAS2-VEN_CLASS.
       WA_TAS3-PAN = WA_TAS2-PAN.
       WA_TAS3-VEN_CL = WA_TAS2-VEN_CL.
       WA_TAS3-SCODE = WA_TAS2-SCODE.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR = WA_TAS2-BELNR
         AND GJAHR = WA_TAS2-GJAHR
         AND EBELP NE SPACE.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM EKPO WHERE EBELN EQ BSEG-EBELN
           AND EBELP EQ BSEG-EBELP.
         IF SY-SUBRC EQ 0.
           WA_TAS3-WERKS = EKPO-WERKS.
         ENDIF.
       ENDIF.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR = WA_TAS2-BELNR
         AND GJAHR = WA_TAS2-GJAHR
         AND TXGRP = WA_TAS2-TXGRP.
       IF SY-SUBRC EQ 0.
         WA_TAS3-SGTXT = BSEG-SGTXT.
       ELSE.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR = WA_TAS2-BELNR
           AND GJAHR = WA_TAS2-GJAHR.
         IF SY-SUBRC EQ 0.
           WA_TAS3-SGTXT = BSEG-SGTXT.
         ENDIF.
       ENDIF.
       IF WA_TAS3-SGTXT EQ '                    '.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR = WA_TAS2-BELNR
           AND GJAHR = WA_TAS2-GJAHR
           AND SGTXT NE SPACE.
         IF SY-SUBRC EQ 0.
           WA_TAS3-SGTXT = BSEG-SGTXT.
         ENDIF.
       ENDIF.

       READ TABLE IT_BSE_CLR INTO WA_BSE_CLR WITH KEY
       BUKRS_CLR = 'BCLL'
       BELNR = WA_TAS3-BELNR
       GJAHR = WA_TAS3-GJAHR.
       IF SY-SUBRC EQ 0.
         WA_TAS3-BELNR_CLR = WA_BSE_CLR-BELNR_CLR.
         WA_TAS3-GJAHR_CLR = WA_BSE_CLR-GJAHR_CLR.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_BSE_CLR-BELNR_CLR
           AND GJAHR EQ WA_BSE_CLR-GJAHR_CLR
           AND AUGDT NE 0.
         IF SY-SUBRC EQ 0.
           WA_TAS3-AUGDT = BSEG-AUGDT.
         ENDIF.
       ENDIF.

       IF WA_TAS2-HKONT EQ SPACE.
         IF WA_TAS2-TCODE EQ 'FBCJ'.

         ELSE.
           SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
             AND BELNR = WA_TAS2-BELNR
             AND GJAHR = WA_TAS2-GJAHR
             AND TXGRP = WA_TAS2-TXGRP
             AND KOART EQ 'A'.
           IF SY-SUBRC EQ 0.
             WA_TAS3-HKONT = BSEG-HKONT.
             WA_TAS3-KOSTL = BSEG-KOSTL.
           ELSE.
             SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND
               BELNR = WA_TAS2-BELNR
               AND GJAHR = WA_TAS2-GJAHR
               AND TXGRP = WA_TAS2-TXGRP
               AND KTOSL EQ '   '.
             IF SY-SUBRC EQ 0.
               WA_TAS3-HKONT = BSEG-HKONT.
               WA_TAS3-KOSTL = BSEG-KOSTL.
             ENDIF.
           ENDIF.
         ENDIF.
       ELSE.
         WA_TAS3-HKONT = WA_TAS2-HKONT.
         WA_TAS3-KOSTL = WA_TAS2-KOSTL.
       ENDIF.
*       IF WA_TAS3-KOSTL EQ SPACE.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR = WA_TAS2-BELNR
         AND GJAHR = WA_TAS2-GJAHR
         AND TXGRP = WA_TAS2-TXGRP
         AND KOSTL NE SPACE.
       IF SY-SUBRC EQ 0.
         WA_TAS3-KOSTL = BSEG-KOSTL.
       ELSE.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR = WA_TAS2-BELNR
           AND GJAHR = WA_TAS2-GJAHR
           AND KOSTL NE SPACE.
         IF SY-SUBRC EQ 0.
           WA_TAS3-KOSTL = BSEG-KOSTL.
         ENDIF.
       ENDIF.

       COLLECT WA_TAS3 INTO IT_TAS3.
       CLEAR WA_TAS3.
     ENDIF.
   ENDLOOP.
********************
 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DETAILHS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM DETAILHS .
   LOOP AT IT_ALV1 INTO WA_ALV1.
     WA_HS1-BUPLA = WA_ALV1-BUPLA.
     WA_HS1-STEUC = WA_ALV1-STEUC.
     WA_HS1-MENGE = WA_ALV1-MENGE.
     WA_HS1-MEINS = WA_ALV1-MEINS.
     WA_HS1-HWBAS = WA_ALV1-HWBAS.
     WA_HS1-RATE = WA_ALV1-RATE.
     IF WA_ALV1-TEXT EQ 'B. RCM LIABILITY' OR
        WA_ALV1-TEXT EQ 'M. RCM LIABILITY ON IMPORT OF SERVICES' or
        WA_ALV1-TEXT EQ 'T. JV PASSED (RCM LIABILITY)' OR
        WA_ALV1-TEXT EQ 'N. JV PASSED RCM LIABILITY'.
     ELSE.
       WA_HS1-HWBAS1 = WA_ALV1-HWBAS.
     ENDIF.
     WA_HS1-IGST = WA_ALV1-IGST.
     WA_HS1-SGST = WA_ALV1-SGST.
     WA_HS1-CGST = WA_ALV1-CGST.
     WA_HS1-UGST = WA_ALV1-UGST.
     WA_HS1-CESS = WA_ALV1-CESS.
     WA_HS1-RATE = WA_ALV1-RATE.
     COLLECT WA_HS1 INTO IT_HS1.
     CLEAR WA_HS1.
   ENDLOOP.

   LOOP AT IT_HS1 INTO WA_HS1.
     WA_HS2-BUPLA = WA_HS1-BUPLA.
     WA_HS2-STEUC = WA_HS1-STEUC.
     WA_HS2-MENGE = WA_HS1-MENGE.
     WA_HS2-MEINS = WA_HS1-MEINS.
     WA_HS2-RATE = WA_HS1-RATE.
     WA_HS2-HWBAS1 = WA_HS1-HWBAS1.
     WA_HS2-IGST = WA_HS1-IGST.
     WA_HS2-SGST = WA_HS1-SGST.
     WA_HS2-CGST = WA_HS1-CGST.
     WA_HS2-UGST = WA_HS1-UGST.
     WA_HS2-CESS = WA_HS1-CESS.
     COLLECT WA_HS2 INTO IT_HS2.
     CLEAR WA_HS2.
   ENDLOOP.

   WA_FIELDCAT-FIELDNAME = 'BUPLA'.
   WA_FIELDCAT-SELTEXT_L = 'BUS. PLACE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STEUC'.
   WA_FIELDCAT-SELTEXT_L = 'HSN/SAC'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MEINS'.
   WA_FIELDCAT-SELTEXT_L = 'UOM'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'MENGE'.
   WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWBAS1'.
   WA_FIELDCAT-SELTEXT_L = 'TAXABLE VALUE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RATE'.
   WA_FIELDCAT-SELTEXT_L = 'RATE OF TAX'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'IGST'.
   WA_FIELDCAT-SELTEXT_L = 'IGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CGST'.
   WA_FIELDCAT-SELTEXT_L = 'CGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGST'.
   WA_FIELDCAT-SELTEXT_L = 'SGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'UGST'.
   WA_FIELDCAT-SELTEXT_L = 'UGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CESS'.
   WA_FIELDCAT-SELTEXT_L = 'CESS'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'PURCHASE REGISTER FOR FB60 & MIRO'.

   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_HS2
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.



 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NONTAXGL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM NONTAXGL .
   LOOP AT IT_TAP1 INTO WA_TAP1.
     WA_TAK1-BELNR = WA_TAP1-BELNR.
     WA_TAK1-GJAHR = WA_TAP1-GJAHR.
     WA_TAK1-HWSTE = WA_TAP1-HWSTE.
     IF WA_TAP1-HWSTE LT 0.
       WA_TAK1-SIGN = 'A'.
     ENDIF.
     COLLECT WA_TAK1 INTO IT_TAK1.
     CLEAR WA_TAK1.
   ENDLOOP.
   SORT IT_TAK1 BY BELNR.
   LOOP AT IT_TAK1 INTO WA_TAK1.

     IF WA_TAK1-HWSTE LT 0 OR WA_TAK1-HWSTE GT 0.
       WA_TAK2-BELNR = WA_TAK1-BELNR.
       WA_TAK2-GJAHR = WA_TAK1-GJAHR.
       WA_TAK2-HWSTE = WA_TAK1-HWSTE.
       WA_TAK2-SIGN = WA_TAK1-SIGN.
       COLLECT WA_TAK2 INTO IT_TAK2.
       CLEAR WA_TAK2.
     ENDIF.
   ENDLOOP.
   LOOP AT IT_TAK1 INTO WA_TAK1.
     READ TABLE IT_TAK2 INTO WA_TAK2 WITH KEY
     BELNR = WA_TAK1-BELNR
     GJAHR = WA_TAK1-GJAHR.
     IF SY-SUBRC EQ 4.
       WA_TAK3-BELNR = WA_TAK1-BELNR.
       WA_TAK3-GJAHR = WA_TAK1-GJAHR.
       WA_TAK3-HWSTE = WA_TAK1-HWSTE.
       WA_TAK3-SIGN = WA_TAK1-SIGN.
       COLLECT WA_TAK3 INTO IT_TAK3.
       CLEAR WA_TAK3.
     ENDIF.
   ENDLOOP.

   SORT IT_TAK3 BY BELNR GJAHR.
   DELETE ADJACENT DUPLICATES FROM IT_TAK3 COMPARING BELNR GJAHR.
   IF IT_TAK3 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG13 FOR ALL
       ENTRIES IN IT_TAK3 WHERE BUKRS EQ '1000' AND
       BELNR EQ IT_TAK3-BELNR AND
       GJAHR = IT_TAK3-GJAHR.
   ENDIF.

   LOOP AT IT_BSEG13 INTO WA_BSEG13 WHERE DMBTR NE 0.
     IF ( WA_BSEG13-HKONT GE '0000028010' AND
          WA_BSEG13-HKONT LE '0000028300' ) OR
        ( WA_BSEG13-HKONT GE '0000015880' AND
          WA_BSEG13-HKONT LE '0000015920' ).

       WA_TAK4-BELNR = WA_BSEG13-BELNR.
       WA_TAK4-GJAHR = WA_BSEG13-GJAHR.
       WA_TAK4-MWSKZ = WA_BSEG13-MWSKZ.
       WA_TAK4-TXGRP = WA_BSEG13-TXGRP.
       IF WA_BSEG13-SHKZG EQ 'H'.
         WA_BSEG13-DMBTR = WA_BSEG13-DMBTR * ( - 1 ).
       ENDIF.

       WA_TAK4-DMBTR = WA_BSEG13-DMBTR.

       IF WA_BSEG13-HKONT EQ '0000028010' OR
          WA_BSEG13-HKONT EQ '0000015880' OR
          WA_BSEG13-HKONT EQ '0000028060' OR
          WA_BSEG13-HKONT EQ '0000028150'.
         WA_TAK4-SGST = WA_BSEG13-DMBTR.
         WA_TAK4-HWBAS = WA_BSEG13-DMBTR.
         WA_TAK4-HKONT = WA_BSEG13-HKONT.
         WA_TAK4-HWSTE = WA_BSEG13-DMBTR.
       ELSEIF WA_BSEG13-HKONT EQ '0000028020' OR
              WA_BSEG13-HKONT EQ '0000015890' OR
              WA_BSEG13-HKONT EQ '0000028070' OR
              WA_BSEG13-HKONT EQ '0000028160'.
         WA_TAK4-CGST = WA_BSEG13-DMBTR.
         WA_TAK4-HWBAS = WA_BSEG13-DMBTR.
         WA_TAK4-HKONT = WA_BSEG13-HKONT.
         WA_TAK4-HWSTE = WA_BSEG13-DMBTR.
       ELSEIF WA_BSEG13-HKONT EQ '0000028030' OR
              WA_BSEG13-HKONT EQ '0000015900' OR
              WA_BSEG13-HKONT EQ '0000028080' OR
              WA_BSEG13-HKONT EQ '0000028100' or
              WA_BSEG13-HKONT EQ '0000028110' OR
              WA_BSEG13-HKONT EQ '0000028170'.
         WA_TAK4-IGST = WA_BSEG13-DMBTR.
         WA_TAK4-HWBAS = WA_BSEG13-DMBTR.
         WA_TAK4-HKONT = WA_BSEG13-HKONT.
         WA_TAK4-HWSTE = WA_BSEG13-DMBTR.
       ELSEIF WA_BSEG13-HKONT EQ '0000028040' OR
              WA_BSEG13-HKONT EQ '0000015910' OR
              WA_BSEG13-HKONT EQ '0000028090'.
         WA_TAK4-UGST = WA_BSEG13-DMBTR.
         WA_TAK4-HKONT = WA_BSEG13-HKONT.
         WA_TAK4-HWSTE = WA_BSEG13-DMBTR.
       ELSEIF WA_BSEG13-HKONT EQ '0000028050' OR
              WA_BSEG13-HKONT EQ '0000015920'.
         WA_TAK4-CESS = WA_BSEG13-DMBTR.
         WA_TAK4-HKONT = WA_BSEG13-HKONT.
         WA_TAK4-HWSTE = WA_BSEG13-DMBTR.
       ENDIF.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_BSEG13-BELNR
         AND GJAHR = WA_BSEG13-GJAHR
         and HKONT GE '0000015880'
         AND HKONT LE '0000015920'.
       IF SY-SUBRC EQ 0.
         WA_TAK4-STATUS = 'RCM'.
       ENDIF.
       COLLECT WA_TAK4 INTO IT_TAK4.
       CLEAR WA_TAK4.
     ENDIF.
   ENDLOOP.
 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DETAILJV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM DETAILJV .

   LOOP AT IT_BSEG11 INTO WA_BSEG11.
     READ TABLE IT_BKPF11 INTO WA_BKPF11 WITH KEY
     BELNR = WA_BSEG11-BELNR
     GJAHR = WA_BSEG11-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAB1-BELNR = WA_BKPF11-BELNR.
       WA_TAB1-GJAHR = WA_BKPF11-GJAHR.
       COLLECT WA_TAB1 INTO IT_TAB1.
       CLEAR WA_TAB1.
     ENDIF.
   ENDLOOP.
   SORT IT_TAB1 BY BELNR GJAHR.
   DELETE ADJACENT DUPLICATES FROM IT_TAB1 COMPARING
                       BELNR GJAHR.
   IF IT_TAB1 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG12 FOR ALL
       ENTRIES IN IT_TAB1 WHERE BUKRS EQ '1000'
       AND BELNR EQ IT_TAB1-BELNR
       AND GJAHR = IT_TAB1-GJAHR.
   ENDIF.

   LOOP AT IT_BSEG12 INTO WA_BSEG12.
     READ TABLE IT_BKPF11 INTO WA_BKPF11 WITH KEY
     BELNR = WA_BSEG12-BELNR
     GJAHR = WA_BSEG12-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_TAB2-TCODE = WA_BKPF11-TCODE.
       WA_TAB2-BLART = WA_BKPF11-BLART.
       WA_TAB2-BELNR = WA_BKPF11-BELNR.
       WA_TAB2-GJAHR = WA_BKPF11-GJAHR.
       WA_TAB2-BUDAT = WA_BKPF11-BUDAT.
       WA_TAB2-BLDAT = WA_BKPF11-BLDAT.
       WA_TAB2-XBLNR = WA_BKPF11-XBLNR.
       WA_TAB2-GSBER = WA_BSEG12-GSBER.
       WA_TAB2-MENGE = WA_BSEG12-MENGE.
       WA_TAB2-MEINS = WA_BSEG12-MEINS.
       IF WA_BSEG12-SHKZG EQ 'H'.
         WA_BSEG12-DMBTR = WA_BSEG12-DMBTR * ( - 1 ).
       ENDIF.
       WA_TAB2-DMBTR = WA_BSEG12-DMBTR.
       IF WA_BSEG12-SHKZG EQ 'H'.
         WA_TAB2-SIG = 'A'.
       ELSE.
         WA_TAB2-SIG = 'B'.
       ENDIF.
       WA_TAB2-HKONT = WA_BSEG12-HKONT.
       WA_TAB2-USNAM = WA_BKPF11-USNAM.
       WA_TAB2-BUPLA = WA_BSEG12-BUPLA.
************  business plave for LLM***********************

       DT1+6(2) = '01'.
       DT1+4(2) = '04'.
       DT1+0(4) = '2017'.
       IF S_BUDAT-LOW GE DT1.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR = WA_BKPF11-BELNR
           AND GJAHR = WA_BKPF11-GJAHR
           AND EBELP NE SPACE.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM EKKO WHERE EBELN EQ BSEG-EBELN AND BSART EQ 'ZS'.
           IF SY-SUBRC EQ 0.

             WA_TAB2-BUPLA = 'MAH'.

           ENDIF.
         ENDIF.
       ENDIF.
******************************************

       COLLECT WA_TAB2 INTO IT_TAB2.
       CLEAR WA_TAB2.
*       ENDIF.
*       ENDIF.
     ENDIF.
   ENDLOOP.

   SORT IT_TAB2 BY BELNR GJAHR HKONT.
   LOOP AT IT_TAB2 INTO WA_TAB2 WHERE BUPLA IN BUSPLACE.
     WA_TAB3-BELNR = WA_TAB2-BELNR.
     WA_TAB3-GJAHR = WA_TAB2-GJAHR.
     WA_TAB3-HKONT = WA_TAB2-HKONT.
     WA_TAB3-DMBTR = WA_TAB2-DMBTR.
     WA_TAB3-GSBER = WA_TAB2-GSBER.
     WA_TAB3-BUPLA = WA_TAB2-BUPLA.
     COLLECT WA_TAB3 INTO IT_TAB3.
     CLEAR WA_TAB3.
   ENDLOOP.

   WA_FIELDCAT-FIELDNAME = 'BELNR'.
   WA_FIELDCAT-SELTEXT_L = 'DOC NO.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'GJAHR'.
   WA_FIELDCAT-SELTEXT_L = 'YEAR'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HKONT'.
   WA_FIELDCAT-SELTEXT_L = 'GL CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'DMBTR'.
   WA_FIELDCAT-SELTEXT_L = 'VALUE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'GSBER'.
   WA_FIELDCAT-SELTEXT_L = 'BUS. AREA'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BUPLA'.
   WA_FIELDCAT-SELTEXT_L = 'BUS. PLACE'.
   APPEND WA_FIELDCAT TO FIELDCAT.



   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'PURCHASE REGISTER FOR LEFT DOCUMENT DETAILS'.

   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       IT_SORT                 = LI_SORT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_TAB3
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  IMPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM IMPORT .
***************** IMPORT GOODS *******************************

   SELECT * FROM BKPF INTO TABLE IT_BKPF WHERE
     BUDAT IN S_BUDAT
     AND  TCODE IN ( 'MIRO','MR8M' ) .
   IF SY-SUBRC EQ 0.
     SELECT * FROM BSEG INTO TABLE IT_BSEG
       FOR ALL ENTRIES IN IT_BKPF WHERE
       BUKRS EQ '1000' AND
       BELNR EQ IT_BKPF-BELNR AND GJAHR = IT_BKPF-GJAHR .
   ENDIF.
   IF IT_BKPF IS INITIAL.
     MESSAGE ' NO DATA' TYPE 'E'.
     EXIT.
   ENDIF.

   LOOP AT IT_BSEG INTO WA_BSEG.
     IF WA_BSEG-LIFNR GE '0000020000' AND
        WA_BSEG-LIFNR LE '0000029999'.
       WA_IMP1-BELNR  = WA_BSEG-BELNR.
       WA_IMP1-GJAHR  = WA_BSEG-GJAHR.
       COLLECT WA_IMP1 INTO IT_IMP1.
       CLEAR WA_IMP1.
     ENDIF.
*    ENDIF.
   ENDLOOP.

   IF IT_IMP1 IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG1 FOR ALL
       ENTRIES IN IT_IMP1 WHERE BELNR EQ IT_IMP1-BELNR
       AND GJAHR EQ IT_IMP1-GJAHR
       AND EBELN NE SPACE.
   ENDIF.

   LOOP AT IT_BSEG1 INTO WA_BSEG1.
*    WRITE: / 'a',WA_BSEG1-belnr,WA_BSEG1-gjahr.
     WA_IMP2-EBELN = WA_BSEG1-EBELN.
     WA_IMP2-EBELP = WA_BSEG1-EBELP.
     COLLECT WA_IMP2 INTO IT_IMP2.
     CLEAR WA_IMP2.
   ENDLOOP.

   IF IT_IMP2 IS NOT INITIAL.
     SELECT * FROM RSEG INTO TABLE IT_RSEG FOR ALL
        ENTRIES IN IT_IMP2 WHERE
        EBELN EQ IT_IMP2-EBELN AND
        EBELP EQ IT_IMP2-EBELP.
   ENDIF.
   IF IT_RSEG IS NOT INITIAL.
     LOOP AT IT_RSEG INTO WA_RSEG.
       CLEAR : AWKEY.

       CONCATENATE WA_RSEG-BELNR WA_RSEG-GJAHR INTO AWKEY.
       SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
           AND GJAHR EQ WA_RSEG-GJAHR
           AND BUDAT IN S_BUDAT
           AND AWKEY EQ AWKEY.
       IF SY-SUBRC EQ 0.
         IF WA_RSEG-SHKZG EQ 'H'.
           WA_RSEG-WRBTR = WA_RSEG-WRBTR * ( - 1 ).
         ENDIF.
         WA_IMP3-BELNR = WA_RSEG-BELNR.
         WA_IMP3-GJAHR = WA_RSEG-GJAHR.
         WA_IMP3-LIFNR = WA_RSEG-LIFNR.
         WA_IMP3-STEUC = WA_RSEG-HSN_SAC.
         WA_IMP3-FIDOC = BKPF-BELNR.
         WA_IMP3-FIYEAR = BKPF-GJAHR.
         WA_IMP3-BUDAT = BKPF-BUDAT.
         WA_IMP3-TCODE = BKPF-TCODE.
         WA_IMP3-EBELN = WA_RSEG-EBELN.
         WA_IMP3-EBELP = WA_RSEG-EBELP.
         IF WA_RSEG-LIFNR EQ SPACE.
           SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_RSEG-EBELN.
           IF SY-SUBRC EQ 0.
*          WRITE : EKKO-LIFNR.
             WA_IMP3-LIFNR = EKKO-LIFNR.
           ENDIF.
         ENDIF.
         COLLECT WA_IMP3 INTO IT_IMP3.
         CLEAR WA_IMP3.
       ENDIF.
     ENDLOOP.
   ENDIF.

   SELECT * FROM BSET INTO TABLE IT_BSET FOR ALL
     ENTRIES IN IT_IMP3 WHERE BUKRS EQ '1000'
     AND BELNR EQ IT_IMP3-FIDOC
     AND GJAHR EQ IT_IMP3-GJAHR
     AND HWSTE GT 0.
   IF IT_BSET IS NOT INITIAL.
     LOOP AT IT_BSET INTO WA_BSET.
       IF WA_BSET-SHKZG EQ 'H'.
         WA_BSET-HWSTE = WA_BSET-HWSTE * ( - 1 ).
         WA_BSET-HWBAS = WA_BSET-HWBAS * ( - 1 ).
       ENDIF.
       WA_IMP4-BELNR = WA_BSET-BELNR.
       WA_IMP4-GJAHR = WA_BSET-GJAHR.
       WA_IMP4-HWBAS = WA_BSET-HWBAS.
       WA_IMP4-HWSTE = WA_BSET-HWSTE.
       WA_IMP4-KTOSL = WA_BSET-KTOSL.
       WA_IMP4-KBETR = WA_BSET-KBETR.
       WA_IMP4-BUPLA = WA_BSET-BUPLA.
       COLLECT WA_IMP4 INTO IT_IMP4.
       CLEAR WA_IMP4.
     ENDLOOP.
   ENDIF.

   LOOP AT IT_IMP4 INTO WA_IMP4.
     WA_IMP5-BELNR = WA_IMP4-BELNR.
     WA_IMP5-BUPLA = WA_IMP4-BUPLA.
     WA_IMP5-GJAHR = WA_IMP4-GJAHR.
     WA_IMP5-KTOSL = WA_IMP4-KTOSL.
     WA_IMP5-KBETR = WA_IMP4-KBETR.
     WA_IMP5-HWBAS = WA_IMP4-HWBAS.
     WA_IMP5-HWSTE = WA_IMP4-HWSTE.
     WA_IMP5-VALUE = WA_IMP4-HWBAS + WA_IMP4-HWSTE.
     READ TABLE IT_IMP3 INTO WA_IMP3 WITH KEY FIDOC = WA_IMP4-BELNR GJAHR = WA_IMP4-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_IMP5-LIFNR = WA_IMP3-LIFNR.
       WA_IMP5-STEUC = WA_IMP3-STEUC.
       WA_IMP5-EBELN = WA_IMP3-EBELN.
       WA_IMP5-EBELP = WA_IMP3-EBELP.
     ENDIF.
     COLLECT WA_IMP5 INTO IT_IMP5.
     CLEAR WA_IMP5.
   ENDLOOP.
********************* IF TAX TS ZERO ****************************************
   LOOP AT IT_IMP3 INTO WA_IMP3.
     READ TABLE IT_IMP5 INTO WA_IMP5 WITH KEY
        BELNR = WA_IMP3-FIDOC
        GJAHR = WA_IMP3-GJAHR.
     IF SY-SUBRC EQ 4.
       WA_IMP1A-BELNR = WA_IMP3-FIDOC.
       WA_IMP1A-GJAHR = WA_IMP3-GJAHR.
       COLLECT WA_IMP1A   INTO IT_IMP1A.
       CLEAR WA_IMP1A.
     ENDIF.
   ENDLOOP.
   SORT IT_IMP1A BY BELNR GJAHR.
   DELETE ADJACENT DUPLICATES FROM IT_IMP1A.
   IF IT_IMP1A IS NOT INITIAL.
     SELECT * FROM BSEG INTO TABLE IT_BSEG2 FOR ALL
       ENTRIES IN IT_IMP1A WHERE
       BUKRS EQ '1000'
       AND BELNR EQ IT_IMP1A-BELNR
       AND GJAHR EQ IT_IMP1A-GJAHR.
   ENDIF.
   LOOP AT IT_BSEG2 INTO WA_BSEG2 WHERE KOART EQ 'K'.
     IF WA_BSEG2-SHKZG EQ 'H'.
       WA_BSEG2-DMBTR = WA_BSEG2-DMBTR * ( - 1 ).
     ENDIF.
     WA_IMV1-BELNR = WA_BSEG2-BELNR.
     WA_IMV1-GJAHR = WA_BSEG2-GJAHR.
     WA_IMV1-DMBTR = WA_BSEG2-DMBTR.
     COLLECT WA_IMV1 INTO IT_IMV1.
     CLEAR WA_IMV1.
   ENDLOOP.
   IF IT_BSEG2 IS NOT INITIAL.
     LOOP AT IT_BSEG2 INTO WA_BSEG2 WHERE HSN_SAC NE SPACE.
       IF WA_BSEG2-SHKZG EQ 'H'.
         WA_BSEG2-DMBTR = WA_BSEG2-DMBTR * ( - 1 ).
       ENDIF.
       WA_IMP2A-BELNR = WA_BSEG2-BELNR.
       WA_IMP2A-GJAHR = WA_BSEG2-GJAHR.
       WA_IMP2A-DMBTR = WA_BSEG2-DMBTR.
       WA_IMP2A-STEUC = WA_BSEG2-HSN_SAC.
       WA_IMP2A-BUPLA = WA_BSEG2-BUPLA.
       WA_IMP2A-EBELN = WA_BSEG2-EBELN.
       WA_IMP2A-EBELP = WA_BSEG2-EBELP.
       COLLECT WA_IMP2A INTO IT_IMP2A.
       CLEAR WA_IMP2A.
     ENDLOOP.
   ENDIF.

   IF IT_IMP2A IS INITIAL.
     LOOP AT IT_BSEG2 INTO WA_BSEG2.
       IF WA_BSEG2-SHKZG EQ 'H'.
         WA_BSEG2-DMBTR = WA_BSEG2-DMBTR * ( - 1 ).
       ENDIF.
       WA_IMP2A-BELNR = WA_BSEG2-BELNR.
       WA_IMP2A-GJAHR = WA_BSEG2-GJAHR.
       WA_IMP2A-DMBTR = WA_BSEG2-DMBTR.
       WA_IMP2A-STEUC = WA_BSEG2-HSN_SAC.
       WA_IMP2A-BUPLA = WA_BSEG2-BUPLA.
       WA_IMP2A-EBELN = WA_BSEG2-EBELN.
       WA_IMP2A-EBELP = WA_BSEG2-EBELP.
       COLLECT WA_IMP2A INTO IT_IMP2A.
       CLEAR WA_IMP2A.
     ENDLOOP.
   ENDIF.

   SORT IT_IMP2A BY BELNR GJAHR.
   LOOP AT IT_IMP2A INTO WA_IMP2A.
     WA_IMP5-BELNR = WA_IMP2A-BELNR.
     WA_IMP5-GJAHR = WA_IMP2A-GJAHR.
     WA_IMP5-STEUC = WA_IMP2A-STEUC.
     WA_IMP5-BUPLA = WA_IMP2A-BUPLA.
     WA_IMP5-EBELN = WA_IMP2A-EBELN.
     WA_IMP5-EBELP = WA_IMP2A-EBELP.
     IF WA_IMP2A-DMBTR NE 0.
       WA_IMP5-VALUE = WA_IMP2A-DMBTR.
     ELSE.
       ON CHANGE OF WA_IMP2A-BELNR.
         READ TABLE IT_IMV1 INTO WA_IMV1 WITH KEY
         BELNR = WA_IMP2A-BELNR
         GJAHR = WA_IMP2A-GJAHR.
         IF SY-SUBRC EQ 0.
           WA_IMP5-VALUE = WA_IMV1-DMBTR.
         ENDIF.
       ENDON.
     ENDIF.
     WA_IMP5-HWBAS = 0.
     WA_IMP5-HWSTE = 0.
     READ TABLE IT_IMP3 INTO WA_IMP3 WITH KEY
      FIDOC = WA_IMP2A-BELNR
      FIYEAR = WA_IMP2A-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_IMP5-LIFNR = WA_IMP3-LIFNR.
     ENDIF.
     WA_IMP5-KTOSL = 0.
     WA_IMP5-KBETR = 0.
     COLLECT WA_IMP5 INTO IT_IMP5.
     CLEAR WA_IMP5.
   ENDLOOP.
****************** ENDS HERE *************************
   LOOP AT IT_IMP5 INTO WA_IMP5.
     WA_IMP6-BELNR = WA_IMP5-BELNR.
     WA_IMP6-GJAHR = WA_IMP5-GJAHR.
     WA_IMP6-VALUE = WA_IMP5-VALUE.
     WA_IMP6-STEUC = WA_IMP5-STEUC.
     WA_IMP6-LIFNR = WA_IMP5-LIFNR.
     WA_IMP6-BUPLA = WA_IMP5-BUPLA.
     WA_IMP6-VALUE = WA_IMP5-VALUE.
     WA_IMP6-EBELN = WA_IMP5-EBELN.
     WA_IMP6-EBELP = WA_IMP5-EBELP.
     IF WA_IMP5-KTOSL EQ 'JIM'.
       WA_IMP6-HWBAS = WA_IMP5-HWBAS.
       WA_IMP6-JIM = WA_IMP5-HWSTE.
       WA_IMP6-KBETR = WA_IMP5-KBETR / 10.
     ELSEIF WA_IMP5-KTOSL EQ 'JII'.
       WA_IMP6-HWBAS = WA_IMP5-HWBAS.
       WA_IMP6-JII = WA_IMP5-HWSTE.
       WA_IMP6-KBETR = WA_IMP5-KBETR / 10.
     ELSEIF WA_IMP5-KTOSL EQ 'JIC'.
       WA_IMP6-HWBAS = WA_IMP5-HWBAS.
       WA_IMP6-JIC = WA_IMP5-HWSTE.
       WA_IMP6-KBETR = ( WA_IMP5-KBETR / 10 ) * 2.
     ELSEIF WA_IMP5-KTOSL EQ 'JIS'.
       WA_IMP6-HWBAS = WA_IMP5-HWBAS.
       WA_IMP6-JIS = WA_IMP5-HWSTE.
     ELSE.
       WA_IMP6-HWBAS = WA_IMP5-HWBAS.
       WA_IMP6-OTH = WA_IMP5-HWSTE.
*      WA_IMP6-KBETR = WA_IMP5-KBETR / 10 .
     ENDIF.
     SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000'
       AND BELNR = WA_IMP5-BELNR
       AND GJAHR = WA_IMP5-GJAHR.
     IF SY-SUBRC EQ 0.
       WA_IMP6-BUDAT = BKPF-BUDAT.
       WA_IMP6-BLDAT = BKPF-BLDAT.
       WA_IMP6-XBLNR = BKPF-XBLNR.
     ENDIF.
     SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN'
       AND BLAND EQ WA_IMP5-BUPLA.
     IF SY-SUBRC EQ 0.
       SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN'
         AND LAND1 EQ 'IN'
         AND BLAND EQ WA_IMP5-BUPLA.
       IF SY-SUBRC EQ 0.
         CONCATENATE T005S-FPRCD '-' T005U-BEZEI INTO SCODE.
         WA_IMP6-SCODE = SCODE.
       ENDIF.
     ENDIF.
     COLLECT WA_IMP6 INTO IT_IMP6.
     CLEAR WA_IMP6.
   ENDLOOP.

   LOOP AT IT_IMP6 INTO WA_IMP6 WHERE BUPLA IN BUSPLACE.
     IF WA_IMP6-JIM NE 0.
       MOVE-CORRESPONDING WA_IMP6 TO WA_IMP7.
       COLLECT WA_IMP7 INTO IT_IMP7.
       CLEAR WA_IMP7.
     ENDIF.
   ENDLOOP.

   WA_FIELDCAT-FIELDNAME = 'BUPLA'.
   WA_FIELDCAT-SELTEXT_L = 'BUS PLACE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SCODE'.
   WA_FIELDCAT-SELTEXT_L = 'Place of Supply'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STEUC'.
   WA_FIELDCAT-SELTEXT_L = 'HSN CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'KBETR'.
   WA_FIELDCAT-SELTEXT_L = 'RATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWBAS'.
   WA_FIELDCAT-SELTEXT_L = 'TAXABLE VALUE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'JIM'.
   WA_FIELDCAT-SELTEXT_L = 'IMPORT DUTY'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'OTH'.
   WA_FIELDCAT-SELTEXT_L = 'CESS'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'IMPORT DATA'.


   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_IMP7
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  IMPSER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM IMPSER .
   SORT IT_RRP2 BY TEXT BELNR.

   WA_FIELDCAT-FIELDNAME = 'TEXT'.
   WA_FIELDCAT-SELTEXT_L = 'TEXT'.
   WA_FIELDCAT-DO_SUM = 'X'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SCODE'.
   WA_FIELDCAT-SELTEXT_L = 'Place of Supply'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STEUC'.
   WA_FIELDCAT-SELTEXT_L = 'HSN/SAC CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RATE'.
   WA_FIELDCAT-SELTEXT_L = 'TAX RATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWBAS'.
   WA_FIELDCAT-SELTEXT_L = 'TAXABLE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'IGST'.
   WA_FIELDCAT-SELTEXT_L = 'IGST'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CESS'.
   WA_FIELDCAT-SELTEXT_L = 'CESS'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   PERFORM SORT CHANGING LI_SORT.

   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'IMPS_3I - (IMPORT - SERVICES)'.


   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       IT_SORT                 = LI_SORT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_RRP2
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RCM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM RCM .

   SORT IT_RRP3 BY TEXT BELNR.

   WA_FIELDCAT-FIELDNAME = 'TEXT'.
   WA_FIELDCAT-SELTEXT_L = 'TEXT'.
*   WA_FIELDCAT-DO_SUM = 'X'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STCD3'.
   WA_FIELDCAT-SELTEXT_L = 'GSTIN/PAN of Supplier'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'NAME1'.
   WA_FIELDCAT-SELTEXT_L = 'Trade/Legal  Name'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SCODE'.
   WA_FIELDCAT-SELTEXT_L = 'Place of Supply'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGTXT'.
   WA_FIELDCAT-SELTEXT_L = 'Differential % of Tax Rate'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'VBELN'.
   WA_FIELDCAT-SELTEXT_L = 'Supply Covered Under Sec 7 of IGST Act'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'XBLNR'.
   WA_FIELDCAT-SELTEXT_L = 'Supply Type'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STEUC'.
   WA_FIELDCAT-SELTEXT_L = 'HSN/SAC CODE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RATE'.
   WA_FIELDCAT-SELTEXT_L = 'RATE'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWBAS'.
   WA_FIELDCAT-SELTEXT_L = 'Taxable Value'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'IGST'.
   WA_FIELDCAT-SELTEXT_L = 'Integrated Tax'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CGST'.
   WA_FIELDCAT-SELTEXT_L = 'Central Tax'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGST'.
   WA_FIELDCAT-SELTEXT_L = 'State/UT Tax'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CESS'.
   WA_FIELDCAT-SELTEXT_L = 'CESS'.
   APPEND WA_FIELDCAT TO FIELDCAT.



   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'REV_3H - RCM DOCUMENTS IN PURCHASE REGISTER FOR FB60 & MIRO'.


   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       IT_SORT                 = LI_SORT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_RRP3
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.


 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEWREG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM NEWREG .

   SORT IT_RRP4 BY TEXT BELNR.

   LOOP AT IT_RRP4 INTO WA_RRP4.
     WA_RRP4-SGST = WA_RRP4-SGST + WA_RRP4-UGST.
     MODIFY IT_RRP4 FROM WA_RRP4 TRANSPORTING SGST.
     CLEAR WA_RRP4.
   ENDLOOP.

   WA_FIELDCAT-FIELDNAME = 'TEXT'.
   WA_FIELDCAT-SELTEXT_L = 'TEXT'.
   WA_FIELDCAT-DO_SUM = 'X'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'STCD3'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR GSTN'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'NAME1'.
   WA_FIELDCAT-SELTEXT_L = 'VENDOR NAME'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGTXT'.
   WA_FIELDCAT-SELTEXT_L = 'Type of inward supplies'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BLART'.
   WA_FIELDCAT-SELTEXT_L = 'Document type'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BELNR'.
   WA_FIELDCAT-SELTEXT_L = 'Document number'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BUDAT'.
   WA_FIELDCAT-SELTEXT_L = 'Document date'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWBAS'.
   WA_FIELDCAT-SELTEXT_L = 'Taxable value (₹)'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWSTE'.
   WA_FIELDCAT-SELTEXT_L = 'Total tax(₹)'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'IGST'.
   WA_FIELDCAT-SELTEXT_L = 'Integrated tax (₹)'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CGST'.
   WA_FIELDCAT-SELTEXT_L = 'Central tax (₹)'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGST'.
   WA_FIELDCAT-SELTEXT_L = 'State/ UT tax (₹)'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CESS'.
   WA_FIELDCAT-SELTEXT_L = 'Cess (₹)'.
   APPEND WA_FIELDCAT TO FIELDCAT.
   PERFORM SORT CHANGING LI_SORT.

   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'PURCHASE REGISTER FOR FB60 & MIRO'.


   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       IT_SORT                 = LI_SORT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_RRP4
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DETAILFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM DETAILFORM.

   LOOP AT IT_ALV1 INTO WA_ALV1.
     IF WA_ALV1-TEXT CS 'RCM'.
     ELSE.

       WA_ALV2-BELNR  = WA_ALV1-BELNR.
       WA_ALV2-GJAHR  = WA_ALV1-GJAHR.
       WA_ALV2-STCD3  = WA_ALV1-STCD3.
       WA_ALV2-NAME1  = WA_ALV1-NAME1.
       WA_ALV2-XBLNR  = WA_ALV1-XBLNR.
       WA_ALV2-BLDAT = WA_ALV1-BLDAT.
       WA_ALV2-BUDAT = WA_ALV1-BUDAT.
       WA_ALV2-TYP1 = 'REGULAR'.
       WA_ALV2-TYP2 = 'GOODS'.
       SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
         AND BELNR EQ WA_ALV1-BELNR
         AND GJAHR EQ WA_ALV1-GJAHR
         AND EBELN NE SPACE.
       IF SY-SUBRC EQ 0.
         SELECT SINGLE * FROM EKPO WHERE
           EBELN EQ BSEG-EBELN AND
           EBELP EQ BSEG-EBELP.
         IF SY-SUBRC EQ 0.
           WA_ALV2-TYP3 = EKPO-TXZ01.
         ENDIF.
       ELSE.
         SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000'
           AND BELNR EQ WA_ALV1-BELNR
           AND GJAHR EQ WA_ALV1-GJAHR
           AND HSN_SAC NE SPACE.
         IF SY-SUBRC EQ 0.
           SELECT SINGLE * FROM SKAT WHERE SPRAS EQ 'EN'
             AND KTOPL EQ '1000'
             AND SAKNR EQ BSEG-HKONT.
           IF SY-SUBRC EQ 0.
             WA_ALV2-TYP3 = SKAT-TXT20.
           ENDIF.
         ENDIF.
       ENDIF.
       WA_ALV2-HWBAS = WA_ALV1-HWBAS.
       WA_ALV2-RATE = WA_ALV1-RATE.
       WA_ALV2-IGST = WA_ALV1-IGST.
       WA_ALV2-CGST = WA_ALV1-CGST.
       WA_ALV2-SGST = WA_ALV1-SGST + WA_ALV1-UGST.
       WA_ALV2-UGST = WA_ALV1-UGST.
       WA_ALV2-CESS = WA_ALV1-CESS.
       WA_ALV2-DMBTR = WA_ALV1-DMBTR.
       WA_ALV2-TYP4 = 'Input Good'.
       WA_ALV2-TYP5 = '10'.
       WA_ALV2-TYP6 = 'No'.
       IF WA_ALV1-DMBTR LT 0.
         WA_ALV2-STAT = 'P'.
       ELSE.
         WA_ALV2-STAT = 'N'.
       ENDIF.
       COLLECT WA_ALV2 INTO IT_ALV2.
       CLEAR WA_ALV2.
     ENDIF.
   ENDLOOP.

   SORT IT_ALV2 BY BELNR.
*BREAK-POINT .


   WA_FIELDCAT-FIELDNAME = 'STCD3'.
   WA_FIELDCAT-SELTEXT_L = 'GSTIN'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'NAME1'.
   WA_FIELDCAT-SELTEXT_L = 'Vendor Name'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'XBLNR'.
   WA_FIELDCAT-SELTEXT_L = 'Invoice Number'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BLDAT'.
   WA_FIELDCAT-SELTEXT_L = 'Invoice Date'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BUDAT'.
   WA_FIELDCAT-SELTEXT_L = 'Transaction Date'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TYP1'.
   WA_FIELDCAT-SELTEXT_L = 'Invoice Type'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TYP2'.
   WA_FIELDCAT-SELTEXT_L = 'Item Nature'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TYP3'.
   WA_FIELDCAT-SELTEXT_L = 'Item Name'.
   APPEND WA_FIELDCAT TO FIELDCAT.

*   WA_FIELDCAT-FIELDNAME = 'BLART'.
*   WA_FIELDCAT-SELTEXT_L = 'DOC TYPE'.
*   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'HWBAS'.
   WA_FIELDCAT-SELTEXT_L = 'Item Taxable Value'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'RATE'.
   WA_FIELDCAT-SELTEXT_L = 'GST Rate'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'IGST'.
   WA_FIELDCAT-SELTEXT_L = 'IGST Amount'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CGST'.
   WA_FIELDCAT-SELTEXT_L = 'CGST Amount'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'SGST'.
   WA_FIELDCAT-SELTEXT_L = 'SGST Amount'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'CESS'.
   WA_FIELDCAT-SELTEXT_L = 'Cess Amount'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'DMBTR'.
   WA_FIELDCAT-SELTEXT_L = 'Invoice Value'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TYP4'.
   WA_FIELDCAT-SELTEXT_L = 'ITC Eligibility'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TYP5'.
   WA_FIELDCAT-SELTEXT_L = 'ITC Claim (%)'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'TYP6'.
   WA_FIELDCAT-SELTEXT_L = 'RCM Applicable'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'BELNR'.
   WA_FIELDCAT-SELTEXT_L = 'SAP Document No.'.
   APPEND WA_FIELDCAT TO FIELDCAT.

   WA_FIELDCAT-FIELDNAME = 'GJAHR'.
   WA_FIELDCAT-SELTEXT_L = 'SAP Document Year'.
   APPEND WA_FIELDCAT TO FIELDCAT.
   LAYOUT-ZEBRA = 'X'.
   LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   LAYOUT-WINDOW_TITLEBAR  = 'PURCHASE REGISTER FOR FB60 & MIRO'.

   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = G_REPID
       I_CALLBACK_USER_COMMAND = 'USER_COMM'
       I_CALLBACK_TOP_OF_PAGE  = 'TOP'
       IS_LAYOUT               = LAYOUT
       IT_FIELDCAT             = FIELDCAT
       IT_SORT                 = LI_SORT
       I_SAVE                  = 'A'
     TABLES
       T_OUTTAB                = IT_ALV2
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.

 ENDFORM.
