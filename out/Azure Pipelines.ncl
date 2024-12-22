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
      "_js2n__-:definitions/any!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/any!predicate"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/boolean!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^true$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^y$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^yes$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^on$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^false$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^n$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^no$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^off$"
                ]
            ],
      "_js2n__-:definitions/branchFilter!predicate"
        | doc "branch name or prefix filter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[^\\/~\\^\\: \\[\\]\\\\]+(\\/[^\\/~\\^\\: \\[\\]\\\\]+)*$"
            ],
      "_js2n__-:definitions/branchFilterArray!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/branchFilter!predicate"
            ],
      "_js2n__-:definitions/buildResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "build", "connection", "source", "type" ],
              _js2n__-prdslib.records.record
                {
                  branch =
                    _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                  build =
                    _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                  connection =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  trigger =
                    _js2n__-refsenv."_js2n__-:definitions/buildResourceTrigger!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/buildResourceTrigger!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^none$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^true$"
                ]
            ],
      "_js2n__-:definitions/buildResources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/buildResource!predicate"
            ],
      "_js2n__-:definitions/canaryDeploymentIncrements!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate"
            ],
      "_js2n__-:definitions/canaryDeploymentStrategy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  deploy =
                    _js2n__-refsenv."_js2n__-:definitions/deployHook!predicate",
                  increments =
                    _js2n__-refsenv."_js2n__-:definitions/canaryDeploymentIncrements!predicate",
                  on =
                    _js2n__-refsenv."_js2n__-:definitions/onSuccessOrFailureHook!predicate",
                  postRouteTraffic =
                    _js2n__-refsenv."_js2n__-:definitions/postRouteTrafficHook!predicate",
                  preDeploy =
                    _js2n__-refsenv."_js2n__-:definitions/preDeployHook!predicate",
                  routeTraffic =
                    _js2n__-refsenv."_js2n__-:definitions/routeTrafficHook!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/containerArtifactType!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^ACR$"
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/containerResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "container", "image" ],
              _js2n__-prdslib.records.record
                {
                  container =
                    _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                  endpoint =
                    _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                  env =
                    _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                  mapDockerSocket =
                    _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                  mountReadOnly =
                    _js2n__-refsenv."_js2n__-:definitions/readOnlyMounts!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                  ports =
                    _js2n__-refsenv."_js2n__-:definitions/sequenceOfString_allowExpressions!predicate",
                  trigger =
                    _js2n__-refsenv."_js2n__-:definitions/containerResourceTrigger!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/containerArtifactType!predicate",
                  volumes =
                    _js2n__-refsenv."_js2n__-:definitions/sequenceOfString_allowExpressions!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/containerResourceTrigger!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^none$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^true$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      tags =
                        _js2n__-refsenv."_js2n__-:definitions/includeExcludeStringFilters!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/containerResources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/containerResource!predicate"
            ],
      "_js2n__-:definitions/deployHook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pool = _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                  steps =
                    _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/deploymentEnvironment!predicate"
        | doc "Environment details"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      resourceId =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      resourceName =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      resourceType =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      tags =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/deploymentStrategy!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      runOnce =
                        _js2n__-refsenv."_js2n__-:definitions/runOnceDeploymentStrategy!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      rolling =
                        _js2n__-refsenv."_js2n__-:definitions/rollingDeploymentStrategy!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      canary =
                        _js2n__-refsenv."_js2n__-:definitions/canaryDeploymentStrategy!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/explicitResources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pools =
                    _js2n__-refsenv."_js2n__-:definitions/sequenceOfNonEmptyString!predicate",
                  repositories =
                    _js2n__-refsenv."_js2n__-:definitions/sequenceOfNonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/extends!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  parameters =
                    _js2n__-refsenv."_js2n__-:definitions/mapping!predicate",
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/includeExcludeFilters!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exclude =
                    _js2n__-refsenv."_js2n__-:definitions/branchFilterArray!predicate",
                  include =
                    _js2n__-refsenv."_js2n__-:definitions/branchFilterArray!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/includeExcludeStringFilters!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      exclude =
                        _js2n__-refsenv."_js2n__-:definitions/sequenceOfNonEmptyString!predicate",
                      include =
                        _js2n__-refsenv."_js2n__-:definitions/sequenceOfNonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/job!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      cancelTimeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      container =
                        _js2n__-refsenv."_js2n__-:definitions/jobContainer!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/jobContinueOnError!predicate",
                      dependsOn =
                        _js2n__-refsenv."_js2n__-:definitions/jobDependsOn!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      job =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      pool =
                        _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                      services =
                        _js2n__-refsenv."_js2n__-:definitions/jobServices!predicate",
                      steps =
                        _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                      strategy =
                        _js2n__-refsenv."_js2n__-:definitions/jobStrategy!predicate",
                      templateContext =
                        _js2n__-refsenv."_js2n__-:definitions/templateContext!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      uses =
                        _js2n__-refsenv."_js2n__-:definitions/explicitResources!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                      workspace =
                        _js2n__-refsenv."_js2n__-:definitions/jobWorkspace!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      cancelTimeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      container =
                        _js2n__-refsenv."_js2n__-:definitions/jobContainer!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/jobContinueOnError!predicate",
                      dependsOn =
                        _js2n__-refsenv."_js2n__-:definitions/jobDependsOn!predicate",
                      deployment =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      environment =
                        _js2n__-refsenv."_js2n__-:definitions/deploymentEnvironment!predicate",
                      pool =
                        _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                      services =
                        _js2n__-refsenv."_js2n__-:definitions/jobServices!predicate",
                      strategy =
                        _js2n__-refsenv."_js2n__-:definitions/deploymentStrategy!predicate",
                      templateContext =
                        _js2n__-refsenv."_js2n__-:definitions/templateContext!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      uses =
                        _js2n__-refsenv."_js2n__-:definitions/explicitResources!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                      workspace =
                        _js2n__-refsenv."_js2n__-:definitions/jobWorkspace!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/mapping!predicate",
                      template =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/jobContainer!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      alias =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "image" ],
                  _js2n__-prdslib.records.record
                    {
                      endpoint =
                        _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      image =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      mapDockerSocket =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      mountReadOnly =
                        _js2n__-refsenv."_js2n__-:definitions/readOnlyMounts!predicate",
                      options =
                        _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                      ports =
                        _js2n__-refsenv."_js2n__-:definitions/sequenceOfString_allowExpressions!predicate",
                      volumes =
                        _js2n__-refsenv."_js2n__-:definitions/sequenceOfString_allowExpressions!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/jobContinueOnError!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/jobDependsOn!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate"
                ]
            ],
      "_js2n__-:definitions/jobMatrix!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.minProperties 1,
                  _js2n__-prdslib.records.record {}
                    {
                      "^[A-Za-z0-9_]+$" =
                        _js2n__-refsenv."_js2n__-:definitions/matrixProperties!predicate",
                    } true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/jobServices!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/jobStrategy!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      matrix =
                        _js2n__-refsenv."_js2n__-:definitions/jobMatrix!predicate",
                      maxParallel =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      parallel =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/jobWorkspace!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clean =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.enum
                            [ "outputs", "resources", "all" ],
                          _js2n__-refsenv."_js2n__-:definitions/string!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/jobs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/job!predicate"
            ],
      "_js2n__-:definitions/legacyRepoResourceAlias!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^self$"
            ],
      "_js2n__-:definitions/legacyResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clean =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.enum [ "true", "false" ],
                          _js2n__-refsenv."_js2n__-:definitions/string!predicate"
                        ],
                  fetchDepth =
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                  lfs = _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                  repo =
                    _js2n__-refsenv."_js2n__-:definitions/legacyRepoResourceAlias!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/lockBehavior!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^sequential$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^runLatest$"
                ]
            ],
      "_js2n__-:definitions/mapping!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/mappingOfStringString!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/matrixProperties!predicate"
        | doc "Variable-value pair to pass in this matrix instance"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nonEmptyString!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/onFailureHook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pool = _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                  steps =
                    _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/onSuccessHook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pool = _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                  steps =
                    _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/onSuccessOrFailureHook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  failure =
                    _js2n__-refsenv."_js2n__-:definitions/onFailureHook!predicate",
                  success =
                    _js2n__-refsenv."_js2n__-:definitions/onSuccessHook!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/packageResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "connection", "name", "package", "type" ],
              _js2n__-prdslib.records.record
                {
                  connection =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  package =
                    _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                  tag =
                    _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                  trigger =
                    _js2n__-refsenv."_js2n__-:definitions/packageResourceTrigger!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/packageResourceTrigger!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^none$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^true$"
                ]
            ],
      "_js2n__-:definitions/packageResources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/packageResource!predicate"
            ],
      "_js2n__-:definitions/phase!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/jobContinueOnError!predicate",
                      dependsOn =
                        _js2n__-refsenv."_js2n__-:definitions/jobDependsOn!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      phase =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      queue =
                        _js2n__-refsenv."_js2n__-:definitions/phaseQueueTarget!predicate",
                      steps =
                        _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/jobContinueOnError!predicate",
                      dependsOn =
                        _js2n__-refsenv."_js2n__-:definitions/jobDependsOn!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      phase =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      server =
                        _js2n__-refsenv."_js2n__-:definitions/phaseServerTarget!predicate",
                      steps =
                        _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/mapping!predicate",
                      template =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/phaseQueueTarget!predicate"
        | doc "Queue details"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      cancelTimeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      container =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      demands =
                        _js2n__-refsenv."_js2n__-:definitions/phaseTargetDemands!predicate",
                      matrix =
                        _js2n__-refsenv."_js2n__-:definitions/phaseTargetMatrix!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      parallel =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      workspace =
                        _js2n__-refsenv."_js2n__-:definitions/phaseTargetWorkspace!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/phaseServerTarget!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      cancelTimeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      matrix =
                        _js2n__-refsenv."_js2n__-:definitions/phaseTargetMatrix!predicate",
                      parallel =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/phaseTargetDemands!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate"
                ]
            ],
      "_js2n__-:definitions/phaseTargetMatrix!predicate"
        | doc "List of permutations of variable values to run"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record {}
                {
                  "^[A-Za-z0-9_]+$" =
                    _js2n__-refsenv."_js2n__-:definitions/matrixProperties!predicate",
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/phaseTargetWorkspace!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clean =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.enum
                            [ "outputs", "resources", "all" ],
                          _js2n__-refsenv."_js2n__-:definitions/string!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/phases!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/phase!predicate"
            ],
      "_js2n__-:definitions/pipeline!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "stages" ],
                  _js2n__-prdslib.records.record
                    {
                      appendCommitMessageToRunName =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      lockBehavior =
                        _js2n__-refsenv."_js2n__-:definitions/lockBehavior!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/pipelineTemplateParameters!predicate",
                      pool =
                        _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                      pr = _js2n__-refsenv."_js2n__-:definitions/pr!predicate",
                      resources =
                        _js2n__-refsenv."_js2n__-:definitions/resources!predicate",
                      schedules =
                        _js2n__-refsenv."_js2n__-:definitions/schedules!predicate",
                      stages =
                        _js2n__-refsenv."_js2n__-:definitions/stages!predicate",
                      trigger =
                        _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "extends" ],
                  _js2n__-prdslib.records.record
                    {
                      appendCommitMessageToRunName =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      extends =
                        _js2n__-refsenv."_js2n__-:definitions/extends!predicate",
                      lockBehavior =
                        _js2n__-refsenv."_js2n__-:definitions/lockBehavior!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/pipelineTemplateParameters!predicate",
                      pool =
                        _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                      pr = _js2n__-refsenv."_js2n__-:definitions/pr!predicate",
                      resources =
                        _js2n__-refsenv."_js2n__-:definitions/resources!predicate",
                      schedules =
                        _js2n__-refsenv."_js2n__-:definitions/schedules!predicate",
                      trigger =
                        _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "jobs" ],
                  _js2n__-prdslib.records.record
                    {
                      appendCommitMessageToRunName =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      jobs =
                        _js2n__-refsenv."_js2n__-:definitions/jobs!predicate",
                      lockBehavior =
                        _js2n__-refsenv."_js2n__-:definitions/lockBehavior!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/pipelineTemplateParameters!predicate",
                      pool =
                        _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                      pr = _js2n__-refsenv."_js2n__-:definitions/pr!predicate",
                      resources =
                        _js2n__-refsenv."_js2n__-:definitions/resources!predicate",
                      schedules =
                        _js2n__-refsenv."_js2n__-:definitions/schedules!predicate",
                      trigger =
                        _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "phases" ],
                  _js2n__-prdslib.records.record
                    {
                      appendCommitMessageToRunName =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      lockBehavior =
                        _js2n__-refsenv."_js2n__-:definitions/lockBehavior!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/pipelineTemplateParameters!predicate",
                      phases =
                        _js2n__-refsenv."_js2n__-:definitions/phases!predicate",
                      pr = _js2n__-refsenv."_js2n__-:definitions/pr!predicate",
                      resources =
                        _js2n__-refsenv."_js2n__-:definitions/resources!predicate",
                      schedules =
                        _js2n__-refsenv."_js2n__-:definitions/schedules!predicate",
                      trigger =
                        _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "steps" ],
                  _js2n__-prdslib.records.record
                    {
                      appendCommitMessageToRunName =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      container =
                        _js2n__-refsenv."_js2n__-:definitions/jobContainer!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/jobContinueOnError!predicate",
                      lockBehavior =
                        _js2n__-refsenv."_js2n__-:definitions/lockBehavior!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/pipelineTemplateParameters!predicate",
                      pool =
                        _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                      pr = _js2n__-refsenv."_js2n__-:definitions/pr!predicate",
                      resources =
                        _js2n__-refsenv."_js2n__-:definitions/resources!predicate",
                      schedules =
                        _js2n__-refsenv."_js2n__-:definitions/schedules!predicate",
                      services =
                        _js2n__-refsenv."_js2n__-:definitions/jobServices!predicate",
                      steps =
                        _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                      strategy =
                        _js2n__-refsenv."_js2n__-:definitions/jobStrategy!predicate",
                      trigger =
                        _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                      workspace =
                        _js2n__-refsenv."_js2n__-:definitions/jobWorkspace!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "steps" ],
                  _js2n__-prdslib.records.record
                    {
                      appendCommitMessageToRunName =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/jobContinueOnError!predicate",
                      lockBehavior =
                        _js2n__-refsenv."_js2n__-:definitions/lockBehavior!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/pipelineTemplateParameters!predicate",
                      pr = _js2n__-refsenv."_js2n__-:definitions/pr!predicate",
                      queue =
                        _js2n__-refsenv."_js2n__-:definitions/phaseQueueTarget!predicate",
                      resources =
                        _js2n__-refsenv."_js2n__-:definitions/resources!predicate",
                      schedules =
                        _js2n__-refsenv."_js2n__-:definitions/schedules!predicate",
                      steps =
                        _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                      trigger =
                        _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "steps" ],
                  _js2n__-prdslib.records.record
                    {
                      appendCommitMessageToRunName =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/jobContinueOnError!predicate",
                      lockBehavior =
                        _js2n__-refsenv."_js2n__-:definitions/lockBehavior!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/pipelineTemplateParameters!predicate",
                      pr = _js2n__-refsenv."_js2n__-:definitions/pr!predicate",
                      resources =
                        _js2n__-refsenv."_js2n__-:definitions/resources!predicate",
                      schedules =
                        _js2n__-refsenv."_js2n__-:definitions/schedules!predicate",
                      server =
                        _js2n__-refsenv."_js2n__-:definitions/phaseServerTarget!predicate",
                      steps =
                        _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                      trigger =
                        _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/pipelineResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "pipeline" ],
              _js2n__-prdslib.records.record
                {
                  branch =
                    _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                  pipeline =
                    _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                  project =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  tags =
                    _js2n__-refsenv."_js2n__-:definitions/sequenceOfNonEmptyString!predicate",
                  trigger =
                    _js2n__-refsenv."_js2n__-:definitions/pipelineResourceTrigger!predicate",
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/pipelineResourceTrigger!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^none$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^true$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      branches =
                        _js2n__-refsenv."_js2n__-:definitions/triggerBranchFilter!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      stages =
                        _js2n__-refsenv."_js2n__-:definitions/sequenceOfNonEmptyString!predicate",
                      tags =
                        _js2n__-refsenv."_js2n__-:definitions/sequenceOfNonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/pipelineResources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/pipelineResource!predicate"
            ],
      "_js2n__-:definitions/pipelineTemplateParameter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "default" =
                    _js2n__-refsenv."_js2n__-:definitions/any!predicate",
                  displayName =
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/pipelineTemplateParameterType!predicate",
                  values =
                    _js2n__-refsenv."_js2n__-:definitions/sequenceOfNonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/pipelineTemplateParameterType!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^boolean$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^container$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^containerList$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^deployment$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^deploymentList$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^environment$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^filePath$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^job$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^jobList$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^number$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^object$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^pool$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^secureFile$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^serviceConnection$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^stage$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^stageList$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^step$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^stepList$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^string$"
                ]
            ],
      "_js2n__-:definitions/pipelineTemplateParameters!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/pipelineTemplateParameter!predicate"
            ],
      "_js2n__-:definitions/pool!predicate"
        | doc "Pool details"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      demands =
                        _js2n__-refsenv."_js2n__-:definitions/poolDemands!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/poolDemands!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate"
                ]
            ],
      "_js2n__-:definitions/postRouteTrafficHook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pool = _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                  steps =
                    _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/pr!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^none$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/branchFilter!predicate"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      autoCancel =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      branches =
                        _js2n__-refsenv."_js2n__-:definitions/includeExcludeFilters!predicate",
                      drafts =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      paths =
                        _js2n__-refsenv."_js2n__-:definitions/includeExcludeFilters!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/preDeployHook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pool = _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                  steps =
                    _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/readOnlyMounts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  externals =
                    _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                  tasks =
                    _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                  tools =
                    _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                  work =
                    _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/referenceName!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[-_A-Za-z0-9]*$"
            ],
      "_js2n__-:definitions/repositoryCheckoutOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clean =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.enum [ "true", "false" ],
                          _js2n__-refsenv."_js2n__-:definitions/string!predicate"
                        ],
                  fetchDepth =
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                  fetchTags =
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                  lfs = _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                  persistCredentials =
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                  submodules =
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/repositoryResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repository" ],
              _js2n__-prdslib.records.record
                {
                  checkoutOptions =
                    _js2n__-refsenv."_js2n__-:definitions/repositoryCheckoutOptions!predicate",
                  endpoint =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  ref =
                    _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                  trigger =
                    _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/repositoryResources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/repositoryResource!predicate"
            ],
      "_js2n__-:definitions/resources!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      builds =
                        _js2n__-refsenv."_js2n__-:definitions/buildResources!predicate",
                      containers =
                        _js2n__-refsenv."_js2n__-:definitions/containerResources!predicate",
                      packages =
                        _js2n__-refsenv."_js2n__-:definitions/packageResources!predicate",
                      pipelines =
                        _js2n__-refsenv."_js2n__-:definitions/pipelineResources!predicate",
                      repositories =
                        _js2n__-refsenv."_js2n__-:definitions/repositoryResources!predicate",
                      webhooks =
                        _js2n__-refsenv."_js2n__-:definitions/webhookResources!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/legacyResource!predicate"
                ]
            ],
      "_js2n__-:definitions/rollingDeploymentStrategy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  deploy =
                    _js2n__-refsenv."_js2n__-:definitions/deployHook!predicate",
                  maxParallel =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  on =
                    _js2n__-refsenv."_js2n__-:definitions/onSuccessOrFailureHook!predicate",
                  postRouteTraffic =
                    _js2n__-refsenv."_js2n__-:definitions/postRouteTrafficHook!predicate",
                  preDeploy =
                    _js2n__-refsenv."_js2n__-:definitions/preDeployHook!predicate",
                  routeTraffic =
                    _js2n__-refsenv."_js2n__-:definitions/routeTrafficHook!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/routeTrafficHook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pool = _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                  steps =
                    _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/runOnceDeploymentStrategy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  deploy =
                    _js2n__-refsenv."_js2n__-:definitions/deployHook!predicate",
                  on =
                    _js2n__-refsenv."_js2n__-:definitions/onSuccessOrFailureHook!predicate",
                  postRouteTraffic =
                    _js2n__-refsenv."_js2n__-:definitions/postRouteTrafficHook!predicate",
                  preDeploy =
                    _js2n__-refsenv."_js2n__-:definitions/preDeployHook!predicate",
                  routeTraffic =
                    _js2n__-refsenv."_js2n__-:definitions/routeTrafficHook!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/schedule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  always =
                    _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                  batch =
                    _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                  branches =
                    _js2n__-refsenv."_js2n__-:definitions/includeExcludeFilters!predicate",
                  cron =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  displayName =
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/schedules!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/schedule!predicate"
            ],
      "_js2n__-:definitions/sequenceOfNonEmptyString!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate"
            ],
      "_js2n__-:definitions/sequenceOfString_allowExpressions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/string_allowExpressions!predicate"
            ],
      "_js2n__-:definitions/stage!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      dependsOn =
                        _js2n__-refsenv."_js2n__-:definitions/jobDependsOn!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      isSkippable =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      jobs =
                        _js2n__-refsenv."_js2n__-:definitions/jobs!predicate",
                      lockBehavior =
                        _js2n__-refsenv."_js2n__-:definitions/lockBehavior!predicate",
                      pool =
                        _js2n__-refsenv."_js2n__-:definitions/pool!predicate",
                      stage =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      templateContext =
                        _js2n__-refsenv."_js2n__-:definitions/templateContext!predicate",
                      trigger =
                        _js2n__-refsenv."_js2n__-:definitions/stageTrigger!predicate",
                      variables =
                        _js2n__-refsenv."_js2n__-:definitions/variables!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/mapping!predicate",
                      template =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/stageTrigger!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^manual$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^automatic$"
                ]
            ],
      "_js2n__-:definitions/stages!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/stage!predicate"
            ],
      "_js2n__-:definitions/step!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-refsenv."_js2n__-:definitions/task!predicate"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "script" ],
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      failOnStderr =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      script =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      workingDirectory =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "powershell" ],
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      errorActionPreference =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      failOnStderr =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      ignoreLASTEXITCODE =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      powershell =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      workingDirectory =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "pwsh" ],
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      errorActionPreference =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      failOnStderr =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      ignoreLASTEXITCODE =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      pwsh =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      workingDirectory =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "bash" ],
                  _js2n__-prdslib.records.record
                    {
                      bash =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      failOnStderr =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      workingDirectory =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      checkout =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      clean =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.enum [ "true", "false" ],
                              _js2n__-refsenv."_js2n__-:definitions/string!predicate"
                            ],
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      fetchDepth =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      fetchFilter =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      fetchTags =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      lfs =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      path =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      persistCredentials =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      submodules =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      workspaceRepo =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.enum [ "true", "false" ],
                              _js2n__-refsenv."_js2n__-:definitions/string!predicate"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "download" ],
                  _js2n__-prdslib.records.record
                    {
                      artifact =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      download =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      patterns =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      artifact =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      downloadBuild =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      inputs =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      path =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      patterns =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      getPackage =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      path =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      artifact =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      upload =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      artifact =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      publish =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/mapping!predicate",
                      template =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      continueOnError =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      displayName =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      env =
                        _js2n__-refsenv."_js2n__-:definitions/mappingOfStringString!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                      retryCountOnTaskFailure =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      reviewApp =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/stepTarget!predicate",
                      timeoutInMinutes =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/stepTarget!predicate"
        | doc "Step target"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      commands =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.enum [ "any", "restricted" ],
                              _js2n__-refsenv."_js2n__-:definitions/string!predicate"
                            ],
                      container =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      settableVariables =
                        _js2n__-refsenv."_js2n__-:definitions/variableRestrictions!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/steps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/step!predicate"
            ],
      "_js2n__-:definitions/string!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/string_allowExpressions!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/task!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  debugPreference =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "stop",
                                          "continue",
                                          "silentlyContinue"
                                        ],
                                  errorActionPreference =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "stop",
                                          "continue",
                                          "silentlyContinue"
                                        ],
                                  failOnStderr = _js2n__-prdslib.isType '"Bool",
                                  filePath = _js2n__-prdslib.isType '"String",
                                  ignoreLASTEXITCODE =
                                    _js2n__-prdslib.isType '"Bool",
                                  informationPreference =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "stop",
                                          "continue",
                                          "silentlyContinue"
                                        ],
                                  progressPreference =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "stop",
                                          "continue",
                                          "silentlyContinue"
                                        ],
                                  pwsh = _js2n__-prdslib.isType '"Bool",
                                  runScriptInSeparateScope =
                                    _js2n__-prdslib.isType '"Bool",
                                  script = _js2n__-prdslib.isType '"String",
                                  showWarnings = _js2n__-prdslib.isType '"Bool",
                                  targetType =
                                    _js2n__-prdslib.enum
                                        [ "filePath", "inline" ],
                                  verbosePreference =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "stop",
                                          "continue",
                                          "silentlyContinue"
                                        ],
                                  warningPreference =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "stop",
                                          "continue",
                                          "silentlyContinue"
                                        ],
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^PowerShell@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  failOnStandardError =
                                    _js2n__-prdslib.isType '"Bool",
                                  inlineScript =
                                    _js2n__-prdslib.isType '"String",
                                  scriptName = _js2n__-prdslib.isType '"String",
                                  scriptType =
                                    _js2n__-prdslib.enum
                                        [ "inlineScript", "filePath" ],
                                  workingFolder =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^PowerShell@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      FailOnStandardError =
                                        _js2n__-prdslib.isType '"Bool",
                                      Inline = _js2n__-prdslib.isType '"String",
                                      ScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptType =
                                        _js2n__-prdslib.enum
                                            [ "FilePath", "InlineScript" ],
                                      azurePowerShellVersion =
                                        _js2n__-prdslib.enum
                                            [ "LatestVersion", "OtherVersion" ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      errorActionPreference =
                                        _js2n__-prdslib.enum
                                            [
                                              "stop",
                                              "continue",
                                              "silentlyContinue"
                                            ],
                                      preferredAzurePowerShellVersion =
                                        _js2n__-prdslib.isType '"String",
                                      pwsh = _js2n__-prdslib.isType '"Bool",
                                      validateScriptSignature =
                                        _js2n__-prdslib.isType '"Bool",
                                      workingDirectory =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzurePowerShell@5$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  Inline = _js2n__-prdslib.isType '"String",
                                  ScriptArguments =
                                    _js2n__-prdslib.isType '"String",
                                  ScriptPath = _js2n__-prdslib.isType '"String",
                                  ScriptType =
                                    _js2n__-prdslib.enum
                                        [ "FilePath", "InlineScript" ],
                                  azureClassicSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  azureConnectionType =
                                    _js2n__-prdslib.enum
                                        [
                                          "ConnectedServiceName",
                                          "ConnectedServiceNameARM"
                                        ],
                                  azurePowerShellVersion =
                                    _js2n__-prdslib.enum
                                        [ "LatestVersion", "OtherVersion" ],
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  preferredAzurePowerShellVersion =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzurePowerShell@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      FailOnStandardError =
                                        _js2n__-prdslib.isType '"Bool",
                                      Inline = _js2n__-prdslib.isType '"String",
                                      RestrictContextToCurrentTask =
                                        _js2n__-prdslib.isType '"Bool",
                                      ScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptType =
                                        _js2n__-prdslib.enum
                                            [ "FilePath", "InlineScript" ],
                                      azurePowerShellVersion =
                                        _js2n__-prdslib.enum
                                            [ "LatestVersion", "OtherVersion" ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      errorActionPreference =
                                        _js2n__-prdslib.enum
                                            [
                                              "stop",
                                              "continue",
                                              "silentlyContinue"
                                            ],
                                      preferredAzurePowerShellVersion =
                                        _js2n__-prdslib.isType '"String",
                                      pwsh = _js2n__-prdslib.isType '"Bool",
                                      validateScriptSignature =
                                        _js2n__-prdslib.isType '"Bool",
                                      workingDirectory =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzurePowerShell@4$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  FailOnStandardError =
                                    _js2n__-prdslib.isType '"Bool",
                                  Inline = _js2n__-prdslib.isType '"String",
                                  ScriptArguments =
                                    _js2n__-prdslib.isType '"String",
                                  ScriptPath = _js2n__-prdslib.isType '"String",
                                  ScriptType =
                                    _js2n__-prdslib.enum
                                        [ "FilePath", "InlineScript" ],
                                  azureClassicSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  azureConnectionType =
                                    _js2n__-prdslib.enum
                                        [
                                          "ConnectedServiceName",
                                          "ConnectedServiceNameARM"
                                        ],
                                  azurePowerShellVersion =
                                    _js2n__-prdslib.enum
                                        [ "LatestVersion", "OtherVersion" ],
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  errorActionPreference =
                                    _js2n__-prdslib.enum
                                        [
                                          "stop",
                                          "continue",
                                          "silentlyContinue"
                                        ],
                                  preferredAzurePowerShellVersion =
                                    _js2n__-prdslib.isType '"String",
                                  validateScriptSignature =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzurePowerShell@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  ConnectedServiceName =
                                    _js2n__-prdslib.isType '"String",
                                  ConnectedServiceNameARM =
                                    _js2n__-prdslib.isType '"String",
                                  ConnectedServiceNameSelector =
                                    _js2n__-prdslib.enum
                                        [
                                          "ConnectedServiceName",
                                          "ConnectedServiceNameARM"
                                        ],
                                  Inline = _js2n__-prdslib.isType '"String",
                                  ScriptArguments =
                                    _js2n__-prdslib.isType '"String",
                                  ScriptPath = _js2n__-prdslib.isType '"String",
                                  ScriptType =
                                    _js2n__-prdslib.enum
                                        [ "FilePath", "InlineScript" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzurePowerShell@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "SqlPassword", "SqlUsername" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      DatabaseName =
                                        _js2n__-prdslib.isType '"String",
                                      ServerName =
                                        _js2n__-prdslib.isType '"String",
                                      SqlAdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      SqlFile =
                                        _js2n__-prdslib.isType '"String",
                                      SqlInline =
                                        _js2n__-prdslib.isType '"String",
                                      SqlPassword =
                                        _js2n__-prdslib.isType '"String",
                                      SqlUsername =
                                        _js2n__-prdslib.isType '"String",
                                      TaskNameSelector =
                                        _js2n__-prdslib.enum
                                            [ "SqlTaskFile", "InlineSqlTask" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^MysqlDeploymentOnMachineGroup@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  artifactFeeds =
                                    _js2n__-prdslib.isType '"String",
                                  azureDevOpsServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                  feedUrl = _js2n__-prdslib.isType '"String",
                                  onlyAddExtraIndex =
                                    _js2n__-prdslib.isType '"Bool",
                                  pythonDownloadServiceConnections =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PipAuthenticate@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  artifactFeeds =
                                    _js2n__-prdslib.isType '"String",
                                  externalFeeds =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PipAuthenticate@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  allowBrokenSymlinks =
                                    _js2n__-prdslib.isType '"Bool",
                                  checkStyleRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageClassFilesDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageClassFilter =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageFailIfEmpty =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageRestoreOriginalPomXml =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageSourceDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageToolOption =
                                    _js2n__-prdslib.enum
                                        [ "None", "Cobertura", "JaCoCo" ],
                                  findBugsRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  goals = _js2n__-prdslib.isType '"String",
                                  isJacocoCoverageReportXML =
                                    _js2n__-prdslib.isType '"Bool",
                                  javaHomeOption =
                                    _js2n__-prdslib.enum
                                        [ "JDKVersion", "Path" ],
                                  jdkArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  jdkDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  jdkVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "1.17",
                                          "1.11",
                                          "1.10",
                                          "1.9",
                                          "1.8",
                                          "1.7",
                                          "1.6"
                                        ],
                                  mavenAuthenticateFeed =
                                    _js2n__-prdslib.isType '"Bool",
                                  mavenDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  mavenOptions =
                                    _js2n__-prdslib.isType '"String",
                                  mavenPomFile =
                                    _js2n__-prdslib.isType '"String",
                                  mavenSetM2Home =
                                    _js2n__-prdslib.isType '"Bool",
                                  mavenVersionOption =
                                    _js2n__-prdslib.enum [ "Default", "Path" ],
                                  options = _js2n__-prdslib.isType '"String",
                                  pmdRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  sqMavenPluginVersionChoice =
                                    _js2n__-prdslib.enum [ "latest", "pom" ],
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Maven@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  allowBrokenSymlinks =
                                    _js2n__-prdslib.isType '"Bool",
                                  checkStyleRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageClassFilesDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageClassFilter =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageFailIfEmpty =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageRestoreOriginalPomXml =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageSourceDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageToolOption =
                                    _js2n__-prdslib.enum
                                        [ "None", "Cobertura", "JaCoCo" ],
                                  effectivePomSkip =
                                    _js2n__-prdslib.isType '"Bool",
                                  failWhenBugsFound =
                                    _js2n__-prdslib.isType '"Bool",
                                  findBugsRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  goals = _js2n__-prdslib.isType '"String",
                                  isJacocoCoverageReportXML =
                                    _js2n__-prdslib.isType '"Bool",
                                  javaHomeOption =
                                    _js2n__-prdslib.enum
                                        [ "JDKVersion", "Path" ],
                                  jdkArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  jdkDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  jdkVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "1.17",
                                          "1.11",
                                          "1.10",
                                          "1.9",
                                          "1.8",
                                          "1.7",
                                          "1.6"
                                        ],
                                  mavenAuthenticateFeed =
                                    _js2n__-prdslib.isType '"Bool",
                                  mavenDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  mavenOptions =
                                    _js2n__-prdslib.isType '"String",
                                  mavenPomFile =
                                    _js2n__-prdslib.isType '"String",
                                  mavenSetM2Home =
                                    _js2n__-prdslib.isType '"Bool",
                                  mavenVersionOption =
                                    _js2n__-prdslib.enum [ "Default", "Path" ],
                                  options = _js2n__-prdslib.isType '"String",
                                  pmdRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  spotBugsGoal =
                                    _js2n__-prdslib.enum
                                        [ "spotbugs", "check" ],
                                  spotBugsRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  spotBugsVersion =
                                    _js2n__-prdslib.isType '"String",
                                  sqMavenPluginVersionChoice =
                                    _js2n__-prdslib.enum [ "latest", "pom" ],
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Maven@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  allowBrokenSymlinks =
                                    _js2n__-prdslib.isType '"Bool",
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  checkStyleRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageClassFilesDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageClassFilter =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageFailIfEmpty =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageRestoreOriginalPomXml =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageSourceDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageToolOption =
                                    _js2n__-prdslib.enum
                                        [ "None", "Cobertura", "JaCoCo" ],
                                  effectivePomSkip =
                                    _js2n__-prdslib.isType '"Bool",
                                  failWhenBugsFound =
                                    _js2n__-prdslib.isType '"Bool",
                                  findBugsRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  goals = _js2n__-prdslib.isType '"String",
                                  isJacocoCoverageReportXML =
                                    _js2n__-prdslib.isType '"Bool",
                                  javaHomeOption =
                                    _js2n__-prdslib.enum
                                        [ "JDKVersion", "Path" ],
                                  jdkArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  jdkDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  jdkVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "1.17",
                                          "1.11",
                                          "1.10",
                                          "1.9",
                                          "1.8",
                                          "1.7",
                                          "1.6"
                                        ],
                                  mavenAuthenticateFeed =
                                    _js2n__-prdslib.isType '"Bool",
                                  mavenDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  mavenOptions =
                                    _js2n__-prdslib.isType '"String",
                                  mavenPomFile =
                                    _js2n__-prdslib.isType '"String",
                                  mavenSetM2Home =
                                    _js2n__-prdslib.isType '"Bool",
                                  mavenVersionOption =
                                    _js2n__-prdslib.enum [ "Default", "Path" ],
                                  options = _js2n__-prdslib.isType '"String",
                                  pmdRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  spotBugsGoal =
                                    _js2n__-prdslib.enum
                                        [ "spotbugs", "check" ],
                                  spotBugsRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  spotBugsVersion =
                                    _js2n__-prdslib.isType '"String",
                                  sqMavenPluginVersionChoice =
                                    _js2n__-prdslib.enum [ "latest", "pom" ],
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Maven@4$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkStyleRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageClassFilesDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageClassFilter =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageFailIfEmpty =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageSourceDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageToolOption =
                                    _js2n__-prdslib.enum
                                        [ "None", "Cobertura", "JaCoCo" ],
                                  findBugsRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  goals = _js2n__-prdslib.isType '"String",
                                  javaHomeOption =
                                    _js2n__-prdslib.enum
                                        [ "JDKVersion", "Path" ],
                                  jdkArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  jdkDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  jdkVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "1.9",
                                          "1.8",
                                          "1.7",
                                          "1.6"
                                        ],
                                  mavenAuthenticateFeed =
                                    _js2n__-prdslib.isType '"Bool",
                                  mavenDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  mavenOptions =
                                    _js2n__-prdslib.isType '"String",
                                  mavenPomFile =
                                    _js2n__-prdslib.isType '"String",
                                  mavenSetM2Home =
                                    _js2n__-prdslib.isType '"Bool",
                                  mavenVersionOption =
                                    _js2n__-prdslib.enum [ "Default", "Path" ],
                                  options = _js2n__-prdslib.isType '"String",
                                  pmdRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeDBPassword =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeDBUrl =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeDBUsername =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeFailWhenQualityGateFails =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeIncludeFullReport =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeProjectKey =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeProjectName =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeProjectVersion =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeServiceEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeSpecifyDB =
                                    _js2n__-prdslib.isType '"Bool",
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Maven@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  buildProperties =
                                    _js2n__-prdslib.isType '"String",
                                  command =
                                    _js2n__-prdslib.enum
                                        [
                                          "build",
                                          "push",
                                          "pack",
                                          "publish",
                                          "restore",
                                          "run",
                                          "test",
                                          "custom"
                                        ],
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  custom = _js2n__-prdslib.isType '"String",
                                  externalFeedCredentials =
                                    _js2n__-prdslib.isType '"String",
                                  feedsToUse =
                                    _js2n__-prdslib.enum [ "select", "config" ],
                                  includeNuGetOrg =
                                    _js2n__-prdslib.isType '"Bool",
                                  includesource =
                                    _js2n__-prdslib.isType '"Bool",
                                  includesymbols =
                                    _js2n__-prdslib.isType '"Bool",
                                  majorVersion =
                                    _js2n__-prdslib.isType '"String",
                                  minorVersion =
                                    _js2n__-prdslib.isType '"String",
                                  modifyOutputPath =
                                    _js2n__-prdslib.isType '"Bool",
                                  noCache = _js2n__-prdslib.isType '"Bool",
                                  nobuild = _js2n__-prdslib.isType '"Bool",
                                  nuGetFeedType =
                                    _js2n__-prdslib.enum
                                        [ "internal", "external" ],
                                  nugetConfigPath =
                                    _js2n__-prdslib.isType '"String",
                                  packDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  packagesToPack =
                                    _js2n__-prdslib.isType '"String",
                                  packagesToPush =
                                    _js2n__-prdslib.isType '"String",
                                  patchVersion =
                                    _js2n__-prdslib.isType '"String",
                                  projects = _js2n__-prdslib.isType '"String",
                                  publishFeedCredentials =
                                    _js2n__-prdslib.isType '"String",
                                  publishPackageMetadata =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishTestResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishVstsFeed =
                                    _js2n__-prdslib.isType '"String",
                                  publishWebProjects =
                                    _js2n__-prdslib.isType '"Bool",
                                  requestTimeout =
                                    _js2n__-prdslib.isType 'Integer,
                                  restoreArguments =
                                    _js2n__-prdslib.isType '"String",
                                  restoreDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  verbosityPack =
                                    _js2n__-prdslib.enum
                                        [
                                          "-",
                                          "Quiet",
                                          "Minimal",
                                          "Normal",
                                          "Detailed",
                                          "Diagnostic"
                                        ],
                                  verbosityRestore =
                                    _js2n__-prdslib.enum
                                        [
                                          "-",
                                          "Quiet",
                                          "Minimal",
                                          "Normal",
                                          "Detailed",
                                          "Diagnostic"
                                        ],
                                  versionEnvVar =
                                    _js2n__-prdslib.isType '"String",
                                  versioningScheme =
                                    _js2n__-prdslib.enum
                                        [
                                          "off",
                                          "byPrereleaseNumber",
                                          "byEnvVar",
                                          "byBuildNumber"
                                        ],
                                  vstsFeed = _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  zipAfterPublish =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^DotNetCoreCLI@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  command =
                                    _js2n__-prdslib.enum
                                        [
                                          "build",
                                          "publish",
                                          "restore",
                                          "test",
                                          "run"
                                        ],
                                  projects = _js2n__-prdslib.isType '"String",
                                  publishWebProjects =
                                    _js2n__-prdslib.isType '"Bool",
                                  zipAfterPublish =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^DotNetCoreCLI@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  command =
                                    _js2n__-prdslib.enum
                                        [
                                          "build",
                                          "publish",
                                          "restore",
                                          "test",
                                          "run"
                                        ],
                                  projects = _js2n__-prdslib.isType '"String",
                                  publishWebProjects =
                                    _js2n__-prdslib.isType '"Bool",
                                  zipAfterPublish =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^DotNetCoreCLI@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "email", "password" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      email = _js2n__-prdslib.isType '"String",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      solutionFile =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^XamarinComponentRestore@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "WebAppName", "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      AppSettings =
                                        _js2n__-prdslib.isType '"String",
                                      AzureContainerRegistry =
                                        _js2n__-prdslib.isType '"String",
                                      AzureContainerRegistryImage =
                                        _js2n__-prdslib.isType '"String",
                                      AzureContainerRegistryLoginServer =
                                        _js2n__-prdslib.isType '"String",
                                      AzureContainerRegistryTag =
                                        _js2n__-prdslib.isType '"String",
                                      ConfigurationSettings =
                                        _js2n__-prdslib.isType '"String",
                                      DeployToSlotFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      DockerImageTag =
                                        _js2n__-prdslib.isType '"String",
                                      DockerNamespace =
                                        _js2n__-prdslib.isType '"String",
                                      DockerRepository =
                                        _js2n__-prdslib.isType '"String",
                                      DockerRepositoryAccess =
                                        _js2n__-prdslib.enum
                                            [ "private", "public" ],
                                      ExcludeFilesFromAppDataFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      GenerateWebConfig =
                                        _js2n__-prdslib.isType '"Bool",
                                      ImageSource =
                                        _js2n__-prdslib.enum
                                            [ "Registry", "Builtin" ],
                                      InlineScript =
                                        _js2n__-prdslib.isType '"String",
                                      JSONFiles =
                                        _js2n__-prdslib.isType '"String",
                                      Package =
                                        _js2n__-prdslib.isType '"String",
                                      PrivateRegistryImage =
                                        _js2n__-prdslib.isType '"String",
                                      PrivateRegistryTag =
                                        _js2n__-prdslib.isType '"String",
                                      RemoveAdditionalFilesFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      RenameFilesFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      ResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      RuntimeStack =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptType =
                                        _js2n__-prdslib.enum
                                            [
                                              "",
                                              "Inline Script",
                                              "File Path"
                                            ],
                                      SetParametersFile =
                                        _js2n__-prdslib.isType '"String",
                                      SlotName =
                                        _js2n__-prdslib.isType '"String",
                                      StartupCommand =
                                        _js2n__-prdslib.isType '"String",
                                      TakeAppOfflineFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      UseWebDeploy =
                                        _js2n__-prdslib.isType '"Bool",
                                      VirtualApplication =
                                        _js2n__-prdslib.isType '"String",
                                      WebAppName =
                                        _js2n__-prdslib.isType '"String",
                                      WebAppUri =
                                        _js2n__-prdslib.isType '"String",
                                      WebConfigParameters =
                                        _js2n__-prdslib.isType '"String",
                                      appType =
                                        _js2n__-prdslib.enum
                                            [
                                              "app",
                                              "applinux",
                                              "functionapp",
                                              "api",
                                              "mobileapp"
                                            ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      dockerRegistryConnection =
                                        _js2n__-prdslib.isType '"String",
                                      enableXmlTransform =
                                        _js2n__-prdslib.isType '"Bool",
                                      enableXmlVariableSubstitution =
                                        _js2n__-prdslib.isType '"Bool",
                                      packageForLinux =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureRmWebAppDeployment@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "ConnectedServiceName", "WebAppName" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ConnectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      DeployToSlotFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      ExcludeFilesFromAppDataFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      Package =
                                        _js2n__-prdslib.isType '"String",
                                      RemoveAdditionalFilesFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      ResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      SetParametersFile =
                                        _js2n__-prdslib.isType '"String",
                                      SlotName =
                                        _js2n__-prdslib.isType '"String",
                                      TakeAppOfflineFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      UseWebDeploy =
                                        _js2n__-prdslib.isType '"Bool",
                                      VirtualApplication =
                                        _js2n__-prdslib.isType '"String",
                                      WebAppName =
                                        _js2n__-prdslib.isType '"String",
                                      WebAppUri =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureRmWebAppDeployment@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  AdditionalArguments =
                                    _js2n__-prdslib.isType '"String",
                                  AppSettings =
                                    _js2n__-prdslib.isType '"String",
                                  ConfigurationSettings =
                                    _js2n__-prdslib.isType '"String",
                                  ConnectionType =
                                    _js2n__-prdslib.enum
                                        [ "AzureRM", "PublishProfile" ],
                                  DeploymentType =
                                    _js2n__-prdslib.enum
                                        [
                                          "webDeploy",
                                          "zipDeploy",
                                          "runFromZip"
                                        ],
                                  DockerImageTag =
                                    _js2n__-prdslib.isType '"String",
                                  DockerNamespace =
                                    _js2n__-prdslib.isType '"String",
                                  DockerRepository =
                                    _js2n__-prdslib.isType '"String",
                                  ExcludeFilesFromAppDataFlag =
                                    _js2n__-prdslib.isType '"Bool",
                                  InlineScript =
                                    _js2n__-prdslib.isType '"String",
                                  JSONFiles = _js2n__-prdslib.isType '"String",
                                  PublishProfilePassword =
                                    _js2n__-prdslib.isType '"String",
                                  PublishProfilePath =
                                    _js2n__-prdslib.isType '"String",
                                  RemoveAdditionalFilesFlag =
                                    _js2n__-prdslib.isType '"Bool",
                                  RenameFilesFlag =
                                    _js2n__-prdslib.isType '"Bool",
                                  ResourceGroupName =
                                    _js2n__-prdslib.isType '"String",
                                  RuntimeStack =
                                    _js2n__-prdslib.isType '"String",
                                  RuntimeStackFunction =
                                    _js2n__-prdslib.enum
                                        [
                                          "DOTNET|2.2",
                                          "DOTNET|3.1",
                                          "JAVA|8",
                                          "JAVA|11",
                                          "NODE|8",
                                          "NODE|10",
                                          "NODE|12",
                                          "NODE|14",
                                          "PYTHON|3.6",
                                          "PYTHON|3.7",
                                          "PYTHON|3.8"
                                        ],
                                  ScriptPath = _js2n__-prdslib.isType '"String",
                                  ScriptType =
                                    _js2n__-prdslib.enum
                                        [ "", "Inline Script", "File Path" ],
                                  SetParametersFile =
                                    _js2n__-prdslib.isType '"String",
                                  SlotName = _js2n__-prdslib.isType '"String",
                                  StartupCommand =
                                    _js2n__-prdslib.isType '"String",
                                  TakeAppOfflineFlag =
                                    _js2n__-prdslib.isType '"Bool",
                                  VirtualApplication =
                                    _js2n__-prdslib.isType '"String",
                                  WebAppName = _js2n__-prdslib.isType '"String",
                                  WebConfigParameters =
                                    _js2n__-prdslib.isType '"String",
                                  appType =
                                    _js2n__-prdslib.enum
                                        [
                                          "webApp",
                                          "webAppLinux",
                                          "webAppContainer",
                                          "webAppHyperVContainer",
                                          "functionApp",
                                          "functionAppLinux",
                                          "functionAppContainer",
                                          "apiApp",
                                          "mobileApp"
                                        ],
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  deployToSlotOrASE =
                                    _js2n__-prdslib.isType '"Bool",
                                  enableCustomDeployment =
                                    _js2n__-prdslib.isType '"Bool",
                                  enableXmlTransform =
                                    _js2n__-prdslib.isType '"Bool",
                                  enableXmlVariableSubstitution =
                                    _js2n__-prdslib.isType '"Bool",
                                  packageForLinux =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureRmWebAppDeployment@4$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "Machines" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AuthenticationMechanism =
                                        _js2n__-prdslib.enum
                                            [ "Default", "Credssp" ],
                                      CommunicationProtocol =
                                        _js2n__-prdslib.enum
                                            [ "Http", "Https" ],
                                      ErrorActionPreference =
                                        _js2n__-prdslib.enum
                                            [
                                              "stop",
                                              "continue",
                                              "silentlyContinue"
                                            ],
                                      InitializationScript =
                                        _js2n__-prdslib.isType '"String",
                                      InlineScript =
                                        _js2n__-prdslib.isType '"String",
                                      Machines =
                                        _js2n__-prdslib.isType '"String",
                                      NewPsSessionOptionArguments =
                                        _js2n__-prdslib.isType '"String",
                                      RunPowershellInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      ScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptType =
                                        _js2n__-prdslib.enum
                                            [ "FilePath", "Inline" ],
                                      SessionVariables =
                                        _js2n__-prdslib.isType '"String",
                                      UserName =
                                        _js2n__-prdslib.isType '"String",
                                      UserPassword =
                                        _js2n__-prdslib.isType '"String",
                                      WorkingDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      failOnStderr =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreLASTEXITCODE =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PowerShellOnTargetMachines@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "EnvironmentName", "ScriptPath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      AdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                      EnvironmentName =
                                        _js2n__-prdslib.isType '"String",
                                      InitializationScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      Protocol =
                                        _js2n__-prdslib.enum
                                            [ "Http", "Https" ],
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      RunPowershellInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      ScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      SessionVariables =
                                        _js2n__-prdslib.isType '"String",
                                      TestCertificate =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PowerShellOnTargetMachines@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "EnvironmentName", "ScriptPath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      AdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                      EnvironmentName =
                                        _js2n__-prdslib.isType '"String",
                                      InitializationScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      Protocol =
                                        _js2n__-prdslib.enum
                                            [ "Http", "Https" ],
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      RunPowershellInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      ScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      SessionVariables =
                                        _js2n__-prdslib.isType '"String",
                                      TestCertificate =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PowerShellOnTargetMachines@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "summaryFileLocation" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      failIfCoverageEmpty =
                                        _js2n__-prdslib.isType '"Bool",
                                      pathToSources =
                                        _js2n__-prdslib.isType '"String",
                                      summaryFileLocation =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishCodeCoverageResults@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "summaryFileLocation" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      additionalCodeCoverageFiles =
                                        _js2n__-prdslib.isType '"String",
                                      codeCoverageTool =
                                        _js2n__-prdslib.enum
                                            [ "Cobertura", "JaCoCo" ],
                                      failIfCoverageEmpty =
                                        _js2n__-prdslib.isType '"Bool",
                                      pathToSources =
                                        _js2n__-prdslib.isType '"String",
                                      reportDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      summaryFileLocation =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishCodeCoverageResults@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "dropLocation", "testMachineGroup" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      autMachineGroup =
                                        _js2n__-prdslib.isType '"String",
                                      codeCoverageEnabled =
                                        _js2n__-prdslib.isType '"Bool",
                                      configuration =
                                        _js2n__-prdslib.isType '"String",
                                      customSlicingEnabled =
                                        _js2n__-prdslib.isType '"Bool",
                                      dropLocation =
                                        _js2n__-prdslib.isType '"String",
                                      overrideRunParams =
                                        _js2n__-prdslib.isType '"String",
                                      platform =
                                        _js2n__-prdslib.isType '"String",
                                      runSettingsFile =
                                        _js2n__-prdslib.isType '"String",
                                      sourcefilters =
                                        _js2n__-prdslib.isType '"String",
                                      testConfiguration =
                                        _js2n__-prdslib.isType '"String",
                                      testConfigurations =
                                        _js2n__-prdslib.isType '"String",
                                      testFilterCriteria =
                                        _js2n__-prdslib.isType '"String",
                                      testMachineGroup =
                                        _js2n__-prdslib.isType '"String",
                                      testPlan =
                                        _js2n__-prdslib.isType '"String",
                                      testRunTitle =
                                        _js2n__-prdslib.isType '"String",
                                      testSelection =
                                        _js2n__-prdslib.enum
                                            [ "testAssembly", "testPlan" ],
                                      testSuite =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^RunVisualStudioTestsusingTestAgent@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  emailRecipients =
                                    _js2n__-prdslib.isType '"String",
                                  instructions =
                                    _js2n__-prdslib.isType '"String",
                                  onTimeout =
                                    _js2n__-prdslib.enum [ "reject", "resume" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ManualIntervention@8$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  provProfileSecureFile =
                                    _js2n__-prdslib.isType '"String",
                                  provProfileSourceRepository =
                                    _js2n__-prdslib.isType '"String",
                                  provisioningProfileLocation =
                                    _js2n__-prdslib.enum
                                        [ "secureFiles", "sourceRepository" ],
                                  removeProfile =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^InstallAppleProvisioningProfile@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "provProfileSecureFile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      provProfileSecureFile =
                                        _js2n__-prdslib.isType '"String",
                                      removeProfile =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^InstallAppleProvisioningProfile@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record {} {} false
                                _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^SonarQubePostTest@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "packageDirectory", "pypiConnection" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      alsoPublishWheel =
                                        _js2n__-prdslib.isType '"Bool",
                                      packageDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      pypiConnection =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^PyPIPublisher@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "ConnectedServiceName", "ScriptPath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ConnectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^ChefKnife@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  goBin = _js2n__-prdslib.isType '"String",
                                  goPath = _js2n__-prdslib.isType '"String",
                                  version = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^GoTool@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "provisioningProfile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appName =
                                        _js2n__-prdslib.isType '"String",
                                      appPath =
                                        _js2n__-prdslib.isType '"String",
                                      ipaName =
                                        _js2n__-prdslib.isType '"String",
                                      ipaPath =
                                        _js2n__-prdslib.isType '"String",
                                      provisioningProfile =
                                        _js2n__-prdslib.isType '"String",
                                      sdk = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^XcodePackageiOS@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  command =
                                    _js2n__-prdslib.enum
                                        [ "get", "build", "test", "custom" ],
                                  customCommand =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Go@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record {} {} false
                                _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishPipelineMetadata@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  action =
                                    _js2n__-prdslib.enum
                                        [
                                          "Build an image",
                                          "Tag images",
                                          "Push an image",
                                          "Push images",
                                          "Run an image",
                                          "Run a Docker command"
                                        ],
                                  addBaseImageData =
                                    _js2n__-prdslib.isType '"Bool",
                                  additionalImageTags =
                                    _js2n__-prdslib.isType '"String",
                                  azureContainerRegistry =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  buildArguments =
                                    _js2n__-prdslib.isType '"String",
                                  containerCommand =
                                    _js2n__-prdslib.isType '"String",
                                  containerName =
                                    _js2n__-prdslib.isType '"String",
                                  containerregistrytype =
                                    _js2n__-prdslib.enum
                                        [
                                          "Azure Container Registry",
                                          "Container Registry"
                                        ],
                                  context = _js2n__-prdslib.isType '"String",
                                  customCommand =
                                    _js2n__-prdslib.isType '"String",
                                  defaultContext =
                                    _js2n__-prdslib.isType '"Bool",
                                  detached = _js2n__-prdslib.isType '"Bool",
                                  dockerFile = _js2n__-prdslib.isType '"String",
                                  dockerHostEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  dockerRegistryConnection =
                                    _js2n__-prdslib.isType '"String",
                                  enforceDockerNamingConvention =
                                    _js2n__-prdslib.isType '"Bool",
                                  entrypoint = _js2n__-prdslib.isType '"String",
                                  envVars = _js2n__-prdslib.isType '"String",
                                  imageDigestFile =
                                    _js2n__-prdslib.isType '"String",
                                  imageName = _js2n__-prdslib.isType '"String",
                                  imageNamesPath =
                                    _js2n__-prdslib.isType '"String",
                                  includeLatestTag =
                                    _js2n__-prdslib.isType '"Bool",
                                  includeSourceTags =
                                    _js2n__-prdslib.isType '"Bool",
                                  memory = _js2n__-prdslib.isType '"String",
                                  ports = _js2n__-prdslib.isType '"String",
                                  qualifyImageName =
                                    _js2n__-prdslib.isType '"Bool",
                                  restartMaxRetries =
                                    _js2n__-prdslib.isType '"String",
                                  restartPolicy =
                                    _js2n__-prdslib.enum
                                        [
                                          "no",
                                          "onFailure",
                                          "always",
                                          "unlessStopped"
                                        ],
                                  volumes = _js2n__-prdslib.isType '"String",
                                  workDir = _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Docker@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  Dockerfile = _js2n__-prdslib.isType '"String",
                                  addBaseImageData =
                                    _js2n__-prdslib.isType '"Bool",
                                  addPipelineData =
                                    _js2n__-prdslib.isType '"Bool",
                                  arguments = _js2n__-prdslib.isType '"String",
                                  buildContext =
                                    _js2n__-prdslib.isType '"String",
                                  command =
                                    _js2n__-prdslib.enum
                                        [
                                          "buildAndPush",
                                          "build",
                                          "push",
                                          "login",
                                          "logout",
                                          "start",
                                          "stop"
                                        ],
                                  container = _js2n__-prdslib.isType '"String",
                                  containerRegistry =
                                    _js2n__-prdslib.isType '"String",
                                  repository = _js2n__-prdslib.isType '"String",
                                  tags = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Docker@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  addBaseImageData =
                                    _js2n__-prdslib.isType '"Bool",
                                  addDefaultLabels =
                                    _js2n__-prdslib.isType '"Bool",
                                  arguments = _js2n__-prdslib.isType '"String",
                                  azureContainerRegistry =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscriptionEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  buildContext =
                                    _js2n__-prdslib.isType '"String",
                                  command =
                                    _js2n__-prdslib.enum
                                        [
                                          "Build an image",
                                          "Tag image",
                                          "Push an image",
                                          "Run an image",
                                          "login",
                                          "logout"
                                        ],
                                  containerCommand =
                                    _js2n__-prdslib.isType '"String",
                                  containerName =
                                    _js2n__-prdslib.isType '"String",
                                  containerregistrytype =
                                    _js2n__-prdslib.enum
                                        [
                                          "Azure Container Registry",
                                          "Container Registry"
                                        ],
                                  dockerFile = _js2n__-prdslib.isType '"String",
                                  dockerHostEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  dockerRegistryEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  enforceDockerNamingConvention =
                                    _js2n__-prdslib.isType '"Bool",
                                  entrypointOverride =
                                    _js2n__-prdslib.isType '"String",
                                  envVars = _js2n__-prdslib.isType '"String",
                                  imageDigestFile =
                                    _js2n__-prdslib.isType '"String",
                                  imageName = _js2n__-prdslib.isType '"String",
                                  imageNamesPath =
                                    _js2n__-prdslib.isType '"String",
                                  includeLatestTag =
                                    _js2n__-prdslib.isType '"Bool",
                                  includeSourceTags =
                                    _js2n__-prdslib.isType '"Bool",
                                  maxRestartRetries =
                                    _js2n__-prdslib.isType '"String",
                                  memoryLimit =
                                    _js2n__-prdslib.isType '"String",
                                  ports = _js2n__-prdslib.isType '"String",
                                  pushMultipleImages =
                                    _js2n__-prdslib.isType '"Bool",
                                  qualifyImageName =
                                    _js2n__-prdslib.isType '"Bool",
                                  qualifySourceImageName =
                                    _js2n__-prdslib.isType '"Bool",
                                  restartPolicy =
                                    _js2n__-prdslib.enum
                                        [
                                          "no",
                                          "onFailure",
                                          "always",
                                          "unlessStopped"
                                        ],
                                  runInBackground =
                                    _js2n__-prdslib.isType '"Bool",
                                  tagMultipleImages =
                                    _js2n__-prdslib.isType '"Bool",
                                  useDefaultContext =
                                    _js2n__-prdslib.isType '"Bool",
                                  volumes = _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Docker@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "jobName", "serverEndpoint" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      captureConsole =
                                        _js2n__-prdslib.isType '"Bool",
                                      capturePipeline =
                                        _js2n__-prdslib.isType '"Bool",
                                      delayBetweenRetries =
                                        _js2n__-prdslib.isType '"String",
                                      failOnUnstableResult =
                                        _js2n__-prdslib.isType '"Bool",
                                      isMultibranchJob =
                                        _js2n__-prdslib.isType '"Bool",
                                      isParameterizedJob =
                                        _js2n__-prdslib.isType '"Bool",
                                      jobName =
                                        _js2n__-prdslib.isType '"String",
                                      jobParameters =
                                        _js2n__-prdslib.isType '"String",
                                      multibranchPipelineBranch =
                                        _js2n__-prdslib.isType '"String",
                                      retryCount =
                                        _js2n__-prdslib.isType '"String",
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^JenkinsQueueJob@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "jobName", "serverEndpoint" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      captureConsole =
                                        _js2n__-prdslib.isType '"Bool",
                                      capturePipeline =
                                        _js2n__-prdslib.isType '"Bool",
                                      isMultibranchJob =
                                        _js2n__-prdslib.isType '"Bool",
                                      jobName =
                                        _js2n__-prdslib.isType '"String",
                                      jobParameters =
                                        _js2n__-prdslib.isType '"String",
                                      multibranchPipelineBranch =
                                        _js2n__-prdslib.isType '"String",
                                      parameterizedJob =
                                        _js2n__-prdslib.isType '"Bool",
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^JenkinsQueueJob@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "rootDirectory" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      clean = _js2n__-prdslib.isType '"Bool",
                                      cleanContents =
                                        _js2n__-prdslib.isType '"Bool",
                                      credentialsOption =
                                        _js2n__-prdslib.enum
                                            [ "serviceEndpoint", "inputs" ],
                                      customCmds =
                                        _js2n__-prdslib.isType '"String",
                                      enableUtf8 =
                                        _js2n__-prdslib.isType '"Bool",
                                      filePatterns =
                                        _js2n__-prdslib.isType '"String",
                                      implicitFTPS =
                                        _js2n__-prdslib.isType '"Bool",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      preservePaths =
                                        _js2n__-prdslib.isType '"Bool",
                                      remoteDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      rootDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      serverUrl =
                                        _js2n__-prdslib.isType '"String",
                                      trustSSL = _js2n__-prdslib.isType '"Bool",
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^FtpUpload@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "rootDirectory" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      clean = _js2n__-prdslib.isType '"Bool",
                                      cleanContents =
                                        _js2n__-prdslib.isType '"Bool",
                                      credentialsOption =
                                        _js2n__-prdslib.enum
                                            [ "serviceEndpoint", "inputs" ],
                                      filePatterns =
                                        _js2n__-prdslib.isType '"String",
                                      overwrite =
                                        _js2n__-prdslib.isType '"Bool",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      preservePaths =
                                        _js2n__-prdslib.isType '"Bool",
                                      remoteDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      rootDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      serverUrl =
                                        _js2n__-prdslib.isType '"String",
                                      trustSSL = _js2n__-prdslib.isType '"Bool",
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^FtpUpload@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "SourcePath", "TargetPath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      AdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      AdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                      CleanTargetBeforeCopy =
                                        _js2n__-prdslib.isType '"Bool",
                                      CopyFilesInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      EnvironmentName =
                                        _js2n__-prdslib.isType '"String",
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      SourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      TargetPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^WindowsMachineFileCopy@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "AdminPassword",
                                      "AdminUserName",
                                      "MachineNames",
                                      "SourcePath",
                                      "TargetPath"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      AdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      AdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                      CleanTargetBeforeCopy =
                                        _js2n__-prdslib.isType '"Bool",
                                      CopyFilesInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      SourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      TargetPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^WindowsMachineFileCopy@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  avdAbi = _js2n__-prdslib.isType '"String",
                                  avdForce = _js2n__-prdslib.isType '"Bool",
                                  avdName = _js2n__-prdslib.isType '"String",
                                  avdOptionalArgs =
                                    _js2n__-prdslib.isType '"String",
                                  createAvd = _js2n__-prdslib.isType '"Bool",
                                  deleteAvd = _js2n__-prdslib.isType '"Bool",
                                  emulatorDevice =
                                    _js2n__-prdslib.isType '"String",
                                  emulatorHeadless =
                                    _js2n__-prdslib.isType '"Bool",
                                  emulatorOptionalArgs =
                                    _js2n__-prdslib.isType '"String",
                                  emulatorTarget =
                                    _js2n__-prdslib.isType '"String",
                                  emulatorTimeout =
                                    _js2n__-prdslib.isType '"String",
                                  gradleArguments =
                                    _js2n__-prdslib.isType '"String",
                                  gradleProj = _js2n__-prdslib.isType '"String",
                                  gradleWrapper =
                                    _js2n__-prdslib.isType '"String",
                                  startEmulator =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^AndroidBuild@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  artifactFeeds =
                                    _js2n__-prdslib.isType '"String",
                                  externalFeeds =
                                    _js2n__-prdslib.isType '"String",
                                  publishPackageMetadata =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^TwineAuthenticate@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  artifactFeed =
                                    _js2n__-prdslib.isType '"String",
                                  azureDevOpsServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                  feedUrl = _js2n__-prdslib.isType '"String",
                                  pythonUploadServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^TwineAuthenticate@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "WebSiteName" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ExcludeFilesFromAppDataFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      JSONFiles =
                                        _js2n__-prdslib.isType '"String",
                                      Package =
                                        _js2n__-prdslib.isType '"String",
                                      RemoveAdditionalFilesFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      SetParametersFile =
                                        _js2n__-prdslib.isType '"String",
                                      TakeAppOfflineFlag =
                                        _js2n__-prdslib.isType '"Bool",
                                      VirtualApplication =
                                        _js2n__-prdslib.isType '"String",
                                      WebSiteName =
                                        _js2n__-prdslib.isType '"String",
                                      XmlTransformation =
                                        _js2n__-prdslib.isType '"Bool",
                                      XmlVariableSubstitution =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^IISWebAppDeploymentOnMachineGroup@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  failOnStderr = _js2n__-prdslib.isType '"Bool",
                                  pythonInterpreter =
                                    _js2n__-prdslib.isType '"String",
                                  script = _js2n__-prdslib.isType '"String",
                                  scriptPath = _js2n__-prdslib.isType '"String",
                                  scriptSource =
                                    _js2n__-prdslib.enum
                                        [ "filePath", "inline" ],
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^PythonScript@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkLatestHelmVersion =
                                    _js2n__-prdslib.isType '"Bool",
                                  checkLatestKubectl =
                                    _js2n__-prdslib.isType '"Bool",
                                  helmVersion =
                                    _js2n__-prdslib.isType '"String",
                                  installKubectl =
                                    _js2n__-prdslib.isType '"Bool",
                                  kubectlVersion =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^HelmInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  helmVersionToInstall =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^HelmInstaller@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  nodeVersion =
                                    _js2n__-prdslib.enum [ "6", "10", "16" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^NodeTaskRunnerInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "email", "password" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      action =
                                        _js2n__-prdslib.enum
                                            [ "Activate", "Deactivate" ],
                                      email = _js2n__-prdslib.isType '"String",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      product =
                                        _js2n__-prdslib.enum
                                            [ "MA", "MT", "MM" ],
                                      timeout =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^XamarinLicense@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  forceReinstallCredentialProvider =
                                    _js2n__-prdslib.isType '"Bool",
                                  nuGetServiceConnections =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^NuGetAuthenticate@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  azureDevOpsServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                  feedUrl = _js2n__-prdslib.isType '"String",
                                  forceReinstallCredentialProvider =
                                    _js2n__-prdslib.isType '"Bool",
                                  nuGetServiceConnections =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^NuGetAuthenticate@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "packageName", "version" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      externalFeedCredentials =
                                        _js2n__-prdslib.isType '"String",
                                      packageName =
                                        _js2n__-prdslib.isType '"String",
                                      restoreDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      version =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadGitHubNugetPackage@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  artifactsFeeds =
                                    _js2n__-prdslib.isType '"String",
                                  mavenServiceConnections =
                                    _js2n__-prdslib.isType '"String",
                                  workloadIdentityServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^MavenAuthenticate@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "AppConfigurationEndpoint",
                                      "azureSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AppConfigurationEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      KeyFilter =
                                        _js2n__-prdslib.isType '"String",
                                      Label = _js2n__-prdslib.isType '"String",
                                      SelectionMode =
                                        _js2n__-prdslib.enum
                                            [ "Default", "Snapshot" ],
                                      SnapshotName =
                                        _js2n__-prdslib.isType '"String",
                                      SuppressWarningForOverriddenKeys =
                                        _js2n__-prdslib.isType '"Bool",
                                      TreatKeyVaultErrorsAsWarning =
                                        _js2n__-prdslib.isType '"Bool",
                                      TrimKeyPrefix =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureAppConfigurationExport@10$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "resourceName" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      baseEnvironmentName =
                                        _js2n__-prdslib.isType '"String",
                                      resourceName =
                                        _js2n__-prdslib.isType '"String",
                                      reviewResourceName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^ReviewApp@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "jdkArchitectureOption",
                                      "jdkSourceOption"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      azureCommonVirtualFile =
                                        _js2n__-prdslib.isType '"String",
                                      azureContainerName =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceManagerEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      azureStorageAccountName =
                                        _js2n__-prdslib.isType '"String",
                                      cleanDestinationDirectory =
                                        _js2n__-prdslib.isType '"Bool",
                                      createExtractDirectory =
                                        _js2n__-prdslib.isType '"Bool",
                                      jdkArchitectureOption =
                                        _js2n__-prdslib.enum [ "x64", "x86" ],
                                      jdkDestinationDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      jdkFile =
                                        _js2n__-prdslib.isType '"String",
                                      jdkSourceOption =
                                        _js2n__-prdslib.enum
                                            [
                                              "AzureStorage",
                                              "LocalDirectory",
                                              "PreInstalled"
                                            ],
                                      versionSpec =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^JavaToolInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "jdkArchitectureOption",
                                      "jdkSourceOption"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      azureCommonVirtualFile =
                                        _js2n__-prdslib.isType '"String",
                                      azureContainerName =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceManagerEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      azureStorageAccountName =
                                        _js2n__-prdslib.isType '"String",
                                      cleanDestinationDirectory =
                                        _js2n__-prdslib.isType '"Bool",
                                      createExtractDirectory =
                                        _js2n__-prdslib.isType '"Bool",
                                      jdkArchitectureOption =
                                        _js2n__-prdslib.enum [ "x64", "x86" ],
                                      jdkDestinationDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      jdkFile =
                                        _js2n__-prdslib.isType '"String",
                                      jdkSourceOption =
                                        _js2n__-prdslib.enum
                                            [
                                              "AzureStorage",
                                              "LocalDirectory",
                                              "PreInstalled"
                                            ],
                                      versionSpec =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^JavaToolInstaller@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "Attributes",
                                      "Environment",
                                      "connectedServiceName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      Attributes =
                                        _js2n__-prdslib.isType '"String",
                                      Environment =
                                        _js2n__-prdslib.isType '"String",
                                      chefWaitTime =
                                        _js2n__-prdslib.isType '"String",
                                      connectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task = _js2n__-prdslib.strings.pattern "^Chef@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "appName",
                                      "appType",
                                      "azureSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appName =
                                        _js2n__-prdslib.isType '"String",
                                      appSettings =
                                        _js2n__-prdslib.isType '"String",
                                      appType =
                                        _js2n__-prdslib.enum
                                            [
                                              "functionApp",
                                              "functionAppLinux"
                                            ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      configurationStrings =
                                        _js2n__-prdslib.isType '"String",
                                      customWebConfig =
                                        _js2n__-prdslib.isType '"String",
                                      deployToSlotOrASE =
                                        _js2n__-prdslib.isType '"Bool",
                                      deploymentMethod =
                                        _js2n__-prdslib.enum
                                            [
                                              "auto",
                                              "zipDeploy",
                                              "runFromPackage"
                                            ],
                                      package =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      runtimeStack =
                                        _js2n__-prdslib.enum
                                            [
                                              "DOTNET|6.0",
                                              "DOTNET-ISOLATED|6.0",
                                              "DOTNET-ISOLATED|7.0",
                                              "DOTNET-ISOLATED|8.0",
                                              "JAVA|8",
                                              "JAVA|11",
                                              "JAVA|17",
                                              "JAVA|21",
                                              "NODE|14",
                                              "NODE|16",
                                              "NODE|18",
                                              "NODE|20",
                                              "PYTHON|3.8",
                                              "PYTHON|3.9",
                                              "PYTHON|3.10",
                                              "PYTHON|3.11"
                                            ],
                                      slotName =
                                        _js2n__-prdslib.isType '"String",
                                      startUpCommand =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureFunctionApp@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "appName",
                                      "appType",
                                      "connectedServiceNameARM"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appName =
                                        _js2n__-prdslib.isType '"String",
                                      appSettings =
                                        _js2n__-prdslib.isType '"String",
                                      appType =
                                        _js2n__-prdslib.enum
                                            [
                                              "functionApp",
                                              "functionAppLinux"
                                            ],
                                      connectedServiceNameARM =
                                        _js2n__-prdslib.isType '"String",
                                      deployToSlotOrASE =
                                        _js2n__-prdslib.isType '"Bool",
                                      deploymentMethod =
                                        _js2n__-prdslib.enum
                                            [
                                              "auto",
                                              "zipDeploy",
                                              "runFromPackage"
                                            ],
                                      isFlexConsumption =
                                        _js2n__-prdslib.isType '"Bool",
                                      package =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      runtimeStack =
                                        _js2n__-prdslib.enum
                                            [
                                              "DOTNET|6.0",
                                              "DOTNET-ISOLATED|6.0",
                                              "DOTNET-ISOLATED|7.0",
                                              "DOTNET-ISOLATED|8.0",
                                              "JAVA|8",
                                              "JAVA|11",
                                              "JAVA|17",
                                              "JAVA|21",
                                              "NODE|14",
                                              "NODE|16",
                                              "NODE|18",
                                              "NODE|20",
                                              "PYTHON|3.8",
                                              "PYTHON|3.9",
                                              "PYTHON|3.10",
                                              "PYTHON|3.11"
                                            ],
                                      slotName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureFunctionApp@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "workingFile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      azureDevOpsServiceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      customEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      feedUrl =
                                        _js2n__-prdslib.isType '"String",
                                      workingFile =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^npmAuthenticate@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  clean = _js2n__-prdslib.isType '"Bool",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  createLogFile =
                                    _js2n__-prdslib.isType '"Bool",
                                  logFileVerbosity =
                                    _js2n__-prdslib.enum
                                        [
                                          "quiet",
                                          "minimal",
                                          "normal",
                                          "detailed",
                                          "diagnostic"
                                        ],
                                  logProjectEvents =
                                    _js2n__-prdslib.isType '"Bool",
                                  maximumCpuCount =
                                    _js2n__-prdslib.isType '"Bool",
                                  msbuildArchitecture =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  msbuildArguments =
                                    _js2n__-prdslib.isType '"String",
                                  msbuildLocation =
                                    _js2n__-prdslib.isType '"String",
                                  msbuildLocationMethod =
                                    _js2n__-prdslib.enum
                                        [ "version", "location" ],
                                  msbuildVersion =
                                    _js2n__-prdslib.enum
                                        [
                                          "latest",
                                          "17.0",
                                          "16.0",
                                          "15.0",
                                          "14.0",
                                          "12.0",
                                          "4.0"
                                        ],
                                  platform = _js2n__-prdslib.isType '"String",
                                  restoreNugetPackages =
                                    _js2n__-prdslib.isType '"Bool",
                                  solution = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^MSBuild@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "ConnectedServiceName",
                                      "azureResourceGroup",
                                      "deployScriptPath",
                                      "location",
                                      "packagePath",
                                      "storageAccountName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ConnectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      additionalBuilderParameters =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      baseImage =
                                        _js2n__-prdslib.enum
                                            [
                                              "MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:windows",
                                              "MicrosoftWindowsServer:WindowsServer:2016-Datacenter:windows",
                                              "MicrosoftWindowsServer:WindowsServer:2012-Datacenter:windows",
                                              "MicrosoftWindowsServer:WindowsServer:2008-R2-SP1:windows",
                                              "Canonical:UbuntuServer:14.04.4-LTS:linux",
                                              "Canonical:UbuntuServer:16.04-LTS:linux",
                                              "RedHat:RHEL:7.2:linux",
                                              "RedHat:RHEL:6.8:linux",
                                              "OpenLogic:CentOS:7.2:linux",
                                              "OpenLogic:CentOS:6.8:linux",
                                              "credativ:Debian:8:linux",
                                              "credativ:Debian:7:linux",
                                              "SUSE:openSUSE-Leap:42.2:linux",
                                              "SUSE:SLES:12-SP2:linux",
                                              "SUSE:SLES:11-SP4:linux"
                                            ],
                                      baseImageSource =
                                        _js2n__-prdslib.enum
                                            [ "default", "customVhd" ],
                                      customImageOSType =
                                        _js2n__-prdslib.enum
                                            [ "windows", "linux" ],
                                      customImageUrl =
                                        _js2n__-prdslib.isType '"String",
                                      customTemplateLocation =
                                        _js2n__-prdslib.isType '"String",
                                      customTemplateParameters =
                                        _js2n__-prdslib.isType '"String",
                                      deployScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      deployScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      imageUri =
                                        _js2n__-prdslib.isType '"String",
                                      location =
                                        _js2n__-prdslib.isType '"String",
                                      packagePath =
                                        _js2n__-prdslib.isType '"String",
                                      skipTempFileCleanupDuringVMDeprovision =
                                        _js2n__-prdslib.isType '"Bool",
                                      storageAccountName =
                                        _js2n__-prdslib.isType '"String",
                                      templateType =
                                        _js2n__-prdslib.enum
                                            [ "builtin", "custom" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^PackerBuild@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "ConnectedServiceName",
                                      "azureResourceGroup",
                                      "deployScriptPath",
                                      "location",
                                      "packagePath",
                                      "storageAccountName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ConnectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      additionalBuilderParameters =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      baseImage =
                                        _js2n__-prdslib.enum
                                            [
                                              "MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:windows",
                                              "MicrosoftWindowsServer:WindowsServer:2016-Datacenter:windows",
                                              "MicrosoftWindowsServer:WindowsServer:2012-Datacenter:windows",
                                              "MicrosoftWindowsServer:WindowsServer:2008-R2-SP1:windows",
                                              "Canonical:UbuntuServer:14.04.4-LTS:linux",
                                              "Canonical:UbuntuServer:16.04-LTS:linux",
                                              "Canonical:UbuntuServer:18.04-LTS:linux",
                                              "RedHat:RHEL:7.2:linux",
                                              "RedHat:RHEL:6.8:linux",
                                              "OpenLogic:CentOS:7.2:linux",
                                              "OpenLogic:CentOS:6.8:linux",
                                              "credativ:Debian:8:linux",
                                              "credativ:Debian:7:linux",
                                              "SUSE:openSUSE-Leap:42.2:linux",
                                              "SUSE:SLES:12-SP2:linux",
                                              "SUSE:SLES:11-SP4:linux"
                                            ],
                                      baseImageSource =
                                        _js2n__-prdslib.enum
                                            [ "default", "customVhd" ],
                                      customImageOSType =
                                        _js2n__-prdslib.enum
                                            [ "windows", "linux" ],
                                      customImageUrl =
                                        _js2n__-prdslib.isType '"String",
                                      customTemplateLocation =
                                        _js2n__-prdslib.isType '"String",
                                      customTemplateParameters =
                                        _js2n__-prdslib.isType '"String",
                                      deployScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      deployScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      imageId =
                                        _js2n__-prdslib.isType '"String",
                                      imageUri =
                                        _js2n__-prdslib.isType '"String",
                                      isManagedImage =
                                        _js2n__-prdslib.isType '"Bool",
                                      location =
                                        _js2n__-prdslib.isType '"String",
                                      managedImageName =
                                        _js2n__-prdslib.isType '"String",
                                      packagePath =
                                        _js2n__-prdslib.isType '"String",
                                      packerVersion =
                                        _js2n__-prdslib.isType '"String",
                                      skipTempFileCleanupDuringVMDeprovision =
                                        _js2n__-prdslib.isType '"Bool",
                                      storageAccountName =
                                        _js2n__-prdslib.isType '"String",
                                      templateType =
                                        _js2n__-prdslib.enum
                                            [ "builtin", "custom" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^PackerBuild@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  buildProperties =
                                    _js2n__-prdslib.isType '"String",
                                  configurationToPack =
                                    _js2n__-prdslib.isType '"String",
                                  includeReferencedProjects =
                                    _js2n__-prdslib.isType '"Bool",
                                  nuGetAdditionalArgs =
                                    _js2n__-prdslib.isType '"String",
                                  nuGetPath = _js2n__-prdslib.isType '"String",
                                  outputdir = _js2n__-prdslib.isType '"String",
                                  requestedMajorVersion =
                                    _js2n__-prdslib.isType '"String",
                                  requestedMinorVersion =
                                    _js2n__-prdslib.isType '"String",
                                  requestedPatchVersion =
                                    _js2n__-prdslib.isType '"String",
                                  searchPattern =
                                    _js2n__-prdslib.isType '"String",
                                  versionByBuild =
                                    _js2n__-prdslib.enum
                                        [
                                          "false",
                                          "byPrereleaseNumber",
                                          "byEnvVar",
                                          "true"
                                        ],
                                  versionEnvVar =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^NuGetPackager@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "AppConfigurationEndpoint",
                                      "Filters",
                                      "SnapshotName",
                                      "azureSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AppConfigurationEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      CompositionType =
                                        _js2n__-prdslib.enum
                                            [ "key", "key_label" ],
                                      Filters =
                                        _js2n__-prdslib.isType '"String",
                                      RetentionPeriod =
                                        _js2n__-prdslib.isType 'Integer,
                                      SnapshotName =
                                        _js2n__-prdslib.isType '"String",
                                      Tags = _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureAppConfigurationSnapshot@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkLatestVersion =
                                    _js2n__-prdslib.isType '"Bool",
                                  version = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DuffleInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "applicationPackagePath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      applicationPackagePath =
                                        _js2n__-prdslib.isType '"String",
                                      buildNumber =
                                        _js2n__-prdslib.isType '"String",
                                      compareType =
                                        _js2n__-prdslib.enum
                                            [ "LastSuccessful", "Specific" ],
                                      logAllChanges =
                                        _js2n__-prdslib.isType '"Bool",
                                      pkgArtifactName =
                                        _js2n__-prdslib.isType '"String",
                                      updateOnlyChanged =
                                        _js2n__-prdslib.isType '"Bool",
                                      versionBehavior =
                                        _js2n__-prdslib.enum
                                            [ "Append", "Replace" ],
                                      versionSuffix =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ServiceFabricUpdateAppVersions@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "applicationPackagePath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      applicationPackagePath =
                                        _js2n__-prdslib.isType '"String",
                                      buildNumber =
                                        _js2n__-prdslib.isType '"String",
                                      compareType =
                                        _js2n__-prdslib.enum
                                            [ "LastSuccessful", "Specific" ],
                                      imageDigestsPath =
                                        _js2n__-prdslib.isType '"String",
                                      imageNamesPath =
                                        _js2n__-prdslib.isType '"String",
                                      logAllChanges =
                                        _js2n__-prdslib.isType '"Bool",
                                      overwriteExistingPkgArtifact =
                                        _js2n__-prdslib.isType '"Bool",
                                      pkgArtifactName =
                                        _js2n__-prdslib.isType '"String",
                                      updateOnlyChanged =
                                        _js2n__-prdslib.isType '"Bool",
                                      updateType =
                                        _js2n__-prdslib.enum
                                            [
                                              "Manifest versions",
                                              "Docker image settings"
                                            ],
                                      versionBehavior =
                                        _js2n__-prdslib.enum
                                            [ "Append", "Replace" ],
                                      versionSuffix =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ServiceFabricUpdateManifests@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "ResourceGroupName",
                                      "connectedServiceNameARM"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      alertRule =
                                        _js2n__-prdslib.isType '"String",
                                      alertState =
                                        _js2n__-prdslib.enum
                                            [ "New", "Acknowledged", "Closed" ],
                                      connectedServiceNameARM =
                                        _js2n__-prdslib.isType '"String",
                                      filterType =
                                        _js2n__-prdslib.enum
                                            [ "resource", "alertrule", "none" ],
                                      monitorCondition =
                                        _js2n__-prdslib.enum
                                            [ "Fired ", "Resolved" ],
                                      resource =
                                        _js2n__-prdslib.isType '"String",
                                      severity =
                                        _js2n__-prdslib.enum
                                            [
                                              "Sev0",
                                              "Sev1",
                                              "Sev2",
                                              "Sev3",
                                              "Sev4"
                                            ],
                                      timeRange =
                                        _js2n__-prdslib.enum
                                            [ "1h", "1d", "7d", "30d" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureMonitor@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "ResourceGroupName",
                                      "alertRules",
                                      "connectedServiceNameARM",
                                      "resourceName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceType =
                                        _js2n__-prdslib.enum
                                            [
                                              "Microsoft.Insights/components",
                                              "Microsoft.Web/sites",
                                              "Microsoft.Storage/storageAccounts",
                                              "Microsoft.Compute/virtualMachines"
                                            ],
                                      alertRules =
                                        _js2n__-prdslib.isType '"String",
                                      connectedServiceNameARM =
                                        _js2n__-prdslib.isType '"String",
                                      resourceName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureMonitor@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  akvPluginVersion =
                                    _js2n__-prdslib.isType '"String",
                                  allowReferrersAPI =
                                    _js2n__-prdslib.isType '"Bool",
                                  artifactRefs =
                                    _js2n__-prdslib.isType '"String",
                                  azurekvServiceConection =
                                    _js2n__-prdslib.isType '"String",
                                  caCertBundle =
                                    _js2n__-prdslib.isType '"String",
                                  checksum = _js2n__-prdslib.isType '"String",
                                  command =
                                    _js2n__-prdslib.enum
                                        [ "install", "sign", "verify" ],
                                  isCustomVersion =
                                    _js2n__-prdslib.isType '"Bool",
                                  keyid = _js2n__-prdslib.isType '"String",
                                  plugin =
                                    _js2n__-prdslib.enum [ "azureKeyVault" ],
                                  selfSigned = _js2n__-prdslib.isType '"Bool",
                                  signatureFormat =
                                    _js2n__-prdslib.enum [ "cose", "jws" ],
                                  timestampRootCert =
                                    _js2n__-prdslib.isType '"String",
                                  timestampURL =
                                    _js2n__-prdslib.isType '"String",
                                  trustPolicy =
                                    _js2n__-prdslib.isType '"String",
                                  trustStore = _js2n__-prdslib.isType '"String",
                                  url = _js2n__-prdslib.isType '"String",
                                  version = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Notation@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "Action",
                                      "LoadBalancer",
                                      "ResourceGroupName",
                                      "azureSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      Action =
                                        _js2n__-prdslib.enum
                                            [ "Disconnect", "Connect" ],
                                      LoadBalancer =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureNLBManagement@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "TestDrop" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      LoadTest =
                                        _js2n__-prdslib.isType '"String",
                                      TestDrop =
                                        _js2n__-prdslib.isType '"String",
                                      agentCount =
                                        _js2n__-prdslib.enum
                                            [ "1", "2", "3", "4", "5" ],
                                      connectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      geoLocation =
                                        _js2n__-prdslib.enum
                                            [
                                              "Default",
                                              "Australia East",
                                              "Australia Southeast",
                                              "Brazil South",
                                              "Central India",
                                              "Central US",
                                              "East Asia",
                                              "East US 2",
                                              "East US",
                                              "Japan East",
                                              "Japan West",
                                              "North Central US",
                                              "North Europe",
                                              "South Central US",
                                              "South India",
                                              "Southeast Asia",
                                              "West Europe",
                                              "West US"
                                            ],
                                      machineType =
                                        _js2n__-prdslib.enum [ "0", "2" ],
                                      runDuration =
                                        _js2n__-prdslib.enum
                                            [
                                              "60",
                                              "120",
                                              "180",
                                              "240",
                                              "300"
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ApacheJMeterLoadTest@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  abortOnContainerExit =
                                    _js2n__-prdslib.isType '"Bool",
                                  action =
                                    _js2n__-prdslib.enum
                                        [
                                          "Build services",
                                          "Push services",
                                          "Run services",
                                          "Run a specific service",
                                          "Lock services",
                                          "Write service image digests",
                                          "Combine configuration",
                                          "Run a Docker Compose command"
                                        ],
                                  additionalDockerComposeFiles =
                                    _js2n__-prdslib.isType '"String",
                                  additionalImageTags =
                                    _js2n__-prdslib.isType '"String",
                                  arguments = _js2n__-prdslib.isType '"String",
                                  azureContainerRegistry =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  baseResolveDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  buildImages = _js2n__-prdslib.isType '"Bool",
                                  containerCommand =
                                    _js2n__-prdslib.isType '"String",
                                  containerName =
                                    _js2n__-prdslib.isType '"String",
                                  containerregistrytype =
                                    _js2n__-prdslib.enum
                                        [
                                          "Azure Container Registry",
                                          "Container Registry"
                                        ],
                                  currentWorkingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  detached = _js2n__-prdslib.isType '"Bool",
                                  dockerComposeCommand =
                                    _js2n__-prdslib.isType '"String",
                                  dockerComposeFile =
                                    _js2n__-prdslib.isType '"String",
                                  dockerComposeFileArgs =
                                    _js2n__-prdslib.isType '"String",
                                  dockerComposePath =
                                    _js2n__-prdslib.isType '"String",
                                  dockerHostEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  dockerRegistryEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  entrypoint = _js2n__-prdslib.isType '"String",
                                  imageDigestComposeFile =
                                    _js2n__-prdslib.isType '"String",
                                  includeLatestTag =
                                    _js2n__-prdslib.isType '"Bool",
                                  includeSourceTags =
                                    _js2n__-prdslib.isType '"Bool",
                                  nopIfNoDockerComposeFile =
                                    _js2n__-prdslib.isType '"Bool",
                                  outputDockerComposeFile =
                                    _js2n__-prdslib.isType '"String",
                                  ports = _js2n__-prdslib.isType '"String",
                                  projectName =
                                    _js2n__-prdslib.isType '"String",
                                  qualifyImageNames =
                                    _js2n__-prdslib.isType '"Bool",
                                  removeBuildOptions =
                                    _js2n__-prdslib.isType '"Bool",
                                  requireAdditionalDockerComposeFiles =
                                    _js2n__-prdslib.isType '"Bool",
                                  serviceName =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^DockerCompose@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  abortOnContainerExit =
                                    _js2n__-prdslib.isType '"Bool",
                                  action =
                                    _js2n__-prdslib.enum
                                        [
                                          "Build services",
                                          "Push services",
                                          "Run services",
                                          "Run a specific service",
                                          "Lock services",
                                          "Write service image digests",
                                          "Combine configuration",
                                          "Run a Docker Compose command"
                                        ],
                                  additionalDockerComposeFiles =
                                    _js2n__-prdslib.isType '"String",
                                  additionalImageTags =
                                    _js2n__-prdslib.isType '"String",
                                  arguments = _js2n__-prdslib.isType '"String",
                                  azureContainerRegistry =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  baseResolveDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  buildImages = _js2n__-prdslib.isType '"Bool",
                                  containerCommand =
                                    _js2n__-prdslib.isType '"String",
                                  containerName =
                                    _js2n__-prdslib.isType '"String",
                                  containerregistrytype =
                                    _js2n__-prdslib.enum
                                        [
                                          "Azure Container Registry",
                                          "Container Registry"
                                        ],
                                  currentWorkingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  detached = _js2n__-prdslib.isType '"Bool",
                                  dockerComposeCommand =
                                    _js2n__-prdslib.isType '"String",
                                  dockerComposeFile =
                                    _js2n__-prdslib.isType '"String",
                                  dockerComposeFileArgs =
                                    _js2n__-prdslib.isType '"String",
                                  dockerComposePath =
                                    _js2n__-prdslib.isType '"String",
                                  dockerHostEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  dockerRegistryEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  entrypoint = _js2n__-prdslib.isType '"String",
                                  imageDigestComposeFile =
                                    _js2n__-prdslib.isType '"String",
                                  includeLatestTag =
                                    _js2n__-prdslib.isType '"Bool",
                                  includeSourceTags =
                                    _js2n__-prdslib.isType '"Bool",
                                  nopIfNoDockerComposeFile =
                                    _js2n__-prdslib.isType '"Bool",
                                  outputDockerComposeFile =
                                    _js2n__-prdslib.isType '"String",
                                  ports = _js2n__-prdslib.isType '"String",
                                  projectName =
                                    _js2n__-prdslib.isType '"String",
                                  qualifyImageNames =
                                    _js2n__-prdslib.isType '"Bool",
                                  removeBuildOptions =
                                    _js2n__-prdslib.isType '"Bool",
                                  requireAdditionalDockerComposeFiles =
                                    _js2n__-prdslib.isType '"Bool",
                                  serviceName =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^DockerCompose@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "AlertRules",
                                      "ResourceGroupName",
                                      "ResourceName",
                                      "azureSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AlertRules =
                                        _js2n__-prdslib.isType '"String",
                                      NotifyEmails =
                                        _js2n__-prdslib.isType '"String",
                                      NotifyServiceOwners =
                                        _js2n__-prdslib.isType '"Bool",
                                      ResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceName =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceType =
                                        _js2n__-prdslib.enum
                                            [
                                              "Microsoft.Insights/components",
                                              "Microsoft.Web/sites",
                                              "Microsoft.Storage/storageAccounts",
                                              "Microsoft.Compute/virtualMachines"
                                            ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureMonitorAlerts@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "appFile",
                                      "devices",
                                      "email",
                                      "teamApiKey",
                                      "testAssemblyDirectory"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appFile =
                                        _js2n__-prdslib.isType '"String",
                                      devices =
                                        _js2n__-prdslib.isType '"String",
                                      dsymFile =
                                        _js2n__-prdslib.isType '"String",
                                      email = _js2n__-prdslib.isType '"String",
                                      localeOption =
                                        _js2n__-prdslib.enum
                                            [
                                              "da_DK",
                                              "nl_NL",
                                              "en_GB",
                                              "en_US",
                                              "fr_FR",
                                              "de_DE",
                                              "ja_JP",
                                              "ru_RU",
                                              "es_MX",
                                              "es_ES",
                                              "user"
                                            ],
                                      optionalArgs =
                                        _js2n__-prdslib.isType '"String",
                                      parallelizationOption =
                                        _js2n__-prdslib.enum
                                            [
                                              "none",
                                              "--fixture-chunk",
                                              "--test-chunk"
                                            ],
                                      publishNUnitResults =
                                        _js2n__-prdslib.isType '"Bool",
                                      series = _js2n__-prdslib.isType '"String",
                                      teamApiKey =
                                        _js2n__-prdslib.isType '"String",
                                      testAssemblyDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      testCloudFile =
                                        _js2n__-prdslib.isType '"String",
                                      userDefinedLocale =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^XamarinTestCloud@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "applicationPackagePath",
                                      "serviceConnectionName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ConsiderWarningAsError =
                                        _js2n__-prdslib.isType '"Bool",
                                      DefaultServiceTypeHealthPolicy =
                                        _js2n__-prdslib.isType '"String",
                                      FailureAction =
                                        _js2n__-prdslib.enum
                                            [ "Rollback", "Manual" ],
                                      ForceRestart =
                                        _js2n__-prdslib.isType '"Bool",
                                      HealthCheckRetryTimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      HealthCheckStableDurationSec =
                                        _js2n__-prdslib.isType '"String",
                                      HealthCheckWaitDurationSec =
                                        _js2n__-prdslib.isType '"String",
                                      MaxPercentUnhealthyDeployedApplications =
                                        _js2n__-prdslib.isType '"String",
                                      ServiceTypeHealthPolicyMap =
                                        _js2n__-prdslib.isType '"String",
                                      TimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      UpgradeDomainTimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      UpgradeReplicaSetCheckTimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      UpgradeTimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      applicationPackagePath =
                                        _js2n__-prdslib.isType '"String",
                                      applicationParameterPath =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      compressPackage =
                                        _js2n__-prdslib.isType '"Bool",
                                      configureDockerSettings =
                                        _js2n__-prdslib.isType '"Bool",
                                      copyPackageTimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      dockerRegistryConnection =
                                        _js2n__-prdslib.isType '"String",
                                      isUpgrade =
                                        _js2n__-prdslib.isType '"Bool",
                                      overrideApplicationParameter =
                                        _js2n__-prdslib.isType '"Bool",
                                      overridePublishProfileSettings =
                                        _js2n__-prdslib.isType '"Bool",
                                      overwriteBehavior =
                                        _js2n__-prdslib.enum
                                            [
                                              "Always",
                                              "Never",
                                              "SameAppTypeAndVersion"
                                            ],
                                      passwordEncrypted =
                                        _js2n__-prdslib.isType '"Bool",
                                      publishProfilePath =
                                        _js2n__-prdslib.isType '"String",
                                      registerPackageTimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      registryCredentials =
                                        _js2n__-prdslib.enum
                                            [
                                              "AzureResourceManagerEndpoint",
                                              "ContainerRegistryEndpoint",
                                              "UsernamePassword"
                                            ],
                                      registryPassword =
                                        _js2n__-prdslib.isType '"String",
                                      registryUserName =
                                        _js2n__-prdslib.isType '"String",
                                      serviceConnectionName =
                                        _js2n__-prdslib.isType '"String",
                                      skipPackageValidation =
                                        _js2n__-prdslib.isType '"Bool",
                                      skipUpgradeSameTypeAndVersion =
                                        _js2n__-prdslib.isType '"Bool",
                                      unregisterUnusedVersions =
                                        _js2n__-prdslib.isType '"Bool",
                                      upgradeMode =
                                        _js2n__-prdslib.enum
                                            [
                                              "Monitored",
                                              "UnmonitoredAuto",
                                              "UnmonitoredManual"
                                            ],
                                      useDiffPackage =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ServiceFabricDeploy@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  actions = _js2n__-prdslib.isType '"String",
                                  archivePath =
                                    _js2n__-prdslib.isType '"String",
                                  args = _js2n__-prdslib.isType '"String",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  destinationDevices =
                                    _js2n__-prdslib.isType '"String",
                                  destinationPlatform =
                                    _js2n__-prdslib.isType '"String",
                                  destinationPlatformOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "iOS",
                                          "tvOS",
                                          "macOS",
                                          "custom"
                                        ],
                                  destinationSimulators =
                                    _js2n__-prdslib.isType '"String",
                                  destinationTypeOption =
                                    _js2n__-prdslib.enum
                                        [ "simulators", "devices" ],
                                  exportArgs = _js2n__-prdslib.isType '"String",
                                  exportMethod =
                                    _js2n__-prdslib.isType '"String",
                                  exportOptions =
                                    _js2n__-prdslib.enum
                                        [ "auto", "plist", "specify" ],
                                  exportOptionsPlist =
                                    _js2n__-prdslib.isType '"String",
                                  exportPath = _js2n__-prdslib.isType '"String",
                                  exportTeamId =
                                    _js2n__-prdslib.isType '"String",
                                  packageApp = _js2n__-prdslib.isType '"Bool",
                                  provisioningProfileName =
                                    _js2n__-prdslib.isType '"String",
                                  provisioningProfileUuid =
                                    _js2n__-prdslib.isType '"String",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  scheme = _js2n__-prdslib.isType '"String",
                                  sdk = _js2n__-prdslib.isType '"String",
                                  signingIdentity =
                                    _js2n__-prdslib.isType '"String",
                                  signingOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "nosign",
                                          "default",
                                          "manual",
                                          "auto"
                                        ],
                                  teamId = _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  useXcpretty = _js2n__-prdslib.isType '"Bool",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  xcWorkspacePath =
                                    _js2n__-prdslib.isType '"String",
                                  xcodeDeveloperDir =
                                    _js2n__-prdslib.isType '"String",
                                  xcodeVersion =
                                    _js2n__-prdslib.enum
                                        [
                                          "8",
                                          "9",
                                          "10",
                                          "11",
                                          "12",
                                          "13",
                                          "default",
                                          "specifyPath"
                                        ],
                                  xcprettyArgs =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Xcode@5$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  actions = _js2n__-prdslib.isType '"String",
                                  archivePath =
                                    _js2n__-prdslib.isType '"String",
                                  args = _js2n__-prdslib.isType '"String",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  cwd = _js2n__-prdslib.isType '"String",
                                  defaultKeychainPassword =
                                    _js2n__-prdslib.isType '"String",
                                  exportArgs = _js2n__-prdslib.isType '"String",
                                  exportMethod =
                                    _js2n__-prdslib.isType '"String",
                                  exportOptions =
                                    _js2n__-prdslib.enum
                                        [ "auto", "plist", "specify" ],
                                  exportOptionsPlist =
                                    _js2n__-prdslib.isType '"String",
                                  exportPath = _js2n__-prdslib.isType '"String",
                                  exportTeamId =
                                    _js2n__-prdslib.isType '"String",
                                  iosSigningIdentity =
                                    _js2n__-prdslib.isType '"String",
                                  outputPattern =
                                    _js2n__-prdslib.isType '"String",
                                  p12 = _js2n__-prdslib.isType '"String",
                                  p12pwd = _js2n__-prdslib.isType '"String",
                                  packageApp = _js2n__-prdslib.isType '"Bool",
                                  provProfile =
                                    _js2n__-prdslib.isType '"String",
                                  provProfileUuid =
                                    _js2n__-prdslib.isType '"String",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  removeProfile =
                                    _js2n__-prdslib.isType '"Bool",
                                  scheme = _js2n__-prdslib.isType '"String",
                                  sdk = _js2n__-prdslib.isType '"String",
                                  signMethod =
                                    _js2n__-prdslib.enum [ "file", "id" ],
                                  teamId = _js2n__-prdslib.isType '"String",
                                  unlockDefaultKeychain =
                                    _js2n__-prdslib.isType '"Bool",
                                  useXcpretty = _js2n__-prdslib.isType '"Bool",
                                  xcWorkspacePath =
                                    _js2n__-prdslib.isType '"String",
                                  xcode8AutomaticSigning =
                                    _js2n__-prdslib.isType '"Bool",
                                  xcodeDeveloperDir =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Xcode@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  actions = _js2n__-prdslib.isType '"String",
                                  archivePath =
                                    _js2n__-prdslib.isType '"String",
                                  args = _js2n__-prdslib.isType '"String",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  destinationDevices =
                                    _js2n__-prdslib.isType '"String",
                                  destinationPlatform =
                                    _js2n__-prdslib.isType '"String",
                                  destinationPlatformOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "iOS",
                                          "tvOS",
                                          "macOS",
                                          "custom"
                                        ],
                                  destinationSimulators =
                                    _js2n__-prdslib.isType '"String",
                                  destinationTypeOption =
                                    _js2n__-prdslib.enum
                                        [ "simulators", "devices" ],
                                  exportArgs = _js2n__-prdslib.isType '"String",
                                  exportMethod =
                                    _js2n__-prdslib.isType '"String",
                                  exportOptions =
                                    _js2n__-prdslib.enum
                                        [ "auto", "plist", "specify" ],
                                  exportOptionsPlist =
                                    _js2n__-prdslib.isType '"String",
                                  exportPath = _js2n__-prdslib.isType '"String",
                                  exportTeamId =
                                    _js2n__-prdslib.isType '"String",
                                  outputPattern =
                                    _js2n__-prdslib.isType '"String",
                                  packageApp = _js2n__-prdslib.isType '"Bool",
                                  provisioningProfileUuid =
                                    _js2n__-prdslib.isType '"String",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  scheme = _js2n__-prdslib.isType '"String",
                                  sdk = _js2n__-prdslib.isType '"String",
                                  signingIdentity =
                                    _js2n__-prdslib.isType '"String",
                                  signingOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "nosign",
                                          "default",
                                          "manual",
                                          "auto"
                                        ],
                                  teamId = _js2n__-prdslib.isType '"String",
                                  useXcpretty = _js2n__-prdslib.isType '"Bool",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  xcWorkspacePath =
                                    _js2n__-prdslib.isType '"String",
                                  xcodeDeveloperDir =
                                    _js2n__-prdslib.isType '"String",
                                  xcodeVersion =
                                    _js2n__-prdslib.enum
                                        [ "8", "9", "default", "specifyPath" ],
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Xcode@4$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  actions = _js2n__-prdslib.isType '"String",
                                  archivePath =
                                    _js2n__-prdslib.isType '"String",
                                  args = _js2n__-prdslib.isType '"String",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  cwd = _js2n__-prdslib.isType '"String",
                                  defaultKeychainPassword =
                                    _js2n__-prdslib.isType '"String",
                                  exportMethod =
                                    _js2n__-prdslib.isType '"String",
                                  exportOptions =
                                    _js2n__-prdslib.enum
                                        [ "auto", "plist", "specify" ],
                                  exportOptionsPlist =
                                    _js2n__-prdslib.isType '"String",
                                  exportPath = _js2n__-prdslib.isType '"String",
                                  exportTeamId =
                                    _js2n__-prdslib.isType '"String",
                                  iosSigningIdentity =
                                    _js2n__-prdslib.isType '"String",
                                  outputPattern =
                                    _js2n__-prdslib.isType '"String",
                                  p12 = _js2n__-prdslib.isType '"String",
                                  p12pwd = _js2n__-prdslib.isType '"String",
                                  packageApp = _js2n__-prdslib.isType '"Bool",
                                  packageTool =
                                    _js2n__-prdslib.enum
                                        [ "xcrun", "xcodebuild" ],
                                  provProfile =
                                    _js2n__-prdslib.isType '"String",
                                  provProfileUuid =
                                    _js2n__-prdslib.isType '"String",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  removeProfile =
                                    _js2n__-prdslib.isType '"Bool",
                                  scheme = _js2n__-prdslib.isType '"String",
                                  sdk = _js2n__-prdslib.isType '"String",
                                  signMethod =
                                    _js2n__-prdslib.enum [ "file", "id" ],
                                  teamId = _js2n__-prdslib.isType '"String",
                                  unlockDefaultKeychain =
                                    _js2n__-prdslib.isType '"Bool",
                                  useXcpretty = _js2n__-prdslib.isType '"Bool",
                                  useXctool = _js2n__-prdslib.isType '"Bool",
                                  xcWorkspacePath =
                                    _js2n__-prdslib.isType '"String",
                                  xcode8AutomaticSigning =
                                    _js2n__-prdslib.isType '"Bool",
                                  xcodeDeveloperDir =
                                    _js2n__-prdslib.isType '"String",
                                  xctoolReporter =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Xcode@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  connectedServiceName =
                                    _js2n__-prdslib.isType '"String",
                                  continueOnEmptyNupkgMatch =
                                    _js2n__-prdslib.isType '"Bool",
                                  feedName = _js2n__-prdslib.isType '"String",
                                  nuGetAdditionalArgs =
                                    _js2n__-prdslib.isType '"String",
                                  nuGetFeedType =
                                    _js2n__-prdslib.enum
                                        [ "external", "internal" ],
                                  nuGetPath = _js2n__-prdslib.isType '"String",
                                  nuGetVersion =
                                    _js2n__-prdslib.enum
                                        [
                                          "3.3.0",
                                          "3.5.0.1829",
                                          "4.0.0.2283",
                                          "custom"
                                        ],
                                  searchPattern =
                                    _js2n__-prdslib.isType '"String",
                                  verbosity =
                                    _js2n__-prdslib.enum
                                        [ "-", "Quiet", "Normal", "Detailed" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^NuGetPublisher@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "queryId" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      maxThreshold =
                                        _js2n__-prdslib.isType '"String",
                                      minThreshold =
                                        _js2n__-prdslib.isType '"String",
                                      queryId =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^queryWorkItems@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "appName", "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appName =
                                        _js2n__-prdslib.isType '"String",
                                      appSettings =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      configurationStrings =
                                        _js2n__-prdslib.isType '"String",
                                      containerCommand =
                                        _js2n__-prdslib.isType '"String",
                                      containers =
                                        _js2n__-prdslib.isType '"String",
                                      deployToSlotOrASE =
                                        _js2n__-prdslib.isType '"Bool",
                                      multicontainerConfigFile =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      slotName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureWebAppContainer@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  AdditionalArguments =
                                    _js2n__-prdslib.isType '"String",
                                  AdditionalArgumentsSql =
                                    _js2n__-prdslib.isType '"String",
                                  AppLockName =
                                    _js2n__-prdslib.isType '"String",
                                  AuthScheme =
                                    _js2n__-prdslib.enum
                                        [
                                          "windowsAuthentication",
                                          "sqlServerAuthentication"
                                        ],
                                  ConnectionString =
                                    _js2n__-prdslib.isType '"String",
                                  DacpacFile = _js2n__-prdslib.isType '"String",
                                  DatabaseName =
                                    _js2n__-prdslib.isType '"String",
                                  ExclusiveLock =
                                    _js2n__-prdslib.isType '"Bool",
                                  ExecuteInTransaction =
                                    _js2n__-prdslib.isType '"Bool",
                                  InlineSql = _js2n__-prdslib.isType '"String",
                                  PublishProfile =
                                    _js2n__-prdslib.isType '"String",
                                  ServerName = _js2n__-prdslib.isType '"String",
                                  SqlFile = _js2n__-prdslib.isType '"String",
                                  SqlPassword =
                                    _js2n__-prdslib.isType '"String",
                                  SqlUsername =
                                    _js2n__-prdslib.isType '"String",
                                  TargetMethod =
                                    _js2n__-prdslib.enum
                                        [
                                          "server",
                                          "connectionString",
                                          "publishProfile"
                                        ],
                                  TaskType =
                                    _js2n__-prdslib.enum
                                        [ "dacpac", "sqlQuery", "sqlInline" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^SqlDacpacDeploymentOnMachineGroup@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "key", "path" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      cacheHitVar =
                                        _js2n__-prdslib.isType '"String",
                                      key = _js2n__-prdslib.isType '"String",
                                      path = _js2n__-prdslib.isType '"String",
                                      restoreKeys =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^CacheBeta@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "key", "path" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      cacheHitVar =
                                        _js2n__-prdslib.isType '"String",
                                      key = _js2n__-prdslib.isType '"String",
                                      path = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^CacheBeta@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "key", "path" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      cacheHitVar =
                                        _js2n__-prdslib.isType '"String",
                                      key = _js2n__-prdslib.isType '"String",
                                      path = _js2n__-prdslib.isType '"String",
                                      restoreKeys =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task = _js2n__-prdslib.strings.pattern "^Cache@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  cmakeArgs = _js2n__-prdslib.isType '"String",
                                  runInsideShell =
                                    _js2n__-prdslib.isType '"Bool",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^CMake@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "app" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      app = _js2n__-prdslib.isType '"String",
                                      appSlug =
                                        _js2n__-prdslib.isType '"String",
                                      appiumBuildDir =
                                        _js2n__-prdslib.isType '"String",
                                      artifactsDir =
                                        _js2n__-prdslib.isType '"String",
                                      async = _js2n__-prdslib.isType '"Bool",
                                      calabashConfigFile =
                                        _js2n__-prdslib.isType '"String",
                                      calabashProfile =
                                        _js2n__-prdslib.isType '"String",
                                      calabashProjectDir =
                                        _js2n__-prdslib.isType '"String",
                                      calabashSkipConfigCheck =
                                        _js2n__-prdslib.isType '"Bool",
                                      cliLocationOverride =
                                        _js2n__-prdslib.isType '"String",
                                      credsType =
                                        _js2n__-prdslib.enum
                                            [ "serviceEndpoint", "inputs" ],
                                      debug = _js2n__-prdslib.isType '"Bool",
                                      devices =
                                        _js2n__-prdslib.isType '"String",
                                      dsymDir =
                                        _js2n__-prdslib.isType '"String",
                                      enablePrepare =
                                        _js2n__-prdslib.isType '"Bool",
                                      enableRun =
                                        _js2n__-prdslib.isType '"Bool",
                                      espressoBuildDir =
                                        _js2n__-prdslib.isType '"String",
                                      espressoTestApkPath =
                                        _js2n__-prdslib.isType '"String",
                                      framework =
                                        _js2n__-prdslib.enum
                                            [
                                              "appium",
                                              "espresso",
                                              "calabash",
                                              "uitest",
                                              "xcuitest"
                                            ],
                                      locale =
                                        _js2n__-prdslib.enum
                                            [
                                              "da_DK",
                                              "nl_NL",
                                              "en_GB",
                                              "en_US",
                                              "fr_FR",
                                              "de_DE",
                                              "ja_JP",
                                              "ru_RU",
                                              "es_MX",
                                              "es_ES",
                                              "user"
                                            ],
                                      loginOpts =
                                        _js2n__-prdslib.isType '"String",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      prepareOpts =
                                        _js2n__-prdslib.isType '"String",
                                      runOpts =
                                        _js2n__-prdslib.isType '"String",
                                      series = _js2n__-prdslib.isType '"String",
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      signInfo =
                                        _js2n__-prdslib.isType '"String",
                                      uitestBuildDir =
                                        _js2n__-prdslib.isType '"String",
                                      uitestKeyAlias =
                                        _js2n__-prdslib.isType '"String",
                                      uitestKeyPass =
                                        _js2n__-prdslib.isType '"String",
                                      uitestStoreFile =
                                        _js2n__-prdslib.isType '"String",
                                      uitestStorePass =
                                        _js2n__-prdslib.isType '"String",
                                      uitestToolsDir =
                                        _js2n__-prdslib.isType '"String",
                                      userDefinedLocale =
                                        _js2n__-prdslib.isType '"String",
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                      xcuitestBuildDir =
                                        _js2n__-prdslib.isType '"String",
                                      xcuitestTestIpaPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^VSMobileCenterTest@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "appFile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appFile =
                                        _js2n__-prdslib.isType '"String",
                                      appSlug =
                                        _js2n__-prdslib.isType '"String",
                                      appiumBuildDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      artifactsDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      calabashConfigFile =
                                        _js2n__-prdslib.isType '"String",
                                      calabashProfile =
                                        _js2n__-prdslib.isType '"String",
                                      calabashProjectDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      calabashSkipConfigCheck =
                                        _js2n__-prdslib.isType '"Bool",
                                      cliFile =
                                        _js2n__-prdslib.isType '"String",
                                      credentialsOption =
                                        _js2n__-prdslib.enum
                                            [ "serviceEndpoint", "inputs" ],
                                      devices =
                                        _js2n__-prdslib.isType '"String",
                                      dsymDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      espressoBuildDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      espressoTestApkFile =
                                        _js2n__-prdslib.isType '"String",
                                      frameworkOption =
                                        _js2n__-prdslib.enum
                                            [
                                              "appium",
                                              "espresso",
                                              "calabash",
                                              "uitest",
                                              "xcuitest"
                                            ],
                                      localeOption =
                                        _js2n__-prdslib.enum
                                            [
                                              "da_DK",
                                              "nl_NL",
                                              "en_GB",
                                              "en_US",
                                              "fr_FR",
                                              "de_DE",
                                              "ja_JP",
                                              "ru_RU",
                                              "es_MX",
                                              "es_ES",
                                              "user"
                                            ],
                                      loginOptions =
                                        _js2n__-prdslib.isType '"String",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      prepareOptions =
                                        _js2n__-prdslib.isType '"String",
                                      prepareTests =
                                        _js2n__-prdslib.isType '"Bool",
                                      runOptions =
                                        _js2n__-prdslib.isType '"String",
                                      runTests = _js2n__-prdslib.isType '"Bool",
                                      series = _js2n__-prdslib.isType '"String",
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      showDebugOutput =
                                        _js2n__-prdslib.isType '"Bool",
                                      signInfo =
                                        _js2n__-prdslib.isType '"String",
                                      skipWaitingForResults =
                                        _js2n__-prdslib.isType '"Bool",
                                      uiTestBuildDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      uiTestKeyPassword =
                                        _js2n__-prdslib.isType '"String",
                                      uiTestStorePassword =
                                        _js2n__-prdslib.isType '"String",
                                      uiTestToolsDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      uitestKeyAlias =
                                        _js2n__-prdslib.isType '"String",
                                      uitestStorePath =
                                        _js2n__-prdslib.isType '"String",
                                      userDefinedLocale =
                                        _js2n__-prdslib.isType '"String",
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                      xcUITestBuildDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      xcUITestIpaFile =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AppCenterTest@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "secureFile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      retryCount =
                                        _js2n__-prdslib.isType '"String",
                                      secureFile =
                                        _js2n__-prdslib.isType '"String",
                                      socketTimeout =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadSecureFile@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      acrName =
                                        _js2n__-prdslib.isType '"String",
                                      acrPassword =
                                        _js2n__-prdslib.isType '"String",
                                      acrUsername =
                                        _js2n__-prdslib.isType '"String",
                                      appSourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      containerAppEnvironment =
                                        _js2n__-prdslib.isType '"String",
                                      containerAppName =
                                        _js2n__-prdslib.isType '"String",
                                      disableTelemetry =
                                        _js2n__-prdslib.isType '"Bool",
                                      dockerfilePath =
                                        _js2n__-prdslib.isType '"String",
                                      environmentVariables =
                                        _js2n__-prdslib.isType '"String",
                                      imageToBuild =
                                        _js2n__-prdslib.isType '"String",
                                      imageToDeploy =
                                        _js2n__-prdslib.isType '"String",
                                      ingress =
                                        _js2n__-prdslib.isType '"String",
                                      location =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      runtimeStack =
                                        _js2n__-prdslib.isType '"String",
                                      targetPort =
                                        _js2n__-prdslib.isType '"String",
                                      workingDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      yamlConfigPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureContainerApps@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      acrName =
                                        _js2n__-prdslib.isType '"String",
                                      acrPassword =
                                        _js2n__-prdslib.isType '"String",
                                      acrUsername =
                                        _js2n__-prdslib.isType '"String",
                                      appSourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      containerAppEnvironment =
                                        _js2n__-prdslib.isType '"String",
                                      containerAppName =
                                        _js2n__-prdslib.isType '"String",
                                      disableTelemetry =
                                        _js2n__-prdslib.isType '"Bool",
                                      dockerfilePath =
                                        _js2n__-prdslib.isType '"String",
                                      environmentVariables =
                                        _js2n__-prdslib.isType '"String",
                                      imageToBuild =
                                        _js2n__-prdslib.isType '"String",
                                      imageToDeploy =
                                        _js2n__-prdslib.isType '"String",
                                      ingress =
                                        _js2n__-prdslib.isType '"String",
                                      location =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      runtimeStack =
                                        _js2n__-prdslib.isType '"String",
                                      targetPort =
                                        _js2n__-prdslib.isType '"String",
                                      workingDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      yamlConfigPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureContainerApps@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  addToPath = _js2n__-prdslib.isType '"Bool",
                                  versionSpec =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^UseRubyVersion@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  enableCodeCoverage =
                                    _js2n__-prdslib.isType '"Bool",
                                  gruntCli = _js2n__-prdslib.isType '"String",
                                  gruntFile = _js2n__-prdslib.isType '"String",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  srcFiles = _js2n__-prdslib.isType '"String",
                                  targets = _js2n__-prdslib.isType '"String",
                                  testFiles = _js2n__-prdslib.isType '"String",
                                  testFramework =
                                    _js2n__-prdslib.enum [ "Mocha", "Jasmine" ],
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Grunt@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  AdditionalArguments =
                                    _js2n__-prdslib.isType '"String",
                                  AuthenticationType =
                                    _js2n__-prdslib.enum
                                        [
                                          "server",
                                          "aadAuthenticationPassword",
                                          "aadAuthenticationIntegrated",
                                          "connectionString",
                                          "servicePrincipal"
                                        ],
                                  BacpacFile = _js2n__-prdslib.isType '"String",
                                  ConnectionString =
                                    _js2n__-prdslib.isType '"String",
                                  DacpacFile = _js2n__-prdslib.isType '"String",
                                  DatabaseName =
                                    _js2n__-prdslib.isType '"String",
                                  DeleteFirewallRule =
                                    _js2n__-prdslib.isType '"Bool",
                                  DeploymentAction =
                                    _js2n__-prdslib.enum
                                        [
                                          "Publish",
                                          "Extract",
                                          "Export",
                                          "Import",
                                          "Script",
                                          "DriftReport",
                                          "DeployReport"
                                        ],
                                  EndIpAddress =
                                    _js2n__-prdslib.isType '"String",
                                  InlineAdditionalArguments =
                                    _js2n__-prdslib.isType '"String",
                                  IpDetectionMethod =
                                    _js2n__-prdslib.enum
                                        [ "AutoDetect", "IPAddressRange" ],
                                  PublishProfile =
                                    _js2n__-prdslib.isType '"String",
                                  ServerName = _js2n__-prdslib.isType '"String",
                                  SqlAdditionalArguments =
                                    _js2n__-prdslib.isType '"String",
                                  SqlFile = _js2n__-prdslib.isType '"String",
                                  SqlInline = _js2n__-prdslib.isType '"String",
                                  SqlPassword =
                                    _js2n__-prdslib.isType '"String",
                                  SqlUsername =
                                    _js2n__-prdslib.isType '"String",
                                  StartIpAddress =
                                    _js2n__-prdslib.isType '"String",
                                  aadSqlPassword =
                                    _js2n__-prdslib.isType '"String",
                                  aadSqlUsername =
                                    _js2n__-prdslib.isType '"String",
                                  azureClassicSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  azureConnectionType =
                                    _js2n__-prdslib.enum
                                        [
                                          "ConnectedServiceName",
                                          "ConnectedServiceNameARM"
                                        ],
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  deployType =
                                    _js2n__-prdslib.enum
                                        [
                                          "DacpacTask",
                                          "SqlTask",
                                          "InlineSqlTask"
                                        ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^SqlAzureDacpacDeployment@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "configFile",
                                      "dockerRegistryServiceConnection",
                                      "repository"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      configFile =
                                        _js2n__-prdslib.isType '"String",
                                      dockerRegistryServiceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      failTaskOnFailedTests =
                                        _js2n__-prdslib.isType '"Bool",
                                      repository =
                                        _js2n__-prdslib.isType '"String",
                                      tag = _js2n__-prdslib.isType '"String",
                                      testRunTitle =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ContainerStructureTest@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "EnvironmentName", "WebDeployPackage" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AddBinding =
                                        _js2n__-prdslib.isType '"Bool",
                                      AdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      AdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                      AppCmdCommands =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolIdentity =
                                        _js2n__-prdslib.enum
                                            [
                                              "ApplicationPoolIdentity",
                                              "LocalService",
                                              "LocalSystem",
                                              "NetworkService",
                                              "SpecificUser"
                                            ],
                                      AppPoolName =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolPassword =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolUsername =
                                        _js2n__-prdslib.isType '"String",
                                      AssignDuplicateBinding =
                                        _js2n__-prdslib.isType '"Bool",
                                      CreateAppPool =
                                        _js2n__-prdslib.isType '"Bool",
                                      CreateWebSite =
                                        _js2n__-prdslib.isType '"Bool",
                                      DeployInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      DotNetVersion =
                                        _js2n__-prdslib.enum
                                            [
                                              "v4.0",
                                              "v2.0",
                                              "No Managed Code"
                                            ],
                                      EnvironmentName =
                                        _js2n__-prdslib.isType '"String",
                                      HostNameWithHttp =
                                        _js2n__-prdslib.isType '"String",
                                      HostNameWithOutSNI =
                                        _js2n__-prdslib.isType '"String",
                                      HostNameWithSNI =
                                        _js2n__-prdslib.isType '"String",
                                      IPAddress =
                                        _js2n__-prdslib.isType '"String",
                                      MachineFilter =
                                        _js2n__-prdslib.isType '"String",
                                      OverRideParams =
                                        _js2n__-prdslib.isType '"String",
                                      PipeLineMode =
                                        _js2n__-prdslib.enum
                                            [ "Integrated", "Classic" ],
                                      Port = _js2n__-prdslib.isType '"String",
                                      Protocol =
                                        _js2n__-prdslib.enum
                                            [ "https", "http" ],
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      SSLCertThumbPrint =
                                        _js2n__-prdslib.isType '"String",
                                      ServerNameIndication =
                                        _js2n__-prdslib.isType '"Bool",
                                      TestCertificate =
                                        _js2n__-prdslib.isType '"Bool",
                                      WebDeployPackage =
                                        _js2n__-prdslib.isType '"String",
                                      WebDeployParamFile =
                                        _js2n__-prdslib.isType '"String",
                                      WebSiteAuthUserName =
                                        _js2n__-prdslib.isType '"String",
                                      WebSiteAuthUserPassword =
                                        _js2n__-prdslib.isType '"String",
                                      WebSiteName =
                                        _js2n__-prdslib.isType '"String",
                                      WebSitePhysicalPath =
                                        _js2n__-prdslib.isType '"String",
                                      WebSitePhysicalPathAuth =
                                        _js2n__-prdslib.enum
                                            [
                                              "WebSiteUserPassThrough",
                                              "WebSiteWindowsAuth"
                                            ],
                                      WinRMProtocol =
                                        _js2n__-prdslib.enum
                                            [ "Http", "Https" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^IISWebAppDeployment@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "LoadTest" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      LoadTest =
                                        _js2n__-prdslib.isType '"String",
                                      MachineType =
                                        _js2n__-prdslib.enum [ "0", "2" ],
                                      TestDrop =
                                        _js2n__-prdslib.isType '"String",
                                      TestSettings =
                                        _js2n__-prdslib.isType '"String",
                                      ThresholdLimit =
                                        _js2n__-prdslib.isType '"String",
                                      activeRunSettings =
                                        _js2n__-prdslib.enum
                                            [ "useFile", "changeActive" ],
                                      connectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      numOfSelfProvisionedAgents =
                                        _js2n__-prdslib.isType 'Integer,
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      runSettingName =
                                        _js2n__-prdslib.isType '"String",
                                      testContextParameters =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^CloudLoadTest@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  kubectlVersion =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^KubectlInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  failOnStderr = _js2n__-prdslib.isType '"Bool",
                                  script = _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^CmdLine@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "filename" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      arguments =
                                        _js2n__-prdslib.isType '"String",
                                      failOnStandardError =
                                        _js2n__-prdslib.isType '"Bool",
                                      filename =
                                        _js2n__-prdslib.isType '"String",
                                      workingFolder =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task = _js2n__-prdslib.strings.pattern "^CmdLine@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "command" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      arguments =
                                        _js2n__-prdslib.isType '"String",
                                      command =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task = _js2n__-prdslib.strings.pattern "^NuGet@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  Dockerfile = _js2n__-prdslib.isType '"String",
                                  buildContext =
                                    _js2n__-prdslib.isType '"String",
                                  dockerRegistryServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                  repository = _js2n__-prdslib.isType '"String",
                                  tags = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ContainerBuild@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  noCache = _js2n__-prdslib.isType '"Bool",
                                  nuGetPath = _js2n__-prdslib.isType '"String",
                                  nuGetRestoreArgs =
                                    _js2n__-prdslib.isType '"String",
                                  nuGetVersion =
                                    _js2n__-prdslib.enum
                                        [
                                          "3.3.0",
                                          "3.5.0.1829",
                                          "4.0.0.2283",
                                          "custom"
                                        ],
                                  nugetConfigPath =
                                    _js2n__-prdslib.isType '"String",
                                  restoreMode =
                                    _js2n__-prdslib.enum
                                        [ "restore", "install" ],
                                  solution = _js2n__-prdslib.isType '"String",
                                  verbosity =
                                    _js2n__-prdslib.enum
                                        [ "-", "Quiet", "Normal", "Detailed" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^NuGetInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  feed = _js2n__-prdslib.isType '"String",
                                  includeNuGetOrg =
                                    _js2n__-prdslib.isType '"Bool",
                                  noCache = _js2n__-prdslib.isType '"Bool",
                                  nugetConfigPath =
                                    _js2n__-prdslib.isType '"String",
                                  packagesDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  selectOrConfig =
                                    _js2n__-prdslib.enum [ "select", "config" ],
                                  solution = _js2n__-prdslib.isType '"String",
                                  verbosity =
                                    _js2n__-prdslib.enum
                                        [ "-", "Quiet", "Normal", "Detailed" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^NuGetRestore@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  allowPackageConflicts =
                                    _js2n__-prdslib.isType '"Bool",
                                  arguments = _js2n__-prdslib.isType '"String",
                                  basePath = _js2n__-prdslib.isType '"String",
                                  buildProperties =
                                    _js2n__-prdslib.isType '"String",
                                  command =
                                    _js2n__-prdslib.enum
                                        [ "restore", "pack", "push", "custom" ],
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  disableParallelProcessing =
                                    _js2n__-prdslib.isType '"Bool",
                                  externalFeedCredentials =
                                    _js2n__-prdslib.isType '"String",
                                  feedsToUse =
                                    _js2n__-prdslib.enum [ "select", "config" ],
                                  includeNuGetOrg =
                                    _js2n__-prdslib.isType '"Bool",
                                  includeReferencedProjects =
                                    _js2n__-prdslib.isType '"Bool",
                                  includeSymbols =
                                    _js2n__-prdslib.isType '"Bool",
                                  majorVersion =
                                    _js2n__-prdslib.isType '"String",
                                  minorVersion =
                                    _js2n__-prdslib.isType '"String",
                                  noCache = _js2n__-prdslib.isType '"Bool",
                                  nuGetFeedType =
                                    _js2n__-prdslib.enum
                                        [ "internal", "external" ],
                                  nugetConfigPath =
                                    _js2n__-prdslib.isType '"String",
                                  packDestination =
                                    _js2n__-prdslib.isType '"String",
                                  packTimezone =
                                    _js2n__-prdslib.enum [ "utc", "local" ],
                                  packagesToPack =
                                    _js2n__-prdslib.isType '"String",
                                  packagesToPush =
                                    _js2n__-prdslib.isType '"String",
                                  patchVersion =
                                    _js2n__-prdslib.isType '"String",
                                  publishFeedCredentials =
                                    _js2n__-prdslib.isType '"String",
                                  publishPackageMetadata =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishVstsFeed =
                                    _js2n__-prdslib.isType '"String",
                                  restoreDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  restoreSolution =
                                    _js2n__-prdslib.isType '"String",
                                  toolPackage = _js2n__-prdslib.isType '"Bool",
                                  verbosityPack =
                                    _js2n__-prdslib.enum
                                        [ "Quiet", "Normal", "Detailed" ],
                                  verbosityPush =
                                    _js2n__-prdslib.enum
                                        [ "Quiet", "Normal", "Detailed" ],
                                  verbosityRestore =
                                    _js2n__-prdslib.enum
                                        [ "Quiet", "Normal", "Detailed" ],
                                  versionEnvVar =
                                    _js2n__-prdslib.isType '"String",
                                  versioningScheme =
                                    _js2n__-prdslib.enum
                                        [
                                          "off",
                                          "byPrereleaseNumber",
                                          "byEnvVar",
                                          "byBuildNumber"
                                        ],
                                  vstsFeed = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^NuGetCommand@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  delayForMinutes =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Delay@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  args = _js2n__-prdslib.isType '"String",
                                  buildForSimulator =
                                    _js2n__-prdslib.isType '"Bool",
                                  clean = _js2n__-prdslib.isType '"Bool",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  mdtoolFile = _js2n__-prdslib.isType '"String",
                                  packageApp = _js2n__-prdslib.isType '"Bool",
                                  runNugetRestore =
                                    _js2n__-prdslib.isType '"Bool",
                                  signingIdentity =
                                    _js2n__-prdslib.isType '"String",
                                  signingProvisioningProfileID =
                                    _js2n__-prdslib.isType '"String",
                                  solutionFile =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^XamariniOS@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  args = _js2n__-prdslib.isType '"String",
                                  buildForSimulator =
                                    _js2n__-prdslib.isType '"Bool",
                                  buildToolOption =
                                    _js2n__-prdslib.enum
                                        [ "xbuild", "msbuild" ],
                                  clean = _js2n__-prdslib.isType '"Bool",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  mdtoolFile = _js2n__-prdslib.isType '"String",
                                  packageApp = _js2n__-prdslib.isType '"Bool",
                                  runNugetRestore =
                                    _js2n__-prdslib.isType '"Bool",
                                  signingDefaultKeychainPassword =
                                    _js2n__-prdslib.isType '"String",
                                  signingIdentity =
                                    _js2n__-prdslib.isType '"String",
                                  signingOption =
                                    _js2n__-prdslib.enum [ "file", "id" ],
                                  signingP12File =
                                    _js2n__-prdslib.isType '"String",
                                  signingP12Password =
                                    _js2n__-prdslib.isType '"String",
                                  signingProvisioningProfileFile =
                                    _js2n__-prdslib.isType '"String",
                                  signingProvisioningProfileID =
                                    _js2n__-prdslib.isType '"String",
                                  signingRemoveProfile =
                                    _js2n__-prdslib.isType '"Bool",
                                  signingUnlockDefaultKeychain =
                                    _js2n__-prdslib.isType '"Bool",
                                  solutionFile =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^XamariniOS@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  buildConfiguration =
                                    _js2n__-prdslib.isType '"String",
                                  buildPlatform =
                                    _js2n__-prdslib.isType '"String",
                                  failTaskOnFailedTests =
                                    _js2n__-prdslib.isType '"Bool",
                                  failTaskOnFailureToPublishResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  failTaskOnMissingResultsFile =
                                    _js2n__-prdslib.isType '"Bool",
                                  mergeTestResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishRunAttachments =
                                    _js2n__-prdslib.isType '"Bool",
                                  searchFolder =
                                    _js2n__-prdslib.isType '"String",
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testResultsFormat =
                                    _js2n__-prdslib.enum
                                        [
                                          "JUnit",
                                          "NUnit",
                                          "VSTest",
                                          "XUnit",
                                          "CTest"
                                        ],
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishTestResults@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  mergeTestResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  platform = _js2n__-prdslib.isType '"String",
                                  publishRunAttachments =
                                    _js2n__-prdslib.isType '"Bool",
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  testRunner =
                                    _js2n__-prdslib.enum
                                        [ "JUnit", "NUnit", "VSTest", "XUnit" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishTestResults@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "Destination",
                                      "SourcePath",
                                      "azureSubscription",
                                      "storage"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArgumentsForBlobCopy =
                                        _js2n__-prdslib.isType '"String",
                                      AdditionalArgumentsForVMCopy =
                                        _js2n__-prdslib.isType '"String",
                                      BlobPrefix =
                                        _js2n__-prdslib.isType '"String",
                                      CleanTargetBeforeCopy =
                                        _js2n__-prdslib.isType '"Bool",
                                      ContainerName =
                                        _js2n__-prdslib.isType '"String",
                                      CopyFilesInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      Destination =
                                        _js2n__-prdslib.enum
                                            [ "AzureBlob", "AzureVMs" ],
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      SourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      TargetPath =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      enableCopyPrerequisites =
                                        _js2n__-prdslib.isType '"Bool",
                                      resourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      sasTokenTimeOutInMinutes =
                                        _js2n__-prdslib.isType '"String",
                                      skipCACheck =
                                        _js2n__-prdslib.isType '"Bool",
                                      storage =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureFileCopy@5$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "Destination",
                                      "SourcePath",
                                      "azureSubscription",
                                      "storage"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArgumentsForBlobCopy =
                                        _js2n__-prdslib.isType '"String",
                                      AdditionalArgumentsForVMCopy =
                                        _js2n__-prdslib.isType '"String",
                                      BlobPrefix =
                                        _js2n__-prdslib.isType '"String",
                                      CleanTargetBeforeCopy =
                                        _js2n__-prdslib.isType '"Bool",
                                      ContainerName =
                                        _js2n__-prdslib.isType '"String",
                                      CopyFilesInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      Destination =
                                        _js2n__-prdslib.enum
                                            [ "AzureBlob", "AzureVMs" ],
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      SourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      TargetPath =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      enableCopyPrerequisites =
                                        _js2n__-prdslib.isType '"Bool",
                                      resourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      skipCACheck =
                                        _js2n__-prdslib.isType '"Bool",
                                      storage =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureFileCopy@6$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "Destination",
                                      "SourcePath",
                                      "azureSubscription",
                                      "storage"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArgumentsForBlobCopy =
                                        _js2n__-prdslib.isType '"String",
                                      AdditionalArgumentsForVMCopy =
                                        _js2n__-prdslib.isType '"String",
                                      BlobPrefix =
                                        _js2n__-prdslib.isType '"String",
                                      CleanTargetBeforeCopy =
                                        _js2n__-prdslib.isType '"Bool",
                                      ContainerName =
                                        _js2n__-prdslib.isType '"String",
                                      CopyFilesInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      Destination =
                                        _js2n__-prdslib.enum
                                            [ "AzureBlob", "AzureVMs" ],
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      SourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      TargetPath =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      enableCopyPrerequisites =
                                        _js2n__-prdslib.isType '"Bool",
                                      resourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      sasTokenTimeOutInMinutes =
                                        _js2n__-prdslib.isType '"String",
                                      skipCACheck =
                                        _js2n__-prdslib.isType '"Bool",
                                      storage =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureFileCopy@4$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "Destination", "SourcePath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArgumentsForBlobCopy =
                                        _js2n__-prdslib.isType '"String",
                                      AdditionalArgumentsForVMCopy =
                                        _js2n__-prdslib.isType '"String",
                                      BlobPrefix =
                                        _js2n__-prdslib.isType '"String",
                                      CleanTargetBeforeCopy =
                                        _js2n__-prdslib.isType '"Bool",
                                      ContainerName =
                                        _js2n__-prdslib.isType '"String",
                                      CopyFilesInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      Destination =
                                        _js2n__-prdslib.enum
                                            [ "AzureBlob", "AzureVMs" ],
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      SourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      TargetPath =
                                        _js2n__-prdslib.isType '"String",
                                      azureClassicSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      azureConnectionType =
                                        _js2n__-prdslib.enum
                                            [
                                              "ConnectedServiceName",
                                              "ConnectedServiceNameARM"
                                            ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      classicStorage =
                                        _js2n__-prdslib.isType '"String",
                                      cloudService =
                                        _js2n__-prdslib.isType '"String",
                                      enableCopyPrerequisites =
                                        _js2n__-prdslib.isType '"Bool",
                                      outputStorageContainerSasToken =
                                        _js2n__-prdslib.isType '"String",
                                      outputStorageUri =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      skipCACheck =
                                        _js2n__-prdslib.isType '"Bool",
                                      storage =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureFileCopy@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "Destination",
                                      "SourcePath",
                                      "azureSubscription",
                                      "storage"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArgumentsForBlobCopy =
                                        _js2n__-prdslib.isType '"String",
                                      AdditionalArgumentsForVMCopy =
                                        _js2n__-prdslib.isType '"String",
                                      BlobPrefix =
                                        _js2n__-prdslib.isType '"String",
                                      CleanTargetBeforeCopy =
                                        _js2n__-prdslib.isType '"Bool",
                                      ContainerName =
                                        _js2n__-prdslib.isType '"String",
                                      CopyFilesInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      Destination =
                                        _js2n__-prdslib.enum
                                            [ "AzureBlob", "AzureVMs" ],
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      SourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      TargetPath =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      enableCopyPrerequisites =
                                        _js2n__-prdslib.isType '"Bool",
                                      outputStorageContainerSasToken =
                                        _js2n__-prdslib.isType '"String",
                                      outputStorageUri =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      sasTokenTimeOutInMinutes =
                                        _js2n__-prdslib.isType '"String",
                                      skipCACheck =
                                        _js2n__-prdslib.isType '"Bool",
                                      storage =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureFileCopy@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "Destination", "SourcePath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      BlobPrefix =
                                        _js2n__-prdslib.isType '"String",
                                      CleanTargetBeforeCopy =
                                        _js2n__-prdslib.isType '"Bool",
                                      ContainerName =
                                        _js2n__-prdslib.isType '"String",
                                      CopyFilesInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      Destination =
                                        _js2n__-prdslib.enum
                                            [ "AzureBlob", "AzureVMs" ],
                                      MachineNames =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      SourcePath =
                                        _js2n__-prdslib.isType '"String",
                                      TargetPath =
                                        _js2n__-prdslib.isType '"String",
                                      azureClassicSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      azureConnectionType =
                                        _js2n__-prdslib.enum
                                            [
                                              "ConnectedServiceName",
                                              "ConnectedServiceNameARM"
                                            ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      classicStorage =
                                        _js2n__-prdslib.isType '"String",
                                      cloudService =
                                        _js2n__-prdslib.isType '"String",
                                      enableCopyPrerequisites =
                                        _js2n__-prdslib.isType '"Bool",
                                      outputStorageContainerSasToken =
                                        _js2n__-prdslib.isType '"String",
                                      outputStorageUri =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      skipCACheck =
                                        _js2n__-prdslib.isType '"Bool",
                                      storage =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      vmsAdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureFileCopy@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  CompressSymbols =
                                    _js2n__-prdslib.isType '"Bool",
                                  ConnectedServiceName =
                                    _js2n__-prdslib.isType '"String",
                                  DetailedLog = _js2n__-prdslib.isType '"Bool",
                                  IndexSources = _js2n__-prdslib.isType '"Bool",
                                  IndexableFileFormats =
                                    _js2n__-prdslib.enum
                                        [
                                          "Default",
                                          "Pdb",
                                          "SourceMap",
                                          "All"
                                        ],
                                  PublishSymbols =
                                    _js2n__-prdslib.isType '"Bool",
                                  SearchPattern =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolExpirationInDays =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolServerType =
                                    _js2n__-prdslib.enum
                                        [ " ", "TeamServices", "FileShare" ],
                                  SymbolsArtifactName =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsFolder =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsMaximumWaitTime =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsPath =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsProduct =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsVersion =
                                    _js2n__-prdslib.isType '"String",
                                  TreatNotIndexedAsWarning =
                                    _js2n__-prdslib.isType '"Bool",
                                  UseNetCoreClientTool =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishSymbols@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  SearchPattern =
                                    _js2n__-prdslib.isType '"String",
                                  SkipIndexing = _js2n__-prdslib.isType '"Bool",
                                  SymbolsArtifactName =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsFolder =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsMaximumWaitTime =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsPath =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsProduct =
                                    _js2n__-prdslib.isType '"String",
                                  SymbolsVersion =
                                    _js2n__-prdslib.isType '"String",
                                  TreatNotIndexedAsWarning =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishSymbols@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "sshEndpoint" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      cleanHiddenFilesInTarget =
                                        _js2n__-prdslib.isType '"Bool",
                                      cleanTargetFolder =
                                        _js2n__-prdslib.isType '"Bool",
                                      concurrentUploads =
                                        _js2n__-prdslib.isType '"String",
                                      contents =
                                        _js2n__-prdslib.isType '"String",
                                      delayBetweenUploads =
                                        _js2n__-prdslib.isType '"String",
                                      failOnEmptySource =
                                        _js2n__-prdslib.isType '"Bool",
                                      flattenFolders =
                                        _js2n__-prdslib.isType '"Bool",
                                      isWindowsOnTarget =
                                        _js2n__-prdslib.isType '"Bool",
                                      overwrite =
                                        _js2n__-prdslib.isType '"Bool",
                                      readyTimeout =
                                        _js2n__-prdslib.isType '"String",
                                      sourceFolder =
                                        _js2n__-prdslib.isType '"String",
                                      sshEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      targetFolder =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^CopyFilesOverSSH@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkStyleRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageClassFilesDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageClassFilter =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageFailIfEmpty =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageGradle5xOrHigher =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageToolOption =
                                    _js2n__-prdslib.enum
                                        [ "None", "Cobertura", "JaCoCo" ],
                                  findBugsRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  gradleOptions =
                                    _js2n__-prdslib.isType '"String",
                                  gradleWrapperFile =
                                    _js2n__-prdslib.isType '"String",
                                  javaHomeOption =
                                    _js2n__-prdslib.enum
                                        [ "JDKVersion", "Path" ],
                                  jdkArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  jdkDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  jdkVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "1.17",
                                          "1.11",
                                          "1.10",
                                          "1.9",
                                          "1.8",
                                          "1.7",
                                          "1.6"
                                        ],
                                  options = _js2n__-prdslib.isType '"String",
                                  pmdRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeGradlePluginVersion =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  spotBugsAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  spotBugsGradlePluginVersionChoice =
                                    _js2n__-prdslib.enum [ "specify", "build" ],
                                  spotbugsGradlePluginVersion =
                                    _js2n__-prdslib.isType '"String",
                                  sqGradlePluginVersionChoice =
                                    _js2n__-prdslib.enum [ "specify", "build" ],
                                  tasks = _js2n__-prdslib.isType '"String",
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Gradle@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkStyleRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageClassFilesDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageClassFilter =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageFailIfEmpty =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageGradle5xOrHigher =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageToolOption =
                                    _js2n__-prdslib.enum
                                        [ "None", "Cobertura", "JaCoCo" ],
                                  findBugsRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  gradleOptions =
                                    _js2n__-prdslib.isType '"String",
                                  gradleWrapperFile =
                                    _js2n__-prdslib.isType '"String",
                                  javaHomeOption =
                                    _js2n__-prdslib.enum
                                        [ "JDKVersion", "Path" ],
                                  jdkArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  jdkDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  jdkVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "1.17",
                                          "1.11",
                                          "1.10",
                                          "1.9",
                                          "1.8",
                                          "1.7",
                                          "1.6"
                                        ],
                                  options = _js2n__-prdslib.isType '"String",
                                  pmdRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeGradlePluginVersion =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  spotBugsAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  spotBugsGradlePluginVersionChoice =
                                    _js2n__-prdslib.enum [ "specify", "build" ],
                                  spotbugsGradlePluginVersion =
                                    _js2n__-prdslib.isType '"String",
                                  sqGradlePluginVersionChoice =
                                    _js2n__-prdslib.enum [ "specify", "build" ],
                                  tasks = _js2n__-prdslib.isType '"String",
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Gradle@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkStyleRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageClassFilesDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageClassFilter =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageFailIfEmpty =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageToolOption =
                                    _js2n__-prdslib.enum
                                        [ "None", "Cobertura", "JaCoCo" ],
                                  findBugsRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  gradleOptions =
                                    _js2n__-prdslib.isType '"String",
                                  gradleWrapperFile =
                                    _js2n__-prdslib.isType '"String",
                                  javaHomeOption =
                                    _js2n__-prdslib.enum
                                        [ "JDKVersion", "Path" ],
                                  jdkArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  jdkDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  jdkVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "1.9",
                                          "1.8",
                                          "1.7",
                                          "1.6"
                                        ],
                                  options = _js2n__-prdslib.isType '"String",
                                  pmdRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeDBPassword =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeDBUrl =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeDBUsername =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeFailWhenQualityGateFails =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeGradlePluginVersion =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeIncludeFullReport =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeProjectKey =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeProjectName =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeProjectVersion =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeRunAnalysis =
                                    _js2n__-prdslib.isType '"Bool",
                                  sonarQubeServiceEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  sonarQubeSpecifyDB =
                                    _js2n__-prdslib.isType '"Bool",
                                  tasks = _js2n__-prdslib.isType '"String",
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Gradle@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "appFile", "appSlug", "serverEndpoint" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appFile =
                                        _js2n__-prdslib.isType '"String",
                                      appSlug =
                                        _js2n__-prdslib.isType '"String",
                                      distributionGroupId =
                                        _js2n__-prdslib.isType '"String",
                                      isMandatory =
                                        _js2n__-prdslib.isType '"Bool",
                                      releaseNotesFile =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesInput =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesOption =
                                        _js2n__-prdslib.enum
                                            [ "input", "file" ],
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsDsymFiles =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsIncludeParentDirectory =
                                        _js2n__-prdslib.isType '"Bool",
                                      symbolsMappingTxtFile =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsOption =
                                        _js2n__-prdslib.enum [ "Apple" ],
                                      symbolsPath =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsPdbFiles =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AppCenterDistribute@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "appFile", "appSlug", "serverEndpoint" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appFile =
                                        _js2n__-prdslib.isType '"String",
                                      appSlug =
                                        _js2n__-prdslib.isType '"String",
                                      distributionGroupId =
                                        _js2n__-prdslib.isType '"String",
                                      isMandatory =
                                        _js2n__-prdslib.isType '"Bool",
                                      releaseNotesFile =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesInput =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesOption =
                                        _js2n__-prdslib.enum
                                            [ "input", "file" ],
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsDsymFiles =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsIncludeParentDirectory =
                                        _js2n__-prdslib.isType '"Bool",
                                      symbolsMappingTxtFile =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsOption =
                                        _js2n__-prdslib.enum [ "Apple" ],
                                      symbolsPath =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsPdbFiles =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AppCenterDistribute@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "appFile", "appSlug", "serverEndpoint" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appFile =
                                        _js2n__-prdslib.isType '"String",
                                      appSlug =
                                        _js2n__-prdslib.isType '"String",
                                      appxsymPath =
                                        _js2n__-prdslib.isType '"String",
                                      buildVersion =
                                        _js2n__-prdslib.isType '"String",
                                      destinationStoreId =
                                        _js2n__-prdslib.isType '"String",
                                      destinationType =
                                        _js2n__-prdslib.enum
                                            [ "groups", "store" ],
                                      distributionGroupId =
                                        _js2n__-prdslib.isType '"String",
                                      isMandatory =
                                        _js2n__-prdslib.isType '"Bool",
                                      isSilent = _js2n__-prdslib.isType '"Bool",
                                      nativeLibrariesPath =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesFile =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesInput =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesOption =
                                        _js2n__-prdslib.enum
                                            [ "input", "file" ],
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsDsymFiles =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsIncludeParentDirectory =
                                        _js2n__-prdslib.isType '"Bool",
                                      symbolsMappingTxtFile =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsOption =
                                        _js2n__-prdslib.enum
                                            [ "Apple", "Android", "UWP" ],
                                      symbolsPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AppCenterDistribute@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "appFile", "appSlug", "serverEndpoint" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appFile =
                                        _js2n__-prdslib.isType '"String",
                                      appSlug =
                                        _js2n__-prdslib.isType '"String",
                                      distributionGroupId =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesFile =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesInput =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesOption =
                                        _js2n__-prdslib.enum
                                            [ "input", "file" ],
                                      serverEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsDsymFiles =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsIncludeParentDirectory =
                                        _js2n__-prdslib.isType '"Bool",
                                      symbolsMappingTxtFile =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsOption =
                                        _js2n__-prdslib.enum [ "Apple" ],
                                      symbolsPath =
                                        _js2n__-prdslib.isType '"String",
                                      symbolsPdbFiles =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AppCenterDistribute@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkLatest = _js2n__-prdslib.isType '"Bool",
                                  versionSpec =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^NuGetToolInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkLatest = _js2n__-prdslib.isType '"Bool",
                                  versionSpec =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^NuGetToolInstaller@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "jenkinsServerConnection", "jobName" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ConnectedServiceNameARM =
                                        _js2n__-prdslib.isType '"String",
                                      artifactDetailsFileNameSuffix =
                                        _js2n__-prdslib.isType '"String",
                                      artifactProvider =
                                        _js2n__-prdslib.enum [ "azureStorage" ],
                                      commonVirtualPath =
                                        _js2n__-prdslib.isType '"String",
                                      containerName =
                                        _js2n__-prdslib.isType '"String",
                                      downloadCommitsAndWorkItems =
                                        _js2n__-prdslib.isType '"Bool",
                                      itemPattern =
                                        _js2n__-prdslib.isType '"String",
                                      jenkinsBuild =
                                        _js2n__-prdslib.enum
                                            [
                                              "LastSuccessfulBuild",
                                              "BuildNumber"
                                            ],
                                      jenkinsBuildNumber =
                                        _js2n__-prdslib.isType '"String",
                                      jenkinsJobType =
                                        _js2n__-prdslib.isType '"String",
                                      jenkinsServerConnection =
                                        _js2n__-prdslib.isType '"String",
                                      jobName =
                                        _js2n__-prdslib.isType '"String",
                                      propagatedArtifacts =
                                        _js2n__-prdslib.isType '"Bool",
                                      saveTo = _js2n__-prdslib.isType '"String",
                                      startJenkinsBuildNumber =
                                        _js2n__-prdslib.isType '"String",
                                      storageAccountName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^JenkinsDownloadArtifacts@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "jenkinsServerConnection", "jobName" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ConnectedServiceNameARM =
                                        _js2n__-prdslib.isType '"String",
                                      artifactDetailsFileNameSuffix =
                                        _js2n__-prdslib.isType '"String",
                                      artifactProvider =
                                        _js2n__-prdslib.enum [ "azureStorage" ],
                                      commonVirtualPath =
                                        _js2n__-prdslib.isType '"String",
                                      containerName =
                                        _js2n__-prdslib.isType '"String",
                                      downloadCommitsAndWorkItems =
                                        _js2n__-prdslib.isType '"Bool",
                                      itemPattern =
                                        _js2n__-prdslib.isType '"String",
                                      jenkinsBuild =
                                        _js2n__-prdslib.enum
                                            [
                                              "LastSuccessfulBuild",
                                              "BuildNumber"
                                            ],
                                      jenkinsBuildNumber =
                                        _js2n__-prdslib.isType '"String",
                                      jenkinsJobType =
                                        _js2n__-prdslib.isType '"String",
                                      jenkinsServerConnection =
                                        _js2n__-prdslib.isType '"String",
                                      jobName =
                                        _js2n__-prdslib.isType '"String",
                                      propagatedArtifacts =
                                        _js2n__-prdslib.isType '"Bool",
                                      saveTo = _js2n__-prdslib.isType '"String",
                                      startJenkinsBuildNumber =
                                        _js2n__-prdslib.isType '"String",
                                      storageAccountName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^JenkinsDownloadArtifacts@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "appName",
                                      "azureSubscription",
                                      "imageName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appName =
                                        _js2n__-prdslib.isType '"String",
                                      appSettings =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      configurationStrings =
                                        _js2n__-prdslib.isType '"String",
                                      containerCommand =
                                        _js2n__-prdslib.isType '"String",
                                      deployToSlotOrASE =
                                        _js2n__-prdslib.isType '"Bool",
                                      imageName =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      slotName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureFunctionAppContainer@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "inFile", "passphrase" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      cipher = _js2n__-prdslib.isType '"String",
                                      inFile = _js2n__-prdslib.isType '"String",
                                      outFile =
                                        _js2n__-prdslib.isType '"String",
                                      passphrase =
                                        _js2n__-prdslib.isType '"String",
                                      workingDirectory =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^DecryptFile@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "azureContainerRegistry",
                                      "azureResourceGroupForACR",
                                      "azureSubscriptionForACR"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      arguments =
                                        _js2n__-prdslib.isType '"String",
                                      azureContainerRegistry =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceGroupForACR =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscriptionForACR =
                                        _js2n__-prdslib.isType '"String",
                                      caCert = _js2n__-prdslib.isType '"String",
                                      canaryImage =
                                        _js2n__-prdslib.isType '"Bool",
                                      certificate =
                                        _js2n__-prdslib.isType '"String",
                                      chartName =
                                        _js2n__-prdslib.isType '"String",
                                      chartNameForACR =
                                        _js2n__-prdslib.isType '"String",
                                      chartPath =
                                        _js2n__-prdslib.isType '"String",
                                      chartPathForACR =
                                        _js2n__-prdslib.isType '"String",
                                      chartType =
                                        _js2n__-prdslib.enum
                                            [ "Name", "FilePath" ],
                                      chartVersion =
                                        _js2n__-prdslib.isType '"String",
                                      command =
                                        _js2n__-prdslib.enum
                                            [
                                              "create",
                                              "delete",
                                              "expose",
                                              "get",
                                              "init",
                                              "install",
                                              "login",
                                              "logout",
                                              "ls",
                                              "package",
                                              "rollback",
                                              "upgrade",
                                              "uninstall"
                                            ],
                                      connectionType =
                                        _js2n__-prdslib.enum
                                            [
                                              "Azure Resource Manager",
                                              "Kubernetes Service Connection",
                                              "None"
                                            ],
                                      destination =
                                        _js2n__-prdslib.isType '"String",
                                      enableTls =
                                        _js2n__-prdslib.isType '"Bool",
                                      failOnStderr =
                                        _js2n__-prdslib.isType '"Bool",
                                      "force" = _js2n__-prdslib.isType '"Bool",
                                      install = _js2n__-prdslib.isType '"Bool",
                                      kubernetesCluster =
                                        _js2n__-prdslib.isType '"String",
                                      kubernetesServiceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      namespace =
                                        _js2n__-prdslib.isType '"String",
                                      overrideValues =
                                        _js2n__-prdslib.isType '"String",
                                      privatekey =
                                        _js2n__-prdslib.isType '"String",
                                      publishPipelineMetadata =
                                        _js2n__-prdslib.isType '"Bool",
                                      recreate = _js2n__-prdslib.isType '"Bool",
                                      releaseName =
                                        _js2n__-prdslib.isType '"String",
                                      resetValues =
                                        _js2n__-prdslib.isType '"Bool",
                                      save = _js2n__-prdslib.isType '"Bool",
                                      tillerNamespace =
                                        _js2n__-prdslib.isType '"String",
                                      updateDependency =
                                        _js2n__-prdslib.isType '"Bool",
                                      upgradeTiller =
                                        _js2n__-prdslib.isType '"Bool",
                                      useClusterAdmin =
                                        _js2n__-prdslib.isType '"Bool",
                                      valueFile =
                                        _js2n__-prdslib.isType '"String",
                                      waitForExecution =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^HelmDeploy@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "azureContainerRegistry",
                                      "azureResourceGroupForACR",
                                      "azureSubscriptionForACR"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      arguments =
                                        _js2n__-prdslib.isType '"String",
                                      azureContainerRegistry =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceGroupForACR =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscriptionForACR =
                                        _js2n__-prdslib.isType '"String",
                                      caCert = _js2n__-prdslib.isType '"String",
                                      canaryImage =
                                        _js2n__-prdslib.isType '"Bool",
                                      certificate =
                                        _js2n__-prdslib.isType '"String",
                                      chartName =
                                        _js2n__-prdslib.isType '"String",
                                      chartNameForACR =
                                        _js2n__-prdslib.isType '"String",
                                      chartPath =
                                        _js2n__-prdslib.isType '"String",
                                      chartPathForACR =
                                        _js2n__-prdslib.isType '"String",
                                      chartType =
                                        _js2n__-prdslib.enum
                                            [ "Name", "FilePath" ],
                                      chartVersion =
                                        _js2n__-prdslib.isType '"String",
                                      command =
                                        _js2n__-prdslib.enum
                                            [
                                              "create",
                                              "delete",
                                              "expose",
                                              "get",
                                              "init",
                                              "install",
                                              "login",
                                              "logout",
                                              "ls",
                                              "package",
                                              "rollback",
                                              "save",
                                              "upgrade",
                                              "uninstall"
                                            ],
                                      connectionType =
                                        _js2n__-prdslib.enum
                                            [
                                              "Azure Resource Manager",
                                              "Kubernetes Service Connection",
                                              "None"
                                            ],
                                      destination =
                                        _js2n__-prdslib.isType '"String",
                                      enableTls =
                                        _js2n__-prdslib.isType '"Bool",
                                      failOnStderr =
                                        _js2n__-prdslib.isType '"Bool",
                                      "force" = _js2n__-prdslib.isType '"Bool",
                                      install = _js2n__-prdslib.isType '"Bool",
                                      kubernetesCluster =
                                        _js2n__-prdslib.isType '"String",
                                      kubernetesServiceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      namespace =
                                        _js2n__-prdslib.isType '"String",
                                      overrideValues =
                                        _js2n__-prdslib.isType '"String",
                                      privatekey =
                                        _js2n__-prdslib.isType '"String",
                                      publishPipelineMetadata =
                                        _js2n__-prdslib.isType '"Bool",
                                      recreate = _js2n__-prdslib.isType '"Bool",
                                      releaseName =
                                        _js2n__-prdslib.isType '"String",
                                      resetValues =
                                        _js2n__-prdslib.isType '"Bool",
                                      save = _js2n__-prdslib.isType '"Bool",
                                      tillerNamespace =
                                        _js2n__-prdslib.isType '"String",
                                      updateDependency =
                                        _js2n__-prdslib.isType '"Bool",
                                      upgradeTiller =
                                        _js2n__-prdslib.isType '"Bool",
                                      useClusterAdmin =
                                        _js2n__-prdslib.isType '"Bool",
                                      valueFile =
                                        _js2n__-prdslib.isType '"String",
                                      waitForExecution =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^HelmDeploy@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "certSecureFile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      certPwd =
                                        _js2n__-prdslib.isType '"String",
                                      certSecureFile =
                                        _js2n__-prdslib.isType '"String",
                                      customKeychainPath =
                                        _js2n__-prdslib.isType '"String",
                                      deleteCert =
                                        _js2n__-prdslib.isType '"Bool",
                                      deleteCustomKeychain =
                                        _js2n__-prdslib.isType '"Bool",
                                      keychain =
                                        _js2n__-prdslib.enum
                                            [ "default", "temp", "custom" ],
                                      keychainPassword =
                                        _js2n__-prdslib.isType '"String",
                                      opensslPkcsArgs =
                                        _js2n__-prdslib.isType '"String",
                                      setUpPartitionIdACLForPrivateKey =
                                        _js2n__-prdslib.isType '"Bool",
                                      signingIdentity =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^InstallAppleCertificate@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "certSecureFile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      certPwd =
                                        _js2n__-prdslib.isType '"String",
                                      certSecureFile =
                                        _js2n__-prdslib.isType '"String",
                                      customKeychainPath =
                                        _js2n__-prdslib.isType '"String",
                                      deleteCert =
                                        _js2n__-prdslib.isType '"Bool",
                                      deleteCustomKeychain =
                                        _js2n__-prdslib.isType '"Bool",
                                      keychain =
                                        _js2n__-prdslib.enum
                                            [ "default", "temp", "custom" ],
                                      keychainPassword =
                                        _js2n__-prdslib.isType '"String",
                                      signingIdentity =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^InstallAppleCertificate@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "certSecureFile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      certPwd =
                                        _js2n__-prdslib.isType '"String",
                                      certSecureFile =
                                        _js2n__-prdslib.isType '"String",
                                      customKeychainPath =
                                        _js2n__-prdslib.isType '"String",
                                      deleteCert =
                                        _js2n__-prdslib.isType '"Bool",
                                      deleteCustomKeychain =
                                        _js2n__-prdslib.isType '"Bool",
                                      keychain =
                                        _js2n__-prdslib.enum
                                            [ "default", "temp", "custom" ],
                                      keychainPassword =
                                        _js2n__-prdslib.isType '"String",
                                      signingIdentity =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^InstallAppleCertificate@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "function", "key" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      body = _js2n__-prdslib.isType '"String",
                                      function =
                                        _js2n__-prdslib.isType '"String",
                                      headers =
                                        _js2n__-prdslib.isType '"String",
                                      key = _js2n__-prdslib.isType '"String",
                                      method =
                                        _js2n__-prdslib.enum
                                            [
                                              "OPTIONS",
                                              "GET",
                                              "HEAD",
                                              "POST",
                                              "PUT",
                                              "DELETE",
                                              "TRACE",
                                              "PATCH"
                                            ],
                                      queryParameters =
                                        _js2n__-prdslib.isType '"String",
                                      successCriteria =
                                        _js2n__-prdslib.isType '"String",
                                      waitForCompletion =
                                        _js2n__-prdslib.enum
                                            [ "true", "false" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureFunction@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "function", "key" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      body = _js2n__-prdslib.isType '"String",
                                      function =
                                        _js2n__-prdslib.isType '"String",
                                      headers =
                                        _js2n__-prdslib.isType '"String",
                                      key = _js2n__-prdslib.isType '"String",
                                      method =
                                        _js2n__-prdslib.enum
                                            [
                                              "OPTIONS",
                                              "GET",
                                              "HEAD",
                                              "POST",
                                              "PUT",
                                              "DELETE",
                                              "TRACE",
                                              "PATCH"
                                            ],
                                      queryParameters =
                                        _js2n__-prdslib.isType '"String",
                                      successCriteria =
                                        _js2n__-prdslib.isType '"String",
                                      waitForCompletion =
                                        _js2n__-prdslib.enum
                                            [ "true", "false" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureFunction@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  opaVersion = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^OpenPolicyAgentInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "connection", "userRepository" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      connection =
                                        _js2n__-prdslib.isType '"String",
                                      defaultVersionType =
                                        _js2n__-prdslib.enum
                                            [
                                              "latest",
                                              "specificVersion",
                                              "specificTag"
                                            ],
                                      downloadPath =
                                        _js2n__-prdslib.isType '"String",
                                      itemPattern =
                                        _js2n__-prdslib.isType '"String",
                                      userRepository =
                                        _js2n__-prdslib.isType '"String",
                                      version =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadGitHubRelease@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "sshEndpoint" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      args = _js2n__-prdslib.isType '"String",
                                      commands =
                                        _js2n__-prdslib.isType '"String",
                                      failOnStdErr =
                                        _js2n__-prdslib.isType '"Bool",
                                      inline = _js2n__-prdslib.isType '"String",
                                      interactiveKeyboardAuthentication =
                                        _js2n__-prdslib.isType '"Bool",
                                      interactiveSession =
                                        _js2n__-prdslib.isType '"Bool",
                                      interpreterCommand =
                                        _js2n__-prdslib.isType '"String",
                                      readyTimeout =
                                        _js2n__-prdslib.isType '"String",
                                      runOptions =
                                        _js2n__-prdslib.enum
                                            [ "commands", "script", "inline" ],
                                      scriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      sshEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task = _js2n__-prdslib.strings.pattern "^SSH@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "targetPath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      artifactName =
                                        _js2n__-prdslib.isType '"String",
                                      properties =
                                        _js2n__-prdslib.isType '"String",
                                      targetPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishPipelineArtifact@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  artifact = _js2n__-prdslib.isType '"String",
                                  fileSharePath =
                                    _js2n__-prdslib.isType '"String",
                                  parallel = _js2n__-prdslib.isType '"Bool",
                                  parallelCount =
                                    _js2n__-prdslib.isType 'Integer,
                                  properties = _js2n__-prdslib.isType '"String",
                                  publishLocation =
                                    _js2n__-prdslib.enum
                                        [ "pipeline", "filepath" ],
                                  targetPath = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishPipelineArtifact@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "connectedServiceName",
                                      "projectKey",
                                      "projectName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      breakBuild =
                                        _js2n__-prdslib.isType '"Bool",
                                      cmdLineArgs =
                                        _js2n__-prdslib.isType '"String",
                                      configFile =
                                        _js2n__-prdslib.isType '"String",
                                      connectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      dbPassword =
                                        _js2n__-prdslib.isType '"String",
                                      dbUrl = _js2n__-prdslib.isType '"String",
                                      dbUsername =
                                        _js2n__-prdslib.isType '"String",
                                      includeFullReport =
                                        _js2n__-prdslib.isType '"Bool",
                                      projectKey =
                                        _js2n__-prdslib.isType '"String",
                                      projectName =
                                        _js2n__-prdslib.isType '"String",
                                      projectVersion =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^SonarQubePreBuild@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "artifactName", "filesharePath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      artifactName =
                                        _js2n__-prdslib.isType '"String",
                                      downloadPath =
                                        _js2n__-prdslib.isType '"String",
                                      filesharePath =
                                        _js2n__-prdslib.isType '"String",
                                      itemPattern =
                                        _js2n__-prdslib.isType '"String",
                                      parallelizationLimit =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadFileshareArtifacts@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  azureContainerRegistry =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  checkLatest = _js2n__-prdslib.isType '"Bool",
                                  command =
                                    _js2n__-prdslib.enum
                                        [
                                          "apply",
                                          "create",
                                          "delete",
                                          "exec",
                                          "expose",
                                          "get",
                                          "logs",
                                          "run",
                                          "set",
                                          "top"
                                        ],
                                  configMapArguments =
                                    _js2n__-prdslib.isType '"String",
                                  configMapFile =
                                    _js2n__-prdslib.isType '"String",
                                  configMapName =
                                    _js2n__-prdslib.isType '"String",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  containerRegistryType =
                                    _js2n__-prdslib.enum
                                        [
                                          "Azure Container Registry",
                                          "Container Registry"
                                        ],
                                  dockerRegistryConnection =
                                    _js2n__-prdslib.isType '"String",
                                  forceUpdate = _js2n__-prdslib.isType '"Bool",
                                  forceUpdateConfigMap =
                                    _js2n__-prdslib.isType '"Bool",
                                  kubectlOutput =
                                    _js2n__-prdslib.isType '"String",
                                  kubernetesServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                  namespace = _js2n__-prdslib.isType '"String",
                                  outputFormat =
                                    _js2n__-prdslib.enum [ "json", "yaml" ],
                                  secretArguments =
                                    _js2n__-prdslib.isType '"String",
                                  secretName = _js2n__-prdslib.isType '"String",
                                  secretType =
                                    _js2n__-prdslib.enum
                                        [ "dockerRegistry", "generic" ],
                                  specifyLocation =
                                    _js2n__-prdslib.isType '"String",
                                  useConfigMapFile =
                                    _js2n__-prdslib.isType '"Bool",
                                  useConfigurationFile =
                                    _js2n__-prdslib.isType '"Bool",
                                  versionOrLocation =
                                    _js2n__-prdslib.enum
                                        [ "version", "location" ],
                                  versionSpec =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^Kubernetes@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  azureContainerRegistry =
                                    _js2n__-prdslib.isType '"String",
                                  azureResourceGroup =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscriptionEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscriptionEndpointForSecrets =
                                    _js2n__-prdslib.isType '"String",
                                  checkLatest = _js2n__-prdslib.isType '"Bool",
                                  command =
                                    _js2n__-prdslib.enum
                                        [
                                          "apply",
                                          "create",
                                          "delete",
                                          "exec",
                                          "expose",
                                          "get",
                                          "login",
                                          "logout",
                                          "logs",
                                          "run",
                                          "set",
                                          "top"
                                        ],
                                  configMapArguments =
                                    _js2n__-prdslib.isType '"String",
                                  configMapFile =
                                    _js2n__-prdslib.isType '"String",
                                  configMapName =
                                    _js2n__-prdslib.isType '"String",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  configurationType =
                                    _js2n__-prdslib.enum
                                        [ "configuration", "inline" ],
                                  connectionType =
                                    _js2n__-prdslib.enum
                                        [
                                          "Azure Resource Manager",
                                          "Kubernetes Service Connection",
                                          "None"
                                        ],
                                  containerRegistryType =
                                    _js2n__-prdslib.enum
                                        [
                                          "Azure Container Registry",
                                          "Container Registry"
                                        ],
                                  dockerRegistryEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  forceUpdate = _js2n__-prdslib.isType '"Bool",
                                  forceUpdateConfigMap =
                                    _js2n__-prdslib.isType '"Bool",
                                  inline = _js2n__-prdslib.isType '"String",
                                  kubernetesCluster =
                                    _js2n__-prdslib.isType '"String",
                                  kubernetesServiceEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  namespace = _js2n__-prdslib.isType '"String",
                                  outputFormat =
                                    _js2n__-prdslib.enum
                                        [ "json", "yaml", "none" ],
                                  secretArguments =
                                    _js2n__-prdslib.isType '"String",
                                  secretName = _js2n__-prdslib.isType '"String",
                                  secretType =
                                    _js2n__-prdslib.enum
                                        [ "dockerRegistry", "generic" ],
                                  specifyLocation =
                                    _js2n__-prdslib.isType '"String",
                                  useClusterAdmin =
                                    _js2n__-prdslib.isType '"Bool",
                                  useConfigMapFile =
                                    _js2n__-prdslib.isType '"Bool",
                                  useConfigurationFile =
                                    _js2n__-prdslib.isType '"Bool",
                                  versionOrLocation =
                                    _js2n__-prdslib.enum
                                        [ "version", "location" ],
                                  versionSpec =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^Kubernetes@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  action =
                                    _js2n__-prdslib.enum
                                        [
                                          "Build module images",
                                          "Push module images",
                                          "Generate deployment manifest",
                                          "Deploy to IoT Edge devices"
                                        ],
                                  azureContainerRegistry =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscriptionEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  bypassModules =
                                    _js2n__-prdslib.isType '"String",
                                  containerregistrytype =
                                    _js2n__-prdslib.enum
                                        [
                                          "Azure Container Registry",
                                          "Generic Container Registry"
                                        ],
                                  defaultPlatform =
                                    _js2n__-prdslib.enum
                                        [
                                          "amd64",
                                          "windows-amd64",
                                          "arm32v7",
                                          "arm64v8"
                                        ],
                                  deploymentFilePath =
                                    _js2n__-prdslib.isType '"String",
                                  deploymentManifestOutputPath =
                                    _js2n__-prdslib.isType '"String",
                                  deploymentid =
                                    _js2n__-prdslib.isType '"String",
                                  deviceId = _js2n__-prdslib.isType '"String",
                                  deviceOption =
                                    _js2n__-prdslib.enum
                                        [ "Single Device", "Multiple Devices" ],
                                  dockerRegistryConnection =
                                    _js2n__-prdslib.isType '"String",
                                  fillRegistryCredential =
                                    _js2n__-prdslib.enum [ "true", "false" ],
                                  iothubname = _js2n__-prdslib.isType '"String",
                                  "priority" = _js2n__-prdslib.isType '"String",
                                  targetcondition =
                                    _js2n__-prdslib.isType '"String",
                                  templateFilePath =
                                    _js2n__-prdslib.isType '"String",
                                  validateGeneratedDeploymentManifest =
                                    _js2n__-prdslib.enum [ "true", "false" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureIoTEdge@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "clusterConnection" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      applicationName =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      clusterConnection =
                                        _js2n__-prdslib.isType '"String",
                                      composeFilePath =
                                        _js2n__-prdslib.isType '"String",
                                      deployTimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      dockerRegistryConnection =
                                        _js2n__-prdslib.isType '"String",
                                      getStatusTimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      passwordEncrypted =
                                        _js2n__-prdslib.isType '"Bool",
                                      registryCredentials =
                                        _js2n__-prdslib.enum
                                            [
                                              "AzureResourceManagerEndpoint",
                                              "ContainerRegistryEndpoint",
                                              "UsernamePassword",
                                              "None"
                                            ],
                                      registryPassword =
                                        _js2n__-prdslib.isType '"String",
                                      registryUserName =
                                        _js2n__-prdslib.isType '"String",
                                      removeTimeoutSec =
                                        _js2n__-prdslib.isType '"String",
                                      upgrade = _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ServiceFabricComposeDeploy@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "files" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      files = _js2n__-prdslib.isType '"String",
                                      jarsign = _js2n__-prdslib.isType '"Bool",
                                      jarsignerArguments =
                                        _js2n__-prdslib.isType '"String",
                                      keyPass =
                                        _js2n__-prdslib.isType '"String",
                                      keystoreAlias =
                                        _js2n__-prdslib.isType '"String",
                                      keystoreFile =
                                        _js2n__-prdslib.isType '"String",
                                      keystorePass =
                                        _js2n__-prdslib.isType '"String",
                                      zipalign = _js2n__-prdslib.isType '"Bool",
                                      zipalignLocation =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AndroidSigning@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  apkFiles = _js2n__-prdslib.isType '"String",
                                  jarsign = _js2n__-prdslib.isType '"Bool",
                                  jarsignerArguments =
                                    _js2n__-prdslib.isType '"String",
                                  jarsignerKeyPassword =
                                    _js2n__-prdslib.isType '"String",
                                  jarsignerKeystoreAlias =
                                    _js2n__-prdslib.isType '"String",
                                  jarsignerKeystoreFile =
                                    _js2n__-prdslib.isType '"String",
                                  jarsignerKeystorePassword =
                                    _js2n__-prdslib.isType '"String",
                                  zipalign = _js2n__-prdslib.isType '"Bool",
                                  zipalignFile =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AndroidSigning@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  apkFiles = _js2n__-prdslib.isType '"String",
                                  apksign = _js2n__-prdslib.isType '"Bool",
                                  apksignerArguments =
                                    _js2n__-prdslib.isType '"String",
                                  apksignerFile =
                                    _js2n__-prdslib.isType '"String",
                                  apksignerKeyPassword =
                                    _js2n__-prdslib.isType '"String",
                                  apksignerKeystoreAlias =
                                    _js2n__-prdslib.isType '"String",
                                  apksignerKeystoreFile =
                                    _js2n__-prdslib.isType '"String",
                                  apksignerKeystorePassword =
                                    _js2n__-prdslib.isType '"String",
                                  apksignerVersion =
                                    _js2n__-prdslib.isType '"String",
                                  zipalign = _js2n__-prdslib.isType '"Bool",
                                  zipalignFile =
                                    _js2n__-prdslib.isType '"String",
                                  zipalignVersion =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AndroidSigning@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "targetPath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      artifactName =
                                        _js2n__-prdslib.isType '"String",
                                      pipelineId =
                                        _js2n__-prdslib.isType '"String",
                                      targetPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadPipelineArtifact@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  allowFailedBuilds =
                                    _js2n__-prdslib.isType '"Bool",
                                  allowPartiallySucceededBuilds =
                                    _js2n__-prdslib.isType '"Bool",
                                  artifactName =
                                    _js2n__-prdslib.isType '"String",
                                  branchName = _js2n__-prdslib.isType '"String",
                                  buildType =
                                    _js2n__-prdslib.enum
                                        [ "current", "specific" ],
                                  buildVersionToDownload =
                                    _js2n__-prdslib.enum
                                        [
                                          "latest",
                                          "latestFromBranch",
                                          "specific"
                                        ],
                                  definition = _js2n__-prdslib.isType '"String",
                                  itemPattern =
                                    _js2n__-prdslib.isType '"String",
                                  pipelineId = _js2n__-prdslib.isType '"String",
                                  project = _js2n__-prdslib.isType '"String",
                                  specificBuildWithTriggering =
                                    _js2n__-prdslib.isType '"Bool",
                                  tags = _js2n__-prdslib.isType '"String",
                                  targetPath = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadPipelineArtifact@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  artifactName =
                                    _js2n__-prdslib.isType '"String",
                                  branchName = _js2n__-prdslib.isType '"String",
                                  buildType =
                                    _js2n__-prdslib.enum
                                        [ "current", "specific" ],
                                  buildVersionToDownload =
                                    _js2n__-prdslib.enum
                                        [
                                          "latest",
                                          "latestFromBranch",
                                          "specific"
                                        ],
                                  itemPattern =
                                    _js2n__-prdslib.isType '"String",
                                  pipeline = _js2n__-prdslib.isType '"String",
                                  pipelineId = _js2n__-prdslib.isType '"String",
                                  project = _js2n__-prdslib.isType '"String",
                                  specificBuildWithTriggering =
                                    _js2n__-prdslib.isType '"Bool",
                                  tags = _js2n__-prdslib.isType '"String",
                                  targetPath = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadPipelineArtifact@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  addToPath = _js2n__-prdslib.isType '"Bool",
                                  allowUnstable =
                                    _js2n__-prdslib.isType '"Bool",
                                  architecture =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  disableDownloadFromRegistry =
                                    _js2n__-prdslib.isType '"Bool",
                                  githubToken =
                                    _js2n__-prdslib.isType '"String",
                                  versionSpec =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^UsePythonVersion@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "clusterConnection" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      Inline = _js2n__-prdslib.isType '"String",
                                      ScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      ScriptType =
                                        _js2n__-prdslib.enum
                                            [ "FilePath", "InlineScript" ],
                                      clusterConnection =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ServiceFabricPowerShell@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  batchingBasedOnAgentsOption =
                                    _js2n__-prdslib.enum
                                        [ "autoBatchSize", "customBatchSize" ],
                                  batchingBasedOnExecutionTimeOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "autoBatchSize",
                                          "customTimeBatchSize"
                                        ],
                                  codeCoverageEnabled =
                                    _js2n__-prdslib.isType '"Bool",
                                  collectDumpOn =
                                    _js2n__-prdslib.enum
                                        [ "onAbortOnly", "always", "never" ],
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  customBatchSizeValue =
                                    _js2n__-prdslib.isType '"String",
                                  customRunTimePerBatchValue =
                                    _js2n__-prdslib.isType '"String",
                                  diagnosticsEnabled =
                                    _js2n__-prdslib.isType '"Bool",
                                  distributionBatchType =
                                    _js2n__-prdslib.enum
                                        [
                                          "basedOnTestCases",
                                          "basedOnExecutionTime",
                                          "basedOnAssembly"
                                        ],
                                  dontDistribute =
                                    _js2n__-prdslib.isType '"Bool",
                                  failOnMinTestsNotRun =
                                    _js2n__-prdslib.isType '"Bool",
                                  minimumExpectedTests =
                                    _js2n__-prdslib.isType '"String",
                                  otherConsoleOptions =
                                    _js2n__-prdslib.isType '"String",
                                  overrideTestrunParameters =
                                    _js2n__-prdslib.isType '"String",
                                  pathtoCustomTestAdapters =
                                    _js2n__-prdslib.isType '"String",
                                  platform = _js2n__-prdslib.isType '"String",
                                  publishRunAttachments =
                                    _js2n__-prdslib.isType '"Bool",
                                  rerunFailedTestCasesMaxLimit =
                                    _js2n__-prdslib.isType '"String",
                                  rerunFailedTests =
                                    _js2n__-prdslib.isType '"Bool",
                                  rerunFailedThreshold =
                                    _js2n__-prdslib.isType '"String",
                                  rerunMaxAttempts =
                                    _js2n__-prdslib.isType '"String",
                                  rerunType =
                                    _js2n__-prdslib.enum
                                        [
                                          "basedOnTestFailurePercentage",
                                          "basedOnTestFailureCount"
                                        ],
                                  resultsFolder =
                                    _js2n__-prdslib.isType '"String",
                                  runAllTestsAfterXBuilds =
                                    _js2n__-prdslib.isType '"String",
                                  runInParallel =
                                    _js2n__-prdslib.isType '"Bool",
                                  runOnlyImpactedTests =
                                    _js2n__-prdslib.isType '"Bool",
                                  runSettingsFile =
                                    _js2n__-prdslib.isType '"String",
                                  runTestsInIsolation =
                                    _js2n__-prdslib.isType '"Bool",
                                  searchFolder =
                                    _js2n__-prdslib.isType '"String",
                                  tcmTestRun = _js2n__-prdslib.isType '"String",
                                  testAssemblyVer2 =
                                    _js2n__-prdslib.isType '"String",
                                  testConfiguration =
                                    _js2n__-prdslib.isType '"String",
                                  testFiltercriteria =
                                    _js2n__-prdslib.isType '"String",
                                  testPlan = _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  testSelector =
                                    _js2n__-prdslib.enum
                                        [
                                          "testAssemblies",
                                          "testPlan",
                                          "testRun"
                                        ],
                                  testSuite = _js2n__-prdslib.isType '"String",
                                  uiTests = _js2n__-prdslib.isType '"Bool",
                                  vsTestVersion =
                                    _js2n__-prdslib.enum
                                        [
                                          "latest",
                                          "17.0",
                                          "16.0",
                                          "15.0",
                                          "14.0",
                                          "toolsInstaller"
                                        ],
                                  vstestLocation =
                                    _js2n__-prdslib.isType '"String",
                                  vstestLocationMethod =
                                    _js2n__-prdslib.enum
                                        [ "version", "location" ],
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^VSTest@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  azureSubscription =
                                    _js2n__-prdslib.isType '"String",
                                  batchingBasedOnAgentsOption =
                                    _js2n__-prdslib.enum
                                        [ "autoBatchSize", "customBatchSize" ],
                                  batchingBasedOnExecutionTimeOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "autoBatchSize",
                                          "customTimeBatchSize"
                                        ],
                                  codeCoverageEnabled =
                                    _js2n__-prdslib.isType '"Bool",
                                  collectDumpOn =
                                    _js2n__-prdslib.enum
                                        [ "onAbortOnly", "always", "never" ],
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  customBatchSizeValue =
                                    _js2n__-prdslib.isType '"String",
                                  customRunTimePerBatchValue =
                                    _js2n__-prdslib.isType '"String",
                                  diagnosticsEnabled =
                                    _js2n__-prdslib.isType '"Bool",
                                  distributionBatchType =
                                    _js2n__-prdslib.enum
                                        [
                                          "basedOnTestCases",
                                          "basedOnExecutionTime",
                                          "basedOnAssembly"
                                        ],
                                  dontDistribute =
                                    _js2n__-prdslib.isType '"Bool",
                                  failOnMinTestsNotRun =
                                    _js2n__-prdslib.isType '"Bool",
                                  minimumExpectedTests =
                                    _js2n__-prdslib.isType '"String",
                                  otherConsoleOptions =
                                    _js2n__-prdslib.isType '"String",
                                  overrideTestrunParameters =
                                    _js2n__-prdslib.isType '"String",
                                  pathtoCustomTestAdapters =
                                    _js2n__-prdslib.isType '"String",
                                  platform = _js2n__-prdslib.isType '"String",
                                  publishRunAttachments =
                                    _js2n__-prdslib.isType '"Bool",
                                  rerunFailedTestCasesMaxLimit =
                                    _js2n__-prdslib.isType '"String",
                                  rerunFailedTests =
                                    _js2n__-prdslib.isType '"Bool",
                                  rerunFailedThreshold =
                                    _js2n__-prdslib.isType '"String",
                                  rerunMaxAttempts =
                                    _js2n__-prdslib.isType '"String",
                                  rerunType =
                                    _js2n__-prdslib.enum
                                        [
                                          "basedOnTestFailurePercentage",
                                          "basedOnTestFailureCount"
                                        ],
                                  resultsFolder =
                                    _js2n__-prdslib.isType '"String",
                                  runAllTestsAfterXBuilds =
                                    _js2n__-prdslib.isType '"String",
                                  runInParallel =
                                    _js2n__-prdslib.isType '"Bool",
                                  runOnlyImpactedTests =
                                    _js2n__-prdslib.isType '"Bool",
                                  runSettingsFile =
                                    _js2n__-prdslib.isType '"String",
                                  runTestsInIsolation =
                                    _js2n__-prdslib.isType '"Bool",
                                  searchFolder =
                                    _js2n__-prdslib.isType '"String",
                                  tcmTestRun = _js2n__-prdslib.isType '"String",
                                  testAssemblyVer2 =
                                    _js2n__-prdslib.isType '"String",
                                  testConfiguration =
                                    _js2n__-prdslib.isType '"String",
                                  testFiltercriteria =
                                    _js2n__-prdslib.isType '"String",
                                  testPlan = _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  testSelector =
                                    _js2n__-prdslib.enum
                                        [
                                          "testAssemblies",
                                          "testPlan",
                                          "testRun"
                                        ],
                                  testSuite = _js2n__-prdslib.isType '"String",
                                  uiTests = _js2n__-prdslib.isType '"Bool",
                                  vsTestVersion =
                                    _js2n__-prdslib.enum
                                        [
                                          "latest",
                                          "17.0",
                                          "16.0",
                                          "15.0",
                                          "14.0",
                                          "toolsInstaller"
                                        ],
                                  vstestLocation =
                                    _js2n__-prdslib.isType '"String",
                                  vstestLocationMethod =
                                    _js2n__-prdslib.enum
                                        [ "version", "location" ],
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^VSTest@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  codeCoverageEnabled =
                                    _js2n__-prdslib.isType '"Bool",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  otherConsoleOptions =
                                    _js2n__-prdslib.isType '"String",
                                  overrideTestrunParameters =
                                    _js2n__-prdslib.isType '"String",
                                  pathtoCustomTestAdapters =
                                    _js2n__-prdslib.isType '"String",
                                  platform = _js2n__-prdslib.isType '"String",
                                  publishRunAttachments =
                                    _js2n__-prdslib.isType '"Bool",
                                  runInParallel =
                                    _js2n__-prdslib.isType '"Bool",
                                  runSettingsFile =
                                    _js2n__-prdslib.isType '"String",
                                  testAssembly =
                                    _js2n__-prdslib.isType '"String",
                                  testFiltercriteria =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  vsTestVersion =
                                    _js2n__-prdslib.enum
                                        [ "latest", "14.0", "12.0" ],
                                  vstestLocation =
                                    _js2n__-prdslib.isType '"String",
                                  vstestLocationMethod =
                                    _js2n__-prdslib.enum
                                        [ "version", "location" ],
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^VSTest@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "notifyUsers" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      allowApproversToApproveTheirOwnRuns =
                                        _js2n__-prdslib.isType '"Bool",
                                      approvers =
                                        _js2n__-prdslib.isType '"String",
                                      instructions =
                                        _js2n__-prdslib.isType '"String",
                                      notifyUsers =
                                        _js2n__-prdslib.isType '"String",
                                      onTimeout =
                                        _js2n__-prdslib.enum
                                            [ "reject", "resume" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ManualValidation@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "notifyUsers" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      instructions =
                                        _js2n__-prdslib.isType '"String",
                                      notifyUsers =
                                        _js2n__-prdslib.isType '"String",
                                      onTimeout =
                                        _js2n__-prdslib.enum
                                            [ "reject", "resume" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^ManualValidation@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  antHomeDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  buildFile = _js2n__-prdslib.isType '"String",
                                  codeCoverageClassFilesDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageClassFilter =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageFailIfEmpty =
                                    _js2n__-prdslib.isType '"Bool",
                                  codeCoverageSourceDirectories =
                                    _js2n__-prdslib.isType '"String",
                                  codeCoverageToolOptions =
                                    _js2n__-prdslib.enum
                                        [ "None", "Cobertura", "JaCoCo" ],
                                  javaHomeOption =
                                    _js2n__-prdslib.enum
                                        [ "JDKVersion", "Path" ],
                                  jdkArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  jdkUserInputDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  jdkVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "1.11",
                                          "1.10",
                                          "1.9",
                                          "1.8",
                                          "1.7",
                                          "1.6"
                                        ],
                                  options = _js2n__-prdslib.isType '"String",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  targets = _js2n__-prdslib.isType '"String",
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Ant@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "adminPassword",
                                      "adminUserName",
                                      "machinePassword",
                                      "machineUserName",
                                      "testMachines"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      adminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      adminUserName =
                                        _js2n__-prdslib.isType '"String",
                                      agentLocation =
                                        _js2n__-prdslib.isType '"String",
                                      isDataCollectionOnly =
                                        _js2n__-prdslib.isType '"Bool",
                                      machinePassword =
                                        _js2n__-prdslib.isType '"String",
                                      machineUserName =
                                        _js2n__-prdslib.isType '"String",
                                      runAsProcess =
                                        _js2n__-prdslib.isType '"Bool",
                                      testCertificate =
                                        _js2n__-prdslib.isType '"Bool",
                                      testMachines =
                                        _js2n__-prdslib.isType '"String",
                                      testPlatform =
                                        _js2n__-prdslib.enum [ "15.0", "14.0" ],
                                      updateTestAgent =
                                        _js2n__-prdslib.isType '"Bool",
                                      winRmProtocol =
                                        _js2n__-prdslib.enum
                                            [ "Http", "Https" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DeployVisualStudioTestAgent@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "machinePassword",
                                      "machineUserName",
                                      "testMachineGroup"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      adminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      adminUserName =
                                        _js2n__-prdslib.isType '"String",
                                      agentLocation =
                                        _js2n__-prdslib.isType '"String",
                                      isDataCollectionOnly =
                                        _js2n__-prdslib.isType '"Bool",
                                      machinePassword =
                                        _js2n__-prdslib.isType '"String",
                                      machineUserName =
                                        _js2n__-prdslib.isType '"String",
                                      resourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      runAsProcess =
                                        _js2n__-prdslib.isType '"Bool",
                                      testCertificate =
                                        _js2n__-prdslib.isType '"Bool",
                                      testMachineGroup =
                                        _js2n__-prdslib.isType '"String",
                                      testMachines =
                                        _js2n__-prdslib.isType '"String",
                                      updateTestAgent =
                                        _js2n__-prdslib.isType '"Bool",
                                      winRmProtocol =
                                        _js2n__-prdslib.enum
                                            [ "Http", "Https" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DeployVisualStudioTestAgent@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "environmentName" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      cleanEnvironment =
                                        _js2n__-prdslib.isType '"Bool",
                                      createOptions =
                                        _js2n__-prdslib.isType '"String",
                                      environmentName =
                                        _js2n__-prdslib.isType '"String",
                                      packageSpecs =
                                        _js2n__-prdslib.isType '"String",
                                      updateConda =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^CondaEnvironment@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  cleanEnvironment =
                                    _js2n__-prdslib.isType '"Bool",
                                  createCustomEnvironment =
                                    _js2n__-prdslib.isType '"Bool",
                                  createOptions =
                                    _js2n__-prdslib.isType '"String",
                                  environmentName =
                                    _js2n__-prdslib.isType '"String",
                                  installOptions =
                                    _js2n__-prdslib.isType '"String",
                                  packageSpecs =
                                    _js2n__-prdslib.isType '"String",
                                  updateConda = _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^CondaEnvironment@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "filename" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      arguments =
                                        _js2n__-prdslib.isType '"String",
                                      failOnStandardError =
                                        _js2n__-prdslib.isType '"Bool",
                                      filename =
                                        _js2n__-prdslib.isType '"String",
                                      modifyEnvironment =
                                        _js2n__-prdslib.isType '"Bool",
                                      workingFolder =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^BatchScript@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "externalRegistryCredentials",
                                      "packageName",
                                      "version"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      externalRegistryCredentials =
                                        _js2n__-prdslib.isType '"String",
                                      installDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      packageName =
                                        _js2n__-prdslib.isType '"String",
                                      version =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadGithubNpmPackage@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  clean = _js2n__-prdslib.isType '"Bool",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  createLogFile =
                                    _js2n__-prdslib.isType '"Bool",
                                  customVersion =
                                    _js2n__-prdslib.isType '"String",
                                  enableDefaultLogger =
                                    _js2n__-prdslib.isType '"Bool",
                                  logFileVerbosity =
                                    _js2n__-prdslib.enum
                                        [
                                          "quiet",
                                          "minimal",
                                          "normal",
                                          "detailed",
                                          "diagnostic"
                                        ],
                                  logProjectEvents =
                                    _js2n__-prdslib.isType '"Bool",
                                  maximumCpuCount =
                                    _js2n__-prdslib.isType '"Bool",
                                  msbuildArchitecture =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  msbuildArgs =
                                    _js2n__-prdslib.isType '"String",
                                  platform = _js2n__-prdslib.isType '"String",
                                  restoreNugetPackages =
                                    _js2n__-prdslib.isType '"Bool",
                                  solution = _js2n__-prdslib.isType '"String",
                                  vsVersion =
                                    _js2n__-prdslib.enum
                                        [
                                          "latest",
                                          "17.0",
                                          "16.0",
                                          "15.0",
                                          "14.0",
                                          "12.0",
                                          "11.0"
                                        ],
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^VSBuild@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "KeyVaultName", "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      KeyVaultName =
                                        _js2n__-prdslib.isType '"String",
                                      RunAsPreJob =
                                        _js2n__-prdslib.isType '"Bool",
                                      SecretsFilter =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureKeyVault@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "KeyVaultName", "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      KeyVaultName =
                                        _js2n__-prdslib.isType '"String",
                                      RunAsPreJob =
                                        _js2n__-prdslib.isType '"Bool",
                                      SecretsFilter =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureKeyVault@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  includePreviewVersions =
                                    _js2n__-prdslib.isType '"Bool",
                                  installationPath =
                                    _js2n__-prdslib.isType '"String",
                                  packageType =
                                    _js2n__-prdslib.enum [ "runtime", "sdk" ],
                                  performMultiLevelLookup =
                                    _js2n__-prdslib.isType '"Bool",
                                  requestTimeout =
                                    _js2n__-prdslib.isType 'Integer,
                                  useGlobalJson =
                                    _js2n__-prdslib.isType '"Bool",
                                  version = _js2n__-prdslib.isType '"String",
                                  vsVersion = _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^UseDotNet@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  packageType =
                                    _js2n__-prdslib.enum [ "runtime", "sdk" ],
                                  version = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DotNetCoreInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  includePreviewVersions =
                                    _js2n__-prdslib.isType '"Bool",
                                  installationPath =
                                    _js2n__-prdslib.isType '"String",
                                  packageType =
                                    _js2n__-prdslib.enum [ "runtime", "sdk" ],
                                  performMultiLevelLookup =
                                    _js2n__-prdslib.isType '"Bool",
                                  version = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DotNetCoreInstaller@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "AppConfigurationEndpoint",
                                      "ConfigurationFile",
                                      "azureSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AppConfigurationEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      ConfigurationFile =
                                        _js2n__-prdslib.isType '"String",
                                      ContentType =
                                        _js2n__-prdslib.isType '"String",
                                      Depth = _js2n__-prdslib.isType '"String",
                                      DryRun = _js2n__-prdslib.isType '"Bool",
                                      ExcludeFeatureFlags =
                                        _js2n__-prdslib.isType '"Bool",
                                      FileContentProfile =
                                        _js2n__-prdslib.enum
                                            [
                                              "appconfig/default",
                                              "appconfig/kvset"
                                            ],
                                      FileFormat =
                                        _js2n__-prdslib.enum
                                            [ "json", "yaml", "properties" ],
                                      ImportMode =
                                        _js2n__-prdslib.enum
                                            [ "All", "Ignore-Match" ],
                                      Label = _js2n__-prdslib.isType '"String",
                                      Prefix = _js2n__-prdslib.isType '"String",
                                      Separator =
                                        _js2n__-prdslib.enum
                                            [
                                              ".",
                                              "/",
                                              ":",
                                              ";",
                                              ",",
                                              "-",
                                              "_",
                                              "__"
                                            ],
                                      Strict = _js2n__-prdslib.isType '"Bool",
                                      Tags = _js2n__-prdslib.isType '"String",
                                      UseFilePathExtension =
                                        _js2n__-prdslib.isType '"Bool",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureAppConfigurationImport@10$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "WebAppName", "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      Action =
                                        _js2n__-prdslib.enum
                                            [
                                              "Swap Slots",
                                              "Start Azure App Service",
                                              "Stop Azure App Service",
                                              "Restart Azure App Service",
                                              "Start Swap With Preview",
                                              "Complete Swap",
                                              "Cancel Swap",
                                              "Delete Slot",
                                              "Install Extensions",
                                              "Enable Continuous Monitoring",
                                              "Start all continuous webjobs",
                                              "Stop all continuous webjobs"
                                            ],
                                      AppInsightsResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      ApplicationInsightsResourceName =
                                        _js2n__-prdslib.isType '"String",
                                      ApplicationInsightsWebTestName =
                                        _js2n__-prdslib.isType '"String",
                                      ExtensionsList =
                                        _js2n__-prdslib.isType '"String",
                                      OutputVariable =
                                        _js2n__-prdslib.isType '"String",
                                      PreserveVnet =
                                        _js2n__-prdslib.isType '"Bool",
                                      ResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      Slot = _js2n__-prdslib.isType '"String",
                                      SourceSlot =
                                        _js2n__-prdslib.isType '"String",
                                      SpecifySlotOrASE =
                                        _js2n__-prdslib.isType '"Bool",
                                      SwapWithProduction =
                                        _js2n__-prdslib.isType '"Bool",
                                      TargetSlot =
                                        _js2n__-prdslib.isType '"String",
                                      WebAppName =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureAppServiceManage@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  kubeloginVersion =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^KubeloginInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                { version = _js2n__-prdslib.isType '"String", }
                                {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^FuncToolsInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  enableXmlTransform =
                                    _js2n__-prdslib.isType '"Bool",
                                  folderPath = _js2n__-prdslib.isType '"String",
                                  jsonTargetFiles =
                                    _js2n__-prdslib.isType '"String",
                                  xmlTargetFiles =
                                    _js2n__-prdslib.isType '"String",
                                  xmlTransformationRules =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^FileTransform@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  enableXmlTransform =
                                    _js2n__-prdslib.isType '"Bool",
                                  fileType =
                                    _js2n__-prdslib.enum [ "xml", "json" ],
                                  folderPath = _js2n__-prdslib.isType '"String",
                                  targetFiles =
                                    _js2n__-prdslib.isType '"String",
                                  xmlTransformationRules =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^FileTransform@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "destinationFolder" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      archiveFilePatterns =
                                        _js2n__-prdslib.isType '"String",
                                      cleanDestinationFolder =
                                        _js2n__-prdslib.isType '"Bool",
                                      destinationFolder =
                                        _js2n__-prdslib.isType '"String",
                                      overwriteExistingFiles =
                                        _js2n__-prdslib.isType '"Bool",
                                      pathToSevenZipTool =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^ExtractFiles@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  clean = _js2n__-prdslib.isType '"Bool",
                                  configuration =
                                    _js2n__-prdslib.isType '"String",
                                  createAppPackage =
                                    _js2n__-prdslib.isType '"Bool",
                                  jdkArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  jdkDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  jdkOption =
                                    _js2n__-prdslib.enum
                                        [ "JDKVersion", "Path" ],
                                  jdkVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "default",
                                          "1.11",
                                          "1.10",
                                          "1.9",
                                          "1.8",
                                          "1.7",
                                          "1.6"
                                        ],
                                  msbuildArchitectureOption =
                                    _js2n__-prdslib.enum [ "x86", "x64" ],
                                  msbuildArguments =
                                    _js2n__-prdslib.isType '"String",
                                  msbuildFile =
                                    _js2n__-prdslib.isType '"String",
                                  msbuildLocationOption =
                                    _js2n__-prdslib.enum
                                        [ "version", "location" ],
                                  msbuildVersionOption =
                                    _js2n__-prdslib.enum
                                        [
                                          "latest",
                                          "17.0",
                                          "16.0",
                                          "15.0",
                                          "14.0",
                                          "12.0",
                                          "4.0"
                                        ],
                                  outputDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  projectFile =
                                    _js2n__-prdslib.isType '"String",
                                  target = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^XamarinAndroid@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "ArtifactName",
                                      "ArtifactType",
                                      "Contents"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ArtifactName =
                                        _js2n__-prdslib.isType '"String",
                                      ArtifactType =
                                        _js2n__-prdslib.enum
                                            [ "Container", "FilePath" ],
                                      Contents =
                                        _js2n__-prdslib.isType '"String",
                                      CopyRoot =
                                        _js2n__-prdslib.isType '"String",
                                      TargetPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^CopyPublishBuildArtifacts@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "definition", "feed", "version" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      definition =
                                        _js2n__-prdslib.isType '"String",
                                      downloadPath =
                                        _js2n__-prdslib.isType '"String",
                                      feed = _js2n__-prdslib.isType '"String",
                                      version =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadPackage@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "definition", "feed", "version" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      definition =
                                        _js2n__-prdslib.isType '"String",
                                      downloadPath =
                                        _js2n__-prdslib.isType '"String",
                                      extract = _js2n__-prdslib.isType '"Bool",
                                      feed = _js2n__-prdslib.isType '"String",
                                      files = _js2n__-prdslib.isType '"String",
                                      packageType =
                                        _js2n__-prdslib.enum
                                            [
                                              "maven",
                                              "npm",
                                              "nuget",
                                              "pypi",
                                              "upack",
                                              "cargo"
                                            ],
                                      version =
                                        _js2n__-prdslib.isType '"String",
                                      view = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadPackage@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "azureSubscription",
                                      "resourceGroupName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      action =
                                        _js2n__-prdslib.enum
                                            [
                                              "Create Or Update Resource Group",
                                              "Select Resource Group",
                                              "Start",
                                              "Stop",
                                              "StopWithDeallocate",
                                              "Restart",
                                              "Delete",
                                              "DeleteRG"
                                            ],
                                      addSpnToEnvironment =
                                        _js2n__-prdslib.isType '"Bool",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      copyAzureVMTags =
                                        _js2n__-prdslib.isType '"Bool",
                                      csmFile =
                                        _js2n__-prdslib.isType '"String",
                                      csmFileLink =
                                        _js2n__-prdslib.isType '"String",
                                      csmParametersFile =
                                        _js2n__-prdslib.isType '"String",
                                      csmParametersFileLink =
                                        _js2n__-prdslib.isType '"String",
                                      deploymentGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      deploymentMode =
                                        _js2n__-prdslib.enum
                                            [
                                              "Incremental",
                                              "Complete",
                                              "Validation"
                                            ],
                                      deploymentName =
                                        _js2n__-prdslib.isType '"String",
                                      deploymentOutputs =
                                        _js2n__-prdslib.isType '"String",
                                      enableDeploymentPrerequisites =
                                        _js2n__-prdslib.enum
                                            [
                                              "None",
                                              "ConfigureVMwithWinRM",
                                              "ConfigureVMWithDGAgent"
                                            ],
                                      location =
                                        _js2n__-prdslib.isType '"String",
                                      outputVariable =
                                        _js2n__-prdslib.isType '"String",
                                      overrideParameters =
                                        _js2n__-prdslib.isType '"String",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      runAgentServiceAsUser =
                                        _js2n__-prdslib.isType '"Bool",
                                      teamProject =
                                        _js2n__-prdslib.isType '"String",
                                      teamServicesConnection =
                                        _js2n__-prdslib.isType '"String",
                                      templateLocation =
                                        _js2n__-prdslib.enum
                                            [
                                              "Linked artifact",
                                              "URL of the file"
                                            ],
                                      useWithoutJSON =
                                        _js2n__-prdslib.isType '"Bool",
                                      userName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureResourceGroupDeployment@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  ConnectedServiceName =
                                    _js2n__-prdslib.isType '"String",
                                  ConnectedServiceNameClassic =
                                    _js2n__-prdslib.isType '"String",
                                  ConnectedServiceNameSelector =
                                    _js2n__-prdslib.enum
                                        [
                                          "ConnectedServiceName",
                                          "ConnectedServiceNameClassic"
                                        ],
                                  action =
                                    _js2n__-prdslib.enum
                                        [
                                          "Create Or Update Resource Group",
                                          "Select Resource Group",
                                          "Start",
                                          "Stop",
                                          "Restart",
                                          "Delete",
                                          "DeleteRG"
                                        ],
                                  actionClassic =
                                    _js2n__-prdslib.enum
                                        [ "Select Resource Group" ],
                                  cloudService =
                                    _js2n__-prdslib.isType '"String",
                                  csmFile = _js2n__-prdslib.isType '"String",
                                  csmParametersFile =
                                    _js2n__-prdslib.isType '"String",
                                  deploymentMode =
                                    _js2n__-prdslib.enum
                                        [
                                          "Validation",
                                          "Incremental",
                                          "Complete"
                                        ],
                                  enableDeploymentPrerequisitesForCreate =
                                    _js2n__-prdslib.isType '"Bool",
                                  enableDeploymentPrerequisitesForSelect =
                                    _js2n__-prdslib.isType '"Bool",
                                  location =
                                    _js2n__-prdslib.enum
                                        [
                                          "Australia East",
                                          "Australia Southeast",
                                          "Brazil South",
                                          "Canada Central",
                                          "Canada East",
                                          "Central India",
                                          "Central US",
                                          "East Asia",
                                          "East US",
                                          "East US 2 ",
                                          "Japan East",
                                          "Japan West",
                                          "North Central US",
                                          "North Europe",
                                          "South Central US",
                                          "South India",
                                          "Southeast Asia",
                                          "UK South",
                                          "UK West",
                                          "West Central US",
                                          "West Europe",
                                          "West India",
                                          "West US",
                                          "West US 2"
                                        ],
                                  outputVariable =
                                    _js2n__-prdslib.isType '"String",
                                  overrideParameters =
                                    _js2n__-prdslib.isType '"String",
                                  resourceGroupName =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureResourceGroupDeployment@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureResourceManagerConnection" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      action =
                                        _js2n__-prdslib.enum
                                            [
                                              "Create Or Update Resource Group",
                                              "DeleteRG"
                                            ],
                                      addSpnToEnvironment =
                                        _js2n__-prdslib.isType '"Bool",
                                      azureResourceManagerConnection =
                                        _js2n__-prdslib.isType '"String",
                                      csmFile =
                                        _js2n__-prdslib.isType '"String",
                                      csmFileLink =
                                        _js2n__-prdslib.isType '"String",
                                      csmParametersFile =
                                        _js2n__-prdslib.isType '"String",
                                      csmParametersFileLink =
                                        _js2n__-prdslib.isType '"String",
                                      deploymentMode =
                                        _js2n__-prdslib.enum
                                            [
                                              "Incremental",
                                              "Complete",
                                              "Validation"
                                            ],
                                      deploymentName =
                                        _js2n__-prdslib.isType '"String",
                                      deploymentOutputs =
                                        _js2n__-prdslib.isType '"String",
                                      deploymentScope =
                                        _js2n__-prdslib.enum
                                            [
                                              "Management Group",
                                              "Subscription",
                                              "Resource Group"
                                            ],
                                      location =
                                        _js2n__-prdslib.isType '"String",
                                      overrideParameters =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      subscriptionId =
                                        _js2n__-prdslib.isType '"String",
                                      templateLocation =
                                        _js2n__-prdslib.enum
                                            [
                                              "Linked artifact",
                                              "URL of the file"
                                            ],
                                      useWithoutJSON =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureResourceManagerTemplateDeployment@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "serviceConnection" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      body = _js2n__-prdslib.isType '"String",
                                      headers =
                                        _js2n__-prdslib.isType '"String",
                                      method =
                                        _js2n__-prdslib.enum
                                            [
                                              "OPTIONS",
                                              "GET",
                                              "HEAD",
                                              "POST",
                                              "PUT",
                                              "DELETE",
                                              "TRACE",
                                              "PATCH"
                                            ],
                                      serviceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      successCriteria =
                                        _js2n__-prdslib.isType '"String",
                                      urlSuffix =
                                        _js2n__-prdslib.isType '"String",
                                      waitForCompletion =
                                        _js2n__-prdslib.enum
                                            [ "true", "false" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^InvokeRESTAPI@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  azureServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                  body = _js2n__-prdslib.isType '"String",
                                  connectionType =
                                    _js2n__-prdslib.enum
                                        [
                                          "connectedServiceName",
                                          "connectedServiceNameARM"
                                        ],
                                  headers = _js2n__-prdslib.isType '"String",
                                  method =
                                    _js2n__-prdslib.enum
                                        [
                                          "OPTIONS",
                                          "GET",
                                          "HEAD",
                                          "POST",
                                          "PUT",
                                          "DELETE",
                                          "TRACE",
                                          "PATCH"
                                        ],
                                  serviceConnection =
                                    _js2n__-prdslib.isType '"String",
                                  successCriteria =
                                    _js2n__-prdslib.isType '"String",
                                  urlSuffix = _js2n__-prdslib.isType '"String",
                                  waitForCompletion =
                                    _js2n__-prdslib.enum [ "true", "false" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^InvokeRESTAPI@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  archiveFile =
                                    _js2n__-prdslib.isType '"String",
                                  archiveType =
                                    _js2n__-prdslib.enum
                                        [ "zip", "7z", "tar", "wim" ],
                                  includeRootFolder =
                                    _js2n__-prdslib.isType '"Bool",
                                  quiet = _js2n__-prdslib.isType '"Bool",
                                  replaceExistingArchive =
                                    _js2n__-prdslib.isType '"Bool",
                                  rootFolderOrFile =
                                    _js2n__-prdslib.isType '"String",
                                  sevenZipCompression =
                                    _js2n__-prdslib.enum
                                        [
                                          "ultra",
                                          "maximum",
                                          "normal",
                                          "fast",
                                          "fastest",
                                          "none"
                                        ],
                                  tarCompression =
                                    _js2n__-prdslib.enum
                                        [ "gz", "bz2", "xz", "none" ],
                                  verbose = _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^ArchiveFiles@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  archiveFile =
                                    _js2n__-prdslib.isType '"String",
                                  archiveType =
                                    _js2n__-prdslib.enum
                                        [ "default", "7z", "tar", "wim" ],
                                  includeRootFolder =
                                    _js2n__-prdslib.isType '"Bool",
                                  replaceExistingArchive =
                                    _js2n__-prdslib.isType '"Bool",
                                  rootFolder = _js2n__-prdslib.isType '"String",
                                  tarCompression =
                                    _js2n__-prdslib.enum
                                        [ "gz", "bz2", "xz", "none" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^ArchiveFiles@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "gitHubConnection" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      comment =
                                        _js2n__-prdslib.isType '"String",
                                      gitHubConnection =
                                        _js2n__-prdslib.isType '"String",
                                      id = _js2n__-prdslib.isType '"String",
                                      repositoryName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^GitHubComment@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "TargetFolder" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      CleanTargetFolder =
                                        _js2n__-prdslib.isType '"Bool",
                                      Contents =
                                        _js2n__-prdslib.isType '"String",
                                      OverWrite =
                                        _js2n__-prdslib.isType '"Bool",
                                      SourceFolder =
                                        _js2n__-prdslib.isType '"String",
                                      TargetFolder =
                                        _js2n__-prdslib.isType '"String",
                                      delayBetweenRetries =
                                        _js2n__-prdslib.isType '"String",
                                      flattenFolders =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreMakeDirErrors =
                                        _js2n__-prdslib.isType '"Bool",
                                      preserveTimestamp =
                                        _js2n__-prdslib.isType '"Bool",
                                      retryCount =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^CopyFiles@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "TargetFolder" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      CleanTargetFolder =
                                        _js2n__-prdslib.isType '"Bool",
                                      Contents =
                                        _js2n__-prdslib.isType '"String",
                                      OverWrite =
                                        _js2n__-prdslib.isType '"Bool",
                                      SourceFolder =
                                        _js2n__-prdslib.isType '"String",
                                      TargetFolder =
                                        _js2n__-prdslib.isType '"String",
                                      flattenFolders =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^CopyFiles@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "ServerName",
                                      "SqlPassword",
                                      "SqlUsername",
                                      "azureSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      DatabaseName =
                                        _js2n__-prdslib.isType '"String",
                                      DeleteFirewallRule =
                                        _js2n__-prdslib.isType '"Bool",
                                      EndIpAddress =
                                        _js2n__-prdslib.isType '"String",
                                      IpDetectionMethod =
                                        _js2n__-prdslib.enum
                                            [ "AutoDetect", "IPAddressRange" ],
                                      ServerName =
                                        _js2n__-prdslib.isType '"String",
                                      SqlAdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      SqlFile =
                                        _js2n__-prdslib.isType '"String",
                                      SqlInline =
                                        _js2n__-prdslib.isType '"String",
                                      SqlPassword =
                                        _js2n__-prdslib.isType '"String",
                                      SqlUsername =
                                        _js2n__-prdslib.isType '"String",
                                      StartIpAddress =
                                        _js2n__-prdslib.isType '"String",
                                      TaskNameSelector =
                                        _js2n__-prdslib.enum
                                            [ "SqlTaskFile", "InlineSqlTask" ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureMysqlDeployment@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  command =
                                    _js2n__-prdslib.enum
                                        [
                                          "ci",
                                          "install",
                                          "publish",
                                          "custom"
                                        ],
                                  customCommand =
                                    _js2n__-prdslib.isType '"String",
                                  customEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  customFeed = _js2n__-prdslib.isType '"String",
                                  customRegistry =
                                    _js2n__-prdslib.enum
                                        [ "useNpmrc", "useFeed" ],
                                  publishEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  publishFeed =
                                    _js2n__-prdslib.isType '"String",
                                  publishPackageMetadata =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishRegistry =
                                    _js2n__-prdslib.enum
                                        [ "useExternalRegistry", "useFeed" ],
                                  verbose = _js2n__-prdslib.isType '"Bool",
                                  workingDir = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Npm@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  command = _js2n__-prdslib.isType '"String",
                                  cwd = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Npm@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  api_build_command =
                                    _js2n__-prdslib.isType '"String",
                                  api_location =
                                    _js2n__-prdslib.isType '"String",
                                  app_build_command =
                                    _js2n__-prdslib.isType '"String",
                                  app_location =
                                    _js2n__-prdslib.isType '"String",
                                  azure_access_token =
                                    _js2n__-prdslib.isType '"String",
                                  azure_static_web_apps_api_token =
                                    _js2n__-prdslib.isType '"String",
                                  build_timeout_in_minutes =
                                    _js2n__-prdslib.isType 'Integer,
                                  config_file_location =
                                    _js2n__-prdslib.isType '"String",
                                  data_api_location =
                                    _js2n__-prdslib.isType '"String",
                                  default_hostname =
                                    _js2n__-prdslib.isType '"String",
                                  deployment_environment =
                                    _js2n__-prdslib.isType '"String",
                                  is_static_export =
                                    _js2n__-prdslib.isType '"Bool",
                                  output_location =
                                    _js2n__-prdslib.isType '"String",
                                  production_branch =
                                    _js2n__-prdslib.isType '"String",
                                  routes_location =
                                    _js2n__-prdslib.isType '"String",
                                  skip_api_build =
                                    _js2n__-prdslib.isType '"Bool",
                                  skip_app_build =
                                    _js2n__-prdslib.isType '"Bool",
                                  verbose = _js2n__-prdslib.isType '"Bool",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureStaticWebApp@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkLatest = _js2n__-prdslib.isType '"Bool",
                                  delayBetweenRetries =
                                    _js2n__-prdslib.isType '"String",
                                  force32bit = _js2n__-prdslib.isType '"Bool",
                                  retryCountOnDownloadFails =
                                    _js2n__-prdslib.isType '"String",
                                  version = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^UseNode@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  checkLatest = _js2n__-prdslib.isType '"Bool",
                                  delayBetweenRetries =
                                    _js2n__-prdslib.isType '"String",
                                  force32bit = _js2n__-prdslib.isType '"Bool",
                                  nodejsMirror =
                                    _js2n__-prdslib.isType '"String",
                                  retryCountOnDownloadFails =
                                    _js2n__-prdslib.isType '"String",
                                  versionFilePath =
                                    _js2n__-prdslib.isType '"String",
                                  versionSource =
                                    _js2n__-prdslib.enum [ "spec", "fromFile" ],
                                  versionSpec =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^NodeTool@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "DacpacFile", "EnvironmentName" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      AdminPassword =
                                        _js2n__-prdslib.isType '"String",
                                      AdminUserName =
                                        _js2n__-prdslib.isType '"String",
                                      ConnectionString =
                                        _js2n__-prdslib.isType '"String",
                                      DacpacFile =
                                        _js2n__-prdslib.isType '"String",
                                      DatabaseName =
                                        _js2n__-prdslib.isType '"String",
                                      DeployInParallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      EnvironmentName =
                                        _js2n__-prdslib.isType '"String",
                                      MachineFilter =
                                        _js2n__-prdslib.isType '"String",
                                      Protocol =
                                        _js2n__-prdslib.enum
                                            [ "Http", "Https" ],
                                      PublishProfile =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceFilteringMethod =
                                        _js2n__-prdslib.enum
                                            [ "machineNames", "tags" ],
                                      ServerName =
                                        _js2n__-prdslib.isType '"String",
                                      SqlPassword =
                                        _js2n__-prdslib.isType '"String",
                                      SqlUsername =
                                        _js2n__-prdslib.isType '"String",
                                      TargetMethod =
                                        _js2n__-prdslib.enum
                                            [
                                              "server",
                                              "connectionString",
                                              "publishProfile"
                                            ],
                                      TestCertificate =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^SqlServerDacpacDeployment@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  customFeed = _js2n__-prdslib.isType '"String",
                                  netShare = _js2n__-prdslib.isType '"String",
                                  packageFeedSelector =
                                    _js2n__-prdslib.enum
                                        [
                                          "nugetOrg",
                                          "customFeed",
                                          "netShare"
                                        ],
                                  password = _js2n__-prdslib.isType '"String",
                                  testPlatformVersion =
                                    _js2n__-prdslib.isType '"String",
                                  username = _js2n__-prdslib.isType '"String",
                                  versionSelector =
                                    _js2n__-prdslib.enum
                                        [
                                          "latestPreRelease",
                                          "latestStable",
                                          "specificVersion"
                                        ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^VisualStudioTestPlatformInstaller@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      certificateString =
                                        _js2n__-prdslib.isType '"String",
                                      messageBody =
                                        _js2n__-prdslib.isType '"String",
                                      sessionId =
                                        _js2n__-prdslib.isType '"String",
                                      signPayload =
                                        _js2n__-prdslib.isType '"Bool",
                                      signatureKey =
                                        _js2n__-prdslib.isType '"String",
                                      useDataContractSerializer =
                                        _js2n__-prdslib.isType '"Bool",
                                      waitForCompletion =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishToAzureServiceBus@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "azureSubscription",
                                      "serviceBusNamespace",
                                      "serviceBusQueueName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      certificateString =
                                        _js2n__-prdslib.isType '"String",
                                      messageBody =
                                        _js2n__-prdslib.isType '"String",
                                      serviceBusNamespace =
                                        _js2n__-prdslib.isType '"String",
                                      serviceBusQueueName =
                                        _js2n__-prdslib.isType '"String",
                                      sessionId =
                                        _js2n__-prdslib.isType '"String",
                                      signPayload =
                                        _js2n__-prdslib.isType '"Bool",
                                      signatureKey =
                                        _js2n__-prdslib.isType '"String",
                                      useDataContractSerializer =
                                        _js2n__-prdslib.isType '"Bool",
                                      waitForCompletion =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishToAzureServiceBus@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      messageBody =
                                        _js2n__-prdslib.isType '"String",
                                      waitForCompletion =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishToAzureServiceBus@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  action =
                                    _js2n__-prdslib.enum
                                        [
                                          "bake",
                                          "createSecret",
                                          "delete",
                                          "deploy",
                                          "patch",
                                          "promote",
                                          "scale",
                                          "reject"
                                        ],
                                  arguments = _js2n__-prdslib.isType '"String",
                                  baselineAndCanaryReplicas =
                                    _js2n__-prdslib.isType '"String",
                                  containers = _js2n__-prdslib.isType '"String",
                                  dockerComposeFile =
                                    _js2n__-prdslib.isType '"String",
                                  dockerRegistryEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  helmChart = _js2n__-prdslib.isType '"String",
                                  imagePullSecrets =
                                    _js2n__-prdslib.isType '"String",
                                  kind =
                                    _js2n__-prdslib.enum
                                        [
                                          "deployment",
                                          "replicaset",
                                          "statefulset"
                                        ],
                                  kubernetesServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                  kustomizationPath =
                                    _js2n__-prdslib.isType '"String",
                                  manifests = _js2n__-prdslib.isType '"String",
                                  mergeStrategy =
                                    _js2n__-prdslib.enum
                                        [ "json", "merge", "strategic" ],
                                  name = _js2n__-prdslib.isType '"String",
                                  namespace = _js2n__-prdslib.isType '"String",
                                  overrideFiles =
                                    _js2n__-prdslib.isType '"String",
                                  overrides = _js2n__-prdslib.isType '"String",
                                  patch = _js2n__-prdslib.isType '"String",
                                  percentage = _js2n__-prdslib.isType '"String",
                                  releaseName =
                                    _js2n__-prdslib.isType '"String",
                                  renderType =
                                    _js2n__-prdslib.enum
                                        [ "helm", "kompose", "kustomize" ],
                                  replicas = _js2n__-prdslib.isType '"String",
                                  resourceFileToPatch =
                                    _js2n__-prdslib.isType '"String",
                                  resourceToPatch =
                                    _js2n__-prdslib.enum [ "file", "name" ],
                                  rolloutStatusTimeout =
                                    _js2n__-prdslib.isType '"String",
                                  secretArguments =
                                    _js2n__-prdslib.isType '"String",
                                  secretName = _js2n__-prdslib.isType '"String",
                                  secretType =
                                    _js2n__-prdslib.enum
                                        [ "dockerRegistry", "generic" ],
                                  strategy =
                                    _js2n__-prdslib.enum [ "canary", "none" ],
                                  trafficSplitMethod =
                                    _js2n__-prdslib.enum [ "pod", "smi" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^KubernetesManifest@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  action =
                                    _js2n__-prdslib.enum
                                        [
                                          "bake",
                                          "createSecret",
                                          "delete",
                                          "deploy",
                                          "patch",
                                          "promote",
                                          "scale",
                                          "reject"
                                        ],
                                  arguments = _js2n__-prdslib.isType '"String",
                                  azureResourceGroup =
                                    _js2n__-prdslib.isType '"String",
                                  azureSubscriptionConnection =
                                    _js2n__-prdslib.isType '"String",
                                  baselineAndCanaryReplicas =
                                    _js2n__-prdslib.isType '"String",
                                  connectionType =
                                    _js2n__-prdslib.enum
                                        [
                                          "azureResourceManager",
                                          "kubernetesServiceConnection"
                                        ],
                                  containers = _js2n__-prdslib.isType '"String",
                                  dockerComposeFile =
                                    _js2n__-prdslib.isType '"String",
                                  dockerRegistryEndpoint =
                                    _js2n__-prdslib.isType '"String",
                                  helmChart = _js2n__-prdslib.isType '"String",
                                  imagePullSecrets =
                                    _js2n__-prdslib.isType '"String",
                                  kind =
                                    _js2n__-prdslib.enum
                                        [
                                          "deployment",
                                          "replicaset",
                                          "statefulset"
                                        ],
                                  kubernetesCluster =
                                    _js2n__-prdslib.isType '"String",
                                  kubernetesServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                  kustomizationPath =
                                    _js2n__-prdslib.isType '"String",
                                  manifests = _js2n__-prdslib.isType '"String",
                                  mergeStrategy =
                                    _js2n__-prdslib.enum
                                        [ "json", "merge", "strategic" ],
                                  name = _js2n__-prdslib.isType '"String",
                                  namespace = _js2n__-prdslib.isType '"String",
                                  overrideFiles =
                                    _js2n__-prdslib.isType '"String",
                                  overrides = _js2n__-prdslib.isType '"String",
                                  patch = _js2n__-prdslib.isType '"String",
                                  percentage = _js2n__-prdslib.isType '"String",
                                  releaseName =
                                    _js2n__-prdslib.isType '"String",
                                  renderType =
                                    _js2n__-prdslib.enum
                                        [ "helm", "kompose", "kustomize" ],
                                  replicas = _js2n__-prdslib.isType '"String",
                                  resourceFileToPatch =
                                    _js2n__-prdslib.isType '"String",
                                  resourceToPatch =
                                    _js2n__-prdslib.enum [ "file", "name" ],
                                  rolloutStatusTimeout =
                                    _js2n__-prdslib.isType '"String",
                                  secretArguments =
                                    _js2n__-prdslib.isType '"String",
                                  secretName = _js2n__-prdslib.isType '"String",
                                  secretType =
                                    _js2n__-prdslib.enum
                                        [ "dockerRegistry", "generic" ],
                                  strategy =
                                    _js2n__-prdslib.enum [ "canary", "none" ],
                                  trafficSplitMethod =
                                    _js2n__-prdslib.enum [ "pod", "smi" ],
                                  useClusterAdmin =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^KubernetesManifest@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  allowPartiallySucceededBuilds =
                                    _js2n__-prdslib.isType '"Bool",
                                  artifactName =
                                    _js2n__-prdslib.isType '"String",
                                  branchName = _js2n__-prdslib.isType '"String",
                                  buildId = _js2n__-prdslib.isType '"String",
                                  buildType =
                                    _js2n__-prdslib.enum
                                        [ "current", "specific" ],
                                  buildVersionToDownload =
                                    _js2n__-prdslib.enum
                                        [
                                          "latest",
                                          "latestFromBranch",
                                          "specific"
                                        ],
                                  checkDownloadedFiles =
                                    _js2n__-prdslib.isType '"Bool",
                                  cleanDestinationFolder =
                                    _js2n__-prdslib.isType '"Bool",
                                  downloadPath =
                                    _js2n__-prdslib.isType '"String",
                                  downloadType =
                                    _js2n__-prdslib.enum
                                        [ "single", "specific" ],
                                  extractTars = _js2n__-prdslib.isType '"Bool",
                                  itemPattern =
                                    _js2n__-prdslib.isType '"String",
                                  parallelizationLimit =
                                    _js2n__-prdslib.isType '"String",
                                  pipeline = _js2n__-prdslib.isType '"String",
                                  project = _js2n__-prdslib.isType '"String",
                                  retryDownloadCount =
                                    _js2n__-prdslib.isType '"String",
                                  retryRedirectDownloadCount =
                                    _js2n__-prdslib.isType '"String",
                                  specificBuildWithTriggering =
                                    _js2n__-prdslib.isType '"Bool",
                                  tags = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadBuildArtifacts@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  allowPartiallySucceededBuilds =
                                    _js2n__-prdslib.isType '"Bool",
                                  artifactName =
                                    _js2n__-prdslib.isType '"String",
                                  branchName = _js2n__-prdslib.isType '"String",
                                  buildId = _js2n__-prdslib.isType '"String",
                                  buildType =
                                    _js2n__-prdslib.enum
                                        [ "current", "specific" ],
                                  buildVersionToDownload =
                                    _js2n__-prdslib.enum
                                        [
                                          "latest",
                                          "latestFromBranch",
                                          "specific"
                                        ],
                                  checkDownloadedFiles =
                                    _js2n__-prdslib.isType '"Bool",
                                  cleanDestinationFolder =
                                    _js2n__-prdslib.isType '"Bool",
                                  downloadPath =
                                    _js2n__-prdslib.isType '"String",
                                  downloadType =
                                    _js2n__-prdslib.enum
                                        [ "single", "specific" ],
                                  extractTars = _js2n__-prdslib.isType '"Bool",
                                  itemPattern =
                                    _js2n__-prdslib.isType '"String",
                                  parallelizationLimit =
                                    _js2n__-prdslib.isType '"String",
                                  pipeline = _js2n__-prdslib.isType '"String",
                                  project = _js2n__-prdslib.isType '"String",
                                  retryDownloadCount =
                                    _js2n__-prdslib.isType '"String",
                                  specificBuildWithTriggering =
                                    _js2n__-prdslib.isType '"Bool",
                                  tags = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DownloadBuildArtifacts@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  forceRepoUpdate =
                                    _js2n__-prdslib.isType '"Bool",
                                  projectDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^CocoaPods@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "AppName",
                                      "AzureSpringCloud",
                                      "azureSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      Action =
                                        _js2n__-prdslib.enum
                                            [
                                              "Deploy",
                                              "Set Production",
                                              "Delete Staging Deployment"
                                            ],
                                      AppName =
                                        _js2n__-prdslib.isType '"String",
                                      AzureSpringCloud =
                                        _js2n__-prdslib.isType '"String",
                                      Builder =
                                        _js2n__-prdslib.isType '"String",
                                      CreateNewDeployment =
                                        _js2n__-prdslib.isType '"Bool",
                                      DeploymentName =
                                        _js2n__-prdslib.isType '"String",
                                      DeploymentType =
                                        _js2n__-prdslib.enum
                                            [ "Artifacts", "CustomContainer" ],
                                      DotNetCoreMainEntryPath =
                                        _js2n__-prdslib.isType '"String",
                                      EnvironmentVariables =
                                        _js2n__-prdslib.isType '"String",
                                      ImageArgs =
                                        _js2n__-prdslib.isType '"String",
                                      ImageCommand =
                                        _js2n__-prdslib.isType '"String",
                                      ImageLanguageFramework =
                                        _js2n__-prdslib.enum
                                            [ "springboot", "" ],
                                      ImageName =
                                        _js2n__-prdslib.isType '"String",
                                      JvmOptions =
                                        _js2n__-prdslib.isType '"String",
                                      Package =
                                        _js2n__-prdslib.isType '"String",
                                      RegistryPassword =
                                        _js2n__-prdslib.isType '"String",
                                      RegistryServer =
                                        _js2n__-prdslib.isType '"String",
                                      RegistryUsername =
                                        _js2n__-prdslib.isType '"String",
                                      RuntimeVersion =
                                        _js2n__-prdslib.enum
                                            [
                                              "Java_8",
                                              "Java_11",
                                              "Java_17",
                                              "Java_21",
                                              "NetCore_31"
                                            ],
                                      UseStagingDeployment =
                                        _js2n__-prdslib.isType '"Bool",
                                      Version =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureSpringCloud@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "appName",
                                      "appType",
                                      "azureSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appName =
                                        _js2n__-prdslib.isType '"String",
                                      appSettings =
                                        _js2n__-prdslib.isType '"String",
                                      appType =
                                        _js2n__-prdslib.enum
                                            [ "webApp", "webAppLinux" ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      configurationStrings =
                                        _js2n__-prdslib.isType '"String",
                                      customDeployFolder =
                                        _js2n__-prdslib.isType '"String",
                                      customWebConfig =
                                        _js2n__-prdslib.isType '"String",
                                      deployToSlotOrASE =
                                        _js2n__-prdslib.isType '"Bool",
                                      deploymentMethod =
                                        _js2n__-prdslib.enum
                                            [
                                              "auto",
                                              "zipDeploy",
                                              "runFromPackage"
                                            ],
                                      package =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      runtimeStack =
                                        _js2n__-prdslib.isType '"String",
                                      slotName =
                                        _js2n__-prdslib.isType '"String",
                                      startUpCommand =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^AzureWebApp@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      addSpnToEnvironment =
                                        _js2n__-prdslib.isType '"Bool",
                                      arguments =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      failOnStandardError =
                                        _js2n__-prdslib.isType '"Bool",
                                      inlineScript =
                                        _js2n__-prdslib.isType '"String",
                                      scriptLocation =
                                        _js2n__-prdslib.enum
                                            [ "inlineScript", "scriptPath" ],
                                      scriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      useGlobalConfig =
                                        _js2n__-prdslib.isType '"Bool",
                                      workingDirectory =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task = _js2n__-prdslib.strings.pattern "^AzureCLI@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  args = _js2n__-prdslib.isType '"String",
                                  connectedServiceName =
                                    _js2n__-prdslib.isType '"String",
                                  connectedServiceNameARM =
                                    _js2n__-prdslib.isType '"String",
                                  connectedServiceNameSelector =
                                    _js2n__-prdslib.enum
                                        [
                                          "connectedServiceName",
                                          "connectedServiceNameARM"
                                        ],
                                  cwd = _js2n__-prdslib.isType '"String",
                                  failOnStandardError =
                                    _js2n__-prdslib.isType '"Bool",
                                  inlineScript =
                                    _js2n__-prdslib.isType '"String",
                                  scriptLocation =
                                    _js2n__-prdslib.enum
                                        [ "inlineScript", "scriptPath" ],
                                  scriptPath = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^AzureCLI@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureSubscription", "scriptType" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      addSpnToEnvironment =
                                        _js2n__-prdslib.isType '"Bool",
                                      arguments =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      failOnStandardError =
                                        _js2n__-prdslib.isType '"Bool",
                                      inlineScript =
                                        _js2n__-prdslib.isType '"String",
                                      keepAzSessionActive =
                                        _js2n__-prdslib.isType '"Bool",
                                      powerShellErrorActionPreference =
                                        _js2n__-prdslib.enum
                                            [
                                              "stop",
                                              "continue",
                                              "silentlyContinue"
                                            ],
                                      powerShellIgnoreLASTEXITCODE =
                                        _js2n__-prdslib.isType '"Bool",
                                      scriptLocation =
                                        _js2n__-prdslib.enum
                                            [ "inlineScript", "scriptPath" ],
                                      scriptPath =
                                        _js2n__-prdslib.isType '"String",
                                      scriptType =
                                        _js2n__-prdslib.enum
                                            [ "ps", "pscore", "batch", "bash" ],
                                      useGlobalConfig =
                                        _js2n__-prdslib.isType '"Bool",
                                      visibleAzLogin =
                                        _js2n__-prdslib.isType '"Bool",
                                      workingDirectory =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task = _js2n__-prdslib.strings.pattern "^AzureCLI@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "gitHubConnection" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      action =
                                        _js2n__-prdslib.enum
                                            [ "create", "edit", "delete" ],
                                      addChangeLog =
                                        _js2n__-prdslib.isType '"Bool",
                                      assetUploadMode =
                                        _js2n__-prdslib.enum
                                            [ "delete", "replace" ],
                                      assets = _js2n__-prdslib.isType '"String",
                                      changeLogCompareToRelease =
                                        _js2n__-prdslib.enum
                                            [
                                              "lastFullRelease",
                                              "lastNonDraftRelease",
                                              "lastNonDraftReleaseByTag"
                                            ],
                                      changeLogCompareToReleaseTag =
                                        _js2n__-prdslib.isType '"String",
                                      changeLogLabels =
                                        _js2n__-prdslib.isType '"String",
                                      changeLogType =
                                        _js2n__-prdslib.enum
                                            [ "commitBased", "issueBased" ],
                                      gitHubConnection =
                                        _js2n__-prdslib.isType '"String",
                                      isDraft = _js2n__-prdslib.isType '"Bool",
                                      isPreRelease =
                                        _js2n__-prdslib.isType '"Bool",
                                      releaseNotesFilePath =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesInline =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesSource =
                                        _js2n__-prdslib.enum
                                            [ "filePath", "inline" ],
                                      repositoryName =
                                        _js2n__-prdslib.isType '"String",
                                      tag = _js2n__-prdslib.isType '"String",
                                      tagPattern =
                                        _js2n__-prdslib.isType '"String",
                                      tagSource =
                                        _js2n__-prdslib.enum
                                            [ "gitTag", "userSpecifiedTag" ],
                                      target = _js2n__-prdslib.isType '"String",
                                      title = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^GitHubRelease@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "gitHubConnection" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      action =
                                        _js2n__-prdslib.enum
                                            [ "create", "edit", "delete" ],
                                      addChangeLog =
                                        _js2n__-prdslib.isType '"Bool",
                                      assetUploadMode =
                                        _js2n__-prdslib.enum
                                            [ "delete", "replace" ],
                                      assets = _js2n__-prdslib.isType '"String",
                                      changeLogCompareToRelease =
                                        _js2n__-prdslib.enum
                                            [
                                              "lastFullRelease",
                                              "lastNonDraftRelease",
                                              "lastNonDraftReleaseByTag"
                                            ],
                                      changeLogCompareToReleaseTag =
                                        _js2n__-prdslib.isType '"String",
                                      changeLogLabels =
                                        _js2n__-prdslib.isType '"String",
                                      changeLogType =
                                        _js2n__-prdslib.enum
                                            [ "commitBased", "issueBased" ],
                                      gitHubConnection =
                                        _js2n__-prdslib.isType '"String",
                                      isDraft = _js2n__-prdslib.isType '"Bool",
                                      isPreRelease =
                                        _js2n__-prdslib.isType '"Bool",
                                      releaseNotes =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesFile =
                                        _js2n__-prdslib.isType '"String",
                                      releaseNotesSource =
                                        _js2n__-prdslib.enum
                                            [ "file", "input" ],
                                      repositoryName =
                                        _js2n__-prdslib.isType '"String",
                                      tag = _js2n__-prdslib.isType '"String",
                                      tagPattern =
                                        _js2n__-prdslib.isType '"String",
                                      tagSource =
                                        _js2n__-prdslib.enum
                                            [ "auto", "manual" ],
                                      target = _js2n__-prdslib.isType '"String",
                                      title = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^GitHubRelease@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "files", "url" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      files = _js2n__-prdslib.isType '"String",
                                      options =
                                        _js2n__-prdslib.isType '"String",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      redirectStderr =
                                        _js2n__-prdslib.isType '"Bool",
                                      url = _js2n__-prdslib.isType '"String",
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^cURLUploader@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "files" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      authType =
                                        _js2n__-prdslib.enum
                                            [
                                              "ServiceEndpoint",
                                              "UserAndPass"
                                            ],
                                      files = _js2n__-prdslib.isType '"String",
                                      options =
                                        _js2n__-prdslib.isType '"String",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      redirectStderr =
                                        _js2n__-prdslib.isType '"Bool",
                                      remotePath =
                                        _js2n__-prdslib.isType '"String",
                                      serviceEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      url = _js2n__-prdslib.isType '"String",
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^cURLUploader@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "appName",
                                      "azureSubscription",
                                      "resourceGroupName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appName =
                                        _js2n__-prdslib.isType '"String",
                                      appSettings =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      connectionStrings =
                                        _js2n__-prdslib.isType '"String",
                                      generalSettings =
                                        _js2n__-prdslib.isType '"String",
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      slotName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureAppServiceSettings@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  command =
                                    _js2n__-prdslib.enum
                                        [ "download", "publish" ],
                                  downloadDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  externalFeedCredentials =
                                    _js2n__-prdslib.isType '"String",
                                  feedDownloadExternal =
                                    _js2n__-prdslib.isType '"String",
                                  feedPublishExternal =
                                    _js2n__-prdslib.isType '"String",
                                  feedsToUse =
                                    _js2n__-prdslib.enum
                                        [ "internal", "external" ],
                                  feedsToUsePublish =
                                    _js2n__-prdslib.enum
                                        [ "internal", "external" ],
                                  packageDownloadExternal =
                                    _js2n__-prdslib.isType '"String",
                                  packagePublishDescription =
                                    _js2n__-prdslib.isType '"String",
                                  packagePublishExternal =
                                    _js2n__-prdslib.isType '"String",
                                  publishDirectory =
                                    _js2n__-prdslib.isType '"String",
                                  publishFeedCredentials =
                                    _js2n__-prdslib.isType '"String",
                                  publishPackageMetadata =
                                    _js2n__-prdslib.isType '"Bool",
                                  publishedPackageVar =
                                    _js2n__-prdslib.isType '"String",
                                  verbosity =
                                    _js2n__-prdslib.enum
                                        [
                                          "None",
                                          "Trace",
                                          "Debug",
                                          "Information",
                                          "Warning",
                                          "Error",
                                          "Critical"
                                        ],
                                  versionDownloadExternal =
                                    _js2n__-prdslib.isType '"String",
                                  versionOption =
                                    _js2n__-prdslib.enum
                                        [ "major", "minor", "patch", "custom" ],
                                  versionPublish =
                                    _js2n__-prdslib.isType '"String",
                                  vstsFeed = _js2n__-prdslib.isType '"String",
                                  vstsFeedPackage =
                                    _js2n__-prdslib.isType '"String",
                                  vstsFeedPackagePublish =
                                    _js2n__-prdslib.isType '"String",
                                  vstsFeedPublish =
                                    _js2n__-prdslib.isType '"String",
                                  vstsPackageVersion =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^UniversalPackages@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azureSubscription" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      Resources =
                                        _js2n__-prdslib.isType '"String",
                                      RetryDuration =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzurePolicyCheckGate@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "appName",
                                      "dockerRegistryServiceConnection",
                                      "kubernetesServiceConnection"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appName =
                                        _js2n__-prdslib.isType '"String",
                                      arguments =
                                        _js2n__-prdslib.isType '"String",
                                      dockerHubNamespace =
                                        _js2n__-prdslib.isType '"String",
                                      dockerRegistryServiceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      functionRootDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      kubernetesServiceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      namespace =
                                        _js2n__-prdslib.isType '"String",
                                      secretName =
                                        _js2n__-prdslib.isType '"String",
                                      waitForStability =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureFunctionOnKubernetes@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "appName",
                                      "dockerRegistryServiceConnection"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      appName =
                                        _js2n__-prdslib.isType '"String",
                                      arguments =
                                        _js2n__-prdslib.isType '"String",
                                      azureResourceGroup =
                                        _js2n__-prdslib.isType '"String",
                                      azureSubscriptionConnection =
                                        _js2n__-prdslib.isType '"String",
                                      connectionType =
                                        _js2n__-prdslib.enum
                                            [
                                              "Azure Resource Manager",
                                              "Kubernetes Service Connection"
                                            ],
                                      dockerHubNamespace =
                                        _js2n__-prdslib.isType '"String",
                                      dockerRegistryServiceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      functionRootDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      kubernetesCluster =
                                        _js2n__-prdslib.isType '"String",
                                      kubernetesServiceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      namespace =
                                        _js2n__-prdslib.isType '"String",
                                      secretName =
                                        _js2n__-prdslib.isType '"String",
                                      waitForStability =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureFunctionOnKubernetes@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "scriptPath" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      args = _js2n__-prdslib.isType '"String",
                                      cwd = _js2n__-prdslib.isType '"String",
                                      disableAutoCwd =
                                        _js2n__-prdslib.isType '"Bool",
                                      failOnStandardError =
                                        _js2n__-prdslib.isType '"Bool",
                                      scriptPath =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^ShellScript@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  bashEnvValue =
                                    _js2n__-prdslib.isType '"String",
                                  failOnStderr = _js2n__-prdslib.isType '"Bool",
                                  filePath = _js2n__-prdslib.isType '"String",
                                  script = _js2n__-prdslib.isType '"String",
                                  targetType =
                                    _js2n__-prdslib.enum
                                        [ "filePath", "inline" ],
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^Bash@3$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  ArtifactName =
                                    _js2n__-prdslib.isType '"String",
                                  MaxArtifactSize =
                                    _js2n__-prdslib.isType 'Integer,
                                  Parallel = _js2n__-prdslib.isType '"Bool",
                                  ParallelCount =
                                    _js2n__-prdslib.isType 'Integer,
                                  PathtoPublish =
                                    _js2n__-prdslib.isType '"String",
                                  StoreAsTar = _js2n__-prdslib.isType '"Bool",
                                  TargetPath = _js2n__-prdslib.isType '"String",
                                  publishLocation =
                                    _js2n__-prdslib.enum
                                        [ "Container", "FilePath" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^PublishBuildArtifacts@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "knownHostsEntry", "sshKeySecureFile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      addEntryToConfig =
                                        _js2n__-prdslib.isType '"Bool",
                                      configHostAlias =
                                        _js2n__-prdslib.isType '"String",
                                      configHostname =
                                        _js2n__-prdslib.isType '"String",
                                      configPort =
                                        _js2n__-prdslib.isType '"String",
                                      configUser =
                                        _js2n__-prdslib.isType '"String",
                                      knownHostsEntry =
                                        _js2n__-prdslib.isType '"String",
                                      sshKeySecureFile =
                                        _js2n__-prdslib.isType '"String",
                                      sshPassphrase =
                                        _js2n__-prdslib.isType '"String",
                                      sshPublicKey =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^InstallSSHKey@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "azureSubscription",
                                      "imageUrl",
                                      "vmssName",
                                      "vmssOsType"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      action =
                                        _js2n__-prdslib.enum
                                            [
                                              "Update image",
                                              "Configure application startup"
                                            ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      customScript =
                                        _js2n__-prdslib.isType '"String",
                                      customScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      customScriptsDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      customScriptsStorageAccount =
                                        _js2n__-prdslib.isType '"String",
                                      imageUrl =
                                        _js2n__-prdslib.isType '"String",
                                      skipArchivingCustomScripts =
                                        _js2n__-prdslib.isType '"Bool",
                                      vmssName =
                                        _js2n__-prdslib.isType '"String",
                                      vmssOsType =
                                        _js2n__-prdslib.enum
                                            [ "Windows", "Linux" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureVmssDeployment@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "azureSubscription",
                                      "imageUrl",
                                      "vmssName",
                                      "vmssOsType"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      action =
                                        _js2n__-prdslib.enum
                                            [
                                              "Update image",
                                              "Configure application startup"
                                            ],
                                      azureSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      customScript =
                                        _js2n__-prdslib.isType '"String",
                                      customScriptArguments =
                                        _js2n__-prdslib.isType '"String",
                                      customScriptsDirectory =
                                        _js2n__-prdslib.isType '"String",
                                      customScriptsStorageAccount =
                                        _js2n__-prdslib.isType '"String",
                                      imageUrl =
                                        _js2n__-prdslib.isType '"String",
                                      skipArchivingCustomScripts =
                                        _js2n__-prdslib.isType '"Bool",
                                      vmssName =
                                        _js2n__-prdslib.isType '"String",
                                      vmssOsType =
                                        _js2n__-prdslib.enum
                                            [ "Windows", "Linux" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureVmssDeployment@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "ConnectedServiceName",
                                      "Package",
                                      "WebSiteLocation",
                                      "WebSiteName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      AdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      ConnectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      Package =
                                        _js2n__-prdslib.isType '"String",
                                      Slot = _js2n__-prdslib.isType '"String",
                                      WebSiteLocation =
                                        _js2n__-prdslib.isType '"String",
                                      WebSiteName =
                                        _js2n__-prdslib.isType '"String",
                                      doNotDelete =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureWebPowerShellDeployment@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  azureDevOpsServiceConnection =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^CondaAuthenticate@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "ARMConnectedServiceName",
                                      "ARMStorageAccount",
                                      "CsCfg",
                                      "CsDef",
                                      "CsPkg",
                                      "ResourceGroupName",
                                      "ServiceLocation",
                                      "ServiceName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ARMConnectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      ARMStorageAccount =
                                        _js2n__-prdslib.isType '"String",
                                      AllowUpgrade =
                                        _js2n__-prdslib.isType '"Bool",
                                      AppendDateTimeToLabel =
                                        _js2n__-prdslib.isType '"Bool",
                                      CsCfg = _js2n__-prdslib.isType '"String",
                                      CsDef = _js2n__-prdslib.isType '"String",
                                      CsPkg = _js2n__-prdslib.isType '"String",
                                      DeploymentLabel =
                                        _js2n__-prdslib.isType '"String",
                                      DiagnosticStorageAccountKeys =
                                        _js2n__-prdslib.isType '"String",
                                      KeyVault =
                                        _js2n__-prdslib.isType '"String",
                                      ResourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      ServiceLocation =
                                        _js2n__-prdslib.isType '"String",
                                      ServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      UpgradeMode =
                                        _js2n__-prdslib.isType '"String",
                                      VerifyRoleInstanceStatus =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureCloudPowerShellDeployment@2$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "CsCfg",
                                      "CsPkg",
                                      "ServiceLocation",
                                      "ServiceName",
                                      "azureClassicSubscription"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ARMConnectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      ARMStorageAccount =
                                        _js2n__-prdslib.isType '"String",
                                      AllowUpgrade =
                                        _js2n__-prdslib.isType '"Bool",
                                      AppendDateTimeToLabel =
                                        _js2n__-prdslib.isType '"Bool",
                                      CsCfg = _js2n__-prdslib.isType '"String",
                                      CsPkg = _js2n__-prdslib.isType '"String",
                                      DeploymentLabel =
                                        _js2n__-prdslib.isType '"String",
                                      DiagnosticStorageAccountKeys =
                                        _js2n__-prdslib.isType '"String",
                                      EnableAdvancedStorageOptions =
                                        _js2n__-prdslib.isType '"Bool",
                                      ForceUpgrade =
                                        _js2n__-prdslib.isType '"Bool",
                                      NewServiceAdditionalArguments =
                                        _js2n__-prdslib.isType '"String",
                                      NewServiceAffinityGroup =
                                        _js2n__-prdslib.isType '"String",
                                      NewServiceCustomCertificates =
                                        _js2n__-prdslib.isType '"String",
                                      ServiceLocation =
                                        _js2n__-prdslib.isType '"String",
                                      ServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      SimultaneousUpgrade =
                                        _js2n__-prdslib.isType '"Bool",
                                      StorageAccount =
                                        _js2n__-prdslib.isType '"String",
                                      VerifyRoleInstanceStatus =
                                        _js2n__-prdslib.isType '"Bool",
                                      azureClassicSubscription =
                                        _js2n__-prdslib.isType '"String",
                                      slotName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^AzureCloudPowerShellDeployment@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "configFile" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      azureDevOpsServiceConnection =
                                        _js2n__-prdslib.isType '"String",
                                      cargoServiceConnections =
                                        _js2n__-prdslib.isType '"String",
                                      configFile =
                                        _js2n__-prdslib.isType '"String",
                                      registryNames =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^CargoAuthenticate@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  Contents = _js2n__-prdslib.isType '"String",
                                  RemoveDotFiles =
                                    _js2n__-prdslib.isType '"Bool",
                                  RemoveSourceFolder =
                                    _js2n__-prdslib.isType '"Bool",
                                  SourceFolder =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern "^DeleteFiles@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  enableCodeCoverage =
                                    _js2n__-prdslib.isType '"Bool",
                                  gulpFile = _js2n__-prdslib.isType '"String",
                                  gulpjs = _js2n__-prdslib.isType '"String",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  srcFiles = _js2n__-prdslib.isType '"String",
                                  targets = _js2n__-prdslib.isType '"String",
                                  testFiles = _js2n__-prdslib.isType '"String",
                                  testFramework =
                                    _js2n__-prdslib.enum [ "Mocha", "Jasmine" ],
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^gulp@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  arguments = _js2n__-prdslib.isType '"String",
                                  enableCodeCoverage =
                                    _js2n__-prdslib.isType '"Bool",
                                  gulpFile = _js2n__-prdslib.isType '"String",
                                  gulpjs = _js2n__-prdslib.isType '"String",
                                  publishJUnitResults =
                                    _js2n__-prdslib.isType '"Bool",
                                  srcFiles = _js2n__-prdslib.isType '"String",
                                  targets = _js2n__-prdslib.isType '"String",
                                  testFiles = _js2n__-prdslib.isType '"String",
                                  testFramework =
                                    _js2n__-prdslib.enum [ "Mocha", "Jasmine" ],
                                  testResultsFiles =
                                    _js2n__-prdslib.isType '"String",
                                  testRunTitle =
                                    _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never,
                          task = _js2n__-prdslib.strings.pattern "^gulp@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "testName", "websiteUrl" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      avgResponseTimeThreshold =
                                        _js2n__-prdslib.isType '"String",
                                      connectedServiceName =
                                        _js2n__-prdslib.isType '"String",
                                      geoLocation =
                                        _js2n__-prdslib.enum
                                            [
                                              "Default",
                                              "Australia East",
                                              "Australia Southeast",
                                              "Brazil South",
                                              "Central India",
                                              "Central US",
                                              "East Asia",
                                              "East US 2",
                                              "East US",
                                              "Japan East",
                                              "Japan West",
                                              "North Central US",
                                              "North Europe",
                                              "South Central US",
                                              "South India",
                                              "Southeast Asia",
                                              "West Europe",
                                              "West US"
                                            ],
                                      machineType =
                                        _js2n__-prdslib.enum [ "0", "2" ],
                                      numOfSelfProvisionedAgents =
                                        _js2n__-prdslib.isType 'Integer,
                                      resourceGroupName =
                                        _js2n__-prdslib.isType '"String",
                                      runDuration =
                                        _js2n__-prdslib.enum
                                            [
                                              "60",
                                              "120",
                                              "180",
                                              "240",
                                              "300"
                                            ],
                                      testName =
                                        _js2n__-prdslib.isType '"String",
                                      vuLoad =
                                        _js2n__-prdslib.enum
                                            [ "25", "50", "100", "250" ],
                                      websiteUrl =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern "^QuickPerfTest@1$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [
                                      "AppPoolName",
                                      "AppPoolNameForApplication",
                                      "AppPoolNameForWebsite",
                                      "Bindings",
                                      "ParentWebsiteNameForApplication",
                                      "ParentWebsiteNameForVD",
                                      "VirtualPathForApplication",
                                      "VirtualPathForVD",
                                      "WebsiteName"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ActionIISApplicationPool =
                                        _js2n__-prdslib.enum
                                            [
                                              "CreateOrUpdateAppPool",
                                              "StartAppPool",
                                              "StopAppPool",
                                              "RecycleAppPool"
                                            ],
                                      ActionIISWebsite =
                                        _js2n__-prdslib.enum
                                            [
                                              "CreateOrUpdateWebsite",
                                              "StartWebsite",
                                              "StopWebsite"
                                            ],
                                      AddBinding =
                                        _js2n__-prdslib.isType '"Bool",
                                      AnonymousAuthenticationForWebsite =
                                        _js2n__-prdslib.isType '"Bool",
                                      AppCmdCommands =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolIdentity =
                                        _js2n__-prdslib.enum
                                            [
                                              "ApplicationPoolIdentity",
                                              "LocalService",
                                              "LocalSystem",
                                              "NetworkService",
                                              "SpecificUser"
                                            ],
                                      AppPoolIdentityForApplication =
                                        _js2n__-prdslib.enum
                                            [
                                              "ApplicationPoolIdentity",
                                              "LocalService",
                                              "LocalSystem",
                                              "NetworkService",
                                              "SpecificUser"
                                            ],
                                      AppPoolIdentityForWebsite =
                                        _js2n__-prdslib.enum
                                            [
                                              "ApplicationPoolIdentity",
                                              "LocalService",
                                              "LocalSystem",
                                              "NetworkService",
                                              "SpecificUser"
                                            ],
                                      AppPoolName =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolNameForApplication =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolNameForWebsite =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolPassword =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolPasswordForApplication =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolPasswordForWebsite =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolUsername =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolUsernameForApplication =
                                        _js2n__-prdslib.isType '"String",
                                      AppPoolUsernameForWebsite =
                                        _js2n__-prdslib.isType '"String",
                                      ApplicationAuthUserName =
                                        _js2n__-prdslib.isType '"String",
                                      ApplicationAuthUserPassword =
                                        _js2n__-prdslib.isType '"String",
                                      ApplicationPhysicalPathAuth =
                                        _js2n__-prdslib.enum
                                            [
                                              "ApplicationUserPassThrough",
                                              "ApplicationWindowsAuth"
                                            ],
                                      BasicAuthenticationForWebsite =
                                        _js2n__-prdslib.isType '"Bool",
                                      Bindings =
                                        _js2n__-prdslib.isType '"String",
                                      ConfigureAuthenticationForWebsite =
                                        _js2n__-prdslib.isType '"Bool",
                                      CreateOrUpdateAppPoolForApplication =
                                        _js2n__-prdslib.isType '"Bool",
                                      CreateOrUpdateAppPoolForWebsite =
                                        _js2n__-prdslib.isType '"Bool",
                                      DotNetVersion =
                                        _js2n__-prdslib.enum
                                            [
                                              "v4.0",
                                              "v2.0",
                                              "No Managed Code"
                                            ],
                                      DotNetVersionForApplication =
                                        _js2n__-prdslib.enum
                                            [
                                              "v4.0",
                                              "v2.0",
                                              "No Managed Code"
                                            ],
                                      DotNetVersionForWebsite =
                                        _js2n__-prdslib.enum
                                            [
                                              "v4.0",
                                              "v2.0",
                                              "No Managed Code"
                                            ],
                                      EnableIIS =
                                        _js2n__-prdslib.isType '"Bool",
                                      HostNameWithHttp =
                                        _js2n__-prdslib.isType '"String",
                                      HostNameWithOutSNI =
                                        _js2n__-prdslib.isType '"String",
                                      HostNameWithSNI =
                                        _js2n__-prdslib.isType '"String",
                                      IISDeploymentType =
                                        _js2n__-prdslib.enum
                                            [
                                              "IISWebsite",
                                              "IISWebApplication",
                                              "IISVirtualDirectory",
                                              "IISApplicationPool"
                                            ],
                                      IPAddress =
                                        _js2n__-prdslib.isType '"String",
                                      ParentWebsiteNameForApplication =
                                        _js2n__-prdslib.isType '"String",
                                      ParentWebsiteNameForVD =
                                        _js2n__-prdslib.isType '"String",
                                      PhysicalPathForApplication =
                                        _js2n__-prdslib.isType '"String",
                                      PhysicalPathForVD =
                                        _js2n__-prdslib.isType '"String",
                                      PipeLineMode =
                                        _js2n__-prdslib.enum
                                            [ "Integrated", "Classic" ],
                                      PipeLineModeForApplication =
                                        _js2n__-prdslib.enum
                                            [ "Integrated", "Classic" ],
                                      PipeLineModeForWebsite =
                                        _js2n__-prdslib.enum
                                            [ "Integrated", "Classic" ],
                                      Port = _js2n__-prdslib.isType '"String",
                                      Protocol =
                                        _js2n__-prdslib.enum
                                            [ "https", "http" ],
                                      SSLCertThumbPrint =
                                        _js2n__-prdslib.isType '"String",
                                      ServerNameIndication =
                                        _js2n__-prdslib.isType '"Bool",
                                      StartStopRecycleAppPoolName =
                                        _js2n__-prdslib.isType '"String",
                                      StartStopWebsiteName =
                                        _js2n__-prdslib.isType '"String",
                                      VDAuthUserName =
                                        _js2n__-prdslib.isType '"String",
                                      VDAuthUserPassword =
                                        _js2n__-prdslib.isType '"String",
                                      VDPhysicalPathAuth =
                                        _js2n__-prdslib.enum
                                            [
                                              "VDUserPassThrough",
                                              "VDWindowsAuth"
                                            ],
                                      VirtualPathForApplication =
                                        _js2n__-prdslib.isType '"String",
                                      VirtualPathForVD =
                                        _js2n__-prdslib.isType '"String",
                                      WebsiteAuthUserName =
                                        _js2n__-prdslib.isType '"String",
                                      WebsiteAuthUserPassword =
                                        _js2n__-prdslib.isType '"String",
                                      WebsiteName =
                                        _js2n__-prdslib.isType '"String",
                                      WebsitePhysicalPath =
                                        _js2n__-prdslib.isType '"String",
                                      WebsitePhysicalPathAuth =
                                        _js2n__-prdslib.enum
                                            [
                                              "WebsiteUserPassThrough",
                                              "WebsiteWindowsAuth"
                                            ],
                                      WindowsAuthenticationForWebsite =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^IISWebAppManagementOnMachineGroup@0$",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record
                        {
                          inputs =
                            _js2n__-prdslib.records.record
                                {
                                  dockerVersion =
                                    _js2n__-prdslib.isType '"String",
                                  releaseType =
                                    _js2n__-prdslib.enum
                                        [ "stable", "edge", "test", "nightly" ],
                                } {} false _js2n__-prdslib.never,
                          task =
                            _js2n__-prdslib.strings.pattern
                                "^DockerInstaller@0$",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  condition = _js2n__-prdslib.isType '"String",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  displayName = _js2n__-prdslib.isType '"String",
                  enabled = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType 'Record,
                  inputs = _js2n__-prdslib.isType 'Record,
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^[_A-Za-z0-9]*$"
                        ],
                  retryCountOnTaskFailure = _js2n__-prdslib.isType 'Integer,
                  task =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.enum [ "PowerShell@2" ],
                          _js2n__-prdslib.enum [ "PowerShell@1" ],
                          _js2n__-prdslib.enum [ "AzurePowerShell@5" ],
                          _js2n__-prdslib.enum [ "AzurePowerShell@2" ],
                          _js2n__-prdslib.enum [ "AzurePowerShell@4" ],
                          _js2n__-prdslib.enum [ "AzurePowerShell@3" ],
                          _js2n__-prdslib.enum [ "AzurePowerShell@1" ],
                          _js2n__-prdslib.enum
                            [ "MysqlDeploymentOnMachineGroup@1" ],
                          _js2n__-prdslib.enum [ "PipAuthenticate@1" ],
                          _js2n__-prdslib.enum [ "PipAuthenticate@0" ],
                          _js2n__-prdslib.enum [ "Maven@2" ],
                          _js2n__-prdslib.enum [ "Maven@3" ],
                          _js2n__-prdslib.enum [ "Maven@4" ],
                          _js2n__-prdslib.enum [ "Maven@1" ],
                          _js2n__-prdslib.enum [ "DotNetCoreCLI@2" ],
                          _js2n__-prdslib.enum [ "DotNetCoreCLI@0" ],
                          _js2n__-prdslib.enum [ "DotNetCoreCLI@1" ],
                          _js2n__-prdslib.enum [ "XamarinComponentRestore@0" ],
                          _js2n__-prdslib.enum [ "AzureRmWebAppDeployment@3" ],
                          _js2n__-prdslib.enum [ "AzureRmWebAppDeployment@2" ],
                          _js2n__-prdslib.enum [ "AzureRmWebAppDeployment@4" ],
                          _js2n__-prdslib.enum
                            [ "PowerShellOnTargetMachines@3" ],
                          _js2n__-prdslib.enum
                            [ "PowerShellOnTargetMachines@1" ],
                          _js2n__-prdslib.enum
                            [ "PowerShellOnTargetMachines@2" ],
                          _js2n__-prdslib.enum
                            [ "PublishCodeCoverageResults@2" ],
                          _js2n__-prdslib.enum
                            [ "PublishCodeCoverageResults@1" ],
                          _js2n__-prdslib.enum
                            [ "RunVisualStudioTestsusingTestAgent@1" ],
                          _js2n__-prdslib.enum [ "ManualIntervention@8" ],
                          _js2n__-prdslib.enum
                            [ "InstallAppleProvisioningProfile@1" ],
                          _js2n__-prdslib.enum
                            [ "InstallAppleProvisioningProfile@0" ],
                          _js2n__-prdslib.enum [ "SonarQubePostTest@1" ],
                          _js2n__-prdslib.enum [ "PyPIPublisher@0" ],
                          _js2n__-prdslib.enum [ "ChefKnife@1" ],
                          _js2n__-prdslib.enum [ "GoTool@0" ],
                          _js2n__-prdslib.enum [ "XcodePackageiOS@0" ],
                          _js2n__-prdslib.enum [ "Go@0" ],
                          _js2n__-prdslib.enum [ "PublishPipelineMetadata@0" ],
                          _js2n__-prdslib.enum [ "Docker@0" ],
                          _js2n__-prdslib.enum [ "Docker@2" ],
                          _js2n__-prdslib.enum [ "Docker@1" ],
                          _js2n__-prdslib.enum [ "JenkinsQueueJob@2" ],
                          _js2n__-prdslib.enum [ "JenkinsQueueJob@1" ],
                          _js2n__-prdslib.enum [ "FtpUpload@2" ],
                          _js2n__-prdslib.enum [ "FtpUpload@1" ],
                          _js2n__-prdslib.enum [ "WindowsMachineFileCopy@1" ],
                          _js2n__-prdslib.enum [ "WindowsMachineFileCopy@2" ],
                          _js2n__-prdslib.enum [ "AndroidBuild@1" ],
                          _js2n__-prdslib.enum [ "TwineAuthenticate@0" ],
                          _js2n__-prdslib.enum [ "TwineAuthenticate@1" ],
                          _js2n__-prdslib.enum
                            [ "IISWebAppDeploymentOnMachineGroup@0" ],
                          _js2n__-prdslib.enum [ "PythonScript@0" ],
                          _js2n__-prdslib.enum [ "HelmInstaller@0" ],
                          _js2n__-prdslib.enum [ "HelmInstaller@1" ],
                          _js2n__-prdslib.enum [ "NodeTaskRunnerInstaller@0" ],
                          _js2n__-prdslib.enum [ "XamarinLicense@1" ],
                          _js2n__-prdslib.enum [ "NuGetAuthenticate@0" ],
                          _js2n__-prdslib.enum [ "NuGetAuthenticate@1" ],
                          _js2n__-prdslib.enum
                            [ "DownloadGitHubNugetPackage@1" ],
                          _js2n__-prdslib.enum [ "MavenAuthenticate@0" ],
                          _js2n__-prdslib.enum
                            [ "AzureAppConfigurationExport@10" ],
                          _js2n__-prdslib.enum [ "ReviewApp@0" ],
                          _js2n__-prdslib.enum [ "JavaToolInstaller@0" ],
                          _js2n__-prdslib.enum [ "JavaToolInstaller@1" ],
                          _js2n__-prdslib.enum [ "Chef@1" ],
                          _js2n__-prdslib.enum [ "AzureFunctionApp@1" ],
                          _js2n__-prdslib.enum [ "AzureFunctionApp@2" ],
                          _js2n__-prdslib.enum [ "npmAuthenticate@0" ],
                          _js2n__-prdslib.enum [ "MSBuild@1" ],
                          _js2n__-prdslib.enum [ "PackerBuild@0" ],
                          _js2n__-prdslib.enum [ "PackerBuild@1" ],
                          _js2n__-prdslib.enum [ "NuGetPackager@0" ],
                          _js2n__-prdslib.enum
                            [ "AzureAppConfigurationSnapshot@1" ],
                          _js2n__-prdslib.enum [ "DuffleInstaller@0" ],
                          _js2n__-prdslib.enum
                            [ "ServiceFabricUpdateAppVersions@1" ],
                          _js2n__-prdslib.enum
                            [ "ServiceFabricUpdateManifests@2" ],
                          _js2n__-prdslib.enum [ "AzureMonitor@1" ],
                          _js2n__-prdslib.enum [ "AzureMonitor@0" ],
                          _js2n__-prdslib.enum [ "Notation@0" ],
                          _js2n__-prdslib.enum [ "AzureNLBManagement@1" ],
                          _js2n__-prdslib.enum [ "ApacheJMeterLoadTest@1" ],
                          _js2n__-prdslib.enum [ "DockerCompose@0" ],
                          _js2n__-prdslib.enum [ "DockerCompose@1" ],
                          _js2n__-prdslib.enum [ "AzureMonitorAlerts@0" ],
                          _js2n__-prdslib.enum [ "XamarinTestCloud@1" ],
                          _js2n__-prdslib.enum [ "ServiceFabricDeploy@1" ],
                          _js2n__-prdslib.enum [ "Xcode@5" ],
                          _js2n__-prdslib.enum [ "Xcode@3" ],
                          _js2n__-prdslib.enum [ "Xcode@4" ],
                          _js2n__-prdslib.enum [ "Xcode@2" ],
                          _js2n__-prdslib.enum [ "NuGetPublisher@0" ],
                          _js2n__-prdslib.enum [ "queryWorkItems@0" ],
                          _js2n__-prdslib.enum [ "AzureWebAppContainer@1" ],
                          _js2n__-prdslib.enum
                            [ "SqlDacpacDeploymentOnMachineGroup@0" ],
                          _js2n__-prdslib.enum [ "CacheBeta@1" ],
                          _js2n__-prdslib.enum [ "CacheBeta@0" ],
                          _js2n__-prdslib.enum [ "Cache@2" ],
                          _js2n__-prdslib.enum [ "CMake@1" ],
                          _js2n__-prdslib.enum [ "VSMobileCenterTest@0" ],
                          _js2n__-prdslib.enum [ "AppCenterTest@1" ],
                          _js2n__-prdslib.enum [ "DownloadSecureFile@1" ],
                          _js2n__-prdslib.enum [ "AzureContainerApps@0" ],
                          _js2n__-prdslib.enum [ "AzureContainerApps@1" ],
                          _js2n__-prdslib.enum [ "UseRubyVersion@0" ],
                          _js2n__-prdslib.enum [ "Grunt@0" ],
                          _js2n__-prdslib.enum [ "SqlAzureDacpacDeployment@1" ],
                          _js2n__-prdslib.enum [ "ContainerStructureTest@0" ],
                          _js2n__-prdslib.enum [ "IISWebAppDeployment@1" ],
                          _js2n__-prdslib.enum [ "CloudLoadTest@1" ],
                          _js2n__-prdslib.enum [ "KubectlInstaller@0" ],
                          _js2n__-prdslib.enum [ "CmdLine@2" ],
                          _js2n__-prdslib.enum [ "CmdLine@1" ],
                          _js2n__-prdslib.enum [ "NuGet@0" ],
                          _js2n__-prdslib.enum [ "ContainerBuild@0" ],
                          _js2n__-prdslib.enum [ "NuGetInstaller@0" ],
                          _js2n__-prdslib.enum [ "NuGetRestore@1" ],
                          _js2n__-prdslib.enum [ "NuGetCommand@2" ],
                          _js2n__-prdslib.enum [ "Delay@1" ],
                          _js2n__-prdslib.enum [ "XamariniOS@2" ],
                          _js2n__-prdslib.enum [ "XamariniOS@1" ],
                          _js2n__-prdslib.enum [ "PublishTestResults@2" ],
                          _js2n__-prdslib.enum [ "PublishTestResults@1" ],
                          _js2n__-prdslib.enum [ "AzureFileCopy@5" ],
                          _js2n__-prdslib.enum [ "AzureFileCopy@6" ],
                          _js2n__-prdslib.enum [ "AzureFileCopy@4" ],
                          _js2n__-prdslib.enum [ "AzureFileCopy@2" ],
                          _js2n__-prdslib.enum [ "AzureFileCopy@3" ],
                          _js2n__-prdslib.enum [ "AzureFileCopy@1" ],
                          _js2n__-prdslib.enum [ "PublishSymbols@2" ],
                          _js2n__-prdslib.enum [ "PublishSymbols@1" ],
                          _js2n__-prdslib.enum [ "CopyFilesOverSSH@0" ],
                          _js2n__-prdslib.enum [ "Gradle@2" ],
                          _js2n__-prdslib.enum [ "Gradle@3" ],
                          _js2n__-prdslib.enum [ "Gradle@1" ],
                          _js2n__-prdslib.enum [ "AppCenterDistribute@1" ],
                          _js2n__-prdslib.enum [ "AppCenterDistribute@2" ],
                          _js2n__-prdslib.enum [ "AppCenterDistribute@3" ],
                          _js2n__-prdslib.enum [ "AppCenterDistribute@0" ],
                          _js2n__-prdslib.enum [ "NuGetToolInstaller@0" ],
                          _js2n__-prdslib.enum [ "NuGetToolInstaller@1" ],
                          _js2n__-prdslib.enum [ "JenkinsDownloadArtifacts@1" ],
                          _js2n__-prdslib.enum [ "JenkinsDownloadArtifacts@2" ],
                          _js2n__-prdslib.enum
                            [ "AzureFunctionAppContainer@1" ],
                          _js2n__-prdslib.enum [ "DecryptFile@1" ],
                          _js2n__-prdslib.enum [ "HelmDeploy@1" ],
                          _js2n__-prdslib.enum [ "HelmDeploy@0" ],
                          _js2n__-prdslib.enum [ "InstallAppleCertificate@2" ],
                          _js2n__-prdslib.enum [ "InstallAppleCertificate@1" ],
                          _js2n__-prdslib.enum [ "InstallAppleCertificate@0" ],
                          _js2n__-prdslib.enum [ "AzureFunction@1" ],
                          _js2n__-prdslib.enum [ "AzureFunction@0" ],
                          _js2n__-prdslib.enum [ "OpenPolicyAgentInstaller@0" ],
                          _js2n__-prdslib.enum [ "DownloadGitHubRelease@0" ],
                          _js2n__-prdslib.enum [ "SSH@0" ],
                          _js2n__-prdslib.enum [ "PublishPipelineArtifact@0" ],
                          _js2n__-prdslib.enum [ "PublishPipelineArtifact@1" ],
                          _js2n__-prdslib.enum [ "SonarQubePreBuild@1" ],
                          _js2n__-prdslib.enum
                            [ "DownloadFileshareArtifacts@1" ],
                          _js2n__-prdslib.enum [ "Kubernetes@0" ],
                          _js2n__-prdslib.enum [ "Kubernetes@1" ],
                          _js2n__-prdslib.enum [ "AzureIoTEdge@2" ],
                          _js2n__-prdslib.enum
                            [ "ServiceFabricComposeDeploy@0" ],
                          _js2n__-prdslib.enum [ "AndroidSigning@1" ],
                          _js2n__-prdslib.enum [ "AndroidSigning@2" ],
                          _js2n__-prdslib.enum [ "AndroidSigning@3" ],
                          _js2n__-prdslib.enum [ "DownloadPipelineArtifact@0" ],
                          _js2n__-prdslib.enum [ "DownloadPipelineArtifact@2" ],
                          _js2n__-prdslib.enum [ "DownloadPipelineArtifact@1" ],
                          _js2n__-prdslib.enum [ "UsePythonVersion@0" ],
                          _js2n__-prdslib.enum [ "ServiceFabricPowerShell@1" ],
                          _js2n__-prdslib.enum [ "VSTest@2" ],
                          _js2n__-prdslib.enum [ "VSTest@3" ],
                          _js2n__-prdslib.enum [ "VSTest@1" ],
                          _js2n__-prdslib.enum [ "ManualValidation@1" ],
                          _js2n__-prdslib.enum [ "ManualValidation@0" ],
                          _js2n__-prdslib.enum [ "Ant@1" ],
                          _js2n__-prdslib.enum
                            [ "DeployVisualStudioTestAgent@2" ],
                          _js2n__-prdslib.enum
                            [ "DeployVisualStudioTestAgent@1" ],
                          _js2n__-prdslib.enum [ "CondaEnvironment@0" ],
                          _js2n__-prdslib.enum [ "CondaEnvironment@1" ],
                          _js2n__-prdslib.enum [ "BatchScript@1" ],
                          _js2n__-prdslib.enum [ "DownloadGithubNpmPackage@1" ],
                          _js2n__-prdslib.enum [ "VSBuild@1" ],
                          _js2n__-prdslib.enum [ "AzureKeyVault@1" ],
                          _js2n__-prdslib.enum [ "AzureKeyVault@2" ],
                          _js2n__-prdslib.enum [ "UseDotNet@2" ],
                          _js2n__-prdslib.enum [ "DotNetCoreInstaller@0" ],
                          _js2n__-prdslib.enum [ "DotNetCoreInstaller@1" ],
                          _js2n__-prdslib.enum
                            [ "AzureAppConfigurationImport@10" ],
                          _js2n__-prdslib.enum [ "AzureAppServiceManage@0" ],
                          _js2n__-prdslib.enum [ "KubeloginInstaller@0" ],
                          _js2n__-prdslib.enum [ "FuncToolsInstaller@0" ],
                          _js2n__-prdslib.enum [ "FileTransform@2" ],
                          _js2n__-prdslib.enum [ "FileTransform@1" ],
                          _js2n__-prdslib.enum [ "ExtractFiles@1" ],
                          _js2n__-prdslib.enum [ "XamarinAndroid@1" ],
                          _js2n__-prdslib.enum
                            [ "CopyPublishBuildArtifacts@1" ],
                          _js2n__-prdslib.enum [ "DownloadPackage@0" ],
                          _js2n__-prdslib.enum [ "DownloadPackage@1" ],
                          _js2n__-prdslib.enum
                            [ "AzureResourceGroupDeployment@2" ],
                          _js2n__-prdslib.enum
                            [ "AzureResourceGroupDeployment@1" ],
                          _js2n__-prdslib.enum
                            [ "AzureResourceManagerTemplateDeployment@3" ],
                          _js2n__-prdslib.enum [ "InvokeRESTAPI@0" ],
                          _js2n__-prdslib.enum [ "InvokeRESTAPI@1" ],
                          _js2n__-prdslib.enum [ "ArchiveFiles@2" ],
                          _js2n__-prdslib.enum [ "ArchiveFiles@1" ],
                          _js2n__-prdslib.enum [ "GitHubComment@0" ],
                          _js2n__-prdslib.enum [ "CopyFiles@2" ],
                          _js2n__-prdslib.enum [ "CopyFiles@1" ],
                          _js2n__-prdslib.enum [ "AzureMysqlDeployment@1" ],
                          _js2n__-prdslib.enum [ "Npm@1" ],
                          _js2n__-prdslib.enum [ "Npm@0" ],
                          _js2n__-prdslib.enum [ "AzureStaticWebApp@0" ],
                          _js2n__-prdslib.enum [ "UseNode@1" ],
                          _js2n__-prdslib.enum [ "NodeTool@0" ],
                          _js2n__-prdslib.enum
                            [ "SqlServerDacpacDeployment@1" ],
                          _js2n__-prdslib.enum
                            [ "VisualStudioTestPlatformInstaller@1" ],
                          _js2n__-prdslib.enum [ "PublishToAzureServiceBus@1" ],
                          _js2n__-prdslib.enum [ "PublishToAzureServiceBus@2" ],
                          _js2n__-prdslib.enum [ "PublishToAzureServiceBus@0" ],
                          _js2n__-prdslib.enum [ "KubernetesManifest@0" ],
                          _js2n__-prdslib.enum [ "KubernetesManifest@1" ],
                          _js2n__-prdslib.enum [ "DownloadBuildArtifacts@0" ],
                          _js2n__-prdslib.enum [ "DownloadBuildArtifacts@1" ],
                          _js2n__-prdslib.enum [ "CocoaPods@0" ],
                          _js2n__-prdslib.enum [ "AzureSpringCloud@0" ],
                          _js2n__-prdslib.enum [ "AzureWebApp@1" ],
                          _js2n__-prdslib.enum [ "AzureCLI@1" ],
                          _js2n__-prdslib.enum [ "AzureCLI@0" ],
                          _js2n__-prdslib.enum [ "AzureCLI@2" ],
                          _js2n__-prdslib.enum [ "GitHubRelease@1" ],
                          _js2n__-prdslib.enum [ "GitHubRelease@0" ],
                          _js2n__-prdslib.enum [ "cURLUploader@1" ],
                          _js2n__-prdslib.enum [ "cURLUploader@2" ],
                          _js2n__-prdslib.enum [ "AzureAppServiceSettings@1" ],
                          _js2n__-prdslib.enum [ "UniversalPackages@0" ],
                          _js2n__-prdslib.enum [ "AzurePolicyCheckGate@0" ],
                          _js2n__-prdslib.enum
                            [ "AzureFunctionOnKubernetes@0" ],
                          _js2n__-prdslib.enum
                            [ "AzureFunctionOnKubernetes@1" ],
                          _js2n__-prdslib.enum [ "ShellScript@2" ],
                          _js2n__-prdslib.enum [ "Bash@3" ],
                          _js2n__-prdslib.enum [ "PublishBuildArtifacts@1" ],
                          _js2n__-prdslib.enum [ "InstallSSHKey@0" ],
                          _js2n__-prdslib.enum [ "AzureVmssDeployment@0" ],
                          _js2n__-prdslib.enum [ "AzureVmssDeployment@1" ],
                          _js2n__-prdslib.enum
                            [ "AzureWebPowerShellDeployment@1" ],
                          _js2n__-prdslib.enum [ "CondaAuthenticate@0" ],
                          _js2n__-prdslib.enum
                            [ "AzureCloudPowerShellDeployment@2" ],
                          _js2n__-prdslib.enum
                            [ "AzureCloudPowerShellDeployment@1" ],
                          _js2n__-prdslib.enum [ "CargoAuthenticate@0" ],
                          _js2n__-prdslib.enum [ "DeleteFiles@1" ],
                          _js2n__-prdslib.enum [ "gulp@0" ],
                          _js2n__-prdslib.enum [ "gulp@1" ],
                          _js2n__-prdslib.enum [ "QuickPerfTest@1" ],
                          _js2n__-prdslib.enum
                            [ "IISWebAppManagementOnMachineGroup@0" ],
                          _js2n__-prdslib.enum [ "DockerInstaller@0" ]
                        ],
                  timeoutInMinutes = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/templateContext!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/trigger!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^none$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/branchFilter!predicate"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      batch =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      branches =
                        _js2n__-refsenv."_js2n__-:definitions/includeExcludeFilters!predicate",
                      paths =
                        _js2n__-refsenv."_js2n__-:definitions/includeExcludeFilters!predicate",
                      tags =
                        _js2n__-refsenv."_js2n__-:definitions/includeExcludeFilters!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/triggerBranchFilter!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      exclude =
                        _js2n__-refsenv."_js2n__-:definitions/branchFilterArray!predicate",
                      include =
                        _js2n__-refsenv."_js2n__-:definitions/branchFilterArray!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/branchFilter!predicate"
                ]
            ],
      "_js2n__-:definitions/variable!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      readonly =
                        _js2n__-refsenv."_js2n__-:definitions/boolean!predicate",
                      value =
                        _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      group =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      parameters =
                        _js2n__-refsenv."_js2n__-:definitions/mapping!predicate",
                      template =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/variableRestrictions!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^none$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate"
                ]
            ],
      "_js2n__-:definitions/variables!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/variable!predicate"
                ]
            ],
      "_js2n__-:definitions/webhookFilter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path", "value" ],
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  value =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/webhookFilters!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/webhookFilter!predicate"
            ],
      "_js2n__-:definitions/webhookResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "connection", "webhook" ],
              _js2n__-prdslib.records.record
                {
                  connection =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  filters =
                    _js2n__-refsenv."_js2n__-:definitions/webhookFilters!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  webhook =
                    _js2n__-refsenv."_js2n__-:definitions/referenceName!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/webhookResources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/webhookResource!predicate"
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.oneOf
        [
          _js2n__-refsenv."_js2n__-:definitions/pipeline!predicate",
          _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^$"
            ]
        ])