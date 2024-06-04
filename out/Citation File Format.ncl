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
      "_js2n__-:definitions/address!contract"
        | doc "An address."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/address!predicate"
        | doc "An address."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/alias!contract"
        | doc "An alias."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/alias!predicate"
        | doc "An alias."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/city!contract"
        | doc "A city"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/city!predicate"
        | doc "A city"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/commit!contract"
        | doc "The (e.g., Git) commit hash or (e.g., Subversion) revision number of the work."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/commit!predicate"
        | doc "The (e.g., Git) commit hash or (e.g., Subversion) revision number of the work."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/country!contract"
        | doc "The ISO 3166-1 alpha-2 country code for a country."
        = std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'ZW,
                'ZM,
                'ZA,
                'YT,
                'YE,
                'WS,
                'WF,
                'VU,
                'VN,
                'VI,
                'VG,
                'VE,
                'VC,
                'VA,
                'UZ,
                'UY,
                'US,
                'UM,
                'UG,
                'UA,
                'TZ,
                'TW,
                'TV,
                'TT,
                'TR,
                'TO,
                'TN,
                'TM,
                'TL,
                'TK,
                'TJ,
                'TH,
                'TG,
                'TF,
                'TD,
                'TC,
                'SZ,
                'SY,
                'SX,
                'SV,
                'ST,
                'SS,
                'SR,
                'SO,
                'SN,
                'SM,
                'SL,
                'SK,
                'SJ,
                'SI,
                'SH,
                'SG,
                'SE,
                'SD,
                'SC,
                'SB,
                'SA,
                'RW,
                'RU,
                'RS,
                'RO,
                'RE,
                'QA,
                'PY,
                'PW,
                'PT,
                'PS,
                'PR,
                'PN,
                'PM,
                'PL,
                'PK,
                'PH,
                'PG,
                'PF,
                'PE,
                'PA,
                'OM,
                'NZ,
                'NU,
                'NR,
                'NP,
                'NO,
                'NL,
                'NI,
                'NG,
                'NF,
                'NE,
                'NC,
                'NA,
                'MZ,
                'MY,
                'MX,
                'MW,
                'MV,
                'MU,
                'MT,
                'MS,
                'MR,
                'MQ,
                'MP,
                'MO,
                'MN,
                'MM,
                'ML,
                'MK,
                'MH,
                'MG,
                'MF,
                'ME,
                'MD,
                'MC,
                'MA,
                'LY,
                'LV,
                'LU,
                'LT,
                'LS,
                'LR,
                'LK,
                'LI,
                'LC,
                'LB,
                'LA,
                'KZ,
                'KY,
                'KW,
                'KR,
                'KP,
                'KN,
                'KM,
                'KI,
                'KH,
                'KG,
                'KE,
                'JP,
                'JO,
                'JM,
                'JE,
                'IT,
                'IS,
                'IR,
                'IQ,
                'IO,
                'IN,
                'IM,
                'IL,
                'IE,
                'ID,
                'HU,
                'HT,
                'HR,
                'HN,
                'HM,
                'HK,
                'GY,
                'GW,
                'GU,
                'GT,
                'GS,
                'GR,
                'GQ,
                'GP,
                'GN,
                'GM,
                'GL,
                'GI,
                'GH,
                'GG,
                'GF,
                'GE,
                'GD,
                'GB,
                'GA,
                'FR,
                'FO,
                'FM,
                'FK,
                'FJ,
                'FI,
                'ET,
                'ES,
                'ER,
                'EH,
                'EG,
                'EE,
                'EC,
                'DZ,
                'DO,
                'DM,
                'DK,
                'DJ,
                'DE,
                'CZ,
                'CY,
                'CX,
                'CW,
                'CV,
                'CU,
                'CR,
                'CO,
                'CN,
                'CM,
                'CL,
                'CK,
                'CI,
                'CH,
                'CG,
                'CF,
                'CD,
                'CC,
                'CA,
                'BZ,
                'BY,
                'BW,
                'BV,
                'BT,
                'BS,
                'BR,
                'BQ,
                'BO,
                'BN,
                'BM,
                'BL,
                'BJ,
                'BI,
                'BH,
                'BG,
                'BF,
                'BE,
                'BD,
                'BB,
                'BA,
                'AZ,
                'AX,
                'AW,
                'AU,
                'AT,
                'AS,
                'AR,
                'AQ,
                'AO,
                'AM,
                'AL,
                'AI,
                'AG,
                'AF,
                'AE,
                'AD
              |]
            ],
      "_js2n__-:definitions/country!predicate"
        | doc "The ISO 3166-1 alpha-2 country code for a country."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "AD",
                  "AE",
                  "AF",
                  "AG",
                  "AI",
                  "AL",
                  "AM",
                  "AO",
                  "AQ",
                  "AR",
                  "AS",
                  "AT",
                  "AU",
                  "AW",
                  "AX",
                  "AZ",
                  "BA",
                  "BB",
                  "BD",
                  "BE",
                  "BF",
                  "BG",
                  "BH",
                  "BI",
                  "BJ",
                  "BL",
                  "BM",
                  "BN",
                  "BO",
                  "BQ",
                  "BR",
                  "BS",
                  "BT",
                  "BV",
                  "BW",
                  "BY",
                  "BZ",
                  "CA",
                  "CC",
                  "CD",
                  "CF",
                  "CG",
                  "CH",
                  "CI",
                  "CK",
                  "CL",
                  "CM",
                  "CN",
                  "CO",
                  "CR",
                  "CU",
                  "CV",
                  "CW",
                  "CX",
                  "CY",
                  "CZ",
                  "DE",
                  "DJ",
                  "DK",
                  "DM",
                  "DO",
                  "DZ",
                  "EC",
                  "EE",
                  "EG",
                  "EH",
                  "ER",
                  "ES",
                  "ET",
                  "FI",
                  "FJ",
                  "FK",
                  "FM",
                  "FO",
                  "FR",
                  "GA",
                  "GB",
                  "GD",
                  "GE",
                  "GF",
                  "GG",
                  "GH",
                  "GI",
                  "GL",
                  "GM",
                  "GN",
                  "GP",
                  "GQ",
                  "GR",
                  "GS",
                  "GT",
                  "GU",
                  "GW",
                  "GY",
                  "HK",
                  "HM",
                  "HN",
                  "HR",
                  "HT",
                  "HU",
                  "ID",
                  "IE",
                  "IL",
                  "IM",
                  "IN",
                  "IO",
                  "IQ",
                  "IR",
                  "IS",
                  "IT",
                  "JE",
                  "JM",
                  "JO",
                  "JP",
                  "KE",
                  "KG",
                  "KH",
                  "KI",
                  "KM",
                  "KN",
                  "KP",
                  "KR",
                  "KW",
                  "KY",
                  "KZ",
                  "LA",
                  "LB",
                  "LC",
                  "LI",
                  "LK",
                  "LR",
                  "LS",
                  "LT",
                  "LU",
                  "LV",
                  "LY",
                  "MA",
                  "MC",
                  "MD",
                  "ME",
                  "MF",
                  "MG",
                  "MH",
                  "MK",
                  "ML",
                  "MM",
                  "MN",
                  "MO",
                  "MP",
                  "MQ",
                  "MR",
                  "MS",
                  "MT",
                  "MU",
                  "MV",
                  "MW",
                  "MX",
                  "MY",
                  "MZ",
                  "NA",
                  "NC",
                  "NE",
                  "NF",
                  "NG",
                  "NI",
                  "NL",
                  "NO",
                  "NP",
                  "NR",
                  "NU",
                  "NZ",
                  "OM",
                  "PA",
                  "PE",
                  "PF",
                  "PG",
                  "PH",
                  "PK",
                  "PL",
                  "PM",
                  "PN",
                  "PR",
                  "PS",
                  "PT",
                  "PW",
                  "PY",
                  "QA",
                  "RE",
                  "RO",
                  "RS",
                  "RU",
                  "RW",
                  "SA",
                  "SB",
                  "SC",
                  "SD",
                  "SE",
                  "SG",
                  "SH",
                  "SI",
                  "SJ",
                  "SK",
                  "SL",
                  "SM",
                  "SN",
                  "SO",
                  "SR",
                  "SS",
                  "ST",
                  "SV",
                  "SX",
                  "SY",
                  "SZ",
                  "TC",
                  "TD",
                  "TF",
                  "TG",
                  "TH",
                  "TJ",
                  "TK",
                  "TL",
                  "TM",
                  "TN",
                  "TO",
                  "TR",
                  "TT",
                  "TV",
                  "TW",
                  "TZ",
                  "UA",
                  "UG",
                  "UM",
                  "US",
                  "UY",
                  "UZ",
                  "VA",
                  "VC",
                  "VE",
                  "VG",
                  "VI",
                  "VN",
                  "VU",
                  "WF",
                  "WS",
                  "YE",
                  "YT",
                  "ZA",
                  "ZM",
                  "ZW"
                ]
            ],
      "_js2n__-:definitions/date!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$"
              ]),
      "_js2n__-:definitions/date!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$"
            ],
      "_js2n__-:definitions/doi!contract"
        | doc "The DOI of the work (i.e., 10.5281/zenodo.1003150, not the resolver URL http://doi.org/10.5281/zenodo.1003150)."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^10\\.\\d{4,9}(\\.\\d+)?/[A-Za-z0-9:/_;\\-\\.\\(\\)\\[\\]\\\\]+$"
              ]),
      "_js2n__-:definitions/doi!predicate"
        | doc "The DOI of the work (i.e., 10.5281/zenodo.1003150, not the resolver URL http://doi.org/10.5281/zenodo.1003150)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^10\\.\\d{4,9}(\\.\\d+)?/[A-Za-z0-9:/_;\\-\\.\\(\\)\\[\\]\\\\]+$"
            ],
      "_js2n__-:definitions/email!contract"
        | doc "An email address."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^[\\S]+@[\\S]+\\.[\\S]{2,}$"
              ]),
      "_js2n__-:definitions/email!predicate"
        | doc "An email address."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[\\S]+@[\\S]+\\.[\\S]{2,}$"
            ],
      "_js2n__-:definitions/entity!contract"
        | doc "An entity, i.e., an institution, team, research group, company, conference, etc., as opposed to a single natural person."
        = {
            address
              | _js2n__-refsenv."_js2n__-:definitions/address!contract"
              | doc "The entity's address."
              | optional,
            alias
              | _js2n__-refsenv."_js2n__-:definitions/alias!contract"
              | doc "The entity's alias."
              | optional,
            city
              | _js2n__-refsenv."_js2n__-:definitions/city!contract"
              | doc "The entity's city."
              | optional,
            country
              | _js2n__-refsenv."_js2n__-:definitions/country!contract"
              | doc "The entity's country."
              | optional,
            date-end
              | _js2n__-refsenv."_js2n__-:definitions/date!contract"
              | doc "The entity's ending date, e.g., when the entity is a conference."
              | optional,
            date-start
              | _js2n__-refsenv."_js2n__-:definitions/date!contract"
              | doc "The entity's starting date, e.g., when the entity is a conference."
              | optional,
            email
              | _js2n__-refsenv."_js2n__-:definitions/email!contract"
              | doc "The entity's email address."
              | optional,
            fax
              | _js2n__-refsenv."_js2n__-:definitions/fax!contract"
              | doc "The entity's fax number."
              | optional,
            location
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The entity's location, e.g., when the entity is a conference."
              | optional,
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The entity's name.",
            orcid
              | _js2n__-refsenv."_js2n__-:definitions/orcid!contract"
              | doc "The entity's orcid."
              | optional,
            post-code
              | _js2n__-refsenv."_js2n__-:definitions/post-code!contract"
              | doc "The entity's post code."
              | optional,
            region
              | _js2n__-refsenv."_js2n__-:definitions/region!contract"
              | doc "The entity's region."
              | optional,
            tel
              | _js2n__-refsenv."_js2n__-:definitions/tel!contract"
              | doc "The entity's telephone number."
              | optional,
            website
              | _js2n__-refsenv."_js2n__-:definitions/url!contract"
              | doc "The entity's website."
              | optional,
          },
      "_js2n__-:definitions/entity!predicate"
        | doc "An entity, i.e., an institution, team, research group, company, conference, etc., as opposed to a single natural person."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/address!predicate",
                  alias =
                    _js2n__-refsenv."_js2n__-:definitions/alias!predicate",
                  city = _js2n__-refsenv."_js2n__-:definitions/city!predicate",
                  country =
                    _js2n__-refsenv."_js2n__-:definitions/country!predicate",
                  date-end =
                    _js2n__-refsenv."_js2n__-:definitions/date!predicate",
                  date-start =
                    _js2n__-refsenv."_js2n__-:definitions/date!predicate",
                  email =
                    _js2n__-refsenv."_js2n__-:definitions/email!predicate",
                  fax = _js2n__-refsenv."_js2n__-:definitions/fax!predicate",
                  location =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  orcid =
                    _js2n__-refsenv."_js2n__-:definitions/orcid!predicate",
                  post-code =
                    _js2n__-refsenv."_js2n__-:definitions/post-code!predicate",
                  region =
                    _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                  tel = _js2n__-refsenv."_js2n__-:definitions/tel!predicate",
                  website =
                    _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/fax!contract"
        | doc "A fax number."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/fax!predicate"
        | doc "A fax number."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/identifier!predicate"
        | doc "An identifier for a work."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type", "value" ],
                  _js2n__-prdslib.records.record
                    {
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/identifier-description!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "doi" ]
                            ],
                      value =
                        _js2n__-refsenv."_js2n__-:definitions/doi!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type", "value" ],
                  _js2n__-prdslib.records.record
                    {
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/identifier-description!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "url" ]
                            ],
                      value =
                        _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type", "value" ],
                  _js2n__-prdslib.records.record
                    {
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/identifier-description!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "swh" ]
                            ],
                      value =
                        _js2n__-refsenv."_js2n__-:definitions/swh-identifier!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type", "value" ],
                  _js2n__-prdslib.records.record
                    {
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/identifier-description!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "other" ]
                            ],
                      value =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/identifier-description!predicate"
        | doc "A description for a specific identifier value."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/license!contract"
        | doc "An SPDX license identifier."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-refsenv."_js2n__-:definitions/license-enum!predicate",
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      _js2n__-refsenv."_js2n__-:definitions/license-enum!predicate",
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ]
              ]),
      "_js2n__-:definitions/license!predicate"
        | doc "An SPDX license identifier."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/license-enum!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/license-enum!predicate",
                  _js2n__-prdslib.arrays.minItems 1,
                  _js2n__-prdslib.arrays.uniqueItems
                ]
            ],
      "_js2n__-:definitions/license-enum!predicate"
        | doc "SPDX license list; releaseDate=2021-05-14; source=https://raw.githubusercontent.com/spdx/license-list-data/master/json/licenses.json"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "0BSD",
                  "AAL",
                  "Abstyles",
                  "Adobe-2006",
                  "Adobe-Glyph",
                  "ADSL",
                  "AFL-1.1",
                  "AFL-1.2",
                  "AFL-2.0",
                  "AFL-2.1",
                  "AFL-3.0",
                  "Afmparse",
                  "AGPL-1.0",
                  "AGPL-1.0-only",
                  "AGPL-1.0-or-later",
                  "AGPL-3.0",
                  "AGPL-3.0-only",
                  "AGPL-3.0-or-later",
                  "Aladdin",
                  "AMDPLPA",
                  "AML",
                  "AMPAS",
                  "ANTLR-PD",
                  "ANTLR-PD-fallback",
                  "Apache-1.0",
                  "Apache-1.1",
                  "Apache-2.0",
                  "APAFML",
                  "APL-1.0",
                  "APSL-1.0",
                  "APSL-1.1",
                  "APSL-1.2",
                  "APSL-2.0",
                  "Artistic-1.0",
                  "Artistic-1.0-cl8",
                  "Artistic-1.0-Perl",
                  "Artistic-2.0",
                  "Bahyph",
                  "Barr",
                  "Beerware",
                  "BitTorrent-1.0",
                  "BitTorrent-1.1",
                  "blessing",
                  "BlueOak-1.0.0",
                  "Borceux",
                  "BSD-1-Clause",
                  "BSD-2-Clause",
                  "BSD-2-Clause-FreeBSD",
                  "BSD-2-Clause-NetBSD",
                  "BSD-2-Clause-Patent",
                  "BSD-2-Clause-Views",
                  "BSD-3-Clause",
                  "BSD-3-Clause-Attribution",
                  "BSD-3-Clause-Clear",
                  "BSD-3-Clause-LBNL",
                  "BSD-3-Clause-Modification",
                  "BSD-3-Clause-No-Nuclear-License",
                  "BSD-3-Clause-No-Nuclear-License-2014",
                  "BSD-3-Clause-No-Nuclear-Warranty",
                  "BSD-3-Clause-Open-MPI",
                  "BSD-4-Clause",
                  "BSD-4-Clause-Shortened",
                  "BSD-4-Clause-UC",
                  "BSD-Protection",
                  "BSD-Source-Code",
                  "BSL-1.0",
                  "BUSL-1.1",
                  "bzip2-1.0.5",
                  "bzip2-1.0.6",
                  "C-UDA-1.0",
                  "CAL-1.0",
                  "CAL-1.0-Combined-Work-Exception",
                  "Caldera",
                  "CATOSL-1.1",
                  "CC-BY-1.0",
                  "CC-BY-2.0",
                  "CC-BY-2.5",
                  "CC-BY-3.0",
                  "CC-BY-3.0-AT",
                  "CC-BY-3.0-US",
                  "CC-BY-4.0",
                  "CC-BY-NC-1.0",
                  "CC-BY-NC-2.0",
                  "CC-BY-NC-2.5",
                  "CC-BY-NC-3.0",
                  "CC-BY-NC-4.0",
                  "CC-BY-NC-ND-1.0",
                  "CC-BY-NC-ND-2.0",
                  "CC-BY-NC-ND-2.5",
                  "CC-BY-NC-ND-3.0",
                  "CC-BY-NC-ND-3.0-IGO",
                  "CC-BY-NC-ND-4.0",
                  "CC-BY-NC-SA-1.0",
                  "CC-BY-NC-SA-2.0",
                  "CC-BY-NC-SA-2.5",
                  "CC-BY-NC-SA-3.0",
                  "CC-BY-NC-SA-4.0",
                  "CC-BY-ND-1.0",
                  "CC-BY-ND-2.0",
                  "CC-BY-ND-2.5",
                  "CC-BY-ND-3.0",
                  "CC-BY-ND-4.0",
                  "CC-BY-SA-1.0",
                  "CC-BY-SA-2.0",
                  "CC-BY-SA-2.0-UK",
                  "CC-BY-SA-2.1-JP",
                  "CC-BY-SA-2.5",
                  "CC-BY-SA-3.0",
                  "CC-BY-SA-3.0-AT",
                  "CC-BY-SA-4.0",
                  "CC-PDDC",
                  "CC0-1.0",
                  "CDDL-1.0",
                  "CDDL-1.1",
                  "CDL-1.0",
                  "CDLA-Permissive-1.0",
                  "CDLA-Sharing-1.0",
                  "CECILL-1.0",
                  "CECILL-1.1",
                  "CECILL-2.0",
                  "CECILL-2.1",
                  "CECILL-B",
                  "CECILL-C",
                  "CERN-OHL-1.1",
                  "CERN-OHL-1.2",
                  "CERN-OHL-P-2.0",
                  "CERN-OHL-S-2.0",
                  "CERN-OHL-W-2.0",
                  "ClArtistic",
                  "CNRI-Jython",
                  "CNRI-Python",
                  "CNRI-Python-GPL-Compatible",
                  "Condor-1.1",
                  "copyleft-next-0.3.0",
                  "copyleft-next-0.3.1",
                  "CPAL-1.0",
                  "CPL-1.0",
                  "CPOL-1.02",
                  "Crossword",
                  "CrystalStacker",
                  "CUA-OPL-1.0",
                  "Cube",
                  "curl",
                  "D-FSL-1.0",
                  "diffmark",
                  "DOC",
                  "Dotseqn",
                  "DRL-1.0",
                  "DSDP",
                  "dvipdfm",
                  "ECL-1.0",
                  "ECL-2.0",
                  "eCos-2.0",
                  "EFL-1.0",
                  "EFL-2.0",
                  "eGenix",
                  "Entessa",
                  "EPICS",
                  "EPL-1.0",
                  "EPL-2.0",
                  "ErlPL-1.1",
                  "etalab-2.0",
                  "EUDatagrid",
                  "EUPL-1.0",
                  "EUPL-1.1",
                  "EUPL-1.2",
                  "Eurosym",
                  "Fair",
                  "Frameworx-1.0",
                  "FreeBSD-DOC",
                  "FreeImage",
                  "FSFAP",
                  "FSFUL",
                  "FSFULLR",
                  "FTL",
                  "GD",
                  "GFDL-1.1",
                  "GFDL-1.1-invariants-only",
                  "GFDL-1.1-invariants-or-later",
                  "GFDL-1.1-no-invariants-only",
                  "GFDL-1.1-no-invariants-or-later",
                  "GFDL-1.1-only",
                  "GFDL-1.1-or-later",
                  "GFDL-1.2",
                  "GFDL-1.2-invariants-only",
                  "GFDL-1.2-invariants-or-later",
                  "GFDL-1.2-no-invariants-only",
                  "GFDL-1.2-no-invariants-or-later",
                  "GFDL-1.2-only",
                  "GFDL-1.2-or-later",
                  "GFDL-1.3",
                  "GFDL-1.3-invariants-only",
                  "GFDL-1.3-invariants-or-later",
                  "GFDL-1.3-no-invariants-only",
                  "GFDL-1.3-no-invariants-or-later",
                  "GFDL-1.3-only",
                  "GFDL-1.3-or-later",
                  "Giftware",
                  "GL2PS",
                  "Glide",
                  "Glulxe",
                  "GLWTPL",
                  "gnuplot",
                  "GPL-1.0",
                  "GPL-1.0-only",
                  "GPL-1.0-or-later",
                  "GPL-1.0+",
                  "GPL-2.0",
                  "GPL-2.0-only",
                  "GPL-2.0-or-later",
                  "GPL-2.0-with-autoconf-exception",
                  "GPL-2.0-with-bison-exception",
                  "GPL-2.0-with-classpath-exception",
                  "GPL-2.0-with-font-exception",
                  "GPL-2.0-with-GCC-exception",
                  "GPL-2.0+",
                  "GPL-3.0",
                  "GPL-3.0-only",
                  "GPL-3.0-or-later",
                  "GPL-3.0-with-autoconf-exception",
                  "GPL-3.0-with-GCC-exception",
                  "GPL-3.0+",
                  "gSOAP-1.3b",
                  "HaskellReport",
                  "Hippocratic-2.1",
                  "HPND",
                  "HPND-sell-variant",
                  "HTMLTIDY",
                  "IBM-pibs",
                  "ICU",
                  "IJG",
                  "ImageMagick",
                  "iMatix",
                  "Imlib2",
                  "Info-ZIP",
                  "Intel",
                  "Intel-ACPI",
                  "Interbase-1.0",
                  "IPA",
                  "IPL-1.0",
                  "ISC",
                  "JasPer-2.0",
                  "JPNIC",
                  "JSON",
                  "LAL-1.2",
                  "LAL-1.3",
                  "Latex2e",
                  "Leptonica",
                  "LGPL-2.0",
                  "LGPL-2.0-only",
                  "LGPL-2.0-or-later",
                  "LGPL-2.0+",
                  "LGPL-2.1",
                  "LGPL-2.1-only",
                  "LGPL-2.1-or-later",
                  "LGPL-2.1+",
                  "LGPL-3.0",
                  "LGPL-3.0-only",
                  "LGPL-3.0-or-later",
                  "LGPL-3.0+",
                  "LGPLLR",
                  "Libpng",
                  "libpng-2.0",
                  "libselinux-1.0",
                  "libtiff",
                  "LiLiQ-P-1.1",
                  "LiLiQ-R-1.1",
                  "LiLiQ-Rplus-1.1",
                  "Linux-OpenIB",
                  "LPL-1.0",
                  "LPL-1.02",
                  "LPPL-1.0",
                  "LPPL-1.1",
                  "LPPL-1.2",
                  "LPPL-1.3a",
                  "LPPL-1.3c",
                  "MakeIndex",
                  "MirOS",
                  "MIT",
                  "MIT-0",
                  "MIT-advertising",
                  "MIT-CMU",
                  "MIT-enna",
                  "MIT-feh",
                  "MIT-Modern-Variant",
                  "MIT-open-group",
                  "MITNFA",
                  "Motosoto",
                  "mpich2",
                  "MPL-1.0",
                  "MPL-1.1",
                  "MPL-2.0",
                  "MPL-2.0-no-copyleft-exception",
                  "MS-PL",
                  "MS-RL",
                  "MTLL",
                  "MulanPSL-1.0",
                  "MulanPSL-2.0",
                  "Multics",
                  "Mup",
                  "NAIST-2003",
                  "NASA-1.3",
                  "Naumen",
                  "NBPL-1.0",
                  "NCGL-UK-2.0",
                  "NCSA",
                  "Net-SNMP",
                  "NetCDF",
                  "Newsletr",
                  "NGPL",
                  "NIST-PD",
                  "NIST-PD-fallback",
                  "NLOD-1.0",
                  "NLPL",
                  "Nokia",
                  "NOSL",
                  "Noweb",
                  "NPL-1.0",
                  "NPL-1.1",
                  "NPOSL-3.0",
                  "NRL",
                  "NTP",
                  "NTP-0",
                  "Nunit",
                  "O-UDA-1.0",
                  "OCCT-PL",
                  "OCLC-2.0",
                  "ODbL-1.0",
                  "ODC-By-1.0",
                  "OFL-1.0",
                  "OFL-1.0-no-RFN",
                  "OFL-1.0-RFN",
                  "OFL-1.1",
                  "OFL-1.1-no-RFN",
                  "OFL-1.1-RFN",
                  "OGC-1.0",
                  "OGDL-Taiwan-1.0",
                  "OGL-Canada-2.0",
                  "OGL-UK-1.0",
                  "OGL-UK-2.0",
                  "OGL-UK-3.0",
                  "OGTSL",
                  "OLDAP-1.1",
                  "OLDAP-1.2",
                  "OLDAP-1.3",
                  "OLDAP-1.4",
                  "OLDAP-2.0",
                  "OLDAP-2.0.1",
                  "OLDAP-2.1",
                  "OLDAP-2.2",
                  "OLDAP-2.2.1",
                  "OLDAP-2.2.2",
                  "OLDAP-2.3",
                  "OLDAP-2.4",
                  "OLDAP-2.5",
                  "OLDAP-2.6",
                  "OLDAP-2.7",
                  "OLDAP-2.8",
                  "OML",
                  "OpenSSL",
                  "OPL-1.0",
                  "OSET-PL-2.1",
                  "OSL-1.0",
                  "OSL-1.1",
                  "OSL-2.0",
                  "OSL-2.1",
                  "OSL-3.0",
                  "Parity-6.0.0",
                  "Parity-7.0.0",
                  "PDDL-1.0",
                  "PHP-3.0",
                  "PHP-3.01",
                  "Plexus",
                  "PolyForm-Noncommercial-1.0.0",
                  "PolyForm-Small-Business-1.0.0",
                  "PostgreSQL",
                  "PSF-2.0",
                  "psfrag",
                  "psutils",
                  "Python-2.0",
                  "Qhull",
                  "QPL-1.0",
                  "Rdisc",
                  "RHeCos-1.1",
                  "RPL-1.1",
                  "RPL-1.5",
                  "RPSL-1.0",
                  "RSA-MD",
                  "RSCPL",
                  "Ruby",
                  "SAX-PD",
                  "Saxpath",
                  "SCEA",
                  "Sendmail",
                  "Sendmail-8.23",
                  "SGI-B-1.0",
                  "SGI-B-1.1",
                  "SGI-B-2.0",
                  "SHL-0.5",
                  "SHL-0.51",
                  "SimPL-2.0",
                  "SISSL",
                  "SISSL-1.2",
                  "Sleepycat",
                  "SMLNJ",
                  "SMPPL",
                  "SNIA",
                  "Spencer-86",
                  "Spencer-94",
                  "Spencer-99",
                  "SPL-1.0",
                  "SSH-OpenSSH",
                  "SSH-short",
                  "SSPL-1.0",
                  "StandardML-NJ",
                  "SugarCRM-1.1.3",
                  "SWL",
                  "TAPR-OHL-1.0",
                  "TCL",
                  "TCP-wrappers",
                  "TMate",
                  "TORQUE-1.1",
                  "TOSL",
                  "TU-Berlin-1.0",
                  "TU-Berlin-2.0",
                  "UCL-1.0",
                  "Unicode-DFS-2015",
                  "Unicode-DFS-2016",
                  "Unicode-TOU",
                  "Unlicense",
                  "UPL-1.0",
                  "Vim",
                  "VOSTROM",
                  "VSL-1.0",
                  "W3C",
                  "W3C-19980720",
                  "W3C-20150513",
                  "Watcom-1.0",
                  "Wsuipa",
                  "WTFPL",
                  "wxWindows",
                  "X11",
                  "Xerox",
                  "XFree86-1.1",
                  "xinetd",
                  "Xnet",
                  "xpp",
                  "XSkat",
                  "YPL-1.0",
                  "YPL-1.1",
                  "Zed",
                  "Zend-2.0",
                  "Zimbra-1.3",
                  "Zimbra-1.4",
                  "Zlib",
                  "zlib-acknowledgement",
                  "ZPL-1.1",
                  "ZPL-2.0",
                  "ZPL-2.1"
                ]
            ],
      "_js2n__-:definitions/orcid!contract"
        | doc "Identifier for an author, see https://orcid.org."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "https://orcid\\.org/[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{3}[0-9X]{1}"
              ]),
      "_js2n__-:definitions/orcid!predicate"
        | doc "Identifier for an author, see https://orcid.org."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "https://orcid\\.org/[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{3}[0-9X]{1}"
            ],
      "_js2n__-:definitions/person!predicate"
        | doc "A person."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/address!predicate",
                  affiliation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  alias =
                    _js2n__-refsenv."_js2n__-:definitions/alias!predicate",
                  city = _js2n__-refsenv."_js2n__-:definitions/city!predicate",
                  country =
                    _js2n__-refsenv."_js2n__-:definitions/country!predicate",
                  email =
                    _js2n__-refsenv."_js2n__-:definitions/email!predicate",
                  family-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  fax = _js2n__-refsenv."_js2n__-:definitions/fax!predicate",
                  given-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  name-particle =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  name-suffix =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  orcid =
                    _js2n__-refsenv."_js2n__-:definitions/orcid!predicate",
                  post-code =
                    _js2n__-refsenv."_js2n__-:definitions/post-code!predicate",
                  region =
                    _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                  tel = _js2n__-refsenv."_js2n__-:definitions/tel!predicate",
                  website =
                    _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/post-code!contract"
        | doc "A post code."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ],
                _js2n__-prdslib.isType '"Number"
              ]),
      "_js2n__-:definitions/post-code!predicate"
        | doc "A post code."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ],
              _js2n__-prdslib.isType '"Number"
            ],
      "_js2n__-:definitions/reference!contract"
        | doc "A reference to a work."
        = {
            abbreviation
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The abbreviation of a work."
              | optional,
            abstract
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The abstract of a work."
              | optional,
            authors
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The author(s) of a work.",
            collection-doi
              | _js2n__-refsenv."_js2n__-:definitions/doi!contract"
              | doc "The DOI of a collection containing the work."
              | optional,
            collection-title
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The title of a collection or proceedings."
              | optional,
            collection-type
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The type of a collection."
              | optional,
            commit
              | _js2n__-refsenv."_js2n__-:definitions/commit!contract"
              | optional,
            conference
              | _js2n__-refsenv."_js2n__-:definitions/entity!contract"
              | doc "The conference where the work was presented."
              | optional,
            contact
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The contact person, group, company, etc. for a work."
              | optional,
            copyright
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The copyright information pertaining to the work."
              | optional,
            data-type
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The data type of a data set."
              | optional,
            database
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The name of the database where a work was accessed/is stored."
              | optional,
            database-provider
              | _js2n__-refsenv."_js2n__-:definitions/entity!contract"
              | doc "The provider of the database where a work was accessed/is stored."
              | optional,
            date-accessed
              | _js2n__-refsenv."_js2n__-:definitions/date!contract"
              | doc "The date the work was accessed."
              | optional,
            date-downloaded
              | _js2n__-refsenv."_js2n__-:definitions/date!contract"
              | doc "The date the work has been downloaded."
              | optional,
            date-published
              | _js2n__-refsenv."_js2n__-:definitions/date!contract"
              | doc "The date the work has been published."
              | optional,
            date-released
              | _js2n__-refsenv."_js2n__-:definitions/date!contract"
              | doc "The date the work has been released."
              | optional,
            department
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The department where a work has been produced."
              | optional,
            doi
              | _js2n__-refsenv."_js2n__-:definitions/doi!contract"
              | doc "The DOI of the work."
              | optional,
            edition
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The edition of the work."
              | optional,
            editors
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The editor(s) of a work."
              | optional,
            editors-series
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The editor(s) of a series in which a work has been published."
              | optional,
            end
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]
                  ])
              | doc "The end page of the work."
              | optional,
            entry
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "An entry in the collection that constitutes the work."
              | optional,
            filename
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The name of the electronic file containing the work."
              | optional,
            format
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The format in which a work is represented."
              | optional,
            identifiers
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The identifier(s) of the work."
              | optional,
            institution
              | _js2n__-refsenv."_js2n__-:definitions/entity!contract"
              | doc "The institution where a work has been produced or published."
              | optional,
            isbn
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[0-9\\- ]{10,17}X?$"
                  ])
              | doc "The ISBN of the work."
              | optional,
            issn
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^\\d{4}-\\d{3}[\\dxX]$"
                  ])
              | doc "The ISSN of the work."
              | optional,
            issue
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ],
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "The issue of a periodical in which a work appeared."
              | optional,
            issue-date
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The publication date of the issue of a periodical in which a work appeared."
              | optional,
            issue-title
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The name of the issue of a periodical in which the work appeared."
              | optional,
            journal
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The name of the journal/magazine/newspaper/periodical where the work was published."
              | optional,
            keywords
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "Keywords pertaining to the work."
              | optional,
            languages
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 3,
                          _js2n__-prdslib.strings.minLength 2,
                          _js2n__-prdslib.strings.pattern "^[a-z]{2,3}$"
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The language identifier(s) of the work according to ISO 639 language strings."
              | optional,
            license
              | _js2n__-refsenv."_js2n__-:definitions/license!contract"
              | optional,
            license-url
              | _js2n__-refsenv."_js2n__-:definitions/url!contract"
              | doc "The URL of the license text under which the work is licensed (only for non-standard licenses not included in the SPDX License List)."
              | optional,
            loc-end
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]
                  ])
              | doc "The line of code in the file where the work ends."
              | optional,
            loc-start
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]
                  ])
              | doc "The line of code in the file where the work starts."
              | optional,
            location
              | _js2n__-refsenv."_js2n__-:definitions/entity!contract"
              | doc "The location of the work."
              | optional,
            medium
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The medium of the work."
              | optional,
            month
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.maximum 12,
                        _js2n__-prdslib.numbers.minimum 1
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "1",
                            "2",
                            "3",
                            "4",
                            "5",
                            "6",
                            "7",
                            "8",
                            "9",
                            "10",
                            "11",
                            "12"
                          ]
                      ]
                  ])
              | doc "The month in which a work has been published."
              | optional,
            nihmsid
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The NIHMSID of a work."
              | optional,
            notes
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "Notes pertaining to the work."
              | optional,
            number
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ],
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "The accession number for a work."
              | optional,
            number-volumes
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]
                  ])
              | doc "The number of volumes making up the collection in which the work has been published."
              | optional,
            pages
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]
                  ])
              | doc "The number of pages of the work."
              | optional,
            patent-states
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The states for which a patent is granted."
              | optional,
            pmcid
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^PMC[0-9]{7}$"
                  ])
              | doc "The PMCID of a work."
              | optional,
            publisher
              | _js2n__-refsenv."_js2n__-:definitions/entity!contract"
              | doc "The publisher who has published the work."
              | optional,
            recipients
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/person!predicate"
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The recipient(s) of a personal communication."
              | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/url!contract"
              | doc "The URL of the work in a repository (when the repository is neither a source code repository nor a build artifact repository)."
              | optional,
            repository-artifact
              | _js2n__-refsenv."_js2n__-:definitions/url!contract"
              | doc "The URL of the work in a build artifact/binary repository."
              | optional,
            repository-code
              | _js2n__-refsenv."_js2n__-:definitions/url!contract"
              | doc "The URL of the work in a source code repository."
              | optional,
            scope
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The scope of the reference, e.g., the section of the work it adheres to."
              | optional,
            section
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ],
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "The section of a work that is referenced."
              | optional,
            senders
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/person!predicate"
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The sender(s) of a personal communication."
              | optional,
            start
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]
                  ])
              | doc "The start page of the work."
              | optional,
            status
              | std.enum.TagOrString
              | [|
                'submitted,
                'preprint,
                'in-press,
                'in-preparation,
                'advance-online,
                'abstract
              |]
              | doc "The publication status of the work."
              | optional,
            term
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The term being referenced if the work is a dictionary or encyclopedia."
              | optional,
            thesis-type
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The type of the thesis that is the work."
              | optional,
            title
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The title of the work.",
            translators
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/person!predicate"
                        ]),
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "The translator(s) of a work."
              | optional,
            type
              | std.enum.TagOrString
              | [|
                'website,
                'video,
                'unpublished,
                'thesis,
                'statute,
                'standard,
                'sound-recording,
                'software,
                'software-virtual-machine,
                'software-executable,
                'software-container,
                'software-code,
                'slides,
                'serial,
                'report,
                'proceedings,
                'personal-communication,
                'patent,
                'pamphlet,
                'newspaper-article,
                'music,
                'multimedia,
                'map,
                'manual,
                'magazine-article,
                'legal-rule,
                'legal-case,
                'historical-work,
                'hearing,
                'grant,
                'government-document,
                'generic,
                'film-broadcast,
                'encyclopedia,
                'edited-work,
                'dictionary,
                'database,
                'data,
                'conference,
                'conference-paper,
                'catalogue,
                'book,
                'blog,
                'bill,
                'audiovisual,
                'article,
                'art
              |]
              | doc "The type of the work.",
            url
              | _js2n__-refsenv."_js2n__-:definitions/url!contract"
              | doc "The URL of the work."
              | optional,
            version
              | _js2n__-refsenv."_js2n__-:definitions/version!contract"
              | doc "The version of the work."
              | optional,
            volume
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]
                  ])
              | doc "The volume of the periodical in which a work appeared."
              | optional,
            volume-title
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
              | doc "The title of the volume in which the work appeared."
              | optional,
            year
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]
                  ])
              | doc "The year in which a work has been published."
              | optional,
            year-original
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]
                  ])
              | doc "The year of the original publication."
              | optional,
          },
      "_js2n__-:definitions/reference!predicate"
        | doc "A reference to a work."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "authors", "title", "type" ],
              _js2n__-prdslib.records.record
                {
                  abbreviation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  abstract =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  authors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  collection-doi =
                    _js2n__-refsenv."_js2n__-:definitions/doi!predicate",
                  collection-title =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  collection-type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  commit =
                    _js2n__-refsenv."_js2n__-:definitions/commit!predicate",
                  conference =
                    _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                  contact =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  copyright =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  data-type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  database =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  database-provider =
                    _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                  date-accessed =
                    _js2n__-refsenv."_js2n__-:definitions/date!predicate",
                  date-downloaded =
                    _js2n__-refsenv."_js2n__-:definitions/date!predicate",
                  date-published =
                    _js2n__-refsenv."_js2n__-:definitions/date!predicate",
                  date-released =
                    _js2n__-refsenv."_js2n__-:definitions/date!predicate",
                  department =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  doi = _js2n__-refsenv."_js2n__-:definitions/doi!predicate",
                  edition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  editors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  editors-series =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  end =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  entry =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  filename =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  format =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  identifiers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  institution =
                    _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                  isbn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^[0-9\\- ]{10,17}X?$"
                        ],
                  issn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\d{4}-\\d{3}[\\dxX]$"
                        ],
                  issue =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ],
                          _js2n__-prdslib.isType '"Number"
                        ],
                  issue-date =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  issue-title =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  journal =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  keywords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  languages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 3,
                                _js2n__-prdslib.strings.minLength 2,
                                _js2n__-prdslib.strings.pattern "^[a-z]{2,3}$"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  license =
                    _js2n__-refsenv."_js2n__-:definitions/license!predicate",
                  license-url =
                    _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                  loc-end =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  loc-start =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                  medium =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  month =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 12,
                              _js2n__-prdslib.numbers.minimum 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "1",
                                  "2",
                                  "3",
                                  "4",
                                  "5",
                                  "6",
                                  "7",
                                  "8",
                                  "9",
                                  "10",
                                  "11",
                                  "12"
                                ]
                            ]
                        ],
                  nihmsid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  notes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  number =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ],
                          _js2n__-prdslib.isType '"Number"
                        ],
                  number-volumes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  pages =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  patent-states =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  pmcid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^PMC[0-9]{7}$"
                        ],
                  publisher =
                    _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                  recipients =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/person!predicate"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                  repository-artifact =
                    _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                  repository-code =
                    _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                  scope =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  section =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ],
                          _js2n__-prdslib.isType '"Number"
                        ],
                  senders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/person!predicate"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  start =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  status =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "abstract",
                              "advance-online",
                              "in-preparation",
                              "in-press",
                              "preprint",
                              "submitted"
                            ]
                        ],
                  term =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  thesis-type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  title =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  translators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/entity!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/person!predicate"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "art",
                              "article",
                              "audiovisual",
                              "bill",
                              "blog",
                              "book",
                              "catalogue",
                              "conference-paper",
                              "conference",
                              "data",
                              "database",
                              "dictionary",
                              "edited-work",
                              "encyclopedia",
                              "film-broadcast",
                              "generic",
                              "government-document",
                              "grant",
                              "hearing",
                              "historical-work",
                              "legal-case",
                              "legal-rule",
                              "magazine-article",
                              "manual",
                              "map",
                              "multimedia",
                              "music",
                              "newspaper-article",
                              "pamphlet",
                              "patent",
                              "personal-communication",
                              "proceedings",
                              "report",
                              "serial",
                              "slides",
                              "software-code",
                              "software-container",
                              "software-executable",
                              "software-virtual-machine",
                              "software",
                              "sound-recording",
                              "standard",
                              "statute",
                              "thesis",
                              "unpublished",
                              "video",
                              "website"
                            ]
                        ],
                  url = _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                  volume =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  volume-title =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  year =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  year-original =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/region!contract"
        | doc "A region."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/region!predicate"
        | doc "A region."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/swh-identifier!predicate"
        | doc "The Software Heritage identifier (without further qualifiers such as origin, visit, anchor, path)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^swh:1:(snp|rel|rev|dir|cnt):[0-9a-fA-F]{40}$"
            ],
      "_js2n__-:definitions/tel!contract"
        | doc "A phone number."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/tel!predicate"
        | doc "A phone number."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/url!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^(https|http|ftp|sftp)://.+"
              ]),
      "_js2n__-:definitions/url!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^(https|http|ftp|sftp)://.+"
            ],
      "_js2n__-:definitions/version!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ],
                _js2n__-prdslib.isType '"Number"
              ]),
      "_js2n__-:definitions/version!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ],
              _js2n__-prdslib.isType '"Number"
            ],
    }
    in
  {
      abstract
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc "A description of the software or dataset."
        | optional,
      authors
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "The author(s) of the software or dataset.",
      cff-version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^1\\.2\\.0$"
            ])
        | doc "The version of CFF used for providing the citation metadata.",
      commit
        | _js2n__-refsenv."_js2n__-:definitions/commit!contract"
        | optional,
      contact
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/person!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/entity!predicate"
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "The contact person, group, company, etc. for the software or dataset."
        | optional,
      date-released
        | _js2n__-refsenv."_js2n__-:definitions/date!contract"
        | doc "The date the work has been released."
        | optional,
      doi | _js2n__-refsenv."_js2n__-:definitions/doi!contract" | optional,
      identifiers
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "The identifiers of the software or dataset."
        | optional,
      keywords
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Keywords that describe the work."
        | optional,
      license
        | _js2n__-refsenv."_js2n__-:definitions/license!contract"
        | optional,
      license-url
        | _js2n__-refsenv."_js2n__-:definitions/url!contract"
        | doc "The URL of the license text under which the software or dataset is licensed (only for non-standard licenses not included in the SPDX License List)."
        | optional,
      message
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc "A message to the human reader of the file to let them know what to do with the citation metadata.",
      preferred-citation
        | _js2n__-refsenv."_js2n__-:definitions/reference!contract"
        | doc "A reference to another work that should be cited instead of the software or dataset itself."
        | optional,
      references
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/reference!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Reference(s) to other creative works."
        | optional,
      repository
        | _js2n__-refsenv."_js2n__-:definitions/url!contract"
        | doc "The URL of the software or dataset in a repository (when the repository is neither a source code repository nor a build artifact repository)."
        | optional,
      repository-artifact
        | _js2n__-refsenv."_js2n__-:definitions/url!contract"
        | doc "The URL of the software in a build artifact/binary repository."
        | optional,
      repository-code
        | _js2n__-refsenv."_js2n__-:definitions/url!contract"
        | doc "The URL of the software or dataset in a source code repository."
        | optional,
      title
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc "The name of the software or dataset.",
      type
        | std.enum.TagOrString
        | [| 'software, 'dataset |]
        | doc "The type of the work."
        | optional,
      url
        | _js2n__-refsenv."_js2n__-:definitions/url!contract"
        | doc "The URL of a landing page/website for the software or dataset."
        | optional,
      version
        | _js2n__-refsenv."_js2n__-:definitions/version!contract"
        | doc "The version of the software or dataset."
        | optional,
    }