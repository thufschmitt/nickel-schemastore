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
      "_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.BeansDeserializer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.BeanFactoryDefinition!predicate",
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.DataFormatsDefinitionDeserializer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.DataFormatsDefinition!predicate",
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.ErrorHandlerDeserializer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "deadLetterChannel" ],
                      _js2n__-prdslib.records.record
                        {
                          deadLetterChannel =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.DeadLetterChannelDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "deadLetterChannel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "defaultErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "jtaTransactionErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "noErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "refErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "springTransactionErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "defaultErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          defaultErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.DefaultErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "jtaTransactionErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          jtaTransactionErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.JtaTransactionErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "noErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          noErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.NoErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "refErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          refErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.RefErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "springTransactionErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          springTransactionErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.SpringTransactionErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  deadLetterChannel = _js2n__-prdslib.always,
                  defaultErrorHandler = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  jtaTransactionErrorHandler = _js2n__-prdslib.always,
                  noErrorHandler = _js2n__-prdslib.always,
                  refErrorHandler = _js2n__-prdslib.always,
                  springTransactionErrorHandler = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.OutputAwareFromDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "steps", "uri" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  parameters = _js2n__-prdslib.isType 'Record,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  uri = _js2n__-prdslib.isType '"String",
                  variableReceive = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.RouteFromDefinitionDeserializer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "steps", "uri" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  parameters = _js2n__-prdslib.isType 'Record,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  uri = _js2n__-prdslib.isType '"String",
                  variableReceive = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never,
              _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.OutputAwareFromDefinition!predicate"
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.AggregateDefinition!predicate"
        | doc "Aggregates many messages into a single message"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "aggregationStrategy" ],
              _js2n__-prdslib.records.record
                {
                  aggregateController = _js2n__-prdslib.isType '"String",
                  aggregationRepository = _js2n__-prdslib.isType '"String",
                  aggregationStrategy = _js2n__-prdslib.isType '"String",
                  aggregationStrategyMethodAllowNull =
                    _js2n__-prdslib.isType '"Bool",
                  aggregationStrategyMethodName =
                    _js2n__-prdslib.isType '"String",
                  closeCorrelationKeyOnCompletion =
                    _js2n__-prdslib.isType '"Number",
                  completeAllOnStop = _js2n__-prdslib.isType '"Bool",
                  completionFromBatchConsumer = _js2n__-prdslib.isType '"Bool",
                  completionInterval = _js2n__-prdslib.isType '"String",
                  completionOnNewCorrelationGroup =
                    _js2n__-prdslib.isType '"Bool",
                  completionPredicate =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate",
                  completionSize = _js2n__-prdslib.isType '"Number",
                  completionSizeExpression =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate",
                  completionTimeout = _js2n__-prdslib.isType '"String",
                  completionTimeoutCheckerInterval =
                    _js2n__-prdslib.isType '"String",
                  completionTimeoutExpression =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate",
                  correlationExpression =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  discardOnAggregationFailure = _js2n__-prdslib.isType '"Bool",
                  discardOnCompletionTimeout = _js2n__-prdslib.isType '"Bool",
                  eagerCheckCompletion = _js2n__-prdslib.isType '"Bool",
                  executorService = _js2n__-prdslib.isType '"String",
                  forceCompletionOnStop = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  ignoreInvalidCorrelationKeys = _js2n__-prdslib.isType '"Bool",
                  optimisticLockRetryPolicy =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OptimisticLockRetryPolicyDefinition!predicate",
                  optimisticLocking = _js2n__-prdslib.isType '"Bool",
                  parallelProcessing = _js2n__-prdslib.isType '"Bool",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  timeoutCheckerExecutorService =
                    _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.BeanDefinition!predicate"
        | doc "Calls a Java bean"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      beanType = _js2n__-prdslib.isType '"String",
                      description = _js2n__-prdslib.isType '"String",
                      disabled = _js2n__-prdslib.isType '"Bool",
                      id = _js2n__-prdslib.isType '"String",
                      method = _js2n__-prdslib.isType '"String",
                      ref = _js2n__-prdslib.isType '"String",
                      scope =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "Singleton", "Request", "Prototype" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.BeanFactoryDefinition!predicate"
        | doc "Define custom beans that can be used in your Camel routes and in general."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  builderClass = _js2n__-prdslib.isType '"String",
                  builderMethod = _js2n__-prdslib.isType '"String",
                  constructors = _js2n__-prdslib.isType 'Record,
                  destroyMethod = _js2n__-prdslib.isType '"String",
                  factoryBean = _js2n__-prdslib.isType '"String",
                  factoryMethod = _js2n__-prdslib.isType '"String",
                  initMethod = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  properties = _js2n__-prdslib.isType 'Record,
                  script = _js2n__-prdslib.isType '"String",
                  scriptLanguage = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.CatchDefinition!predicate"
        | doc "Catches exceptions as part of a try, catch, finally block"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exception =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  onWhen =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnWhenDefinition!predicate",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ChoiceDefinition!predicate"
        | doc "Route messages based on a series of predicates"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  otherwise =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OtherwiseDefinition!predicate",
                  precondition = _js2n__-prdslib.isType '"Bool",
                  when =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.WhenDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.CircuitBreakerDefinition!predicate"
        | doc "Route messages in a fault tolerance way using Circuit Breaker"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configuration = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  faultToleranceConfiguration =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.FaultToleranceConfigurationDefinition!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  onFallback =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnFallbackDefinition!predicate",
                  resilience4jConfiguration =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.Resilience4jConfigurationDefinition!predicate",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ClaimCheckDefinition!predicate"
        | doc "The Claim Check EIP allows you to replace message content with a claim check (a unique key), which can be used to retrieve the message content at a later time."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aggregationStrategy = _js2n__-prdslib.isType '"String",
                  aggregationStrategyMethodName =
                    _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  filter = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  operation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Get", "GetAndRemove", "Set", "Push", "Pop" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ConvertBodyDefinition!predicate"
        | doc "Converts the message body to another type"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          charset = _js2n__-prdslib.isType '"String",
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          mandatory = _js2n__-prdslib.isType '"Bool",
                          type = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ConvertHeaderDefinition!predicate"
        | doc "Converts the message header to another type"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  charset = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  mandatory = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  toName = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ConvertVariableDefinition!predicate"
        | doc "Converts the variable to another type"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  charset = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  mandatory = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  toName = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.DelayDefinition!predicate"
        | doc "Delays processing for a specified length of time"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  asyncDelayed = _js2n__-prdslib.isType '"Bool",
                  callerRunsWhenRejected = _js2n__-prdslib.isType '"Bool",
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  executorService = _js2n__-prdslib.isType '"String",
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.DynamicRouterDefinition!predicate"
        | doc "Route messages based on dynamic rules"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  cacheSize = _js2n__-prdslib.isType '"Number",
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  ignoreInvalidEndpoints = _js2n__-prdslib.isType '"Bool",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  uriDelimiter = _js2n__-prdslib.isType '"String",
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.EnrichDefinition!predicate"
        | doc "Enriches a message with data from a secondary resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  aggregateOnException = _js2n__-prdslib.isType '"Bool",
                  aggregationStrategy = _js2n__-prdslib.isType '"String",
                  aggregationStrategyMethodAllowNull =
                    _js2n__-prdslib.isType '"String",
                  aggregationStrategyMethodName =
                    _js2n__-prdslib.isType '"String",
                  allowOptimisedComponents = _js2n__-prdslib.isType '"Bool",
                  autoStartComponents = _js2n__-prdslib.isType '"Bool",
                  cacheSize = _js2n__-prdslib.isType '"Number",
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  ignoreInvalidEndpoint = _js2n__-prdslib.isType '"Bool",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  shareUnitOfWork = _js2n__-prdslib.isType '"Bool",
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  variableReceive = _js2n__-prdslib.isType '"String",
                  variableSend = _js2n__-prdslib.isType '"String",
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ErrorHandlerDefinition!predicate"
        | doc "Camel error handling."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "deadLetterChannel" ],
                      _js2n__-prdslib.records.record
                        {
                          deadLetterChannel =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.DeadLetterChannelDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "deadLetterChannel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "defaultErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "jtaTransactionErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "noErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "refErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "springTransactionErrorHandler" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "defaultErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          defaultErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.DefaultErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "jtaTransactionErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          jtaTransactionErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.JtaTransactionErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "noErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          noErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.NoErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "refErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          refErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.RefErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "springTransactionErrorHandler" ],
                      _js2n__-prdslib.records.record
                        {
                          springTransactionErrorHandler =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.errorhandler.SpringTransactionErrorHandlerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  deadLetterChannel = _js2n__-prdslib.always,
                  defaultErrorHandler = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  jtaTransactionErrorHandler = _js2n__-prdslib.always,
                  noErrorHandler = _js2n__-prdslib.always,
                  refErrorHandler = _js2n__-prdslib.always,
                  springTransactionErrorHandler = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "constant" ],
                      _js2n__-prdslib.records.record
                        {
                          constant =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ConstantExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "csimple" ],
                      _js2n__-prdslib.records.record
                        {
                          csimple =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.CSimpleExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "datasonnet" ],
                      _js2n__-prdslib.records.record
                        {
                          datasonnet =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.DatasonnetExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "exchangeProperty" ],
                      _js2n__-prdslib.records.record
                        {
                          exchangeProperty =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExchangePropertyExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "groovy" ],
                      _js2n__-prdslib.records.record
                        {
                          groovy =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.GroovyExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "header" ],
                      _js2n__-prdslib.records.record
                        {
                          header =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.HeaderExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "hl7terser" ],
                      _js2n__-prdslib.records.record
                        {
                          hl7terser =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.Hl7TerserExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "java" ],
                      _js2n__-prdslib.records.record
                        {
                          java =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JavaExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "joor" ],
                      _js2n__-prdslib.records.record
                        {
                          joor =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JoorExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jq" ],
                      _js2n__-prdslib.records.record
                        {
                          jq =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JqExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "js" ],
                      _js2n__-prdslib.records.record
                        {
                          js =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JavaScriptExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jsonpath" ],
                      _js2n__-prdslib.records.record
                        {
                          jsonpath =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JsonPathExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "language" ],
                      _js2n__-prdslib.records.record
                        {
                          language =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.LanguageExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "method" ],
                      _js2n__-prdslib.records.record
                        {
                          method =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.MethodCallExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mvel" ],
                      _js2n__-prdslib.records.record
                        {
                          mvel =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.MvelExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "ognl" ],
                      _js2n__-prdslib.records.record
                        {
                          ognl =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.OgnlExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "python" ],
                      _js2n__-prdslib.records.record
                        {
                          python =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.PythonExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "ref" ],
                      _js2n__-prdslib.records.record
                        {
                          ref =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.RefExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "simple" ],
                      _js2n__-prdslib.records.record
                        {
                          simple =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.SimpleExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "spel" ],
                      _js2n__-prdslib.records.record
                        {
                          spel =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.SpELExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "tokenize" ],
                      _js2n__-prdslib.records.record
                        {
                          tokenize =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.TokenizerExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "variable" ],
                      _js2n__-prdslib.records.record
                        {
                          variable =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.VariableExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "wasm" ],
                      _js2n__-prdslib.records.record
                        {
                          wasm =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.WasmExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "xpath" ],
                      _js2n__-prdslib.records.record
                        {
                          xpath =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.XPathExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "xquery" ],
                      _js2n__-prdslib.records.record
                        {
                          xquery =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.XQueryExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "xtokenize" ],
                      _js2n__-prdslib.records.record
                        {
                          xtokenize =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.XMLTokenizerExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  exchangeProperty = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.FaultToleranceConfigurationDefinition!predicate"
        | doc "MicroProfile Fault Tolerance Circuit Breaker EIP configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bulkheadEnabled = _js2n__-prdslib.isType '"Bool",
                  bulkheadExecutorService = _js2n__-prdslib.isType '"String",
                  bulkheadMaxConcurrentCalls = _js2n__-prdslib.isType '"Number",
                  bulkheadWaitingTaskQueue = _js2n__-prdslib.isType '"Number",
                  circuitBreaker = _js2n__-prdslib.isType '"String",
                  delay = _js2n__-prdslib.isType '"String",
                  failureRatio = _js2n__-prdslib.isType '"Number",
                  id = _js2n__-prdslib.isType '"String",
                  requestVolumeThreshold = _js2n__-prdslib.isType '"Number",
                  successThreshold = _js2n__-prdslib.isType '"Number",
                  timeoutDuration = _js2n__-prdslib.isType '"String",
                  timeoutEnabled = _js2n__-prdslib.isType '"Bool",
                  timeoutPoolSize = _js2n__-prdslib.isType '"Number",
                  timeoutScheduledExecutorService =
                    _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.FilterDefinition!predicate"
        | doc "Filter out messages based using a predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  statusPropertyName = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.FinallyDefinition!predicate"
        | doc "Path traversed when a try, catch, finally block exits"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.FromDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "steps", "uri" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  parameters = _js2n__-prdslib.isType 'Record,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  uri = _js2n__-prdslib.isType '"String",
                  variableReceive = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.IdempotentConsumerDefinition!predicate"
        | doc "Filters out duplicate messages"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "idempotentRepository" ],
              _js2n__-prdslib.records.record
                {
                  completionEager = _js2n__-prdslib.isType '"Bool",
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  eager = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  idempotentRepository = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  removeOnFailure = _js2n__-prdslib.isType '"Bool",
                  simple = _js2n__-prdslib.always,
                  skipDuplicate = _js2n__-prdslib.isType '"Bool",
                  spel = _js2n__-prdslib.always,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.InputTypeDefinition!predicate"
        | doc "Set the expected data type of the input message. If the actual message type is different at runtime, camel look for a required Transformer and apply if exists. If validate attribute is true then camel applies Validator as well. Type name consists of two parts, 'scheme' and 'name' connected with ':'. For Java type 'name' is a fully qualified class name. For example {code java:java.lang.String} , {code json:ABCOrder} . It's also possible to specify only scheme part, so that it works like a wildcard. If only 'xml' is specified, all the XML message matches. It's handy to add only one transformer/validator for all the transformation from/to XML."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "urn" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  urn = _js2n__-prdslib.isType '"String",
                  validate = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.InterceptDefinition!predicate"
        | doc "Intercepts a message at each step in the route"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  onWhen =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnWhenDefinition!predicate",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.InterceptFromDefinition!predicate"
        | doc "Intercepts incoming messages"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      description = _js2n__-prdslib.isType '"String",
                      disabled = _js2n__-prdslib.isType '"Bool",
                      id = _js2n__-prdslib.isType '"String",
                      onWhen =
                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnWhenDefinition!predicate",
                      steps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                            ],
                      uri = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.InterceptSendToEndpointDefinition!predicate"
        | doc "Intercepts messages being sent to an endpoint"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          afterUri = _js2n__-prdslib.isType '"String",
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          onWhen =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnWhenDefinition!predicate",
                          skipSendToOriginalEndpoint =
                            _js2n__-prdslib.isType '"String",
                          steps =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                                ],
                          uri = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "uri" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.KameletDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          name = _js2n__-prdslib.isType '"String",
                          parameters = _js2n__-prdslib.isType 'Record,
                          steps =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                                ],
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.LoadBalanceDefinition!predicate"
        | doc "Balances message processing among a number of nodes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "customLoadBalancer" ],
                      _js2n__-prdslib.records.record
                        {
                          customLoadBalancer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.CustomLoadBalancerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "customLoadBalancer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "failoverLoadBalancer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "randomLoadBalancer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "roundRobinLoadBalancer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "stickyLoadBalancer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "topicLoadBalancer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "weightedLoadBalancer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "failoverLoadBalancer" ],
                      _js2n__-prdslib.records.record
                        {
                          failoverLoadBalancer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.FailoverLoadBalancerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "randomLoadBalancer" ],
                      _js2n__-prdslib.records.record
                        {
                          randomLoadBalancer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.RandomLoadBalancerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "roundRobinLoadBalancer" ],
                      _js2n__-prdslib.records.record
                        {
                          roundRobinLoadBalancer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.RoundRobinLoadBalancerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "stickyLoadBalancer" ],
                      _js2n__-prdslib.records.record
                        {
                          stickyLoadBalancer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.StickyLoadBalancerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "topicLoadBalancer" ],
                      _js2n__-prdslib.records.record
                        {
                          topicLoadBalancer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.TopicLoadBalancerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "weightedLoadBalancer" ],
                      _js2n__-prdslib.records.record
                        {
                          weightedLoadBalancer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.WeightedLoadBalancerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  customLoadBalancer = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  failoverLoadBalancer = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  randomLoadBalancer = _js2n__-prdslib.always,
                  roundRobinLoadBalancer = _js2n__-prdslib.always,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  stickyLoadBalancer = _js2n__-prdslib.always,
                  topicLoadBalancer = _js2n__-prdslib.always,
                  weightedLoadBalancer = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.LogDefinition!predicate"
        | doc "Used for printing custom messages to the logger."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          logLanguage = _js2n__-prdslib.isType '"String",
                          logName = _js2n__-prdslib.isType '"String",
                          logger = _js2n__-prdslib.isType '"String",
                          loggingLevel =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "TRACE",
                                      "DEBUG",
                                      "INFO",
                                      "WARN",
                                      "ERROR",
                                      "OFF"
                                    ]
                                ],
                          marker = _js2n__-prdslib.isType '"String",
                          message = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "message" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.LoopDefinition!predicate"
        | doc "Processes a message multiple times"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  breakOnShutdown = _js2n__-prdslib.isType '"Bool",
                  constant = _js2n__-prdslib.always,
                  copy = _js2n__-prdslib.isType '"Bool",
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  doWhile = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.MarshalDefinition!predicate"
        | doc "Marshals data into a specified format for transmission over a transport or component"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "asn1" ],
                      _js2n__-prdslib.records.record
                        {
                          asn1 =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ASN1DataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "asn1" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "avro" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "barcode" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "base64" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "beanio" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "bindy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "cbor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "crypto" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csv" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "custom" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "fhirJson" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "fhirXml" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "flatpack" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "fury" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "grok" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "gzipDeflater" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ical" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jacksonXml" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jaxb" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "json" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonApi" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "lzf" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "mimeMultipart" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "parquetAvro" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "pgp" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "protobuf" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "rss" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "smooks" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "soap" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "swiftMt" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "swiftMx" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "syslog" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tarFile" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "thrift" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tidyMarkup" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "univocityCsv" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "univocityFixed" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "univocityTsv" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xmlSecurity" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "yaml" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "zipDeflater" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "zipFile" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "avro" ],
                      _js2n__-prdslib.records.record
                        {
                          avro =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.AvroDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "barcode" ],
                      _js2n__-prdslib.records.record
                        {
                          barcode =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.BarcodeDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "base64" ],
                      _js2n__-prdslib.records.record
                        {
                          base64 =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.Base64DataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "beanio" ],
                      _js2n__-prdslib.records.record
                        {
                          beanio =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.BeanioDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "bindy" ],
                      _js2n__-prdslib.records.record
                        {
                          bindy =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.BindyDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "cbor" ],
                      _js2n__-prdslib.records.record
                        {
                          cbor =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CBORDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "crypto" ],
                      _js2n__-prdslib.records.record
                        {
                          crypto =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CryptoDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "csv" ],
                      _js2n__-prdslib.records.record
                        {
                          csv =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CsvDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "custom" ],
                      _js2n__-prdslib.records.record
                        {
                          custom =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CustomDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "fhirJson" ],
                      _js2n__-prdslib.records.record
                        {
                          fhirJson =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FhirJsonDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "fhirXml" ],
                      _js2n__-prdslib.records.record
                        {
                          fhirXml =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FhirXmlDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "flatpack" ],
                      _js2n__-prdslib.records.record
                        {
                          flatpack =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FlatpackDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "fury" ],
                      _js2n__-prdslib.records.record
                        {
                          fury =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FuryDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "grok" ],
                      _js2n__-prdslib.records.record
                        {
                          grok =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.GrokDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "gzipDeflater" ],
                      _js2n__-prdslib.records.record
                        {
                          gzipDeflater =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.GzipDeflaterDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "hl7" ],
                      _js2n__-prdslib.records.record
                        {
                          hl7 =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.HL7DataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "ical" ],
                      _js2n__-prdslib.records.record
                        {
                          ical =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.IcalDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jacksonXml" ],
                      _js2n__-prdslib.records.record
                        {
                          jacksonXml =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JacksonXMLDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jaxb" ],
                      _js2n__-prdslib.records.record
                        {
                          jaxb =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JaxbDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "json" ],
                      _js2n__-prdslib.records.record
                        {
                          json =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JsonDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jsonApi" ],
                      _js2n__-prdslib.records.record
                        {
                          jsonApi =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JsonApiDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "lzf" ],
                      _js2n__-prdslib.records.record
                        {
                          lzf =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.LZFDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mimeMultipart" ],
                      _js2n__-prdslib.records.record
                        {
                          mimeMultipart =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.MimeMultipartDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "parquetAvro" ],
                      _js2n__-prdslib.records.record
                        {
                          parquetAvro =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ParquetAvroDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "pgp" ],
                      _js2n__-prdslib.records.record
                        {
                          pgp =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.PGPDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "protobuf" ],
                      _js2n__-prdslib.records.record
                        {
                          protobuf =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ProtobufDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "rss" ],
                      _js2n__-prdslib.records.record
                        {
                          rss =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.RssDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "smooks" ],
                      _js2n__-prdslib.records.record
                        {
                          smooks =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SmooksDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "soap" ],
                      _js2n__-prdslib.records.record
                        {
                          soap =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SoapDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "swiftMt" ],
                      _js2n__-prdslib.records.record
                        {
                          swiftMt =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SwiftMtDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "swiftMx" ],
                      _js2n__-prdslib.records.record
                        {
                          swiftMx =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SwiftMxDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "syslog" ],
                      _js2n__-prdslib.records.record
                        {
                          syslog =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SyslogDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "tarFile" ],
                      _js2n__-prdslib.records.record
                        {
                          tarFile =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.TarFileDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "thrift" ],
                      _js2n__-prdslib.records.record
                        {
                          thrift =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ThriftDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "tidyMarkup" ],
                      _js2n__-prdslib.records.record
                        {
                          tidyMarkup =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.TidyMarkupDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "univocityCsv" ],
                      _js2n__-prdslib.records.record
                        {
                          univocityCsv =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityCsvDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "univocityFixed" ],
                      _js2n__-prdslib.records.record
                        {
                          univocityFixed =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityFixedDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "univocityTsv" ],
                      _js2n__-prdslib.records.record
                        {
                          univocityTsv =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityTsvDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "xmlSecurity" ],
                      _js2n__-prdslib.records.record
                        {
                          xmlSecurity =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.XMLSecurityDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "yaml" ],
                      _js2n__-prdslib.records.record
                        {
                          yaml =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.YAMLDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "zipDeflater" ],
                      _js2n__-prdslib.records.record
                        {
                          zipDeflater =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ZipDeflaterDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "zipFile" ],
                      _js2n__-prdslib.records.record
                        {
                          zipFile =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ZipFileDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  asn1 = _js2n__-prdslib.always,
                  avro = _js2n__-prdslib.always,
                  barcode = _js2n__-prdslib.always,
                  base64 = _js2n__-prdslib.always,
                  beanio = _js2n__-prdslib.always,
                  bindy = _js2n__-prdslib.always,
                  cbor = _js2n__-prdslib.always,
                  crypto = _js2n__-prdslib.always,
                  csv = _js2n__-prdslib.always,
                  custom = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  fhirJson = _js2n__-prdslib.always,
                  fhirXml = _js2n__-prdslib.always,
                  flatpack = _js2n__-prdslib.always,
                  fury = _js2n__-prdslib.always,
                  grok = _js2n__-prdslib.always,
                  gzipDeflater = _js2n__-prdslib.always,
                  hl7 = _js2n__-prdslib.always,
                  ical = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  jacksonXml = _js2n__-prdslib.always,
                  jaxb = _js2n__-prdslib.always,
                  json = _js2n__-prdslib.always,
                  jsonApi = _js2n__-prdslib.always,
                  lzf = _js2n__-prdslib.always,
                  mimeMultipart = _js2n__-prdslib.always,
                  parquetAvro = _js2n__-prdslib.always,
                  pgp = _js2n__-prdslib.always,
                  protobuf = _js2n__-prdslib.always,
                  rss = _js2n__-prdslib.always,
                  smooks = _js2n__-prdslib.always,
                  soap = _js2n__-prdslib.always,
                  swiftMt = _js2n__-prdslib.always,
                  swiftMx = _js2n__-prdslib.always,
                  syslog = _js2n__-prdslib.always,
                  tarFile = _js2n__-prdslib.always,
                  thrift = _js2n__-prdslib.always,
                  tidyMarkup = _js2n__-prdslib.always,
                  univocityCsv = _js2n__-prdslib.always,
                  univocityFixed = _js2n__-prdslib.always,
                  univocityTsv = _js2n__-prdslib.always,
                  variableReceive = _js2n__-prdslib.isType '"String",
                  variableSend = _js2n__-prdslib.isType '"String",
                  xmlSecurity = _js2n__-prdslib.always,
                  yaml = _js2n__-prdslib.always,
                  zipDeflater = _js2n__-prdslib.always,
                  zipFile = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.MulticastDefinition!predicate"
        | doc "Routes the same message to multiple paths either sequentially or in parallel."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aggregationStrategy = _js2n__-prdslib.isType '"String",
                  aggregationStrategyMethodAllowNull =
                    _js2n__-prdslib.isType '"Bool",
                  aggregationStrategyMethodName =
                    _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  executorService = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  onPrepare = _js2n__-prdslib.isType '"String",
                  parallelAggregate = _js2n__-prdslib.isType '"Bool",
                  parallelProcessing = _js2n__-prdslib.isType '"Bool",
                  shareUnitOfWork = _js2n__-prdslib.isType '"Bool",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  stopOnException = _js2n__-prdslib.isType '"Bool",
                  streaming = _js2n__-prdslib.isType '"Bool",
                  synchronous = _js2n__-prdslib.isType '"Bool",
                  timeout = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.OnCompletionDefinition!predicate"
        | doc "Route to be executed when normal route processing completes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  executorService = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "AfterConsumer", "BeforeConsumer" ]
                        ],
                  onCompleteOnly = _js2n__-prdslib.isType '"Bool",
                  onFailureOnly = _js2n__-prdslib.isType '"Bool",
                  onWhen =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnWhenDefinition!predicate",
                  parallelProcessing = _js2n__-prdslib.isType '"Bool",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  useOriginalMessage = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.OnExceptionDefinition!predicate"
        | doc "Route to be executed when an exception is thrown"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  continued =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exception =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  handled =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  onExceptionOccurredRef = _js2n__-prdslib.isType '"String",
                  onRedeliveryRef = _js2n__-prdslib.isType '"String",
                  onWhen =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnWhenDefinition!predicate",
                  redeliveryPolicy =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RedeliveryPolicyDefinition!predicate",
                  redeliveryPolicyRef = _js2n__-prdslib.isType '"String",
                  retryWhile =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  useOriginalBody = _js2n__-prdslib.isType '"Bool",
                  useOriginalMessage = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.OnFallbackDefinition!predicate"
        | doc "Route to be executed when Circuit Breaker EIP executes fallback"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  fallbackViaNetwork = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.OnWhenDefinition!predicate"
        | doc "To use a predicate to determine when to trigger this."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.OptimisticLockRetryPolicyDefinition!predicate"
        | doc "To configure optimistic locking"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exponentialBackOff = _js2n__-prdslib.isType '"Bool",
                  maximumRetries = _js2n__-prdslib.isType '"Number",
                  maximumRetryDelay = _js2n__-prdslib.isType '"String",
                  randomBackOff = _js2n__-prdslib.isType '"Bool",
                  retryDelay = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.OtherwiseDefinition!predicate"
        | doc "Route to be executed when all other choices evaluate to false"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.OutputTypeDefinition!predicate"
        | doc "Set the expected data type of the output message. If the actual message type is different at runtime, camel look for a required Transformer and apply if exists. If validate attribute is true then camel applies Validator as well. Type name consists of two parts, 'scheme' and 'name' connected with ':'. For Java type 'name' is a fully qualified class name. For example {code java:java.lang.String} , {code json:ABCOrder} . It's also possible to specify only scheme part, so that it works like a wildcard. If only 'xml' is specified, all the XML message matches. It's handy to add only one transformer/validator for all the XML-Java transformation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "urn" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  urn = _js2n__-prdslib.isType '"String",
                  validate = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.PausableDefinition!predicate"
        | doc "Pausable EIP to support resuming processing from last known offset."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "consumerListener", "untilCheck" ],
              _js2n__-prdslib.records.record
                {
                  consumerListener = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  untilCheck = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.PipelineDefinition!predicate"
        | doc "Routes the message to a sequence of processors."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.PolicyDefinition!predicate"
        | doc "Defines a policy the route will use"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "ref" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  ref = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.PollDefinition!predicate"
        | doc "Polls a message from a static endpoint"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          parameters = _js2n__-prdslib.isType 'Record,
                          timeout = _js2n__-prdslib.isType '"String",
                          uri = _js2n__-prdslib.isType '"String",
                          variableReceive = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "uri" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.PollEnrichDefinition!predicate"
        | doc "Enriches messages with data polled from a secondary resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  aggregateOnException = _js2n__-prdslib.isType '"Bool",
                  aggregationStrategy = _js2n__-prdslib.isType '"String",
                  aggregationStrategyMethodAllowNull =
                    _js2n__-prdslib.isType '"String",
                  aggregationStrategyMethodName =
                    _js2n__-prdslib.isType '"String",
                  autoStartComponents = _js2n__-prdslib.isType '"Bool",
                  cacheSize = _js2n__-prdslib.isType '"Number",
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  ignoreInvalidEndpoint = _js2n__-prdslib.isType '"Bool",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  timeout = _js2n__-prdslib.isType '"String",
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  variableReceive = _js2n__-prdslib.isType '"String",
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ProcessDefinition!predicate"
        | doc "Calls a Camel processor"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "ref" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  ref = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.maxProperties 1,
              _js2n__-prdslib.records.record
                {
                  aggregate =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.AggregateDefinition!predicate",
                  bean =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.BeanDefinition!predicate",
                  choice =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ChoiceDefinition!predicate",
                  circuitBreaker =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.CircuitBreakerDefinition!predicate",
                  claimCheck =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ClaimCheckDefinition!predicate",
                  convertBodyTo =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ConvertBodyDefinition!predicate",
                  convertHeaderTo =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ConvertHeaderDefinition!predicate",
                  convertVariableTo =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ConvertVariableDefinition!predicate",
                  delay =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.DelayDefinition!predicate",
                  doCatch =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.CatchDefinition!predicate",
                  doFinally =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.FinallyDefinition!predicate",
                  doTry =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.TryDefinition!predicate",
                  dynamicRouter =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.DynamicRouterDefinition!predicate",
                  enrich =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.EnrichDefinition!predicate",
                  filter =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.FilterDefinition!predicate",
                  idempotentConsumer =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.IdempotentConsumerDefinition!predicate",
                  kamelet =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.KameletDefinition!predicate",
                  loadBalance =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.LoadBalanceDefinition!predicate",
                  log =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.LogDefinition!predicate",
                  loop =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.LoopDefinition!predicate",
                  marshal =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.MarshalDefinition!predicate",
                  multicast =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.MulticastDefinition!predicate",
                  pausable =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PausableDefinition!predicate",
                  pipeline =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PipelineDefinition!predicate",
                  policy =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PolicyDefinition!predicate",
                  poll =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PollDefinition!predicate",
                  pollEnrich =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PollEnrichDefinition!predicate",
                  process =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessDefinition!predicate",
                  recipientList =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RecipientListDefinition!predicate",
                  removeHeader =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RemoveHeaderDefinition!predicate",
                  removeHeaders =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RemoveHeadersDefinition!predicate",
                  removeProperties =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RemovePropertiesDefinition!predicate",
                  removeProperty =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RemovePropertyDefinition!predicate",
                  removeVariable =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RemoveVariableDefinition!predicate",
                  resequence =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ResequenceDefinition!predicate",
                  resumable =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ResumableDefinition!predicate",
                  rollback =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RollbackDefinition!predicate",
                  routingSlip =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RoutingSlipDefinition!predicate",
                  saga =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SagaDefinition!predicate",
                  sample =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SamplingDefinition!predicate",
                  script =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ScriptDefinition!predicate",
                  serviceCall =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.ServiceCallDefinition!predicate",
                  setBody =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SetBodyDefinition!predicate",
                  setExchangePattern =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SetExchangePatternDefinition!predicate",
                  setHeader =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SetHeaderDefinition!predicate",
                  setHeaders =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SetHeadersDefinition!predicate",
                  setProperty =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SetPropertyDefinition!predicate",
                  setVariable =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SetVariableDefinition!predicate",
                  setVariables =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SetVariablesDefinition!predicate",
                  sort =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SortDefinition!predicate",
                  split =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SplitDefinition!predicate",
                  step =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.StepDefinition!predicate",
                  stop =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.StopDefinition!predicate",
                  threads =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ThreadsDefinition!predicate",
                  throttle =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ThrottleDefinition!predicate",
                  throwException =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ThrowExceptionDefinition!predicate",
                  to =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ToDefinition!predicate",
                  toD =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ToDynamicDefinition!predicate",
                  tokenizer =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.TokenizerDefinition!predicate",
                  transacted =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.TransactedDefinition!predicate",
                  transform =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.TransformDefinition!predicate",
                  unmarshal =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.UnmarshalDefinition!predicate",
                  validate =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ValidateDefinition!predicate",
                  wireTap =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.WireTapDefinition!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
        | doc "A key value pair where the value is a literal value"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "value" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.PropertyExpressionDefinition!predicate"
        | doc "A key value pair where the value is an expression."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  key = _js2n__-prdslib.isType '"String",
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RecipientListDefinition!predicate"
        | doc "Route messages to a number of dynamically specified recipients"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  aggregationStrategy = _js2n__-prdslib.isType '"String",
                  aggregationStrategyMethodAllowNull =
                    _js2n__-prdslib.isType '"Bool",
                  aggregationStrategyMethodName =
                    _js2n__-prdslib.isType '"String",
                  cacheSize = _js2n__-prdslib.isType '"Number",
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  delimiter = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  executorService = _js2n__-prdslib.isType '"String",
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  ignoreInvalidEndpoints = _js2n__-prdslib.isType '"Bool",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  onPrepare = _js2n__-prdslib.isType '"String",
                  parallelAggregate = _js2n__-prdslib.isType '"Bool",
                  parallelProcessing = _js2n__-prdslib.isType '"Bool",
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  shareUnitOfWork = _js2n__-prdslib.isType '"Bool",
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  stopOnException = _js2n__-prdslib.isType '"Bool",
                  streaming = _js2n__-prdslib.isType '"Bool",
                  synchronous = _js2n__-prdslib.isType '"Bool",
                  timeout = _js2n__-prdslib.isType '"String",
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RedeliveryPolicyDefinition!predicate"
        | doc "To configure re-delivery for error handling"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowRedeliveryWhileStopping = _js2n__-prdslib.isType '"Bool",
                  asyncDelayedRedelivery = _js2n__-prdslib.isType '"Bool",
                  backOffMultiplier = _js2n__-prdslib.isType '"Number",
                  collisionAvoidanceFactor = _js2n__-prdslib.isType '"Number",
                  delayPattern = _js2n__-prdslib.isType '"String",
                  disableRedelivery = _js2n__-prdslib.isType '"Bool",
                  exchangeFormatterRef = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  logContinued = _js2n__-prdslib.isType '"Bool",
                  logExhausted = _js2n__-prdslib.isType '"Bool",
                  logExhaustedMessageBody = _js2n__-prdslib.isType '"Bool",
                  logExhaustedMessageHistory = _js2n__-prdslib.isType '"Bool",
                  logHandled = _js2n__-prdslib.isType '"Bool",
                  logNewException = _js2n__-prdslib.isType '"Bool",
                  logRetryAttempted = _js2n__-prdslib.isType '"Bool",
                  logRetryStackTrace = _js2n__-prdslib.isType '"Bool",
                  logStackTrace = _js2n__-prdslib.isType '"Bool",
                  maximumRedeliveries = _js2n__-prdslib.isType '"Number",
                  maximumRedeliveryDelay = _js2n__-prdslib.isType '"String",
                  redeliveryDelay = _js2n__-prdslib.isType '"String",
                  retriesExhaustedLogLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" ]
                        ],
                  retryAttemptedLogInterval = _js2n__-prdslib.isType '"Number",
                  retryAttemptedLogLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" ]
                        ],
                  useCollisionAvoidance = _js2n__-prdslib.isType '"Bool",
                  useExponentialBackOff = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RemoveHeaderDefinition!predicate"
        | doc "Removes a named header from the message"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          name = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RemoveHeadersDefinition!predicate"
        | doc "Removes message headers whose name matches a specified pattern"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          excludePattern = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          pattern = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "pattern" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RemovePropertiesDefinition!predicate"
        | doc "Removes message exchange properties whose name matches a specified pattern"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          excludePattern = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          pattern = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "pattern" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RemovePropertyDefinition!predicate"
        | doc "Removes a named property from the message exchange"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          name = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RemoveVariableDefinition!predicate"
        | doc "Removes a named variable"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          name = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ResequenceDefinition!predicate"
        | doc "Resequences (re-order) messages based on an expression"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "expression" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "constant" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "csimple" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "datasonnet" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "exchangeProperty" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "groovy" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "header" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "hl7terser" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "java" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "joor" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "jq" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "js" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "jsonpath" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "language" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "method" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "mvel" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "ognl" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "python" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "ref" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "simple" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "spel" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "tokenize" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "variable" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "wasm" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "xpath" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "xquery" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "xtokenize" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]
                          ]),
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "expression" ],
                          _js2n__-prdslib.records.record
                            {
                              expression =
                                _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "batchConfig" ],
                          _js2n__-prdslib.records.record
                            {
                              batchConfig =
                                _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.config.BatchResequencerConfig!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "batchConfig" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "streamConfig" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]
                          ]),
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "streamConfig" ],
                          _js2n__-prdslib.records.record
                            {
                              streamConfig =
                                _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.config.StreamResequencerConfig!predicate",
                            } {} true _js2n__-prdslib.always
                        ]
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  batchConfig = _js2n__-prdslib.always,
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  streamConfig = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.Resilience4jConfigurationDefinition!predicate"
        | doc "Resilience4j Circuit Breaker EIP configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  automaticTransitionFromOpenToHalfOpenEnabled =
                    _js2n__-prdslib.isType '"Bool",
                  bulkheadEnabled = _js2n__-prdslib.isType '"Bool",
                  bulkheadMaxConcurrentCalls = _js2n__-prdslib.isType '"Number",
                  bulkheadMaxWaitDuration = _js2n__-prdslib.isType '"Number",
                  circuitBreaker = _js2n__-prdslib.isType '"String",
                  config = _js2n__-prdslib.isType '"String",
                  failureRateThreshold = _js2n__-prdslib.isType '"Number",
                  id = _js2n__-prdslib.isType '"String",
                  ignoreException =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  minimumNumberOfCalls = _js2n__-prdslib.isType '"Number",
                  permittedNumberOfCallsInHalfOpenState =
                    _js2n__-prdslib.isType '"Number",
                  recordException =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  slidingWindowSize = _js2n__-prdslib.isType '"Number",
                  slidingWindowType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "TIME_BASED", "COUNT_BASED" ]
                        ],
                  slowCallDurationThreshold = _js2n__-prdslib.isType '"Number",
                  slowCallRateThreshold = _js2n__-prdslib.isType '"Number",
                  throwExceptionWhenHalfOpenOrOpenState =
                    _js2n__-prdslib.isType '"Bool",
                  timeoutCancelRunningFuture = _js2n__-prdslib.isType '"Bool",
                  timeoutDuration = _js2n__-prdslib.isType '"Number",
                  timeoutEnabled = _js2n__-prdslib.isType '"Bool",
                  timeoutExecutorService = _js2n__-prdslib.isType '"String",
                  waitDurationInOpenState = _js2n__-prdslib.isType '"Number",
                  writableStackTraceEnabled = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ResumableDefinition!predicate"
        | doc "Resume EIP to support resuming processing from last known offset."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "resumeStrategy" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  intermittent = _js2n__-prdslib.isType '"Bool",
                  loggingLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" ]
                        ],
                  resumeStrategy = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RollbackDefinition!predicate"
        | doc "Forces a rollback by stopping routing the message"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      description = _js2n__-prdslib.isType '"String",
                      disabled = _js2n__-prdslib.isType '"Bool",
                      id = _js2n__-prdslib.isType '"String",
                      markRollbackOnly = _js2n__-prdslib.isType '"Bool",
                      markRollbackOnlyLast = _js2n__-prdslib.isType '"Bool",
                      message = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RouteConfigurationDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  errorHandler =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ErrorHandlerDefinition!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  intercept =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    intercept =
                                      _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.InterceptDefinition!predicate",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  interceptFrom =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    interceptFrom =
                                      _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.InterceptFromDefinition!predicate",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  interceptSendToEndpoint =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    interceptSendToEndpoint =
                                      _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.InterceptSendToEndpointDefinition!predicate",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  onCompletion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    onCompletion =
                                      _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnCompletionDefinition!predicate",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  onException =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    onException =
                                      _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnExceptionDefinition!predicate",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  precondition = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RouteDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from" ],
              _js2n__-prdslib.records.record
                {
                  autoStartup = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  errorHandler =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ErrorHandlerDefinition!predicate",
                  errorHandlerRef = _js2n__-prdslib.isType '"String",
                  from =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.FromDefinition!predicate",
                  group = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  inputType =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.InputTypeDefinition!predicate",
                  logMask = _js2n__-prdslib.isType '"Bool",
                  messageHistory = _js2n__-prdslib.isType '"Bool",
                  nodePrefixId = _js2n__-prdslib.isType '"String",
                  outputType =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OutputTypeDefinition!predicate",
                  precondition = _js2n__-prdslib.isType '"String",
                  routeConfigurationId = _js2n__-prdslib.isType '"String",
                  routePolicy = _js2n__-prdslib.isType '"String",
                  shutdownRoute =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Default", "Defer" ]
                        ],
                  shutdownRunningTask =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "CompleteCurrentTaskOnly", "CompleteAllTasks" ]
                        ],
                  startupOrder = _js2n__-prdslib.isType '"Number",
                  streamCache = _js2n__-prdslib.isType '"Bool",
                  trace = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RouteTemplateDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  beans =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.BeanFactoryDefinition!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  from =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.FromDefinition!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RouteTemplateParameterDefinition!predicate"
                        ],
                  route =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RouteDefinition!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RouteTemplateParameterDefinition!predicate"
        | doc "A route template parameter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  defaultValue = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.RoutingSlipDefinition!predicate"
        | doc "Routes a message through a series of steps that are pre-determined (the slip)"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "expression" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "constant" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "csimple" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "datasonnet" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "exchangeProperty" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "groovy" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "header" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "hl7terser" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "java" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "joor" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "jq" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "js" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "jsonpath" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "language" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "method" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "mvel" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "ognl" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "python" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "ref" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "simple" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "spel" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "tokenize" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "variable" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "wasm" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "xpath" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "xquery" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "xtokenize" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]
                          ]),
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "expression" ],
                          _js2n__-prdslib.records.record
                            {
                              expression =
                                _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.records.record
                    {
                      cacheSize = _js2n__-prdslib.isType '"Number",
                      constant = _js2n__-prdslib.always,
                      csimple = _js2n__-prdslib.always,
                      datasonnet = _js2n__-prdslib.always,
                      description = _js2n__-prdslib.isType '"String",
                      disabled = _js2n__-prdslib.isType '"Bool",
                      exchangeProperty = _js2n__-prdslib.always,
                      expression = _js2n__-prdslib.always,
                      groovy = _js2n__-prdslib.always,
                      header = _js2n__-prdslib.always,
                      hl7terser = _js2n__-prdslib.always,
                      id = _js2n__-prdslib.isType '"String",
                      ignoreInvalidEndpoints = _js2n__-prdslib.isType '"Bool",
                      java = _js2n__-prdslib.always,
                      joor = _js2n__-prdslib.always,
                      jq = _js2n__-prdslib.always,
                      js = _js2n__-prdslib.always,
                      jsonpath = _js2n__-prdslib.always,
                      language = _js2n__-prdslib.always,
                      method = _js2n__-prdslib.always,
                      mvel = _js2n__-prdslib.always,
                      ognl = _js2n__-prdslib.always,
                      python = _js2n__-prdslib.always,
                      ref = _js2n__-prdslib.always,
                      simple = _js2n__-prdslib.always,
                      spel = _js2n__-prdslib.always,
                      tokenize = _js2n__-prdslib.always,
                      uriDelimiter = _js2n__-prdslib.isType '"String",
                      variable = _js2n__-prdslib.always,
                      wasm = _js2n__-prdslib.always,
                      xpath = _js2n__-prdslib.always,
                      xquery = _js2n__-prdslib.always,
                      xtokenize = _js2n__-prdslib.always,
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SagaActionUriDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          parameters = _js2n__-prdslib.isType 'Record,
                          uri = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "uri" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SagaDefinition!predicate"
        | doc "Enables Sagas on the route"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compensation =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SagaActionUriDefinition!predicate",
                  completion =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SagaActionUriDefinition!predicate",
                  completionMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "AUTO", "MANUAL" ]
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  option =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyExpressionDefinition!predicate"
                        ],
                  propagation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "REQUIRED",
                              "REQUIRES_NEW",
                              "MANDATORY",
                              "SUPPORTS",
                              "NOT_SUPPORTED",
                              "NEVER"
                            ]
                        ],
                  sagaService = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  timeout = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SamplingDefinition!predicate"
        | doc "Extract a sample of the messages passing through a route"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      description = _js2n__-prdslib.isType '"String",
                      disabled = _js2n__-prdslib.isType '"Bool",
                      id = _js2n__-prdslib.isType '"String",
                      messageFrequency = _js2n__-prdslib.isType '"Number",
                      samplePeriod = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ScriptDefinition!predicate"
        | doc "Executes a script from a language which does not change the message body."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SetBodyDefinition!predicate"
        | doc "Sets the contents of the message body"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SetExchangePatternDefinition!predicate"
        | doc "Sets the exchange pattern on the message exchange"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      description = _js2n__-prdslib.isType '"String",
                      disabled = _js2n__-prdslib.isType '"Bool",
                      id = _js2n__-prdslib.isType '"String",
                      pattern =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "InOnly", "InOut" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SetHeaderDefinition!predicate"
        | doc "Sets the value of a message header"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  name = _js2n__-prdslib.isType '"String",
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SetHeadersDefinition!predicate"
        | doc "Allows setting multiple headers on the message at the same time."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SetHeaderDefinition!predicate"
                        ],
                  id = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SetPropertyDefinition!predicate"
        | doc "Sets a named property on the message exchange"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  name = _js2n__-prdslib.isType '"String",
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SetVariableDefinition!predicate"
        | doc "Sets the value of a variable"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  name = _js2n__-prdslib.isType '"String",
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SetVariablesDefinition!predicate"
        | doc "Allows setting multiple variables at the same time."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  variables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.SetVariableDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SortDefinition!predicate"
        | doc "Sorts the contents of the message"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  comparator = _js2n__-prdslib.isType '"String",
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.SplitDefinition!predicate"
        | doc "Splits a single message into many sub-messages."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  aggregationStrategy = _js2n__-prdslib.isType '"String",
                  aggregationStrategyMethodAllowNull =
                    _js2n__-prdslib.isType '"Bool",
                  aggregationStrategyMethodName =
                    _js2n__-prdslib.isType '"String",
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  delimiter = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  executorService = _js2n__-prdslib.isType '"String",
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  onPrepare = _js2n__-prdslib.isType '"String",
                  parallelAggregate = _js2n__-prdslib.isType '"Bool",
                  parallelProcessing = _js2n__-prdslib.isType '"Bool",
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  shareUnitOfWork = _js2n__-prdslib.isType '"Bool",
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  stopOnException = _js2n__-prdslib.isType '"Bool",
                  streaming = _js2n__-prdslib.isType '"Bool",
                  synchronous = _js2n__-prdslib.isType '"Bool",
                  timeout = _js2n__-prdslib.isType '"String",
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.StepDefinition!predicate"
        | doc "Routes the message to a sequence of processors which is grouped together as one logical name"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.StopDefinition!predicate"
        | doc "Stops the processing of the current message"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.TemplatedRouteDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "routeTemplateRef" ],
              _js2n__-prdslib.records.record
                {
                  beans =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.BeanFactoryDefinition!predicate"
                        ],
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.TemplatedRouteParameterDefinition!predicate"
                        ],
                  prefixId = _js2n__-prdslib.isType '"String",
                  routeId = _js2n__-prdslib.isType '"String",
                  routeTemplateRef = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.TemplatedRouteParameterDefinition!predicate"
        | doc "An input parameter of a route template."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "value" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ThreadsDefinition!predicate"
        | doc "Specifies that all steps after this node are processed asynchronously"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowCoreThreadTimeOut = _js2n__-prdslib.isType '"Bool",
                  callerRunsWhenRejected = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  executorService = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  keepAliveTime = _js2n__-prdslib.isType '"Number",
                  maxPoolSize = _js2n__-prdslib.isType '"Number",
                  maxQueueSize = _js2n__-prdslib.isType '"Number",
                  poolSize = _js2n__-prdslib.isType '"Number",
                  rejectedPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Abort", "CallerRuns" ]
                        ],
                  threadName = _js2n__-prdslib.isType '"String",
                  timeUnit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "NANOSECONDS",
                              "MICROSECONDS",
                              "MILLISECONDS",
                              "SECONDS",
                              "MINUTES",
                              "HOURS",
                              "DAYS"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ThrottleDefinition!predicate"
        | doc "Controls the rate at which messages are passed to the next node in the route"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  asyncDelayed = _js2n__-prdslib.isType '"Bool",
                  callerRunsWhenRejected = _js2n__-prdslib.isType '"Bool",
                  constant = _js2n__-prdslib.always,
                  correlationExpression =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate",
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  executorService = _js2n__-prdslib.isType '"String",
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TotalRequests", "ConcurrentRequests" ]
                        ],
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  rejectExecution = _js2n__-prdslib.isType '"Bool",
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  timePeriodMillis = _js2n__-prdslib.isType '"String",
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ThrowExceptionDefinition!predicate"
        | doc "Throws an exception"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exceptionType = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  message = _js2n__-prdslib.isType '"String",
                  ref = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ToDefinition!predicate"
        | doc "Sends the message to a static endpoint"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          parameters = _js2n__-prdslib.isType 'Record,
                          pattern =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "InOnly", "InOut" ]
                                ],
                          uri = _js2n__-prdslib.isType '"String",
                          variableReceive = _js2n__-prdslib.isType '"String",
                          variableSend = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "uri" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ToDynamicDefinition!predicate"
        | doc "Sends the message to a dynamic endpoint"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          allowOptimisedComponents =
                            _js2n__-prdslib.isType '"Bool",
                          autoStartComponents = _js2n__-prdslib.isType '"Bool",
                          cacheSize = _js2n__-prdslib.isType '"Number",
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          id = _js2n__-prdslib.isType '"String",
                          ignoreInvalidEndpoint =
                            _js2n__-prdslib.isType '"Bool",
                          parameters = _js2n__-prdslib.isType 'Record,
                          pattern =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "InOnly", "InOut" ]
                                ],
                          uri = _js2n__-prdslib.isType '"String",
                          variableReceive = _js2n__-prdslib.isType '"String",
                          variableSend = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "uri" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.TokenizerDefinition!predicate"
        | doc "Represents a Camel tokenizer for AI."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "langChain4jCharacterTokenizer" ],
                      _js2n__-prdslib.records.record
                        {
                          langChain4jCharacterTokenizer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jCharacterTokenizerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "langChain4jCharacterTokenizer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "langChain4jLineTokenizer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "langChain4jParagraphTokenizer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "langChain4jSentenceTokenizer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "langChain4jWordTokenizer" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "langChain4jLineTokenizer" ],
                      _js2n__-prdslib.records.record
                        {
                          langChain4jLineTokenizer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jTokenizerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "langChain4jParagraphTokenizer" ],
                      _js2n__-prdslib.records.record
                        {
                          langChain4jParagraphTokenizer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jParagraphTokenizerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "langChain4jSentenceTokenizer" ],
                      _js2n__-prdslib.records.record
                        {
                          langChain4jSentenceTokenizer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jSentenceTokenizerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "langChain4jWordTokenizer" ],
                      _js2n__-prdslib.records.record
                        {
                          langChain4jWordTokenizer =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jWordTokenizerDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  langChain4jCharacterTokenizer = _js2n__-prdslib.always,
                  langChain4jLineTokenizer = _js2n__-prdslib.always,
                  langChain4jParagraphTokenizer = _js2n__-prdslib.always,
                  langChain4jSentenceTokenizer = _js2n__-prdslib.always,
                  langChain4jWordTokenizer = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.TransactedDefinition!predicate"
        | doc "Enables transaction on the route"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  ref = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.TransformDefinition!predicate"
        | doc "Transforms the message body based on an expression"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  fromType = _js2n__-prdslib.isType '"String",
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  toType = _js2n__-prdslib.isType '"String",
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.TryDefinition!predicate"
        | doc "Marks the beginning of a try, catch, finally block"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  doCatch =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.CatchDefinition!predicate"
                        ],
                  doFinally =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.FinallyDefinition!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.UnmarshalDefinition!predicate"
        | doc "Converts the message data received from the wire into a format that Apache Camel processors can consume"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "asn1" ],
                      _js2n__-prdslib.records.record
                        {
                          asn1 =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ASN1DataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "asn1" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "avro" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "barcode" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "base64" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "beanio" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "bindy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "cbor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "crypto" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csv" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "custom" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "fhirJson" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "fhirXml" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "flatpack" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "fury" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "grok" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "gzipDeflater" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ical" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jacksonXml" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jaxb" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "json" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonApi" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "lzf" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "mimeMultipart" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "parquetAvro" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "pgp" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "protobuf" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "rss" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "smooks" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "soap" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "swiftMt" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "swiftMx" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "syslog" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tarFile" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "thrift" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tidyMarkup" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "univocityCsv" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "univocityFixed" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "univocityTsv" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xmlSecurity" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "yaml" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "zipDeflater" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "zipFile" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "avro" ],
                      _js2n__-prdslib.records.record
                        {
                          avro =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.AvroDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "barcode" ],
                      _js2n__-prdslib.records.record
                        {
                          barcode =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.BarcodeDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "base64" ],
                      _js2n__-prdslib.records.record
                        {
                          base64 =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.Base64DataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "beanio" ],
                      _js2n__-prdslib.records.record
                        {
                          beanio =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.BeanioDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "bindy" ],
                      _js2n__-prdslib.records.record
                        {
                          bindy =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.BindyDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "cbor" ],
                      _js2n__-prdslib.records.record
                        {
                          cbor =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CBORDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "crypto" ],
                      _js2n__-prdslib.records.record
                        {
                          crypto =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CryptoDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "csv" ],
                      _js2n__-prdslib.records.record
                        {
                          csv =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CsvDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "custom" ],
                      _js2n__-prdslib.records.record
                        {
                          custom =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CustomDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "fhirJson" ],
                      _js2n__-prdslib.records.record
                        {
                          fhirJson =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FhirJsonDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "fhirXml" ],
                      _js2n__-prdslib.records.record
                        {
                          fhirXml =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FhirXmlDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "flatpack" ],
                      _js2n__-prdslib.records.record
                        {
                          flatpack =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FlatpackDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "fury" ],
                      _js2n__-prdslib.records.record
                        {
                          fury =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FuryDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "grok" ],
                      _js2n__-prdslib.records.record
                        {
                          grok =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.GrokDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "gzipDeflater" ],
                      _js2n__-prdslib.records.record
                        {
                          gzipDeflater =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.GzipDeflaterDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "hl7" ],
                      _js2n__-prdslib.records.record
                        {
                          hl7 =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.HL7DataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "ical" ],
                      _js2n__-prdslib.records.record
                        {
                          ical =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.IcalDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jacksonXml" ],
                      _js2n__-prdslib.records.record
                        {
                          jacksonXml =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JacksonXMLDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jaxb" ],
                      _js2n__-prdslib.records.record
                        {
                          jaxb =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JaxbDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "json" ],
                      _js2n__-prdslib.records.record
                        {
                          json =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JsonDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jsonApi" ],
                      _js2n__-prdslib.records.record
                        {
                          jsonApi =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JsonApiDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "lzf" ],
                      _js2n__-prdslib.records.record
                        {
                          lzf =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.LZFDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mimeMultipart" ],
                      _js2n__-prdslib.records.record
                        {
                          mimeMultipart =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.MimeMultipartDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "parquetAvro" ],
                      _js2n__-prdslib.records.record
                        {
                          parquetAvro =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ParquetAvroDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "pgp" ],
                      _js2n__-prdslib.records.record
                        {
                          pgp =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.PGPDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "protobuf" ],
                      _js2n__-prdslib.records.record
                        {
                          protobuf =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ProtobufDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "rss" ],
                      _js2n__-prdslib.records.record
                        {
                          rss =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.RssDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "smooks" ],
                      _js2n__-prdslib.records.record
                        {
                          smooks =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SmooksDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "soap" ],
                      _js2n__-prdslib.records.record
                        {
                          soap =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SoapDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "swiftMt" ],
                      _js2n__-prdslib.records.record
                        {
                          swiftMt =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SwiftMtDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "swiftMx" ],
                      _js2n__-prdslib.records.record
                        {
                          swiftMx =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SwiftMxDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "syslog" ],
                      _js2n__-prdslib.records.record
                        {
                          syslog =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SyslogDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "tarFile" ],
                      _js2n__-prdslib.records.record
                        {
                          tarFile =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.TarFileDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "thrift" ],
                      _js2n__-prdslib.records.record
                        {
                          thrift =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ThriftDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "tidyMarkup" ],
                      _js2n__-prdslib.records.record
                        {
                          tidyMarkup =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.TidyMarkupDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "univocityCsv" ],
                      _js2n__-prdslib.records.record
                        {
                          univocityCsv =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityCsvDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "univocityFixed" ],
                      _js2n__-prdslib.records.record
                        {
                          univocityFixed =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityFixedDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "univocityTsv" ],
                      _js2n__-prdslib.records.record
                        {
                          univocityTsv =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityTsvDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "xmlSecurity" ],
                      _js2n__-prdslib.records.record
                        {
                          xmlSecurity =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.XMLSecurityDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "yaml" ],
                      _js2n__-prdslib.records.record
                        {
                          yaml =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.YAMLDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "zipDeflater" ],
                      _js2n__-prdslib.records.record
                        {
                          zipDeflater =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ZipDeflaterDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "zipFile" ],
                      _js2n__-prdslib.records.record
                        {
                          zipFile =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ZipFileDataFormat!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  allowNullBody = _js2n__-prdslib.isType '"Bool",
                  asn1 = _js2n__-prdslib.always,
                  avro = _js2n__-prdslib.always,
                  barcode = _js2n__-prdslib.always,
                  base64 = _js2n__-prdslib.always,
                  beanio = _js2n__-prdslib.always,
                  bindy = _js2n__-prdslib.always,
                  cbor = _js2n__-prdslib.always,
                  crypto = _js2n__-prdslib.always,
                  csv = _js2n__-prdslib.always,
                  custom = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  fhirJson = _js2n__-prdslib.always,
                  fhirXml = _js2n__-prdslib.always,
                  flatpack = _js2n__-prdslib.always,
                  fury = _js2n__-prdslib.always,
                  grok = _js2n__-prdslib.always,
                  gzipDeflater = _js2n__-prdslib.always,
                  hl7 = _js2n__-prdslib.always,
                  ical = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  jacksonXml = _js2n__-prdslib.always,
                  jaxb = _js2n__-prdslib.always,
                  json = _js2n__-prdslib.always,
                  jsonApi = _js2n__-prdslib.always,
                  lzf = _js2n__-prdslib.always,
                  mimeMultipart = _js2n__-prdslib.always,
                  parquetAvro = _js2n__-prdslib.always,
                  pgp = _js2n__-prdslib.always,
                  protobuf = _js2n__-prdslib.always,
                  rss = _js2n__-prdslib.always,
                  smooks = _js2n__-prdslib.always,
                  soap = _js2n__-prdslib.always,
                  swiftMt = _js2n__-prdslib.always,
                  swiftMx = _js2n__-prdslib.always,
                  syslog = _js2n__-prdslib.always,
                  tarFile = _js2n__-prdslib.always,
                  thrift = _js2n__-prdslib.always,
                  tidyMarkup = _js2n__-prdslib.always,
                  univocityCsv = _js2n__-prdslib.always,
                  univocityFixed = _js2n__-prdslib.always,
                  univocityTsv = _js2n__-prdslib.always,
                  variableReceive = _js2n__-prdslib.isType '"String",
                  variableSend = _js2n__-prdslib.isType '"String",
                  xmlSecurity = _js2n__-prdslib.always,
                  yaml = _js2n__-prdslib.always,
                  zipDeflater = _js2n__-prdslib.always,
                  zipFile = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ValidateDefinition!predicate"
        | doc "Validates a message based on an expression"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  predicateExceptionFactory = _js2n__-prdslib.isType '"String",
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.ValueDefinition!predicate"
        | doc "A single value"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    { value = _js2n__-prdslib.isType '"String", } {} false
                    _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.WhenDefinition!predicate"
        | doc "Triggers a route when the expression evaluates to true"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "expression" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "constant" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "csimple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "datasonnet" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exchangeProperty" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "groovy" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "header" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "hl7terser" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "java" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "joor" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jq" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "js" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "jsonpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "language" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "method" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "mvel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ognl" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "python" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "ref" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "simple" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "spel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "tokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "variable" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "wasm" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xpath" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xquery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "xtokenize" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "expression" ],
                      _js2n__-prdslib.records.record
                        {
                          expression =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  exchangeProperty = _js2n__-prdslib.always,
                  expression = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ProcessorDefinition!predicate"
                        ],
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.WireTapDefinition!predicate"
        | doc "Routes a copy of a message (or creates a new message) to a secondary destination while continue routing the original message."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "uri" ],
              _js2n__-prdslib.records.record
                {
                  allowOptimisedComponents = _js2n__-prdslib.isType '"Bool",
                  autoStartComponents = _js2n__-prdslib.isType '"Bool",
                  cacheSize = _js2n__-prdslib.isType '"Number",
                  copy = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  dynamicUri = _js2n__-prdslib.isType '"Bool",
                  executorService = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  ignoreInvalidEndpoint = _js2n__-prdslib.isType '"Bool",
                  onPrepare = _js2n__-prdslib.isType '"String",
                  parameters = _js2n__-prdslib.isType 'Record,
                  pattern =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "InOnly", "InOut" ]
                        ],
                  uri = _js2n__-prdslib.isType '"String",
                  variableReceive = _js2n__-prdslib.isType '"String",
                  variableSend = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.BlacklistServiceCallServiceFilterConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                  servers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.CachingServiceCallServiceDiscoveryConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "combinedServiceDiscovery" ],
                      _js2n__-prdslib.records.record
                        {
                          combinedServiceDiscovery =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.CombinedServiceCallServiceDiscoveryConfiguration!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "combinedServiceDiscovery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "consulServiceDiscovery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "dnsServiceDiscovery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "kubernetesServiceDiscovery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "staticServiceDiscovery" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ]),
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "consulServiceDiscovery" ],
                      _js2n__-prdslib.records.record
                        {
                          consulServiceDiscovery =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.ConsulServiceCallServiceDiscoveryConfiguration!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "dnsServiceDiscovery" ],
                      _js2n__-prdslib.records.record
                        {
                          dnsServiceDiscovery =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.DnsServiceCallServiceDiscoveryConfiguration!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "kubernetesServiceDiscovery" ],
                      _js2n__-prdslib.records.record
                        {
                          kubernetesServiceDiscovery =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.KubernetesServiceCallServiceDiscoveryConfiguration!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "staticServiceDiscovery" ],
                      _js2n__-prdslib.records.record
                        {
                          staticServiceDiscovery =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.StaticServiceCallServiceDiscoveryConfiguration!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  combinedServiceDiscovery = _js2n__-prdslib.always,
                  consulServiceDiscovery = _js2n__-prdslib.always,
                  dnsServiceDiscovery = _js2n__-prdslib.always,
                  id = _js2n__-prdslib.isType '"String",
                  kubernetesServiceDiscovery = _js2n__-prdslib.always,
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                  staticServiceDiscovery = _js2n__-prdslib.always,
                  timeout = _js2n__-prdslib.isType '"Number",
                  units =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "NANOSECONDS",
                              "MICROSECONDS",
                              "MILLISECONDS",
                              "SECONDS",
                              "MINUTES",
                              "HOURS",
                              "DAYS"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.CombinedServiceCallServiceDiscoveryConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cachingServiceDiscovery =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.CachingServiceCallServiceDiscoveryConfiguration!predicate",
                  consulServiceDiscovery =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.ConsulServiceCallServiceDiscoveryConfiguration!predicate",
                  dnsServiceDiscovery =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.DnsServiceCallServiceDiscoveryConfiguration!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  kubernetesServiceDiscovery =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.KubernetesServiceCallServiceDiscoveryConfiguration!predicate",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                  staticServiceDiscovery =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.StaticServiceCallServiceDiscoveryConfiguration!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.CombinedServiceCallServiceFilterConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  blacklistServiceFilter =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.BlacklistServiceCallServiceFilterConfiguration!predicate",
                  customServiceFilter =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.CustomServiceCallServiceFilterConfiguration!predicate",
                  healthyServiceFilter =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.HealthyServiceCallServiceFilterConfiguration!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  passThroughServiceFilter =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.PassThroughServiceCallServiceFilterConfiguration!predicate",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.ConsulServiceCallServiceDiscoveryConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aclToken = _js2n__-prdslib.isType '"String",
                  blockSeconds = _js2n__-prdslib.isType '"Number",
                  connectTimeoutMillis = _js2n__-prdslib.isType '"Number",
                  datacenter = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                  readTimeoutMillis = _js2n__-prdslib.isType '"Number",
                  url = _js2n__-prdslib.isType '"String",
                  userName = _js2n__-prdslib.isType '"String",
                  writeTimeoutMillis = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.CustomServiceCallServiceFilterConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                  ref = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.DefaultServiceCallServiceLoadBalancerConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.DnsServiceCallServiceDiscoveryConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  domain = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                  proto = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.HealthyServiceCallServiceFilterConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.KubernetesServiceCallServiceDiscoveryConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiVersion = _js2n__-prdslib.isType '"String",
                  caCertData = _js2n__-prdslib.isType '"String",
                  caCertFile = _js2n__-prdslib.isType '"String",
                  clientCertData = _js2n__-prdslib.isType '"String",
                  clientCertFile = _js2n__-prdslib.isType '"String",
                  clientKeyAlgo = _js2n__-prdslib.isType '"String",
                  clientKeyData = _js2n__-prdslib.isType '"String",
                  clientKeyFile = _js2n__-prdslib.isType '"String",
                  clientKeyPassphrase = _js2n__-prdslib.isType '"String",
                  dnsDomain = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  lookup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "environment", "dns", "client" ]
                        ],
                  masterUrl = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  oauthToken = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  portName = _js2n__-prdslib.isType '"String",
                  portProtocol = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                  trustCerts = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.PassThroughServiceCallServiceFilterConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.ServiceCallDefinition!predicate"
        | doc "To call remote services"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "blacklistServiceFilter" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      blacklistServiceFilter =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.BlacklistServiceCallServiceFilterConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.not
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "blacklistServiceFilter" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "combinedServiceFilter" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "customServiceFilter" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "healthyServiceFilter" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "passThroughServiceFilter" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ]
                                  ]),
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "combinedServiceFilter" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      combinedServiceFilter =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.CombinedServiceCallServiceFilterConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "customServiceFilter" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      customServiceFilter =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.CustomServiceCallServiceFilterConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "healthyServiceFilter" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      healthyServiceFilter =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.HealthyServiceCallServiceFilterConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "passThroughServiceFilter" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      passThroughServiceFilter =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.PassThroughServiceCallServiceFilterConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "cachingServiceDiscovery" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      cachingServiceDiscovery =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.CachingServiceCallServiceDiscoveryConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.not
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "cachingServiceDiscovery" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "combinedServiceDiscovery" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "consulServiceDiscovery" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "dnsServiceDiscovery" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kubernetesServiceDiscovery" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "staticServiceDiscovery" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "zookeeperServiceDiscovery" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ]
                                  ]),
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "combinedServiceDiscovery" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      combinedServiceDiscovery =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.CombinedServiceCallServiceDiscoveryConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "consulServiceDiscovery" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      consulServiceDiscovery =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.ConsulServiceCallServiceDiscoveryConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "dnsServiceDiscovery" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      dnsServiceDiscovery =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.DnsServiceCallServiceDiscoveryConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "kubernetesServiceDiscovery" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      kubernetesServiceDiscovery =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.KubernetesServiceCallServiceDiscoveryConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "staticServiceDiscovery" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      staticServiceDiscovery =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.StaticServiceCallServiceDiscoveryConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "zookeeperServiceDiscovery" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      zookeeperServiceDiscovery =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.ZooKeeperServiceCallServiceDiscoveryConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "defaultLoadBalancer" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      defaultLoadBalancer =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.DefaultServiceCallServiceLoadBalancerConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.not
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "defaultLoadBalancer" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "expression" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      expression =
                                        _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.cloud.ServiceCallExpressionConfiguration!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.not
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "expression" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ])
                            ]
                        ],
                      _js2n__-prdslib.records.record
                        {
                          blacklistServiceFilter = _js2n__-prdslib.always,
                          cachingServiceDiscovery = _js2n__-prdslib.always,
                          combinedServiceDiscovery = _js2n__-prdslib.always,
                          combinedServiceFilter = _js2n__-prdslib.always,
                          component = _js2n__-prdslib.isType '"String",
                          configurationRef = _js2n__-prdslib.isType '"String",
                          consulServiceDiscovery = _js2n__-prdslib.always,
                          customServiceFilter = _js2n__-prdslib.always,
                          defaultLoadBalancer = _js2n__-prdslib.always,
                          description = _js2n__-prdslib.isType '"String",
                          disabled = _js2n__-prdslib.isType '"Bool",
                          dnsServiceDiscovery = _js2n__-prdslib.always,
                          expression = _js2n__-prdslib.always,
                          expressionRef = _js2n__-prdslib.isType '"String",
                          healthyServiceFilter = _js2n__-prdslib.always,
                          id = _js2n__-prdslib.isType '"String",
                          kubernetesServiceDiscovery = _js2n__-prdslib.always,
                          loadBalancerRef = _js2n__-prdslib.isType '"String",
                          name = _js2n__-prdslib.isType '"String",
                          passThroughServiceFilter = _js2n__-prdslib.always,
                          pattern =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "InOnly", "InOut" ]
                                ],
                          serviceChooserRef = _js2n__-prdslib.isType '"String",
                          serviceDiscoveryRef =
                            _js2n__-prdslib.isType '"String",
                          serviceFilterRef = _js2n__-prdslib.isType '"String",
                          staticServiceDiscovery = _js2n__-prdslib.always,
                          uri = _js2n__-prdslib.isType '"String",
                          zookeeperServiceDiscovery = _js2n__-prdslib.always,
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.ServiceCallExpressionConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  expressionType =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate",
                  hostHeader = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  portHeader = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.StaticServiceCallServiceDiscoveryConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                  servers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.cloud.ZooKeeperServiceCallServiceDiscoveryConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "basePath", "nodes" ],
              _js2n__-prdslib.records.record
                {
                  basePath = _js2n__-prdslib.isType '"String",
                  connectionTimeout = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  nodes = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                        ],
                  reconnectBaseSleepTime = _js2n__-prdslib.isType '"String",
                  reconnectMaxRetries = _js2n__-prdslib.isType '"String",
                  reconnectMaxSleepTime = _js2n__-prdslib.isType '"String",
                  sessionTimeout = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.config.BatchResequencerConfig!predicate"
        | doc "Configures batch-processing resequence eip."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowDuplicates = _js2n__-prdslib.isType '"Bool",
                  batchSize = _js2n__-prdslib.isType '"Number",
                  batchTimeout = _js2n__-prdslib.isType '"String",
                  ignoreInvalidExchanges = _js2n__-prdslib.isType '"Bool",
                  reverse = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.config.StreamResequencerConfig!predicate"
        | doc "Configures stream-processing resequence eip."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  capacity = _js2n__-prdslib.isType '"Number",
                  comparator = _js2n__-prdslib.isType '"String",
                  deliveryAttemptInterval = _js2n__-prdslib.isType '"String",
                  ignoreInvalidExchanges = _js2n__-prdslib.isType '"Bool",
                  rejectOld = _js2n__-prdslib.isType '"Bool",
                  timeout = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.ASN1DataFormat!predicate"
        | doc "Encode and decode data structures using Abstract Syntax Notation One (ASN.1)."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      id = _js2n__-prdslib.isType '"String",
                      unmarshalType = _js2n__-prdslib.isType '"String",
                      usingIterator = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.AvroDataFormat!predicate"
        | doc "Serialize and deserialize messages using Apache Avro binary data format."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      allowJmsType = _js2n__-prdslib.isType '"Bool",
                      allowUnmarshallType = _js2n__-prdslib.isType '"Bool",
                      autoDiscoverObjectMapper = _js2n__-prdslib.isType '"Bool",
                      autoDiscoverSchemaResolver =
                        _js2n__-prdslib.isType '"Bool",
                      collectionType = _js2n__-prdslib.isType '"String",
                      contentTypeHeader = _js2n__-prdslib.isType '"Bool",
                      disableFeatures = _js2n__-prdslib.isType '"String",
                      enableFeatures = _js2n__-prdslib.isType '"String",
                      id = _js2n__-prdslib.isType '"String",
                      include = _js2n__-prdslib.isType '"String",
                      instanceClassName = _js2n__-prdslib.isType '"String",
                      jsonView = _js2n__-prdslib.isType '"String",
                      library =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "ApacheAvro", "Jackson" ]
                            ],
                      moduleClassNames = _js2n__-prdslib.isType '"String",
                      moduleRefs = _js2n__-prdslib.isType '"String",
                      objectMapper = _js2n__-prdslib.isType '"String",
                      schemaResolver = _js2n__-prdslib.isType '"String",
                      timezone = _js2n__-prdslib.isType '"String",
                      unmarshalType = _js2n__-prdslib.isType '"String",
                      useDefaultObjectMapper = _js2n__-prdslib.isType '"Bool",
                      useList = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.BarcodeDataFormat!predicate"
        | doc "Transform strings to various 1D/2D barcode bitmap formats and back."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  barcodeFormat = _js2n__-prdslib.isType '"String",
                  height = _js2n__-prdslib.isType '"Number",
                  id = _js2n__-prdslib.isType '"String",
                  imageType = _js2n__-prdslib.isType '"String",
                  width = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.Base64DataFormat!predicate"
        | doc "Encode and decode data using Base64."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  lineLength = _js2n__-prdslib.isType '"Number",
                  lineSeparator = _js2n__-prdslib.isType '"String",
                  urlSafe = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.BeanioDataFormat!predicate"
        | doc "Marshal and unmarshal Java beans to and from flat files (such as CSV, delimited, or fixed length formats)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "mapping", "streamName" ],
              _js2n__-prdslib.records.record
                {
                  beanReaderErrorHandlerType = _js2n__-prdslib.isType '"String",
                  encoding = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  ignoreInvalidRecords = _js2n__-prdslib.isType '"Bool",
                  ignoreUnexpectedRecords = _js2n__-prdslib.isType '"Bool",
                  ignoreUnidentifiedRecords = _js2n__-prdslib.isType '"Bool",
                  mapping = _js2n__-prdslib.isType '"String",
                  streamName = _js2n__-prdslib.isType '"String",
                  unmarshalSingleObject = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.BindyDataFormat!predicate"
        | doc "Marshal and unmarshal Java beans from and to flat payloads (such as CSV, delimited, fixed length formats, or FIX messages)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowEmptyStream = _js2n__-prdslib.isType '"Bool",
                  classType = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  locale = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Csv", "Fixed", "KeyValue" ]
                        ],
                  unwrapSingleInstance = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.CBORDataFormat!predicate"
        | doc "Unmarshal a CBOR payload to POJO and back."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowJmsType = _js2n__-prdslib.isType '"Bool",
                  allowUnmarshallType = _js2n__-prdslib.isType '"Bool",
                  collectionType = _js2n__-prdslib.isType '"String",
                  disableFeatures = _js2n__-prdslib.isType '"String",
                  enableFeatures = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  objectMapper = _js2n__-prdslib.isType '"String",
                  prettyPrint = _js2n__-prdslib.isType '"Bool",
                  unmarshalType = _js2n__-prdslib.isType '"String",
                  useDefaultObjectMapper = _js2n__-prdslib.isType '"Bool",
                  useList = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.CryptoDataFormat!predicate"
        | doc "Encrypt and decrypt messages using Java Cryptography Extension (JCE)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  algorithm = _js2n__-prdslib.isType '"String",
                  algorithmParameterRef = _js2n__-prdslib.isType '"String",
                  bufferSize = _js2n__-prdslib.isType '"Number",
                  cryptoProvider = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  initVectorRef = _js2n__-prdslib.isType '"String",
                  inline = _js2n__-prdslib.isType '"Bool",
                  keyRef = _js2n__-prdslib.isType '"String",
                  macAlgorithm = _js2n__-prdslib.isType '"String",
                  shouldAppendHMAC = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.CsvDataFormat!predicate"
        | doc "Handle CSV (Comma Separated Values) payloads."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      allowMissingColumnNames = _js2n__-prdslib.isType '"Bool",
                      captureHeaderRecord = _js2n__-prdslib.isType '"Bool",
                      commentMarker = _js2n__-prdslib.isType '"String",
                      commentMarkerDisabled = _js2n__-prdslib.isType '"Bool",
                      delimiter = _js2n__-prdslib.isType '"String",
                      escape = _js2n__-prdslib.isType '"String",
                      escapeDisabled = _js2n__-prdslib.isType '"Bool",
                      formatName =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "DEFAULT",
                                  "EXCEL",
                                  "INFORMIX_UNLOAD",
                                  "INFORMIX_UNLOAD_CSV",
                                  "MYSQL",
                                  "RFC4180"
                                ]
                            ],
                      formatRef = _js2n__-prdslib.isType '"String",
                      header =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      headerDisabled = _js2n__-prdslib.isType '"Bool",
                      id = _js2n__-prdslib.isType '"String",
                      ignoreEmptyLines = _js2n__-prdslib.isType '"Bool",
                      ignoreHeaderCase = _js2n__-prdslib.isType '"Bool",
                      ignoreSurroundingSpaces = _js2n__-prdslib.isType '"Bool",
                      lazyLoad = _js2n__-prdslib.isType '"Bool",
                      marshallerFactoryRef = _js2n__-prdslib.isType '"String",
                      nullString = _js2n__-prdslib.isType '"String",
                      nullStringDisabled = _js2n__-prdslib.isType '"Bool",
                      quote = _js2n__-prdslib.isType '"String",
                      quoteDisabled = _js2n__-prdslib.isType '"Bool",
                      quoteMode =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "ALL",
                                  "ALL_NON_NULL",
                                  "MINIMAL",
                                  "NON_NUMERIC",
                                  "NONE"
                                ]
                            ],
                      recordConverterRef = _js2n__-prdslib.isType '"String",
                      recordSeparator = _js2n__-prdslib.isType '"String",
                      recordSeparatorDisabled =
                        _js2n__-prdslib.isType '"String",
                      skipHeaderRecord = _js2n__-prdslib.isType '"Bool",
                      trailingDelimiter = _js2n__-prdslib.isType '"Bool",
                      trim = _js2n__-prdslib.isType '"Bool",
                      useMaps = _js2n__-prdslib.isType '"Bool",
                      useOrderedMaps = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.CustomDataFormat!predicate"
        | doc "Delegate to a custom org.apache.camel.spi.DataFormat implementation via Camel registry."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          id = _js2n__-prdslib.isType '"String",
                          ref = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "ref" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.DataFormatsDefinition!predicate"
        | doc "Configure data formats."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  asn1 =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ASN1DataFormat!predicate",
                  avro =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.AvroDataFormat!predicate",
                  barcode =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.BarcodeDataFormat!predicate",
                  base64 =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.Base64DataFormat!predicate",
                  beanio =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.BeanioDataFormat!predicate",
                  bindy =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.BindyDataFormat!predicate",
                  cbor =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CBORDataFormat!predicate",
                  crypto =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CryptoDataFormat!predicate",
                  csv =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CsvDataFormat!predicate",
                  custom =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.CustomDataFormat!predicate",
                  fhirJson =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FhirJsonDataFormat!predicate",
                  fhirXml =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FhirXmlDataFormat!predicate",
                  flatpack =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FlatpackDataFormat!predicate",
                  fury =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.FuryDataFormat!predicate",
                  grok =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.GrokDataFormat!predicate",
                  gzipDeflater =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.GzipDeflaterDataFormat!predicate",
                  hl7 =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.HL7DataFormat!predicate",
                  ical =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.IcalDataFormat!predicate",
                  jacksonXml =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JacksonXMLDataFormat!predicate",
                  jaxb =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JaxbDataFormat!predicate",
                  json =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JsonDataFormat!predicate",
                  jsonApi =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.JsonApiDataFormat!predicate",
                  lzf =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.LZFDataFormat!predicate",
                  mimeMultipart =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.MimeMultipartDataFormat!predicate",
                  parquetAvro =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ParquetAvroDataFormat!predicate",
                  pgp =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.PGPDataFormat!predicate",
                  protobuf =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ProtobufDataFormat!predicate",
                  rss =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.RssDataFormat!predicate",
                  smooks =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SmooksDataFormat!predicate",
                  soap =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SoapDataFormat!predicate",
                  swiftMt =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SwiftMtDataFormat!predicate",
                  swiftMx =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SwiftMxDataFormat!predicate",
                  syslog =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.SyslogDataFormat!predicate",
                  tarFile =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.TarFileDataFormat!predicate",
                  thrift =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ThriftDataFormat!predicate",
                  tidyMarkup =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.TidyMarkupDataFormat!predicate",
                  univocityCsv =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityCsvDataFormat!predicate",
                  univocityFixed =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityFixedDataFormat!predicate",
                  univocityTsv =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityTsvDataFormat!predicate",
                  xmlSecurity =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.XMLSecurityDataFormat!predicate",
                  yaml =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.YAMLDataFormat!predicate",
                  zipDeflater =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ZipDeflaterDataFormat!predicate",
                  zipFile =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.ZipFileDataFormat!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.FhirJsonDataFormat!predicate"
        | doc "Marshall and unmarshall FHIR objects to/from JSON."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  contentTypeHeader = _js2n__-prdslib.isType '"Bool",
                  dontEncodeElements = _js2n__-prdslib.isType '"String",
                  dontStripVersionsFromReferencesAtPaths =
                    _js2n__-prdslib.isType '"String",
                  encodeElements = _js2n__-prdslib.isType '"String",
                  encodeElementsAppliesToChildResourcesOnly =
                    _js2n__-prdslib.isType '"Bool",
                  fhirContext = _js2n__-prdslib.isType '"String",
                  fhirVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "DSTU2",
                              "DSTU2_HL7ORG",
                              "DSTU2_1",
                              "DSTU3",
                              "R4",
                              "R5"
                            ]
                        ],
                  forceResourceId = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  omitResourceId = _js2n__-prdslib.isType '"Bool",
                  overrideResourceIdWithBundleEntryFullUrl =
                    _js2n__-prdslib.isType '"Bool",
                  parserErrorHandler = _js2n__-prdslib.isType '"String",
                  parserOptions = _js2n__-prdslib.isType '"String",
                  preferTypes = _js2n__-prdslib.isType '"String",
                  prettyPrint = _js2n__-prdslib.isType '"Bool",
                  serverBaseUrl = _js2n__-prdslib.isType '"String",
                  stripVersionsFromReferences = _js2n__-prdslib.isType '"Bool",
                  summaryMode = _js2n__-prdslib.isType '"Bool",
                  suppressNarratives = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.FhirXmlDataFormat!predicate"
        | doc "Marshall and unmarshall FHIR objects to/from XML."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  contentTypeHeader = _js2n__-prdslib.isType '"Bool",
                  dontEncodeElements = _js2n__-prdslib.isType '"String",
                  dontStripVersionsFromReferencesAtPaths =
                    _js2n__-prdslib.isType '"String",
                  encodeElements = _js2n__-prdslib.isType '"String",
                  encodeElementsAppliesToChildResourcesOnly =
                    _js2n__-prdslib.isType '"Bool",
                  fhirContext = _js2n__-prdslib.isType '"String",
                  fhirVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "DSTU2",
                              "DSTU2_HL7ORG",
                              "DSTU2_1",
                              "DSTU3",
                              "R4",
                              "R5"
                            ]
                        ],
                  forceResourceId = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  omitResourceId = _js2n__-prdslib.isType '"Bool",
                  overrideResourceIdWithBundleEntryFullUrl =
                    _js2n__-prdslib.isType '"Bool",
                  parserErrorHandler = _js2n__-prdslib.isType '"String",
                  parserOptions = _js2n__-prdslib.isType '"String",
                  preferTypes = _js2n__-prdslib.isType '"String",
                  prettyPrint = _js2n__-prdslib.isType '"Bool",
                  serverBaseUrl = _js2n__-prdslib.isType '"String",
                  stripVersionsFromReferences = _js2n__-prdslib.isType '"Bool",
                  summaryMode = _js2n__-prdslib.isType '"Bool",
                  suppressNarratives = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.FlatpackDataFormat!predicate"
        | doc "Marshal and unmarshal Java lists and maps to/from flat files (such as CSV, delimited, or fixed length formats) using Flatpack library."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowShortLines = _js2n__-prdslib.isType '"Bool",
                  definition = _js2n__-prdslib.isType '"String",
                  delimiter = _js2n__-prdslib.isType '"String",
                  fixed = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  ignoreExtraColumns = _js2n__-prdslib.isType '"Bool",
                  ignoreFirstRecord = _js2n__-prdslib.isType '"Bool",
                  parserFactoryRef = _js2n__-prdslib.isType '"String",
                  textQualifier = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.FuryDataFormat!predicate"
        | doc "Serialize and deserialize messages using Apache Fury"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowAutoWiredFury = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  requireClassRegistration = _js2n__-prdslib.isType '"Bool",
                  threadSafe = _js2n__-prdslib.isType '"Bool",
                  unmarshalType = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.GrokDataFormat!predicate"
        | doc "Unmarshal unstructured data to objects using Logstash based Grok patterns."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "pattern" ],
              _js2n__-prdslib.records.record
                {
                  allowMultipleMatchesPerLine = _js2n__-prdslib.isType '"Bool",
                  flattened = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  namedOnly = _js2n__-prdslib.isType '"Bool",
                  pattern = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.GzipDeflaterDataFormat!predicate"
        | doc "Compress and decompress messages using java.util.zip.GZIPStream."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { id = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.HL7DataFormat!predicate"
        | doc "Marshal and unmarshal HL7 (Health Care) model objects using the HL7 MLLP codec."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  validate = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.IcalDataFormat!predicate"
        | doc "Marshal and unmarshal iCal (.ics) documents to/from model objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  validating = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.JacksonXMLDataFormat!predicate"
        | doc "Unmarshal an XML payloads to POJOs and back using XMLMapper extension of Jackson."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowJmsType = _js2n__-prdslib.isType '"Bool",
                  allowUnmarshallType = _js2n__-prdslib.isType '"Bool",
                  collectionType = _js2n__-prdslib.isType '"String",
                  contentTypeHeader = _js2n__-prdslib.isType '"Bool",
                  disableFeatures = _js2n__-prdslib.isType '"String",
                  enableFeatures = _js2n__-prdslib.isType '"String",
                  enableJaxbAnnotationModule = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  include = _js2n__-prdslib.isType '"String",
                  jsonView = _js2n__-prdslib.isType '"String",
                  moduleClassNames = _js2n__-prdslib.isType '"String",
                  moduleRefs = _js2n__-prdslib.isType '"String",
                  prettyPrint = _js2n__-prdslib.isType '"Bool",
                  timezone = _js2n__-prdslib.isType '"String",
                  unmarshalType = _js2n__-prdslib.isType '"String",
                  useList = _js2n__-prdslib.isType '"Bool",
                  xmlMapper = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.JaxbDataFormat!predicate"
        | doc "Unmarshal XML payloads to POJOs and back using JAXB2 XML marshalling standard."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "contextPath" ],
              _js2n__-prdslib.records.record
                {
                  accessExternalSchemaProtocols =
                    _js2n__-prdslib.isType '"String",
                  contentTypeHeader = _js2n__-prdslib.isType '"Bool",
                  contextPath = _js2n__-prdslib.isType '"String",
                  contextPathIsClassName = _js2n__-prdslib.isType '"Bool",
                  encoding = _js2n__-prdslib.isType '"String",
                  filterNonXmlChars = _js2n__-prdslib.isType '"Bool",
                  fragment = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  ignoreJAXBElement = _js2n__-prdslib.isType '"Bool",
                  jaxbProviderProperties = _js2n__-prdslib.isType '"String",
                  mustBeJAXBElement = _js2n__-prdslib.isType '"Bool",
                  namespacePrefixRef = _js2n__-prdslib.isType '"String",
                  noNamespaceSchemaLocation = _js2n__-prdslib.isType '"String",
                  objectFactory = _js2n__-prdslib.isType '"Bool",
                  partClass = _js2n__-prdslib.isType '"String",
                  partNamespace = _js2n__-prdslib.isType '"String",
                  prettyPrint = _js2n__-prdslib.isType '"Bool",
                  schema = _js2n__-prdslib.isType '"String",
                  schemaLocation = _js2n__-prdslib.isType '"String",
                  schemaSeverityLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "0", "1", "2" ]
                        ],
                  xmlStreamWriterWrapper = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.JsonApiDataFormat!predicate"
        | doc "Marshal and unmarshal JSON:API resources using JSONAPI-Converter library."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataFormatTypes = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  mainFormatType = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.JsonDataFormat!predicate"
        | doc "Marshal POJOs to JSON and back."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowJmsType = _js2n__-prdslib.isType '"Bool",
                  allowUnmarshallType = _js2n__-prdslib.isType '"Bool",
                  autoDiscoverObjectMapper = _js2n__-prdslib.isType '"Bool",
                  autoDiscoverSchemaResolver = _js2n__-prdslib.isType '"Bool",
                  collectionType = _js2n__-prdslib.isType '"String",
                  combineUnicodeSurrogates = _js2n__-prdslib.isType '"Bool",
                  contentTypeHeader = _js2n__-prdslib.isType '"Bool",
                  dateFormatPattern = _js2n__-prdslib.isType '"String",
                  disableFeatures = _js2n__-prdslib.isType '"String",
                  enableFeatures = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  include = _js2n__-prdslib.isType '"String",
                  jsonView = _js2n__-prdslib.isType '"String",
                  library =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Fastjson",
                              "Gson",
                              "Jackson",
                              "Johnzon",
                              "Jsonb"
                            ]
                        ],
                  moduleClassNames = _js2n__-prdslib.isType '"String",
                  moduleRefs = _js2n__-prdslib.isType '"String",
                  namingStrategy = _js2n__-prdslib.isType '"String",
                  objectMapper = _js2n__-prdslib.isType '"String",
                  prettyPrint = _js2n__-prdslib.isType '"Bool",
                  schemaResolver = _js2n__-prdslib.isType '"String",
                  timezone = _js2n__-prdslib.isType '"String",
                  unmarshalType = _js2n__-prdslib.isType '"String",
                  useDefaultObjectMapper = _js2n__-prdslib.isType '"Bool",
                  useList = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.LZFDataFormat!predicate"
        | doc "Compress and decompress streams using LZF deflate algorithm."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  usingParallelCompression = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.MimeMultipartDataFormat!predicate"
        | doc "Marshal Camel messages with attachments into MIME-Multipart messages and back."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  binaryContent = _js2n__-prdslib.isType '"Bool",
                  headersInline = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  includeHeaders = _js2n__-prdslib.isType '"String",
                  multipartSubType = _js2n__-prdslib.isType '"String",
                  multipartWithoutAttachment = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.PGPDataFormat!predicate"
        | doc "Encrypt and decrypt messages using Java Cryptographic Extension (JCE) and PGP."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  algorithm = _js2n__-prdslib.isType '"Number",
                  armored = _js2n__-prdslib.isType '"Bool",
                  compressionAlgorithm = _js2n__-prdslib.isType '"Number",
                  hashAlgorithm = _js2n__-prdslib.isType '"Number",
                  id = _js2n__-prdslib.isType '"String",
                  integrity = _js2n__-prdslib.isType '"Bool",
                  keyFileName = _js2n__-prdslib.isType '"String",
                  keyUserid = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  provider = _js2n__-prdslib.isType '"String",
                  signatureKeyFileName = _js2n__-prdslib.isType '"String",
                  signatureKeyRing = _js2n__-prdslib.isType '"String",
                  signatureKeyUserid = _js2n__-prdslib.isType '"String",
                  signaturePassword = _js2n__-prdslib.isType '"String",
                  signatureVerificationOption =
                    _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.ParquetAvroDataFormat!predicate"
        | doc "Parquet Avro serialization and de-serialization."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      compressionCodecName =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "UNCOMPRESSED",
                                  "SNAPPY",
                                  "GZIP",
                                  "LZO",
                                  "BROTLI",
                                  "LZ4",
                                  "ZSTD",
                                  "LZ4_RAW"
                                ]
                            ],
                      id = _js2n__-prdslib.isType '"String",
                      lazyLoad = _js2n__-prdslib.isType '"Bool",
                      unmarshalType = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.ProtobufDataFormat!predicate"
        | doc "Serialize and deserialize Java objects using Google's Protocol buffers."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      allowJmsType = _js2n__-prdslib.isType '"Bool",
                      allowUnmarshallType = _js2n__-prdslib.isType '"Bool",
                      autoDiscoverObjectMapper = _js2n__-prdslib.isType '"Bool",
                      autoDiscoverSchemaResolver =
                        _js2n__-prdslib.isType '"Bool",
                      collectionType = _js2n__-prdslib.isType '"String",
                      contentTypeFormat =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "native", "json" ]
                            ],
                      contentTypeHeader = _js2n__-prdslib.isType '"Bool",
                      disableFeatures = _js2n__-prdslib.isType '"String",
                      enableFeatures = _js2n__-prdslib.isType '"String",
                      id = _js2n__-prdslib.isType '"String",
                      include = _js2n__-prdslib.isType '"String",
                      instanceClass = _js2n__-prdslib.isType '"String",
                      jsonView = _js2n__-prdslib.isType '"String",
                      library =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "GoogleProtobuf", "Jackson" ]
                            ],
                      moduleClassNames = _js2n__-prdslib.isType '"String",
                      moduleRefs = _js2n__-prdslib.isType '"String",
                      objectMapper = _js2n__-prdslib.isType '"String",
                      schemaResolver = _js2n__-prdslib.isType '"String",
                      timezone = _js2n__-prdslib.isType '"String",
                      unmarshalType = _js2n__-prdslib.isType '"String",
                      useDefaultObjectMapper = _js2n__-prdslib.isType '"Bool",
                      useList = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.RssDataFormat!predicate"
        | doc "Transform from ROME SyndFeed Java Objects to XML and vice-versa."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { id = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.SmooksDataFormat!predicate"
        | doc "Transform and bind XML as well as non-XML data, including EDI, CSV, JSON, and YAML using Smooks."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "smooksConfig" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  smooksConfig = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.SoapDataFormat!predicate"
        | doc "Marshal Java objects to SOAP messages and back."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          contextPath = _js2n__-prdslib.isType '"String",
                          elementNameStrategyRef =
                            _js2n__-prdslib.isType '"String",
                          encoding = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          namespacePrefixRef = _js2n__-prdslib.isType '"String",
                          schema = _js2n__-prdslib.isType '"String",
                          version =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "1.1", "1.2" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "contextPath" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.SwiftMtDataFormat!predicate"
        | doc "Encode and decode SWIFT MT messages."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      id = _js2n__-prdslib.isType '"String",
                      writeInJson = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.SwiftMxDataFormat!predicate"
        | doc "Encode and decode SWIFT MX messages."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  readConfigRef = _js2n__-prdslib.isType '"String",
                  readMessageId = _js2n__-prdslib.isType '"String",
                  writeConfigRef = _js2n__-prdslib.isType '"String",
                  writeInJson = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.SyslogDataFormat!predicate"
        | doc "Marshall SyslogMessages to RFC3164 and RFC5424 messages and back."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { id = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.TarFileDataFormat!predicate"
        | doc "Archive files into tarballs or extract files from tarballs."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowEmptyDirectory = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  maxDecompressedSize = _js2n__-prdslib.isType '"Number",
                  preservePathElements = _js2n__-prdslib.isType '"Bool",
                  usingIterator = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.ThriftDataFormat!predicate"
        | doc "Serialize and deserialize messages using Apache Thrift binary data format."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      contentTypeFormat =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "binary", "json", "sjson" ]
                            ],
                      contentTypeHeader = _js2n__-prdslib.isType '"Bool",
                      id = _js2n__-prdslib.isType '"String",
                      instanceClass = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.TidyMarkupDataFormat!predicate"
        | doc "Parse (potentially invalid) HTML into valid HTML or DOM."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataObjectType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "org.w3c.dom.Node", "java.lang.String" ]
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  omitXmlDeclaration = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityCsvDataFormat!predicate"
        | doc "Marshal and unmarshal Java objects from and to CSV (Comma Separated Values) using UniVocity Parsers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  asMap = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  delimiter = _js2n__-prdslib.isType '"String",
                  emptyValue = _js2n__-prdslib.isType '"String",
                  headerExtractionEnabled = _js2n__-prdslib.isType '"Bool",
                  headersDisabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  ignoreLeadingWhitespaces = _js2n__-prdslib.isType '"Bool",
                  ignoreTrailingWhitespaces = _js2n__-prdslib.isType '"Bool",
                  lazyLoad = _js2n__-prdslib.isType '"Bool",
                  lineSeparator = _js2n__-prdslib.isType '"String",
                  normalizedLineSeparator = _js2n__-prdslib.isType '"String",
                  nullValue = _js2n__-prdslib.isType '"String",
                  numberOfRecordsToRead = _js2n__-prdslib.isType '"Number",
                  quote = _js2n__-prdslib.isType '"String",
                  quoteAllFields = _js2n__-prdslib.isType '"Bool",
                  quoteEscape = _js2n__-prdslib.isType '"String",
                  skipEmptyLines = _js2n__-prdslib.isType '"Bool",
                  univocityHeader =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityHeader!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityFixedDataFormat!predicate"
        | doc "Marshal and unmarshal Java objects from and to fixed length records using UniVocity Parsers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  asMap = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  emptyValue = _js2n__-prdslib.isType '"String",
                  headerExtractionEnabled = _js2n__-prdslib.isType '"Bool",
                  headersDisabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  ignoreLeadingWhitespaces = _js2n__-prdslib.isType '"Bool",
                  ignoreTrailingWhitespaces = _js2n__-prdslib.isType '"Bool",
                  lazyLoad = _js2n__-prdslib.isType '"Bool",
                  lineSeparator = _js2n__-prdslib.isType '"String",
                  normalizedLineSeparator = _js2n__-prdslib.isType '"String",
                  nullValue = _js2n__-prdslib.isType '"String",
                  numberOfRecordsToRead = _js2n__-prdslib.isType '"Number",
                  padding = _js2n__-prdslib.isType '"String",
                  recordEndsOnNewline = _js2n__-prdslib.isType '"Bool",
                  skipEmptyLines = _js2n__-prdslib.isType '"Bool",
                  skipTrailingCharsUntilNewline =
                    _js2n__-prdslib.isType '"Bool",
                  univocityHeader =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityHeader!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityHeader!predicate"
        | doc "To configure headers for UniVocity data formats."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  length = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityTsvDataFormat!predicate"
        | doc "Marshal and unmarshal Java objects from and to TSV (Tab-Separated Values) records using UniVocity Parsers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  asMap = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  emptyValue = _js2n__-prdslib.isType '"String",
                  escapeChar = _js2n__-prdslib.isType '"String",
                  headerExtractionEnabled = _js2n__-prdslib.isType '"Bool",
                  headersDisabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  ignoreLeadingWhitespaces = _js2n__-prdslib.isType '"Bool",
                  ignoreTrailingWhitespaces = _js2n__-prdslib.isType '"Bool",
                  lazyLoad = _js2n__-prdslib.isType '"Bool",
                  lineSeparator = _js2n__-prdslib.isType '"String",
                  normalizedLineSeparator = _js2n__-prdslib.isType '"String",
                  nullValue = _js2n__-prdslib.isType '"String",
                  numberOfRecordsToRead = _js2n__-prdslib.isType '"Number",
                  skipEmptyLines = _js2n__-prdslib.isType '"Bool",
                  univocityHeader =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.UniVocityHeader!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.XMLSecurityDataFormat!predicate"
        | doc "Encrypt and decrypt XML payloads using Apache Santuario."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addKeyValueForEncryptedKey = _js2n__-prdslib.isType '"Bool",
                  digestAlgorithm =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "SHA1", "SHA256", "SHA512" ]
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  keyCipherAlgorithm =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "RSA_v1dot5", "RSA_OAEP", "RSA_OAEP_11" ]
                        ],
                  keyOrTrustStoreParametersRef =
                    _js2n__-prdslib.isType '"String",
                  keyPassword = _js2n__-prdslib.isType '"String",
                  mgfAlgorithm =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "MGF1_SHA1", "MGF1_SHA256", "MGF1_SHA512" ]
                        ],
                  passPhrase = _js2n__-prdslib.isType '"String",
                  passPhraseByte = _js2n__-prdslib.isType '"String",
                  recipientKeyAlias = _js2n__-prdslib.isType '"String",
                  secureTag = _js2n__-prdslib.isType '"String",
                  secureTagContents = _js2n__-prdslib.isType '"Bool",
                  xmlCipherAlgorithm =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "TRIPLEDES",
                              "AES_128",
                              "AES_128_GCM",
                              "AES_192",
                              "AES_192_GCM",
                              "AES_256",
                              "AES_256_GCM",
                              "SEED_128",
                              "CAMELLIA_128",
                              "CAMELLIA_192",
                              "CAMELLIA_256"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.YAMLDataFormat!predicate"
        | doc "Marshal and unmarshal Java objects to and from YAML."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowAnyType = _js2n__-prdslib.isType '"Bool",
                  allowRecursiveKeys = _js2n__-prdslib.isType '"Bool",
                  constructor = _js2n__-prdslib.isType '"String",
                  dumperOptions = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  library =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "SnakeYAML" ]
                        ],
                  maxAliasesForCollections = _js2n__-prdslib.isType '"Number",
                  prettyFlow = _js2n__-prdslib.isType '"Bool",
                  representer = _js2n__-prdslib.isType '"String",
                  resolver = _js2n__-prdslib.isType '"String",
                  typeFilter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.dataformat.YAMLTypeFilterDefinition!predicate"
                        ],
                  unmarshalType = _js2n__-prdslib.isType '"String",
                  useApplicationContextClassLoader =
                    _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.YAMLTypeFilterDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  type = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.ZipDeflaterDataFormat!predicate"
        | doc "Compress and decompress streams using java.util.zip.Deflater and java.util.zip.Inflater."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compressionLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "-1",
                              "0",
                              "1",
                              "2",
                              "3",
                              "4",
                              "5",
                              "6",
                              "7",
                              "8",
                              "9"
                            ]
                        ],
                  id = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.dataformat.ZipFileDataFormat!predicate"
        | doc "Compression and decompress streams using java.util.zip.ZipStream."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowEmptyDirectory = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  maxDecompressedSize = _js2n__-prdslib.isType '"Number",
                  preservePathElements = _js2n__-prdslib.isType '"Bool",
                  usingIterator = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.errorhandler.DeadLetterChannelDefinition!predicate"
        | doc "Error handler with dead letter queue."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "deadLetterUri" ],
              _js2n__-prdslib.records.record
                {
                  deadLetterHandleNewException = _js2n__-prdslib.isType '"Bool",
                  deadLetterUri = _js2n__-prdslib.isType '"String",
                  executorServiceRef = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" ]
                        ],
                  logName = _js2n__-prdslib.isType '"String",
                  loggerRef = _js2n__-prdslib.isType '"String",
                  onExceptionOccurredRef = _js2n__-prdslib.isType '"String",
                  onPrepareFailureRef = _js2n__-prdslib.isType '"String",
                  onRedeliveryRef = _js2n__-prdslib.isType '"String",
                  redeliveryPolicy =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RedeliveryPolicyDefinition!predicate",
                  redeliveryPolicyRef = _js2n__-prdslib.isType '"String",
                  retryWhileRef = _js2n__-prdslib.isType '"String",
                  useOriginalBody = _js2n__-prdslib.isType '"Bool",
                  useOriginalMessage = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.errorhandler.DefaultErrorHandlerDefinition!predicate"
        | doc "The default error handler."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  executorServiceRef = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" ]
                        ],
                  logName = _js2n__-prdslib.isType '"String",
                  loggerRef = _js2n__-prdslib.isType '"String",
                  onExceptionOccurredRef = _js2n__-prdslib.isType '"String",
                  onPrepareFailureRef = _js2n__-prdslib.isType '"String",
                  onRedeliveryRef = _js2n__-prdslib.isType '"String",
                  redeliveryPolicy =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RedeliveryPolicyDefinition!predicate",
                  redeliveryPolicyRef = _js2n__-prdslib.isType '"String",
                  retryWhileRef = _js2n__-prdslib.isType '"String",
                  useOriginalBody = _js2n__-prdslib.isType '"Bool",
                  useOriginalMessage = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.errorhandler.JtaTransactionErrorHandlerDefinition!predicate"
        | doc "JTA based transactional error handler (requires camel-jta)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  executorServiceRef = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" ]
                        ],
                  logName = _js2n__-prdslib.isType '"String",
                  loggerRef = _js2n__-prdslib.isType '"String",
                  onExceptionOccurredRef = _js2n__-prdslib.isType '"String",
                  onPrepareFailureRef = _js2n__-prdslib.isType '"String",
                  onRedeliveryRef = _js2n__-prdslib.isType '"String",
                  redeliveryPolicy =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RedeliveryPolicyDefinition!predicate",
                  redeliveryPolicyRef = _js2n__-prdslib.isType '"String",
                  retryWhileRef = _js2n__-prdslib.isType '"String",
                  rollbackLoggingLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" ]
                        ],
                  transactedPolicyRef = _js2n__-prdslib.isType '"String",
                  useOriginalBody = _js2n__-prdslib.isType '"Bool",
                  useOriginalMessage = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.errorhandler.NoErrorHandlerDefinition!predicate"
        | doc "To not use an error handler."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { id = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.errorhandler.RefErrorHandlerDefinition!predicate"
        | doc "References to an existing or custom error handler."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          id = _js2n__-prdslib.isType '"String",
                          ref = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "ref" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.errorhandler.SpringTransactionErrorHandlerDefinition!predicate"
        | doc "Spring based transactional error handler (requires camel-spring)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  executorServiceRef = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" ]
                        ],
                  logName = _js2n__-prdslib.isType '"String",
                  loggerRef = _js2n__-prdslib.isType '"String",
                  onExceptionOccurredRef = _js2n__-prdslib.isType '"String",
                  onPrepareFailureRef = _js2n__-prdslib.isType '"String",
                  onRedeliveryRef = _js2n__-prdslib.isType '"String",
                  redeliveryPolicy =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RedeliveryPolicyDefinition!predicate",
                  redeliveryPolicyRef = _js2n__-prdslib.isType '"String",
                  retryWhileRef = _js2n__-prdslib.isType '"String",
                  rollbackLoggingLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" ]
                        ],
                  transactedPolicyRef = _js2n__-prdslib.isType '"String",
                  useOriginalBody = _js2n__-prdslib.isType '"Bool",
                  useOriginalMessage = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.CSimpleExpression!predicate"
        | doc "Evaluate a compiled simple expression."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.ConstantExpression!predicate"
        | doc "A fixed value set only once during the route startup."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.DatasonnetExpression!predicate"
        | doc "To use DataSonnet scripts for message transformations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          bodyMediaType = _js2n__-prdslib.isType '"String",
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          outputMediaType = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          source = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.ExchangePropertyExpression!predicate"
        | doc "Gets a property from the Exchange."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.ExpressionDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "constant" ],
                      _js2n__-prdslib.records.record
                        {
                          constant =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ConstantExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "csimple" ],
                      _js2n__-prdslib.records.record
                        {
                          csimple =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.CSimpleExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "datasonnet" ],
                      _js2n__-prdslib.records.record
                        {
                          datasonnet =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.DatasonnetExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "exchangeProperty" ],
                      _js2n__-prdslib.records.record
                        {
                          exchangeProperty =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.ExchangePropertyExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "groovy" ],
                      _js2n__-prdslib.records.record
                        {
                          groovy =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.GroovyExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "header" ],
                      _js2n__-prdslib.records.record
                        {
                          header =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.HeaderExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "hl7terser" ],
                      _js2n__-prdslib.records.record
                        {
                          hl7terser =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.Hl7TerserExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "java" ],
                      _js2n__-prdslib.records.record
                        {
                          java =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JavaExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "joor" ],
                      _js2n__-prdslib.records.record
                        {
                          joor =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JoorExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jq" ],
                      _js2n__-prdslib.records.record
                        {
                          jq =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JqExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "js" ],
                      _js2n__-prdslib.records.record
                        {
                          js =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JavaScriptExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "jsonpath" ],
                      _js2n__-prdslib.records.record
                        {
                          jsonpath =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.JsonPathExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "language" ],
                      _js2n__-prdslib.records.record
                        {
                          language =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.LanguageExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "method" ],
                      _js2n__-prdslib.records.record
                        {
                          method =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.MethodCallExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mvel" ],
                      _js2n__-prdslib.records.record
                        {
                          mvel =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.MvelExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "ognl" ],
                      _js2n__-prdslib.records.record
                        {
                          ognl =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.OgnlExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "python" ],
                      _js2n__-prdslib.records.record
                        {
                          python =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.PythonExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "ref" ],
                      _js2n__-prdslib.records.record
                        {
                          ref =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.RefExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "simple" ],
                      _js2n__-prdslib.records.record
                        {
                          simple =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.SimpleExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "spel" ],
                      _js2n__-prdslib.records.record
                        {
                          spel =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.SpELExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "tokenize" ],
                      _js2n__-prdslib.records.record
                        {
                          tokenize =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.TokenizerExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "variable" ],
                      _js2n__-prdslib.records.record
                        {
                          variable =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.VariableExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "wasm" ],
                      _js2n__-prdslib.records.record
                        {
                          wasm =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.WasmExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "xpath" ],
                      _js2n__-prdslib.records.record
                        {
                          xpath =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.XPathExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "xquery" ],
                      _js2n__-prdslib.records.record
                        {
                          xquery =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.XQueryExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "xtokenize" ],
                      _js2n__-prdslib.records.record
                        {
                          xtokenize =
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.language.XMLTokenizerExpression!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  constant = _js2n__-prdslib.always,
                  csimple = _js2n__-prdslib.always,
                  datasonnet = _js2n__-prdslib.always,
                  exchangeProperty = _js2n__-prdslib.always,
                  groovy = _js2n__-prdslib.always,
                  header = _js2n__-prdslib.always,
                  hl7terser = _js2n__-prdslib.always,
                  java = _js2n__-prdslib.always,
                  joor = _js2n__-prdslib.always,
                  jq = _js2n__-prdslib.always,
                  js = _js2n__-prdslib.always,
                  jsonpath = _js2n__-prdslib.always,
                  language = _js2n__-prdslib.always,
                  method = _js2n__-prdslib.always,
                  mvel = _js2n__-prdslib.always,
                  ognl = _js2n__-prdslib.always,
                  python = _js2n__-prdslib.always,
                  ref = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.always,
                  spel = _js2n__-prdslib.always,
                  tokenize = _js2n__-prdslib.always,
                  variable = _js2n__-prdslib.always,
                  wasm = _js2n__-prdslib.always,
                  xpath = _js2n__-prdslib.always,
                  xquery = _js2n__-prdslib.always,
                  xtokenize = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.GroovyExpression!predicate"
        | doc "Evaluates a Groovy script."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.HeaderExpression!predicate"
        | doc "Gets a header from the Exchange."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.Hl7TerserExpression!predicate"
        | doc "Get the value of a HL7 message field specified by terse location specification syntax."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          source = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.JavaExpression!predicate"
        | doc "Evaluates a Java (Java compiled once at runtime) expression."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          preCompile = _js2n__-prdslib.isType '"Bool",
                          resultType = _js2n__-prdslib.isType '"String",
                          singleQuotes = _js2n__-prdslib.isType '"Bool",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.JavaScriptExpression!predicate"
        | doc "Evaluates a JavaScript expression."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.JoorExpression!predicate"
        | doc "Evaluates a jOOR (Java compiled once at runtime) expression."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          preCompile = _js2n__-prdslib.isType '"Bool",
                          resultType = _js2n__-prdslib.isType '"String",
                          singleQuotes = _js2n__-prdslib.isType '"Bool",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.JqExpression!predicate"
        | doc "Evaluates a JQ expression against a JSON message body."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          source = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.JsonPathExpression!predicate"
        | doc "Evaluates a JSONPath expression against a JSON message body."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          allowEasyPredicate = _js2n__-prdslib.isType '"Bool",
                          allowSimple = _js2n__-prdslib.isType '"Bool",
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          option =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "DEFAULT_PATH_LEAF_TO_NULL",
                                      "ALWAYS_RETURN_LIST",
                                      "AS_PATH_LIST",
                                      "SUPPRESS_EXCEPTIONS",
                                      "REQUIRE_PROPERTIES"
                                    ]
                                ],
                          resultType = _js2n__-prdslib.isType '"String",
                          source = _js2n__-prdslib.isType '"String",
                          suppressExceptions = _js2n__-prdslib.isType '"Bool",
                          trim = _js2n__-prdslib.isType '"Bool",
                          unpackArray = _js2n__-prdslib.isType '"Bool",
                          writeAsString = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.LanguageExpression!predicate"
        | doc "Evaluates a custom language."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "expression", "language" ],
              _js2n__-prdslib.records.record
                {
                  expression = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  language = _js2n__-prdslib.isType '"String",
                  trim = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.MethodCallExpression!predicate"
        | doc "Calls a Java bean method."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      beanType = _js2n__-prdslib.isType '"String",
                      id = _js2n__-prdslib.isType '"String",
                      method = _js2n__-prdslib.isType '"String",
                      ref = _js2n__-prdslib.isType '"String",
                      resultType = _js2n__-prdslib.isType '"String",
                      scope =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "Singleton", "Request", "Prototype" ]
                            ],
                      trim = _js2n__-prdslib.isType '"Bool",
                      validate = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.MvelExpression!predicate"
        | doc "Evaluates a MVEL template."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.OgnlExpression!predicate"
        | doc "Evaluates an OGNL expression (Apache Commons OGNL)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.PythonExpression!predicate"
        | doc "Evaluates a Python expression."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.RefExpression!predicate"
        | doc "Uses an existing expression from the registry."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.SimpleExpression!predicate"
        | doc "Evaluates a Camel simple expression."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.SpELExpression!predicate"
        | doc "Evaluates a Spring expression (SpEL)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.TokenizerExpression!predicate"
        | doc "Tokenize text payloads using delimiter patterns."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          endToken = _js2n__-prdslib.isType '"String",
                          group = _js2n__-prdslib.isType '"String",
                          groupDelimiter = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          includeTokens = _js2n__-prdslib.isType '"Bool",
                          inheritNamespaceTagName =
                            _js2n__-prdslib.isType '"String",
                          regex = _js2n__-prdslib.isType '"Bool",
                          resultType = _js2n__-prdslib.isType '"String",
                          skipFirst = _js2n__-prdslib.isType '"Bool",
                          source = _js2n__-prdslib.isType '"String",
                          token = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                          xml = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "token" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.VariableExpression!predicate"
        | doc "Gets a variable"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.WasmExpression!predicate"
        | doc "Call a wasm (web assembly) function."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          module = _js2n__-prdslib.isType '"String",
                          resultType = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression", "module" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.XMLTokenizerExpression!predicate"
        | doc "Tokenize XML payloads."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          group = _js2n__-prdslib.isType '"Number",
                          id = _js2n__-prdslib.isType '"String",
                          mode =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "i", "w", "u", "t" ]
                                ],
                          namespace =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                                ],
                          resultType = _js2n__-prdslib.isType '"String",
                          source = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.XPathExpression!predicate"
        | doc "Evaluates an XPath expression against an XML payload."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          documentType = _js2n__-prdslib.isType '"String",
                          expression = _js2n__-prdslib.isType '"String",
                          factoryRef = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          logNamespaces = _js2n__-prdslib.isType '"Bool",
                          namespace =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                                ],
                          objectModel = _js2n__-prdslib.isType '"String",
                          preCompile = _js2n__-prdslib.isType '"Bool",
                          resultQName =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "NUMBER",
                                      "STRING",
                                      "BOOLEAN",
                                      "NODESET",
                                      "NODE"
                                    ]
                                ],
                          resultType = _js2n__-prdslib.isType '"String",
                          saxon = _js2n__-prdslib.isType '"Bool",
                          source = _js2n__-prdslib.isType '"String",
                          threadSafety = _js2n__-prdslib.isType '"Bool",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.language.XQueryExpression!predicate"
        | doc "Evaluates an XQuery expressions against an XML payload."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          configurationRef = _js2n__-prdslib.isType '"String",
                          expression = _js2n__-prdslib.isType '"String",
                          id = _js2n__-prdslib.isType '"String",
                          namespace =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.PropertyDefinition!predicate"
                                ],
                          resultType = _js2n__-prdslib.isType '"String",
                          source = _js2n__-prdslib.isType '"String",
                          trim = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.CustomLoadBalancerDefinition!predicate"
        | doc "To use a custom load balancer implementation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          id = _js2n__-prdslib.isType '"String",
                          ref = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.records.required [ "ref" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.FailoverLoadBalancerDefinition!predicate"
        | doc "In case of failures the exchange will be tried on the next endpoint."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exception =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  maximumFailoverAttempts = _js2n__-prdslib.isType '"String",
                  roundRobin = _js2n__-prdslib.isType '"String",
                  sticky = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.RandomLoadBalancerDefinition!predicate"
        | doc "The destination endpoints are selected randomly."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { id = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.RoundRobinLoadBalancerDefinition!predicate"
        | doc "The destination endpoints are selected in a round-robin fashion. This is a well-known and classic policy, which spreads the load evenly."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { id = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.StickyLoadBalancerDefinition!predicate"
        | doc "Sticky load balancing using an expression to calculate a correlation key to perform the sticky load balancing."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  correlationExpression =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ExpressionSubElementDefinition!predicate",
                  id = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.TopicLoadBalancerDefinition!predicate"
        | doc "Topic which sends to all destinations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { id = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.loadbalancer.WeightedLoadBalancerDefinition!predicate"
        | doc "Uses a weighted load distribution ratio for each server with respect to others."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "distributionRatio" ],
              _js2n__-prdslib.records.record
                {
                  distributionRatio = _js2n__-prdslib.isType '"String",
                  distributionRatioDelimiter = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  roundRobin = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.ApiKeyDefinition!predicate"
        | doc "Rest security basic auth definition"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "name" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  inCookie = _js2n__-prdslib.isType '"Bool",
                  inHeader = _js2n__-prdslib.isType '"Bool",
                  inQuery = _js2n__-prdslib.isType '"Bool",
                  key = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.BasicAuthDefinition!predicate"
        | doc "Rest security basic auth definition"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.BearerTokenDefinition!predicate"
        | doc "Rest security bearer token authentication definition"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  format = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.DeleteDefinition!predicate"
        | doc "Rest DELETE command"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiDocs = _js2n__-prdslib.isType '"Bool",
                  bindingMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "off", "auto", "json", "xml", "json_xml" ]
                        ],
                  clientRequestValidation = _js2n__-prdslib.isType '"Bool",
                  consumes = _js2n__-prdslib.isType '"String",
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  enableCORS = _js2n__-prdslib.isType '"Bool",
                  enableNoContentResponse = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  outType = _js2n__-prdslib.isType '"String",
                  param =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ParamDefinition!predicate"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  produces = _js2n__-prdslib.isType '"String",
                  responseMessage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ResponseMessageDefinition!predicate"
                        ],
                  routeId = _js2n__-prdslib.isType '"String",
                  security =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.SecurityDefinition!predicate"
                        ],
                  skipBindingOnErrorCode = _js2n__-prdslib.isType '"Bool",
                  streamCache = _js2n__-prdslib.isType '"Bool",
                  to =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ToDefinition!predicate",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.GetDefinition!predicate"
        | doc "Rest GET command"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiDocs = _js2n__-prdslib.isType '"Bool",
                  bindingMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "off", "auto", "json", "xml", "json_xml" ]
                        ],
                  clientRequestValidation = _js2n__-prdslib.isType '"Bool",
                  consumes = _js2n__-prdslib.isType '"String",
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  enableCORS = _js2n__-prdslib.isType '"Bool",
                  enableNoContentResponse = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  outType = _js2n__-prdslib.isType '"String",
                  param =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ParamDefinition!predicate"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  produces = _js2n__-prdslib.isType '"String",
                  responseMessage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ResponseMessageDefinition!predicate"
                        ],
                  routeId = _js2n__-prdslib.isType '"String",
                  security =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.SecurityDefinition!predicate"
                        ],
                  skipBindingOnErrorCode = _js2n__-prdslib.isType '"Bool",
                  streamCache = _js2n__-prdslib.isType '"Bool",
                  to =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ToDefinition!predicate",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.HeadDefinition!predicate"
        | doc "Rest HEAD command"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiDocs = _js2n__-prdslib.isType '"Bool",
                  bindingMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "off", "auto", "json", "xml", "json_xml" ]
                        ],
                  clientRequestValidation = _js2n__-prdslib.isType '"Bool",
                  consumes = _js2n__-prdslib.isType '"String",
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  enableCORS = _js2n__-prdslib.isType '"Bool",
                  enableNoContentResponse = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  outType = _js2n__-prdslib.isType '"String",
                  param =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ParamDefinition!predicate"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  produces = _js2n__-prdslib.isType '"String",
                  responseMessage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ResponseMessageDefinition!predicate"
                        ],
                  routeId = _js2n__-prdslib.isType '"String",
                  security =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.SecurityDefinition!predicate"
                        ],
                  skipBindingOnErrorCode = _js2n__-prdslib.isType '"Bool",
                  streamCache = _js2n__-prdslib.isType '"Bool",
                  to =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ToDefinition!predicate",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.MutualTLSDefinition!predicate"
        | doc "Rest security mutual TLS authentication definition"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.OAuth2Definition!predicate"
        | doc "Rest security OAuth2 definition"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  authorizationUrl = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  flow =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "implicit",
                              "password",
                              "application",
                              "clientCredentials",
                              "accessCode",
                              "authorizationCode"
                            ]
                        ],
                  key = _js2n__-prdslib.isType '"String",
                  refreshUrl = _js2n__-prdslib.isType '"String",
                  scopes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
                        ],
                  tokenUrl = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.OpenApiDefinition!predicate"
        | doc "To use OpenApi as contract-first with Camel Rest DSL."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "specification" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  missingOperation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "fail", "ignore", "mock" ]
                        ],
                  mockIncludePattern = _js2n__-prdslib.isType '"String",
                  routeId = _js2n__-prdslib.isType '"String",
                  specification = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.OpenIdConnectDefinition!predicate"
        | doc "Rest security OpenID Connect definition"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "url" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.ParamDefinition!predicate"
        | doc "To specify the rest operation parameters."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  allowableValues =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ValueDefinition!predicate"
                        ],
                  arrayType = _js2n__-prdslib.isType '"String",
                  collectionFormat =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "csv", "multi", "pipes", "ssv", "tsv" ]
                        ],
                  dataFormat = _js2n__-prdslib.isType '"String",
                  dataType = _js2n__-prdslib.isType '"String",
                  defaultValue = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "body", "formData", "header", "path", "query" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.PatchDefinition!predicate"
        | doc "Rest PATCH command"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiDocs = _js2n__-prdslib.isType '"Bool",
                  bindingMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "off", "auto", "json", "xml", "json_xml" ]
                        ],
                  clientRequestValidation = _js2n__-prdslib.isType '"Bool",
                  consumes = _js2n__-prdslib.isType '"String",
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  enableCORS = _js2n__-prdslib.isType '"Bool",
                  enableNoContentResponse = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  outType = _js2n__-prdslib.isType '"String",
                  param =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ParamDefinition!predicate"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  produces = _js2n__-prdslib.isType '"String",
                  responseMessage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ResponseMessageDefinition!predicate"
                        ],
                  routeId = _js2n__-prdslib.isType '"String",
                  security =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.SecurityDefinition!predicate"
                        ],
                  skipBindingOnErrorCode = _js2n__-prdslib.isType '"Bool",
                  streamCache = _js2n__-prdslib.isType '"Bool",
                  to =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ToDefinition!predicate",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.PostDefinition!predicate"
        | doc "Rest POST command"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiDocs = _js2n__-prdslib.isType '"Bool",
                  bindingMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "off", "auto", "json", "xml", "json_xml" ]
                        ],
                  clientRequestValidation = _js2n__-prdslib.isType '"Bool",
                  consumes = _js2n__-prdslib.isType '"String",
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  enableCORS = _js2n__-prdslib.isType '"Bool",
                  enableNoContentResponse = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  outType = _js2n__-prdslib.isType '"String",
                  param =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ParamDefinition!predicate"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  produces = _js2n__-prdslib.isType '"String",
                  responseMessage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ResponseMessageDefinition!predicate"
                        ],
                  routeId = _js2n__-prdslib.isType '"String",
                  security =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.SecurityDefinition!predicate"
                        ],
                  skipBindingOnErrorCode = _js2n__-prdslib.isType '"Bool",
                  streamCache = _js2n__-prdslib.isType '"Bool",
                  to =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ToDefinition!predicate",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.PutDefinition!predicate"
        | doc "Rest PUT command"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiDocs = _js2n__-prdslib.isType '"Bool",
                  bindingMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "off", "auto", "json", "xml", "json_xml" ]
                        ],
                  clientRequestValidation = _js2n__-prdslib.isType '"Bool",
                  consumes = _js2n__-prdslib.isType '"String",
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  enableCORS = _js2n__-prdslib.isType '"Bool",
                  enableNoContentResponse = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  outType = _js2n__-prdslib.isType '"String",
                  param =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ParamDefinition!predicate"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  produces = _js2n__-prdslib.isType '"String",
                  responseMessage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ResponseMessageDefinition!predicate"
                        ],
                  routeId = _js2n__-prdslib.isType '"String",
                  security =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.SecurityDefinition!predicate"
                        ],
                  skipBindingOnErrorCode = _js2n__-prdslib.isType '"Bool",
                  streamCache = _js2n__-prdslib.isType '"Bool",
                  to =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ToDefinition!predicate",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.ResponseHeaderDefinition!predicate"
        | doc "To specify the rest operation response headers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  allowableValues =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.ValueDefinition!predicate"
                        ],
                  arrayType = _js2n__-prdslib.isType '"String",
                  collectionFormat =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "csv", "multi", "pipes", "ssv", "tsv" ]
                        ],
                  dataFormat = _js2n__-prdslib.isType '"String",
                  dataType = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  example = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.ResponseMessageDefinition!predicate"
        | doc "To specify the rest operation response messages."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "message" ],
              _js2n__-prdslib.records.record
                {
                  code = _js2n__-prdslib.isType '"String",
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
                        ],
                  header =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ResponseHeaderDefinition!predicate"
                        ],
                  message = _js2n__-prdslib.isType '"String",
                  responseModel = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.RestConfigurationDefinition!predicate"
        | doc "To configure rest"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiComponent =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "openapi", "swagger" ]
                        ],
                  apiContextPath = _js2n__-prdslib.isType '"String",
                  apiContextRouteId = _js2n__-prdslib.isType '"String",
                  apiHost = _js2n__-prdslib.isType '"String",
                  apiProperty =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
                        ],
                  apiVendorExtension = _js2n__-prdslib.isType '"Bool",
                  bindingMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "auto", "json", "json_xml", "off", "xml" ]
                        ],
                  bindingPackageScan = _js2n__-prdslib.isType '"String",
                  clientRequestValidation = _js2n__-prdslib.isType '"Bool",
                  component =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "platform-http",
                              "servlet",
                              "jetty",
                              "undertow",
                              "netty-http",
                              "coap"
                            ]
                        ],
                  componentProperty =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
                        ],
                  consumerProperty =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
                        ],
                  contextPath = _js2n__-prdslib.isType '"String",
                  corsHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
                        ],
                  dataFormatProperty =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
                        ],
                  enableCORS = _js2n__-prdslib.isType '"Bool",
                  enableNoContentResponse = _js2n__-prdslib.isType '"Bool",
                  endpointProperty =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
                        ],
                  host = _js2n__-prdslib.isType '"String",
                  hostNameResolver =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "allLocalIp", "localHostName", "localIp", "none" ]
                        ],
                  inlineRoutes = _js2n__-prdslib.isType '"Bool",
                  jsonDataFormat = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType '"String",
                  producerApiDoc = _js2n__-prdslib.isType '"String",
                  producerComponent =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "vertx-http", "http", "undertow", "netty-http" ]
                        ],
                  scheme = _js2n__-prdslib.isType '"String",
                  skipBindingOnErrorCode = _js2n__-prdslib.isType '"Bool",
                  useXForwardHeaders = _js2n__-prdslib.isType '"Bool",
                  xmlDataFormat = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.RestDefinition!predicate"
        | doc "Defines a rest service using the rest-dsl"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiDocs = _js2n__-prdslib.isType '"Bool",
                  bindingMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "off", "auto", "json", "xml", "json_xml" ]
                        ],
                  clientRequestValidation = _js2n__-prdslib.isType '"Bool",
                  consumes = _js2n__-prdslib.isType '"String",
                  delete =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.DeleteDefinition!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  enableCORS = _js2n__-prdslib.isType '"Bool",
                  enableNoContentResponse = _js2n__-prdslib.isType '"Bool",
                  get =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.GetDefinition!predicate"
                        ],
                  head =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.HeadDefinition!predicate"
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  openApi =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.OpenApiDefinition!predicate",
                  patch =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.PatchDefinition!predicate"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  post =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.PostDefinition!predicate"
                        ],
                  produces = _js2n__-prdslib.isType '"String",
                  put =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.PutDefinition!predicate"
                        ],
                  securityDefinitions =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestSecuritiesDefinition!predicate",
                  securityRequirements =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.SecurityDefinition!predicate"
                        ],
                  skipBindingOnErrorCode = _js2n__-prdslib.isType '"Bool",
                  tag = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.RestPropertyDefinition!predicate"
        | doc "A key value pair"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "value" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.RestSecuritiesDefinition!predicate"
        | doc "To configure rest security definitions."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiKey =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.ApiKeyDefinition!predicate",
                  basicAuth =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.BasicAuthDefinition!predicate",
                  bearer =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.BearerTokenDefinition!predicate",
                  mutualTLS =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.MutualTLSDefinition!predicate",
                  oauth2 =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.OAuth2Definition!predicate",
                  openIdConnect =
                    _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.OpenIdConnectDefinition!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.rest.SecurityDefinition!predicate"
        | doc "Rest security definition"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  scopes = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jCharacterTokenizerDefinition!predicate"
        | doc "Camel AI: Tokenizer for splitting by character."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "maxOverlap", "maxTokens" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  maxOverlap = _js2n__-prdslib.isType '"Number",
                  maxTokens = _js2n__-prdslib.isType '"Number",
                  tokenizerType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "OPEN_AI", "AZURE", "QWEN" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jParagraphTokenizerDefinition!predicate"
        | doc "Camel AI: Tokenizer for splitting by paragraphs."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "maxOverlap", "maxTokens" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  maxOverlap = _js2n__-prdslib.isType '"Number",
                  maxTokens = _js2n__-prdslib.isType '"Number",
                  tokenizerType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "OPEN_AI", "AZURE", "QWEN" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jSentenceTokenizerDefinition!predicate"
        | doc "Camel AI: Tokenizer for splitting by sentences."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "maxOverlap", "maxTokens" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  maxOverlap = _js2n__-prdslib.isType '"Number",
                  maxTokens = _js2n__-prdslib.isType '"Number",
                  tokenizerType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "OPEN_AI", "AZURE", "QWEN" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jTokenizerDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "maxOverlap", "maxTokens" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  maxOverlap = _js2n__-prdslib.isType '"Number",
                  maxTokens = _js2n__-prdslib.isType '"Number",
                  tokenizerType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "OPEN_AI", "AZURE", "QWEN" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:items/definitions/org.apache.camel.model.tokenizer.LangChain4jWordTokenizerDefinition!predicate"
        | doc "Camel AI: Tokenizer for splitting by word."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "maxOverlap", "maxTokens" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  maxOverlap = _js2n__-prdslib.isType '"Number",
                  maxTokens = _js2n__-prdslib.isType '"Number",
                  tokenizerType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "OPEN_AI", "AZURE", "QWEN" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  Array (
      _js2n__-prdslib.contract_from_predicate
        (_js2n__-prdslib.allOf
          [
            _js2n__-prdslib.records.maxProperties 1,
            _js2n__-prdslib.records.record
              {
                beans =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.BeansDeserializer!predicate",
                dataFormats =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.DataFormatsDefinitionDeserializer!predicate",
                errorHandler =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.ErrorHandlerDeserializer!predicate",
                from =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.dsl.yaml.deserializers.RouteFromDefinitionDeserializer!predicate",
                intercept =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.InterceptDefinition!predicate",
                interceptFrom =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.InterceptFromDefinition!predicate",
                interceptSendToEndpoint =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.InterceptSendToEndpointDefinition!predicate",
                onCompletion =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnCompletionDefinition!predicate",
                onException =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.OnExceptionDefinition!predicate",
                rest =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestDefinition!predicate",
                restConfiguration =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.rest.RestConfigurationDefinition!predicate",
                route =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RouteDefinition!predicate",
                routeConfiguration =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RouteConfigurationDefinition!predicate",
                routeTemplate =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.RouteTemplateDefinition!predicate",
                templatedRoute =
                  _js2n__-refsenv."_js2n__-:items/definitions/org.apache.camel.model.TemplatedRouteDefinition!predicate",
              } {} false _js2n__-prdslib.never
          ])
    )