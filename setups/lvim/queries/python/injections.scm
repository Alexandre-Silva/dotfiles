; Highlight embbeded SQL. Strings that have '-- TS-sql' in them
((string) @sql (#contains? @sql "-- TS-sql"))


; Highlight SQL inside text() functions
((call
  function: (identifier) @_fn
  arguments: (argument_list
    (string) @sql))
  (#any-of? @_fn "text" "TEXT"))

