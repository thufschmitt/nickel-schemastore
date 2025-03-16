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
      "_js2n__-:definitions/A11y!predicate"
        | doc "A list of rules that belong to this group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noAccessKey =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noAriaHiddenOnFocusable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noAriaUnsupportedElements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noAutofocus =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noBlankTarget =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AllowDomainConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDistractingElements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noHeaderScope =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInteractiveElementToNoninteractiveRole =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noLabelWithoutControl =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/NoLabelWithoutControlConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNoninteractiveElementToInteractiveRole =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNoninteractiveTabindex =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noPositiveTabindex =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noRedundantAlt =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noRedundantRoles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSvgWithoutTitle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  recommended =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useAltText =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useAnchorContent =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useAriaActivedescendantWithTabindex =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useAriaPropsForRole =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useButtonType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useFocusableInteractive =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useGenericFontNames =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useHeadingContent =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useHtmlLang =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useIframeTitle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useKeyWithClickEvents =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useKeyWithMouseEvents =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useMediaCaption =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useSemanticElements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useValidAnchor =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useValidAriaProps =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useValidAriaRole =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ValidAriaRoleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useValidAriaValues =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useValidLang =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Accessibility!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "noPublic", "explicit", "none" ]
            ],
      "_js2n__-:definitions/Actions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  source =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Source!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AllowDomainConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithAllowDomainOptions!predicate"
            ],
      "_js2n__-:definitions/AllowDomainOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowDomains =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArrowParentheses!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "always", "asNeeded" ]
            ],
      "_js2n__-:definitions/AssistsConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Actions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AttributePosition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "auto", "multiline" ]
            ],
      "_js2n__-:definitions/BracketSpacing!predicate" =
        _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/Complexity!predicate"
        | doc "A list of rules that belong to this group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noBannedTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noEmptyTypeParameters =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noExcessiveCognitiveComplexity =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ComplexityConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noExcessiveNestedTestSuites =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noExtraBooleanCast =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noForEach =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noMultipleSpacesInRegularExpressionLiterals =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noStaticOnlyClass =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noThisInStatic =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessCatch =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessConstructor =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessEmptyExport =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessFragments =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessLabel =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessLoneBlockStatements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessRename =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessStringConcat =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessSwitchCase =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessTernary =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessThisAlias =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessTypeConstraint =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessUndefinedInitialization =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noVoid =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noWith =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  recommended =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useArrowFunction =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useDateNow =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useFlatMap =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useLiteralKeys =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useOptionalChain =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useRegexLiterals =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useSimpleNumberKeys =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useSimplifiedLogicExpression =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ComplexityConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithComplexityOptions!predicate"
            ],
      "_js2n__-:definitions/ComplexityOptions!predicate"
        | doc "Options for the rule `noExcessiveCognitiveComplexity`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  maxAllowedComplexity =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ConsistentArrayType!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "shorthand" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "generic" ]
                ]
            ],
      "_js2n__-:definitions/ConsistentArrayTypeConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithConsistentArrayTypeOptions!predicate"
            ],
      "_js2n__-:definitions/ConsistentArrayTypeOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  syntax =
                    _js2n__-refsenv."_js2n__-:definitions/ConsistentArrayType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ConsistentMemberAccessibilityConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithConsistentMemberAccessibilityOptions!predicate"
            ],
      "_js2n__-:definitions/ConsistentMemberAccessibilityOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessibility =
                    _js2n__-refsenv."_js2n__-:definitions/Accessibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Convention!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  formats =
                    _js2n__-refsenv."_js2n__-:definitions/Formats!predicate",
                  "match" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Regex!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  selector =
                    _js2n__-refsenv."_js2n__-:definitions/Selector!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Correctness!predicate"
        | doc "A list of rules that belong to this group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noChildrenProp =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noConstAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noConstantCondition =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noConstantMathMinMaxClamp =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noConstructorReturn =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noEmptyCharacterClassInRegex =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noEmptyPattern =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noFlatMapIdentity =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noGlobalObjectCalls =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInnerDeclarations =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInvalidBuiltinInstantiation =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInvalidConstructorSuper =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInvalidDirectionInLinearGradient =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInvalidGridAreas =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInvalidNewBuiltin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInvalidPositionAtImportRule =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInvalidUseBeforeDeclaration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNewSymbol =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNodejsModules =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNonoctalDecimalEscape =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noPrecisionLoss =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noRenderReturnValue =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSelfAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSetterReturn =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noStringCaseMismatch =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSwitchDeclarations =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUndeclaredDependencies =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUndeclaredVariables =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnknownFunction =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnknownMediaFeatureName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnknownProperty =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnknownUnit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnmatchableAnbSelector =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnnecessaryContinue =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnreachable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnreachableSuper =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnsafeFinally =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnsafeOptionalChaining =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnusedFunctionParameters =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnusedImports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnusedLabels =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnusedPrivateClassMembers =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnusedVariables =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noVoidElementsWithChildren =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noVoidTypeReturn =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  recommended =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useArrayLiterals =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useExhaustiveDependencies =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/UseExhaustiveDependenciesConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useHookAtTopLevel =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/DeprecatedHooksConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useImportExtensions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/UseImportExtensionsConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useIsNan =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useJsxKeyInIterable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useValidForDirection =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useYield =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CssAssists!predicate"
        | doc "Options that changes how the CSS assists behaves"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CssConfiguration!predicate"
        | doc "Options applied to CSS files"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  assists =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CssAssists!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  formatter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CssFormatter!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  linter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CssLinter!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  parser =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CssParser!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CssFormatter!predicate"
        | doc "Options that changes how the CSS formatter behaves"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineEnding =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineEnding!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  quoteStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/QuoteStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CssLinter!predicate"
        | doc "Options that changes how the CSS linter behaves"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CssParser!predicate"
        | doc "Options that changes how the CSS parser behaves"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowWrongLineComments =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  cssModules =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CustomRestrictedType!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/CustomRestrictedTypeOptions!predicate"
            ],
      "_js2n__-:definitions/CustomRestrictedTypeOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  message = _js2n__-prdslib.isType '"String",
                  use =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DeprecatedHooksConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithDeprecatedHooksOptions!predicate"
            ],
      "_js2n__-:definitions/DeprecatedHooksOptions!predicate"
        | doc "Options for the `useHookAtTopLevel` rule have been deprecated, since we now use the React hook naming convention to determine whether a function is a hook."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FilenameCase!predicate"
        | doc "Supported cases for file names."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "camelCase" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "export" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "kebab-case" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "PascalCase" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "snake_case" ]
                ]
            ],
      "_js2n__-:definitions/FilenameCases!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/FilenameCase!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/FilenamingConventionConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithFilenamingConventionOptions!predicate"
            ],
      "_js2n__-:definitions/FilenamingConventionOptions!predicate"
        | doc "Rule's options."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  filenameCases =
                    _js2n__-refsenv."_js2n__-:definitions/FilenameCases!predicate",
                  requireAscii = _js2n__-prdslib.isType '"Bool",
                  strictCase = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FilesConfiguration!predicate"
        | doc "The configuration of the filesystem"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignoreUnknown =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  maxSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FixKind!predicate"
        | doc "Used to identify the kind of code action emitted by a rule"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "none" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "safe" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "unsafe" ]
                ]
            ],
      "_js2n__-:definitions/Format!predicate"
        | doc "Supported cases."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "camelCase", "CONSTANT_CASE", "PascalCase", "snake_case" ]
            ],
      "_js2n__-:definitions/Formats!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/Format!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/FormatterConfiguration!predicate"
        | doc "Generic options applied to all files"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  attributePosition =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AttributePosition!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  bracketSpacing =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/BracketSpacing!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  formatWithErrors =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentSize =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineEnding =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineEnding!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useEditorconfig =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GraphqlConfiguration!predicate"
        | doc "Options applied to GraphQL files"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  formatter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GraphqlFormatter!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  linter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GraphqlLinter!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GraphqlFormatter!predicate"
        | doc "Options that changes how the GraphQL formatter behaves"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bracketSpacing =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/BracketSpacing!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineEnding =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineEnding!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  quoteStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/QuoteStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GraphqlLinter!predicate"
        | doc "Options that changes how the GraphQL linter behaves"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Hook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  closureIndex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  dependenciesIndex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  stableResult =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StableHookResult!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/IndentStyle!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "tab" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "space" ]
                ]
            ],
      "_js2n__-:definitions/IndentWidth!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/JavascriptAssists!predicate"
        | doc "Linter options specific to the JavaScript linter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavascriptConfiguration!predicate"
        | doc "A set of options applied to the JavaScript files"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  assists =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JavascriptAssists!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  formatter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JavascriptFormatter!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  globals =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  jsxRuntime =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JsxRuntime!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  linter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JavascriptLinter!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  organizeImports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JavascriptOrganizeImports!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  parser =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JavascriptParser!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavascriptFormatter!predicate"
        | doc "Formatting options specific to the JavaScript files"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arrowParentheses =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ArrowParentheses!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  attributePosition =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AttributePosition!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  bracketSameLine =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  bracketSpacing =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/BracketSpacing!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentSize =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  jsxQuoteStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/QuoteStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineEnding =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineEnding!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  quoteProperties =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/QuoteProperties!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  quoteStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/QuoteStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  semicolons =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Semicolons!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  trailingComma =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/TrailingCommas!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  trailingCommas =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/TrailingCommas!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavascriptLinter!predicate"
        | doc "Linter options specific to the JavaScript linter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavascriptOrganizeImports!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavascriptParser!predicate"
        | doc "Options that changes how the JavaScript parser behaves"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  unsafeParameterDecoratorsEnabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsonAssists!predicate"
        | doc "Linter options specific to the JSON linter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsonConfiguration!predicate"
        | doc "Options applied to JSON files"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  assists =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JsonAssists!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  formatter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JsonFormatter!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  linter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JsonLinter!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  parser =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JsonParser!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsonFormatter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentSize =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineEnding =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineEnding!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  trailingCommas =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/TrailingCommas2!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsonLinter!predicate"
        | doc "Linter options specific to the JSON linter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsonParser!predicate"
        | doc "Options that changes how the JSON parser behaves"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowComments =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  allowTrailingCommas =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsxRuntime!predicate"
        | doc "Indicates the type of runtime or transformation used for interpreting JSX."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "transparent" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "reactClassic" ]
                ]
            ],
      "_js2n__-:definitions/Kind!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum
                    [
                      "class",
                      "enum",
                      "interface",
                      "enumMember",
                      "importNamespace",
                      "exportNamespace",
                      "variable",
                      "const",
                      "let",
                      "using",
                      "var",
                      "catchParameter",
                      "indexParameter",
                      "exportAlias",
                      "importAlias",
                      "classGetter",
                      "classSetter",
                      "classMethod",
                      "objectLiteralProperty",
                      "objectLiteralGetter",
                      "objectLiteralSetter",
                      "objectLiteralMethod",
                      "typeAlias"
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "any" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "typeLike" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "function" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "namespaceLike" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "namespace" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "functionParameter" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "typeParameter" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "classMember" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "classProperty" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "objectLiteralMember" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "typeMember" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "typeGetter" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "typeProperty" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "typeSetter" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "typeMethod" ]
                ]
            ],
      "_js2n__-:definitions/LineEnding!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "lf" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "crlf" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "cr" ]
                ]
            ],
      "_js2n__-:definitions/LineWidth!predicate"
        | doc m%"
          Validated value for the `line_width` formatter options
          
          The allowed range of values is 1..=320
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/LinterConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  rules =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Rules!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Modifiers!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RestrictedModifier!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/NamingConventionConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithNamingConventionOptions!predicate"
            ],
      "_js2n__-:definitions/NamingConventionOptions!predicate"
        | doc "Rule's options."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  conventions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Convention!predicate"
                        ],
                  enumMemberCase =
                    _js2n__-refsenv."_js2n__-:definitions/Format!predicate",
                  requireAscii = _js2n__-prdslib.isType '"Bool",
                  strictCase = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NoConsoleConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithNoConsoleOptions!predicate"
            ],
      "_js2n__-:definitions/NoConsoleOptions!predicate" =
        _js2n__-prdslib.allOf
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
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NoDoubleEqualsConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithNoDoubleEqualsOptions!predicate"
            ],
      "_js2n__-:definitions/NoDoubleEqualsOptions!predicate"
        | doc "Rule's options"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { ignoreNull = _js2n__-prdslib.isType '"Bool", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NoLabelWithoutControlConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithNoLabelWithoutControlOptions!predicate"
            ],
      "_js2n__-:definitions/NoLabelWithoutControlOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  inputComponents =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labelAttributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labelComponents =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NoRestrictedTypesConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithNoRestrictedTypesOptions!predicate"
            ],
      "_js2n__-:definitions/NoRestrictedTypesOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/CustomRestrictedType!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NoSecretsConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithNoSecretsOptions!predicate"
            ],
      "_js2n__-:definitions/NoSecretsOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  entropyThreshold =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Nursery!predicate"
        | doc "A list of rules that belong to this group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noCommonJs =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDescendingSpecificity =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDocumentCookie =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDocumentImportInPage =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateCustomProperties =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateElseIf =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateProperties =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicatedFields =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDynamicNamespaceImportAccess =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noEnum =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noExportedImports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noHeadElement =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noHeadImportInDocument =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noImgElement =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noIrregularWhitespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noMissingVarFunction =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNestedTernary =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noOctalEscape =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noProcessEnv =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noRestrictedImports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RestrictedImportsConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noRestrictedTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/NoRestrictedTypesConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSecrets =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/NoSecretsConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noStaticElementInteractions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSubstr =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noTemplateCurlyInString =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnknownPseudoClass =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnknownPseudoElement =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnknownTypeSelector =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessEscapeInRegex =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessStringRaw =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noValueAtRule =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  recommended =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useAdjacentOverloadSignatures =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useAriaPropsSupportedByRole =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useAtIndex =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useCollapsedIf =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useComponentExportOnlyModules =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/UseComponentExportOnlyModulesConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useConsistentCurlyBraces =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useConsistentMemberAccessibility =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ConsistentMemberAccessibilityConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useDeprecatedReason =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useExplicitType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useGoogleFontDisplay =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useGuardForIn =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useImportRestrictions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useSortedClasses =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/UtilityClassSortingConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useStrictMode =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useTrimStartEnd =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useValidAutocomplete =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/UseValidAutocompleteConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OrganizeImports!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OverrideFormatterConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  attributePosition =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AttributePosition!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  bracketSpacing =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/BracketSpacing!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  formatWithErrors =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentSize =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentStyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  indentWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineEnding =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineEnding!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lineWidth =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OverrideLinterConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  rules =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Rules!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OverrideOrganizeImportsConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OverridePattern!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  css =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CssConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  formatter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/OverrideFormatterConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  graphql =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GraphqlConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  javascript =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JavascriptConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  json =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JsonConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  linter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/OverrideLinterConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  organizeImports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/OverrideOrganizeImportsConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Overrides!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/OverridePattern!predicate"
            ],
      "_js2n__-:definitions/Performance!predicate"
        | doc "A list of rules that belong to this group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noAccumulatingSpread =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noBarrelFile =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDelete =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noReExportAll =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  recommended =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useTopLevelRegex =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/QuoteProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "asNeeded", "preserve" ]
            ],
      "_js2n__-:definitions/QuoteStyle!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "double", "single" ]
            ],
      "_js2n__-:definitions/Regex!predicate" = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/RestrictedGlobalsConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithRestrictedGlobalsOptions!predicate"
            ],
      "_js2n__-:definitions/RestrictedGlobalsOptions!predicate"
        | doc "Options for the rule `noRestrictedGlobals`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  deniedGlobals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RestrictedImportsConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithRestrictedImportsOptions!predicate"
            ],
      "_js2n__-:definitions/RestrictedImportsOptions!predicate"
        | doc "Options for the rule `noRestrictedImports`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RestrictedModifier!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "abstract", "private", "protected", "readonly", "static" ]
            ],
      "_js2n__-:definitions/RuleAssistConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "on", "off" ]
            ],
      "_js2n__-:definitions/RuleConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithNoOptions!predicate"
            ],
      "_js2n__-:definitions/RuleFixConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithFixNoOptions!predicate"
            ],
      "_js2n__-:definitions/RulePlainConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "warn", "error", "info", "off" ]
            ],
      "_js2n__-:definitions/RuleWithAllowDomainOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDomainOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithComplexityOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ComplexityOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithConsistentArrayTypeOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ConsistentArrayTypeOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithConsistentMemberAccessibilityOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ConsistentMemberAccessibilityOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithDeprecatedHooksOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/DeprecatedHooksOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithFilenamingConventionOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/FilenamingConventionOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithFixNoOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithNamingConventionOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/NamingConventionOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithNoConsoleOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/NoConsoleOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithNoDoubleEqualsOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/NoDoubleEqualsOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithNoLabelWithoutControlOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/NoLabelWithoutControlOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithNoOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithNoRestrictedTypesOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/NoRestrictedTypesOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithNoSecretsOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/NoSecretsOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithRestrictedGlobalsOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/RestrictedGlobalsOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithRestrictedImportsOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/RestrictedImportsOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithUseComponentExportOnlyModulesOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/UseComponentExportOnlyModulesOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithUseExhaustiveDependenciesOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/UseExhaustiveDependenciesOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithUseImportExtensionsOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/UseImportExtensionsOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithUseValidAutocompleteOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/UseValidAutocompleteOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithUtilityClassSortingOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/UtilityClassSortingOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleWithValidAriaRoleOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "level", "options" ],
              _js2n__-prdslib.records.record
                {
                  fix =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FixKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ValidAriaRoleOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Rules!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  a11y =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/A11y!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  all =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  complexity =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Complexity!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  correctness =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Correctness!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  nursery =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Nursery!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  performance =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Performance!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  recommended =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  security =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Security!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  style =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Style!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  suspicious =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Suspicious!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Scope!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "any", "global" ]
            ],
      "_js2n__-:definitions/Security!predicate"
        | doc "A list of rules that belong to this group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDangerouslySetInnerHtml =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDangerouslySetInnerHtmlWithChildren =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noGlobalEval =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  recommended =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Selector!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  kind = _js2n__-refsenv."_js2n__-:definitions/Kind!predicate",
                  modifiers =
                    _js2n__-refsenv."_js2n__-:definitions/Modifiers!predicate",
                  scope =
                    _js2n__-refsenv."_js2n__-:definitions/Scope!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Semicolons!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "always", "asNeeded" ]
            ],
      "_js2n__-:definitions/Source!predicate"
        | doc "A list of rules that belong to this group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  sortJsxProps =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleAssistConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useSortedKeys =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleAssistConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StableHookResult!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.maximum 255,
                        _js2n__-prdslib.numbers.minimum 0
                      ]),
                  _js2n__-prdslib.arrays.minItems 1
                ]
            ],
      "_js2n__-:definitions/StringSet!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/Style!predicate"
        | doc "A list of rules that belong to this group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noArguments =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noCommaOperator =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDefaultExport =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDoneCallback =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noImplicitBoolean =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noInferrableTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNamespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNamespaceImport =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNegationElse =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noNonNullAssertion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noParameterAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noParameterProperties =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noRestrictedGlobals =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RestrictedGlobalsConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noShoutyConstants =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnusedTemplateLiteral =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUselessElse =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noVar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noYodaExpression =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  recommended =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useAsConstAssertion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useBlockStatements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useCollapsedElseIf =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useConsistentArrayType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ConsistentArrayTypeConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useConsistentBuiltinInstantiation =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useConst =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useDefaultParameterLast =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useDefaultSwitchClause =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useEnumInitializers =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useExplicitLengthCheck =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useExponentiationOperator =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useExportType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useFilenamingConvention =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FilenamingConventionConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useForOf =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useFragmentSyntax =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useImportType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useLiteralEnumMembers =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useNamingConvention =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/NamingConventionConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useNodeAssertStrict =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useNodejsImportProtocol =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useNumberNamespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useNumericLiterals =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useSelfClosingElements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useShorthandArrayType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useShorthandAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useShorthandFunctionType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useSingleCaseStatement =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useSingleVarDeclarator =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useTemplate =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useThrowNewError =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useThrowOnlyError =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useWhile =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SuggestedExtensionMapping!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  component = _js2n__-prdslib.isType '"String",
                  module = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Suspicious!predicate"
        | doc "A list of rules that belong to this group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noApproximativeNumericConstant =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noArrayIndexKey =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noAssignInExpressions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noAsyncPromiseExecutor =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noCatchAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noClassAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noCommentText =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noCompareNegZero =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noConfusingLabels =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noConfusingVoidType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noConsole =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/NoConsoleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noConsoleLog =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noConstEnum =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noControlCharactersInRegex =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDebugger =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDoubleEquals =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/NoDoubleEqualsConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateAtImportRules =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateCase =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateClassMembers =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateFontNames =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateJsxProps =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateObjectKeys =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateParameters =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateSelectorsKeyframeBlock =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noDuplicateTestHooks =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noEmptyBlock =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noEmptyBlockStatements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noEmptyInterface =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noEvolvingTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noExplicitAny =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noExportsInTest =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noExtraNonNullAssertion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noFallthroughSwitchClause =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noFocusedTests =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noFunctionAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noGlobalAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noGlobalIsFinite =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noGlobalIsNan =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noImplicitAnyLet =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noImportAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noImportantInKeyframe =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noLabelVar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noMisleadingCharacterClass =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noMisleadingInstantiator =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noMisplacedAssertion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noMisrefactoredShorthandAssign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noPrototypeBuiltins =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noReactSpecificProps =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noRedeclare =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noRedundantUseStrict =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSelfCompare =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noShadowRestrictedNames =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noShorthandPropertyOverrides =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSkippedTests =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSparseArray =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noSuspiciousSemicolonInJsx =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noThenProperty =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnsafeDeclarationMerging =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  noUnsafeNegation =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  recommended =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useAwait =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useDefaultSwitchClauseLast =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useErrorMessage =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useGetterReturn =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useIsArray =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useNamespaceKeyword =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useNumberToFixedDigitsArgument =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useValidTypeof =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuleFixConfiguration!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TrailingCommas!predicate"
        | doc "Print trailing commas wherever possible in multi-line comma-separated syntactic structures."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "all" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "es5" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "none" ]
                ]
            ],
      "_js2n__-:definitions/TrailingCommas2!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "none" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "all" ]
                ]
            ],
      "_js2n__-:definitions/UseComponentExportOnlyModulesConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithUseComponentExportOnlyModulesOptions!predicate"
            ],
      "_js2n__-:definitions/UseComponentExportOnlyModulesOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowConstantExport = _js2n__-prdslib.isType '"Bool",
                  allowExportNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UseExhaustiveDependenciesConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithUseExhaustiveDependenciesOptions!predicate"
            ],
      "_js2n__-:definitions/UseExhaustiveDependenciesOptions!predicate"
        | doc "Options for the rule `useExhaustiveDependencies`"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  hooks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Hook!predicate"
                        ],
                  reportMissingDependenciesArray =
                    _js2n__-prdslib.isType '"Bool",
                  reportUnnecessaryDependencies =
                    _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UseImportExtensionsConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithUseImportExtensionsOptions!predicate"
            ],
      "_js2n__-:definitions/UseImportExtensionsOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  suggestedExtensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/SuggestedExtensionMapping!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UseValidAutocompleteConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithUseValidAutocompleteOptions!predicate"
            ],
      "_js2n__-:definitions/UseValidAutocompleteOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  inputComponents =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UtilityClassSortingConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithUtilityClassSortingOptions!predicate"
            ],
      "_js2n__-:definitions/UtilityClassSortingOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  functions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ValidAriaRoleConfiguration!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RulePlainConfiguration!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RuleWithValidAriaRoleOptions!predicate"
            ],
      "_js2n__-:definitions/ValidAriaRoleOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowInvalidRoles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignoreNonDom = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VcsClientKind!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "git" ]
                ]
            ],
      "_js2n__-:definitions/VcsConfiguration!predicate"
        | doc "Set of properties to integrate Biome with a VCS software."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clientKind =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/VcsClientKind!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  defaultBranch =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  root =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  useIgnoreFile =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      "$schema"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc "A field for the [JSON schema](https://json-schema.org/) specification"
        | optional,
      assists
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/AssistsConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Specific configuration for assists"
        | optional,
      css
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/CssConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Specific configuration for the Css language"
        | optional,
      extends
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "A list of paths to other JSON files, used to extends the current configuration."
        | optional,
      files
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FilesConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "The configuration of the filesystem"
        | optional,
      formatter
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FormatterConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "The configuration of the formatter"
        | optional,
      graphql
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/GraphqlConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Specific configuration for the GraphQL language"
        | optional,
      javascript
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/JavascriptConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Specific configuration for the JavaScript language"
        | optional,
      json
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/JsonConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Specific configuration for the Json language"
        | optional,
      linter
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LinterConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "The configuration for the linter"
        | optional,
      organizeImports
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/OrganizeImports!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "The configuration of the import sorting"
        | optional,
      overrides
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Overrides!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "A list of granular patterns that should be applied only to a sub set of files"
        | optional,
      vcs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/VcsConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "The configuration of the VCS integration"
        | optional,
    }