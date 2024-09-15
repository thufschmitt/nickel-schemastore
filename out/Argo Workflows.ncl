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
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Amount!predicate"
        | doc "Amount represent a numeric amount."
        = _js2n__-prdslib.isType '"Number",
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArchiveStrategy!predicate"
        | doc "ArchiveStrategy describes how to archive files/directory when saving artifacts"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  none =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.NoneStrategy!predicate",
                  tar =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TarStrategy!predicate",
                  zip =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ZipStrategy!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Arguments!predicate"
        | doc "Arguments to a template"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Artifact!predicate"
                        ],
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Parameter!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtGCStatus!predicate"
        | doc "ArtGCStatus maintains state related to ArtifactGC"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  notSpecified = _js2n__-prdslib.isType '"Bool",
                  podsRecouped =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"Bool")
                        ],
                  strategiesProcessed =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"Bool")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Artifact!predicate"
        | doc "Artifact indicates an artifact to place at a specified path"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  archive =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArchiveStrategy!predicate",
                  archiveLogs = _js2n__-prdslib.isType '"Bool",
                  artifactGC =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactGC!predicate",
                  artifactory =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactoryArtifact!predicate",
                  azure =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.AzureArtifact!predicate",
                  deleted = _js2n__-prdslib.isType '"Bool",
                  from = _js2n__-prdslib.isType '"String",
                  fromExpression = _js2n__-prdslib.isType '"String",
                  gcs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GCSArtifact!predicate",
                  git =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GitArtifact!predicate",
                  globalName = _js2n__-prdslib.isType '"String",
                  hdfs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HDFSArtifact!predicate",
                  http =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPArtifact!predicate",
                  mode = _js2n__-prdslib.isType 'Integer,
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                  oss =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OSSArtifact!predicate",
                  path = _js2n__-prdslib.isType '"String",
                  raw =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RawArtifact!predicate",
                  recurseMode = _js2n__-prdslib.isType '"Bool",
                  s3 =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.S3Artifact!predicate",
                  subPath = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactGC!predicate"
        | doc "ArtifactGC describes how to delete artifacts from completed Workflows - this is embedded into the WorkflowLevelArtifactGC, and also used for individual Artifacts to override that as needed"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  podMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Metadata!predicate",
                  serviceAccountName = _js2n__-prdslib.isType '"String",
                  strategy = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactLocation!predicate"
        | doc "ArtifactLocation describes a location for a single or multiple artifacts. It is used as single artifact in the context of inputs/outputs (e.g. outputs.artifacts.artname). It is also used to describe the location of multiple artifacts such as the archive location of a single workflow step, which the executor will use as a default location to store its files."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  archiveLogs = _js2n__-prdslib.isType '"Bool",
                  artifactory =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactoryArtifact!predicate",
                  azure =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.AzureArtifact!predicate",
                  gcs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GCSArtifact!predicate",
                  git =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GitArtifact!predicate",
                  hdfs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HDFSArtifact!predicate",
                  http =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPArtifact!predicate",
                  oss =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OSSArtifact!predicate",
                  raw =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RawArtifact!predicate",
                  s3 =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.S3Artifact!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactPaths!predicate"
        | doc "ArtifactPaths expands a step from a collection of artifacts"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  archive =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArchiveStrategy!predicate",
                  archiveLogs = _js2n__-prdslib.isType '"Bool",
                  artifactGC =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactGC!predicate",
                  artifactory =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactoryArtifact!predicate",
                  azure =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.AzureArtifact!predicate",
                  deleted = _js2n__-prdslib.isType '"Bool",
                  from = _js2n__-prdslib.isType '"String",
                  fromExpression = _js2n__-prdslib.isType '"String",
                  gcs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GCSArtifact!predicate",
                  git =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GitArtifact!predicate",
                  globalName = _js2n__-prdslib.isType '"String",
                  hdfs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HDFSArtifact!predicate",
                  http =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPArtifact!predicate",
                  mode = _js2n__-prdslib.isType 'Integer,
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                  oss =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OSSArtifact!predicate",
                  path = _js2n__-prdslib.isType '"String",
                  raw =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RawArtifact!predicate",
                  recurseMode = _js2n__-prdslib.isType '"Bool",
                  s3 =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.S3Artifact!predicate",
                  subPath = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactRepository!predicate"
        | doc "ArtifactRepository represents an artifact repository in which a controller will store its artifacts"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  archiveLogs = _js2n__-prdslib.isType '"Bool",
                  artifactory =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactoryArtifactRepository!predicate",
                  azure =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.AzureArtifactRepository!predicate",
                  gcs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GCSArtifactRepository!predicate",
                  hdfs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HDFSArtifactRepository!predicate",
                  oss =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OSSArtifactRepository!predicate",
                  s3 =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.S3ArtifactRepository!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactRepositoryRef!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configMap = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactRepositoryRefStatus!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactRepository =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactRepository!predicate",
                  configMap = _js2n__-prdslib.isType '"String",
                  "default" = _js2n__-prdslib.isType '"Bool",
                  key = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactoryArtifact!predicate"
        | doc "ArtifactoryArtifact is the location of an artifactory artifact"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  passwordSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  url = _js2n__-prdslib.isType '"String",
                  usernameSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactoryArtifactRepository!predicate"
        | doc "ArtifactoryArtifactRepository defines the controller configuration for an artifactory artifact repository"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  keyFormat = _js2n__-prdslib.isType '"String",
                  passwordSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  repoURL = _js2n__-prdslib.isType '"String",
                  usernameSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.AzureArtifact!predicate"
        | doc "AzureArtifact is the location of a an Azure Storage artifact"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "blob", "container", "endpoint" ],
              _js2n__-prdslib.records.record
                {
                  accountKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  blob = _js2n__-prdslib.isType '"String",
                  container = _js2n__-prdslib.isType '"String",
                  endpoint = _js2n__-prdslib.isType '"String",
                  useSDKCreds = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.AzureArtifactRepository!predicate"
        | doc "AzureArtifactRepository defines the controller configuration for an Azure Blob Storage artifact repository"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "container", "endpoint" ],
              _js2n__-prdslib.records.record
                {
                  accountKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  blobNameFormat = _js2n__-prdslib.isType '"String",
                  container = _js2n__-prdslib.isType '"String",
                  endpoint = _js2n__-prdslib.isType '"String",
                  useSDKCreds = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Backoff!predicate"
        | doc "Backoff is a backoff strategy to use within retryStrategy"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  duration = _js2n__-prdslib.isType '"String",
                  factor =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                  maxDuration = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.BasicAuth!predicate"
        | doc "BasicAuth describes the secret selectors required for basic authentication"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  passwordSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  usernameSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Cache!predicate"
        | doc "Cache is the configuration for the type of cache to be used"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "configMap" ],
              _js2n__-prdslib.records.record
                {
                  configMap =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ClientCertAuth!predicate"
        | doc "ClientCertAuth holds necessary information for client authentication via certificates"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clientCertSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  clientKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate!predicate"
        | doc "ClusterWorkflowTemplate is the definition of a workflow template resource in cluster scope"
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
                          _js2n__-prdslib.const "ClusterWorkflowTemplate"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowSpec!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Condition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  message = _js2n__-prdslib.isType '"String",
                  status = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ContainerNode!predicate" =
        _js2n__-prdslib.allOf
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
                  dependencies =
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
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate",
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
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ContainerSetRetryStrategy!predicate"
        | doc "ContainerSetRetryStrategy provides controls on how to retry a container set"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "retries" ],
              _js2n__-prdslib.records.record
                {
                  duration = _js2n__-prdslib.isType '"String",
                  retries =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ContainerSetTemplate!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "containers" ],
              _js2n__-prdslib.records.record
                {
                  containers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ContainerNode!predicate"
                        ],
                  retryStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ContainerSetRetryStrategy!predicate",
                  volumeMounts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.VolumeMount!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ContinueOn!predicate"
        | doc "ContinueOn defines if a workflow should continue even if a task or step fails/errors. It can be specified if the workflow should continue when the pod errors, fails or both."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  error = _js2n__-prdslib.isType '"Bool",
                  failed = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Counter!predicate"
        | doc "Counter is a Counter prometheus metric"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "value" ],
              _js2n__-prdslib.records.record
                { value = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.CreateS3BucketOptions!predicate"
        | doc "CreateS3BucketOptions options used to determine automatic automatic bucket-creation process"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { objectLocking = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.CronWorkflow!predicate"
        | doc "CronWorkflow is the definition of a scheduled workflow resource"
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
                          _js2n__-prdslib.const "CronWorkflow"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.CronWorkflowSpec!predicate",
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.CronWorkflowStatus!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.CronWorkflowSpec!predicate"
        | doc "CronWorkflowSpec is the specification of a CronWorkflow"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "schedule", "workflowSpec" ],
              _js2n__-prdslib.records.record
                {
                  concurrencyPolicy = _js2n__-prdslib.isType '"String",
                  failedJobsHistoryLimit = _js2n__-prdslib.isType 'Integer,
                  schedule = _js2n__-prdslib.isType '"String",
                  schedules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  startingDeadlineSeconds = _js2n__-prdslib.isType 'Integer,
                  stopStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.StopStrategy!predicate",
                  successfulJobsHistoryLimit = _js2n__-prdslib.isType 'Integer,
                  suspend = _js2n__-prdslib.isType '"Bool",
                  timezone = _js2n__-prdslib.isType '"String",
                  workflowMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  workflowSpec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowSpec!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.CronWorkflowStatus!predicate"
        | doc "CronWorkflowStatus is the status of a CronWorkflow"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "active",
                  "conditions",
                  "failed",
                  "lastScheduledTime",
                  "phase",
                  "succeeded"
                ],
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ObjectReference!predicate"
                        ],
                  conditions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Condition!predicate"
                        ],
                  failed = _js2n__-prdslib.isType 'Integer,
                  lastScheduledTime =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  phase = _js2n__-prdslib.isType '"String",
                  succeeded = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.DAGTask!predicate"
        | doc "DAGTask represents a node in the graph during DAG execution"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  arguments =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Arguments!predicate",
                  continueOn =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ContinueOn!predicate",
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  depends = _js2n__-prdslib.isType '"String",
                  hooks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.LifecycleHook!predicate"
                        ],
                  inline =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Template!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  onExit = _js2n__-prdslib.isType '"String",
                  template = _js2n__-prdslib.isType '"String",
                  templateRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TemplateRef!predicate",
                  when = _js2n__-prdslib.isType '"String",
                  withItems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Item!predicate"
                        ],
                  withParam = _js2n__-prdslib.isType '"String",
                  withSequence =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Sequence!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.DAGTemplate!predicate"
        | doc "DAGTemplate is a template subtype for directed acyclic graph templates"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tasks" ],
              _js2n__-prdslib.records.record
                {
                  failFast = _js2n__-prdslib.isType '"Bool",
                  target = _js2n__-prdslib.isType '"String",
                  tasks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.DAGTask!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Data!predicate"
        | doc "Data is a data template"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "source", "transformation" ],
              _js2n__-prdslib.records.record
                {
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.DataSource!predicate",
                  transformation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TransformationStep!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.DataSource!predicate"
        | doc "DataSource sources external data into a data template"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactPaths =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactPaths!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "selector" ],
              _js2n__-prdslib.records.record
                { selector = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ExecutorConfig!predicate"
        | doc "ExecutorConfig holds configurations of an executor container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { serviceAccountName = _js2n__-prdslib.isType '"String", } {}
                true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GCSArtifact!predicate"
        | doc "GCSArtifact is the location of a GCS artifact"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  bucket = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  serviceAccountKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GCSArtifactRepository!predicate"
        | doc "GCSArtifactRepository defines the controller configuration for a GCS artifact repository"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bucket = _js2n__-prdslib.isType '"String",
                  keyFormat = _js2n__-prdslib.isType '"String",
                  serviceAccountKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Gauge!predicate"
        | doc "Gauge is a Gauge prometheus metric"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "realtime", "value" ],
              _js2n__-prdslib.records.record
                {
                  operation = _js2n__-prdslib.isType '"String",
                  realtime = _js2n__-prdslib.isType '"Bool",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.GitArtifact!predicate"
        | doc "GitArtifact is the location of an git artifact"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repo" ],
              _js2n__-prdslib.records.record
                {
                  branch = _js2n__-prdslib.isType '"String",
                  depth = _js2n__-prdslib.isType 'Integer,
                  disableSubmodules = _js2n__-prdslib.isType '"Bool",
                  fetch =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  insecureIgnoreHostKey = _js2n__-prdslib.isType '"Bool",
                  passwordSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  repo = _js2n__-prdslib.isType '"String",
                  revision = _js2n__-prdslib.isType '"String",
                  singleBranch = _js2n__-prdslib.isType '"Bool",
                  sshPrivateKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  usernameSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HDFSArtifact!predicate"
        | doc "HDFSArtifact is the location of an HDFS artifact"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  addresses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dataTransferProtection = _js2n__-prdslib.isType '"String",
                  "force" = _js2n__-prdslib.isType '"Bool",
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
                  path = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HDFSArtifactRepository!predicate"
        | doc "HDFSArtifactRepository defines the controller configuration for an HDFS artifact repository"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addresses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dataTransferProtection = _js2n__-prdslib.isType '"String",
                  "force" = _js2n__-prdslib.isType '"Bool",
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
                  pathFormat = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTP!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  body = _js2n__-prdslib.isType '"String",
                  bodyFrom =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPBodySource!predicate",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPHeader!predicate"
                        ],
                  insecureSkipVerify = _js2n__-prdslib.isType '"Bool",
                  method = _js2n__-prdslib.isType '"String",
                  successCondition = _js2n__-prdslib.isType '"String",
                  timeoutSeconds = _js2n__-prdslib.isType 'Integer,
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPArtifact!predicate"
        | doc "HTTPArtifact allows a file served on HTTP to be placed as an input artifact in a container"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  auth =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPAuth!predicate",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Header!predicate"
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPAuth!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  basicAuth =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.BasicAuth!predicate",
                  clientCert =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ClientCertAuth!predicate",
                  oauth2 =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OAuth2Auth!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPBodySource!predicate"
        | doc "HTTPBodySource contains the source of the HTTP body."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { bytes = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPHeader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                  valueFrom =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPHeaderSource!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTPHeaderSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  secretKeyRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Header!predicate"
        | doc "Header indicate a key-value request header to be used when fetching artifacts over HTTP"
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
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Histogram!predicate"
        | doc "Histogram is a Histogram prometheus metric"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "buckets", "value" ],
              _js2n__-prdslib.records.record
                {
                  buckets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Amount!predicate"
                        ],
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Inputs!predicate"
        | doc "Inputs are the mechanism for passing parameters, artifacts, volumes from one template to another"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Artifact!predicate"
                        ],
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Parameter!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Item!predicate"
        | doc "Item expands a single workflow step into multiple parallel steps The value of Item can be a map, string, bool, or number"
        = _js2n__-prdslib.always,
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.LabelValueFrom!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record
                { expression = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.LifecycleHook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arguments =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Arguments!predicate",
                  expression = _js2n__-prdslib.isType '"String",
                  template = _js2n__-prdslib.isType '"String",
                  templateRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TemplateRef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ManifestFrom!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "artifact" ],
              _js2n__-prdslib.records.record
                {
                  artifact =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Artifact!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.MemoizationStatus!predicate"
        | doc "MemoizationStatus is the status of this memoized node"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "cacheName", "hit", "key" ],
              _js2n__-prdslib.records.record
                {
                  cacheName = _js2n__-prdslib.isType '"String",
                  hit = _js2n__-prdslib.isType '"Bool",
                  key = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Memoize!predicate"
        | doc "Memoization enables caching for the Outputs of the template"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "cache", "key", "maxAge" ],
              _js2n__-prdslib.records.record
                {
                  cache =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Cache!predicate",
                  key = _js2n__-prdslib.isType '"String",
                  maxAge = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Metadata!predicate"
        | doc "Pod metdata"
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
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.MetricLabel!predicate"
        | doc "MetricLabel is a single label for a prometheus metric"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "value" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Metrics!predicate"
        | doc "Metrics are a list of metrics emitted from a Workflow/Template"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "prometheus" ],
              _js2n__-prdslib.records.record
                {
                  prometheus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Prometheus!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Mutex!predicate"
        | doc "Mutex holds Mutex configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.MutexHolding!predicate"
        | doc "MutexHolding describes the mutex and the object which is holding it."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  holder = _js2n__-prdslib.isType '"String",
                  mutex = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.MutexStatus!predicate"
        | doc "MutexStatus contains which objects hold  mutex locks, and which objects this workflow is waiting on to release locks."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  holding =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.MutexHolding!predicate"
                        ],
                  waiting =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.MutexHolding!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.NodeFlag!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  hooked = _js2n__-prdslib.isType '"Bool",
                  retried = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.NodeStatus!predicate"
        | doc "NodeStatus contains status information about an individual node in the workflow"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id", "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  boundaryID = _js2n__-prdslib.isType '"String",
                  children =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  daemoned = _js2n__-prdslib.isType '"Bool",
                  displayName = _js2n__-prdslib.isType '"String",
                  estimatedDuration = _js2n__-prdslib.isType 'Integer,
                  finishedAt =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  hostNodeName = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  inputs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Inputs!predicate",
                  memoizationStatus =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.MemoizationStatus!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  nodeFlag =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.NodeFlag!predicate",
                  outboundNodes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  outputs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Outputs!predicate",
                  phase = _js2n__-prdslib.isType '"String",
                  podIP = _js2n__-prdslib.isType '"String",
                  progress = _js2n__-prdslib.isType '"String",
                  resourcesDuration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType 'Integer)
                        ],
                  startedAt =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  synchronizationStatus =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.NodeSynchronizationStatus!predicate",
                  templateName = _js2n__-prdslib.isType '"String",
                  templateRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TemplateRef!predicate",
                  templateScope = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.NodeSynchronizationStatus!predicate"
        | doc "NodeSynchronizationStatus stores the status of a node"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { waiting = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.NoneStrategy!predicate"
        | doc "NoneStrategy indicates to skip tar process and upload the files or directory tree as independent files. Note that if the artifact is a directory, the artifact driver must support the ability to save/load the directory appropriately."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OAuth2Auth!predicate"
        | doc "OAuth2Auth holds all information for client authentication via OAuth2 tokens"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clientIDSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  clientSecretSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  endpointParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OAuth2EndpointParam!predicate"
                        ],
                  scopes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tokenURLSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OAuth2EndpointParam!predicate"
        | doc "EndpointParam is for requesting optional fields that should be sent in the oauth request"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OSSArtifact!predicate"
        | doc "OSSArtifact is the location of an Alibaba Cloud OSS artifact"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  accessKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  bucket = _js2n__-prdslib.isType '"String",
                  createBucketIfNotPresent = _js2n__-prdslib.isType '"Bool",
                  endpoint = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  lifecycleRule =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OSSLifecycleRule!predicate",
                  secretKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  securityToken = _js2n__-prdslib.isType '"String",
                  useSDKCreds = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OSSArtifactRepository!predicate"
        | doc "OSSArtifactRepository defines the controller configuration for an OSS artifact repository"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  bucket = _js2n__-prdslib.isType '"String",
                  createBucketIfNotPresent = _js2n__-prdslib.isType '"Bool",
                  endpoint = _js2n__-prdslib.isType '"String",
                  keyFormat = _js2n__-prdslib.isType '"String",
                  lifecycleRule =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OSSLifecycleRule!predicate",
                  secretKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  securityToken = _js2n__-prdslib.isType '"String",
                  useSDKCreds = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.OSSLifecycleRule!predicate"
        | doc "OSSLifecycleRule specifies how to manage bucket's lifecycle"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  markDeletionAfterDays = _js2n__-prdslib.isType 'Integer,
                  markInfrequentAccessAfterDays =
                    _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Outputs!predicate"
        | doc "Outputs hold parameters, artifacts, and results from a step"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Artifact!predicate"
                        ],
                  exitCode = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Parameter!predicate"
                        ],
                  result = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ParallelSteps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowStep!predicate"
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Parameter!predicate"
        | doc "Parameter indicate a passed string parameter to a service template with an optional default value"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  "default" = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  enum =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  globalName = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                  valueFrom =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ValueFrom!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Plugin!predicate"
        | doc "Plugin is an Object with exactly one key"
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.PodGC!predicate"
        | doc "PodGC describes how to delete completed pods as they complete"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  deleteDelayDuration = _js2n__-prdslib.isType '"String",
                  labelSelector =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector!predicate",
                  strategy = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Prometheus!predicate"
        | doc "Prometheus is a prometheus metric to be emitted"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "help", "name" ],
              _js2n__-prdslib.records.record
                {
                  counter =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Counter!predicate",
                  gauge =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Gauge!predicate",
                  help = _js2n__-prdslib.isType '"String",
                  histogram =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Histogram!predicate",
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.MetricLabel!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  when = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RawArtifact!predicate"
        | doc "RawArtifact allows raw string content to be placed as an artifact in a container"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "data" ],
              _js2n__-prdslib.records.record
                { data = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ResourceTemplate!predicate"
        | doc "ResourceTemplate is a template subtype to manipulate kubernetes resources"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "action" ],
              _js2n__-prdslib.records.record
                {
                  action = _js2n__-prdslib.isType '"String",
                  failureCondition = _js2n__-prdslib.isType '"String",
                  flags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  manifest = _js2n__-prdslib.isType '"String",
                  manifestFrom =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ManifestFrom!predicate",
                  mergeStrategy = _js2n__-prdslib.isType '"String",
                  setOwnerReference = _js2n__-prdslib.isType '"Bool",
                  successCondition = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RetryAffinity!predicate"
        | doc "RetryAffinity prevents running steps on the same host."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  nodeAntiAffinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RetryNodeAntiAffinity!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RetryNodeAntiAffinity!predicate"
        | doc "RetryNodeAntiAffinity is a placeholder for future expansion, only empty nodeAntiAffinity is allowed. In order to prevent running steps on the same host, it uses \"kubernetes.io/hostname\"."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RetryStrategy!predicate"
        | doc "RetryStrategy provides controls on how to retry a workflow step"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  affinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RetryAffinity!predicate",
                  backoff =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Backoff!predicate",
                  expression = _js2n__-prdslib.isType '"String",
                  limit =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                  retryPolicy = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.S3Artifact!predicate"
        | doc "S3Artifact is the location of an S3 artifact"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  bucket = _js2n__-prdslib.isType '"String",
                  caSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  createBucketIfNotPresent =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.CreateS3BucketOptions!predicate",
                  encryptionOptions =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.S3EncryptionOptions!predicate",
                  endpoint = _js2n__-prdslib.isType '"String",
                  insecure = _js2n__-prdslib.isType '"Bool",
                  key = _js2n__-prdslib.isType '"String",
                  region = _js2n__-prdslib.isType '"String",
                  roleARN = _js2n__-prdslib.isType '"String",
                  secretKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  sessionTokenSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  useSDKCreds = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.S3ArtifactRepository!predicate"
        | doc "S3ArtifactRepository defines the controller configuration for an S3 artifact repository"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  bucket = _js2n__-prdslib.isType '"String",
                  caSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  createBucketIfNotPresent =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.CreateS3BucketOptions!predicate",
                  encryptionOptions =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.S3EncryptionOptions!predicate",
                  endpoint = _js2n__-prdslib.isType '"String",
                  insecure = _js2n__-prdslib.isType '"Bool",
                  keyFormat = _js2n__-prdslib.isType '"String",
                  keyPrefix = _js2n__-prdslib.isType '"String",
                  region = _js2n__-prdslib.isType '"String",
                  roleARN = _js2n__-prdslib.isType '"String",
                  secretKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  sessionTokenSecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                  useSDKCreds = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.S3EncryptionOptions!predicate"
        | doc "S3EncryptionOptions used to determine encryption options during s3 operations"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enableEncryption = _js2n__-prdslib.isType '"Bool",
                  kmsEncryptionContext = _js2n__-prdslib.isType '"String",
                  kmsKeyId = _js2n__-prdslib.isType '"String",
                  serverSideCustomerKeySecret =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecretKeySelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ScriptTemplate!predicate"
        | doc "ScriptTemplate is a template subtype to enable scripting through code steps"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "image", "source" ],
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
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate",
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecurityContext!predicate",
                  source = _js2n__-prdslib.isType '"String",
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
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SemaphoreHolding!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  holders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  semaphore = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SemaphoreRef!predicate"
        | doc "SemaphoreRef is a reference of Semaphore"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configMapKeyRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapKeySelector!predicate",
                  namespace = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SemaphoreStatus!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  holding =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SemaphoreHolding!predicate"
                        ],
                  waiting =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SemaphoreHolding!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Sequence!predicate"
        | doc "Sequence expands a workflow step into numeric range"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  count =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                  end =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                  format = _js2n__-prdslib.isType '"String",
                  start =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.StopStrategy!predicate"
        | doc "v3.6 and after: StopStrategy defines if the CronWorkflow should stop scheduling based on a condition"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "condition" ],
              _js2n__-prdslib.records.record
                { condition = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Submit!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "workflowTemplateRef" ],
              _js2n__-prdslib.records.record
                {
                  arguments =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Arguments!predicate",
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  workflowTemplateRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowTemplateRef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SuppliedValueFrom!predicate"
        | doc "SuppliedValueFrom is a placeholder for a value to be filled in directly, either through the CLI, API, etc."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SuspendTemplate!predicate"
        | doc "SuspendTemplate is a template subtype to suspend a workflow at a predetermined point in time"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { duration = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Synchronization!predicate"
        | doc "Synchronization holds synchronization lock configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  mutex =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Mutex!predicate",
                  semaphore =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SemaphoreRef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SynchronizationStatus!predicate"
        | doc "SynchronizationStatus stores the status of semaphore and mutex."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  mutex =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.MutexStatus!predicate",
                  semaphore =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SemaphoreStatus!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TTLStrategy!predicate"
        | doc "TTLStrategy is the strategy for the time to live depending on if the workflow succeeded or failed"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  secondsAfterCompletion = _js2n__-prdslib.isType 'Integer,
                  secondsAfterFailure = _js2n__-prdslib.isType 'Integer,
                  secondsAfterSuccess = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TarStrategy!predicate"
        | doc "TarStrategy will tar and gzip the file or directory when saving"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { compressionLevel = _js2n__-prdslib.isType 'Integer, } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Template!predicate"
        | doc "Template is a reusable and composable unit of execution in a workflow"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  activeDeadlineSeconds =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                  affinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Affinity!predicate",
                  archiveLocation =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactLocation!predicate",
                  automountServiceAccountToken = _js2n__-prdslib.isType '"Bool",
                  container =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Container!predicate",
                  containerSet =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ContainerSetTemplate!predicate",
                  daemon = _js2n__-prdslib.isType '"Bool",
                  dag =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.DAGTemplate!predicate",
                  data =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Data!predicate",
                  executor =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ExecutorConfig!predicate",
                  failFast = _js2n__-prdslib.isType '"Bool",
                  hostAliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.HostAlias!predicate"
                        ],
                  http =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.HTTP!predicate",
                  initContainers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.UserContainer!predicate"
                        ],
                  inputs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Inputs!predicate",
                  memoize =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Memoize!predicate",
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Metadata!predicate",
                  metrics =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Metrics!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  nodeSelector =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  outputs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Outputs!predicate",
                  parallelism = _js2n__-prdslib.isType 'Integer,
                  plugin =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Plugin!predicate",
                  podSpecPatch = _js2n__-prdslib.isType '"String",
                  "priority" = _js2n__-prdslib.isType 'Integer,
                  priorityClassName = _js2n__-prdslib.isType '"String",
                  resource =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ResourceTemplate!predicate",
                  retryStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RetryStrategy!predicate",
                  schedulerName = _js2n__-prdslib.isType '"String",
                  script =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ScriptTemplate!predicate",
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodSecurityContext!predicate",
                  serviceAccountName = _js2n__-prdslib.isType '"String",
                  sidecars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.UserContainer!predicate"
                        ],
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ParallelSteps!predicate"
                        ],
                  suspend =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SuspendTemplate!predicate",
                  synchronization =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Synchronization!predicate",
                  timeout = _js2n__-prdslib.isType '"String",
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
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TemplateRef!predicate"
        | doc "TemplateRef is a reference of template resource."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clusterScope = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  template = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TransformationStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record
                { expression = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.UserContainer!predicate"
        | doc "UserContainer is a container specified by a user."
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
                  mirrorVolumeMounts = _js2n__-prdslib.isType '"Bool",
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
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate",
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
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ValueFrom!predicate"
        | doc "ValueFrom describes a location in which to obtain the value to a parameter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configMapKeyRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ConfigMapKeySelector!predicate",
                  "default" = _js2n__-prdslib.isType '"String",
                  event = _js2n__-prdslib.isType '"String",
                  expression = _js2n__-prdslib.isType '"String",
                  jqFilter = _js2n__-prdslib.isType '"String",
                  jsonPath = _js2n__-prdslib.isType '"String",
                  parameter = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  supplied =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SuppliedValueFrom!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.VolumeClaimGC!predicate"
        | doc "VolumeClaimGC describes how to delete volumes from completed Workflows"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { strategy = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Workflow!predicate"
        | doc "Workflow is the definition of a workflow resource"
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
                          _js2n__-prdslib.const "Workflow"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowSpec!predicate",
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowStatus!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowEventBinding!predicate"
        | doc "WorkflowEventBinding is the definition of an event resource"
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
                          _js2n__-prdslib.const "WorkflowEventBinding"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowEventBindingSpec!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowEventBindingSpec!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "event" ],
              _js2n__-prdslib.records.record
                {
                  event =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Event!predicate",
                  submit =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Submit!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowLevelArtifactGC!predicate"
        | doc "WorkflowLevelArtifactGC describes how to delete artifacts from completed Workflows - this spec is used on the Workflow level"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  forceFinalizerRemoval = _js2n__-prdslib.isType '"Bool",
                  podMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Metadata!predicate",
                  podSpecPatch = _js2n__-prdslib.isType '"String",
                  serviceAccountName = _js2n__-prdslib.isType '"String",
                  strategy = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowMetadata!predicate" =
        _js2n__-prdslib.allOf
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
                  labelsFrom =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.LabelValueFrom!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowSpec!predicate"
        | doc "WorkflowSpec is the specification of a Workflow."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  activeDeadlineSeconds = _js2n__-prdslib.isType 'Integer,
                  affinity =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Affinity!predicate",
                  archiveLogs = _js2n__-prdslib.isType '"Bool",
                  arguments =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Arguments!predicate",
                  artifactGC =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowLevelArtifactGC!predicate",
                  artifactRepositoryRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactRepositoryRef!predicate",
                  automountServiceAccountToken = _js2n__-prdslib.isType '"Bool",
                  dnsConfig =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodDNSConfig!predicate",
                  dnsPolicy = _js2n__-prdslib.isType '"String",
                  entrypoint = _js2n__-prdslib.isType '"String",
                  executor =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ExecutorConfig!predicate",
                  hooks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.LifecycleHook!predicate"
                        ],
                  hostAliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.HostAlias!predicate"
                        ],
                  hostNetwork = _js2n__-prdslib.isType '"Bool",
                  imagePullSecrets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.LocalObjectReference!predicate"
                        ],
                  metrics =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Metrics!predicate",
                  nodeSelector =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  onExit = _js2n__-prdslib.isType '"String",
                  parallelism = _js2n__-prdslib.isType 'Integer,
                  podDisruptionBudget =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.policy.v1.PodDisruptionBudgetSpec!predicate",
                  podGC =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.PodGC!predicate",
                  podMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Metadata!predicate",
                  podPriority = _js2n__-prdslib.isType 'Integer,
                  podPriorityClassName = _js2n__-prdslib.isType '"String",
                  podSpecPatch = _js2n__-prdslib.isType '"String",
                  "priority" = _js2n__-prdslib.isType 'Integer,
                  retryStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.RetryStrategy!predicate",
                  schedulerName = _js2n__-prdslib.isType '"String",
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodSecurityContext!predicate",
                  serviceAccountName = _js2n__-prdslib.isType '"String",
                  shutdown = _js2n__-prdslib.isType '"String",
                  suspend = _js2n__-prdslib.isType '"Bool",
                  synchronization =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Synchronization!predicate",
                  templateDefaults =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Template!predicate",
                  templates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Template!predicate"
                        ],
                  tolerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Toleration!predicate"
                        ],
                  ttlStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TTLStrategy!predicate",
                  volumeClaimGC =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.VolumeClaimGC!predicate",
                  volumeClaimTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaim!predicate"
                        ],
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Volume!predicate"
                        ],
                  workflowMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowMetadata!predicate",
                  workflowTemplateRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowTemplateRef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowStatus!predicate"
        | doc "WorkflowStatus contains overall status information about a workflow"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactGCStatus =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtGCStatus!predicate",
                  artifactRepositoryRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ArtifactRepositoryRefStatus!predicate",
                  compressedNodes = _js2n__-prdslib.isType '"String",
                  conditions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Condition!predicate"
                        ],
                  estimatedDuration = _js2n__-prdslib.isType 'Integer,
                  finishedAt =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  nodes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.NodeStatus!predicate"
                        ],
                  offloadNodeStatusVersion = _js2n__-prdslib.isType '"String",
                  outputs =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Outputs!predicate",
                  persistentVolumeClaims =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Volume!predicate"
                        ],
                  phase = _js2n__-prdslib.isType '"String",
                  progress = _js2n__-prdslib.isType '"String",
                  resourcesDuration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType 'Integer)
                        ],
                  startedAt =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  storedTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Template!predicate"
                        ],
                  storedWorkflowTemplateSpec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowSpec!predicate",
                  synchronization =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.SynchronizationStatus!predicate",
                  taskResultsCompletionStatus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"Bool")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowStep!predicate"
        | doc "WorkflowStep is a reference to a template to execute in a series of step"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arguments =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Arguments!predicate",
                  continueOn =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ContinueOn!predicate",
                  hooks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.LifecycleHook!predicate"
                        ],
                  inline =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Template!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  onExit = _js2n__-prdslib.isType '"String",
                  template = _js2n__-prdslib.isType '"String",
                  templateRef =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.TemplateRef!predicate",
                  when = _js2n__-prdslib.isType '"String",
                  withItems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Item!predicate"
                        ],
                  withParam = _js2n__-prdslib.isType '"String",
                  withSequence =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Sequence!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowTemplate!predicate"
        | doc "WorkflowTemplate is the definition of a workflow template resource"
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
                          _js2n__-prdslib.const "WorkflowTemplate"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowSpec!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowTemplateRef!predicate"
        | doc "WorkflowTemplateRef is a reference to a WorkflowTemplate resource."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clusterScope = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ZipStrategy!predicate"
        | doc "ZipStrategy will unzip zipped input artifacts"
        = _js2n__-prdslib.isType 'Record,
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
              _js2n__-prdslib.records.required [ "image" ],
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
                  imagePullPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Always", "IfNotPresent", "Never" ]
                        ],
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
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate",
                  securityContext =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.SecurityContext!predicate",
                  startupProbe =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Probe!predicate",
                  stdin = _js2n__-prdslib.isType '"Bool",
                  stdinOnce = _js2n__-prdslib.isType '"Bool",
                  terminationMessagePath = _js2n__-prdslib.isType '"String",
                  terminationMessagePolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "FallbackToLogsOnError", "File" ]
                        ],
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
                  protocol =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "SCTP", "TCP", "UDP" ]
                        ],
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
                  scheme =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "HTTP", "HTTPS" ]
                        ],
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
      "_js2n__-:definitions/io.k8s.api.core.v1.HostAlias!predicate"
        | doc "HostAlias holds the mapping between IP and hostnames that will be injected as an entry in the pod's hosts file."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  hostnames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ip = _js2n__-prdslib.isType '"String",
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
                  operator =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "DoesNotExist",
                              "Exists",
                              "Gt",
                              "In",
                              "Lt",
                              "NotIn"
                            ]
                        ],
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
      "_js2n__-:definitions/io.k8s.api.core.v1.ObjectReference!predicate"
        | doc "ObjectReference contains enough information to let you inspect or modify the referred object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiVersion = _js2n__-prdslib.isType '"String",
                  fieldPath = _js2n__-prdslib.isType '"String",
                  kind = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  resourceVersion = _js2n__-prdslib.isType '"String",
                  uid = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaim!predicate"
        | doc "PersistentVolumeClaim is a user's request for and claim to a persistent volume"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiVersion = _js2n__-prdslib.isType '"String",
                  kind = _js2n__-prdslib.isType '"String",
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimSpec!predicate",
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimStatus!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimCondition!predicate"
        | doc "PersistentVolumeClaimCondition contails details about state of pvc"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "status", "type" ],
              _js2n__-prdslib.records.record
                {
                  lastProbeTime =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  lastTransitionTime =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.Time!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  reason = _js2n__-prdslib.isType '"String",
                  status = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "FileSystemResizePending", "Resizing" ]
                        ],
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
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.TypedLocalObjectReference!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate",
                  selector =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector!predicate",
                  storageClassName = _js2n__-prdslib.isType '"String",
                  volumeMode = _js2n__-prdslib.isType '"String",
                  volumeName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimStatus!predicate"
        | doc "PersistentVolumeClaimStatus is the current status of a persistent volume claim."
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
                  allocatedResources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
                        ],
                  capacity =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
                        ],
                  conditions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PersistentVolumeClaimCondition!predicate"
                        ],
                  phase =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Bound", "Lost", "Pending" ]
                        ],
                  resizeStatus = _js2n__-prdslib.isType '"String",
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
      "_js2n__-:definitions/io.k8s.api.core.v1.PodDNSConfig!predicate"
        | doc "PodDNSConfig defines the DNS parameters of a pod in addition to those generated from DNSPolicy."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  nameservers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.PodDNSConfigOption!predicate"
                        ],
                  searches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.PodDNSConfigOption!predicate"
        | doc "PodDNSConfigOption defines DNS resolver options of a pod."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
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
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Localhost", "RuntimeDefault", "Unconfined" ]
                        ],
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
                  effect =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "NoExecute", "NoSchedule", "PreferNoSchedule" ]
                        ],
                  key = _js2n__-prdslib.isType '"String",
                  operator =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Equal", "Exists" ]
                        ],
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
      "_js2n__-:definitions/io.k8s.api.policy.v1.PodDisruptionBudgetSpec!predicate"
        | doc "PodDisruptionBudgetSpec is a description of a PodDisruptionBudget."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  maxUnavailable =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                  minAvailable =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate",
                  selector =
                    _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
        | doc m%"
          Quantity is a fixed-point representation of a number. It provides convenient marshaling/unmarshaling in JSON and YAML, in addition to String() and AsInt64() accessors.
          
          The serialization format is:
          
          <quantity>        ::= <signedNumber><suffix>
            (Note that <suffix> may be empty, from the "" case in <decimalSI>.)
          <digit>           ::= 0 | 1 | ... | 9 <digits>          ::= <digit> | <digit><digits> <number>          ::= <digits> | <digits>.<digits> | <digits>. | .<digits> <sign>            ::= "+" | "-" <signedNumber>    ::= <number> | <sign><number> <suffix>          ::= <binarySI> | <decimalExponent> | <decimalSI> <binarySI>        ::= Ki | Mi | Gi | Ti | Pi | Ei
            (International System of units; See: http://physics.nist.gov/cuu/Units/binary.html)
          <decimalSI>       ::= m | "" | k | M | G | T | P | E
            (Note that 1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization.)
          <decimalExponent> ::= "e" <signedNumber> | "E" <signedNumber>
          
          No matter which of the three exponent forms is used, no quantity may represent a number greater than 2^63-1 in magnitude, nor may it have more than 3 decimal places. Numbers larger or more precise will be capped or rounded up. (E.g.: 0.1m will rounded up to 1m.) This may be extended in the future if we require larger or smaller quantities.
          
          When a Quantity is parsed from a string, it will remember the type of suffix it had, and will use the same type again when it is serialized.
          
          Before serializing, Quantity will be put in "canonical form". This means that Exponent/suffix will be adjusted up or down (with a corresponding increase or decrease in Mantissa) such that:
            a. No precision is lost
            b. No fractional digits will be emitted
            c. The exponent (or suffix) is as large as possible.
          The sign will be omitted unless the number is negative.
          
          Examples:
            1.5 will be serialized as "1500m"
            1.5Gi will be serialized as "1536Mi"
          
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
                  clusterName = _js2n__-prdslib.isType '"String",
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
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.util.intstr.IntOrString!predicate" =
        _js2n__-prdslib.isType '"String",
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate!predicate",
              _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.CronWorkflow!predicate",
              _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.Workflow!predicate",
              _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowEventBinding!predicate",
              _js2n__-refsenv."_js2n__-:definitions/io.argoproj.workflow.v1alpha1.WorkflowTemplate!predicate"
            ]
        ])