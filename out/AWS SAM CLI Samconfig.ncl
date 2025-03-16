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
    = {}
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.required [ "version" ],
          _js2n__-prdslib.records.record
            { version = _js2n__-prdslib.isType '"Number", }
            {
              "^.+$" =
                _js2n__-prdslib.records.record
                    {
                      build =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              base_dir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              build_dir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              build_image =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              build_in_source =
                                                _js2n__-prdslib.isType '"Bool",
                                              cache_dir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              cached =
                                                _js2n__-prdslib.isType '"Bool",
                                              container_env_var =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              container_env_var_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              docker_network =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              exclude =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              hook_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              manifest =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              mount_symlinks =
                                                _js2n__-prdslib.isType '"Bool",
                                              mount_with =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "READ", "WRITE" ]
                                                    ],
                                              parallel =
                                                _js2n__-prdslib.isType '"Bool",
                                              parameter_overrides =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              skip_prepare_infra =
                                                _js2n__-prdslib.isType '"Bool",
                                              skip_pull_image =
                                                _js2n__-prdslib.isType '"Bool",
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              terraform_project_root_path =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              use_container =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      delete =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              no_prompts =
                                                _js2n__-prdslib.isType '"Bool",
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              s3_bucket =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              s3_prefix =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              stack_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      deploy =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              capabilities =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              confirm_changeset =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              disable_rollback =
                                                _js2n__-prdslib.isType '"Bool",
                                              fail_on_empty_changeset =
                                                _js2n__-prdslib.isType '"Bool",
                                              force_upload =
                                                _js2n__-prdslib.isType '"Bool",
                                              guided =
                                                _js2n__-prdslib.isType '"Bool",
                                              image_repositories =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              image_repository =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              kms_key_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              max_wait_duration =
                                                _js2n__-prdslib.isType 'Integer,
                                              metadata =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              no_execute_changeset =
                                                _js2n__-prdslib.isType '"Bool",
                                              no_progressbar =
                                                _js2n__-prdslib.isType '"Bool",
                                              notification_arns =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              on_failure =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "DELETE",
                                                          "DO_NOTHING",
                                                          "ROLLBACK"
                                                        ]
                                                    ],
                                              parameter_overrides =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              resolve_image_repos =
                                                _js2n__-prdslib.isType '"Bool",
                                              resolve_s3 =
                                                _js2n__-prdslib.isType '"Bool",
                                              role_arn =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              s3_bucket =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              s3_prefix =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              signing_profiles =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              stack_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              tags =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              use_json =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      docs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                { parameters = _js2n__-prdslib.isType 'Record, }
                                {} true _js2n__-prdslib.always
                            ],
                      init =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              app_template =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              application_insights =
                                                _js2n__-prdslib.isType '"Bool",
                                              architecture =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "arm64", "x86_64" ]
                                                    ],
                                              base_image =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "amazon/dotnet6-base",
                                                          "amazon/dotnet8-base",
                                                          "amazon/go-provided.al2-base",
                                                          "amazon/go-provided.al2023-base",
                                                          "amazon/go1.x-base",
                                                          "amazon/java11-base",
                                                          "amazon/java17-base",
                                                          "amazon/java21-base",
                                                          "amazon/java8.al2-base",
                                                          "amazon/nodejs16.x-base",
                                                          "amazon/nodejs18.x-base",
                                                          "amazon/nodejs20.x-base",
                                                          "amazon/nodejs22.x-base",
                                                          "amazon/python3.10-base",
                                                          "amazon/python3.11-base",
                                                          "amazon/python3.12-base",
                                                          "amazon/python3.13-base",
                                                          "amazon/python3.8-base",
                                                          "amazon/python3.9-base",
                                                          "amazon/ruby3.2-base",
                                                          "amazon/ruby3.3-base"
                                                        ]
                                                    ],
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              dependency_manager =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "bundler",
                                                          "cli-package",
                                                          "gradle",
                                                          "maven",
                                                          "mod",
                                                          "npm",
                                                          "pip"
                                                        ]
                                                    ],
                                              extra_context =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              location =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              no_input =
                                                _js2n__-prdslib.isType '"Bool",
                                              no_interactive =
                                                _js2n__-prdslib.isType '"Bool",
                                              output_dir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              package_type =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "Image", "Zip" ]
                                                    ],
                                              runtime =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "dotnet6",
                                                          "dotnet8",
                                                          "go1.x",
                                                          "java11",
                                                          "java17",
                                                          "java21",
                                                          "java8.al2",
                                                          "nodejs16.x",
                                                          "nodejs18.x",
                                                          "nodejs20.x",
                                                          "nodejs22.x",
                                                          "provided",
                                                          "provided.al2",
                                                          "provided.al2023",
                                                          "python3.10",
                                                          "python3.11",
                                                          "python3.12",
                                                          "python3.13",
                                                          "python3.8",
                                                          "python3.9",
                                                          "ruby3.2",
                                                          "ruby3.3"
                                                        ]
                                                    ],
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              structured_logging =
                                                _js2n__-prdslib.isType '"Bool",
                                              tracing =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      list_endpoints =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              output =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "json", "table" ]
                                                    ],
                                              parameter_overrides =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              stack_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      list_resources =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              output =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "json", "table" ]
                                                    ],
                                              parameter_overrides =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              stack_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      list_stack_outputs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              output =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "json", "table" ]
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              stack_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      local_generate_event =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                { parameters = _js2n__-prdslib.isType 'Record, }
                                {} true _js2n__-prdslib.always
                            ],
                      local_invoke =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              add_host =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              container_env_vars =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              container_host =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              container_host_interface =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug_args =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug_port =
                                                _js2n__-prdslib.isType 'Integer,
                                              debugger_path =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              docker_network =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              docker_volume_basedir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              env_vars =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              event =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              force_image_build =
                                                _js2n__-prdslib.isType '"Bool",
                                              hook_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              invoke_image =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              layer_cache_basedir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              log_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              mount_symlinks =
                                                _js2n__-prdslib.isType '"Bool",
                                              no_event =
                                                _js2n__-prdslib.isType '"Bool",
                                              no_memory_limit =
                                                _js2n__-prdslib.isType '"Bool",
                                              parameter_overrides =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              runtime =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "dotnet6",
                                                          "dotnet8",
                                                          "go1.x",
                                                          "java11",
                                                          "java17",
                                                          "java21",
                                                          "java8.al2",
                                                          "nodejs16.x",
                                                          "nodejs18.x",
                                                          "nodejs20.x",
                                                          "nodejs22.x",
                                                          "provided",
                                                          "provided.al2",
                                                          "provided.al2023",
                                                          "python3.10",
                                                          "python3.11",
                                                          "python3.12",
                                                          "python3.13",
                                                          "python3.8",
                                                          "python3.9",
                                                          "ruby3.2",
                                                          "ruby3.3"
                                                        ]
                                                    ],
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              shutdown =
                                                _js2n__-prdslib.isType '"Bool",
                                              skip_prepare_infra =
                                                _js2n__-prdslib.isType '"Bool",
                                              skip_pull_image =
                                                _js2n__-prdslib.isType '"Bool",
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              terraform_plan_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      local_start_api =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              add_host =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              container_env_vars =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              container_host =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              container_host_interface =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug_args =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug_function =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug_port =
                                                _js2n__-prdslib.isType 'Integer,
                                              debugger_path =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              disable_authorizer =
                                                _js2n__-prdslib.isType '"Bool",
                                              docker_network =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              docker_volume_basedir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              env_vars =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              force_image_build =
                                                _js2n__-prdslib.isType '"Bool",
                                              hook_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              host =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              invoke_image =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              layer_cache_basedir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              log_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              no_memory_limit =
                                                _js2n__-prdslib.isType '"Bool",
                                              parameter_overrides =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              port =
                                                _js2n__-prdslib.isType 'Integer,
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              shutdown =
                                                _js2n__-prdslib.isType '"Bool",
                                              skip_prepare_infra =
                                                _js2n__-prdslib.isType '"Bool",
                                              skip_pull_image =
                                                _js2n__-prdslib.isType '"Bool",
                                              ssl_cert_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              ssl_key_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              static_dir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              terraform_plan_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              warm_containers =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "EAGER", "LAZY" ]
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      local_start_lambda =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              add_host =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              container_env_vars =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              container_host =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              container_host_interface =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug_args =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug_function =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug_port =
                                                _js2n__-prdslib.isType 'Integer,
                                              debugger_path =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              docker_network =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              docker_volume_basedir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              env_vars =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              force_image_build =
                                                _js2n__-prdslib.isType '"Bool",
                                              hook_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              host =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              invoke_image =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              layer_cache_basedir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              log_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              no_memory_limit =
                                                _js2n__-prdslib.isType '"Bool",
                                              parameter_overrides =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              port =
                                                _js2n__-prdslib.isType 'Integer,
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              shutdown =
                                                _js2n__-prdslib.isType '"Bool",
                                              skip_prepare_infra =
                                                _js2n__-prdslib.isType '"Bool",
                                              skip_pull_image =
                                                _js2n__-prdslib.isType '"Bool",
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              terraform_plan_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              warm_containers =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "EAGER", "LAZY" ]
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      logs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              cw_log_group =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              end_time =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              filter =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              include_traces =
                                                _js2n__-prdslib.isType '"Bool",
                                              name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              output =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "json", "text" ]
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              stack_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              start_time =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              tail =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      package =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              force_upload =
                                                _js2n__-prdslib.isType '"Bool",
                                              image_repositories =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              image_repository =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              kms_key_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              metadata =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              no_progressbar =
                                                _js2n__-prdslib.isType '"Bool",
                                              output_template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              resolve_s3 =
                                                _js2n__-prdslib.isType '"Bool",
                                              s3_bucket =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              s3_prefix =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              signing_profiles =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              use_json =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      pipeline_bootstrap =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              bitbucket_repo_uuid =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              bucket =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              cicd_provider =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              cloudformation_execution_role =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              confirm_changeset =
                                                _js2n__-prdslib.isType '"Bool",
                                              create_image_repository =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              deployment_branch =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              github_org =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              github_repo =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              gitlab_group =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              gitlab_project =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              image_repository =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              interactive =
                                                _js2n__-prdslib.isType '"Bool",
                                              oidc_client_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              oidc_provider =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "bitbucket-pipelines",
                                                          "github-actions",
                                                          "gitlab"
                                                        ]
                                                    ],
                                              oidc_provider_url =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              permissions_provider =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "iam", "oidc" ]
                                                    ],
                                              pipeline_execution_role =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              pipeline_user =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              stage =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      pipeline_init =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              bootstrap =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      publish =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              fail_on_same_version =
                                                _js2n__-prdslib.isType '"Bool",
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              semantic_version =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      remote_invoke =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              event =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              event_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              output =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "json", "text" ]
                                                    ],
                                              parameter =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              stack_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              test_event_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      remote_test_event =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                { parameters = _js2n__-prdslib.isType 'Record, }
                                {} true _js2n__-prdslib.always
                            ],
                      sync =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              base_dir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              build_image =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              build_in_source =
                                                _js2n__-prdslib.isType '"Bool",
                                              capabilities =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              code =
                                                _js2n__-prdslib.isType '"Bool",
                                              container_env_var_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              dependency_layer =
                                                _js2n__-prdslib.isType '"Bool",
                                              image_repositories =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              image_repository =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              kms_key_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              metadata =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              notification_arns =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              parameter_overrides =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              resource =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "AWS::ApiGateway::RestApi",
                                                          "AWS::ApiGatewayV2::Api",
                                                          "AWS::Lambda::Function",
                                                          "AWS::Lambda::LayerVersion",
                                                          "AWS::Serverless::Api",
                                                          "AWS::Serverless::Function",
                                                          "AWS::Serverless::HttpApi",
                                                          "AWS::Serverless::LayerVersion",
                                                          "AWS::Serverless::StateMachine",
                                                          "AWS::StepFunctions::StateMachine"
                                                        ]
                                                    ],
                                              resource_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              role_arn =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              s3_bucket =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              s3_prefix =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              skip_deploy_sync =
                                                _js2n__-prdslib.isType '"Bool",
                                              stack_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              tags =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              use_container =
                                                _js2n__-prdslib.isType '"Bool",
                                              watch =
                                                _js2n__-prdslib.isType '"Bool",
                                              watch_exclude =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      traces =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              end_time =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              output =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "json", "text" ]
                                                    ],
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              start_time =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              tail =
                                                _js2n__-prdslib.isType '"Bool",
                                              trace_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      validate =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "parameters" ],
                              _js2n__-prdslib.records.record
                                {
                                  parameters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              beta_features =
                                                _js2n__-prdslib.isType '"Bool",
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              lint =
                                                _js2n__-prdslib.isType '"Bool",
                                              profile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              save_params =
                                                _js2n__-prdslib.isType '"Bool",
                                              template_file =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always,
            } false _js2n__-prdslib.never
        ])