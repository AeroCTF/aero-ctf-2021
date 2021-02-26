-----------  CREATE help_msg -----------
CREATE TABLE public.help_msg (
    id serial NOT NULL,
    sha text NULL,
    name text NULL,
    msg text NULL,
    creat_date timestamp NOT NULL DEFAULT now(),
    status int2 NULL DEFAULT 0,
    CONSTRAINT help_msg_pkey PRIMARY KEY (id)
);