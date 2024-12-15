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
      "_js2n__-:definitions/certificate-authority-config!predicate"
        | doc "Certificate Authority"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "key-size" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "validity-duration" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]
                          ]),
                      _js2n__-prdslib.records.required [ "cert", "key" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "key-size" ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required
                                [ "validity-duration" ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ]
                        ],
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "cert" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "key" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]
                          ])
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  cert = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  key-size = _js2n__-prdslib.isType 'Integer,
                  validity-duration = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/certificate-config!predicate"
        | doc "Node's Certificate configuration option"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  issue = _js2n__-prdslib.always,
                  key-size = _js2n__-prdslib.isType 'Integer,
                  sans =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  validity-duration = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/config-config!predicate"
        | doc "containerlab config engine parameters"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { vars = _js2n__-prdslib.isType 'Record, } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dns-config!predicate"
        | doc "Node's DNS configuration option"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  search =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  servers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/extras-config!predicate"
        | doc "node's extra configurations"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  mysocket-proxy = _js2n__-prdslib.isType '"String",
                  srl-agents =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/healthcheck-config!predicate"
        | doc "Node's Healthcheck configuration option"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  interval = _js2n__-prdslib.isType 'Integer,
                  retries = _js2n__-prdslib.isType 'Integer,
                  start-period = _js2n__-prdslib.isType 'Integer,
                  test =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  timeout = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/link-config!predicate"
        | doc "link configuration container"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern "^\\S+:\\S+$"
                              ]),
                          _js2n__-prdslib.arrays.minItems 2,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  vars = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/node-config!predicate"
        | doc "topology node configuration container"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.record
                    { type = _js2n__-prdslib.isType '"String", } {} true
                    _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "kind" ],
                        _js2n__-prdslib.records.record
                          {
                            kind =
                              _js2n__-prdslib.strings.pattern
                                  "(srl|nokia_srlinux)",
                          } {} true _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "ixsa1",
                                    "ixrd1",
                                    "ixrd2",
                                    "ixrd3",
                                    "ixrd2l",
                                    "ixrd3l",
                                    "ixrd4",
                                    "ixrd5",
                                    "ixrh2",
                                    "ixrh3",
                                    "ixrh4",
                                    "ixr6",
                                    "ixr6e",
                                    "ixr10",
                                    "ixr10e",
                                    "sxr1x44s",
                                    "sxr1d32d",
                                    "ixrx1b",
                                    "ixrx3b"
                                  ]
                              ],
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "kind" ],
                        _js2n__-prdslib.records.record
                          {
                            kind =
                              _js2n__-prdslib.strings.pattern
                                  "(vr-sros|vr-nokia_sros)",
                          } {} true _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.enum
                                      [
                                        "sr-1",
                                        "sr-1e",
                                        "sr-1e-sec",
                                        "sr-1s",
                                        "sr-1s-macsec",
                                        "sr-2s",
                                        "sr-7s",
                                        "sr-7s-fp4",
                                        "sr-14s",
                                        "sr-a4",
                                        "ixr-e-small",
                                        "ixr-e-big",
                                        "ixr-e2",
                                        "ixr-ec",
                                        "ixr-r6",
                                        "ixr-s"
                                      ],
                                    _js2n__-prdslib.strings.pattern "cp:.+"
                                  ]
                              ],
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.record
                {
                  aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  auto-remove = _js2n__-prdslib.isType '"Bool",
                  binds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  certificate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/certificate-config!predicate"
                        ],
                  cmd = _js2n__-prdslib.isType '"String",
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/config-config!predicate",
                  cpu = _js2n__-prdslib.isType 'Integer,
                  cpu-set = _js2n__-prdslib.isType '"String",
                  dns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/dns-config!predicate"
                        ],
                  enforce-startup-config = _js2n__-prdslib.isType '"Bool",
                  entrypoint = _js2n__-prdslib.isType '"String",
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              ".+" =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.arrays.minItems 1
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.arrays.minItems 1
                                        ]
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  exec =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  extras =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/extras-config!predicate"
                        ],
                  group = _js2n__-prdslib.isType '"String",
                  healthcheck =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/healthcheck-config!predicate"
                        ],
                  image = _js2n__-prdslib.isType '"String",
                  image-pull-policy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "always",
                              "Always",
                              "never",
                              "Never",
                              "ifnotpresent",
                              "IfNotPresent"
                            ]
                        ],
                  kernel = _js2n__-prdslib.isType '"String",
                  kind =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "srl",
                              "nokia_srlinux",
                              "ceos",
                              "arista_ceos",
                              "crpd",
                              "juniper_crpd",
                              "sonic-vs",
                              "sonic-vm",
                              "vr-sros",
                              "nokia_sros",
                              "vr-nokia_sros",
                              "vr-vmx",
                              "vr-juniper_vmx",
                              "juniper_vmx",
                              "vr-vqfx",
                              "vr-juniper_vqfx",
                              "juniper_vqfx",
                              "vr-vsrx",
                              "vr-juniper_vsrx",
                              "juniper_vsrx",
                              "juniper_vjunosrouter",
                              "juniper_vjunosswitch",
                              "juniper_vjunosevolved",
                              "vr-xrv",
                              "vr-cisco_xrv",
                              "cisco_xrv",
                              "vr-xrv9k",
                              "vr-cisco_xrv9k",
                              "cisco_xrv9k",
                              "vr-veos",
                              "vr-arista_veos",
                              "arista_veos",
                              "vr-csr",
                              "vr-cisco_csr",
                              "cisco_csr1000v",
                              "vr-pan",
                              "vr-paloalto_panos",
                              "paloalto_panos",
                              "vr-ros",
                              "vr-mikrotik_ros",
                              "mikrotik_ros",
                              "vr-n9kv",
                              "vr-cisco_n9kv",
                              "cisco_n9kv",
                              "cisco_ftdv",
                              "dell_ftosv",
                              "dell_sonic",
                              "vr-aoscx",
                              "vr-aruba_aoscx",
                              "aruba_aoscx",
                              "linux",
                              "bridge",
                              "ovs-bridge",
                              "border0",
                              "host",
                              "keysight_ixia-c-one",
                              "ipinfusion_ocnos",
                              "checkpoint_cloudguard",
                              "ext-container",
                              "xrd",
                              "rare",
                              "cisco_xrd",
                              "c8000",
                              "cisco_c8000",
                              "cisco_c8000v",
                              "cisco_cat9kv",
                              "cisco_iol",
                              "cvx",
                              "cumulus_cvx",
                              "huawei_vrp",
                              "openbsd",
                              "freebsd",
                              "generic_vm",
                              "fortinet_fortigate",
                              "k8s-kind"
                            ]
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              ".+" =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.arrays.minItems 1
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.arrays.minItems 1
                                        ]
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  license = _js2n__-prdslib.isType '"String",
                  memory = _js2n__-prdslib.isType '"String",
                  mgmt-ipv4 =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(%[\\p{N}\\p{L}]+)?$"
                        ],
                  mgmt-ipv6 =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^((:|[0-9a-fA-F]{0,4}):)([0-9a-fA-F]{0,4}:){0,5}((([0-9a-fA-F]{0,4}:)?(:|[0-9a-fA-F]{0,4}))|(((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])))(%[\\p{N}\\p{L}]+)?$"
                        ],
                  network-mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(host)|(container:\\S+)|(none)$"
                        ],
                  ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(%[\\p{N}\\p{L}]+)?:([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$|^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(%[\\p{N}\\p{L}]+)?:([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])+(/tcp|/udp|/sctp)$|^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$|^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])+(/tcp|/udp|/sctp)$|^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$|^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])-([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])+(/tcp|/udp|/sctp)?$"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  publish =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "(^http|^https|^tcp|^tls)/(([0-9]+$)|([0-9]+/.+$))"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  restart-policy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "no",
                              "No",
                              "on-failure",
                              "On-failure",
                              "Always",
                              "always",
                              "unless-stopped",
                              "Unless-stopped"
                            ]
                        ],
                  runtime =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "docker", "ignite" ]
                        ],
                  sandbox = _js2n__-prdslib.isType '"String",
                  stages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/stages-config!predicate"
                        ],
                  startup-config = _js2n__-prdslib.isType '"String",
                  startup-delay = _js2n__-prdslib.isType 'Integer,
                  type = _js2n__-prdslib.isType '"String",
                  user =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.arrays.minItems 1
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/stage-exec!predicate"
        | doc "per-stage exec configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  on-enter =
                    _js2n__-refsenv."_js2n__-:definitions/stage-exec-list!predicate",
                  on-exit =
                    _js2n__-refsenv."_js2n__-:definitions/stage-exec-list!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/stage-exec-list!predicate"
        | doc "list of commands to execute"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/stages-config!predicate"
        | doc "node's stages configurations"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configure =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              exec =
                                _js2n__-refsenv."_js2n__-:definitions/stage-exec!predicate",
                              wait-for =
                                _js2n__-refsenv."_js2n__-:definitions/wait-for-config!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  create =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              exec =
                                _js2n__-refsenv."_js2n__-:definitions/stage-exec!predicate",
                              wait-for =
                                _js2n__-refsenv."_js2n__-:definitions/wait-for-config!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  create-links =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              exec =
                                _js2n__-refsenv."_js2n__-:definitions/stage-exec!predicate",
                              wait-for =
                                _js2n__-refsenv."_js2n__-:definitions/wait-for-config!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  exit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              exec =
                                _js2n__-refsenv."_js2n__-:definitions/stage-exec!predicate",
                              wait-for =
                                _js2n__-refsenv."_js2n__-:definitions/wait-for-config!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  healthy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              exec =
                                _js2n__-refsenv."_js2n__-:definitions/stage-exec!predicate",
                              wait-for =
                                _js2n__-refsenv."_js2n__-:definitions/wait-for-config!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/stages-enum!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "create", "create-links", "configure", "healthy", "exit" ]
            ],
      "_js2n__-:definitions/wait-for-config!predicate"
        | doc "Dependency list for the node"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        node = _js2n__-prdslib.isType '"String",
                        stage =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/stages-enum!predicate"
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
    }
    in
  {
      mgmt
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  bridge = _js2n__-prdslib.isType '"String",
                  ipv4-gw =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(%[\\p{N}\\p{L}]+)?$"
                        ],
                  ipv4-range =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^.+/[0-9]{1,2}$"
                        ],
                  ipv4-subnet =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "(^.+/[0-9]{1,2}$)|(auto)"
                        ],
                  ipv6-gw =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^((:|[0-9a-fA-F]{0,4}):)([0-9a-fA-F]{0,4}:){0,5}((([0-9a-fA-F]{0,4}:)?(:|[0-9a-fA-F]{0,4}))|(((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])))(%[\\p{N}\\p{L}]+)?$"
                        ],
                  ipv6-range =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^((:|[0-9a-fA-F]{0,4}):)([0-9a-fA-F]{0,4}:){0,5}((([0-9a-fA-F]{0,4}:)?(:|[0-9a-fA-F]{0,4}))|(((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])))(%[\\p{N}\\p{L}]+)?$"
                        ],
                  ipv6-subnet =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "(^.+/[0-9]{1,3}$)|(auto)"
                        ],
                  mtu =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 65535,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  network = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ])
        | doc "configuration container for management network"
        | optional,
      name | String | doc "topology name",
      prefix
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"String")
        | doc "lab prefix"
        | optional,
      settings
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  certificate-authority =
                    _js2n__-refsenv."_js2n__-:definitions/certificate-authority-config!predicate",
                } {} true _js2n__-prdslib.always
            ])
        | doc "Global containerlab settings"
        | optional,
      topology
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "nodes" ],
              _js2n__-prdslib.records.record
                {
                  defaults =
                    _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                  kinds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              arista_ceos =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              bridge =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              c8000 =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              c8000v =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              ceos =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              checkpoint_cloudguard =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              cisco_cat9kv =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              cisco_ftdv =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              cisco_iol =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              crpd =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              cumulus_cvx =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              cvx =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              dell_ftosv =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              dell_sonic =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              ext-container =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              freebsd =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              generic_vm =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              host =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              huawei_vrp =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              ipinfusion_ocnos =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              juniper_crpd =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              juniper_vjunosevolved =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              juniper_vjunosrouter =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              juniper_vjunosswitch =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              keysight_ixia-c-one =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              linux =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              mysocketio =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              nokia_srlinux =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              openbsd =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              ovs-bridge =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              rare =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              sonic-vm =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              sonic-vs =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              srl =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-aoscx =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-arista_veos =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-aruba_aoscx =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-cisco_csr =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-cisco_nxos =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-cisco_xrv =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-cisco_xrv9k =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-csr =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-juniper_vmx =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-juniper_vsrx =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-nokia_sros =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-nxos =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-sros =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-vmx =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-vsrx =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-xrv =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              vr-xrv9k =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                              xrd =
                                _js2n__-refsenv."_js2n__-:definitions/node-config!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  links =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/link-config!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  nodes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              ".*" =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType 'Null,
                                      _js2n__-refsenv."_js2n__-:definitions/node-config!predicate"
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ])
        | doc "topology configuration container",
    }