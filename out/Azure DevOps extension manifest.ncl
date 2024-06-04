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
      "_js2n__-:definitions/Badge!contract"
        | doc "A link to external metadata badge."
        = {
            description
              | String
              | doc "Description of the badge, to be displayed on hover."
              | optional,
            href
              | String
              | doc "Link the user navigates to when selecting the badge."
              | optional,
            uri
              | String
              | doc "The absolute URL of the badge image to be displayed.",
            ..
          },
      "_js2n__-:definitions/Content!contract"
        | doc "A content file that describes the extension to users."
        = { path | String | doc "The path to the file in the extension.", .. },
      "_js2n__-:definitions/Content!predicate"
        | doc "A content file that describes the extension to users."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                { path = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Contribution!contract"
        | doc "An individual contribution made by an extension"
        = {
            constraints
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ContributionConstraint!contract"
              | doc "List of constraints (filters) that should be applied to the availability of this contribution"
              | optional,
            description
              | String
              | doc "Description of the contribution/type"
              | optional,
            id
              | String
              | doc "Fully qualified identifier of the contribution/type",
            includes
              | Array (String)
              | doc "Includes is a set of contributions that should have this contribution included in their targets list."
              | optional,
            properties
              | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
              | doc "Properties/attributes of this contribution"
              | optional,
            restrictedTo
              | Array (String)
              | doc "List of demanded claims in order for the user to see this contribution (like anonymous, public, member...)."
              | optional,
            targets
              | Array (String)
              | doc "The ids of the contribution(s) that this contribution targets. (parent contributions)",
            type | String | doc "Id of the Contribution Type",
            visibleTo
              | Array (String)
              | doc "VisibleTo can be used to restrict whom can reference a given contribution/type. This value should be a list of publishers or extensions access is restricted too.  Examples: \"ms\" - Means only the \"ms\" publisher can reference this. \"ms.vss-web\" - Means only the \"vss-web\" extension from the \"ms\" publisher can reference this."
              | optional,
            ..
          },
      "_js2n__-:definitions/ContributionConstraint!contract"
        | doc "Specifies a constraint that can be used to dynamically include/exclude a given contribution"
        = {
            group
              | Number
              | doc "An optional property that can be specified to group constraints together. All constraints within a group are AND'd together (all must be evaluate to True in order for the contribution to be included). Different groups of constraints are OR'd (only one group needs to evaluate to True for the contribution to be included)."
              | optional,
            id
              | String
              | doc "Fully qualified identifier of a shared constraint"
              | optional,
            inverse
              | Bool
              | doc "If true, negate the result of the filter (include the contribution if the applied filter returns false instead of true)"
              | optional,
            name
              | String
              | doc "Name of the IContributionFilter plugin"
              | optional,
            properties
              | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
              | doc "Properties that are fed to the contribution filter class"
              | optional,
            relationships
              | Array (String)
              | doc "Constraints can be optionally be applied to one or more of the relationships defined in the contribution. If no relationships are defined then all relationships are associated with the constraint. This means the default behaviour will eliminate the contribution from the tree completely if the constraint is applied."
              | optional,
            ..
          },
      "_js2n__-:definitions/ContributionLicensingBehaviorType!contract"
        | doc "Represents different ways of including contributions based on licensing"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Number",
                _js2n__-prdslib.enum [ 0, 1, 2 ]
              ]),
      "_js2n__-:definitions/ContributionPropertyDescription!predicate"
        | doc "Description about a property of a contribution type"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/ContributionPropertyType!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ContributionPropertyType!predicate"
        | doc "The type of value used for a property"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum [ 0, 1, 128, 16, 2, 256, 32, 4, 512, 64, 8 ]
            ],
      "_js2n__-:definitions/ContributionType!contract"
        | doc "A contribution type, given by a json schema"
        = {
            description
              | String
              | doc "Description of the contribution/type"
              | optional,
            id
              | String
              | doc "Fully qualified identifier of the contribution/type"
              | optional,
            indexed
              | Bool
              | doc "Controls whether or not contributions of this type have the type indexed for queries. This allows clients to find all extensions that have a contribution of this type.  NOTE: Only TrustedPartners are allowed to specify indexed contribution types."
              | optional,
            name
              | String
              | doc "Friendly name of the contribution/type"
              | optional,
            properties
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-refsenv."_js2n__-:definitions/ContributionPropertyDescription!predicate"
                  ])
              | doc "Describes the allowed properties for this contribution type"
              | optional,
            visibleTo
              | Array (String)
              | doc "VisibleTo can be used to restrict whom can reference a given contribution/type. This value should be a list of publishers or extensions access is restricted too.  Examples: \"ms\" - Means only the \"ms\" publisher can reference this. \"ms.vss-web\" - Means only the \"vss-web\" extension from the \"ms\" publisher can reference this."
              | optional,
            ..
          },
      "_js2n__-:definitions/ExtensionEventCallback!contract"
        | doc "Base class for an event callback for an extension"
        = {
            uri
              | String
              | doc "The uri of the endpoint that is hit when an event occurs"
              | optional,
            ..
          },
      "_js2n__-:definitions/ExtensionEventCallbackCollection!contract"
        | doc "Collection of event callbacks - endpoints called when particular extension events occur."
        = {
            postDisable
              | _js2n__-refsenv."_js2n__-:definitions/ExtensionEventCallback!contract"
              | doc "Optional.  Defines an endpoint that gets called via a POST request to notify that an extension disable has occurred."
              | optional,
            postEnable
              | _js2n__-refsenv."_js2n__-:definitions/ExtensionEventCallback!contract"
              | doc "Optional.  Defines an endpoint that gets called via a POST request to notify that an extension enable has occurred."
              | optional,
            postInstall
              | _js2n__-refsenv."_js2n__-:definitions/ExtensionEventCallback!contract"
              | doc "Optional.  Defines an endpoint that gets called via a POST request to notify that an extension install has completed."
              | optional,
            postUninstall
              | _js2n__-refsenv."_js2n__-:definitions/ExtensionEventCallback!contract"
              | doc "Optional.  Defines an endpoint that gets called via a POST request to notify that an extension uninstall has occurred."
              | optional,
            postUpdate
              | _js2n__-refsenv."_js2n__-:definitions/ExtensionEventCallback!contract"
              | doc "Optional.  Defines an endpoint that gets called via a POST request to notify that an extension update has occurred."
              | optional,
            preInstall
              | _js2n__-refsenv."_js2n__-:definitions/ExtensionEventCallback!contract"
              | doc "Optional.  Defines an endpoint that gets called via a POST request to notify that an extension install is about to occur.  Response indicates whether to proceed or abort."
              | optional,
            versionCheck
              | _js2n__-refsenv."_js2n__-:definitions/ExtensionEventCallback!contract"
              | doc "For multi-version extensions, defines an endpoint that gets called via an OPTIONS request to determine the particular version of the extension to be used"
              | optional,
            ..
          },
      "_js2n__-:definitions/ExtensionLicensing!contract"
        | doc "How an extension should handle including contributions based on licensing"
        = {
            overrides
              | Array
                _js2n__-refsenv."_js2n__-:definitions/LicensingOverride!contract"
              | doc "A list of contributions which deviate from the default licensing behavior"
              | optional,
            ..
          },
      "_js2n__-:definitions/File!contract" =
        {
            addressable
              | Bool
              | doc "(optional) Set to true if you want your file to be URL-addressable. Defaults to false."
              | optional,
            assetType
              | String
              | doc "(optional) Specify the value of the Type attribute of the asset entry in the VSIX manifest. Can also be an array of strings, in which case multiple asset entries get added for this file. Defaults to the packagePath."
              | optional,
            contentType
              | String
              | doc "(optional) MIME type of the file. Defaults to a best guess based on the file extension and OS settings."
              | optional,
            lang
              | String
              | doc "(optional) Language of this asset. Localized files are served based on the Accept-Language header. Leave blank to signify this file is in the default (or fallback) language. Localized versions of the same file should have the same assetType."
              | optional,
            packagePath
              | String
              | doc "(optional) Path to the resource within the package. Defaults to the relative path on disk from your root directory."
              | optional,
            path
              | String
              | doc "Path to resource on disk, which can be relative to your root directory.",
            ..
          },
      "_js2n__-:definitions/LicensingOverride!contract"
        | doc "Maps a contribution to a licensing behavior"
        = {
            behavior
              | _js2n__-refsenv."_js2n__-:definitions/ContributionLicensingBehaviorType!contract"
              | doc "How the inclusion of this contribution should change based on licensing"
              | optional,
            id
              | String
              | doc "Fully qualified contribution id which we want to define licensing behavior for"
              | optional,
            ..
          },
      "_js2n__-:definitions/Link!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { uri = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Target!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Microsoft.VisualStudio.Services",
                              "Microsoft.TeamFoundation.Server",
                              "Microsoft.VisualStudio.Services.Integration",
                              "Microsoft.TeamFoundation.Server.Integration"
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      badges
        | Array _js2n__-refsenv."_js2n__-:definitions/Badge!contract"
        | doc "Array of links to external metadata badges like TravisCI, Appveyor, and so on, from the approved badges sites."
        | optional,
      baseUri
        | String
        | doc "Uri used as base for other relative uri's defined in extension"
        | optional,
      branding
        | {
          color
            | String
            | doc "Primary color of the extension or publisher; can be a hex (#ff00ff), RGB (rgb(100,200,50)), or supported HTML color names (blue)."
            | optional,
          theme
            | std.enum.TagOrString
            | [| 'light, 'dark |]
            | doc "Complements the color; use dark for dark branding colors, or light for lighter branding colors."
            | optional,
          ..
        }
        | doc "Dictionary of brand-related properties."
        | optional,
      categories
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "Azure Repos",
                        "Azure Boards",
                        "Azure Pipelines",
                        "Azure Test Plans",
                        "Azure Artifacts"
                      ]
                  ]),
              _js2n__-prdslib.arrays.minItems 1
            ])
        | doc "Array of strings representing the categories your extension belongs to. At least one category must be provided and there's no limit to how many categories you may include. Valid values: Azure Repos, Azure Boards, Azure Pipelines, Azure Test Plans, and Azure Artifacts."
        | optional,
      constraints
        | Array
          _js2n__-refsenv."_js2n__-:definitions/ContributionConstraint!contract"
        | doc "List of shared constraints defined by this extension"
        | optional,
      content
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  details =
                    _js2n__-refsenv."_js2n__-:definitions/Content!predicate",
                } {} true
                _js2n__-refsenv."_js2n__-:definitions/Content!predicate"
            ])
        | doc "Dictionary of content files that describe your extension to users."
        | optional,
      contributionTypes
        | Array _js2n__-refsenv."_js2n__-:definitions/ContributionType!contract"
        | doc "List of contribution types defined by this extension"
        | optional,
      contributions
        | Array _js2n__-refsenv."_js2n__-:definitions/Contribution!contract"
        | doc "List of contributions made by this extension"
        | optional,
      demands
        | Array (String)
        | doc "List of explicit demands required by this extension"
        | optional,
      description
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 200
            ])
        | doc "A few sentences describing the extensions. Limited to 200 characters."
        | optional,
      eventCallbacks
        | _js2n__-refsenv."_js2n__-:definitions/ExtensionEventCallbackCollection!contract"
        | doc "Collection of endpoints that get called when particular extension events occur"
        | optional,
      fallbackBaseUri
        | String
        | doc "Secondary location that can be used as base for other relative uri's defined in extension"
        | optional,
      files
        | Array _js2n__-refsenv."_js2n__-:definitions/File!contract"
        | doc "The files section is where you reference any files you wish to include in your extension."
        | optional,
      icons
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { "default" = _js2n__-prdslib.isType '"String", } {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "Dictionary of icons representing the extension."
        | optional,
      id | String | doc "The extension's identifier." | optional,
      language
        | String
        | doc "Language Culture Name set by the Gallery"
        | optional,
      licensing
        | _js2n__-refsenv."_js2n__-:definitions/ExtensionLicensing!contract"
        | doc "How this extension behaves with respect to licensing"
        | optional,
      links
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  getstarted =
                    _js2n__-refsenv."_js2n__-:definitions/Link!predicate",
                  learn = _js2n__-refsenv."_js2n__-:definitions/Link!predicate",
                  license =
                    _js2n__-refsenv."_js2n__-:definitions/Link!predicate",
                  privacypolicy =
                    _js2n__-refsenv."_js2n__-:definitions/Link!predicate",
                  support =
                    _js2n__-refsenv."_js2n__-:definitions/Link!predicate",
                } {} true _js2n__-refsenv."_js2n__-:definitions/Link!predicate"
            ])
        | doc "Dictionary of links that help users learn more about your extension, get support, and move."
        | optional,
      manifestVersion
        | Number
        | doc "Version of the extension manifest format/content. Should be 1."
        | optional,
      name
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 200
            ])
        | doc "A short, human-readable name of the extension. Limited to 200 characters."
        | optional,
      publisher
        | String
        | doc "The identifier of the publisher. This identifier must match the identifier the extension is published under."
        | optional,
      repository
        | {
          type | String | doc "Type of repository. Example: git." | optional,
          uri | String | doc "Absolute URL of the repository." | optional,
          ..
        }
        | doc "Dictionary of properties describing the source code repository for the extension."
        | optional,
      restrictedTo
        | Array (String)
        | doc "Default user claims applied to all contributions (except the ones which have been specified restrictedTo explicitly) to control the visibility of a contribution."
        | optional,
      scopes
        | Array (String)
        | doc "List of all oauth scopes required by this extension"
        | optional,
      screenshots
        | Array _js2n__-refsenv."_js2n__-:definitions/Content!contract"
        | doc "Array of images that couldn't be included in your content."
        | optional,
      serviceInstanceType
        | String
        | doc "The ServiceInstanceType(Guid) of the VSTS service that must be available to an account in order for the extension to be installed"
        | optional,
      tags
        | Array (String)
        | doc "Array of string tags to help users find your extension."
        | optional,
      targets
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/Target!predicate",
              _js2n__-prdslib.arrays.minItems 1
            ])
        | doc "The products and services supported by your integration or extension."
        | optional,
      version
        | String
        | doc "A string specifying the version of an extension. Should be in the format major.minor.patch."
        | optional,
      ..
    }