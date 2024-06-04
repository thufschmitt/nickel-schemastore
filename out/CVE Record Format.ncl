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
      "_js2n__-:definitions/adpContainer!predicate"
        | doc "An object containing the vulnerability information provided by an Authorized Data Publisher (ADP). Since multiple ADPs can provide information for a CVE ID, an ADP container must indicate which ADP is the source of the information in the object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 2,
              _js2n__-prdslib.records.required [ "providerMetadata" ],
              _js2n__-prdslib.records.record
                {
                  affected =
                    _js2n__-refsenv."_js2n__-:definitions/affected!predicate",
                  configurations =
                    _js2n__-refsenv."_js2n__-:definitions/configurations!predicate",
                  credits =
                    _js2n__-refsenv."_js2n__-:definitions/credits!predicate",
                  datePublic =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  descriptions =
                    _js2n__-refsenv."_js2n__-:definitions/descriptions!predicate",
                  exploits =
                    _js2n__-refsenv."_js2n__-:definitions/exploits!predicate",
                  impacts =
                    _js2n__-refsenv."_js2n__-:definitions/impacts!predicate",
                  metrics =
                    _js2n__-refsenv."_js2n__-:definitions/metrics!predicate",
                  problemTypes =
                    _js2n__-refsenv."_js2n__-:definitions/problemTypes!predicate",
                  providerMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/providerMetadata!predicate",
                  references =
                    _js2n__-refsenv."_js2n__-:definitions/references!predicate",
                  solutions =
                    _js2n__-refsenv."_js2n__-:definitions/solutions!predicate",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/source!predicate",
                  tags =
                    _js2n__-refsenv."_js2n__-:definitions/adpTags!predicate",
                  taxonomyMappings =
                    _js2n__-refsenv."_js2n__-:definitions/taxonomyMappings!predicate",
                  timeline =
                    _js2n__-refsenv."_js2n__-:definitions/timeline!predicate",
                  title =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 256,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  workarounds =
                    _js2n__-refsenv."_js2n__-:definitions/workarounds!predicate",
                } { "^x_[^.]*$" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/adpTags!predicate"
        | doc "Tags provided by an ADP describing the CVE Record."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/tagExtension!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum [ "disputed" ]
                      ]
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/affected!predicate"
        | doc "List of affected products."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/product!predicate",
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/cnaPublishedContainer!predicate"
        | doc "An object containing the vulnerability information provided by a CVE Numbering Authority (CNA) for a published CVE ID. There can only be one CNA container per CVE record since there can only be one assigning CNA. The CNA container must include the required information defined in the CVE Rules, which includes a product, version, problem type, prose description, and a reference."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "affected",
                  "descriptions",
                  "providerMetadata",
                  "references"
                ],
              _js2n__-prdslib.records.record
                {
                  affected =
                    _js2n__-refsenv."_js2n__-:definitions/affected!predicate",
                  configurations =
                    _js2n__-refsenv."_js2n__-:definitions/configurations!predicate",
                  credits =
                    _js2n__-refsenv."_js2n__-:definitions/credits!predicate",
                  dateAssigned =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  datePublic =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  descriptions =
                    _js2n__-refsenv."_js2n__-:definitions/descriptions!predicate",
                  exploits =
                    _js2n__-refsenv."_js2n__-:definitions/exploits!predicate",
                  impacts =
                    _js2n__-refsenv."_js2n__-:definitions/impacts!predicate",
                  metrics =
                    _js2n__-refsenv."_js2n__-:definitions/metrics!predicate",
                  problemTypes =
                    _js2n__-refsenv."_js2n__-:definitions/problemTypes!predicate",
                  providerMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/providerMetadata!predicate",
                  references =
                    _js2n__-refsenv."_js2n__-:definitions/references!predicate",
                  solutions =
                    _js2n__-refsenv."_js2n__-:definitions/solutions!predicate",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/source!predicate",
                  tags =
                    _js2n__-refsenv."_js2n__-:definitions/cnaTags!predicate",
                  taxonomyMappings =
                    _js2n__-refsenv."_js2n__-:definitions/taxonomyMappings!predicate",
                  timeline =
                    _js2n__-refsenv."_js2n__-:definitions/timeline!predicate",
                  title =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 256,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  workarounds =
                    _js2n__-refsenv."_js2n__-:definitions/workarounds!predicate",
                } { "^x_[^.]*$" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cnaRejectedContainer!predicate"
        | doc "An object containing the vulnerability information provided by a CVE Numbering Authority (CNA) for a rejected CVE ID. There can only be one CNA container per CVE record since there can only be one assigning CNA."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "providerMetadata", "rejectedReasons" ],
              _js2n__-prdslib.records.record
                {
                  providerMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/providerMetadata!predicate",
                  rejectedReasons =
                    _js2n__-refsenv."_js2n__-:definitions/descriptions!predicate",
                  replacedBy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/cveId!predicate",
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } { "^x_[^.]*$" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cnaTags!predicate"
        | doc "Tags provided by a CNA describing the CVE Record."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/tagExtension!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "unsupported-when-assigned",
                            "exclusively-hosted-service",
                            "disputed"
                          ]
                      ]
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/configurations!predicate"
        | doc "Configurations required for exploiting this vulnerability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/description!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/credits!predicate"
        | doc "Statements acknowledging specific people, organizations, or tools recognizing the work done in researching, discovering, remediating or helping with activities related to this CVE."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "lang", "value" ],
                    _js2n__-prdslib.records.record
                      {
                        lang =
                          _js2n__-refsenv."_js2n__-:definitions/language!predicate",
                        type =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "finder",
                                    "reporter",
                                    "analyst",
                                    "coordinator",
                                    "remediation developer",
                                    "remediation reviewer",
                                    "remediation verifier",
                                    "tool",
                                    "sponsor",
                                    "other"
                                  ]
                              ],
                        user =
                          _js2n__-refsenv."_js2n__-:definitions/uuidType!predicate",
                        value =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 4096,
                                _js2n__-prdslib.strings.minLength 1
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/cveId!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^CVE-[0-9]{4}-[0-9]{4,19}$"
            ],
      "_js2n__-:definitions/cveMetadataPublished!predicate"
        | doc "This is meta data about the CVE ID such as the CVE ID, who requested it, who assigned it, when it was requested, the current state (PUBLISHED, REJECTED, etc.) and so on.  These fields are controlled by the CVE Services."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "assignerOrgId", "cveId", "state" ],
              _js2n__-prdslib.records.record
                {
                  assignerOrgId =
                    _js2n__-refsenv."_js2n__-:definitions/orgId!predicate",
                  assignerShortName =
                    _js2n__-refsenv."_js2n__-:definitions/shortName!predicate",
                  cveId =
                    _js2n__-refsenv."_js2n__-:definitions/cveId!predicate",
                  datePublished =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  dateReserved =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  dateUpdated =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  requesterUserId =
                    _js2n__-refsenv."_js2n__-:definitions/userId!predicate",
                  serial =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  state =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "PUBLISHED" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cveMetadataRejected!predicate"
        | doc "This is meta data about the CVE ID such as the CVE ID, who requested it, who assigned it, when it was requested, the current state (PUBLISHED, REJECTED, etc.) and so on.  These fields are controlled by the CVE Services."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "assignerOrgId", "cveId", "state" ],
              _js2n__-prdslib.records.record
                {
                  assignerOrgId =
                    _js2n__-refsenv."_js2n__-:definitions/orgId!predicate",
                  assignerShortName =
                    _js2n__-refsenv."_js2n__-:definitions/shortName!predicate",
                  cveId =
                    _js2n__-refsenv."_js2n__-:definitions/cveId!predicate",
                  datePublished =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  dateRejected =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  dateReserved =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  dateUpdated =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  serial =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  state =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "REJECTED" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dataType!predicate"
        | doc "Indicates the type of information represented in the JSON instance."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "CVE_RECORD" ]
            ],
      "_js2n__-:definitions/dataVersion!predicate"
        | doc "The version of the CVE schema used for validating this record. Used to support multiple versions of this format."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^5\\.(0|[1-9][0-9]*)(\\.(0|[1-9][0-9]*))?$"
            ],
      "_js2n__-:definitions/description!predicate"
        | doc "Text in a particular language with optional alternate markup or formatted representation (e.g., Markdown) or embedded media."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "lang", "value" ],
              _js2n__-prdslib.records.record
                {
                  lang =
                    _js2n__-refsenv."_js2n__-:definitions/language!predicate",
                  supportingMedia =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "type", "value" ],
                                _js2n__-prdslib.records.record
                                  {
                                    base64 = _js2n__-prdslib.isType '"Bool",
                                    type =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.maxLength
                                              256,
                                            _js2n__-prdslib.strings.minLength 1
                                          ],
                                    value =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.maxLength
                                              16384,
                                            _js2n__-prdslib.strings.minLength 1
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  value =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 4096,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/descriptions!predicate"
        | doc "A list of multi-lingual descriptions of the vulnerability. E.g., [PROBLEMTYPE] in [COMPONENT] in [VENDOR] [PRODUCT] [VERSION] on [PLATFORMS] allows [ATTACKER] to [IMPACT] via [VECTOR]. OR [COMPONENT] in [VENDOR] [PRODUCT] [VERSION] [ROOT CAUSE], which allows [ATTACKER] to [IMPACT] via [VECTOR]."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/description!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems,
              _js2n__-prdslib.arrays.contains
                _js2n__-refsenv."_js2n__-:definitions/englishLanguageDescription!predicate"
            ],
      "_js2n__-:definitions/englishLanguage!predicate"
        | doc "BCP 47 language code, language-region, required to be English."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^en([_-][A-Za-z]{4})?([_-]([A-Za-z]{2}|[0-9]{3}))?$"
            ],
      "_js2n__-:definitions/englishLanguageDescription!predicate"
        | doc "A description with lang set to an English language (en, en_US, en_UK, and so on)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "lang" ],
              _js2n__-prdslib.records.record
                {
                  lang =
                    _js2n__-refsenv."_js2n__-:definitions/englishLanguage!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/exploits!predicate"
        | doc "Information about exploits of the vulnerability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/description!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/impacts!predicate"
        | doc "Collection of impacts of this vulnerability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "descriptions" ],
                    _js2n__-prdslib.records.record
                      {
                        capecId =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 11,
                                _js2n__-prdslib.strings.minLength 7,
                                _js2n__-prdslib.strings.pattern
                                  "^CAPEC-[1-9][0-9]{0,4}$"
                              ],
                        descriptions =
                          _js2n__-refsenv."_js2n__-:definitions/descriptions!predicate",
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/language!predicate"
        | doc "BCP 47 language code, language-region."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[A-Za-z]{2,4}([_-][A-Za-z]{4})?([_-]([A-Za-z]{2}|[0-9]{3}))?$"
            ],
      "_js2n__-:definitions/metrics!predicate"
        | doc "Collection of impact scores with attribution."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "cvssV4_0" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "cvssV3_1" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "cvssV3_0" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "cvssV2_0" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "other" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ],
                    _js2n__-prdslib.records.record
                      {
                        cvssV2_0 =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "baseScore", "vectorString", "version" ],
                                _js2n__-prdslib.records.record
                                  {
                                    accessComplexity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/accessComplexityType!predicate",
                                    accessVector =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/accessVectorType!predicate",
                                    authentication =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/authenticationType!predicate",
                                    availabilityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/ciaType!predicate",
                                    availabilityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/ciaRequirementType!predicate",
                                    baseScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/scoreType!predicate",
                                    collateralDamagePotential =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/collateralDamagePotentialType!predicate",
                                    confidentialityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/ciaType!predicate",
                                    confidentialityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/ciaRequirementType!predicate",
                                    environmentalScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/scoreType!predicate",
                                    exploitability =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/exploitabilityType!predicate",
                                    integrityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/ciaType!predicate",
                                    integrityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/ciaRequirementType!predicate",
                                    remediationLevel =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/remediationLevelType!predicate",
                                    reportConfidence =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/reportConfidenceType!predicate",
                                    targetDistribution =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/targetDistributionType!predicate",
                                    temporalScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/scoreType!predicate",
                                    vectorString =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.pattern
                                              "^((AV:[NAL]|AC:[LMH]|Au:[MSN]|[CIA]:[NPC]|E:(U|POC|F|H|ND)|RL:(OF|TF|W|U|ND)|RC:(UC|UR|C|ND)|CDP:(N|L|LM|MH|H|ND)|TD:(N|L|M|H|ND)|[CIA]R:(L|M|H|ND))/)*(AV:[NAL]|AC:[LMH]|Au:[MSN]|[CIA]:[NPC]|E:(U|POC|F|H|ND)|RL:(OF|TF|W|U|ND)|RC:(UC|UR|C|ND)|CDP:(N|L|LM|MH|H|ND)|TD:(N|L|M|H|ND)|[CIA]R:(L|M|H|ND))$"
                                          ],
                                    version =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum [ "2.0" ]
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        cvssV3_0 =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/noneScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/noneSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always,
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/lowScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/lowSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always,
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/mediumScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/mediumSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always,
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/highScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/highSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always,
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/criticalScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/criticalSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always
                                  ],
                                _js2n__-prdslib.records.required
                                  [
                                    "baseScore",
                                    "baseSeverity",
                                    "vectorString",
                                    "version"
                                  ],
                                _js2n__-prdslib.records.record
                                  {
                                    attackComplexity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/attackComplexityType!predicate",
                                    attackVector =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/attackVectorType!predicate",
                                    availabilityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/ciaType!predicate",
                                    availabilityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/ciaRequirementType!predicate",
                                    baseScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/scoreType!predicate",
                                    baseSeverity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/severityType!predicate",
                                    confidentialityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/ciaType!predicate",
                                    confidentialityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/ciaRequirementType!predicate",
                                    environmentalScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/scoreType!predicate",
                                    environmentalSeverity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/severityType!predicate",
                                    exploitCodeMaturity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/exploitCodeMaturityType!predicate",
                                    integrityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/ciaType!predicate",
                                    integrityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/ciaRequirementType!predicate",
                                    modifiedAttackComplexity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedAttackComplexityType!predicate",
                                    modifiedAttackVector =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedAttackVectorType!predicate",
                                    modifiedAvailabilityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedCiaType!predicate",
                                    modifiedConfidentialityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedCiaType!predicate",
                                    modifiedIntegrityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedCiaType!predicate",
                                    modifiedPrivilegesRequired =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedPrivilegesRequiredType!predicate",
                                    modifiedScope =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedScopeType!predicate",
                                    modifiedUserInteraction =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedUserInteractionType!predicate",
                                    privilegesRequired =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/privilegesRequiredType!predicate",
                                    remediationLevel =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/remediationLevelType!predicate",
                                    reportConfidence =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/confidenceType!predicate",
                                    scope =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/scopeType!predicate",
                                    temporalScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/scoreType!predicate",
                                    temporalSeverity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/severityType!predicate",
                                    userInteraction =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/userInteractionType!predicate",
                                    vectorString =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.pattern
                                              "^CVSS:3[.]0/((AV:[NALP]|AC:[LH]|PR:[UNLH]|UI:[NR]|S:[UC]|[CIA]:[NLH]|E:[XUPFH]|RL:[XOTWU]|RC:[XURC]|[CIA]R:[XLMH]|MAV:[XNALP]|MAC:[XLH]|MPR:[XUNLH]|MUI:[XNR]|MS:[XUC]|M[CIA]:[XNLH])/)*(AV:[NALP]|AC:[LH]|PR:[UNLH]|UI:[NR]|S:[UC]|[CIA]:[NLH]|E:[XUPFH]|RL:[XOTWU]|RC:[XURC]|[CIA]R:[XLMH]|MAV:[XNALP]|MAC:[XLH]|MPR:[XUNLH]|MUI:[XNR]|MS:[XUC]|M[CIA]:[XNLH])$"
                                          ],
                                    version =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum [ "3.0" ]
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        cvssV3_1 =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/noneScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/noneSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always,
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/lowScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/lowSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always,
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/mediumScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/mediumSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always,
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/highScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/highSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always,
                                    _js2n__-prdslib.records.record
                                      {
                                        baseScore =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/criticalScoreType!predicate",
                                        baseSeverity =
                                          _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/criticalSeverityType!predicate",
                                      } {} true _js2n__-prdslib.always
                                  ],
                                _js2n__-prdslib.records.required
                                  [
                                    "baseScore",
                                    "baseSeverity",
                                    "vectorString",
                                    "version"
                                  ],
                                _js2n__-prdslib.records.record
                                  {
                                    attackComplexity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/attackComplexityType!predicate",
                                    attackVector =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/attackVectorType!predicate",
                                    availabilityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/ciaType!predicate",
                                    availabilityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/ciaRequirementType!predicate",
                                    baseScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/scoreType!predicate",
                                    baseSeverity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/severityType!predicate",
                                    confidentialityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/ciaType!predicate",
                                    confidentialityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/ciaRequirementType!predicate",
                                    environmentalScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/scoreType!predicate",
                                    environmentalSeverity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/severityType!predicate",
                                    exploitCodeMaturity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/exploitCodeMaturityType!predicate",
                                    integrityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/ciaType!predicate",
                                    integrityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/ciaRequirementType!predicate",
                                    modifiedAttackComplexity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedAttackComplexityType!predicate",
                                    modifiedAttackVector =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedAttackVectorType!predicate",
                                    modifiedAvailabilityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedCiaType!predicate",
                                    modifiedConfidentialityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedCiaType!predicate",
                                    modifiedIntegrityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedCiaType!predicate",
                                    modifiedPrivilegesRequired =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedPrivilegesRequiredType!predicate",
                                    modifiedScope =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedScopeType!predicate",
                                    modifiedUserInteraction =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedUserInteractionType!predicate",
                                    privilegesRequired =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/privilegesRequiredType!predicate",
                                    remediationLevel =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/remediationLevelType!predicate",
                                    reportConfidence =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/confidenceType!predicate",
                                    scope =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/scopeType!predicate",
                                    temporalScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/scoreType!predicate",
                                    temporalSeverity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/severityType!predicate",
                                    userInteraction =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/userInteractionType!predicate",
                                    vectorString =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.pattern
                                              "^CVSS:3[.]1/((AV:[NALP]|AC:[LH]|PR:[NLH]|UI:[NR]|S:[UC]|[CIA]:[NLH]|E:[XUPFH]|RL:[XOTWU]|RC:[XURC]|[CIA]R:[XLMH]|MAV:[XNALP]|MAC:[XLH]|MPR:[XNLH]|MUI:[XNR]|MS:[XUC]|M[CIA]:[XNLH])/)*(AV:[NALP]|AC:[LH]|PR:[NLH]|UI:[NR]|S:[UC]|[CIA]:[NLH]|E:[XUPFH]|RL:[XOTWU]|RC:[XURC]|[CIA]R:[XLMH]|MAV:[XNALP]|MAC:[XLH]|MPR:[XNLH]|MUI:[XNR]|MS:[XUC]|M[CIA]:[XNLH])$"
                                          ],
                                    version =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum [ "3.1" ]
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        cvssV4_0 =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.records.record
                                          {
                                            baseScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/noneScoreType!predicate",
                                            baseSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/noneSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            baseScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/lowScoreType!predicate",
                                            baseSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/lowSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            baseScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/mediumScoreType!predicate",
                                            baseSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/mediumSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            baseScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/highScoreType!predicate",
                                            baseSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/highSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            baseScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/criticalScoreType!predicate",
                                            baseSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/criticalSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.records.record
                                          {
                                            threatScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/noneScoreType!predicate",
                                            threatSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/noneSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            threatScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/lowScoreType!predicate",
                                            threatSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/lowSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            threatScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/mediumScoreType!predicate",
                                            threatSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/mediumSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            threatScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/highScoreType!predicate",
                                            threatSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/highSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            threatScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/criticalScoreType!predicate",
                                            threatSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/criticalSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.records.record
                                          {
                                            environmentalScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/noneScoreType!predicate",
                                            environmentalSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/noneSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            environmentalScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/lowScoreType!predicate",
                                            environmentalSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/lowSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            environmentalScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/mediumScoreType!predicate",
                                            environmentalSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/mediumSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            environmentalScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/highScoreType!predicate",
                                            environmentalSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/highSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            environmentalScore =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/criticalScoreType!predicate",
                                            environmentalSeverity =
                                              _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/criticalSeverityType!predicate",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.records.required
                                  [
                                    "baseScore",
                                    "baseSeverity",
                                    "vectorString",
                                    "version"
                                  ],
                                _js2n__-prdslib.records.record
                                  {
                                    Automatable =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/automatableType!predicate",
                                    Recovery =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/recoveryType!predicate",
                                    Safety =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/safetyType!predicate",
                                    attackComplexity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/attackComplexityType!predicate",
                                    attackRequirements =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/attackRequirementsType!predicate",
                                    attackVector =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/attackVectorType!predicate",
                                    availabilityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/ciaRequirementType!predicate",
                                    baseScore =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/scoreType!predicate",
                                    baseSeverity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/severityType!predicate",
                                    confidentialityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/ciaRequirementType!predicate",
                                    exploitMaturity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/exploitMaturityType!predicate",
                                    integrityRequirement =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/ciaRequirementType!predicate",
                                    modifiedAttackComplexity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedAttackComplexityType!predicate",
                                    modifiedAttackRequirements =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedAttackRequirementsType!predicate",
                                    modifiedAttackVector =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedAttackVectorType!predicate",
                                    modifiedPrivilegesRequired =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedPrivilegesRequiredType!predicate",
                                    modifiedSubAvailabilityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedSubIaType!predicate",
                                    modifiedSubConfidentialityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedSubCType!predicate",
                                    modifiedSubIntegrityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedSubIaType!predicate",
                                    modifiedUserInteraction =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedUserInteractionType!predicate",
                                    modifiedVulnAvailabilityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedVulnCiaType!predicate",
                                    modifiedVulnConfidentialityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedVulnCiaType!predicate",
                                    modifiedVulnIntegrityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedVulnCiaType!predicate",
                                    privilegesRequired =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/privilegesRequiredType!predicate",
                                    providerUrgency =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/providerUrgencyType!predicate",
                                    subAvailabilityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/subCiaType!predicate",
                                    subConfidentialityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/subCiaType!predicate",
                                    subIntegrityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/subCiaType!predicate",
                                    userInteraction =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/userInteractionType!predicate",
                                    valueDensity =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/valueDensityType!predicate",
                                    vectorString =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.pattern
                                              "^CVSS:4[.]0/AV:[NALP]/AC:[LH]/AT:[NP]/PR:[NLH]/UI:[NPA]/VC:[HLN]/VI:[HLN]/VA:[HLN]/SC:[HLN]/SI:[HLN]/SA:[HLN](/E:[XAPU])?(/CR:[XHML])?(/IR:[XHML])?(/AR:[XHML])?(/MAV:[XNALP])?(/MAC:[XLH])?(/MAT:[XNP])?(/MPR:[XNLH])?(/MUI:[XNPA])?(/MVC:[XNLH])?(/MVI:[XNLH])?(/MVA:[XNLH])?(/MSC:[XNLH])?(/MSI:[XNLHS])?(/MSA:[XNLHS])?(/S:[XNP])?(/AU:[XNY])?(/R:[XAUI])?(/V:[XDC])?(/RE:[XLMH])?(/U:(X|Clear|Green|Amber|Red))?$"
                                          ],
                                    version =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum [ "4.0" ]
                                          ],
                                    vulnAvailabilityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/vulnCiaType!predicate",
                                    vulnConfidentialityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/vulnCiaType!predicate",
                                    vulnIntegrityImpact =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/vulnCiaType!predicate",
                                    vulnerabilityResponseEffort =
                                      _js2n__-refsenv."_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/vulnerabilityResponseEffortType!predicate",
                                  } {} false _js2n__-prdslib.never
                              ],
                        format =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 64,
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        other =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "content", "type" ],
                                _js2n__-prdslib.records.record
                                  {
                                    content =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.minProperties
                                              1,
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                    type =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.maxLength
                                              128,
                                            _js2n__-prdslib.strings.minLength 1
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        scenarios =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "lang", "value" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          lang =
                                            _js2n__-refsenv."_js2n__-:definitions/language!predicate",
                                          value =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.maxLength
                                                    4096,
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1,
                                _js2n__-prdslib.arrays.uniqueItems
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/accessComplexityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "MEDIUM", "LOW" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/accessVectorType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NETWORK", "ADJACENT_NETWORK", "LOCAL" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/authenticationType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "MULTIPLE", "SINGLE", "NONE" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/ciaRequirementType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "LOW", "MEDIUM", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/ciaType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "PARTIAL", "COMPLETE" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/collateralDamagePotentialType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "NONE",
                  "LOW",
                  "LOW_MEDIUM",
                  "MEDIUM_HIGH",
                  "HIGH",
                  "NOT_DEFINED"
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/exploitabilityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "UNPROVEN",
                  "PROOF_OF_CONCEPT",
                  "FUNCTIONAL",
                  "HIGH",
                  "NOT_DEFINED"
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/remediationLevelType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "OFFICIAL_FIX",
                  "TEMPORARY_FIX",
                  "WORKAROUND",
                  "UNAVAILABLE",
                  "NOT_DEFINED"
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/reportConfidenceType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "UNCONFIRMED", "UNCORROBORATED", "CONFIRMED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/scoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 10,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV2_0/definitions/targetDistributionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NONE", "LOW", "MEDIUM", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/attackComplexityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/attackVectorType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NETWORK", "ADJACENT_NETWORK", "LOCAL", "PHYSICAL" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/ciaRequirementType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "LOW", "MEDIUM", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/ciaType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "LOW", "HIGH" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/confidenceType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "UNKNOWN", "REASONABLE", "CONFIRMED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/criticalScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [ 9, 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 9.7, 9.8, 9.9, 10 ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/criticalSeverityType!predicate" =
        _js2n__-prdslib.const "CRITICAL",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/exploitCodeMaturityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "UNPROVEN",
                  "PROOF_OF_CONCEPT",
                  "FUNCTIONAL",
                  "HIGH",
                  "NOT_DEFINED"
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/highScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  7,
                  7.1,
                  7.2,
                  7.3,
                  7.4,
                  7.5,
                  7.6,
                  7.7,
                  7.8,
                  7.9,
                  8,
                  8.1,
                  8.2,
                  8.3,
                  8.4,
                  8.5,
                  8.6,
                  8.7,
                  8.8,
                  8.9
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/highSeverityType!predicate" =
        _js2n__-prdslib.const "HIGH",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/lowScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  0.1,
                  0.2,
                  0.3,
                  0.4,
                  0.5,
                  0.6,
                  0.7,
                  0.8,
                  0.9,
                  1,
                  1.1,
                  1.2,
                  1.3,
                  1.4,
                  1.5,
                  1.6,
                  1.7,
                  1.8,
                  1.9,
                  2,
                  2.1,
                  2.2,
                  2.3,
                  2.4,
                  2.5,
                  2.6,
                  2.7,
                  2.8,
                  2.9,
                  3,
                  3.1,
                  3.2,
                  3.3,
                  3.4,
                  3.5,
                  3.6,
                  3.7,
                  3.8,
                  3.9
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/lowSeverityType!predicate" =
        _js2n__-prdslib.const "LOW",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/mediumScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  4,
                  4.1,
                  4.2,
                  4.3,
                  4.4,
                  4.5,
                  4.6,
                  4.7,
                  4.8,
                  4.9,
                  5,
                  5.1,
                  5.2,
                  5.3,
                  5.4,
                  5.5,
                  5.6,
                  5.7,
                  5.8,
                  5.9,
                  6,
                  6.1,
                  6.2,
                  6.3,
                  6.4,
                  6.5,
                  6.6,
                  6.7,
                  6.8,
                  6.9
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/mediumSeverityType!predicate" =
        _js2n__-prdslib.const "MEDIUM",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedAttackComplexityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedAttackVectorType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "NETWORK",
                  "ADJACENT_NETWORK",
                  "LOCAL",
                  "PHYSICAL",
                  "NOT_DEFINED"
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedCiaType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "LOW", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedPrivilegesRequiredType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW", "NONE", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedScopeType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "UNCHANGED", "CHANGED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/modifiedUserInteractionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "REQUIRED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/noneScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 0,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/noneSeverityType!predicate" =
        _js2n__-prdslib.const "NONE",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/privilegesRequiredType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW", "NONE" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/remediationLevelType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "OFFICIAL_FIX",
                  "TEMPORARY_FIX",
                  "WORKAROUND",
                  "UNAVAILABLE",
                  "NOT_DEFINED"
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/scopeType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "UNCHANGED", "CHANGED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/scoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  0,
                  0.1,
                  0.2,
                  0.3,
                  0.4,
                  0.5,
                  0.6,
                  0.7,
                  0.8,
                  0.9,
                  1,
                  1.1,
                  1.2,
                  1.3,
                  1.4,
                  1.5,
                  1.6,
                  1.7,
                  1.8,
                  1.9,
                  2,
                  2.1,
                  2.2,
                  2.3,
                  2.4,
                  2.5,
                  2.6,
                  2.7,
                  2.8,
                  2.9,
                  3,
                  3.1,
                  3.2,
                  3.3,
                  3.4,
                  3.5,
                  3.6,
                  3.7,
                  3.8,
                  3.9,
                  4,
                  4.1,
                  4.2,
                  4.3,
                  4.4,
                  4.5,
                  4.6,
                  4.7,
                  4.8,
                  4.9,
                  5,
                  5.1,
                  5.2,
                  5.3,
                  5.4,
                  5.5,
                  5.6,
                  5.7,
                  5.8,
                  5.9,
                  6,
                  6.1,
                  6.2,
                  6.3,
                  6.4,
                  6.5,
                  6.6,
                  6.7,
                  6.8,
                  6.9,
                  7,
                  7.1,
                  7.2,
                  7.3,
                  7.4,
                  7.5,
                  7.6,
                  7.7,
                  7.8,
                  7.9,
                  8,
                  8.1,
                  8.2,
                  8.3,
                  8.4,
                  8.5,
                  8.6,
                  8.7,
                  8.8,
                  8.9,
                  9,
                  9.1,
                  9.2,
                  9.3,
                  9.4,
                  9.5,
                  9.6,
                  9.7,
                  9.8,
                  9.9,
                  10
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/severityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NONE", "LOW", "MEDIUM", "HIGH", "CRITICAL" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_0/definitions/userInteractionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "REQUIRED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/attackComplexityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/attackVectorType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NETWORK", "ADJACENT_NETWORK", "LOCAL", "PHYSICAL" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/ciaRequirementType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "LOW", "MEDIUM", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/ciaType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "LOW", "HIGH" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/confidenceType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "UNKNOWN", "REASONABLE", "CONFIRMED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/criticalScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [ 9, 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 9.7, 9.8, 9.9, 10 ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/criticalSeverityType!predicate" =
        _js2n__-prdslib.const "CRITICAL",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/exploitCodeMaturityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "UNPROVEN",
                  "PROOF_OF_CONCEPT",
                  "FUNCTIONAL",
                  "HIGH",
                  "NOT_DEFINED"
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/highScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  7,
                  7.1,
                  7.2,
                  7.3,
                  7.4,
                  7.5,
                  7.6,
                  7.7,
                  7.8,
                  7.9,
                  8,
                  8.1,
                  8.2,
                  8.3,
                  8.4,
                  8.5,
                  8.6,
                  8.7,
                  8.8,
                  8.9
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/highSeverityType!predicate" =
        _js2n__-prdslib.const "HIGH",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/lowScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  0.1,
                  0.2,
                  0.3,
                  0.4,
                  0.5,
                  0.6,
                  0.7,
                  0.8,
                  0.9,
                  1,
                  1.1,
                  1.2,
                  1.3,
                  1.4,
                  1.5,
                  1.6,
                  1.7,
                  1.8,
                  1.9,
                  2,
                  2.1,
                  2.2,
                  2.3,
                  2.4,
                  2.5,
                  2.6,
                  2.7,
                  2.8,
                  2.9,
                  3,
                  3.1,
                  3.2,
                  3.3,
                  3.4,
                  3.5,
                  3.6,
                  3.7,
                  3.8,
                  3.9
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/lowSeverityType!predicate" =
        _js2n__-prdslib.const "LOW",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/mediumScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  4,
                  4.1,
                  4.2,
                  4.3,
                  4.4,
                  4.5,
                  4.6,
                  4.7,
                  4.8,
                  4.9,
                  5,
                  5.1,
                  5.2,
                  5.3,
                  5.4,
                  5.5,
                  5.6,
                  5.7,
                  5.8,
                  5.9,
                  6,
                  6.1,
                  6.2,
                  6.3,
                  6.4,
                  6.5,
                  6.6,
                  6.7,
                  6.8,
                  6.9
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/mediumSeverityType!predicate" =
        _js2n__-prdslib.const "MEDIUM",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedAttackComplexityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedAttackVectorType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "NETWORK",
                  "ADJACENT_NETWORK",
                  "LOCAL",
                  "PHYSICAL",
                  "NOT_DEFINED"
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedCiaType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "LOW", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedPrivilegesRequiredType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW", "NONE", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedScopeType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "UNCHANGED", "CHANGED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/modifiedUserInteractionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "REQUIRED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/noneScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 0,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/noneSeverityType!predicate" =
        _js2n__-prdslib.const "NONE",
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/privilegesRequiredType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW", "NONE" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/remediationLevelType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "OFFICIAL_FIX",
                  "TEMPORARY_FIX",
                  "WORKAROUND",
                  "UNAVAILABLE",
                  "NOT_DEFINED"
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/scopeType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "UNCHANGED", "CHANGED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/scoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  0,
                  0.1,
                  0.2,
                  0.3,
                  0.4,
                  0.5,
                  0.6,
                  0.7,
                  0.8,
                  0.9,
                  1,
                  1.1,
                  1.2,
                  1.3,
                  1.4,
                  1.5,
                  1.6,
                  1.7,
                  1.8,
                  1.9,
                  2,
                  2.1,
                  2.2,
                  2.3,
                  2.4,
                  2.5,
                  2.6,
                  2.7,
                  2.8,
                  2.9,
                  3,
                  3.1,
                  3.2,
                  3.3,
                  3.4,
                  3.5,
                  3.6,
                  3.7,
                  3.8,
                  3.9,
                  4,
                  4.1,
                  4.2,
                  4.3,
                  4.4,
                  4.5,
                  4.6,
                  4.7,
                  4.8,
                  4.9,
                  5,
                  5.1,
                  5.2,
                  5.3,
                  5.4,
                  5.5,
                  5.6,
                  5.7,
                  5.8,
                  5.9,
                  6,
                  6.1,
                  6.2,
                  6.3,
                  6.4,
                  6.5,
                  6.6,
                  6.7,
                  6.8,
                  6.9,
                  7,
                  7.1,
                  7.2,
                  7.3,
                  7.4,
                  7.5,
                  7.6,
                  7.7,
                  7.8,
                  7.9,
                  8,
                  8.1,
                  8.2,
                  8.3,
                  8.4,
                  8.5,
                  8.6,
                  8.7,
                  8.8,
                  8.9,
                  9,
                  9.1,
                  9.2,
                  9.3,
                  9.4,
                  9.5,
                  9.6,
                  9.7,
                  9.8,
                  9.9,
                  10
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/severityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NONE", "LOW", "MEDIUM", "HIGH", "CRITICAL" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV3_1/definitions/userInteractionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "REQUIRED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/attackComplexityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/attackRequirementsType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "PRESENT" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/attackVectorType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NETWORK", "ADJACENT", "LOCAL", "PHYSICAL" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/automatableType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NO", "YES", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/ciaRequirementType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "LOW", "MEDIUM", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/criticalScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [ 9, 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 9.7, 9.8, 9.9, 10 ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/criticalSeverityType!predicate" =
        _js2n__-prdslib.const "CRITICAL",
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/exploitMaturityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "UNREPORTED", "PROOF_OF_CONCEPT", "ATTACKED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/highScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  7,
                  7.1,
                  7.2,
                  7.3,
                  7.4,
                  7.5,
                  7.6,
                  7.7,
                  7.8,
                  7.9,
                  8,
                  8.1,
                  8.2,
                  8.3,
                  8.4,
                  8.5,
                  8.6,
                  8.7,
                  8.8,
                  8.9
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/highSeverityType!predicate" =
        _js2n__-prdslib.const "HIGH",
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/lowScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  0.1,
                  0.2,
                  0.3,
                  0.4,
                  0.5,
                  0.6,
                  0.7,
                  0.8,
                  0.9,
                  1,
                  1.1,
                  1.2,
                  1.3,
                  1.4,
                  1.5,
                  1.6,
                  1.7,
                  1.8,
                  1.9,
                  2,
                  2.1,
                  2.2,
                  2.3,
                  2.4,
                  2.5,
                  2.6,
                  2.7,
                  2.8,
                  2.9,
                  3,
                  3.1,
                  3.2,
                  3.3,
                  3.4,
                  3.5,
                  3.6,
                  3.7,
                  3.8,
                  3.9
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/lowSeverityType!predicate" =
        _js2n__-prdslib.const "LOW",
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/mediumScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  4,
                  4.1,
                  4.2,
                  4.3,
                  4.4,
                  4.5,
                  4.6,
                  4.7,
                  4.8,
                  4.9,
                  5,
                  5.1,
                  5.2,
                  5.3,
                  5.4,
                  5.5,
                  5.6,
                  5.7,
                  5.8,
                  5.9,
                  6,
                  6.1,
                  6.2,
                  6.3,
                  6.4,
                  6.5,
                  6.6,
                  6.7,
                  6.8,
                  6.9
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/mediumSeverityType!predicate" =
        _js2n__-prdslib.const "MEDIUM",
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedAttackComplexityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedAttackRequirementsType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "PRESENT", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedAttackVectorType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NETWORK", "ADJACENT", "LOCAL", "PHYSICAL", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedPrivilegesRequiredType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW", "NONE", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedSubCType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "LOW", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedSubIaType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NONE", "LOW", "HIGH", "SAFETY", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedUserInteractionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NONE", "PASSIVE", "ACTIVE", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/modifiedVulnCiaType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "LOW", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/noneScoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 0,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/noneSeverityType!predicate" =
        _js2n__-prdslib.const "NONE",
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/privilegesRequiredType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "HIGH", "LOW", "NONE" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/providerUrgencyType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "CLEAR", "GREEN", "AMBER", "RED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/recoveryType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "AUTOMATIC", "USER", "IRRECOVERABLE", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/safetyType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NEGLIGIBLE", "PRESENT", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/scoreType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.enum
                [
                  0,
                  0.1,
                  0.2,
                  0.3,
                  0.4,
                  0.5,
                  0.6,
                  0.7,
                  0.8,
                  0.9,
                  1,
                  1.1,
                  1.2,
                  1.3,
                  1.4,
                  1.5,
                  1.6,
                  1.7,
                  1.8,
                  1.9,
                  2,
                  2.1,
                  2.2,
                  2.3,
                  2.4,
                  2.5,
                  2.6,
                  2.7,
                  2.8,
                  2.9,
                  3,
                  3.1,
                  3.2,
                  3.3,
                  3.4,
                  3.5,
                  3.6,
                  3.7,
                  3.8,
                  3.9,
                  4,
                  4.1,
                  4.2,
                  4.3,
                  4.4,
                  4.5,
                  4.6,
                  4.7,
                  4.8,
                  4.9,
                  5,
                  5.1,
                  5.2,
                  5.3,
                  5.4,
                  5.5,
                  5.6,
                  5.7,
                  5.8,
                  5.9,
                  6,
                  6.1,
                  6.2,
                  6.3,
                  6.4,
                  6.5,
                  6.6,
                  6.7,
                  6.8,
                  6.9,
                  7,
                  7.1,
                  7.2,
                  7.3,
                  7.4,
                  7.5,
                  7.6,
                  7.7,
                  7.8,
                  7.9,
                  8,
                  8.1,
                  8.2,
                  8.3,
                  8.4,
                  8.5,
                  8.6,
                  8.7,
                  8.8,
                  8.9,
                  9,
                  9.1,
                  9.2,
                  9.3,
                  9.4,
                  9.5,
                  9.6,
                  9.7,
                  9.8,
                  9.9,
                  10
                ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/severityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NONE", "LOW", "MEDIUM", "HIGH", "CRITICAL" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/subCiaType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "LOW", "HIGH" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/userInteractionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "PASSIVE", "ACTIVE" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/valueDensityType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "DIFFUSE", "CONCENTRATED", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/vulnCiaType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "LOW", "HIGH" ]
            ],
      "_js2n__-:definitions/metrics/items/properties/cvssV4_0/definitions/vulnerabilityResponseEffortType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "LOW", "MODERATE", "HIGH", "NOT_DEFINED" ]
            ],
      "_js2n__-:definitions/orgId!predicate"
        | doc "A UUID for an organization participating in the CVE program. This UUID can be used to lookup the organization record in the user registry service."
        = _js2n__-refsenv."_js2n__-:definitions/uuidType!predicate",
      "_js2n__-:definitions/problemTypes!predicate"
        | doc "This is problem type information (e.g. CWE identifier). Must contain: At least one entry, can be text, OWASP, CWE, please note that while only one is required you can use more than one (or indeed all three) as long as they are correct). (CNA requirement: [PROBLEMTYPE])."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "descriptions" ],
                    _js2n__-prdslib.records.record
                      {
                        descriptions =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "description", "lang" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          cweId =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.maxLength
                                                    9,
                                                  _js2n__-prdslib.strings.minLength
                                                    5,
                                                  _js2n__-prdslib.strings.pattern
                                                    "^CWE-[1-9][0-9]*$"
                                                ],
                                          description =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.maxLength
                                                    4096,
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ],
                                          lang =
                                            _js2n__-refsenv."_js2n__-:definitions/language!predicate",
                                          references =
                                            _js2n__-refsenv."_js2n__-:definitions/references!predicate",
                                          type =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.maxLength
                                                    128,
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1,
                                _js2n__-prdslib.arrays.uniqueItems
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/product!predicate"
        | doc "Provides information about the set of products and services affected by this vulnerability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "product", "vendor" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "collectionURL", "packageName" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "versions" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "defaultStatus" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  collectionURL =
                    _js2n__-refsenv."_js2n__-:definitions/uriType!predicate",
                  cpes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 2048,
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.strings.pattern
                                  "([c][pP][eE]:/[AHOaho]?(:[A-Za-z0-9._\\-~%]*){0,6})|(cpe:2\\.3:[aho*\\-](:(((\\?*|\\*?)([a-zA-Z0-9\\-._]|(\\\\[\\\\*?!\"#$%&'()+,/:;<=>@\\[\\]\\^`{|}~]))+(\\?*|\\*?))|[*\\-])){5}(:(([a-zA-Z]{2,3}(-([a-zA-Z]{2}|[0-9]{3}))?)|[*\\-]))(:(((\\?*|\\*?)([a-zA-Z0-9\\-._]|(\\\\[\\\\*?!\"#$%&'()+,/:;<=>@\\[\\]\\^`{|}~]))+(\\?*|\\*?))|[*\\-])){4})"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  defaultStatus =
                    _js2n__-refsenv."_js2n__-:definitions/status!predicate",
                  modules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 4096,
                                _js2n__-prdslib.strings.minLength 1
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  packageName =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 2048,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  platforms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 1024
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  product =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 2048,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  programFiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 1024,
                                _js2n__-prdslib.strings.minLength 1
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  programRoutines =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "name" ],
                                _js2n__-prdslib.records.record
                                  {
                                    name =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.maxLength
                                              4096,
                                            _js2n__-prdslib.strings.minLength 1
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  repo =
                    _js2n__-refsenv."_js2n__-:definitions/uriType!predicate",
                  vendor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 512,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  versions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.maxProperties 2,
                                        _js2n__-prdslib.records.required
                                          [ "status", "version" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.maxProperties 3,
                                        _js2n__-prdslib.records.required
                                          [
                                            "status",
                                            "version",
                                            "versionType"
                                          ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [
                                            "lessThan",
                                            "status",
                                            "version",
                                            "versionType"
                                          ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [
                                            "lessThanOrEqual",
                                            "status",
                                            "version",
                                            "versionType"
                                          ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.records.record
                                  {
                                    changes =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "at", "status" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      at =
                                                        _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                                                      status =
                                                        _js2n__-refsenv."_js2n__-:definitions/status!predicate",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ]),
                                            _js2n__-prdslib.arrays.minItems 1,
                                            _js2n__-prdslib.arrays.uniqueItems
                                          ],
                                    lessThan =
                                      _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                                    lessThanOrEqual =
                                      _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                                    status =
                                      _js2n__-refsenv."_js2n__-:definitions/status!predicate",
                                    version =
                                      _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                                    versionType =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.maxLength
                                              128,
                                            _js2n__-prdslib.strings.minLength 1
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/providerMetadata!predicate"
        | doc "Details related to the information container provider (CNA or ADP)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "orgId" ],
              _js2n__-prdslib.records.record
                {
                  dateUpdated =
                    _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                  orgId =
                    _js2n__-refsenv."_js2n__-:definitions/orgId!predicate",
                  shortName =
                    _js2n__-refsenv."_js2n__-:definitions/shortName!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/reference!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 512,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/tagExtension!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "broken-link",
                                        "customer-entitlement",
                                        "exploit",
                                        "government-resource",
                                        "issue-tracking",
                                        "mailing-list",
                                        "mitigation",
                                        "not-applicable",
                                        "patch",
                                        "permissions-required",
                                        "media-coverage",
                                        "product",
                                        "related",
                                        "release-notes",
                                        "signature",
                                        "technical-description",
                                        "third-party-advisory",
                                        "vendor-advisory",
                                        "vdb-entry"
                                      ]
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  url =
                    _js2n__-refsenv."_js2n__-:definitions/uriType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/references!predicate"
        | doc "This is reference data in the form of URLs or file objects (uuencoded and embedded within the JSON file, exact format to be decided, e.g. we may require a compressed format so the objects require unpacking before they are \"dangerous\")."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/reference!predicate",
              _js2n__-prdslib.arrays.maxItems 512,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/shortName!predicate"
        | doc "A 2-32 character name that can be used to complement an organization's UUID."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 32,
              _js2n__-prdslib.strings.minLength 2
            ],
      "_js2n__-:definitions/solutions!predicate"
        | doc "Information about solutions or remediations available for this vulnerability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/description!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/source!predicate"
        | doc m%"
          This is the source information (who discovered it, who researched it, etc.) and optionally a chain of CNA information (e.g. the originating CNA and subsequent parent CNAs who have processed it before it arrives at the MITRE root).
           Must contain: IF this is in the root level it MUST contain a CNA_chain entry, IF this source entry is NOT in the root (e.g. it is part of a vendor statement) then it must contain at least one type of data entry.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/status!predicate"
        | doc "The vulnerability status of a given version or range of versions of a product. The statuses 'affected' and 'unaffected' indicate that the version is affected or unaffected by the vulnerability. The status 'unknown' indicates that it is unknown or unspecified whether the given version is affected. There can be many reasons for an 'unknown' status, including that an investigation has not been undertaken or that a vendor has not disclosed the status."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "affected", "unaffected", "unknown" ]
            ],
      "_js2n__-:definitions/tagExtension!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 128,
              _js2n__-prdslib.strings.minLength 2,
              _js2n__-prdslib.strings.pattern "^x_.*$"
            ],
      "_js2n__-:definitions/taxonomyMappings!predicate"
        | doc "List of taxonomy items related to the vulnerability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required
                      [ "taxonomyName", "taxonomyRelations" ],
                    _js2n__-prdslib.records.record
                      {
                        taxonomyName =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 128,
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        taxonomyRelations =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [
                                          "relationshipName",
                                          "relationshipValue",
                                          "taxonomyId"
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          relationshipName =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.maxLength
                                                    128,
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ],
                                          relationshipValue =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.maxLength
                                                    2048,
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ],
                                          taxonomyId =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.maxLength
                                                    2048,
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1,
                                _js2n__-prdslib.arrays.uniqueItems
                              ],
                        taxonomyVersion =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 128,
                                _js2n__-prdslib.strings.minLength 1
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/timeline!predicate"
        | doc "This is timeline information for significant events about this vulnerability or changes to the CVE Record."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required
                      [ "lang", "time", "value" ],
                    _js2n__-prdslib.records.record
                      {
                        lang =
                          _js2n__-refsenv."_js2n__-:definitions/language!predicate",
                        time =
                          _js2n__-refsenv."_js2n__-:definitions/timestamp!predicate",
                        value =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 4096,
                                _js2n__-prdslib.strings.minLength 1
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/timestamp!predicate"
        | doc "Date/time format based on RFC3339 and ISO ISO8601, with an optional timezone in the format 'yyyy-MM-ddTHH:mm:ss[+-]ZH:ZM'. If timezone offset is not given, GMT (+00:00) is assumed."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(((2000|2400|2800|(19|2[0-9](0[48]|[2468][048]|[13579][26])))-02-29)|(((19|2[0-9])[0-9]{2})-02-(0[1-9]|1[0-9]|2[0-8]))|(((19|2[0-9])[0-9]{2})-(0[13578]|10|12)-(0[1-9]|[12][0-9]|3[01]))|(((19|2[0-9])[0-9]{2})-(0[469]|11)-(0[1-9]|[12][0-9]|30)))T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})?$"
            ],
      "_js2n__-:definitions/uriType!predicate"
        | doc "A universal resource identifier (URI), according to [RFC 3986](https://tools.ietf.org/html/rfc3986)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 2048,
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/userId!predicate"
        | doc "A UUID for a user participating in the CVE program. This UUID can be used to lookup the user record in the user registry service."
        = _js2n__-refsenv."_js2n__-:definitions/uuidType!predicate",
      "_js2n__-:definitions/uuidType!predicate"
        | doc "A version 4 (random) universally unique identifier (UUID) as defined by [RFC 4122](https://tools.ietf.org/html/rfc4122#section-4.1.3)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-4[0-9A-Fa-f]{3}-[89ABab][0-9A-Fa-f]{3}-[0-9A-Fa-f]{12}$"
            ],
      "_js2n__-:definitions/version!predicate"
        | doc "A single version of a product, as expressed in its own version numbering scheme."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 1024,
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/workarounds!predicate"
        | doc "Workarounds and mitigations for this vulnerability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/description!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.oneOf
        [
          _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "containers", "cveMetadata", "dataType", "dataVersion" ],
              _js2n__-prdslib.records.record
                {
                  containers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "cna" ],
                          _js2n__-prdslib.records.record
                            {
                              adp =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/adpContainer!predicate",
                                      _js2n__-prdslib.arrays.minItems 1,
                                      _js2n__-prdslib.arrays.uniqueItems
                                    ],
                              cna =
                                _js2n__-refsenv."_js2n__-:definitions/cnaPublishedContainer!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  cveMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/cveMetadataPublished!predicate",
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/dataType!predicate",
                  dataVersion =
                    _js2n__-refsenv."_js2n__-:definitions/dataVersion!predicate",
                } {} false _js2n__-prdslib.never
            ],
          _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "containers", "cveMetadata", "dataType", "dataVersion" ],
              _js2n__-prdslib.records.record
                {
                  containers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "cna" ],
                          _js2n__-prdslib.records.record
                            {
                              cna =
                                _js2n__-refsenv."_js2n__-:definitions/cnaRejectedContainer!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  cveMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/cveMetadataRejected!predicate",
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/dataType!predicate",
                  dataVersion =
                    _js2n__-refsenv."_js2n__-:definitions/dataVersion!predicate",
                } {} false _js2n__-prdslib.never
            ]
        ])