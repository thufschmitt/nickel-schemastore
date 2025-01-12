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
      "_js2n__-:definitions/Authors!predicate"
        | doc m%"
          The `authors` field lists people or organizations that are considered the
          "authors" of the package. The exact meaning is open to interpretation — it may
          list the original or primary authors, current maintainers, or owners of the
          package. These names will be listed on the crate's page on
          [crates.io](https://crates.io). An optional email address may be included within angled
          brackets at the end of each author.
          
          > **Note**: [crates.io](https://crates.io) requires at least one author to be listed.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/Build!predicate"
        | doc m%"
          The `build` field specifies a file in the package root which is a [build script](https://doc.rust-lang.org/cargo/reference/build-scripts.html) for building native code. More information can be found in the [build script guide](https://doc.rust-lang.org/cargo/reference/build-scripts.html).
          
          
          ```toml
          [package]
          # ...
          build = "build.rs"
          ```
          
          The default is `"build.rs"`, which loads the script from a file named
          `build.rs` in the root of the package. Use `build = "custom_build_name.rs"` to
          specify a path to a different file or `build = false` to disable automatic
          detection of the build script.
          
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.enum [ true, false ]
                ]
            ],
      "_js2n__-:definitions/Categories!predicate"
        | doc m%"
          The `categories` field is an array of strings of the categories this package
          belongs to.
          
          ```toml
          categories = ["command-line-utilities", "development-tools::cargo-plugins"]
          ```
          
          > **Note**: [crates.io](https://crates.io) has a maximum of 5 categories. Each category should
          > match one of the strings available at https://crates.io/category_slugs, and
          > must match exactly.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/DebugLevel!predicate"
        | doc m%"
          The `debug` setting controls the [`-C debuginfo` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#debuginfo) which controls the
          amount of debug information included in the compiled binary.
        "%
        = _js2n__-prdslib.enum
            [
              0,
              1,
              2,
              true,
              false,
              "none",
              "line-directives-only",
              "line-tables-only",
              "limited",
              "full"
            ],
      "_js2n__-:definitions/Dependency!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/SemVerRequirement!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DetailedDependency!predicate"
            ],
      "_js2n__-:definitions/Description!predicate"
        | doc m%"
          The description is a short blurb about the package. [crates.io](https://crates.io) will display
          this with your package. This should be plain text (not Markdown).
          
          ```toml
          [package]
          # ...
          description = "A short description of my package"
          ```
          
          > **Note**: [crates.io](https://crates.io) requires the `description` to be set.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/DetailedDependency!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  branch = _js2n__-prdslib.isType '"String",
                  default-features = _js2n__-prdslib.isType '"Bool",
                  default_features = _js2n__-prdslib.isType '"Bool",
                  features =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  git = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                  package = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  public = _js2n__-prdslib.isType '"Bool",
                  registry = _js2n__-prdslib.isType '"String",
                  registry-index = _js2n__-prdslib.isType '"String",
                  rev = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/SemVerRequirement!predicate",
                  workspace = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DetailedLint!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  level =
                    _js2n__-refsenv."_js2n__-:definitions/LintLevel!predicate",
                  "priority" = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Documentation!predicate"
        | doc m%"
          
          The `documentation` field specifies a URL to a website hosting the crate's
          documentation. If no URL is specified in the manifest file, [crates.io](https://crates.io) will
          automatically link your crate to the corresponding [docs.rs](https://docs.rs) page.
          
          ```toml
          [package]
          # ...
          documentation = "https://docs.rs/bitflags"
          ```
          
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Edition!predicate"
        | doc m%"
          The `edition` key affects which edition your package is compiled with. Cargo
          will always generate packages via [`cargo new`](https://doc.rust-lang.org/cargo/commands/cargo-new.html) with the `edition` key set to the
          latest edition. Setting the `edition` key in `[package]` will affect all
          targets/crates in the package, including test suites, benchmarks, binaries,
          examples, etc.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "2015", "2018", "2021", "2024" ]
            ],
      "_js2n__-:definitions/Exclude!predicate"
        | doc m%"
          You can explicitly specify that a set of file patterns should be ignored or
          included for the purposes of packaging. The patterns specified in the
          `exclude` field identify a set of files that are not included, and the
          patterns in `include` specify files that are explicitly included.
          
          The patterns should be [gitignore](https://git-scm.com/docs/gitignore)-style patterns. Briefly:
          
          - `foo` matches any file or directory with the name `foo` anywhere in the
            package. This is equivalent to the pattern `**/foo`.
          - `/foo` matches any file or directory with the name `foo` only in the root of
            the package.
          - `foo/` matches any *directory* with the name `foo` anywhere in the package.
          - Common glob patterns like `*`, `?`, and `[]` are supported:
            - `*` matches zero or more characters except `/`.  For example, `*.html`
              matches any file or directory with the `.html` extension anywhere in the
              package.
            - `?` matches any character except `/`. For example, `foo?` matches `food`,
              but not `foo`.
            - `[]` allows for matching a range of characters. For example, `[ab]`
              matches either `a` or `b`. `[a-z]` matches letters a through z.
          - `**/` prefix matches in any directory. For example, `**/foo/bar` matches the
            file or directory `bar` anywhere that is directly under directory `foo`.
          - `/**` suffix matches everything inside. For example, `foo/**` matches all
            files inside directory `foo`, including all files in subdirectories below
            `foo`.
          - `/**/` matches zero or more directories. For example, `a/**/b` matches
            `a/b`, `a/x/b`, `a/x/y/b`, and so on.
          - `!` prefix negates a pattern. For example, a pattern of `src/**.rs` and
            `!foo.rs` would match all files with the `.rs` extension inside the `src`
            directory, except for any file named `foo.rs`.
          
          If git is being used for a package, the `exclude` field will be seeded with
          the `gitignore` settings from the repository.
          
          ```toml
          [package]
          # ...
          exclude = ["build/**/*.o", "doc/**/*.html"]
          ```
          
          ```toml
          [package]
          # ...
          include = ["src/**/*", "Cargo.toml"]
          ```
          
          The options are mutually exclusive: setting `include` will override an
          `exclude`. Note that `include` must be an exhaustive list of files as otherwise
          necessary source files may not be included. The package's `Cargo.toml` is
          automatically included.
          
          The include/exclude list is also used for change tracking in some situations.
          For targets built with `rustdoc`, it is used to determine the list of files to
          track to determine if the target should be rebuilt. If the package has a
          [build script](https://doc.rust-lang.org/cargo/reference/build-scripts.html) that does not emit any `rerun-if-*` directives, then the
          include/exclude list is used for tracking if the build script should be re-run
          if any of those files change.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/Homepage!predicate"
        | doc m%"
          The `homepage` field should be a URL to a site that is the home page for your
          package.
          
          ```toml
          [package]
          # ...
          homepage = "https://serde.rs/"
          ```
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Include!predicate"
        | doc m%"
          You can explicitly specify that a set of file patterns should be ignored or
          included for the purposes of packaging. The patterns specified in the
          `exclude` field identify a set of files that are not included, and the
          patterns in `include` specify files that are explicitly included.
          
          The patterns should be [gitignore](https://git-scm.com/docs/gitignore)-style patterns. Briefly:
          
          - `foo` matches any file or directory with the name `foo` anywhere in the
            package. This is equivalent to the pattern `**/foo`.
          - `/foo` matches any file or directory with the name `foo` only in the root of
            the package.
          - `foo/` matches any *directory* with the name `foo` anywhere in the package.
          - Common glob patterns like `*`, `?`, and `[]` are supported:
            - `*` matches zero or more characters except `/`.  For example, `*.html`
              matches any file or directory with the `.html` extension anywhere in the
              package.
            - `?` matches any character except `/`. For example, `foo?` matches `food`,
              but not `foo`.
            - `[]` allows for matching a range of characters. For example, `[ab]`
              matches either `a` or `b`. `[a-z]` matches letters a through z.
          - `**/` prefix matches in any directory. For example, `**/foo/bar` matches the
            file or directory `bar` anywhere that is directly under directory `foo`.
          - `/**` suffix matches everything inside. For example, `foo/**` matches all
            files inside directory `foo`, including all files in subdirectories below
            `foo`.
          - `/**/` matches zero or more directories. For example, `a/**/b` matches
            `a/b`, `a/x/b`, `a/x/y/b`, and so on.
          - `!` prefix negates a pattern. For example, a pattern of `src/**.rs` and
            `!foo.rs` would match all files with the `.rs` extension inside the `src`
            directory, except for any file named `foo.rs`.
          
          If git is being used for a package, the `exclude` field will be seeded with
          the `gitignore` settings from the repository.
          
          ```toml
          [package]
          # ...
          exclude = ["build/**/*.o", "doc/**/*.html"]
          ```
          
          ```toml
          [package]
          # ...
          include = ["src/**/*", "Cargo.toml"]
          ```
          
          The options are mutually exclusive: setting `include` will override an
          `exclude`. Note that `include` must be an exhaustive list of files as otherwise
          necessary source files may not be included. The package's `Cargo.toml` is
          automatically included.
          
          The include/exclude list is also used for change tracking in some situations.
          For targets built with `rustdoc`, it is used to determine the list of files to
          track to determine if the target should be rebuilt. If the package has a
          [build script](https://doc.rust-lang.org/cargo/reference/build-scripts.html) that does not emit any `rerun-if-*` directives, then the
          include/exclude list is used for tracking if the build script should be re-run
          if any of those files change.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/Keywords!predicate"
        | doc m%"
          The `keywords` field is an array of strings that describe this package. This
          can help when searching for the package on a registry, and you may choose any
          words that would help someone find this crate.
          
          ```toml
          [package]
          # ...
          keywords = ["gamedev", "graphics"]
          ```
          
          > **Note**: [crates.io](https://crates.io) has a maximum of 5 keywords. Each keyword must be
          > ASCII text, start with a letter, and only contain letters, numbers, `_` or
          > `-`, and have at most 20 characters.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/License!predicate"
        | doc m%"
          The `license` field contains the name of the software license that the package
          is released under.
          
          [crates.io](https://crates.io/) interprets the `license` field as an [SPDX 2.1 license
          expression](https://spdx.org/spdx-specification-21-web-version#h.jxpfx0ykyb60). The name must be a known license
          from the [SPDX license list 3.6](https://github.com/spdx/license-list-data/tree/v3.6). Parentheses are not
          currently supported. See the [SPDX site](https://spdx.org/license-list) for more information.
          
          SPDX license expressions support AND and OR operators to combine multiple
          licenses.
          
          ```toml
          [package]
          # ...
          license = "MIT OR Apache-2.0"
          ```
          
          Using `OR` indicates the user may choose either license. Using `AND` indicates
          the user must comply with both licenses simultaneously. The `WITH` operator
          indicates a license with a special exception. Some examples:
          
          * `MIT OR Apache-2.0`
          * `LGPL-2.1 AND MIT AND BSD-2-Clause`
          * `GPL-2.0+ WITH Bison-exception-2.2`
          
          If a package is using a nonstandard license, then the `license-file` field may
          be specified in lieu of the `license` field.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/LicenseFile!predicate"
        | doc m%"
          The `license-file` field contains the path to a file
          containing the text of the license (relative to this `Cargo.toml`).
          
          ```toml
          [package]
          # ...
          license-file = "LICENSE.txt"
          ```
          
          > **Note**: [crates.io](https://crates.io) requires either `license` or `license-file` to be set.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Lint!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LintLevel!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DetailedLint!predicate"
            ],
      "_js2n__-:definitions/LintLevel!predicate"
        | doc "Specify the [lint level](https://doc.rust-lang.org/rustc/lints/levels.html) for a lint or lint group."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "forbid", "deny", "warn", "allow" ]
            ],
      "_js2n__-:definitions/Lints!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clippy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Lint!predicate"
                        ],
                  rust =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Lint!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Lto!predicate"
        | doc m%"
          The `lto` setting controls the [`-C lto` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#lto) which controls LLVM's [link time optimizations](https://llvm.org/docs/LinkTimeOptimization.html). LTO can produce better optimized code, using
          whole-program analysis, at the cost of longer linking time.
                              
          See also the [`-C linker-plugin-lto`](https://doc.rust-lang.org/rustc/codegen-options/index.html#linker-plugin-lto) `rustc` flag for cross-language LTO.
        "%
        = _js2n__-prdslib.enum [ "fat", "thin", "off", true, false ],
      "_js2n__-:definitions/MetaBuild!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/OptLevel!predicate"
        | doc m%"
          The `opt-level` setting controls the [`-C opt-level` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#opt-level) which controls the level
          of optimization. Higher optimization levels may produce faster runtime code at
          the expense of longer compiler times. Higher levels may also change and
          rearrange the compiled code which may make it harder to use with a debugger.
          
          It is recommended to experiment with different levels to find the right
          balance for your project. There may be surprising results, such as level `3`
          being slower than `2`, or the `"s"` and `"z"` levels not being necessarily
          smaller. You may also want to reevaluate your settings over time as newer
          versions of `rustc` changes optimization behavior.
          
          See also [Profile Guided Optimization](https://doc.rust-lang.org/rustc/profile-guided-optimization.html) for more advanced optimization
          techniques.
        "%
        = _js2n__-prdslib.enum [ 0, 1, 2, 3, "s", "z" ],
      "_js2n__-:definitions/Package!predicate"
        | doc m%"
          The only field required by Cargo is [`name`](https://doc.rust-lang.org/cargo/reference/manifest.html#the-name-field).
           If publishing to a registry, the registry may
          require additional fields. See the notes below and [the publishing chapter](https://doc.rust-lang.org/cargo/reference/publishing.html) for requirements for publishing to [crates.io](https://crates.io/).
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  authors =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Authors!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  autobenches = _js2n__-prdslib.isType '"Bool",
                  autobins = _js2n__-prdslib.isType '"Bool",
                  autoexamples = _js2n__-prdslib.isType '"Bool",
                  autotests = _js2n__-prdslib.isType '"Bool",
                  build =
                    _js2n__-refsenv."_js2n__-:definitions/Build!predicate",
                  categories =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Categories!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  default-run = _js2n__-prdslib.isType '"String",
                  description =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Description!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  documentation =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  edition =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Edition!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  exclude =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Exclude!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  homepage =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Homepage!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  im-a-teapot = _js2n__-prdslib.isType '"Bool",
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Include!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  keywords =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Keywords!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  license =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/License!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  license-file =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LicenseFile!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  links = _js2n__-prdslib.isType '"String",
                  metabuild =
                    _js2n__-refsenv."_js2n__-:definitions/MetaBuild!predicate",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              playdate =
                                _js2n__-refsenv."_js2n__-:definitions/PlaydateMetadata!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  namespaced-features = _js2n__-prdslib.isType '"Bool",
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Publish!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  publish-lockfile = _js2n__-prdslib.isType '"Bool",
                  readme =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Readme!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  repository =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Repository!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  resolver =
                    _js2n__-refsenv."_js2n__-:definitions/Resolver!predicate",
                  rust-version =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RustVersion!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  version =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/SemVer!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WorkspaceInheritance!predicate"
                        ],
                  workspace = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Panic!predicate"
        | doc m%"
          The `panic` setting controls the [`-C panic` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#panic) which controls which panic
          strategy to use.
          
          When set to `"unwind"`, the actual value depends on the default of the target
          platform. For example, the NVPTX platform does not support unwinding, so it
          always uses `"abort"`.
          
          Tests, benchmarks, build scripts, and proc macros ignore the `panic` setting.
          The `rustc` test harness currently requires `unwind` behavior. See the
          [`panic-abort-tests`](https://doc.rust-lang.org/cargo/reference/unstable.html#panic-abort-tests) unstable flag which enables `abort` behavior.
          
          Additionally, when using the `abort` strategy and building a test, all of the
          dependencies will also be forced to built with the `unwind` strategy.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "unwind", "abort" ]
            ],
      "_js2n__-:definitions/Platform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  build-dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                        ],
                  build_dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                        ],
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                        ],
                  dev-dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                        ],
                  dev_dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/PlaydateMetadata!predicate"
        | doc "Metadata and build configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "bundle-id" ],
              _js2n__-prdslib.records.record
                {
                  assets =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PlaydateMetadataAssetsMap!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/PlaydateMetadataAssetsArray!predicate"
                        ],
                  author = _js2n__-prdslib.isType '"String",
                  build-number =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  bundle-id = _js2n__-prdslib.isType '"String",
                  content-warning = _js2n__-prdslib.isType '"String",
                  content-warning2 = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  dev-assets =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PlaydateMetadataAssetsMap!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/PlaydateMetadataAssetsArray!predicate"
                        ],
                  image-path = _js2n__-prdslib.isType '"String",
                  launch-sound-path = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/PlaydateMetadataOptions!predicate",
                  support =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PlaydateMetadataAssetsArray!predicate"
        | doc "List of paths to include."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/PlaydateMetadataAssetsMap!predicate"
        | doc "Rules used to resolve paths to include."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/PlaydateMetadataAssetsOptions!predicate",
                } {} true
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Bool"
                  ])
            ],
      "_js2n__-:definitions/PlaydateMetadataAssetsOptions!predicate"
        | doc "Options for assets paths resolution and how to build assets collection"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dependencies = _js2n__-prdslib.isType '"Bool",
                  follow-symlinks = _js2n__-prdslib.isType '"Bool",
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "copy", "link" ]
                        ],
                  overwrite = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PlaydateMetadataOptions!predicate"
        | doc "Package build options."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  assets =
                    _js2n__-refsenv."_js2n__-:definitions/PlaydateMetadataAssetsOptions!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Profile!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  codegen-units =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  debug =
                    _js2n__-refsenv."_js2n__-:definitions/DebugLevel!predicate",
                  debug-assertions = _js2n__-prdslib.isType '"Bool",
                  dir-name = _js2n__-prdslib.isType '"String",
                  incremental = _js2n__-prdslib.isType '"Bool",
                  inherits = _js2n__-prdslib.isType '"String",
                  lto = _js2n__-refsenv."_js2n__-:definitions/Lto!predicate",
                  opt-level =
                    _js2n__-refsenv."_js2n__-:definitions/OptLevel!predicate",
                  overflow-checks = _js2n__-prdslib.isType '"Bool",
                  package =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Profile!predicate"
                        ],
                  panic =
                    _js2n__-refsenv."_js2n__-:definitions/Panic!predicate",
                  rpath = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ProfileWithBuildOverride!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Profile!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      build-override =
                        _js2n__-refsenv."_js2n__-:definitions/Profile!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/Profiles!predicate"
        | doc m%"
          Profiles provide a way to alter the compiler settings, influencing things like optimizations and debugging symbols.
          
          Cargo has 4 built-in profiles: dev, release, test, and bench. It automatically chooses the profile based on which command is being run, the package and target that is being built, and command-line flags like --release.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bench =
                    _js2n__-refsenv."_js2n__-:definitions/ProfileWithBuildOverride!predicate",
                  dev =
                    _js2n__-refsenv."_js2n__-:definitions/ProfileWithBuildOverride!predicate",
                  release =
                    _js2n__-refsenv."_js2n__-:definitions/ProfileWithBuildOverride!predicate",
                  test =
                    _js2n__-refsenv."_js2n__-:definitions/ProfileWithBuildOverride!predicate",
                } {} true
                _js2n__-refsenv."_js2n__-:definitions/ProfileWithBuildOverride!predicate"
            ],
      "_js2n__-:definitions/Publish!predicate"
        | doc m%"
          The `publish` field can be used to prevent a package from being published to a package registry (like *crates.io*) by mistake, for instance to keep a package
          private in a company.
          
          ```toml
          [package]
          # ...
          publish = false
          ```
          
          The value may also be an array of strings which are registry names that are
          allowed to be published to.
          
          ```toml
          [package]
          # ...
          publish = ["some-registry-name"]
          ```
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.enum [ true, false ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/Readme!predicate"
        | doc m%"
          The `readme` field should be the path to a file in the package root (relative
          to this `Cargo.toml`) that contains general information about the package.
          This file will be transferred to the registry when you publish. [crates.io](https://crates.io)
          will interpret it as Markdown and render it on the crate's page.
          
          ```toml
          [package]
          # ...
          readme = "README.md"
          ```
          
          If no value is specified for this field, and a file named `README.md`,
          `README.txt` or `README` exists in the package root, then the name of that
          file will be used. You can suppress this behavior by setting this field to
          `false`. If the field is set to `true`, a default value of `README.md` will
          be assumed.
          
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.enum [ true, false ]
                ]
            ],
      "_js2n__-:definitions/Repository!predicate"
        | doc m%"
          The `repository` field should be a URL to the source repository for your
          package.
          
          ```toml
          [package]
          # ...
          repository = "https://github.com/rust-lang/cargo/"
          ```
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Resolver!predicate"
        | doc m%"
          A different feature resolver algorithm can be used by specifying the resolver version in Cargo.toml like this:
          
          [package]
          name = "my-package"
          version = "1.0.0"
          resolver = "2"
          
          The version "1" resolver is the original resolver that shipped with Cargo up to version 1.50. The default is "2" if the root package specifies edition = "2021" or a newer edition. Otherwise the default is "1".
          
          The version "2" resolver introduces changes in feature unification. See the features chapter for more details.
          
          The resolver is a global option that affects the entire workspace. The resolver version in dependencies is ignored, only the value in the top-level package will be used. If using a virtual workspace, the version should be specified in the [workspace] table, for example:
          
          [workspace]
          members = ["member1", "member2"]
          resolver = "2"
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "1", "2", "3" ]
            ],
      "_js2n__-:definitions/RustVersion!predicate"
        | doc m%"
          The `rust-version` field is an optional key that tells cargo what version of the
          Rust language and compiler your package can be compiled with. If the currently
          selected version of the Rust compiler is older than the stated version, cargo
          will exit with an error, telling the user what version is required.
          
          The first version of Cargo that supports this field was released with Rust 1.56.0.
          In older releases, the field will be ignored, and Cargo will display a warning.
          
          ```toml
          [package]
          # ...
          rust-version = "1.56"
          ```
          
          The Rust version must be a bare version number with two or three components; it
          cannot include semver operators or pre-release identifiers. Compiler pre-release
          identifiers such as -nightly will be ignored while checking the Rust version.
          The `rust-version` must be equal to or newer than the version that first
          introduced the configured `edition`.
          
          The `rust-version` may be ignored using the `--ignore-rust-version` option.
          
          Setting the `rust-version` key in `[package]` will affect all targets/crates in
          the package, including test suites, benchmarks, binaries, examples, etc.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/SemVer!predicate"
        | doc m%"
          Cargo bakes in the concept of [Semantic Versioning](https://semver.org/), so make sure you follow some basic rules:
          
          * Before you reach 1.0.0, anything goes, but if you make breaking changes,
              increment the minor version. In Rust, breaking changes include adding fields to
              structs or variants to enums.
          * After 1.0.0, only make breaking changes when you increment the major version.
              Don't break the build.
          * After 1.0.0, don't add any new public API (no new `pub` anything) in patch-level
              versions. Always increment the minor version if you add any new `pub` structs,
              traits, fields, types, functions, methods or anything else.
          * Use version numbers with three numeric parts such as 1.0.0 rather than 1.0.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/SemVerRequirement!predicate"
        | doc "The [version requirement](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html) of the target dependency."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Target!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bench = _js2n__-prdslib.isType '"Bool",
                  crate-type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  crate_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "doc" = _js2n__-prdslib.isType '"Bool",
                  doctest = _js2n__-prdslib.isType '"Bool",
                  edition =
                    _js2n__-refsenv."_js2n__-:definitions/Edition!predicate",
                  harness = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  plugin = _js2n__-prdslib.isType '"Bool",
                  proc-macro = _js2n__-prdslib.isType '"Bool",
                  proc_macro = _js2n__-prdslib.isType '"Bool",
                  required-features =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  test = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Workspace!predicate"
        | doc m%"
          The `[workspace]` table in `Cargo.toml` defines which packages are members of
          the workspace:
          
          ```toml
          [workspace]
          members = ["member1", "path/to/member2", "crates/*"]
          exclude = ["crates/foo", "path/to/other"]
          ```
          
          An empty `[workspace]` table can be used with a `[package]` to conveniently
          create a workspace with the package and all of its path dependencies.
          
          All [`path` dependencies](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html#specifying-path-dependencies) residing in the workspace directory automatically
          become members. Additional members can be listed with the `members` key, which
          should be an array of strings containing directories with `Cargo.toml` files.
          
          The `members` list also supports [globs](https://docs.rs/glob/0.3.0/glob/struct.Pattern.html) to match multiple paths, using
          typical filename glob patterns like `*` and `?`.
          
          The `exclude` key can be used to prevent paths from being included in a
          workspace. This can be useful if some path dependencies aren't desired to be
          in the workspace at all, or using a glob pattern and you want to remove a
          directory.
          
          An empty `[workspace]` table can be used with a `[package]` to conveniently
          create a workspace with the package and all of its path dependencies.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  default-members =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                        ],
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  lints =
                    _js2n__-refsenv."_js2n__-:definitions/Lints!predicate",
                  members =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  package =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              authors =
                                _js2n__-refsenv."_js2n__-:definitions/Authors!predicate",
                              categories =
                                _js2n__-refsenv."_js2n__-:definitions/Categories!predicate",
                              description =
                                _js2n__-refsenv."_js2n__-:definitions/Description!predicate",
                              documentation =
                                _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                              edition =
                                _js2n__-refsenv."_js2n__-:definitions/Edition!predicate",
                              exclude =
                                _js2n__-refsenv."_js2n__-:definitions/Exclude!predicate",
                              homepage =
                                _js2n__-refsenv."_js2n__-:definitions/Homepage!predicate",
                              include =
                                _js2n__-refsenv."_js2n__-:definitions/Include!predicate",
                              keywords =
                                _js2n__-refsenv."_js2n__-:definitions/Keywords!predicate",
                              license =
                                _js2n__-refsenv."_js2n__-:definitions/License!predicate",
                              license-file =
                                _js2n__-refsenv."_js2n__-:definitions/LicenseFile!predicate",
                              publish =
                                _js2n__-refsenv."_js2n__-:definitions/Publish!predicate",
                              readme =
                                _js2n__-refsenv."_js2n__-:definitions/Readme!predicate",
                              repository =
                                _js2n__-refsenv."_js2n__-:definitions/Repository!predicate",
                              rust-version =
                                _js2n__-refsenv."_js2n__-:definitions/RustVersion!predicate",
                              version =
                                _js2n__-refsenv."_js2n__-:definitions/SemVer!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  resolver =
                    _js2n__-refsenv."_js2n__-:definitions/Resolver!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/WorkspaceInheritance!predicate"
        | doc "The `workspace` field allow keys to be inherited by defining them in the member package with `{key}.workspace = true`"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  workspace =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.enum [ true ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              badges =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record {} {} true
                              (_js2n__-prdslib.isType '"String")
                          ])
                    ],
              bench =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/Target!predicate"
                    ],
              bin =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/Target!predicate"
                    ],
              build-dependencies =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                    ],
              build_dependencies =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                    ],
              cargo-features =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              dependencies =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                    ],
              dev-dependencies =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                    ],
              dev_dependencies =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                    ],
              example =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/Target!predicate"
                    ],
              features =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.isType '"String")
                          ])
                    ],
              lib = _js2n__-refsenv."_js2n__-:definitions/Target!predicate",
              lints =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/Lints!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { workspace = _js2n__-prdslib.isType '"Bool", } {}
                            false _js2n__-prdslib.never
                        ]
                    ],
              package =
                _js2n__-refsenv."_js2n__-:definitions/Package!predicate",
              patch =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                          ])
                    ],
              profile =
                _js2n__-refsenv."_js2n__-:definitions/Profiles!predicate",
              project =
                _js2n__-refsenv."_js2n__-:definitions/Package!predicate",
              replace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                    ],
              target =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/Platform!predicate"
                    ],
              test =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/Target!predicate"
                    ],
              workspace =
                _js2n__-refsenv."_js2n__-:definitions/Workspace!predicate",
            } {} true _js2n__-prdslib.always
        ])