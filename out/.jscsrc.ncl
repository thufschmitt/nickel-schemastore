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
      "_js2n__-:definitions/blockKeywords!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.enum
                  [
                    "catch",
                    "do",
                    "else",
                    "finally",
                    "for",
                    "function",
                    "if",
                    "try",
                    "while"
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/braceRules!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType 'Record
                ],
              _js2n__-prdslib.records.record
                {
                  beforeOpeningCurlyBrace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  beforeOpeningRoundBrace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/equalityOperators!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.enum [ "==", "===", "!=", "!==", null ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/esprimaNodeTypes!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.enum
                  [
                    "ArrayExpression",
                    "ArrayPattern",
                    "ArrowFunctionExpression",
                    "AssignmentExpression",
                    "AssignmentPattern",
                    "BinaryExpression",
                    "BlockStatement",
                    "BreakStatement",
                    "CallExpression",
                    "CatchClause",
                    "ClassBody",
                    "ClassDeclaration",
                    "ClassExpression",
                    "ConditionalExpression",
                    "ContinueStatement",
                    "DebuggerStatement",
                    "DoWhileStatement",
                    "EmptyStatement",
                    "ExportAllDeclaration",
                    "ExportDefaultDeclaration",
                    "ExportNamedDeclaration",
                    "ExportSpecifier",
                    "ExpressionStatement",
                    "ForInStatement",
                    "ForStatement",
                    "FunctionDeclaration",
                    "FunctionExpression",
                    "Identifier",
                    "IfStatement",
                    "ImportDeclaration",
                    "ImportDefaultSpecifier",
                    "ImportNamespaceSpecifier",
                    "ImportSpecifier",
                    "LabeledStatement",
                    "Literal",
                    "LogicalExpression",
                    "MemberExpression",
                    "MethodDefinition",
                    "NewExpression",
                    "ObjectExpression",
                    "ObjectPattern",
                    "Program",
                    "Property",
                    "RestElement",
                    "ReturnStatement",
                    "SequenceExpression",
                    "SpreadElement",
                    "Super",
                    "SwitchCase",
                    "SwitchStatement",
                    "TaggedTemplateExpression",
                    "TemplateElement",
                    "TemplateLiteral",
                    "ThisExpression",
                    "ThrowStatement",
                    "TryStatement",
                    "UnaryExpression",
                    "UpdateExpression",
                    "VariableDeclaration",
                    "VariableDeclarator",
                    "WhileStatement",
                    "WithStatement"
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/jsDoc!predicate"
        | doc "Validate jsdoc comments."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  checkAnnotations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      extra =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} true
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Bool",
                                                            _js2n__-prdslib.isType
                                                              '"String"
                                                          ],
                                                        _js2n__-prdslib.enum
                                                          [
                                                            true,
                                                            false,
                                                            "some"
                                                          ]
                                                      ]
                                                  ])
                                            ],
                                      preset =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [ "closurecompiler" ],
                                                  _js2n__-prdslib.enum
                                                    [ "jsdoc3" ],
                                                  _js2n__-prdslib.enum
                                                    [ "jsduck5" ]
                                                ]
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.enum
                                        [ "closurecompiler" ],
                                      _js2n__-prdslib.enum [ "jsdoc3" ],
                                      _js2n__-prdslib.enum [ "jsduck5" ]
                                    ]
                                ]
                            ]
                        ],
                  checkParamExistence =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  checkParamNames =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  checkRedundantAccess =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.enum
                                        [ "enforceLeadingUnderscore" ],
                                      _js2n__-prdslib.enum
                                        [ "enforceTrailingUnderscore" ]
                                    ]
                                ]
                            ]
                        ],
                  checkRedundantParams =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  checkRedundantReturns =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  checkReturnTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  checkTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.enum
                                        [ "strictNativeCase" ],
                                      _js2n__-prdslib.enum
                                        [ "capitalizedNativeCase" ]
                                    ]
                                ]
                            ]
                        ],
                  disallowNewlineAfterDescription =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  enforceExistence =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      allExcept =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.enum
                                                          [ "expressions" ],
                                                        _js2n__-prdslib.enum
                                                          [ "exports" ],
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "paramless-procedures"
                                                          ]
                                                      ]
                                                  ]),
                                              _js2n__-prdslib.arrays.minItems 0,
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.oneOf
                                    [ _js2n__-prdslib.enum [ "exceptExports" ] ]
                                ]
                            ]
                        ],
                  leadingUnderscoreAccess =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.enum [ "private" ],
                                      _js2n__-prdslib.enum [ "protected" ]
                                    ]
                                ]
                            ]
                        ],
                  requireDescriptionCompleteSentence =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  requireHyphenBeforeDescription =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  requireNewlineAfterDescription =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  requireParamDescription =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  requireParamTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  requireReturnDescription =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  requireReturnTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/keywords!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.enum
                  [
                    "break",
                    "case",
                    "catch",
                    "continue",
                    "debugger",
                    "default",
                    "delete",
                    "do",
                    "else",
                    "finally",
                    "for",
                    "function",
                    "if",
                    "in",
                    "instanceof",
                    "new",
                    "return",
                    "switch",
                    "this",
                    "throw",
                    "try",
                    "typeof",
                    "var",
                    "void",
                    "while",
                    "with"
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/keywords2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/keywords!predicate",
                  _js2n__-prdslib.isType '"Bool"
                ]
            ],
      "_js2n__-:definitions/nullRule!predicate"
        | doc "Removes the rule."
        = _js2n__-prdslib.isType 'Null,
      "_js2n__-:definitions/operators!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.enum
                  [
                    ",",
                    ":",
                    "?",
                    "^",
                    "^=",
                    "|",
                    "||",
                    "|=",
                    "&",
                    "&&",
                    "&=",
                    "+",
                    "+=",
                    "-",
                    "-=",
                    "%",
                    "%=",
                    "/",
                    "/=",
                    "*",
                    "*=",
                    "=",
                    "==",
                    "===",
                    "!=",
                    "!==",
                    ">",
                    ">>",
                    ">>>",
                    ">=",
                    ">>=",
                    ">>>=",
                    "<",
                    "<<",
                    "<=",
                    "<<=",
                    null
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/unaryOperators!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.enum [ "++", "--", "+", "-", "~", "!" ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              additionalRules =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              disallowAnonymousFunctions =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowArrowFunctions =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowCapitalizedComments =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowCommaBeforeLineBreak =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.enum
                                              [ "function" ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowCurlyBraces =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords2!predicate"
                        ]
                    ],
              disallowDanglingUnderscores =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowEmptyBlocks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.enum
                                              [ "comments" ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowFunctionDeclarations =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowIdenticalDestructuringNames =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowIdentifierNames =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.minItems 0,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              disallowImplicitTypeConversion =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.enum
                          [ "numeric", "boolean", "binary", "string" ]),
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              disallowKeywords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords!predicate"
                        ]
                    ],
              disallowKeywordsInComments =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.minItems 0,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.isType '"String"
                        ]
                    ],
              disallowKeywordsOnNewLine =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords!predicate"
                        ]
                    ],
              disallowMixedSpacesAndTabs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.enum [ true, false, null, "smart" ]
                    ],
              disallowMultiLineTernary =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowMultipleLineBreaks =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowMultipleLineStrings =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowMultipleSpaces =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allowEOLComments =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowMultipleVarDecl =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "require" ],
                                                    _js2n__-prdslib.enum
                                                      [ "undefined" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  strict =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowNamedUnassignedFunctions =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowNestedTernaries =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  maxLevel =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.minimum 1
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowNewlineBeforeBlockStatements =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/blockKeywords!predicate",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "multiline" ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  value =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType '"Bool"
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowNodeTypes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/esprimaNodeTypes!predicate"
                        ]
                    ],
              disallowNotOperatorsInConditionals =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowObjectKeysOnNewLine =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowOperatorBeforeLineBreak =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/operators!predicate"
                        ]
                    ],
              disallowPaddingNewLinesAfterBlocks =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowPaddingNewLinesAfterUseStrict =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowPaddingNewLinesBeforeExport =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowPaddingNewLinesBeforeLineComments =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              disallowPaddingNewLinesInObjects =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowPaddingNewlinesBeforeKeywords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords2!predicate"
                        ]
                    ],
              disallowPaddingNewlinesInBlocks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.enum
                                              [ "conditionals", "functions" ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  close = _js2n__-prdslib.isType '"Bool",
                                  open = _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowParenthesesAroundArrowParam =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowQuotedKeysInObjects =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "reserved" ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [ _js2n__-prdslib.enum [ "allButReserved" ] ]
                            ]
                        ]
                    ],
              disallowSemicolons =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowShorthandArrowFunctions =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowSpaceAfterBinaryOperators =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/operators!predicate"
                        ]
                    ],
              disallowSpaceAfterComma =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "sparseArrays" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowSpaceAfterKeywords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords2!predicate"
                        ]
                    ],
              disallowSpaceAfterLineComment =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowSpaceAfterObjectKeys =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "singleline" ],
                                                    _js2n__-prdslib.enum
                                                      [ "multiline" ],
                                                    _js2n__-prdslib.enum
                                                      [ "aligned" ],
                                                    _js2n__-prdslib.enum
                                                      [ "method" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.enum [ "ignoreSingleLine" ],
                                  _js2n__-prdslib.enum [ "ignoreMultiLine" ]
                                ]
                            ]
                        ]
                    ],
              disallowSpaceAfterPrefixUnaryOperators =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/unaryOperators!predicate"
                        ]
                    ],
              disallowSpaceBeforeBinaryOperators =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/operators!predicate"
                        ]
                    ],
              disallowSpaceBeforeBlockStatements =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowSpaceBeforeComma =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "sparseArrays" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [ _js2n__-prdslib.enum [ "exceptExports" ] ]
                            ]
                        ]
                    ],
              disallowSpaceBeforeKeywords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords2!predicate"
                        ]
                    ],
              disallowSpaceBeforeObjectValues =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowSpaceBeforePostfixUnaryOperators =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/unaryOperators!predicate"
                        ]
                    ],
              disallowSpaceBeforeSemicolon =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "(" ],
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.strings.maxLength
                                                          1
                                                      ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowSpaceBetweenArguments =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowSpacesInAnonymousFunctionExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/braceRules!predicate"
                        ]
                    ],
              disallowSpacesInCallExpression =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowSpacesInConditionalExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.records.record
                            {
                              afterConsequent = _js2n__-prdslib.isType '"Bool",
                              afterTest = _js2n__-prdslib.isType '"Bool",
                              beforeAlternate = _js2n__-prdslib.isType '"Bool",
                              beforeConsequent = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
              disallowSpacesInForStatement =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.isType 'Null
                    ],
              disallowSpacesInFunction =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/braceRules!predicate"
                        ]
                    ],
              disallowSpacesInFunctionDeclaration =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/braceRules!predicate"
                        ]
                    ],
              disallowSpacesInFunctionExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/braceRules!predicate"
                        ]
                    ],
              disallowSpacesInGenerator =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  afterStar = _js2n__-prdslib.isType '"Bool",
                                  beforeStar = _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowSpacesInNamedFunctionExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/braceRules!predicate"
                        ]
                    ],
              disallowSpacesInsideArrayBrackets =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType '"String"
                                ],
                              _js2n__-prdslib.enum [ true, false, "all" ]
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "(",
                                                        ")",
                                                        "{",
                                                        "}",
                                                        "[",
                                                        "]"
                                                      ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [ _js2n__-prdslib.enum [ "nested" ] ]
                            ]
                        ]
                    ],
              disallowSpacesInsideBrackets =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "(",
                                                        ")",
                                                        "{",
                                                        "}",
                                                        "[",
                                                        "]"
                                                      ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowSpacesInsideObjectBrackets =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType '"String"
                                ],
                              _js2n__-prdslib.enum [ true, false, "all" ]
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ ")", "}", "]" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [ _js2n__-prdslib.enum [ "nested" ] ]
                            ]
                        ]
                    ],
              disallowSpacesInsideParentheses =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType '"String"
                                ],
                              _js2n__-prdslib.enum [ true, false, "all" ]
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  only =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "(",
                                                        ")",
                                                        "{",
                                                        "}",
                                                        "[",
                                                        "]",
                                                        "function"
                                                      ],
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.strings.minLength
                                                          1
                                                      ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowSpacesInsideParenthesizedExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "(",
                                                        ")",
                                                        "{",
                                                        "}",
                                                        "[",
                                                        "]",
                                                        "function"
                                                      ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              disallowSpacesInsideTemplateStringPlaceholders =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              disallowTabs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              disallowTrailingComma =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              disallowTrailingWhitespace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType '"String"
                                ],
                              _js2n__-prdslib.enum
                                [ true, false, "ignoreEmptyLines" ]
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              disallowUnusedParams =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              disallowVar =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                    ],
              disallowYodaConditions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/equalityOperators!predicate"
                        ]
                    ],
              excludeFiles =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              jsDoc = _js2n__-refsenv."_js2n__-:definitions/jsDoc!predicate",
              maximumLineLength =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 1
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "value" ],
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.enum
                                                  [ "comments" ],
                                                _js2n__-prdslib.enum
                                                  [ "functionSignature" ],
                                                _js2n__-prdslib.enum
                                                  [ "regex" ],
                                                _js2n__-prdslib.enum
                                                  [ "require" ],
                                                _js2n__-prdslib.enum
                                                  [ "urlComments" ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  tabSize =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.minimum 1
                                        ],
                                  value =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.minimum 1
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              maximumNumberOfLines =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 1
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "value" ],
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.enum
                                              [ "comments" ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  value =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.minimum 1
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              preset =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "airbnb",
                          "crockford",
                          "google",
                          "grunt",
                          "idiomatic",
                          "jquery",
                          "mdcs",
                          "node-style-guide",
                          "wikimedia",
                          "wordpress",
                          "yandex"
                        ]
                    ],
              requireAlignedMultilineParams =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "firstParam" ]
                            ]
                        ]
                    ],
              requireAlignedObjectValues =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.enum [ "all" ],
                                  _js2n__-prdslib.enum [ "ignoreFunction" ],
                                  _js2n__-prdslib.enum [ "ignoreLineBreak" ]
                                ]
                            ]
                        ]
                    ],
              requireAnonymousFunctions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.enum
                                              [ "declarations" ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireArrayDestructuring =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireArrowFunctions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireBlocksOnNewline =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  includeComments =
                                    _js2n__-prdslib.isType '"Bool",
                                  minLines = _js2n__-prdslib.isType 'Integer,
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireCamelCaseOrUpperCaseIdentifiers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  allowedPrefixes =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  allowedSuffixes =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  ignoreProperties =
                                    _js2n__-prdslib.isType '"Bool",
                                  strict = _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [ _js2n__-prdslib.enum [ "ignoreProperties" ] ]
                            ]
                        ]
                    ],
              requireCapitalizedComments =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  inlined = _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireCapitalizedConstructors =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireCapitalizedConstructorsNew =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireCommaBeforeLineBreak =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireCurlyBraces =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords2!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  keywords =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireDollarBeforejQueryAssignment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType '"String"
                                ],
                              _js2n__-prdslib.enum
                                [ true, false, "ignoreProperties" ]
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireDotNotation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "keywords" ],
                                                    _js2n__-prdslib.enum
                                                      [ "snake_case" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [ _js2n__-prdslib.enum [ "except_snake_case" ] ]
                            ]
                        ]
                    ],
              requireEarlyReturn =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireEnhancedObjectLiterals =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireFunctionDeclarations =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireImportAlphabetized =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireKeywordsOnNewLine =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords!predicate"
                        ]
                    ],
              requireLineBreakAfterVariableAssignment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireLineFeedAtFileEnd =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireMatchingFunctionName =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  includeModuleExports =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireMultiLineTernary =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireMultipleVarDecl =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "require" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [ _js2n__-prdslib.enum [ "onevar" ] ]
                            ]
                        ]
                    ],
              requireNamedUnassignedFunctions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireNewlineBeforeBlockStatements =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords2!predicate"
                        ]
                    ],
              requireNumericLiterals =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireObjectDestructuring =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireObjectKeysOnNewLine =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "sameLine" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireOperatorBeforeLineBreak =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/operators!predicate"
                        ]
                    ],
              requirePaddingNewLineAfterVariableDeclaration =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requirePaddingNewLinesAfterBlocks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "inCallExpressions" ],
                                                    _js2n__-prdslib.enum
                                                      [ "inNewExpressions" ],
                                                    _js2n__-prdslib.enum
                                                      [ "inArrayExpressions" ],
                                                    _js2n__-prdslib.enum
                                                      [ "inProperties" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requirePaddingNewLinesAfterUseStrict =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "require" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requirePaddingNewLinesBeforeExport =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requirePaddingNewLinesBeforeLineComments =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "firstAfterCurly" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requirePaddingNewLinesInObjects =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requirePaddingNewlinesBeforeKeywords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords2!predicate"
                        ]
                    ],
              requirePaddingNewlinesInBlocks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "conditionals" ],
                                                    _js2n__-prdslib.enum
                                                      [ "functions" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  close = _js2n__-prdslib.isType '"Bool",
                                  open = _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireParenthesesAroundArrowParam =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireParenthesesAroundIIFE =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireQuotedKeysInObjects =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireSemicolons =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireShorthandArrowFunctions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireSpaceAfterBinaryOperators =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/operators!predicate"
                        ]
                    ],
              requireSpaceAfterComma =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "trailing" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireSpaceAfterKeywords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/keywords2!predicate"
                        ]
                    ],
              requireSpaceAfterLineComment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [ _js2n__-prdslib.enum [ "allowSlash" ] ]
                            ]
                        ]
                    ],
              requireSpaceAfterObjectKeys =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireSpaceAfterPrefixUnaryOperators =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/unaryOperators!predicate"
                        ]
                    ],
              requireSpaceBeforeBinaryOperators =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/operators!predicate"
                        ]
                    ],
              requireSpaceBeforeBlockStatements =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Integer
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 1
                            ]
                        ]
                    ],
              requireSpaceBeforeComma =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireSpaceBeforeKeywords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/blockKeywords!predicate",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireSpaceBeforeObjectValues =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireSpaceBeforePostfixUnaryOperators =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/unaryOperators!predicate"
                        ]
                    ],
              requireSpaceBetweenArguments =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireSpacesInAnonymousFunctionExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType '"Bool",
                                              _js2n__-prdslib.isType 'Null,
                                              _js2n__-prdslib.isType '"Array"
                                            ],
                                          _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.isType '"Bool",
                                              _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.oneOf
                                                          [
                                                            _js2n__-prdslib.enum
                                                              [ "shorthand" ]
                                                          ]
                                                      ]),
                                                  _js2n__-prdslib.arrays.minItems
                                                    0,
                                                  _js2n__-prdslib.arrays.uniqueItems
                                                ]
                                            ]
                                        ],
                                  beforeOpeningCurlyBrace =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                  beforeOpeningRoundBrace =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireSpacesInCallExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireSpacesInConditionalExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  afterConsequent =
                                    _js2n__-prdslib.isType '"Bool",
                                  afterTest = _js2n__-prdslib.isType '"Bool",
                                  beforeAlternate =
                                    _js2n__-prdslib.isType '"Bool",
                                  beforeConsequent =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireSpacesInForStatement =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireSpacesInFunction =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/braceRules!predicate"
                        ]
                    ],
              requireSpacesInFunctionDeclaration =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/braceRules!predicate"
                        ]
                    ],
              requireSpacesInFunctionExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/braceRules!predicate"
                        ]
                    ],
              requireSpacesInGenerator =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  afterStar = _js2n__-prdslib.isType '"Bool",
                                  beforeStar = _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireSpacesInNamedFunctionExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/braceRules!predicate"
                        ]
                    ],
              requireSpacesInsideArrayBrackets =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "{", "}", "[", "]" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.enum [ "all" ],
                                  _js2n__-prdslib.enum [ "allButNested" ]
                                ]
                            ]
                        ]
                    ],
              requireSpacesInsideBrackets =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "{", "}", "[", "]" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireSpacesInsideObjectBrackets =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "(",
                                                        ")",
                                                        "{",
                                                        "}",
                                                        "[",
                                                        "]"
                                                      ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.enum [ "all" ],
                                  _js2n__-prdslib.enum [ "allButNested" ]
                                ]
                            ]
                        ]
                    ],
              requireSpacesInsideParentheses =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  all = _js2n__-prdslib.isType '"Bool",
                                  except =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "(",
                                                        ")",
                                                        "{",
                                                        "}",
                                                        "[",
                                                        "]"
                                                      ],
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.strings.maxLength
                                                          1
                                                      ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  ignoreParenthesizedExpression =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.enum [ "all" ],
                                  _js2n__-prdslib.enum [ "allButNested" ]
                                ]
                            ]
                        ]
                    ],
              requireSpacesInsideParenthesizedExpression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "{", "}", "function" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireSpread =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireTemplateStrings =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "stringConcatenation" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireTrailingComma =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  ignoreSingleLine =
                                    _js2n__-prdslib.isType '"Bool",
                                  ignoreSingleValue =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              requireVarDeclFirst =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              requireYodaConditions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/equalityOperators!predicate",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate"
                        ]
                    ],
              safeContextKeyword =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ]),
                              _js2n__-prdslib.arrays.minItems 0,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ]
                    ],
              validateAlignedFunctionParameters =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  lineBreakAfterOpeningBrace =
                                    _js2n__-prdslib.isType '"Bool",
                                  lineBreakBeforeClosingBrace =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              validateCommentPosition =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  position =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "above", "beside" ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              validateIndentation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "value" ],
                              _js2n__-prdslib.records.record
                                {
                                  allExcept =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.enum
                                                      [ "comments" ],
                                                    _js2n__-prdslib.enum
                                                      [ "emptyLines" ]
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 0,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  includeEmptyLines =
                                    _js2n__-prdslib.isType '"Bool",
                                  value =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              validateLineBreaks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  character =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "CR", "LF", "CRLF" ]
                                        ],
                                  reportOncePerFile =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "CR", "LF", "CRLF" ]
                            ]
                        ]
                    ],
              validateNewlineAfterArrayElements =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  ignoreBrackets =
                                    _js2n__-prdslib.isType '"Bool",
                                  maximum =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ]
                    ],
              validateOrderInObjectKeys =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.enum [ "asc" ],
                                  _js2n__-prdslib.enum [ "asc-insensitive" ],
                                  _js2n__-prdslib.enum [ "asc-natural" ],
                                  _js2n__-prdslib.enum [ "desc" ],
                                  _js2n__-prdslib.enum [ "desc-insensitive" ],
                                  _js2n__-prdslib.enum [ "desc-natural" ]
                                ]
                            ]
                        ]
                    ],
              validateParameterSeparator =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.enum [ "," ],
                                  _js2n__-prdslib.enum [ ", " ],
                                  _js2n__-prdslib.enum [ " ," ],
                                  _js2n__-prdslib.enum [ " , " ]
                                ]
                            ]
                        ]
                    ],
              validateQuoteMarks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/nullRule!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "value" ],
                              _js2n__-prdslib.records.record
                                {
                                  escape = _js2n__-prdslib.isType '"Bool",
                                  ignoreJSX = _js2n__-prdslib.isType '"Bool",
                                  mark =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.enum [ "" ],
                                              _js2n__-prdslib.enum [ "" ]
                                            ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.enum [ "\"" ],
                                  _js2n__-prdslib.enum [ "'" ]
                                ]
                            ]
                        ]
                    ],
            } {} true _js2n__-prdslib.always
        ])