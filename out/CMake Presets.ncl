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
      "_js2n__-:definitions/$schema!predicate"
        | doc "The schema against which to verify this document."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/buildPresetsItemsV2!predicate"
        | doc "An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 2 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        cleanFirst = _js2n__-prdslib.isType '"Bool",
                        configuration = _js2n__-prdslib.isType '"String",
                        configurePreset =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        description = _js2n__-prdslib.isType '"String",
                        displayName = _js2n__-prdslib.isType '"String",
                        environment =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.propertyNames
                                  (_js2n__-prdslib.strings.pattern "^.+$"),
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Null,
                                      _js2n__-prdslib.isType '"String"
                                    ])
                              ],
                        hidden = _js2n__-prdslib.isType '"Bool",
                        inheritConfigureEnvironment =
                          _js2n__-prdslib.isType '"Bool",
                        inherits =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.minLength 1
                                        ])
                                  ]
                              ],
                        jobs = _js2n__-prdslib.isType 'Integer,
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        nativeToolOptions =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        targets =
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
                        vendor = _js2n__-prdslib.isType 'Record,
                        verbose = _js2n__-prdslib.isType '"Bool",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/buildPresetsItemsV3!predicate"
        | doc "An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 3 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        condition =
                          _js2n__-refsenv."_js2n__-:definitions/topCondition!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/buildPresetsItemsV4!predicate"
        | doc "An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 4 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        resolvePackageReferences =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "on", "off", "only" ]
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/buildPresetsV2!predicate"
        | doc "An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 2 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-refsenv."_js2n__-:definitions/buildPresetsItemsV2!predicate",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        cleanFirst = _js2n__-prdslib.always,
                        configuration = _js2n__-prdslib.always,
                        configurePreset = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inheritConfigureEnvironment = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        jobs = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        nativeToolOptions = _js2n__-prdslib.always,
                        targets = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                        verbose = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/buildPresetsV3!predicate"
        | doc "An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 3 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/buildPresetsItemsV3!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/buildPresetsItemsV2!predicate"
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        cleanFirst = _js2n__-prdslib.always,
                        condition = _js2n__-prdslib.always,
                        configuration = _js2n__-prdslib.always,
                        configurePreset = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inheritConfigureEnvironment = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        jobs = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        nativeToolOptions = _js2n__-prdslib.always,
                        targets = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                        verbose = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/buildPresetsV4!predicate"
        | doc "An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 4 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/buildPresetsItemsV4!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/buildPresetsItemsV3!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/buildPresetsItemsV2!predicate"
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        cleanFirst = _js2n__-prdslib.always,
                        condition = _js2n__-prdslib.always,
                        configuration = _js2n__-prdslib.always,
                        configurePreset = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inheritConfigureEnvironment = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        jobs = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        nativeToolOptions = _js2n__-prdslib.always,
                        resolvePackageReferences = _js2n__-prdslib.always,
                        targets = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                        verbose = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/cmakeMinimumRequired!predicate"
        | doc "An optional object representing the minimum version of CMake needed to build this project."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  major = _js2n__-prdslib.isType 'Integer,
                  minor = _js2n__-prdslib.isType 'Integer,
                  patch = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/condition!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type", "value" ],
                  _js2n__-prdslib.records.record
                    {
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "const"
                            ],
                      value = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "lhs", "rhs", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      lhs = _js2n__-prdslib.isType '"String",
                      rhs = _js2n__-prdslib.isType '"String",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "equals"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "lhs", "rhs", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      lhs = _js2n__-prdslib.isType '"String",
                      rhs = _js2n__-prdslib.isType '"String",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "notEquals"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "list", "string", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      list =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      string = _js2n__-prdslib.isType '"String",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "inList"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "list", "string", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      list =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      string = _js2n__-prdslib.isType '"String",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "notInList"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "regex", "string", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      regex = _js2n__-prdslib.isType '"String",
                      string = _js2n__-prdslib.isType '"String",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "matches"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "regex", "string", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      regex = _js2n__-prdslib.isType '"String",
                      string = _js2n__-prdslib.isType '"String",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "notMatches"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "conditions", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      conditions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/condition!predicate"
                            ],
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "anyOf"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "conditions", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      conditions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/condition!predicate"
                            ],
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "allOf"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "condition", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/condition!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "not"
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/configurePresetsItemsV1!predicate"
        | doc "An optional array of configure preset objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        architecture =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        strategy =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "set", "external" ]
                                              ],
                                        value =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        binaryDir = _js2n__-prdslib.isType '"String",
                        cacheVariables =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.propertyNames
                                  (_js2n__-prdslib.strings.pattern "^.+$"),
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Null,
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "value" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              type =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              value =
                                                _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Bool",
                                                      _js2n__-prdslib.isType
                                                        '"String"
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ])
                              ],
                        cmakeExecutable = _js2n__-prdslib.isType '"String",
                        debug =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    find = _js2n__-prdslib.isType '"Bool",
                                    output = _js2n__-prdslib.isType '"Bool",
                                    tryCompile = _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ],
                        description = _js2n__-prdslib.isType '"String",
                        displayName = _js2n__-prdslib.isType '"String",
                        environment =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.propertyNames
                                  (_js2n__-prdslib.strings.pattern "^.+$"),
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Null,
                                      _js2n__-prdslib.isType '"String"
                                    ])
                              ],
                        errors =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    deprecated = _js2n__-prdslib.isType '"Bool",
                                    dev = _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ],
                        generator = _js2n__-prdslib.isType '"String",
                        hidden = _js2n__-prdslib.isType '"Bool",
                        inherits =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.minLength 1
                                        ])
                                  ]
                              ],
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        toolset =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        strategy =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "set", "external" ]
                                              ],
                                        value =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        vendor = _js2n__-prdslib.isType 'Record,
                        warnings =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    deprecated = _js2n__-prdslib.isType '"Bool",
                                    dev = _js2n__-prdslib.isType '"Bool",
                                    systemVars = _js2n__-prdslib.isType '"Bool",
                                    uninitialized =
                                      _js2n__-prdslib.isType '"Bool",
                                    unusedCli = _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/configurePresetsItemsV3!predicate"
        | doc "A configure preset object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        binaryDir = _js2n__-prdslib.isType '"String",
                        condition =
                          _js2n__-refsenv."_js2n__-:definitions/topCondition!predicate",
                        generator = _js2n__-prdslib.isType '"String",
                        installDir = _js2n__-prdslib.isType '"String",
                        toolchainFile = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/configurePresetsItemsV7!predicate"
        | doc "A configure preset object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        trace =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    format =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "human", "json-v1" ]
                                          ],
                                    mode =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "on", "off", "expand" ]
                                          ],
                                    redirect = _js2n__-prdslib.isType '"String",
                                    source =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.strings.minLength
                                                  1
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.strings.minLength
                                                        1
                                                    ])
                                              ]
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/configurePresetsV1!predicate"
        | doc "An optional array of configure preset objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-refsenv."_js2n__-:definitions/configurePresetsItemsV1!predicate",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        architecture = _js2n__-prdslib.always,
                        binaryDir = _js2n__-prdslib.always,
                        cacheVariables = _js2n__-prdslib.always,
                        cmakeExecutable = _js2n__-prdslib.always,
                        debug = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        errors = _js2n__-prdslib.always,
                        generator = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        toolset = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                        warnings = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/configurePresetsV3!predicate"
        | doc "An optional array of configure preset objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/configurePresetsItemsV1!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/configurePresetsItemsV3!predicate"
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        architecture = _js2n__-prdslib.always,
                        binaryDir = _js2n__-prdslib.always,
                        cacheVariables = _js2n__-prdslib.always,
                        cmakeExecutable = _js2n__-prdslib.always,
                        condition = _js2n__-prdslib.always,
                        debug = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        errors = _js2n__-prdslib.always,
                        generator = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        installDir = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        toolchainFile = _js2n__-prdslib.always,
                        toolset = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                        warnings = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/configurePresetsV7!predicate"
        | doc "An optional array of configure preset objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/configurePresetsItemsV1!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/configurePresetsItemsV3!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/configurePresetsItemsV7!predicate"
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        architecture = _js2n__-prdslib.always,
                        binaryDir = _js2n__-prdslib.always,
                        cacheVariables = _js2n__-prdslib.always,
                        cmakeExecutable = _js2n__-prdslib.always,
                        condition = _js2n__-prdslib.always,
                        debug = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        errors = _js2n__-prdslib.always,
                        generator = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        installDir = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        toolchainFile = _js2n__-prdslib.always,
                        toolset = _js2n__-prdslib.always,
                        trace = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                        warnings = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/include!predicate"
        | doc "An optional array of strings representing files to include. If the filenames are not absolute, they are considered relative to the current file."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/packagePresetsItemsV6!predicate"
        | doc "An optional array of package preset objects. Used to specify arguments to cpack. Available in version 6 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        condition =
                          _js2n__-refsenv."_js2n__-:definitions/topCondition!predicate",
                        configFile = _js2n__-prdslib.isType '"String",
                        configurations =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        configurePreset =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        description = _js2n__-prdslib.isType '"String",
                        displayName = _js2n__-prdslib.isType '"String",
                        environment =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.propertyNames
                                  (_js2n__-prdslib.strings.pattern "^.+$"),
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Null,
                                      _js2n__-prdslib.isType '"String"
                                    ])
                              ],
                        generators =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        hidden = _js2n__-prdslib.isType '"Bool",
                        inheritConfigureEnvironment =
                          _js2n__-prdslib.isType '"Bool",
                        inherits =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.minLength 1
                                        ])
                                  ]
                              ],
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        output =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    debug = _js2n__-prdslib.isType '"Bool",
                                    verbose = _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ],
                        packageDirectory = _js2n__-prdslib.isType '"String",
                        packageName = _js2n__-prdslib.isType '"String",
                        packageVersion = _js2n__-prdslib.isType '"String",
                        variables =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        vendor = _js2n__-prdslib.isType 'Record,
                        vendorName = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/packagePresetsV6!predicate"
        | doc "An optional array of package preset objects. Used to specify arguments to cpack. Available in version 6 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-refsenv."_js2n__-:definitions/packagePresetsItemsV6!predicate",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        condition = _js2n__-prdslib.always,
                        configFile = _js2n__-prdslib.always,
                        configurations = _js2n__-prdslib.always,
                        configurePreset = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        generators = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inheritConfigureEnvironment = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        output = _js2n__-prdslib.always,
                        packageDirectory = _js2n__-prdslib.always,
                        packageName = _js2n__-prdslib.always,
                        packageVersion = _js2n__-prdslib.always,
                        variables = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                        vendorName = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/testPresetsItemsV2!predicate"
        | doc "An optional array of test preset objects. Used to specify arguments to ctest. Available in version 2 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        configuration = _js2n__-prdslib.isType '"String",
                        configurePreset =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        description = _js2n__-prdslib.isType '"String",
                        displayName = _js2n__-prdslib.isType '"String",
                        environment =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.propertyNames
                                  (_js2n__-prdslib.strings.pattern "^.+$"),
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Null,
                                      _js2n__-prdslib.isType '"String"
                                    ])
                              ],
                        execution =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    enableFailover =
                                      _js2n__-prdslib.isType '"Bool",
                                    interactiveDebugging =
                                      _js2n__-prdslib.isType '"Bool",
                                    jobs = _js2n__-prdslib.isType 'Integer,
                                    noTestsAction =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "default", "error", "ignore" ]
                                          ],
                                    repeat =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "count", "mode" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                count =
                                                  _js2n__-prdslib.isType
                                                      'Integer,
                                                mode =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "until-fail",
                                                            "until-pass",
                                                            "after-timeout"
                                                          ]
                                                      ],
                                              } {} false _js2n__-prdslib.never
                                          ],
                                    resourceSpecFile =
                                      _js2n__-prdslib.isType '"String",
                                    scheduleRandom =
                                      _js2n__-prdslib.isType '"Bool",
                                    showOnly =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "human", "json-v1" ]
                                          ],
                                    stopOnFailure =
                                      _js2n__-prdslib.isType '"Bool",
                                    testLoad = _js2n__-prdslib.isType 'Integer,
                                    timeout = _js2n__-prdslib.isType 'Integer,
                                  } {} false _js2n__-prdslib.never
                              ],
                        filter =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    exclude =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                fixtures =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            any =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            cleanup =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            setup =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ],
                                                label =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    include =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                index =
                                                  _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                end =
                                                                  _js2n__-prdslib.isType
                                                                      'Integer,
                                                                specificTests =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"Array",
                                                                        _js2n__-prdslib.arrays.arrayOf
                                                                          (_js2n__-prdslib.isType
                                                                            'Integer)
                                                                      ],
                                                                start =
                                                                  _js2n__-prdslib.isType
                                                                      'Integer,
                                                                stride =
                                                                  _js2n__-prdslib.isType
                                                                      'Integer,
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ],
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ],
                                                label =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                useUnion =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                              } {} false _js2n__-prdslib.never
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        hidden = _js2n__-prdslib.isType '"Bool",
                        inheritConfigureEnvironment =
                          _js2n__-prdslib.isType '"Bool",
                        inherits =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.minLength 1
                                        ])
                                  ]
                              ],
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        output =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    debug = _js2n__-prdslib.isType '"Bool",
                                    labelSummary =
                                      _js2n__-prdslib.isType '"Bool",
                                    maxFailedTestOutputSize =
                                      _js2n__-prdslib.isType 'Integer,
                                    maxPassedTestOutputSize =
                                      _js2n__-prdslib.isType 'Integer,
                                    maxTestNameWidth =
                                      _js2n__-prdslib.isType 'Integer,
                                    outputLogFile =
                                      _js2n__-prdslib.isType '"String",
                                    outputOnFailure =
                                      _js2n__-prdslib.isType '"Bool",
                                    quiet = _js2n__-prdslib.isType '"Bool",
                                    shortProgress =
                                      _js2n__-prdslib.isType '"Bool",
                                    subprojectSummary =
                                      _js2n__-prdslib.isType '"Bool",
                                    verbosity =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "default", "verbose", "extra" ]
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ],
                        overwriteConfigurationFile =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        vendor = _js2n__-prdslib.isType 'Record,
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/testPresetsItemsV3!predicate"
        | doc "An optional array of test preset objects. Used to specify arguments to ctest. Available in version 3 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        condition =
                          _js2n__-refsenv."_js2n__-:definitions/topCondition!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/testPresetsItemsV5!predicate"
        | doc "An optional array of test preset objects. Used to specify arguments to ctest. Available in version 5 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        output =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    testOutputTruncation =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "tail", "middle", "head" ]
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/testPresetsItemsV6!predicate"
        | doc "An optional array of test preset objects. Used to specify arguments to ctest. Available in version 6 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        output =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    outputJUnitFile =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/testPresetsV2!predicate"
        | doc "An optional array of test preset objects. Used to specify arguments to ctest. Available in version 2 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV2!predicate",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        configuration = _js2n__-prdslib.always,
                        configurePreset = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        execution = _js2n__-prdslib.always,
                        filter = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inheritConfigureEnvironment = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        output =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    debug = _js2n__-prdslib.always,
                                    labelSummary = _js2n__-prdslib.always,
                                    maxFailedTestOutputSize =
                                      _js2n__-prdslib.always,
                                    maxPassedTestOutputSize =
                                      _js2n__-prdslib.always,
                                    maxTestNameWidth = _js2n__-prdslib.always,
                                    outputLogFile = _js2n__-prdslib.always,
                                    outputOnFailure = _js2n__-prdslib.always,
                                    quiet = _js2n__-prdslib.always,
                                    shortProgress = _js2n__-prdslib.always,
                                    subprojectSummary = _js2n__-prdslib.always,
                                    verbosity = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never
                              ],
                        overwriteConfigurationFile = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/testPresetsV3!predicate"
        | doc "An optional array of test preset objects. Used to specify arguments to ctest. Available in version 3 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV2!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV3!predicate"
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        condition = _js2n__-prdslib.always,
                        configuration = _js2n__-prdslib.always,
                        configurePreset = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        execution = _js2n__-prdslib.always,
                        filter = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inheritConfigureEnvironment = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        output =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    debug = _js2n__-prdslib.always,
                                    labelSummary = _js2n__-prdslib.always,
                                    maxFailedTestOutputSize =
                                      _js2n__-prdslib.always,
                                    maxPassedTestOutputSize =
                                      _js2n__-prdslib.always,
                                    maxTestNameWidth = _js2n__-prdslib.always,
                                    outputLogFile = _js2n__-prdslib.always,
                                    outputOnFailure = _js2n__-prdslib.always,
                                    quiet = _js2n__-prdslib.always,
                                    shortProgress = _js2n__-prdslib.always,
                                    subprojectSummary = _js2n__-prdslib.always,
                                    verbosity = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never
                              ],
                        overwriteConfigurationFile = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/testPresetsV5!predicate"
        | doc "An optional array of test preset objects. Used to specify arguments to ctest. Available in version 5 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV2!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV3!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV5!predicate"
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        condition = _js2n__-prdslib.always,
                        configuration = _js2n__-prdslib.always,
                        configurePreset = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        execution = _js2n__-prdslib.always,
                        filter = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inheritConfigureEnvironment = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        output =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    debug = _js2n__-prdslib.always,
                                    labelSummary = _js2n__-prdslib.always,
                                    maxFailedTestOutputSize =
                                      _js2n__-prdslib.always,
                                    maxPassedTestOutputSize =
                                      _js2n__-prdslib.always,
                                    maxTestNameWidth = _js2n__-prdslib.always,
                                    outputLogFile = _js2n__-prdslib.always,
                                    outputOnFailure = _js2n__-prdslib.always,
                                    quiet = _js2n__-prdslib.always,
                                    shortProgress = _js2n__-prdslib.always,
                                    subprojectSummary = _js2n__-prdslib.always,
                                    testOutputTruncation =
                                      _js2n__-prdslib.always,
                                    verbosity = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never
                              ],
                        overwriteConfigurationFile = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/testPresetsV6!predicate"
        | doc "An optional array of test preset objects. Used to specify arguments to ctest. Available in version 6 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV2!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV3!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV5!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/testPresetsItemsV6!predicate"
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        condition = _js2n__-prdslib.always,
                        configuration = _js2n__-prdslib.always,
                        configurePreset = _js2n__-prdslib.always,
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        environment = _js2n__-prdslib.always,
                        execution = _js2n__-prdslib.always,
                        filter = _js2n__-prdslib.always,
                        hidden = _js2n__-prdslib.always,
                        inheritConfigureEnvironment = _js2n__-prdslib.always,
                        inherits = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        output =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    debug = _js2n__-prdslib.always,
                                    labelSummary = _js2n__-prdslib.always,
                                    maxFailedTestOutputSize =
                                      _js2n__-prdslib.always,
                                    maxPassedTestOutputSize =
                                      _js2n__-prdslib.always,
                                    maxTestNameWidth = _js2n__-prdslib.always,
                                    outputJUnitFile = _js2n__-prdslib.always,
                                    outputLogFile = _js2n__-prdslib.always,
                                    outputOnFailure = _js2n__-prdslib.always,
                                    quiet = _js2n__-prdslib.always,
                                    shortProgress = _js2n__-prdslib.always,
                                    subprojectSummary = _js2n__-prdslib.always,
                                    testOutputTruncation =
                                      _js2n__-prdslib.always,
                                    verbosity = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never
                              ],
                        overwriteConfigurationFile = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/topCondition!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/condition!predicate",
              _js2n__-prdslib.isType 'Null
            ],
      "_js2n__-:definitions/vendor!predicate"
        | doc "An optional map containing vendor-specific information. CMake does not interpret the contents of this field except to verify that it is a map if it does exist. However, the keys should be a vendor-specific domain name followed by a /-separated path. For example, the Example IDE 1.0 could use example.com/ExampleIDE/1.0. The value of each field can be anything desired by the vendor, though will typically be a map."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/workflowPresetsItemsV6!predicate"
        | doc "An optional array of workflow preset objects. Used to execute configure, build, test, and package presets in order. Available in version 6 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name", "steps" ],
                    _js2n__-prdslib.records.record
                      {
                        description = _js2n__-prdslib.isType '"String",
                        displayName = _js2n__-prdslib.isType '"String",
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        steps =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "name", "type" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          name =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ],
                                          type =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "configure",
                                                      "build",
                                                      "test",
                                                      "package"
                                                    ]
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ])
                              ],
                        vendor = _js2n__-prdslib.isType 'Record,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/workflowPresetsV6!predicate"
        | doc "An optional array of workflow preset objects. Used to execute configure, build, test, and package presets in order. Available in version 6 and higher."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-refsenv."_js2n__-:definitions/workflowPresetsItemsV6!predicate",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name", "steps" ],
                    _js2n__-prdslib.records.record
                      {
                        description = _js2n__-prdslib.always,
                        displayName = _js2n__-prdslib.always,
                        name = _js2n__-prdslib.always,
                        steps = _js2n__-prdslib.always,
                        vendor = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.records.record
                {
                  cmakeMinimumRequired =
                    _js2n__-refsenv."_js2n__-:definitions/cmakeMinimumRequired!predicate",
                  configurePresets =
                    _js2n__-refsenv."_js2n__-:definitions/configurePresetsV1!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/vendor!predicate",
                  version = _js2n__-prdslib.const 1,
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.record
                {
                  buildPresets =
                    _js2n__-refsenv."_js2n__-:definitions/buildPresetsV2!predicate",
                  cmakeMinimumRequired =
                    _js2n__-refsenv."_js2n__-:definitions/cmakeMinimumRequired!predicate",
                  configurePresets =
                    _js2n__-refsenv."_js2n__-:definitions/configurePresetsV1!predicate",
                  testPresets =
                    _js2n__-refsenv."_js2n__-:definitions/testPresetsV2!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/vendor!predicate",
                  version = _js2n__-prdslib.const 2,
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.record
                {
                  buildPresets =
                    _js2n__-refsenv."_js2n__-:definitions/buildPresetsV3!predicate",
                  cmakeMinimumRequired =
                    _js2n__-refsenv."_js2n__-:definitions/cmakeMinimumRequired!predicate",
                  configurePresets =
                    _js2n__-refsenv."_js2n__-:definitions/configurePresetsV3!predicate",
                  testPresets =
                    _js2n__-refsenv."_js2n__-:definitions/testPresetsV3!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/vendor!predicate",
                  version = _js2n__-prdslib.const 3,
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.record
                {
                  buildPresets =
                    _js2n__-refsenv."_js2n__-:definitions/buildPresetsV4!predicate",
                  cmakeMinimumRequired =
                    _js2n__-refsenv."_js2n__-:definitions/cmakeMinimumRequired!predicate",
                  configurePresets =
                    _js2n__-refsenv."_js2n__-:definitions/configurePresetsV3!predicate",
                  include =
                    _js2n__-refsenv."_js2n__-:definitions/include!predicate",
                  testPresets =
                    _js2n__-refsenv."_js2n__-:definitions/testPresetsV3!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/vendor!predicate",
                  version = _js2n__-prdslib.const 4,
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.record
                {
                  buildPresets =
                    _js2n__-refsenv."_js2n__-:definitions/buildPresetsV4!predicate",
                  cmakeMinimumRequired =
                    _js2n__-refsenv."_js2n__-:definitions/cmakeMinimumRequired!predicate",
                  configurePresets =
                    _js2n__-refsenv."_js2n__-:definitions/configurePresetsV3!predicate",
                  include =
                    _js2n__-refsenv."_js2n__-:definitions/include!predicate",
                  testPresets =
                    _js2n__-refsenv."_js2n__-:definitions/testPresetsV5!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/vendor!predicate",
                  version = _js2n__-prdslib.const 5,
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.record
                {
                  buildPresets =
                    _js2n__-refsenv."_js2n__-:definitions/buildPresetsV4!predicate",
                  cmakeMinimumRequired =
                    _js2n__-refsenv."_js2n__-:definitions/cmakeMinimumRequired!predicate",
                  configurePresets =
                    _js2n__-refsenv."_js2n__-:definitions/configurePresetsV3!predicate",
                  include =
                    _js2n__-refsenv."_js2n__-:definitions/include!predicate",
                  packagePresets =
                    _js2n__-refsenv."_js2n__-:definitions/packagePresetsV6!predicate",
                  testPresets =
                    _js2n__-refsenv."_js2n__-:definitions/testPresetsV6!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/vendor!predicate",
                  version = _js2n__-prdslib.const 6,
                  workflowPresets =
                    _js2n__-refsenv."_js2n__-:definitions/workflowPresetsV6!predicate",
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.record
                {
                  buildPresets =
                    _js2n__-refsenv."_js2n__-:definitions/buildPresetsV4!predicate",
                  cmakeMinimumRequired =
                    _js2n__-refsenv."_js2n__-:definitions/cmakeMinimumRequired!predicate",
                  configurePresets =
                    _js2n__-refsenv."_js2n__-:definitions/configurePresetsV7!predicate",
                  include =
                    _js2n__-refsenv."_js2n__-:definitions/include!predicate",
                  packagePresets =
                    _js2n__-refsenv."_js2n__-:definitions/packagePresetsV6!predicate",
                  testPresets =
                    _js2n__-refsenv."_js2n__-:definitions/testPresetsV6!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/vendor!predicate",
                  version = _js2n__-prdslib.const 7,
                  workflowPresets =
                    _js2n__-refsenv."_js2n__-:definitions/workflowPresetsV6!predicate",
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.record
                {
                  "$schema" =
                    _js2n__-refsenv."_js2n__-:definitions/$schema!predicate",
                  buildPresets =
                    _js2n__-refsenv."_js2n__-:definitions/buildPresetsV4!predicate",
                  cmakeMinimumRequired =
                    _js2n__-refsenv."_js2n__-:definitions/cmakeMinimumRequired!predicate",
                  configurePresets =
                    _js2n__-refsenv."_js2n__-:definitions/configurePresetsV7!predicate",
                  include =
                    _js2n__-refsenv."_js2n__-:definitions/include!predicate",
                  packagePresets =
                    _js2n__-refsenv."_js2n__-:definitions/packagePresetsV6!predicate",
                  testPresets =
                    _js2n__-refsenv."_js2n__-:definitions/testPresetsV6!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/vendor!predicate",
                  version = _js2n__-prdslib.const 8,
                  workflowPresets =
                    _js2n__-refsenv."_js2n__-:definitions/workflowPresetsV6!predicate",
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.record
                {
                  "$schema" =
                    _js2n__-refsenv."_js2n__-:definitions/$schema!predicate",
                  buildPresets =
                    _js2n__-refsenv."_js2n__-:definitions/buildPresetsV4!predicate",
                  cmakeMinimumRequired =
                    _js2n__-refsenv."_js2n__-:definitions/cmakeMinimumRequired!predicate",
                  configurePresets =
                    _js2n__-refsenv."_js2n__-:definitions/configurePresetsV7!predicate",
                  include =
                    _js2n__-refsenv."_js2n__-:definitions/include!predicate",
                  packagePresets =
                    _js2n__-refsenv."_js2n__-:definitions/packagePresetsV6!predicate",
                  testPresets =
                    _js2n__-refsenv."_js2n__-:definitions/testPresetsV6!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/vendor!predicate",
                  version = _js2n__-prdslib.const 9,
                  workflowPresets =
                    _js2n__-refsenv."_js2n__-:definitions/workflowPresetsV6!predicate",
                } {} false _js2n__-prdslib.never
            ],
          _js2n__-prdslib.records.required [ "version" ],
          _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
        ])