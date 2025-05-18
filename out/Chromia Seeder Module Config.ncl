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
    = {}
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.required [ "module" ],
          _js2n__-prdslib.records.record
            { module = _js2n__-prdslib.isType '"String", } {} true
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record
                  {
                    attributes =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record {} {} true
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.ifThenElse
                                    (_js2n__-prdslib.records.record
                                      {
                                        generator =
                                          _js2n__-prdslib.const "text",
                                      } {} true _js2n__-prdslib.always)
                                    (_js2n__-prdslib.records.record
                                      {
                                        max =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.numbers.minimum
                                                  1
                                              ],
                                        min =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.numbers.minimum
                                                  1
                                              ],
                                      } {} true _js2n__-prdslib.always)
                                    (_js2n__-prdslib.ifThenElse
                                      (_js2n__-prdslib.records.record
                                        {
                                          generator =
                                            _js2n__-prdslib.const "range",
                                        } {} true _js2n__-prdslib.always)
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.records.required
                                            [ "max", "min" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              max =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Number",
                                                      _js2n__-prdslib.numbers.multipleOf
                                                        1
                                                    ],
                                              min =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Number",
                                                      _js2n__-prdslib.numbers.multipleOf
                                                        1
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ])
                                      (_js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            generator =
                                              _js2n__-prdslib.const
                                                  "predefined",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "values" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                values =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.anyOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.isType
                                                                '"Bool",
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.isType
                                                                '"Array"
                                                            ])
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ])
                                        (_js2n__-prdslib.ifThenElse
                                          (_js2n__-prdslib.records.record
                                            {
                                              generator =
                                                _js2n__-prdslib.const
                                                    "byte_array",
                                            } {} true _js2n__-prdslib.always)
                                          (_js2n__-prdslib.records.record
                                            {
                                              size =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Integer,
                                                      _js2n__-prdslib.numbers.minimum
                                                        1
                                                    ],
                                            } {} true _js2n__-prdslib.always)
                                          _js2n__-prdslib.always))),
                                  _js2n__-prdslib.records.record
                                    {
                                      generator =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "text",
                                                  "byte_array",
                                                  "range",
                                                  "predefined",
                                                  "first_name",
                                                  "last_name",
                                                  "name",
                                                  "male_first_name",
                                                  "female_first_name",
                                                  "neutral_first_name",
                                                  "name_with_middle",
                                                  "email",
                                                  "internet.domain",
                                                  "internet.private_ipv4_addr",
                                                  "internet.public_ipv4_addr",
                                                  "internet.ipv4_addr",
                                                  "internet.ipv6_addr",
                                                  "internet.mac_addr",
                                                  "internet.safe_email",
                                                  "internet.slug",
                                                  "internet.domain_suffix",
                                                  "internet.user_agent",
                                                  "internet.bot_user_agent",
                                                  "company.name",
                                                  "company.department",
                                                  "company.industry",
                                                  "company.profession",
                                                  "company.type",
                                                  "company.sic_code",
                                                  "address.full",
                                                  "address.city",
                                                  "address.country",
                                                  "address.country_code",
                                                  "address.street",
                                                  "address.country_code_long",
                                                  "address.building_number",
                                                  "address.community",
                                                  "address.secondary_address",
                                                  "address.postcode",
                                                  "address.state",
                                                  "address.state_abbr",
                                                  "address.time_zone",
                                                  "address.city_with_state",
                                                  "address.street_name",
                                                  "address.mailbox",
                                                  "phone_number",
                                                  "phone_number.area_code",
                                                  "phone_number.exchange_code",
                                                  "phone_number.country_code",
                                                  "random.integer",
                                                  "random.boolean",
                                                  "random.decimal",
                                                  "random.enum",
                                                  "random.uuid",
                                                  "random.text",
                                                  "random.json",
                                                  "bank.name",
                                                  "bank.swift_bic",
                                                  "bank.iban_details",
                                                  "color.name",
                                                  "commerce.department",
                                                  "commerce.product_name",
                                                  "commerce.promotion_code",
                                                  "commerce.brand",
                                                  "commerce.vendor",
                                                  "crypto.md5",
                                                  "crypto.sha1",
                                                  "crypto.sha224",
                                                  "crypto.sha256",
                                                  "crypto.sha384",
                                                  "crypto.sha512",
                                                  "currency.code",
                                                  "currency.name",
                                                  "currency.symbol",
                                                  "file.extension",
                                                  "file.mimetype_application",
                                                  "file.mimetype_audio",
                                                  "file.mimetype_image",
                                                  "file.mimetype_message",
                                                  "file.mimetype_model",
                                                  "file.mimetype_multipart",
                                                  "file.mimetype_text",
                                                  "file.mimetype_video",
                                                  "gender.types",
                                                  "gender.binary_type",
                                                  "gender.short_binary_type",
                                                  "measurement.height",
                                                  "measurement.weight",
                                                  "measurement.volume",
                                                  "measurement.length",
                                                  "measurement.metric_height",
                                                  "measurement.metric_weight",
                                                  "measurement.metric_volume",
                                                  "measurement.metric_length",
                                                  "money.amount",
                                                  "educator.school_name",
                                                  "educator.secondary",
                                                  "educator.primary",
                                                  "educator.secondary_school",
                                                  "educator.primary_school",
                                                  "educator.campus",
                                                  "educator.subject",
                                                  "educator.university_type",
                                                  "educator.degree_type",
                                                  "educator.course_number",
                                                  "job.field",
                                                  "job.seniority",
                                                  "job.position",
                                                  "job.key_skills",
                                                  "job.employment_type",
                                                  "job.education_level",
                                                  "job.title",
                                                  "science.element",
                                                  "science.element_symbol",
                                                  "science.element_state",
                                                  "science.element_subcategory",
                                                  "science.modifier",
                                                  "science.scientist",
                                                  "science.tool",
                                                  "university.prefix",
                                                  "university.suffix",
                                                  "university.name",
                                                  "adjective.positive",
                                                  "adjective.negative",
                                                  "emotion.adjective",
                                                  "emotion.noun",
                                                  "hipster.words",
                                                  "lorem.words",
                                                  "lorem.supplemental",
                                                  "lorem.punctuation",
                                                  "markdown.headers",
                                                  "markdown.emphasis",
                                                  "nato.alphabet",
                                                  "slack_emoji.people",
                                                  "slack_emoji.nature",
                                                  "slack_emoji.food_and_drink",
                                                  "slack_emoji.celebration",
                                                  "slack_emoji.activity",
                                                  "slack_emoji.travel_and_places",
                                                  "slack_emoji.objects_and_symbols",
                                                  "slack_emoji.custom",
                                                  "slack_emoji.emoji",
                                                  "quote.famous_last_words",
                                                  "quote.matz",
                                                  "quote.most_interesting_man_in_the_world",
                                                  "quote.robin",
                                                  "quote.singular_siegler",
                                                  "quote.yoda",
                                                  "quote.fortune_cookie",
                                                  "verbs.base",
                                                  "verbs.past",
                                                  "verbs.past_participle",
                                                  "verbs.ing_form",
                                                  "verbs.simple_present",
                                                  "artist.names",
                                                  "blood.type",
                                                  "blood.rh_factor",
                                                  "blood.group",
                                                  "demographic.race",
                                                  "demographic.sex",
                                                  "demographic.demonym",
                                                  "demographic.educational_attainment",
                                                  "demographic.marital_status",
                                                  "driving_license.license",
                                                  "greek_philosophers.names",
                                                  "greek_philosophers.quotes",
                                                  "hobby.activity",
                                                  "military.army_rank",
                                                  "military.marines_rank",
                                                  "military.navy_rank",
                                                  "military.coast_guard_rank",
                                                  "military.air_force_rank",
                                                  "military.space_force_rank",
                                                  "military.dod_paygrade",
                                                  "basketball.teams",
                                                  "basketball.players",
                                                  "basketball.coaches",
                                                  "basketball.positions",
                                                  "chess.players",
                                                  "chess.tournaments",
                                                  "chess.openings",
                                                  "chess.titles",
                                                  "crossfit.competitions",
                                                  "crossfit.male_athletes",
                                                  "crossfit.female_athletes",
                                                  "crossfit.movements",
                                                  "crossfit.girl_workouts",
                                                  "crossfit.hero_workouts",
                                                  "esport.players",
                                                  "esport.teams",
                                                  "esport.events",
                                                  "esport.leagues",
                                                  "esport.games",
                                                  "football.teams",
                                                  "football.players",
                                                  "football.coaches",
                                                  "football.competitions",
                                                  "football.positions",
                                                  "mountaineering.mountaineer",
                                                  "sport.summer_olympics",
                                                  "sport.winter_olympics",
                                                  "sport.summer_paralympics",
                                                  "sport.winter_paralympics",
                                                  "sport.ancient_olympics",
                                                  "sport.unusual",
                                                  "team.name",
                                                  "team.sport",
                                                  "team.mascot",
                                                  "volleyball.team",
                                                  "volleyball.player",
                                                  "volleyball.coach",
                                                  "volleyball.position",
                                                  "volleyball.formation",
                                                  "world_cup.teams",
                                                  "world_cup.stadiums",
                                                  "world_cup.cities",
                                                  "app.name",
                                                  "app.version",
                                                  "app.author",
                                                  "appliance.brand",
                                                  "appliance.equipment",
                                                  "camera.brand",
                                                  "camera.model",
                                                  "camera.brand_with_model",
                                                  "computer.type",
                                                  "computer.platform",
                                                  "computer.os.linux",
                                                  "computer.os.openbsd",
                                                  "computer.os.templeos",
                                                  "computer.os.plan9",
                                                  "computer.os.macos",
                                                  "computer.os.windows",
                                                  "crypto_coin.coin",
                                                  "device.platform",
                                                  "device.model_name",
                                                  "device.manufacturer",
                                                  "device.serial",
                                                  "programming_language.name",
                                                  "programming_language.creator",
                                                  "airport.usa.large",
                                                  "airport.usa.medium",
                                                  "airport.usa.small",
                                                  "airport.usa.iata.large",
                                                  "airport.usa.iata.medium",
                                                  "airport.usa.iata.small",
                                                  "airport.eu.large",
                                                  "airport.eu.medium",
                                                  "airport.eu.iata.large",
                                                  "airport.eu.iata.medium",
                                                  "australia.locations",
                                                  "australia.animals",
                                                  "australia.states",
                                                  "mountain.name",
                                                  "mountain.range",
                                                  "nation.nationality",
                                                  "nation.capital_city",
                                                  "nation.language",
                                                  "train_station.uk.metro",
                                                  "train_station.uk.railway",
                                                  "train_station.spain.metro",
                                                  "train_station.spain.railway",
                                                  "train_station.germany.metro",
                                                  "train_station.germany.railway",
                                                  "train_station.usa.metro",
                                                  "train_station.usa.railway",
                                                  "beer.name",
                                                  "beer.style",
                                                  "beer.hop",
                                                  "beer.yeast",
                                                  "beer.malts",
                                                  "beer.brand",
                                                  "credit_card.number",
                                                  "credit_card.type",
                                                  "finance.vat_number",
                                                  "finance.ticker",
                                                  "coffee.blend_name",
                                                  "coffee.country",
                                                  "coffee.notes",
                                                  "coffee.variety",
                                                  "coffee.region",
                                                  "ancient.god",
                                                  "ancient.primordial",
                                                  "ancient.titan",
                                                  "ancient.hero",
                                                  "animal.name",
                                                  "bird.geo",
                                                  "bird.anatomy",
                                                  "bird.colors",
                                                  "bird.plausible_name",
                                                  "bird.family_name",
                                                  "cat.name",
                                                  "cat.breed",
                                                  "cat.registry",
                                                  "dog.name",
                                                  "dog.breed",
                                                  "dog.sound",
                                                  "dog.meme_phrase",
                                                  "dog.coat_length",
                                                  "dog.size",
                                                  "dog.age",
                                                  "horse.name",
                                                  "horse.breed",
                                                  "dessert.flavor",
                                                  "dessert.topping",
                                                  "dessert.variety",
                                                  "dessert",
                                                  "food.allergens",
                                                  "food.dish",
                                                  "food.description",
                                                  "food.ingredients",
                                                  "food.fruits",
                                                  "food.vegetables",
                                                  "food.spices",
                                                  "food.measurement_sizes",
                                                  "food.measurements",
                                                  "food.metric_measurements",
                                                  "food.sushi",
                                                  "food.ethnic_category",
                                                  "house.furniture",
                                                  "house.rooms",
                                                  "industry",
                                                  "industry.super_sector",
                                                  "industry.sector",
                                                  "industry.sub_sector",
                                                  "restaurant.name",
                                                  "restaurant.type",
                                                  "restaurant.description",
                                                  "restaurant.review",
                                                  "stripe.valid_card",
                                                  "stripe.valid_token",
                                                  "stripe.invalid_card",
                                                  "subscription.plan",
                                                  "subscription.status",
                                                  "subscription.payment_method",
                                                  "subscription.term",
                                                  "subscription.payment_term",
                                                  "tea.type",
                                                  "tea.variety.black",
                                                  "tea.variety.green",
                                                  "tea.variety.white",
                                                  "tea.variety.oolong",
                                                  "tea.variety.herbal",
                                                  "barcode.ean8",
                                                  "barcode.ean13",
                                                  "barcode.upca",
                                                  "barcode.upce",
                                                  "barcode.composite_symbol",
                                                  "barcode.isbn",
                                                  "barcode.ismn",
                                                  "barcode.issn"
                                                ]
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ])
                          ],
                    count =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Integer,
                            _js2n__-prdslib.numbers.minimum 1
                          ],
                  } {} true _js2n__-prdslib.always
              ])
        ])