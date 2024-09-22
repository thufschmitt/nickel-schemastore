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
      "_js2n__-:definitions/ApplicationType!predicate"
        | doc "Type of Mobile Application"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HYBRID", "NATIVE", "WEB" ]
            ],
      "_js2n__-:definitions/AutomationType!predicate"
        | doc "Target Appium Driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "UI_AUTOMATOR", "XCUI" ]
            ],
      "_js2n__-:definitions/Browser!predicate"
        | doc "Target Web Browser"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "CHROME", "EDGE", "FIREFOX", "NONE", "REMOTE", "SAFARI" ]
            ],
      "_js2n__-:definitions/DeviceType!predicate"
        | doc "Type of Target Device"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "CLOUD", "VIRTUAL" ]
            ],
      "_js2n__-:definitions/LogLevel!predicate"
        | doc "Log level used to capture the Appium server logging"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "DEBUG",
                  "DEBUG_DEBUG",
                  "DEBUG_ERROR",
                  "DEBUG_INFO",
                  "DEBUG_WARN",
                  "ERROR",
                  "ERROR_DEBUG",
                  "ERROR_ERROR",
                  "ERROR_INFO",
                  "ERROR_WARN",
                  "INFO",
                  "INFO_DEBUG",
                  "INFO_ERROR",
                  "INFO_INFO",
                  "INFO_WARN",
                  "WARN",
                  "WARN_DEBUG",
                  "WARN_ERROR",
                  "WARN_INFO",
                  "WARN_WARN"
                ]
            ],
      "_js2n__-:definitions/OS!predicate"
        | doc "Target Mobile OS"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "ANDROID", "IOS" ]
            ],
      "_js2n__-:definitions/PageLoadStrategy!predicate"
        | doc "Page Load strategy for Web application"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "EAGER", "NORMAL" ]
            ],
      "_js2n__-:definitions/Protocol!predicate"
        | doc "Protocol for Target server"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HTTP", "HTTPS" ]
            ],
      "_js2n__-:definitions/Speed!predicate"
        | doc "Swiping speed for Mobile devices"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "FAST", "NORMAL", "SLOW" ]
            ],
      "_js2n__-:definitions/TargetProviders!predicate"
        | doc "Target Cloud providers"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "BROWSER_STACK",
                  "LAMBDA_TEST_MOBILE",
                  "LAMBDA_TEST_WEB",
                  "LOCAL"
                ]
            ],
      "_js2n__-:definitions/VideoQuality!predicate"
        | doc "Video recording quality"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "LOW", "MEDIUM", "HIGH", "PHOTO" ]
            ],
      "_js2n__-:definitions/WindowResizeType!predicate"
        | doc "Window resize type for Web Browser"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "CUSTOM", "FULL_SCREEN", "MAXIMIZED", "MINIMIZED", "NORMAL" ]
            ],
      "_js2n__-:definitions/args!predicate"
        | doc "Arguments object where you can add any arguments"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
            ],
      "_js2n__-:definitions/caps!predicate"
        | doc "Capabilities object where you can add any capability based on the Cloud platform supported or Grid supported capabilities"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
            ],
    }
    in
  {
      api
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "base_uri" ],
                    _js2n__-prdslib.records.record
                      {
                        base_path = _js2n__-prdslib.isType '"String",
                        base_uri = _js2n__-prdslib.isType '"String",
                        connection_timeout = _js2n__-prdslib.isType '"Number",
                        logging =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    enable = _js2n__-prdslib.isType '"Bool",
                                    request = _js2n__-prdslib.isType '"Bool",
                                    response = _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always
                              ],
                        port = _js2n__-prdslib.isType '"Number",
                        read_timeout = _js2n__-prdslib.isType '"Number",
                        schema_path = _js2n__-prdslib.isType '"String",
                        validate_ssl = _js2n__-prdslib.isType '"Bool",
                        verify_host_name = _js2n__-prdslib.isType '"Bool",
                        write_timeout = _js2n__-prdslib.isType '"Number",
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "Collection of API configurations"
        | optional,
      listeners_package
        | String
        | doc "Package name where all the Boyka listener implementations are placed"
        | optional,
      ui
        | {
          delay
            | {
              before_click
                | Number
                | doc "Delay before clicking on an element (in ms)"
                | optional,
              before_mouse_move
                | Number
                | doc "Delay before moving of mouse (in ms)"
                | optional,
              before_swipe
                | Number
                | doc "Delay before swiping on the device screen or inside an element (in ms)"
                | optional,
              before_tap
                | Number
                | doc "Delay before tapping on an element (in ms)"
                | optional,
              before_typing
                | Number
                | doc "Delay before typing any text in an element (in ms)"
                | optional,
              ..
            }
            | doc "UI interaction delay settings"
            | optional,
          logging
            | {
              enable
                | Bool
                | doc "If true, any log files generated by Selenium or Appium would be saved"
                | optional,
              exclude_logs
                | Array (String)
                | doc "List of type of logs which you want to exclude from"
                | optional,
              path
                | String
                | doc "Path where the logs should be saved"
                | optional,
              ..
            }
            | doc "UI logging related settings"
            | optional,
          mobile
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            device =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        accept_alerts =
                                          _js2n__-prdslib.isType '"Bool",
                                        adb_timeout =
                                          _js2n__-prdslib.isType '"Number",
                                        application =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    base_url =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    browser =
                                                      _js2n__-refsenv."_js2n__-:definitions/Browser!predicate",
                                                    bundle_id =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    chrome_driver_port =
                                                      _js2n__-prdslib.isType
                                                          '"Number",
                                                    external =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    install_timeout =
                                                      _js2n__-prdslib.isType
                                                          '"Number",
                                                    path =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    type =
                                                      _js2n__-refsenv."_js2n__-:definitions/ApplicationType!predicate",
                                                    wait_activity =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    wait_timeout =
                                                      _js2n__-prdslib.isType
                                                          '"Number",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        capabilities =
                                          _js2n__-refsenv."_js2n__-:definitions/caps!predicate",
                                        clear_files =
                                          _js2n__-prdslib.isType '"Bool",
                                        clear_logs =
                                          _js2n__-prdslib.isType '"Bool",
                                        full_reset =
                                          _js2n__-prdslib.isType '"Bool",
                                        ignore_unimportant_views =
                                          _js2n__-prdslib.isType '"Bool",
                                        name = _js2n__-prdslib.isType '"String",
                                        no_reset =
                                          _js2n__-prdslib.isType '"Bool",
                                        os =
                                          _js2n__-refsenv."_js2n__-:definitions/OS!predicate",
                                        server_install_timeout =
                                          _js2n__-prdslib.isType '"Number",
                                        server_launch_timeout =
                                          _js2n__-prdslib.isType '"Number",
                                        swipe =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    distance =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              100,
                                                            _js2n__-prdslib.numbers.minimum
                                                              1
                                                          ],
                                                    max_swipe_until_found =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              100,
                                                            _js2n__-prdslib.numbers.minimum
                                                              1
                                                          ],
                                                    speed =
                                                      _js2n__-refsenv."_js2n__-:definitions/Speed!predicate",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        system_port =
                                          _js2n__-prdslib.isType '"Number",
                                        type =
                                          _js2n__-refsenv."_js2n__-:definitions/DeviceType!predicate",
                                        typing_speed =
                                          _js2n__-prdslib.isType '"Number",
                                        unique_id =
                                          _js2n__-prdslib.isType '"String",
                                        version =
                                          _js2n__-prdslib.isType '"String",
                                        video =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    android =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                bit_rate =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"Number",
                                                                        _js2n__-prdslib.numbers.maximum
                                                                          25,
                                                                        _js2n__-prdslib.numbers.minimum
                                                                          1
                                                                      ],
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    enabled =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    ios =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                codec =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                fps =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"Number",
                                                                        _js2n__-prdslib.numbers.maximum
                                                                          60,
                                                                        _js2n__-prdslib.numbers.minimum
                                                                          1
                                                                      ],
                                                                quality =
                                                                  _js2n__-refsenv."_js2n__-:definitions/VideoQuality!predicate",
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    path =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    prefix =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    size =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    time_limit =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              1800,
                                                            _js2n__-prdslib.numbers.minimum
                                                              10
                                                          ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        virtual_device =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    connect_keyboard =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    headless =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    launch_timeout =
                                                      _js2n__-prdslib.isType
                                                          '"Number",
                                                    name =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    ready_timeout =
                                                      _js2n__-prdslib.isType
                                                          '"Number",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        wda =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    connection_timeout =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              900,
                                                            _js2n__-prdslib.numbers.minimum
                                                              1
                                                          ],
                                                    launch_timeout =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              900,
                                                            _js2n__-prdslib.numbers.minimum
                                                              1
                                                          ],
                                                    local_port =
                                                      _js2n__-prdslib.isType
                                                          '"Number",
                                                    signing_id =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    startup_retries =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              10,
                                                            _js2n__-prdslib.numbers.minimum
                                                              1
                                                          ],
                                                    startup_retry_interval =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              300,
                                                            _js2n__-prdslib.numbers.minimum
                                                              1
                                                          ],
                                                    team_id =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    update_bundle_id =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    use_new =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    use_prebuilt =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                      } {} true _js2n__-prdslib.always
                                  ],
                            server =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        allow_cors =
                                          _js2n__-prdslib.isType '"Bool",
                                        allow_insecure =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        appium_path =
                                          _js2n__-prdslib.isType '"String",
                                        base_path =
                                          _js2n__-prdslib.isType '"String",
                                        callback_address =
                                          _js2n__-prdslib.isType '"String",
                                        callback_port =
                                          _js2n__-prdslib.isType '"Number",
                                        config_path =
                                          _js2n__-prdslib.isType '"String",
                                        deny_insecure =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        driver =
                                          _js2n__-refsenv."_js2n__-:definitions/AutomationType!predicate",
                                        external =
                                          _js2n__-prdslib.isType '"Bool",
                                        external_config =
                                          _js2n__-prdslib.isType '"Bool",
                                        host = _js2n__-prdslib.isType '"String",
                                        keep_alive_timeout =
                                          _js2n__-prdslib.isType '"Number",
                                        logging =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    debug_spacing =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    level =
                                                      _js2n__-refsenv."_js2n__-:definitions/LogLevel!predicate",
                                                    local_timezone =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    timestamp =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        node_path =
                                          _js2n__-prdslib.isType '"String",
                                        other_args =
                                          _js2n__-refsenv."_js2n__-:definitions/args!predicate",
                                        password =
                                          _js2n__-prdslib.isType '"String",
                                        plugins =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        port = _js2n__-prdslib.isType '"Number",
                                        protocol =
                                          _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate",
                                        relaxed_security =
                                          _js2n__-prdslib.isType '"Bool",
                                        session_override =
                                          _js2n__-prdslib.isType '"Bool",
                                        strict_capabilities =
                                          _js2n__-prdslib.isType '"Bool",
                                        target =
                                          _js2n__-refsenv."_js2n__-:definitions/TargetProviders!predicate",
                                        timeout =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"Number",
                                                _js2n__-prdslib.numbers.maximum
                                                  900,
                                                _js2n__-prdslib.numbers.minimum
                                                  1
                                              ],
                                        user_name =
                                          _js2n__-prdslib.isType '"String",
                                        webhook =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ],
                          } {} true _js2n__-prdslib.always
                      ])
                ])
            | doc "Mobile related settings"
            | optional,
          screenshot
            | {
              enabled
                | Bool
                | doc "Set to true to enable screenshots"
                | optional,
              extension | String | doc "Screenshot file extension" | optional,
              path
                | String
                | doc "Path where the screenshots will be saved"
                | optional,
              prefix
                | String
                | doc "Prefix of the screenshot file name"
                | optional,
              ..
            }
            | doc "UI screenshot related settings"
            | optional,
          timeout
            | {
              explicit_wait
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.maximum 900
                    ])
                | doc "Explicit wait for the element to wait for a particular condition to succeed (in seconds)"
                | optional,
              highlight_delay
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.maximum 90000
                    ])
                | doc "Delay while Highlighting the element (in ms)"
                | optional,
              implicit_wait
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.maximum 300
                    ])
                | doc "Implicit wait for Appium to find the element (in seconds)"
                | optional,
              page_load_timeout
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.maximum 300
                    ])
                | doc "Page load timeout (in seconds)"
                | optional,
              script_timeout
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.maximum 300
                    ])
                | doc "Script load timeout (in seconds)"
                | optional,
              ..
            }
            | doc "UI timeout related settings"
            | optional,
          web
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            base_url = _js2n__-prdslib.isType '"String",
                            browser =
                              _js2n__-refsenv."_js2n__-:definitions/Browser!predicate",
                            browser_options =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                            capabilities =
                              _js2n__-refsenv."_js2n__-:definitions/caps!predicate",
                            custom_size =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        height =
                                          _js2n__-prdslib.isType '"Number",
                                        width =
                                          _js2n__-prdslib.isType '"Number",
                                      } {} true _js2n__-prdslib.always
                                  ],
                            headless = _js2n__-prdslib.isType '"Bool",
                            highlight = _js2n__-prdslib.isType '"Bool",
                            host = _js2n__-prdslib.isType '"String",
                            page_load_strategy =
                              _js2n__-refsenv."_js2n__-:definitions/PageLoadStrategy!predicate",
                            password = _js2n__-prdslib.isType '"String",
                            platform = _js2n__-prdslib.isType '"String",
                            port = _js2n__-prdslib.isType '"Number",
                            protocol =
                              _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate",
                            resize =
                              _js2n__-refsenv."_js2n__-:definitions/WindowResizeType!predicate",
                            target =
                              _js2n__-refsenv."_js2n__-:definitions/TargetProviders!predicate",
                            user_name = _js2n__-prdslib.isType '"String",
                            version = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ])
                ])
            | doc "Web related settings"
            | optional,
          ..
        }
        | doc "UI Configurations for Web and Mobile"
        | optional,
      ..
    }