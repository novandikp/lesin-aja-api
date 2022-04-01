--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

-- Started on 2021-08-24 11:09:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 296 (class 1255 OID 25400)
-- Name: prevent_delete_default(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.prevent_delete_default() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
        IF (old.defaultstatus = 1) THEN
            RAISE EXCEPTION 'Cannot Delete Default Data';
        END IF;
        RETURN OLD;
END;
$$;


ALTER FUNCTION public.prevent_delete_default() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 291 (class 1259 OID 27582)
-- Name: hakakses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hakakses (
    id integer NOT NULL,
    fitur integer,
    akses character varying
);


ALTER TABLE public.hakakses OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 27580)
-- Name: hakakses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hakakses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hakakses_id_seq OWNER TO postgres;

--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 290
-- Name: hakakses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hakakses_id_seq OWNED BY public.hakakses.id;


--
-- TOC entry 202 (class 1259 OID 17812)
-- Name: tblakun; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblakun (
    kodeakun character varying(10) NOT NULL,
    idsubklasifikasi character varying(10),
    akun character varying(50),
    statusakun smallint,
    defaultstatus smallint DEFAULT 0
);


ALTER TABLE public.tblakun OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 17886)
-- Name: tbljurnal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbljurnal (
    idjurnal integer NOT NULL,
    kodeakun character varying(10),
    kodeprojek character varying(10),
    kodedepartemen character varying(10),
    kontak integer,
    tgljurnal date,
    debit double precision,
    kredit double precision,
    tipe character varying(10),
    koderefrensi character varying(10),
    deskripsijurnal text,
    is_showed integer DEFAULT 1
);


ALTER TABLE public.tbljurnal OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 24262)
-- Name: jurnal_transaksi; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.jurnal_transaksi AS
 SELECT tbljurnal.koderefrensi,
    tblakun.akun,
    tbljurnal.kodeakun,
    tbljurnal.debit,
    tbljurnal.kredit
   FROM (public.tbljurnal
     JOIN public.tblakun ON (((tblakun.kodeakun)::text = (tbljurnal.kodeakun)::text)))
  ORDER BY tbljurnal.koderefrensi;


ALTER TABLE public.jurnal_transaksi OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 27542)
-- Name: tblakses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblakses (
    hakakses character varying NOT NULL
);


ALTER TABLE public.tblakses OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 27419)
-- Name: tblaset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblaset (
    kodeaset character varying NOT NULL,
    idkategoriaset integer,
    aset character varying,
    tanggaldapat date,
    nilaibeli double precision,
    nilairesidu double precision
);


ALTER TABLE public.tblaset OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 18212)
-- Name: tblaudit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblaudit (
    idaudit integer NOT NULL,
    kodeakun character varying,
    kodeprojek character varying,
    serialdata character varying,
    kodedepartemen character varying,
    kontak integer,
    tglaudit date,
    debit double precision,
    kredit double precision,
    tipe character varying,
    koderefrensi character varying,
    deskripsiaudit text,
    createdat date,
    createdfrom character varying,
    updatedat date,
    updatedmsg text,
    updatedfrom character varying
);


ALTER TABLE public.tblaudit OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 24792)
-- Name: tblbayarhutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblbayarhutang (
    kodebeli character varying,
    tglbayarhutang date,
    akun character varying,
    bayarhutang double precision DEFAULT 0,
    akunbiayalain character varying,
    biayalain double precision DEFAULT 0,
    kodebayarhutang character varying NOT NULL
);


ALTER TABLE public.tblbayarhutang OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 18340)
-- Name: tblbayarpiutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblbayarpiutang (
    kodejual character varying(10),
    tglbayarpiutang date,
    akun character varying(10),
    bayarpiutang double precision DEFAULT 0,
    akunbiayalain character varying(10),
    biayalain double precision DEFAULT 0,
    kodebayarpiutang character varying NOT NULL
);


ALTER TABLE public.tblbayarpiutang OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 24593)
-- Name: tblbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblbeli (
    kodebeli character varying NOT NULL,
    kodepengirimanbeli character varying,
    tglbeli date,
    kodedepartemen character varying,
    kodeprojek character varying,
    total double precision DEFAULT 0,
    bayar double precision DEFAULT 0,
    kembali double precision DEFAULT 0,
    diskonrupiah double precision,
    diskonpersen double precision,
    totalpajak double precision,
    biayalain double precision,
    kasbiayalain character varying,
    kasdiskon character varying,
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying,
    statusbeli integer DEFAULT 0,
    kodepesananbeli character varying,
    kaspenerimaan character varying
);


ALTER TABLE public.tblbeli OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 17829)
-- Name: tbldepartemen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldepartemen (
    iddepartemen character varying(10) NOT NULL,
    departemen character varying(30),
    penanggunjawab integer,
    flagdepartemen integer,
    defaultstatus smallint DEFAULT 0
);


ALTER TABLE public.tbldepartemen OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 24696)
-- Name: tbldetailbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailbeli (
    iddetailbeli integer NOT NULL,
    kodebeli character varying,
    idharga integer,
    jumlahbeli double precision,
    hargabeli double precision,
    jumlahpajak double precision,
    catatandetail text,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailbeli OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 24875)
-- Name: tbldetailbeli_iddetailbeli_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailbeli ALTER COLUMN iddetailbeli ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailbeli_iddetailbeli_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 18516)
-- Name: tbldetailjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailjual (
    iddetailjual integer NOT NULL,
    kodejual character varying,
    idharga integer,
    jumlahjual double precision,
    hargajual double precision,
    jumlahpajak double precision,
    catatandetail text,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailjual OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 24230)
-- Name: tbldetailjual_iddetailjual_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailjual ALTER COLUMN iddetailjual ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailjual_iddetailjual_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 265 (class 1259 OID 24715)
-- Name: tbldetailpenawaranbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailpenawaranbeli (
    iddetailpenawaranbeli integer NOT NULL,
    kodepenawaranbeli character varying,
    jumlahbeli double precision,
    hargabeli double precision,
    jumlahpajak double precision,
    catatandetail text,
    idharga integer,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailpenawaranbeli OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 24869)
-- Name: tbldetailpenawaranbeli_iddetailpenawaranbeli_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailpenawaranbeli ALTER COLUMN iddetailpenawaranbeli ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailpenawaranbeli_iddetailpenawaranbeli_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 18424)
-- Name: tbldetailpenawaranjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailpenawaranjual (
    iddetailpenawaranjual integer NOT NULL,
    kodepenawaranjual character varying,
    jumlahjual double precision,
    hargajual double precision,
    jumlahpajak double precision,
    catatandetail text,
    idharga integer,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailpenawaranjual OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 18422)
-- Name: tbldetailpenawaranjual_iddetailpenawaranjual_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailpenawaranjual ALTER COLUMN iddetailpenawaranjual ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailpenawaranjual_iddetailpenawaranjual_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 266 (class 1259 OID 24734)
-- Name: tbldetailpengirimanbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailpengirimanbeli (
    iddetailpengirimanbeli integer NOT NULL,
    kodepengirimanbeli character varying,
    idharga integer,
    jumlahbeli double precision,
    hargabeli double precision,
    jumlahpajak double precision,
    catatandetail text,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailpengirimanbeli OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 24871)
-- Name: tbldetailpengirimanbeli_iddetailpengirimanbeli_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailpengirimanbeli ALTER COLUMN iddetailpengirimanbeli ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailpengirimanbeli_iddetailpengirimanbeli_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 18470)
-- Name: tbldetailpengirimanjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailpengirimanjual (
    iddetailpengirimanjual integer NOT NULL,
    kodepengirimanjual character varying,
    idharga integer,
    jumlahjual double precision,
    hargajual double precision,
    jumlahpajak double precision,
    catatandetail text,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailpengirimanjual OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 24053)
-- Name: tbldetailpengirimanjual_iddetailpengirimanjual_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailpengirimanjual ALTER COLUMN iddetailpengirimanjual ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailpengirimanjual_iddetailpengirimanjual_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 267 (class 1259 OID 24753)
-- Name: tbldetailpesananbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailpesananbeli (
    iddetailpesananbeli integer NOT NULL,
    kodepesananbeli character varying,
    idharga integer,
    jumlahbeli double precision,
    hargabeli double precision,
    jumlahpajak double precision,
    catatandetail text,
    jumlahkirim double precision DEFAULT 0,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailpesananbeli OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 24873)
-- Name: tbldetailpesananbeli_iddetailpesananbeli_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailpesananbeli ALTER COLUMN iddetailpesananbeli ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailpesananbeli_iddetailpesananbeli_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 18447)
-- Name: tbldetailpesananjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailpesananjual (
    iddetailpesananjual integer NOT NULL,
    kodepesananjual character varying,
    idharga integer,
    jumlahjual double precision,
    hargajual double precision,
    jumlahpajak double precision,
    catatandetail text,
    jumlahkirim double precision DEFAULT 0,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailpesananjual OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 24041)
-- Name: tbldetailpesananjual_iddetailpesananjual_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailpesananjual ALTER COLUMN iddetailpesananjual ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailpesananjual_iddetailpesananjual_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 268 (class 1259 OID 24773)
-- Name: tbldetailreturbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailreturbeli (
    iddetailreturbeli integer NOT NULL,
    kodereturbeli character varying,
    idharga integer,
    jumlahbeli double precision,
    hargabeli double precision,
    jumlahpajak double precision,
    catatandetail text,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailreturbeli OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 24877)
-- Name: tbldetailreturbeli_iddetailreturbeli_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailreturbeli ALTER COLUMN iddetailreturbeli ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailreturbeli_iddetailreturbeli_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 18493)
-- Name: tbldetailreturjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailreturjual (
    iddetailreturjual integer NOT NULL,
    kodereturjual character varying,
    idharga integer,
    jumlahjual double precision,
    hargajual double precision,
    jumlahpajak double precision,
    catatandetail text,
    diskondetailpersen integer DEFAULT 0
);


ALTER TABLE public.tbldetailreturjual OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 24256)
-- Name: tbldetailreturjual_iddetailreturjual_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailreturjual ALTER COLUMN iddetailreturjual ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailreturjual_iddetailreturjual_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 18587)
-- Name: tbldetailstokopname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailstokopname (
    iddetailstokopname integer NOT NULL,
    kodestokopname character varying,
    kodebarang character varying,
    hpp double precision,
    fisik double precision,
    selisih double precision,
    buku double precision,
    idsatuan integer
);


ALTER TABLE public.tbldetailstokopname OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 18605)
-- Name: tbldetailstokopname_iddetailstokopname_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailstokopname ALTER COLUMN iddetailstokopname ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tbldetailstokopname_iddetailstokopname_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 17956)
-- Name: tbldetailtransaksi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbldetailtransaksi (
    iddetailtransaksi integer NOT NULL,
    idtransaksi character varying,
    akuntujuan character varying(10),
    besartransaksi double precision,
    kodedepartemen character varying(10),
    kodeprojek character varying(10),
    catatandetail text
);


ALTER TABLE public.tbldetailtransaksi OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 17954)
-- Name: tbldetailtransaksi_iddetailtransaksi_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbldetailtransaksi ALTER COLUMN iddetailtransaksi ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbldetailtransaksi_iddetailtransaksi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 289 (class 1259 OID 27571)
-- Name: tblfitur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblfitur (
    id integer NOT NULL,
    fitur character varying,
    asal character varying,
    posisiasal integer
);


ALTER TABLE public.tblfitur OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 27569)
-- Name: tblfitur_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tblfitur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tblfitur_id_seq OWNER TO postgres;

--
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 288
-- Name: tblfitur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tblfitur_id_seq OWNED BY public.tblfitur.id;


--
-- TOC entry 295 (class 1259 OID 27691)
-- Name: tblgirokeluar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblgirokeluar (
    kodegirokeluar character varying NOT NULL,
    koderefrensi character varying,
    bank character varying,
    norek character varying,
    jatuhtempo date,
    tipe character varying,
    jumlah double precision,
    status integer
);


ALTER TABLE public.tblgirokeluar OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 27683)
-- Name: tblgiromasuk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblgiromasuk (
    kodegiromasuk character varying NOT NULL,
    koderefrensi character varying,
    bank character varying,
    norek character varying,
    jatuhtempo date,
    tipe character varying,
    jumlah double precision,
    status integer DEFAULT 0
);


ALTER TABLE public.tblgiromasuk OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 18180)
-- Name: tblgudang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblgudang (
    idgudang character varying(10) NOT NULL,
    gudang character varying(30),
    iddepartemen character varying(10),
    flaggudang integer DEFAULT 1,
    defaultstatus smallint DEFAULT 0
);


ALTER TABLE public.tblgudang OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 24817)
-- Name: tblhapushutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblhapushutang (
    kodehapushutang character varying NOT NULL,
    tglhapushutang date,
    jumlahhutang double precision,
    kodedepartemen character varying,
    kodeprojek character varying,
    kodeakun character varying
);


ALTER TABLE public.tblhapushutang OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 24303)
-- Name: tblhapuspiutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblhapuspiutang (
    kodehapuspiutang character varying NOT NULL,
    tglhapuspiutang date,
    jumlahpiutang double precision,
    kodedepartemen character varying,
    kodeprojek character varying,
    kodeakun character varying
);


ALTER TABLE public.tblhapuspiutang OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 18541)
-- Name: tblharga; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblharga (
    idharga integer NOT NULL,
    hargajual double precision,
    hpp double precision,
    idbarang character varying,
    hargabeli double precision,
    idsatuan integer,
    level integer,
    konversi double precision,
    nilaidasar double precision
);


ALTER TABLE public.tblharga OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 18539)
-- Name: tblharga_idharga_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblharga ALTER COLUMN idharga ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblharga_idharga_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 271 (class 1259 OID 24840)
-- Name: tblhistoribayarhutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblhistoribayarhutang (
    idhistoribayarhutang integer NOT NULL,
    idjurnal integer,
    kodebeli character varying
);


ALTER TABLE public.tblhistoribayarhutang OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 24879)
-- Name: tblhistoribayarhutang_idhistoribayarhutang_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblhistoribayarhutang ALTER COLUMN idhistoribayarhutang ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblhistoribayarhutang_idhistoribayarhutang_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 255 (class 1259 OID 24280)
-- Name: tblhistoribayarpiutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblhistoribayarpiutang (
    idhistoribayarpiutang integer NOT NULL,
    idjurnal integer,
    kodejual character varying
);


ALTER TABLE public.tblhistoribayarpiutang OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 24278)
-- Name: tblhistoribayarpiutang_idhistoribayarpiutang_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblhistoribayarpiutang ALTER COLUMN idhistoribayarpiutang ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblhistoribayarpiutang_idhistoribayarpiutang_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 272 (class 1259 OID 24858)
-- Name: tblhistorihutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblhistorihutang (
    idhistorihutang integer NOT NULL,
    idjurnal integer
);


ALTER TABLE public.tblhistorihutang OWNER TO postgres;

--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN tblhistorihutang.idjurnal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tblhistorihutang.idjurnal IS 'Untuk melakukan pengecekan histori hutang';


--
-- TOC entry 279 (class 1259 OID 24881)
-- Name: tblhistorihutang_idhistorihutang_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblhistorihutang ALTER COLUMN idhistorihutang ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblhistorihutang_idhistorihutang_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 253 (class 1259 OID 24268)
-- Name: tblhistoripiutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblhistoripiutang (
    idhistoripiutang integer NOT NULL,
    idjurnal integer
);


ALTER TABLE public.tblhistoripiutang OWNER TO postgres;

--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN tblhistoripiutang.idjurnal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tblhistoripiutang.idjurnal IS 'Untuk melakukan pengecekan histori piutang';


--
-- TOC entry 252 (class 1259 OID 24266)
-- Name: tblhistoripiutang_idhistoripiutang_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblhistoripiutang ALTER COLUMN idhistoripiutang ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblhistoripiutang_idhistoripiutang_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 241 (class 1259 OID 18561)
-- Name: tblhistoristok; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblhistoristok (
    idhistoristok integer NOT NULL,
    masuk double precision,
    keluar double precision,
    harga double precision,
    tglhistori date,
    idharga integer,
    refrensi character varying,
    hpp double precision
);


ALTER TABLE public.tblhistoristok OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 18559)
-- Name: tblhistoristok_idhistoristok_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblhistoristok ALTER COLUMN idhistoristok ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblhistoristok_idhistoristok_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 18139)
-- Name: tbljual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbljual (
    kodejual character varying NOT NULL,
    kodepengirimanjual character varying,
    tgljual date,
    kodedepartemen character varying,
    kodeprojek character varying,
    total double precision DEFAULT 0,
    bayar double precision DEFAULT 0,
    kembali double precision DEFAULT 0,
    diskonrupiah double precision,
    diskonpersen double precision,
    totalpajak double precision,
    biayalain double precision,
    kasbiayalain character varying,
    kasdiskon character varying,
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying(10),
    statusjual integer DEFAULT 0,
    kodepesananjual character varying,
    kaspenerimaan character varying
);


ALTER TABLE public.tbljual OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 17884)
-- Name: tbljurnal_idjurnal_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tbljurnal ALTER COLUMN idjurnal ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tbljurnal_idjurnal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 18057)
-- Name: tblkategori; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblkategori (
    idkategori integer NOT NULL,
    kategori character varying(30),
    deskripsikategori character varying(30)
);


ALTER TABLE public.tblkategori OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 18055)
-- Name: tblkategori_idkategori_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblkategori ALTER COLUMN idkategori ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblkategori_idkategori_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 285 (class 1259 OID 27411)
-- Name: tblkategoriaset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblkategoriaset (
    idkategoriaset integer NOT NULL,
    kategoriaset character varying,
    metodepenyusutan character varying,
    penggunaan double precision
);


ALTER TABLE public.tblkategoriaset OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 27409)
-- Name: tblkategoriaset_idkategoriaset_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblkategoriaset ALTER COLUMN idkategoriaset ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tblkategoriaset_idkategoriaset_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 281 (class 1259 OID 24888)
-- Name: tblkelebihanbayarbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblkelebihanbayarbeli (
    kodekelebihanbayarbeli character varying NOT NULL,
    akun character varying,
    jumlah double precision,
    kodebeli character varying,
    tglkelebihanbeli date
);


ALTER TABLE public.tblkelebihanbayarbeli OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 24439)
-- Name: tblkelebihanbayarjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblkelebihanbayarjual (
    kodekelebihanbayarjual character varying NOT NULL,
    akun character varying,
    jumlah double precision,
    kodejual character varying,
    tglkelebihanjual date
);


ALTER TABLE public.tblkelebihanbayarjual OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 17786)
-- Name: tblklasifikasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblklasifikasi (
    klasifikasi character varying(30),
    idklasifikasi integer NOT NULL
);


ALTER TABLE public.tblklasifikasi OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 17914)
-- Name: tblklasifikasi_idklasifikasi_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblklasifikasi ALTER COLUMN idklasifikasi ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblklasifikasi_idklasifikasi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 204 (class 1259 OID 17824)
-- Name: tblkontak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblkontak (
    idpelanggan integer NOT NULL,
    pelanggan character varying(30),
    alamat character varying(50),
    notelp character varying(25),
    posisi character varying(40),
    bayarpiutang double precision DEFAULT 0,
    bayarhutang double precision DEFAULT 0,
    sisapiutang double precision DEFAULT 0,
    sisahutang double precision DEFAULT 0,
    defaultstatus smallint DEFAULT 0
);


ALTER TABLE public.tblkontak OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 17822)
-- Name: tblkontak_idpelanggan_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblkontak ALTER COLUMN idpelanggan ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblkontak_idpelanggan_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 18206)
-- Name: tblpajak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblpajak (
    kodepajak character varying(10) NOT NULL,
    pajak character varying(30),
    persenpajak double precision,
    flagpajak smallint DEFAULT 1,
    akunpajakjual character varying,
    akunpajakbeli character varying,
    defaultstatus smallint DEFAULT 0
);


ALTER TABLE public.tblpajak OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 24467)
-- Name: tblpenawaranbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblpenawaranbeli (
    kodepenawaranbeli character varying NOT NULL,
    tglpenawaranbeli date,
    kodedepartemen character varying,
    kodeprojek character varying,
    total double precision,
    diskonrupiah double precision,
    diskonpersen double precision,
    totalpajak double precision,
    biayalain double precision,
    kasbiayalain character varying,
    kasdiskon character varying,
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying,
    statuspenawaran integer DEFAULT 0
);


ALTER TABLE public.tblpenawaranbeli OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17984)
-- Name: tblpenawaranjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblpenawaranjual (
    kodepenawaranjual character varying(10) NOT NULL,
    tglpenawaranjual date,
    kodedepartemen character varying(10),
    kodeprojek character varying(10),
    total double precision,
    diskonrupiah double precision,
    diskonpersen double precision,
    totalpajak double precision,
    biayalain double precision,
    kasbiayalain character varying(10),
    kasdiskon character varying(10),
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying(10),
    statuspenawaran integer DEFAULT 0
);


ALTER TABLE public.tblpenawaranjual OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 24550)
-- Name: tblpengirimanbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblpengirimanbeli (
    kodepengirimanbeli character varying NOT NULL,
    kodepesananbeli character varying,
    tglpengirimanbeli date,
    kodedepartemen character varying,
    kodeprojek character varying,
    total double precision,
    diskonrupiah double precision,
    diskonpersen double precision,
    totalpajak double precision,
    biayalain double precision,
    kasbiayalain character varying,
    kasdiskon character varying,
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying,
    statuspengiriman integer
);


ALTER TABLE public.tblpengirimanbeli OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 18063)
-- Name: tblpengirimanjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblpengirimanjual (
    kodepengirimanjual character varying NOT NULL,
    kodepesananjual character varying,
    tglpengirimanjual date,
    kodedepartemen character varying,
    kodeprojek character varying,
    total double precision,
    diskonrupiah double precision,
    diskonpersen double precision,
    totalpajak double precision,
    biayalain double precision,
    kasbiayalain character varying,
    kasdiskon character varying,
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying(10),
    statuspengiriman integer
);


ALTER TABLE public.tblpengirimanjual OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 24506)
-- Name: tblpesananbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblpesananbeli (
    kodepesananbeli character varying NOT NULL,
    kodepenawaranbeli character varying,
    tglpesananbeli date,
    kodedepartemen character varying,
    kodeprojek character varying,
    total double precision,
    diskonrupiah double precision,
    diskonpersen double precision,
    totalpajak double precision,
    biayalain double precision,
    kasbiayalain character varying,
    kasdiskon character varying,
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying,
    statuspesanan integer DEFAULT 0
);


ALTER TABLE public.tblpesananbeli OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 18017)
-- Name: tblpesananjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblpesananjual (
    kodepesananjual character varying NOT NULL,
    kodepenawaranjual character varying,
    tglpesananjual date,
    kodedepartemen character varying,
    kodeprojek character varying,
    total double precision,
    diskonrupiah double precision,
    diskonpersen double precision,
    totalpajak double precision,
    biayalain double precision,
    kasbiayalain character varying,
    kasdiskon character varying,
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying(10),
    statuspesanan integer DEFAULT 0
);


ALTER TABLE public.tblpesananjual OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 18382)
-- Name: tblpiutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblpiutang (
    idpiutang integer NOT NULL,
    idjurnal integer,
    kodejual character varying,
    statuspiutang integer DEFAULT 1
);


ALTER TABLE public.tblpiutang OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 18380)
-- Name: tblpiutang_idpiutang_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblpiutang ALTER COLUMN idpiutang ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblpiutang_idpiutang_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 18290)
-- Name: tblproduk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblproduk (
    idproduk character varying NOT NULL,
    produk character varying(30),
    idkategori integer,
    stokmin double precision,
    pajakjual character varying(10),
    pajakbeli character varying(10),
    statusproduk integer
);


ALTER TABLE public.tblproduk OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 17854)
-- Name: tblprojek; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblprojek (
    idprojek character varying(10) NOT NULL,
    projek character varying(30),
    idstatus integer,
    manajer integer,
    pelanggan integer,
    persentase integer,
    catatan text
);


ALTER TABLE public.tblprojek OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 24645)
-- Name: tblreturbeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblreturbeli (
    kodereturbeli character varying NOT NULL,
    kodebeli character varying,
    tglreturbeli date,
    kodedepartemen character varying,
    kodeprojek character varying,
    total double precision DEFAULT 0,
    bayar double precision DEFAULT 0,
    kembali double precision DEFAULT 0,
    diskonrupiah double precision DEFAULT 0,
    diskonpersen double precision DEFAULT 0,
    totalpajak double precision DEFAULT 0,
    biayalain double precision DEFAULT 0,
    kasbiayalain character varying,
    kasdiskon character varying,
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying,
    statusreturbeli integer DEFAULT 0,
    kaspenerimaan character varying
);


ALTER TABLE public.tblreturbeli OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 18240)
-- Name: tblreturjual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblreturjual (
    kodereturjual character varying NOT NULL,
    kodejual character varying,
    tglreturjual date,
    kodedepartemen character varying,
    kodeprojek character varying,
    total double precision DEFAULT 0,
    bayar double precision DEFAULT 0,
    kembali double precision DEFAULT 0,
    diskonrupiah double precision DEFAULT 0,
    diskonpersen double precision DEFAULT 0,
    totalpajak double precision DEFAULT 0,
    biayalain double precision DEFAULT 0,
    kasbiayalain character varying,
    kasdiskon character varying,
    nomerdokumen character varying,
    tgldokumen date,
    pelanggan integer,
    kodegudang character varying,
    statusreturjual integer DEFAULT 0,
    kaspenerimaan character varying
);


ALTER TABLE public.tblreturjual OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 17879)
-- Name: tblsatuan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblsatuan (
    kodesatuan integer NOT NULL,
    satuan character varying(20),
    deskripsisatuan character varying(30)
);


ALTER TABLE public.tblsatuan OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 17877)
-- Name: tblsatuan_kodesatuan_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblsatuan ALTER COLUMN kodesatuan ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblsatuan_kodesatuan_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 207 (class 1259 OID 17841)
-- Name: tblstatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblstatus (
    idstatus integer NOT NULL,
    status character varying(30),
    deskripsi character varying(30)
);


ALTER TABLE public.tblstatus OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 17839)
-- Name: tblstatus_idstatus_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblstatus ALTER COLUMN idstatus ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblstatus_idstatus_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 283 (class 1259 OID 27376)
-- Name: tblstok; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblstok (
    kodestok character varying NOT NULL,
    kodegudang character varying(10),
    tglstok date,
    kodeakun character varying,
    idharga integer,
    kodedepartemen character varying,
    jumlah double precision
);


ALTER TABLE public.tblstok OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 18315)
-- Name: tblstokgudang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblstokgudang (
    idstokgudang integer NOT NULL,
    idgudang character varying(10),
    stok double precision,
    idharga integer
);


ALTER TABLE public.tblstokgudang OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 18313)
-- Name: tblstokgudang_idstokgudang_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tblstokgudang ALTER COLUMN idstokgudang ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tblstokgudang_idstokgudang_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 18574)
-- Name: tblstokopname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblstokopname (
    kodestokopname character varying NOT NULL,
    kodegudang character varying(10),
    tglstokopname date,
    kodeakun character varying,
    idharga integer,
    kodedepartemen character varying,
    buku double precision,
    fisik double precision
);


ALTER TABLE public.tblstokopname OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 17793)
-- Name: tblsubklasifikasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tblsubklasifikasi (
    subklasifikasi character varying(50),
    tipearuskas character varying(30),
    tiperasio character varying(30),
    idsubklasifikasi character varying(10) NOT NULL,
    idklasifikasi integer,
    defaultstatus smallint DEFAULT 0
);


ALTER TABLE public.tblsubklasifikasi OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 26883)
-- Name: tbltransaksi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbltransaksi (
    akunasal character varying(10),
    kontak integer,
    deskripsitransaksi text,
    tipetransaksi character(2),
    kodetransaksi character varying NOT NULL,
    tgltransaksi date,
    akuntujuan character varying(10),
    kodedepartemen character varying,
    kodeprojek character varying,
    jumlah double precision
);


ALTER TABLE public.tbltransaksi OWNER TO postgres;

--
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN tbltransaksi.tipetransaksi; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tbltransaksi.tipetransaksi IS 'M masuk K Keluar';


--
-- TOC entry 292 (class 1259 OID 27671)
-- Name: tbluser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbluser (
    username character varying NOT NULL,
    password character varying,
    hakakses character varying
);


ALTER TABLE public.tbluser OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 27679)
-- Name: view_akses; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_akses AS
 SELECT hakakses.id,
    hakakses.akses,
    tblfitur.fitur,
    tblfitur.asal,
    tblfitur.posisiasal
   FROM (public.hakakses
     JOIN public.tblfitur ON ((hakakses.fitur = tblfitur.id)))
  ORDER BY hakakses.akses, tblfitur.posisiasal, tblfitur.id;


ALTER TABLE public.view_akses OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 24239)
-- Name: view_laba_berjalan; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_laba_berjalan AS
 SELECT to_char((tbljurnal.tgljurnal)::timestamp with time zone, 'YYYY'::text) AS tahun,
    sum((tbljurnal.debit - tbljurnal.kredit)) AS laba
   FROM ((public.tbljurnal
     JOIN public.tblakun ON (((tbljurnal.kodeakun)::text = (tblakun.kodeakun)::text)))
     JOIN public.tblsubklasifikasi ON (((tblakun.idsubklasifikasi)::text = (tblsubklasifikasi.idsubklasifikasi)::text)))
  WHERE (tblsubklasifikasi.idklasifikasi > 3)
  GROUP BY (to_char((tbljurnal.tgljurnal)::timestamp with time zone, 'YYYY'::text));


ALTER TABLE public.view_laba_berjalan OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 24258)
-- Name: view_neraca_refrensi; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_neraca_refrensi AS
 SELECT tbljurnal.koderefrensi,
    sum(tbljurnal.debit) AS debit,
    sum(tbljurnal.kredit) AS kredit
   FROM public.tbljurnal
  GROUP BY tbljurnal.koderefrensi;


ALTER TABLE public.view_neraca_refrensi OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 24883)
-- Name: view_rekap_hutang; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_rekap_hutang AS
SELECT
    NULL::integer AS idpelanggan,
    NULL::character varying(30) AS pelanggan,
    NULL::double precision AS jumlahutang,
    NULL::double precision AS jumlahbayar,
    NULL::double precision AS sisa;


ALTER TABLE public.view_rekap_hutang OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 24298)
-- Name: view_rekap_piutang; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_rekap_piutang AS
SELECT
    NULL::integer AS idpelanggan,
    NULL::character varying(30) AS pelanggan,
    NULL::double precision AS jumlahutang,
    NULL::double precision AS jumlahbayar,
    NULL::double precision AS sisa;


ALTER TABLE public.view_rekap_piutang OWNER TO postgres;

--
-- TOC entry 3280 (class 2604 OID 27585)
-- Name: hakakses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hakakses ALTER COLUMN id SET DEFAULT nextval('public.hakakses_id_seq'::regclass);


--
-- TOC entry 3279 (class 2604 OID 27574)
-- Name: tblfitur id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblfitur ALTER COLUMN id SET DEFAULT nextval('public.tblfitur_id_seq'::regclass);


--
-- TOC entry 3787 (class 0 OID 27582)
-- Dependencies: 291
-- Data for Name: hakakses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hakakses (id, fitur, akses) FROM stdin;
315	1	ADMIN
316	2	ADMIN
317	3	ADMIN
318	4	ADMIN
319	5	ADMIN
320	6	ADMIN
321	7	ADMIN
322	8	ADMIN
323	9	ADMIN
324	24	ADMIN
325	26	ADMIN
326	25	ADMIN
327	27	ADMIN
328	28	ADMIN
329	29	ADMIN
330	30	ADMIN
331	31	ADMIN
332	32	ADMIN
333	33	ADMIN
334	34	ADMIN
335	35	ADMIN
336	36	ADMIN
337	37	ADMIN
338	38	ADMIN
339	39	ADMIN
340	40	ADMIN
341	41	ADMIN
342	42	ADMIN
343	43	ADMIN
344	44	ADMIN
345	45	ADMIN
346	46	ADMIN
347	47	ADMIN
348	48	ADMIN
349	56	ADMIN
350	57	ADMIN
351	49	ADMIN
352	50	ADMIN
353	51	ADMIN
354	52	ADMIN
355	53	ADMIN
166	1	TEST
167	2	TEST
168	3	TEST
169	4	TEST
170	5	TEST
171	6	TEST
172	7	TEST
173	8	TEST
174	30	TEST
175	31	TEST
176	32	TEST
177	33	TEST
178	34	TEST
179	35	TEST
180	36	TEST
181	37	TEST
182	38	TEST
183	39	TEST
184	40	TEST
185	41	TEST
186	42	TEST
187	43	TEST
188	44	TEST
189	45	TEST
190	46	TEST
191	47	TEST
192	48	TEST
193	49	TEST
194	50	TEST
195	51	TEST
196	52	TEST
197	53	TEST
198	54	TEST
199	55	TEST
356	54	ADMIN
357	55	ADMIN
274	1	Kantor
275	2	Kantor
276	3	Kantor
277	4	Kantor
278	5	Kantor
279	6	Kantor
280	7	Kantor
281	8	Kantor
282	9	Kantor
283	24	Kantor
284	25	Kantor
285	26	Kantor
286	27	Kantor
287	28	Kantor
288	29	Kantor
289	30	Kantor
290	31	Kantor
291	32	Kantor
292	33	Kantor
293	34	Kantor
294	35	Kantor
295	36	Kantor
296	37	Kantor
297	38	Kantor
298	39	Kantor
299	40	Kantor
300	41	Kantor
301	42	Kantor
302	43	Kantor
303	44	Kantor
304	45	Kantor
305	46	Kantor
306	47	Kantor
307	48	Kantor
308	49	Kantor
309	50	Kantor
310	51	Kantor
311	52	Kantor
312	53	Kantor
313	54	Kantor
314	55	Kantor
\.


--
-- TOC entry 3783 (class 0 OID 27542)
-- Dependencies: 287
-- Data for Name: tblakses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblakses (hakakses) FROM stdin;
ADMIN
Kantor
\.


--
-- TOC entry 3703 (class 0 OID 17812)
-- Dependencies: 202
-- Data for Name: tblakun; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblakun (kodeakun, idsubklasifikasi, akun, statusakun, defaultstatus) FROM stdin;
110004	1400	Persediaan	1	1
110001	1200	Kas Kecil	1	1
510001	5100	Harga Pokok Penjualan	1	1
219001	2190	Persediaan Dikirim Belum Ditagihkan\r\n	1	1
230001	2300	Utang Pajak	1	1
410001	4100	Penjualan Produk	1	1
410004	4100	Potongan Penjualan	1	1
490001	4900	Pendapatan Lain	1	1
130001	1300	Piutang Usaha	1	1
320001	3200	Laba Tahun Berjalan	1	1
110002	1200	Bank	1	1
152001	1520	Pajak Dibayar Dimuka	1	1
210001	2100	Utang Usaha	1	1
690001	6900	Beban Lain	1	1
510002	5100	Potongan Pembelian	1	1
149001	1490	Persediaan Diterima Belum Ditagihkan	1	1
\.


--
-- TOC entry 3782 (class 0 OID 27419)
-- Dependencies: 286
-- Data for Name: tblaset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblaset (kodeaset, idkategoriaset, aset, tanggaldapat, nilaibeli, nilairesidu) FROM stdin;
\.


--
-- TOC entry 3725 (class 0 OID 18212)
-- Dependencies: 224
-- Data for Name: tblaudit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblaudit (idaudit, kodeakun, kodeprojek, serialdata, kodedepartemen, kontak, tglaudit, debit, kredit, tipe, koderefrensi, deskripsiaudit, createdat, createdfrom, updatedat, updatedmsg, updatedfrom) FROM stdin;
\.


--
-- TOC entry 3766 (class 0 OID 24792)
-- Dependencies: 269
-- Data for Name: tblbayarhutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblbayarhutang (kodebeli, tglbayarhutang, akun, bayarhutang, akunbiayalain, biayalain, kodebayarhutang) FROM stdin;
\.


--
-- TOC entry 3730 (class 0 OID 18340)
-- Dependencies: 229
-- Data for Name: tblbayarpiutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblbayarpiutang (kodejual, tglbayarpiutang, akun, bayarpiutang, akunbiayalain, biayalain, kodebayarpiutang) FROM stdin;
\.


--
-- TOC entry 3759 (class 0 OID 24593)
-- Dependencies: 262
-- Data for Name: tblbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblbeli (kodebeli, kodepengirimanbeli, tglbeli, kodedepartemen, kodeprojek, total, bayar, kembali, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statusbeli, kodepesananbeli, kaspenerimaan) FROM stdin;
\.


--
-- TOC entry 3706 (class 0 OID 17829)
-- Dependencies: 205
-- Data for Name: tbldepartemen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldepartemen (iddepartemen, departemen, penanggunjawab, flagdepartemen, defaultstatus) FROM stdin;
HEAD	Kepala Departemen	1	1	1
\.


--
-- TOC entry 3761 (class 0 OID 24696)
-- Dependencies: 264
-- Data for Name: tbldetailbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailbeli (iddetailbeli, kodebeli, idharga, jumlahbeli, hargabeli, jumlahpajak, catatandetail, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3738 (class 0 OID 18516)
-- Dependencies: 237
-- Data for Name: tbldetailjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailjual (iddetailjual, kodejual, idharga, jumlahjual, hargajual, jumlahpajak, catatandetail, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3762 (class 0 OID 24715)
-- Dependencies: 265
-- Data for Name: tbldetailpenawaranbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailpenawaranbeli (iddetailpenawaranbeli, kodepenawaranbeli, jumlahbeli, hargabeli, jumlahpajak, catatandetail, idharga, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3734 (class 0 OID 18424)
-- Dependencies: 233
-- Data for Name: tbldetailpenawaranjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailpenawaranjual (iddetailpenawaranjual, kodepenawaranjual, jumlahjual, hargajual, jumlahpajak, catatandetail, idharga, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3763 (class 0 OID 24734)
-- Dependencies: 266
-- Data for Name: tbldetailpengirimanbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailpengirimanbeli (iddetailpengirimanbeli, kodepengirimanbeli, idharga, jumlahbeli, hargabeli, jumlahpajak, catatandetail, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3736 (class 0 OID 18470)
-- Dependencies: 235
-- Data for Name: tbldetailpengirimanjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailpengirimanjual (iddetailpengirimanjual, kodepengirimanjual, idharga, jumlahjual, hargajual, jumlahpajak, catatandetail, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3764 (class 0 OID 24753)
-- Dependencies: 267
-- Data for Name: tbldetailpesananbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailpesananbeli (iddetailpesananbeli, kodepesananbeli, idharga, jumlahbeli, hargabeli, jumlahpajak, catatandetail, jumlahkirim, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3735 (class 0 OID 18447)
-- Dependencies: 234
-- Data for Name: tbldetailpesananjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailpesananjual (iddetailpesananjual, kodepesananjual, idharga, jumlahjual, hargajual, jumlahpajak, catatandetail, jumlahkirim, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3765 (class 0 OID 24773)
-- Dependencies: 268
-- Data for Name: tbldetailreturbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailreturbeli (iddetailreturbeli, kodereturbeli, idharga, jumlahbeli, hargabeli, jumlahpajak, catatandetail, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3737 (class 0 OID 18493)
-- Dependencies: 236
-- Data for Name: tbldetailreturjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailreturjual (iddetailreturjual, kodereturjual, idharga, jumlahjual, hargajual, jumlahpajak, catatandetail, diskondetailpersen) FROM stdin;
\.


--
-- TOC entry 3744 (class 0 OID 18587)
-- Dependencies: 243
-- Data for Name: tbldetailstokopname; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailstokopname (iddetailstokopname, kodestokopname, kodebarang, hpp, fisik, selisih, buku, idsatuan) FROM stdin;
\.


--
-- TOC entry 3716 (class 0 OID 17956)
-- Dependencies: 215
-- Data for Name: tbldetailtransaksi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbldetailtransaksi (iddetailtransaksi, idtransaksi, akuntujuan, besartransaksi, kodedepartemen, kodeprojek, catatandetail) FROM stdin;
\.


--
-- TOC entry 3785 (class 0 OID 27571)
-- Dependencies: 289
-- Data for Name: tblfitur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblfitur (id, fitur, asal, posisiasal) FROM stdin;
45	Pengembalian Lebih Bayar (Debit)	Pembelian	4
46	Pengeluaran	Kas	5
1	Akun	Master	1
2	Kontak	Master	1
3	Produk	Master	1
4	Satuan	Master	1
5	Gudang	Master	1
6	Departemen	Master	1
7	Proyek	Master	1
8	Pajak	Master	1
25	Kategori Aset Tetap	Data Lain	2
27	Aset Tetap	Data Lain	2
28	Penyesuaian Stok Manual	Data Lain	2
29	Stok Opname	Data Lain	2
30	Penawaran Harga	Penjualan	3
31	Pesanan Penjualan	Penjualan	3
32	Pengiriman Penjualan	Penjualan	3
33	Faktur Penjualan	Penjualan	3
34	Retur Penjualan	Penjualan	3
35	Piutang Usaha	Penjualan	3
36	Pembayaran Piutang Usaha	Penjualan	3
37	Pengembalian Lebih Bayar (Kredit)	Penjualan	3
38	Penawaran Harga Pembelian	Pembelian	4
39	Pesanan Pembelian	Pembelian	4
40	Pengiriman Pembelian	Pembelian	4
41	Faktur Pembelian	Pembelian	4
42	Retur Pembelian	Pembelian	4
43	Utang Usaha	Pembelian	4
44	Pembayaran Utang Usaha	Pembelian	4
47	Penerimaan	Kas	5
48	Buku Besar	Kas	5
49	Laporan Keuangan	Laporan	6
50	Laporan Produk	Laporan	6
51	Laporan Penjualan dan Piutang	Laporan	6
52	Laporan Pembelian dan Hutang	Laporan	6
53	Laporan Lainnya	Laporan	6
54	User	Utilitas	7
55	Hak Akses	Utilitas	7
9	Kategori Produk	Master	1
24	Subklasifikasi Akun	Master	1
26	Status Proyek	Master	1
56	Giro Masuk	Kas	5
57	Giro Keluar	Kas	5
\.


--
-- TOC entry 3790 (class 0 OID 27691)
-- Dependencies: 295
-- Data for Name: tblgirokeluar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblgirokeluar (kodegirokeluar, koderefrensi, bank, norek, jatuhtempo, tipe, jumlah, status) FROM stdin;
\.


--
-- TOC entry 3789 (class 0 OID 27683)
-- Dependencies: 294
-- Data for Name: tblgiromasuk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblgiromasuk (kodegiromasuk, koderefrensi, bank, norek, jatuhtempo, tipe, jumlah, status) FROM stdin;
\.


--
-- TOC entry 3723 (class 0 OID 18180)
-- Dependencies: 222
-- Data for Name: tblgudang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblgudang (idgudang, gudang, iddepartemen, flaggudang, defaultstatus) FROM stdin;
SIDOARJO	SIDOARJO	HEADD	1	0
HEAD	Utama	HEAD	1	1
\.


--
-- TOC entry 3767 (class 0 OID 24817)
-- Dependencies: 270
-- Data for Name: tblhapushutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblhapushutang (kodehapushutang, tglhapushutang, jumlahhutang, kodedepartemen, kodeprojek, kodeakun) FROM stdin;
\.


--
-- TOC entry 3754 (class 0 OID 24303)
-- Dependencies: 257
-- Data for Name: tblhapuspiutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblhapuspiutang (kodehapuspiutang, tglhapuspiutang, jumlahpiutang, kodedepartemen, kodeprojek, kodeakun) FROM stdin;
\.


--
-- TOC entry 3740 (class 0 OID 18541)
-- Dependencies: 239
-- Data for Name: tblharga; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblharga (idharga, hargajual, hpp, idbarang, hargabeli, idsatuan, level, konversi, nilaidasar) FROM stdin;
\.


--
-- TOC entry 3768 (class 0 OID 24840)
-- Dependencies: 271
-- Data for Name: tblhistoribayarhutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblhistoribayarhutang (idhistoribayarhutang, idjurnal, kodebeli) FROM stdin;
\.


--
-- TOC entry 3753 (class 0 OID 24280)
-- Dependencies: 255
-- Data for Name: tblhistoribayarpiutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblhistoribayarpiutang (idhistoribayarpiutang, idjurnal, kodejual) FROM stdin;
\.


--
-- TOC entry 3769 (class 0 OID 24858)
-- Dependencies: 272
-- Data for Name: tblhistorihutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblhistorihutang (idhistorihutang, idjurnal) FROM stdin;
\.


--
-- TOC entry 3751 (class 0 OID 24268)
-- Dependencies: 253
-- Data for Name: tblhistoripiutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblhistoripiutang (idhistoripiutang, idjurnal) FROM stdin;
\.


--
-- TOC entry 3742 (class 0 OID 18561)
-- Dependencies: 241
-- Data for Name: tblhistoristok; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblhistoristok (idhistoristok, masuk, keluar, harga, tglhistori, idharga, refrensi, hpp) FROM stdin;
\.


--
-- TOC entry 3722 (class 0 OID 18139)
-- Dependencies: 221
-- Data for Name: tbljual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbljual (kodejual, kodepengirimanjual, tgljual, kodedepartemen, kodeprojek, total, bayar, kembali, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statusjual, kodepesananjual, kaspenerimaan) FROM stdin;
\.


--
-- TOC entry 3713 (class 0 OID 17886)
-- Dependencies: 212
-- Data for Name: tbljurnal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbljurnal (idjurnal, kodeakun, kodeprojek, kodedepartemen, kontak, tgljurnal, debit, kredit, tipe, koderefrensi, deskripsijurnal, is_showed) FROM stdin;
\.


--
-- TOC entry 3720 (class 0 OID 18057)
-- Dependencies: 219
-- Data for Name: tblkategori; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblkategori (idkategori, kategori, deskripsikategori) FROM stdin;
1	Minuman	Minuman
\.


--
-- TOC entry 3781 (class 0 OID 27411)
-- Dependencies: 285
-- Data for Name: tblkategoriaset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblkategoriaset (idkategoriaset, kategoriaset, metodepenyusutan, penggunaan) FROM stdin;
1	Kendaraan	GARIS LURUS	8
2	Tanah	TANPA PENYUSUTAN	10
\.


--
-- TOC entry 3777 (class 0 OID 24888)
-- Dependencies: 281
-- Data for Name: tblkelebihanbayarbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblkelebihanbayarbeli (kodekelebihanbayarbeli, akun, jumlah, kodebeli, tglkelebihanbeli) FROM stdin;
\.


--
-- TOC entry 3755 (class 0 OID 24439)
-- Dependencies: 258
-- Data for Name: tblkelebihanbayarjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblkelebihanbayarjual (kodekelebihanbayarjual, akun, jumlah, kodejual, tglkelebihanjual) FROM stdin;
\.


--
-- TOC entry 3701 (class 0 OID 17786)
-- Dependencies: 200
-- Data for Name: tblklasifikasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblklasifikasi (klasifikasi, idklasifikasi) FROM stdin;
Pendapatan	4
Biaya Pendapatan	5
Biaya Operasional	6
Biaya Non Operasional	7
Pendapatan Lain	8
Biaya Lain	9
Harta	1
Modal	3
Kewajiban	2
\.


--
-- TOC entry 3705 (class 0 OID 17824)
-- Dependencies: 204
-- Data for Name: tblkontak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblkontak (idpelanggan, pelanggan, alamat, notelp, posisi, bayarpiutang, bayarhutang, sisapiutang, sisahutang, defaultstatus) FROM stdin;
6	Syafri	12	123	Pelanggan,Pegawai,Supplier	0	0	0	0	0
1	Pekerja Umum	-	0	Pegawai	0	0	0	0	1
2	Supplier Umum	-	0	Supplier	0	0	0	0	1
3	Pelanggan Umum	-	0	Pelanggan	0	0	0	0	1
\.


--
-- TOC entry 3724 (class 0 OID 18206)
-- Dependencies: 223
-- Data for Name: tblpajak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblpajak (kodepajak, pajak, persenpajak, flagpajak, akunpajakjual, akunpajakbeli, defaultstatus) FROM stdin;
PPN 10	PPN	10	1	230001	152001	0
.	Tanpa Pajak	0	1	230001	152001	1
\.


--
-- TOC entry 3756 (class 0 OID 24467)
-- Dependencies: 259
-- Data for Name: tblpenawaranbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblpenawaranbeli (kodepenawaranbeli, tglpenawaranbeli, kodedepartemen, kodeprojek, total, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statuspenawaran) FROM stdin;
\.


--
-- TOC entry 3717 (class 0 OID 17984)
-- Dependencies: 216
-- Data for Name: tblpenawaranjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblpenawaranjual (kodepenawaranjual, tglpenawaranjual, kodedepartemen, kodeprojek, total, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statuspenawaran) FROM stdin;
\.


--
-- TOC entry 3758 (class 0 OID 24550)
-- Dependencies: 261
-- Data for Name: tblpengirimanbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblpengirimanbeli (kodepengirimanbeli, kodepesananbeli, tglpengirimanbeli, kodedepartemen, kodeprojek, total, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statuspengiriman) FROM stdin;
\.


--
-- TOC entry 3721 (class 0 OID 18063)
-- Dependencies: 220
-- Data for Name: tblpengirimanjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblpengirimanjual (kodepengirimanjual, kodepesananjual, tglpengirimanjual, kodedepartemen, kodeprojek, total, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statuspengiriman) FROM stdin;
\.


--
-- TOC entry 3757 (class 0 OID 24506)
-- Dependencies: 260
-- Data for Name: tblpesananbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblpesananbeli (kodepesananbeli, kodepenawaranbeli, tglpesananbeli, kodedepartemen, kodeprojek, total, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statuspesanan) FROM stdin;
\.


--
-- TOC entry 3718 (class 0 OID 18017)
-- Dependencies: 217
-- Data for Name: tblpesananjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblpesananjual (kodepesananjual, kodepenawaranjual, tglpesananjual, kodedepartemen, kodeprojek, total, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statuspesanan) FROM stdin;
\.


--
-- TOC entry 3732 (class 0 OID 18382)
-- Dependencies: 231
-- Data for Name: tblpiutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblpiutang (idpiutang, idjurnal, kodejual, statuspiutang) FROM stdin;
\.


--
-- TOC entry 3727 (class 0 OID 18290)
-- Dependencies: 226
-- Data for Name: tblproduk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblproduk (idproduk, produk, idkategori, stokmin, pajakjual, pajakbeli, statusproduk) FROM stdin;
\.


--
-- TOC entry 3709 (class 0 OID 17854)
-- Dependencies: 208
-- Data for Name: tblprojek; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblprojek (idprojek, projek, idstatus, manajer, pelanggan, persentase, catatan) FROM stdin;
PROTOPROJ	Proto Projek	1	1	3	100	Oke
\.


--
-- TOC entry 3760 (class 0 OID 24645)
-- Dependencies: 263
-- Data for Name: tblreturbeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblreturbeli (kodereturbeli, kodebeli, tglreturbeli, kodedepartemen, kodeprojek, total, bayar, kembali, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statusreturbeli, kaspenerimaan) FROM stdin;
\.


--
-- TOC entry 3726 (class 0 OID 18240)
-- Dependencies: 225
-- Data for Name: tblreturjual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblreturjual (kodereturjual, kodejual, tglreturjual, kodedepartemen, kodeprojek, total, bayar, kembali, diskonrupiah, diskonpersen, totalpajak, biayalain, kasbiayalain, kasdiskon, nomerdokumen, tgldokumen, pelanggan, kodegudang, statusreturjual, kaspenerimaan) FROM stdin;
\.


--
-- TOC entry 3711 (class 0 OID 17879)
-- Dependencies: 210
-- Data for Name: tblsatuan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblsatuan (kodesatuan, satuan, deskripsisatuan) FROM stdin;
1	Sak	Sak
2	pcs	pcs
5	Karung	Karung
\.


--
-- TOC entry 3708 (class 0 OID 17841)
-- Dependencies: 207
-- Data for Name: tblstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblstatus (idstatus, status, deskripsi) FROM stdin;
1	ON PROGRESS	Dalam Pengerjaan
2	DONE	Selesai
\.


--
-- TOC entry 3779 (class 0 OID 27376)
-- Dependencies: 283
-- Data for Name: tblstok; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblstok (kodestok, kodegudang, tglstok, kodeakun, idharga, kodedepartemen, jumlah) FROM stdin;
\.


--
-- TOC entry 3729 (class 0 OID 18315)
-- Dependencies: 228
-- Data for Name: tblstokgudang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblstokgudang (idstokgudang, idgudang, stok, idharga) FROM stdin;
\.


--
-- TOC entry 3743 (class 0 OID 18574)
-- Dependencies: 242
-- Data for Name: tblstokopname; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblstokopname (kodestokopname, kodegudang, tglstokopname, kodeakun, idharga, kodedepartemen, buku, fisik) FROM stdin;
\.


--
-- TOC entry 3702 (class 0 OID 17793)
-- Dependencies: 201
-- Data for Name: tblsubklasifikasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tblsubklasifikasi (subklasifikasi, tipearuskas, tiperasio, idsubklasifikasi, idklasifikasi, defaultstatus) FROM stdin;
Piutang Usaha	Operating	Aset Lancar Lainnya	1300	1	1
Bank	UNDEFINED	Setara Kas	1200	1	1
Persediaan Barang	Operating	Persediaan	1400	1	1
Beban atas Pendapatan	Operating	Beban Pendapatan	5100	5	1
Utang Lain	Operating	Kewajiban Lancar	2190	2	1
Utang Pajak	Operating	Kewajiban Lancar	2300	2	1
Pendapatan Usaha	Operating	Pendapatan	4100	4	1
Pendapatan Lain	Operating	Pendapatan	4900	4	1
Laba	Financing	Earnings	3200	3	1
Pajak Dibayar Dimuka	Operating	Uang Muka	1520	1	1
Utang Usaha	Operating	Kewajiban Lancar	2100	2	1
Beban Operasional Lain	Operating	Biaya Operasional	6900	6	1
Persediaan Lain	Operating	Persediaan	1490	1	1
\.


--
-- TOC entry 3778 (class 0 OID 26883)
-- Dependencies: 282
-- Data for Name: tbltransaksi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbltransaksi (akunasal, kontak, deskripsitransaksi, tipetransaksi, kodetransaksi, tgltransaksi, akuntujuan, kodedepartemen, kodeprojek, jumlah) FROM stdin;
\.


--
-- TOC entry 3788 (class 0 OID 27671)
-- Dependencies: 292
-- Data for Name: tbluser; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbluser (username, password, hakakses) FROM stdin;
admin	DCxPynKDY0U=	ADMIN
\.


--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 290
-- Name: hakakses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hakakses_id_seq', 357, true);


--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 276
-- Name: tbldetailbeli_iddetailbeli_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailbeli_iddetailbeli_seq', 1, false);


--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 247
-- Name: tbldetailjual_iddetailjual_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailjual_iddetailjual_seq', 1, false);


--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 273
-- Name: tbldetailpenawaranbeli_iddetailpenawaranbeli_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailpenawaranbeli_iddetailpenawaranbeli_seq', 1, false);


--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 232
-- Name: tbldetailpenawaranjual_iddetailpenawaranjual_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailpenawaranjual_iddetailpenawaranjual_seq', 1, false);


--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 274
-- Name: tbldetailpengirimanbeli_iddetailpengirimanbeli_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailpengirimanbeli_iddetailpengirimanbeli_seq', 1, false);


--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 246
-- Name: tbldetailpengirimanjual_iddetailpengirimanjual_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailpengirimanjual_iddetailpengirimanjual_seq', 1, false);


--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 275
-- Name: tbldetailpesananbeli_iddetailpesananbeli_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailpesananbeli_iddetailpesananbeli_seq', 1, false);


--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 245
-- Name: tbldetailpesananjual_iddetailpesananjual_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailpesananjual_iddetailpesananjual_seq', 1, false);


--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 277
-- Name: tbldetailreturbeli_iddetailreturbeli_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailreturbeli_iddetailreturbeli_seq', 1, false);


--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 249
-- Name: tbldetailreturjual_iddetailreturjual_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailreturjual_iddetailreturjual_seq', 1, false);


--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 244
-- Name: tbldetailstokopname_iddetailstokopname_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailstokopname_iddetailstokopname_seq', 1, false);


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 214
-- Name: tbldetailtransaksi_iddetailtransaksi_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbldetailtransaksi_iddetailtransaksi_seq', 1, false);


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 288
-- Name: tblfitur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblfitur_id_seq', 57, true);


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 238
-- Name: tblharga_idharga_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblharga_idharga_seq', 1, false);


--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 278
-- Name: tblhistoribayarhutang_idhistoribayarhutang_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblhistoribayarhutang_idhistoribayarhutang_seq', 1, false);


--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 254
-- Name: tblhistoribayarpiutang_idhistoribayarpiutang_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblhistoribayarpiutang_idhistoribayarpiutang_seq', 1, false);


--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 279
-- Name: tblhistorihutang_idhistorihutang_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblhistorihutang_idhistorihutang_seq', 1, false);


--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 252
-- Name: tblhistoripiutang_idhistoripiutang_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblhistoripiutang_idhistoripiutang_seq', 1, false);


--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 240
-- Name: tblhistoristok_idhistoristok_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblhistoristok_idhistoristok_seq', 1, false);


--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 211
-- Name: tbljurnal_idjurnal_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbljurnal_idjurnal_seq', 1, false);


--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 218
-- Name: tblkategori_idkategori_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblkategori_idkategori_seq', 2, true);


--
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 284
-- Name: tblkategoriaset_idkategoriaset_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblkategoriaset_idkategoriaset_seq', 3, true);


--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 213
-- Name: tblklasifikasi_idklasifikasi_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblklasifikasi_idklasifikasi_seq', 9, true);


--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 203
-- Name: tblkontak_idpelanggan_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblkontak_idpelanggan_seq', 6, true);


--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 230
-- Name: tblpiutang_idpiutang_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblpiutang_idpiutang_seq', 1, false);


--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 209
-- Name: tblsatuan_kodesatuan_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblsatuan_kodesatuan_seq', 5, true);


--
-- TOC entry 3828 (class 0 OID 0)
-- Dependencies: 206
-- Name: tblstatus_idstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblstatus_idstatus_seq', 3, true);


--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 227
-- Name: tblstokgudang_idstokgudang_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tblstokgudang_idstokgudang_seq', 1, false);


--
-- TOC entry 3394 (class 2606 OID 27549)
-- Name: tblakses tblakses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblakses
    ADD CONSTRAINT tblakses_pkey PRIMARY KEY (hakakses);


--
-- TOC entry 3287 (class 2606 OID 17816)
-- Name: tblakun tblakun_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblakun
    ADD CONSTRAINT tblakun_pkey PRIMARY KEY (kodeakun);


--
-- TOC entry 3392 (class 2606 OID 27426)
-- Name: tblaset tblaset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblaset
    ADD CONSTRAINT tblaset_pkey PRIMARY KEY (kodeaset);


--
-- TOC entry 3317 (class 2606 OID 18219)
-- Name: tblaudit tblaudit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblaudit
    ADD CONSTRAINT tblaudit_pkey PRIMARY KEY (idaudit);


--
-- TOC entry 3376 (class 2606 OID 24801)
-- Name: tblbayarhutang tblbayarhutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbayarhutang
    ADD CONSTRAINT tblbayarhutang_pkey PRIMARY KEY (kodebayarhutang);


--
-- TOC entry 3326 (class 2606 OID 24351)
-- Name: tblbayarpiutang tblbayarpiutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbayarpiutang
    ADD CONSTRAINT tblbayarpiutang_pkey PRIMARY KEY (kodebayarpiutang);


--
-- TOC entry 3362 (class 2606 OID 24604)
-- Name: tblbeli tblbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbeli
    ADD CONSTRAINT tblbeli_pkey PRIMARY KEY (kodebeli);


--
-- TOC entry 3291 (class 2606 OID 17833)
-- Name: tbldepartemen tbldepartemen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldepartemen
    ADD CONSTRAINT tbldepartemen_pkey PRIMARY KEY (iddepartemen);


--
-- TOC entry 3366 (class 2606 OID 24704)
-- Name: tbldetailbeli tbldetailbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailbeli
    ADD CONSTRAINT tbldetailbeli_pkey PRIMARY KEY (iddetailbeli);


--
-- TOC entry 3338 (class 2606 OID 18523)
-- Name: tbldetailjual tbldetailjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailjual
    ADD CONSTRAINT tbldetailjual_pkey PRIMARY KEY (iddetailjual);


--
-- TOC entry 3368 (class 2606 OID 24723)
-- Name: tbldetailpenawaranbeli tbldetailpenawaranbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpenawaranbeli
    ADD CONSTRAINT tbldetailpenawaranbeli_pkey PRIMARY KEY (iddetailpenawaranbeli);


--
-- TOC entry 3330 (class 2606 OID 18431)
-- Name: tbldetailpenawaranjual tbldetailpenawaranjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpenawaranjual
    ADD CONSTRAINT tbldetailpenawaranjual_pkey PRIMARY KEY (iddetailpenawaranjual);


--
-- TOC entry 3370 (class 2606 OID 24742)
-- Name: tbldetailpengirimanbeli tbldetailpengirimanbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpengirimanbeli
    ADD CONSTRAINT tbldetailpengirimanbeli_pkey PRIMARY KEY (iddetailpengirimanbeli);


--
-- TOC entry 3334 (class 2606 OID 18477)
-- Name: tbldetailpengirimanjual tbldetailpengirimanjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpengirimanjual
    ADD CONSTRAINT tbldetailpengirimanjual_pkey PRIMARY KEY (iddetailpengirimanjual);


--
-- TOC entry 3372 (class 2606 OID 24762)
-- Name: tbldetailpesananbeli tbldetailpesananbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpesananbeli
    ADD CONSTRAINT tbldetailpesananbeli_pkey PRIMARY KEY (iddetailpesananbeli);


--
-- TOC entry 3332 (class 2606 OID 18454)
-- Name: tbldetailpesananjual tbldetailpesananjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpesananjual
    ADD CONSTRAINT tbldetailpesananjual_pkey PRIMARY KEY (iddetailpesananjual);


--
-- TOC entry 3374 (class 2606 OID 24781)
-- Name: tbldetailreturbeli tbldetailreturbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailreturbeli
    ADD CONSTRAINT tbldetailreturbeli_pkey PRIMARY KEY (iddetailreturbeli);


--
-- TOC entry 3336 (class 2606 OID 18500)
-- Name: tbldetailreturjual tbldetailreturjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailreturjual
    ADD CONSTRAINT tbldetailreturjual_pkey PRIMARY KEY (iddetailreturjual);


--
-- TOC entry 3346 (class 2606 OID 18594)
-- Name: tbldetailstokopname tbldetailstokopname_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailstokopname
    ADD CONSTRAINT tbldetailstokopname_pkey PRIMARY KEY (iddetailstokopname);


--
-- TOC entry 3301 (class 2606 OID 17960)
-- Name: tbldetailtransaksi tbldetailtransaksi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailtransaksi
    ADD CONSTRAINT tbldetailtransaksi_pkey PRIMARY KEY (iddetailtransaksi);


--
-- TOC entry 3396 (class 2606 OID 27579)
-- Name: tblfitur tblfitur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblfitur
    ADD CONSTRAINT tblfitur_pkey PRIMARY KEY (id);


--
-- TOC entry 3402 (class 2606 OID 27698)
-- Name: tblgirokeluar tblgirokeluar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblgirokeluar
    ADD CONSTRAINT tblgirokeluar_pkey PRIMARY KEY (kodegirokeluar);


--
-- TOC entry 3400 (class 2606 OID 27690)
-- Name: tblgiromasuk tblgiromasuk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblgiromasuk
    ADD CONSTRAINT tblgiromasuk_pkey PRIMARY KEY (kodegiromasuk);


--
-- TOC entry 3313 (class 2606 OID 18185)
-- Name: tblgudang tblgudang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblgudang
    ADD CONSTRAINT tblgudang_pkey PRIMARY KEY (idgudang);


--
-- TOC entry 3378 (class 2606 OID 24824)
-- Name: tblhapushutang tblhapushutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhapushutang
    ADD CONSTRAINT tblhapushutang_pkey PRIMARY KEY (kodehapushutang);


--
-- TOC entry 3352 (class 2606 OID 24310)
-- Name: tblhapuspiutang tblhapuspiutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhapuspiutang
    ADD CONSTRAINT tblhapuspiutang_pkey PRIMARY KEY (kodehapuspiutang);


--
-- TOC entry 3340 (class 2606 OID 18548)
-- Name: tblharga tblharga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblharga
    ADD CONSTRAINT tblharga_pkey PRIMARY KEY (idharga);


--
-- TOC entry 3380 (class 2606 OID 24847)
-- Name: tblhistoribayarhutang tblhistoribayarhutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistoribayarhutang
    ADD CONSTRAINT tblhistoribayarhutang_pkey PRIMARY KEY (idhistoribayarhutang);


--
-- TOC entry 3350 (class 2606 OID 24287)
-- Name: tblhistoribayarpiutang tblhistoribayarpiutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistoribayarpiutang
    ADD CONSTRAINT tblhistoribayarpiutang_pkey PRIMARY KEY (idhistoribayarpiutang);


--
-- TOC entry 3382 (class 2606 OID 24862)
-- Name: tblhistorihutang tblhistorihutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistorihutang
    ADD CONSTRAINT tblhistorihutang_pkey PRIMARY KEY (idhistorihutang);


--
-- TOC entry 3348 (class 2606 OID 24272)
-- Name: tblhistoripiutang tblhistoripiutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistoripiutang
    ADD CONSTRAINT tblhistoripiutang_pkey PRIMARY KEY (idhistoripiutang);


--
-- TOC entry 3342 (class 2606 OID 18568)
-- Name: tblhistoristok tblhistoristok_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistoristok
    ADD CONSTRAINT tblhistoristok_pkey PRIMARY KEY (idhistoristok);


--
-- TOC entry 3311 (class 2606 OID 18149)
-- Name: tbljual tbljual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljual
    ADD CONSTRAINT tbljual_pkey PRIMARY KEY (kodejual);


--
-- TOC entry 3299 (class 2606 OID 17893)
-- Name: tbljurnal tbljurnal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljurnal
    ADD CONSTRAINT tbljurnal_pkey PRIMARY KEY (idjurnal);


--
-- TOC entry 3307 (class 2606 OID 18061)
-- Name: tblkategori tblkategori_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblkategori
    ADD CONSTRAINT tblkategori_pkey PRIMARY KEY (idkategori);


--
-- TOC entry 3390 (class 2606 OID 27418)
-- Name: tblkategoriaset tblkategoriaset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblkategoriaset
    ADD CONSTRAINT tblkategoriaset_pkey PRIMARY KEY (idkategoriaset);


--
-- TOC entry 3384 (class 2606 OID 24895)
-- Name: tblkelebihanbayarbeli tblkelebihanbayarbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblkelebihanbayarbeli
    ADD CONSTRAINT tblkelebihanbayarbeli_pkey PRIMARY KEY (kodekelebihanbayarbeli);


--
-- TOC entry 3354 (class 2606 OID 24446)
-- Name: tblkelebihanbayarjual tblkelebihanbayarjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblkelebihanbayarjual
    ADD CONSTRAINT tblkelebihanbayarjual_pkey PRIMARY KEY (kodekelebihanbayarjual);


--
-- TOC entry 3283 (class 2606 OID 17920)
-- Name: tblklasifikasi tblklasifikasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblklasifikasi
    ADD CONSTRAINT tblklasifikasi_pkey PRIMARY KEY (idklasifikasi);


--
-- TOC entry 3289 (class 2606 OID 17828)
-- Name: tblkontak tblkontak_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblkontak
    ADD CONSTRAINT tblkontak_pkey PRIMARY KEY (idpelanggan);


--
-- TOC entry 3315 (class 2606 OID 18211)
-- Name: tblpajak tblpajak_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpajak
    ADD CONSTRAINT tblpajak_pkey PRIMARY KEY (kodepajak);


--
-- TOC entry 3356 (class 2606 OID 24475)
-- Name: tblpenawaranbeli tblpenawaranbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranbeli
    ADD CONSTRAINT tblpenawaranbeli_pkey PRIMARY KEY (kodepenawaranbeli);


--
-- TOC entry 3303 (class 2606 OID 17991)
-- Name: tblpenawaranjual tblpenawaranjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranjual
    ADD CONSTRAINT tblpenawaranjual_pkey PRIMARY KEY (kodepenawaranjual);


--
-- TOC entry 3360 (class 2606 OID 24557)
-- Name: tblpengirimanbeli tblpengirimanbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanbeli
    ADD CONSTRAINT tblpengirimanbeli_pkey PRIMARY KEY (kodepengirimanbeli);


--
-- TOC entry 3309 (class 2606 OID 18070)
-- Name: tblpengirimanjual tblpengirimanjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanjual
    ADD CONSTRAINT tblpengirimanjual_pkey PRIMARY KEY (kodepengirimanjual);


--
-- TOC entry 3358 (class 2606 OID 24514)
-- Name: tblpesananbeli tblpesananbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananbeli
    ADD CONSTRAINT tblpesananbeli_pkey PRIMARY KEY (kodepesananbeli);


--
-- TOC entry 3305 (class 2606 OID 18024)
-- Name: tblpesananjual tblpesananjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananjual
    ADD CONSTRAINT tblpesananjual_pkey PRIMARY KEY (kodepesananjual);


--
-- TOC entry 3328 (class 2606 OID 18391)
-- Name: tblpiutang tblpiutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpiutang
    ADD CONSTRAINT tblpiutang_pkey PRIMARY KEY (idpiutang);


--
-- TOC entry 3321 (class 2606 OID 18297)
-- Name: tblproduk tblproduk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblproduk
    ADD CONSTRAINT tblproduk_pkey PRIMARY KEY (idproduk);


--
-- TOC entry 3295 (class 2606 OID 17861)
-- Name: tblprojek tblprojek_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblprojek
    ADD CONSTRAINT tblprojek_pkey PRIMARY KEY (idprojek);


--
-- TOC entry 3364 (class 2606 OID 24660)
-- Name: tblreturbeli tblreturbeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturbeli
    ADD CONSTRAINT tblreturbeli_pkey PRIMARY KEY (kodereturbeli);


--
-- TOC entry 3319 (class 2606 OID 18254)
-- Name: tblreturjual tblreturjual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturjual
    ADD CONSTRAINT tblreturjual_pkey PRIMARY KEY (kodereturjual);


--
-- TOC entry 3297 (class 2606 OID 17883)
-- Name: tblsatuan tblsatuan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblsatuan
    ADD CONSTRAINT tblsatuan_pkey PRIMARY KEY (kodesatuan);


--
-- TOC entry 3293 (class 2606 OID 17845)
-- Name: tblstatus tblstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstatus
    ADD CONSTRAINT tblstatus_pkey PRIMARY KEY (idstatus);


--
-- TOC entry 3388 (class 2606 OID 27383)
-- Name: tblstok tblstok_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstok
    ADD CONSTRAINT tblstok_pkey PRIMARY KEY (kodestok);


--
-- TOC entry 3323 (class 2606 OID 18322)
-- Name: tblstokgudang tblstokgudang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstokgudang
    ADD CONSTRAINT tblstokgudang_pkey PRIMARY KEY (idstokgudang);


--
-- TOC entry 3344 (class 2606 OID 18581)
-- Name: tblstokopname tblstokopname_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstokopname
    ADD CONSTRAINT tblstokopname_pkey PRIMARY KEY (kodestokopname);


--
-- TOC entry 3285 (class 2606 OID 17806)
-- Name: tblsubklasifikasi tblsubklasifikasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblsubklasifikasi
    ADD CONSTRAINT tblsubklasifikasi_pkey PRIMARY KEY (idsubklasifikasi);


--
-- TOC entry 3386 (class 2606 OID 26890)
-- Name: tbltransaksi tbltransaksi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbltransaksi
    ADD CONSTRAINT tbltransaksi_pkey PRIMARY KEY (kodetransaksi);


--
-- TOC entry 3398 (class 2606 OID 27678)
-- Name: tbluser tbluser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbluser
    ADD CONSTRAINT tbluser_pkey PRIMARY KEY (username);


--
-- TOC entry 3324 (class 1259 OID 24069)
-- Name: unique_stok_gudang; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_stok_gudang ON public.tblstokgudang USING btree (idharga, idgudang);


--
-- TOC entry 3698 (class 2618 OID 24301)
-- Name: view_rekap_piutang _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.view_rekap_piutang AS
 SELECT tblkontak.idpelanggan,
    tblkontak.pelanggan,
    sum(tbljurnal.debit) AS jumlahutang,
    sum(tbljurnal.kredit) AS jumlahbayar,
    sum((tbljurnal.debit - tbljurnal.kredit)) AS sisa
   FROM (public.tbljurnal
     JOIN public.tblkontak ON ((tblkontak.idpelanggan = tbljurnal.kontak)))
  WHERE ((tbljurnal.kodeakun)::text = '130001'::text)
  GROUP BY tbljurnal.kontak, tblkontak.idpelanggan;


--
-- TOC entry 3699 (class 2618 OID 24886)
-- Name: view_rekap_hutang _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.view_rekap_hutang AS
 SELECT tblkontak.idpelanggan,
    tblkontak.pelanggan,
    sum(tbljurnal.debit) AS jumlahutang,
    sum(tbljurnal.kredit) AS jumlahbayar,
    sum((tbljurnal.debit - tbljurnal.kredit)) AS sisa
   FROM (public.tbljurnal
     JOIN public.tblkontak ON ((tblkontak.idpelanggan = tbljurnal.kontak)))
  WHERE ((tbljurnal.kodeakun)::text = '210001'::text)
  GROUP BY tbljurnal.kontak, tblkontak.idpelanggan;


--
-- TOC entry 3559 (class 2620 OID 25414)
-- Name: tblsubklasifikasi check_default_data; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_default_data BEFORE DELETE ON public.tblsubklasifikasi FOR EACH ROW EXECUTE FUNCTION public.prevent_delete_default();


--
-- TOC entry 3560 (class 2620 OID 25406)
-- Name: tblakun prevent_defaultdata_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER prevent_defaultdata_delete BEFORE DELETE ON public.tblakun FOR EACH ROW EXECUTE FUNCTION public.prevent_delete_default();


--
-- TOC entry 3562 (class 2620 OID 25407)
-- Name: tbldepartemen prevent_defaultdata_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER prevent_defaultdata_delete BEFORE DELETE ON public.tbldepartemen FOR EACH ROW EXECUTE FUNCTION public.prevent_delete_default();


--
-- TOC entry 3563 (class 2620 OID 25408)
-- Name: tblgudang prevent_defaultdata_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER prevent_defaultdata_delete BEFORE DELETE ON public.tblgudang FOR EACH ROW EXECUTE FUNCTION public.prevent_delete_default();


--
-- TOC entry 3561 (class 2620 OID 25412)
-- Name: tblkontak prevent_defaultdata_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER prevent_defaultdata_delete BEFORE DELETE ON public.tblkontak FOR EACH ROW EXECUTE FUNCTION public.prevent_delete_default();


--
-- TOC entry 3564 (class 2620 OID 25409)
-- Name: tblpajak prevent_defaultdata_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER prevent_defaultdata_delete BEFORE DELETE ON public.tblpajak FOR EACH ROW EXECUTE FUNCTION public.prevent_delete_default();


--
-- TOC entry 3404 (class 2606 OID 17817)
-- Name: tblakun tblakun_idsubklasifikasi_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblakun
    ADD CONSTRAINT tblakun_idsubklasifikasi_fkey FOREIGN KEY (idsubklasifikasi) REFERENCES public.tblsubklasifikasi(idsubklasifikasi) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3558 (class 2606 OID 27427)
-- Name: tblaset tblaset_idkategoriaset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblaset
    ADD CONSTRAINT tblaset_idkategoriaset_fkey FOREIGN KEY (idkategoriaset) REFERENCES public.tblkategoriaset(idkategoriaset) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3446 (class 2606 OID 18220)
-- Name: tblaudit tblaudit_kodeakun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblaudit
    ADD CONSTRAINT tblaudit_kodeakun_fkey FOREIGN KEY (kodeakun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3448 (class 2606 OID 18230)
-- Name: tblaudit tblaudit_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblaudit
    ADD CONSTRAINT tblaudit_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3449 (class 2606 OID 18235)
-- Name: tblaudit tblaudit_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblaudit
    ADD CONSTRAINT tblaudit_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3447 (class 2606 OID 18225)
-- Name: tblaudit tblaudit_kontak_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblaudit
    ADD CONSTRAINT tblaudit_kontak_fkey FOREIGN KEY (kontak) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3539 (class 2606 OID 24802)
-- Name: tblbayarhutang tblbayarhutang_akun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbayarhutang
    ADD CONSTRAINT tblbayarhutang_akun_fkey FOREIGN KEY (akun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3540 (class 2606 OID 24807)
-- Name: tblbayarhutang tblbayarhutang_akunbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbayarhutang
    ADD CONSTRAINT tblbayarhutang_akunbiayalain_fkey FOREIGN KEY (akunbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3541 (class 2606 OID 24812)
-- Name: tblbayarhutang tblbayarhutang_kodebeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbayarhutang
    ADD CONSTRAINT tblbayarhutang_kodebeli_fkey FOREIGN KEY (kodebeli) REFERENCES public.tblbeli(kodebeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3464 (class 2606 OID 24362)
-- Name: tblbayarpiutang tblbayarpiutang_akun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbayarpiutang
    ADD CONSTRAINT tblbayarpiutang_akun_fkey FOREIGN KEY (akun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3463 (class 2606 OID 24357)
-- Name: tblbayarpiutang tblbayarpiutang_akunbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbayarpiutang
    ADD CONSTRAINT tblbayarpiutang_akunbiayalain_fkey FOREIGN KEY (akunbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3462 (class 2606 OID 24352)
-- Name: tblbayarpiutang tblbayarpiutang_kodejual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbayarpiutang
    ADD CONSTRAINT tblbayarpiutang_kodejual_fkey FOREIGN KEY (kodejual) REFERENCES public.tbljual(kodejual) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3514 (class 2606 OID 24605)
-- Name: tblbeli tblbeli_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbeli
    ADD CONSTRAINT tblbeli_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3515 (class 2606 OID 24610)
-- Name: tblbeli tblbeli_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbeli
    ADD CONSTRAINT tblbeli_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3516 (class 2606 OID 24615)
-- Name: tblbeli tblbeli_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbeli
    ADD CONSTRAINT tblbeli_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3521 (class 2606 OID 24640)
-- Name: tblbeli tblbeli_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbeli
    ADD CONSTRAINT tblbeli_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3520 (class 2606 OID 24635)
-- Name: tblbeli tblbeli_kodepengirimanbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbeli
    ADD CONSTRAINT tblbeli_kodepengirimanbeli_fkey FOREIGN KEY (kodepengirimanbeli) REFERENCES public.tblpengirimanbeli(kodepengirimanbeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3518 (class 2606 OID 24625)
-- Name: tblbeli tblbeli_kodepesananbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbeli
    ADD CONSTRAINT tblbeli_kodepesananbeli_fkey FOREIGN KEY (kodepesananbeli) REFERENCES public.tblpesananbeli(kodepesananbeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3517 (class 2606 OID 24620)
-- Name: tblbeli tblbeli_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbeli
    ADD CONSTRAINT tblbeli_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3519 (class 2606 OID 24630)
-- Name: tblbeli tblbeli_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblbeli
    ADD CONSTRAINT tblbeli_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3405 (class 2606 OID 17834)
-- Name: tbldepartemen tbldepartemen_penanggunjawab_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldepartemen
    ADD CONSTRAINT tbldepartemen_penanggunjawab_fkey FOREIGN KEY (penanggunjawab) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3530 (class 2606 OID 24710)
-- Name: tbldetailbeli tbldetailbeli_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailbeli
    ADD CONSTRAINT tbldetailbeli_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3529 (class 2606 OID 24705)
-- Name: tbldetailbeli tbldetailbeli_kodebeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailbeli
    ADD CONSTRAINT tbldetailbeli_kodebeli_fkey FOREIGN KEY (kodebeli) REFERENCES public.tblbeli(kodebeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3476 (class 2606 OID 24076)
-- Name: tbldetailjual tbldetailjual_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailjual
    ADD CONSTRAINT tbldetailjual_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3475 (class 2606 OID 18524)
-- Name: tbldetailjual tbldetailjual_kodejual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailjual
    ADD CONSTRAINT tbldetailjual_kodejual_fkey FOREIGN KEY (kodejual) REFERENCES public.tbljual(kodejual) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3532 (class 2606 OID 24729)
-- Name: tbldetailpenawaranbeli tbldetailpenawaranbeli_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpenawaranbeli
    ADD CONSTRAINT tbldetailpenawaranbeli_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3531 (class 2606 OID 24724)
-- Name: tbldetailpenawaranbeli tbldetailpenawaranbeli_kodepenawaranbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpenawaranbeli
    ADD CONSTRAINT tbldetailpenawaranbeli_kodepenawaranbeli_fkey FOREIGN KEY (kodepenawaranbeli) REFERENCES public.tblpenawaranbeli(kodepenawaranbeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3468 (class 2606 OID 24028)
-- Name: tbldetailpenawaranjual tbldetailpenawaranjual_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpenawaranjual
    ADD CONSTRAINT tbldetailpenawaranjual_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3467 (class 2606 OID 18432)
-- Name: tbldetailpenawaranjual tbldetailpenawaranjual_kodepenawaranjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpenawaranjual
    ADD CONSTRAINT tbldetailpenawaranjual_kodepenawaranjual_fkey FOREIGN KEY (kodepenawaranjual) REFERENCES public.tblpenawaranjual(kodepenawaranjual) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3533 (class 2606 OID 24743)
-- Name: tbldetailpengirimanbeli tbldetailpengirimanbeli_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpengirimanbeli
    ADD CONSTRAINT tbldetailpengirimanbeli_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3534 (class 2606 OID 24748)
-- Name: tbldetailpengirimanbeli tbldetailpengirimanbeli_kodepengirimanbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpengirimanbeli
    ADD CONSTRAINT tbldetailpengirimanbeli_kodepengirimanbeli_fkey FOREIGN KEY (kodepengirimanbeli) REFERENCES public.tblpengirimanbeli(kodepengirimanbeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3471 (class 2606 OID 24043)
-- Name: tbldetailpengirimanjual tbldetailpengirimanjual_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpengirimanjual
    ADD CONSTRAINT tbldetailpengirimanjual_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3472 (class 2606 OID 24048)
-- Name: tbldetailpengirimanjual tbldetailpengirimanjual_kodepengirimanjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpengirimanjual
    ADD CONSTRAINT tbldetailpengirimanjual_kodepengirimanjual_fkey FOREIGN KEY (kodepengirimanjual) REFERENCES public.tblpengirimanjual(kodepengirimanjual) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3536 (class 2606 OID 24768)
-- Name: tbldetailpesananbeli tbldetailpesananbeli_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpesananbeli
    ADD CONSTRAINT tbldetailpesananbeli_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3535 (class 2606 OID 24763)
-- Name: tbldetailpesananbeli tbldetailpesananbeli_kodepesananbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpesananbeli
    ADD CONSTRAINT tbldetailpesananbeli_kodepesananbeli_fkey FOREIGN KEY (kodepesananbeli) REFERENCES public.tblpesananbeli(kodepesananbeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3470 (class 2606 OID 24034)
-- Name: tbldetailpesananjual tbldetailpesananjual_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpesananjual
    ADD CONSTRAINT tbldetailpesananjual_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3469 (class 2606 OID 18455)
-- Name: tbldetailpesananjual tbldetailpesananjual_kodepesananjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailpesananjual
    ADD CONSTRAINT tbldetailpesananjual_kodepesananjual_fkey FOREIGN KEY (kodepesananjual) REFERENCES public.tblpesananjual(kodepesananjual) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3538 (class 2606 OID 24787)
-- Name: tbldetailreturbeli tbldetailreturbeli_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailreturbeli
    ADD CONSTRAINT tbldetailreturbeli_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3537 (class 2606 OID 24782)
-- Name: tbldetailreturbeli tbldetailreturbeli_kodereturbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailreturbeli
    ADD CONSTRAINT tbldetailreturbeli_kodereturbeli_fkey FOREIGN KEY (kodereturbeli) REFERENCES public.tblreturbeli(kodereturbeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3474 (class 2606 OID 24251)
-- Name: tbldetailreturjual tbldetailreturjual_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailreturjual
    ADD CONSTRAINT tbldetailreturjual_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3473 (class 2606 OID 18501)
-- Name: tbldetailreturjual tbldetailreturjual_kodereturjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailreturjual
    ADD CONSTRAINT tbldetailreturjual_kodereturjual_fkey FOREIGN KEY (kodereturjual) REFERENCES public.tblreturjual(kodereturjual) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3486 (class 2606 OID 18612)
-- Name: tbldetailstokopname tbldetailstokopname_idsatuan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailstokopname
    ADD CONSTRAINT tbldetailstokopname_idsatuan_fkey FOREIGN KEY (idsatuan) REFERENCES public.tblsatuan(kodesatuan) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3485 (class 2606 OID 18600)
-- Name: tbldetailstokopname tbldetailstokopname_kodebarang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailstokopname
    ADD CONSTRAINT tbldetailstokopname_kodebarang_fkey FOREIGN KEY (kodebarang) REFERENCES public.tblproduk(idproduk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3484 (class 2606 OID 18595)
-- Name: tbldetailstokopname tbldetailstokopname_kodestokopname_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailstokopname
    ADD CONSTRAINT tbldetailstokopname_kodestokopname_fkey FOREIGN KEY (kodestokopname) REFERENCES public.tblstokopname(kodestokopname) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3413 (class 2606 OID 17969)
-- Name: tbldetailtransaksi tbldetailtransaksi_akuntujuan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailtransaksi
    ADD CONSTRAINT tbldetailtransaksi_akuntujuan_fkey FOREIGN KEY (akuntujuan) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3414 (class 2606 OID 17974)
-- Name: tbldetailtransaksi tbldetailtransaksi_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailtransaksi
    ADD CONSTRAINT tbldetailtransaksi_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3415 (class 2606 OID 17979)
-- Name: tbldetailtransaksi tbldetailtransaksi_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbldetailtransaksi
    ADD CONSTRAINT tbldetailtransaksi_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3542 (class 2606 OID 24825)
-- Name: tblhapushutang tblhapushutang_kodeakun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhapushutang
    ADD CONSTRAINT tblhapushutang_kodeakun_fkey FOREIGN KEY (kodeakun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3543 (class 2606 OID 24830)
-- Name: tblhapushutang tblhapushutang_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhapushutang
    ADD CONSTRAINT tblhapushutang_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3544 (class 2606 OID 24835)
-- Name: tblhapushutang tblhapushutang_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhapushutang
    ADD CONSTRAINT tblhapushutang_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3491 (class 2606 OID 24321)
-- Name: tblhapuspiutang tblhapuspiutang_kodeakun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhapuspiutang
    ADD CONSTRAINT tblhapuspiutang_kodeakun_fkey FOREIGN KEY (kodeakun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3489 (class 2606 OID 24311)
-- Name: tblhapuspiutang tblhapuspiutang_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhapuspiutang
    ADD CONSTRAINT tblhapuspiutang_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3490 (class 2606 OID 24316)
-- Name: tblhapuspiutang tblhapuspiutang_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhapuspiutang
    ADD CONSTRAINT tblhapuspiutang_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3477 (class 2606 OID 18549)
-- Name: tblharga tblharga_idbarang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblharga
    ADD CONSTRAINT tblharga_idbarang_fkey FOREIGN KEY (idbarang) REFERENCES public.tblproduk(idproduk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3545 (class 2606 OID 24848)
-- Name: tblhistoribayarhutang tblhistoribayarhutang_idjurnal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistoribayarhutang
    ADD CONSTRAINT tblhistoribayarhutang_idjurnal_fkey FOREIGN KEY (idjurnal) REFERENCES public.tbljurnal(idjurnal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3488 (class 2606 OID 24288)
-- Name: tblhistoribayarpiutang tblhistoribayarpiutang_idjurnal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistoribayarpiutang
    ADD CONSTRAINT tblhistoribayarpiutang_idjurnal_fkey FOREIGN KEY (idjurnal) REFERENCES public.tbljurnal(idjurnal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3546 (class 2606 OID 24863)
-- Name: tblhistorihutang tblhistorihutang_idjurnal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistorihutang
    ADD CONSTRAINT tblhistorihutang_idjurnal_fkey FOREIGN KEY (idjurnal) REFERENCES public.tbljurnal(idjurnal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3487 (class 2606 OID 24273)
-- Name: tblhistoripiutang tblhistoripiutang_idjurnal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistoripiutang
    ADD CONSTRAINT tblhistoripiutang_idjurnal_fkey FOREIGN KEY (idjurnal) REFERENCES public.tbljurnal(idjurnal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3478 (class 2606 OID 24070)
-- Name: tblhistoristok tblhistoristok_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblhistoristok
    ADD CONSTRAINT tblhistoristok_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3437 (class 2606 OID 18155)
-- Name: tbljual tbljual_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljual
    ADD CONSTRAINT tbljual_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3436 (class 2606 OID 18150)
-- Name: tbljual tbljual_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljual
    ADD CONSTRAINT tbljual_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3439 (class 2606 OID 18165)
-- Name: tbljual tbljual_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljual
    ADD CONSTRAINT tbljual_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3442 (class 2606 OID 18201)
-- Name: tbljual tbljual_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljual
    ADD CONSTRAINT tbljual_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3441 (class 2606 OID 18175)
-- Name: tbljual tbljual_kodepengirimanjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljual
    ADD CONSTRAINT tbljual_kodepengirimanjual_fkey FOREIGN KEY (kodepengirimanjual) REFERENCES public.tblpengirimanjual(kodepengirimanjual) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3443 (class 2606 OID 24225)
-- Name: tbljual tbljual_kodepesananjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljual
    ADD CONSTRAINT tbljual_kodepesananjual_fkey FOREIGN KEY (kodepesananjual) REFERENCES public.tblpesananjual(kodepesananjual) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3440 (class 2606 OID 18170)
-- Name: tbljual tbljual_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljual
    ADD CONSTRAINT tbljual_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3438 (class 2606 OID 18160)
-- Name: tbljual tbljual_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljual
    ADD CONSTRAINT tbljual_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3409 (class 2606 OID 17894)
-- Name: tbljurnal tbljurnal_kodeakun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljurnal
    ADD CONSTRAINT tbljurnal_kodeakun_fkey FOREIGN KEY (kodeakun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3411 (class 2606 OID 17904)
-- Name: tbljurnal tbljurnal_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljurnal
    ADD CONSTRAINT tbljurnal_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3410 (class 2606 OID 17899)
-- Name: tbljurnal tbljurnal_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljurnal
    ADD CONSTRAINT tbljurnal_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3412 (class 2606 OID 17909)
-- Name: tbljurnal tbljurnal_kontak_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbljurnal
    ADD CONSTRAINT tbljurnal_kontak_fkey FOREIGN KEY (kontak) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3547 (class 2606 OID 24896)
-- Name: tblkelebihanbayarbeli tblkelebihanbayarbeli_akun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblkelebihanbayarbeli
    ADD CONSTRAINT tblkelebihanbayarbeli_akun_fkey FOREIGN KEY (akun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3548 (class 2606 OID 24901)
-- Name: tblkelebihanbayarbeli tblkelebihanbayarbeli_kodebeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblkelebihanbayarbeli
    ADD CONSTRAINT tblkelebihanbayarbeli_kodebeli_fkey FOREIGN KEY (kodebeli) REFERENCES public.tblbeli(kodebeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3492 (class 2606 OID 24447)
-- Name: tblkelebihanbayarjual tblkelebihanbayarjual_akun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblkelebihanbayarjual
    ADD CONSTRAINT tblkelebihanbayarjual_akun_fkey FOREIGN KEY (akun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3493 (class 2606 OID 24452)
-- Name: tblkelebihanbayarjual tblkelebihanbayarjual_kodejual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblkelebihanbayarjual
    ADD CONSTRAINT tblkelebihanbayarjual_kodejual_fkey FOREIGN KEY (kodejual) REFERENCES public.tbljual(kodejual) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3445 (class 2606 OID 20892)
-- Name: tblpajak tblpajak_akunpajakbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpajak
    ADD CONSTRAINT tblpajak_akunpajakbeli_fkey FOREIGN KEY (akunpajakbeli) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3444 (class 2606 OID 20887)
-- Name: tblpajak tblpajak_akunpajakjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpajak
    ADD CONSTRAINT tblpajak_akunpajakjual_fkey FOREIGN KEY (akunpajakjual) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3495 (class 2606 OID 24481)
-- Name: tblpenawaranbeli tblpenawaranbeli_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranbeli
    ADD CONSTRAINT tblpenawaranbeli_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3494 (class 2606 OID 24476)
-- Name: tblpenawaranbeli tblpenawaranbeli_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranbeli
    ADD CONSTRAINT tblpenawaranbeli_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3496 (class 2606 OID 24486)
-- Name: tblpenawaranbeli tblpenawaranbeli_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranbeli
    ADD CONSTRAINT tblpenawaranbeli_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3499 (class 2606 OID 24501)
-- Name: tblpenawaranbeli tblpenawaranbeli_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranbeli
    ADD CONSTRAINT tblpenawaranbeli_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3497 (class 2606 OID 24491)
-- Name: tblpenawaranbeli tblpenawaranbeli_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranbeli
    ADD CONSTRAINT tblpenawaranbeli_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3498 (class 2606 OID 24496)
-- Name: tblpenawaranbeli tblpenawaranbeli_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranbeli
    ADD CONSTRAINT tblpenawaranbeli_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3418 (class 2606 OID 18002)
-- Name: tblpenawaranjual tblpenawaranjual_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranjual
    ADD CONSTRAINT tblpenawaranjual_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3419 (class 2606 OID 18007)
-- Name: tblpenawaranjual tblpenawaranjual_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranjual
    ADD CONSTRAINT tblpenawaranjual_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3416 (class 2606 OID 17992)
-- Name: tblpenawaranjual tblpenawaranjual_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranjual
    ADD CONSTRAINT tblpenawaranjual_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3421 (class 2606 OID 18186)
-- Name: tblpenawaranjual tblpenawaranjual_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranjual
    ADD CONSTRAINT tblpenawaranjual_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3417 (class 2606 OID 17997)
-- Name: tblpenawaranjual tblpenawaranjual_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranjual
    ADD CONSTRAINT tblpenawaranjual_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3420 (class 2606 OID 18012)
-- Name: tblpenawaranjual tblpenawaranjual_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpenawaranjual
    ADD CONSTRAINT tblpenawaranjual_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3507 (class 2606 OID 24558)
-- Name: tblpengirimanbeli tblpengirimanbeli_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanbeli
    ADD CONSTRAINT tblpengirimanbeli_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3508 (class 2606 OID 24563)
-- Name: tblpengirimanbeli tblpengirimanbeli_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanbeli
    ADD CONSTRAINT tblpengirimanbeli_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3509 (class 2606 OID 24568)
-- Name: tblpengirimanbeli tblpengirimanbeli_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanbeli
    ADD CONSTRAINT tblpengirimanbeli_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3513 (class 2606 OID 24588)
-- Name: tblpengirimanbeli tblpengirimanbeli_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanbeli
    ADD CONSTRAINT tblpengirimanbeli_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3511 (class 2606 OID 24578)
-- Name: tblpengirimanbeli tblpengirimanbeli_kodepesananbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanbeli
    ADD CONSTRAINT tblpengirimanbeli_kodepesananbeli_fkey FOREIGN KEY (kodepesananbeli) REFERENCES public.tblpesananbeli(kodepesananbeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3510 (class 2606 OID 24573)
-- Name: tblpengirimanbeli tblpengirimanbeli_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanbeli
    ADD CONSTRAINT tblpengirimanbeli_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3512 (class 2606 OID 24583)
-- Name: tblpengirimanbeli tblpengirimanbeli_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanbeli
    ADD CONSTRAINT tblpengirimanbeli_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3430 (class 2606 OID 18076)
-- Name: tblpengirimanjual tblpengirimanjual_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanjual
    ADD CONSTRAINT tblpengirimanjual_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3429 (class 2606 OID 18071)
-- Name: tblpengirimanjual tblpengirimanjual_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanjual
    ADD CONSTRAINT tblpengirimanjual_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3432 (class 2606 OID 18086)
-- Name: tblpengirimanjual tblpengirimanjual_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanjual
    ADD CONSTRAINT tblpengirimanjual_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3435 (class 2606 OID 18191)
-- Name: tblpengirimanjual tblpengirimanjual_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanjual
    ADD CONSTRAINT tblpengirimanjual_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3434 (class 2606 OID 18096)
-- Name: tblpengirimanjual tblpengirimanjual_kodepesananjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanjual
    ADD CONSTRAINT tblpengirimanjual_kodepesananjual_fkey FOREIGN KEY (kodepesananjual) REFERENCES public.tblpesananjual(kodepesananjual) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3433 (class 2606 OID 18091)
-- Name: tblpengirimanjual tblpengirimanjual_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanjual
    ADD CONSTRAINT tblpengirimanjual_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3431 (class 2606 OID 18081)
-- Name: tblpengirimanjual tblpengirimanjual_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpengirimanjual
    ADD CONSTRAINT tblpengirimanjual_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3501 (class 2606 OID 24520)
-- Name: tblpesananbeli tblpesananbeli_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananbeli
    ADD CONSTRAINT tblpesananbeli_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3500 (class 2606 OID 24515)
-- Name: tblpesananbeli tblpesananbeli_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananbeli
    ADD CONSTRAINT tblpesananbeli_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3502 (class 2606 OID 24525)
-- Name: tblpesananbeli tblpesananbeli_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananbeli
    ADD CONSTRAINT tblpesananbeli_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3505 (class 2606 OID 24540)
-- Name: tblpesananbeli tblpesananbeli_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananbeli
    ADD CONSTRAINT tblpesananbeli_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3506 (class 2606 OID 24545)
-- Name: tblpesananbeli tblpesananbeli_kodepenawaranbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananbeli
    ADD CONSTRAINT tblpesananbeli_kodepenawaranbeli_fkey FOREIGN KEY (kodepenawaranbeli) REFERENCES public.tblpenawaranbeli(kodepenawaranbeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3503 (class 2606 OID 24530)
-- Name: tblpesananbeli tblpesananbeli_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananbeli
    ADD CONSTRAINT tblpesananbeli_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3504 (class 2606 OID 24535)
-- Name: tblpesananbeli tblpesananbeli_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananbeli
    ADD CONSTRAINT tblpesananbeli_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3424 (class 2606 OID 18035)
-- Name: tblpesananjual tblpesananjual_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananjual
    ADD CONSTRAINT tblpesananjual_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3426 (class 2606 OID 18040)
-- Name: tblpesananjual tblpesananjual_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananjual
    ADD CONSTRAINT tblpesananjual_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3422 (class 2606 OID 18025)
-- Name: tblpesananjual tblpesananjual_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananjual
    ADD CONSTRAINT tblpesananjual_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3428 (class 2606 OID 18196)
-- Name: tblpesananjual tblpesananjual_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananjual
    ADD CONSTRAINT tblpesananjual_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3425 (class 2606 OID 18050)
-- Name: tblpesananjual tblpesananjual_kodepenawaranjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananjual
    ADD CONSTRAINT tblpesananjual_kodepenawaranjual_fkey FOREIGN KEY (kodepenawaranjual) REFERENCES public.tblpenawaranjual(kodepenawaranjual) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3423 (class 2606 OID 18030)
-- Name: tblpesananjual tblpesananjual_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananjual
    ADD CONSTRAINT tblpesananjual_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3427 (class 2606 OID 18045)
-- Name: tblpesananjual tblpesananjual_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpesananjual
    ADD CONSTRAINT tblpesananjual_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3465 (class 2606 OID 18392)
-- Name: tblpiutang tblpiutang_idjurnal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpiutang
    ADD CONSTRAINT tblpiutang_idjurnal_fkey FOREIGN KEY (idjurnal) REFERENCES public.tbljurnal(idjurnal) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3466 (class 2606 OID 18397)
-- Name: tblpiutang tblpiutang_kodejual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblpiutang
    ADD CONSTRAINT tblpiutang_kodejual_fkey FOREIGN KEY (kodejual) REFERENCES public.tbljual(kodejual) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3457 (class 2606 OID 18298)
-- Name: tblproduk tblproduk_idkategori_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblproduk
    ADD CONSTRAINT tblproduk_idkategori_fkey FOREIGN KEY (idkategori) REFERENCES public.tblkategori(idkategori) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3459 (class 2606 OID 18308)
-- Name: tblproduk tblproduk_pajakbeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblproduk
    ADD CONSTRAINT tblproduk_pajakbeli_fkey FOREIGN KEY (pajakbeli) REFERENCES public.tblpajak(kodepajak) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3458 (class 2606 OID 18303)
-- Name: tblproduk tblproduk_pajakjual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblproduk
    ADD CONSTRAINT tblproduk_pajakjual_fkey FOREIGN KEY (pajakjual) REFERENCES public.tblpajak(kodepajak) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3408 (class 2606 OID 17872)
-- Name: tblprojek tblprojek_idstatus_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblprojek
    ADD CONSTRAINT tblprojek_idstatus_fkey FOREIGN KEY (idstatus) REFERENCES public.tblstatus(idstatus) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3406 (class 2606 OID 17862)
-- Name: tblprojek tblprojek_manajer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblprojek
    ADD CONSTRAINT tblprojek_manajer_fkey FOREIGN KEY (manajer) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3407 (class 2606 OID 17867)
-- Name: tblprojek tblprojek_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblprojek
    ADD CONSTRAINT tblprojek_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3522 (class 2606 OID 24661)
-- Name: tblreturbeli tblreturbeli_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturbeli
    ADD CONSTRAINT tblreturbeli_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3523 (class 2606 OID 24666)
-- Name: tblreturbeli tblreturbeli_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturbeli
    ADD CONSTRAINT tblreturbeli_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3527 (class 2606 OID 24686)
-- Name: tblreturbeli tblreturbeli_kodebeli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturbeli
    ADD CONSTRAINT tblreturbeli_kodebeli_fkey FOREIGN KEY (kodebeli) REFERENCES public.tblbeli(kodebeli) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3524 (class 2606 OID 24671)
-- Name: tblreturbeli tblreturbeli_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturbeli
    ADD CONSTRAINT tblreturbeli_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3528 (class 2606 OID 24691)
-- Name: tblreturbeli tblreturbeli_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturbeli
    ADD CONSTRAINT tblreturbeli_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3525 (class 2606 OID 24676)
-- Name: tblreturbeli tblreturbeli_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturbeli
    ADD CONSTRAINT tblreturbeli_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3526 (class 2606 OID 24681)
-- Name: tblreturbeli tblreturbeli_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturbeli
    ADD CONSTRAINT tblreturbeli_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3451 (class 2606 OID 18260)
-- Name: tblreturjual tblreturjual_kasbiayalain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturjual
    ADD CONSTRAINT tblreturjual_kasbiayalain_fkey FOREIGN KEY (kasbiayalain) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3450 (class 2606 OID 18255)
-- Name: tblreturjual tblreturjual_kasdiskon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturjual
    ADD CONSTRAINT tblreturjual_kasdiskon_fkey FOREIGN KEY (kasdiskon) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3453 (class 2606 OID 18270)
-- Name: tblreturjual tblreturjual_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturjual
    ADD CONSTRAINT tblreturjual_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3456 (class 2606 OID 18285)
-- Name: tblreturjual tblreturjual_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturjual
    ADD CONSTRAINT tblreturjual_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3455 (class 2606 OID 18280)
-- Name: tblreturjual tblreturjual_kodejual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturjual
    ADD CONSTRAINT tblreturjual_kodejual_fkey FOREIGN KEY (kodejual) REFERENCES public.tbljual(kodejual) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3454 (class 2606 OID 18275)
-- Name: tblreturjual tblreturjual_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturjual
    ADD CONSTRAINT tblreturjual_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3452 (class 2606 OID 18265)
-- Name: tblreturjual tblreturjual_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblreturjual
    ADD CONSTRAINT tblreturjual_pelanggan_fkey FOREIGN KEY (pelanggan) REFERENCES public.tblkontak(idpelanggan) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3553 (class 2606 OID 27384)
-- Name: tblstok tblstok_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstok
    ADD CONSTRAINT tblstok_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3554 (class 2606 OID 27389)
-- Name: tblstok tblstok_kodeakun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstok
    ADD CONSTRAINT tblstok_kodeakun_fkey FOREIGN KEY (kodeakun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3555 (class 2606 OID 27394)
-- Name: tblstok tblstok_kodeakun_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstok
    ADD CONSTRAINT tblstok_kodeakun_fkey1 FOREIGN KEY (kodeakun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3556 (class 2606 OID 27399)
-- Name: tblstok tblstok_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstok
    ADD CONSTRAINT tblstok_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3557 (class 2606 OID 27404)
-- Name: tblstok tblstok_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstok
    ADD CONSTRAINT tblstok_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3460 (class 2606 OID 18328)
-- Name: tblstokgudang tblstokgudang_idgudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstokgudang
    ADD CONSTRAINT tblstokgudang_idgudang_fkey FOREIGN KEY (idgudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3461 (class 2606 OID 21030)
-- Name: tblstokgudang tblstokgudang_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstokgudang
    ADD CONSTRAINT tblstokgudang_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3482 (class 2606 OID 27366)
-- Name: tblstokopname tblstokopname_idharga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstokopname
    ADD CONSTRAINT tblstokopname_idharga_fkey FOREIGN KEY (idharga) REFERENCES public.tblharga(idharga) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3480 (class 2606 OID 18607)
-- Name: tblstokopname tblstokopname_kodeakun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstokopname
    ADD CONSTRAINT tblstokopname_kodeakun_fkey FOREIGN KEY (kodeakun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3481 (class 2606 OID 27361)
-- Name: tblstokopname tblstokopname_kodeakun_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstokopname
    ADD CONSTRAINT tblstokopname_kodeakun_fkey1 FOREIGN KEY (kodeakun) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3483 (class 2606 OID 27371)
-- Name: tblstokopname tblstokopname_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstokopname
    ADD CONSTRAINT tblstokopname_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3479 (class 2606 OID 18582)
-- Name: tblstokopname tblstokopname_kodegudang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblstokopname
    ADD CONSTRAINT tblstokopname_kodegudang_fkey FOREIGN KEY (kodegudang) REFERENCES public.tblgudang(idgudang) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3403 (class 2606 OID 17921)
-- Name: tblsubklasifikasi tblsubklasifikasi_idklasifikasi_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tblsubklasifikasi
    ADD CONSTRAINT tblsubklasifikasi_idklasifikasi_fkey FOREIGN KEY (idklasifikasi) REFERENCES public.tblklasifikasi(idklasifikasi) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3549 (class 2606 OID 26891)
-- Name: tbltransaksi tbltransaksi_akunasal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbltransaksi
    ADD CONSTRAINT tbltransaksi_akunasal_fkey FOREIGN KEY (akunasal) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3550 (class 2606 OID 26896)
-- Name: tbltransaksi tbltransaksi_akuntujuan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbltransaksi
    ADD CONSTRAINT tbltransaksi_akuntujuan_fkey FOREIGN KEY (akuntujuan) REFERENCES public.tblakun(kodeakun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3551 (class 2606 OID 26901)
-- Name: tbltransaksi tbltransaksi_kodedepartemen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbltransaksi
    ADD CONSTRAINT tbltransaksi_kodedepartemen_fkey FOREIGN KEY (kodedepartemen) REFERENCES public.tbldepartemen(iddepartemen) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3552 (class 2606 OID 26906)
-- Name: tbltransaksi tbltransaksi_kodeprojek_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbltransaksi
    ADD CONSTRAINT tbltransaksi_kodeprojek_fkey FOREIGN KEY (kodeprojek) REFERENCES public.tblprojek(idprojek) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2021-08-24 11:09:35

--
-- PostgreSQL database dump complete
--

