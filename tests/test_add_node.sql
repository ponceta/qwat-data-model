-- add a distributor
INSERT INTO qwat_od.distributor (id, name) VALUES (1, 'Demo Distributor');

-- add a district
INSERT INTO qwat_od.district (id, name) VALUES (1, 'My district');

-- add a consumption zone
INSERT INTO qwat_od.consumptionzone(id, name) VALUES (1, 'A consumption zone');

-- add a pressure zone
INSERT INTO qwat_od.pressurezone (id, name, fk_distributor, fk_consumptionzone) VALUES (1, 'A pressure zone', 1, 1);

-- add a pipe between two nodes (1 and 2)
INSERT INTO qwat_od.pipe (id, fk_node_a, fk_node_b,
       fk_function, fk_installmethod, fk_material, fk_distributor, fk_precision, fk_bedding,
       fk_status, fk_watertype,
       geometry) VALUES (1, 1, 2,
       101, 101, 101, 1, 101, 101, 101, 101,
       st_setsrid('linestring(530000 138260 0,530050 138270 0)'::geometry, 21781));

INSERT INTO qwat_od.vw_element_valve (id, fk_district, fk_pressurezone, fk_distributor, fk_pipe,
       fk_precision, fk_precisionalti, fk_status, fk_valve_type, fk_valve_function, fk_valve_actuation,
       geometry)
       VALUES (3, 1, 1, 1, 1,
       101, 101, 101, 101, 6108, 101,
       st_setsrid('point(530025 138265 0)'::geometry,21781));

-- Now we have 3 vertices on the pipe
SELECT 'num_points_after_add1', st_numpoints(geometry) FROM qwat_od.pipe WHERE id = 1;

INSERT INTO qwat_od.vw_element_valve (id, fk_district, fk_pressurezone, fk_distributor, fk_pipe,
       fk_precision, fk_precisionalti, fk_status, fk_valve_type, fk_valve_function, fk_valve_actuation,
       geometry)
       VALUES (4, 1, 1, 1, 1,
       101, 101, 101, 101, 6108, 101,
       st_setsrid('point(530040 1382608 0)'::geometry,21781));

-- Now we have 4 vertices on the pipe
SELECT 'num_points_after_add2', st_numpoints(geometry) FROM qwat_od.pipe WHERE id = 1;

-- What if the intersection test fails but the node is close enough to the pipe ?
INSERT INTO qwat_od.vw_element_valve (id, fk_district, fk_pressurezone, fk_distributor, fk_pipe,
       fk_precision, fk_precisionalti, fk_status, fk_valve_type, fk_valve_function, fk_valve_actuation,
       geometry)
       VALUES (5, 1, 1, 1, 1,
       101, 101, 101, 101, 6108, 101,
       st_setsrid('point(530025.2 138265.04 0)'::geometry,21781));

-- Another point added
SELECT 'num_points_after_add3', st_numpoints(geometry) FROM qwat_od.pipe WHERE id = 1;

-- insert two pipes with the second one starting very close to the end of the first (1e-8)
-- this should not result in a recursive trigger call
SELECT 'new pipe close to the previous';
INSERT INTO qwat_od.pipe (id,
       fk_function, fk_installmethod, fk_material, fk_distributor, fk_precision, fk_bedding, fk_status, fk_watertype,
       geometry) VALUES
       (14428,
       101, 101, 101, 1, 101, 101, 101, 101,
       ST_GeomFromText('LINESTRING(540899.7448098600 152955.6844859300, 540900.2686702100 152955.4115092600)',21781)
);

INSERT INTO qwat_od.pipe (id,
       fk_function, fk_installmethod, fk_material, fk_distributor, fk_precision, fk_bedding, fk_status, fk_watertype,
       geometry) VALUES
       (14296,
       101, 101, 101, 1, 101, 101, 101, 101,
       ST_GeomFromText('LINESTRING(540900.2686702100 152955.4115092800, 540900.4100672200 152952.3142217600)',21781)
       --                                                          ^
       --       Here is the small distance to the last end point --+
);
SELECT 'new pipe close to the previous - end';

-- restore the initial state
DELETE FROM qwat_od.vw_element_valve;
DELETE FROM qwat_od.pipe;
DELETE FROM qwat_od.pressurezone;
DELETE FROM qwat_od.consumptionzone;
DELETE FROM qwat_od.district;
DELETE FROM qwat_od.distributor;

