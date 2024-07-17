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
      "_js2n__-:definitions/io.argoproj.common.Amount!predicate"
        | doc "Amount represent a numeric amount."
        = _js2n__-prdslib.isType '"Number",
      "_js2n__-:definitions/io.argoproj.common.Backoff!predicate"
        | doc "Backoff for an operation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  duration =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Int64OrString!predicate",
                  factor =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Amount!predicate",
                  jitter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Amount!predicate",
                  steps = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.BasicAuth!predicate"
        | doc "BasicAuth contains the reference to K8s secrets that holds the username and password"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  username =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.Condition!predicate"
        | doc "Condition contains details about resource state"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "status", "type" ],
              _js2n__-prdslib.records.record
                {
                  lastTransitionTime =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  reason = _js2n__-prdslib.isType '"String",
                  status = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.Int64OrString!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/io.argoproj.common.Metadata!predicate"
        | doc "Metadata holds the annotations and labels of an event source pod"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.Resource!predicate"
        | doc "Resource represent arbitrary structured data."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/io.argoproj.common.S3Artifact!predicate"
        | doc "S3Artifact contains information about an S3 connection and bucket"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "accessKey", "bucket", "endpoint", "secretKey" ],
              _js2n__-prdslib.records.record
                {
                  accessKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  bucket =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.S3Bucket!predicate",
                  caCertificate =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  endpoint = _js2n__-prdslib.isType '"String",
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.S3Filter!predicate",
                  insecure = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  region = _js2n__-prdslib.isType '"String",
                  secretKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.S3Bucket!predicate"
        | doc "S3Bucket contains information to describe an S3 Bucket"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.S3Filter!predicate"
        | doc "S3Filter represents filters to apply to bucket notifications for specifying constraints on objects"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "prefix", "suffix" ],
              _js2n__-prdslib.records.record
                {
                  prefix = _js2n__-prdslib.isType '"String",
                  suffix = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.SASLConfig!predicate"
        | doc "SASLConfig refers to SASL configuration for a client"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  mechanism = _js2n__-prdslib.isType '"String",
                  passwordSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  userSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.SchemaRegistryConfig!predicate"
        | doc "SchemaRegistryConfig refers to configuration for a client"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "schemaId", "url" ],
              _js2n__-prdslib.records.record
                {
                  auth =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.BasicAuth!predicate",
                  schemaId = _js2n__-prdslib.isType 'Integer,
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.SecureHeader!predicate"
        | doc "SecureHeader refers to HTTP Headers with auth tokens as values"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  valueFrom =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.ValueFromSource!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate"
        | doc "TLSConfig refers to TLS configuration for a client."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  caCertSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  clientCertSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  clientKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  insecureSkipVerify = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.common.ValueFromSource!predicate"
        | doc "ValueFromSource allows you to reference keys from either a Configmap or Secret"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configMapKeyRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapKeySelector!predicate",
                  secretKeyRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.BusConfig!predicate"
        | doc "BusConfig has the finalized configuration for EventBus"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  jetstream =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.JetStreamConfig!predicate",
                  kafka =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.KafkaBus!predicate",
                  nats =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.NATSConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.ContainerTemplate!predicate"
        | doc "ContainerTemplate defines customized spec for a container"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  imagePullPolicy = _js2n__-prdslib.isType '"String",
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate",
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecurityContext!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.EventBus!predicate"
        | doc "EventBus is the definition of a eventbus resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "metadata", "spec" ],
              _js2n__-prdslib.records.record
                {
                  apiVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "argoproj.io/v1alpha1"
                        ],
                  kind =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "EventBus"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.EventBusSpec!predicate",
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.EventBusStatus!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.EventBusSpec!predicate"
        | doc "EventBusSpec refers to specification of eventbus resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  jetstream =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.JetStreamBus!predicate",
                  jetstreamExotic =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.JetStreamConfig!predicate",
                  kafka =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.KafkaBus!predicate",
                  nats =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.NATSBus!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.EventBusStatus!predicate"
        | doc "EventBusStatus holds the status of the eventbus resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  conditions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Condition!predicate"
                        ],
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.BusConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.JetStreamBus!predicate"
        | doc "JetStreamBus holds the JetStream EventBus information"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  affinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Affinity!predicate",
                  containerTemplate =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.ContainerTemplate!predicate",
                  imagePullSecrets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate"
                        ],
                  maxPayload = _js2n__-prdslib.isType '"String",
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Metadata!predicate",
                  metricsContainerTemplate =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.ContainerTemplate!predicate",
                  nodeSelector =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  persistence =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.PersistenceStrategy!predicate",
                  "priority" = _js2n__-prdslib.isType 'Integer,
                  priorityClassName = _js2n__-prdslib.isType '"String",
                  reloaderContainerTemplate =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.ContainerTemplate!predicate",
                  replicas = _js2n__-prdslib.isType 'Integer,
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodSecurityContext!predicate",
                  serviceAccountName = _js2n__-prdslib.isType '"String",
                  settings = _js2n__-prdslib.isType '"String",
                  startArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  streamConfig = _js2n__-prdslib.isType '"String",
                  tolerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Toleration!predicate"
                        ],
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.JetStreamConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  streamConfig = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.KafkaBus!predicate"
        | doc "KafkaBus holds the KafkaBus EventBus information"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  consumerGroup =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.KafkaConsumerGroup!predicate",
                  sasl =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.SASLConfig!predicate",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  topic = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.KafkaConsumerGroup!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  groupName = _js2n__-prdslib.isType '"String",
                  rebalanceStrategy = _js2n__-prdslib.isType '"String",
                  startOldest = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.NATSBus!predicate"
        | doc "NATSBus holds the NATS eventbus information"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exotic =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.NATSConfig!predicate",
                  native =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.NativeStrategy!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.NATSConfig!predicate"
        | doc "NATSConfig holds the config of NATS"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  auth = _js2n__-prdslib.isType '"String",
                  clusterID = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.NativeStrategy!predicate"
        | doc "NativeStrategy indicates to install a native NATS service"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  affinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Affinity!predicate",
                  auth = _js2n__-prdslib.isType '"String",
                  containerTemplate =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.ContainerTemplate!predicate",
                  imagePullSecrets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate"
                        ],
                  maxAge = _js2n__-prdslib.isType '"String",
                  maxBytes = _js2n__-prdslib.isType '"String",
                  maxMsgs = _js2n__-prdslib.isType 'Integer,
                  maxPayload = _js2n__-prdslib.isType '"String",
                  maxSubs = _js2n__-prdslib.isType 'Integer,
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Metadata!predicate",
                  metricsContainerTemplate =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.ContainerTemplate!predicate",
                  nodeSelector =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  persistence =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.PersistenceStrategy!predicate",
                  "priority" = _js2n__-prdslib.isType 'Integer,
                  priorityClassName = _js2n__-prdslib.isType '"String",
                  raftCommitTimeout = _js2n__-prdslib.isType '"String",
                  raftElectionTimeout = _js2n__-prdslib.isType '"String",
                  raftHeartbeatTimeout = _js2n__-prdslib.isType '"String",
                  raftLeaseTimeout = _js2n__-prdslib.isType '"String",
                  replicas = _js2n__-prdslib.isType 'Integer,
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodSecurityContext!predicate",
                  serviceAccountName = _js2n__-prdslib.isType '"String",
                  tolerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Toleration!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.PersistenceStrategy!predicate"
        | doc "PersistenceStrategy defines the strategy of persistence"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessMode = _js2n__-prdslib.isType '"String",
                  storageClassName = _js2n__-prdslib.isType '"String",
                  volumeSize =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPConsumeConfig!predicate"
        | doc "AMQPConsumeConfig holds the configuration to immediately starts delivering queued messages"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  autoAck = _js2n__-prdslib.isType '"Bool",
                  consumerTag = _js2n__-prdslib.isType '"String",
                  exclusive = _js2n__-prdslib.isType '"Bool",
                  noLocal = _js2n__-prdslib.isType '"Bool",
                  noWait = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPEventSource!predicate"
        | doc "AMQPEventSource refers to an event-source for AMQP stream events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "exchangeName", "exchangeType", "routingKey" ],
              _js2n__-prdslib.records.record
                {
                  auth =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.BasicAuth!predicate",
                  connectionBackoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  consume =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPConsumeConfig!predicate",
                  exchangeDeclare =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPExchangeDeclareConfig!predicate",
                  exchangeName = _js2n__-prdslib.isType '"String",
                  exchangeType = _js2n__-prdslib.isType '"String",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  queueBind =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPQueueBindConfig!predicate",
                  queueDeclare =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPQueueDeclareConfig!predicate",
                  routingKey = _js2n__-prdslib.isType '"String",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  url = _js2n__-prdslib.isType '"String",
                  urlSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPExchangeDeclareConfig!predicate"
        | doc "AMQPExchangeDeclareConfig holds the configuration for the exchange on the server"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  autoDelete = _js2n__-prdslib.isType '"Bool",
                  durable = _js2n__-prdslib.isType '"Bool",
                  internal = _js2n__-prdslib.isType '"Bool",
                  noWait = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPQueueBindConfig!predicate"
        | doc "AMQPQueueBindConfig holds the configuration that binds an exchange to a queue so that publishings to the exchange will be routed to the queue when the publishing routing key matches the binding routing key"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { noWait = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPQueueDeclareConfig!predicate"
        | doc "AMQPQueueDeclareConfig holds the configuration of a queue to hold messages and deliver to consumers. Declaring creates a queue if it doesn't already exist, or ensures that an existing queue matches the same parameters"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arguments = _js2n__-prdslib.isType '"String",
                  autoDelete = _js2n__-prdslib.isType '"Bool",
                  durable = _js2n__-prdslib.isType '"Bool",
                  exclusive = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  noWait = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AzureEventsHubEventSource!predicate"
        | doc "AzureEventsHubEventSource describes the event source for azure events hub More info at https://docs.microsoft.com/en-us/azure/event-hubs/"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fqdn", "hubName" ],
              _js2n__-prdslib.records.record
                {
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  fqdn = _js2n__-prdslib.isType '"String",
                  hubName = _js2n__-prdslib.isType '"String",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  sharedAccessKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  sharedAccessKeyName =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AzureQueueStorageEventSource!predicate"
        | doc "AzureQueueStorageEventSource describes the event source for azure queue storage more info at https://learn.microsoft.com/en-us/azure/storage/queues/"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "queueName" ],
              _js2n__-prdslib.records.record
                {
                  connectionString =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  decodeMessage = _js2n__-prdslib.isType '"Bool",
                  dlq = _js2n__-prdslib.isType '"Bool",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  queueName = _js2n__-prdslib.isType '"String",
                  storageAccountName = _js2n__-prdslib.isType '"String",
                  waitTimeInSeconds = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AzureServiceBusEventSource!predicate"
        | doc "AzureServiceBusEventSource describes the event source for azure service bus More info at https://docs.microsoft.com/en-us/azure/service-bus-messaging/"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "queueName", "subscriptionName", "topicName" ],
              _js2n__-prdslib.records.record
                {
                  connectionString =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  fullyQualifiedNamespace = _js2n__-prdslib.isType '"String",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  queueName = _js2n__-prdslib.isType '"String",
                  subscriptionName = _js2n__-prdslib.isType '"String",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  topicName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketAuth!predicate"
        | doc "BitbucketAuth holds the different auth strategies for connecting to Bitbucket"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  basic =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketBasicAuth!predicate",
                  oauthToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketBasicAuth!predicate"
        | doc "BasicAuth holds the information required to authenticate user via basic auth mechanism"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "password", "username" ],
              _js2n__-prdslib.records.record
                {
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  username =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketEventSource!predicate"
        | doc "BitbucketEventSource describes the event source for Bitbucket"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "auth", "events", "webhook" ],
              _js2n__-prdslib.records.record
                {
                  auth =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketAuth!predicate",
                  deleteHookOnFinish = _js2n__-prdslib.isType '"Bool",
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  owner = _js2n__-prdslib.isType '"String",
                  projectKey = _js2n__-prdslib.isType '"String",
                  repositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketRepository!predicate"
                        ],
                  repositorySlug = _js2n__-prdslib.isType '"String",
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "owner", "repositorySlug" ],
              _js2n__-prdslib.records.record
                {
                  owner = _js2n__-prdslib.isType '"String",
                  repositorySlug = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketServerEventSource!predicate"
        | doc "BitbucketServerEventSource refers to event-source related to Bitbucket Server events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "bitbucketserverBaseURL" ],
              _js2n__-prdslib.records.record
                {
                  accessToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  bitbucketserverBaseURL = _js2n__-prdslib.isType '"String",
                  checkInterval = _js2n__-prdslib.isType '"String",
                  deleteHookOnFinish = _js2n__-prdslib.isType '"Bool",
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  projectKey = _js2n__-prdslib.isType '"String",
                  projects =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  repositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketServerRepository!predicate"
                        ],
                  repositorySlug = _js2n__-prdslib.isType '"String",
                  skipBranchRefsChangedOnOpenPR =
                    _js2n__-prdslib.isType '"Bool",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate",
                  webhookSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketServerRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "projectKey", "repositorySlug" ],
              _js2n__-prdslib.records.record
                {
                  projectKey = _js2n__-prdslib.isType '"String",
                  repositorySlug = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.CalendarEventSource!predicate"
        | doc "CalendarEventSource describes a time based dependency. One of the fields (schedule, interval, or recurrence) must be passed. Schedule takes precedence over interval; interval takes precedence over recurrence"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exclusionDates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  interval = _js2n__-prdslib.isType '"String",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  persistence =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventPersistence!predicate",
                  schedule = _js2n__-prdslib.isType '"String",
                  timezone = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.CatchupConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  maxDuration = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.ConfigMapPersistence!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  createIfNotExist = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EmitterEventSource!predicate"
        | doc "EmitterEventSource describes the event source for emitter More info at https://emitter.io/develop/getting-started/"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "broker", "channelKey", "channelName" ],
              _js2n__-prdslib.records.record
                {
                  broker = _js2n__-prdslib.isType '"String",
                  channelKey = _js2n__-prdslib.isType '"String",
                  channelName = _js2n__-prdslib.isType '"String",
                  connectionBackoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  username =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventPersistence!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  catchup =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.CatchupConfiguration!predicate",
                  configMap =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.ConfigMapPersistence!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSource!predicate"
        | doc "EventSource is the definition of a eventsource resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "metadata", "spec" ],
              _js2n__-prdslib.records.record
                {
                  apiVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "argoproj.io/v1alpha1"
                        ],
                  kind =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "EventSource"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceSpec!predicate",
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceStatus!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { expression = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceSpec!predicate"
        | doc "EventSourceSpec refers to specification of event-source resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  amqp =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AMQPEventSource!predicate"
                        ],
                  azureEventsHub =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AzureEventsHubEventSource!predicate"
                        ],
                  azureQueueStorage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AzureQueueStorageEventSource!predicate"
                        ],
                  azureServiceBus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.AzureServiceBusEventSource!predicate"
                        ],
                  bitbucket =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketEventSource!predicate"
                        ],
                  bitbucketserver =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.BitbucketServerEventSource!predicate"
                        ],
                  calendar =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.CalendarEventSource!predicate"
                        ],
                  emitter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EmitterEventSource!predicate"
                        ],
                  eventBusName = _js2n__-prdslib.isType '"String",
                  file =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.FileEventSource!predicate"
                        ],
                  generic =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GenericEventSource!predicate"
                        ],
                  gerrit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GerritEventSource!predicate"
                        ],
                  github =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GithubEventSource!predicate"
                        ],
                  gitlab =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GitlabEventSource!predicate"
                        ],
                  hdfs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.HDFSEventSource!predicate"
                        ],
                  kafka =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.KafkaEventSource!predicate"
                        ],
                  minio =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.S3Artifact!predicate"
                        ],
                  mqtt =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.MQTTEventSource!predicate"
                        ],
                  nats =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.NATSEventsSource!predicate"
                        ],
                  nsq =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.NSQEventSource!predicate"
                        ],
                  pubSub =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.PubSubEventSource!predicate"
                        ],
                  pulsar =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.PulsarEventSource!predicate"
                        ],
                  redis =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.RedisEventSource!predicate"
                        ],
                  redisStream =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.RedisStreamEventSource!predicate"
                        ],
                  replicas = _js2n__-prdslib.isType 'Integer,
                  resource =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.ResourceEventSource!predicate"
                        ],
                  service =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.Service!predicate",
                  sftp =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.SFTPEventSource!predicate"
                        ],
                  slack =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.SlackEventSource!predicate"
                        ],
                  sns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.SNSEventSource!predicate"
                        ],
                  sqs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.SQSEventSource!predicate"
                        ],
                  storageGrid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.StorageGridEventSource!predicate"
                        ],
                  stripe =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.StripeEventSource!predicate"
                        ],
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.Template!predicate",
                  webhook =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookEventSource!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceStatus!predicate"
        | doc "EventSourceStatus holds the status of the event-source resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  conditions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Condition!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.FileEventSource!predicate"
        | doc "FileEventSource describes an event-source for file related events."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "eventType", "watchPathConfig" ],
              _js2n__-prdslib.records.record
                {
                  eventType = _js2n__-prdslib.isType '"String",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  polling = _js2n__-prdslib.isType '"Bool",
                  watchPathConfig =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WatchPathConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GenericEventSource!predicate"
        | doc "GenericEventSource refers to a generic event source. It can be used to implement a custom event source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "url" ],
              _js2n__-prdslib.records.record
                {
                  authSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  config = _js2n__-prdslib.isType '"String",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  insecure = _js2n__-prdslib.isType '"Bool",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GerritEventSource!predicate"
        | doc "GerritEventSource refers to event-source related to gerrit events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "events", "gerritBaseURL", "hookName" ],
              _js2n__-prdslib.records.record
                {
                  auth =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.BasicAuth!predicate",
                  deleteHookOnFinish = _js2n__-prdslib.isType '"Bool",
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  gerritBaseURL = _js2n__-prdslib.isType '"String",
                  hookName = _js2n__-prdslib.isType '"String",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  projects =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  sslVerify = _js2n__-prdslib.isType '"Bool",
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GithubAppCreds!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "appID", "installationID", "privateKey" ],
              _js2n__-prdslib.records.record
                {
                  appID = _js2n__-prdslib.isType 'Integer,
                  installationID = _js2n__-prdslib.isType 'Integer,
                  privateKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GithubEventSource!predicate"
        | doc "GithubEventSource refers to event-source for github related events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "events" ],
              _js2n__-prdslib.records.record
                {
                  active = _js2n__-prdslib.isType '"Bool",
                  apiToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  contentType = _js2n__-prdslib.isType '"String",
                  deleteHookOnFinish = _js2n__-prdslib.isType '"Bool",
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  githubApp =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GithubAppCreds!predicate",
                  githubBaseURL = _js2n__-prdslib.isType '"String",
                  githubUploadURL = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType 'Integer,
                  insecure = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  organizations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  owner = _js2n__-prdslib.isType '"String",
                  repositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.OwnedRepositories!predicate"
                        ],
                  repository = _js2n__-prdslib.isType '"String",
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate",
                  webhookSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.GitlabEventSource!predicate"
        | doc "GitlabEventSource refers to event-source related to Gitlab events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "events", "gitlabBaseURL" ],
              _js2n__-prdslib.records.record
                {
                  accessToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  deleteHookOnFinish = _js2n__-prdslib.isType '"Bool",
                  enableSSLVerification = _js2n__-prdslib.isType '"Bool",
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  gitlabBaseURL = _js2n__-prdslib.isType '"String",
                  groups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  projectID = _js2n__-prdslib.isType '"String",
                  projects =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  secretToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.HDFSEventSource!predicate"
        | doc "HDFSEventSource refers to event-source for HDFS related events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "addresses", "directory", "type" ],
              _js2n__-prdslib.records.record
                {
                  addresses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  checkInterval = _js2n__-prdslib.isType '"String",
                  directory = _js2n__-prdslib.isType '"String",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  hdfsUser = _js2n__-prdslib.isType '"String",
                  krbCCacheSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  krbConfigConfigMap =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapKeySelector!predicate",
                  krbKeytabSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  krbRealm = _js2n__-prdslib.isType '"String",
                  krbServicePrincipalName = _js2n__-prdslib.isType '"String",
                  krbUsername = _js2n__-prdslib.isType '"String",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  pathRegexp = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.KafkaConsumerGroup!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "groupName" ],
              _js2n__-prdslib.records.record
                {
                  groupName = _js2n__-prdslib.isType '"String",
                  oldest = _js2n__-prdslib.isType '"Bool",
                  rebalanceStrategy = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.KafkaEventSource!predicate"
        | doc "KafkaEventSource refers to event-source for Kafka related events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "topic", "url" ],
              _js2n__-prdslib.records.record
                {
                  config = _js2n__-prdslib.isType '"String",
                  connectionBackoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  consumerGroup =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.KafkaConsumerGroup!predicate",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  limitEventsPerSecond = _js2n__-prdslib.isType 'Integer,
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  partition = _js2n__-prdslib.isType '"String",
                  sasl =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.SASLConfig!predicate",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  topic = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.MQTTEventSource!predicate"
        | doc "MQTTEventSource refers to event-source for MQTT related events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "clientId", "topic", "url" ],
              _js2n__-prdslib.records.record
                {
                  auth =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.BasicAuth!predicate",
                  clientId = _js2n__-prdslib.isType '"String",
                  connectionBackoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  topic = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.NATSAuth!predicate"
        | doc "NATSAuth refers to the auth info for NATS EventSource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  basic =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.BasicAuth!predicate",
                  credential =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  nkey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  token =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.NATSEventsSource!predicate"
        | doc "NATSEventsSource refers to event-source for NATS related events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "subject", "url" ],
              _js2n__-prdslib.records.record
                {
                  auth =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.NATSAuth!predicate",
                  connectionBackoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  queue = _js2n__-prdslib.isType '"String",
                  subject = _js2n__-prdslib.isType '"String",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.NSQEventSource!predicate"
        | doc "NSQEventSource describes the event source for NSQ PubSub More info at https://godoc.org/github.com/nsqio/go-nsq"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "channel", "hostAddress", "topic" ],
              _js2n__-prdslib.records.record
                {
                  channel = _js2n__-prdslib.isType '"String",
                  connectionBackoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  hostAddress = _js2n__-prdslib.isType '"String",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  topic = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.OwnedRepositories!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  owner = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.PubSubEventSource!predicate"
        | doc "PubSubEventSource refers to event-source for GCP PubSub related events."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  credentialSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  deleteSubscriptionOnFinish = _js2n__-prdslib.isType '"Bool",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  projectID = _js2n__-prdslib.isType '"String",
                  subscriptionID = _js2n__-prdslib.isType '"String",
                  topic = _js2n__-prdslib.isType '"String",
                  topicProjectID = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.PulsarEventSource!predicate"
        | doc "PulsarEventSource describes the event source for Apache Pulsar"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "topics", "url" ],
              _js2n__-prdslib.records.record
                {
                  authAthenzParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  authAthenzSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  authTokenSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  connectionBackoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  tlsAllowInsecureConnection = _js2n__-prdslib.isType '"Bool",
                  tlsTrustCertsSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  tlsValidateHostname = _js2n__-prdslib.isType '"Bool",
                  topics =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.RedisEventSource!predicate"
        | doc "RedisEventSource describes an event source for the Redis PubSub. More info at https://godoc.org/github.com/go-redis/redis#example-PubSub"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "channels", "hostAddress" ],
              _js2n__-prdslib.records.record
                {
                  channels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  db = _js2n__-prdslib.isType 'Integer,
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  hostAddress = _js2n__-prdslib.isType '"String",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  namespace = _js2n__-prdslib.isType '"String",
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.RedisStreamEventSource!predicate"
        | doc "RedisStreamEventSource describes an event source for Redis streams (https://redis.io/topics/streams-intro)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "hostAddress", "streams" ],
              _js2n__-prdslib.records.record
                {
                  consumerGroup = _js2n__-prdslib.isType '"String",
                  db = _js2n__-prdslib.isType 'Integer,
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  hostAddress = _js2n__-prdslib.isType '"String",
                  maxMsgCountPerRead = _js2n__-prdslib.isType 'Integer,
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  streams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.ResourceEventSource!predicate"
        | doc "ResourceEventSource refers to a event-source for K8s resource related events."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "eventTypes", "group", "namespace", "resource", "version" ],
              _js2n__-prdslib.records.record
                {
                  eventTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.ResourceFilter!predicate",
                  group = _js2n__-prdslib.isType '"String",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  namespace = _js2n__-prdslib.isType '"String",
                  resource = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.ResourceFilter!predicate"
        | doc "ResourceFilter contains K8s ObjectMeta information to further filter resource event objects"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  afterStart = _js2n__-prdslib.isType '"Bool",
                  createdBy =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.Selector!predicate"
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.Selector!predicate"
                        ],
                  prefix = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.SFTPEventSource!predicate"
        | doc "SFTPEventSource describes an event-source for sftp related events."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "eventType", "watchPathConfig" ],
              _js2n__-prdslib.records.record
                {
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  eventType = _js2n__-prdslib.isType '"String",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  pollIntervalDuration = _js2n__-prdslib.isType '"String",
                  sshKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  username =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  watchPathConfig =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WatchPathConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.SNSEventSource!predicate"
        | doc "SNSEventSource refers to event-source for AWS SNS related events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "region", "topicArn" ],
              _js2n__-prdslib.records.record
                {
                  accessKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  endpoint = _js2n__-prdslib.isType '"String",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  region = _js2n__-prdslib.isType '"String",
                  roleARN = _js2n__-prdslib.isType '"String",
                  secretKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  topicArn = _js2n__-prdslib.isType '"String",
                  validateSignature = _js2n__-prdslib.isType '"Bool",
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.SQSEventSource!predicate"
        | doc "SQSEventSource refers to event-source for AWS SQS related events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "queue", "region", "waitTimeSeconds" ],
              _js2n__-prdslib.records.record
                {
                  accessKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  dlq = _js2n__-prdslib.isType '"Bool",
                  endpoint = _js2n__-prdslib.isType '"String",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  jsonBody = _js2n__-prdslib.isType '"Bool",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  queue = _js2n__-prdslib.isType '"String",
                  queueAccountId = _js2n__-prdslib.isType '"String",
                  region = _js2n__-prdslib.isType '"String",
                  roleARN = _js2n__-prdslib.isType '"String",
                  secretKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  sessionToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  waitTimeSeconds = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.Selector!predicate"
        | doc "Selector represents conditional operation to select K8s objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "value" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  operation = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.Service!predicate"
        | doc "Service holds the service information eventsource exposes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clusterIP = _js2n__-prdslib.isType '"String",
                  ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ServicePort!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.SlackEventSource!predicate"
        | doc "SlackEventSource refers to event-source for Slack related events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  signingSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  token =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.StorageGridEventSource!predicate"
        | doc "StorageGridEventSource refers to event-source for StorageGrid related events"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "apiURL", "authToken", "bucket", "topicArn" ],
              _js2n__-prdslib.records.record
                {
                  apiURL = _js2n__-prdslib.isType '"String",
                  authToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  bucket = _js2n__-prdslib.isType '"String",
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.StorageGridFilter!predicate",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  region = _js2n__-prdslib.isType '"String",
                  topicArn = _js2n__-prdslib.isType '"String",
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.StorageGridFilter!predicate"
        | doc "StorageGridFilter represents filters to apply to bucket notifications for specifying constraints on objects"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "prefix", "suffix" ],
              _js2n__-prdslib.records.record
                {
                  prefix = _js2n__-prdslib.isType '"String",
                  suffix = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.StripeEventSource!predicate"
        | doc "StripeEventSource describes the event source for stripe webhook notifications More info at https://stripe.com/docs/webhooks"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  createWebhook = _js2n__-prdslib.isType '"Bool",
                  eventFilter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.Template!predicate"
        | doc "Template holds the information of an EventSource deployment template"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  affinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Affinity!predicate",
                  container =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Container!predicate",
                  imagePullSecrets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Metadata!predicate",
                  nodeSelector =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "priority" = _js2n__-prdslib.isType 'Integer,
                  priorityClassName = _js2n__-prdslib.isType '"String",
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodSecurityContext!predicate",
                  serviceAccountName = _js2n__-prdslib.isType '"String",
                  tolerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Toleration!predicate"
                        ],
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Volume!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WatchPathConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "directory" ],
              _js2n__-prdslib.records.record
                {
                  directory = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  pathRegexp = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookContext!predicate"
        | doc "WebhookContext holds a general purpose REST API context"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "endpoint", "method", "port", "url" ],
              _js2n__-prdslib.records.record
                {
                  authSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  endpoint = _js2n__-prdslib.isType '"String",
                  maxPayloadSize = _js2n__-prdslib.isType 'Integer,
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  method = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType '"String",
                  serverCertSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  serverKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.WebhookEventSource!predicate"
        | doc "CalendarEventSource describes an HTTP based EventSource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "endpoint", "method", "port", "url" ],
              _js2n__-prdslib.records.record
                {
                  authSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  endpoint = _js2n__-prdslib.isType '"String",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSourceFilter!predicate",
                  maxPayloadSize = _js2n__-prdslib.isType 'Integer,
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  method = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType '"String",
                  serverCertSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  serverKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.AWSLambdaTrigger!predicate"
        | doc "AWSLambdaTrigger refers to specification of the trigger to invoke an AWS Lambda function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "functionName", "payload", "region" ],
              _js2n__-prdslib.records.record
                {
                  accessKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  functionName = _js2n__-prdslib.isType '"String",
                  invocationType = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  payload =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  region = _js2n__-prdslib.isType '"String",
                  roleARN = _js2n__-prdslib.isType '"String",
                  secretKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ArgoWorkflowTrigger!predicate"
        | doc "ArgoWorkflowTrigger is the trigger for the Argo Workflow"
        = _js2n__-prdslib.allOf
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
                  operation = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ArtifactLocation!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ArtifactLocation!predicate"
        | doc "ArtifactLocation describes the source location for an external artifact"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configmap =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapKeySelector!predicate",
                  file =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.FileArtifact!predicate",
                  git =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.GitArtifact!predicate",
                  inline = _js2n__-prdslib.isType '"String",
                  resource =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Resource!predicate",
                  s3 =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.S3Artifact!predicate",
                  url =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.URLArtifact!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.AzureEventHubsTrigger!predicate"
        | doc "AzureEventHubsTrigger refers to specification of the Azure Event Hubs Trigger"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "fqdn", "hubName", "payload", "sharedAccessKeyName" ],
              _js2n__-prdslib.records.record
                {
                  fqdn = _js2n__-prdslib.isType '"String",
                  hubName = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  payload =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  sharedAccessKey =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  sharedAccessKeyName =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.AzureServiceBusTrigger!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "payload", "queueName", "subscriptionName", "topicName" ],
              _js2n__-prdslib.records.record
                {
                  connectionString =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  payload =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  queueName = _js2n__-prdslib.isType '"String",
                  subscriptionName = _js2n__-prdslib.isType '"String",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  topicName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ConditionsResetByTime!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cron = _js2n__-prdslib.isType '"String",
                  timezone = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ConditionsResetCriteria!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  byTime =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ConditionsResetByTime!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.CustomTrigger!predicate"
        | doc "CustomTrigger refers to the specification of the custom trigger."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "payload", "secure", "serverURL", "spec" ],
              _js2n__-prdslib.records.record
                {
                  certSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  payload =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  secure = _js2n__-prdslib.isType '"Bool",
                  serverNameOverride = _js2n__-prdslib.isType '"String",
                  serverURL = _js2n__-prdslib.isType '"String",
                  spec =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.DataFilter!predicate"
        | doc "DataFilter describes constraints and filters for event data Regular Expressions are purposefully not a feature as they are overkill for our uses here See Rob Pike's Post: https://commandcenter.blogspot.com/2011/08/regular-expressions-in-lexing-and.html"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path", "type", "value" ],
              _js2n__-prdslib.records.record
                {
                  comparator = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  template = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  value =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EmailTrigger!predicate"
        | doc "EmailTrigger refers to the specification of the email notification trigger."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  body = _js2n__-prdslib.isType '"String",
                  from = _js2n__-prdslib.isType '"String",
                  host = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  port = _js2n__-prdslib.isType 'Integer,
                  smtpPassword =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  subject = _js2n__-prdslib.isType '"String",
                  to =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  username = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EventContext!predicate"
        | doc "EventContext holds the context of the cloudevent received from an event source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "datacontenttype",
                  "id",
                  "source",
                  "specversion",
                  "subject",
                  "time",
                  "type"
                ],
              _js2n__-prdslib.records.record
                {
                  datacontenttype = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  source = _js2n__-prdslib.isType '"String",
                  specversion = _js2n__-prdslib.isType '"String",
                  subject = _js2n__-prdslib.isType '"String",
                  time =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  type = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EventDependency!predicate"
        | doc "EventDependency describes a dependency"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "eventName", "eventSourceName", "name" ],
              _js2n__-prdslib.records.record
                {
                  eventName = _js2n__-prdslib.isType '"String",
                  eventSourceName = _js2n__-prdslib.isType '"String",
                  filters =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EventDependencyFilter!predicate",
                  filtersLogicalOperator = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  transform =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EventDependencyTransformer!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EventDependencyFilter!predicate"
        | doc "EventDependencyFilter defines filters and constraints for a event."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  context =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EventContext!predicate",
                  data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.DataFilter!predicate"
                        ],
                  dataLogicalOperator = _js2n__-prdslib.isType '"String",
                  exprLogicalOperator = _js2n__-prdslib.isType '"String",
                  exprs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ExprFilter!predicate"
                        ],
                  script = _js2n__-prdslib.isType '"String",
                  time =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TimeFilter!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EventDependencyTransformer!predicate"
        | doc "EventDependencyTransformer transforms the event"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  jq = _js2n__-prdslib.isType '"String",
                  script = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ExprFilter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "expr", "fields" ],
              _js2n__-prdslib.records.record
                {
                  expr = _js2n__-prdslib.isType '"String",
                  fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.PayloadField!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.FileArtifact!predicate"
        | doc "FileArtifact contains information about an artifact in a filesystem"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { path = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.GitArtifact!predicate"
        | doc "GitArtifact contains information about an artifact stored in git"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "cloneDirectory", "filePath", "url" ],
              _js2n__-prdslib.records.record
                {
                  branch = _js2n__-prdslib.isType '"String",
                  cloneDirectory = _js2n__-prdslib.isType '"String",
                  creds =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.GitCreds!predicate",
                  filePath = _js2n__-prdslib.isType '"String",
                  insecureIgnoreHostKey = _js2n__-prdslib.isType '"Bool",
                  ref = _js2n__-prdslib.isType '"String",
                  remote =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.GitRemoteConfig!predicate",
                  sshKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  tag = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.GitCreds!predicate"
        | doc "GitCreds contain reference to git username and password"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  username =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.GitRemoteConfig!predicate"
        | doc "GitRemoteConfig contains the configuration of a Git remote"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "urls" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  urls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.HTTPTrigger!predicate"
        | doc "HTTPTrigger is the trigger for the HTTP request"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "payload", "url" ],
              _js2n__-prdslib.records.record
                {
                  basicAuth =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.BasicAuth!predicate",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  method = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  payload =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  secureHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.SecureHeader!predicate"
                        ],
                  timeout = _js2n__-prdslib.isType 'Integer,
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.K8SResourcePolicy!predicate"
        | doc "K8SResourcePolicy refers to the policy used to check the state of K8s based triggers using labels"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "backoff", "errorOnBackoffTimeout" ],
              _js2n__-prdslib.records.record
                {
                  backoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  errorOnBackoffTimeout = _js2n__-prdslib.isType '"Bool",
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.KafkaTrigger!predicate"
        | doc "KafkaTrigger refers to the specification of the Kafka trigger."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "payload", "topic", "url" ],
              _js2n__-prdslib.records.record
                {
                  compress = _js2n__-prdslib.isType '"Bool",
                  flushFrequency = _js2n__-prdslib.isType 'Integer,
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  partition = _js2n__-prdslib.isType 'Integer,
                  partitioningKey = _js2n__-prdslib.isType '"String",
                  payload =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  requiredAcks = _js2n__-prdslib.isType 'Integer,
                  sasl =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.SASLConfig!predicate",
                  schemaRegistry =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.SchemaRegistryConfig!predicate",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  topic = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.LogTrigger!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { intervalSeconds = _js2n__-prdslib.isType 'Integer, } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.NATSTrigger!predicate"
        | doc "NATSTrigger refers to the specification of the NATS trigger."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "payload", "subject", "url" ],
              _js2n__-prdslib.records.record
                {
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  payload =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  subject = _js2n__-prdslib.isType '"String",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.OpenWhiskTrigger!predicate"
        | doc "OpenWhiskTrigger refers to the specification of the OpenWhisk trigger."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "actionName", "host", "payload" ],
              _js2n__-prdslib.records.record
                {
                  actionName = _js2n__-prdslib.isType '"String",
                  authToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  host = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  payload =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.PayloadField!predicate"
        | doc "PayloadField binds a value at path within the event payload against a name."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "path" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.PulsarTrigger!predicate"
        | doc "PulsarTrigger refers to the specification of the Pulsar trigger."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "payload", "topic", "url" ],
              _js2n__-prdslib.records.record
                {
                  authAthenzParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  authAthenzSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  authTokenSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  connectionBackoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  payload =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.TLSConfig!predicate",
                  tlsAllowInsecureConnection = _js2n__-prdslib.isType '"Bool",
                  tlsTrustCertsSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  tlsValidateHostname = _js2n__-prdslib.isType '"Bool",
                  topic = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.RateLimit!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  requestsPerUnit = _js2n__-prdslib.isType 'Integer,
                  unit = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.Sensor!predicate"
        | doc "Sensor is the definition of a sensor resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "metadata", "spec" ],
              _js2n__-prdslib.records.record
                {
                  apiVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "argoproj.io/v1alpha1"
                        ],
                  kind =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "Sensor"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SensorSpec!predicate",
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SensorStatus!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SensorSpec!predicate"
        | doc "SensorSpec represents desired sensor state"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "dependencies", "triggers" ],
              _js2n__-prdslib.records.record
                {
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EventDependency!predicate"
                        ],
                  errorOnFailedRound = _js2n__-prdslib.isType '"Bool",
                  eventBusName = _js2n__-prdslib.isType '"String",
                  loggingFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  replicas = _js2n__-prdslib.isType 'Integer,
                  revisionHistoryLimit = _js2n__-prdslib.isType 'Integer,
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.Template!predicate",
                  triggers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.Trigger!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SensorStatus!predicate"
        | doc "SensorStatus contains information about the status of a sensor."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  conditions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Condition!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SlackSender!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  icon = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SlackThread!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  broadcastMessageToChannel = _js2n__-prdslib.isType '"Bool",
                  messageAggregationKey = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SlackTrigger!predicate"
        | doc "SlackTrigger refers to the specification of the slack notification trigger."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  attachments = _js2n__-prdslib.isType '"String",
                  blocks = _js2n__-prdslib.isType '"String",
                  channel = _js2n__-prdslib.isType '"String",
                  message = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  sender =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SlackSender!predicate",
                  slackToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  thread =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SlackThread!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.StandardK8STrigger!predicate"
        | doc "StandardK8STrigger is the standard Kubernetes resource trigger"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  liveObject = _js2n__-prdslib.isType '"Bool",
                  operation = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  patchStrategy = _js2n__-prdslib.isType '"String",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ArtifactLocation!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.StatusPolicy!predicate"
        | doc "StatusPolicy refers to the policy used to check the state of the trigger using response status"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "allow" ],
              _js2n__-prdslib.records.record
                {
                  allow =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Integer)
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.Template!predicate"
        | doc "Template holds the information of a sensor deployment template"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  affinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Affinity!predicate",
                  container =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Container!predicate",
                  imagePullSecrets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Metadata!predicate",
                  nodeSelector =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "priority" = _js2n__-prdslib.isType 'Integer,
                  priorityClassName = _js2n__-prdslib.isType '"String",
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodSecurityContext!predicate",
                  serviceAccountName = _js2n__-prdslib.isType '"String",
                  tolerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Toleration!predicate"
                        ],
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Volume!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TimeFilter!predicate"
        | doc "TimeFilter describes a window in time. It filters out events that occur outside the time limits. In other words, only events that occur after Start and before Stop will pass this filter."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "start", "stop" ],
              _js2n__-prdslib.records.record
                {
                  start = _js2n__-prdslib.isType '"String",
                  stop = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.Trigger!predicate"
        | doc "Trigger is an action taken, output produced, an event created, a message sent"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  atLeastOnce = _js2n__-prdslib.isType '"Bool",
                  dlqTrigger =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.Trigger!predicate",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
                        ],
                  policy =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerPolicy!predicate",
                  rateLimit =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.RateLimit!predicate",
                  retryStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.common.Backoff!predicate",
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerTemplate!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameter!predicate"
        | doc "TriggerParameter indicates a passed parameter to a service template"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "dest" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  operation = _js2n__-prdslib.isType '"String",
                  src =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameterSource!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerParameterSource!predicate"
        | doc "TriggerParameterSource defines the source for a parameter from a event event"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "dependencyName" ],
              _js2n__-prdslib.records.record
                {
                  contextKey = _js2n__-prdslib.isType '"String",
                  contextTemplate = _js2n__-prdslib.isType '"String",
                  dataKey = _js2n__-prdslib.isType '"String",
                  dataTemplate = _js2n__-prdslib.isType '"String",
                  dependencyName = _js2n__-prdslib.isType '"String",
                  useRawData = _js2n__-prdslib.isType '"Bool",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerPolicy!predicate"
        | doc "TriggerPolicy dictates the policy for the trigger retries"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  k8s =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.K8SResourcePolicy!predicate",
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.StatusPolicy!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.TriggerTemplate!predicate"
        | doc "TriggerTemplate is the template that describes trigger specification."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  argoWorkflow =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ArgoWorkflowTrigger!predicate",
                  awsLambda =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.AWSLambdaTrigger!predicate",
                  azureEventHubs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.AzureEventHubsTrigger!predicate",
                  azureServiceBus =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.AzureServiceBusTrigger!predicate",
                  conditions = _js2n__-prdslib.isType '"String",
                  conditionsReset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.ConditionsResetCriteria!predicate"
                        ],
                  custom =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.CustomTrigger!predicate",
                  email =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.EmailTrigger!predicate",
                  http =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.HTTPTrigger!predicate",
                  k8s =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.StandardK8STrigger!predicate",
                  kafka =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.KafkaTrigger!predicate",
                  log =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.LogTrigger!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  nats =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.NATSTrigger!predicate",
                  openWhisk =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.OpenWhiskTrigger!predicate",
                  pulsar =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.PulsarTrigger!predicate",
                  slack =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.SlackTrigger!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.sensor.v1alpha1.URLArtifact!predicate"
        | doc "URLArtifact contains information about an artifact at an http endpoint."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  verifyCert = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.AWSElasticBlockStoreVolumeSource!predicate"
        | doc m%"
          Represents a Persistent Disk resource in AWS.
          
          An AWS EBS disk must exist before mounting to a container. The disk must also be in the same AWS zone as the kubelet. An AWS EBS disk can only be mounted as read/write once. AWS EBS volumes support ownership management and SELinux relabeling.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "volumeID" ],
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  partition = _js2n__-prdslib.isType 'Integer,
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  volumeID = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.Affinity!predicate"
        | doc "Affinity is a group of affinity scheduling rules."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  nodeAffinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.NodeAffinity!predicate",
                  podAffinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodAffinity!predicate",
                  podAntiAffinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodAntiAffinity!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.AzureDiskVolumeSource!predicate"
        | doc "AzureDisk represents an Azure Data Disk mount on the host and bind mount to the pod."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "diskName", "diskURI" ],
              _js2n__-prdslib.records.record
                {
                  cachingMode = _js2n__-prdslib.isType '"String",
                  diskName = _js2n__-prdslib.isType '"String",
                  diskURI = _js2n__-prdslib.isType '"String",
                  fsType = _js2n__-prdslib.isType '"String",
                  kind = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.AzureFileVolumeSource!predicate"
        | doc "AzureFile represents an Azure File Service mount on the host and bind mount to the pod."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "secretName", "shareName" ],
              _js2n__-prdslib.records.record
                {
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretName = _js2n__-prdslib.isType '"String",
                  shareName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.CSIVolumeSource!predicate"
        | doc "Represents a source location of a volume to mount, managed by an external CSI driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "driver" ],
              _js2n__-prdslib.records.record
                {
                  driver = _js2n__-prdslib.isType '"String",
                  fsType = _js2n__-prdslib.isType '"String",
                  nodePublishSecretRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  volumeAttributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.Capabilities!predicate"
        | doc "Adds and removes POSIX capabilities from running containers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  add =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  drop =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.CephFSVolumeSource!predicate"
        | doc "Represents a Ceph Filesystem mount that lasts the lifetime of a pod Cephfs volumes do not support ownership management or SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "monitors" ],
              _js2n__-prdslib.records.record
                {
                  monitors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretFile = _js2n__-prdslib.isType '"String",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate",
                  user = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.CinderVolumeSource!predicate"
        | doc "Represents a cinder volume resource in Openstack. A Cinder volume must exist before mounting to a container. The volume must also be in the same region as the kubelet. Cinder volumes support ownership management and SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "volumeID" ],
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate",
                  volumeID = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ClusterTrustBundleProjection!predicate"
        | doc "ClusterTrustBundleProjection describes how to select a set of ClusterTrustBundle objects and project their contents into the pod filesystem."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  labelSelector =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  signerName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapEnvSource!predicate"
        | doc m%"
          ConfigMapEnvSource selects a ConfigMap to populate the environment variables with.
          
          The contents of the target ConfigMap's Data field will represent the key-value pairs as environment variables.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapKeySelector!predicate"
        | doc "Selects a key from a ConfigMap."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapProjection!predicate"
        | doc m%"
          Adapts a ConfigMap into a projected volume.
          
          The contents of the target ConfigMap's Data field will be presented in a projected volume as files using the keys in the Data field as the file names, unless the items element is populated with specific mappings of keys to paths. Note that this is identical to a configmap volume source without the default mode.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.KeyToPath!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapVolumeSource!predicate"
        | doc m%"
          Adapts a ConfigMap into a volume.
          
          The contents of the target ConfigMap's Data field will be presented in a volume as files using the keys in the Data field as the file names, unless the items element is populated with specific mappings of keys to paths. ConfigMap volumes support ownership management and SELinux relabeling.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultMode = _js2n__-prdslib.isType 'Integer,
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.KeyToPath!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.Container!predicate"
        | doc "A single application container that you want to run within a pod."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  command =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.EnvVar!predicate"
                        ],
                  envFrom =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.EnvFromSource!predicate"
                        ],
                  image = _js2n__-prdslib.isType '"String",
                  imagePullPolicy = _js2n__-prdslib.isType '"String",
                  lifecycle =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Lifecycle!predicate",
                  livenessProbe =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Probe!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ContainerPort!predicate"
                        ],
                  readinessProbe =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Probe!predicate",
                  resizePolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ContainerResizePolicy!predicate"
                        ],
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate",
                  restartPolicy = _js2n__-prdslib.isType '"String",
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecurityContext!predicate",
                  startupProbe =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Probe!predicate",
                  stdin = _js2n__-prdslib.isType '"Bool",
                  stdinOnce = _js2n__-prdslib.isType '"Bool",
                  terminationMessagePath = _js2n__-prdslib.isType '"String",
                  terminationMessagePolicy = _js2n__-prdslib.isType '"String",
                  tty = _js2n__-prdslib.isType '"Bool",
                  volumeDevices =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.VolumeDevice!predicate"
                        ],
                  volumeMounts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.VolumeMount!predicate"
                        ],
                  workingDir = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ContainerPort!predicate"
        | doc "ContainerPort represents a network port in a single container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "containerPort" ],
              _js2n__-prdslib.records.record
                {
                  containerPort = _js2n__-prdslib.isType 'Integer,
                  hostIP = _js2n__-prdslib.isType '"String",
                  hostPort = _js2n__-prdslib.isType 'Integer,
                  name = _js2n__-prdslib.isType '"String",
                  protocol = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ContainerResizePolicy!predicate"
        | doc "ContainerResizePolicy represents resource resize policy for the container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "resourceName", "restartPolicy" ],
              _js2n__-prdslib.records.record
                {
                  resourceName = _js2n__-prdslib.isType '"String",
                  restartPolicy = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.DownwardAPIProjection!predicate"
        | doc "Represents downward API info for projecting into a projected volume. Note that this is identical to a downwardAPI volume source without the default mode."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.DownwardAPIVolumeFile!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.DownwardAPIVolumeFile!predicate"
        | doc "DownwardAPIVolumeFile represents information to create the file containing the pod field"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  fieldRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ObjectFieldSelector!predicate",
                  mode = _js2n__-prdslib.isType 'Integer,
                  path = _js2n__-prdslib.isType '"String",
                  resourceFieldRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceFieldSelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.DownwardAPIVolumeSource!predicate"
        | doc "DownwardAPIVolumeSource represents a volume containing downward API info. Downward API volumes support ownership management and SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultMode = _js2n__-prdslib.isType 'Integer,
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.DownwardAPIVolumeFile!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.EmptyDirVolumeSource!predicate"
        | doc "Represents an empty directory for a pod. Empty directory volumes support ownership management and SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  medium = _js2n__-prdslib.isType '"String",
                  sizeLimit =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.EnvFromSource!predicate"
        | doc "EnvFromSource represents the source of a set of ConfigMaps"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configMapRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapEnvSource!predicate",
                  prefix = _js2n__-prdslib.isType '"String",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretEnvSource!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.EnvVar!predicate"
        | doc "EnvVar represents an environment variable present in a Container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                  valueFrom =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.EnvVarSource!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.EnvVarSource!predicate"
        | doc "EnvVarSource represents a source for the value of an EnvVar."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configMapKeyRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapKeySelector!predicate",
                  fieldRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ObjectFieldSelector!predicate",
                  resourceFieldRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceFieldSelector!predicate",
                  secretKeyRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.EphemeralVolumeSource!predicate"
        | doc "Represents an ephemeral volume that is handled by a normal storage driver."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  volumeClaimTemplate =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimTemplate!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ExecAction!predicate"
        | doc "ExecAction describes a \"run in container\" action."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  command =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.FCVolumeSource!predicate"
        | doc "Represents a Fibre Channel volume. Fibre Channel volumes can only be mounted as read/write once. Fibre Channel volumes support ownership management and SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  lun = _js2n__-prdslib.isType 'Integer,
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  targetWWNs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  wwids =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.FlexVolumeSource!predicate"
        | doc "FlexVolume represents a generic volume resource that is provisioned/attached using an exec based plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "driver" ],
              _js2n__-prdslib.records.record
                {
                  driver = _js2n__-prdslib.isType '"String",
                  fsType = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.FlockerVolumeSource!predicate"
        | doc "Represents a Flocker volume mounted by the Flocker agent. One and only one of datasetName and datasetUUID should be set. Flocker volumes do not support ownership management or SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  datasetName = _js2n__-prdslib.isType '"String",
                  datasetUUID = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.GCEPersistentDiskVolumeSource!predicate"
        | doc m%"
          Represents a Persistent Disk resource in Google Compute Engine.
          
          A GCE PD must exist before mounting to a container. The disk must also be in the same GCE project and zone as the kubelet. A GCE PD can only be mounted as read/write once or read-only many times. GCE PDs support ownership management and SELinux relabeling.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "pdName" ],
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  partition = _js2n__-prdslib.isType 'Integer,
                  pdName = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.GRPCAction!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "port" ],
              _js2n__-prdslib.records.record
                {
                  port = _js2n__-prdslib.isType 'Integer,
                  service = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.GitRepoVolumeSource!predicate"
        | doc m%"
          Represents a volume that is populated with the contents of a git repository. Git repo volumes do not support ownership management. Git repo volumes support SELinux relabeling.
          
          DEPRECATED: GitRepo is deprecated. To provision a container with a git repo, mount an EmptyDir into an InitContainer that clones the repo using git, then mount the EmptyDir into the Pod's container.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repository" ],
              _js2n__-prdslib.records.record
                {
                  directory = _js2n__-prdslib.isType '"String",
                  repository = _js2n__-prdslib.isType '"String",
                  revision = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.GlusterfsVolumeSource!predicate"
        | doc "Represents a Glusterfs mount that lasts the lifetime of a pod. Glusterfs volumes do not support ownership management or SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoints", "path" ],
              _js2n__-prdslib.records.record
                {
                  endpoints = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.HTTPGetAction!predicate"
        | doc "HTTPGetAction describes an action based on HTTP Get requests."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "port" ],
              _js2n__-prdslib.records.record
                {
                  host = _js2n__-prdslib.isType '"String",
                  httpHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.HTTPHeader!predicate"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  port =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.HTTPHeader!predicate"
        | doc "HTTPHeader describes a custom header to be used in HTTP probes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "value" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.HostPathVolumeSource!predicate"
        | doc "Represents a host path mapped into a pod. Host path volumes do not support ownership management or SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ISCSIVolumeSource!predicate"
        | doc "Represents an ISCSI disk. ISCSI volumes can only be mounted as read/write once. ISCSI volumes support ownership management and SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "iqn", "lun", "targetPortal" ],
              _js2n__-prdslib.records.record
                {
                  chapAuthDiscovery = _js2n__-prdslib.isType '"Bool",
                  chapAuthSession = _js2n__-prdslib.isType '"Bool",
                  fsType = _js2n__-prdslib.isType '"String",
                  initiatorName = _js2n__-prdslib.isType '"String",
                  iqn = _js2n__-prdslib.isType '"String",
                  iscsiInterface = _js2n__-prdslib.isType '"String",
                  lun = _js2n__-prdslib.isType 'Integer,
                  portals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate",
                  targetPortal = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.KeyToPath!predicate"
        | doc "Maps a string key to a path within a volume."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "path" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  mode = _js2n__-prdslib.isType 'Integer,
                  path = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.Lifecycle!predicate"
        | doc "Lifecycle describes actions that the management system should take in response to container lifecycle events. For the PostStart and PreStop lifecycle handlers, management of the container blocks until the action is complete, unless the container process fails, in which case the handler is aborted."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  postStart =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LifecycleHandler!predicate",
                  preStop =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LifecycleHandler!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.LifecycleHandler!predicate"
        | doc "LifecycleHandler defines a specific action that should be taken in a lifecycle hook. One and only one of the fields, except TCPSocket must be specified."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exec =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ExecAction!predicate",
                  httpGet =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.HTTPGetAction!predicate",
                  sleep =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SleepAction!predicate",
                  tcpSocket =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.TCPSocketAction!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate"
        | doc "LocalObjectReference contains enough information to let you locate the referenced object inside the same namespace."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { name = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.NFSVolumeSource!predicate"
        | doc "Represents an NFS mount that lasts the lifetime of a pod. NFS volumes do not support ownership management or SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path", "server" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  server = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.NodeAffinity!predicate"
        | doc "Node affinity is a group of node affinity scheduling rules."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  preferredDuringSchedulingIgnoredDuringExecution =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PreferredSchedulingTerm!predicate"
                        ],
                  requiredDuringSchedulingIgnoredDuringExecution =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.NodeSelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.NodeSelector!predicate"
        | doc "A node selector represents the union of the results of one or more label queries over a set of nodes; that is, it represents the OR of the selectors represented by the node selector terms."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "nodeSelectorTerms" ],
              _js2n__-prdslib.records.record
                {
                  nodeSelectorTerms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.NodeSelectorTerm!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.NodeSelectorRequirement!predicate"
        | doc "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "operator" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  operator = _js2n__-prdslib.isType '"String",
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.NodeSelectorTerm!predicate"
        | doc "A null or empty node selector term matches no objects. The requirements of them are ANDed. The TopologySelectorTerm type implements a subset of the NodeSelectorTerm."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  matchExpressions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.NodeSelectorRequirement!predicate"
                        ],
                  matchFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.NodeSelectorRequirement!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ObjectFieldSelector!predicate"
        | doc "ObjectFieldSelector selects an APIVersioned field of an object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fieldPath" ],
              _js2n__-prdslib.records.record
                {
                  apiVersion = _js2n__-prdslib.isType '"String",
                  fieldPath = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimSpec!predicate"
        | doc "PersistentVolumeClaimSpec describes the common attributes of storage devices and allows a Source for provider-specific attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessModes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dataSource =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.TypedLocalObjectReference!predicate",
                  dataSourceRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.TypedObjectReference!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.VolumeResourceRequirements!predicate",
                  selector =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector!predicate",
                  storageClassName = _js2n__-prdslib.isType '"String",
                  volumeAttributesClassName = _js2n__-prdslib.isType '"String",
                  volumeMode = _js2n__-prdslib.isType '"String",
                  volumeName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimTemplate!predicate"
        | doc "PersistentVolumeClaimTemplate is used to produce PersistentVolumeClaim objects as part of an EphemeralVolumeSource."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "spec" ],
              _js2n__-prdslib.records.record
                {
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimSpec!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimVolumeSource!predicate"
        | doc "PersistentVolumeClaimVolumeSource references the user's PVC in the same namespace. This volume finds the bound PV and mounts that volume for the pod. A PersistentVolumeClaimVolumeSource is, essentially, a wrapper around another type of volume that is owned by someone else (the system)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "claimName" ],
              _js2n__-prdslib.records.record
                {
                  claimName = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PhotonPersistentDiskVolumeSource!predicate"
        | doc "Represents a Photon Controller persistent disk resource."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "pdID" ],
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  pdID = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PodAffinity!predicate"
        | doc "Pod affinity is a group of inter pod affinity scheduling rules."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  preferredDuringSchedulingIgnoredDuringExecution =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.WeightedPodAffinityTerm!predicate"
                        ],
                  requiredDuringSchedulingIgnoredDuringExecution =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodAffinityTerm!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PodAffinityTerm!predicate"
        | doc "Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "topologyKey" ],
              _js2n__-prdslib.records.record
                {
                  labelSelector =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector!predicate",
                  matchLabelKeys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  mismatchLabelKeys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  namespaceSelector =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector!predicate",
                  namespaces =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  topologyKey = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PodAntiAffinity!predicate"
        | doc "Pod anti affinity is a group of inter pod anti affinity scheduling rules."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  preferredDuringSchedulingIgnoredDuringExecution =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.WeightedPodAffinityTerm!predicate"
                        ],
                  requiredDuringSchedulingIgnoredDuringExecution =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodAffinityTerm!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PodSecurityContext!predicate"
        | doc "PodSecurityContext holds pod-level security attributes and common container settings. Some fields are also present in container.securityContext.  Field values of container.securityContext take precedence over field values of PodSecurityContext."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsGroup = _js2n__-prdslib.isType 'Integer,
                  fsGroupChangePolicy = _js2n__-prdslib.isType '"String",
                  runAsGroup = _js2n__-prdslib.isType 'Integer,
                  runAsNonRoot = _js2n__-prdslib.isType '"Bool",
                  runAsUser = _js2n__-prdslib.isType 'Integer,
                  seLinuxOptions =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SELinuxOptions!predicate",
                  seccompProfile =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SeccompProfile!predicate",
                  supplementalGroups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Integer)
                        ],
                  sysctls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Sysctl!predicate"
                        ],
                  windowsOptions =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.WindowsSecurityContextOptions!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PortworxVolumeSource!predicate"
        | doc "PortworxVolumeSource represents a Portworx volume resource."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "volumeID" ],
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  volumeID = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PreferredSchedulingTerm!predicate"
        | doc "An empty preferred scheduling term matches all objects with implicit weight 0 (i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "preference", "weight" ],
              _js2n__-prdslib.records.record
                {
                  preference =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.NodeSelectorTerm!predicate",
                  weight = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.Probe!predicate"
        | doc "Probe describes a health check to be performed against a container to determine whether it is alive or ready to receive traffic."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exec =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ExecAction!predicate",
                  failureThreshold = _js2n__-prdslib.isType 'Integer,
                  grpc =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.GRPCAction!predicate",
                  httpGet =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.HTTPGetAction!predicate",
                  initialDelaySeconds = _js2n__-prdslib.isType 'Integer,
                  periodSeconds = _js2n__-prdslib.isType 'Integer,
                  successThreshold = _js2n__-prdslib.isType 'Integer,
                  tcpSocket =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.TCPSocketAction!predicate",
                  terminationGracePeriodSeconds =
                    _js2n__-prdslib.isType 'Integer,
                  timeoutSeconds = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ProjectedVolumeSource!predicate"
        | doc "Represents a projected volume source"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultMode = _js2n__-prdslib.isType 'Integer,
                  sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.VolumeProjection!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.QuobyteVolumeSource!predicate"
        | doc "Represents a Quobyte mount that lasts the lifetime of a pod. Quobyte volumes do not support ownership management or SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "registry", "volume" ],
              _js2n__-prdslib.records.record
                {
                  group = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  registry = _js2n__-prdslib.isType '"String",
                  tenant = _js2n__-prdslib.isType '"String",
                  user = _js2n__-prdslib.isType '"String",
                  volume = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.RBDVolumeSource!predicate"
        | doc "Represents a Rados Block Device mount that lasts the lifetime of a pod. RBD volumes support ownership management and SELinux relabeling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "image", "monitors" ],
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                  keyring = _js2n__-prdslib.isType '"String",
                  monitors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  pool = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate",
                  user = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ResourceClaim!predicate"
        | doc "ResourceClaim references one entry in PodSpec.ResourceClaims."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                { name = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ResourceFieldSelector!predicate"
        | doc "ResourceFieldSelector represents container resources (cpu, memory) and their output format"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "resource" ],
              _js2n__-prdslib.records.record
                {
                  containerName = _js2n__-prdslib.isType '"String",
                  divisor =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate",
                  resource = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate"
        | doc "ResourceRequirements describes the compute resource requirements."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  claims =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceClaim!predicate"
                        ],
                  limits =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
                        ],
                  requests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.SELinuxOptions!predicate"
        | doc "SELinuxOptions are the labels to be applied to the container"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  level = _js2n__-prdslib.isType '"String",
                  role = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  user = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ScaleIOVolumeSource!predicate"
        | doc "ScaleIOVolumeSource represents a persistent ScaleIO volume"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "gateway", "secretRef", "system" ],
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  gateway = _js2n__-prdslib.isType '"String",
                  protectionDomain = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate",
                  sslEnabled = _js2n__-prdslib.isType '"Bool",
                  storageMode = _js2n__-prdslib.isType '"String",
                  storagePool = _js2n__-prdslib.isType '"String",
                  system = _js2n__-prdslib.isType '"String",
                  volumeName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.SeccompProfile!predicate"
        | doc "SeccompProfile defines a pod/container's seccomp profile settings. Only one profile source may be set."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  localhostProfile = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.SecretEnvSource!predicate"
        | doc m%"
          SecretEnvSource selects a Secret to populate the environment variables with.
          
          The contents of the target Secret's Data field will represent the key-value pairs as environment variables.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate"
        | doc "SecretKeySelector selects a key of a Secret."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.SecretProjection!predicate"
        | doc m%"
          Adapts a secret into a projected volume.
          
          The contents of the target Secret's Data field will be presented in a projected volume as files using the keys in the Data field as the file names. Note that this is identical to a secret volume source without the default mode.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.KeyToPath!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.SecretVolumeSource!predicate"
        | doc m%"
          Adapts a Secret into a volume.
          
          The contents of the target Secret's Data field will be presented in a volume as files using the keys in the Data field as the file names. Secret volumes support ownership management and SELinux relabeling.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultMode = _js2n__-prdslib.isType 'Integer,
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.KeyToPath!predicate"
                        ],
                  "optional" = _js2n__-prdslib.isType '"Bool",
                  secretName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.SecurityContext!predicate"
        | doc "SecurityContext holds security configuration that will be applied to a container. Some fields are present in both SecurityContext and PodSecurityContext.  When both are set, the values in SecurityContext take precedence."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowPrivilegeEscalation = _js2n__-prdslib.isType '"Bool",
                  capabilities =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Capabilities!predicate",
                  privileged = _js2n__-prdslib.isType '"Bool",
                  procMount = _js2n__-prdslib.isType '"String",
                  readOnlyRootFilesystem = _js2n__-prdslib.isType '"Bool",
                  runAsGroup = _js2n__-prdslib.isType 'Integer,
                  runAsNonRoot = _js2n__-prdslib.isType '"Bool",
                  runAsUser = _js2n__-prdslib.isType 'Integer,
                  seLinuxOptions =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SELinuxOptions!predicate",
                  seccompProfile =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SeccompProfile!predicate",
                  windowsOptions =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.WindowsSecurityContextOptions!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ServiceAccountTokenProjection!predicate"
        | doc "ServiceAccountTokenProjection represents a projected service account token volume. This projection can be used to insert a service account token into the pods runtime filesystem for use against APIs (Kubernetes API Server or otherwise)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  audience = _js2n__-prdslib.isType '"String",
                  expirationSeconds = _js2n__-prdslib.isType 'Integer,
                  path = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ServicePort!predicate"
        | doc "ServicePort contains information on service's port."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "port" ],
              _js2n__-prdslib.records.record
                {
                  appProtocol = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  nodePort = _js2n__-prdslib.isType 'Integer,
                  port = _js2n__-prdslib.isType 'Integer,
                  protocol = _js2n__-prdslib.isType '"String",
                  targetPort =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.SleepAction!predicate"
        | doc "SleepAction describes a \"sleep\" action."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "seconds" ],
              _js2n__-prdslib.records.record
                { seconds = _js2n__-prdslib.isType 'Integer, } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.StorageOSVolumeSource!predicate"
        | doc "Represents a StorageOS persistent volume resource."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate",
                  volumeName = _js2n__-prdslib.isType '"String",
                  volumeNamespace = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.Sysctl!predicate"
        | doc "Sysctl defines a kernel parameter to be set"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "value" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.TCPSocketAction!predicate"
        | doc "TCPSocketAction describes an action based on opening a socket"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "port" ],
              _js2n__-prdslib.records.record
                {
                  host = _js2n__-prdslib.isType '"String",
                  port =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.Toleration!predicate"
        | doc "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  effect = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  operator = _js2n__-prdslib.isType '"String",
                  tolerationSeconds = _js2n__-prdslib.isType 'Integer,
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.TypedLocalObjectReference!predicate"
        | doc "TypedLocalObjectReference contains enough information to let you locate the typed referenced object inside the same namespace."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "kind", "name" ],
              _js2n__-prdslib.records.record
                {
                  apiGroup = _js2n__-prdslib.isType '"String",
                  kind = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.TypedObjectReference!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "kind", "name" ],
              _js2n__-prdslib.records.record
                {
                  apiGroup = _js2n__-prdslib.isType '"String",
                  kind = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.Volume!predicate"
        | doc "Volume represents a named volume in a pod that may be accessed by any container in the pod."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  awsElasticBlockStore =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.AWSElasticBlockStoreVolumeSource!predicate",
                  azureDisk =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.AzureDiskVolumeSource!predicate",
                  azureFile =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.AzureFileVolumeSource!predicate",
                  cephfs =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.CephFSVolumeSource!predicate",
                  cinder =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.CinderVolumeSource!predicate",
                  configMap =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapVolumeSource!predicate",
                  csi =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.CSIVolumeSource!predicate",
                  downwardAPI =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.DownwardAPIVolumeSource!predicate",
                  emptyDir =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.EmptyDirVolumeSource!predicate",
                  ephemeral =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.EphemeralVolumeSource!predicate",
                  fc =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.FCVolumeSource!predicate",
                  flexVolume =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.FlexVolumeSource!predicate",
                  flocker =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.FlockerVolumeSource!predicate",
                  gcePersistentDisk =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.GCEPersistentDiskVolumeSource!predicate",
                  gitRepo =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.GitRepoVolumeSource!predicate",
                  glusterfs =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.GlusterfsVolumeSource!predicate",
                  hostPath =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.HostPathVolumeSource!predicate",
                  iscsi =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ISCSIVolumeSource!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  nfs =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.NFSVolumeSource!predicate",
                  persistentVolumeClaim =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimVolumeSource!predicate",
                  photonPersistentDisk =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PhotonPersistentDiskVolumeSource!predicate",
                  portworxVolume =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PortworxVolumeSource!predicate",
                  projected =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ProjectedVolumeSource!predicate",
                  quobyte =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.QuobyteVolumeSource!predicate",
                  rbd =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.RBDVolumeSource!predicate",
                  scaleIO =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ScaleIOVolumeSource!predicate",
                  secret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretVolumeSource!predicate",
                  storageos =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.StorageOSVolumeSource!predicate",
                  vsphereVolume =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.VsphereVirtualDiskVolumeSource!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.VolumeDevice!predicate"
        | doc "volumeDevice describes a mapping of a raw block device within a container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "devicePath", "name" ],
              _js2n__-prdslib.records.record
                {
                  devicePath = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.VolumeMount!predicate"
        | doc "VolumeMount describes a mounting of a Volume within a container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "mountPath", "name" ],
              _js2n__-prdslib.records.record
                {
                  mountPath = _js2n__-prdslib.isType '"String",
                  mountPropagation = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  subPath = _js2n__-prdslib.isType '"String",
                  subPathExpr = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.VolumeProjection!predicate"
        | doc "Projection that may be projected along with other supported volume types"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clusterTrustBundle =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ClusterTrustBundleProjection!predicate",
                  configMap =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapProjection!predicate",
                  downwardAPI =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.DownwardAPIProjection!predicate",
                  secret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretProjection!predicate",
                  serviceAccountToken =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ServiceAccountTokenProjection!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.VolumeResourceRequirements!predicate"
        | doc "VolumeResourceRequirements describes the storage resource requirements for a volume."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  limits =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
                        ],
                  requests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.VsphereVirtualDiskVolumeSource!predicate"
        | doc "Represents a vSphere volume resource."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "volumePath" ],
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  storagePolicyID = _js2n__-prdslib.isType '"String",
                  storagePolicyName = _js2n__-prdslib.isType '"String",
                  volumePath = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.WeightedPodAffinityTerm!predicate"
        | doc "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "podAffinityTerm", "weight" ],
              _js2n__-prdslib.records.record
                {
                  podAffinityTerm =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodAffinityTerm!predicate",
                  weight = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.WindowsSecurityContextOptions!predicate"
        | doc "WindowsSecurityContextOptions contain Windows-specific options and credentials."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  gmsaCredentialSpec = _js2n__-prdslib.isType '"String",
                  gmsaCredentialSpecName = _js2n__-prdslib.isType '"String",
                  hostProcess = _js2n__-prdslib.isType '"Bool",
                  runAsUserName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
        | doc m%"
          Quantity is a fixed-point representation of a number. It provides convenient marshaling/unmarshaling in JSON and YAML, in addition to String() and AsInt64() accessors.
          
          The serialization format is:
          
          ``` <quantity>        ::= <signedNumber><suffix>
          
          	(Note that <suffix> may be empty, from the "" case in <decimalSI>.)
          
          <digit>           ::= 0 | 1 | ... | 9 <digits>          ::= <digit> | <digit><digits> <number>          ::= <digits> | <digits>.<digits> | <digits>. | .<digits> <sign>            ::= "+" | "-" <signedNumber>    ::= <number> | <sign><number> <suffix>          ::= <binarySI> | <decimalExponent> | <decimalSI> <binarySI>        ::= Ki | Mi | Gi | Ti | Pi | Ei
          
          	(International System of units; See: http://physics.nist.gov/cuu/Units/binary.html)
          
          <decimalSI>       ::= m | "" | k | M | G | T | P | E
          
          	(Note that 1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization.)
          
          <decimalExponent> ::= "e" <signedNumber> | "E" <signedNumber> ```
          
          No matter which of the three exponent forms is used, no quantity may represent a number greater than 2^63-1 in magnitude, nor may it have more than 3 decimal places. Numbers larger or more precise will be capped or rounded up. (E.g.: 0.1m will rounded up to 1m.) This may be extended in the future if we require larger or smaller quantities.
          
          When a Quantity is parsed from a string, it will remember the type of suffix it had, and will use the same type again when it is serialized.
          
          Before serializing, Quantity will be put in "canonical form". This means that Exponent/suffix will be adjusted up or down (with a corresponding increase or decrease in Mantissa) such that:
          
          - No precision is lost - No fractional digits will be emitted - The exponent (or suffix) is as large as possible.
          
          The sign will be omitted unless the number is negative.
          
          Examples:
          
          - 1.5 will be serialized as "1500m" - 1.5Gi will be serialized as "1536Mi"
          
          Note that the quantity will NEVER be internally represented by a floating point number. That is the whole point of this exercise.
          
          Non-canonical values will still parse as long as they are well formed, but will be re-emitted in their canonical form. (So always use canonical form, or don't diff.)
          
          This format is intended to make it difficult to use these numbers without writing some sort of special handling code in the hopes that that will cause implementors to also use a fixed point implementation.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.FieldsV1!predicate"
        | doc m%"
          FieldsV1 stores a set of fields in a data structure like a Trie, in JSON format.
          
          Each key is either a '.' representing the field itself, and will always map to an empty set, or a string representing a sub-field or item. The string will follow one of these four formats: 'f:<name>', where <name> is the name of a field in a struct, or key in a map 'v:<value>', where <value> is the exact json formatted value of a list item 'i:<index>', where <index> is position of a item in a list 'k:<keys>', where <keys> is a map of  a list item's key fields to their unique values If a key maps to an empty Fields value, the field that key represents is part of the set.
          
          The exact format is defined in sigs.k8s.io/structured-merge-diff
        "%
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector!predicate"
        | doc "A label selector is a label query over a set of resources. The result of matchLabels and matchExpressions are ANDed. An empty label selector matches all objects. A null label selector matches no objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  matchExpressions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelectorRequirement!predicate"
                        ],
                  matchLabels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelectorRequirement!predicate"
        | doc "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "operator" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  operator = _js2n__-prdslib.isType '"String",
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ManagedFieldsEntry!predicate"
        | doc "ManagedFieldsEntry is a workflow-id, a FieldSet and the group version of the resource that the fieldset applies to."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiVersion = _js2n__-prdslib.isType '"String",
                  fieldsType = _js2n__-prdslib.isType '"String",
                  fieldsV1 =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.FieldsV1!predicate",
                  manager = _js2n__-prdslib.isType '"String",
                  operation = _js2n__-prdslib.isType '"String",
                  subresource = _js2n__-prdslib.isType '"String",
                  time =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate"
        | doc "ObjectMeta is metadata that all persisted resources must have, which includes all objects users must create."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  creationTimestamp =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  deletionGracePeriodSeconds = _js2n__-prdslib.isType 'Integer,
                  deletionTimestamp =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  finalizers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  generateName = _js2n__-prdslib.isType '"String",
                  generation = _js2n__-prdslib.isType 'Integer,
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  managedFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ManagedFieldsEntry!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  ownerReferences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference!predicate"
                        ],
                  resourceVersion = _js2n__-prdslib.isType '"String",
                  selfLink = _js2n__-prdslib.isType '"String",
                  uid = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference!predicate"
        | doc "OwnerReference contains enough information to let you identify an owning object. An owning object must be in the same namespace as the dependent, or be cluster-scoped, so there is no namespace field."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "apiVersion", "kind", "name", "uid" ],
              _js2n__-prdslib.records.record
                {
                  apiVersion = _js2n__-prdslib.isType '"String",
                  blockOwnerDeletion = _js2n__-prdslib.isType '"Bool",
                  controller = _js2n__-prdslib.isType '"Bool",
                  kind = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  uid = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate"
        | doc "Time is a wrapper around time.Time which supports correct marshaling to YAML and JSON.  Wrappers are provided for many of the factory methods that the time package offers."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate"
        | doc "IntOrString is a type that can hold an int32 or a string.  When used in JSON or YAML marshalling and unmarshalling, it produces or consumes the inner type.  This allows you to have, for example, a JSON field that can accept a name or number."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.isType '"String"
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventbus.v1alpha1.EventBus!predicate",
              _js2n__-refsenv."_js2n__-:definitions/io.argoproj.eventsource.v1alpha1.EventSource!predicate",
              _js2n__-refsenv."_js2n__-:definitions/io.argoproj.sensor.v1alpha1.Sensor!predicate"
            ]
        ])