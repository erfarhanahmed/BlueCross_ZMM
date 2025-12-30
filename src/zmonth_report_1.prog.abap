*&---------------------------------------------------------------------*
*& Report  ZRATE9                                                      *
*& Developed by Jyotsna- 20.10.2008                                                                   *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

report  zrate9 no standard page heading line-size 500 .
tables : zrt_input,
         mchb,
         mara,
         t001w,
         mvke,
         makt,
         mkpf,
         mseg,
         ekpo,
         t023t,
         vbrp,
         tvprt,
         t178t,
         tvkmt,
         tvm5t.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.


data : it_ekpo      type table of ekpo,
       wa_ekpo      type ekpo,
       it_mdub      type table of mdub,
       wa_mdub      type mdub,
       it_vbrp      type table of vbrp,
       wa_vbrp      type vbrp,
       it_mara      type table of mara,
       wa_mara      type mara,
       it_ekbe      type table of ekbe,
       wa_ekbe      type ekbe,
       it_mchb      type table of mchb,
       wa_mchb      type mchb,
       it_t001w     type table of t001w,
       wa_t001w     type t001w,
       it_mvke      type table of mvke,
       wa_mvke      type mvke,
       it_makt      type table of makt,
       wa_makt      type makt,
       it_zrt_input type table of zrt_input,
       wa_zrt_input type zrt_input.

data : mesg(40) type c.

data : menge  type p decimals 0,
       stock1 type p decimals 0.


types : begin of itab13,
          matnr type mdub-matnr,
          charg type mdub-charg,
          menge type p decimals 0,
          ebeln type mdub-ebeln,
          ebelp type mdub-ebelp,
          reswk type mdub-reswk,
          kunnr type t001w-kunnr,
          vbeln type vbrp-vbeln,
          arktx type vbrp-arktx,
          fbuda type vbrp-fbuda,
          werks type mdub-werks,
          lgort type mdub-lgort,
*  mtart TYPE mara-mtart,
        end of itab13.

types : begin of itab14,
          matnr type mdub-matnr,
          charg type mdub-charg,
          menge type p decimals 0,
          ebeln type mdub-ebeln,
          ebelp type mdub-ebelp,
          reswk type mdub-reswk,
          kunnr type t001w-kunnr,
          vbeln type vbrp-vbeln,
          arktx type vbrp-arktx,
          fbuda type vbrp-fbuda,
          mtart type mara-mtart,
          werks type mdub-werks,
          lgort type mdub-lgort,
        end of itab14.

types : begin of itab15,
          matnr   type mdub-matnr,
          charg   type mdub-charg,
          menge   type p decimals 0,
          ebeln   type mdub-ebeln,
          ebelp   type mdub-ebelp,
          reswk   type mdub-reswk,
          kunnr   type t001w-kunnr,
          vbeln   type vbrp-vbeln,
          arktx   type vbrp-arktx,
          fbuda   type vbrp-fbuda,
          mtart   type mara-mtart,
          rm_rate type zrt_input-rm_rate,
          pm_rate type zrt_input-pm_rate,
          ccpc    type zrt_input-ccpc,
          ed      type zrt_input-ed,
          werks   type mdub-werks,
          lgort   type mdub-lgort,
        end of itab15.

types : begin of itab16,
          matnr    type mdub-matnr,
          charg    type mdub-charg,
          menge    type p decimals 0,
          ebeln    type mdub-ebeln,
          ebelp    type mdub-ebelp,
          reswk    type mdub-reswk,
          kunnr    type t001w-kunnr,
          kunnr1   type t001w-kunnr,
          vbeln    type vbrp-vbeln,
          arktx    type vbrp-arktx,
          fbuda    type vbrp-fbuda,
          mtart    type mara-mtart,
          rm_rate  type p decimals 2,
          pm_rate  type p decimals 2,
          ccpc     type p decimals 2,
          ed       type p decimals 2,
          rm_val   type p decimals 2,
          pm_val   type p decimals 2,
          ccpc_val type p decimals 2,
          ed_val   type p decimals 2,
          value    type p decimals 2,
          werks    type mdub-werks,
          mvgr1    type mvke-mvgr1,
          bezei    type tvm5t-bezei,
          lgort    type mdub-lgort,
        end of itab16.

types : begin of itab17,
          werks    type mdub-werks,
          kunnr    type t001w-kunnr,
* matnr TYPE MDUB-MATNR,
* charg TYPE MDUB-CHARG,
          menge    type p decimals 0,
* EBELn TYPE MDUB-EBELn,
* EBELP TYPE MDUB-EBELP,
* RESWK TYPE MDUB-RESWK,

* vbeln TYPE vbrp-vbeln,
* arktx TYPE vbrp-arktx,
* fbuda TYPE vbrp-fbuda,
* mtart TYPE mara-mtart,
          rm_rate  type p decimals 2,
          pm_rate  type p decimals 2,
          ccpc     type p decimals 2,
          ed       type  p decimals 2,
          rm_val   type p decimals 2,
          pm_val   type p decimals 2,
          ccpc_val type p decimals 2,
          ed_val   type p decimals 2,
          value    type p decimals 2,
          freight  type p decimals 2,
          t_val    type p decimals 2,

        end of itab17.


types : begin of tab1,
          stock type mchb-clabs,
          block type p decimals 0,
          matnr type mchb-matnr,
          charg type mchb-charg,
          werks type mchb-werks,
          lgort type mchb-lgort,
        end of tab1.

types : begin of tab2,
          stock   type mchb-clabs,
          block   type p decimals 0,
          matnr   type mchb-matnr,
          charg   type mchb-charg,
          werks   type mchb-werks,
          lgort   type mchb-lgort,
          maktx   type makt-maktx,
          mtart   type mara-mtart,
          mvgr1   type mvke-mvgr1,
          vtext   type tvprt-vtext,
          vtext1  type t178t-vtext,
          vtext2  type tvkmt-vtext,
          bezei   type tvm5t-bezei,
          wgbez   type t023t-wgbez,
          rm_rate type zrt_input-rm_rate,
          pm_rate type zrt_input-pm_rate,
          ccpc    type zrt_input-ccpc,
          ed      type zrt_input-ed,

        end of tab2.

types : begin of tab3,
          stock    type p decimals 0,
          block    type p decimals 0,
          matnr    type mchb-matnr,
          charg    type mchb-charg,
          werks    type mchb-werks,
          lgort    type mchb-lgort,
          maktx    type makt-maktx,
          mtart    type mara-mtart,
          mvgr1    type mvke-mvgr1,
          vtext    type tvprt-vtext,
          vtext1   type t178t-vtext,
          vtext2   type tvkmt-vtext,
          bezei    type tvm5t-bezei,
          wgbez    type t023t-wgbez,
          rm_rate  type p decimals 2,
          pm_rate  type p decimals 2,
          ccpc     type p decimals 2,
          ed       type p decimals 2,
          rm_val   type p decimals 2,
          pm_val   type p decimals 2,
          ccpc_val type p decimals 2,
          ed_val   type p decimals 2,
          total    type p decimals 2,
        end of tab3.

types : begin of tab4,
          stock    type p decimals 0,
          block    type p decimals 0,
*  matnr TYPE mchb-matnr,
*  charg TYPE mchb-charg,
          werks    type mchb-werks,
          kunnr    type t001w-kunnr,
*  lgort TYPE mchb-lgort,
*  MAKTX TYPE MAKT-MAKTX,
*   mtart TYPE mara-mtart,
*  MVGR1 TYPE mvke-mvgr1,
*  VTEXT TYPE TVPRT-VTEXT,
*  VTEXT1 TYPE T178t-vtext,
*  VTEXT2 TYPE Tvkmt-vtext,
*  BEZEI TYPE Tvm5t-bezei,
*  WGBEZ TYPE T023T-WGBEZ,
          rm_rate  type p decimals 2,
          pm_rate  type p decimals 2,
          ccpc     type p decimals 2,
          ed       type p decimals 2,
          rm_val   type p decimals 2,
          pm_val   type p decimals 2,
          ccpc_val type p decimals 2,
          ed_val   type p decimals 2,
          total    type p decimals 2,
          freight  type p decimals 2,
          t_val    type p decimals 2,
        end of tab4.

types : begin of tab5,
          kunnr    like t001w-kunnr,
          name1    like t001w-name1,
          rm_rate  type p decimals 2,
          pm_rate  type p decimals 2,
          ccpc     type p decimals 2,
          ed       type p decimals 2,
          rm_val   type p decimals 2,
          pm_val   type p decimals 2,
          ccpc_val type p decimals 2,
          ed_val   type p decimals 2,
          total    type p decimals 2,
          werks    type mdub-werks,
          werks1   type mdub-werks,
          matkl    like mara-matkl,
          wgbez    like t023t-wgbez,
          matnr    like mchb-matnr,
          maktx    like makt-maktx,
          charg    like mchb-charg,
          lgort    like mchb-lgort,
          mtart    like mara-mtart,
          mvgr1    like mvke-mvgr1,
          mvgr5    like mvke-mvgr5,
          bezei    like tvm5t-bezei,
          clabs1   like mchb-clabs,

        end of tab5.


data : it_tab13 type table of itab13,
       wa_tab13 type itab13,
       it_tab14 type table of itab14,
       wa_tab14 type itab14,
       it_tab15 type table of itab15,
       wa_tab15 type itab15,
       it_tab16 type table of itab16,
       wa_tab16 type itab16,
       it_tab17 type table of itab17,
       wa_tab17 type itab17,
       it_tab1  type table of tab1,
       wa_tab1  type tab1,
       it_tab2  type table of tab2,
       wa_tab2  type tab2,
       it_tab3  type table of tab3,
       wa_tab3  type tab3,
       it_tab4  type table of tab4,
       wa_tab4  type tab4,
       it_tab5  type table of tab5,
       wa_tab5  type tab5.

data : begin of itab1 occurs 0,
         werks  like mseg-werks,
         ebeln  like mseg-ebeln,
         matnr  like mseg-matnr,
         menge  like mseg-menge,
         umcha  like mseg-umcha,
         elikz  like ekpo-elikz,
         bwart  like mseg-bwart,
         ebeln1 like ekpo-ebeln,
         mtart  like mara-mtart,
         ebelp  like mseg-ebelp,

       end of itab1.

data : begin of itab2 occurs 0,
         werks  like mseg-werks,
         ebeln  like mseg-ebeln,
         matnr  like mseg-matnr,
         menge  like mseg-menge,
*       umcha like mseg-umcha,
         elikz  like ekpo-elikz,
*       bwart like mseg-bwart,
         ebeln1 like ekpo-ebeln,
         ebelp  like ekpo-ebelp,
         mtart  like mara-mtart,

       end of itab2.

data : itab_tot like mseg-menge.



data : begin of t_details occurs 0,
         matnr    like mchb-matnr,
         charg    like mchb-charg,
         clabs    like mchb-clabs,
         cumlm    like mchb-cumlm,
         cinsm    like mchb-cinsm,
         ceinm    like mchb-ceinm,
         cspem    like mchb-cspem,
         cretm    like mchb-cretm,
         clabs1   like mchb-clabs,
         lgort    like mchb-lgort,
         werks    like mchb-werks,
         mtart    like mara-mtart,
         rm_rate  like zrt_input-rm_rate,
         pm_rate  like zrt_input-pm_rate,
         ccpc     like zrt_input-ccpc,
         ed       like zrt_input-ed,
         kunnr    like t001w-kunnr,
         name1    like t001w-name1,
         rm_val   type p decimals 2,
         pm_val   type p decimals 2,
         ccpc_val type p decimals 2,
         ed_val   type p decimals 2,
         mvgr1    like mvke-mvgr1,
         mvgr5    like mvke-mvgr5,
         bezei    like tvm5t-bezei,
         total    type p decimals 2,
         total2   type p decimals 2,
         maktx    like makt-maktx,
         fret_val type p decimals 2,
         matkl    like mara-matkl,
         wgbez    like t023t-wgbez,
       end of t_details.


data : begin of t_details1 occurs 0,
         matnr       like mchb-matnr,
         charg       like mchb-charg,
         clabs       like mchb-clabs,
         cumlm       like mchb-cumlm,
         cinsm       like mchb-cinsm,
         ceinm       like mchb-ceinm,
         cspem       like mchb-cspem,
         cretm       like mchb-cretm,
         clabs1      like mchb-clabs,
         lgort       like mchb-lgort,
         werks       like mchb-werks,
         mtart       like mara-mtart,
         rm_rate     like zrt_input-rm_rate,
         pm_rate     like zrt_input-pm_rate,
         ccpc        like zrt_input-ccpc,
         ed          like zrt_input-ed,
         kunnr       like t001w-kunnr,
         name1       like t001w-name1,
         rm_val      type p decimals 2,
         pm_val      type p decimals 2,
         ccpc_val    type p decimals 2,
         ed_val      type p decimals 2,
         mvgr1       like mvke-mvgr1,
         mvgr5       like mvke-mvgr5,
         pac_size(8) type c,
         total       type p decimals 2,
         total2      type p decimals 2,
         maktx       like makt-maktx,
         fret_val    type p decimals 2,
         matkl       like mara-matkl,
         wgbez       like t023t-wgbez,

       end of t_details1.


data : begin of t_sum occurs 0,
         werks  like mchb-werks,
         kunnr  like t001w-kunnr,
         clabs  like mchb-clabs,
         cumlm  like mchb-cumlm,
         cinsm  like mchb-cinsm,
         ceinm  like mchb-ceinm,
         cspem  like mchb-cspem,
         cretm  like mchb-cretm,
         clabs1 like mchb-clabs,
         name1  like t001w-name1,
       end of t_sum.


data : tot11 type p decimals 2.
data : tot12 type p decimals 2.
data : tot13 type p decimals 2.
data : tot14 type p decimals 2.

data : tot21 type p decimals 2.
data : tot22 type p decimals 2.
data : tot23 type p decimals 2.
data : tot24 type p decimals 2.

data : tot31 type p decimals 2.
data : tot41 type p decimals 2.


data : tot1rm_val type p decimals 2.
data : tot1pm_val type p decimals 2.
data : tot1ccpc_val type p decimals 2.
data : tot1ed_val type p decimals 2.

data : tot11rm_val type p decimals 2.
data : tot11pm_val type p decimals 2.
data : tot11ccpc_val type p decimals 2.
data : tot11ed_val type p decimals 2.

data : tot2rm_val type p decimals 2.
data : tot2pm_val type p decimals 2.
data : tot2ccpc_val type p decimals 2.
data : tot2ed_val type p decimals 2.
data : tot21rm_val type p decimals 2.
data : tot21pm_val type p decimals 2.
data : tot21ccpc_val type p decimals 2.
data : tot21ed_val type p decimals 2.

data : tot3rm_val type p decimals 2.
data : tot3pm_val type p decimals 2.
data : tot3ccpc_val type p decimals 2.
data : tot3ed_val type p decimals 2.
data : tot31rm_val type p decimals 2.
data : tot31pm_val type p decimals 2.
data : tot31ccpc_val type p decimals 2.
data : tot31ed_val type p decimals 2.
data : tot4rm_val type p decimals 2.
data : tot4pm_val type p decimals 2.
data : tot4ccpc_val type p decimals 2.
data : tot4ed_val type p decimals 2.
data : tot41rm_val type p decimals 2.
data : tot41pm_val type p decimals 2.
data : tot41ccpc_val type p decimals 2.
data : tot41ed_val type p decimals 2.


data : tot1 type p decimals 2,
       tot2 type p decimals 2,
       tot3 type p decimals 2,
       tot4 type p decimals 2.

data : tot2000-s type p decimals 2,
       tot2001-s type p decimals 2,
       tot2002-s type p decimals 2,
       tot2003-s type p decimals 2,
       tot2004-s type p decimals 2,
       tot2005-s type p decimals 2,
       tot2006-s type p decimals 2,
       tot2007-s type p decimals 2,
       tot2008-s type p decimals 2,
       tot2009-s type p decimals 2,
       tot2010-s type p decimals 2,
       tot2011-s type p decimals 2,
       tot2012-s type p decimals 2,
       tot2013-s type p decimals 2,
       tot2014-s type p decimals 2,
       tot2015-s type p decimals 2,
       tot2016-s type p decimals 2,
       tot2017-s type p decimals 2,
       tot2018-s type p decimals 2,
       tot2019-s type p decimals 2,
       tot2020-s type p decimals 2,
       tot2022-s type p decimals 2,
       tot2023-s type p decimals 2,
       tot3000-s type p decimals 2,

       total_s   type p decimals 2.


data : tot2000-r type p decimals 2,
       tot2000-p type p decimals 2,
       tot2000-c type p decimals 2,
       tot2000-e type p decimals 2.


data : tot2001-r type p decimals 2,
       tot2001-p type p decimals 2,
       tot2001-c type p decimals 2,
       tot2001-e type p decimals 2.

data : tot2002-r type p decimals 2,
       tot2002-p type p decimals 2,
       tot2002-c type p decimals 2,
       tot2002-e type p decimals 2.

data : tot2003-r type p decimals 2,
       tot2003-p type p decimals 2,
       tot2003-c type p decimals 2,
       tot2003-e type p decimals 2.

data : tot2004-r type p decimals 2,
       tot2004-p type p decimals 2,
       tot2004-c type p decimals 2,
       tot2004-e type p decimals 2.

data : tot2005-r type p decimals 2,
       tot2005-p type p decimals 2,
       tot2005-c type p decimals 2,
       tot2005-e type p decimals 2.

data : tot2006-r type p decimals 2,
       tot2006-p type p decimals 2,
       tot2006-c type p decimals 2,
       tot2006-e type p decimals 2.

data : tot2007-r type p decimals 2,
       tot2007-p type p decimals 2,
       tot2007-c type p decimals 2,
       tot2007-e type p decimals 2.

data : tot2008-r type p decimals 2,
       tot2008-p type p decimals 2,
       tot2008-c type p decimals 2,
       tot2008-e type p decimals 2.

data : tot2009-r type p decimals 2,
       tot2009-p type p decimals 2,
       tot2009-c type p decimals 2,
       tot2009-e type p decimals 2.

data : tot2010-r type p decimals 2,
       tot2010-p type p decimals 2,
       tot2010-c type p decimals 2,
       tot2010-e type p decimals 2.

data : tot2011-r type p decimals 2,
       tot2011-p type p decimals 2,
       tot2011-c type p decimals 2,
       tot2011-e type p decimals 2.

data : tot2012-r type p decimals 2,
       tot2012-p type p decimals 2,
       tot2012-c type p decimals 2,
       tot2012-e type p decimals 2.

data : tot2013-r type p decimals 2,
       tot2013-p type p decimals 2,
       tot2013-c type p decimals 2,
       tot2013-e type p decimals 2.

data : tot2014-r type p decimals 2,
       tot2014-p type p decimals 2,
       tot2014-c type p decimals 2,
       tot2014-e type p decimals 2.

data : tot2015-r type p decimals 2,
       tot2015-p type p decimals 2,
       tot2015-c type p decimals 2,
       tot2015-e type p decimals 2.

data : tot2016-r type p decimals 2,
       tot2016-p type p decimals 2,
       tot2016-c type p decimals 2,
       tot2016-e type p decimals 2.

data : tot2017-r type p decimals 2,
       tot2017-p type p decimals 2,
       tot2017-c type p decimals 2,
       tot2017-e type p decimals 2.

data : tot2018-r type p decimals 2,
       tot2018-p type p decimals 2,
       tot2018-c type p decimals 2,
       tot2018-e type p decimals 2.

data : tot2019-r type p decimals 2,
       tot2019-p type p decimals 2,
       tot2019-c type p decimals 2,
       tot2019-e type p decimals 2.

data : tot2020-r type p decimals 2,
       tot2020-p type p decimals 2,
       tot2020-c type p decimals 2,
       tot2020-e type p decimals 2.

data : tot2022-r type p decimals 2,
       tot2022-p type p decimals 2,
       tot2022-c type p decimals 2,
       tot2022-e type p decimals 2.

data : tot2023-r type p decimals 2,
       tot2023-p type p decimals 2,
       tot2023-c type p decimals 2,
       tot2023-e type p decimals 2.

data : tot3000-r type p decimals 2,
       tot3000-p type p decimals 2,
       tot3000-c type p decimals 2,
       tot3000-e type p decimals 2.

data : tot4000-r type p decimals 2,
       tot4000-p type p decimals 2,
       tot4000-c type p decimals 2,
       tot4000-e type p decimals 2.

data : tot4001-r type p decimals 2,
       tot4001-p type p decimals 2,
       tot4001-c type p decimals 2,
       tot4001-e type p decimals 2.

data : tot4002-r type p decimals 2,
       tot4002-p type p decimals 2,
       tot4002-c type p decimals 2,
       tot4002-e type p decimals 2.

data : tot4003-r type p decimals 2,
       tot4003-p type p decimals 2,
       tot4003-c type p decimals 2,
       tot4003-e type p decimals 2.

data : tot4004-r type p decimals 2,
       tot4004-p type p decimals 2,
       tot4004-c type p decimals 2,
       tot4004-e type p decimals 2.

data : tot2000 type p decimals 2,
       tot2001 type p decimals 2,
       tot2002 type p decimals 2,
       tot2003 type p decimals 2,
       tot2004 type p decimals 2,
       tot2005 type p decimals 2,
       tot2006 type p decimals 2,
       tot2007 type p decimals 2,
       tot2008 type p decimals 2,
       tot2009 type p decimals 2,
       tot2010 type p decimals 2,
       tot2011 type p decimals 2,
       tot2012 type p decimals 2,
       tot2013 type p decimals 2,
       tot2014 type p decimals 2,
       tot2015 type p decimals 2,
       tot2016 type p decimals 2,
       tot2017 type p decimals 2,
       tot2018 type p decimals 2,
       tot2019 type p decimals 2,
       tot2020 type p decimals 2,
       tot2022 type p decimals 2,
       tot2023 type p decimals 2,
       tot3000 type p decimals 2,
       tot4000 type p decimals 2,
       tot4001 type p decimals 2,
       tot4002 type p decimals 2,
       tot4003 type p decimals 2,
       tot4004 type p decimals 2.


data : to2000 type p decimals 2,
       to2001 type p decimals 2,
       to2002 type p decimals 2,
       to2003 type p decimals 2,
       to2004 type p decimals 2,
       to2005 type p decimals 2,
       to2006 type p decimals 2,
       to2007 type p decimals 2,
       to2008 type p decimals 2,
       to2009 type p decimals 2,
       to2010 type p decimals 2,
       to2011 type p decimals 2,
       to2012 type p decimals 2,
       to2013 type p decimals 2,
       to2014 type p decimals 2,
       to2015 type p decimals 2,
       to2016 type p decimals 2,
       to2017 type p decimals 2,
       to2018 type p decimals 2,
       to2019 type p decimals 2,
       to2020 type p decimals 2,
       to2022 type p decimals 2,
       to2023 type p decimals 2,
       to3000 type p decimals 2,
       to4000 type p decimals 2,
       to4001 type p decimals 2,
       to4002 type p decimals 2,
       to4003 type p decimals 2,
       to4004 type p decimals 2.

data : total_r type p decimals 2,
       total_p type p decimals 2,
       total_c type p decimals 2,
       total_e type p decimals 2,
       t_total type p decimals 2,
       total   type p decimals 2,
       tot_qty type p decimals 2.

data : f_v2000 type p decimals 2,
       f_v2001 type p decimals 2,
       f_v2002 type p decimals 2,
       f_v2003 type p decimals 2,
       f_v2004 type p decimals 2,
       f_v2005 type p decimals 2,
       f_v2006 type p decimals 2,
       f_v2007 type p decimals 2,
       f_v2008 type p decimals 2,
       f_v2009 type p decimals 2,
       f_v2010 type p decimals 2,
       f_v2011 type p decimals 2,
       f_v2012 type p decimals 2,
       f_v2013 type p decimals 2,
       f_v2014 type p decimals 2,
       f_v2015 type p decimals 2,
       f_v2016 type p decimals 2,
       f_v2017 type p decimals 2,
       f_v2018 type p decimals 2,
       f_v2019 type p decimals 2,
       f_v2020 type p decimals 2,
       f_v2022 type p decimals 2,
       f_v2023 type p decimals 2,
       f_v3000 type p decimals 2,
       f_v4000 type p decimals 2,
       f_v4001 type p decimals 2,
       f_v4002 type p decimals 2,
       f_v4003 type p decimals 2,
       f_v4004 type p decimals 2.


data : freight_val type p decimals 2.

data : total_st   type p decimals 0,
       total_rm   type p decimals 2,
       total_pm   type p decimals 2,
       total_ccpc type p decimals 2,
       total_ed   type p decimals 2,
       total_ft   type p decimals 2,
       total_v    type p decimals 2,
       total_vl   type p decimals 2.

types : begin of details,
          matnr    like mchb-matnr,
          charg    like mchb-charg,
          clabs    like mchb-clabs,
          cumlm    like mchb-cumlm,
          cinsm    like mchb-cinsm,
          ceinm    like mchb-ceinm,
          cspem    like mchb-cspem,
          cretm    like mchb-cretm,
          clabs1   like mchb-clabs,
          lgort    like mchb-lgort,
          werks    like mchb-werks,
          mtart    like mara-mtart,
          rm_rate  like zrt_input-rm_rate,
          pm_rate  like zrt_input-pm_rate,
          ccpc     like zrt_input-ccpc,
          ed       like zrt_input-ed,
          kunnr    like t001w-kunnr,
          name1    like t001w-name1,
          rm_val   type p decimals 2,
          pm_val   type p decimals 2,
          ccpc_val type p decimals 2,
          ed_val   type p decimals 2,
          mvgr1    like mvke-mvgr1,
          mvgr5    like mvke-mvgr5,
          bezei    like tvm5t-bezei,
          total    type p decimals 2,
          total2   type p decimals 2,
          maktx    like makt-maktx,
          fret_val type p decimals 2,
          matkl    like mara-matkl,
          wgbez    like t023t-wgbez,
        end of details.

data : it_details type table of details,
       wa_details type details.

selection-screen begin of block b1 with frame title text-001.
parameters: depot radiobutton group 57f4 default 'X' .
parameters: summ_dp radiobutton group 57f4 .
parameters: updt_ts radiobutton group 57f4 .
parameters: summ_ts radiobutton group 57f4.
select-options: m_type for mara-mtart.
select-options: plant for mchb-werks.
select-options: material for mchb-matnr.
parameters freight type p decimals 2 .

parameters: nsk_goa radiobutton group 57f4  .
parameters: summ_ng radiobutton group 57f4 .
parameters : loc_from like mseg-lgort default 'FG01'.
parameters : loc_to like mseg-lgort default 'FG04'.




selection-screen skip.
selection-screen end of block b1.

initialization.
  g_repid = sy-repid.

at selection-screen.
  authority-check object '/DSD/SL_WR'
           id 'WERKS' field plant.

  if sy-subrc ne 0.
    mesg = 'Check your entry'.
    message mesg type 'E'.
  endif.

start-of-selection.


  if depot = 'X'.
    perform depot.
*  elseif update = 'X'.
*    perform update.
  elseif nsk_goa = 'X'.
    perform nsk_goa.
  elseif summ_ng = 'X'.
    perform summ_ng.
  elseif summ_dp = 'X'.
    perform summ_dp.
  elseif updt_ts = 'X'.
    perform updt_ts.
  elseif summ_ts = 'X'.
    perform summ_ts.
  endif.



*&---------------------------------------------------------------------*
*&      Form  depot
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form depot.

*select * from mchb where clabs ne 0 and ( lgort between loc_from and loc_to )
* order by werks matnr .
  select * from mchb into table it_mchb where matnr in material and werks ne 1000 and werks ne 1001
  and werks in plant .
*    order by werks.
  if sy-subrc eq 0.
    select * from mara into table it_mara where matnr in material and mtart in m_type .
    select * from t001w into table it_t001w for all entries in it_mchb where werks eq it_mchb-werks.
    select * from mvke into table it_mvke for all entries in it_mara where matnr = it_mara-matnr.
    select * from makt into table it_makt for all entries in it_mara where spras eq 'EN' and matnr = it_mara-matnr.
*    select * from zrt_input into table it_zrt_input for all entries in it_where matnr eq it_mchb-matnr and batch eq it_mchb-charg.
*          Select * from t023t into table it_t023t FOR ALL ENTRIES IN it_mchb where matkl eq mara-matkl
*            and spras eq 'EN'.
*            sort it_mchb by matnr.
  endif.
  if it_mchb is not initial.
*    select * from zrt_input into table it_zrt_input for all entries in it_MCHB where matnr eq it_mchb-matnr and batch eq it_mchb-charg.
    select * from zrt_input into table it_zrt_input where matnr in material.
  endif.

  loop at it_mchb into wa_mchb.
    stock1 = wa_mchb-clabs + wa_mchb-cspem + wa_mchb-cumlm + wa_mchb-cinsm + wa_mchb-cretm.
    if stock1 ne 0.
      wa_tab1-block = wa_mchb-cspem.
      wa_tab1-matnr = wa_mchb-matnr.
      wa_tab1-charg = wa_mchb-charg.
      wa_tab1-lgort = wa_mchb-lgort.
      wa_tab1-werks = wa_mchb-werks.
      wa_tab1-stock = stock1.
      collect wa_tab1 into it_tab1.
    endif.
    clear wa_tab1.
  endloop.
*EXIT.

  loop at it_tab1 into wa_tab1.
*  write : / wa_tab1-werks,wa_tab1-matnr,wa_tab1-charg,wa_tab1-lgort,wa_tab1-stock,wa_tab1-lgort.


    wa_tab2-lgort = wa_tab1-lgort.
    read table it_makt into wa_makt with key matnr = wa_tab1-matnr.
    if sy-subrc eq 0.
*    write : wa_makt-maktx.
      wa_tab2-maktx = wa_makt-maktx.
    endif.
    read table it_mvke into wa_mvke with key matnr = wa_tab1-matnr.
    if sy-subrc eq 0.
*    write : wa_mvke-mvgr1.
      wa_tab2-mvgr1 = wa_mvke-mvgr1.
*     wa_mvke-provg,wa_mvke-kondm,wa_mvke-ktgrm,,wa_mvke-mvgr5.

      select single * from tvprt where provg eq wa_mvke-provg and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : TVPRT-VTEXT.
        wa_tab2-vtext = tvprt-vtext.
      endif.
      select single * from t178t where kondm eq wa_mvke-kondm and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : T178t-vtext.
        wa_tab2-vtext1 = t178t-vtext.
      endif.
      select single * from tvkmt where ktgrm eq wa_mvke-ktgrm and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : Tvkmt-vtext.
        wa_tab2-vtext2 = tvkmt-vtext.
      endif.
      select single * from tvm5t where mvgr5 eq wa_mvke-mvgr5 and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : Tvm5t-bezei.
        wa_tab2-bezei = tvm5t-bezei.
      endif.

    endif.

    wa_tab2-stock = wa_tab1-stock.
    wa_tab2-werks = wa_tab1-werks.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-lgort = wa_tab1-lgort.

    read table it_zrt_input into wa_zrt_input with key matnr = wa_tab1-matnr batch = wa_tab1-charg.
    if sy-subrc eq 0.
*    WRITE : WA_ZRT_INPUT-RM_RATE,WA_ZRT_INPUT-PM_RATE,WA_ZRT_INPUT-CCPC,WA_ZRT_INPUT-ED.
      wa_tab2-rm_rate = wa_zrt_input-rm_rate.
      wa_tab2-pm_rate = wa_zrt_input-pm_rate.
      wa_tab2-ccpc = wa_zrt_input-ccpc.
      wa_tab2-ed = wa_zrt_input-ed.

    endif.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.

*  WRITE : / 'a'.


  loop at it_tab2 into wa_tab2.
    read table it_mara into wa_mara with key matnr = wa_tab2-matnr.
    if sy-subrc eq 0.
**    write : wa_mara-mtart,wa_mara-matkl.
      wa_tab3-mtart =  wa_mara-mtart.
      select single * from t023t where matkl eq wa_mara-matkl and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : T023T-WGBEZ.
        wa_tab3-wgbez = t023t-wgbez.
      endif.

      wa_tab3-werks = wa_tab2-werks.
      wa_tab3-matnr = wa_tab2-matnr.
      wa_tab3-charg = wa_tab2-charg.
      wa_tab3-lgort = wa_tab2-lgort.

      wa_tab3-maktx = wa_tab2-maktx.
      wa_tab3-stock = wa_tab2-stock.
*   WA_TAB3-mtart = WA_TAB2-mtart.
      wa_tab3-mvgr1 = wa_tab2-mvgr1.
      wa_tab3-vtext = wa_tab2-vtext.
      wa_tab3-vtext1 = wa_tab2-vtext1.
      wa_tab3-vtext2 = wa_tab2-vtext2.
      wa_tab3-bezei = wa_tab2-bezei.
*   WA_TAB3-WGBEZ = WA_TAB2-WGBEZ.
      wa_tab3-rm_rate = wa_tab2-rm_rate.
      wa_tab3-pm_rate = wa_tab2-pm_rate.
      wa_tab3-ccpc = wa_tab2-ccpc.
      wa_tab3-ed = wa_tab2-ed.

      wa_tab3-rm_val = wa_tab2-rm_rate * wa_tab2-stock.
      wa_tab3-pm_val = wa_tab2-pm_rate * wa_tab2-stock.
      wa_tab3-ccpc_val = wa_tab2-ccpc * wa_tab2-stock.
      wa_tab3-ed_val = wa_tab2-ed * wa_tab2-stock.
      wa_tab3-total = wa_tab3-rm_val + wa_tab3-pm_val + wa_tab3-ccpc_val + wa_tab3-ed_val.

      collect wa_tab3 into it_tab3.
    endif.

  endloop.

  loop at it_tab3 into wa_tab3.

    pack wa_tab3-matnr to wa_tab3-matnr.
    condense wa_tab3-matnr.
    modify it_tab3 from wa_tab3 transporting matnr.
    clear wa_tab3.
*  write : / WA_TAB3-werks,WA_TAB3-MTART,WA_TAB3-matnr,WA_TAB3-charg,WA_TAB3-lgort,WA_TAB3-stock.
*   write : WA_TAB3-maktx,WA_TAB3-mvgr1,WA_TAB3-VTEXT,WA_TAB3-vtext1.
*   WRITE : WA_TAB3-vtext2,WA_TAB3-bezei,wa_tab3-wgbez.
*   WRITE : WA_TAB3-RM_RATE,WA_TAB3-PM_RATE,WA_TAB3-CCPC,WA_TAB3-ED.
*  WRITE : WA_TAB3-RM_VAL,WA_TAB3-PM_VAL,WA_TAB3-CCPC_VAL,WA_TAB3-ED_VAL,WA_TAB3-TOTAL.
  endloop.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_s = 'PLANT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MTART'.
  wa_fieldcat-seltext_s = 'TYPE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-seltext_s = 'STOR_LOC'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'WGBEZ'.
  wa_fieldcat-seltext_s = 'GROUP'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_s = 'CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_s = 'MATERIAL'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_s = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MVGR1'.
  wa_fieldcat-seltext_s = 'FORM'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VTEXT'.
  wa_fieldcat-seltext_s = 'TYPE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VTEXT1'.
  wa_fieldcat-seltext_s = 'DC/CO'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_s = 'PAC_SIZE'.
  append wa_fieldcat to fieldcat.



  wa_fieldcat-fieldname = 'STOCK'.
  wa_fieldcat-seltext_s = 'STOCK'.
  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'RM_RATE'.
  wa_fieldcat-seltext_s = 'RM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_RATE'.
  wa_fieldcat-seltext_s = 'PM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC'.
  wa_fieldcat-seltext_s = 'CCPC_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED'.
  wa_fieldcat-seltext_s = 'ED_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RM_VAL'.
  wa_fieldcat-seltext_s = 'RM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_VAL'.
  wa_fieldcat-seltext_s = 'PM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC_VAL'.
  wa_fieldcat-seltext_s = 'CCPC_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED_VAL'.
  wa_fieldcat-seltext_s = 'ED_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'TOTAL'.
  wa_fieldcat-seltext_s = 'TOTAL_VALUE'.
  append wa_fieldcat to fieldcat.








  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'DEPOT STOCK DETAIL'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = layout
      it_fieldcat             = fieldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    tables
      t_outtab                = it_tab3
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.


endform.                    "updt_ts



* WA_FIELDCAT-fieldname = 'MTART'.
*  WA_FIELDCAT-seltext_s = 'TYPE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'MATNR'.
*  WA_FIELDCAT-seltext_s = 'CODE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'ARKTX'.
*  WA_FIELDCAT-seltext_s = 'MATERIAL'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'CHARG'.
*  WA_FIELDCAT-seltext_s = 'BATCH'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'STOCK'.
*  WA_FIELDCAT-seltext_s = 'TRANSIT_QTY'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*
*
*  WA_FIELDCAT-fieldname = 'RM_RATE'.
*  WA_FIELDCAT-seltext_s = 'RM_RATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'PM_RATE'.
*  WA_FIELDCAT-seltext_s = 'PM_RATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'CCPC'.
*  WA_FIELDCAT-seltext_s = 'CCPC_RATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'ED'.
*  WA_FIELDCAT-seltext_s = 'ED_RATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
**  WA_FIELDCAT-fieldname = 'RM_VAL'.
**  WA_FIELDCAT-seltext_s = 'RM_VALUE'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**
**  WA_FIELDCAT-fieldname = 'PM_VAL'.
**  WA_FIELDCAT-seltext_s = 'PM_VALUE'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**
**  WA_FIELDCAT-fieldname = 'CCPC_VAL'.
**  WA_FIELDCAT-seltext_s = 'CCPC_VALUE'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**
**  WA_FIELDCAT-fieldname = 'ED_VAL'.
**  WA_FIELDCAT-seltext_s = 'ED_VALUE'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**
**  WA_FIELDCAT-fieldname = 'VALUE'.
**  WA_FIELDCAT-seltext_s = 'TOTAL_VALUE'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**
*
*
*
*
*
*
*
*  LAYOUT-zebra = 'X'.
*  LAYOUT-colwidth_optimize = 'X'.
*  LAYOUT-WINDOW_TITLEBAR  = 'TRANSIT STOCK DETAIL'.
*
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*   EXPORTING
**   I_INTERFACE_CHECK                 = ' '
**   I_BYPASSING_BUFFER                = ' '
**   I_BUFFER_ACTIVE                   = ' '
*     I_CALLBACK_PROGRAM                =  G_REPID
**   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = 'USER_COMM'
*   I_CALLBACK_TOP_OF_PAGE            = 'TOP'
**   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**   I_CALLBACK_HTML_END_OF_LIST       = ' '
**   I_STRUCTURE_NAME                  =
**   I_BACKGROUND_ID                   = ' '
**   I_GRID_TITLE                      =
**   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         = LAYOUT
*     IT_FIELDCAT                       = FIELDCAT
**   IT_EXCLUDING                      =
**   IT_SPECIAL_GROUPS                 =
**   IT_SORT                           =
**   IT_FILTER                         =
**   IS_SEL_HIDE                       =
**   I_DEFAULT                         = 'X'
*   I_SAVE                            = 'A'
**   IS_VARIANT                        =
**   IT_EVENTS                         =
**   IT_EVENT_EXIT                     =
**   IS_PRINT                          =
**   IS_REPREP_ID                      =
**   I_SCREEN_START_COLUMN             = 0
**   I_SCREEN_START_LINE               = 0
**   I_SCREEN_END_COLUMN               = 0
**   I_SCREEN_END_LINE                 = 0
**   I_HTML_HEIGHT_TOP                 = 0
**   I_HTML_HEIGHT_END                 = 0
**   IT_ALV_GRAPHICS                   =
**   IT_HYPERLINK                      =
**   IT_ADD_FIELDCAT                   =
**   IT_EXCEPT_QINFO                   =
**   IR_SALV_FULLSCREEN_ADAPTER        =
** IMPORTING
**   E_EXIT_CAUSED_BY_CALLER           =
**   ES_EXIT_CAUSED_BY_USER            =
*    TABLES
*      T_OUTTAB                          = IT_TAB3
*   EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS                            = 2
*            .
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*
*ENDFORM.                    "updt_ts

*&---------------------------------------------------------------------*
*&      Form  update
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update.


  select * from mchb where clabs ne 0 and matnr in material and werks in plant
  order by werks.
    select * from mara where matnr eq mchb-matnr and mtart in m_type.
      select * from t001w where werks eq mchb-werks.
        select single * from mvke where matnr = mchb-matnr.
        select * from mara where matnr eq mchb-matnr and mtart in m_type.
          select * from makt where matnr = mchb-matnr.


            move-corresponding mchb to t_details.
            move mara-mtart to t_details-mtart.
            move-corresponding t001w to t_details.
            move-corresponding mvke to t_details.
            move-corresponding mara to t_details.
            move-corresponding makt to t_details.


            append t_details.

          endselect.
        endselect.
      endselect.
    endselect.
  endselect.

  loop at t_details.

    t_details-clabs1 = t_details-clabs + t_details-cumlm + t_details-cinsm +
                      t_details-ceinm + t_details-cspem + t_details-cretm.

    select single * from zrt_input where batch = t_details-charg.
    t_details-rm_rate = zrt_input-rm_rate.
    t_details-pm_rate = zrt_input-pm_rate.
    t_details-ccpc = zrt_input-ccpc.
    t_details-ed = zrt_input-ed.

    t_details-rm_val = t_details-rm_rate * t_details-clabs.
    t_details-pm_val = t_details-pm_rate * t_details-clabs.
    t_details-ccpc_val = t_details-ccpc * t_details-clabs.
    t_details-ed_val = t_details-ed * t_details-clabs.




    on change of t_details-werks.
      uline.
* write : / t_details-name1,t_details-werks.
      skip.
    endon.
*  write : / t_details-werks,t_details-matnr,t_details-charg,t_details-lgort,
*          t_details-clabs, t_details-mtart,t_details-mvgr1.

    if t_details-charg = zrt_input-batch.
*    write : t_details-rm_rate,t_details-pm_rate,t_details-ccpc,t_details-ed,
*            t_details-rm_val,t_details-pm_val,t_details-ccpc_val,t_details-ed_val.

    else.
      t_details-rm_rate = 0.
      t_details-pm_rate = 0.
      t_details-ccpc = 0.
      t_details-ed = 0.
      t_details-rm_val = 0.
      t_details-pm_val = 0.
      t_details-ccpc_val = 0.
      t_details-ed_val = 0.

*    write : t_details-rm_rate,t_details-pm_rate,t_details-ccpc,t_details-ed,
*          t_details-rm_val,t_details-pm_val,t_details-ccpc_val,t_details-ed_val.


      if t_details-rm_rate = 0.
        if t_details-pm_rate = 0.
          if t_details-ccpc = 0.
            if t_details-ed = 0.



              if t_details-lgort  eq 'FG01'.
                if t_details-werks ne 3000.
                  if t_details-matnr ne 14601.
                    if t_details-matnr ne 14602.
                      if t_details-matnr ne 14603.
                        if t_details-matnr ne 14604.
                          if t_details-matnr ne 37401.
                            if t_details-matnr ne 64601.
                              if t_details-matnr ne 27152.
                                if t_details-matnr ne 28101.

                                  write : /1(5) t_details-werks,8(25) t_details-maktx,34(12) t_details-matnr,
                                            46(15) t_details-charg,61(5) t_details-lgort,67(5) t_details-mtart,t_details-clabs1.
                                endif.
                              endif.
                            endif.
                          endif.
                        endif.
                      endif.
                    endif.
                  endif.
                endif.

              elseif t_details-lgort eq 'FG02'.

                if t_details-matnr ne 14601.
                  if t_details-matnr ne 14602.
                    if t_details-matnr ne 14603.
                      if t_details-matnr ne 14604.
                        if t_details-matnr ne 37401.
                          if t_details-matnr ne 64601.
                            if t_details-matnr ne 27152.
                              if t_details-matnr ne 28101.

                                write : /1(5) t_details-werks,8(25) t_details-maktx,34(12) t_details-matnr,
                                         46(15) t_details-charg,61(5) t_details-lgort,67(5) t_details-mtart,t_details-clabs1.
                              endif.
                            endif.
                          endif.
                        endif.
                      endif.
                    endif.
                  endif.
                endif.

              elseif t_details-lgort eq 'FG03'.

                if t_details-matnr ne 14601.
                  if t_details-matnr ne 14602.
                    if t_details-matnr ne 14603.
                      if t_details-matnr ne 14604.
                        if t_details-matnr ne 37401.
                          if t_details-matnr ne 64601.
                            if t_details-matnr ne 27152.
                              if t_details-matnr ne 28101.

                                write : /1(5) t_details-werks,8(25) t_details-maktx,34(12) t_details-matnr,
                                          46(15) t_details-charg,61(5) t_details-lgort,67(5) t_details-mtart,t_details-clabs1.

                              endif.
                            endif.
                          endif.
                        endif.
                      endif.
                    endif.
                  endif.
                endif.

              elseif t_details-lgort eq 'FG04'.

                if t_details-matnr ne 14601.
                  if t_details-matnr ne 14602.
                    if t_details-matnr ne 14603.
                      if t_details-matnr ne 14604.
                        if t_details-matnr ne 37401.
                          if t_details-matnr ne 64601.
                            if t_details-matnr ne 27152.
                              if t_details-matnr ne 28101.

                                write : /1(5) t_details-werks,8(25) t_details-maktx,34(12) t_details-matnr,
                                         46(15) t_details-charg,61(5) t_details-lgort,67(5) t_details-mtart,t_details-clabs1.
                              endif.
                            endif.
                          endif.
                        endif.
                      endif.
                    endif.
                  endif.
                endif.

              elseif t_details-lgort eq 'MU01'.

                if t_details-werks ne 3000.
                  if t_details-matnr ne 14601.
                    if t_details-matnr ne 14602.
                      if t_details-matnr ne 14603.
                        if t_details-matnr ne 14604.
                          if t_details-matnr ne 37401.
                            if t_details-matnr ne 64601.
                              if t_details-matnr ne 27152.
                                if t_details-matnr ne 28101.

                                  write : /1(5) t_details-werks,8(25) t_details-maktx,34(12) t_details-matnr,
                                            46(15) t_details-charg,61(5) t_details-lgort,67(5) t_details-mtart,t_details-clabs1.
                                endif.
                              endif.
                            endif.
                          endif.
                        endif.
                      endif.
                    endif.
                  endif.
                endif.

              elseif t_details-lgort eq 'MU02'.
                if t_details-werks ne 3000.

                  if t_details-matnr ne 14601.
                    if t_details-matnr ne 14602.
                      if t_details-matnr ne 14603.
                        if t_details-matnr ne 14604.
                          if t_details-matnr ne 37401.
                            if t_details-matnr ne 64601.
                              if t_details-matnr ne 27152.
                                if t_details-matnr ne 28101.

                                  write : /1(5) t_details-werks,8(25) t_details-maktx,34(12) t_details-matnr,
                                         46(15) t_details-charg,61(5) t_details-lgort,67(5) t_details-mtart,t_details-clabs1.
                                endif.
                              endif.
                            endif.
                          endif.
                        endif.
                      endif.
                    endif.
                  endif.
                endif.


              elseif t_details-lgort eq 'MUM'.

                if t_details-werks ne 3000.

                  if t_details-matnr ne 14601.
                    if t_details-matnr ne 14602.
                      if t_details-matnr ne 14603.
                        if t_details-matnr ne 14604.
                          if t_details-matnr ne 37401.
                            if t_details-matnr ne 64601.
                              if t_details-matnr ne 27152.
                                if t_details-matnr ne 28101.

                                  write : /1(5) t_details-werks,8(25) t_details-maktx,34(12) t_details-matnr,
                                          46(15) t_details-charg,61(5) t_details-lgort,67(5) t_details-mtart,t_details-clabs1.
                                endif.
                              endif.
                            endif.
                          endif.
                        endif.
                      endif.
                    endif.
                  endif.
                endif.

              else.
*                  WRITE : / 'INVALID'.
              endif.


            endif.
          endif.
        endif.
      endif.



    endif.
  endloop.




endform.                    "update


*&---------------------------------------------------------------------*
*&      Form  nsk_goa
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form nsk_goa.

*  select * from mchb where matnr in material and ( lgort between loc_from and loc_to )
*   and werks in plant .
*
*    select * from mara where matnr eq mchb-matnr and mtart in m_type.
*      select * from t001w where werks eq mchb-werks.
*        select single * from mvke where matnr = mchb-matnr.
*        select single * from tvm5t where mvgr5 eq mvke-mvgr5.
*        select * from makt where matnr = mchb-matnr.
*          select single * from t023t where matkl eq mara-matkl and spras eq 'EN'.
*          move-corresponding mchb to t_details.
*          move mara-mtart to t_details-mtart.
*          move mara-matkl to t_details-matkl.
*          move-corresponding t001w to t_details.
*          move-corresponding mvke to t_details.
*          move-corresponding makt to t_details.
*          move-corresponding t023t to t_details.
*          move-corresponding tvm5t to t_details.
*
*
*          append t_details.
*        endselect.
*      endselect.
*    endselect.
*  endselect.
  select * from mchb into table it_mchb where matnr in material and lgort ge loc_from and lgort le loc_to and werks in plant.
  if sy-subrc eq 0.
    select * from mara into table it_mara where matnr in material and mtart in m_type.
    if sy-subrc eq 0.
      select * from makt into table it_makt for all entries in it_mara where matnr eq it_mara-matnr.
      select * from mvke into table it_mvke for all entries in it_mara where matnr eq it_mara-matnr and vkorg eq '1000' and vtweg eq '10'.
    endif.
    select * from t001w into table it_t001w where werks in plant.
  endif.

  loop at it_mchb into wa_mchb.
    read table it_mara into wa_mara with key matnr = wa_mchb-matnr.
    if sy-subrc eq 0.
      wa_details-matnr = wa_mchb-matnr.
      wa_details-charg = wa_mchb-charg.
      wa_details-clabs = wa_mchb-clabs.
      wa_details-cumlm = wa_mchb-cumlm.
      wa_details-cinsm = wa_mchb-cinsm.
      wa_details-ceinm = wa_mchb-ceinm.
      wa_details-cspem = wa_mchb-cspem.
      wa_details-cretm = wa_mchb-cretm.
      wa_details-clabs1 = wa_mchb-clabs.
      wa_details-lgort = wa_mchb-lgort.
      wa_details-werks = wa_mchb-werks.
      wa_details-mtart =  wa_mara-mtart.
      wa_details-matkl =  wa_mara-matkl.
      select single * from t023t where matkl eq wa_mara-matkl and spras eq 'EN'.
      if sy-subrc eq 0.
        wa_details-wgbez = t023t-wgbez.
      endif.
      read table it_t001w into wa_t001w with key werks = wa_mchb-werks.
      if sy-subrc eq 0.
        wa_details-kunnr = wa_t001w-kunnr.
        wa_details-name1 = wa_t001w-name1.
      endif.
      read table it_mvke into wa_mvke with key matnr = wa_mchb-matnr.
      if sy-subrc eq 0.
        wa_details-mvgr1 = wa_mvke-mvgr1.
        wa_details-mvgr5 = wa_mvke-mvgr5.
        select single * from tvm5t where mvgr5 eq wa_mvke-mvgr5.
        if sy-subrc eq 0.
          wa_details-bezei = tvm5t-bezei.
        endif.
      else.
        select single * from mvke where matnr = wa_mchb-matnr and vkorg eq '2000' and vtweg eq '20'.
        if sy-subrc eq 0.
          wa_details-mvgr1 = mvke-mvgr1.
          wa_details-mvgr5 = mvke-mvgr5.
          select single * from tvm5t where mvgr5 eq mvke-mvgr5.
          if sy-subrc eq 0.
            wa_details-bezei = tvm5t-bezei.
          endif.
        endif.
      endif.
      read table it_makt into wa_makt with key matnr = wa_mchb-matnr.
      if sy-subrc eq 0.
        wa_details-maktx = wa_makt-maktx.
      endif.
      collect wa_details into it_details.
      clear wa_details.
    endif.
  endloop.


  loop at it_details into wa_details.

    wa_details-clabs1 = wa_details-clabs + wa_details-cumlm + wa_details-cinsm + wa_details-ceinm + wa_details-cspem + wa_details-cretm.
    select single * from zrt_input where batch = wa_details-charg and matnr = wa_details-matnr.
    if sy-subrc eq 0.
      wa_details-rm_rate = zrt_input-rm_rate.
      wa_details-pm_rate = zrt_input-pm_rate.
      wa_details-ccpc = zrt_input-ccpc.
      if wa_details-mtart ne 'ZESC'.
        wa_details-ed = zrt_input-ed.
      else.
        wa_details-ed = 0.
      endif.
    endif.
    wa_details-rm_val = wa_details-rm_rate * wa_details-clabs1.
    wa_details-pm_val = wa_details-pm_rate * wa_details-clabs1.
    wa_details-ccpc_val = wa_details-ccpc * wa_details-clabs1.
    wa_details-ed_val = wa_details-ed * wa_details-clabs1.
    wa_details-total = wa_details-rm_val + wa_details-pm_val + wa_details-ccpc_val + wa_details-ed_val.
    on change of wa_details-werks.
      wa_tab5-name1 = wa_details-name1.
      wa_tab5-werks =  wa_details-werks.
    endon.

    if wa_details-clabs1 ne 0.
*      write : /1(5) wa_details-werks,8(9) wa_details-matkl,20(15) wa_details-wgbez,38(10) wa_details-matnr,
*                 51(25) wa_details-maktx,79(12) wa_details-charg,94(5) wa_details-lgort,103(5) wa_details-mtart,
*                 111(5) wa_details-mvgr1,119(3) wa_details-bezei,130(15) wa_details-clabs1.
      wa_tab5-werks1 = wa_details-werks.
      wa_tab5-matkl = wa_details-matkl.
      wa_tab5-wgbez = wa_details-wgbez.
      wa_tab5-matnr = wa_details-matnr.
      wa_tab5-maktx = wa_details-maktx.
      wa_tab5-charg = wa_details-charg.
      wa_tab5-lgort = wa_details-lgort.
      wa_tab5-mtart = wa_details-mtart.
      wa_tab5-mvgr1 = wa_details-mvgr1.
      wa_tab5-bezei = wa_details-bezei.
      wa_tab5-clabs1 = wa_details-clabs1.
      if wa_details-matnr = zrt_input-matnr.
        if wa_details-charg = zrt_input-batch.
          wa_tab5-rm_rate = wa_details-rm_rate.
          wa_tab5-pm_rate = wa_details-pm_rate.
          wa_tab5-ccpc = wa_details-ccpc.
          wa_tab5-ed = wa_details-ed.
          wa_tab5-rm_val = wa_details-rm_val.
          wa_tab5-pm_val = wa_details-pm_val.
          wa_tab5-ccpc_val = wa_details-ccpc_val.
          wa_tab5-ed_val = wa_details-ed_val.
          wa_tab5-total = wa_details-total.
        else.
          wa_details-rm_rate = 0.
          wa_details-pm_rate = 0.
          wa_details-ccpc = 0.
          wa_details-ed = 0.
          wa_details-rm_val = 0.
          wa_details-pm_val = 0.
          wa_details-ccpc_val = 0.
          wa_details-ed_val = 0.
          wa_details-total = 0.

          wa_tab5-rm_rate = 0.
          wa_tab5-pm_rate = 0.
          wa_tab5-ccpc = 0.
          wa_tab5-ed = 0.
          wa_tab5-rm_val = 0.
          wa_tab5-pm_val = 0.
          wa_tab5-ccpc_val = 0.
          wa_tab5-ed_val = 0.
          wa_tab5-total = 0.
        endif.

      else.
        wa_details-rm_rate = 0.
        wa_details-pm_rate = 0.
        wa_details-ccpc = 0.
        wa_details-ed = 0.
        wa_details-rm_val = 0.
        wa_details-pm_val = 0.
        wa_details-ccpc_val = 0.
        wa_details-ed_val = 0.
        wa_details-total = 0.

        wa_tab5-rm_rate = 0.
        wa_tab5-pm_rate = 0.
        wa_tab5-ccpc = 0.
        wa_tab5-ed = 0.
        wa_tab5-rm_val = 0.
        wa_tab5-pm_val = 0.
        wa_tab5-ccpc_val = 0.
        wa_tab5-ed_val = 0.
        wa_tab5-total = 0.
      endif.
      collect wa_tab5 into it_tab5.
      clear wa_tab5.
    endif.
    clear wa_tab5.
  endloop.

  loop at it_tab5 into wa_tab5.
*     write : / wa_tab5-name1,wa_tab5-werks.
*     write : /1(5) wa_tab5-werks1,8(9) wa_tab5-matkl,20(15) wa_tab5-wgbez,38(10) wa_tab5-matnr,
*                 51(25) wa_tab5-maktx,79(12) wa_tab5-charg,94(5) wa_tab5-lgort,103(5) wa_tab5-mtart,
*                 111(5) wa_tab5-mvgr1,119(3) wa_tab5-bezei,130(15) wa_tab5-clabs1.
*
*      write :     148(6) wa_tab5-rm_rate,157(6) wa_tab5-pm_rate,166(6) wa_tab5-ccpc,175(6) wa_tab5-ed,
*                      184(15) wa_tab5-rm_val,202(15) wa_tab5-pm_val,220(15) wa_tab5-ccpc_val,
*                      238(15) wa_tab5-ed_val,256(20) wa_tab5-total.

    pack wa_tab5-matnr to wa_tab5-matnr.
    condense wa_tab5-matnr.
    modify it_tab5 from wa_tab5 transporting matnr.
    clear wa_tab5.
  endloop.



  wa_fieldcat-fieldname = 'WERKS1'.
  wa_fieldcat-seltext_s = 'PLANT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MTART'.
  wa_fieldcat-seltext_s = 'TYPE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-seltext_s = 'STOR_LOC'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'WGBEZ'.
  wa_fieldcat-seltext_s = 'GROUP'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_s = 'CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_s = 'MATERIAL'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_s = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MVGR1'.
  wa_fieldcat-seltext_s = 'FORM'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-fieldname = 'VTEXT'.
*  WA_FIELDCAT-seltext_s = 'TYPE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'VTEXT1'.
*  WA_FIELDCAT-seltext_s = 'DC/CO'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_s = 'PAC_SIZE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CLABS1'.
  wa_fieldcat-seltext_s = 'STOCK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RM_RATE'.
  wa_fieldcat-seltext_s = 'RM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_RATE'.
  wa_fieldcat-seltext_s = 'PM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC'.
  wa_fieldcat-seltext_s = 'CCPC_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED'.
  wa_fieldcat-seltext_s = 'ED_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RM_VAL'.
  wa_fieldcat-seltext_s = 'RM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_VAL'.
  wa_fieldcat-seltext_s = 'PM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC_VAL'.
  wa_fieldcat-seltext_s = 'CCPC_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED_VAL'.
  wa_fieldcat-seltext_s = 'ED_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'TOTAL'.
  wa_fieldcat-seltext_s = 'TOTAL_VALUE'.
  append wa_fieldcat to fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'NASIK GOA STOCK DETAIL'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = layout
      it_fieldcat             = fieldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    tables
      t_outtab                = it_tab5
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.





endform.                    "nsk_goa

top-of-page.

*  if depot = 'X'.
*    write : /1(5) 'PLANT',
*             8(9) 'GROUP',
*             20(15) 'GROUP_DES',
*             38(10) 'CODE',
*             51(25) 'MATERIAL',
*             79(12) 'BATCH',
*             94(5) 'SLOC',
*             103(5) 'TYPE',
*             111(5) 'FORM',
*             119(8) 'PAC-SIZE',
*             135 'STOCK',
*             148(6) 'RM-RATE',
*             157(6) 'PM-RATE',
*             166(6) 'CCPC',
*             175(6) ' ED',
*             184(15) '   RM-VALUE',
*             202(15) '   PM-VALUE',
*             220(15) ' CCPC-VALUE',
*             238(15) '   ED-VALUE',
*             256(20) '        TOTAL'.
*    uline.
*    skip.
*  elseif nsk_goa = 'X'.
*    write : /1(5) 'PLANT',
*    8(9) 'GROUP',
*    20(15) 'GROUP_DES',
*    38(10) 'CODE',
*    51(25) 'MATERIAL',
*    79(12) 'BATCH',
*    94(5) 'SLOC',
*    103(5) 'TYPE',
*    111(5) 'FORM',
*    119(8) 'PAC-SIZE',
*    135 'STOCK',
*    148(6) 'RM-RATE',
*    157(6) 'PM-RATE',
*    166(6) 'CCPC',
*    175(6) ' ED',
*    184(15) '   RM-VALUE',
*    202(15) '   PM-VALUE',
*    220(15) ' CCPC-VALUE',
*    238(15) '   ED-VALUE',
*    256(20) '        TOTAL'.
*    uline.
*    skip.
  if summ_ng = 'X'.
    write : /1(5) 'PLANT',
             31(15) '     STOCK',
             47(15) '     RM VALUE',
             62(15) '     PM VALUE',
             77(15) '     CCPC VALUE',
             93(15) '     ED VALUE',
             108(15) '     TOTAL'.
    skip.
  elseif summ_dp = 'X'.
    write : /1(15) 'LOCATION',
             16(15) 'STOCK',
             31(15) ' RM VALUE',
             47(15) ' PM VALUE',
             62(15) ' CCPC VALUE',
             77(15) ' ED VALUE ',
             92(15) ' TOTAL',
             107(15) ' FREIGHT VALUE',
             122(15) 'TOTAL VALUE'.
    uline.


  endif.

*&---------------------------------------------------------------------*
*&      Form  summ_ng
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form summ_ng.


  select * from mchb into table it_mchb where matnr in material and lgort ge loc_from and lgort le loc_to and werks in plant.
  if sy-subrc eq 0.
    select * from mara into table it_mara where matnr in material and mtart in m_type.
    select * from t001w into table it_t001w where werks in plant.
  endif.

  loop at it_mchb into wa_mchb.
    read table it_mara into wa_mara with key matnr = wa_mchb-matnr.
    if sy-subrc eq 0.
      wa_details-matnr = wa_mchb-matnr.
      wa_details-charg = wa_mchb-charg.
      wa_details-clabs = wa_mchb-clabs.
      wa_details-cumlm = wa_mchb-cumlm.
      wa_details-cinsm = wa_mchb-cinsm.
      wa_details-ceinm = wa_mchb-ceinm.
      wa_details-cspem = wa_mchb-cspem.
      wa_details-cretm = wa_mchb-cretm.
      wa_details-clabs1 = wa_mchb-clabs.
      wa_details-lgort = wa_mchb-lgort.
      wa_details-werks = wa_mchb-werks.

      wa_details-mtart =  wa_mara-mtart.
      wa_details-matkl =  wa_mara-matkl.
      select single * from t023t where matkl eq wa_mara-matkl and spras eq 'EN'.
      if sy-subrc eq 0.
        wa_details-wgbez = t023t-wgbez.
      endif.

      read table it_t001w into wa_t001w with key werks = wa_mchb-werks.
      if sy-subrc eq 0.
        wa_details-kunnr = wa_t001w-kunnr.
        wa_details-name1 = wa_t001w-name1.
      endif.
      read table it_mvke into wa_mvke with key matnr = wa_mchb-matnr.
      if sy-subrc eq 0.
        wa_details-mvgr1 = wa_mvke-mvgr1.
        wa_details-mvgr5 = wa_mvke-mvgr5.
        select single * from tvm5t where mvgr5 eq wa_mvke-mvgr5.
        if sy-subrc eq 0.
          wa_details-bezei = tvm5t-bezei.
        endif.
      endif.
      read table it_makt into wa_makt with key matnr = wa_mchb-matnr.
      if sy-subrc eq 0.
        wa_details-maktx = wa_makt-maktx.
      endif.
      collect wa_details into it_details.
      clear wa_details.
    endif.
  endloop.

*  select * from mchb where matnr in material and ( lgort between loc_from and loc_to )
*   and werks in plant order by werks.
*
*    select * from mara where matnr eq mchb-matnr and mtart in m_type.
*      select * from t001w where werks eq mchb-werks.
*        select single * from mvke where matnr = mchb-matnr.
*        select * from makt where matnr = mchb-matnr.
*
*          move-corresponding mchb to t_details.
*          move mara-mtart to t_details-mtart.
*          move-corresponding t001w to t_details.
*          move-corresponding mvke to t_details.
*          move-corresponding makt to t_details.
*
*
*          append t_details.
*        endselect.
*      endselect.
*    endselect.
*  endselect.

  sort it_details by werks.

  loop at it_details into wa_details.

    wa_details-clabs1 = wa_details-clabs + wa_details-cumlm + wa_details-cinsm + wa_details-ceinm + wa_details-cspem + wa_details-cretm.

    select single * from zrt_input where batch = wa_details-charg and matnr eq wa_details-matnr.
    if sy-subrc eq 0.
      wa_details-rm_rate = zrt_input-rm_rate.
      wa_details-pm_rate = zrt_input-pm_rate.
      wa_details-ccpc = zrt_input-ccpc.
      if wa_details-mtart ne 'ZESC'.
        wa_details-ed = zrt_input-ed.
      else.
        wa_details-ed = 0.
      endif.
    endif.
    wa_details-rm_val = wa_details-rm_rate * wa_details-clabs1.
    wa_details-pm_val = wa_details-pm_rate * wa_details-clabs1.
    wa_details-ccpc_val = wa_details-ccpc * wa_details-clabs1.
    wa_details-ed_val = wa_details-ed * wa_details-clabs1.
    wa_details-total = wa_details-rm_val + wa_details-pm_val + wa_details-ccpc_val + wa_details-ed_val.

    if wa_details-werks eq '1000'.
      if wa_details-lgort eq 'FG01'.
        tot11 = tot11 + wa_details-clabs1.
      elseif wa_details-lgort eq 'FG02'.
        tot12 = tot12 + wa_details-clabs1.
      elseif wa_details-lgort eq 'FG03'.
        tot13 = tot13 + wa_details-clabs1.
      elseif wa_details-lgort eq 'FG04'.
        tot14 = tot14 + wa_details-clabs1.
      endif.
    endif.

    if wa_details-werks eq '1001'.
      if wa_details-lgort eq 'FG01'.
        tot21 = tot21 + wa_details-clabs1.
      elseif wa_details-lgort eq 'FG02'.
        tot22 = tot22 + wa_details-clabs1.
      elseif wa_details-lgort eq 'FG03'.
        tot23 = tot23 + wa_details-clabs1.
      elseif wa_details-lgort eq 'FG04'.
        tot24 = tot24 + wa_details-clabs1.
      endif.
    endif.
    if wa_details-werks eq '1000'.
      if wa_details-lgort eq 'FG01'.
        tot1rm_val = tot1rm_val + wa_details-rm_val.
        tot1pm_val = tot1pm_val + wa_details-pm_val.
        tot1ccpc_val = tot1ccpc_val + wa_details-ccpc_val.
        tot1ed_val = tot1ed_val + wa_details-ed_val.
      elseif wa_details-lgort eq 'FG02'.
        tot2rm_val = tot2rm_val + wa_details-rm_val.
        tot2pm_val = tot2pm_val + wa_details-pm_val.
        tot2ccpc_val = tot2ccpc_val + wa_details-ccpc_val.
        tot2ed_val = tot2ed_val + wa_details-ed_val.
      elseif wa_details-lgort eq 'FG03'.
        tot3rm_val = tot3rm_val + wa_details-rm_val.
        tot3pm_val = tot3pm_val + wa_details-pm_val.
        tot3ccpc_val = tot3ccpc_val + wa_details-ccpc_val.
        tot3ed_val = tot3ed_val + wa_details-ed_val.
      elseif wa_details-lgort eq 'FG04'.
        tot4rm_val = tot4rm_val + wa_details-rm_val.
        tot4pm_val = tot4pm_val + wa_details-pm_val.
        tot4ccpc_val = tot4ccpc_val + wa_details-ccpc_val.
        tot4ed_val = tot4ed_val + wa_details-ed_val.
      endif.
    endif.

    if wa_details-werks eq '1001'.
      if wa_details-lgort eq 'FG01'.
        tot11rm_val = tot11rm_val + wa_details-rm_val.
        tot11pm_val = tot11pm_val + wa_details-pm_val.
        tot11ccpc_val = tot11ccpc_val + wa_details-ccpc_val.
        tot11ed_val = tot11ed_val + wa_details-ed_val.
      elseif wa_details-lgort eq 'FG02'.
        tot21rm_val = tot21rm_val + wa_details-rm_val.
        tot21pm_val = tot21pm_val + wa_details-pm_val.
        tot21ccpc_val = tot21ccpc_val + wa_details-ccpc_val.
        tot21ed_val = tot21ed_val + wa_details-ed_val.
      elseif wa_details-lgort eq 'FG03'.
        tot31rm_val = tot31rm_val + wa_details-rm_val.
        tot31pm_val = tot31pm_val + wa_details-pm_val.
        tot31ccpc_val = tot31ccpc_val + wa_details-ccpc_val.
        tot31ed_val = tot31ed_val + wa_details-ed_val.
      elseif wa_details-lgort eq 'FG04'.
        tot41rm_val = tot41rm_val + wa_details-rm_val.
        tot41pm_val = tot41pm_val + wa_details-pm_val.
        tot41ccpc_val = tot41ccpc_val + wa_details-ccpc_val.
        tot41ed_val = tot41ed_val + wa_details-ed_val.
      endif.
    endif.
  endloop.
  tot1 = tot1rm_val + tot1pm_val + tot1ccpc_val + tot1ed_val.
  tot2 = tot2rm_val + tot2pm_val + tot2ccpc_val + tot2ed_val.
  tot3 = tot3rm_val + tot3pm_val + tot3ccpc_val + tot3ed_val.
  tot4 = tot4rm_val + tot4pm_val + tot4ccpc_val + tot4ed_val.

  write : /1(30) 'NASHIK : LOCATION - FG01  ',31(15) tot11, 47(15) tot1rm_val,62(15) tot1pm_val,77(15) tot1ccpc_val,93(15) tot1ed_val,108(15) tot1,
          /1(30) 'NASHIK : LOCATION - FG02  ',31(15) tot12,47(15) tot2rm_val,62(15) tot2pm_val,77(15) tot2ccpc_val,93(15) tot2ed_val,108(15) tot2,
          /1(30) 'NASHIK : LOCATION - FG03  ',31(15) tot13,47(15) tot3rm_val,62(15) tot3pm_val,77(15) tot3ccpc_val,93(15) tot3ed_val,108(15) tot3,
          /1(30) 'NASHIK : LOCATION - FG04  ',31(15) tot14,47(15) tot4rm_val,62(15) tot4pm_val,77(15) tot4ccpc_val, 93(15) tot4ed_val,108(15) tot4.

  tot2000 = tot11 + tot12 + tot13 + tot14.
  tot2001 = tot1rm_val + tot2rm_val + tot3rm_val + tot4rm_val.
  tot2002 = tot1pm_val + tot2pm_val + tot3pm_val + tot4pm_val.
  tot2003 = tot1ccpc_val + tot2ccpc_val + tot3ccpc_val + tot4ccpc_val.
  tot2004 = tot1ed_val + tot2ed_val + tot3ed_val + tot4ed_val.
  tot2005 = tot1 + tot2 + tot3 + tot4.

  skip.
  write : / 'GRAND TOTAL : ',31(15) tot2000,47(15) tot2001,62(15) tot2002, 77(15) tot2003,93(15) tot2004,108(15) tot2005.
  uline.

  tot1 = 0.
  tot2 = 0.
  tot3 = 0.
  tot4 = 0.
  tot2000 = 0.
  tot2001 = 0.
  tot2002 = 0.
  tot2003 = 0.
  tot2004 = 0.

  tot1 = tot11rm_val + tot11pm_val + tot11ccpc_val + tot11ed_val.
  tot2 = tot21rm_val + tot21pm_val + tot21ccpc_val + tot21ed_val.
  tot3 = tot31rm_val + tot31pm_val + tot31ccpc_val + tot31ed_val.
  tot4 = tot41rm_val + tot41pm_val + tot41ccpc_val + tot41ed_val.

  write : /'GOA : LOCATION - FG01  ',31(15) tot21,
           47(15) tot11rm_val,62(15) tot11pm_val,77(15) tot11ccpc_val,
           93(15) tot11ed_val,108(15) tot1,
          /'GOA : LOCATION - FG02  ',31(15) tot22,
          47(15) tot21rm_val,62(15) tot21pm_val,77(15) tot21ccpc_val,
          93(15) tot21ed_val,108(15) tot2,
          /'GOA : LOCATION - FG03  ',31(15) tot23,
          47(15) tot31rm_val,62(15) tot31pm_val,77(15) tot31ccpc_val,
          93(15) tot31ed_val,108(15) tot3,
          /'GOA : LOCATION - FG04  ',31(15) tot24,
          47(15) tot41rm_val,62(15) tot41pm_val,77(15) tot41ccpc_val,
          93(15) tot41ed_val,108(15) tot4.

  skip.
  tot2000 = tot21 + tot22 + tot23 + tot24.
  tot2001 = tot11rm_val + tot21rm_val + tot31rm_val + tot41rm_val.
  tot2002 = tot11pm_val + tot21pm_val + tot31pm_val + tot41pm_val.
  tot2003 = tot11ccpc_val + tot21ccpc_val + tot31ccpc_val + tot41ccpc_val.
  tot2004 = tot11ed_val + tot21ed_val + tot31ed_val + tot41ed_val.
  tot2005 = tot1 + tot2 + tot3 + tot4.

  write : / 'GRAND TOTAL : ',31(15) tot2000,47(15) tot2001,62(15) tot2002,
            77(15) tot2003,93(15) tot2004,108(15) tot2005.

endform.                    "summ_ng


*&---------------------------------------------------------------------*
*&      Form  summ_dp
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form summ_dp.

*select * from mchb where clabs ne 0 and ( lgort between loc_from and loc_to )
* order by werks matnr .
  select * from mchb into table it_mchb where matnr in material and werks ne 1000 and werks ne 1001
  and werks in plant.
  if sy-subrc eq 0.
    select * from mara into table it_mara where matnr in material and mtart in m_type.
    select * from t001w into table it_t001w where werks in plant.
    select * from mvke into table it_mvke for all entries in it_mara where matnr = it_mara-matnr.
    select * from makt into table it_makt for all entries in it_mara where spras eq 'EN' and matnr = it_mara-matnr.
*    select * from zrt_input into table it_zrt_input for all entries in it_mchb where matnr eq it_mchb-matnr
*      and batch eq it_mchb-charg.
*          Select * from t023t into table it_t023t FOR ALL ENTRIES IN it_mchb where matkl eq mara-matkl
*            and spras eq 'EN'.
*            sort it_mchb by matnr.
  endif.

  if it_mchb is not initial.
    select * from zrt_input into table it_zrt_input where matnr in material.
  endif.

  loop at it_mchb into wa_mchb.
    stock1 = wa_mchb-clabs + wa_mchb-cspem + wa_mchb-cumlm + wa_mchb-cinsm + wa_mchb-cretm.
    if stock1 ne 0.

      wa_tab1-block = wa_mchb-cspem.
      wa_tab1-matnr = wa_mchb-matnr.
      wa_tab1-charg = wa_mchb-charg.
      wa_tab1-lgort = wa_mchb-lgort.
      wa_tab1-werks = wa_mchb-werks.
      wa_tab1-stock = stock1.

      collect wa_tab1 into it_tab1.
    endif.
    clear wa_tab1.

  endloop.


  loop at it_tab1 into wa_tab1.
*  write : / wa_tab1-werks,wa_tab1-matnr,wa_tab1-charg,wa_tab1-lgort,wa_tab1-stock,wa_tab1-lgort.


    wa_tab2-lgort = wa_tab1-lgort.
    read table it_makt into wa_makt with key matnr = wa_tab1-matnr.
    if sy-subrc eq 0.
*    write : wa_makt-maktx.
      wa_tab2-maktx = wa_makt-maktx.
    endif.
    read table it_mvke into wa_mvke with key matnr = wa_tab1-matnr.
    if sy-subrc eq 0.
*    write : wa_mvke-mvgr1.
      wa_tab2-mvgr1 = wa_mvke-mvgr1.
*     wa_mvke-provg,wa_mvke-kondm,wa_mvke-ktgrm,,wa_mvke-mvgr5.

      select single * from tvprt where provg eq wa_mvke-provg and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : TVPRT-VTEXT.
        wa_tab2-vtext = tvprt-vtext.
      endif.
      select single * from t178t where kondm eq wa_mvke-kondm and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : T178t-vtext.
        wa_tab2-vtext1 = t178t-vtext.
      endif.
      select single * from tvkmt where ktgrm eq wa_mvke-ktgrm and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : Tvkmt-vtext.
        wa_tab2-vtext2 = tvkmt-vtext.
      endif.
      select single * from tvm5t where mvgr5 eq wa_mvke-mvgr5 and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : Tvm5t-bezei.
        wa_tab2-bezei = tvm5t-bezei.
      endif.

    endif.

    wa_tab2-stock = wa_tab1-stock.
    wa_tab2-werks = wa_tab1-werks.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-lgort = wa_tab1-lgort.

    read table it_zrt_input into wa_zrt_input with key matnr = wa_tab1-matnr batch = wa_tab1-charg.
    if sy-subrc eq 0.
*    WRITE : WA_ZRT_INPUT-RM_RATE,WA_ZRT_INPUT-PM_RATE,WA_ZRT_INPUT-CCPC,WA_ZRT_INPUT-ED.
      wa_tab2-rm_rate = wa_zrt_input-rm_rate.
      wa_tab2-pm_rate = wa_zrt_input-pm_rate.
      wa_tab2-ccpc = wa_zrt_input-ccpc.
      wa_tab2-ed = wa_zrt_input-ed.

    endif.

    collect wa_tab2 into it_tab2.
    clear wa_tab2.

  endloop.

  loop at it_tab2 into wa_tab2.
    read table it_mara into wa_mara with key matnr = wa_tab2-matnr.
    if sy-subrc eq 0.
**    write : wa_mara-mtart,wa_mara-matkl.
      wa_tab3-mtart =  wa_mara-mtart.
      select single * from t023t where matkl eq wa_mara-matkl and spras eq 'EN'.
      if sy-subrc eq 0.
*        WRITE : T023T-WGBEZ.
        wa_tab3-wgbez = t023t-wgbez.
      endif.

      wa_tab3-werks = wa_tab2-werks.
      wa_tab3-matnr = wa_tab2-matnr.
      wa_tab3-charg = wa_tab2-charg.
      wa_tab3-lgort = wa_tab2-lgort.

      wa_tab3-maktx = wa_tab2-maktx.
      wa_tab3-stock = wa_tab2-stock.
*   WA_TAB3-mtart = WA_TAB2-mtart.
      wa_tab3-mvgr1 = wa_tab2-mvgr1.
      wa_tab3-vtext = wa_tab2-vtext.
      wa_tab3-vtext1 = wa_tab2-vtext1.
      wa_tab3-vtext2 = wa_tab2-vtext2.
      wa_tab3-bezei = wa_tab2-bezei.
*   WA_TAB3-WGBEZ = WA_TAB2-WGBEZ.
      wa_tab3-rm_rate = wa_tab2-rm_rate.
      wa_tab3-pm_rate = wa_tab2-pm_rate.
      wa_tab3-ccpc = wa_tab2-ccpc.
      wa_tab3-ed = wa_tab2-ed.

      wa_tab3-rm_val = wa_tab2-rm_rate * wa_tab2-stock.
      wa_tab3-pm_val = wa_tab2-pm_rate * wa_tab2-stock.
      wa_tab3-ccpc_val = wa_tab2-ccpc * wa_tab2-stock.
      wa_tab3-ed_val = wa_tab2-ed * wa_tab2-stock.
      wa_tab3-total = wa_tab3-rm_val + wa_tab3-pm_val + wa_tab3-ccpc_val + wa_tab3-ed_val.

      collect wa_tab3 into it_tab3.
    endif.

  endloop.

  loop at it_tab3 into wa_tab3.
*   wa_tab4-mtart =  wa_mara-mtart.
*    WA_tab4-WGBEZ = T023T-WGBEZ.
    wa_tab4-werks = wa_tab3-werks.
*   WA_tab4-MATNR = WA_tab3-MATNR.
*   WA_tab4-CHARG = WA_tab3-CHARG.
*   WA_tab4-LGORT = WA_tab3-LGORT.

*   WA_tab4-maktx = WA_tab3-maktx.
    wa_tab4-stock = wa_tab3-stock.
*   WA_tab4-mtart = WA_tab3-mtart.
*   WA_tab4-mvgr1 = WA_tab3-mvgr1.
*   WA_tab4-VTEXT = WA_tab3-VTEXT.
*   WA_tab4-VTEXT1 = WA_tab3-VTEXT1.
*   WA_tab4-VTEXT2 = WA_tab3-VTEXT2.
*   WA_tab4-bezei = WA_tab3-bezei.
*   WA_tab4-WGBEZ = WA_tab3-WGBEZ.
    wa_tab4-rm_rate = wa_tab3-rm_rate.
    wa_tab4-pm_rate = wa_tab3-pm_rate.
    wa_tab4-ccpc = wa_tab3-ccpc.
    wa_tab4-ed = wa_tab3-ed.

    wa_tab4-rm_val = wa_tab3-rm_rate * wa_tab3-stock.
    wa_tab4-pm_val = wa_tab3-pm_rate * wa_tab3-stock.
    wa_tab4-ccpc_val = wa_tab3-ccpc * wa_tab3-stock.
    wa_tab4-ed_val = wa_tab3-ed * wa_tab3-stock.
    wa_tab4-total = wa_tab4-rm_val + wa_tab4-pm_val + wa_tab4-ccpc_val + wa_tab4-ed_val.
    wa_tab4-freight = ( wa_tab4-total * freight ) / 100.
    wa_tab4-t_val = wa_tab4-total + wa_tab4-freight.

    select single * from t001w where werks eq wa_tab3-werks.
    if sy-subrc eq 0.
      wa_tab4-kunnr = t001w-kunnr.
    endif.

    collect wa_tab4 into it_tab4.
    clear wa_tab4.


  endloop.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_s = 'PLANT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'KUNNR'.
  wa_fieldcat-seltext_s = 'LOCATION'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-fieldname = 'MTART'.
*  WA_FIELDCAT-seltext_s = 'TYPE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'LGORT'.
*  WA_FIELDCAT-seltext_s = 'STOR_LOC'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'WGBEZ'.
*  WA_FIELDCAT-seltext_s = 'GROUP'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'MATNR'.
*  WA_FIELDCAT-seltext_s = 'CODE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
* WA_FIELDCAT-fieldname = 'MAKTX'.
*  WA_FIELDCAT-seltext_s = 'MATERIAL'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

*  WA_FIELDCAT-fieldname = 'CHARG'.
*  WA_FIELDCAT-seltext_s = 'BATCH'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'MVGR1'.
*  WA_FIELDCAT-seltext_s = 'FORM'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'VTEXT'.
*  WA_FIELDCAT-seltext_s = 'TYPE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'VTEXT1'.
*  WA_FIELDCAT-seltext_s = 'DC/CO'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'BEZEI'.
*  WA_FIELDCAT-seltext_s = 'PAC_SIZE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*

  wa_fieldcat-fieldname = 'STOCK'.
  wa_fieldcat-seltext_s = 'STOCK'.
  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'RM_RATE'.
  wa_fieldcat-seltext_s = 'RM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_RATE'.
  wa_fieldcat-seltext_s = 'PM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC'.
  wa_fieldcat-seltext_s = 'CCPC_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED'.
  wa_fieldcat-seltext_s = 'ED_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RM_VAL'.
  wa_fieldcat-seltext_s = 'RM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_VAL'.
  wa_fieldcat-seltext_s = 'PM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC_VAL'.
  wa_fieldcat-seltext_s = 'CCPC_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED_VAL'.
  wa_fieldcat-seltext_s = 'ED_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'TOTAL'.
  wa_fieldcat-seltext_s = 'VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FREIGHT'.
  wa_fieldcat-seltext_s = 'FREIGHT_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'T_VAL'.
  wa_fieldcat-seltext_s = 'TOTAL_VALUE'.
  append wa_fieldcat to fieldcat.








  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'DEPOT STOCK DETAIL'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = layout
      it_fieldcat             = fieldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    tables
      t_outtab                = it_tab4
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "summ_dp

data : rm_val   type p decimals 2,
       pm_val   type p decimals 2,
       ccpc_val type p decimals 2,
       ed_val   type p decimals 2,
       val_tot  type p decimals 2.

*&---------------------------------------------------------------------*
*&      Form  tran_stk
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*form tran_stk.

*  select * from mkpf where budat in s_budat.
*    select * from mseg where mblnr eq mkpf-mblnr and matnr in material and werks in plant.
*      move-corresponding mseg to itab1.
*      append itab1.
*    endselect.
*  endselect.
*  sort itab1 by matnr.
**delete adjacent duplicates from itab1 comparing ebeln.
*  loop at itab1.
*    if itab1-ebeln ne ' '.
*      select single * from ekpo where ebeln eq itab1-ebeln and matnr eq itab1-matnr
*        and werks eq itab1-werks.
*
*      if itab1-bwart eq '101'.
*        itab1-menge = itab1-menge * ( - 1 ).
*      elseif itab1-bwart eq '642'.
*        itab1-menge = itab1-menge * ( - 1 ).
*      endif.
*
*      if ekpo-elikz ne 'X'.
*        move itab1-ebeln to itab2-ebeln.
*        move itab1-matnr to itab2-matnr.
*        move itab1-werks to itab2-werks.
*        move itab1-ebelp to itab2-ebelp.
*        move itab1-menge to itab2-menge.
*        collect itab2.
*
**write : / itab1-ebeln,itab1-matnr,itab1-menge,itab1-bwart,itab1-ebelp,
**          ekpo-elikz.
** val_tot = val_tot + itab1-menge.
*
*      endif.
*
**   Endselect.
*    endif.
*  endloop.
*  sort itab2 by werks matnr.
*  loop at itab2.
*    if itab2-menge ne 0.
*
*      select single * from mara where matnr eq itab2-matnr.
*      if mara-mtart ne 'ZDSM'.
*
*        write : /1(5) itab2-werks,8(10) itab2-ebeln,21(10) itab2-matnr,
*                 34(12) itab2-menge,49(4) mara-mtart.
**           itab2-ebelp.
*        select single * from mseg where ebeln eq itab2-ebeln and matnr eq
*          itab2-matnr and werks eq itab2-werks and ebelp eq itab2-ebelp.
*        write : 56(12) mseg-umcha.
*
*        select single * from zrt_input where batch eq mseg-umcha.
*        if zrt_input-batch eq mseg-umcha.
*
*          write : 71(5) zrt_input-rm_rate,79(5) zrt_input-pm_rate,
*                  87(5) zrt_input-ccpc,95(5) zrt_input-ed.
*
*          rm_val = zrt_input-rm_rate * itab2-menge.
*          pm_val = zrt_input-pm_rate * itab2-menge.
*          ccpc_val = zrt_input-ccpc * itab2-menge.
*          ed_val = zrt_input-ed * itab2-menge.
*          total = rm_val + pm_val + ccpc_val + ed_val.
*          write :  103(12) rm_val,118(12) pm_val,133(12) ccpc_val,148(12) ed_val,
*                   163(15) total.
*
*        else.
*          zrt_input-rm_rate = 0.
*          zrt_input-pm_rate = 0.
*          zrt_input-ccpc = 0.
*          zrt_input-ed = 0.
*          rm_val = 0.
*          pm_val = 0.
*          ccpc_val = 0.
*          ed_val = 0.
*          total = 0.
*
*          write : 71(5) zrt_input-rm_rate,79(5) zrt_input-pm_rate,
*                 87(5) zrt_input-ccpc,95(5) zrt_input-ed,103(12) rm_val,
*                 118(12) pm_val,133(12) ccpc_val,148(12) ed_val,163(15) total.
*        endif.
*
*        t_total = t_total + total.
*        val_tot = val_tot + itab2-menge.
*
*      endif.
*    endif.
*  endloop.
*  uline.
*  write :  /'TOTAL QUANTITY : ', val_tot,'TOTAL VALUE : ',t_total.
*  uline.
*endform.                    "tran_stk

*&---------------------------------------------------------------------*
*&      Form  summ_ts
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*form summ_ts.
*
*  select * from mkpf where budat in s_budat.
*    select * from mseg where mblnr eq mkpf-mblnr and matnr in material
*      and werks in plant.
*      move-corresponding mseg to itab1.
*      append itab1.
*    endselect.
*  endselect.
*  sort itab1 by matnr.
**delete adjacent duplicates from itab1 comparing ebeln.
*  loop at itab1.
*    if itab1-ebeln ne ' '.
*      select single * from ekpo where ebeln eq itab1-ebeln and matnr eq itab1-matnr
*        and werks eq itab1-werks.
*
*      if itab1-bwart eq '101'.
*        itab1-menge = itab1-menge * ( - 1 ).
*      elseif itab1-bwart eq '642'.
*        itab1-menge = itab1-menge * ( - 1 ).
*      endif.
*
*      if ekpo-elikz ne 'X'.
*        move itab1-ebeln to itab2-ebeln.
*        move itab1-matnr to itab2-matnr.
*        move itab1-werks to itab2-werks.
*        move itab1-ebelp to itab2-ebelp.
*        move itab1-menge to itab2-menge.
*        collect itab2.
*
*write : / itab1-ebeln,itab1-matnr,itab1-menge,itab1-bwart,itab1-ebelp,
*          ekpo-elikz.
* val_tot = val_tot + itab1-menge.

*      endif.
*
**   Endselect.
*    endif.
*  endloop.
*  sort itab2 by werks matnr.
*  loop at itab2.
*    if itab2-menge ne 0.
*
*      select single * from mara where matnr eq itab2-matnr.
*      if mara-mtart ne 'ZDSM'.
*

*  write : /1(5) itab2-werks,8(10) itab2-ebeln,21(10) itab2-matnr,
*           34(12) itab2-menge.
*           itab2-ebelp.
*        select single * from mseg where ebeln eq itab2-ebeln and matnr eq
*          itab2-matnr and werks eq itab2-werks and ebelp eq itab2-ebelp.
**    write : 49(12) mseg-umcha.
*
*        select single * from zrt_input where batch eq mseg-umcha.
*        if zrt_input-batch eq mseg-umcha.
*
**    write : 64(5) zrt_input-rm_rate,75(5) zrt_input-pm_rate,
**            80(5) zrt_input-ccpc,88(5) zrt_input-ed.
*
*          rm_val = zrt_input-rm_rate * itab2-menge.
*          pm_val = zrt_input-pm_rate * itab2-menge.
*          ccpc_val = zrt_input-ccpc * itab2-menge.
*          ed_val = zrt_input-ed * itab2-menge.
*          total = rm_val + pm_val + ccpc_val + ed_val.
**    write :  96(12) rm_val,111(12) pm_val,126(12) ccpc_val,141(12) ed_val,
**             156(15) total.
**
*        else.
*          zrt_input-rm_rate = 0.
*          zrt_input-pm_rate = 0.
*          zrt_input-ccpc = 0.
*          zrt_input-ed = 0.
*          rm_val = 0.
*          pm_val = 0.
*          ccpc_val = 0.
*          ed_val = 0.
*          total = 0.
*
**     write : 64(5) zrt_input-rm_rate,75(5) zrt_input-pm_rate,
**            80(5) zrt_input-ccpc,88(5) zrt_input-ed,96(12) rm_val,
**            111(12) pm_val,126(12) ccpc_val,141(12) ed_val,156(15) total.
*        endif.
*
*        t_total = t_total + total.
*        val_tot = val_tot + itab2-menge.
*
*        if itab2-werks eq '2000'.
*          tot2000 = tot2000 + itab2-menge.
*        elseif itab2-werks eq '2001'.
*          tot2001 = tot2001 + itab2-menge.
*        elseif itab2-werks eq '2002'.
*          tot2002 = tot2002 + itab2-menge.
*        elseif itab2-werks eq '2003'.
*          tot2003 = tot2003 + itab2-menge.
*        elseif itab2-werks eq '2004'.
*          tot2004 = tot2004 + itab2-menge.
*        elseif itab2-werks eq '2005'.
*          tot2005 = tot2005 + itab2-menge.
*        elseif itab2-werks eq '2006'.
*          tot2006 = tot2006 + itab2-menge.
*        elseif itab2-werks eq '2007'.
*          tot2007 = tot2007 + itab2-menge.
*        elseif itab2-werks eq '2008'.
*          tot2008 = tot2008 + itab2-menge.
*        elseif itab2-werks eq '2009'.
*          tot2009 = tot2009 + itab2-menge.
*        elseif itab2-werks eq '2010'.
*          tot2010 = tot2010 + itab2-menge.
*        elseif itab2-werks eq '2011'.
*          tot2011 = tot2011 + itab2-menge.
*        elseif itab2-werks eq '2012'.
*          tot2012 = tot2012 + itab2-menge.
*        elseif itab2-werks eq '2013'.
*          tot2013 = tot2013 + itab2-menge.
*        elseif itab2-werks eq '2014'.
*          tot2014 = tot2014 + itab2-menge.
*        elseif itab2-werks eq '2015'.
*          tot2015 = tot2015 + itab2-menge.
*        elseif itab2-werks eq '2016'.
*          tot2016 = tot2016 + itab2-menge.
*        elseif itab2-werks eq '2017'.
*          tot2017 = tot2017 + itab2-menge.
*        elseif itab2-werks eq '2018'.
*          tot2018 = tot2018 + itab2-menge.
*        elseif itab2-werks eq '2019'.
*          tot2019 = tot2019 + itab2-menge.
*        elseif itab2-werks eq '2020'.
*          tot2020 = tot2020 + itab2-menge.
*        elseif itab2-werks eq '2022'.
*          tot2022 = tot2022 + itab2-menge.
*        elseif itab2-werks eq '2023'.
*          tot2023 = tot2023 + itab2-menge.
*
*        endif.
*
*
*        if itab2-werks = '2000'.
*          tot2000-r = tot2000-r + rm_val.
*          tot2000-p = tot2000-p + pm_val.
*          tot2000-c = tot2000-c + ccpc_val.
*          tot2000-e = tot2000-e + ed_val.
*        elseif itab2-werks = '2001'.
*          tot2001-r = tot2001-r + rm_val.
*          tot2001-p = tot2001-p + pm_val.
*          tot2001-c = tot2001-c + ccpc_val.
*          tot2001-e = tot2001-e + ed_val.
*        elseif itab2-werks = '2002'.
*          tot2002-r = tot2002-r + rm_val.
*          tot2002-p = tot2002-p + pm_val.
*          tot2002-c = tot2002-c + ccpc_val.
*          tot2002-e = tot2002-e + ed_val.
*        elseif itab2-werks = '2003'.
*          tot2003-r = tot2003-r + rm_val.
*          tot2003-p = tot2003-p + pm_val.
*          tot2003-c = tot2003-c + ccpc_val.
*          tot2003-e = tot2003-e + ed_val.
*        elseif itab2-werks = '2004'.
*          tot2004-r = tot2004-r + rm_val.
*          tot2004-p = tot2004-p + pm_val.
*          tot2004-c = tot2004-c + ccpc_val.
*          tot2004-e = tot2004-e + ed_val.
*        elseif itab2-werks = '2005'.
*          tot2005-r = tot2005-r + rm_val.
*          tot2005-p = tot2005-p + pm_val.
*          tot2005-c = tot2005-c + ccpc_val.
*          tot2005-e = tot2005-e + ed_val.
*        elseif itab2-werks = '2006'.
*          tot2006-r = tot2006-r + rm_val.
*          tot2006-p = tot2006-p + pm_val.
*          tot2006-c = tot2006-c + ccpc_val.
*          tot2006-e = tot2006-e + ed_val.
*        elseif itab2-werks = '2007'.
*          tot2007-r = tot2007-r + rm_val.
*          tot2007-p = tot2007-p + pm_val.
*          tot2007-c = tot2007-c + ccpc_val.
*          tot2007-e = tot2007-e + ed_val.
*        elseif itab2-werks = '2008'.
*          tot2008-r = tot2008-r + rm_val.
*          tot2008-p = tot2008-p + pm_val.
*          tot2008-c = tot2008-c + ccpc_val.
*          tot2008-e = tot2008-e + ed_val.
*        elseif itab2-werks = '2009'.
*          tot2009-r = tot2009-r + rm_val.
*          tot2009-p = tot2009-p + pm_val.
*          tot2009-c = tot2009-c + ccpc_val.
*          tot2009-e = tot2009-e + ed_val.
*        elseif itab2-werks = '2010'.
*          tot2010-r = tot2010-r + rm_val.
*          tot2010-p = tot2010-p + pm_val.
*          tot2010-c = tot2010-c + ccpc_val.
*          tot2010-e = tot2010-e + ed_val.
*        elseif itab2-werks = '2011'.
*          tot2011-r = tot2011-r + rm_val.
*          tot2011-p = tot2011-p + pm_val.
*          tot2011-c = tot2011-c + ccpc_val.
*          tot2011-e = tot2011-e + ed_val.
*        elseif itab2-werks = '2012'.
*          tot2012-r = tot2012-r + rm_val.
*          tot2012-p = tot2012-p + pm_val.
*          tot2012-c = tot2012-c + ccpc_val.
*          tot2012-e = tot2012-e + ed_val.
*        elseif itab2-werks = '2013'.
*          tot2013-r = tot2013-r + rm_val.
*          tot2013-p = tot2013-p + pm_val.
*          tot2013-c = tot2013-c + ccpc_val.
*          tot2013-e = tot2013-e + ed_val.
*        elseif itab2-werks = '2014'.
*          tot2014-r = tot2014-r + rm_val.
*          tot2014-p = tot2014-p + pm_val.
*          tot2014-c = tot2014-c + ccpc_val.
*          tot2014-e = tot2014-e + ed_val.
*        elseif itab2-werks = '2015'.
*          tot2015-r = tot2015-r + rm_val.
*          tot2015-p = tot2015-p + pm_val.
*          tot2015-c = tot2015-c + ccpc_val.
*          tot2015-e = tot2015-e + ed_val.
*        elseif itab2-werks = '2016'.
*          tot2016-r = tot2016-r + rm_val.
*          tot2016-p = tot2016-p + pm_val.
*          tot2016-c = tot2016-c + ccpc_val.
*          tot2016-e = tot2016-e + ed_val.
*        elseif itab2-werks = '2017'.
*          tot2017-r = tot2017-r + rm_val.
*          tot2017-p = tot2017-p + pm_val.
*          tot2017-c = tot2017-c + ccpc_val.
*          tot2017-e = tot2017-e + ed_val.
*        elseif itab2-werks = '2018'.
*          tot2018-r = tot2018-r + rm_val.
*          tot2018-p = tot2018-p + pm_val.
*          tot2018-c = tot2018-c + ccpc_val.
*          tot2018-e = tot2018-e + ed_val.
*        elseif itab2-werks = '2019'.
*          tot2019-r = tot2019-r + rm_val.
*          tot2019-p = tot2019-p + pm_val.
*          tot2019-c = tot2019-c + ccpc_val.
*          tot2019-e = tot2019-e + ed_val.
*        elseif itab2-werks = '2020'.
*          tot2020-r = tot2020-r + rm_val.
*          tot2020-p = tot2020-p + pm_val.
*          tot2020-c = tot2020-c + ccpc_val.
*          tot2020-e = tot2020-e + ed_val.
*        elseif itab2-werks = '2022'.
*          tot2022-r = tot2022-r + rm_val.
*          tot2022-p = tot2022-p + pm_val.
*          tot2022-c = tot2022-c + ccpc_val.
*          tot2022-e = tot2022-e + ed_val.
*        elseif itab2-werks = '2023'.
*          tot2023-r = tot2023-r + rm_val.
*          tot2023-p = tot2023-p + pm_val.
*          tot2023-c = tot2023-c + ccpc_val.
*          tot2023-e = tot2023-e + ed_val.
*
*        endif.
*
*
*        tot2000-s = tot2000-r + tot2000-p + tot2000-c + tot2000-e.
*        tot2001-s = tot2001-r + tot2001-p + tot2001-c + tot2001-e.
*        tot2002-s = tot2002-r + tot2002-p + tot2002-c + tot2002-e.
*        tot2003-s = tot2003-r + tot2003-p + tot2003-c + tot2003-e.
*        tot2004-s = tot2004-r + tot2004-p + tot2004-c + tot2004-e.
*        tot2005-s = tot2005-r + tot2005-p + tot2005-c + tot2005-e.
*        tot2006-s = tot2006-r + tot2006-p + tot2006-c + tot2006-e.
*        tot2007-s = tot2007-r + tot2007-p + tot2007-c + tot2007-e.
*        tot2008-s = tot2008-r + tot2008-p + tot2008-c + tot2008-e.
*        tot2009-s = tot2009-r + tot2009-p + tot2009-c + tot2009-e.
*        tot2010-s = tot2010-r + tot2010-p + tot2010-c + tot2010-e.
*        tot2011-s = tot2011-r + tot2011-p + tot2011-c + tot2011-e.
*        tot2012-s = tot2012-r + tot2012-p + tot2012-c + tot2012-e.
*        tot2013-s = tot2013-r + tot2013-p + tot2013-c + tot2013-e.
*        tot2014-s = tot2014-r + tot2014-p + tot2014-c + tot2014-e.
*        tot2015-s = tot2015-r + tot2015-p + tot2015-c + tot2015-e.
*        tot2016-s = tot2016-r + tot2016-p + tot2016-c + tot2016-e.
*        tot2017-s = tot2017-r + tot2017-p + tot2017-c + tot2017-e.
*        tot2018-s = tot2018-r + tot2018-p + tot2018-c + tot2018-e.
*        tot2019-s = tot2019-r + tot2019-p + tot2019-c + tot2019-e.
*        tot2020-s = tot2020-r + tot2020-p + tot2020-c + tot2020-e.
*        tot2022-s = tot2022-r + tot2022-p + tot2022-c + tot2022-e.
*        tot2023-s = tot2023-r + tot2023-p + tot2023-c + tot2023-e.
*
*      endif.
*    endif.
*
*  endloop.
*
*  write :  / '2000',tot2000,tot2000-r,tot2000-p,tot2000-c,tot2000-e,tot2000-s,
*          / '2001',tot2001,tot2001-r,tot2001-p,tot2001-c,tot2001-e,tot2001-s,
*          / '2002',tot2002,tot2002-r,tot2002-p,tot2002-c,tot2002-e,tot2002-s,
*          / '2003',tot2003,tot2003-r,tot2003-p,tot2003-c,tot2003-e,tot2003-s,
*          / '2004',tot2004,tot2004-r,tot2004-p,tot2004-c,tot2004-e,tot2004-s,
*          / '2005',tot2005,tot2005-r,tot2005-p,tot2005-c,tot2005-e,tot2005-s,
*          / '2006',tot2006,tot2006-r,tot2006-p,tot2006-c,tot2006-e,tot2006-s,
*          / '2007',tot2007,tot2007-r,tot2007-p,tot2007-c,tot2007-e,tot2007-s,
*          / '2008',tot2008,tot2008-r,tot2008-p,tot2008-c,tot2008-e,tot2008-s,
*          / '2009',tot2009,tot2009-r,tot2009-p,tot2009-c,tot2009-e,tot2009-s,
*          / '2010',tot2010,tot2010-r,tot2010-p,tot2010-c,tot2010-e,tot2010-s,
*          / '2011',tot2011,tot2011-r,tot2011-p,tot2011-c,tot2011-e,tot2011-s,
*          / '2012',tot2012,tot2012-r,tot2012-p,tot2012-c,tot2012-e,tot2012-s,
*          / '2013',tot2013,tot2013-r,tot2013-p,tot2013-c,tot2013-e,tot2013-s,
*          / '2014',tot2014,tot2014-r,tot2014-p,tot2014-c,tot2014-e,tot2014-s,
*          / '2015',tot2015,tot2015-r,tot2015-p,tot2015-c,tot2015-e,tot2015-s,
*          / '2016',tot2016,tot2016-r,tot2016-p,tot2016-c,tot2016-e,tot2016-s,
*          / '2017',tot2017,tot2017-r,tot2017-p,tot2017-c,tot2017-e,tot2017-s,
*          / '2018',tot2018,tot2018-r,tot2018-p,tot2018-c,tot2018-e,tot2018-s,
*          / '2019',tot2019,tot2019-r,tot2019-p,tot2019-c,tot2019-e,tot2019-s,
*          / '2020',tot2020,tot2020-r,tot2020-p,tot2020-c,tot2020-e,tot2020-s,
*          / '2022',tot2022,tot2022-r,tot2022-p,tot2022-c,tot2022-e,tot2022-s,
*          / '2023',tot2023,tot2023-r,tot2023-p,tot2023-c,tot2023-e,tot2023-s.
*
*
*  skip.
*  uline.
*  skip.
*
*  tot1 = tot2000 + tot2001 + tot2002 + tot2003 + tot2004 + tot2005 + tot2006 +
*         tot2007 + tot2008 + tot2009 + tot2010 + tot2011 + tot2012 + tot2013 +
*         tot2014 + tot2015 + tot2016 + tot2017 + tot2018 + tot2019 + tot2020 +
*         tot2022 + tot2023.
*
*  tot1rm_val  = tot2000-r + tot2001-r + tot2002-r + tot2003-r + tot2004-r + tot2005-r
*              + tot2006-r + tot2007-r + tot2008-r + tot2009-r + tot2010-r + tot2011-r
*              + tot2012-r + tot2013-r + tot2014-r + tot2015-r + tot2016-r + tot2017-r
*              + tot2018-r + tot2019-r + tot2020-r + tot2022-r + tot2023-r.
*
*  tot1pm_val  = tot2000-p + tot2001-p + tot2002-p + tot2003-p + tot2004-p + tot2005-p
*              + tot2006-p + tot2007-p + tot2008-p + tot2009-p + tot2010-p + tot2011-p
*              + tot2012-p + tot2013-p + tot2014-p + tot2015-p + tot2016-p + tot2017-p
*              + tot2018-p + tot2019-p + tot2020-p + tot2022-p + tot2023-p.
*
*  tot1ccpc_val  = tot2000-c + tot2001-c + tot2002-c + tot2003-c + tot2004-c + tot2005-c
*              + tot2006-c + tot2007-c + tot2008-c + tot2009-c + tot2010-c + tot2011-c
*              + tot2012-c + tot2013-c + tot2014-c + tot2015-c + tot2016-c + tot2017-c
*              + tot2018-c + tot2019-c + tot2020-c + tot2022-c + tot2023-c.
*
*  tot1ed_val  = tot2000-e + tot2001-e + tot2002-e + tot2003-e + tot2004-e + tot2005-e
*              + tot2006-e + tot2007-e + tot2008-e + tot2009-e + tot2010-e + tot2011-e
*              + tot2012-e + tot2013-e + tot2014-e + tot2015-e + tot2016-e + tot2017-e
*              + tot2018-e + tot2019-e + tot2020-e + tot2022-e + tot2023-e.
*
*  tot2 =  tot2000-s + tot2001-s + tot2002-s + tot2003-s + tot2004-s + tot2005-s
*              + tot2006-s + tot2007-s + tot2008-s + tot2009-s + tot2010-s + tot2011-s
*              + tot2012-s + tot2013-s + tot2014-s + tot2015-s + tot2016-s + tot2017-s
*              + tot2018-s + tot2019-s + tot2020-s + tot2022-s + tot2023-s.
*
*
*
*  uline.
*  write : / 'TOTAL : ',tot1,tot1rm_val,tot1pm_val,tot1ccpc_val,tot1ed_val,tot2.
*  uline .
*  skip.
*
**write :  /'TOTAL QUANTITY : ', val_tot,'TOTAL VALUE : ',t_total.
*  uline.
*
*endform.                    "summ_ts

*&---------------------------------------------------------------------*
*&      Form  updt_ts
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form updt_ts.
  select * from ekpo into table it_ekpo where werks in plant and matnr in material and  elikz ne 'X'.
  if sy-subrc eq 0.
    select * from mdub into table it_mdub for all entries in it_ekpo where  ebeln eq it_ekpo-ebeln and
      werks in plant and matnr in material.
    if sy-subrc eq 0.
      select * from ekbe into table it_ekbe for all entries in it_mdub where ebeln eq it_mdub-ebeln and
        ebelp eq it_mdub-ebelp.
      select * from mara into table it_mara for all entries in it_mdub where matnr eq it_mdub-matnr and

        mtart in m_type.
    endif.
    sort it_mdub by matnr.
  endif.
  delete it_mdub where ebeln eq '4500000229'.  "added on 24.3.22
  delete it_mdub where ebeln eq '4500000230'. "added on 24.3.22
  delete it_mdub where charg eq 'ZCQ1605'. "added on 24.3.22
  delete it_mdub where ebeln eq '4500025163'. "added on 24.3.22

  loop at it_mdub into wa_mdub.
    if wa_mdub-wamng ne 0.
*    IF WA_MDUB-WEMNG EQ '0'.
*      IF WA_MDUB-CHARG NE ' '.
      menge = wa_mdub-wamng - wa_mdub-wemng.
      if menge ne 0.
*        WRITE : / WA_MDUB-MATNR,WA_MDUB-CHARG,MENGE,WA_MDUB-EBELn,WA_MDUB-EBELP,WA_MDUB-RESWK.

        wa_tab13-matnr = wa_mdub-matnr.
        wa_tab13-charg = wa_mdub-charg.
        wa_tab13-lgort = wa_mdub-lgort.
        wa_tab13-menge = menge.
        wa_tab13-ebeln = wa_mdub-ebeln.
        wa_tab13-ebelp = wa_mdub-ebelp.
        wa_tab13-reswk = wa_mdub-reswk.
        wa_tab13-werks = wa_mdub-werks.




        select single * from t001w where werks eq wa_mdub-reswk.
        if sy-subrc eq 0.
*            write : t001w-kunnr.
          wa_tab13-kunnr = t001w-kunnr.
        endif.
*        Select single * from vbrp where aubel eq WA_MDUB-EBELn and aupos eq WA_MDUB-EBELP and matnr eq
*          wa_mdub-matnr.
        read table it_ekbe into wa_ekbe with key ebelp = wa_mdub-ebelp ebeln = wa_mdub-ebeln matnr =
         wa_mdub-matnr.

        if sy-subrc eq 0.
*            write : vbrp-vbeln,vbrp-arktx.
*          wa_TAB13-vbeln = vbrp-vbeln.
*          wa_TAB13-arktx = vbrp-arktx.
*          wa_TAB13-fbuda = vbrp-fbuda.
          wa_tab13-charg = wa_ekbe-charg.
        endif.
*        TOTAL = TOTAL + MENGE.
*      ENDIF.
*    ENDIF.
        collect wa_tab13 into it_tab13.
      endif.
    endif.

    clear wa_tab13.
  endloop.
  delete it_tab13 where charg eq 'ZCQ1605'.

  loop at it_tab13 into wa_tab13.
    read table it_mara into wa_mara with key matnr = wa_tab13-matnr.
    if sy-subrc eq 0.
*          wa_tab13-mtart = wa_mara-mtart.
*          write : wa_mara-mtart.
      wa_tab14-mtart = wa_mara-mtart.
      wa_tab14-kunnr = wa_tab13-kunnr.
      wa_tab14-fbuda = wa_tab13-fbuda.
      wa_tab14-vbeln = wa_tab13-vbeln.
      wa_tab14-matnr = wa_tab13-matnr.
      wa_tab14-arktx = wa_tab13-arktx.
      wa_tab14-charg = wa_tab13-charg.
      wa_tab14-lgort = wa_tab13-lgort.
      wa_tab14-menge = wa_tab13-menge.
      wa_tab14-ebeln = wa_tab13-ebeln.
      wa_tab14-ebelp = wa_tab13-ebelp.
      wa_tab14-werks = wa_tab13-werks.


*  write : / wa_TAB13-kunnr,wa_TAB13-fbuda,wa_TAB13-vbeln,wa_TAB13-matnr,wa_TAB13-arktx,
*  wa_TAB13-charg,wa_TAB13-menge,wa_TAB13-ebeln,wa_TAB13-ebelp.

      collect wa_tab14 into it_tab14.
    endif.



  endloop.

  loop at it_tab14 into wa_tab14.

*    write : / wa_tab14-kunnr,wa_tab14-fbuda,wa_tab14-vbeln,wa_tab14-mtart,wa_tab14-matnr,wa_tab14-arktx,
*      wa_tab14-charg,wa_tab14-menge,wa_tab14-ebeln,wa_tab14-ebelp.

    wa_tab15-kunnr = wa_tab14-kunnr.
    wa_tab15-fbuda = wa_tab14-fbuda.
    wa_tab15-vbeln = wa_tab14-vbeln.
    wa_tab15-mtart = wa_tab14-mtart.
    wa_tab15-kunnr = wa_tab14-kunnr.
    wa_tab15-matnr = wa_tab14-matnr.
    wa_tab15-arktx = wa_tab14-arktx.
    wa_tab15-charg = wa_tab14-charg.
    wa_tab15-lgort = wa_tab14-lgort.
    wa_tab15-menge = wa_tab14-menge.
    wa_tab15-ebeln = wa_tab14-ebeln.
    wa_tab15-ebelp = wa_tab14-ebelp.
    wa_tab15-werks = wa_tab14-werks.


    select single * from zrt_input where matnr eq wa_tab14-matnr and batch eq wa_tab14-charg.
    if sy-subrc eq 0.
*      write : zrt_input-rm_rate,zrt_input-pm_rate,zrt_input-ccpc,zrt_input-ed.
      wa_tab15-rm_rate = zrt_input-rm_rate.
      wa_tab15-pm_rate = zrt_input-pm_rate.
      wa_tab15-ccpc = zrt_input-ccpc.
      wa_tab15-ed = zrt_input-ed.

    endif.
    collect wa_tab15 into it_tab15.
    clear wa_tab15.
*    pack wa_TAB14-matnr to wa_TAB14-matnr.
*    CONDENSE wa_TAB14-matnr.
*    modify it_TAB14 from wa_TAB14 TRANSPORTING matnr.
*    clear wa_tab14.
  endloop.


  loop at it_tab15 into wa_tab15.
* write : / wa_tab15-kunnr,wa_tab15-fbuda,wa_tab15-vbeln,wa_tab15-mtart,wa_tab15-matnr,wa_tab15-arktx,
*           wa_tab15-charg,wa_tab15-menge,wa_tab15-ebeln,wa_tab15-ebelp.
* write : / wa_tab15-rm_rate,wa_tab15-pm_rate,wa_tab15-ccpc,wa_tab15-ed.

    wa_tab16-kunnr = wa_tab15-kunnr.
    wa_tab16-fbuda = wa_tab15-fbuda.
    wa_tab16-vbeln = wa_tab15-vbeln.
    wa_tab16-mtart = wa_tab15-mtart.
    wa_tab16-kunnr = wa_tab15-kunnr.
    wa_tab16-matnr = wa_tab15-matnr.

    select single * from makt where matnr eq wa_tab15-matnr.
    if sy-subrc eq 0.
      wa_tab16-arktx = makt-maktx.
    endif.
    select single * from mvke where matnr eq wa_tab15-matnr and vkorg eq '1000' and vtweg eq '10'.
    if sy-subrc eq 0.
      wa_tab16-mvgr1 = mvke-mvgr1.
      select single * from tvm5t where mvgr5 eq mvke-mvgr5.
      if sy-subrc eq 0.
        wa_tab16-bezei = tvm5t-bezei.
      endif.
    else.
      select single * from mvke where matnr eq wa_tab15-matnr and vkorg eq '2000' and vtweg eq '20'.
      if sy-subrc eq 0.
        wa_tab16-mvgr1 = mvke-mvgr1.
        select single * from tvm5t where mvgr5 eq mvke-mvgr5.
        if sy-subrc eq 0.
          wa_tab16-bezei = tvm5t-bezei.
        endif.
      endif.
    endif.
    wa_tab16-charg = wa_tab15-charg.
    wa_tab16-lgort = wa_tab15-lgort.
    wa_tab16-menge = wa_tab15-menge.
    wa_tab16-ebeln = wa_tab15-ebeln.
    wa_tab16-ebelp = wa_tab15-ebelp.
    wa_tab16-rm_rate = wa_tab15-rm_rate.
    wa_tab16-pm_rate = wa_tab15-pm_rate.
    wa_tab16-ccpc = wa_tab15-ccpc.
    wa_tab16-ed = wa_tab15-ed.
    wa_tab16-werks = wa_tab15-werks.

    wa_tab16-rm_val = wa_tab15-rm_rate * wa_tab15-menge.
    wa_tab16-pm_val = wa_tab15-pm_rate * wa_tab15-menge.
    wa_tab16-ccpc_val = wa_tab15-ccpc * wa_tab15-menge.
    wa_tab16-ed_val = wa_tab15-ed * wa_tab15-menge.

    wa_tab16-value = wa_tab16-rm_val + wa_tab16-pm_val + wa_tab16-ccpc_val + wa_tab16-ed_val.
*write : wa_tab16-rm_val.

    collect wa_tab16 into it_tab16.
    clear wa_tab16.
  endloop.


  loop at it_tab16 into wa_tab16.
    pack wa_tab16-matnr to wa_tab16-matnr.
    condense wa_tab16-matnr.
    modify it_tab16 from wa_tab16 transporting matnr.
    clear wa_tab16.
  endloop.

  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_s = 'PO_NO'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'KUNNR'.
  wa_fieldcat-seltext_s = 'SUPPLYING_PLANT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_s = 'RECEIVE_PLANT'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-fieldname = 'FBUDA'.
*  WA_FIELDCAT-seltext_s = 'DATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*
*  WA_FIELDCAT-fieldname = 'VBELN'.
*  WA_FIELDCAT-seltext_s = 'INV_NO'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'MTART'.
  wa_fieldcat-seltext_s = 'TYPE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_s = 'CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ARKTX'.
  wa_fieldcat-seltext_s = 'MATERIAL'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_s = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-seltext_s = 'STR LOC'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MENGE'.
  wa_fieldcat-seltext_s = 'TRANSIT_QTY'.
  append wa_fieldcat to fieldcat.

*  wa_fieldcat-fieldname = 'MTART'.
*  wa_fieldcat-seltext_s = 'TYPE'.
*  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MVGR1'.
  wa_fieldcat-seltext_s = 'FORM'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_s = 'PACK SIZE'.
  append wa_fieldcat to fieldcat.



  wa_fieldcat-fieldname = 'RM_RATE'.
  wa_fieldcat-seltext_s = 'RM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_RATE'.
  wa_fieldcat-seltext_s = 'PM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC'.
  wa_fieldcat-seltext_s = 'CCPC_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED'.
  wa_fieldcat-seltext_s = 'ED_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RM_VAL'.
  wa_fieldcat-seltext_s = 'RM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_VAL'.
  wa_fieldcat-seltext_s = 'PM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC_VAL'.
  wa_fieldcat-seltext_s = 'CCPC_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED_VAL'.
  wa_fieldcat-seltext_s = 'ED_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VALUE'.
  wa_fieldcat-seltext_s = 'TOTAL_VALUE'.
  append wa_fieldcat to fieldcat.








  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'TRANSIT STOCK DETAIL'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = layout
      it_fieldcat             = fieldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    tables
      t_outtab                = it_tab16
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.


endform.                    "updt_ts




*&---------------------------------------------------------------------*
*&      Form  SUMM_TS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form summ_ts.
  select * from ekpo into table it_ekpo where werks in plant and matnr in material and  elikz ne 'X'.
  if sy-subrc eq 0.
    select * from mdub into table it_mdub for all entries in it_ekpo where  ebeln eq it_ekpo-ebeln and
      werks in plant and matnr in material.
    if sy-subrc eq 0.
      select * from ekbe into table it_ekbe for all entries in it_mdub where ebeln eq it_mdub-ebeln and
        ebelp eq it_mdub-ebelp.
      select * from mara into table it_mara for all entries in it_mdub where matnr eq it_mdub-matnr and

        mtart in m_type.
    endif.
    sort it_mdub by matnr.
  endif.

  delete it_mdub where ebeln eq '4500000229'.  "added on 24.3.22
  delete it_mdub where ebeln eq '4500000230'. "added on 24.3.22
  delete it_mdub where charg eq 'ZCQ1605'. "added on 24.3.22
  delete it_mdub where ebeln eq '4500025163'. "added on 24.3.22


  loop at it_mdub into wa_mdub.
    if wa_mdub-wamng ne 0.
*    IF WA_MDUB-WEMNG EQ '0'.
*      IF WA_MDUB-CHARG NE ' '.
      menge = wa_mdub-wamng - wa_mdub-wemng.
      if menge ne 0.
*        WRITE : / WA_MDUB-MATNR,WA_MDUB-CHARG,MENGE,WA_MDUB-EBELn,WA_MDUB-EBELP,WA_MDUB-RESWK.

        wa_tab13-matnr = wa_mdub-matnr.
        wa_tab13-charg = wa_mdub-charg.
        wa_tab13-menge = menge.
        wa_tab13-ebeln = wa_mdub-ebeln.
        wa_tab13-ebelp = wa_mdub-ebelp.
        wa_tab13-reswk = wa_mdub-reswk.
        wa_tab13-werks = wa_mdub-werks.




        select single * from t001w where werks eq wa_mdub-reswk.
        if sy-subrc eq 0.
*            write : t001w-kunnr.
          wa_tab13-kunnr = t001w-kunnr.
        endif.
*        Select single * from vbrp where aubel eq WA_MDUB-EBELn and aupos eq WA_MDUB-EBELP and matnr eq
*          wa_mdub-matnr.
        read table it_ekbe into wa_ekbe with key ebelp = wa_mdub-ebelp ebeln = wa_mdub-ebeln matnr =
         wa_mdub-matnr.

        if sy-subrc eq 0.
*            write : vbrp-vbeln,vbrp-arktx.
*          wa_TAB13-vbeln = vbrp-vbeln.
*          wa_TAB13-arktx = vbrp-arktx.
*          wa_TAB13-fbuda = vbrp-fbuda.
          wa_tab13-charg = wa_ekbe-charg.
        endif.
*        TOTAL = TOTAL + MENGE.
*      ENDIF.
*    ENDIF.
        collect wa_tab13 into it_tab13.
      endif.
    endif.

    clear wa_tab13.
  endloop.
  delete it_tab13 where charg eq 'ZCQ1605'.

  loop at it_tab13 into wa_tab13.
    read table it_mara into wa_mara with key matnr = wa_tab13-matnr.
    if sy-subrc eq 0.
*          wa_tab13-mtart = wa_mara-mtart.
*          write : wa_mara-mtart.
      wa_tab14-mtart = wa_mara-mtart.
      wa_tab14-kunnr = wa_tab13-kunnr.
      wa_tab14-fbuda = wa_tab13-fbuda.
      wa_tab14-vbeln = wa_tab13-vbeln.
      wa_tab14-matnr = wa_tab13-matnr.
      wa_tab14-arktx = wa_tab13-arktx.
      wa_tab14-charg = wa_tab13-charg.
      wa_tab14-menge = wa_tab13-menge.
      wa_tab14-ebeln = wa_tab13-ebeln.
      wa_tab14-ebelp = wa_tab13-ebelp.
      wa_tab14-werks = wa_tab13-werks.


*  write : / wa_TAB13-kunnr,wa_TAB13-fbuda,wa_TAB13-vbeln,wa_TAB13-matnr,wa_TAB13-arktx,
*  wa_TAB13-charg,wa_TAB13-menge,wa_TAB13-ebeln,wa_TAB13-ebelp.

      collect wa_tab14 into it_tab14.
    endif.



  endloop.

  loop at it_tab14 into wa_tab14.

*    write : / wa_tab14-kunnr,wa_tab14-fbuda,wa_tab14-vbeln,wa_tab14-mtart,wa_tab14-matnr,wa_tab14-arktx,
*      wa_tab14-charg,wa_tab14-menge,wa_tab14-ebeln,wa_tab14-ebelp.

    wa_tab15-kunnr = wa_tab14-kunnr.
    wa_tab15-fbuda = wa_tab14-fbuda.
    wa_tab15-vbeln = wa_tab14-vbeln.
    wa_tab15-mtart = wa_tab14-mtart.
    wa_tab15-kunnr = wa_tab14-kunnr.
    wa_tab15-matnr = wa_tab14-matnr.
    wa_tab15-arktx = wa_tab14-arktx.
    wa_tab15-charg = wa_tab14-charg.
    wa_tab15-menge = wa_tab14-menge.
    wa_tab15-ebeln = wa_tab14-ebeln.
    wa_tab15-ebelp = wa_tab14-ebelp.
    wa_tab15-werks = wa_tab14-werks.


    select single * from zrt_input where matnr eq wa_tab14-matnr and batch eq wa_tab14-charg.
    if sy-subrc eq 0.
*      write : zrt_input-rm_rate,zrt_input-pm_rate,zrt_input-ccpc,zrt_input-ed.
      wa_tab15-rm_rate = zrt_input-rm_rate.
      wa_tab15-pm_rate = zrt_input-pm_rate.
      wa_tab15-ccpc = zrt_input-ccpc.
      wa_tab15-ed = zrt_input-ed.

    endif.
    collect wa_tab15 into it_tab15.
    clear wa_tab15.
*    pack wa_TAB14-matnr to wa_TAB14-matnr.
*    CONDENSE wa_TAB14-matnr.
*    modify it_TAB14 from wa_TAB14 TRANSPORTING matnr.
*    clear wa_tab14.
  endloop.


  loop at it_tab15 into wa_tab15.
* write : / wa_tab15-kunnr,wa_tab15-fbuda,wa_tab15-vbeln,wa_tab15-mtart,wa_tab15-matnr,wa_tab15-arktx,
*           wa_tab15-charg,wa_tab15-menge,wa_tab15-ebeln,wa_tab15-ebelp.
* write : / wa_tab15-rm_rate,wa_tab15-pm_rate,wa_tab15-ccpc,wa_tab15-ed.

    wa_tab16-kunnr = wa_tab15-kunnr.
    wa_tab16-fbuda = wa_tab15-fbuda.
    wa_tab16-vbeln = wa_tab15-vbeln.
    wa_tab16-mtart = wa_tab15-mtart.
    wa_tab16-kunnr = wa_tab15-kunnr.
    wa_tab16-matnr = wa_tab15-matnr.

    select single * from makt where matnr eq wa_tab15-matnr.
    if sy-subrc eq 0.
      wa_tab16-arktx = makt-maktx.
    endif.
    wa_tab16-charg = wa_tab15-charg.
    wa_tab16-menge = wa_tab15-menge.
    wa_tab16-ebeln = wa_tab15-ebeln.
    wa_tab16-ebelp = wa_tab15-ebelp.
    wa_tab16-rm_rate = wa_tab15-rm_rate.
    wa_tab16-pm_rate = wa_tab15-pm_rate.
    wa_tab16-ccpc = wa_tab15-ccpc.
    wa_tab16-ed = wa_tab15-ed.
    wa_tab16-werks = wa_tab15-werks.

    wa_tab16-rm_val = wa_tab15-rm_rate * wa_tab15-menge.
    wa_tab16-pm_val = wa_tab15-pm_rate * wa_tab15-menge.
    wa_tab16-ccpc_val = wa_tab15-ccpc * wa_tab15-menge.
    wa_tab16-ed_val = wa_tab15-ed * wa_tab15-menge.

    wa_tab16-value = wa_tab16-rm_val + wa_tab16-pm_val + wa_tab16-ccpc_val + wa_tab16-ed_val.
*write : wa_tab16-rm_val.
*SELECT SINGLE * FROM T001W WHERE WERKS EQ WA_TAB15-WERKS.
*  IF SY-SUBRC EQ 0.
*    WA_TAB16-KUNNR1 = T001W-KUNNR.
*  ENDIF.
    collect wa_tab16 into it_tab16.
    clear wa_tab16.
  endloop.

  sort it_tab16 by werks.

  loop at it_tab16 into wa_tab16.
    select single * from t001w where werks eq wa_tab16-werks.
    if sy-subrc eq 0.
      wa_tab17-kunnr = t001w-kunnr.
    endif.

    wa_tab17-werks = wa_tab16-werks.
*    wa_tab17-kunnr1 = wa_tab16-kunnr1.
*    wa_tab17-fbuda = wa_tab16-fbuda.
*    wa_tab17-vbeln = wa_tab16-vbeln.
*    wa_tab17-mtart = wa_tab16-mtart.
*    wa_tab17-kunnr = wa_tab16-kunnr.
*    wa_tab17-matnr = wa_tab16-matnr.
*    wa_tab17-arktx = WA_TAB16-MAKTX.

*    wa_tab17-charg = wa_tab16-charg.
    wa_tab17-menge = wa_tab16-menge.
*    wa_tab17-ebeln = wa_tab16-ebeln.
*    wa_tab17-ebelp = wa_tab16-ebelp.
    wa_tab17-rm_rate = wa_tab16-rm_rate.
    wa_tab17-pm_rate = wa_tab16-pm_rate.
    wa_tab17-ccpc = wa_tab16-ccpc.
    wa_tab17-ed = wa_tab16-ed.


    wa_tab17-rm_val = wa_tab16-rm_val.
    wa_tab17-pm_val = wa_tab16-pm_val.
    wa_tab17-ccpc_val = wa_tab16-ccpc_val.
    wa_tab17-ed_val = wa_tab16-ed_val.
    wa_tab17-value = wa_tab16-value.
    wa_tab17-freight = ( wa_tab16-value * freight ) / 100.
    wa_tab17-t_val = wa_tab16-value + wa_tab17-freight.


    collect wa_tab17 into it_tab17.
    clear wa_tab17.
*      pack wa_TAB16-matnr to wa_TAB16-matnr.
*    CONDENSE wa_TAB16-matnr.
*    modify it_TAB16 from wa_TAB16 TRANSPORTING matnr.
*    clear wa_tab16.
  endloop.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_s = 'RECEIVE_PLANT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'KUNNR'.
  wa_fieldcat-seltext_s = 'LOCATION'.
  append wa_fieldcat to fieldcat.



*  WA_FIELDCAT-fieldname = 'FBUDA'.
*  WA_FIELDCAT-seltext_s = 'DATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*
*  WA_FIELDCAT-fieldname = 'VBELN'.
*  WA_FIELDCAT-seltext_s = 'INV_NO'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

*  WA_FIELDCAT-fieldname = 'MTART'.
*  WA_FIELDCAT-seltext_s = 'TYPE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'MATNR'.
*  WA_FIELDCAT-seltext_s = 'CODE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'ARKTX'.
*  WA_FIELDCAT-seltext_s = 'MATERIAL'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'CHARG'.
*  WA_FIELDCAT-seltext_s = 'BATCH'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'MENGE'.
  wa_fieldcat-seltext_s = 'TRANSIT_QTY'.
  append wa_fieldcat to fieldcat.



  wa_fieldcat-fieldname = 'RM_RATE'.
  wa_fieldcat-seltext_s = 'RM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_RATE'.
  wa_fieldcat-seltext_s = 'PM_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC'.
  wa_fieldcat-seltext_s = 'CCPC_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED'.
  wa_fieldcat-seltext_s = 'ED_RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RM_VAL'.
  wa_fieldcat-seltext_s = 'RM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PM_VAL'.
  wa_fieldcat-seltext_s = 'PM_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCPC_VAL'.
  wa_fieldcat-seltext_s = 'CCPC_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ED_VAL'.
  wa_fieldcat-seltext_s = 'ED_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VALUE'.
  wa_fieldcat-seltext_s = 'VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FREIGHT'.
  wa_fieldcat-seltext_s = 'FREIGHT_VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'T_VAL'.
  wa_fieldcat-seltext_s = 'TOTAL_VALUE'.
  append wa_fieldcat to fieldcat.








  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'TRANSIT STOCK DETAIL'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = layout
      it_fieldcat             = fieldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    tables
      t_outtab                = it_tab17
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.


endform.                    "SUMM_TS

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'MONTH END INVENTORY REPORT'.
*  WA_COMMENT-INFO = P_FRMDT.
  append wa_comment to comment.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  clear comment.

endform.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
form user_comm using ucomm like sy-ucomm
                     selfield type slis_selfield.



  case selfield-fieldname.
    when 'MATNR'.
      set parameter id 'MAT' field selfield-value.
      call transaction 'MM03' and skip first screen.
    when others.
  endcase.
endform.                    "USER_COMM
