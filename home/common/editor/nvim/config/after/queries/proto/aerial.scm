;; extends

(field
  (identifier) @name
  (#set! "kind" "Field")) @symbol

(map_field
  (identifier) @name
  (#set! "kind" "Field")) @symbol

(oneof
  (identifier) @name
  (#set! "kind" "Struct")) @symbol

(oneof_field
  (identifier) @name
  (#set! "kind" "Field")) @symbol

(enum_field
  (identifier) @name
  (#set! "kind" "Field")) @symbol
