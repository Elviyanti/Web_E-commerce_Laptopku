PGDMP  7    6                |            Laptopku    17.2    17.2 Q    R           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            S           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            T           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            U           1262    16387    Laptopku    DATABASE     �   CREATE DATABASE "Laptopku" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Indonesian_Indonesia.1252';
    DROP DATABASE "Laptopku";
                     postgres    false                        2615    24687    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                     postgres    false            V           0    0    SCHEMA public    COMMENT         COMMENT ON SCHEMA public IS '';
                        postgres    false    5            W           0    0    SCHEMA public    ACL     +   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
                        postgres    false    5            �            1255    25006    insert_status_orders()    FUNCTION     �   CREATE FUNCTION public.insert_status_orders() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Status_Orders (id_order, status_delivery, order_date)
    VALUES (NEW.id_order, 'packaged', NOW());
    RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.insert_status_orders();
       public               postgres    false    5            �            1255    24873    update_timestamp()    FUNCTION     �   CREATE FUNCTION public.update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;  -- Set updated_at ke waktu saat ini
    RETURN NEW;  -- Kembalikan baris yang diperbarui
END;
$$;
 )   DROP FUNCTION public.update_timestamp();
       public               postgres    false    5            �            1259    24932    cart    TABLE     �   CREATE TABLE public.cart (
    id_cart integer NOT NULL,
    id_user integer NOT NULL,
    id_product integer NOT NULL,
    quantity integer NOT NULL
);
    DROP TABLE public.cart;
       public         heap r       postgres    false    5            �            1259    24931    cart_id_cart_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_id_cart_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.cart_id_cart_seq;
       public               postgres    false    228    5            X           0    0    cart_id_cart_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.cart_id_cart_seq OWNED BY public.cart.id_cart;
          public               postgres    false    227            �            1259    24887 
   in_product    TABLE     �   CREATE TABLE public.in_product (
    id_in integer NOT NULL,
    id_product integer NOT NULL,
    in_date date NOT NULL,
    quantity integer NOT NULL
);
    DROP TABLE public.in_product;
       public         heap r       postgres    false    5            �            1259    24886    in_product_id_in_seq    SEQUENCE     �   CREATE SEQUENCE public.in_product_id_in_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.in_product_id_in_seq;
       public               postgres    false    222    5            Y           0    0    in_product_id_in_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.in_product_id_in_seq OWNED BY public.in_product.id_in;
          public               postgres    false    221            �            1259    24949    orders    TABLE     3  CREATE TABLE public.orders (
    id_order integer NOT NULL,
    id_user integer NOT NULL,
    id_product integer NOT NULL,
    id_out integer,
    recipent_name character varying(255) NOT NULL,
    product_price numeric(10,2) NOT NULL,
    total_price numeric(10,2) NOT NULL,
    shipping_type character varying(255) NOT NULL,
    resi character varying(255),
    payment_status character varying(10),
    CONSTRAINT orders_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['paid'::character varying, 'not paid'::character varying])::text[])))
);
    DROP TABLE public.orders;
       public         heap r       postgres    false    5            �            1259    24948    orders_id_order_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_id_order_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.orders_id_order_seq;
       public               postgres    false    230    5            Z           0    0    orders_id_order_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.orders_id_order_seq OWNED BY public.orders.id_order;
          public               postgres    false    229            �            1259    24899    out_product    TABLE     �   CREATE TABLE public.out_product (
    id_out integer NOT NULL,
    id_product integer NOT NULL,
    out_date date NOT NULL,
    quantity integer NOT NULL
);
    DROP TABLE public.out_product;
       public         heap r       postgres    false    5            �            1259    24898    out_product_id_out_seq    SEQUENCE     �   CREATE SEQUENCE public.out_product_id_out_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.out_product_id_out_seq;
       public               postgres    false    224    5            [           0    0    out_product_id_out_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.out_product_id_out_seq OWNED BY public.out_product.id_out;
          public               postgres    false    223            �            1259    24876    products    TABLE     �  CREATE TABLE public.products (
    id_product integer NOT NULL,
    merk character varying(255) NOT NULL,
    variety character varying(255) NOT NULL,
    ssd_hdd character varying(10),
    processor character varying(255) NOT NULL,
    ram character varying(10) NOT NULL,
    vga character varying(255),
    screen_size numeric(5,2),
    storages character varying(255) NOT NULL,
    price numeric(10,2) NOT NULL,
    purpose character varying(255),
    feature text,
    image_path character varying(255),
    stock integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    CONSTRAINT products_ssd_hdd_check CHECK (((ssd_hdd)::text = ANY ((ARRAY['SSD'::character varying, 'HDD'::character varying])::text[])))
);
    DROP TABLE public.products;
       public         heap r       postgres    false    5            �            1259    24875    products_id_product_seq    SEQUENCE     �   CREATE SEQUENCE public.products_id_product_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.products_id_product_seq;
       public               postgres    false    5    220            \           0    0    products_id_product_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.products_id_product_seq OWNED BY public.products.id_product;
          public               postgres    false    219            �            1259    24911    review    TABLE     O  CREATE TABLE public.review (
    id_review integer NOT NULL,
    id_user integer NOT NULL,
    id_product integer NOT NULL,
    rating integer,
    review_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    review_text text NOT NULL,
    CONSTRAINT review_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);
    DROP TABLE public.review;
       public         heap r       postgres    false    5            �            1259    24910    review_id_review_seq    SEQUENCE     �   CREATE SEQUENCE public.review_id_review_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.review_id_review_seq;
       public               postgres    false    226    5            ]           0    0    review_id_review_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.review_id_review_seq OWNED BY public.review.id_review;
          public               postgres    false    225            �            1259    24863    roles    TABLE     e   CREATE TABLE public.roles (
    role_id integer NOT NULL,
    name character varying(50) NOT NULL
);
    DROP TABLE public.roles;
       public         heap r       postgres    false    5            �            1259    24974    status_orders    TABLE     �  CREATE TABLE public.status_orders (
    id_status integer NOT NULL,
    id_order integer NOT NULL,
    status_delivery character varying(10),
    order_date date NOT NULL,
    payment_date date,
    delivery_date date,
    arrived_date date,
    CONSTRAINT status_orders_status_delivery_check CHECK (((status_delivery)::text = ANY ((ARRAY['not paid'::character varying, 'packaged'::character varying, 'shipped'::character varying, 'completed'::character varying])::text[])))
);
 !   DROP TABLE public.status_orders;
       public         heap r       postgres    false    5            �            1259    24973    status_orders_id_status_seq    SEQUENCE     �   CREATE SEQUENCE public.status_orders_id_status_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.status_orders_id_status_seq;
       public               postgres    false    232    5            ^           0    0    status_orders_id_status_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.status_orders_id_status_seq OWNED BY public.status_orders.id_status;
          public               postgres    false    231            �            1259    24856    users    TABLE     [  CREATE TABLE public.users (
    id_user integer NOT NULL,
    username character varying(50),
    email character varying(100),
    password character varying(255),
    telepon character varying(100),
    alamat character varying(100),
    image_path character varying(255),
    role_id_user integer,
    updated_at timestamp without time zone
);
    DROP TABLE public.users;
       public         heap r       postgres    false    5            �            1259    25012    users_id_user_seq    SEQUENCE     �   ALTER TABLE public.users ALTER COLUMN id_user ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    217    5            �           2604    24935    cart id_cart    DEFAULT     l   ALTER TABLE ONLY public.cart ALTER COLUMN id_cart SET DEFAULT nextval('public.cart_id_cart_seq'::regclass);
 ;   ALTER TABLE public.cart ALTER COLUMN id_cart DROP DEFAULT;
       public               postgres    false    228    227    228            �           2604    24890    in_product id_in    DEFAULT     t   ALTER TABLE ONLY public.in_product ALTER COLUMN id_in SET DEFAULT nextval('public.in_product_id_in_seq'::regclass);
 ?   ALTER TABLE public.in_product ALTER COLUMN id_in DROP DEFAULT;
       public               postgres    false    222    221    222            �           2604    24952    orders id_order    DEFAULT     r   ALTER TABLE ONLY public.orders ALTER COLUMN id_order SET DEFAULT nextval('public.orders_id_order_seq'::regclass);
 >   ALTER TABLE public.orders ALTER COLUMN id_order DROP DEFAULT;
       public               postgres    false    230    229    230            �           2604    24902    out_product id_out    DEFAULT     x   ALTER TABLE ONLY public.out_product ALTER COLUMN id_out SET DEFAULT nextval('public.out_product_id_out_seq'::regclass);
 A   ALTER TABLE public.out_product ALTER COLUMN id_out DROP DEFAULT;
       public               postgres    false    223    224    224            �           2604    24879    products id_product    DEFAULT     z   ALTER TABLE ONLY public.products ALTER COLUMN id_product SET DEFAULT nextval('public.products_id_product_seq'::regclass);
 B   ALTER TABLE public.products ALTER COLUMN id_product DROP DEFAULT;
       public               postgres    false    219    220    220            �           2604    24914    review id_review    DEFAULT     t   ALTER TABLE ONLY public.review ALTER COLUMN id_review SET DEFAULT nextval('public.review_id_review_seq'::regclass);
 ?   ALTER TABLE public.review ALTER COLUMN id_review DROP DEFAULT;
       public               postgres    false    226    225    226            �           2604    24977    status_orders id_status    DEFAULT     �   ALTER TABLE ONLY public.status_orders ALTER COLUMN id_status SET DEFAULT nextval('public.status_orders_id_status_seq'::regclass);
 F   ALTER TABLE public.status_orders ALTER COLUMN id_status DROP DEFAULT;
       public               postgres    false    231    232    232            J          0    24932    cart 
   TABLE DATA           F   COPY public.cart (id_cart, id_user, id_product, quantity) FROM stdin;
    public               postgres    false    228   ,g       D          0    24887 
   in_product 
   TABLE DATA           J   COPY public.in_product (id_in, id_product, in_date, quantity) FROM stdin;
    public               postgres    false    222   Ig       L          0    24949    orders 
   TABLE DATA           �   COPY public.orders (id_order, id_user, id_product, id_out, recipent_name, product_price, total_price, shipping_type, resi, payment_status) FROM stdin;
    public               postgres    false    230   �g       F          0    24899    out_product 
   TABLE DATA           M   COPY public.out_product (id_out, id_product, out_date, quantity) FROM stdin;
    public               postgres    false    224   �h       B          0    24876    products 
   TABLE DATA           �   COPY public.products (id_product, merk, variety, ssd_hdd, processor, ram, vga, screen_size, storages, price, purpose, feature, image_path, stock, updated_at) FROM stdin;
    public               postgres    false    220   �h       H          0    24911    review 
   TABLE DATA           b   COPY public.review (id_review, id_user, id_product, rating, review_date, review_text) FROM stdin;
    public               postgres    false    226   �k       @          0    24863    roles 
   TABLE DATA           .   COPY public.roles (role_id, name) FROM stdin;
    public               postgres    false    218   �m       N          0    24974    status_orders 
   TABLE DATA           �   COPY public.status_orders (id_status, id_order, status_delivery, order_date, payment_date, delivery_date, arrived_date) FROM stdin;
    public               postgres    false    232   �m       ?          0    24856    users 
   TABLE DATA           z   COPY public.users (id_user, username, email, password, telepon, alamat, image_path, role_id_user, updated_at) FROM stdin;
    public               postgres    false    217   �n       _           0    0    cart_id_cart_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.cart_id_cart_seq', 34, true);
          public               postgres    false    227            `           0    0    in_product_id_in_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.in_product_id_in_seq', 4, true);
          public               postgres    false    221            a           0    0    orders_id_order_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.orders_id_order_seq', 62, true);
          public               postgres    false    229            b           0    0    out_product_id_out_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.out_product_id_out_seq', 6, true);
          public               postgres    false    223            c           0    0    products_id_product_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.products_id_product_seq', 10, true);
          public               postgres    false    219            d           0    0    review_id_review_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.review_id_review_seq', 20, true);
          public               postgres    false    225            e           0    0    status_orders_id_status_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.status_orders_id_status_seq', 89, true);
          public               postgres    false    231            f           0    0    users_id_user_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_id_user_seq', 16, true);
          public               postgres    false    233            �           2606    24937    cart cart_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id_cart);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public                 postgres    false    228            �           2606    24892    in_product in_product_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.in_product
    ADD CONSTRAINT in_product_pkey PRIMARY KEY (id_in);
 D   ALTER TABLE ONLY public.in_product DROP CONSTRAINT in_product_pkey;
       public                 postgres    false    222            �           2606    24957    orders orders_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id_order);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public                 postgres    false    230            �           2606    24904    out_product out_product_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.out_product
    ADD CONSTRAINT out_product_pkey PRIMARY KEY (id_out);
 F   ALTER TABLE ONLY public.out_product DROP CONSTRAINT out_product_pkey;
       public                 postgres    false    224            �           2606    24885    products products_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id_product);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public                 postgres    false    220            �           2606    24920    review review_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id_review);
 <   ALTER TABLE ONLY public.review DROP CONSTRAINT review_pkey;
       public                 postgres    false    226            �           2606    24867    roles roles_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public                 postgres    false    218            �           2606    24980     status_orders status_orders_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.status_orders
    ADD CONSTRAINT status_orders_pkey PRIMARY KEY (id_status);
 J   ALTER TABLE ONLY public.status_orders DROP CONSTRAINT status_orders_pkey;
       public                 postgres    false    232            �           2606    24862    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    217            �           2620    24987    products set_updated_at    TRIGGER     x   CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();
 0   DROP TRIGGER set_updated_at ON public.products;
       public               postgres    false    220    234            �           2620    24874    users set_updated_at    TRIGGER     u   CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();
 -   DROP TRIGGER set_updated_at ON public.users;
       public               postgres    false    234    217            �           2606    24943    cart cart_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(id_product);
 C   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_id_product_fkey;
       public               postgres    false    220    4754    228            �           2606    24938    cart cart_id_user_fkey    FK CONSTRAINT     z   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user);
 @   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_id_user_fkey;
       public               postgres    false    228    4750    217            �           2606    24993    cart fk_cart_product    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT fk_cart_product FOREIGN KEY (id_product) REFERENCES public.products(id_product);
 >   ALTER TABLE ONLY public.cart DROP CONSTRAINT fk_cart_product;
       public               postgres    false    228    4754    220            �           2606    24988    cart fk_cart_user    FK CONSTRAINT     u   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT fk_cart_user FOREIGN KEY (id_user) REFERENCES public.users(id_user);
 ;   ALTER TABLE ONLY public.cart DROP CONSTRAINT fk_cart_user;
       public               postgres    false    228    217    4750            �           2606    24868    users fk_users_roles_user    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_roles_user FOREIGN KEY (role_id_user) REFERENCES public.roles(role_id);
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_users_roles_user;
       public               postgres    false    217    4752    218            �           2606    24893 %   in_product in_product_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.in_product
    ADD CONSTRAINT in_product_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(id_product);
 O   ALTER TABLE ONLY public.in_product DROP CONSTRAINT in_product_id_product_fkey;
       public               postgres    false    222    220    4754            �           2606    24968    orders orders_id_out_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_id_out_fkey FOREIGN KEY (id_out) REFERENCES public.out_product(id_out);
 C   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_id_out_fkey;
       public               postgres    false    4758    224    230            �           2606    24963    orders orders_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(id_product);
 G   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_id_product_fkey;
       public               postgres    false    230    220    4754            �           2606    24958    orders orders_id_user_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user);
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_id_user_fkey;
       public               postgres    false    230    217    4750            �           2606    24905 '   out_product out_product_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.out_product
    ADD CONSTRAINT out_product_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(id_product);
 Q   ALTER TABLE ONLY public.out_product DROP CONSTRAINT out_product_id_product_fkey;
       public               postgres    false    220    224    4754            �           2606    24926    review review_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(id_product);
 G   ALTER TABLE ONLY public.review DROP CONSTRAINT review_id_product_fkey;
       public               postgres    false    226    220    4754            �           2606    24921    review review_id_user_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user);
 D   ALTER TABLE ONLY public.review DROP CONSTRAINT review_id_user_fkey;
       public               postgres    false    217    226    4750            �           2606    24981 )   status_orders status_orders_id_order_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.status_orders
    ADD CONSTRAINT status_orders_id_order_fkey FOREIGN KEY (id_order) REFERENCES public.orders(id_order);
 S   ALTER TABLE ONLY public.status_orders DROP CONSTRAINT status_orders_id_order_fkey;
       public               postgres    false    232    4764    230            J      x������ � �      D   /   x�3�4�4202�54�52�4�2�4B0�2FWa�i�,`����� ��J      L      x���;O�0 �9���g��钡c%d�J-�2���5���F��/��فF�{�k^�c~Já�N]��R�U��|�9ŏ�/��SjK����k�bWh��g����w�	tu8 �@]#�K�BME�~^��<UE��lY�Z#jO.�1�75'I[���~�h�L���8�N�P�Q�R�e��t#O8�i'N�)9���3��8O�	2��Eg��Ա{Os�z�se�~¦c��kyЀRS�4f�2��G?<�����@�%O?���t��)��gi�K����m�o����      F   3   x�]ȱ  �:�O�ø����;�Js�E�p��ݣpz,��$��      B   �  x����r�0ƯOq�2$��z����H�)�M��#a��>��V[i�\0� �_��;�@X�%���H��xӼ���(�@���~L��'�A�c���ĳ|B��wګ��.+�֦ ,�"G��(E��0����Y����?��)�}�Z�A5_�E�q�:Ի!�H�!�N�܀|�aQHKZ�P薼�ň�� 5��4�xj�ٮ�o�B]��d+�J�g���>����|j;�8��3��5�$K9�g�ڢ9�פ�,�����B�`��O�^�;�/XR�pk�ł��{�']��;d�]���`0�,
ab�ò̇Ǳ�2����������#��rƊJnD��Ɔ�fJ�����AzdHomϣ}�Y.������]b�!%N�(q�ߺN�\�����x�fSQ�{Xh��׵�]������qsvR��I��D�o�{!"q��������aZ�>7�o�|��\T�x�9KqI����?�ߥ��L/�Fu)r^�0�u��ќ}ھ��&�(���!p������z�.�D�f�����E�D)�<�mpn!�V��T�z���N���wz�t�?�sة:ٖ��<?g��`�m�D�پ��z�$�}�v�͵��]�	���k��o���9��[��P�l˲�vt�      H     x����n�0D��W��X%?�l�K�e7Wm_�z���;�l�E[&� BZptf�j��fE^,�X�R���b󨖙ʷ*�;Q{�A����5�[�k��\C��G�=q۞i.
h�eJ�+�C��3DeEldh�`�h�;�>��Ÿd��\��{	dy [�֓�� ;�ph�b�ʔ�S0��Dr��,+�$���(��3��4I�/�\u�jr��kg���M&�[�ͽ^�>P�ɝ� G�o �����w�� V�%b��ڇ�GLKMEC&�ۦ�=�aOp�!�X�[#n����v���ojBMGYsE�$� -�%*����Р�1���Ѕ�QC!q��xaz�=��i�w��=��_�=]����ia��nز�P%&W��JL���X�A6�g�6a����:��r��+�~u�U`�����PZ�I�����?]%��h�B��v_������!�������TiK'r�؍��\�uG��Wc>n����׻��oC���Ɠc'��	!~��z      @       x�3�t.-.��M-�2�tL�������� Y�m      N   �   x���Kn�0����@
�")�=A6F�A?��5�E�P3����Či{�&��_��|;�B��!�AǗ�Y�QVf%�Q������ ��;4��|_oOm�<�2=�y0�tQW�<&5AGY{����=�R�N�B+!{�A�CWB*,0�n]a��H0�ndi7Fڍ#������A�(�g�nh�$V��~i��p#/��~��0�Q�d;"���Cz��G����,�/V'�      ?   .  x�}�Y��L�k�^�mE��W#��(�I:%����,���{���y�P�R�|l��|ֿ���Gh+��_\���B���\(X1Z"��0ӭE����E�*V�0	&jWZ5��8Gj���+�(�Q}������!],Ÿ>ޑs��ю�(���7���`�Ѣ� k���8�n�T�+�ET�y�t��Z���� �Q�'1܃=��e��k��8Q����_���rH�c��rw�5�5�k�,�
�̢���Z�c�t�_A��LmƩ���0>Ȝ���S��m�~��T�>��Y��<W6���*h�6n=�wi�ZQ�Kjy$�xjn>6q����1.�`5L
�Q���E����ꄚ�g�8��r�!t̥�+ư��������v19TJ��,3h'�� ��@Y�=�������v�0��:y-���٬i&���	
�>���XHX7��l�2ڌ���;���#���v�3���
�yX)�-o�G�	�կ��a�t�5ma��b9ZtH�A�� �˹��Gz���n�N��U�Yq��*ީU���2 �$�����ΐ�s�*�̅����Ҋ��h9��IBګ���ݎ���kP%�EGY���#U�m)�o��mR�;��C[%��QM��nXv� ���+k��3��nj�l���q/5���Yc�g<�����lk�w�0U�㉐G�TY�0ݑ s=�T^�h.eJQ;�;���|��6{m?nY+��ʚ���٧#+꠭2ҹ��5�C"h	��4�v��\i;޵�*+�[o���[@�P��j:����x��6�:��1ju�St��ۓ�"n�Ö1��}��^"�V�jw0��i���֊����4�Bl�m�}����1��j�,@��9X|���(�,W�e_9��7{{L��;��#�-�6z����p�A� �	
`���"���J���`�E�頦���9�co1K}�ܞ	�>>�8���$��k��娤�;�{�|���}앻5x>3���@�yV���O|��\�NFS���Ś2��,�4o�����[\��� ]^r��c�?~2.B/v/���(7�r@Qd�੶���X&.E��g�q=z�b}*&�0Tqq���^k�T��z,�Po��92��
����j� ��L���R6ѭO�SR��U���7�}�U����R�w���1��f�-u4k�wّ-�d����������J����"}~k ��j�}K�,R��v��s� A��/f�|���,� ��D�	��c�<�^�����Dm/F�!�R,���(��5������j��mڒ     