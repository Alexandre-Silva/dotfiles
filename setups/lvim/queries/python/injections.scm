; Highlight embbeded SQL. Strings must have '-- TS-sql' OR be inside a text() function

((string) @sql (#contains? @sql "-- TS-sql"))

