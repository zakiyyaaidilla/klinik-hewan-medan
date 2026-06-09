--
-- PostgreSQL database dump
--

\restrict UukoGAifzplzGvGUyOgcGVVaFknKb10nYe9ccdX40oI0927RFBI3uZmXywv6Rqb

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

-- Started on 2026-06-09 18:02:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 65540)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 5855 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 40962)
-- Name: fasilitas_klinik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fasilitas_klinik (
    id integer NOT NULL,
    klinik_id integer,
    fasilitas character varying(100)
);


ALTER TABLE public.fasilitas_klinik OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 40961)
-- Name: fasilitas_klinik_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fasilitas_klinik_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fasilitas_klinik_id_seq OWNER TO postgres;

--
-- TOC entry 5856 (class 0 OID 0)
-- Dependencies: 221
-- Name: fasilitas_klinik_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fasilitas_klinik_id_seq OWNED BY public.fasilitas_klinik.id;


--
-- TOC entry 224 (class 1259 OID 49154)
-- Name: klinik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klinik (
    id integer NOT NULL,
    nama character varying(100),
    alamat text,
    latitude numeric(10,8),
    longitude numeric(11,8),
    rating numeric(2,1),
    jam_operasional character varying(100),
    no_tlp character varying(20),
    harga character varying(50),
    status character varying(20),
    geom public.geometry(Point,4326),
    CONSTRAINT chk_latitude CHECK (((latitude >= ('-90'::integer)::numeric) AND (latitude <= (90)::numeric))),
    CONSTRAINT chk_longitude CHECK (((longitude >= ('-180'::integer)::numeric) AND (longitude <= (180)::numeric))),
    CONSTRAINT enforce_srid_geom CHECK ((public.st_srid(geom) = 4326))
);


ALTER TABLE public.klinik OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24578)
-- Name: klinik_hewan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klinik_hewan (
    id integer NOT NULL,
    nama_klinik character varying(150) NOT NULL,
    alamat text NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    no_telepon character varying(20),
    rating numeric(2,1),
    fasilitas text[],
    akses_jalan character varying(50),
    jam_operasional character varying(100),
    status_aktif boolean DEFAULT true,
    foto_url character varying(255),
    kecamatan character varying(100),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT klinik_hewan_akses_jalan_check CHECK (((akses_jalan)::text = ANY ((ARRAY['Mudah'::character varying, 'Sedang'::character varying, 'Sulit'::character varying])::text[]))),
    CONSTRAINT klinik_hewan_rating_check CHECK (((rating >= (1)::numeric) AND (rating <= (5)::numeric)))
);


ALTER TABLE public.klinik_hewan OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24577)
-- Name: klinik_hewan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.klinik_hewan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.klinik_hewan_id_seq OWNER TO postgres;

--
-- TOC entry 5857 (class 0 OID 0)
-- Dependencies: 218
-- Name: klinik_hewan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.klinik_hewan_id_seq OWNED BY public.klinik_hewan.id;


--
-- TOC entry 223 (class 1259 OID 49153)
-- Name: klinik_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.klinik_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.klinik_id_seq OWNER TO postgres;

--
-- TOC entry 5858 (class 0 OID 0)
-- Dependencies: 223
-- Name: klinik_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.klinik_id_seq OWNED BY public.klinik.id;


--
-- TOC entry 229 (class 1259 OID 57383)
-- Name: klinik_terbaik; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.klinik_terbaik AS
 SELECT id,
    nama,
    alamat,
    rating,
    harga
   FROM public.klinik
  WHERE (rating >= 4.0)
  ORDER BY rating DESC;


ALTER VIEW public.klinik_terbaik OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 57357)
-- Name: schools; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schools (
    id integer NOT NULL,
    nama_sekolah character varying(255) NOT NULL,
    npsn character varying(20),
    jenjang character varying(10),
    status character varying(10),
    akreditasi character varying(5),
    kurikulum character varying(20),
    jam_operasional character varying(10),
    kecamatan character varying(100),
    alamat text,
    jumlah_siswa integer,
    jumlah_guru integer,
    spp integer,
    no_telepon character varying(20),
    website character varying(255),
    has_lab_komputer boolean DEFAULT false,
    has_lab_ipa boolean DEFAULT false,
    has_perpustakaan boolean DEFAULT false,
    has_lapangan boolean DEFAULT false,
    has_musholla boolean DEFAULT false,
    has_kantin boolean DEFAULT false,
    ekskul text[],
    foto_url text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT schools_akreditasi_check CHECK (((akreditasi)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying, 'Belum'::character varying])::text[]))),
    CONSTRAINT schools_jam_operasional_check CHECK (((jam_operasional)::text = ANY ((ARRAY['Pagi'::character varying, 'Siang'::character varying, 'Fullday'::character varying])::text[]))),
    CONSTRAINT schools_jenjang_check CHECK (((jenjang)::text = ANY ((ARRAY['SD'::character varying, 'SMP'::character varying, 'SMA'::character varying, 'SMK'::character varying])::text[]))),
    CONSTRAINT schools_kurikulum_check CHECK (((kurikulum)::text = ANY ((ARRAY['Merdeka'::character varying, 'K-13'::character varying])::text[]))),
    CONSTRAINT schools_status_check CHECK (((status)::text = ANY ((ARRAY['Negeri'::character varying, 'Swasta'::character varying])::text[])))
);


ALTER TABLE public.schools OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 57356)
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.schools_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schools_id_seq OWNER TO postgres;

--
-- TOC entry 5859 (class 0 OID 0)
-- Dependencies: 227
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.schools_id_seq OWNED BY public.schools.id;


--
-- TOC entry 226 (class 1259 OID 57347)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 57346)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5860 (class 0 OID 0)
-- Dependencies: 225
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 220 (class 1259 OID 24593)
-- Name: v_klinik_lengkap; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_klinik_lengkap AS
 SELECT id,
    nama_klinik,
    alamat,
    kecamatan,
    latitude,
    longitude,
    no_telepon,
    rating,
    array_to_string(fasilitas, ', '::text) AS fasilitas_text,
    fasilitas,
    akses_jalan,
    jam_operasional,
    status_aktif,
    foto_url,
    created_at
   FROM public.klinik_hewan
  WHERE (status_aktif = true)
  ORDER BY rating DESC;


ALTER VIEW public.v_klinik_lengkap OWNER TO postgres;

--
-- TOC entry 5640 (class 2604 OID 40965)
-- Name: fasilitas_klinik id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fasilitas_klinik ALTER COLUMN id SET DEFAULT nextval('public.fasilitas_klinik_id_seq'::regclass);


--
-- TOC entry 5641 (class 2604 OID 49157)
-- Name: klinik id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klinik ALTER COLUMN id SET DEFAULT nextval('public.klinik_id_seq'::regclass);


--
-- TOC entry 5636 (class 2604 OID 24581)
-- Name: klinik_hewan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klinik_hewan ALTER COLUMN id SET DEFAULT nextval('public.klinik_hewan_id_seq'::regclass);


--
-- TOC entry 5644 (class 2604 OID 57360)
-- Name: schools id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schools ALTER COLUMN id SET DEFAULT nextval('public.schools_id_seq'::regclass);


--
-- TOC entry 5642 (class 2604 OID 57350)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5843 (class 0 OID 40962)
-- Dependencies: 222
-- Data for Name: fasilitas_klinik; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fasilitas_klinik (id, klinik_id, fasilitas) FROM stdin;
1	1	Rawat Inap
2	1	Operasi
3	1	Lab
4	1	Grooming
5	1	Vaksinasi
6	1	Apotek
7	2	Vaksinasi
8	2	Konsultasi
9	2	Grooming
10	2	Apotek
11	3	Rawat Inap
12	3	Operasi
13	3	Lab
14	3	Grooming
15	3	Vaksinasi
16	3	USG
17	3	Apotek
18	3	Emergency 24 Jam
19	4	Vaksinasi
20	4	Konsultasi
21	4	Apotek
22	5	Rawat Inap
23	5	Operasi
24	5	Vaksinasi
25	5	Lab
26	5	Grooming
27	5	Apotek
28	6	Vaksinasi
29	6	Konsultasi
30	6	Grooming
31	7	Rawat Inap
32	7	Operasi
33	7	Lab
34	7	Grooming
35	7	Vaksinasi
36	7	USG
37	7	Apotek
38	7	Emergency 24 Jam
39	7	ICU Hewan
40	8	Vaksinasi
41	8	Konsultasi
42	8	Apotek
43	8	Grooming
\.


--
-- TOC entry 5845 (class 0 OID 49154)
-- Dependencies: 224
-- Data for Name: klinik; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.klinik (id, nama, alamat, latitude, longitude, rating, jam_operasional, no_tlp, harga, status, geom) FROM stdin;
2	Happy Vet	Jl. Setia Budi	3.56780000	98.65430000	4.7	09:00-22:00	0813	Tinggi	Buka	0101000020E610000076711B0DE0A95840B459F5B9DA8A0C40
3	Animal Care	Jl. Asia	3.58010000	98.70020000	4.2	09:00-21:00	0814	Murah	Buka	0101000020E6100000302AA913D0AC5840DC4603780BA40C40
4	Vet Medika	Jl. Krakatau	3.60030000	98.71040000	4.6	08:00-22:00	0815	Tinggi	Buka	0101000020E610000005C58F3177AD5840764F1E166ACD0C40
5	Pet House	Jl. Thamrin	3.59020000	98.72050000	4.1	08:00-20:00	0816	Murah	Buka	0101000020E6100000273108AC1CAE584029CB10C7BAB80C40
6	Sehat Pet	Jl. Denai	3.61010000	98.73020000	4.0	09:00-21:00	0817	Sedang	Buka	0101000020E610000082E2C798BBAE58401A51DA1B7CE10C40
7	Care Center	Jl. Amplas	3.62050000	98.74010000	4.4	08:00-22:00	0818	Tinggi	Buka	0101000020E610000041F163CC5DAF5840105839B4C8F60C40
8	Vet Plus	Jl. Marelan	3.63010000	98.75020000	4.3	08:00-21:00	0819	Sedang	Buka	0101000020E6100000645DDC4603B0584043AD69DE710A0D40
9	Pet Medan	Jl. Cemara	3.64020000	98.76030000	4.5	09:00-22:00	0820	Tinggi	Buka	0101000020E610000086C954C1A8B058409031772D211F0D40
10	Sahabat Satwa	Jl. Ringroad	3.58900000	98.69010000	4.3	08:00-20:00	0821	Murah	Buka	0101000020E61000000EBE30992AAC584083C0CAA145B60C40
1	Klinik Hewan Medan Pet Care	Jl. Gatot Subroto	3.59520000	98.67220000	4.8	08:00-21:00	0812	Sedang	Buka	0101000020E6100000C217265305AB584034A2B437F8C20C40
39	Praktek Dokter Hewan Medvet Animal Clinic	Jl. Arteri Ring Road No.19, Tj. Sari, Medan Selayang	3.56140000	98.62600000	5.0	08:00-21:00	081234567899	Sedang	Buka	0101000020E6100000F2D24D6210A8584092CB7F48BF7D0C40
40	Praktek Dokter Hewan Medvet Animal Clinic	Jl. Arteri Ring Road No.19, Tj. Sari, Medan Selayang	3.56140000	98.62600000	5.0	08:00-21:00	081234567899	Sedang	Buka	0101000020E6100000F2D24D6210A8584092CB7F48BF7D0C40
\.


--
-- TOC entry 5841 (class 0 OID 24578)
-- Dependencies: 219
-- Data for Name: klinik_hewan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.klinik_hewan (id, nama_klinik, alamat, latitude, longitude, no_telepon, rating, fasilitas, akses_jalan, jam_operasional, status_aktif, foto_url, kecamatan, created_at, updated_at) FROM stdin;
1	Klinik Hewan Medan Veteriner	Jl. Imam Bonjol No. 15, Medan Barat	3.5895	98.6731	061-4512345	4.5	{"Rawat Inap",Operasi,Lab,Grooming,Vaksinasi,Apotek}	Mudah	Senin-Sabtu: 08.00-20.00 | Minggu: 09.00-15.00	t	\N	Medan Barat	2026-04-22 10:45:01.237548	2026-04-22 10:45:01.237548
2	Klinik Dr. Hewan Sejahtera	Jl. Gatot Subroto No. 88, Medan Sunggal	3.5712	98.6543	061-8821000	4.2	{Vaksinasi,Konsultasi,Grooming,Apotek}	Mudah	Senin-Jumat: 09.00-18.00 | Sabtu: 09.00-14.00	t	\N	Medan Sunggal	2026-04-22 10:45:01.237548	2026-04-22 10:45:01.237548
3	Animal Care Clinic Medan	Jl. S. Parman No. 234, Medan Petisah	3.5962	98.6618	061-4521789	4.7	{"Rawat Inap",Operasi,Lab,Grooming,Vaksinasi,USG,Apotek,"Emergency 24 Jam"}	Mudah	Senin-Minggu: 24 Jam (Emergency)	t	\N	Medan Petisah	2026-04-22 10:45:01.237548	2026-04-22 10:45:01.237548
4	Klinik Hewan Peliharaan Bahagia	Jl. Brigjend Katamso No. 101, Medan Kota	3.5831	98.689	061-7741234	3.8	{Vaksinasi,Konsultasi,Apotek}	Sedang	Senin-Sabtu: 08.00-17.00	t	\N	Medan Kota	2026-04-22 10:45:01.237548	2026-04-22 10:45:01.237548
5	Pet Health Center Medan	Jl. Dr. Mansur No. 55, Medan Selayang	3.6105	98.6742	061-8123456	4.3	{"Rawat Inap",Operasi,Vaksinasi,Lab,Grooming,Apotek}	Mudah	Senin-Sabtu: 08.00-20.00	t	\N	Medan Selayang	2026-04-22 10:45:01.237548	2026-04-22 10:45:01.237548
6	Klinik Veteriner Tulus	Jl. Kapten Muslim No. 77, Medan Helvetia	3.6234	98.6521	061-8887654	3.5	{Vaksinasi,Konsultasi,Grooming}	Sedang	Senin-Jumat: 08.00-16.00	t	\N	Medan Helvetia	2026-04-22 10:45:01.237548	2026-04-22 10:45:01.237548
7	Rumah Sakit Hewan Medan	Jl. Jend. Besar A.H. Nasution No. 1, Medan Johor	3.5634	98.7012	061-7812000	4.8	{"Rawat Inap",Operasi,Lab,Grooming,Vaksinasi,USG,Apotek,"Emergency 24 Jam","ICU Hewan"}	Mudah	Senin-Minggu: 24 Jam	t	\N	Medan Johor	2026-04-22 10:45:01.237548	2026-04-22 10:45:01.237548
8	Klinik Hewan Asih	Jl. Pelajar No. 33, Medan Area	3.5789	98.7134	061-7712345	3.9	{Vaksinasi,Konsultasi,Apotek,Grooming}	Sulit	Senin-Sabtu: 09.00-17.00	t	\N	Medan Area	2026-04-22 10:45:01.237548	2026-04-22 10:45:01.237548
\.


--
-- TOC entry 5849 (class 0 OID 57357)
-- Dependencies: 228
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schools (id, nama_sekolah, npsn, jenjang, status, akreditasi, kurikulum, jam_operasional, kecamatan, alamat, jumlah_siswa, jumlah_guru, spp, no_telepon, website, has_lab_komputer, has_lab_ipa, has_perpustakaan, has_lapangan, has_musholla, has_kantin, ekskul, foto_url, created_at) FROM stdin;
\.


--
-- TOC entry 5635 (class 0 OID 65859)
-- Dependencies: 231
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 5847 (class 0 OID 57347)
-- Dependencies: 226
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, created_at) FROM stdin;
\.


--
-- TOC entry 5861 (class 0 OID 0)
-- Dependencies: 221
-- Name: fasilitas_klinik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fasilitas_klinik_id_seq', 43, true);


--
-- TOC entry 5862 (class 0 OID 0)
-- Dependencies: 218
-- Name: klinik_hewan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.klinik_hewan_id_seq', 8, true);


--
-- TOC entry 5863 (class 0 OID 0)
-- Dependencies: 223
-- Name: klinik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.klinik_id_seq', 40, true);


--
-- TOC entry 5864 (class 0 OID 0)
-- Dependencies: 227
-- Name: schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.schools_id_seq', 1, false);


--
-- TOC entry 5865 (class 0 OID 0)
-- Dependencies: 225
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 5668 (class 2606 OID 40967)
-- Name: fasilitas_klinik fasilitas_klinik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fasilitas_klinik
    ADD CONSTRAINT fasilitas_klinik_pkey PRIMARY KEY (id);


--
-- TOC entry 5666 (class 2606 OID 24590)
-- Name: klinik_hewan klinik_hewan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klinik_hewan
    ADD CONSTRAINT klinik_hewan_pkey PRIMARY KEY (id);


--
-- TOC entry 5676 (class 2606 OID 49161)
-- Name: klinik klinik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klinik
    ADD CONSTRAINT klinik_pkey PRIMARY KEY (id);


--
-- TOC entry 5682 (class 2606 OID 57378)
-- Name: schools schools_npsn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_npsn_key UNIQUE (npsn);


--
-- TOC entry 5684 (class 2606 OID 57376)
-- Name: schools schools_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- TOC entry 5678 (class 2606 OID 57353)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5680 (class 2606 OID 57355)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 5663 (class 1259 OID 24592)
-- Name: idx_klinik_aktif; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_klinik_aktif ON public.klinik_hewan USING btree (status_aktif);


--
-- TOC entry 5664 (class 1259 OID 24591)
-- Name: idx_klinik_coords; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_klinik_coords ON public.klinik_hewan USING btree (latitude, longitude);


--
-- TOC entry 5669 (class 1259 OID 66628)
-- Name: idx_klinik_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_klinik_geom ON public.klinik USING gist (geom);


--
-- TOC entry 5670 (class 1259 OID 57380)
-- Name: idx_klinik_lat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_klinik_lat ON public.klinik USING btree (latitude);


--
-- TOC entry 5671 (class 1259 OID 65538)
-- Name: idx_klinik_latitude; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_klinik_latitude ON public.klinik USING btree (latitude);


--
-- TOC entry 5672 (class 1259 OID 57381)
-- Name: idx_klinik_lon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_klinik_lon ON public.klinik USING btree (longitude);


--
-- TOC entry 5673 (class 1259 OID 65539)
-- Name: idx_klinik_longitude; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_klinik_longitude ON public.klinik USING btree (longitude);


--
-- TOC entry 5674 (class 1259 OID 57382)
-- Name: idx_klinik_rating; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_klinik_rating ON public.klinik USING btree (rating);


--
-- TOC entry 5687 (class 2606 OID 40968)
-- Name: fasilitas_klinik fasilitas_klinik_klinik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fasilitas_klinik
    ADD CONSTRAINT fasilitas_klinik_klinik_id_fkey FOREIGN KEY (klinik_id) REFERENCES public.klinik_hewan(id);


-- Completed on 2026-06-09 18:02:35

--
-- PostgreSQL database dump complete
--

\unrestrict UukoGAifzplzGvGUyOgcGVVaFknKb10nYe9ccdX40oI0927RFBI3uZmXywv6Rqb

