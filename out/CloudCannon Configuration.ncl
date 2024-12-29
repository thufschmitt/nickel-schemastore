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
      "_js2n__-:definitions/AddOption!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  base_path = _js2n__-prdslib.isType '"String",
                  collection = _js2n__-prdslib.isType '"String",
                  default_content_file = _js2n__-prdslib.isType '"String",
                  editor =
                    _js2n__-refsenv."_js2n__-:definitions/EditorKey!predicate",
                  icon = _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  schema = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArrayInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ArrayInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "array"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArrayInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "array" ]
                        ],
                  structures =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AttributeListPosition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "none",
                  "right",
                  "space right",
                  "below",
                  "newline below",
                  "right-of-prefix"
                ]
            ],
      "_js2n__-:definitions/BaseInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/WithEmptyTypeText!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WithEmptyTypeNumber!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WithEmptyTypeObject!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WithEmptyTypeArray!predicate"
                        ],
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/InputType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BlockEditable!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_custom_markup = _js2n__-prdslib.isType '"Bool",
                  allowed_sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  blockquote = _js2n__-prdslib.isType '"Bool",
                  bold = _js2n__-prdslib.isType '"Bool",
                  bulletedlist = _js2n__-prdslib.isType '"Bool",
                  center = _js2n__-prdslib.isType '"String",
                  code = _js2n__-prdslib.isType '"Bool",
                  code_block = _js2n__-prdslib.isType '"Bool",
                  code_inline = _js2n__-prdslib.isType '"Bool",
                  copyformatting = _js2n__-prdslib.isType '"Bool",
                  embed = _js2n__-prdslib.isType '"Bool",
                  expandable = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  height = _js2n__-prdslib.isType '"Number",
                  horizontalrule = _js2n__-prdslib.isType '"Bool",
                  image = _js2n__-prdslib.isType '"Bool",
                  image_size_attributes = _js2n__-prdslib.isType '"Bool",
                  indent = _js2n__-prdslib.isType '"Bool",
                  italic = _js2n__-prdslib.isType '"Bool",
                  justify = _js2n__-prdslib.isType '"String",
                  left = _js2n__-prdslib.isType '"String",
                  link = _js2n__-prdslib.isType '"Bool",
                  mime_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "image/jpeg", "image/png", "image/webp" ]
                        ],
                  numberedlist = _js2n__-prdslib.isType '"Bool",
                  outdent = _js2n__-prdslib.isType '"Bool",
                  paths =
                    _js2n__-refsenv."_js2n__-:definitions/Paths!predicate",
                  prevent_resize_existing_files =
                    _js2n__-prdslib.isType '"Bool",
                  redo = _js2n__-prdslib.isType '"Bool",
                  remove_custom_markup = _js2n__-prdslib.isType '"Bool",
                  removeformat = _js2n__-prdslib.isType '"Bool",
                  resize_style =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "cover", "contain", "stretch", "crop" ]
                        ],
                  right = _js2n__-prdslib.isType '"String",
                  sizes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "size" ],
                                _js2n__-prdslib.records.record
                                  {
                                    size = _js2n__-prdslib.isType '"String",
                                    target = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  snippet = _js2n__-prdslib.isType '"Bool",
                  strike = _js2n__-prdslib.isType '"Bool",
                  styles = _js2n__-prdslib.isType '"String",
                  subscript = _js2n__-prdslib.isType '"Bool",
                  superscript = _js2n__-prdslib.isType '"Bool",
                  table = _js2n__-prdslib.isType '"Bool",
                  underline = _js2n__-prdslib.isType '"Bool",
                  undo = _js2n__-prdslib.isType '"Bool",
                  width = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BooleanInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "checkbox", "switch" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ChoiceInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              allow_empty = _js2n__-prdslib.isType '"Bool",
                              empty_type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "null", "string" ]
                                    ],
                              picker_preview =
                                _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                              picker_view =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "card",
                                          "text",
                                          "gallery",
                                          "gallery-left"
                                        ]
                                    ],
                              preview =
                                _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                              value_key = _js2n__-prdslib.isType '"String",
                              values =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                                    ],
                              view =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "card",
                                          "text",
                                          "gallery",
                                          "gallery-left"
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "choice"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CodeInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/CodeInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "code"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CodeInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "string" ]
                        ],
                  max_visible_lines = _js2n__-prdslib.isType '"Number",
                  min_visible_lines = _js2n__-prdslib.isType '"Number",
                  show_gutter = _js2n__-prdslib.isType '"Bool",
                  syntax =
                    _js2n__-refsenv."_js2n__-:definitions/Syntax!predicate",
                  tab_size = _js2n__-prdslib.isType '"Number",
                  theme =
                    _js2n__-refsenv."_js2n__-:definitions/Theme!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CollectionConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  _editables =
                    _js2n__-refsenv."_js2n__-:definitions/Editables!predicate",
                  _enabled_editors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EditorKey!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  _inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Input!predicate"
                        ],
                  _select_data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                        ],
                  _structures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                        ],
                  add_options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/AddOption!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/HrefAddOption!predicate"
                              ])
                        ],
                  create =
                    _js2n__-refsenv."_js2n__-:definitions/Create!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  disable_add = _js2n__-prdslib.isType '"Bool",
                  disable_add_folder = _js2n__-prdslib.isType '"Bool",
                  disable_file_actions = _js2n__-prdslib.isType '"Bool",
                  disable_url = _js2n__-prdslib.isType '"Bool",
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
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
                  icon = _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                  include_developer_files = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  new_preview_url = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  preview =
                    _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                  schema_key = _js2n__-prdslib.isType '"String",
                  schemas =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Schema!predicate"
                        ],
                  singular_name = _js2n__-prdslib.isType '"String",
                  sort = _js2n__-refsenv."_js2n__-:definitions/Sort!predicate",
                  sort_options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SortOption!predicate"
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CollectionGroup!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "collections", "heading" ],
              _js2n__-prdslib.records.record
                {
                  collections =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  heading = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ColorInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ColorInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "color"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ColorInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alpha = _js2n__-prdslib.isType '"Bool",
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "string" ]
                        ],
                  format =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "rgb", "hex", "hsl", "hsv" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CommitTemplate!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  _inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Input!predicate"
                        ],
                  extra_data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  template_path = _js2n__-prdslib.isType '"String",
                  template_string = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Create!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  _inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Input!predicate"
                        ],
                  _select_data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                        ],
                  _structures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                        ],
                  extra_data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  publish_to = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DataConfigEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                { path = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DateInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/DateInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "date", "datetime" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DateInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "string" ]
                        ],
                  timezone =
                    _js2n__-refsenv."_js2n__-:definitions/Timezone!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Documentation!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  icon = _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                  text = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Editables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  block =
                    _js2n__-refsenv."_js2n__-:definitions/BlockEditable!predicate",
                  content =
                    _js2n__-refsenv."_js2n__-:definitions/BlockEditable!predicate",
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/ImageEditable!predicate",
                  link =
                    _js2n__-refsenv."_js2n__-:definitions/LinkEditable!predicate",
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/TextEditable!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Editor!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "default_path" ],
              _js2n__-prdslib.records.record
                { default_path = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/EditorKey!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "visual", "content", "data" ]
            ],
      "_js2n__-:definitions/FileConfigEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "glob" ],
              _js2n__-prdslib.records.record
                {
                  _editables =
                    _js2n__-refsenv."_js2n__-:definitions/Editables!predicate",
                  _enabled_editors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EditorKey!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  _inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Input!predicate"
                        ],
                  _select_data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                        ],
                  _structures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                        ],
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
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FileInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/FileInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "file", "document" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FileInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accepts_mime_types =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MimeType!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  allowed_sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "string" ]
                        ],
                  paths =
                    _js2n__-refsenv."_js2n__-:definitions/Paths!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HrefAddOption!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "href" ],
              _js2n__-prdslib.records.record
                {
                  href = _js2n__-prdslib.isType '"String",
                  icon = _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Icon!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "10k",
                  "10mp",
                  "11mp",
                  "123",
                  "12mp",
                  "13mp",
                  "14mp",
                  "15mp",
                  "16mp",
                  "17mp",
                  "18_up_rating",
                  "18mp",
                  "19mp",
                  "1k",
                  "1k_plus",
                  "1x_mobiledata",
                  "20mp",
                  "21mp",
                  "22mp",
                  "23mp",
                  "24mp",
                  "2k",
                  "2k_plus",
                  "2mp",
                  "30fps",
                  "30fps_select",
                  "360",
                  "3d_rotation",
                  "3g_mobiledata",
                  "3k",
                  "3k_plus",
                  "3mp",
                  "3p",
                  "4g_mobiledata",
                  "4g_plus_mobiledata",
                  "4k",
                  "4k_plus",
                  "4mp",
                  "5g",
                  "5k",
                  "5k_plus",
                  "5mp",
                  "60fps",
                  "60fps_select",
                  "6_ft_apart",
                  "6k",
                  "6k_plus",
                  "6mp",
                  "7k",
                  "7k_plus",
                  "7mp",
                  "8k",
                  "8k_plus",
                  "8mp",
                  "9k",
                  "9k_plus",
                  "9mp",
                  "abc",
                  "ac_unit",
                  "access_alarm",
                  "access_alarms",
                  "access_time",
                  "access_time_filled",
                  "accessibility",
                  "accessibility_new",
                  "accessible",
                  "accessible_forward",
                  "account_balance",
                  "account_balance_wallet",
                  "account_box",
                  "account_circle",
                  "account_tree",
                  "ad_units",
                  "adb",
                  "add",
                  "add_a_photo",
                  "add_alarm",
                  "add_alert",
                  "add_box",
                  "add_business",
                  "add_card",
                  "add_chart",
                  "add_circle",
                  "add_circle_outline",
                  "add_comment",
                  "add_home",
                  "add_home_work",
                  "add_ic_call",
                  "add_link",
                  "add_location",
                  "add_location_alt",
                  "add_moderator",
                  "add_photo_alternate",
                  "add_reaction",
                  "add_road",
                  "add_shopping_cart",
                  "add_task",
                  "add_to_drive",
                  "add_to_home_screen",
                  "add_to_photos",
                  "add_to_queue",
                  "addchart",
                  "adf_scanner",
                  "adjust",
                  "admin_panel_settings",
                  "ads_click",
                  "agriculture",
                  "air",
                  "airline_seat_flat",
                  "airline_seat_flat_angled",
                  "airline_seat_individual_suite",
                  "airline_seat_legroom_extra",
                  "airline_seat_legroom_normal",
                  "airline_seat_legroom_reduced",
                  "airline_seat_recline_extra",
                  "airline_seat_recline_normal",
                  "airline_stops",
                  "airlines",
                  "airplane_ticket",
                  "airplanemode_active",
                  "airplanemode_inactive",
                  "airplay",
                  "airport_shuttle",
                  "alarm",
                  "alarm_add",
                  "alarm_off",
                  "alarm_on",
                  "album",
                  "align_horizontal_center",
                  "align_horizontal_left",
                  "align_horizontal_right",
                  "align_vertical_bottom",
                  "align_vertical_center",
                  "align_vertical_top",
                  "all_inbox",
                  "all_inclusive",
                  "all_out",
                  "alt_route",
                  "alternate_email",
                  "analytics",
                  "anchor",
                  "android",
                  "animation",
                  "announcement",
                  "aod",
                  "apartment",
                  "api",
                  "app_blocking",
                  "app_registration",
                  "app_settings_alt",
                  "app_shortcut",
                  "approval",
                  "apps",
                  "apps_outage",
                  "architecture",
                  "archive",
                  "area_chart",
                  "arrow_back",
                  "arrow_back_ios",
                  "arrow_back_ios_new",
                  "arrow_circle_down",
                  "arrow_circle_left",
                  "arrow_circle_right",
                  "arrow_circle_up",
                  "arrow_downward",
                  "arrow_drop_down",
                  "arrow_drop_down_circle",
                  "arrow_drop_up",
                  "arrow_forward",
                  "arrow_forward_ios",
                  "arrow_left",
                  "arrow_outward",
                  "arrow_right",
                  "arrow_right_alt",
                  "arrow_upward",
                  "art_track",
                  "article",
                  "aspect_ratio",
                  "assessment",
                  "assignment",
                  "assignment_ind",
                  "assignment_late",
                  "assignment_return",
                  "assignment_returned",
                  "assignment_turned_in",
                  "assist_walker",
                  "assistant",
                  "assistant_direction",
                  "assistant_photo",
                  "assured_workload",
                  "atm",
                  "attach_email",
                  "attach_file",
                  "attach_money",
                  "attachment",
                  "attractions",
                  "attribution",
                  "audio_file",
                  "audiotrack",
                  "auto_awesome",
                  "auto_awesome_mosaic",
                  "auto_awesome_motion",
                  "auto_delete",
                  "auto_fix_high",
                  "auto_fix_normal",
                  "auto_fix_off",
                  "auto_graph",
                  "auto_mode",
                  "auto_stories",
                  "autofps_select",
                  "autorenew",
                  "av_timer",
                  "baby_changing_station",
                  "back_hand",
                  "backpack",
                  "backspace",
                  "backup",
                  "backup_table",
                  "badge",
                  "bakery_dining",
                  "balance",
                  "balcony",
                  "ballot",
                  "bar_chart",
                  "batch_prediction",
                  "bathroom",
                  "bathtub",
                  "battery_0_bar",
                  "battery_1_bar",
                  "battery_2_bar",
                  "battery_3_bar",
                  "battery_4_bar",
                  "battery_5_bar",
                  "battery_6_bar",
                  "battery_alert",
                  "battery_charging_full",
                  "battery_full",
                  "battery_saver",
                  "battery_std",
                  "battery_unknown",
                  "beach_access",
                  "bed",
                  "bedroom_baby",
                  "bedroom_child",
                  "bedroom_parent",
                  "bedtime",
                  "bedtime_off",
                  "beenhere",
                  "bento",
                  "bike_scooter",
                  "biotech",
                  "blender",
                  "blind",
                  "blinds",
                  "blinds_closed",
                  "block",
                  "bloodtype",
                  "bluetooth",
                  "bluetooth_audio",
                  "bluetooth_connected",
                  "bluetooth_disabled",
                  "bluetooth_drive",
                  "bluetooth_searching",
                  "blur_circular",
                  "blur_linear",
                  "blur_off",
                  "blur_on",
                  "bolt",
                  "book",
                  "book_online",
                  "bookmark",
                  "bookmark_add",
                  "bookmark_added",
                  "bookmark_border",
                  "bookmark_remove",
                  "bookmarks",
                  "border_all",
                  "border_bottom",
                  "border_clear",
                  "border_color",
                  "border_horizontal",
                  "border_inner",
                  "border_left",
                  "border_outer",
                  "border_right",
                  "border_style",
                  "border_top",
                  "border_vertical",
                  "boy",
                  "branding_watermark",
                  "breakfast_dining",
                  "brightness_1",
                  "brightness_2",
                  "brightness_3",
                  "brightness_4",
                  "brightness_5",
                  "brightness_6",
                  "brightness_7",
                  "brightness_auto",
                  "brightness_high",
                  "brightness_low",
                  "brightness_medium",
                  "broadcast_on_home",
                  "broadcast_on_personal",
                  "broken_image",
                  "browse_gallery",
                  "browser_not_supported",
                  "browser_updated",
                  "brunch_dining",
                  "brush",
                  "bubble_chart",
                  "bug_report",
                  "build",
                  "build_circle",
                  "bungalow",
                  "burst_mode",
                  "bus_alert",
                  "business",
                  "business_center",
                  "cabin",
                  "cable",
                  "cached",
                  "cake",
                  "calculate",
                  "calendar_month",
                  "calendar_today",
                  "calendar_view_day",
                  "calendar_view_month",
                  "calendar_view_week",
                  "call",
                  "call_end",
                  "call_made",
                  "call_merge",
                  "call_missed",
                  "call_missed_outgoing",
                  "call_received",
                  "call_split",
                  "call_to_action",
                  "camera",
                  "camera_alt",
                  "camera_enhance",
                  "camera_front",
                  "camera_indoor",
                  "camera_outdoor",
                  "camera_rear",
                  "camera_roll",
                  "cameraswitch",
                  "campaign",
                  "cancel",
                  "cancel_presentation",
                  "cancel_schedule_send",
                  "candlestick_chart",
                  "car_crash",
                  "car_rental",
                  "car_repair",
                  "card_giftcard",
                  "card_membership",
                  "card_travel",
                  "carpenter",
                  "cases",
                  "casino",
                  "cast",
                  "cast_connected",
                  "cast_for_education",
                  "castle",
                  "catching_pokemon",
                  "category",
                  "celebration",
                  "cell_tower",
                  "cell_wifi",
                  "center_focus_strong",
                  "center_focus_weak",
                  "chair",
                  "chair_alt",
                  "chalet",
                  "change_circle",
                  "change_history",
                  "charging_station",
                  "chat",
                  "chat_bubble",
                  "chat_bubble_outline",
                  "check",
                  "check_box",
                  "check_box_outline_blank",
                  "check_circle",
                  "check_circle_outline",
                  "checklist",
                  "checklist_rtl",
                  "checkroom",
                  "chevron_left",
                  "chevron_right",
                  "child_care",
                  "child_friendly",
                  "chrome_reader_mode",
                  "church",
                  "circle",
                  "circle_notifications",
                  "class",
                  "clean_hands",
                  "cleaning_services",
                  "clear",
                  "clear_all",
                  "close",
                  "close_fullscreen",
                  "closed_caption",
                  "closed_caption_disabled",
                  "closed_caption_off",
                  "cloud",
                  "cloud_circle",
                  "cloud_done",
                  "cloud_download",
                  "cloud_off",
                  "cloud_queue",
                  "cloud_sync",
                  "cloud_upload",
                  "co2",
                  "co_present",
                  "code",
                  "code_off",
                  "coffee",
                  "coffee_maker",
                  "collections",
                  "collections_bookmark",
                  "color_lens",
                  "colorize",
                  "comment",
                  "comment_bank",
                  "comments_disabled",
                  "commit",
                  "commute",
                  "compare",
                  "compare_arrows",
                  "compass_calibration",
                  "compost",
                  "compress",
                  "computer",
                  "confirmation_number",
                  "connect_without_contact",
                  "connected_tv",
                  "connecting_airports",
                  "construction",
                  "contact_emergency",
                  "contact_mail",
                  "contact_page",
                  "contact_phone",
                  "contact_support",
                  "contactless",
                  "contacts",
                  "content_copy",
                  "content_cut",
                  "content_paste",
                  "content_paste_go",
                  "content_paste_off",
                  "content_paste_search",
                  "contrast",
                  "control_camera",
                  "control_point",
                  "control_point_duplicate",
                  "cookie",
                  "copy_all",
                  "copyright",
                  "coronavirus",
                  "corporate_fare",
                  "cottage",
                  "countertops",
                  "create",
                  "create_new_folder",
                  "credit_card",
                  "credit_card_off",
                  "credit_score",
                  "crib",
                  "crisis_alert",
                  "crop",
                  "crop_16_9",
                  "crop_3_2",
                  "crop_5_4",
                  "crop_7_5",
                  "crop_din",
                  "crop_free",
                  "crop_landscape",
                  "crop_original",
                  "crop_portrait",
                  "crop_rotate",
                  "crop_square",
                  "cruelty_free",
                  "css",
                  "currency_bitcoin",
                  "currency_exchange",
                  "currency_franc",
                  "currency_lira",
                  "currency_pound",
                  "currency_ruble",
                  "currency_rupee",
                  "currency_yen",
                  "currency_yuan",
                  "curtains",
                  "curtains_closed",
                  "cyclone",
                  "dangerous",
                  "dark_mode",
                  "dashboard",
                  "dashboard_customize",
                  "data_array",
                  "data_exploration",
                  "data_object",
                  "data_saver_off",
                  "data_saver_on",
                  "data_thresholding",
                  "data_usage",
                  "dataset",
                  "dataset_linked",
                  "date_range",
                  "deblur",
                  "deck",
                  "dehaze",
                  "delete",
                  "delete_forever",
                  "delete_outline",
                  "delete_sweep",
                  "delivery_dining",
                  "density_large",
                  "density_medium",
                  "density_small",
                  "departure_board",
                  "description",
                  "deselect",
                  "design_services",
                  "desk",
                  "desktop_access_disabled",
                  "desktop_mac",
                  "desktop_windows",
                  "details",
                  "developer_board",
                  "developer_board_off",
                  "developer_mode",
                  "device_hub",
                  "device_thermostat",
                  "device_unknown",
                  "devices",
                  "devices_fold",
                  "devices_other",
                  "dialer_sip",
                  "dialpad",
                  "diamond",
                  "difference",
                  "dining",
                  "dinner_dining",
                  "directions",
                  "directions_bike",
                  "directions_boat",
                  "directions_boat_filled",
                  "directions_bus",
                  "directions_bus_filled",
                  "directions_car",
                  "directions_car_filled",
                  "directions_off",
                  "directions_railway",
                  "directions_railway_filled",
                  "directions_run",
                  "directions_subway",
                  "directions_subway_filled",
                  "directions_transit",
                  "directions_transit_filled",
                  "directions_walk",
                  "dirty_lens",
                  "disabled_by_default",
                  "disabled_visible",
                  "disc_full",
                  "discount",
                  "display_settings",
                  "diversity_1",
                  "diversity_2",
                  "diversity_3",
                  "dns",
                  "do_disturb",
                  "do_disturb_alt",
                  "do_disturb_off",
                  "do_disturb_on",
                  "do_not_disturb",
                  "do_not_disturb_alt",
                  "do_not_disturb_off",
                  "do_not_disturb_on",
                  "do_not_disturb_on_total_silence",
                  "do_not_step",
                  "do_not_touch",
                  "dock",
                  "document_scanner",
                  "domain",
                  "domain_add",
                  "domain_disabled",
                  "domain_verification",
                  "done",
                  "done_all",
                  "done_outline",
                  "donut_large",
                  "donut_small",
                  "door_back",
                  "door_front",
                  "door_sliding",
                  "doorbell",
                  "double_arrow",
                  "downhill_skiing",
                  "download",
                  "download_done",
                  "download_for_offline",
                  "downloading",
                  "drafts",
                  "drag_handle",
                  "drag_indicator",
                  "draw",
                  "drive_eta",
                  "drive_file_move",
                  "drive_file_move_rtl",
                  "drive_file_rename_outline",
                  "drive_folder_upload",
                  "dry",
                  "dry_cleaning",
                  "duo",
                  "dvr",
                  "dynamic_feed",
                  "dynamic_form",
                  "e_mobiledata",
                  "earbuds",
                  "earbuds_battery",
                  "east",
                  "edgesensor_high",
                  "edgesensor_low",
                  "edit",
                  "edit_attributes",
                  "edit_calendar",
                  "edit_location",
                  "edit_location_alt",
                  "edit_note",
                  "edit_notifications",
                  "edit_off",
                  "edit_road",
                  "egg",
                  "egg_alt",
                  "eject",
                  "elderly",
                  "elderly_woman",
                  "electric_bike",
                  "electric_bolt",
                  "electric_car",
                  "electric_meter",
                  "electric_moped",
                  "electric_rickshaw",
                  "electric_scooter",
                  "electrical_services",
                  "elevator",
                  "email",
                  "emergency",
                  "emergency_recording",
                  "emergency_share",
                  "emoji_emotions",
                  "emoji_events",
                  "emoji_food_beverage",
                  "emoji_nature",
                  "emoji_objects",
                  "emoji_people",
                  "emoji_symbols",
                  "emoji_transportation",
                  "energy_savings_leaf",
                  "engineering",
                  "enhanced_encryption",
                  "equalizer",
                  "error",
                  "error_outline",
                  "escalator",
                  "escalator_warning",
                  "euro",
                  "euro_symbol",
                  "ev_station",
                  "event",
                  "event_available",
                  "event_busy",
                  "event_note",
                  "event_repeat",
                  "event_seat",
                  "exit_to_app",
                  "expand",
                  "expand_circle_down",
                  "expand_less",
                  "expand_more",
                  "explicit",
                  "explore",
                  "explore_off",
                  "exposure",
                  "exposure_neg_1",
                  "exposure_neg_2",
                  "exposure_plus_1",
                  "exposure_plus_2",
                  "exposure_zero",
                  "extension",
                  "extension_off",
                  "face",
                  "face_2",
                  "face_3",
                  "face_4",
                  "face_5",
                  "face_6",
                  "face_retouching_natural",
                  "face_retouching_off",
                  "fact_check",
                  "factory",
                  "family_restroom",
                  "fast_forward",
                  "fast_rewind",
                  "fastfood",
                  "favorite",
                  "favorite_border",
                  "fax",
                  "featured_play_list",
                  "featured_video",
                  "feed",
                  "feedback",
                  "female",
                  "fence",
                  "festival",
                  "fiber_dvr",
                  "fiber_manual_record",
                  "fiber_new",
                  "fiber_pin",
                  "fiber_smart_record",
                  "file_copy",
                  "file_download",
                  "file_download_done",
                  "file_download_off",
                  "file_open",
                  "file_present",
                  "file_upload",
                  "filter",
                  "filter_1",
                  "filter_2",
                  "filter_3",
                  "filter_4",
                  "filter_5",
                  "filter_6",
                  "filter_7",
                  "filter_8",
                  "filter_9",
                  "filter_9_plus",
                  "filter_alt",
                  "filter_alt_off",
                  "filter_b_and_w",
                  "filter_center_focus",
                  "filter_drama",
                  "filter_frames",
                  "filter_hdr",
                  "filter_list",
                  "filter_list_off",
                  "filter_none",
                  "filter_tilt_shift",
                  "filter_vintage",
                  "find_in_page",
                  "find_replace",
                  "fingerprint",
                  "fire_extinguisher",
                  "fire_hydrant_alt",
                  "fire_truck",
                  "fireplace",
                  "first_page",
                  "fit_screen",
                  "fitbit",
                  "fitness_center",
                  "flag",
                  "flag_circle",
                  "flaky",
                  "flare",
                  "flash_auto",
                  "flash_off",
                  "flash_on",
                  "flashlight_off",
                  "flashlight_on",
                  "flatware",
                  "flight",
                  "flight_class",
                  "flight_land",
                  "flight_takeoff",
                  "flip",
                  "flip_camera_android",
                  "flip_camera_ios",
                  "flip_to_back",
                  "flip_to_front",
                  "flood",
                  "fluorescent",
                  "flutter_dash",
                  "fmd_bad",
                  "fmd_good",
                  "folder",
                  "folder_copy",
                  "folder_delete",
                  "folder_off",
                  "folder_open",
                  "folder_shared",
                  "folder_special",
                  "folder_zip",
                  "follow_the_signs",
                  "font_download",
                  "font_download_off",
                  "food_bank",
                  "forest",
                  "fork_left",
                  "fork_right",
                  "format_align_center",
                  "format_align_justify",
                  "format_align_left",
                  "format_align_right",
                  "format_bold",
                  "format_clear",
                  "format_color_fill",
                  "format_color_reset",
                  "format_color_text",
                  "format_indent_decrease",
                  "format_indent_increase",
                  "format_italic",
                  "format_line_spacing",
                  "format_list_bulleted",
                  "format_list_numbered",
                  "format_list_numbered_rtl",
                  "format_overline",
                  "format_paint",
                  "format_quote",
                  "format_shapes",
                  "format_size",
                  "format_strikethrough",
                  "format_textdirection_l_to_r",
                  "format_textdirection_r_to_l",
                  "format_underlined",
                  "fort",
                  "forum",
                  "forward",
                  "forward_10",
                  "forward_30",
                  "forward_5",
                  "forward_to_inbox",
                  "foundation",
                  "free_breakfast",
                  "free_cancellation",
                  "front_hand",
                  "fullscreen",
                  "fullscreen_exit",
                  "functions",
                  "g_mobiledata",
                  "g_translate",
                  "gamepad",
                  "games",
                  "garage",
                  "gas_meter",
                  "gavel",
                  "generating_tokens",
                  "gesture",
                  "get_app",
                  "gif",
                  "gif_box",
                  "girl",
                  "gite",
                  "golf_course",
                  "gpp_bad",
                  "gpp_good",
                  "gpp_maybe",
                  "gps_fixed",
                  "gps_not_fixed",
                  "gps_off",
                  "grade",
                  "gradient",
                  "grading",
                  "grain",
                  "graphic_eq",
                  "grass",
                  "grid_3x3",
                  "grid_4x4",
                  "grid_goldenratio",
                  "grid_off",
                  "grid_on",
                  "grid_view",
                  "group",
                  "group_add",
                  "group_off",
                  "group_remove",
                  "group_work",
                  "groups",
                  "groups_2",
                  "groups_3",
                  "h_mobiledata",
                  "h_plus_mobiledata",
                  "hail",
                  "handshake",
                  "handyman",
                  "hardware",
                  "hd",
                  "hdr_auto",
                  "hdr_auto_select",
                  "hdr_enhanced_select",
                  "hdr_off",
                  "hdr_off_select",
                  "hdr_on",
                  "hdr_on_select",
                  "hdr_plus",
                  "hdr_strong",
                  "hdr_weak",
                  "headphones",
                  "headphones_battery",
                  "headset",
                  "headset_mic",
                  "headset_off",
                  "healing",
                  "health_and_safety",
                  "hearing",
                  "hearing_disabled",
                  "heart_broken",
                  "heat_pump",
                  "height",
                  "help",
                  "help_center",
                  "help_outline",
                  "hevc",
                  "hexagon",
                  "hide_image",
                  "hide_source",
                  "high_quality",
                  "highlight",
                  "highlight_alt",
                  "highlight_off",
                  "hiking",
                  "history",
                  "history_edu",
                  "history_toggle_off",
                  "hive",
                  "hls",
                  "hls_off",
                  "holiday_village",
                  "home",
                  "home_max",
                  "home_mini",
                  "home_repair_service",
                  "home_work",
                  "horizontal_distribute",
                  "horizontal_rule",
                  "horizontal_split",
                  "hot_tub",
                  "hotel",
                  "hotel_class",
                  "hourglass_bottom",
                  "hourglass_disabled",
                  "hourglass_empty",
                  "hourglass_full",
                  "hourglass_top",
                  "house",
                  "house_siding",
                  "houseboat",
                  "how_to_reg",
                  "how_to_vote",
                  "html",
                  "http",
                  "https",
                  "hub",
                  "hvac",
                  "ice_skating",
                  "icecream",
                  "image",
                  "image_aspect_ratio",
                  "image_not_supported",
                  "image_search",
                  "imagesearch_roller",
                  "import_contacts",
                  "import_export",
                  "important_devices",
                  "inbox",
                  "incomplete_circle",
                  "indeterminate_check_box",
                  "info",
                  "input",
                  "insert_chart",
                  "insert_chart_outlined",
                  "insert_comment",
                  "insert_drive_file",
                  "insert_emoticon",
                  "insert_invitation",
                  "insert_link",
                  "insert_page_break",
                  "insert_photo",
                  "insights",
                  "install_desktop",
                  "install_mobile",
                  "integration_instructions",
                  "interests",
                  "interpreter_mode",
                  "inventory",
                  "inventory_2",
                  "invert_colors",
                  "invert_colors_off",
                  "ios_share",
                  "iron",
                  "iso",
                  "javascript",
                  "join_full",
                  "join_inner",
                  "join_left",
                  "join_right",
                  "kayaking",
                  "kebab_dining",
                  "key",
                  "key_off",
                  "keyboard",
                  "keyboard_alt",
                  "keyboard_arrow_down",
                  "keyboard_arrow_left",
                  "keyboard_arrow_right",
                  "keyboard_arrow_up",
                  "keyboard_backspace",
                  "keyboard_capslock",
                  "keyboard_command_key",
                  "keyboard_control_key",
                  "keyboard_double_arrow_down",
                  "keyboard_double_arrow_left",
                  "keyboard_double_arrow_right",
                  "keyboard_double_arrow_up",
                  "keyboard_hide",
                  "keyboard_option_key",
                  "keyboard_return",
                  "keyboard_tab",
                  "keyboard_voice",
                  "king_bed",
                  "kitchen",
                  "kitesurfing",
                  "label",
                  "label_important",
                  "label_off",
                  "lan",
                  "landscape",
                  "landslide",
                  "language",
                  "laptop",
                  "laptop_chromebook",
                  "laptop_mac",
                  "laptop_windows",
                  "last_page",
                  "launch",
                  "layers",
                  "layers_clear",
                  "leaderboard",
                  "leak_add",
                  "leak_remove",
                  "legend_toggle",
                  "lens",
                  "lens_blur",
                  "library_add",
                  "library_add_check",
                  "library_books",
                  "library_music",
                  "light",
                  "light_mode",
                  "lightbulb",
                  "lightbulb_circle",
                  "line_axis",
                  "line_style",
                  "line_weight",
                  "linear_scale",
                  "link",
                  "link_off",
                  "linked_camera",
                  "liquor",
                  "list",
                  "list_alt",
                  "live_help",
                  "live_tv",
                  "living",
                  "local_activity",
                  "local_airport",
                  "local_atm",
                  "local_bar",
                  "local_cafe",
                  "local_car_wash",
                  "local_convenience_store",
                  "local_dining",
                  "local_drink",
                  "local_fire_department",
                  "local_florist",
                  "local_gas_station",
                  "local_grocery_store",
                  "local_hospital",
                  "local_hotel",
                  "local_laundry_service",
                  "local_library",
                  "local_mall",
                  "local_movies",
                  "local_offer",
                  "local_parking",
                  "local_pharmacy",
                  "local_phone",
                  "local_pizza",
                  "local_play",
                  "local_police",
                  "local_post_office",
                  "local_printshop",
                  "local_see",
                  "local_shipping",
                  "local_taxi",
                  "location_city",
                  "location_disabled",
                  "location_off",
                  "location_on",
                  "location_searching",
                  "lock",
                  "lock_clock",
                  "lock_open",
                  "lock_person",
                  "lock_reset",
                  "login",
                  "logo_dev",
                  "logout",
                  "looks",
                  "looks_3",
                  "looks_4",
                  "looks_5",
                  "looks_6",
                  "looks_one",
                  "looks_two",
                  "loop",
                  "loupe",
                  "low_priority",
                  "loyalty",
                  "lte_mobiledata",
                  "lte_plus_mobiledata",
                  "luggage",
                  "lunch_dining",
                  "lyrics",
                  "macro_off",
                  "mail",
                  "mail_lock",
                  "mail_outline",
                  "male",
                  "man",
                  "man_2",
                  "man_3",
                  "man_4",
                  "manage_accounts",
                  "manage_history",
                  "manage_search",
                  "map",
                  "maps_home_work",
                  "maps_ugc",
                  "margin",
                  "mark_as_unread",
                  "mark_chat_read",
                  "mark_chat_unread",
                  "mark_email_read",
                  "mark_email_unread",
                  "mark_unread_chat_alt",
                  "markunread",
                  "markunread_mailbox",
                  "masks",
                  "maximize",
                  "media_bluetooth_off",
                  "media_bluetooth_on",
                  "mediation",
                  "medical_information",
                  "medical_services",
                  "medication",
                  "medication_liquid",
                  "meeting_room",
                  "memory",
                  "menu",
                  "menu_book",
                  "menu_open",
                  "merge",
                  "merge_type",
                  "message",
                  "mic",
                  "mic_external_off",
                  "mic_external_on",
                  "mic_none",
                  "mic_off",
                  "microwave",
                  "military_tech",
                  "minimize",
                  "minor_crash",
                  "miscellaneous_services",
                  "missed_video_call",
                  "mms",
                  "mobile_friendly",
                  "mobile_off",
                  "mobile_screen_share",
                  "mobiledata_off",
                  "mode",
                  "mode_comment",
                  "mode_edit",
                  "mode_edit_outline",
                  "mode_fan_off",
                  "mode_night",
                  "mode_of_travel",
                  "mode_standby",
                  "model_training",
                  "monetization_on",
                  "money",
                  "money_off",
                  "money_off_csred",
                  "monitor",
                  "monitor_heart",
                  "monitor_weight",
                  "monochrome_photos",
                  "mood",
                  "mood_bad",
                  "moped",
                  "more",
                  "more_horiz",
                  "more_time",
                  "more_vert",
                  "mosque",
                  "motion_photos_auto",
                  "motion_photos_off",
                  "motion_photos_on",
                  "motion_photos_pause",
                  "motion_photos_paused",
                  "mouse",
                  "move_down",
                  "move_to_inbox",
                  "move_up",
                  "movie",
                  "movie_creation",
                  "movie_filter",
                  "moving",
                  "mp",
                  "multiline_chart",
                  "multiple_stop",
                  "museum",
                  "music_note",
                  "music_off",
                  "music_video",
                  "my_location",
                  "nat",
                  "nature",
                  "nature_people",
                  "navigate_before",
                  "navigate_next",
                  "navigation",
                  "near_me",
                  "near_me_disabled",
                  "nearby_error",
                  "nearby_off",
                  "nest_cam_wired_stand",
                  "network_cell",
                  "network_check",
                  "network_locked",
                  "network_ping",
                  "network_wifi",
                  "network_wifi_1_bar",
                  "network_wifi_2_bar",
                  "network_wifi_3_bar",
                  "new_label",
                  "new_releases",
                  "newspaper",
                  "next_plan",
                  "next_week",
                  "nfc",
                  "night_shelter",
                  "nightlife",
                  "nightlight",
                  "nightlight_round",
                  "nights_stay",
                  "no_accounts",
                  "no_adult_content",
                  "no_backpack",
                  "no_cell",
                  "no_crash",
                  "no_drinks",
                  "no_encryption",
                  "no_encryption_gmailerrorred",
                  "no_flash",
                  "no_food",
                  "no_luggage",
                  "no_meals",
                  "no_meeting_room",
                  "no_photography",
                  "no_sim",
                  "no_stroller",
                  "no_transfer",
                  "noise_aware",
                  "noise_control_off",
                  "nordic_walking",
                  "north",
                  "north_east",
                  "north_west",
                  "not_accessible",
                  "not_interested",
                  "not_listed_location",
                  "not_started",
                  "note",
                  "note_add",
                  "note_alt",
                  "notes",
                  "notification_add",
                  "notification_important",
                  "notifications",
                  "notifications_active",
                  "notifications_none",
                  "notifications_off",
                  "notifications_paused",
                  "numbers",
                  "offline_bolt",
                  "offline_pin",
                  "offline_share",
                  "oil_barrel",
                  "on_device_training",
                  "ondemand_video",
                  "online_prediction",
                  "opacity",
                  "open_in_browser",
                  "open_in_full",
                  "open_in_new",
                  "open_in_new_off",
                  "open_with",
                  "other_houses",
                  "outbound",
                  "outbox",
                  "outdoor_grill",
                  "outlet",
                  "outlined_flag",
                  "output",
                  "padding",
                  "pages",
                  "pageview",
                  "paid",
                  "palette",
                  "pan_tool",
                  "pan_tool_alt",
                  "panorama",
                  "panorama_fish_eye",
                  "panorama_horizontal",
                  "panorama_horizontal_select",
                  "panorama_photosphere",
                  "panorama_photosphere_select",
                  "panorama_vertical",
                  "panorama_vertical_select",
                  "panorama_wide_angle",
                  "panorama_wide_angle_select",
                  "paragliding",
                  "park",
                  "party_mode",
                  "password",
                  "pattern",
                  "pause",
                  "pause_circle",
                  "pause_circle_filled",
                  "pause_circle_outline",
                  "pause_presentation",
                  "payment",
                  "payments",
                  "pedal_bike",
                  "pending",
                  "pending_actions",
                  "pentagon",
                  "people",
                  "people_alt",
                  "people_outline",
                  "percent",
                  "perm_camera_mic",
                  "perm_contact_calendar",
                  "perm_data_setting",
                  "perm_device_information",
                  "perm_identity",
                  "perm_media",
                  "perm_phone_msg",
                  "perm_scan_wifi",
                  "person",
                  "person_2",
                  "person_3",
                  "person_4",
                  "person_add",
                  "person_add_alt",
                  "person_add_alt_1",
                  "person_add_disabled",
                  "person_off",
                  "person_outline",
                  "person_pin",
                  "person_pin_circle",
                  "person_remove",
                  "person_remove_alt_1",
                  "person_search",
                  "personal_injury",
                  "personal_video",
                  "pest_control",
                  "pest_control_rodent",
                  "pets",
                  "phishing",
                  "phone",
                  "phone_android",
                  "phone_bluetooth_speaker",
                  "phone_callback",
                  "phone_disabled",
                  "phone_enabled",
                  "phone_forwarded",
                  "phone_in_talk",
                  "phone_iphone",
                  "phone_locked",
                  "phone_missed",
                  "phone_paused",
                  "phonelink",
                  "phonelink_erase",
                  "phonelink_lock",
                  "phonelink_off",
                  "phonelink_ring",
                  "phonelink_setup",
                  "photo",
                  "photo_album",
                  "photo_camera",
                  "photo_camera_back",
                  "photo_camera_front",
                  "photo_filter",
                  "photo_library",
                  "photo_size_select_actual",
                  "photo_size_select_large",
                  "photo_size_select_small",
                  "php",
                  "piano",
                  "piano_off",
                  "picture_as_pdf",
                  "picture_in_picture",
                  "picture_in_picture_alt",
                  "pie_chart",
                  "pie_chart_outline",
                  "pin",
                  "pin_drop",
                  "pin_end",
                  "pin_invoke",
                  "pinch",
                  "pivot_table_chart",
                  "pix",
                  "place",
                  "plagiarism",
                  "play_arrow",
                  "play_circle",
                  "play_circle_filled",
                  "play_circle_outline",
                  "play_disabled",
                  "play_for_work",
                  "play_lesson",
                  "playlist_add",
                  "playlist_add_check",
                  "playlist_add_check_circle",
                  "playlist_add_circle",
                  "playlist_play",
                  "playlist_remove",
                  "plumbing",
                  "plus_one",
                  "podcasts",
                  "point_of_sale",
                  "policy",
                  "poll",
                  "polyline",
                  "polymer",
                  "pool",
                  "portable_wifi_off",
                  "portrait",
                  "post_add",
                  "power",
                  "power_input",
                  "power_off",
                  "power_settings_new",
                  "precision_manufacturing",
                  "pregnant_woman",
                  "present_to_all",
                  "preview",
                  "price_change",
                  "price_check",
                  "print",
                  "print_disabled",
                  "priority_high",
                  "privacy_tip",
                  "private_connectivity",
                  "production_quantity_limits",
                  "propane",
                  "propane_tank",
                  "psychology",
                  "psychology_alt",
                  "public",
                  "public_off",
                  "publish",
                  "published_with_changes",
                  "punch_clock",
                  "push_pin",
                  "qr_code",
                  "qr_code_2",
                  "qr_code_scanner",
                  "query_builder",
                  "query_stats",
                  "question_answer",
                  "question_mark",
                  "queue",
                  "queue_music",
                  "queue_play_next",
                  "quickreply",
                  "quiz",
                  "r_mobiledata",
                  "radar",
                  "radio",
                  "radio_button_checked",
                  "radio_button_unchecked",
                  "railway_alert",
                  "ramen_dining",
                  "ramp_left",
                  "ramp_right",
                  "rate_review",
                  "raw_off",
                  "raw_on",
                  "read_more",
                  "real_estate_agent",
                  "receipt",
                  "receipt_long",
                  "recent_actors",
                  "recommend",
                  "record_voice_over",
                  "rectangle",
                  "recycling",
                  "redeem",
                  "redo",
                  "reduce_capacity",
                  "refresh",
                  "remember_me",
                  "remove",
                  "remove_circle",
                  "remove_circle_outline",
                  "remove_done",
                  "remove_from_queue",
                  "remove_moderator",
                  "remove_red_eye",
                  "remove_road",
                  "remove_shopping_cart",
                  "reorder",
                  "repartition",
                  "repeat",
                  "repeat_on",
                  "repeat_one",
                  "repeat_one_on",
                  "replay",
                  "replay_10",
                  "replay_30",
                  "replay_5",
                  "replay_circle_filled",
                  "reply",
                  "reply_all",
                  "report",
                  "report_gmailerrorred",
                  "report_off",
                  "report_problem",
                  "request_page",
                  "request_quote",
                  "reset_tv",
                  "restart_alt",
                  "restaurant",
                  "restaurant_menu",
                  "restore",
                  "restore_from_trash",
                  "restore_page",
                  "reviews",
                  "rice_bowl",
                  "ring_volume",
                  "rocket",
                  "rocket_launch",
                  "roller_shades",
                  "roller_shades_closed",
                  "roller_skating",
                  "roofing",
                  "room",
                  "room_preferences",
                  "room_service",
                  "rotate_90_degrees_ccw",
                  "rotate_90_degrees_cw",
                  "rotate_left",
                  "rotate_right",
                  "roundabout_left",
                  "roundabout_right",
                  "rounded_corner",
                  "route",
                  "router",
                  "rowing",
                  "rss_feed",
                  "rsvp",
                  "rtt",
                  "rule",
                  "rule_folder",
                  "run_circle",
                  "running_with_errors",
                  "rv_hookup",
                  "safety_check",
                  "safety_divider",
                  "sailing",
                  "sanitizer",
                  "satellite",
                  "satellite_alt",
                  "save",
                  "save_alt",
                  "save_as",
                  "saved_search",
                  "savings",
                  "scale",
                  "scanner",
                  "scatter_plot",
                  "schedule",
                  "schedule_send",
                  "schema",
                  "school",
                  "science",
                  "score",
                  "scoreboard",
                  "screen_lock_landscape",
                  "screen_lock_portrait",
                  "screen_lock_rotation",
                  "screen_rotation",
                  "screen_rotation_alt",
                  "screen_search_desktop",
                  "screen_share",
                  "screenshot",
                  "screenshot_monitor",
                  "scuba_diving",
                  "sd",
                  "sd_card",
                  "sd_card_alert",
                  "sd_storage",
                  "search",
                  "search_off",
                  "security",
                  "security_update",
                  "security_update_good",
                  "security_update_warning",
                  "segment",
                  "select_all",
                  "self_improvement",
                  "sell",
                  "send",
                  "send_and_archive",
                  "send_time_extension",
                  "send_to_mobile",
                  "sensor_door",
                  "sensor_occupied",
                  "sensor_window",
                  "sensors",
                  "sensors_off",
                  "sentiment_dissatisfied",
                  "sentiment_neutral",
                  "sentiment_satisfied",
                  "sentiment_satisfied_alt",
                  "sentiment_very_dissatisfied",
                  "sentiment_very_satisfied",
                  "set_meal",
                  "settings",
                  "settings_accessibility",
                  "settings_applications",
                  "settings_backup_restore",
                  "settings_bluetooth",
                  "settings_brightness",
                  "settings_cell",
                  "settings_ethernet",
                  "settings_input_antenna",
                  "settings_input_component",
                  "settings_input_composite",
                  "settings_input_hdmi",
                  "settings_input_svideo",
                  "settings_overscan",
                  "settings_phone",
                  "settings_power",
                  "settings_remote",
                  "settings_suggest",
                  "settings_system_daydream",
                  "settings_voice",
                  "severe_cold",
                  "shape_line",
                  "share",
                  "share_location",
                  "shield",
                  "shield_moon",
                  "shop",
                  "shop_2",
                  "shop_two",
                  "shopping_bag",
                  "shopping_basket",
                  "shopping_cart",
                  "shopping_cart_checkout",
                  "short_text",
                  "shortcut",
                  "show_chart",
                  "shower",
                  "shuffle",
                  "shuffle_on",
                  "shutter_speed",
                  "sick",
                  "sign_language",
                  "signal_cellular_0_bar",
                  "signal_cellular_4_bar",
                  "signal_cellular_alt",
                  "signal_cellular_alt_1_bar",
                  "signal_cellular_alt_2_bar",
                  "signal_cellular_connected_no_internet_0_bar",
                  "signal_cellular_connected_no_internet_4_bar",
                  "signal_cellular_no_sim",
                  "signal_cellular_nodata",
                  "signal_cellular_null",
                  "signal_cellular_off",
                  "signal_wifi_0_bar",
                  "signal_wifi_4_bar",
                  "signal_wifi_4_bar_lock",
                  "signal_wifi_bad",
                  "signal_wifi_connected_no_internet_4",
                  "signal_wifi_off",
                  "signal_wifi_statusbar_4_bar",
                  "signal_wifi_statusbar_connected_no_internet_4",
                  "signal_wifi_statusbar_null",
                  "signpost",
                  "sim_card",
                  "sim_card_alert",
                  "sim_card_download",
                  "single_bed",
                  "sip",
                  "skateboarding",
                  "skip_next",
                  "skip_previous",
                  "sledding",
                  "slideshow",
                  "slow_motion_video",
                  "smart_button",
                  "smart_display",
                  "smart_screen",
                  "smart_toy",
                  "smartphone",
                  "smoke_free",
                  "smoking_rooms",
                  "sms",
                  "sms_failed",
                  "snippet_folder",
                  "snooze",
                  "snowboarding",
                  "snowmobile",
                  "snowshoeing",
                  "soap",
                  "social_distance",
                  "solar_power",
                  "sort",
                  "sort_by_alpha",
                  "sos",
                  "soup_kitchen",
                  "source",
                  "south",
                  "south_america",
                  "south_east",
                  "south_west",
                  "spa",
                  "space_bar",
                  "space_dashboard",
                  "spatial_audio",
                  "spatial_audio_off",
                  "spatial_tracking",
                  "speaker",
                  "speaker_group",
                  "speaker_notes",
                  "speaker_notes_off",
                  "speaker_phone",
                  "speed",
                  "spellcheck",
                  "splitscreen",
                  "spoke",
                  "sports",
                  "sports_bar",
                  "sports_baseball",
                  "sports_basketball",
                  "sports_cricket",
                  "sports_esports",
                  "sports_football",
                  "sports_golf",
                  "sports_gymnastics",
                  "sports_handball",
                  "sports_hockey",
                  "sports_kabaddi",
                  "sports_martial_arts",
                  "sports_mma",
                  "sports_motorsports",
                  "sports_rugby",
                  "sports_score",
                  "sports_soccer",
                  "sports_tennis",
                  "sports_volleyball",
                  "square",
                  "square_foot",
                  "ssid_chart",
                  "stacked_bar_chart",
                  "stacked_line_chart",
                  "stadium",
                  "stairs",
                  "star",
                  "star_border",
                  "star_border_purple500",
                  "star_half",
                  "star_outline",
                  "star_purple500",
                  "star_rate",
                  "stars",
                  "start",
                  "stay_current_landscape",
                  "stay_current_portrait",
                  "stay_primary_landscape",
                  "stay_primary_portrait",
                  "sticky_note_2",
                  "stop",
                  "stop_circle",
                  "stop_screen_share",
                  "storage",
                  "store",
                  "store_mall_directory",
                  "storefront",
                  "storm",
                  "straight",
                  "straighten",
                  "stream",
                  "streetview",
                  "strikethrough_s",
                  "stroller",
                  "style",
                  "subdirectory_arrow_left",
                  "subdirectory_arrow_right",
                  "subject",
                  "subscript",
                  "subscriptions",
                  "subtitles",
                  "subtitles_off",
                  "subway",
                  "summarize",
                  "superscript",
                  "supervised_user_circle",
                  "supervisor_account",
                  "support",
                  "support_agent",
                  "surfing",
                  "surround_sound",
                  "swap_calls",
                  "swap_horiz",
                  "swap_horizontal_circle",
                  "swap_vert",
                  "swap_vertical_circle",
                  "swipe",
                  "swipe_down",
                  "swipe_down_alt",
                  "swipe_left",
                  "swipe_left_alt",
                  "swipe_right",
                  "swipe_right_alt",
                  "swipe_up",
                  "swipe_up_alt",
                  "swipe_vertical",
                  "switch_access_shortcut",
                  "switch_access_shortcut_add",
                  "switch_account",
                  "switch_camera",
                  "switch_left",
                  "switch_right",
                  "switch_video",
                  "synagogue",
                  "sync",
                  "sync_alt",
                  "sync_disabled",
                  "sync_lock",
                  "sync_problem",
                  "system_security_update",
                  "system_security_update_good",
                  "system_security_update_warning",
                  "system_update",
                  "system_update_alt",
                  "tab",
                  "tab_unselected",
                  "table_bar",
                  "table_chart",
                  "table_restaurant",
                  "table_rows",
                  "table_view",
                  "tablet",
                  "tablet_android",
                  "tablet_mac",
                  "tag",
                  "tag_faces",
                  "takeout_dining",
                  "tap_and_play",
                  "tapas",
                  "task",
                  "task_alt",
                  "taxi_alert",
                  "temple_buddhist",
                  "temple_hindu",
                  "terminal",
                  "terrain",
                  "text_decrease",
                  "text_fields",
                  "text_format",
                  "text_increase",
                  "text_rotate_up",
                  "text_rotate_vertical",
                  "text_rotation_angledown",
                  "text_rotation_angleup",
                  "text_rotation_down",
                  "text_rotation_none",
                  "text_snippet",
                  "textsms",
                  "texture",
                  "theater_comedy",
                  "theaters",
                  "thermostat",
                  "thermostat_auto",
                  "thumb_down",
                  "thumb_down_alt",
                  "thumb_down_off_alt",
                  "thumb_up",
                  "thumb_up_alt",
                  "thumb_up_off_alt",
                  "thumbs_up_down",
                  "thunderstorm",
                  "time_to_leave",
                  "timelapse",
                  "timeline",
                  "timer",
                  "timer_10",
                  "timer_10_select",
                  "timer_3",
                  "timer_3_select",
                  "timer_off",
                  "tips_and_updates",
                  "tire_repair",
                  "title",
                  "toc",
                  "today",
                  "toggle_off",
                  "toggle_on",
                  "token",
                  "toll",
                  "tonality",
                  "topic",
                  "tornado",
                  "touch_app",
                  "tour",
                  "toys",
                  "track_changes",
                  "traffic",
                  "train",
                  "tram",
                  "transcribe",
                  "transfer_within_a_station",
                  "transform",
                  "transgender",
                  "transit_enterexit",
                  "translate",
                  "travel_explore",
                  "trending_down",
                  "trending_flat",
                  "trending_up",
                  "trip_origin",
                  "troubleshoot",
                  "try",
                  "tsunami",
                  "tty",
                  "tune",
                  "tungsten",
                  "turn_left",
                  "turn_right",
                  "turn_sharp_left",
                  "turn_sharp_right",
                  "turn_slight_left",
                  "turn_slight_right",
                  "turned_in",
                  "turned_in_not",
                  "tv",
                  "tv_off",
                  "two_wheeler",
                  "type_specimen",
                  "u_turn_left",
                  "u_turn_right",
                  "umbrella",
                  "unarchive",
                  "undo",
                  "unfold_less",
                  "unfold_less_double",
                  "unfold_more",
                  "unfold_more_double",
                  "unpublished",
                  "unsubscribe",
                  "upcoming",
                  "update",
                  "update_disabled",
                  "upgrade",
                  "upload",
                  "upload_file",
                  "usb",
                  "usb_off",
                  "vaccines",
                  "vape_free",
                  "vaping_rooms",
                  "verified",
                  "verified_user",
                  "vertical_align_bottom",
                  "vertical_align_center",
                  "vertical_align_top",
                  "vertical_distribute",
                  "vertical_shades",
                  "vertical_shades_closed",
                  "vertical_split",
                  "vibration",
                  "video_call",
                  "video_camera_back",
                  "video_camera_front",
                  "video_chat",
                  "video_file",
                  "video_label",
                  "video_library",
                  "video_settings",
                  "video_stable",
                  "videocam",
                  "videocam_off",
                  "videogame_asset",
                  "videogame_asset_off",
                  "view_agenda",
                  "view_array",
                  "view_carousel",
                  "view_column",
                  "view_comfy",
                  "view_comfy_alt",
                  "view_compact",
                  "view_compact_alt",
                  "view_cozy",
                  "view_day",
                  "view_headline",
                  "view_in_ar",
                  "view_kanban",
                  "view_list",
                  "view_module",
                  "view_quilt",
                  "view_sidebar",
                  "view_stream",
                  "view_timeline",
                  "view_week",
                  "vignette",
                  "villa",
                  "visibility",
                  "visibility_off",
                  "voice_chat",
                  "voice_over_off",
                  "voicemail",
                  "volcano",
                  "volume_down",
                  "volume_mute",
                  "volume_off",
                  "volume_up",
                  "volunteer_activism",
                  "vpn_key",
                  "vpn_key_off",
                  "vpn_lock",
                  "vrpano",
                  "wallet",
                  "wallpaper",
                  "warehouse",
                  "warning",
                  "warning_amber",
                  "wash",
                  "watch",
                  "watch_later",
                  "watch_off",
                  "water",
                  "water_damage",
                  "water_drop",
                  "waterfall_chart",
                  "waves",
                  "waving_hand",
                  "wb_auto",
                  "wb_cloudy",
                  "wb_incandescent",
                  "wb_iridescent",
                  "wb_shade",
                  "wb_sunny",
                  "wb_twilight",
                  "wc",
                  "web",
                  "web_asset",
                  "web_asset_off",
                  "web_stories",
                  "webhook",
                  "weekend",
                  "west",
                  "whatshot",
                  "wheelchair_pickup",
                  "where_to_vote",
                  "widgets",
                  "width_full",
                  "width_normal",
                  "width_wide",
                  "wifi",
                  "wifi_1_bar",
                  "wifi_2_bar",
                  "wifi_calling",
                  "wifi_calling_3",
                  "wifi_channel",
                  "wifi_find",
                  "wifi_lock",
                  "wifi_off",
                  "wifi_password",
                  "wifi_protected_setup",
                  "wifi_tethering",
                  "wifi_tethering_error",
                  "wifi_tethering_off",
                  "wind_power",
                  "window",
                  "wine_bar",
                  "woman",
                  "woman_2",
                  "work",
                  "work_history",
                  "work_off",
                  "work_outline",
                  "workspace_premium",
                  "workspaces",
                  "wrap_text",
                  "wrong_location",
                  "wysiwyg",
                  "yard",
                  "youtube_searched_for",
                  "zoom_in",
                  "zoom_in_map",
                  "zoom_out",
                  "zoom_out_map"
                ]
            ],
      "_js2n__-:definitions/ImageEditable!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowed_sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  expandable = _js2n__-prdslib.isType '"Bool",
                  height = _js2n__-prdslib.isType '"Number",
                  image_size_attributes = _js2n__-prdslib.isType '"Bool",
                  mime_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "image/jpeg", "image/png", "image/webp" ]
                        ],
                  paths =
                    _js2n__-refsenv."_js2n__-:definitions/Paths!predicate",
                  prevent_resize_existing_files =
                    _js2n__-prdslib.isType '"Bool",
                  resize_style =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "cover", "contain", "stretch", "crop" ]
                        ],
                  sizes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "size" ],
                                _js2n__-prdslib.records.record
                                  {
                                    size = _js2n__-prdslib.isType '"String",
                                    target = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  width = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ImageInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ImageInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "image"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ImageInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accepts_mime_types =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MimeType!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  allowed_sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "string" ]
                        ],
                  expandable = _js2n__-prdslib.isType '"Bool",
                  height = _js2n__-prdslib.isType '"Number",
                  image_size_attributes = _js2n__-prdslib.isType '"Bool",
                  mime_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "image/jpeg", "image/png", "image/webp" ]
                        ],
                  paths =
                    _js2n__-refsenv."_js2n__-:definitions/Paths!predicate",
                  prevent_resize_existing_files =
                    _js2n__-prdslib.isType '"Bool",
                  resize_style =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "cover", "contain", "stretch", "crop" ]
                        ],
                  sizes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "size" ],
                                _js2n__-prdslib.records.record
                                  {
                                    size = _js2n__-prdslib.isType '"String",
                                    target = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  width = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Input!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/BaseInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/UnknownInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/TextInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/CodeInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ColorInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/BooleanInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/NumberInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RangeInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/UrlInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RichTextInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DateInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/TimeInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/FileInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ImageInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/SelectInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/MultiselectInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ChoiceInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/MultichoiceInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ObjectInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ArrayInput!predicate"
            ],
      "_js2n__-:definitions/InputType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "text",
                  "textarea",
                  "email",
                  "disabled",
                  "pinterest",
                  "facebook",
                  "twitter",
                  "github",
                  "instagram",
                  "code",
                  "checkbox",
                  "switch",
                  "color",
                  "number",
                  "range",
                  "url",
                  "html",
                  "markdown",
                  "date",
                  "datetime",
                  "time",
                  "file",
                  "image",
                  "document",
                  "select",
                  "multiselect",
                  "choice",
                  "multichoice",
                  "object",
                  "array",
                  "auto"
                ]
            ],
      "_js2n__-:definitions/InstanceValue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "UUID", "NOW" ]
            ],
      "_js2n__-:definitions/LinkEditable!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/WithPaths!predicate",
      "_js2n__-:definitions/MarkdownAttributeElementOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  block =
                    _js2n__-refsenv."_js2n__-:definitions/AttributeListPosition!predicate",
                  inline =
                    _js2n__-refsenv."_js2n__-:definitions/AttributeListPosition!predicate",
                } {} true
                _js2n__-refsenv."_js2n__-:definitions/AttributeListPosition!predicate"
            ],
      "_js2n__-:definitions/MarkdownSettings!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "engine", "options" ],
              _js2n__-prdslib.records.record
                {
                  engine =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "commonmark", "kramdown" ]
                        ],
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              attribute_elements =
                                _js2n__-refsenv."_js2n__-:definitions/MarkdownAttributeElementOptions!predicate",
                              attributes = _js2n__-prdslib.isType '"Bool",
                              breaks = _js2n__-prdslib.isType '"Bool",
                              code_block_fences =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "```", "~~~" ]
                                    ],
                              escape_snippets_in_code_blocks =
                                _js2n__-prdslib.isType '"Bool",
                              gfm = _js2n__-prdslib.isType '"Bool",
                              heading_ids = _js2n__-prdslib.isType '"Bool",
                              html = _js2n__-prdslib.isType '"Bool",
                              linkify = _js2n__-prdslib.isType '"Bool",
                              quotes = _js2n__-prdslib.isType '"String",
                              sentence_per_line =
                                _js2n__-prdslib.isType '"Bool",
                              spaced_lists = _js2n__-prdslib.isType '"Bool",
                              strikethrough = _js2n__-prdslib.isType '"Bool",
                              subscript = _js2n__-prdslib.isType '"Bool",
                              superscript = _js2n__-prdslib.isType '"Bool",
                              table = _js2n__-prdslib.isType '"Bool",
                              treat_indentation_as_code =
                                _js2n__-prdslib.isType '"Bool",
                              typographer = _js2n__-prdslib.isType '"Bool",
                              xhtml = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MimeType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "x-world/x-3dmf",
                  "application/x-authorware-bin",
                  "application/x-authorware-map",
                  "application/x-authorware-seg",
                  "text/vnd.abc",
                  "video/animaflex",
                  "application/postscript",
                  "audio/aiff",
                  "audio/x-aiff",
                  "application/x-aim",
                  "text/x-audiosoft-intra",
                  "application/x-navi-animation",
                  "application/x-nokia-9000-communicator-add-on-software",
                  "application/mime",
                  "application/arj",
                  "image/x-jg",
                  "video/x-ms-asf",
                  "text/x-asm",
                  "text/asp",
                  "application/x-mplayer2",
                  "video/x-ms-asf-plugin",
                  "audio/basic",
                  "audio/x-au",
                  "application/x-troff-msvideo",
                  "video/avi",
                  "video/msvideo",
                  "video/x-msvideo",
                  "video/avs-video",
                  "application/x-bcpio",
                  "application/mac-binary",
                  "application/macbinary",
                  "application/x-binary",
                  "application/x-macbinary",
                  "image/bmp",
                  "image/x-windows-bmp",
                  "application/book",
                  "application/x-bsh",
                  "application/x-bzip",
                  "application/x-bzip2",
                  "text/plain",
                  "text/x-c",
                  "application/vnd.ms-pki.seccat",
                  "application/clariscad",
                  "application/x-cocoa",
                  "application/cdf",
                  "application/x-cdf",
                  "application/x-netcdf",
                  "application/pkix-cert",
                  "application/x-x509-ca-cert",
                  "application/x-chat",
                  "application/java",
                  "application/java-byte-code",
                  "application/x-java-class",
                  "application/x-cpio",
                  "application/mac-compactpro",
                  "application/x-compactpro",
                  "application/x-cpt",
                  "application/pkcs-crl",
                  "application/pkix-crl",
                  "application/x-x509-user-cert",
                  "application/x-csh",
                  "text/x-script.csh",
                  "application/x-pointplus",
                  "text/css",
                  "text/csv",
                  "application/x-director",
                  "application/x-deepv",
                  "video/x-dv",
                  "video/dl",
                  "video/x-dl",
                  "application/msword",
                  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                  "application/commonground",
                  "application/drafting",
                  "application/x-dvi",
                  "drawing/x-dwf (old)",
                  "model/vnd.dwf",
                  "application/acad",
                  "image/vnd.dwg",
                  "image/x-dwg",
                  "application/dxf",
                  "text/x-script.elisp",
                  "application/x-bytecode.elisp (compiled elisp)",
                  "application/x-elc",
                  "application/x-envoy",
                  "application/x-esrehber",
                  "text/x-setext",
                  "application/envoy",
                  "text/x-fortran",
                  "application/vnd.fdf",
                  "application/fractals",
                  "image/fif",
                  "video/fli",
                  "video/x-fli",
                  "image/florian",
                  "text/vnd.fmi.flexstor",
                  "video/x-atomic3d-feature",
                  "image/vnd.fpx",
                  "image/vnd.net-fpx",
                  "application/freeloader",
                  "audio/make",
                  "image/g3fax",
                  "image/gif",
                  "video/gl",
                  "video/x-gl",
                  "audio/x-gsm",
                  "application/x-gsp",
                  "application/x-gss",
                  "application/x-gtar",
                  "application/x-compressed",
                  "application/x-gzip",
                  "multipart/x-gzip",
                  "text/x-h",
                  "application/x-hdf",
                  "application/x-helpfile",
                  "application/vnd.hp-hpgl",
                  "text/x-script",
                  "application/hlp",
                  "application/x-winhelp",
                  "application/binhex",
                  "application/binhex4",
                  "application/mac-binhex",
                  "application/mac-binhex40",
                  "application/x-binhex40",
                  "application/x-mac-binhex40",
                  "application/hta",
                  "text/x-component",
                  "text/html",
                  "text/webviewhtml",
                  "x-conference/x-cooltalk",
                  "image/x-icon",
                  "image/ief",
                  "application/iges",
                  "model/iges",
                  "application/x-ima",
                  "application/x-httpd-imap",
                  "application/inf",
                  "application/x-internett-signup",
                  "application/x-ip2",
                  "video/x-isvideo",
                  "audio/it",
                  "application/x-inventor",
                  "i-world/i-vrml",
                  "application/x-livescreen",
                  "audio/x-jam",
                  "text/x-java-source",
                  "application/x-java-commerce",
                  "image/jpeg",
                  "image/pjpeg",
                  "image/x-jps",
                  "application/x-javascript",
                  "application/javascript",
                  "application/ecmascript",
                  "text/javascript",
                  "text/ecmascript",
                  "application/json",
                  "image/jutvision",
                  "music/x-karaoke",
                  "application/x-ksh",
                  "text/x-script.ksh",
                  "audio/nspaudio",
                  "audio/x-nspaudio",
                  "audio/x-liveaudio",
                  "application/x-latex",
                  "application/lha",
                  "application/x-lha",
                  "application/x-lisp",
                  "text/x-script.lisp",
                  "text/x-la-asf",
                  "application/x-lzh",
                  "application/lzx",
                  "application/x-lzx",
                  "text/x-m",
                  "audio/mpeg",
                  "audio/x-mpequrl",
                  "audio/m4a",
                  "audio/x-m4a",
                  "application/x-troff-man",
                  "application/x-navimap",
                  "application/mbedlet",
                  "application/x-magic-cap-package-1.0",
                  "application/mcad",
                  "application/x-mathcad",
                  "image/vasa",
                  "text/mcf",
                  "application/netmc",
                  "text/markdown",
                  "application/x-troff-me",
                  "message/rfc822",
                  "application/x-midi",
                  "audio/midi",
                  "audio/x-mid",
                  "audio/x-midi",
                  "music/crescendo",
                  "x-music/x-midi",
                  "application/x-frame",
                  "application/x-mif",
                  "www/mime",
                  "audio/x-vnd.audioexplosion.mjuicemediafile",
                  "video/x-motion-jpeg",
                  "application/base64",
                  "application/x-meme",
                  "audio/mod",
                  "audio/x-mod",
                  "video/quicktime",
                  "video/x-sgi-movie",
                  "audio/x-mpeg",
                  "video/x-mpeg",
                  "video/x-mpeq2a",
                  "audio/mpeg3",
                  "audio/x-mpeg-3",
                  "video/mp4",
                  "application/x-project",
                  "video/mpeg",
                  "application/vnd.ms-project",
                  "application/marc",
                  "application/x-troff-ms",
                  "application/x-vnd.audioexplosion.mzz",
                  "image/naplps",
                  "application/vnd.nokia.configuration-message",
                  "image/x-niff",
                  "application/x-mix-transfer",
                  "application/x-conference",
                  "application/x-navidoc",
                  "application/octet-stream",
                  "application/oda",
                  "audio/ogg",
                  "application/ogg",
                  "video/ogg",
                  "application/x-omc",
                  "application/x-omcdatamaker",
                  "application/x-omcregerator",
                  "text/x-pascal",
                  "application/pkcs10",
                  "application/x-pkcs10",
                  "application/pkcs-12",
                  "application/x-pkcs12",
                  "application/x-pkcs7-signature",
                  "application/pkcs7-mime",
                  "application/x-pkcs7-mime",
                  "application/x-pkcs7-certreqresp",
                  "application/pkcs7-signature",
                  "application/pro_eng",
                  "text/pascal",
                  "image/x-portable-bitmap",
                  "application/vnd.hp-pcl",
                  "application/x-pcl",
                  "image/x-pict",
                  "image/x-pcx",
                  "chemical/x-pdb",
                  "application/pdf",
                  "audio/make.my.funk",
                  "image/x-portable-graymap",
                  "image/x-portable-greymap",
                  "image/pict",
                  "application/x-newton-compatible-pkg",
                  "application/vnd.ms-pki.pko",
                  "text/x-script.perl",
                  "application/x-pixclscript",
                  "image/x-xpixmap",
                  "text/x-script.perl-module",
                  "application/x-pagemaker",
                  "image/png",
                  "application/x-portable-anymap",
                  "image/x-portable-anymap",
                  "model/x-pov",
                  "image/x-portable-pixmap",
                  "application/mspowerpoint",
                  "application/powerpoint",
                  "application/vnd.ms-powerpoint",
                  "application/x-mspowerpoint",
                  "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                  "application/x-freelance",
                  "paleovu/x-pv",
                  "text/x-script.phyton",
                  "application/x-bytecode.python",
                  "audio/vnd.qcelp",
                  "image/x-quicktime",
                  "video/x-qtc",
                  "audio/x-pn-realaudio",
                  "audio/x-pn-realaudio-plugin",
                  "audio/x-realaudio",
                  "application/x-cmu-raster",
                  "image/cmu-raster",
                  "image/x-cmu-raster",
                  "text/x-script.rexx",
                  "image/vnd.rn-realflash",
                  "image/x-rgb",
                  "application/vnd.rn-realmedia",
                  "audio/mid",
                  "application/ringing-tones",
                  "application/vnd.nokia.ringing-tone",
                  "application/vnd.rn-realplayer",
                  "application/x-troff",
                  "image/vnd.rn-realpix",
                  "application/x-rtf",
                  "text/richtext",
                  "application/rtf",
                  "video/vnd.rn-realvideo",
                  "audio/s3m",
                  "application/x-tbook",
                  "application/x-lotusscreencam",
                  "text/x-script.guile",
                  "text/x-script.scheme",
                  "video/x-scm",
                  "application/sdp",
                  "application/x-sdp",
                  "application/sounder",
                  "application/sea",
                  "application/x-sea",
                  "application/set",
                  "text/sgml",
                  "text/x-sgml",
                  "application/x-sh",
                  "application/x-shar",
                  "text/x-script.sh",
                  "text/x-server-parsed-html",
                  "audio/x-psid",
                  "application/x-sit",
                  "application/x-stuffit",
                  "application/x-koan",
                  "application/x-seelogo",
                  "application/smil",
                  "audio/x-adpcm",
                  "application/solids",
                  "application/x-pkcs7-certificates",
                  "text/x-speech",
                  "application/futuresplash",
                  "application/x-sprite",
                  "application/x-wais-source",
                  "application/streamingmedia",
                  "application/vnd.ms-pki.certstore",
                  "application/step",
                  "application/sla",
                  "application/vnd.ms-pki.stl",
                  "application/x-navistyle",
                  "application/x-sv4cpio",
                  "application/x-sv4crc",
                  "image/svg+xml",
                  "application/x-world",
                  "x-world/x-svr",
                  "application/x-shockwave-flash",
                  "application/x-tar",
                  "application/toolbook",
                  "application/x-tcl",
                  "text/x-script.tcl",
                  "text/x-script.tcsh",
                  "application/x-tex",
                  "application/x-texinfo",
                  "application/plain",
                  "application/gnutar",
                  "image/tiff",
                  "image/x-tiff",
                  "application/toml",
                  "audio/tsp-audio",
                  "application/dsptype",
                  "audio/tsplayer",
                  "text/tab-separated-values",
                  "application/i-deas",
                  "text/uri-list",
                  "application/x-ustar",
                  "multipart/x-ustar",
                  "text/x-uuencode",
                  "application/x-cdlink",
                  "text/x-vcalendar",
                  "application/vda",
                  "video/vdo",
                  "application/groupwise",
                  "video/vivo",
                  "video/vnd.vivo",
                  "application/vocaltec-media-desc",
                  "application/vocaltec-media-file",
                  "audio/voc",
                  "audio/x-voc",
                  "video/vosaic",
                  "audio/voxware",
                  "audio/x-twinvq-plugin",
                  "audio/x-twinvq",
                  "application/x-vrml",
                  "model/vrml",
                  "x-world/x-vrml",
                  "x-world/x-vrt",
                  "application/x-visio",
                  "application/wordperfect6.0",
                  "application/wordperfect6.1",
                  "audio/wav",
                  "audio/x-wav",
                  "application/x-qpro",
                  "image/vnd.wap.wbmp",
                  "application/vnd.xara",
                  "video/webm",
                  "audio/webm",
                  "image/webp",
                  "application/x-123",
                  "windows/metafile",
                  "text/vnd.wap.wml",
                  "application/vnd.wap.wmlc",
                  "text/vnd.wap.wmlscript",
                  "application/vnd.wap.wmlscriptc",
                  "video/x-ms-wmv",
                  "application/wordperfect",
                  "application/x-wpwin",
                  "application/x-lotus",
                  "application/mswrite",
                  "application/x-wri",
                  "text/scriplet",
                  "application/x-wintalk",
                  "image/x-xbitmap",
                  "image/x-xbm",
                  "image/xbm",
                  "video/x-amt-demorun",
                  "xgl/drawing",
                  "image/vnd.xiff",
                  "application/excel",
                  "application/vnd.ms-excel",
                  "application/x-excel",
                  "application/x-msexcel",
                  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                  "audio/xm",
                  "application/xml",
                  "text/xml",
                  "xgl/movie",
                  "application/x-vnd.ls-xpix",
                  "image/xpm",
                  "video/x-amt-showrun",
                  "image/x-xwd",
                  "image/x-xwindowdump",
                  "text/vnd.yaml",
                  "application/x-compress",
                  "application/x-zip-compressed",
                  "application/zip",
                  "multipart/x-zip",
                  "text/x-script.zsh"
                ]
            ],
      "_js2n__-:definitions/MultichoiceInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              allow_empty = _js2n__-prdslib.isType '"Bool",
                              empty_type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "null", "array" ]
                                    ],
                              picker_preview =
                                _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                              picker_view =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "card",
                                          "text",
                                          "gallery",
                                          "gallery-left"
                                        ]
                                    ],
                              preview =
                                _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                              value_key = _js2n__-prdslib.isType '"String",
                              values =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                                    ],
                              view =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "card",
                                          "text",
                                          "gallery",
                                          "gallery-left"
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "multichoice"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MultiselectInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              allow_create = _js2n__-prdslib.isType '"Bool",
                              allow_empty = _js2n__-prdslib.isType '"Bool",
                              empty_type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "null", "array" ]
                                    ],
                              picker_preview =
                                _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                              picker_view =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "card",
                                          "text",
                                          "gallery",
                                          "gallery-left"
                                        ]
                                    ],
                              preview =
                                _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                              value_key = _js2n__-prdslib.isType '"String",
                              values =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                                    ],
                              view =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "card",
                                          "text",
                                          "gallery",
                                          "gallery-left"
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "multiselect"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NumberInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/NumberInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "number"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NumberInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "number" ]
                        ],
                  max = _js2n__-prdslib.isType '"Number",
                  min = _js2n__-prdslib.isType '"Number",
                  step = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ObjectInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ObjectInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "object"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ObjectInputGroup!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  collapsed = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  heading = _js2n__-prdslib.isType '"String",
                  inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ObjectInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_label_formatting = _js2n__-prdslib.isType '"Bool",
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "object" ]
                        ],
                  entries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              allowed_keys =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              assigned_structures =
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
                              structures =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  groups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ObjectInputGroup!predicate"
                        ],
                  place_groups_below = _js2n__-prdslib.isType '"Bool",
                  preview =
                    _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                  structures =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                        ],
                  subtype =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "object", "mutable", "tabbed" ]
                        ],
                  view =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "card", "gallery", "gallery-left" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Paths!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dam_static = _js2n__-prdslib.isType '"String",
                  dam_uploads = _js2n__-prdslib.isType '"String",
                  dam_uploads_filename = _js2n__-prdslib.isType '"String",
                  static = _js2n__-prdslib.isType '"String",
                  uploads = _js2n__-prdslib.isType '"String",
                  uploads_filename = _js2n__-prdslib.isType '"String",
                  uploads_use_relative_path = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Preview!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  gallery =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewGallery!predicate",
                  icon =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                  icon_color = _js2n__-prdslib.isType '"String",
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                  metadata =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PreviewMetadata!predicate"
                        ],
                  subtext =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PreviewEntry!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/PreviewKeyEntry!predicate",
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                ],
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool"
            ],
      "_js2n__-:definitions/PreviewGallery!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "padded", "cover", "contain", "cover-top" ]
                        ],
                  icon =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                  icon_color = _js2n__-prdslib.isType '"String",
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PreviewKeyEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                { key = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PreviewMetadata!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  icon =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                  icon_color = _js2n__-prdslib.isType '"String",
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/PreviewEntry!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RangeInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/RangeInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "range"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RangeInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "number" ]
                        ],
                  max = _js2n__-prdslib.isType '"Number",
                  min = _js2n__-prdslib.isType '"Number",
                  step = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RichTextInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/RichTextInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "html", "markdown" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RichTextInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_custom_markup = _js2n__-prdslib.isType '"Bool",
                  allow_resize = _js2n__-prdslib.isType '"Bool",
                  allowed_sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  blockquote = _js2n__-prdslib.isType '"Bool",
                  bold = _js2n__-prdslib.isType '"Bool",
                  bulletedlist = _js2n__-prdslib.isType '"Bool",
                  center = _js2n__-prdslib.isType '"String",
                  code = _js2n__-prdslib.isType '"Bool",
                  code_block = _js2n__-prdslib.isType '"Bool",
                  code_inline = _js2n__-prdslib.isType '"Bool",
                  copyformatting = _js2n__-prdslib.isType '"Bool",
                  embed = _js2n__-prdslib.isType '"Bool",
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "string" ]
                        ],
                  expandable = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  height = _js2n__-prdslib.isType '"Number",
                  horizontalrule = _js2n__-prdslib.isType '"Bool",
                  image = _js2n__-prdslib.isType '"Bool",
                  image_size_attributes = _js2n__-prdslib.isType '"Bool",
                  indent = _js2n__-prdslib.isType '"Bool",
                  initial_height = _js2n__-prdslib.isType '"Number",
                  italic = _js2n__-prdslib.isType '"Bool",
                  justify = _js2n__-prdslib.isType '"String",
                  left = _js2n__-prdslib.isType '"String",
                  link = _js2n__-prdslib.isType '"Bool",
                  mime_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "image/jpeg", "image/png", "image/webp" ]
                        ],
                  numberedlist = _js2n__-prdslib.isType '"Bool",
                  outdent = _js2n__-prdslib.isType '"Bool",
                  paths =
                    _js2n__-refsenv."_js2n__-:definitions/Paths!predicate",
                  prevent_resize_existing_files =
                    _js2n__-prdslib.isType '"Bool",
                  redo = _js2n__-prdslib.isType '"Bool",
                  remove_custom_markup = _js2n__-prdslib.isType '"Bool",
                  removeformat = _js2n__-prdslib.isType '"Bool",
                  resize_style =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "cover", "contain", "stretch", "crop" ]
                        ],
                  right = _js2n__-prdslib.isType '"String",
                  sizes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "size" ],
                                _js2n__-prdslib.records.record
                                  {
                                    size = _js2n__-prdslib.isType '"String",
                                    target = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  snippet = _js2n__-prdslib.isType '"Bool",
                  strike = _js2n__-prdslib.isType '"Bool",
                  styles = _js2n__-prdslib.isType '"String",
                  subscript = _js2n__-prdslib.isType '"Bool",
                  superscript = _js2n__-prdslib.isType '"Bool",
                  table = _js2n__-prdslib.isType '"Bool",
                  underline = _js2n__-prdslib.isType '"Bool",
                  undo = _js2n__-prdslib.isType '"Bool",
                  width = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Schema!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  _editables =
                    _js2n__-refsenv."_js2n__-:definitions/Editables!predicate",
                  _enabled_editors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EditorKey!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  _inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Input!predicate"
                        ],
                  _select_data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                        ],
                  _structures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                        ],
                  create =
                    _js2n__-refsenv."_js2n__-:definitions/Create!predicate",
                  hide_extra_inputs = _js2n__-prdslib.isType '"Bool",
                  icon = _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  new_preview_url = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  preview =
                    _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                  remove_empty_inputs = _js2n__-prdslib.isType '"Bool",
                  remove_extra_inputs = _js2n__-prdslib.isType '"Bool",
                  reorder_inputs = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SelectInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              allow_create = _js2n__-prdslib.isType '"Bool",
                              allow_empty = _js2n__-prdslib.isType '"Bool",
                              empty_type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "null", "string" ]
                                    ],
                              picker_preview =
                                _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                              picker_view =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "card",
                                          "text",
                                          "gallery",
                                          "gallery-left"
                                        ]
                                    ],
                              preview =
                                _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                              value_key = _js2n__-prdslib.isType '"String",
                              values =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                                    ],
                              view =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "card",
                                          "text",
                                          "gallery",
                                          "gallery-left"
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "select"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SelectValues!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ])
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ])
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/SnippetConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  _inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Input!predicate"
                        ],
                  _select_data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                        ],
                  _structures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                        ],
                  alternate_formats =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SnippetConfig!predicate"
                        ],
                  definitions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  inline = _js2n__-prdslib.isType '"Bool",
                  params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  picker_preview =
                    _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                  preview =
                    _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                  snippet = _js2n__-prdslib.isType '"String",
                  strict_whitespace = _js2n__-prdslib.isType '"Bool",
                  template = _js2n__-prdslib.isType '"String",
                  view =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "card", "inline", "gallery" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SnippetsImports!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  docusaurus_mdx =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "exclude" ],
                              _js2n__-prdslib.records.record
                                {
                                  exclude =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "docusaurus_mdx_admonition",
                                                    "docusaurus_mdx_tabs",
                                                    "docusaurus_mdx_truncate",
                                                    "docusaurus_mdx_codeblock"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "include" ],
                              _js2n__-prdslib.records.record
                                {
                                  include =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "docusaurus_mdx_admonition",
                                                    "docusaurus_mdx_tabs",
                                                    "docusaurus_mdx_truncate",
                                                    "docusaurus_mdx_codeblock"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  eleventy_liquid =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "exclude" ],
                              _js2n__-prdslib.records.record
                                {
                                  exclude =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "eleventy_liquid_raw",
                                                    "_cc_eleventy_liquid_unknown_paired_shortcode",
                                                    "_cc_eleventy_liquid_unknown_shortcode",
                                                    "_cc_eleventy_liquid_template"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "include" ],
                              _js2n__-prdslib.records.record
                                {
                                  include =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "eleventy_liquid_raw",
                                                    "_cc_eleventy_liquid_unknown_paired_shortcode",
                                                    "_cc_eleventy_liquid_unknown_shortcode",
                                                    "_cc_eleventy_liquid_template"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  eleventy_nunjucks =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "exclude" ],
                              _js2n__-prdslib.records.record
                                {
                                  exclude =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "eleventy_nunjucks_raw",
                                                    "eleventy_nunjucks_verbatim",
                                                    "_cc_eleventy_nunjucks_unknown_paired_shortcode",
                                                    "_cc_eleventy_nunjucks_unknown_shortcode",
                                                    "_cc_eleventy_nunjucks_template"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "include" ],
                              _js2n__-prdslib.records.record
                                {
                                  include =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "eleventy_nunjucks_raw",
                                                    "eleventy_nunjucks_verbatim",
                                                    "_cc_eleventy_nunjucks_unknown_paired_shortcode",
                                                    "_cc_eleventy_nunjucks_unknown_shortcode",
                                                    "_cc_eleventy_nunjucks_template"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  hugo =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "exclude" ],
                              _js2n__-prdslib.records.record
                                {
                                  exclude =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "hugo_summary_divider",
                                                    "hugo_highlight",
                                                    "hugo_figure",
                                                    "hugo_gist",
                                                    "hugo_instagram",
                                                    "hugo_param",
                                                    "hugo_ref",
                                                    "hugo_relref",
                                                    "hugo_tweet",
                                                    "hugo_vimeo",
                                                    "hugo_youtube",
                                                    "_cc_hugo_unknown_paired",
                                                    "_cc_hugo_unknown",
                                                    "_cc_hugo_unknown_paired_processed",
                                                    "_cc_hugo_unknown_processed"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "include" ],
                              _js2n__-prdslib.records.record
                                {
                                  include =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "hugo_summary_divider",
                                                    "hugo_highlight",
                                                    "hugo_figure",
                                                    "hugo_gist",
                                                    "hugo_instagram",
                                                    "hugo_param",
                                                    "hugo_ref",
                                                    "hugo_relref",
                                                    "hugo_tweet",
                                                    "hugo_vimeo",
                                                    "hugo_youtube",
                                                    "_cc_hugo_unknown_paired",
                                                    "_cc_hugo_unknown",
                                                    "_cc_hugo_unknown_paired_processed",
                                                    "_cc_hugo_unknown_processed"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  jekyll =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "exclude" ],
                              _js2n__-prdslib.records.record
                                {
                                  exclude =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "_cc_jekyll_unknown_paired_tag",
                                                    "_cc_jekyll_unknown_tag",
                                                    "jekyll_highlight",
                                                    "_cc_jekyll_template",
                                                    "jekyll_raw",
                                                    "jekyll_link",
                                                    "jekyll_post_url"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "include" ],
                              _js2n__-prdslib.records.record
                                {
                                  include =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "_cc_jekyll_unknown_paired_tag",
                                                    "_cc_jekyll_unknown_tag",
                                                    "jekyll_highlight",
                                                    "_cc_jekyll_template",
                                                    "jekyll_raw",
                                                    "jekyll_link",
                                                    "jekyll_post_url"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  markdoc =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "exclude" ],
                              _js2n__-prdslib.records.record
                                {
                                  exclude =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "markdoc_id_annotation",
                                                    "markdoc_class_annotation",
                                                    "markdoc_table",
                                                    "_cc_markdoc_unknown_tag",
                                                    "_cc_markdoc_unknown_paired_tag",
                                                    "_cc_markdoc_unknown_template"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "include" ],
                              _js2n__-prdslib.records.record
                                {
                                  include =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "markdoc_id_annotation",
                                                    "markdoc_class_annotation",
                                                    "markdoc_table",
                                                    "_cc_markdoc_unknown_tag",
                                                    "_cc_markdoc_unknown_paired_tag",
                                                    "_cc_markdoc_unknown_template"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  mdx =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "exclude" ],
                              _js2n__-prdslib.records.record
                                {
                                  exclude =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "import",
                                                    "_cc_mdx_unknown_export",
                                                    "_cc_mdx_unknown_export_expression",
                                                    "_cc_mdx_unknown_export_default",
                                                    "_cc_mdx_unknown_template",
                                                    "_cc_mdx_paired_unknown",
                                                    "_cc_mdx_unknown"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "include" ],
                              _js2n__-prdslib.records.record
                                {
                                  include =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "import",
                                                    "_cc_mdx_unknown_export",
                                                    "_cc_mdx_unknown_export_expression",
                                                    "_cc_mdx_unknown_export_default",
                                                    "_cc_mdx_unknown_template",
                                                    "_cc_mdx_paired_unknown",
                                                    "_cc_mdx_unknown"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  python_markdown_extensions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "exclude" ],
                              _js2n__-prdslib.records.record
                                {
                                  exclude =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "python_markdown_abbreviation",
                                                    "python_markdown_admonition",
                                                    "python_markdown_arithmatex",
                                                    "python_markdown_attribute_list",
                                                    "python_markdown_code_block",
                                                    "python_markdown_collapsible_admonition",
                                                    "python_markdown_tabs",
                                                    "python_markdown_footnote",
                                                    "python_markdown_footnote_marker",
                                                    "python_markdown_icon",
                                                    "python_markdown_image",
                                                    "python_markdown_inline_arithmatex",
                                                    "python_markdown_inline_code",
                                                    "python_markdown_link",
                                                    "python_markdown_reference_image",
                                                    "python_markdown_reference_template_image",
                                                    "python_markdown_reference_link",
                                                    "python_markdown_reference",
                                                    "python_markdown_reference_template",
                                                    "python_markdown_block_snippet",
                                                    "_cc_python_markdown_unknown_snippet",
                                                    "_cc_python_markdown_unknown_markdown_in_html"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "include" ],
                              _js2n__-prdslib.records.record
                                {
                                  include =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "python_markdown_abbreviation",
                                                    "python_markdown_admonition",
                                                    "python_markdown_arithmatex",
                                                    "python_markdown_attribute_list",
                                                    "python_markdown_code_block",
                                                    "python_markdown_collapsible_admonition",
                                                    "python_markdown_tabs",
                                                    "python_markdown_footnote",
                                                    "python_markdown_footnote_marker",
                                                    "python_markdown_icon",
                                                    "python_markdown_image",
                                                    "python_markdown_inline_arithmatex",
                                                    "python_markdown_inline_code",
                                                    "python_markdown_link",
                                                    "python_markdown_reference_image",
                                                    "python_markdown_reference_template_image",
                                                    "python_markdown_reference_link",
                                                    "python_markdown_reference",
                                                    "python_markdown_reference_template",
                                                    "python_markdown_block_snippet",
                                                    "_cc_python_markdown_unknown_snippet",
                                                    "_cc_python_markdown_unknown_markdown_in_html"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Sort!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  order =
                    _js2n__-refsenv."_js2n__-:definitions/SortOrder!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SortOption!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  order =
                    _js2n__-refsenv."_js2n__-:definitions/SortOrder!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SortOrder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "ascending", "descending", "asc", "desc" ]
            ],
      "_js2n__-:definitions/SourceEditor!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  show_gutter = _js2n__-prdslib.isType '"Bool",
                  tab_size = _js2n__-prdslib.isType '"Number",
                  theme =
                    _js2n__-refsenv."_js2n__-:definitions/Theme!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Structure!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "values" ],
              _js2n__-prdslib.records.record
                {
                  hide_extra_inputs = _js2n__-prdslib.isType '"Bool",
                  id_key = _js2n__-prdslib.isType '"String",
                  remove_empty_inputs = _js2n__-prdslib.isType '"Bool",
                  remove_extra_inputs = _js2n__-prdslib.isType '"Bool",
                  reorder_inputs = _js2n__-prdslib.isType '"Bool",
                  style =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "select", "modal" ]
                        ],
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/StructureValue!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StructureValue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "value" ],
              _js2n__-prdslib.records.record
                {
                  _editables =
                    _js2n__-refsenv."_js2n__-:definitions/Editables!predicate",
                  _enabled_editors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EditorKey!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  _inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Input!predicate"
                        ],
                  _select_data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                        ],
                  _structures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                        ],
                  comment = _js2n__-prdslib.isType '"String",
                  "default" = _js2n__-prdslib.isType '"Bool",
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  groups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ObjectInputGroup!predicate"
                        ],
                  hide_extra_inputs = _js2n__-prdslib.isType '"Bool",
                  icon = _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  picker_preview =
                    _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                  place_groups_below = _js2n__-prdslib.isType '"Bool",
                  preview =
                    _js2n__-refsenv."_js2n__-:definitions/Preview!predicate",
                  remove_empty_inputs = _js2n__-prdslib.isType '"Bool",
                  remove_extra_inputs = _js2n__-prdslib.isType '"Bool",
                  reorder_inputs = _js2n__-prdslib.isType '"Bool",
                  tabbed = _js2n__-prdslib.isType '"Bool",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  value = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Syntax!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "abap",
                  "abc",
                  "actionscript",
                  "ada",
                  "alda",
                  "apache_conf",
                  "apex",
                  "applescript",
                  "aql",
                  "asciidoc",
                  "asl",
                  "assembly_x86",
                  "autohotkey",
                  "batchfile",
                  "c9search",
                  "c_cpp",
                  "cirru",
                  "clojure",
                  "cobol",
                  "coffee",
                  "coldfusion",
                  "crystal",
                  "csharp",
                  "csound_document",
                  "csound_orchestra",
                  "csound_score",
                  "csp",
                  "css",
                  "curly",
                  "d",
                  "dart",
                  "diff",
                  "django",
                  "dockerfile",
                  "dot",
                  "drools",
                  "edifact",
                  "eiffel",
                  "ejs",
                  "elixir",
                  "elm",
                  "erlang",
                  "forth",
                  "fortran",
                  "fsharp",
                  "fsl",
                  "ftl",
                  "gcode",
                  "gherkin",
                  "gitignore",
                  "glsl",
                  "gobstones",
                  "golang",
                  "graphqlschema",
                  "groovy",
                  "haml",
                  "handlebars",
                  "haskell",
                  "haskell_cabal",
                  "haxe",
                  "hjson",
                  "html",
                  "html_elixir",
                  "html_ruby",
                  "ini",
                  "io",
                  "jack",
                  "jade",
                  "java",
                  "javascript",
                  "json5",
                  "json",
                  "jsoniq",
                  "jsp",
                  "jssm",
                  "jsx",
                  "julia",
                  "kotlin",
                  "latex",
                  "less",
                  "liquid",
                  "lisp",
                  "livescript",
                  "logiql",
                  "logtalk",
                  "lsl",
                  "lua",
                  "luapage",
                  "lucene",
                  "makefile",
                  "markdown",
                  "mask",
                  "matlab",
                  "maze",
                  "mediawiki",
                  "mel",
                  "mixal",
                  "mushcode",
                  "mysql",
                  "nginx",
                  "nim",
                  "nix",
                  "nsis",
                  "nunjucks",
                  "objectivec",
                  "ocaml",
                  "pascal",
                  "perl6",
                  "perl",
                  "pgsql",
                  "php",
                  "php_laravel_blade",
                  "pig",
                  "plain_text",
                  "powershell",
                  "praat",
                  "prisma",
                  "prolog",
                  "properties",
                  "protobuf",
                  "puppet",
                  "python",
                  "qml",
                  "r",
                  "razor",
                  "rdoc",
                  "red",
                  "redshift",
                  "rhtml",
                  "rst",
                  "ruby",
                  "rust",
                  "sass",
                  "scad",
                  "scala",
                  "scheme",
                  "scss",
                  "sh",
                  "sjs",
                  "slim",
                  "smarty",
                  "snippets",
                  "soy_template",
                  "space",
                  "sparql",
                  "sql",
                  "sqlserver",
                  "stylus",
                  "svg",
                  "swift",
                  "tcl",
                  "terraform",
                  "tex",
                  "text",
                  "textile",
                  "toml",
                  "tsx",
                  "turtle",
                  "twig",
                  "export typescript",
                  "vala",
                  "vbscript",
                  "velocity",
                  "verilog",
                  "vhdl",
                  "visualforce",
                  "wollok",
                  "xml",
                  "xquery",
                  "yaml",
                  "zeek"
                ]
            ],
      "_js2n__-:definitions/TextEditable!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_custom_markup = _js2n__-prdslib.isType '"Bool",
                  bold = _js2n__-prdslib.isType '"Bool",
                  copyformatting = _js2n__-prdslib.isType '"Bool",
                  italic = _js2n__-prdslib.isType '"Bool",
                  link = _js2n__-prdslib.isType '"Bool",
                  paths =
                    _js2n__-refsenv."_js2n__-:definitions/Paths!predicate",
                  redo = _js2n__-prdslib.isType '"Bool",
                  remove_custom_markup = _js2n__-prdslib.isType '"Bool",
                  removeformat = _js2n__-prdslib.isType '"Bool",
                  strike = _js2n__-prdslib.isType '"Bool",
                  subscript = _js2n__-prdslib.isType '"Bool",
                  superscript = _js2n__-prdslib.isType '"Bool",
                  underline = _js2n__-prdslib.isType '"Bool",
                  undo = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TextInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/TextInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "text",
                              "email",
                              "disabled",
                              "pinterest",
                              "facebook",
                              "twitter",
                              "github",
                              "instagram"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TextInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "string" ]
                        ],
                  icon = _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                  placeholder = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Theme!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ambiance",
                  "chaos",
                  "chrome",
                  "clouds",
                  "clouds_midnight",
                  "cobalt",
                  "crimson_editor",
                  "dawn",
                  "dracula",
                  "dreamweaver",
                  "eclipse",
                  "github",
                  "gob",
                  "gruvbox",
                  "idle_fingers",
                  "iplastic",
                  "katzenmilch",
                  "kr_theme",
                  "kuroir",
                  "merbivore",
                  "merbivore_soft",
                  "mono_industrial",
                  "monokai",
                  "nord_dark",
                  "pastel_on_dark",
                  "solarized_dark",
                  "solarized_light",
                  "sqlserver",
                  "terminal",
                  "textmate",
                  "tomorrow",
                  "tomorrow_night",
                  "tomorrow_night_blue",
                  "tomorrow_night_bright",
                  "tomorrow_night_eighties",
                  "twilight",
                  "vibrant_ink",
                  "xcode"
                ]
            ],
      "_js2n__-:definitions/TimeInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/WithEmptyTypeText!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "time"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Timezone!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "Africa/Abidjan",
                  "Africa/Accra",
                  "Africa/Addis_Ababa",
                  "Africa/Algiers",
                  "Africa/Asmara",
                  "Africa/Asmera",
                  "Africa/Bamako",
                  "Africa/Bangui",
                  "Africa/Banjul",
                  "Africa/Bissau",
                  "Africa/Blantyre",
                  "Africa/Brazzaville",
                  "Africa/Bujumbura",
                  "Africa/Cairo",
                  "Africa/Casablanca",
                  "Africa/Ceuta",
                  "Africa/Conakry",
                  "Africa/Dakar",
                  "Africa/Dar_es_Salaam",
                  "Africa/Djibouti",
                  "Africa/Douala",
                  "Africa/El_Aaiun",
                  "Africa/Freetown",
                  "Africa/Gaborone",
                  "Africa/Harare",
                  "Africa/Johannesburg",
                  "Africa/Juba",
                  "Africa/Kampala",
                  "Africa/Khartoum",
                  "Africa/Kigali",
                  "Africa/Kinshasa",
                  "Africa/Lagos",
                  "Africa/Libreville",
                  "Africa/Lome",
                  "Africa/Luanda",
                  "Africa/Lubumbashi",
                  "Africa/Lusaka",
                  "Africa/Malabo",
                  "Africa/Maputo",
                  "Africa/Maseru",
                  "Africa/Mbabane",
                  "Africa/Mogadishu",
                  "Africa/Monrovia",
                  "Africa/Nairobi",
                  "Africa/Ndjamena",
                  "Africa/Niamey",
                  "Africa/Nouakchott",
                  "Africa/Ouagadougou",
                  "Africa/Porto-Novo",
                  "Africa/Sao_Tome",
                  "Africa/Timbuktu",
                  "Africa/Tripoli",
                  "Africa/Tunis",
                  "Africa/Windhoek",
                  "America/Adak",
                  "America/Anchorage",
                  "America/Anguilla",
                  "America/Antigua",
                  "America/Araguaina",
                  "America/Argentina/Buenos_Aires",
                  "America/Argentina/Catamarca",
                  "America/Argentina/ComodRivadavia",
                  "America/Argentina/Cordoba",
                  "America/Argentina/Jujuy",
                  "America/Argentina/La_Rioja",
                  "America/Argentina/Mendoza",
                  "America/Argentina/Rio_Gallegos",
                  "America/Argentina/Salta",
                  "America/Argentina/San_Juan",
                  "America/Argentina/San_Luis",
                  "America/Argentina/Tucuman",
                  "America/Argentina/Ushuaia",
                  "America/Aruba",
                  "America/Asuncion",
                  "America/Atikokan",
                  "America/Atka",
                  "America/Bahia",
                  "America/Bahia_Banderas",
                  "America/Barbados",
                  "America/Belem",
                  "America/Belize",
                  "America/Blanc-Sablon",
                  "America/Boa_Vista",
                  "America/Bogota",
                  "America/Boise",
                  "America/Buenos_Aires",
                  "America/Cambridge_Bay",
                  "America/Campo_Grande",
                  "America/Cancun",
                  "America/Caracas",
                  "America/Catamarca",
                  "America/Cayenne",
                  "America/Cayman",
                  "America/Chicago",
                  "America/Chihuahua",
                  "America/Coral_Harbour",
                  "America/Cordoba",
                  "America/Costa_Rica",
                  "America/Creston",
                  "America/Cuiaba",
                  "America/Curacao",
                  "America/Danmarkshavn",
                  "America/Dawson",
                  "America/Dawson_Creek",
                  "America/Denver",
                  "America/Detroit",
                  "America/Dominica",
                  "America/Edmonton",
                  "America/Eirunepe",
                  "America/El_Salvador",
                  "America/Ensenada",
                  "America/Fort_Nelson",
                  "America/Fort_Wayne",
                  "America/Fortaleza",
                  "America/Glace_Bay",
                  "America/Godthab",
                  "America/Goose_Bay",
                  "America/Grand_Turk",
                  "America/Grenada",
                  "America/Guadeloupe",
                  "America/Guatemala",
                  "America/Guayaquil",
                  "America/Guyana",
                  "America/Halifax",
                  "America/Havana",
                  "America/Hermosillo",
                  "America/Indiana/Indianapolis",
                  "America/Indiana/Knox",
                  "America/Indiana/Marengo",
                  "America/Indiana/Petersburg",
                  "America/Indiana/Tell_City",
                  "America/Indiana/Vevay",
                  "America/Indiana/Vincennes",
                  "America/Indiana/Winamac",
                  "America/Indianapolis",
                  "America/Inuvik",
                  "America/Iqaluit",
                  "America/Jamaica",
                  "America/Jujuy",
                  "America/Juneau",
                  "America/Kentucky/Louisville",
                  "America/Kentucky/Monticello",
                  "America/Knox_IN",
                  "America/Kralendijk",
                  "America/La_Paz",
                  "America/Lima",
                  "America/Los_Angeles",
                  "America/Louisville",
                  "America/Lower_Princes",
                  "America/Maceio",
                  "America/Managua",
                  "America/Manaus",
                  "America/Marigot",
                  "America/Martinique",
                  "America/Matamoros",
                  "America/Mazatlan",
                  "America/Mendoza",
                  "America/Menominee",
                  "America/Merida",
                  "America/Metlakatla",
                  "America/Mexico_City",
                  "America/Miquelon",
                  "America/Moncton",
                  "America/Monterrey",
                  "America/Montevideo",
                  "America/Montreal",
                  "America/Montserrat",
                  "America/Nassau",
                  "America/New_York",
                  "America/Nipigon",
                  "America/Nome",
                  "America/Noronha",
                  "America/North_Dakota/Beulah",
                  "America/North_Dakota/Center",
                  "America/North_Dakota/New_Salem",
                  "America/Nuuk",
                  "America/Ojinaga",
                  "America/Panama",
                  "America/Pangnirtung",
                  "America/Paramaribo",
                  "America/Phoenix",
                  "America/Port_of_Spain",
                  "America/Port-au-Prince",
                  "America/Porto_Acre",
                  "America/Porto_Velho",
                  "America/Puerto_Rico",
                  "America/Punta_Arenas",
                  "America/Rainy_River",
                  "America/Rankin_Inlet",
                  "America/Recife",
                  "America/Regina",
                  "America/Resolute",
                  "America/Rio_Branco",
                  "America/Rosario",
                  "America/Santa_Isabel",
                  "America/Santarem",
                  "America/Santiago",
                  "America/Santo_Domingo",
                  "America/Sao_Paulo",
                  "America/Scoresbysund",
                  "America/Shiprock",
                  "America/Sitka",
                  "America/St_Barthelemy",
                  "America/St_Johns",
                  "America/St_Kitts",
                  "America/St_Lucia",
                  "America/St_Thomas",
                  "America/St_Vincent",
                  "America/Swift_Current",
                  "America/Tegucigalpa",
                  "America/Thule",
                  "America/Thunder_Bay",
                  "America/Tijuana",
                  "America/Toronto",
                  "America/Tortola",
                  "America/Vancouver",
                  "America/Virgin",
                  "America/Whitehorse",
                  "America/Winnipeg",
                  "America/Yakutat",
                  "America/Yellowknife",
                  "Antarctica/Casey",
                  "Antarctica/Davis",
                  "Antarctica/DumontDUrville",
                  "Antarctica/Macquarie",
                  "Antarctica/Mawson",
                  "Antarctica/McMurdo",
                  "Antarctica/Palmer",
                  "Antarctica/Rothera",
                  "Antarctica/South_Pole",
                  "Antarctica/Syowa",
                  "Antarctica/Troll",
                  "Antarctica/Vostok",
                  "Arctic/Longyearbyen",
                  "Asia/Aden",
                  "Asia/Almaty",
                  "Asia/Amman",
                  "Asia/Anadyr",
                  "Asia/Aqtau",
                  "Asia/Aqtobe",
                  "Asia/Ashgabat",
                  "Asia/Ashkhabad",
                  "Asia/Atyrau",
                  "Asia/Baghdad",
                  "Asia/Bahrain",
                  "Asia/Baku",
                  "Asia/Bangkok",
                  "Asia/Barnaul",
                  "Asia/Beirut",
                  "Asia/Bishkek",
                  "Asia/Brunei",
                  "Asia/Calcutta",
                  "Asia/Chita",
                  "Asia/Choibalsan",
                  "Asia/Chongqing",
                  "Asia/Chungking",
                  "Asia/Colombo",
                  "Asia/Dacca",
                  "Asia/Damascus",
                  "Asia/Dhaka",
                  "Asia/Dili",
                  "Asia/Dubai",
                  "Asia/Dushanbe",
                  "Asia/Famagusta",
                  "Asia/Gaza",
                  "Asia/Harbin",
                  "Asia/Hebron",
                  "Asia/Ho_Chi_Minh",
                  "Asia/Hong_Kong",
                  "Asia/Hovd",
                  "Asia/Irkutsk",
                  "Asia/Istanbul",
                  "Asia/Jakarta",
                  "Asia/Jayapura",
                  "Asia/Jerusalem",
                  "Asia/Kabul",
                  "Asia/Kamchatka",
                  "Asia/Karachi",
                  "Asia/Kashgar",
                  "Asia/Kathmandu",
                  "Asia/Katmandu",
                  "Asia/Khandyga",
                  "Asia/Kolkata",
                  "Asia/Krasnoyarsk",
                  "Asia/Kuala_Lumpur",
                  "Asia/Kuching",
                  "Asia/Kuwait",
                  "Asia/Macao",
                  "Asia/Macau",
                  "Asia/Magadan",
                  "Asia/Makassar",
                  "Asia/Manila",
                  "Asia/Muscat",
                  "Asia/Nicosia",
                  "Asia/Novokuznetsk",
                  "Asia/Novosibirsk",
                  "Asia/Omsk",
                  "Asia/Oral",
                  "Asia/Phnom_Penh",
                  "Asia/Pontianak",
                  "Asia/Pyongyang",
                  "Asia/Qatar",
                  "Asia/Qostanay",
                  "Asia/Qyzylorda",
                  "Asia/Rangoon",
                  "Asia/Riyadh",
                  "Asia/Saigon",
                  "Asia/Sakhalin",
                  "Asia/Samarkand",
                  "Asia/Seoul",
                  "Asia/Shanghai",
                  "Asia/Singapore",
                  "Asia/Srednekolymsk",
                  "Asia/Taipei",
                  "Asia/Tashkent",
                  "Asia/Tbilisi",
                  "Asia/Tehran",
                  "Asia/Tel_Aviv",
                  "Asia/Thimbu",
                  "Asia/Thimphu",
                  "Asia/Tokyo",
                  "Asia/Tomsk",
                  "Asia/Ujung_Pandang",
                  "Asia/Ulaanbaatar",
                  "Asia/Ulan_Bator",
                  "Asia/Urumqi",
                  "Asia/Ust-Nera",
                  "Asia/Vientiane",
                  "Asia/Vladivostok",
                  "Asia/Yakutsk",
                  "Asia/Yangon",
                  "Asia/Yekaterinburg",
                  "Asia/Yerevan",
                  "Atlantic/Azores",
                  "Atlantic/Bermuda",
                  "Atlantic/Canary",
                  "Atlantic/Cape_Verde",
                  "Atlantic/Faeroe",
                  "Atlantic/Faroe",
                  "Atlantic/Jan_Mayen",
                  "Atlantic/Madeira",
                  "Atlantic/Reykjavik",
                  "Atlantic/South_Georgia",
                  "Atlantic/St_Helena",
                  "Atlantic/Stanley",
                  "Australia/ACT",
                  "Australia/Adelaide",
                  "Australia/Brisbane",
                  "Australia/Broken_Hill",
                  "Australia/Canberra",
                  "Australia/Currie",
                  "Australia/Darwin",
                  "Australia/Eucla",
                  "Australia/Hobart",
                  "Australia/LHI",
                  "Australia/Lindeman",
                  "Australia/Lord_Howe",
                  "Australia/Melbourne",
                  "Australia/North",
                  "Australia/NSW",
                  "Australia/Perth",
                  "Australia/Queensland",
                  "Australia/South",
                  "Australia/Sydney",
                  "Australia/Tasmania",
                  "Australia/Victoria",
                  "Australia/West",
                  "Australia/Yancowinna",
                  "Brazil/Acre",
                  "Brazil/DeNoronha",
                  "Brazil/East",
                  "Brazil/West",
                  "Canada/Atlantic",
                  "Canada/Central",
                  "Canada/Eastern",
                  "Canada/Mountain",
                  "Canada/Newfoundland",
                  "Canada/Pacific",
                  "Canada/Saskatchewan",
                  "Canada/Yukon",
                  "CET",
                  "Chile/Continental",
                  "Chile/EasterIsland",
                  "CST6CDT",
                  "Cuba",
                  "EET",
                  "Egypt",
                  "Eire",
                  "EST",
                  "EST5EDT",
                  "Etc/GMT",
                  "Etc/GMT-0",
                  "Etc/GMT-1",
                  "Etc/GMT-10",
                  "Etc/GMT-11",
                  "Etc/GMT-12",
                  "Etc/GMT-13",
                  "Etc/GMT-14",
                  "Etc/GMT-2",
                  "Etc/GMT-3",
                  "Etc/GMT-4",
                  "Etc/GMT-5",
                  "Etc/GMT-6",
                  "Etc/GMT-7",
                  "Etc/GMT-8",
                  "Etc/GMT-9",
                  "Etc/GMT+0",
                  "Etc/GMT+1",
                  "Etc/GMT+10",
                  "Etc/GMT+11",
                  "Etc/GMT+12",
                  "Etc/GMT+2",
                  "Etc/GMT+3",
                  "Etc/GMT+4",
                  "Etc/GMT+5",
                  "Etc/GMT+6",
                  "Etc/GMT+7",
                  "Etc/GMT+8",
                  "Etc/GMT+9",
                  "Etc/GMT0",
                  "Etc/Greenwich",
                  "Etc/UCT",
                  "Etc/Universal",
                  "Etc/UTC",
                  "Etc/Zulu",
                  "Europe/Amsterdam",
                  "Europe/Andorra",
                  "Europe/Astrakhan",
                  "Europe/Athens",
                  "Europe/Belfast",
                  "Europe/Belgrade",
                  "Europe/Berlin",
                  "Europe/Bratislava",
                  "Europe/Brussels",
                  "Europe/Bucharest",
                  "Europe/Budapest",
                  "Europe/Busingen",
                  "Europe/Chisinau",
                  "Europe/Copenhagen",
                  "Europe/Dublin",
                  "Europe/Gibraltar",
                  "Europe/Guernsey",
                  "Europe/Helsinki",
                  "Europe/Isle_of_Man",
                  "Europe/Istanbul",
                  "Europe/Jersey",
                  "Europe/Kaliningrad",
                  "Europe/Kiev",
                  "Europe/Kirov",
                  "Europe/Kyiv",
                  "Europe/Lisbon",
                  "Europe/Ljubljana",
                  "Europe/London",
                  "Europe/Luxembourg",
                  "Europe/Madrid",
                  "Europe/Malta",
                  "Europe/Mariehamn",
                  "Europe/Minsk",
                  "Europe/Monaco",
                  "Europe/Moscow",
                  "Europe/Nicosia",
                  "Europe/Oslo",
                  "Europe/Paris",
                  "Europe/Podgorica",
                  "Europe/Prague",
                  "Europe/Riga",
                  "Europe/Rome",
                  "Europe/Samara",
                  "Europe/San_Marino",
                  "Europe/Sarajevo",
                  "Europe/Saratov",
                  "Europe/Simferopol",
                  "Europe/Skopje",
                  "Europe/Sofia",
                  "Europe/Stockholm",
                  "Europe/Tallinn",
                  "Europe/Tirane",
                  "Europe/Tiraspol",
                  "Europe/Ulyanovsk",
                  "Europe/Uzhgorod",
                  "Europe/Vaduz",
                  "Europe/Vatican",
                  "Europe/Vienna",
                  "Europe/Vilnius",
                  "Europe/Volgograd",
                  "Europe/Warsaw",
                  "Europe/Zagreb",
                  "Europe/Zaporozhye",
                  "Europe/Zurich",
                  "GB",
                  "GB-Eire",
                  "GMT",
                  "GMT-0",
                  "GMT+0",
                  "GMT0",
                  "Greenwich",
                  "Hongkong",
                  "HST",
                  "Iceland",
                  "Indian/Antananarivo",
                  "Indian/Chagos",
                  "Indian/Christmas",
                  "Indian/Cocos",
                  "Indian/Comoro",
                  "Indian/Kerguelen",
                  "Indian/Mahe",
                  "Indian/Maldives",
                  "Indian/Mauritius",
                  "Indian/Mayotte",
                  "Indian/Reunion",
                  "Iran",
                  "Israel",
                  "Jamaica",
                  "Japan",
                  "Kwajalein",
                  "Libya",
                  "MET",
                  "Mexico/BajaNorte",
                  "Mexico/BajaSur",
                  "Mexico/General",
                  "MST",
                  "MST7MDT",
                  "Navajo",
                  "NZ",
                  "NZ-CHAT",
                  "Pacific/Apia",
                  "Pacific/Auckland",
                  "Pacific/Bougainville",
                  "Pacific/Chatham",
                  "Pacific/Chuuk",
                  "Pacific/Easter",
                  "Pacific/Efate",
                  "Pacific/Enderbury",
                  "Pacific/Fakaofo",
                  "Pacific/Fiji",
                  "Pacific/Funafuti",
                  "Pacific/Galapagos",
                  "Pacific/Gambier",
                  "Pacific/Guadalcanal",
                  "Pacific/Guam",
                  "Pacific/Honolulu",
                  "Pacific/Johnston",
                  "Pacific/Kanton",
                  "Pacific/Kiritimati",
                  "Pacific/Kosrae",
                  "Pacific/Kwajalein",
                  "Pacific/Majuro",
                  "Pacific/Marquesas",
                  "Pacific/Midway",
                  "Pacific/Nauru",
                  "Pacific/Niue",
                  "Pacific/Norfolk",
                  "Pacific/Noumea",
                  "Pacific/Pago_Pago",
                  "Pacific/Palau",
                  "Pacific/Pitcairn",
                  "Pacific/Pohnpei",
                  "Pacific/Ponape",
                  "Pacific/Port_Moresby",
                  "Pacific/Rarotonga",
                  "Pacific/Saipan",
                  "Pacific/Samoa",
                  "Pacific/Tahiti",
                  "Pacific/Tarawa",
                  "Pacific/Tongatapu",
                  "Pacific/Truk",
                  "Pacific/Wake",
                  "Pacific/Wallis",
                  "Pacific/Yap",
                  "Poland",
                  "Portugal",
                  "PRC",
                  "PST8PDT",
                  "ROC",
                  "ROK",
                  "Singapore",
                  "Turkey",
                  "UCT",
                  "Universal",
                  "US/Alaska",
                  "US/Aleutian",
                  "US/Arizona",
                  "US/Central",
                  "US/East-Indiana",
                  "US/Eastern",
                  "US/Hawaii",
                  "US/Indiana-Starke",
                  "US/Michigan",
                  "US/Mountain",
                  "US/Pacific",
                  "US/Samoa",
                  "UTC",
                  "W-SU",
                  "WET",
                  "Zulu"
                ]
            ],
      "_js2n__-:definitions/UnknownInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/WithEmptyTypeText!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WithEmptyTypeNumber!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WithEmptyTypeObject!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/WithEmptyTypeArray!predicate"
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "auto"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UrlInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  cascade = _js2n__-prdslib.isType '"Bool",
                  comment = _js2n__-prdslib.isType '"String",
                  context =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              content = _js2n__-prdslib.isType '"String",
                              icon =
                                _js2n__-refsenv."_js2n__-:definitions/Icon!predicate",
                              open = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  documentation =
                    _js2n__-refsenv."_js2n__-:definitions/Documentation!predicate",
                  hidden =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  instance_value =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceValue!predicate",
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/UrlInputOptions!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "url"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UrlInputOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "string" ]
                        ],
                  paths =
                    _js2n__-refsenv."_js2n__-:definitions/Paths!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WithEmptyTypeArray!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "array" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WithEmptyTypeNumber!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "number" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WithEmptyTypeObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "object" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WithEmptyTypeText!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  empty_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "null", "string" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WithPaths!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  paths =
                    _js2n__-refsenv."_js2n__-:definitions/Paths!predicate",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              _editables =
                _js2n__-refsenv."_js2n__-:definitions/Editables!predicate",
              _enabled_editors =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/EditorKey!predicate",
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              _inputs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/Input!predicate"
                    ],
              _select_data =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/SelectValues!predicate"
                    ],
              _snippets =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/SnippetConfig!predicate"
                    ],
              _snippets_definitions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/SnippetConfig!predicate"
                    ],
              _snippets_imports =
                _js2n__-refsenv."_js2n__-:definitions/SnippetsImports!predicate",
              _snippets_templates =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/SnippetConfig!predicate"
                    ],
              _structures =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/Structure!predicate"
                    ],
              base_url = _js2n__-prdslib.isType '"String",
              collection_groups =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/CollectionGroup!predicate"
                    ],
              collections_config =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/CollectionConfig!predicate"
                    ],
              commit_templates =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/CommitTemplate!predicate"
                    ],
              data_config =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/DataConfigEntry!predicate"
                    ],
              editor = _js2n__-refsenv."_js2n__-:definitions/Editor!predicate",
              file_config =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/FileConfigEntry!predicate"
                    ],
              markdown =
                _js2n__-refsenv."_js2n__-:definitions/MarkdownSettings!predicate",
              paths = _js2n__-refsenv."_js2n__-:definitions/Paths!predicate",
              source = _js2n__-prdslib.isType '"String",
              source_editor =
                _js2n__-refsenv."_js2n__-:definitions/SourceEditor!predicate",
              timezone =
                _js2n__-refsenv."_js2n__-:definitions/Timezone!predicate",
            } {} false _js2n__-prdslib.never
        ])