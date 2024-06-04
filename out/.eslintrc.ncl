# DO NOT EDIT
# This file was automatically generated using json-schema-to-nickel
let _js2n__-prdslib
  = {
    allOf
      : Array (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `allOf preds` succeeds if all of the predicates in `preds` succeed
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.1]
      "%
      = fun
          preds
          x
          =>
          std.array.fold_right
            (fun pred acc => (match { 'Ok => acc, 'Err s => 'Err s, }) (pred x))
            'Ok preds,
    always : Dyn -> [| 'Ok, 'Err String |] = std.function.const 'Ok,
    anyOf
      : Array (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `anyOf preds` succeeds if at least one of the predicates in `preds` succeeds
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.2]
      "%
      = fun
          preds
          x
          =>
          (match {
            'Ok =>
              'Ok,
            'Errs
              msgs =>
              'Err
                m%"
                  anyOf: none of the options matched
                  %{std.string.join
                    m%"
                      
                      
                    "% msgs}
                "%,
          })
            (std.array.fold_right
              (fun
                pred
                acc
                =>
                (match {
                  'Ok =>
                    'Ok,
                  'Errs
                    msgs =>
                    (match {
                      'Ok =>
                        'Ok,
                      'Err
                        msg =>
                        'Errs ([ "  - %{msg}" ] @ msgs),
                    }) (pred x),
                }) acc) ('Errs [  ]) preds),
    arrays =
      {
          additionalItems
            : (Dyn -> [| 'Ok, 'Err String |])
            -> Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.2]"
            = fun
                pred
                start
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  let x
                    | Array Dyn
                    = x
                    in
                  let value_length
                      = std.array.length x
                      in
                    if start >= value_length then
                        'Ok
                      else
                        arrayOf pred
                          ((std.array.slice start value_length x)
                          | Dyn),
          arrayOf
            : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              Apply a predicate to all elements of an array, succeeding if all
              applications succeed.
            "%
            = fun
                pred
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  let x
                    | Array Dyn
                    = x
                    in
                  std.array.fold_right
                      (fun
                        x
                        acc
                        =>
                        (match { 'Ok => acc, 'Err msg => 'Err msg, }) (pred x))
                      'Ok x,
          contains
            : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.6]"
            = fun
                pred
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  let x
                    | Array Dyn
                    = x
                    in
                  (match {
                      'Ok =>
                        'Ok,
                      'Errs
                        msgs =>
                        'Err
                          m%"
                            contains: no elements matched
                            %{std.string.join
                              m%"
                                
                                
                              "% msgs}
                          "%,
                    })
                      (std.array.fold_right
                        (fun
                          x
                          acc
                          =>
                          (match {
                            'Ok =>
                              'Ok,
                            'Errs
                              msgs =>
                              (match {
                                'Ok =>
                                  'Ok,
                                'Err
                                  msg =>
                                  'Errs ([ "  - %{msg}" ] @ msgs),
                              }) (pred x),
                          }) acc) ('Errs [  ]) x),
          items
            : Array (Dyn -> [| 'Ok, 'Err String |])
            -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.1]"
            = fun
                preds
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  let x
                    | Array Dyn
                    = x
                    in
                  let length_to_check
                      = std.number.min (std.array.length preds)
                        (std.array.length x)
                      in
                    std.array.fold_right
                        (fun
                          i
                          acc
                          =>
                          (match { 'Err msg => 'Err msg, 'Ok => acc, })
                            (std.array.at i preds (std.array.at i x))) 'Ok
                        (std.array.range 0 length_to_check),
          maxItems
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `maxItems n x` fails if `x` is an array of length strictly greater than `n` and succeeds otherwise.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.3]
            "%
            = fun
                n
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  if (std.array.length (x | Array Dyn)) > n then
                    'Err
                      "array is longer than %{std.string.from_number n} items"
                  else
                    'Ok,
          minItems
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `minItems n x` fails if `x` is an array of length strictly smaller than `n` and succeeds otherwise.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.4]
            "%
            = fun
                n
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  if (std.array.length (x | Array Dyn)) < n then
                    'Err
                      "array is shorter than %{std.string.from_number n} items"
                  else
                    'Ok,
          uniqueItems
            : Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              Succeeds for any array if its elements are pairwise distinct.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.5]
            "%
            = let find_duplicate
                : Array Dyn
                -> {
                  has_duplicate : Bool,
                  duplicate : Dyn,
                  seen : { _ : Bool }
                }
                = std.array.fold_right
                  (fun
                    elt
                    acc
                    =>
                    if acc.has_duplicate then
                      acc
                    else
                      let index
                        = std.serialize 'Json elt
                        in
                      if std.record.has_field index acc.seen then
                          {
                            duplicate = elt,
                            has_duplicate = true,
                            seen = acc.seen,
                          }
                        else
                          {
                            duplicate = null,
                            has_duplicate = false,
                            seen = std.record.insert index true acc.seen,
                          })
                  { duplicate = null, has_duplicate = false, seen = {}, }
                in
              fun
                  x
                  =>
                  if !(std.is_array x) then
                    'Ok
                  else
                    let { has_duplicate, duplicate, .. }
                      = find_duplicate (x | Array Dyn)
                      in
                    if has_duplicate then
                        'Err "duplicate found: %{std.serialize 'Json duplicate}"
                      else
                        'Ok,
        },
    const
      : Dyn -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `const value x` succeeds if and only if `x` is equal to `value`
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.3]
      "%
      = fun
          value
          x
          =>
          if x == value then
            'Ok
          else
            'Err "expected %{std.serialize 'Json value}",
    contract_from_predicate
      : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> Dyn -> Dyn
      = fun
          predicate
          label
          value
          =>
          (match {
            'Ok =>
              value,
            'Err
              msg =>
              (std.contract.blame_with_message msg label)
              | Dyn,
          }) (predicate value),
    enum
      : Array Dyn -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `enum values x` succeeds if and only if `x` is equal to one of the elements of `values`.
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.2]
      "%
      = let checkEqual
          = fun
            input
            variant
            =>
            (input == variant)
            || ((std.is_enum input)
            && (((std.string.from_enum input) == variant)
            | Bool))
          in
        fun
            values
            x
            =>
            std.array.fold_right
              (fun value acc => if checkEqual x value then 'Ok else acc)
              ('Err "expected one of %{std.serialize 'Json (values | Dyn)}")
              values,
    from_simple_predicate
      : String -> (Dyn -> Bool) -> Dyn -> [| 'Ok, 'Err String |]
      | doc "Convert a simple boolean predicate into a predicate supporting error messages"
      = fun error' pred x => if pred x then 'Ok else 'Err error',
    ifThenElse
      : (Dyn -> [| 'Ok, 'Err String |])
      -> (Dyn -> [| 'Ok, 'Err String |])
      -> (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `ifThenElse i t e` first checks if the predicate `i` succeeds. If it does, it's equivalent to `t`, otherwise it's equivalent to `e`.
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.6]
      "%
      = fun i t e x => (match { 'Ok => t x, 'Err msg => e x, }) (i x),
    isType
      : [| '"Array", '"Bool", 'Integer, 'Null, '"Number", 'Record, '"String" |]
      -> Dyn -> [| 'Ok, 'Err String |]
      = fun
          t
          =>
          (match {
            'Null =>
              from_simple_predicate "expected `null`" (fun x => x == null),
            'Integer =>
              from_simple_predicate "expected an integer"
                (fun
                  x
                  =>
                  (std.is_number x) && (std.number.is_integer (x | Number))),
            _ =>
              from_simple_predicate
                "value is not of type %{std.string.from_enum t}"
                (fun x => (std.typeof x) == t),
          }) t,
    never : Dyn -> [| 'Ok, 'Err String |] = std.function.const ('Err "never"),
    not
      : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `not pred` succeeds if and only if `pred` fails
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.4]
      "%
      = fun
          pred
          x
          =>
          (match {
            'Ok =>
              'Err "Inverted predicate succeeded unexpectedly",
            'Err
              msg =>
              'Ok,
          }) (pred x),
    numbers =
      {
          exclusiveMaximum
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.3]"
            = fun
                limit
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if (x | Number) < limit then
                    'Ok
                  else
                    'Err
                      "expected an exclusive maximum of %{std.string.from_number
                        limit}",
          exclusiveMinimum
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.5]"
            = fun
                limit
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if (x | Number) > limit then
                    'Ok
                  else
                    'Err
                      "expected an exclusive minimum of %{std.string.from_number
                        limit}",
          maximum
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.2]"
            = fun
                limit
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if (x | Number) <= limit then
                    'Ok
                  else
                    'Err
                      "expected a maximum of %{std.string.from_number limit}",
          minimum
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.4]"
            = fun
                limit
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if (x | Number) >= limit then
                    'Ok
                  else
                    'Err
                      "expected a minimum of %{std.string.from_number limit}",
          multipleOf
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.1]"
            = fun
                mult
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if std.number.is_integer ((x | Number) / mult) then
                    'Ok
                  else
                    'Err
                      "expected a multiple of %{std.string.from_number mult}",
        },
    oneOf
      : Array (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `oneOf preds` succeeds if precisely one of the predicates in `preds` succeeds
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.3]
      "%
      = fun
          preds
          x
          =>
          let count_ok
            : Array [| 'Ok, 'Err String |] -> Number
            = fun
              results
              =>
              std.array.fold_left (fun n b => if b == 'Ok then n + 1 else n) 0
                results
            in
          let results
              = std.array.map (fun pred => pred x) preds
              in
            let count
                = count_ok results
                in
              if count == 0 then
                  let errors
                    = std.array.flat_map
                      (fun
                        result
                        =>
                        (match { 'Ok => [  ], 'Err s => [ "  - %{s}" ], })
                          result) results
                    in
                  'Err
                      m%"
                        oneOf: none of the options matched
                        %{std.string.join
                          m%"
                            
                            
                          "% errors}
                      "%
                else
                  if count > 1 then
                    'Err "oneOf: more than one of the options matched"
                  else
                    'Ok,
    records =
      {
          dependencies
            : { _ : Dyn } -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.7]"
            = let mustHaveFields
                : Array String -> { _ : Dyn } -> [| 'Ok, 'Err String |]
                = fun
                  fields
                  x
                  =>
                  std.array.fold_right
                    (fun
                      field
                      acc
                      =>
                      if !(std.record.has_field field x) then
                        'Err "expected field `%{field}`"
                      else
                        acc) 'Ok fields
                in
              fun
                  deps
                  x
                  =>
                  if !(std.is_record x) then
                    'Ok
                  else
                    let x
                      | { _ : Dyn }
                      = x
                      in
                    std.array.fold_right
                        (fun
                          { field, value, }
                          =>
                          fun
                            acc
                            =>
                            if !(std.record.has_field field x) then
                              acc
                            else
                              let result
                                = if std.is_array value then
                                  mustHaveFields (value | Array String) x
                                else
                                  let pred
                                    | Dyn -> [| 'Ok, 'Err String |]
                                    = value
                                    in
                                  pred (x | Dyn)
                                in
                              (match {
                                  'Err
                                    msg =>
                                    'Err
                                      "dependency of `%{field}` failed: %{msg}",
                                  'Ok =>
                                    acc,
                                }) result) 'Ok (std.record.to_array deps),
          maxProperties
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `maxProperties n x` fails if `x` is a record containing stricly more than `n` fields.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun
                n
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  if (std.record.length (x | { _ : Dyn })) > n then
                    'Err
                      "record contains more than %{std.string.from_number
                        n} fields"
                  else
                    'Ok,
          minProperties
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `minProperties n x` fails if `x` is a record containing stricly less than `n` fields.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun
                n
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  if (std.record.length (x | { _ : Dyn })) < n then
                    'Err
                      "record contains fewer than %{std.string.from_number
                        n} fields"
                  else
                    'Ok,
          propertyNames
            : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.8]"
            = fun
                pred
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  std.array.fold_right
                    (fun
                      field
                      acc
                      =>
                      (match {
                        'Err
                          msg =>
                          'Err
                            "field `%{field}` did not validate against `propertyNames` schema",
                        'Ok =>
                          acc,
                      }) (pred (field | Dyn))) 'Ok
                    (std.record.fields (x | { _ : Dyn })),
          record
            : { _ : Dyn -> [| 'Ok, 'Err String |] }
            -> { _ : Dyn -> [| 'Ok, 'Err String |] }
            -> Bool
            -> (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `record properties patternProperties additionalAllowed
              additionalProperties x` is a combination of the `properties`,
              `patternProperties` and `additionalProperties` validation keywords in
              JSON schema.
              
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5]
            "%
            = fun
                properties
                patternProperties
                additionalAllowed
                additionalProperties
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  let x
                    | { _ : Dyn }
                    = x
                    in
                  let check_properties
                      : {
                        result : [| 'Ok, 'Err String |],
                        checked : { _ : Bool }
                      }
                      = std.array.fold_right
                        (fun
                          { field, value, }
                          =>
                          fun
                            acc
                            =>
                            if !(std.record.has_field field x) then
                              acc
                            else
                              (match {
                                'Err
                                  msg =>
                                  {
                                    checked : { _ : Bool } = {},
                                    result =
                                      'Err
                                          "field `%{field}` didn't validate: %{msg}",
                                  },
                                'Ok =>
                                  {
                                    checked =
                                      std.record.insert field true acc.checked,
                                    result = acc.result,
                                  },
                              }) (value x."%{field}"))
                        { checked = {}, result = 'Ok, }
                        (std.record.to_array properties)
                      in
                    let matching_fields
                        : String -> { _ : Dyn }
                        = fun
                          pattern
                          =>
                          let matcher
                            = std.string.is_match pattern
                            in
                          std.array.fold_left
                              (fun
                                acc
                                =>
                                fun
                                  { field, value, }
                                  =>
                                  if matcher field then
                                    std.record.insert field value acc
                                  else
                                    acc) {} (std.record.to_array x)
                        in
                      let check_pattern_properties
                          : {
                            result : [| 'Ok, 'Err String |],
                            checked : { _ : Bool }
                          }
                          = std.array.fold_right
                            (fun
                              { field = pattern, value = pred, }
                              =>
                              fun
                                acc
                                =>
                                (match {
                                  r @ { result = 'Err msg, .. } =>
                                    r,
                                  { result = 'Ok, checked = ch, } =>
                                    {
                                      checked =
                                        std.array.fold_left
                                            (fun
                                              r
                                              field
                                              =>
                                              if !(std.record.has_field field
                                                r) then
                                                std.record.insert field true r
                                              else
                                                r) acc.checked
                                            (std.record.fields ch),
                                      result = acc.result,
                                    },
                                })
                                  (std.array.fold_right
                                    (fun
                                      { field, value, }
                                      =>
                                      fun
                                        acc
                                        =>
                                        (match {
                                          'Err
                                            msg =>
                                            {
                                              checked : { _ : Bool } = {},
                                              result =
                                                'Err
                                                    "field `%{field}` didn't validate: %{msg}",
                                            },
                                          'Ok =>
                                            {
                                              checked =
                                                std.record.insert field true
                                                    acc.checked,
                                              result = acc.result,
                                            },
                                        }) (pred value))
                                    {
                                      checked : { _ : Bool } = {},
                                      result = 'Ok,
                                    }
                                    (std.record.to_array
                                      (matching_fields pattern))))
                            { checked : { _ : Bool } = {}, result = 'Ok, }
                            (std.record.to_array patternProperties)
                          in
                        let remaining_fields
                            = std.array.fold_left
                              (fun
                                acc
                                field
                                =>
                                if !(std.record.has_field field acc) then
                                  acc
                                else
                                  std.record.remove field acc) x
                              ((std.record.fields check_properties.checked)
                              @ (std.record.fields
                                check_pattern_properties.checked))
                            in
                          let check_additional_properties
                              : [| 'Ok, 'Err String |]
                              = if (!additionalAllowed)
                              && (!(std.record.is_empty remaining_fields)) then
                                'Err
                                  "extra fields %{std.serialize 'Json
                                    ((std.record.fields remaining_fields)
                                    | Dyn)}"
                              else
                                std.array.fold_right
                                  (fun
                                    { field, value, }
                                    =>
                                    fun
                                      acc
                                      =>
                                      (match {
                                        'Err
                                          msg =>
                                          'Err
                                            "field `%{field}` didn't validate: %{msg}",
                                        'Ok =>
                                          acc,
                                      }) (additionalProperties value)) 'Ok
                                  (std.record.to_array remaining_fields)
                              in
                            (match {
                                'Err
                                  msg =>
                                  check_properties.result,
                                'Ok =>
                                  (match {
                                    'Err
                                      msg =>
                                      check_pattern_properties.result,
                                    'Ok =>
                                      check_additional_properties,
                                  }) check_pattern_properties.result,
                              }) check_properties.result,
          required
            : Array String -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.3]"
            = fun
                fields
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  std.array.fold_right
                    (fun
                      field
                      acc
                      =>
                      if !(std.record.has_field field (x | { _ : Dyn })) then
                        'Err "missing required field %{field}"
                      else
                        acc) 'Ok fields,
        },
    strings =
      {
          maxLength
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.1]"
            = fun
                limit
                x
                =>
                if !(std.is_string x) then
                  'Ok
                else
                  if (std.string.length (x | String)) <= limit then
                    'Ok
                  else
                    'Err
                      "expected a string of length no larger than %{std.string.from_number
                        limit}",
          minLength
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.2]"
            = fun
                limit
                x
                =>
                if !(std.is_string x) then
                  'Ok
                else
                  if (std.string.length (x | String)) >= limit then
                    'Ok
                  else
                    'Err
                      "expected a string of length no smaller than %{std.string.from_number
                        limit}",
          pattern
            : String -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.3]"
            = fun
                pattern
                x
                =>
                if !(std.is_string x) then
                  'Ok
                else
                  if std.string.is_match pattern (x | String) then
                    'Ok
                  else
                    'Err "expected a string matching the pattern `%{pattern}`",
        },
  }
  in
let rec _js2n__-refsenv
    = {
      "_js2n__-:definitions/bestPractices!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessor-pairs =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  array-callback-return =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  block-scoped-var =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  class-methods-use-this =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  complexity =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  consistent-return =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  curly = _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  default-case =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  dot-location =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  dot-notation =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  eqeqeq =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  guard-for-in =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-alert =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-caller =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-case-declarations =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-div-regex =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-else-return =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-empty-function =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-empty-pattern =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-eq-null =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-eval =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-extend-native =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-extra-bind =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-extra-label =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-fallthrough =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-floating-decimal =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-global-assign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-implicit-coercion =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-implicit-globals =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-implied-eval =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-invalid-this =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-iterator =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-labels =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-lone-blocks =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-loop-func =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-magic-numbers =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-multi-spaces =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-multi-str =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-native-reassign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-new =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-new-func =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-new-wrappers =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-octal =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-octal-escape =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-param-reassign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-proto =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-redeclare =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-restricted-properties =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-return-assign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-return-await =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-script-url =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-self-assign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-self-compare =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-sequences =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-throw-literal =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-unmodified-loop-condition =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-unused-expressions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-unused-labels =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-useless-call =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-useless-concat =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-useless-escape =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-useless-return =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-void =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-warning-comments =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-with =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  prefer-promise-reject-errors =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  radix = _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  require-await =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  vars-on-top =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  wrap-iife =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  yoda = _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ecmaScript6!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arrow-body-style =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  arrow-parens =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  arrow-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  constructor-super =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  generator-star-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-class-assign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-confusing-arrow =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-const-assign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-dupe-class-members =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-duplicate-imports =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-new-symbol =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-restricted-imports =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-this-before-super =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-useless-computed-key =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-useless-constructor =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-useless-rename =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-var =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  object-shorthand =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  prefer-arrow-callback =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  prefer-const =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  prefer-destructuring =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  prefer-numeric-literals =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  prefer-reflect =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  prefer-rest-params =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  prefer-spread =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  prefer-template =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  require-yield =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  rest-spread-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  sort-imports =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  symbol-description =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  template-curly-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  yield-star-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/legacy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max-depth =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-len =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-params =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-statements =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-bitwise =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-plusplus =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeAndCommonJs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  callback-return =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  global-require =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  handle-callback-err =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-buffer-constructor =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-mixed-requires =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-new-require =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-path-concat =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-process-env =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-process-exit =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-restricted-modules =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-sync =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/possibleErrors!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  comma-dangle =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  for-direction =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  getter-return =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-await-in-loop =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-compare-neg-zero =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-cond-assign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-console =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-constant-condition =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-control-regex =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-debugger =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-dupe-args =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-dupe-keys =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-duplicate-case =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-empty =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-empty-character-class =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-ex-assign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-extra-boolean-cast =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-extra-parens =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-extra-semi =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-func-assign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-inner-declarations =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-invalid-regexp =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-irregular-whitespace =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-negated-in-lhs =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-obj-calls =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-prototype-builtins =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-regex-spaces =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-sparse-arrays =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-template-curly-in-string =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-unexpected-multiline =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-unreachable =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-unsafe-finally =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-unsafe-negation =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  use-isnan =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  valid-jsdoc =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  valid-typeof =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/rule!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.maximum 2,
                  _js2n__-prdslib.numbers.minimum 0
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "off", "warn", "error" ]
                ],
              _js2n__-prdslib.isType '"Array"
            ],
      "_js2n__-:definitions/strictMode!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  strict =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/stringOrStringArray!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String")
                  ]
              ]),
      "_js2n__-:definitions/stylisticIssues!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  array-bracket-newline =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  array-bracket-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  array-element-newline =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  block-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  brace-style =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  camelcase =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  capitalized-comments =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  comma-dangle =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  comma-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  comma-style =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  computed-property-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  consistent-this =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  eol-last =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  func-call-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  func-name-matching =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  func-names =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  func-style =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  function-call-argument-newline =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  function-paren-newline =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  id-blacklist =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  id-length =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  id-match =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  implicit-arrow-linebreak =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  indent =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  indent-legacy =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  jsx-quotes =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  key-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  keyword-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  line-comment-position =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  linebreak-style =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  lines-around-comment =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  lines-around-directive =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  lines-between-class-members =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-depth =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-len =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-lines =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-nested-callbacks =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-params =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-statements =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  max-statements-per-line =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  multiline-comment-style =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  multiline-ternary =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  new-cap =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  new-parens =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  newline-after-var =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  newline-before-return =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  newline-per-chained-call =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-array-constructor =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-bitwise =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-continue =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-inline-comments =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-lonely-if =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-mixed-operators =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-mixed-spaces-and-tabs =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-multi-assign =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-multiple-empty-lines =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-negated-condition =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-nested-ternary =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-new-object =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-plusplus =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-restricted-syntax =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-spaced-func =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-tabs =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-ternary =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-trailing-spaces =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-underscore-dangle =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-unneeded-ternary =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-whitespace-before-property =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  nonblock-statement-body-position =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  object-curly-newline =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  object-curly-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  object-property-newline =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  object-shorthand =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  one-var =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  one-var-declaration-per-line =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  operator-assignment =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  operator-linebreak =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  padded-blocks =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  padding-line-between-statements =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  quote-props =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  quotes =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  require-jsdoc =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  semi = _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  semi-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  semi-style =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  sort-keys =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  sort-vars =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  space-before-blocks =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  space-before-function-paren =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  space-in-parens =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  space-infix-ops =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  space-unary-ops =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  spaced-comment =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  switch-colon-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  template-tag-spacing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  unicode-bom =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  wrap-regex =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/variables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  init-declarations =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-catch-shadow =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-delete-var =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-label-var =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-restricted-globals =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-shadow =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-shadow-restricted-names =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-undef =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-undef-init =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-undefined =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-unused-vars =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  no-use-before-define =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      ecmaFeatures
        | {
          arrowFunctions | Bool | optional,
          binaryLiterals | Bool | optional,
          blockBindings | Bool | optional,
          classes | Bool | optional,
          defaultParams | Bool | optional,
          destructuring | Bool | optional,
          experimentalObjectRestSpread
            | Bool
            | doc "Enables support for the experimental object rest/spread properties (IMPORTANT: This is an experimental feature that may change significantly in the future. It's recommended that you do not write rules relying on this functionality unless you are willing to incur maintenance cost when it changes.)"
            | optional,
          forOf | Bool | optional,
          generators | Bool | optional,
          globalReturn
            | Bool
            | doc "allow return statements in the global scope"
            | optional,
          impliedStrict
            | Bool
            | doc "enable global strict mode (if ecmaVersion is 5 or greater)"
            | optional,
          jsx | Bool | doc "enable JSX" | optional,
          modules | Bool | optional,
          objectLiteralComputedProperties | Bool | optional,
          objectLiteralDuplicateProperties | Bool | optional,
          objectLiteralShorthandMethods | Bool | optional,
          objectLiteralShorthandProperties | Bool | optional,
          octalLiterals | Bool | optional,
          regexUFlag | Bool | optional,
          regexYFlag | Bool | optional,
          restParams | Bool | optional,
          spread | Bool | optional,
          superInFunctions | Bool | optional,
          templateStrings | Bool | optional,
          unicodeCodePointEscapes | Bool | optional,
          ..
        }
        | doc "By default, ESLint supports only ECMAScript 5 syntax. You can override that setting to enable support for ECMAScript 6 as well as JSX by using configuration settings."
        | optional,
      env
        | {
          amd
            | Bool
            | doc "defines require() and define() as global variables as per the amd spec"
            | optional,
          applescript | Bool | doc "AppleScript global variables" | optional,
          atomtest | Bool | doc "Atom test helper globals" | optional,
          browser | Bool | doc "browser global variables" | optional,
          commonjs
            | Bool
            | doc "CommonJS global variables and CommonJS scoping (use this for browser-only code that uses Browserify/WebPack)"
            | optional,
          embertest | Bool | doc "Ember test helper globals" | optional,
          es6
            | Bool
            | doc "enable all ECMAScript 6 features except for modules"
            | optional,
          greasemonkey | Bool | doc "GreaseMonkey globals" | optional,
          jasmine
            | Bool
            | doc "adds all of the Jasmine testing global variables for version 1.3 and 2.0"
            | optional,
          jest | Bool | doc "Jest global variables" | optional,
          jquery | Bool | doc "jQuery global variables" | optional,
          meteor | Bool | doc "Meteor global variables" | optional,
          mocha
            | Bool
            | doc "adds all of the Mocha test global variables"
            | optional,
          mongo | Bool | doc "MongoDB global variables" | optional,
          nashorn | Bool | doc "Java 8 Nashorn global variables" | optional,
          node
            | Bool
            | doc "Node.js global variables and Node.js scoping"
            | optional,
          phantomjs | Bool | doc "PhantomJS global variables" | optional,
          prototypejs | Bool | doc "Prototype.js global variables" | optional,
          protractor | Bool | doc "Protractor global variables" | optional,
          qunit | Bool | doc "QUnit global variables" | optional,
          serviceworker
            | Bool
            | doc "Service Worker global variables"
            | optional,
          shared-node-browser
            | Bool
            | doc "Globals common to both Node and Browser"
            | optional,
          shelljs | Bool | doc "ShellJS global variables" | optional,
          webextensions | Bool | doc "WebExtensions globals" | optional,
          worker | Bool | doc "web workers global variables" | optional,
          ..
        }
        | doc "An environment defines global variables that are predefined."
        | optional,
      extends
        | _js2n__-refsenv."_js2n__-:definitions/stringOrStringArray!contract"
        | doc "If you want to extend a specific configuration file, you can use the extends property and specify the path to the file. The path can be either relative or absolute."
        | optional,
      globals
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum [ "readonly", "writable", "off" ]
                      ],
                    _js2n__-prdslib.isType '"Bool"
                  ])
            ])
        | doc "Set each global variable name equal to true to allow the variable to be overwritten or false to disallow overwriting."
        | optional,
      ignorePatterns
        | _js2n__-refsenv."_js2n__-:definitions/stringOrStringArray!contract"
        | doc "Tell ESLint to ignore specific files and directories. Each value uses the same pattern as the `.eslintignore` file."
        | optional,
      noInlineConfig
        | Bool
        | doc "Prevent comments from changing config or rules"
        | optional,
      overrides
        | Array
          {
            ecmaFeatures | ecmaFeatures | optional,
            env | env | optional,
            excludedFiles
              | _js2n__-refsenv."_js2n__-:definitions/stringOrStringArray!contract"
              | doc "If a file matches any of the 'excludedFiles' glob patterns, the 'overrides' configuration won't apply"
              | optional,
            extends
              | _js2n__-refsenv."_js2n__-:definitions/stringOrStringArray!contract"
              | doc "If you want to extend a specific configuration file, you can use the extends property and specify the path to the file. The path can be either relative or absolute."
              | optional,
            files
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String"),
                        _js2n__-prdslib.arrays.minItems 1
                      ]
                  ])
              | doc "Glob pattern for files to apply 'overrides' configuration, relative to the directory of the config file",
            globals | globals | optional,
            overrides | overrides | optional,
            parser | parser | optional,
            parserOptions | parserOptions | optional,
            plugins | plugins | optional,
            processor
              | String
              | doc "To specify a processor, specify the plugin name and processor name joined by a forward slash"
              | optional,
            rules | rules | optional,
            settings | settings | optional,
          }
        | doc "Allows to override configuration for files and folders, specified by glob patterns"
        | optional,
      parser | String | optional,
      parserOptions
        | {
          ecmaFeatures | ecmaFeatures | optional,
          ecmaVersion
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum
                [
                  3,
                  5,
                  6,
                  2015,
                  7,
                  2016,
                  8,
                  2017,
                  9,
                  2018,
                  10,
                  2019,
                  11,
                  2020,
                  12,
                  2021,
                  13,
                  2022,
                  14,
                  2023,
                  "latest"
                ])
            | doc "Set to 3, 5, 6, 7, 8, 9, 10, 11 (default), 12, 13, 14 or \"latest\" to specify the version of ECMAScript syntax you want to use. You can also set to 2015 (same as 6), 2016 (same as 7), 2017 (same as 8), 2018 (same as 9), 2019 (same as 10), 2020 (same as 11), 2021 (same as 12), 2022 (same as 13) or 2023 (same as 14) to use the year-based naming. \"latest\" always enables the latest supported ECMAScript version."
            | optional,
          sourceType
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "script", "module", "commonjs" ])
            | doc "set to \"script\" (default), \"commonjs\", or \"module\" if your code is in ECMAScript modules"
            | optional,
          ..
        }
        | doc "The JavaScript language options to be supported"
        | optional,
      plugins
        | Array (String)
        | doc "ESLint supports the use of third-party plugins. Before using the plugin, you have to install it using npm."
        | optional,
      reportUnusedDisableDirectives
        | Bool
        | doc "Report unused eslint-disable comments"
        | optional,
      root
        | Bool
        | doc "By default, ESLint will look for configuration files in all parent folders up to the root directory. This can be useful if you want all of your projects to follow a certain convention, but can sometimes lead to unexpected results. To limit ESLint to a specific project, set this to `true` in a configuration in the root of your project."
        | optional,
      rules
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/possibleErrors!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/bestPractices!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/strictMode!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/nodeAndCommonJs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/stylisticIssues!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/ecmaScript6!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/legacy!predicate",
                  _js2n__-prdslib.always
                ]
            ])
        | doc "ESLint comes with a large number of rules. You can modify which rules your project uses either using configuration comments or configuration files."
        | optional,
      settings
        | {  .. }
        | doc "ESLint supports adding shared settings into configuration file. You can add settings object to ESLint configuration file and it will be supplied to every rule that will be executed. This may be useful if you are adding custom rules and want them to have access to the same information and be easily configurable."
        | optional,
      ..
    }