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
      "_js2n__-:definitions/rule!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.enum [ "on", "off" ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.items
                      [
                        _js2n__-prdslib.enum [ "on", "off" ],
                        _js2n__-prdslib.isType 'Record
                      ],
                    _js2n__-prdslib.arrays.additionalItems _js2n__-prdslib.never
                      2,
                    _js2n__-prdslib.arrays.minItems 2
                  ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.items
                      [
                        _js2n__-prdslib.enum [ "on", "off" ],
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType 'Record
                      ],
                    _js2n__-prdslib.arrays.additionalItems _js2n__-prdslib.never
                      3,
                    _js2n__-prdslib.arrays.minItems 3
                  ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.items
                      [
                        _js2n__-prdslib.enum [ "on", "off" ],
                        _js2n__-prdslib.isType '"String"
                      ],
                    _js2n__-prdslib.arrays.additionalItems _js2n__-prdslib.never
                      2,
                    _js2n__-prdslib.arrays.minItems 2
                  ]
              ]),
      "_js2n__-:definitions/rule!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.enum [ "on", "off" ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.items
                    [
                      _js2n__-prdslib.enum [ "on", "off" ],
                      _js2n__-prdslib.isType 'Record
                    ],
                  _js2n__-prdslib.arrays.additionalItems _js2n__-prdslib.never
                    2,
                  _js2n__-prdslib.arrays.minItems 2
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.items
                    [
                      _js2n__-prdslib.enum [ "on", "off" ],
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType 'Record
                    ],
                  _js2n__-prdslib.arrays.additionalItems _js2n__-prdslib.never
                    3,
                  _js2n__-prdslib.arrays.minItems 3
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.items
                    [
                      _js2n__-prdslib.enum [ "on", "off" ],
                      _js2n__-prdslib.isType '"String"
                    ],
                  _js2n__-prdslib.arrays.additionalItems _js2n__-prdslib.never
                    2,
                  _js2n__-prdslib.arrays.minItems 2
                ]
            ],
      "_js2n__-:definitions/rules!contract"
        | doc "🐊Putout comes with a large number of rules. You can modify which rules your project uses."
        = {
            add-return-await
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-at
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-await-import
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-destructuring
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-early-return
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-montag
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-nullish-coalescing
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-numeric-separators
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-optional-chaining
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-shorthand-properties
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-try-catch
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            apply-utility-types
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            browserlist
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            cloudcmd
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            conditions
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/apply-comparison-order"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/apply-if"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/convert-comparison-to-boolean"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/convert-equal-to-strict-equal"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/evaluate"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/merge-if-statements"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/remove-boolean"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/remove-constant"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/remove-useless-else"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "conditions/simplify"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-apply-to-spread
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-arguments-to-rest
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-array-copy-to-slice
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-assignment-to-arrow-function
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-assignment-to-comparison
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-bitwise-to-logical
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-concat-to-flat
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-index-of-to-includes
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-is-nan-to-number-is-nan
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-math-pow
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-mock-require-to-mock-import
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-object-assign-to-merge-spread
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-quotes-to-backticks
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-spread-to-array-from
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-template-to-string
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-throw
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            convert-to-arrow-function
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            declare
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            eslint
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            extract-object-properties
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            extract-sequence-expressions
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "for-of/for"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "for-of/for-each"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "for-of/for-in"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "for-of/map"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "for-of/remove-unused-variables"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "for-of/remove-useless"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "for-of/remove-useless-array-from"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            github
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            gitignore
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            jest
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            madrun
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            maybe
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            merge-destructuring-properties
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            merge-duplicate-imports
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            nodejs
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/add-missing-strict-mode"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/cjs-file"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/convert-commonjs-to-esm"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/convert-dirname-to-url"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/convert-esm-to-commonjs"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/convert-fs-promises"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/convert-promisify-to-fs-promises"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/convert-top-level-return"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/mjs-file"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/remove-process-exit"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/remove-useless-strict-mode"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "nodejs/rename-file-mjs-to-js"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            npmignore
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            package-json
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            postcss
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            promises
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "promises/add-missing-await"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "promises/apply-top-level-await"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "promises/convert-new-promise-to-async"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "promises/convert-reject-to-throw"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "promises/remove-useless-async"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "promises/remove-useless-await"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "promises/remove-useless-resolve"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            putout
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            putout-config
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/add-args"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/add-index-to-import"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/add-push"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/apply-async-formatter"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/apply-create-test"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/apply-declare"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/apply-insert-after"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/apply-insert-before"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/apply-namaspace-specifier"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/apply-processors-destructuring"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/apply-remove"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/check-match"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/check-replace-code"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-add-argument-to-add-args"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-babel-types"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-destructuring-to-identifier"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-dirname-to-url"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-find-to-traverse"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-get-rule-to-require"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-match-to-function"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-method-to-property"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-node-to-path-in-get-template-values"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-number-to-numeric"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-process-to-find"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-putout-test-to-create-test"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-replace-to-function"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-replace-with"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-replace-with-multiple"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-report-to-function"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-to-no-transform-code"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-traverse-to-include"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-traverse-to-replace"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/convert-url-to-dirname"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/create-test"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/declare"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/includer"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/insert-rust"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/move-require-on-top-level"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/rename-operate-to-operator"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/replace-operate-with-operator"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/replace-test-message"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "putout/shorten-imports"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            react-hooks
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            regexp
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-boolean-from-assertions
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-boolean-from-logical-expressions
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-console
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-debugger
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-duplicate-case
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-duplicate-interface-keys
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-duplicate-keys
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-duplicates-from-logical-expressions
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-duplicates-from-union
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-empty
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "remove-empty/argument"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "remove-empty/block"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "remove-empty/export"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "remove-empty/import"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "remove-empty/pattern"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-iife
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-nested-blocks
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-unreachable-code
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-unreferenced-variables
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-unused-expressions
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-unused-private-fields
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-unused-types
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-unused-variables
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-arguments
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-array
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-array-constructor
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-array-entries
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-constructor
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-continue
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-escape
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-functions
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-map
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-new
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-operand
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-return
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-spread
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-template-expressions
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-templates
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-type-conversion
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-types-from-constants
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            remove-useless-variables
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            reuse-duplicate-init
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            simplify-assignment
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            simplify-logical-expressions
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            simplify-ternary
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            split-nested-destructuring
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            split-variable-declarations
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            tape
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "tape/remove-only"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "tape/remove-skip"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            travis
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            types
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "types/apply-is-array"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "types/convert-typeof-to-is-type"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "types/remove-double-negations"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "types/remove-useless-conversion"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "types/remove-useless-typeof"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            typescript
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/apply-as-type-assertion"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/apply-utility-types"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/convert-generic-to-shorthand"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/remove-duplicate-interface-keys"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/remove-duplicates-from-union"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/remove-unused-types"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/remove-useless-mapped-types"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/remove-useless-mapping-modifiers"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/remove-useless-types"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            "typescript/remove-useless-types-from-constants"
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            webpack
              | _js2n__-refsenv."_js2n__-:definitions/rule!contract"
              | optional,
            ..
          },
      "_js2n__-:definitions/rules!predicate"
        | doc "🐊Putout comes with a large number of rules. You can modify which rules your project uses."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  add-return-await =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-at =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-await-import =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-destructuring =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-early-return =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-montag =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-nullish-coalescing =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-numeric-separators =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-optional-chaining =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-shorthand-properties =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-try-catch =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  apply-utility-types =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  browserlist =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  cloudcmd =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  conditions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/apply-comparison-order" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/apply-if" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/convert-comparison-to-boolean" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/convert-equal-to-strict-equal" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/evaluate" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/merge-if-statements" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/remove-boolean" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/remove-constant" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/remove-useless-else" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "conditions/simplify" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-apply-to-spread =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-arguments-to-rest =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-array-copy-to-slice =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-assignment-to-arrow-function =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-assignment-to-comparison =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-bitwise-to-logical =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-concat-to-flat =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-index-of-to-includes =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-is-nan-to-number-is-nan =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-math-pow =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-mock-require-to-mock-import =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-object-assign-to-merge-spread =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-quotes-to-backticks =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-spread-to-array-from =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-template-to-string =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-throw =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  convert-to-arrow-function =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  declare =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  eslint =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  extract-object-properties =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  extract-sequence-expressions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "for-of/for" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "for-of/for-each" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "for-of/for-in" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "for-of/map" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "for-of/remove-unused-variables" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "for-of/remove-useless" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "for-of/remove-useless-array-from" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  github =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  gitignore =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  jest = _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  madrun =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  maybe = _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  merge-destructuring-properties =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  merge-duplicate-imports =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  nodejs =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/add-missing-strict-mode" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/cjs-file" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/convert-commonjs-to-esm" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/convert-dirname-to-url" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/convert-esm-to-commonjs" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/convert-fs-promises" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/convert-promisify-to-fs-promises" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/convert-top-level-return" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/mjs-file" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/remove-process-exit" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/remove-useless-strict-mode" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "nodejs/rename-file-mjs-to-js" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  npmignore =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  package-json =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  postcss =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  promises =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "promises/add-missing-await" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "promises/apply-top-level-await" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "promises/convert-new-promise-to-async" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "promises/convert-reject-to-throw" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "promises/remove-useless-async" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "promises/remove-useless-await" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "promises/remove-useless-resolve" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  putout =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  putout-config =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/add-args" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/add-index-to-import" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/add-push" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/apply-async-formatter" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/apply-create-test" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/apply-declare" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/apply-insert-after" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/apply-insert-before" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/apply-namaspace-specifier" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/apply-processors-destructuring" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/apply-remove" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/check-match" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/check-replace-code" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-add-argument-to-add-args" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-babel-types" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-destructuring-to-identifier" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-dirname-to-url" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-find-to-traverse" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-get-rule-to-require" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-match-to-function" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-method-to-property" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-node-to-path-in-get-template-values" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-number-to-numeric" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-process-to-find" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-putout-test-to-create-test" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-replace-to-function" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-replace-with" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-replace-with-multiple" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-report-to-function" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-to-no-transform-code" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-traverse-to-include" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-traverse-to-replace" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/convert-url-to-dirname" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/create-test" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/declare" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/includer" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/insert-rust" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/move-require-on-top-level" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/rename-operate-to-operator" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/replace-operate-with-operator" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/replace-test-message" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "putout/shorten-imports" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  react-hooks =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  regexp =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-boolean-from-assertions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-boolean-from-logical-expressions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-console =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-debugger =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-duplicate-case =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-duplicate-interface-keys =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-duplicate-keys =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-duplicates-from-logical-expressions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-duplicates-from-union =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-empty =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "remove-empty/argument" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "remove-empty/block" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "remove-empty/export" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "remove-empty/import" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "remove-empty/pattern" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-iife =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-nested-blocks =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-unreachable-code =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-unreferenced-variables =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-unused-expressions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-unused-private-fields =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-unused-types =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-unused-variables =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-arguments =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-array =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-array-constructor =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-array-entries =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-constructor =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-continue =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-escape =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-functions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-map =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-new =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-operand =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-return =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-spread =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-template-expressions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-templates =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-type-conversion =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-types-from-constants =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  remove-useless-variables =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  reuse-duplicate-init =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  simplify-assignment =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  simplify-logical-expressions =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  simplify-ternary =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  split-nested-destructuring =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  split-variable-declarations =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  tape = _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "tape/remove-only" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "tape/remove-skip" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  travis =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  types = _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "types/apply-is-array" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "types/convert-typeof-to-is-type" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "types/remove-double-negations" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "types/remove-useless-conversion" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "types/remove-useless-typeof" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  typescript =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/apply-as-type-assertion" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/apply-utility-types" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/convert-generic-to-shorthand" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/remove-duplicate-interface-keys" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/remove-duplicates-from-union" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/remove-unused-types" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/remove-useless-mapped-types" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/remove-useless-mapping-modifiers" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/remove-useless-types" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  "typescript/remove-useless-types-from-constants" =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                  webpack =
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      formatter
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Array"
            ])
        | doc "Choose the way to show information about errors found"
        | optional,
      ignore
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Tell 🐊Putout to ignore specific files and directories."
        | optional,
      "match"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^.*$" =
                    _js2n__-refsenv."_js2n__-:definitions/rules!predicate",
                  additionalProperties = _js2n__-prdslib.never,
                } true _js2n__-prdslib.always
            ])
        | doc "Allows to match rules for files and folders, specified by glob patterns."
        | optional,
      parser | String | doc "Tell 🐊Putout which parser to use" | optional,
      plugins
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Tell 🐊Putout which plugins to load"
        | optional,
      printer
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.items
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType 'Record
                    ],
                  _js2n__-prdslib.arrays.maxItems 2,
                  _js2n__-prdslib.arrays.minItems 2
                ]
            ])
        | doc "Tell 🐊Putout which printer to use"
        | optional,
      processors
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Tell 🐊Putout which processors to use to support file types other then JavaScript"
        | optional,
      rules | _js2n__-refsenv."_js2n__-:definitions/rules!contract" | optional,
    }