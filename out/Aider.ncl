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
  {
      "35turbo"
        | Bool
        | doc "Use gpt-3.5-turbo model for the main chat. Default: false"
        | optional,
      "4"
        | Bool
        | doc "Use gpt-4-0613 model for the main chat. Default: false"
        | optional,
      "4-turbo"
        | Bool
        | doc "Use gpt-4-1106-preview model for the main chat. Default: false"
        | optional,
      "4o"
        | Bool
        | doc "Use gpt-4o model for the main chat. Default: false"
        | optional,
      aiderignore
        | String
        | doc "Specify the aider ignore file. Default: .aiderignore"
        | optional,
      alias | Array (String) | doc "Add a model alias. Default: []" | optional,
      analytics
        | Bool
        | doc "Enable/disable analytics for current session. Default: None"
        | optional,
      analytics-disable
        | Bool
        | doc "Permanently disable analytics. Default: false"
        | optional,
      analytics-log
        | String
        | doc "Specify a file to log analytics events. Default: None"
        | optional,
      anthropic-api-key
        | String
        | doc "Specify the Anthropic API key. Default: None"
        | optional,
      api-key
        | Array (String)
        | doc "Set an API key for a provider. Default: []"
        | optional,
      apply
        | String
        | doc "Apply the changes from the given file instead of running the chat. Default: None"
        | optional,
      apply-clipboard-edits
        | Bool
        | doc "Apply clipboard contents as edits using the main model’s editor format. Default: false"
        | optional,
      architect
        | Bool
        | doc "Use architect edit format for the main chat. Default: None"
        | optional,
      assistant-output-color
        | String
        | doc "Set the color for assistant output. Default: #0088ff"
        | optional,
      attribute-author
        | Bool
        | doc "Attribute aider code changes in the git author name. Default: None"
        | optional,
      attribute-co-authored-by
        | Bool
        | doc "Attribute aider edits using the Co-authored-by trailer in the commit message. Default: false"
        | optional,
      attribute-commit-message-author
        | Bool
        | doc "Prefix commit messages with ‘aider: ‘ if aider authored the changes. Default: false"
        | optional,
      attribute-commit-message-committer
        | Bool
        | doc "Prefix all commit messages with ‘aider: ‘. Default: false"
        | optional,
      attribute-committer
        | Bool
        | doc "Attribute aider commits in the git committer name. Default: None"
        | optional,
      auto-accept-architect
        | Bool
        | doc "Enable/disable automatic acceptance of architect changes. Default: true"
        | optional,
      auto-commits
        | Bool
        | doc "Enable/disable auto commit of LLM changes. Default: true"
        | optional,
      auto-lint
        | Bool
        | doc "Enable/disable automatic linting after changes. Default: true"
        | optional,
      auto-test
        | Bool
        | doc "Enable/disable automatic testing after changes. Default: false"
        | optional,
      cache-keepalive-pings
        | String
        | doc "Number of times to ping at 5min intervals to keep prompt cache warm. Default: 0"
        | optional,
      cache-prompts
        | Bool
        | doc "Enable caching of prompts. Default: false"
        | optional,
      chat-history-file
        | String
        | doc "Specify the chat history file. Default: .aider.chat.history.md"
        | optional,
      chat-language
        | String
        | doc "Specify the language to use in the chat. Default: None"
        | optional,
      check-model-accepts-settings
        | Bool
        | doc "Check if model accepts settings like reasoning_effort/thinking_tokens. Default: true"
        | optional,
      check-update
        | Bool
        | doc "Check for new aider versions on launch. Default: true"
        | optional,
      code-theme
        | String
        | doc "Set the markdown code theme. Default: default"
        | optional,
      commit
        | Bool
        | doc "Commit all pending changes with a suitable commit message, then exit. Default: false"
        | optional,
      commit-prompt
        | String
        | doc "Specify a custom prompt for generating commit messages. Default: None"
        | optional,
      completion-menu-bg-color
        | String
        | doc "Set the background color for the completion menu. Default: None"
        | optional,
      completion-menu-color
        | String
        | doc "Set the color for the completion menu. Default: None"
        | optional,
      completion-menu-current-bg-color
        | String
        | doc "Set the background color for the current item in the completion menu. Default: None"
        | optional,
      completion-menu-current-color
        | String
        | doc "Set the color for the current item in the completion menu. Default: None"
        | optional,
      config | String | doc "Specify the config file. Default: None" | optional,
      copy-paste
        | Bool
        | doc "Enable automatic copy/paste of chat between aider and web UI. Default: false"
        | optional,
      dark-mode
        | Bool
        | doc "Use colors suitable for a dark terminal background. Default: false"
        | optional,
      deepseek
        | Bool
        | doc "Use deepseek/deepseek-chat model for the main chat. Default: false"
        | optional,
      detect-urls
        | Bool
        | doc "Enable/disable detection and offering to add URLs to chat. Default: true"
        | optional,
      dirty-commits
        | Bool
        | doc "Enable/disable commits when repo is found dirty. Default: true"
        | optional,
      disable-playwright
        | Bool
        | doc "Never prompt for or attempt to install Playwright for web scraping. Default: false"
        | optional,
      dry-run
        | Bool
        | doc "Perform a dry run without modifying files. Default: false"
        | optional,
      edit-format
        | String
        | doc "Specify what edit format the LLM should use. Default: None"
        | optional,
      editor
        | String
        | doc "Specify which editor to use for the /editor command. Default: None"
        | optional,
      editor-edit-format
        | String
        | doc "Specify the edit format for the editor model. Default: None"
        | optional,
      editor-model
        | String
        | doc "Specify the model to use for editor tasks. Default: None"
        | optional,
      encoding
        | String
        | doc "Specify the encoding for input and output. Default: utf-8"
        | optional,
      env-file
        | String
        | doc "Specify the .env file to load. Default: .env"
        | optional,
      exit
        | Bool
        | doc "Do all startup activities then exit before accepting user input. Default: false"
        | optional,
      fancy-input
        | Bool
        | doc "Enable/disable fancy input with history and completion. Default: true"
        | optional,
      file
        | Array (String)
        | doc "Specify a file to edit. Default: []"
        | optional,
      git
        | Bool
        | doc "Enable/disable looking for a git repo. Default: true"
        | optional,
      git-commit-verify
        | Bool
        | doc "Enable/disable git pre-commit hooks with –no-verify. Default: false"
        | optional,
      gitignore
        | Bool
        | doc "Enable/disable adding .aider* to .gitignore. Default: true"
        | optional,
      gui | Bool | doc "Run aider in your browser. Default: false" | optional,
      haiku
        | Bool
        | doc "Use claude-3-5-haiku-20241022 model for the main chat. Default: false"
        | optional,
      input-history-file
        | String
        | doc "Specify the chat input history file. Default: .aider.input.history"
        | optional,
      install-main-branch
        | Bool
        | doc "Install the latest version from the main branch. Default: false"
        | optional,
      just-check-update
        | Bool
        | doc "Check for updates and return status in the exit code. Default: false"
        | optional,
      light-mode
        | Bool
        | doc "Use colors suitable for a light terminal background. Default: false"
        | optional,
      line-endings
        | String
        | doc "Line endings to use when writing files. Default: platform"
        | optional,
      lint
        | Bool
        | doc "Lint and fix provided files, or dirty files if none provided. Default: false"
        | optional,
      lint-cmd
        | Array (String)
        | doc "Specify lint commands to run for different languages. Default: []"
        | optional,
      list-models
        | String
        | doc "List known models which match the (partial) MODEL name. Default: None"
        | optional,
      llm-history-file
        | String
        | doc "Log the conversation with the LLM to this file. Default: None"
        | optional,
      load
        | String
        | doc "Load and execute /commands from a file on launch. Default: None"
        | optional,
      map-multiplier-no-files
        | String
        | doc "Multiplier for map tokens when no files are specified. Default: 2"
        | optional,
      map-refresh
        | String
        | doc "Control how often the repo map is refreshed. Default: auto"
        | optional,
      map-tokens
        | String
        | doc "Suggested number of tokens to use for repo map. Default: None"
        | optional,
      max-chat-history-tokens
        | String
        | doc "Soft limit on tokens for chat history, after which summarization begins. Default: None"
        | optional,
      message
        | String
        | doc "Specify a single message to send the LLM, process reply then exit. Default: None"
        | optional,
      message-file
        | String
        | doc "Specify a file containing the message to send the LLM, process reply, then exit. Default: None"
        | optional,
      mini
        | Bool
        | doc "Use gpt-4o-mini model for the main chat. Default: false"
        | optional,
      model
        | String
        | doc "Specify the model to use for the main chat. Default: None"
        | optional,
      model-metadata-file
        | String
        | doc "Specify a file with context window and costs for unknown models. Default: .aider.model.metadata.json"
        | optional,
      model-settings-file
        | String
        | doc "Specify a file with aider model settings for unknown models. Default: .aider.model.settings.yml"
        | optional,
      multiline
        | Bool
        | doc "Enable/disable multi-line input mode with Meta-Enter to submit. Default: false"
        | optional,
      notifications
        | Bool
        | doc "Enable/disable terminal bell notifications when LLM responses are ready. Default: false"
        | optional,
      notifications-command
        | String
        | doc "Specify a command to run for notifications instead of the terminal bell. Default: None"
        | optional,
      o1-mini
        | Bool
        | doc "Use o1-mini model for the main chat. Default: false"
        | optional,
      o1-preview
        | Bool
        | doc "Use o1-preview model for the main chat. Default: false"
        | optional,
      openai-api-base
        | String
        | doc "Specify the api base url. Default: None"
        | optional,
      openai-api-deployment-id
        | String
        | doc "Specify the OpenAI API deployment ID. Default: None"
        | optional,
      openai-api-key
        | String
        | doc "Specify the OpenAI API key. Default: None"
        | optional,
      openai-api-type
        | String
        | doc "Specify the OpenAI API type. Default: None"
        | optional,
      openai-api-version
        | String
        | doc "Specify the OpenAI API version. Default: None"
        | optional,
      openai-organization-id
        | String
        | doc "Specify the OpenAI organization ID. Default: None"
        | optional,
      opus
        | Bool
        | doc "Use claude-3-opus-20240229 model for the main chat. Default: false"
        | optional,
      pretty
        | Bool
        | doc "Enable/disable pretty, colorized output. Default: true"
        | optional,
      read
        | Array (String)
        | doc "Specify a read-only file. Default: []"
        | optional,
      reasoning-effort
        | String
        | doc "Set the reasoning_effort API parameter. Default: None"
        | optional,
      restore-chat-history
        | Bool
        | doc "Restore the previous chat history messages. Default: false"
        | optional,
      set-env
        | Array (String)
        | doc "Set environment variables. Default: []"
        | optional,
      show-diffs
        | Bool
        | doc "Show diffs when committing changes. Default: false"
        | optional,
      show-model-warnings
        | Bool
        | doc "Only work with models that have meta-data available. Default: true"
        | optional,
      show-prompts
        | Bool
        | doc "Print the system prompts and exit. Default: false"
        | optional,
      show-release-notes
        | Bool
        | doc "Show release notes on first run of new version. Default: None"
        | optional,
      show-repo-map
        | Bool
        | doc "Print the repo map and exit. Default: false"
        | optional,
      skip-sanity-check-repo
        | Bool
        | doc "Skip the sanity check for the git repository. Default: false"
        | optional,
      sonnet
        | Bool
        | doc "Use anthropic/claude-3-7-sonnet-20250219 model for the main chat. Default: false"
        | optional,
      stream
        | Bool
        | doc "Enable/disable streaming responses. Default: true"
        | optional,
      subtree-only
        | Bool
        | doc "Only consider files in the current subtree of the git repository. Default: false"
        | optional,
      suggest-shell-commands
        | Bool
        | doc "Enable/disable suggesting shell commands. Default: true"
        | optional,
      test
        | Bool
        | doc "Run tests, fix problems found and then exit. Default: false"
        | optional,
      test-cmd
        | Array (String)
        | doc "Specify command to run tests. Default: []"
        | optional,
      thinking-tokens
        | String
        | doc "Set the thinking token budget for models that support it. Default: None"
        | optional,
      timeout
        | String
        | doc "Timeout in seconds for API calls. Default: None"
        | optional,
      tool-error-color
        | String
        | doc "Set the color for tool error messages. Default: #FF2222"
        | optional,
      tool-output-color
        | String
        | doc "Set the color for tool output. Default: None"
        | optional,
      tool-warning-color
        | String
        | doc "Set the color for tool warning messages. Default: #FFA500"
        | optional,
      upgrade
        | Bool
        | doc "Upgrade aider to the latest version from PyPI. Default: false"
        | optional,
      user-input-color
        | String
        | doc "Set the color for user input. Default: #00cc00"
        | optional,
      verbose | Bool | doc "Enable verbose output. Default: false" | optional,
      verify-ssl
        | Bool
        | doc "Verify the SSL cert when connecting to models. Default: true"
        | optional,
      version
        | Bool
        | doc "Show the version number and exit. Default: None"
        | optional,
      vim
        | Bool
        | doc "Use VI editing mode in the terminal. Default: false"
        | optional,
      voice-format
        | String
        | doc "Audio format for voice recording. Default: wav"
        | optional,
      voice-input-device
        | String
        | doc "Specify the input device name for voice recording. Default: None"
        | optional,
      voice-language
        | String
        | doc "Specify the language for voice using ISO 639-1 code. Default: en"
        | optional,
      watch-files
        | Bool
        | doc "Enable/disable watching files for ai coding comments. Default: false"
        | optional,
      weak-model
        | String
        | doc "Specify the model to use for commit messages and chat history summarization. Default: None"
        | optional,
      yes-always
        | Bool
        | doc "Always say yes to every confirmation. Default: None"
        | optional,
      ..
    }