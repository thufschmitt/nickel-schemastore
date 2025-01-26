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
      "_js2n__-:definitions/commands!contract"
        | doc m%"
          https://circleci.com/docs/configuration-reference#commands-requires-version-21
          
          A command definition defines a sequence of steps as a map to be executed in a job, enabling you to reuse a single command definition across multiple jobs.
        "%
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {} {} true
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "steps" ],
                      _js2n__-prdslib.records.record
                        {
                          description = _js2n__-prdslib.isType '"String",
                          parameters =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {}
                                    {
                                      "^[a-z][a-z0-9_-]+$" =
                                        _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "type" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      "default" =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      type =
                                                        _js2n__-prdslib.enum
                                                            [ "string" ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "type" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      "default" =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      type =
                                                        _js2n__-prdslib.enum
                                                            [ "boolean" ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "type" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      "default" =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      type =
                                                        _js2n__-prdslib.enum
                                                            [ "integer" ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "enum", "type" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      "default" =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      enum =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String"),
                                                              _js2n__-prdslib.arrays.minItems
                                                                1
                                                            ],
                                                      type =
                                                        _js2n__-prdslib.enum
                                                            [ "enum" ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "type" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      "default" =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      type =
                                                        _js2n__-prdslib.enum
                                                            [ "executor" ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "type" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      "default" =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                _js2n__-refsenv."_js2n__-:definitions/step!predicate"
                                                            ],
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      type =
                                                        _js2n__-prdslib.enum
                                                            [ "steps" ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "type" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      "default" =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.strings.pattern
                                                                "^[a-zA-Z][a-zA-Z0-9_-]+$"
                                                            ],
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      type =
                                                        _js2n__-prdslib.enum
                                                            [ "env_var_name" ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ]
                                            ],
                                    } true _js2n__-prdslib.always
                                ],
                          steps =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/step!predicate"
                                ],
                        } {} true _js2n__-prdslib.always
                    ])
              ]),
      "_js2n__-:definitions/commands!predicate"
        | doc m%"
          https://circleci.com/docs/configuration-reference#commands-requires-version-21
          
          A command definition defines a sequence of steps as a map to be executed in a job, enabling you to reuse a single command definition across multiple jobs.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "steps" ],
                    _js2n__-prdslib.records.record
                      {
                        description = _js2n__-prdslib.isType '"String",
                        parameters =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {}
                                  {
                                    "^[a-z][a-z0-9_-]+$" =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "type" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    "default" =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    description =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    type =
                                                      _js2n__-prdslib.enum
                                                          [ "string" ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "type" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    "default" =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    description =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    type =
                                                      _js2n__-prdslib.enum
                                                          [ "boolean" ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "type" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    "default" =
                                                      _js2n__-prdslib.isType
                                                          'Integer,
                                                    description =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    type =
                                                      _js2n__-prdslib.enum
                                                          [ "integer" ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "enum", "type" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    "default" =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    description =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    enum =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.arrays.arrayOf
                                                              (_js2n__-prdslib.isType
                                                                '"String"),
                                                            _js2n__-prdslib.arrays.minItems
                                                              1
                                                          ],
                                                    type =
                                                      _js2n__-prdslib.enum
                                                          [ "enum" ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "type" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    "default" =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    description =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    type =
                                                      _js2n__-prdslib.enum
                                                          [ "executor" ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "type" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    "default" =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.arrays.arrayOf
                                                              _js2n__-refsenv."_js2n__-:definitions/step!predicate"
                                                          ],
                                                    description =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    type =
                                                      _js2n__-prdslib.enum
                                                          [ "steps" ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "type" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    "default" =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"String",
                                                            _js2n__-prdslib.strings.pattern
                                                              "^[a-zA-Z][a-zA-Z0-9_-]+$"
                                                          ],
                                                    description =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    type =
                                                      _js2n__-prdslib.enum
                                                          [ "env_var_name" ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ]
                                          ],
                                  } true _js2n__-prdslib.always
                              ],
                        steps =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/step!predicate"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/dockerExecutor!predicate"
        | doc "Options for the [docker executor](https://circleci.com/docs/configuration-reference/#docker)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "docker" ],
              _js2n__-prdslib.records.record
                {
                  docker =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "image" ],
                                _js2n__-prdslib.records.record
                                  {
                                    auth =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ],
                                    aws_auth =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                aws_access_key_id =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                aws_secret_access_key =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                oidc_role_arn =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ],
                                    command =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ]
                                          ],
                                    entrypoint =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ]
                                          ],
                                    environment =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true
                                              (_js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType '"Bool"
                                                ])
                                          ],
                                    image = _js2n__-prdslib.isType '"String",
                                    name = _js2n__-prdslib.isType '"String",
                                    user = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  resource_class =
                    _js2n__-refsenv."_js2n__-:definitions/linuxResourceClass!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dockerLayerCaching!predicate"
        | doc "Set to `true` to enable [Docker Layer Caching](https://circleci.com/docs/docker-layer-caching). Note: If you haven't already, you must open a support ticket to have a CircleCI Sales representative contact you about enabling this feature on your account for an additional fee."
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/executorChoice!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/dockerExecutor!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/machineExecutor!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/macosExecutor!predicate"
                ]
            ],
      "_js2n__-:definitions/executors!contract"
        | doc "Executors define the environment in which the steps of a job will be run, allowing you to reuse a single executor definition across multiple jobs."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {} {} true
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          environment =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType '"Number"
                                      ])
                                ],
                          shell = _js2n__-prdslib.isType '"String",
                          working_directory = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always,
                      _js2n__-refsenv."_js2n__-:definitions/executorChoice!predicate"
                    ])
              ]),
      "_js2n__-:definitions/executors!predicate"
        | doc "Executors define the environment in which the steps of a job will be run, allowing you to reuse a single executor definition across multiple jobs."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        environment =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number"
                                    ])
                              ],
                        shell = _js2n__-prdslib.isType '"String",
                        working_directory = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always,
                    _js2n__-refsenv."_js2n__-:definitions/executorChoice!predicate"
                  ])
            ],
      "_js2n__-:definitions/filter!predicate"
        | doc "A map defining rules for execution on specific branches"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore =
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
                  only =
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
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/jobRef!predicate"
        | doc "Run a job as part of this workflow"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  context =
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
                  filters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              branches =
                                _js2n__-refsenv."_js2n__-:definitions/filter!predicate",
                              tags =
                                _js2n__-refsenv."_js2n__-:definitions/filter!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  matrix =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "parameters" ],
                          _js2n__-prdslib.records.record
                            {
                              alias = _js2n__-prdslib.isType '"String",
                              exclude =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType 'Record)
                                    ],
                              parameters =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        (_js2n__-prdslib.isType '"Array")
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  requires =
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
                                    _js2n__-prdslib.records.minProperties 1,
                                    _js2n__-prdslib.records.record {}
                                      {
                                        "^[A-Za-z][A-Za-z\\s\\d_-]*$" =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "success",
                                                        "failed",
                                                        "canceled"
                                                      ]
                                                  ],
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.strings.minLength
                                                      1,
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "success",
                                                              "failed",
                                                              "canceled"
                                                            ]
                                                        ])
                                                  ]
                                              ],
                                      } true _js2n__-prdslib.always
                                  ]
                              ])
                        ],
                  type = _js2n__-prdslib.enum [ "approval" ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/jobs!predicate"
        | doc "Jobs are collections of steps. All of the steps in the job are executed in a single unit, either within a fresh container or VM."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/executorChoice!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required [ "executor" ],
                            _js2n__-prdslib.records.record
                              { executor = _js2n__-prdslib.isType '"String", }
                              {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required [ "executor" ],
                            _js2n__-prdslib.records.record
                              {
                                executor =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "name" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            name =
                                              _js2n__-prdslib.isType '"String",
                                          } {} true _js2n__-prdslib.always
                                      ],
                              } {} true _js2n__-prdslib.always
                          ]
                      ],
                    _js2n__-prdslib.records.required [ "steps" ],
                    _js2n__-prdslib.records.record
                      {
                        branches =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        environment =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number"
                                    ])
                              ],
                        parallelism =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^<<.+\\..+>>$"
                                  ]
                              ],
                        shell = _js2n__-prdslib.isType '"String",
                        steps =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/step!predicate"
                              ],
                        working_directory = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/linuxGPUMachineImage!predicate"
        | doc "The Linux GPU machine image to use. View available images for [CUDA 11](https://circleci.com/developer/machine/image/linux-cuda-11) or [CUDA 12](https://circleci.com/developer/machine/image/linux-cuda-12)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "linux-cuda-11:default",
                  "linux-cuda-11:edge",
                  "linux-cuda-12:default",
                  "linux-cuda-12:edge"
                ]
            ],
      "_js2n__-:definitions/linuxGPUResourceClass!predicate"
        | doc "Amount of CPU and RAM allocated for each job. View [available resource classes](https://circleci.com/docs/configuration-reference/#gpu-execution-environment-linux)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "gpu.nvidia.small.gen2",
                  "gpu.nvidia.small.multi",
                  "gpu.nvidia.medium.multi",
                  "gpu.nvidia.medium",
                  "gpu.nvidia.large"
                ]
            ],
      "_js2n__-:definitions/linuxMachineImage!predicate"
        | doc "The LinuxVM image to use. View available images for [Ubuntu 20.04](https://circleci.com/developer/machine/image/ubuntu-2004), [Ubuntu 22.04](https://circleci.com/developer/machine/image/ubuntu-2204), or [Android](https://circleci.com/developer/machine/image/android). **Note:** This key is **not** supported on the installable CircleCI. For information about customizing machine executor images on CircleCI installed on your servers, see our [VM Service documentation](https://circleci.com/docs/vm-service)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ubuntu-2004:2024.08.1",
                  "ubuntu-2004:2024.05.1",
                  "ubuntu-2004:2024.04.4",
                  "ubuntu-2004:2024.01.2",
                  "ubuntu-2004:2024.01.1",
                  "ubuntu-2004:2023.10.1",
                  "ubuntu-2004:2023.07.1",
                  "ubuntu-2004:2023.04.2",
                  "ubuntu-2004:2023.04.1",
                  "ubuntu-2004:2023.02.1",
                  "ubuntu-2004:2022.10.1",
                  "ubuntu-2004:2022.07.1",
                  "ubuntu-2004:2022.04.2",
                  "ubuntu-2004:2022.04.1",
                  "ubuntu-2004:202201-02",
                  "ubuntu-2004:202201-01",
                  "ubuntu-2004:202111-02",
                  "ubuntu-2004:202111-01",
                  "ubuntu-2004:202107-02",
                  "ubuntu-2004:202104-01",
                  "ubuntu-2004:202101-01",
                  "ubuntu-2004:202010-01",
                  "ubuntu-2004:current",
                  "ubuntu-2004:edge",
                  "ubuntu-2204:2024.08.1",
                  "ubuntu-2204:2024.05.1",
                  "ubuntu-2204:2024.04.4",
                  "ubuntu-2204:2024.01.2",
                  "ubuntu-2204:2024.01.1",
                  "ubuntu-2204:2023.10.1",
                  "ubuntu-2204:2023.07.2",
                  "ubuntu-2204:2023.04.2",
                  "ubuntu-2204:2023.04.1",
                  "ubuntu-2204:2023.02.1",
                  "ubuntu-2204:2022.10.2",
                  "ubuntu-2204:2022.10.1",
                  "ubuntu-2204:2022.07.2",
                  "ubuntu-2204:2022.07.1",
                  "ubuntu-2204:2022.04.2",
                  "ubuntu-2204:2022.04.1",
                  "ubuntu-2204:current",
                  "ubuntu-2204:edge",
                  "ubuntu-2404:2024.08.1",
                  "ubuntu-2404:2024.05.1",
                  "ubuntu-2404:current",
                  "ubuntu-2404:edge",
                  "android:2024.04.1",
                  "android:2024.01.1",
                  "android:2023.11.1",
                  "android:2023.10.1",
                  "android:2023.09.1",
                  "android:2023.08.1",
                  "android:2023.07.1",
                  "android:2023.06.1",
                  "android:2023.05.1",
                  "android:2023.04.1",
                  "android:2023.03.1",
                  "android:2023.02.1",
                  "android:2022.12.1",
                  "android:2022.09.1",
                  "android:2022.08.1",
                  "android:2022.07.1",
                  "android:2022.06.2",
                  "android:2022.06.1",
                  "android:2022.04.1",
                  "android:2022.03.1",
                  "android:2022.01.1",
                  "android:2021.12.1",
                  "android:2021.10.1",
                  "android:202102-01"
                ]
            ],
      "_js2n__-:definitions/linuxResourceClass!predicate"
        | doc "Amount of CPU and RAM allocated for each job. View available resource classes for [x86](https://circleci.com/docs/configuration-reference/#docker-execution-environment) or [ARM](https://circleci.com/docs/configuration-reference/#arm-execution-environment-linux)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "small",
                  "medium",
                  "medium+",
                  "large",
                  "xlarge",
                  "2xlarge",
                  "2xlarge+",
                  "arm.medium",
                  "arm.large",
                  "arm.xlarge",
                  "arm.2xlarge"
                ]
            ],
      "_js2n__-:definitions/logical!predicate"
        | doc m%"
          https://circleci.com/docs/configuration-reference#logic-statements 
          
          A logical statement to be used in dynamic configuration
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"Number"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.maxProperties 1,
                  _js2n__-prdslib.records.minProperties 1,
                  _js2n__-prdslib.records.record
                    {
                      and =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/logical!predicate"
                            ],
                      equal = _js2n__-prdslib.isType '"Array",
                      matches =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  pattern = _js2n__-prdslib.isType '"String",
                                  value = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never
                            ],
                      not =
                        _js2n__-refsenv."_js2n__-:definitions/logical!predicate",
                      or =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/logical!predicate"
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/macOSResourceClass!predicate"
        | doc "Amount of CPU and RAM allocated for each job. View [available resource classes](https://circleci.com/docs/configuration-reference/#macos-execution-environment)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "macos.m1.medium.gen1", "macos.m1.large.gen1" ]
            ],
      "_js2n__-:definitions/machineExecutor!predicate"
        | doc "Options for the [machine executor](https://circleci.com/docs/configuration-reference#machine)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.records.record
                    {
                      machine = _js2n__-prdslib.const true,
                      resource_class =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/linuxResourceClass!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/selfHostedRunnerResourceClass!predicate"
                            ],
                    } {} true _js2n__-prdslib.always,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.record
                        {
                          machine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      docker_layer_caching =
                                        _js2n__-refsenv."_js2n__-:definitions/dockerLayerCaching!predicate",
                                      image =
                                        _js2n__-refsenv."_js2n__-:definitions/linuxMachineImage!predicate",
                                      resource_class =
                                        _js2n__-refsenv."_js2n__-:definitions/linuxResourceClass!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          resource_class =
                            _js2n__-refsenv."_js2n__-:definitions/linuxResourceClass!predicate",
                        } {} true _js2n__-prdslib.always,
                      _js2n__-prdslib.records.dependencies
                        {
                          resource_class =
                            _js2n__-prdslib.not
                                (_js2n__-prdslib.records.record
                                  {
                                    machine =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "resource_class" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always),
                        }
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.record
                        {
                          machine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required [ "image" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      image =
                                        _js2n__-refsenv."_js2n__-:definitions/windowsMachineImage!predicate",
                                      resource_class =
                                        _js2n__-refsenv."_js2n__-:definitions/windowsResourceClass!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          resource_class =
                            _js2n__-refsenv."_js2n__-:definitions/windowsResourceClass!predicate",
                        } {} true _js2n__-prdslib.always,
                      _js2n__-prdslib.records.dependencies
                        {
                          resource_class =
                            _js2n__-prdslib.not
                                (_js2n__-prdslib.records.record
                                  {
                                    machine =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "resource_class" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always),
                        }
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.record
                        {
                          machine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required [ "image" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      image =
                                        _js2n__-refsenv."_js2n__-:definitions/linuxGPUMachineImage!predicate",
                                      resource_class =
                                        _js2n__-refsenv."_js2n__-:definitions/linuxGPUResourceClass!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          resource_class =
                            _js2n__-refsenv."_js2n__-:definitions/linuxGPUResourceClass!predicate",
                        } {} true _js2n__-prdslib.always,
                      _js2n__-prdslib.records.dependencies
                        {
                          resource_class =
                            _js2n__-prdslib.not
                                (_js2n__-prdslib.records.record
                                  {
                                    machine =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "resource_class" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always),
                        }
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.record
                        {
                          machine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required [ "image" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      image =
                                        _js2n__-refsenv."_js2n__-:definitions/windowsGPUMachineImage!predicate",
                                      resource_class =
                                        _js2n__-refsenv."_js2n__-:definitions/windowsGPUResourceClass!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          resource_class =
                            _js2n__-refsenv."_js2n__-:definitions/windowsGPUResourceClass!predicate",
                        } {} true _js2n__-prdslib.always,
                      _js2n__-prdslib.records.dependencies
                        {
                          resource_class =
                            _js2n__-prdslib.not
                                (_js2n__-prdslib.records.record
                                  {
                                    machine =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "resource_class" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always),
                        }
                    ],
                  _js2n__-prdslib.records.record
                    {
                      machine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "resource_class" ],
                              _js2n__-prdslib.records.record
                                {
                                  resource_class =
                                    _js2n__-refsenv."_js2n__-:definitions/selfHostedRunnerResourceClass!predicate",
                                } {} false _js2n__-prdslib.never
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "machine" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/macosExecutor!predicate"
        | doc "Options for the [macOS executor](https://circleci.com/docs/configuration-reference#macos)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "macos" ],
              _js2n__-prdslib.records.record
                {
                  macos =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "xcode" ],
                          _js2n__-prdslib.records.record
                            {
                              xcode =
                                _js2n__-refsenv."_js2n__-:definitions/xcodeVersion!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  resource_class =
                    _js2n__-refsenv."_js2n__-:definitions/macOSResourceClass!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/orbs!contract"
        | doc m%"
          https://circleci.com/docs/configuration-reference#orbs-requires-version-21
          
          Orbs are reusable packages of CircleCI configuration that you may share across projects, enabling you to create encapsulated, parameterized commands, jobs, and executors that can be used across multiple projects.
        "%
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {} {} true
                  (_js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-z][a-z0-9_-]+/[a-z][a-z0-9_-]+@(dev:[\\.a-z0-9_-]+|\\d+|\\d+\\.\\d+|\\d+\\.\\d+\\.\\d+|volatile)$"
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              commands =
                                _js2n__-refsenv."_js2n__-:definitions/commands!predicate",
                              executors =
                                _js2n__-refsenv."_js2n__-:definitions/executors!predicate",
                              jobs =
                                _js2n__-refsenv."_js2n__-:definitions/jobs!predicate",
                              orbs =
                                _js2n__-refsenv."_js2n__-:definitions/orbs!predicate",
                            } {} true _js2n__-prdslib.always
                        ]
                    ])
              ]),
      "_js2n__-:definitions/orbs!predicate"
        | doc m%"
          https://circleci.com/docs/configuration-reference#orbs-requires-version-21
          
          Orbs are reusable packages of CircleCI configuration that you may share across projects, enabling you to create encapsulated, parameterized commands, jobs, and executors that can be used across multiple projects.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.pattern
                          "^[a-z][a-z0-9_-]+/[a-z][a-z0-9_-]+@(dev:[\\.a-z0-9_-]+|\\d+|\\d+\\.\\d+|\\d+\\.\\d+\\.\\d+|volatile)$"
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            commands =
                              _js2n__-refsenv."_js2n__-:definitions/commands!predicate",
                            executors =
                              _js2n__-refsenv."_js2n__-:definitions/executors!predicate",
                            jobs =
                              _js2n__-refsenv."_js2n__-:definitions/jobs!predicate",
                            orbs =
                              _js2n__-refsenv."_js2n__-:definitions/orbs!predicate",
                          } {} true _js2n__-prdslib.always
                      ]
                  ])
            ],
      "_js2n__-:definitions/selfHostedRunnerResourceClass!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[^/\\s]+/\\S+$"
            ],
      "_js2n__-:definitions/step!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [ _js2n__-prdslib.enum [ "checkout" ], _js2n__-prdslib.always ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.enum [ "setup_remote_docker" ],
                  _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.enum [ "add_ssh_keys" ],
                  _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[a-z][a-z0-9_-]+$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^[a-z][a-z0-9_-]+/[a-z][a-z0-9_-]+$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.maxProperties 1,
                  _js2n__-prdslib.records.minProperties 1,
                  _js2n__-prdslib.records.record
                    {
                      add_ssh_keys = _js2n__-prdslib.always,
                      attach_workspace = _js2n__-prdslib.always,
                      checkout = _js2n__-prdslib.always,
                      deploy = _js2n__-prdslib.always,
                      persist_to_workspace = _js2n__-prdslib.always,
                      restore_cache = _js2n__-prdslib.always,
                      run = _js2n__-prdslib.always,
                      save_cache = _js2n__-prdslib.always,
                      setup_remote_docker = _js2n__-prdslib.always,
                      store_artifacts = _js2n__-prdslib.always,
                      store_test_results = _js2n__-prdslib.always,
                      unless = _js2n__-prdslib.always,
                      when = _js2n__-prdslib.always,
                    }
                    {
                      "^[a-z][a-z0-9_-]+$" = _js2n__-prdslib.always,
                      "^[a-z][a-z0-9_-]+/[a-z][a-z0-9_-]+$" =
                        _js2n__-prdslib.always,
                    } true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/windowsGPUMachineImage!predicate"
        | doc "The Windows GPU machine image to use. View [available images](https://circleci.com/developer/machine/image/windows-server-2019-cuda)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "windows-server-2019-cuda:current",
                  "windows-server-2019-cuda:edge"
                ]
            ],
      "_js2n__-:definitions/windowsGPUResourceClass!predicate"
        | doc "Amount of CPU and RAM allocated for each job. View [available resource classes](https://circleci.com/docs/configuration-reference/#gpu-execution-environment-windows)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "windows.gpu.nvidia.medium" ]
            ],
      "_js2n__-:definitions/windowsMachineImage!predicate"
        | doc "The Windows machine image to use. View available images for [Windows Server 2022](https://circleci.com/developer/machine/image/windows-server-2022-gui) or [Windows Server 2019](https://circleci.com/developer/machine/image/windows-server-2019)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "windows-server-2019-vs2019:2024.05.1",
                  "windows-server-2019-vs2019:2024.01.1",
                  "windows-server-2019-vs2019:2023.10.1",
                  "windows-server-2019-vs2019:2023.08.1",
                  "windows-server-2019-vs2019:2023.04.1",
                  "windows-server-2019-vs2019:2022.08.1",
                  "windows-server-2019-vs2019:current",
                  "windows-server-2019-vs2019:edge",
                  "windows-server-2022-gui:2024.04.1",
                  "windows-server-2022-gui:2024.01.1",
                  "windows-server-2022-gui:2023.11.1",
                  "windows-server-2022-gui:2023.10.1",
                  "windows-server-2022-gui:2023.09.1",
                  "windows-server-2022-gui:2023.08.1",
                  "windows-server-2022-gui:2023.07.1",
                  "windows-server-2022-gui:2023.06.1",
                  "windows-server-2022-gui:2023.05.1",
                  "windows-server-2022-gui:2023.04.1",
                  "windows-server-2022-gui:2023.03.1",
                  "windows-server-2022-gui:2022.08.1",
                  "windows-server-2022-gui:2022.07.1",
                  "windows-server-2022-gui:2022.06.1",
                  "windows-server-2022-gui:2022.04.1",
                  "windows-server-2022-gui:current",
                  "windows-server-2022-gui:edge"
                ]
            ],
      "_js2n__-:definitions/windowsResourceClass!predicate"
        | doc "Amount of CPU and RAM allocated for each job. View [available resource classes](https://circleci.com/docs/configuration-reference/#windows-execution-environment)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "windows.medium",
                  "windows.large",
                  "windows.xlarge",
                  "windows.2xlarge"
                ]
            ],
      "_js2n__-:definitions/xcodeVersion!predicate"
        | doc "The version of Xcode to use. View [available versions](https://circleci.com/developer/machine/image/xcode)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "16.2.0",
                  "16.1.0",
                  "16.0.0",
                  "15.4.0",
                  "15.3.0",
                  "15.2.0",
                  "15.1.0",
                  "15.0.0",
                  "14.3.1",
                  "14.2.0",
                  "14.1.0",
                  "14.0.1",
                  "13.4.1",
                  "12.5.1"
                ]
            ],
    }
    in
  {
      commands
        | _js2n__-refsenv."_js2n__-:definitions/commands!contract"
        | optional,
      executors
        | _js2n__-refsenv."_js2n__-:definitions/executors!contract"
        | optional,
      jobs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.propertyNames
                (_js2n__-prdslib.strings.pattern "^[A-Za-z][A-Za-z\\s\\d_-]*$"),
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always,
              _js2n__-refsenv."_js2n__-:definitions/jobs!predicate"
            ])
        | optional,
      orbs | _js2n__-refsenv."_js2n__-:definitions/orbs!contract" | optional,
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.enum [ 2, 2.1 ])
        | doc "The version field is intended to be used in order to issue warnings for deprecation or breaking changes.",
      workflows
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { version = _js2n__-prdslib.enum [ 2 ], } {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        jobs =
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
                                          _js2n__-prdslib.records.record {} {}
                                            true
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-refsenv."_js2n__-:definitions/jobRef!predicate"
                                              ])
                                        ]
                                    ])
                              ],
                        triggers =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          schedule =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      cron =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      filters =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  branches =
                                                                    _js2n__-refsenv."_js2n__-:definitions/filter!predicate",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ])
                              ],
                        unless =
                          _js2n__-refsenv."_js2n__-:definitions/logical!predicate",
                        when =
                          _js2n__-refsenv."_js2n__-:definitions/logical!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
            ])
        | doc "Used for orchestrating all jobs. Each workflow consists of the workflow name as a key and a map as a value"
        | optional,
      ..
    }