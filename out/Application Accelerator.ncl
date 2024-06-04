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
      "_js2n__-:definitions/AcceleratorOption!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.records.record
                    {
                      dataType = _js2n__-prdslib.const "string",
                      defaultValue = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-prdslib.records.record
                    {
                      dataType =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.const "string")
                            ],
                      defaultValue =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} true _js2n__-prdslib.always,
                  _js2n__-prdslib.records.record
                    {
                      dataType = _js2n__-prdslib.const "number",
                      defaultValue = _js2n__-prdslib.isType '"Number",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-prdslib.records.record
                    {
                      dataType =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.const "number")
                            ],
                      defaultValue =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"Number")
                            ],
                    } {} true _js2n__-prdslib.always,
                  _js2n__-prdslib.records.record
                    {
                      dataType = _js2n__-prdslib.const "boolean",
                      defaultValue = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-prdslib.records.record
                    {
                      dataType =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.const "boolean")
                            ],
                      defaultValue =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"Bool")
                            ],
                    } {} true _js2n__-prdslib.always,
                  _js2n__-prdslib.records.record
                    {
                      dataType =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^$|^[A-Z][a-z0-9A-Z]*$"
                            ],
                      defaultValue = _js2n__-prdslib.isType 'Record,
                    } {} true _js2n__-prdslib.always,
                  _js2n__-prdslib.records.record
                    {
                      dataType =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^$|^[A-Z][a-z0-9A-Z]*$"
                                  ])
                            ],
                      defaultValue =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Record)
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.record
                {
                  choices =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    text = _js2n__-prdslib.isType '"String",
                                    value = _js2n__-prdslib.always,
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  dataType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.const "string",
                          _js2n__-prdslib.const "number",
                          _js2n__-prdslib.const "boolean",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^$|^[A-Z][a-z0-9A-Z]*$"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.const "string"),
                              _js2n__-prdslib.arrays.maxItems 1,
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.const "number"),
                              _js2n__-prdslib.arrays.maxItems 1,
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.const "boolean"),
                              _js2n__-prdslib.arrays.maxItems 1,
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^$|^[A-Z][a-z0-9A-Z]*$"
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 1,
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  defaultValue = _js2n__-prdslib.always,
                  dependsOn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/DependsOn!predicate",
                          _js2n__-prdslib.always
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  inputType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "text",
                              "textarea",
                              "checkbox",
                              "select",
                              "radio"
                            ]
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1,
                          _js2n__-prdslib.strings.pattern
                            "^$|^[a-z][a-z0-9A-Z]*$"
                        ],
                  required = _js2n__-prdslib.isType '"Bool",
                  validationRegex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Pattern!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Chain-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  applyTo =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.strings.pattern "^$|^[^/].*$"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  transformations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Loop-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Chain-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Provenance-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Exclude-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Include-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Combo-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/ReplaceText-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Merge-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/OpenRewriteRecipe-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/RewritePath-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/UniquePath-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/YTT-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Let-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/UseEncoding-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Chain-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Chain-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "Chain", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/Combo-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  applyTo =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.strings.pattern "^$|^[^/].*$"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  chain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Loop-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Chain-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Provenance-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Exclude-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Include-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Combo-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/ReplaceText-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Merge-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/OpenRewriteRecipe-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/RewritePath-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/UniquePath-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/YTT-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Let-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/UseEncoding-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate"
                              ])
                        ],
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.strings.pattern "^$|^[^/].*$"
                              ])
                        ],
                  include =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.strings.pattern "^$|^[^/].*$"
                              ])
                        ],
                  "let" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/DerivedSymbol!predicate",
                                _js2n__-prdslib.always
                              ])
                        ],
                  "merge" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Loop-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Chain-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Provenance-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Exclude-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Include-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Combo-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/ReplaceText-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Merge-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/OpenRewriteRecipe-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/RewritePath-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/UniquePath-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/YTT-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Let-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/UseEncoding-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate"
                              ])
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  onConflict =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ConflictResolution!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Combo-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Combo-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "Combo", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ConflictResolution!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "Fail",
                  "UseFirst",
                  "UseLast",
                  "Append",
                  "FavorOwn",
                  "FavorForeign",
                  "NWayDiff"
                ]
            ],
      "_js2n__-:definitions/DependsOn!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1,
                          _js2n__-prdslib.strings.pattern
                            "^$|^[a-z][a-z0-9A-Z]*$"
                        ],
                  value = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DerivedSymbol!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  expression =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1,
                          _js2n__-prdslib.strings.pattern
                            "^$|^[a-z][a-z0-9A-Z]*$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Exclude-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  patterns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.strings.pattern "^$|^[^/].*$"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Exclude-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Exclude-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "Exclude", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/Expression!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Include-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  patterns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.strings.pattern "^$|^[^/].*$"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Include-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Include-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "Include", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/InvokeFragment-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  anchor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^$|^[^/]$|^[^/](.+)[^/]$"
                        ],
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  "let" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/DerivedSymbol!predicate",
                                _js2n__-prdslib.always
                              ])
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  reference =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1,
                          _js2n__-prdslib.strings.pattern
                            "^[a-z0-9]([a-z0-9-]*[a-z0-9])?$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/InvokeFragment-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "InvokeFragment", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/Let-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  "in" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Loop-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Chain-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Provenance-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Exclude-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Include-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Combo-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/ReplaceText-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Merge-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OpenRewriteRecipe-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/RewritePath-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UniquePath-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/YTT-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Let-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UseEncoding-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  noShadow = _js2n__-prdslib.isType '"Bool",
                  symbols =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/DerivedSymbol!predicate",
                                _js2n__-prdslib.always
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Let-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Let-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "Let", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/Loop-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  doAsChain =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Loop-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Chain-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Provenance-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Exclude-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Include-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Combo-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/ReplaceText-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Merge-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OpenRewriteRecipe-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/RewritePath-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UniquePath-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/YTT-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Let-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UseEncoding-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate"
                        ],
                  doAsMerge =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Loop-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Chain-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Provenance-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Exclude-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Include-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Combo-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/ReplaceText-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Merge-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OpenRewriteRecipe-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/RewritePath-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UniquePath-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/YTT-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Let-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UseEncoding-2!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate"
                        ],
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^$|^[a-z][a-z0-9A-Z]*$"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  on =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  var =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^$|^[a-z][a-z0-9A-Z]*$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Loop-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Loop-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "Loop", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/Merge-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Loop-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Chain-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Provenance-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Exclude-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Include-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Combo-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/ReplaceText-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Merge-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/OpenRewriteRecipe-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/RewritePath-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/UniquePath-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/YTT-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Let-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/UseEncoding-2!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Merge-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Merge-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "Merge", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/OpenRewriteRecipe-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  options = _js2n__-prdslib.isType 'Record,
                  parseOrFail = _js2n__-prdslib.isType '"Bool",
                  recipe =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z_$][a-zA-Z\\d_$]*(?:\\.[a-zA-Z_$][a-zA-Z\\d_$]*)*$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OpenRewriteRecipe-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/OpenRewriteRecipe-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "OpenRewriteRecipe", } {}
                    true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/Pattern!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Provenance-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Provenance-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Provenance-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "Provenance", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ReplaceText-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  regex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              pattern =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/Pattern!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              with =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                                      _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  substitutions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    text =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.minLength 1
                                          ],
                                    with =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                                            _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ReplaceText-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/ReplaceText-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "ReplaceText", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/RewritePath-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  matchOrFail = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  regex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Pattern!predicate",
                          _js2n__-prdslib.always
                        ],
                  rewriteTo =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/RewritePath-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RewritePath-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "RewritePath", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/UniquePath-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  strategy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ConflictResolution!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/UniquePath-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/UniquePath-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "UniquePath", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/UseEncoding-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  encoding = _js2n__-prdslib.isType 'Record,
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/UseEncoding-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/UseEncoding-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "UseEncoding", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/YTT-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowList =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Pattern!predicate",
                                _js2n__-prdslib.always
                              ])
                        ],
                  condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                          _js2n__-prdslib.always
                        ],
                  denyList =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Pattern!predicate",
                                _js2n__-prdslib.always
                              ])
                        ],
                  extraArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Expression!predicate",
                                _js2n__-prdslib.always
                              ])
                        ],
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/YTT-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/YTT-1!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.const "YTT", } {} true
                    _js2n__-prdslib.always
                ]
            ],
    }
    in
  {
      accelerator
        | {
          description | String | doc "A more detailed description" | optional,
          displayName | String | doc "A human-readable name" | optional,
          iconUrl | String | doc "A URL pointing to an icon image" | optional,
          imports
            | Array
              {
                expose
                  | Array
                    {
                      as
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern
                                "^$|^[a-z][a-z0-9A-Z]*$"
                            ])
                        | doc "The alias to use as the name of the option"
                        | optional,
                      dependsOn
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/DependsOn!predicate",
                              _js2n__-prdslib.always
                            ])
                        | optional,
                      name
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern
                                "^\\*$|^$|^[a-z][a-z0-9A-Z]*$"
                            ])
                        | doc "The original name of the option"
                        | optional,
                      ..
                    }
                  | doc "The list of fragment options to make available as accelerator options"
                  | optional,
                exposeTypes
                  | Array
                    {
                      as
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern
                                "^$|^[A-Z][a-z0-9A-Z]*$"
                            ])
                        | doc "The alias to use as the name of the type"
                        | optional,
                      name
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern
                                "^\\*$|^$|^[A-Z][a-z0-9A-Z]*$"
                            ])
                        | doc "The original name of the type"
                        | optional,
                      ..
                    }
                  | doc "The list of fragment types to make available as accelerator types"
                  | optional,
                name
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ])
                  | doc "The name of the fragment to import"
                  | optional,
                ..
              }
            | doc "The list of fragment to import"
            | optional,
          options
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/AcceleratorOption!predicate",
                    _js2n__-prdslib.always
                  ])
            )
            | doc "The list of options passed to the UI to create input text boxes"
            | optional,
          tags
            | Array (String)
            | doc "A list of tags used to filter accelerators"
            | optional,
          types
            | Array
              {
                name
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1,
                        _js2n__-prdslib.strings.pattern "^$|^[A-Z][a-z0-9A-Z]*$"
                      ])
                  | doc "The capitalized name of this custom type"
                  | optional,
                struct
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/AcceleratorOption!predicate",
                              _js2n__-prdslib.always
                            ]),
                        _js2n__-prdslib.arrays.minItems 1
                      ])
                  | doc "A sequence of option definitions"
                  | optional,
                ..
              }
            | doc "The definitions of custom types"
            | optional,
          ..
        }
        | doc "The metadata (non-behavioral) part of an App Accelerator's accelerator.yaml file"
        | optional,
      engine
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Loop-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/Chain-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/Provenance-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/Exclude-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/Include-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/Combo-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ReplaceText-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/Merge-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/OpenRewriteRecipe-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RewritePath-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/UniquePath-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/YTT-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/Let-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/UseEncoding-2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/InvokeFragment-2!predicate"
            ])
        | optional,
      ..
    }