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
      "_js2n__-:definitions/binaryRepository!contract"
        | doc "Binary repository details"
        = {
            address | String | doc "Repository URL",
            credentials
              | _js2n__-refsenv."_js2n__-:definitions/credentials!contract"
              | doc "Jenkins credentials ID for connecting to this repository",
          },
      "_js2n__-:definitions/branchPattern!contract"
        | doc "Regular expression for validating branch names"
        = String,
      "_js2n__-:definitions/branchPattern!predicate"
        | doc "Regular expression for validating branch names"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/cacheItem!contract" =
        {
            enabled | Bool | doc "Sets whether this cache type is enabled",
            source
              | String
              | doc "Location of the cache in the Jenkins workspace"
              | optional,
            target
              | String
              | doc "Location of the cache directory inside the Docker container"
              | optional,
            type
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.enum [ "maven", "npm", "local" ])
              | doc "Cache type",
          },
      "_js2n__-:definitions/checkmarx!contract" =
        {
            branch_pattern
              | _js2n__-refsenv."_js2n__-:definitions/branchPattern!contract"
              | doc "Specifies in which branches this stage will be executed"
              | optional,
            credentialsId | String | doc "Jenkins credentials ID" | optional,
            enabled
              | Bool
              | doc "Sets whether the scan should be run"
              | optional,
            excludeFolders
              | String
              | doc "Comma separated list of folders to be excluded from the CxSAST scan"
              | optional,
            exclusionsSetting
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.enum [ "job", "global" ])
              | doc "Specifies which exclusions settings to use: global (Jenkins global settings) or job (current pipeline)"
              | optional,
            filterPattern
              | String
              | doc "Defines the include/exclude wildcard patterns. Does not have effect when \"exclusionsSetting\" is set to \"global\""
              | optional,
            groupId
              | String
              | doc "Fully qualified team name for the project"
              | optional,
            hideDebugLogs
              | Bool
              | doc "Sets whether debug logs are visible in the job output"
              | optional,
            highThreshold
              | std.number.Integer
              | doc "Sets the maximum number of High vulnerabilities allowed"
              | optional,
            isProxy | Bool | optional,
            lowThreshold
              | std.number.Integer
              | doc "Sets the maximum number of Low vulnerabilities allowed"
              | optional,
            mediumThreshold
              | std.number.Integer
              | doc "Sets the maximum number of Medium vulnerabilities allowed"
              | optional,
            preset | String | doc "Scan preset for the project" | optional,
            projectName
              | String
              | doc "Unique project name. Will be inferred from the repository name if not provided"
              | optional,
            serverUrl
              | String
              | doc "Checkmarx Server URL or IP address"
              | optional,
            sourceEncoding
              | String
              | doc "Language encoding ID associated to the source code character encoding (5: Multi-Language Scan)"
              | optional,
            useOwnServerCredentials
              | Bool
              | doc "Enables the use of the default server credentials or disables and provides server and credentials that override the defaults"
              | optional,
            vulnerabilityThresholdEnabled
              | Bool
              | doc "Sets whether the scan should fail if the number of vulnerabilities is above the configured thresholds. This option is only available if the waitForResultsEnabled parameter is enabled"
              | optional,
            waitForResultsEnabled
              | Bool
              | doc "Sets whether the scan should be executed synchronously (default). The Synchronous mode allows viewing scan results in Jenkins"
              | optional,
          },
      "_js2n__-:definitions/credentials!contract"
        | doc "Jenkins credentials ID"
        = String,
      "_js2n__-:definitions/dockerReleaseChannel!contract" =
        {
            branch
              | _js2n__-refsenv."_js2n__-:definitions/releaseChannelBranch!contract",
            channel
              | _js2n__-refsenv."_js2n__-:definitions/releaseChannel!contract",
            credentials
              | _js2n__-refsenv."_js2n__-:definitions/credentials!contract"
              | doc "Jenkins credentials ID for publishing into the specified Docker registry",
            registry
              | String
              | doc "Docker registry. Must include protocol (http|https) and port",
          },
      "_js2n__-:definitions/dockerfile!contract"
        | doc "Dockerfile path"
        = String,
      "_js2n__-:definitions/failFast!predicate"
        | doc "Forces parallel stages to all be aborted when one of them fails"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/helmReleaseChannel!contract" =
        {
            branch
              | _js2n__-refsenv."_js2n__-:definitions/releaseChannelBranch!contract",
            channel
              | _js2n__-refsenv."_js2n__-:definitions/releaseChannel!contract",
            credentials
              | _js2n__-refsenv."_js2n__-:definitions/credentials!contract"
              | doc "Jenkins credentials Id for this repository for uploading the chart",
            repository
              | String
              | doc "Helm chart repository. Must include protocol, host, port (if needed) and path",
          },
      "_js2n__-:definitions/outputDocker!contract" =
        {
            images
              | Array
                _js2n__-refsenv."_js2n__-:definitions/outputDockerImage!contract",
            multiArch
              | {
                architectures | Array (String) | optional,
                enabled
                  | Bool
                  | doc "Whether the multi-arch build should be enabled"
                  | optional,
                ..
              }
              | optional,
            publish
              | _js2n__-refsenv."_js2n__-:definitions/outputDockerPublish!contract"
              | doc "Docker publishing information. If not present, no images will be published"
              | optional,
          },
      "_js2n__-:definitions/outputDockerBuildArgs!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "key", "value" ],
                        _js2n__-prdslib.records.record
                          {
                            additionalProperties = _js2n__-prdslib.never,
                            key = _js2n__-prdslib.isType '"String",
                            value = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "env", "key" ],
                        _js2n__-prdslib.records.record
                          {
                            additionalProperties = _js2n__-prdslib.never,
                            env =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^[A-Za-z_][A-Za-z0-9_]*$"
                                  ],
                            key = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ]
                  ],
                _js2n__-prdslib.records.record
                  {
                    env =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.pattern
                              "^[A-Za-z_][A-Za-z0-9_]*$"
                          ],
                    key = _js2n__-prdslib.isType '"String",
                    value = _js2n__-prdslib.isType '"String",
                  } {} true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/outputDockerImage!contract" =
        {
            args
              | Array
                _js2n__-refsenv."_js2n__-:definitions/outputDockerBuildArgs!contract"
              | doc "List of build args (--build-arg) to pass in docker build"
              | optional,
            dockerfile
              | _js2n__-refsenv."_js2n__-:definitions/dockerfile!contract"
              | doc "Path to Dockerfile used to generate the docker image",
            name | String | doc "Docker image name",
            vulnerability_scan
              | {
                enabled
                  | Bool
                  | doc "Whether the vulnerability scan step should be run",
              }
              | doc "Configuration for running vulnerability scans on published Docker images"
              | optional,
          },
      "_js2n__-:definitions/outputDockerPublish!contract" =
        Array
            _js2n__-refsenv."_js2n__-:definitions/dockerReleaseChannel!contract",
      "_js2n__-:definitions/outputHelm!contract" =
        {
            charts
              | Array
                _js2n__-refsenv."_js2n__-:definitions/outputHelmChart!contract"
              | optional,
            publish
              | _js2n__-refsenv."_js2n__-:definitions/outputHelmPublish!contract"
              | doc "Helm chart publishing configuration. If not present, no charts will be published",
          },
      "_js2n__-:definitions/outputHelmChart!contract" =
        {
            path | String | doc "Path to the Helm chart directory",
            updates
              | Array
                _js2n__-refsenv."_js2n__-:definitions/outputHelmUpdates!contract"
              | doc "List of files to update"
              | optional,
          },
      "_js2n__-:definitions/outputHelmPublish!contract" =
        Array
            _js2n__-refsenv."_js2n__-:definitions/helmReleaseChannel!contract",
      "_js2n__-:definitions/outputHelmUpdates!contract" =
        {
            file
              | String
              | doc "Name (including path from Helm object path) of the file to be updated. Only supports yaml files",
            properties
              | Array
                _js2n__-refsenv."_js2n__-:definitions/outputHelmUpdatesProperties!contract"
              | doc "A list of properties to update. It can be updated with a fixed value or environment variable",
          },
      "_js2n__-:definitions/outputHelmUpdatesProperties!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "env", "key" ],
                        _js2n__-prdslib.records.record
                          {
                            additionalProperties = _js2n__-prdslib.never,
                            env =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^[A-Za-z_][A-Za-z0-9_]*$"
                                  ],
                            key = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "key", "value" ],
                        _js2n__-prdslib.records.record
                          {
                            key = _js2n__-prdslib.isType '"String",
                            value = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ]
                  ]
              ]),
      "_js2n__-:definitions/outputPackage!contract" =
        {
            publish
              | _js2n__-refsenv."_js2n__-:definitions/outputPackagePublish!contract"
              | doc "Package publish configuration.",
          },
      "_js2n__-:definitions/outputPackagePublish!contract" =
        Array
            _js2n__-refsenv."_js2n__-:definitions/packagePublishChannel!contract",
      "_js2n__-:definitions/packagePublishChannel!contract" =
        {
            branch
              | _js2n__-refsenv."_js2n__-:definitions/releaseChannelBranch!contract",
            channel
              | _js2n__-refsenv."_js2n__-:definitions/releaseChannel!contract",
            credentials
              | _js2n__-refsenv."_js2n__-:definitions/credentials!contract"
              | doc "Jenkins credentials ID for publishing into the specified Docker registry"
              | optional,
            maven_releases_repo
              | String
              | doc "Maven repository for deploying releases"
              | optional,
            maven_snapshots_repo
              | String
              | doc "Maven repository for deploying snapshots"
              | optional,
            params
              | String
              | doc "Optional params for npm publish or mvn deploy command."
              | optional,
            registry
              | String
              | doc "NPM registry (env variable or registry URL)"
              | optional,
          },
      "_js2n__-:definitions/parallelStage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "parallel" ],
              _js2n__-prdslib.records.record
                {
                  fail_fast =
                    _js2n__-refsenv."_js2n__-:definitions/failFast!predicate",
                  parallel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^\\w+( \\w+)*$" =
                                _js2n__-refsenv."_js2n__-:definitions/singleStage!predicate",
                            } true _js2n__-prdslib.always
                        ],
                  when = _js2n__-refsenv."_js2n__-:definitions/when!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/releaseChannel!contract"
        | doc "Release channel name"
        = String,
      "_js2n__-:definitions/releaseChannelBranch!contract"
        | doc "Indicates on which branches the artifact will be published"
        = _js2n__-refsenv."_js2n__-:definitions/branchPattern!contract",
      "_js2n__-:definitions/singleStage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "steps" ],
              _js2n__-prdslib.records.record
                {
                  steps =
                    _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                  when = _js2n__-refsenv."_js2n__-:definitions/when!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sonar!contract" =
        {
            branch_analysis
              | Bool
              | doc "Indicates whether sonnar server supports branch analysis, to provide dedicated parameters."
              | optional,
            branch_pattern
              | String
              | doc "Indicates on which branches static analysis will be performed."
              | optional,
            breaks_build
              | Bool
              | doc "Waits for analysis result and breaks the build when the project fails for some quality gates"
              | optional,
            enabled | Bool | optional,
            exclusions
              | String
              | doc "Comma separated list of wildcard patterns defining files to be excluded from the SonarQube scan"
              | optional,
            image
              | String
              | doc "Prebuilt Docker image for running scan into it. If not specified, it will use the same image used for main build."
              | optional,
            timeout
              | _js2n__-refsenv."_js2n__-:definitions/timeout!contract"
              | doc "Seconds to wait for the result of the quality gate. Only applies when breaks_build is set to true"
              | optional,
          },
      "_js2n__-:definitions/stage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/singleStage!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/parallelStage!predicate"
                ],
              _js2n__-prdslib.records.record
                {
                  fail_fast =
                    _js2n__-refsenv."_js2n__-:definitions/failFast!predicate",
                  parallel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^\\w+( \\w+)*$" =
                                _js2n__-refsenv."_js2n__-:definitions/singleStage!predicate",
                            } true _js2n__-prdslib.always
                        ],
                  steps =
                    _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                  when = _js2n__-refsenv."_js2n__-:definitions/when!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/steps!predicate"
        | doc "List of steps to run"
        = _js2n__-prdslib.isType '"Array",
      "_js2n__-:definitions/timeout!contract"
        | doc "Timeout in seconds"
        = std.number.Integer,
      "_js2n__-:definitions/when!predicate"
        | doc "Condition that should be met to run this step"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  branch =
                    _js2n__-refsenv."_js2n__-:definitions/branchPattern!predicate",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      archive
        | Array Dyn
        | doc "List of artifacts to archive (wildcards allowed). Check out https://www.jenkins.io/doc/pipeline/steps/core/#archiveartifacts-archive-the-artifacts"
        | optional,
      config
        | {
          branch
            | {
              branch_pattern
                | _js2n__-refsenv."_js2n__-:definitions/branchPattern!contract"
                | optional,
              disable_validation
                | Bool
                | doc "Disables branch name validation"
                | optional,
            }
            | doc "Describes on which branch names a build will be run"
            | optional,
          build
            | {
              checkmarx
                | _js2n__-refsenv."_js2n__-:definitions/checkmarx!contract"
                | doc "Adds a Static Analysis stage for CheckMarx. See https://www.jenkins.io/doc/pipeline/steps/checkmarx/ for all the configuration options."
                | optional,
              clean_workspace_after_run
                | Bool
                | doc "Whether Jenkins workspace should be cleaned after the build"
                | optional,
              commit_time_threshold
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.const 0
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^\\d+[mhd]$"
                        ]
                    ])
                | doc "Commit age threshold. Disables automated builds older than this parameter. When 0, this feature is disabled"
                | optional,
              static_analysis
                | _js2n__-refsenv."_js2n__-:definitions/sonar!contract"
                | doc "Adds a Static Analysis stage for Sonar."
                | optional,
            }
            | optional,
          cache
            | {
              items
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/cacheItem!contract"
                | doc "List of cache types"
                | optional,
              repository
                | _js2n__-refsenv."_js2n__-:definitions/binaryRepository!contract"
                | optional,
            }
            | doc "Cache configuration for projects built inside Docker containers"
            | optional,
          jenkins_runtime
            | {
              docker
                | {
                  dockerfile
                    | _js2n__-refsenv."_js2n__-:definitions/dockerfile!contract"
                    | doc "Path to a local Dockerfile"
                    | optional,
                  image
                    | String
                    | doc "Prebuilt Docker image (has precedence over dockerfile)"
                    | optional,
                }
                | doc "Specifies how to build the Docker container (from an existing image or from a local Dockerfile)",
            }
            | optional,
        }
        | optional,
      environment
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.propertyNames
                (_js2n__-prdslib.strings.pattern "^[A-Za-z_][A-Za-z0-9_]*$"),
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ])
        | doc "Custom environment variables to be added to the pipeline"
        | optional,
      jenkinsEnvironment
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[A-Za-z_][A-Za-z0-9_]*$"
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Jenkins environment variables that are passed to the Docker container"
        | optional,
      output
        | {
          docker
            | _js2n__-refsenv."_js2n__-:definitions/outputDocker!contract"
            | doc "Configuration for generating a Docker image"
            | optional,
          helm
            | _js2n__-refsenv."_js2n__-:definitions/outputHelm!contract"
            | doc "Configuration for generating a Helm chart"
            | optional,
          package
            | _js2n__-refsenv."_js2n__-:definitions/outputPackage!contract"
            | doc "Configuration for publishing NPM or Maven packages"
            | optional,
        }
        | doc "Describes artifacts generated after all the stages have been run"
        | optional,
      project
        | {
          name
            | String
            | doc "Project's name (used by Jenkins, Docker and Sonar)"
            | optional,
          settings
            | String
            | doc "ID of a managed maven or npm Jenkins file"
            | optional,
          type
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "npm", "maven", "mvn" ])
            | doc "Project type"
            | optional,
        }
        | doc "Project properties",
      services
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.enum
                  [
                    "Postgres",
                    "Postgis",
                    "Redis",
                    "Mssql",
                    "Mysql",
                    "Mongodb",
                    "Elasticsearch"
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Additional services required by the project or application."
        | optional,
      stages
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^\\w+( \\w+)*$" =
                    _js2n__-refsenv."_js2n__-:definitions/stage!predicate",
                } true _js2n__-prdslib.always
            ])
        | doc "Defines the stages and steps required to build the project."
        | optional,
      timeout
        | _js2n__-refsenv."_js2n__-:definitions/timeout!contract"
        | doc "Build timeout in seconds"
        | optional,
      ..
    }