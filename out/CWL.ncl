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
      "_js2n__-:definitions/CWLDocumentMetadata!predicate"
        | doc "Metadata for a CWL document"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "$namespaces" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                _js2n__-prdslib.isType '"String",
                            } true _js2n__-prdslib.always
                        ],
                  "$schemas" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                }
                {
                  "^\\w+:.*$" = _js2n__-prdslib.isType 'Record,
                  "^\\w+:\\/\\/.*" = _js2n__-prdslib.isType 'Record,
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/CWLFile!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/Workflow!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/CommandLineTool!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/ExpressionTool!predicate"
                    ],
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/CWLDocumentMetadata!predicate"
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  "$namespaces" = _js2n__-prdslib.always,
                  "$schemas" = _js2n__-prdslib.always,
                  arguments = _js2n__-prdslib.always,
                  baseCommand = _js2n__-prdslib.always,
                  class = _js2n__-prdslib.always,
                  cwlVersion = _js2n__-prdslib.always,
                  "doc" = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  hints = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.always,
                  inputs = _js2n__-prdslib.always,
                  intent = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  outputs = _js2n__-prdslib.always,
                  permanentFailCodes = _js2n__-prdslib.always,
                  requirements = _js2n__-prdslib.always,
                  stderr = _js2n__-prdslib.always,
                  stdin = _js2n__-prdslib.always,
                  stdout = _js2n__-prdslib.always,
                  steps = _js2n__-prdslib.always,
                  successCodes = _js2n__-prdslib.always,
                  temporaryFailCodes = _js2n__-prdslib.always,
                }
                {
                  "^\\w+:.*$" = _js2n__-prdslib.isType 'Record,
                  "^\\w+:\\/\\/.*" = _js2n__-prdslib.isType 'Record,
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CWLGraph!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "$graph" ],
              _js2n__-prdslib.records.record
                {
                  "$graph" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/CWLFile!predicate"
                        ],
                  cwlVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "draft-2",
                              "draft-3",
                              "draft-3.dev1",
                              "draft-3.dev2",
                              "draft-3.dev3",
                              "draft-3.dev4",
                              "draft-3.dev5",
                              "draft-4.dev1",
                              "draft-4.dev2",
                              "draft-4.dev3",
                              "v1.0",
                              "v1.0.dev4",
                              "v1.1",
                              "v1.1.0-dev1",
                              "v1.2",
                              "v1.2.0-dev1",
                              "v1.2.0-dev2",
                              "v1.2.0-dev3",
                              "v1.2.0-dev4",
                              "v1.2.0-dev5"
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/CWLGraphOrFile!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/CWLGraph!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CWLFile!predicate"
                      ],
                    _js2n__-refsenv."_js2n__-:definitions/CWLDocumentMetadata!predicate"
                  ],
                _js2n__-prdslib.records.record
                  {
                    "$graph" = _js2n__-prdslib.always,
                    "$namespaces" = _js2n__-prdslib.always,
                    "$schemas" = _js2n__-prdslib.always,
                    arguments = _js2n__-prdslib.always,
                    baseCommand = _js2n__-prdslib.always,
                    class = _js2n__-prdslib.always,
                    cwlVersion = _js2n__-prdslib.always,
                    "doc" = _js2n__-prdslib.always,
                    expression = _js2n__-prdslib.always,
                    hints = _js2n__-prdslib.always,
                    id = _js2n__-prdslib.always,
                    inputs = _js2n__-prdslib.always,
                    intent = _js2n__-prdslib.always,
                    label = _js2n__-prdslib.always,
                    outputs = _js2n__-prdslib.always,
                    permanentFailCodes = _js2n__-prdslib.always,
                    requirements = _js2n__-prdslib.always,
                    stderr = _js2n__-prdslib.always,
                    stdin = _js2n__-prdslib.always,
                    stdout = _js2n__-prdslib.always,
                    steps = _js2n__-prdslib.always,
                    successCodes = _js2n__-prdslib.always,
                    temporaryFailCodes = _js2n__-prdslib.always,
                  }
                  {
                    "^\\w+:.*$" = _js2n__-prdslib.isType 'Record,
                    "^\\w+:\\/\\/.*" = _js2n__-prdslib.isType 'Record,
                  } false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/CWLImportManual!predicate"
        | doc "Represents an '$import' directive that should point toward another compatible CWL file to import where specified. The contents of the imported file should be relevant contextually where it is being imported"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "$import" ],
              _js2n__-prdslib.records.record
                { "$import" = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CWLIncludeManual!predicate"
        | doc "Represents an '$include' directive that should point toward another compatible CWL file to import where specified. The contents of the imported file should be relevant contextually where it is being imported"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "$include" ],
              _js2n__-prdslib.records.record
                { "$include" = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandInputArraySchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandInputArraySchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "items", "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  inputBinding =
                    _js2n__-refsenv."_js2n__-:definitions/CommandLineBinding!predicate",
                  items =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "array"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandInputEnumSchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandInputEnumSchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "symbols", "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  inputBinding =
                    _js2n__-refsenv."_js2n__-:definitions/CommandLineBinding!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  symbols =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "enum"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandInputParameter!predicate"
        | doc "An input parameter for a CommandLineTool."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "default" = _js2n__-prdslib.always,
                  "doc" =
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
                  format =
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
                  id = _js2n__-prdslib.isType '"String",
                  inputBinding =
                    _js2n__-refsenv."_js2n__-:definitions/CommandLineBinding!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  loadContents = _js2n__-prdslib.isType '"Bool",
                  loadListing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "deep_listing", "no_listing", "shallow_listing" ]
                        ],
                  secondaryFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                            ]
                        ],
                  streamable = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandInputRecordField!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandInputRecordField"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      "doc" =
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
                      format =
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
                      inputBinding =
                        _js2n__-refsenv."_js2n__-:definitions/CommandLineBinding!predicate",
                      label = _js2n__-prdslib.isType '"String",
                      loadContents = _js2n__-prdslib.isType '"Bool",
                      loadListing =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "deep_listing",
                                  "no_listing",
                                  "shallow_listing"
                                ]
                            ],
                      name = _js2n__-prdslib.isType '"String",
                      secondaryFiles =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                                ]
                            ],
                      streamable = _js2n__-prdslib.isType '"Bool",
                      type =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ])
                                ],
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                                  _js2n__-prdslib.isType '"String"
                                ])
                          ],
                        _js2n__-prdslib.isType '"String"
                      ])
                ]
            ],
      "_js2n__-:definitions/CommandInputRecordFieldMap!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandInputRecordField"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    {
                      "doc" =
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
                      format =
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
                      inputBinding =
                        _js2n__-refsenv."_js2n__-:definitions/CommandLineBinding!predicate",
                      label = _js2n__-prdslib.isType '"String",
                      loadContents = _js2n__-prdslib.isType '"Bool",
                      loadListing =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "deep_listing",
                                  "no_listing",
                                  "shallow_listing"
                                ]
                            ],
                      name = _js2n__-prdslib.isType '"String",
                      secondaryFiles =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                                ]
                            ],
                      streamable = _js2n__-prdslib.isType '"Bool",
                      type =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ])
                                ],
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                                  _js2n__-prdslib.isType '"String"
                                ])
                          ],
                        _js2n__-prdslib.isType '"String"
                      ])
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/CommandInputRecordSchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandInputRecordSchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  fields =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordField!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordFieldMap!predicate",
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  inputBinding =
                    _js2n__-refsenv."_js2n__-:definitions/CommandLineBinding!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "record"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandLineBinding!predicate"
        | doc m%"
          
          When listed under `inputBinding` in the input schema, the term
          "value" refers to the corresponding value in the input object.  For
          binding objects listed in `CommandLineTool.arguments`, the term "value"
          refers to the effective value after evaluating `valueFrom`.
          
          The binding behavior when building the command line depends on the data
          type of the value.  If there is a mismatch between the type described by
          the input schema and the effective value, such as resulting from an
          expression evaluation, an implementation must use the data type of the
          effective value.
          
            - **string**: Add `prefix` and the string to the command line.
          
            - **number**: Add `prefix` and decimal representation to command line.
          
            - **boolean**: If true, add `prefix` to the command line.  If false, add
                nothing.
          
            - **File**: Add `prefix` and the value of
              [`File.path`](#File) to the command line.
          
            - **Directory**: Add `prefix` and the value of
              [`Directory.path`](#Directory) to the command line.
          
            - **array**: If `itemSeparator` is specified, add `prefix` and the join
                the array into a single string with `itemSeparator` separating the
                items.  Otherwise, first add `prefix`, then recursively process
                individual elements.
                If the array is empty, it does not add anything to command line.
          
            - **object**: Add `prefix` only, and recursively add object fields for
                which `inputBinding` is specified.
          
            - **null**: Add nothing.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  itemSeparator = _js2n__-prdslib.isType '"String",
                  loadContents = _js2n__-prdslib.isType '"Bool",
                  position =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  prefix = _js2n__-prdslib.isType '"String",
                  separate = _js2n__-prdslib.isType '"Bool",
                  shellQuote = _js2n__-prdslib.isType '"Bool",
                  valueFrom = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandLineTool!predicate"
        | doc "This defines the schema of the CWL Command Line Tool Description document."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "inputs", "outputs" ],
              _js2n__-prdslib.records.record
                {
                  arguments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/CommandLineBinding!predicate",
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  baseCommand =
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
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "CommandLineTool"
                        ],
                  cwlVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "draft-2",
                              "draft-3",
                              "draft-3.dev1",
                              "draft-3.dev2",
                              "draft-3.dev3",
                              "draft-3.dev4",
                              "draft-3.dev5",
                              "draft-4.dev1",
                              "draft-4.dev2",
                              "draft-4.dev3",
                              "v1.0",
                              "v1.0.dev4",
                              "v1.1",
                              "v1.1.0-dev1",
                              "v1.2",
                              "v1.2.0-dev1",
                              "v1.2.0-dev2",
                              "v1.2.0-dev3",
                              "v1.2.0-dev4",
                              "v1.2.0-dev5"
                            ]
                        ],
                  "doc" =
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
                  hints =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/DockerRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/WorkReuse!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/NetworkAccess!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimit!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirement!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  DockerRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/DockerRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  EnvVarRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InitialWorkDirRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InlineJavascriptRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InplaceUpdateRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  LoadListingRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  MultipleInputFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  NetworkAccess =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/NetworkAccessMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ResourceRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ResourceRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ScatterFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SchemaDefRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ShellCommandRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SoftwareRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  StepInputExpressionRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SubworkflowFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ToolTimeLimit =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimitMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  WorkReuse =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkReuseMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  inputs =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CommandInputParameter!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/CommandInputParameter!predicate",
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate",
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ])
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputParameter!predicate"
                                                  ])
                                            ]
                                        ],
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  intent =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  outputs =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CommandOutputParameter!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/CommandOutputParameter!predicate",
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ])
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-refsenv."_js2n__-:definitions/CommandOutputParameter!predicate"
                                                  ])
                                            ]
                                        ],
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  permanentFailCodes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"Number")
                        ],
                  requirements =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/DockerRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/WorkReuse!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/NetworkAccess!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimit!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirement!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  DockerRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/DockerRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  EnvVarRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InitialWorkDirRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InlineJavascriptRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InplaceUpdateRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  LoadListingRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  MultipleInputFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  NetworkAccess =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/NetworkAccessMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ResourceRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ResourceRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ScatterFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SchemaDefRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ShellCommandRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SoftwareRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  StepInputExpressionRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SubworkflowFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ToolTimeLimit =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimitMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  WorkReuse =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkReuseMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  stderr = _js2n__-prdslib.isType '"String",
                  stdin = _js2n__-prdslib.isType '"String",
                  stdout = _js2n__-prdslib.isType '"String",
                  successCodes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"Number")
                        ],
                  temporaryFailCodes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"Number")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/CommandOutputArraySchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandOutputArraySchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "items", "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  items =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "array"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandOutputBinding!predicate"
        | doc m%"
          Describes how to generate an output parameter based on the files produced
          by a CommandLineTool.
          
          The output parameter value is generated by applying these operations in the
          following order:
          
            - glob
            - loadContents
            - outputEval
            - secondaryFiles
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  glob =
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
                  loadContents = _js2n__-prdslib.isType '"Bool",
                  loadListing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "deep_listing", "no_listing", "shallow_listing" ]
                        ],
                  outputEval = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandOutputEnumSchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandOutputEnumSchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "symbols", "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  symbols =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "enum"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandOutputParameter!predicate"
        | doc "An output parameter for a CommandLineTool."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  format = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  outputBinding =
                    _js2n__-refsenv."_js2n__-:definitions/CommandOutputBinding!predicate",
                  secondaryFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                            ]
                        ],
                  streamable = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommandOutputRecordField!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandOutputRecordField"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      "doc" =
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
                      format = _js2n__-prdslib.isType '"String",
                      label = _js2n__-prdslib.isType '"String",
                      name = _js2n__-prdslib.isType '"String",
                      outputBinding =
                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputBinding!predicate",
                      secondaryFiles =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                                ]
                            ],
                      streamable = _js2n__-prdslib.isType '"Bool",
                      type =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ])
                                ],
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                                  _js2n__-prdslib.isType '"String"
                                ])
                          ],
                        _js2n__-prdslib.isType '"String"
                      ])
                ]
            ],
      "_js2n__-:definitions/CommandOutputRecordFieldMap!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandOutputRecordField"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    {
                      "doc" =
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
                      format = _js2n__-prdslib.isType '"String",
                      label = _js2n__-prdslib.isType '"String",
                      name = _js2n__-prdslib.isType '"String",
                      outputBinding =
                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputBinding!predicate",
                      secondaryFiles =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                                ]
                            ],
                      streamable = _js2n__-prdslib.isType '"Bool",
                      type =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ])
                                ],
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/CommandOutputArraySchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/CommandOutputEnumSchema!predicate",
                                  _js2n__-prdslib.isType '"String"
                                ])
                          ],
                        _js2n__-prdslib.isType '"String"
                      ])
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/CommandOutputRecordSchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#CommandOutputRecordSchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  fields =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordField!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/CommandOutputRecordFieldMap!predicate",
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "record"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Directory!predicate"
        | doc m%"
          Represents a directory to present to a command line tool.
          
          Directories are represented as objects with `class` of `Directory`.  Directory objects have
          a number of properties that provide metadata about the directory.
          
          The `location` property of a Directory is a IRI that uniquely identifies
          the directory.  Implementations must support the file:// IRI scheme and may
          support other schemes such as http://.  Alternately to `location`,
          implementations must also accept the `path` property on Directory, which
          must be a filesystem path available on the same host as the CWL runner (for
          inputs) or the runtime environment of a command line tool execution (for
          command line tool outputs).
          
          A Directory object may have a `listing` field.  This is a list of File and
          Directory objects that are contained in the Directory.  For each entry in
          `listing`, the `basename` property defines the name of the File or
          Subdirectory when staged to disk.  If `listing` is not provided, the
          implementation must have some way of fetching the Directory listing at
          runtime based on the `location` field.
          
          If a Directory does not have `location`, it is a Directory literal.  A
          Directory literal must provide `listing`.  Directory literals must be
          created on disk at runtime as needed.
          
          The resources in a Directory literal do not need to have any implied
          relationship in their `location`.  For example, a Directory listing may
          contain two files located on different hosts.  It is the responsibility of
          the runtime to ensure that those files are staged to disk appropriately.
          Secondary files associated with files in `listing` must also be staged to
          the same Directory.
          
          When executing a CommandLineTool, Directories must be recursively staged
          first and have local values of `path` assigned.
          
          Directory objects in CommandLineTool output must provide either a
          `location` IRI or a `path` property in the context of the tool execution
          runtime (local to the compute node, or within the executing container).
          
          An ExpressionTool may forward file references from input to output by using
          the same value for `location`.
          
          Name conflicts (the same `basename` appearing multiple times in `listing`
          or in any entry in `secondaryFiles` in the listing) is a fatal error.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  basename = _js2n__-prdslib.isType '"String",
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "Directory"
                        ],
                  listing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Directory!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/File!predicate"
                              ])
                        ],
                  location = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Dirent!predicate"
        | doc m%"
          Define a file or subdirectory that must be staged to a particular
          place prior to executing the command line tool.  May be the result
          of executing an expression, such as building a configuration file
          from a template.
          
          Usually files are staged within the [designated output directory](#Runtime_environment).
          However, under certain circumstances, files may be staged at
          arbitrary locations, see discussion for `entryname`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "entry" ],
              _js2n__-prdslib.records.record
                {
                  entry = _js2n__-prdslib.isType '"String",
                  entryname = _js2n__-prdslib.isType '"String",
                  writable = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerRequirement!predicate"
        | doc m%"
          Indicates that a workflow component should be run in a
          [Docker](https://docker.com) or Docker-compatible (such as
          [Singularity](https://www.sylabs.io/) and [udocker](https://github.com/indigo-dc/udocker)) container environment and
          specifies how to fetch or build the image.
          
          If a CommandLineTool lists `DockerRequirement` under
          `hints` (or `requirements`), it may (or must) be run in the specified Docker
          container.
          
          The platform must first acquire or install the correct Docker image as
          specified by `dockerPull`, `dockerImport`, `dockerLoad` or `dockerFile`.
          
          The platform must execute the tool in the container using `docker run` with
          the appropriate Docker image and tool command line.
          
          The workflow platform may provide input files and the designated output
          directory through the use of volume bind mounts.  The platform should rewrite
          file paths in the input object to correspond to the Docker bind mounted
          locations. That is, the platform should rewrite values in the parameter context
          such as `runtime.outdir`, `runtime.tmpdir` and others to be valid paths
          within the container. The platform must ensure that `runtime.outdir` and
          `runtime.tmpdir` are distinct directories.
          
          When running a tool contained in Docker, the workflow platform must not
          assume anything about the contents of the Docker container, such as the
          presence or absence of specific software, except to assume that the
          generated command line represents a valid command within the runtime
          environment of the container.
          
          A container image may specify an
          [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)
          and/or
          [CMD](https://docs.docker.com/engine/reference/builder/#cmd).
          Command line arguments will be appended after all elements of
          ENTRYPOINT, and will override all elements specified using CMD (in
          other words, CMD is only used when the CommandLineTool definition
          produces an empty command line).
          
          Use of implicit ENTRYPOINT or CMD are discouraged due to reproducibility
          concerns of the implicit hidden execution point (For further discussion, see
          [https://doi.org/10.12688/f1000research.15140.1](https://doi.org/10.12688/f1000research.15140.1)). Portable
          CommandLineTool wrappers in which use of a container is optional must not rely on ENTRYPOINT or CMD.
          CommandLineTools which do rely on ENTRYPOINT or CMD must list `DockerRequirement` in the
          `requirements` section.
          
          ## Interaction with other requirements
          
          If [EnvVarRequirement](#EnvVarRequirement) is specified alongside a
          DockerRequirement, the environment variables must be provided to Docker
          using `--env` or `--env-file` and interact with the container's preexisting
          environment as defined by Docker.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "DockerRequirement"
                        ],
                  dockerFile = _js2n__-prdslib.isType '"String",
                  dockerImageId = _js2n__-prdslib.isType '"String",
                  dockerImport = _js2n__-prdslib.isType '"String",
                  dockerLoad = _js2n__-prdslib.isType '"String",
                  dockerOutputDirectory = _js2n__-prdslib.isType '"String",
                  dockerPull = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerRequirementMap!predicate"
        | doc m%"
          Indicates that a workflow component should be run in a
          [Docker](https://docker.com) or Docker-compatible (such as
          [Singularity](https://www.sylabs.io/) and [udocker](https://github.com/indigo-dc/udocker)) container environment and
          specifies how to fetch or build the image.
          
          If a CommandLineTool lists `DockerRequirement` under
          `hints` (or `requirements`), it may (or must) be run in the specified Docker
          container.
          
          The platform must first acquire or install the correct Docker image as
          specified by `dockerPull`, `dockerImport`, `dockerLoad` or `dockerFile`.
          
          The platform must execute the tool in the container using `docker run` with
          the appropriate Docker image and tool command line.
          
          The workflow platform may provide input files and the designated output
          directory through the use of volume bind mounts.  The platform should rewrite
          file paths in the input object to correspond to the Docker bind mounted
          locations. That is, the platform should rewrite values in the parameter context
          such as `runtime.outdir`, `runtime.tmpdir` and others to be valid paths
          within the container. The platform must ensure that `runtime.outdir` and
          `runtime.tmpdir` are distinct directories.
          
          When running a tool contained in Docker, the workflow platform must not
          assume anything about the contents of the Docker container, such as the
          presence or absence of specific software, except to assume that the
          generated command line represents a valid command within the runtime
          environment of the container.
          
          A container image may specify an
          [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)
          and/or
          [CMD](https://docs.docker.com/engine/reference/builder/#cmd).
          Command line arguments will be appended after all elements of
          ENTRYPOINT, and will override all elements specified using CMD (in
          other words, CMD is only used when the CommandLineTool definition
          produces an empty command line).
          
          Use of implicit ENTRYPOINT or CMD are discouraged due to reproducibility
          concerns of the implicit hidden execution point (For further discussion, see
          [https://doi.org/10.12688/f1000research.15140.1](https://doi.org/10.12688/f1000research.15140.1)). Portable
          CommandLineTool wrappers in which use of a container is optional must not rely on ENTRYPOINT or CMD.
          CommandLineTools which do rely on ENTRYPOINT or CMD must list `DockerRequirement` in the
          `requirements` section.
          
          ## Interaction with other requirements
          
          If [EnvVarRequirement](#EnvVarRequirement) is specified alongside a
          DockerRequirement, the environment variables must be provided to Docker
          using `--env` or `--env-file` and interact with the container's preexisting
          environment as defined by Docker.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dockerFile = _js2n__-prdslib.isType '"String",
                  dockerImageId = _js2n__-prdslib.isType '"String",
                  dockerImport = _js2n__-prdslib.isType '"String",
                  dockerLoad = _js2n__-prdslib.isType '"String",
                  dockerOutputDirectory = _js2n__-prdslib.isType '"String",
                  dockerPull = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/EnvVarRequirement!predicate"
        | doc m%"
          Define a list of environment variables which will be set in the
          execution environment of the tool.  See `EnvironmentDef` for details.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "envDef" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "EnvVarRequirement"
                        ],
                  envDef =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/EnvironmentDef!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.records.record {}
                            {
                              "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                _js2n__-prdslib.isType '"String",
                            } true _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/EnvVarRequirementMap!predicate"
        | doc m%"
          Define a list of environment variables which will be set in the
          execution environment of the tool.  See `EnvironmentDef` for details.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "envDef" ],
              _js2n__-prdslib.records.record
                {
                  envDef =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/EnvironmentDef!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.records.record {}
                            {
                              "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                _js2n__-prdslib.isType '"String",
                            } true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/EnvironmentDef!predicate"
        | doc m%"
          Define an environment variable that will be set in the runtime environment
          by the workflow platform when executing the command line tool.  May be the
          result of executing an expression, such as getting a parameter from input.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "envName", "envValue" ],
              _js2n__-prdslib.records.record
                {
                  envName = _js2n__-prdslib.isType '"String",
                  envValue = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ExpressionTool!predicate"
        | doc m%"
          An ExpressionTool is a type of Process object that can be run by itself
          or as a Workflow step. It executes a pure Javascript expression that has
          access to the same input parameters as a workflow. It is meant to be used
          sparingly as a way to isolate complex Javascript expressions that need to
          operate on input data and produce some result; perhaps just a
          rearrangement of the inputs. No Docker software container is required
          or allowed.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "class", "expression", "inputs", "outputs" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "ExpressionTool"
                        ],
                  cwlVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "draft-2",
                              "draft-3",
                              "draft-3.dev1",
                              "draft-3.dev2",
                              "draft-3.dev3",
                              "draft-3.dev4",
                              "draft-3.dev5",
                              "draft-4.dev1",
                              "draft-4.dev2",
                              "draft-4.dev3",
                              "v1.0",
                              "v1.0.dev4",
                              "v1.1",
                              "v1.1.0-dev1",
                              "v1.2",
                              "v1.2.0-dev1",
                              "v1.2.0-dev2",
                              "v1.2.0-dev3",
                              "v1.2.0-dev4",
                              "v1.2.0-dev5"
                            ]
                        ],
                  "doc" =
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
                  expression = _js2n__-prdslib.isType '"String",
                  hints =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/DockerRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/WorkReuse!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/NetworkAccess!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimit!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirement!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  DockerRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/DockerRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  EnvVarRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InitialWorkDirRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InlineJavascriptRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InplaceUpdateRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  LoadListingRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  MultipleInputFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  NetworkAccess =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/NetworkAccessMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ResourceRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ResourceRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ScatterFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SchemaDefRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ShellCommandRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SoftwareRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  StepInputExpressionRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SubworkflowFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ToolTimeLimit =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimitMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  WorkReuse =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkReuseMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  inputs =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/WorkflowInputParameter!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkflowInputParameter!predicate",
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ])
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-refsenv."_js2n__-:definitions/WorkflowInputParameter!predicate"
                                                  ])
                                            ]
                                        ],
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  intent =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  outputs =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ExpressionToolOutputParameter!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ExpressionToolOutputParameter!predicate",
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ])
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-refsenv."_js2n__-:definitions/ExpressionToolOutputParameter!predicate"
                                                  ])
                                            ]
                                        ],
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  requirements =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/DockerRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/WorkReuse!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/NetworkAccess!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimit!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirement!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  DockerRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/DockerRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  EnvVarRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InitialWorkDirRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InlineJavascriptRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InplaceUpdateRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  LoadListingRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  MultipleInputFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  NetworkAccess =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/NetworkAccessMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ResourceRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ResourceRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ScatterFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SchemaDefRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ShellCommandRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SoftwareRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  StepInputExpressionRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SubworkflowFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ToolTimeLimit =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimitMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  WorkReuse =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkReuseMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ExpressionToolOutputParameter!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#ExpressionToolOutputParameter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  format = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  secondaryFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                            ]
                        ],
                  streamable = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/File!predicate"
        | doc m%"
          Represents a file (or group of files when `secondaryFiles` is provided) that
          will be accessible by tools using standard POSIX file system call API such as
          open(2) and read(2).
          
          Files are represented as objects with `class` of `File`.  File objects have
          a number of properties that provide metadata about the file.
          
          The `location` property of a File is a IRI that uniquely identifies the
          file.  Implementations must support the `file://` IRI scheme and may support
          other schemes such as `http://` and `https://`.  The value of `location` may also be a
          relative reference, in which case it must be resolved relative to the IRI
          of the document it appears in.  Alternately to `location`, implementations
          must also accept the `path` property on File, which must be a filesystem
          path available on the same host as the CWL runner (for inputs) or the
          runtime environment of a command line tool execution (for command line tool
          outputs).
          
          If no `location` or `path` is specified, a file object must specify
          `contents` with the UTF-8 text content of the file.  This is a "file
          literal".  File literals do not correspond to external resources, but are
          created on disk with `contents` with when needed for executing a tool.
          Where appropriate, expressions can return file literals to define new files
          on a runtime.  The maximum size of `contents` is 64 kilobytes.
          
          The `basename` property defines the filename on disk where the file is
          staged.  This may differ from the resource name.  If not provided,
          `basename` must be computed from the last path part of `location` and made
          available to expressions.
          
          The `secondaryFiles` property is a list of File or Directory objects that
          must be staged in the same directory as the primary file.  It is an error
          for file names to be duplicated in `secondaryFiles`.
          
          The `size` property is the size in bytes of the File.  It must be computed
          from the resource and made available to expressions.  The `checksum` field
          contains a cryptographic hash of the file content for use it verifying file
          contents.  Implementations may, at user option, enable or disable
          computation of the `checksum` field for performance or other reasons.
          However, the ability to compute output checksums is required to pass the
          CWL conformance test suite.
          
          When executing a CommandLineTool, the files and secondary files may be
          staged to an arbitrary directory, but must use the value of `basename` for
          the filename.  The `path` property must be file path in the context of the
          tool execution runtime (local to the compute node, or within the executing
          container).  All computed properties should be available to expressions.
          File literals also must be staged and `path` must be set.
          
          When collecting CommandLineTool outputs, `glob` matching returns file paths
          (with the `path` property) and the derived properties. This can all be
          modified by `outputEval`.  Alternately, if the file `cwl.output.json` is
          present in the output, `outputBinding` is ignored.
          
          File objects in the output must provide either a `location` IRI or a `path`
          property in the context of the tool execution runtime (local to the compute
          node, or within the executing container).
          
          When evaluating an ExpressionTool, file objects must be referenced via
          `location` (the expression tool does not have access to files on disk so
          `path` is meaningless) or as file literals.  It is legal to return a file
          object with an existing `location` but a different `basename`.  The
          `loadContents` field of ExpressionTool inputs behaves the same as on
          CommandLineTool inputs, however it is not meaningful on the outputs.
          
          An ExpressionTool may forward file references from input to output by using
          the same value for `location`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  basename = _js2n__-prdslib.isType '"String",
                  checksum = _js2n__-prdslib.isType '"String",
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "File"
                        ],
                  contents = _js2n__-prdslib.isType '"String",
                  dirname = _js2n__-prdslib.isType '"String",
                  format = _js2n__-prdslib.isType '"String",
                  location = _js2n__-prdslib.isType '"String",
                  nameext = _js2n__-prdslib.isType '"String",
                  nameroot = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  secondaryFiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Directory!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/File!predicate"
                              ])
                        ],
                  size = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InitialWorkDirRequirement!predicate"
        | doc m%"
          Define a list of files and subdirectories that must be staged by the workflow platform prior to executing the command line tool.
          Normally files are staged within the designated output directory. However, when running inside containers, files may be staged at arbitrary locations, see discussion for [`Dirent.entryname`](#Dirent). Together with `DockerRequirement.dockerOutputDirectory` it is possible to control the locations of both input and output files when running in containers.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "InitialWorkDirRequirement"
                        ],
                  listing =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/Directory!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/File!predicate",
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-refsenv."_js2n__-:definitions/Directory!predicate",
                                                      _js2n__-refsenv."_js2n__-:definitions/File!predicate"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                                  _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                                                ])
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/Dirent!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ],
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InitialWorkDirRequirementMap!predicate"
        | doc m%"
          Define a list of files and subdirectories that must be staged by the workflow platform prior to executing the command line tool.
          Normally files are staged within the designated output directory. However, when running inside containers, files may be staged at arbitrary locations, see discussion for [`Dirent.entryname`](#Dirent). Together with `DockerRequirement.dockerOutputDirectory` it is possible to control the locations of both input and output files when running in containers.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  listing =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/Directory!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/File!predicate",
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-refsenv."_js2n__-:definitions/Directory!predicate",
                                                      _js2n__-refsenv."_js2n__-:definitions/File!predicate"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                                  _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                                                ])
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/Dirent!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ],
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/InlineJavascriptRequirement!predicate"
        | doc m%"
          Indicates that the workflow platform must support inline Javascript expressions.
          If this requirement is not present, the workflow platform must not perform expression
          interpolation.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "InlineJavascriptRequirement"
                        ],
                  expressionLib =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InlineJavascriptRequirementMap!predicate"
        | doc m%"
          Indicates that the workflow platform must support inline Javascript expressions.
          If this requirement is not present, the workflow platform must not perform expression
          interpolation.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  expressionLib =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/InplaceUpdateRequirement!predicate"
        | doc m%"
          
          If `inplaceUpdate` is true, then an implementation supporting this
          feature may permit tools to directly update files with `writable:
          true` in InitialWorkDirRequirement.  That is, as an optimization,
          files may be destructively modified in place as opposed to copied
          and updated.
          
          An implementation must ensure that only one workflow step may
          access a writable file at a time.  It is an error if a file which
          is writable by one workflow step file is accessed (for reading or
          writing) by any other workflow step running independently.
          However, a file which has been updated in a previous completed
          step may be used as input to multiple steps, provided it is
          read-only in every step.
          
          Workflow steps which modify a file must produce the modified file
          as output.  Downstream steps which further process the file must
          use the output of previous steps, and not refer to a common input
          (this is necessary for both ordering and correctness).
          
          Workflow authors should provide this in the `hints` section.  The
          intent of this feature is that workflows produce the same results
          whether or not InplaceUpdateRequirement is supported by the
          implementation, and this feature is primarily available as an
          optimization for particular environments.
          
          Users and implementers should be aware that workflows that
          destructively modify inputs may not be repeatable or reproducible.
          In particular, enabling this feature implies that WorkReuse should
          not be enabled.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "inplaceUpdate" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "InplaceUpdateRequirement"
                        ],
                  inplaceUpdate = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InplaceUpdateRequirementMap!predicate"
        | doc m%"
          
          If `inplaceUpdate` is true, then an implementation supporting this
          feature may permit tools to directly update files with `writable:
          true` in InitialWorkDirRequirement.  That is, as an optimization,
          files may be destructively modified in place as opposed to copied
          and updated.
          
          An implementation must ensure that only one workflow step may
          access a writable file at a time.  It is an error if a file which
          is writable by one workflow step file is accessed (for reading or
          writing) by any other workflow step running independently.
          However, a file which has been updated in a previous completed
          step may be used as input to multiple steps, provided it is
          read-only in every step.
          
          Workflow steps which modify a file must produce the modified file
          as output.  Downstream steps which further process the file must
          use the output of previous steps, and not refer to a common input
          (this is necessary for both ordering and correctness).
          
          Workflow authors should provide this in the `hints` section.  The
          intent of this feature is that workflows produce the same results
          whether or not InplaceUpdateRequirement is supported by the
          implementation, and this feature is primarily available as an
          optimization for particular environments.
          
          Users and implementers should be aware that workflows that
          destructively modify inputs may not be repeatable or reproducible.
          In particular, enabling this feature implies that WorkReuse should
          not be enabled.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "inplaceUpdate" ],
              _js2n__-prdslib.records.record
                { inplaceUpdate = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/InputArraySchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#InputArraySchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "items", "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  items =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "array"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InputBinding!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#InputBinding"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { loadContents = _js2n__-prdslib.isType '"Bool", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InputEnumSchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#InputEnumSchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "symbols", "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  symbols =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "enum"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InputRecordField!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#InputRecordField"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      "doc" =
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
                      format =
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
                      label = _js2n__-prdslib.isType '"String",
                      loadContents = _js2n__-prdslib.isType '"Bool",
                      loadListing =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "deep_listing",
                                  "no_listing",
                                  "shallow_listing"
                                ]
                            ],
                      name = _js2n__-prdslib.isType '"String",
                      secondaryFiles =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                                ]
                            ],
                      streamable = _js2n__-prdslib.isType '"Bool",
                      type =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ])
                                ],
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                  _js2n__-prdslib.isType '"String"
                                ])
                          ],
                        _js2n__-prdslib.isType '"String"
                      ])
                ]
            ],
      "_js2n__-:definitions/InputRecordFieldMap!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#InputRecordField"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    {
                      "doc" =
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
                      format =
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
                      label = _js2n__-prdslib.isType '"String",
                      loadContents = _js2n__-prdslib.isType '"Bool",
                      loadListing =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "deep_listing",
                                  "no_listing",
                                  "shallow_listing"
                                ]
                            ],
                      name = _js2n__-prdslib.isType '"String",
                      secondaryFiles =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                                ]
                            ],
                      streamable = _js2n__-prdslib.isType '"Bool",
                      type =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ])
                                ],
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                  _js2n__-prdslib.isType '"String"
                                ])
                          ],
                        _js2n__-prdslib.isType '"String"
                      ])
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/InputRecordSchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#InputRecordSchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  fields =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/InputRecordField!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/InputRecordFieldMap!predicate",
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "record"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LoadListingRequirement!predicate"
        | doc m%"
          Specify the desired behavior for loading the `listing` field of
          a Directory object for use by expressions.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "LoadListingRequirement"
                        ],
                  loadListing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "deep_listing", "no_listing", "shallow_listing" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LoadListingRequirementMap!predicate"
        | doc m%"
          Specify the desired behavior for loading the `listing` field of
          a Directory object for use by expressions.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  loadListing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "deep_listing", "no_listing", "shallow_listing" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MultipleInputFeatureRequirement!predicate"
        | doc m%"
          Indicates that the workflow platform must support multiple inbound data links
          listed in the `source` field of [WorkflowStepInput](#WorkflowStepInput).
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const
                            "MultipleInputFeatureRequirement"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate"
        | doc m%"
          Indicates that the workflow platform must support multiple inbound data links
          listed in the `source` field of [WorkflowStepInput](#WorkflowStepInput).
        "%
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/NetworkAccess!predicate"
        | doc m%"
          Indicate whether a process requires outgoing IPv4/IPv6 network
          access.  Choice of IPv4 or IPv6 is implementation and site
          specific, correct tools must support both.
          
          If `networkAccess` is false or not specified, tools must not
          assume network access, except for localhost (the loopback device).
          
          If `networkAccess` is true, the tool must be able to make outgoing
          connections to network resources.  Resources may be on a private
          subnet or the public Internet.  However, implementations and sites
          may apply their own security policies to restrict what is
          accessible by the tool.
          
          Enabling network access does not imply a publicly routable IP
          address or the ability to accept inbound connections.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "networkAccess" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "NetworkAccess"
                        ],
                  networkAccess =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NetworkAccessMap!predicate"
        | doc m%"
          Indicate whether a process requires outgoing IPv4/IPv6 network
          access.  Choice of IPv4 or IPv6 is implementation and site
          specific, correct tools must support both.
          
          If `networkAccess` is false or not specified, tools must not
          assume network access, except for localhost (the loopback device).
          
          If `networkAccess` is true, the tool must be able to make outgoing
          connections to network resources.  Resources may be on a private
          subnet or the public Internet.  However, implementations and sites
          may apply their own security policies to restrict what is
          accessible by the tool.
          
          Enabling network access does not imply a publicly routable IP
          address or the ability to accept inbound connections.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "networkAccess" ],
              _js2n__-prdslib.records.record
                {
                  networkAccess =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Operation!predicate"
        | doc m%"
          This record describes an abstract operation.  It is a potential
          step of a workflow that has not yet been bound to a concrete
          implementation.  It specifies an input and output signature, but
          does not provide enough information to be executed.  An
          implementation (or other tooling) may provide a means of binding
          an Operation to a concrete process (such as Workflow,
          CommandLineTool, or ExpressionTool) with a compatible signature.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "inputs", "outputs" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "Operation"
                        ],
                  cwlVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "draft-2",
                              "draft-3",
                              "draft-3.dev1",
                              "draft-3.dev2",
                              "draft-3.dev3",
                              "draft-3.dev4",
                              "draft-3.dev5",
                              "draft-4.dev1",
                              "draft-4.dev2",
                              "draft-4.dev3",
                              "v1.0",
                              "v1.0.dev4",
                              "v1.1",
                              "v1.1.0-dev1",
                              "v1.2",
                              "v1.2.0-dev1",
                              "v1.2.0-dev2",
                              "v1.2.0-dev3",
                              "v1.2.0-dev4",
                              "v1.2.0-dev5"
                            ]
                        ],
                  "doc" =
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
                  hints =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/DockerRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/WorkReuse!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/NetworkAccess!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimit!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirement!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  DockerRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/DockerRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  EnvVarRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InitialWorkDirRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InlineJavascriptRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InplaceUpdateRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  LoadListingRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  MultipleInputFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  NetworkAccess =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/NetworkAccessMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ResourceRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ResourceRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ScatterFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SchemaDefRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ShellCommandRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SoftwareRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  StepInputExpressionRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SubworkflowFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ToolTimeLimit =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimitMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  WorkReuse =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkReuseMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  inputs =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/OperationInputParameter!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/OperationInputParameter!predicate",
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ])
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-refsenv."_js2n__-:definitions/OperationInputParameter!predicate"
                                                  ])
                                            ]
                                        ],
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  intent =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  outputs =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/OperationOutputParameter!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/OperationOutputParameter!predicate",
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ])
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-refsenv."_js2n__-:definitions/OperationOutputParameter!predicate"
                                                  ])
                                            ]
                                        ],
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  requirements =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/DockerRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/WorkReuse!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/NetworkAccess!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimit!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirement!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  DockerRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/DockerRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  EnvVarRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InitialWorkDirRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InlineJavascriptRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InplaceUpdateRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  LoadListingRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  MultipleInputFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  NetworkAccess =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/NetworkAccessMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ResourceRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ResourceRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ScatterFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SchemaDefRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ShellCommandRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SoftwareRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  StepInputExpressionRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SubworkflowFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ToolTimeLimit =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimitMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  WorkReuse =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkReuseMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OperationInputParameter!predicate"
        | doc "Describe an input parameter of an operation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "default" = _js2n__-prdslib.always,
                  "doc" =
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
                  format =
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
                  id = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  loadContents = _js2n__-prdslib.isType '"Bool",
                  loadListing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "deep_listing", "no_listing", "shallow_listing" ]
                        ],
                  secondaryFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                            ]
                        ],
                  streamable = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OperationOutputParameter!predicate"
        | doc "Describe an output parameter of an operation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  format = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  secondaryFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                            ]
                        ],
                  streamable = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OutputArraySchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#OutputArraySchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "items", "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  items =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "array"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OutputEnumSchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#OutputEnumSchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "symbols", "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  symbols =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "enum"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OutputRecordField!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#OutputRecordField"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      "doc" =
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
                      format = _js2n__-prdslib.isType '"String",
                      label = _js2n__-prdslib.isType '"String",
                      name = _js2n__-prdslib.isType '"String",
                      secondaryFiles =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                                ]
                            ],
                      streamable = _js2n__-prdslib.isType '"Bool",
                      type =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ])
                                ],
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                  _js2n__-prdslib.isType '"String"
                                ])
                          ],
                        _js2n__-prdslib.isType '"String"
                      ])
                ]
            ],
      "_js2n__-:definitions/OutputRecordFieldMap!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#OutputRecordField"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    {
                      "doc" =
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
                      format = _js2n__-prdslib.isType '"String",
                      label = _js2n__-prdslib.isType '"String",
                      name = _js2n__-prdslib.isType '"String",
                      secondaryFiles =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                                ]
                            ],
                      streamable = _js2n__-prdslib.isType '"Bool",
                      type =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                        _js2n__-prdslib.isType '"String"
                                      ])
                                ],
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                  _js2n__-prdslib.isType '"String"
                                ])
                          ],
                        _js2n__-prdslib.isType '"String"
                      ])
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/OutputRecordSchema!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#OutputRecordSchema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  fields =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/OutputRecordField!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/OutputRecordFieldMap!predicate",
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "record"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourceRequirement!predicate"
        | doc m%"
          Specify basic hardware resource requirements.
          
          "min" is the minimum amount of a resource that must be reserved to
          schedule a job. If "min" cannot be satisfied, the job should not
          be run.
          
          "max" is the maximum amount of a resource that the job shall be
          allocated. If a node has sufficient resources, multiple jobs may
          be scheduled on a single node provided each job's "max" resource
          requirements are met. If a job attempts to exceed its resource
          allocation, an implementation may deny additional resources, which
          may result in job failure.
          
          If both "min" and "max" are specified, an implementation may
          choose to allocate any amount between "min" and "max", with the
          actual allocation provided in the `runtime` object.
          
          If "min" is specified but "max" is not, then "max" == "min"
          If "max" is specified by "min" is not, then "min" == "max".
          
          It is an error if max < min.
          
          It is an error if the value of any of these fields is negative.
          
          If neither "min" nor "max" is specified for a resource, use the default values below.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "ResourceRequirement"
                        ],
                  coresMax =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  coresMin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  outdirMax =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  outdirMin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  ramMax =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  ramMin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  tmpdirMax =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  tmpdirMin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourceRequirementMap!predicate"
        | doc m%"
          Specify basic hardware resource requirements.
          
          "min" is the minimum amount of a resource that must be reserved to
          schedule a job. If "min" cannot be satisfied, the job should not
          be run.
          
          "max" is the maximum amount of a resource that the job shall be
          allocated. If a node has sufficient resources, multiple jobs may
          be scheduled on a single node provided each job's "max" resource
          requirements are met. If a job attempts to exceed its resource
          allocation, an implementation may deny additional resources, which
          may result in job failure.
          
          If both "min" and "max" are specified, an implementation may
          choose to allocate any amount between "min" and "max", with the
          actual allocation provided in the `runtime` object.
          
          If "min" is specified but "max" is not, then "max" == "min"
          If "max" is specified by "min" is not, then "min" == "max".
          
          It is an error if max < min.
          
          It is an error if the value of any of these fields is negative.
          
          If neither "min" nor "max" is specified for a resource, use the default values below.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  coresMax =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  coresMin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  outdirMax =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  outdirMin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  ramMax =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  ramMin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  tmpdirMax =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  tmpdirMin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ScatterFeatureRequirement!predicate"
        | doc m%"
          Indicates that the workflow platform must support the `scatter` and
          `scatterMethod` fields of [WorkflowStep](#WorkflowStep).
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "ScatterFeatureRequirement"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ScatterFeatureRequirementMap!predicate"
        | doc m%"
          Indicates that the workflow platform must support the `scatter` and
          `scatterMethod` fields of [WorkflowStep](#WorkflowStep).
        "%
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/SchemaDefRequirement!predicate"
        | doc m%"
          This field consists of an array of type definitions which must be used when
          interpreting the `inputs` and `outputs` fields.  When a `type` field
          contains a IRI, the implementation must check if the type is defined in
          `schemaDefs` and use that definition.  If the type is not found in
          `schemaDefs`, it is an error.  The entries in `schemaDefs` must be
          processed in the order listed such that later schema definitions may refer
          to earlier schema definitions.
          
          - **Type definitions are allowed for `enum` and `record` types only.**
          - Type definitions may be shared by defining them in a file and then
            `$include`-ing them in the `types` field.
          - A file can contain a list of type definitions
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "types" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "SchemaDefRequirement"
                        ],
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate"
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SchemaDefRequirementMap!predicate"
        | doc m%"
          This field consists of an array of type definitions which must be used when
          interpreting the `inputs` and `outputs` fields.  When a `type` field
          contains a IRI, the implementation must check if the type is defined in
          `schemaDefs` and use that definition.  If the type is not found in
          `schemaDefs`, it is an error.  The entries in `schemaDefs` must be
          processed in the order listed such that later schema definitions may refer
          to earlier schema definitions.
          
          - **Type definitions are allowed for `enum` and `record` types only.**
          - Type definitions may be shared by defining them in a file and then
            `$include`-ing them in the `types` field.
          - A file can contain a list of type definitions
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "types" ],
              _js2n__-prdslib.records.record
                {
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputArraySchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CommandInputEnumSchema!predicate"
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SecondaryFileSchema!predicate"
        | doc m%"
          Secondary files are specified using the following micro-DSL for secondary files:
          
          * If the value is a string, it is transformed to an object with two fields
            `pattern` and `required`
          * By default, the value of `required` is `null`
            (this indicates default behavior, which may be based on the context)
          * If the value ends with a question mark `?` the question mark is
            stripped off and the value of the field `required` is set to `False`
          * The remaining value is assigned to the field `pattern`
          
          For implementation details and examples, please see
          [this section](SchemaSalad.html#Domain_Specific_Language_for_secondary_files)
          in the Schema Salad specification.
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "pattern" ],
                  _js2n__-prdslib.records.record
                    {
                      pattern = _js2n__-prdslib.isType '"String",
                      required =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Bool"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/ShellCommandRequirement!predicate"
        | doc m%"
          Modify the behavior of CommandLineTool to generate a single string
          containing a shell command line.  Each item in the `arguments` list must
          be joined into a string separated by single spaces and quoted to prevent
          interpretation by the shell, unless `CommandLineBinding` for that argument
          contains `shellQuote: false`.  If `shellQuote: false` is specified, the
          argument is joined into the command string without quoting, which allows
          the use of shell metacharacters such as `|` for pipes.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "ShellCommandRequirement"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ShellCommandRequirementMap!predicate"
        | doc m%"
          Modify the behavior of CommandLineTool to generate a single string
          containing a shell command line.  Each item in the `arguments` list must
          be joined into a string separated by single spaces and quoted to prevent
          interpretation by the shell, unless `CommandLineBinding` for that argument
          contains `shellQuote: false`.  If `shellQuote: false` is specified, the
          argument is joined into the command string without quoting, which allows
          the use of shell metacharacters such as `|` for pipes.
        "%
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/SoftwarePackage!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#SoftwarePackage"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "package" ],
              _js2n__-prdslib.records.record
                {
                  package = _js2n__-prdslib.isType '"String",
                  specs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SoftwareRequirement!predicate"
        | doc m%"
          A list of software packages that should be configured in the environment of
          the defined process.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "packages" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "SoftwareRequirement"
                        ],
                  packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/SoftwarePackage!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SoftwareRequirementMap!predicate"
        | doc m%"
          A list of software packages that should be configured in the environment of
          the defined process.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "packages" ],
              _js2n__-prdslib.records.record
                {
                  packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/SoftwarePackage!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/StepInputExpressionRequirement!predicate"
        | doc m%"
          Indicate that the workflow platform must support the `valueFrom` field
          of [WorkflowStepInput](#WorkflowStepInput).
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "StepInputExpressionRequirement"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StepInputExpressionRequirementMap!predicate"
        | doc m%"
          Indicate that the workflow platform must support the `valueFrom` field
          of [WorkflowStepInput](#WorkflowStepInput).
        "%
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/SubworkflowFeatureRequirement!predicate"
        | doc m%"
          Indicates that the workflow platform must support nested workflows in
          the `run` field of [WorkflowStep](#WorkflowStep).
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "SubworkflowFeatureRequirement"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate"
        | doc m%"
          Indicates that the workflow platform must support nested workflows in
          the `run` field of [WorkflowStep](#WorkflowStep).
        "%
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/ToolTimeLimit!predicate"
        | doc m%"
          Set an upper limit on the execution time of a CommandLineTool.
          A CommandLineTool whose execution duration exceeds the time
          limit may be preemptively terminated and considered failed.
          May also be used by batch systems to make scheduling decisions.
          The execution duration excludes external operations, such as
          staging of files, pulling a docker image etc, and only counts
          wall-time for the execution of the command line itself.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "timelimit" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "ToolTimeLimit"
                        ],
                  timelimit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ToolTimeLimitMap!predicate"
        | doc m%"
          Set an upper limit on the execution time of a CommandLineTool.
          A CommandLineTool whose execution duration exceeds the time
          limit may be preemptively terminated and considered failed.
          May also be used by batch systems to make scheduling decisions.
          The execution duration excludes external operations, such as
          staging of files, pulling a docker image etc, and only counts
          wall-time for the execution of the command line itself.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "timelimit" ],
              _js2n__-prdslib.records.record
                {
                  timelimit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/WorkReuse!predicate"
        | doc m%"
          For implementations that support reusing output from past work (on
          the assumption that same code and same input produce same
          results), control whether to enable or disable the reuse behavior
          for a particular tool or step (to accommodate situations where that
          assumption is incorrect).  A reused step is not executed but
          instead returns the same output as the original execution.
          
          If `WorkReuse` is not specified, correct tools should assume it
          is enabled by default.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "enableReuse" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "WorkReuse"
                        ],
                  enableReuse =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WorkReuseMap!predicate"
        | doc m%"
          For implementations that support reusing output from past work (on
          the assumption that same code and same input produce same
          results), control whether to enable or disable the reuse behavior
          for a particular tool or step (to accommodate situations where that
          assumption is incorrect).  A reused step is not executed but
          instead returns the same output as the original execution.
          
          If `WorkReuse` is not specified, correct tools should assume it
          is enabled by default.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "enableReuse" ],
              _js2n__-prdslib.records.record
                {
                  enableReuse =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Workflow!predicate"
        | doc m%"
          A workflow describes a set of **steps** and the **dependencies** between
          those steps.  When a step produces output that will be consumed by a
          second step, the first step is a dependency of the second step.
          
          When there is a dependency, the workflow engine must execute the preceding
          step and wait for it to successfully produce output before executing the
          dependent step.  If two steps are defined in the workflow graph that
          are not directly or indirectly dependent, these steps are **independent**,
          and may execute in any order or execute concurrently.  A workflow is
          complete when all steps have been executed.
          
          Dependencies between parameters are expressed using the `source`
          field on [workflow step input parameters](#WorkflowStepInput) and
          `outputSource` field on [workflow output
          parameters](#WorkflowOutputParameter).
          
          The `source` field on each workflow step input parameter expresses
          the data links that contribute to the value of the step input
          parameter (the "sink").  A workflow step can only begin execution
          when every data link connected to a step has been fulfilled.
          
          The `outputSource` field on each workflow step input parameter
          expresses the data links that contribute to the value of the
          workflow output parameter (the "sink").  Workflow execution cannot
          complete successfully until every data link connected to an output
          parameter has been fulfilled.
          
          ## Workflow success and failure
          
          A completed step must result in one of `success`, `temporaryFailure` or
          `permanentFailure` states.  An implementation may choose to retry a step
          execution which resulted in `temporaryFailure`.  An implementation may
          choose to either continue running other steps of a workflow, or terminate
          immediately upon `permanentFailure`.
          
          * If any step of a workflow execution results in `permanentFailure`, then
          the workflow status is `permanentFailure`.
          
          * If one or more steps result in `temporaryFailure` and all other steps
          complete `success` or are not executed, then the workflow status is
          `temporaryFailure`.
          
          * If all workflow steps are executed and complete with `success`, then the
          workflow status is `success`.
          
          # Extensions
          
          [ScatterFeatureRequirement](#ScatterFeatureRequirement) and
          [SubworkflowFeatureRequirement](#SubworkflowFeatureRequirement) are
          available as standard [extensions](#Extensions_and_Metadata) to core
          workflow semantics.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "class", "inputs", "outputs", "steps" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "Workflow"
                        ],
                  cwlVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "draft-2",
                              "draft-3",
                              "draft-3.dev1",
                              "draft-3.dev2",
                              "draft-3.dev3",
                              "draft-3.dev4",
                              "draft-3.dev5",
                              "draft-4.dev1",
                              "draft-4.dev2",
                              "draft-4.dev3",
                              "v1.0",
                              "v1.0.dev4",
                              "v1.1",
                              "v1.1.0-dev1",
                              "v1.2",
                              "v1.2.0-dev1",
                              "v1.2.0-dev2",
                              "v1.2.0-dev3",
                              "v1.2.0-dev4",
                              "v1.2.0-dev5"
                            ]
                        ],
                  "doc" =
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
                  hints =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/DockerRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/WorkReuse!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/NetworkAccess!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimit!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirement!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  DockerRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/DockerRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  EnvVarRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InitialWorkDirRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InlineJavascriptRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InplaceUpdateRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  LoadListingRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  MultipleInputFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  NetworkAccess =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/NetworkAccessMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ResourceRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ResourceRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ScatterFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SchemaDefRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ShellCommandRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SoftwareRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  StepInputExpressionRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SubworkflowFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ToolTimeLimit =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimitMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  WorkReuse =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkReuseMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  inputs =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/WorkflowInputParameter!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkflowInputParameter!predicate",
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ])
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-refsenv."_js2n__-:definitions/WorkflowInputParameter!predicate"
                                                  ])
                                            ]
                                        ],
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  intent =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  outputs =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/WorkflowOutputParameter!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkflowOutputParameter!predicate",
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                                        _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ])
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-refsenv."_js2n__-:definitions/WorkflowOutputParameter!predicate"
                                                  ])
                                            ]
                                        ],
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  requirements =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/DockerRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/WorkReuse!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/NetworkAccess!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimit!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirement!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  DockerRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/DockerRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  EnvVarRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InitialWorkDirRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InlineJavascriptRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InplaceUpdateRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  LoadListingRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  MultipleInputFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  NetworkAccess =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/NetworkAccessMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ResourceRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ResourceRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ScatterFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SchemaDefRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ShellCommandRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SoftwareRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  StepInputExpressionRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SubworkflowFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ToolTimeLimit =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimitMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  WorkReuse =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkReuseMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  steps =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/WorkflowStep!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/WorkflowStep!predicate",
                                } true _js2n__-prdslib.always
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/WorkflowInputParameter!predicate"
        | doc "Auto-generated class implementation for https://w3id.org/cwl/cwl#WorkflowInputParameter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "default" = _js2n__-prdslib.always,
                  "doc" =
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
                  format =
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
                  id = _js2n__-prdslib.isType '"String",
                  inputBinding =
                    _js2n__-refsenv."_js2n__-:definitions/InputBinding!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  loadContents = _js2n__-prdslib.isType '"Bool",
                  loadListing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "deep_listing", "no_listing", "shallow_listing" ]
                        ],
                  secondaryFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                            ]
                        ],
                  streamable = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/InputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InputEnumSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InputArraySchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WorkflowOutputParameter!predicate"
        | doc m%"
          Describe an output parameter of a workflow.  The parameter must be
          connected to one or more parameters defined in the workflow that
          will provide the value of the output parameter. It is legal to
          connect a WorkflowInputParameter to a WorkflowOutputParameter.
          
          See [WorkflowStepInput](#WorkflowStepInput) for discussion of
          `linkMerge` and `pickValue`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  format = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  linkMerge =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "merge_flattened", "merge_nested" ]
                        ],
                  outputSource =
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
                  pickValue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "all_non_null",
                              "first_non_null",
                              "the_only_non_null"
                            ]
                        ],
                  secondaryFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SecondaryFileSchema!predicate"
                            ]
                        ],
                  streamable = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/OutputRecordSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/OutputEnumSchema!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/OutputArraySchema!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WorkflowStep!predicate"
        | doc m%"
          A workflow step is an executable element of a workflow.  It specifies the
          underlying process implementation (such as `CommandLineTool` or another
          `Workflow`) in the `run` field and connects the input and output parameters
          of the underlying process to workflow parameters.
          
          # Scatter/gather
          
          To use scatter/gather,
          [ScatterFeatureRequirement](#ScatterFeatureRequirement) must be specified
          in the workflow or workflow step requirements.
          
          A "scatter" operation specifies that the associated workflow step or
          subworkflow should execute separately over a list of input elements.  Each
          job making up a scatter operation is independent and may be executed
          concurrently.
          
          The `scatter` field specifies one or more input parameters which will be
          scattered.  An input parameter may be listed more than once.  The declared
          type of each input parameter implicitly becomes an array of items of the
          input parameter type.  If a parameter is listed more than once, it becomes
          a nested array.  As a result, upstream parameters which are connected to
          scattered parameters must be arrays.
          
          All output parameter types are also implicitly wrapped in arrays.  Each job
          in the scatter results in an entry in the output array.
          
          If any scattered parameter runtime value is an empty array, all outputs are
          set to empty arrays and no work is done for the step, according to
          applicable scattering rules.
          
          If `scatter` declares more than one input parameter, `scatterMethod`
          describes how to decompose the input into a discrete set of jobs.
          
            * **dotproduct** specifies that each of the input arrays are aligned and one
                element taken from each array to construct each job.  It is an error
                if all input arrays are not the same length.
          
            * **nested_crossproduct** specifies the Cartesian product of the inputs,
                producing a job for every combination of the scattered inputs.  The
                output must be nested arrays for each level of scattering, in the
                order that the input arrays are listed in the `scatter` field.
          
            * **flat_crossproduct** specifies the Cartesian product of the inputs,
                producing a job for every combination of the scattered inputs.  The
                output arrays must be flattened to a single level, but otherwise listed in the
                order that the input arrays are listed in the `scatter` field.
          
          # Conditional execution (Optional)
          
          Conditional execution makes execution of a step conditional on an
          expression.  A step that is not executed is "skipped".  A skipped
          step produces `null` for all output parameters.
          
          The condition is evaluated after `scatter`, using the input object
          of each individual scatter job.  This means over a set of scatter
          jobs, some may be executed and some may be skipped.  When the
          results are gathered, skipped steps must be `null` in the output
          arrays.
          
          The `when` field controls conditional execution.  This is an
          expression that must be evaluated with `inputs` bound to the step
          input object (or individual scatter job), and returns a boolean
          value.  It is an error if this expression returns a value other
          than `true` or `false`.
          
          Conditionals in CWL are an optional feature and are not required
          to be implemented by all consumers of CWL documents.  An
          implementation that does not support conditionals must return a
          fatal error when attempting to execute a workflow that uses
          conditional constructs the implementation does not support.
          
          # Subworkflows
          
          To specify a nested workflow as part of a workflow step,
          [SubworkflowFeatureRequirement](#SubworkflowFeatureRequirement) must be
          specified in the workflow or workflow step requirements.
          
          It is a fatal error if a workflow directly or indirectly invokes itself as
          a subworkflow (recursive workflows are not allowed).
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "in", "out", "run" ],
              _js2n__-prdslib.records.record
                {
                  "doc" =
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
                  hints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  "in" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/WorkflowStepInput!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkflowStepInput!predicate",
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-refsenv."_js2n__-:definitions/WorkflowStepInput!predicate"
                                                  ])
                                            ]
                                        ],
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  out =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/WorkflowStepOutput!predicate",
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  requirements =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CWLImportManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CWLIncludeManual!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/DockerRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/WorkReuse!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/NetworkAccess!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimit!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirement!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirement!predicate"
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  DockerRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/DockerRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  EnvVarRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/EnvVarRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InitialWorkDirRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InitialWorkDirRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InlineJavascriptRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InlineJavascriptRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  InplaceUpdateRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/InplaceUpdateRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  LoadListingRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/LoadListingRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  MultipleInputFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/MultipleInputFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  NetworkAccess =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/NetworkAccessMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ResourceRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ResourceRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ScatterFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ScatterFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SchemaDefRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SchemaDefRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ShellCommandRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ShellCommandRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SoftwareRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SoftwareRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  StepInputExpressionRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/StepInputExpressionRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  SubworkflowFeatureRequirement =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/SubworkflowFeatureRequirementMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  ToolTimeLimit =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/ToolTimeLimitMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                  WorkReuse =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/WorkReuseMap!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  run =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CommandLineTool!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/ExpressionTool!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Workflow!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Operation!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  scatter =
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
                  scatterMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "dotproduct",
                              "flat_crossproduct",
                              "nested_crossproduct"
                            ]
                        ],
                  when = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WorkflowStepInput!predicate"
        | doc m%"
          The input of a workflow step connects an upstream parameter (from the
          workflow inputs, or the outputs of other workflows steps) with the input
          parameters of the process specified by the `run` field. Only input parameters
          declared by the target process will be passed through at runtime to the process
          though additional parameters may be specified (for use within `valueFrom`
          expressions for instance) - unconnected or unused parameters do not represent an
          error condition.
          
          # Input object
          
          A WorkflowStepInput object must contain an `id` field in the form
          `#fieldname` or `#prefix/fieldname`.  When the `id` field contains a slash
          `/` the field name consists of the characters following the final slash
          (the prefix portion may contain one or more slashes to indicate scope).
          This defines a field of the workflow step input object with the value of
          the `source` parameter(s).
          
          # Merging multiple inbound data links
          
          To merge multiple inbound data links,
          [MultipleInputFeatureRequirement](#MultipleInputFeatureRequirement) must be specified
          in the workflow or workflow step requirements.
          
          If the sink parameter is an array, or named in a [workflow
          scatter](#WorkflowStep) operation, there may be multiple inbound
          data links listed in the `source` field.  The values from the
          input links are merged depending on the method specified in the
          `linkMerge` field.  If both `linkMerge` and `pickValue` are null
          or not specified, and there is more than one element in the
          `source` array, the default method is "merge_nested".
          
          If both `linkMerge` and `pickValue` are null or not specified, and
          there is only a single element in the `source`, then the input
          parameter takes the scalar value from the single input link (it is
          *not* wrapped in a single-list).
          
          * **merge_nested**
          
            The input must be an array consisting of exactly one entry for each
            input link.  If "merge_nested" is specified with a single link, the value
            from the link must be wrapped in a single-item list.
          
          * **merge_flattened**
          
            1. The source and sink parameters must be compatible types, or the source
               type must be compatible with single element from the "items" type of
               the destination array parameter.
            2. Source parameters which are arrays are concatenated.
               Source parameters which are single element types are appended as
               single elements.
          
          # Picking non-null values among inbound data links
          
          If present, `pickValue` specifies how to pick non-null values among inbound data links.
          
          `pickValue` is evaluated
            1. Once all source values from upstream step or parameters are available.
            2. After `linkMerge`.
            3. Before `scatter` or `valueFrom`.
          
          This is specifically intended to be useful in combination with
          [conditional execution](#WorkflowStep), where several upstream
          steps may be connected to a single input (`source` is a list), and
          skipped steps produce null values.
          
          Static type checkers should check for type consistency after inferring what the type
          will be after `pickValue` is applied, just as they do currently for `linkMerge`.
          
          * **first_non_null**
          
            For the first level of a list input, pick the first non-null element.  The result is a scalar.
            It is an error if there is no non-null element.  Examples:
            * `[null, x, null, y] -> x`
            * `[null, [null], null, y] -> [null]`
            * `[null, null, null] -> Runtime Error`
          
            *Intended use case*: If-else pattern where the
            value comes either from a conditional step or from a default or
            fallback value. The conditional step(s) should be placed first in
            the list.
          
          * **the_only_non_null**
          
            For the first level of a list input, pick the single non-null element.  The result is a scalar.
            It is an error if there is more than one non-null element.  Examples:
          
            * `[null, x, null] -> x`
            * `[null, x, null, y] -> Runtime Error`
            * `[null, [null], null] -> [null]`
            * `[null, null, null] -> Runtime Error`
          
            *Intended use case*: Switch type patterns where developer considers
            more than one active code path as a workflow error
            (possibly indicating an error in writing `when` condition expressions).
          
          * **all_non_null**
          
            For the first level of a list input, pick all non-null values.
            The result is a list, which may be empty.  Examples:
          
            * `[null, x, null] -> [x]`
            * `[x, null, y] -> [x, y]`
            * `[null, [x], [null]] -> [[x], [null]]`
            * `[null, null, null] -> []`
          
            *Intended use case*: It is valid to have more than one source, but
             sources are conditional, so null sources (from skipped steps)
             should be filtered out.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "default" = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  linkMerge =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "merge_flattened", "merge_nested" ]
                        ],
                  loadContents = _js2n__-prdslib.isType '"Bool",
                  loadListing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "deep_listing", "no_listing", "shallow_listing" ]
                        ],
                  pickValue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "all_non_null",
                              "first_non_null",
                              "the_only_non_null"
                            ]
                        ],
                  source =
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
                  valueFrom = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WorkflowStepOutput!predicate"
        | doc m%"
          Associate an output parameter of the underlying process with a workflow
          parameter.  The workflow parameter (given in the `id` field) be may be used
          as a `source` to connect with input parameters of other workflow steps, or
          with an output parameter of the process.
          
          A unique identifier for this workflow output parameter.  This is
          the identifier to use in the `source` field of `WorkflowStepInput`
          to connect the output value to downstream parameters.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { id = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-refsenv."_js2n__-:definitions/CWLGraphOrFile!contract"