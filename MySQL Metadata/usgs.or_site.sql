CREATE TABLE usgs.or_site (
    site_no INT NOT NULL PRIMARY KEY,               -- Assuming 'site_no' is a unique identifier
    agency_cd VARCHAR(255),                         -- 'agency_cd' as a string (VARCHAR)
    station_nm VARCHAR(255),                        -- 'station_nm' as a string (VARCHAR)
    site_tp_cd VARCHAR(255),                        -- 'site_tp_cd' as a string (VARCHAR)
    dec_lat_va FLOAT,                               -- 'dec_lat_va' as a floating-point number (FLOAT for latitude)
    dec_long_va FLOAT,                              -- 'dec_long_va' as a floating-point number (FLOAT for longitude)
    coord_acy_cd VARCHAR(255),                      -- 'coord_acy_cd' as a string (VARCHAR)
    dec_coord_datum_cd VARCHAR(255),                -- 'dec_coord_datum_cd' as a string (VARCHAR)
    alt_va FLOAT,                                   -- 'alt_va' as a floating-point number (FLOAT for altitude)
    alt_acy_va FLOAT,                               -- 'alt_acy_va' as a floating-point number (FLOAT for altitude accuracy)
    alt_datum_cd VARCHAR(255),                      -- 'alt_datum_cd' as a string (VARCHAR)
    huc_cd FLOAT                                    -- 'huc_cd' as a floating-point number (FLOAT for huc_cd)
);
