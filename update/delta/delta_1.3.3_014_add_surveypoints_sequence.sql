CREATE SEQUENCE qwat_od.surveypoint_id_seq;
ALTER TABLE qwat_od.surveypoint ALTER COLUMN id SET DEFAULT nextval('qwat_od.surveypoint_id_seq'::regclass);
