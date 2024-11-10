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
      "_js2n__-:definitions/agents!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/agentsObject!predicate",
              _js2n__-refsenv."_js2n__-:definitions/agentsList!predicate"
            ],
      "_js2n__-:definitions/agentsList!predicate"
        | doc "Query rules to target specific agents in k=v format"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/agentsObject!predicate"
        | doc "Query rules to target specific agents"
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/allowDependencyFailure!predicate"
        | doc "Whether to proceed with this step and further steps if a step named in the depends_on attribute fails"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/automaticRetry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exit_status =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "*" ]
                            ],
                          _js2n__-prdslib.isType '"Number"
                        ],
                  limit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 10,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  signal = _js2n__-prdslib.isType '"String",
                  signal_reason =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "*",
                              "none",
                              "agent_refused",
                              "agent_stop",
                              "cancel",
                              "process_run_error",
                              "signature_rejected"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/blockStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_dependency_failure =
                    _js2n__-refsenv."_js2n__-:definitions/allowDependencyFailure!predicate",
                  block = _js2n__-prdslib.isType '"String",
                  blocked_state =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "passed", "failed", "running" ]
                        ],
                  branches =
                    _js2n__-refsenv."_js2n__-:definitions/branches!predicate",
                  depends_on =
                    _js2n__-refsenv."_js2n__-:definitions/dependsOn!predicate",
                  fields =
                    _js2n__-refsenv."_js2n__-:definitions/fields!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  identifier =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  "if" = _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                  key = _js2n__-refsenv."_js2n__-:definitions/key!predicate",
                  label =
                    _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                  name = _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                  prompt =
                    _js2n__-refsenv."_js2n__-:definitions/prompt!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "block" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/branches!predicate"
        | doc "Which branches will include this step in their builds"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/buildNotify!predicate"
        | doc "Array of notification options for this step"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [ "github_check", "github_commit_status" ]
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            email = _js2n__-prdslib.isType '"String",
                            "if" =
                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            basecamp_campfire =
                              _js2n__-prdslib.isType '"String",
                            "if" =
                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            "if" =
                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                            slack =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            channels =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.isType
                                                        '"String")
                                                  ],
                                            message =
                                              _js2n__-prdslib.isType '"String",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ],
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            "if" =
                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                            webhook = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            "if" =
                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                            pagerduty_change_event =
                              _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            github_commit_status =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        context =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ],
                            "if" =
                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            github_check =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        context =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ],
                            "if" =
                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                          } {} false _js2n__-prdslib.never
                      ]
                  ])
            ],
      "_js2n__-:definitions/cache!predicate"
        | doc "The paths for the caches to be used in the step"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "paths" ],
                  _js2n__-prdslib.records.record
                    {
                      name = _js2n__-prdslib.isType '"String",
                      paths =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ]
                            ],
                      size =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern "^\\d+g$"
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/cancelOnBuildFailing!predicate"
        | doc "Whether to cancel the job as soon as the build is marked as failing"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/commandStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  agents =
                    _js2n__-refsenv."_js2n__-:definitions/agents!predicate",
                  allow_dependency_failure =
                    _js2n__-refsenv."_js2n__-:definitions/allowDependencyFailure!predicate",
                  artifact_paths =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  branches =
                    _js2n__-refsenv."_js2n__-:definitions/branches!predicate",
                  cache =
                    _js2n__-refsenv."_js2n__-:definitions/cache!predicate",
                  cancel_on_build_failing =
                    _js2n__-refsenv."_js2n__-:definitions/cancelOnBuildFailing!predicate",
                  command =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  commands =
                    _js2n__-refsenv."_js2n__-:definitions/commandStep/properties/command!predicate",
                  concurrency = _js2n__-prdslib.isType 'Integer,
                  concurrency_group = _js2n__-prdslib.isType '"String",
                  concurrency_method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ordered", "eager" ]
                        ],
                  depends_on =
                    _js2n__-refsenv."_js2n__-:definitions/dependsOn!predicate",
                  env = _js2n__-refsenv."_js2n__-:definitions/env!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  identifier =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  "if" = _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                  key = _js2n__-refsenv."_js2n__-:definitions/key!predicate",
                  label =
                    _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                  matrix =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/matrixElement!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "setup" ],
                              _js2n__-prdslib.records.record
                                {
                                  adjustments =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "with" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    skip =
                                                      _js2n__-refsenv."_js2n__-:definitions/skip!predicate",
                                                    soft_fail =
                                                      _js2n__-refsenv."_js2n__-:definitions/softFail!predicate",
                                                    with =
                                                      _js2n__-prdslib.oneOf
                                                          [
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"Array",
                                                                _js2n__-prdslib.arrays.arrayOf
                                                                  _js2n__-refsenv."_js2n__-:definitions/matrixElement!predicate"
                                                              ],
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.propertyNames
                                                                  (_js2n__-prdslib.isType
                                                                    '"String"),
                                                                _js2n__-prdslib.records.record
                                                                  {} {} true
                                                                  (_js2n__-prdslib.isType
                                                                    '"String")
                                                              ]
                                                          ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ])
                                        ],
                                  setup =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                _js2n__-refsenv."_js2n__-:definitions/matrixElement!predicate"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.propertyNames
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.pattern
                                                      "^[a-zA-Z0-9_]+$"
                                                  ]),
                                              _js2n__-prdslib.records.record {}
                                                {} true
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      _js2n__-refsenv."_js2n__-:definitions/matrixElement!predicate"
                                                  ])
                                            ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  name = _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                  notify =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "github_check", "github_commit_status" ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        basecamp_campfire =
                                          _js2n__-prdslib.isType '"String",
                                        "if" =
                                          _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                                      } {} false _js2n__-prdslib.never
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        "if" =
                                          _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                                        slack =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        channels =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"Array",
                                                                _js2n__-prdslib.arrays.arrayOf
                                                                  (_js2n__-prdslib.isType
                                                                    '"String")
                                                              ],
                                                        message =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        github_commit_status =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    context =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        "if" =
                                          _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                                      } {} false _js2n__-prdslib.never
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        github_check =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    context =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        "if" =
                                          _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ])
                        ],
                  parallelism = _js2n__-prdslib.isType 'Integer,
                  plugins =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.maxProperties 1,
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ]
                                  ])
                            ],
                          _js2n__-prdslib.isType 'Record
                        ],
                  "priority" = _js2n__-prdslib.isType 'Integer,
                  retry =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              automatic =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType '"Bool",
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.strings.pattern
                                            "^(true|false)$"
                                        ],
                                      _js2n__-refsenv."_js2n__-:definitions/automaticRetry!predicate",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-refsenv."_js2n__-:definitions/automaticRetry!predicate"
                                        ]
                                    ],
                              manual =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType '"Bool",
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.strings.pattern
                                            "^(true|false)$"
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              allowed =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Bool",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.strings.pattern
                                                        "^(true|false)$"
                                                    ],
                                              permit_on_passed =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Bool",
                                                          _js2n__-prdslib.isType
                                                            '"String"
                                                        ],
                                                      _js2n__-prdslib.strings.pattern
                                                        "^(true|false)$"
                                                    ],
                                              reason =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  signature =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              algorithm = _js2n__-prdslib.isType '"String",
                              signed_fields =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              value = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  skip = _js2n__-refsenv."_js2n__-:definitions/skip!predicate",
                  soft_fail =
                    _js2n__-refsenv."_js2n__-:definitions/softFail!predicate",
                  timeout_in_minutes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "script", "command", "commands" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/commandStep/properties/command!predicate"
        | doc "The commands to run on the agent"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/dependsOn!predicate"
        | doc "The step keys for a step to depend on"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType 'Null,
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                allow_failure = _js2n__-prdslib.isType '"Bool",
                                step = _js2n__-prdslib.isType '"String",
                              } {} false _js2n__-prdslib.never
                          ]
                      ])
                ]
            ],
      "_js2n__-:definitions/env!predicate"
        | doc "Environment variables for this step"
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/fields!predicate"
        | doc "A list of input fields required to be filled out before unblocking the step"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "key" ],
                        _js2n__-prdslib.records.record
                          {
                            "default" = _js2n__-prdslib.isType '"String",
                            format = _js2n__-prdslib.isType '"String",
                            hint = _js2n__-prdslib.isType '"String",
                            key =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^[a-zA-Z0-9-_]+$"
                                  ],
                            required = _js2n__-prdslib.isType '"Bool",
                            text = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "key", "options" ],
                        _js2n__-prdslib.records.record
                          {
                            "default" =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ]
                                  ],
                            hint = _js2n__-prdslib.isType '"String",
                            key =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^[a-zA-Z0-9-_]+$"
                                  ],
                            multiple = _js2n__-prdslib.isType '"Bool",
                            options =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "label", "value" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              hint =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              label =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              required =
                                                _js2n__-prdslib.isType '"Bool",
                                              value =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            required = _js2n__-prdslib.isType '"Bool",
                            select = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ]
                  ])
            ],
      "_js2n__-:definitions/groupStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_dependency_failure =
                    _js2n__-refsenv."_js2n__-:definitions/allowDependencyFailure!predicate",
                  depends_on =
                    _js2n__-refsenv."_js2n__-:definitions/dependsOn!predicate",
                  group =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  identifier =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  "if" = _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                  key = _js2n__-refsenv."_js2n__-:definitions/key!predicate",
                  label =
                    _js2n__-refsenv."_js2n__-:definitions/groupStep/properties/group!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/groupStep/properties/label!predicate",
                  notify =
                    _js2n__-refsenv."_js2n__-:definitions/buildNotify!predicate",
                  skip = _js2n__-refsenv."_js2n__-:definitions/skip!predicate",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/stringBlockStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/blockStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/commandStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/nestedCommandStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/triggerStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/nestedTriggerStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/stringInputStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/inputStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/nestedInputStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/stringWaitStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/waitStep!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/nestedWaitStep!predicate"
                              ])
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [ _js2n__-prdslib.isType '"String" ],
                          _js2n__-prdslib.enum [ "group" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/groupStep/properties/group!predicate"
        | doc "The name to give to this group of steps"
        = _js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ],
      "_js2n__-:definitions/groupStep/properties/label!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/groupStep/properties/group!predicate",
      "_js2n__-:definitions/identifier!predicate"
        | doc "A string identifier"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/if!predicate"
        | doc "A boolean expression that omits the step when false"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/inputStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_dependency_failure =
                    _js2n__-refsenv."_js2n__-:definitions/allowDependencyFailure!predicate",
                  branches =
                    _js2n__-refsenv."_js2n__-:definitions/branches!predicate",
                  depends_on =
                    _js2n__-refsenv."_js2n__-:definitions/dependsOn!predicate",
                  fields =
                    _js2n__-refsenv."_js2n__-:definitions/fields!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  identifier =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  "if" = _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                  input = _js2n__-prdslib.isType '"String",
                  key = _js2n__-refsenv."_js2n__-:definitions/key!predicate",
                  label =
                    _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                  name = _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                  prompt =
                    _js2n__-refsenv."_js2n__-:definitions/prompt!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "input" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/key!predicate"
        | doc "A unique identifier for a step, must not resemble a UUID"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/label!predicate"
        | doc "The label that will be displayed in the pipeline visualisation in Buildkite. Supports emoji."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/matrixElement!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.isType '"Bool"
            ],
      "_js2n__-:definitions/nestedBlockStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  block =
                    _js2n__-refsenv."_js2n__-:definitions/blockStep!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/nestedCommandStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  command =
                    _js2n__-refsenv."_js2n__-:definitions/commandStep!predicate",
                  commands =
                    _js2n__-refsenv."_js2n__-:definitions/commandStep!predicate",
                  script =
                    _js2n__-refsenv."_js2n__-:definitions/commandStep!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/nestedInputStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  input =
                    _js2n__-refsenv."_js2n__-:definitions/inputStep!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/nestedTriggerStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  trigger =
                    _js2n__-refsenv."_js2n__-:definitions/triggerStep!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/nestedWaitStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  wait =
                    _js2n__-refsenv."_js2n__-:definitions/waitStep!predicate",
                  waiter =
                    _js2n__-refsenv."_js2n__-:definitions/waitStep!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/prompt!predicate"
        | doc "The instructional message displayed in the dialog box when the unblock step is activated"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/skip!predicate"
        | doc "Whether this step should be skipped. You can specify a reason for using a string."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/softFail!predicate"
        | doc "The conditions for marking the step as a soft-fail."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            exit_status =
                              _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum [ "*" ]
                                      ],
                                    _js2n__-prdslib.isType '"Number"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ])
                ]
            ],
      "_js2n__-:definitions/stringBlockStep!predicate"
        | doc "Pauses the execution of a build and waits on a user to unblock it"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "block" ]
            ],
      "_js2n__-:definitions/stringInputStep!predicate"
        | doc "Pauses the execution of a build and waits on a user to unblock it"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "input" ]
            ],
      "_js2n__-:definitions/stringWaitStep!predicate"
        | doc "Waits for previous steps to pass before continuing"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "wait", "waiter" ]
            ],
      "_js2n__-:definitions/triggerStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_dependency_failure =
                    _js2n__-refsenv."_js2n__-:definitions/allowDependencyFailure!predicate",
                  async = _js2n__-prdslib.isType '"Bool",
                  branches =
                    _js2n__-refsenv."_js2n__-:definitions/branches!predicate",
                  build =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              branch = _js2n__-prdslib.isType '"String",
                              commit = _js2n__-prdslib.isType '"String",
                              env =
                                _js2n__-refsenv."_js2n__-:definitions/env!predicate",
                              label =
                                _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                              message = _js2n__-prdslib.isType '"String",
                              meta_data = _js2n__-prdslib.isType 'Record,
                              name =
                                _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                              trigger = _js2n__-prdslib.isType '"String",
                              type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "trigger" ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  depends_on =
                    _js2n__-refsenv."_js2n__-:definitions/dependsOn!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  identifier =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  "if" = _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                  key = _js2n__-refsenv."_js2n__-:definitions/key!predicate",
                  label =
                    _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                  name = _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                  skip = _js2n__-refsenv."_js2n__-:definitions/skip!predicate",
                  soft_fail =
                    _js2n__-refsenv."_js2n__-:definitions/softFail!predicate",
                  trigger = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "trigger" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/waitStep!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_dependency_failure =
                    _js2n__-refsenv."_js2n__-:definitions/allowDependencyFailure!predicate",
                  continue_on_failure = _js2n__-prdslib.isType '"Bool",
                  depends_on =
                    _js2n__-refsenv."_js2n__-:definitions/dependsOn!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  identifier =
                    _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                  "if" = _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                  key = _js2n__-refsenv."_js2n__-:definitions/key!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "wait", "waiter" ]
                        ],
                  wait =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "" ]
                            ]
                        ],
                  waiter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "" ]
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.required [ "steps" ],
          _js2n__-prdslib.records.record
            {
              agents = _js2n__-refsenv."_js2n__-:definitions/agents!predicate",
              env = _js2n__-refsenv."_js2n__-:definitions/env!predicate",
              notify =
                _js2n__-refsenv."_js2n__-:definitions/buildNotify!predicate",
              steps =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-refsenv."_js2n__-:definitions/blockStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/nestedBlockStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/stringBlockStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/inputStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/nestedInputStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/stringInputStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/commandStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/nestedCommandStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/stringWaitStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/waitStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/nestedWaitStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/triggerStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/nestedTriggerStep!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/groupStep!predicate"
                          ])
                    ],
            } {} true _js2n__-prdslib.always
        ])