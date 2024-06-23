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
      "_js2n__-:definitions/CacheFormat!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "legacy", "universal" ]
            ],
      "_js2n__-:definitions/CacheSettings!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cacheFormat =
                    _js2n__-refsenv."_js2n__-:definitions/CacheFormat!predicate",
                  cacheLocation =
                    _js2n__-refsenv."_js2n__-:definitions/FSPathResolvable!predicate",
                  cacheStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/CacheStrategy!predicate",
                  useCache = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CacheStrategy!predicate"
        | doc m%"
          The Strategy to use to detect if a file has changed.
          - `metadata` - uses the file system timestamp and size to detect changes (fastest).
          - `content` - uses a hash of the file content to check file changes (slower - more accurate).
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "metadata", "content" ]
            ],
      "_js2n__-:definitions/CharacterSet!predicate"
        | doc m%"
          This is a set of characters that can include `-` or `|`
          - `-` - indicates a range of characters: `a-c` => `abc`
          - `|` - is a group separator, indicating that the characters on either side    are not related.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/CharacterSetCosts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "characters", "cost" ],
              _js2n__-prdslib.records.record
                {
                  characters =
                    _js2n__-refsenv."_js2n__-:definitions/CharacterSet!predicate",
                  cost = _js2n__-prdslib.isType '"Number",
                  penalty = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CostMapDefInsDel!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "insDel", "map" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  insDel = _js2n__-prdslib.isType '"Number",
                  map = _js2n__-prdslib.isType '"String",
                  penalty = _js2n__-prdslib.isType '"Number",
                  replace = _js2n__-prdslib.isType '"Number",
                  swap = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CostMapDefReplace!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "map", "replace" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  insDel = _js2n__-prdslib.isType '"Number",
                  map = _js2n__-prdslib.isType '"String",
                  penalty = _js2n__-prdslib.isType '"Number",
                  replace = _js2n__-prdslib.isType '"Number",
                  swap = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CostMapDefSwap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "map", "swap" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  insDel = _js2n__-prdslib.isType '"Number",
                  map = _js2n__-prdslib.isType '"String",
                  penalty = _js2n__-prdslib.isType '"Number",
                  replace = _js2n__-prdslib.isType '"Number",
                  swap = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CustomDictionaryPath!predicate"
        | doc "A File System Path to a dictionary file."
        = _js2n__-refsenv."_js2n__-:definitions/FsDictionaryPath!predicate",
      "_js2n__-:definitions/CustomDictionaryScope!predicate"
        | doc "Specifies the scope of a dictionary."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "user", "workspace", "folder" ]
            ],
      "_js2n__-:definitions/DictionaryDefinition!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinitionPreferred!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinitionCustom!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinitionAugmented!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinitionInline!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinitionAlternate!predicate"
            ],
      "_js2n__-:definitions/DictionaryDefinitionAlternate!predicate"
        | doc "Only for legacy dictionary definitions."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "file", "name" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  file =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryPath!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryId!predicate",
                  noSuggest = _js2n__-prdslib.isType '"Bool",
                  repMap =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceMap!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryFileTypes!predicate",
                  useCompounds = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DictionaryDefinitionAugmented!predicate"
        | doc "Used to provide extra data related to the dictionary"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "path" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  dictionaryInformation =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryInformation!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryId!predicate",
                  noSuggest = _js2n__-prdslib.isType '"Bool",
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryPath!predicate",
                  repMap =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceMap!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryFileTypes!predicate",
                  useCompounds = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DictionaryDefinitionCustom!predicate"
        | doc m%"
          For Defining Custom dictionaries. They are generally scoped to a `user`, `workspace`, or `folder`. When `addWords` is true, indicates that the spell checker can add words to the file.
          
          Note: only plain text files with one word per line are supported at this moment.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "addWords", "name", "path" ],
              _js2n__-prdslib.records.record
                {
                  addWords = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryId!predicate",
                  noSuggest = _js2n__-prdslib.isType '"Bool",
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/CustomDictionaryPath!predicate",
                  repMap =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceMap!predicate",
                  scope =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CustomDictionaryScope!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CustomDictionaryScope!predicate"
                            ]
                        ],
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryFileTypes!predicate",
                  useCompounds = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DictionaryDefinitionInline!predicate"
        | doc "Inline Dictionary Definitions"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinitionInlineWords!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinitionInlineIgnoreWords!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinitionInlineFlagWords!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinitionInlineSuggestWords!predicate"
            ],
      "_js2n__-:definitions/DictionaryDefinitionInlineFlagWords!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "flagWords", "name" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  flagWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignoreWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryId!predicate",
                  noSuggest = _js2n__-prdslib.isType '"Bool",
                  repMap =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceMap!predicate",
                  suggestWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryFileTypes!predicate",
                  useCompounds = _js2n__-prdslib.isType '"Bool",
                  words =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DictionaryDefinitionInlineIgnoreWords!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "ignoreWords", "name" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  flagWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignoreWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryId!predicate",
                  noSuggest = _js2n__-prdslib.isType '"Bool",
                  repMap =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceMap!predicate",
                  suggestWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryFileTypes!predicate",
                  useCompounds = _js2n__-prdslib.isType '"Bool",
                  words =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DictionaryDefinitionInlineSuggestWords!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "suggestWords" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  flagWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignoreWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryId!predicate",
                  noSuggest = _js2n__-prdslib.isType '"Bool",
                  repMap =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceMap!predicate",
                  suggestWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryFileTypes!predicate",
                  useCompounds = _js2n__-prdslib.isType '"Bool",
                  words =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DictionaryDefinitionInlineWords!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "words" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  flagWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignoreWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryId!predicate",
                  noSuggest = _js2n__-prdslib.isType '"Bool",
                  repMap =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceMap!predicate",
                  suggestWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryFileTypes!predicate",
                  useCompounds = _js2n__-prdslib.isType '"Bool",
                  words =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DictionaryDefinitionPreferred!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "path" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryId!predicate",
                  noSuggest = _js2n__-prdslib.isType '"Bool",
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryPath!predicate",
                  repMap =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceMap!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/DictionaryFileTypes!predicate",
                  useCompounds = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DictionaryFileTypes!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "S", "W", "C", "T" ]
            ],
      "_js2n__-:definitions/DictionaryId!predicate"
        | doc m%"
          This is the name of a dictionary.
          
          Name Format:
          - Must contain at least 1 number or letter.
          - Spaces are allowed.
          - Leading and trailing space will be removed.
          - Names ARE case-sensitive.
          - Must not contain `*`, `!`, `;`, `,`, `{`, `}`, `[`, `]`, `~`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(?=[^!*,;{}[\\]~\\n]+$)(?=(.*\\w)).+$"
            ],
      "_js2n__-:definitions/DictionaryInformation!predicate"
        | doc m%"
          Use by dictionary authors to help improve the quality of suggestions given from the dictionary.
          
          Added with `v5.16.0`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accents =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CharacterSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CharacterSetCosts!predicate"
                            ]
                        ],
                  adjustments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PatternAdjustment!predicate"
                        ],
                  alphabet =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CharacterSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CharacterSetCosts!predicate"
                            ]
                        ],
                  costs =
                    _js2n__-refsenv."_js2n__-:definitions/EditCosts!predicate",
                  hunspellInformation =
                    _js2n__-refsenv."_js2n__-:definitions/HunspellInformation!predicate",
                  ignore =
                    _js2n__-refsenv."_js2n__-:definitions/CharacterSet!predicate",
                  locale = _js2n__-prdslib.isType '"String",
                  suggestionEditCosts =
                    _js2n__-refsenv."_js2n__-:definitions/SuggestionCostsDefs!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DictionaryNegRef!predicate"
        | doc m%"
          This a negative reference to a named dictionary.
          
          It is used to exclude or include a dictionary by name.
          
          The reference starts with 1 or more `!`.
          - `!<dictionary_name>` - Used to exclude the dictionary matching `<dictionary_name>`.
          - `!!<dictionary_name>` - Used to re-include a dictionary matching `<dictionary_name>`.    Overrides `!<dictionary_name>`.
          - `!!!<dictionary_name>` - Used to exclude a dictionary matching `<dictionary_name>`.    Overrides `!!<dictionary_name>`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(?=!+[^!*,;{}[\\]~\\n]+$)(?=(.*\\w)).+$"
            ],
      "_js2n__-:definitions/DictionaryPath!predicate"
        | doc "A File System Path to a dictionary file. Pattern: `^.*\\.(?:txt|trie|dic)(?:\\.gz)?$`"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/DictionaryRef!predicate"
        | doc "This a reference to a named dictionary. It is expected to match the name of a dictionary."
        = _js2n__-refsenv."_js2n__-:definitions/DictionaryId!predicate",
      "_js2n__-:definitions/DictionaryReference!predicate"
        | doc m%"
          Reference to a dictionary by name. One of:
          -  {@link  DictionaryRef } 
          -  {@link  DictionaryNegRef }
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DictionaryRef!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DictionaryNegRef!predicate"
            ],
      "_js2n__-:definitions/EditCosts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accentCosts = _js2n__-prdslib.isType '"Number",
                  baseCost = _js2n__-prdslib.isType '"Number",
                  capsCosts = _js2n__-prdslib.isType '"Number",
                  firstLetterPenalty = _js2n__-prdslib.isType '"Number",
                  nonAlphabetCosts = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FSPathResolvable!predicate"
        | doc m%"
          A File System Path.
          
          Special Properties:
          - `${cwd}` prefix - will be replaced with the current working directory.
          - Relative paths are relative to the configuration file.
        "%
        = _js2n__-refsenv."_js2n__-:definitions/FsPath!predicate",
      "_js2n__-:definitions/FeatureEnableOnly!predicate" =
        _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/Features!predicate"
        | doc "Features are behaviors or settings that can be explicitly configured."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  weighted-suggestions =
                    _js2n__-refsenv."_js2n__-:definitions/FeatureEnableOnly!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FsDictionaryPath!predicate"
        | doc "A File System Path. Relative paths are relative to the configuration file."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/FsPath!predicate"
        | doc "A File System Path. Relative paths are relative to the configuration file."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Glob!predicate"
        | doc "These are glob expressions."
        = _js2n__-refsenv."_js2n__-:definitions/SimpleGlob!predicate",
      "_js2n__-:definitions/HunspellInformation!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "aff" ],
              _js2n__-prdslib.records.record
                {
                  aff = _js2n__-prdslib.isType '"String",
                  costs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              accentCosts = _js2n__-prdslib.isType '"Number",
                              baseCost = _js2n__-prdslib.isType '"Number",
                              capsCosts = _js2n__-prdslib.isType '"Number",
                              firstLetterPenalty =
                                _js2n__-prdslib.isType '"Number",
                              ioConvertCost = _js2n__-prdslib.isType '"Number",
                              keyboardCost = _js2n__-prdslib.isType '"Number",
                              mapCost = _js2n__-prdslib.isType '"Number",
                              nonAlphabetCosts =
                                _js2n__-prdslib.isType '"Number",
                              replaceCosts = _js2n__-prdslib.isType '"Number",
                              tryCharCost = _js2n__-prdslib.isType '"Number",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LanguageId!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LanguageIdSingle!predicate",
              _js2n__-refsenv."_js2n__-:definitions/LanguageIdMultiple!predicate",
              _js2n__-refsenv."_js2n__-:definitions/LanguageIdMultipleNeg!predicate"
            ],
      "_js2n__-:definitions/LanguageIdMultiple!predicate"
        | doc m%"
          A single string with a comma separated list of file types:
          - `typescript,cpp`
          - `json,jsonc,yaml`
          - etc.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^([-\\w_\\s]+)(,[-\\w_\\s]+)*$"
            ],
      "_js2n__-:definitions/LanguageIdMultipleNeg!predicate"
        | doc m%"
          A Negative File Type used to exclude files of that type.
          - `!typescript` - will exclude typescript files.
          - `!cpp,!json` - will exclude cpp and json files.
          - `!typescript,javascript` - will exclude typescript files and include javascript files.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(![-\\w_\\s]+)(,!?[-\\w_\\s]+)*$"
            ],
      "_js2n__-:definitions/LanguageIdSingle!predicate"
        | doc m%"
          A file type:
          - `*` - will match ALL file types.
          - `typescript`, `cpp`, `json`, etc.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^(!?[-\\w_\\s]+)|(\\*)$"
            ],
      "_js2n__-:definitions/LanguageSetting!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "languageId" ],
              _js2n__-prdslib.records.record
                {
                  allowCompoundWords = _js2n__-prdslib.isType '"Bool",
                  caseSensitive = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  dictionaries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DictionaryReference!predicate"
                        ],
                  dictionaryDefinitions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinition!predicate"
                        ],
                  enabled = _js2n__-prdslib.isType '"Bool",
                  flagWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  ignoreRegExpList =
                    _js2n__-refsenv."_js2n__-:definitions/RegExpPatternList!predicate",
                  ignoreWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  includeRegExpList =
                    _js2n__-refsenv."_js2n__-:definitions/RegExpPatternList!predicate",
                  languageId =
                    _js2n__-refsenv."_js2n__-:definitions/MatchingFileType!predicate",
                  local =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LocaleId!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/LocaleId!predicate"
                            ]
                        ],
                  locale =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LocaleId!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/LocaleId!predicate"
                            ]
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  noSuggestDictionaries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DictionaryReference!predicate"
                        ],
                  patterns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RegExpPatternDefinition!predicate"
                        ],
                  suggestWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  words =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LocaleId!predicate"
        | doc "This is a written language locale like: `en`, `en-GB`, `fr`, `es`, `de` or `en,fr` for both English and French"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/MatchingFileType!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LanguageId!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/LanguageId!predicate"
                ]
            ],
      "_js2n__-:definitions/OverrideSettings!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "filename" ],
              _js2n__-prdslib.records.record
                {
                  allowCompoundWords = _js2n__-prdslib.isType '"Bool",
                  caseSensitive = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  dictionaries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DictionaryReference!predicate"
                        ],
                  dictionaryDefinitions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinition!predicate"
                        ],
                  enableFiletypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/LanguageIdSingle!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  enabled = _js2n__-prdslib.isType '"Bool",
                  enabledFileTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"Bool")
                        ],
                  enabledLanguageIds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/LanguageIdSingle!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  filename =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Glob!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                            ]
                        ],
                  flagWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  ignoreRegExpList =
                    _js2n__-refsenv."_js2n__-:definitions/RegExpPatternList!predicate",
                  ignoreWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  includeRegExpList =
                    _js2n__-refsenv."_js2n__-:definitions/RegExpPatternList!predicate",
                  language =
                    _js2n__-refsenv."_js2n__-:definitions/LocaleId!predicate",
                  languageId =
                    _js2n__-refsenv."_js2n__-:definitions/MatchingFileType!predicate",
                  languageSettings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/LanguageSetting!predicate"
                        ],
                  loadDefaultConfiguration = _js2n__-prdslib.isType '"Bool",
                  maxDuplicateProblems = _js2n__-prdslib.isType '"Number",
                  maxNumberOfProblems = _js2n__-prdslib.isType '"Number",
                  minWordLength = _js2n__-prdslib.isType '"Number",
                  name = _js2n__-prdslib.isType '"String",
                  noSuggestDictionaries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DictionaryReference!predicate"
                        ],
                  numSuggestions = _js2n__-prdslib.isType '"Number",
                  patterns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RegExpPatternDefinition!predicate"
                        ],
                  pnpFiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  suggestWords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  suggestionNumChanges = _js2n__-prdslib.isType '"Number",
                  suggestionsTimeout = _js2n__-prdslib.isType '"Number",
                  usePnP = _js2n__-prdslib.isType '"Bool",
                  words =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Pattern!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/PatternAdjustment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id", "penalty", "regexp" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  penalty = _js2n__-prdslib.isType '"Number",
                  regexp = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PatternId!predicate"
        | doc "This matches the name in a pattern definition."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/PatternRef!predicate"
        | doc "A PatternRef is a Pattern or PatternId."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Pattern!predicate",
              _js2n__-refsenv."_js2n__-:definitions/PatternId!predicate",
              _js2n__-refsenv."_js2n__-:definitions/PredefinedPatterns!predicate"
            ],
      "_js2n__-:definitions/PredefinedPatterns!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "Base64",
                  "Base64MultiLine",
                  "Base64SingleLine",
                  "CStyleComment",
                  "CStyleHexValue",
                  "CSSHexValue",
                  "CommitHash",
                  "CommitHashLink",
                  "Email",
                  "EscapeCharacters",
                  "HexValues",
                  "href",
                  "PhpHereDoc",
                  "PublicKey",
                  "RsaCert",
                  "SshRsa",
                  "SHA",
                  "HashStrings",
                  "SpellCheckerDisable",
                  "SpellCheckerDisableBlock",
                  "SpellCheckerDisableLine",
                  "SpellCheckerDisableNext",
                  "SpellCheckerIgnoreInDocSetting",
                  "string",
                  "UnicodeRef",
                  "Urls",
                  "UUID",
                  "Everything"
                ]
            ],
      "_js2n__-:definitions/RegExpPatternDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "pattern" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/PatternId!predicate",
                  pattern =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Pattern!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Pattern!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RegExpPatternList!predicate"
        | doc "A list of pattern names or regular expressions."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/PatternRef!predicate"
            ],
      "_js2n__-:definitions/ReplaceEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 2
            ],
      "_js2n__-:definitions/ReplaceMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/ReplaceEntry!predicate"
            ],
      "_js2n__-:definitions/ReporterModuleName!predicate"
        | doc "The module or path to the the reporter to load."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/ReporterOptions!predicate"
        | doc "Options to send to the reporter. These are defined by the reporter."
        = _js2n__-refsenv."_js2n__-:definitions/Serializable!predicate",
      "_js2n__-:definitions/ReporterSettings!predicate"
        | doc m%"
          Declare a reporter to use.
          
          `default` - is a special name for the default cli reporter.
          
          Examples:
          - `"default"` - to use the default reporter
          - `"@cspell/cspell-json-reporter"` - use the cspell JSON reporter.
          - `["@cspell/cspell-json-reporter", { "outFile": "out.json" }]`
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/ReporterModuleName!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/ReporterModuleName!predicate",
                  _js2n__-prdslib.arrays.maxItems 1,
                  _js2n__-prdslib.arrays.minItems 1
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.items
                    [
                      _js2n__-refsenv."_js2n__-:definitions/ReporterModuleName!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/ReporterOptions!predicate"
                    ],
                  _js2n__-prdslib.arrays.maxItems 2,
                  _js2n__-prdslib.arrays.minItems 2
                ]
            ],
      "_js2n__-:definitions/Serializable!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType 'Null,
              _js2n__-prdslib.isType 'Record
            ],
      "_js2n__-:definitions/SimpleGlob!predicate"
        | doc "Simple Glob string, the root will be globRoot."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/SuggestionCostMapDef!predicate"
        | doc m%"
          A WeightedMapDef enables setting weights for edits between related characters and substrings.
          
          Multiple groups can be defined using a `|`. A multi-character substring is defined using `()`.
          
          For example, in some languages, some letters sound alike.
          
          ```yaml   map: 'sc(sh)(sch)(ss)|t(tt)' # two groups.   replace: 50    # Make it 1/2 the cost of a normal edit to replace a `t` with `tt`. ```
          
          The following could be used to make inserting, removing, or replacing vowels cheaper. ```yaml   map: 'aeiouy'   insDel: 50     # Make it is cheaper to insert or delete a vowel.   replace: 45    # It is even cheaper to replace one with another. ```
          
          Note: the default edit distance is 100.
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/CostMapDefReplace!predicate",
              _js2n__-refsenv."_js2n__-:definitions/CostMapDefInsDel!predicate",
              _js2n__-refsenv."_js2n__-:definitions/CostMapDefSwap!predicate"
            ],
      "_js2n__-:definitions/SuggestionCostsDefs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SuggestionCostMapDef!predicate"
            ],
      "_js2n__-:definitions/Version!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/VersionLatest!predicate",
              _js2n__-refsenv."_js2n__-:definitions/VersionLegacy!predicate"
            ],
      "_js2n__-:definitions/VersionLatest!predicate"
        | doc "Configuration File Version."
        = _js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.const "0.2" ],
      "_js2n__-:definitions/VersionLegacy!predicate"
        | doc "Legacy Configuration File Versions."
        = _js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.const "0.1" ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              "$schema" = _js2n__-prdslib.isType '"String",
              allowCompoundWords = _js2n__-prdslib.isType '"Bool",
              cache =
                _js2n__-refsenv."_js2n__-:definitions/CacheSettings!predicate",
              caseSensitive = _js2n__-prdslib.isType '"Bool",
              description = _js2n__-prdslib.isType '"String",
              dictionaries =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/DictionaryReference!predicate"
                    ],
              dictionaryDefinitions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/DictionaryDefinition!predicate"
                    ],
              enableFiletypes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/LanguageIdSingle!predicate",
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              enableGlobDot = _js2n__-prdslib.isType '"Bool",
              enabled = _js2n__-prdslib.isType '"Bool",
              enabledFileTypes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.isType '"Bool")
                    ],
              enabledLanguageIds =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/LanguageIdSingle!predicate",
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              failFast = _js2n__-prdslib.isType '"Bool",
              features =
                _js2n__-refsenv."_js2n__-:definitions/Features!predicate",
              files =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                    ],
              flagWords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              gitignoreRoot =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/FsPath!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FsPath!predicate"
                        ]
                    ],
              globRoot =
                _js2n__-refsenv."_js2n__-:definitions/FSPathResolvable!predicate",
              id = _js2n__-prdslib.isType '"String",
              ignorePaths =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                    ],
              ignoreRegExpList =
                _js2n__-refsenv."_js2n__-:definitions/RegExpPatternList!predicate",
              ignoreWords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              "import" =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/FsPath!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FsPath!predicate"
                        ]
                    ],
              includeRegExpList =
                _js2n__-refsenv."_js2n__-:definitions/RegExpPatternList!predicate",
              language =
                _js2n__-refsenv."_js2n__-:definitions/LocaleId!predicate",
              languageId =
                _js2n__-refsenv."_js2n__-:definitions/MatchingFileType!predicate",
              languageSettings =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/LanguageSetting!predicate"
                    ],
              loadDefaultConfiguration = _js2n__-prdslib.isType '"Bool",
              maxDuplicateProblems = _js2n__-prdslib.isType '"Number",
              maxNumberOfProblems = _js2n__-prdslib.isType '"Number",
              minWordLength = _js2n__-prdslib.isType '"Number",
              name = _js2n__-prdslib.isType '"String",
              noConfigSearch = _js2n__-prdslib.isType '"Bool",
              noSuggestDictionaries =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/DictionaryReference!predicate"
                    ],
              numSuggestions = _js2n__-prdslib.isType '"Number",
              overrides =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/OverrideSettings!predicate"
                    ],
              patterns =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/RegExpPatternDefinition!predicate"
                    ],
              pnpFiles =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              readonly = _js2n__-prdslib.isType '"Bool",
              reporters =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/ReporterSettings!predicate"
                    ],
              showStatus = _js2n__-prdslib.isType '"Bool",
              spellCheckDelayMs = _js2n__-prdslib.isType '"Number",
              suggestWords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              suggestionNumChanges = _js2n__-prdslib.isType '"Number",
              suggestionsTimeout = _js2n__-prdslib.isType '"Number",
              useGitignore = _js2n__-prdslib.isType '"Bool",
              usePnP = _js2n__-prdslib.isType '"Bool",
              userWords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              validateDirectives = _js2n__-prdslib.isType '"Bool",
              version =
                _js2n__-refsenv."_js2n__-:definitions/Version!predicate",
              words =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
            } {} false _js2n__-prdslib.never
        ])