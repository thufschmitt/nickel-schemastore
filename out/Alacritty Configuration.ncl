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
      "_js2n__-:definitions/Alacritty.Command!contract" =
        { args | Array (String) | optional, program | String | optional, },
      "_js2n__-:definitions/Alacritty.Command!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  program = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Alacritty.Cursor.Style!contract"
        | doc "Cursor Style"
        = {
            blinking
              | std.enum.TagOrString
              | [| 'Always, 'On, 'Off, 'Never |]
              | doc m%"
                # Cursor blinking state
                
                 Values for `blinking`:
                   - Never: Prevent the cursor from ever blinking
                   - Off: Disable blinking by default
                   - On: Enable blinking by default
                   - Always: Force the cursor to always blink
              "%
              | optional,
            shape
              | std.enum.TagOrString
              | [| 'Underline, 'Beam, 'Block |]
              | doc m%"
                Cursor shape
                
                 Values for `shape`:
                   - ▇ Block
                   - _ Underline
                   - | Beam
              "%
              | optional,
          },
      "_js2n__-:definitions/Alacritty.Cursor.Style!predicate"
        | doc "Cursor Style"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  blinking =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Never", "Off", "On", "Always" ]
                        ],
                  shape =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Block", "Beam", "Underline" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Alacritty.KeyBindings.Action!predicate"
        | doc m%"
          Execute a predefined action
             - ToggleViMode
             - SearchForward
                 Start searching toward the right of the search origin.
             - SearchBackward
                 Start searching toward the left of the search origin.
             - Copy
             - Paste
             - IncreaseFontSize
             - DecreaseFontSize
             - ResetFontSize
             - ScrollPageUp
             - ScrollPageDown
             - ScrollHalfPageUp
             - ScrollHalfPageDown
             - ScrollLineUp
             - ScrollLineDown
             - ScrollToTop
             - ScrollToBottom
             - ClearHistory
                 Remove the terminal's scrollback history.
             - Hide
                 Hide the Alacritty window.
             - Minimize
                 Minimize the Alacritty window.
             - Quit
                 Quit Alacritty.
             - ToggleFullscreen
             - SpawnNewInstance
                 Spawn a new instance of Alacritty.
             - CreateNewWindow
                 Create a new Alacritty window from the current process.
             - ClearLogNotice
                 Clear Alacritty's UI warning and error notice.
             - ClearSelection
                 Remove the active selection.
             - ReceiveChar
             - None
           - Vi mode exclusive actions:
             - Open
                 Perform the action of the first matching hint under the vi mode cursor
                 with `mouse.enabled` set to `true`.
             - ToggleNormalSelection
             - ToggleLineSelection
             - ToggleBlockSelection
             - ToggleSemanticSelection
                 Toggle semantic selection based on `selection.semantic_escape_chars`.
             - CenterAroundViCursor
                 Center view around vi mode cursor
           - Vi mode exclusive cursor motion actions:
             - Up
                 One line up.
             - Down
                 One line down.
             - Left
                 One character left.
             - Right
                 One character right.
             - First
                 First column, or beginning of the line when already at the first column.
             - Last
                 Last column, or beginning of the line when already at the last column.
             - FirstOccupied
                 First non-empty cell in this terminal row, or first non-empty cell of
                 the line when already at the first cell of the row.
             - High
                 Top of the screen.
             - Middle
                 Center of the screen.
             - Low
                 Bottom of the screen.
             - SemanticLeft
                 Start of the previous semantically separated word.
             - SemanticRight
                 Start of the next semantically separated word.
             - SemanticLeftEnd
                 End of the previous semantically separated word.
             - SemanticRightEnd
                 End of the next semantically separated word.
             - WordLeft
                 Start of the previous whitespace separated word.
             - WordRight
                 Start of the next whitespace separated word.
             - WordLeftEnd
                 End of the previous whitespace separated word.
             - WordRightEnd
                 End of the next whitespace separated word.
             - Bracket
                 Character matching the bracket at the cursor's location.
             - SearchNext
                 Beginning of the next match.
             - SearchPrevious
                 Beginning of the previous match.
             - SearchStart
                 Start of the match to the left of the vi mode cursor.
             - SearchEnd
                 End of the match to the right of the vi mode cursor.
           - Search mode exclusive actions:
             - SearchFocusNext
                 Move the focus to the next search match.
             - SearchFocusPrevious
                 Move the focus to the previous search match.
             - SearchConfirm
             - SearchCancel
             - SearchClear
                 Reset the search regex.
             - SearchDeleteWord
                 Delete the last word in the search regex.
             - SearchHistoryPrevious
                 Go to the previous regex in the search history.
             - SearchHistoryNext
                 Go to the next regex in the search history.
           - macOS exclusive actions:
             - ToggleSimpleFullscreen
                 Enter fullscreen without occupying another space.
           - Linux/BSD exclusive actions:
             - CopySelection
                 Copy from the selection buffer.
             - PasteSelection
                 Paste from the selection buffer.
           
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ToggleViMode",
                  "SearchForward",
                  "SearchBackward",
                  "Copy",
                  "Paste",
                  "IncreaseFontSize",
                  "DecreaseFontSize",
                  "ResetFontSize",
                  "ScrollPageUp",
                  "ScrollPageDown",
                  "ScrollHalfPageUp",
                  "ScrollHalfPageDown",
                  "ScrollLineUp",
                  "ScrollLineDown",
                  "ScrollToTop",
                  "ScrollToBottom",
                  "ClearHistory",
                  "Hide",
                  "Minimize",
                  "Quit",
                  "ToggleFullscreen",
                  "SpawnNewInstance",
                  "CreateNewWindow",
                  "ClearLogNotice",
                  "ClearSelection",
                  "ReceiveChar",
                  "None",
                  "Open",
                  "ToggleNormalSelection",
                  "ToggleLineSelection",
                  "ToggleBlockSelection",
                  "ToggleSemanticSelection",
                  "CenterAroundViCursor",
                  "Up",
                  "Down",
                  "Left",
                  "Right",
                  "First",
                  "Last",
                  "FirstOccupied",
                  "High",
                  "Middle",
                  "Low",
                  "SemanticLeft",
                  "SemanticRight",
                  "SemanticLeftEnd",
                  "SemanticRightEnd",
                  "WordLeft",
                  "WordRight",
                  "WordLeftEnd",
                  "WordRightEnd",
                  "Bracket",
                  "SearchNext",
                  "SearchPrevious",
                  "SearchStart",
                  "SearchEnd",
                  "SearchFocusNext",
                  "SearchFocusPrevious",
                  "SearchConfirm",
                  "SearchCancel",
                  "SearchClear",
                  "SearchDeleteWord",
                  "SearchHistoryPrevious",
                  "SearchHistoryNext",
                  "ToggleSimpleFullscreen",
                  "CopySelection",
                  "PasteSelection"
                ]
            ],
      "_js2n__-:definitions/Alacritty.KeyBindings.Chars!predicate"
        | doc m%"
          The `chars` field writes the specified string to the terminal. This makes
              it possible to pass escape sequences. To find escape codes for bindings
              like `PageUp` (`"\x1b[5~"`), you can run the command `showkey -a` outside
              of tmux. Note that applications use terminfo to map escape sequences back
              to keys. It is therefore required to update the terminfo when changing an
              escape sequence.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Alacritty.KeyBindings.Key!contract"
        | doc m%"
          Identifier of the key pressed.
          
           - A-Z
           - F1-F24
           - Key0-Key9
          
           A full list with available key codes can be found here:
           https://docs.rs/glutin/*/glutin/event/enum.VirtualKeyCode.html#variants
          
           Instead of using the name of the keys, the `key` field also supports using the scancode of the desired key. Scancodes have to be specified as a decimal number. This command will allow you to display the hex scancodes for certain keys:
          
              `showkey --scancodes`.
        "%
        = String,
      "_js2n__-:definitions/Alacritty.KeyBindings.Key!predicate"
        | doc m%"
          Identifier of the key pressed.
          
           - A-Z
           - F1-F24
           - Key0-Key9
          
           A full list with available key codes can be found here:
           https://docs.rs/glutin/*/glutin/event/enum.VirtualKeyCode.html#variants
          
           Instead of using the name of the keys, the `key` field also supports using the scancode of the desired key. Scancodes have to be specified as a decimal number. This command will allow you to display the hex scancodes for certain keys:
          
              `showkey --scancodes`.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Alacritty.Mode!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                '"~Vi",
                '"~Alt",
                '"~Search",
                '"~AppKeypad",
                '"~AppCursor",
                'Vi,
                'Alt,
                'Search,
                'AppKeypad,
                'AppCursor
              |]
            ],
      "_js2n__-:definitions/Alacritty.Mode!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "AppCursor",
                  "AppKeypad",
                  "Search",
                  "Alt",
                  "Vi",
                  "~AppCursor",
                  "~AppKeypad",
                  "~Search",
                  "~Alt",
                  "~Vi"
                ]
            ],
      "_js2n__-:definitions/Alacritty.Mods!contract"
        | doc "Multiple modifiers can be combined using |, like this: \"Control | Shift\""
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "(Command|Control|Option|Super|Shift|Alt)(\\s*\\|\\s*(Command|Control|Option|Super|Shift|Alt))*"
              ]),
      "_js2n__-:definitions/Alacritty.Mods!predicate"
        | doc "Multiple modifiers can be combined using |, like this: \"Control | Shift\""
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "(Command|Control|Option|Super|Shift|Alt)(\\s*\\|\\s*(Command|Control|Option|Super|Shift|Alt))*"
            ],
      "_js2n__-:definitions/Alacritty.MouseBinding!contract" =
        {
            action | String,
            mouse | std.enum.TagOrString | [| 'Right, 'Middle, 'Left |],
          },
    }
    in
  {
      bell
        | {
          animation
            | std.enum.TagOrString
            | [|
              'Linear,
              'EaseOutCirc,
              'EaseOutExpo,
              'EaseOutQuint,
              'EaseOutQuart,
              'EaseOutCubic,
              'EaseOutQuad,
              'EaseOutSine,
              'EaseOut,
              'Ease
            |]
            | doc "Animation effect for flashing the screen when the visual bell is rung."
            | optional,
          color
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                ])
            | doc "Visual bell animation color."
            | optional,
          command
            | _js2n__-refsenv."_js2n__-:definitions/Alacritty.Command!contract"
            | optional,
          duration
            | std.number.Integer
            | doc m%"
              Duration of the visual bell flash in milliseconds. A `duration` of `0` will
               disable the visual bell animation.
            "%
            | optional,
        }
        | doc "The bell is rung every time the BEL control character is received."
        | optional,
      colors
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.records.record
            {
              bright =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          black =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          blue =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          cyan =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          green =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          magenta =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          red =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          white =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          yellow =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              cursor =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          cursor =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "#[a-z0-9]{6}|CellBackground|CellForeground"
                                ],
                          text =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "#[a-z0-9]{6}|CellBackground|CellForeground"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              dim =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          black =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          blue =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          cyan =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          green =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          magenta =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          red =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          white =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          yellow =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              draw_bold_text_with_bright_colors =
                _js2n__-prdslib.isType '"Bool",
              footer_bar =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          background =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          foreground =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              hints =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          end =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      background =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "#[a-z0-9]{6}|CellBackground|CellForeground"
                                            ],
                                      foreground =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "#[a-z0-9]{6}|CellBackground|CellForeground"
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          start =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      background =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "#[a-z0-9]{6}|CellBackground|CellForeground"
                                            ],
                                      foreground =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "#[a-z0-9]{6}|CellBackground|CellForeground"
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              indexed_colors =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                color = _js2n__-prdslib.isType '"String",
                                index = _js2n__-prdslib.isType 'Integer,
                              } {} true _js2n__-prdslib.always
                          ])
                    ],
              line_indicator =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          background =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "#[a-z0-9]{6}|None"
                                ],
                          foreground =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "#[a-z0-9]{6}|None"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              normal =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          black =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          blue =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          cyan =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          green =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          magenta =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          red =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          white =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          yellow =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              primary =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          background =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          bright_foreground =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "#[a-z0-9]{6}|None"
                                ],
                          dim_foreground =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                          foreground =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "#[a-z0-9]{6}"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              search =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          focused_match =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      background =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "#[a-z0-9]{6}|CellBackground|CellForeground"
                                            ],
                                      foreground =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "#[a-z0-9]{6}|CellBackground|CellForeground"
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          matches =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      background =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "#[a-z0-9]{6}|CellBackground|CellForeground"
                                            ],
                                      foreground =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "#[a-z0-9]{6}|CellBackground|CellForeground"
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              selection =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          cursor =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "#[a-z0-9]{6}|CellBackground|CellForeground"
                                ],
                          text =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "#[a-z0-9]{6}|CellBackground|CellForeground"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              transparent_background_colors = _js2n__-prdslib.isType '"Bool",
              vi_mode_cursor =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          cursor =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "#[a-z0-9]{6}|CellBackground|CellForeground"
                                ],
                          text =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "#[a-z0-9]{6}|CellBackground|CellForeground"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
            } {} false _js2n__-prdslib.never)
        | optional,
      cursor
        | {
          blink_interval
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Cursor blinking interval in milliseconds."
            | optional,
          blink_timeout
            | std.number.Integer
            | doc m%"
              Time after which cursor stops blinking in seconds. 
              
               Specifying '0' will disable timeout for blinking
            "%
            | optional,
          style
            | _js2n__-refsenv."_js2n__-:definitions/Alacritty.Cursor.Style!contract"
            | optional,
          thickness
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.numbers.maximum 1,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Thickness of the cursor relative to the cell width as floating point number from `0.0` to `1.0`."
            | optional,
          unfocused_hollow
            | Bool
            | doc "If this is `true`, the cursor will be rendered as a hollow box when the window is not focused."
            | optional,
          vi_mode_style
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/Alacritty.Cursor.Style!predicate",
                  _js2n__-prdslib.isType '"String"
                ])
            | doc m%"
              
              Vi mode cursor style
               If the vi mode cursor style is `None` or not specified, it will fall back to
               the style of the active value of the normal cursor.
            "%
            | optional,
        }
        | optional,
      debug
        | {
          highlight_damage
            | Bool
            | doc "Highlight window damage information."
            | optional,
          log_level
            | std.enum.TagOrString
            | [| 'Trace, 'Debug, 'Info, 'Warn, 'Error, 'Off |]
            | doc "To add extra libraries to logging `ALACRITTY_EXTRA_LOG_TARGETS` variable can be used"
            | optional,
          persistent_logging
            | Bool
            | doc "Keep the log file after quitting Alacritty."
            | optional,
          prefer_egl
            | Bool
            | doc "Use EGL as display API if the current platform allows it. Note that transparency may not work with EGL on Linux/BSD"
            | optional,
          print_events | Bool | doc "Log all received window events" | optional,
          render_timer
            | Bool
            | doc "Display the time it takes to redraw each frame."
            | optional,
          renderer
            | std.enum.TagOrString
            | [| 'None, 'gles2_pure, 'gles2, 'glsl3 |]
            | doc "Force use of a specific renderer, \"None\" will use the highest available one."
            | optional,
        }
        | optional,
      env
        | {  .. }
        | doc "Any items in the `env` entry below will be added as environment variables. Some entries may override variables set by alacritty itself."
        | optional,
      font
        | {
          bold
            | {
              family
                | String
                | doc m%"
                  If the bold family is not specified, it will fall back to the
                   value specified for the normal font.
                "%
                | optional,
              style
                | String
                | doc "The `style` can be specified to pick a specific face."
                | optional,
              ..
            }
            | optional,
          bold_italic
            | {
              family
                | String
                | doc m%"
                  If the bold_italic family is not specified, it will fall back to the
                   value specified for the normal font.
                "%
                | optional,
              style
                | String
                | doc "The `style` can be specified to pick a specific face."
                | optional,
              ..
            }
            | optional,
          builtin_box_drawing
            | Bool
            | doc m%"
              Use built-in font for box drawing characters.
              
               If `true`, Alacritty will use a custom built-in font for box drawing
               characters (Unicode points 2500 - 259f).
            "%
            | optional,
          glyph_offset
            | { x | Number | optional, y | Number | optional, }
            | doc m%"
              Glyph offset determines the locations of the glyphs within their cells with
               the default being at the bottom. Increasing `x` moves the glyph to the
               right, increasing `y` moves the glyph upward.
            "%
            | optional,
          italic
            | {
              family
                | String
                | doc m%"
                  If the italic family is not specified, it will fall back to the
                   value specified for the normal font.
                "%
                | optional,
              style
                | String
                | doc "The `style` can be specified to pick a specific face."
                | optional,
              ..
            }
            | optional,
          normal
            | {
              family
                | String
                | doc m%"
                  Font family
                  
                   Default:
                     - (macOS) Menlo
                     - (Linux/BSD) monospace
                     - (Windows) Consolas
                "%
                | optional,
              style
                | String
                | doc "The `style` can be specified to pick a specific face."
                | optional,
              ..
            }
            | optional,
          offset
            | { x | Number | optional, y | Number | optional, }
            | doc m%"
              Offset is the extra space around each character. `offset.y` can be thought
               of as modifying the line spacing, and `offset.x` as modifying the letter
               spacing.
            "%
            | optional,
          size
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Point size"
            | optional,
        }
        | optional,
      hints
        | {
          alphabet | String | doc "Keys used for the hint labels" | optional,
          enabled
            | Array
              {
                action
                  | std.enum.TagOrString
                  | [| 'MoveViModeCursor, 'Select, 'Paste, 'Copy |]
                  | doc m%"
                    - Copy: Copy the hint's text to the clipboard
                    - Paste: Paste the hint's text to the terminal or search
                    - Select: Select the hint's text
                    - MoveViModeCursor: Move the vi mode cursor to the beginning of the hint
                  "%
                  | optional,
                binding
                  | {
                    key
                      | _js2n__-refsenv."_js2n__-:definitions/Alacritty.KeyBindings.Key!contract"
                      | optional,
                    mode
                      | _js2n__-refsenv."_js2n__-:definitions/Alacritty.Mode!contract"
                      | optional,
                    mods
                      | _js2n__-refsenv."_js2n__-:definitions/Alacritty.Mods!contract"
                      | optional,
                    ..
                  }
                  | doc m%"
                    See `keyboard.bindings` for documentation on available values.
                    This controls which key binding is used to start the keyboard hint selection process
                  "%
                  | optional,
                command
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                args =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ],
                                program = _js2n__-prdslib.isType '"String",
                              } {} true _js2n__-prdslib.always
                          ]
                      ])
                  | doc m%"
                    Command which will be executed when the hint is clicked or selected with the `binding`.
                    The hint's text is always attached as the last argument
                  "%
                  | optional,
                hyperlinks
                  | Bool
                  | doc "When this is `true`, all OSC 8 escape sequence hyperlinks will be included in the hints"
                  | optional,
                mouse
                  | {
                    enabled
                      | Bool
                      | doc "The `enabled` field controls if the hint should be underlined when hovering over the hint text with all `mods` pressed"
                      | optional,
                    mods
                      | _js2n__-refsenv."_js2n__-:definitions/Alacritty.Mods!contract"
                      | optional,
                    ..
                  }
                  | doc "See `keyboard.bindings` for documentation on available mods"
                  | optional,
                persist
                  | Bool
                  | doc "When this is `true`, hints remain persistent after selection"
                  | optional,
                post_processing
                  | Bool
                  | doc "When this is `true`, heuristics will be used to shorten the match if there are characters likely not to be part of the hint (e.g. a trailing .). This is most useful for URIs and applies only to `regex` matches"
                  | optional,
                regex
                  | String
                  | doc "Regex each line will be compared against"
                  | optional,
                ..
              }
            | doc "Array with all available hints. Each hint must have at least one of `regex` or `hyperlinks` and either an `action` or a `command`"
            | optional,
          ..
        }
        | doc "Terminal hints can be used to find text or hyperlinks in the visible part of the terminal and pipe it to other applications"
        | optional,
      "import"
        | Array (String)
        | doc m%"
          Import additional configuration files. 
           Imports are loaded in order, skipping all missing files, with the importing file being loaded last. If a field is already present in a previous import, it will be replaced.
        "%
        | optional,
      ipc_socket
        | Bool
        | doc "Offer IPC using `alacritty msg` (unix only)"
        | optional,
      key
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.records.record
            {
              bindings =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                action =
                                  _js2n__-refsenv."_js2n__-:definitions/Alacritty.KeyBindings.Action!predicate",
                                chars =
                                  _js2n__-refsenv."_js2n__-:definitions/Alacritty.KeyBindings.Chars!predicate",
                                command =
                                  _js2n__-refsenv."_js2n__-:definitions/Alacritty.Command!predicate",
                                key =
                                  _js2n__-refsenv."_js2n__-:definitions/Alacritty.KeyBindings.Key!predicate",
                                mode =
                                  _js2n__-refsenv."_js2n__-:definitions/Alacritty.Mode!predicate",
                                mods =
                                  _js2n__-refsenv."_js2n__-:definitions/Alacritty.Mods!predicate",
                              } {} false _js2n__-prdslib.never
                          ])
                    ],
            } {} true _js2n__-prdslib.always)
        | optional,
      live_config_reload
        | Bool
        | doc "Live config reload (changes require restart). Will make alacritty auto load new changes in the config file"
        | optional,
      mouse
        | {
          bindings
            | Array
              _js2n__-refsenv."_js2n__-:definitions/Alacritty.MouseBinding!contract"
            | optional,
          hide_when_typing
            | Bool
            | doc "When this is `true`, the cursor is temporarily hidden when typing."
            | optional,
          ..
        }
        | optional,
      scrolling
        | {
          history
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              Maximum number of lines in the scrollback buffer.
               Specifying '0' will disable scrolling.
            "%
            | optional,
          multiplier
            | std.number.Integer
            | doc "Scrolling distance multiplier."
            | optional,
        }
        | optional,
      selection
        | {
          save_to_clipboard
            | Bool
            | doc "When set to `true`, selected text will be copied to the primary clipboard."
            | optional,
          semantic_escape_chars
            | String
            | doc "This string contains all characters that are used as separators for \"semantic words\" in Alacritty."
            | optional,
        }
        | optional,
      shell
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      args =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      program = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ])
        | doc "You can set shell.program to the path of your favorite shell, e.g. /bin/zsh. Entries in shell.args are passed as arguments to the shell"
        | optional,
      terminal
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Record)
        | optional,
      window
        | {
          blur
            | Bool
            | doc "Request compositor to blur content behind transparent windows"
            | optional,
          class
            | { general | String | optional, instance | String | optional, .. }
            | doc "Window class (Linux/BSD only):"
            | optional,
          decorations
            | std.enum.TagOrString
            | [| 'buttonless, 'transparent, 'none, 'full |]
            | doc m%"
              Values for `decorations`: 
                   - full: Borders and title bar 
                   - none: Neither borders nor title bar 
              
               Values for `decorations` (macOS only):
                   - transparent: Title bar, transparent background and title bar buttons
                   - buttonless: Title bar, transparent background and no title bar buttons
            "%
            | optional,
          decorations_theme_variant
            | String
            | doc m%"
              Decorations theme variant (Linux/BSD only)
              
              Override the variant of the GTK theme/Wayland client side decorations.
               Commonly supported values are `dark` and `light`. Set this to `None` to use
               the default theme variant.
            "%
            | optional,
          dimensions
            | {
              columns
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              lines
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | optional,
            }
            | doc m%"
              Window dimensions (changes require restart). 
               Number of lines/columns (not pixels) in the terminal. Both lines and columns
               must be non-zero for this to take effect. The number of columns must be at
               least `2`, while using a value of `0` for columns and lines will fall back
               to the window manager's recommended size
            "%
            | optional,
          dynamic_padding
            | Bool
            | doc "Spread additional padding evenly around the terminal content."
            | optional,
          dynamic_title
            | Bool
            | doc "Allow terminal applications to change Alacritty's window title."
            | optional,
          opacity
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.numbers.maximum 1,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              Background opacity
              
               Window opacity as a floating point number from `0.0` to `1.0`.
               The value `0.0` is completely transparent and `1.0` is opaque.
            "%
            | optional,
          option_as_alt
            | std.enum.TagOrString
            | [| 'None, 'Both, 'OnlyRight, 'OnlyLeft |]
            | doc "Make `Option` key behave as `Alt` (macos only)"
            | optional,
          padding
            | { x | Number | optional, y | Number | optional, }
            | doc m%"
              # Window padding (changes require restart)
              
               Blank space added around the window in pixels. This padding is scaled
               by DPI and the specified value is always added at both opposing sides.
            "%
            | optional,
          position
            | { x | Number | optional, y | Number | optional, }
            | doc m%"
              Window position (changes require restart)
              Specified in number of pixels.
              If the position is not set, the window manager will handle the placement.
            "%
            | optional,
          resize_increments
            | Bool
            | doc "Prefer resizing window by discrete steps equal to cell dimensions"
            | optional,
          startup_mode
            | std.enum.TagOrString
            | [| 'SimpleFullscreen, 'Fullscreen, 'Maximized, 'Windowed |]
            | doc m%"
                # Startup Mode (changes require restart)
              
               Values for `startup_mode`:
                 - Windowed
                 - Maximized
                 - Fullscreen
              
               Values for `startup_mode` (macOS only):
                 - SimpleFullscreen
            "%
            | optional,
          title | String | doc "Window Title" | optional,
        }
        | optional,
      working_directory
        | String
        | doc m%"
          Startup directory
          
           Directory the shell is started in. If this is unset, or `None`, the working
           directory of the parent process will be used.
        "%
        | optional,
      ..
    }