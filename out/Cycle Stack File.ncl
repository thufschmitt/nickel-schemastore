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
      "_js2n__-:properties/containers/additionalProperties/properties/image/properties/builder/properties/integration_id!predicate"
        | doc "The ID of the integration to use when building the image. The integration must support image building to be compatible."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:properties/containers/additionalProperties/properties/image/properties/origin/oneOf/2/properties/details/properties/existing!predicate"
        | doc "In a stack, specifies an image source ID from which Cycle will derive any values not specified in the stack file. This is useful for avoiding direct placement of credentials in a stack file, for example."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  source_id =
                    _js2n__-refsenv."_js2n__-:properties/containers/additionalProperties/properties/image/properties/origin/oneOf/4/properties/details/properties/source_id!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:properties/containers/additionalProperties/properties/image/properties/origin/oneOf/4/properties/details/properties/source_id!predicate"
        | doc "The ID referencing the image source where this image originated."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate"
        | doc "A string signifying a duration of time. Valid time units are \"ns\", \"us\" (or \"µs\"), \"ms\", \"s\", \"m\", \"h\", \"d\", \"w\", \"y\"."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:properties/scoped_variables/items/properties/identifier!predicate"
        | doc m%"
          A human-readable identifier used to refer to a resource, where using the official ID may be inconvenient.
          The identifier is automatically tokenized from the name/relevant field of the resource if one is not provided. For example, a container named "My Container" will
          have the identifier of `my-container` and is automatically created by the platform.
          
          The identifier does not have to be unique.
          
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/0/properties/details/anyOf/0!predicate"
        | doc "Describes settings that are passed to HAProxy within the load balancer."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "default", "ports" ],
              _js2n__-prdslib.records.record
                {
                  "default" =
                    _js2n__-refsenv."_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/0/properties/details/anyOf/0/properties/ports/additionalProperties!predicate",
                  ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "backend", "frontend" ],
                                _js2n__-prdslib.records.record
                                  {
                                    backend =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "balance", "timeouts" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                balance =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "roundrobin",
                                                            "static-rr",
                                                            "leastconn",
                                                            "first",
                                                            "source"
                                                          ]
                                                      ],
                                                timeouts =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.required
                                                          [
                                                            "connect_ms",
                                                            "queue_ms",
                                                            "server_fin_ms",
                                                            "server_secs",
                                                            "tunnel_secs"
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            connect_ms =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            queue_ms =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            server_fin_ms =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            server_secs =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            tunnel_secs =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    frontend =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [
                                                "max_connections",
                                                "mode",
                                                "timeouts"
                                              ],
                                            _js2n__-prdslib.records.record
                                              {
                                                max_connections =
                                                  _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Integer,
                                                        _js2n__-prdslib.isType
                                                          'Null
                                                      ],
                                                mode =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [ "tcp", "http" ]
                                                      ],
                                                timeouts =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.required
                                                          [
                                                            "client_fin_ms",
                                                            "client_secs",
                                                            "http_keep_alive_ms",
                                                            "http_request_ms"
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            client_fin_ms =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            client_secs =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            http_keep_alive_ms =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            http_request_ms =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/0/properties/details/anyOf/0/properties/ports/additionalProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "backend", "frontend" ],
              _js2n__-prdslib.records.record
                {
                  backend =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "balance", "timeouts" ],
                          _js2n__-prdslib.records.record
                            {
                              balance =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "roundrobin",
                                          "static-rr",
                                          "leastconn",
                                          "first",
                                          "source"
                                        ]
                                    ],
                              timeouts =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.records.required
                                        [
                                          "connect_ms",
                                          "queue_ms",
                                          "server_fin_ms",
                                          "server_secs",
                                          "tunnel_secs"
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          connect_ms =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                          queue_ms =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                          server_fin_ms =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                          server_secs =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                          tunnel_secs =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  frontend =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "max_connections", "mode", "timeouts" ],
                          _js2n__-prdslib.records.record
                            {
                              max_connections =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                              mode =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "tcp", "http" ]
                                    ],
                              timeouts =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.records.required
                                        [
                                          "client_fin_ms",
                                          "client_secs",
                                          "http_keep_alive_ms",
                                          "http_request_ms"
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          client_fin_ms =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                          client_secs =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                          http_keep_alive_ms =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                          http_request_ms =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/1/properties/details!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "controllers" ],
              _js2n__-prdslib.records.record
                {
                  controller_template =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/1/properties/details/properties/controllers/items!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  controllers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "default", "identifier", "transport" ],
                                _js2n__-prdslib.records.record
                                  {
                                    "default" = _js2n__-prdslib.isType '"Bool",
                                    identifier =
                                      _js2n__-prdslib.isType '"String",
                                    transport =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [
                                                "config",
                                                "disable",
                                                "mode",
                                                "routers"
                                              ],
                                            _js2n__-prdslib.records.record
                                              {
                                                config =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.required
                                                          [
                                                            "ingress",
                                                            "performance",
                                                            "timeouts",
                                                            "verbosity"
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            extension =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Record,
                                                                    _js2n__-prdslib.oneOf
                                                                      [
                                                                        _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.required
                                                                              [
                                                                                "details",
                                                                                "type"
                                                                              ],
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                details =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          'Record,
                                                                                        _js2n__-prdslib.records.required
                                                                                          [
                                                                                            "connections",
                                                                                            "telemetry"
                                                                                          ],
                                                                                        _js2n__-prdslib.records.record
                                                                                          {
                                                                                            connections =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.isType
                                                                                                      'Record,
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {}
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                            telemetry =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.isType
                                                                                                      'Record,
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        disable_router_metrics =
                                                                                                          _js2n__-prdslib.isType
                                                                                                              '"Bool",
                                                                                                        persist_restarts =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                        tracking_window =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                          }
                                                                                          {}
                                                                                          true
                                                                                          _js2n__-prdslib.always
                                                                                      ],
                                                                                type =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                        _js2n__-prdslib.enum
                                                                                          [
                                                                                            "tcp"
                                                                                          ]
                                                                                      ],
                                                                              }
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ],
                                                                        _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.required
                                                                              [
                                                                                "details",
                                                                                "type"
                                                                              ],
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                details =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          'Record,
                                                                                        _js2n__-prdslib.records.required
                                                                                          [
                                                                                            "connections",
                                                                                            "telemetry"
                                                                                          ],
                                                                                        _js2n__-prdslib.records.record
                                                                                          {
                                                                                            connections =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.isType
                                                                                                      'Record,
                                                                                                    _js2n__-prdslib.records.required
                                                                                                      [
                                                                                                        "max_idle_conns_per_connection"
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        max_idle_conns_per_connection =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Integer,
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                            telemetry =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.isType
                                                                                                      'Record,
                                                                                                    _js2n__-prdslib.records.required
                                                                                                      [
                                                                                                        "disable_router_metrics",
                                                                                                        "disable_url_tracking"
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        disable_router_metrics =
                                                                                                          _js2n__-prdslib.isType
                                                                                                              '"Bool",
                                                                                                        disable_url_tracking =
                                                                                                          _js2n__-prdslib.isType
                                                                                                              '"Bool",
                                                                                                        group_paths =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Null
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.records.record
                                                                                                                  {}
                                                                                                                  {}
                                                                                                                  true
                                                                                                                  (_js2n__-prdslib.isType
                                                                                                                    '"String")
                                                                                                              ],
                                                                                                        ignore_paths =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      '"Array",
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Null
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.arrays.arrayOf
                                                                                                                  (_js2n__-prdslib.isType
                                                                                                                    '"String")
                                                                                                              ],
                                                                                                        max_trackable_urls =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Integer,
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                        persist_restarts =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                        track_invalid_requests =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                        tracking_window =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                          }
                                                                                          {}
                                                                                          true
                                                                                          _js2n__-prdslib.always
                                                                                      ],
                                                                                type =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                        _js2n__-prdslib.enum
                                                                                          [
                                                                                            "http"
                                                                                          ]
                                                                                      ],
                                                                              }
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ],
                                                                        _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.required
                                                                              [
                                                                                "details",
                                                                                "type"
                                                                              ],
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                details =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          'Record,
                                                                                        _js2n__-prdslib.records.required
                                                                                          [
                                                                                            "telemetry"
                                                                                          ],
                                                                                        _js2n__-prdslib.records.record
                                                                                          {
                                                                                            telemetry =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.isType
                                                                                                      'Record,
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        disable_router_metrics =
                                                                                                          _js2n__-prdslib.isType
                                                                                                              '"Bool",
                                                                                                        persist_restarts =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                        tracking_window =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                          }
                                                                                          {}
                                                                                          true
                                                                                          _js2n__-prdslib.always
                                                                                      ],
                                                                                type =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                        _js2n__-prdslib.enum
                                                                                          [
                                                                                            "udp"
                                                                                          ]
                                                                                      ],
                                                                              }
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ]
                                                                      ]
                                                                  ],
                                                            ingress =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Record,
                                                                    _js2n__-prdslib.records.required
                                                                      [
                                                                        "port"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        port =
                                                                          _js2n__-prdslib.isType
                                                                              'Integer,
                                                                        tls =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.anyOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.isType
                                                                                      'Null
                                                                                  ],
                                                                                _js2n__-prdslib.records.required
                                                                                  [
                                                                                    "enable"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    enable =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                  }
                                                                                  {}
                                                                                  true
                                                                                  _js2n__-prdslib.always
                                                                              ],
                                                                      } {} true
                                                                      _js2n__-prdslib.always
                                                                  ],
                                                            performance =
                                                              _js2n__-prdslib.isType
                                                                  '"Bool",
                                                            timeouts =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Record,
                                                                    _js2n__-prdslib.records.required
                                                                      [
                                                                        "idle"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        idle =
                                                                          _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                      } {} true
                                                                      _js2n__-prdslib.always
                                                                  ],
                                                            verbosity =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.enum
                                                                      [
                                                                        "low",
                                                                        "normal",
                                                                        "high",
                                                                        "debug"
                                                                      ]
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                disable =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                mode =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "tcp",
                                                            "udp",
                                                            "http"
                                                          ]
                                                      ],
                                                routers =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.required
                                                                [
                                                                  "config",
                                                                  "match",
                                                                  "mode"
                                                                ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  config =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.required
                                                                            [
                                                                              "destination_retries",
                                                                              "sticky_sessions",
                                                                              "timeouts"
                                                                            ],
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              destination_prioritization =
                                                                                _js2n__-prdslib.oneOf
                                                                                    [
                                                                                      _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            '"String",
                                                                                          _js2n__-prdslib.enum
                                                                                            [
                                                                                              "latency",
                                                                                              "random"
                                                                                            ]
                                                                                        ],
                                                                                      _js2n__-prdslib.isType
                                                                                        'Null
                                                                                    ],
                                                                              destination_retries =
                                                                                _js2n__-prdslib.isType
                                                                                    'Integer,
                                                                              extension =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        'Record,
                                                                                      _js2n__-prdslib.oneOf
                                                                                        [
                                                                                          _js2n__-prdslib.allOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                'Record,
                                                                                              _js2n__-prdslib.records.required
                                                                                                [
                                                                                                  "details",
                                                                                                  "type"
                                                                                                ],
                                                                                              _js2n__-prdslib.records.record
                                                                                                {
                                                                                                  details =
                                                                                                    _js2n__-prdslib.allOf
                                                                                                        [
                                                                                                          _js2n__-prdslib.isType
                                                                                                            'Record,
                                                                                                          _js2n__-prdslib.records.record
                                                                                                            {}
                                                                                                            {}
                                                                                                            true
                                                                                                            _js2n__-prdslib.always
                                                                                                        ],
                                                                                                  type =
                                                                                                    _js2n__-prdslib.allOf
                                                                                                        [
                                                                                                          _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                          _js2n__-prdslib.enum
                                                                                                            [
                                                                                                              "tcp"
                                                                                                            ]
                                                                                                        ],
                                                                                                }
                                                                                                {}
                                                                                                true
                                                                                                _js2n__-prdslib.always
                                                                                            ],
                                                                                          _js2n__-prdslib.allOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                'Record,
                                                                                              _js2n__-prdslib.records.required
                                                                                                [
                                                                                                  "details",
                                                                                                  "type"
                                                                                                ],
                                                                                              _js2n__-prdslib.records.record
                                                                                                {
                                                                                                  details =
                                                                                                    _js2n__-prdslib.allOf
                                                                                                        [
                                                                                                          _js2n__-prdslib.isType
                                                                                                            'Record,
                                                                                                          _js2n__-prdslib.records.record
                                                                                                            {
                                                                                                              caching =
                                                                                                                _js2n__-prdslib.allOf
                                                                                                                    [
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                        [
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                            'Record,
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                            'Null
                                                                                                                        ],
                                                                                                                      _js2n__-prdslib.records.record
                                                                                                                        {
                                                                                                                          files =
                                                                                                                            _js2n__-prdslib.allOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.anyOf
                                                                                                                                    [
                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                        '"Array",
                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                        'Null
                                                                                                                                    ],
                                                                                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                                                                                    (_js2n__-prdslib.allOf
                                                                                                                                      [
                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                          'Record,
                                                                                                                                        _js2n__-prdslib.records.required
                                                                                                                                          [
                                                                                                                                            "match",
                                                                                                                                            "ttl"
                                                                                                                                          ],
                                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                                          {
                                                                                                                                            "match" =
                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                  '"String",
                                                                                                                                            ttl =
                                                                                                                                              _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                                          }
                                                                                                                                          {}
                                                                                                                                          true
                                                                                                                                          _js2n__-prdslib.always
                                                                                                                                      ])
                                                                                                                                ],
                                                                                                                        }
                                                                                                                        {}
                                                                                                                        true
                                                                                                                        _js2n__-prdslib.always
                                                                                                                    ],
                                                                                                              forward =
                                                                                                                _js2n__-prdslib.allOf
                                                                                                                    [
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                        [
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                            'Record,
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                            'Null
                                                                                                                        ],
                                                                                                                      _js2n__-prdslib.records.record
                                                                                                                        {
                                                                                                                          content_mod =
                                                                                                                            _js2n__-prdslib.allOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.anyOf
                                                                                                                                    [
                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                        'Record,
                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                        'Null
                                                                                                                                    ],
                                                                                                                                  _js2n__-prdslib.records.record
                                                                                                                                    {
                                                                                                                                      replace =
                                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                                            [
                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                [
                                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                                    '"Array",
                                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                                    'Null
                                                                                                                                                ],
                                                                                                                                              _js2n__-prdslib.arrays.arrayOf
                                                                                                                                                (_js2n__-prdslib.allOf
                                                                                                                                                  [
                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                      'Record,
                                                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                                                      [
                                                                                                                                                        "match",
                                                                                                                                                        "value"
                                                                                                                                                      ],
                                                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                                                      {
                                                                                                                                                        "match" =
                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                              '"String",
                                                                                                                                                        value =
                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                              '"String",
                                                                                                                                                      }
                                                                                                                                                      {}
                                                                                                                                                      true
                                                                                                                                                      _js2n__-prdslib.always
                                                                                                                                                  ])
                                                                                                                                            ],
                                                                                                                                    }
                                                                                                                                    {}
                                                                                                                                    true
                                                                                                                                    _js2n__-prdslib.always
                                                                                                                                ],
                                                                                                                          scheme =
                                                                                                                            _js2n__-prdslib.anyOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    '"String",
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    'Null
                                                                                                                                ],
                                                                                                                        }
                                                                                                                        {}
                                                                                                                        true
                                                                                                                        _js2n__-prdslib.always
                                                                                                                    ],
                                                                                                              proxy =
                                                                                                                _js2n__-prdslib.allOf
                                                                                                                    [
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                        [
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                            'Record,
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                            'Null
                                                                                                                        ],
                                                                                                                      _js2n__-prdslib.records.record
                                                                                                                        {
                                                                                                                          content_mod =
                                                                                                                            _js2n__-prdslib.allOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.anyOf
                                                                                                                                    [
                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                        'Record,
                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                        'Null
                                                                                                                                    ],
                                                                                                                                  _js2n__-prdslib.records.record
                                                                                                                                    {
                                                                                                                                      replace =
                                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                                            [
                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                [
                                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                                    '"Array",
                                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                                    'Null
                                                                                                                                                ],
                                                                                                                                              _js2n__-prdslib.arrays.arrayOf
                                                                                                                                                (_js2n__-prdslib.allOf
                                                                                                                                                  [
                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                      'Record,
                                                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                                                      [
                                                                                                                                                        "match",
                                                                                                                                                        "value"
                                                                                                                                                      ],
                                                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                                                      {
                                                                                                                                                        "match" =
                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                              '"String",
                                                                                                                                                        value =
                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                              '"String",
                                                                                                                                                      }
                                                                                                                                                      {}
                                                                                                                                                      true
                                                                                                                                                      _js2n__-prdslib.always
                                                                                                                                                  ])
                                                                                                                                            ],
                                                                                                                                    }
                                                                                                                                    {}
                                                                                                                                    true
                                                                                                                                    _js2n__-prdslib.always
                                                                                                                                ],
                                                                                                                          domain =
                                                                                                                            _js2n__-prdslib.anyOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    '"String",
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    'Null
                                                                                                                                ],
                                                                                                                        }
                                                                                                                        {}
                                                                                                                        true
                                                                                                                        _js2n__-prdslib.always
                                                                                                                    ],
                                                                                                              redirect =
                                                                                                                _js2n__-prdslib.allOf
                                                                                                                    [
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                        [
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                            'Record,
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                            'Null
                                                                                                                        ],
                                                                                                                      _js2n__-prdslib.records.required
                                                                                                                        [
                                                                                                                          "auto_https_redirect",
                                                                                                                          "remove_www"
                                                                                                                        ],
                                                                                                                      _js2n__-prdslib.records.record
                                                                                                                        {
                                                                                                                          auto_https_redirect =
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                '"Bool",
                                                                                                                          port =
                                                                                                                            _js2n__-prdslib.anyOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    'Integer,
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    'Null
                                                                                                                                ],
                                                                                                                          remove_www =
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                '"Bool",
                                                                                                                          scheme =
                                                                                                                            _js2n__-prdslib.anyOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    '"String",
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    'Null
                                                                                                                                ],
                                                                                                                          url =
                                                                                                                            _js2n__-prdslib.anyOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    '"String",
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    'Null
                                                                                                                                ],
                                                                                                                        }
                                                                                                                        {}
                                                                                                                        true
                                                                                                                        _js2n__-prdslib.always
                                                                                                                    ],
                                                                                                            }
                                                                                                            {}
                                                                                                            true
                                                                                                            _js2n__-prdslib.always
                                                                                                        ],
                                                                                                  type =
                                                                                                    _js2n__-prdslib.allOf
                                                                                                        [
                                                                                                          _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                          _js2n__-prdslib.enum
                                                                                                            [
                                                                                                              "http"
                                                                                                            ]
                                                                                                        ],
                                                                                                }
                                                                                                {}
                                                                                                true
                                                                                                _js2n__-prdslib.always
                                                                                            ],
                                                                                          _js2n__-prdslib.allOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                'Record,
                                                                                              _js2n__-prdslib.records.required
                                                                                                [
                                                                                                  "details",
                                                                                                  "type"
                                                                                                ],
                                                                                              _js2n__-prdslib.records.record
                                                                                                {
                                                                                                  details =
                                                                                                    _js2n__-prdslib.allOf
                                                                                                        [
                                                                                                          _js2n__-prdslib.isType
                                                                                                            'Record,
                                                                                                          _js2n__-prdslib.records.record
                                                                                                            {}
                                                                                                            {}
                                                                                                            true
                                                                                                            _js2n__-prdslib.always
                                                                                                        ],
                                                                                                  type =
                                                                                                    _js2n__-prdslib.allOf
                                                                                                        [
                                                                                                          _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                          _js2n__-prdslib.enum
                                                                                                            [
                                                                                                              "udp"
                                                                                                            ]
                                                                                                        ],
                                                                                                }
                                                                                                {}
                                                                                                true
                                                                                                _js2n__-prdslib.always
                                                                                            ]
                                                                                        ]
                                                                                    ],
                                                                              sticky_sessions =
                                                                                _js2n__-prdslib.isType
                                                                                    '"Bool",
                                                                              timeouts =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        'Record,
                                                                                      _js2n__-prdslib.records.required
                                                                                        [
                                                                                          "destination_connection"
                                                                                        ],
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          destination_connection =
                                                                                            _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                        }
                                                                                        {}
                                                                                        true
                                                                                        _js2n__-prdslib.always
                                                                                    ],
                                                                              tls =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.anyOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.isType
                                                                                            'Null
                                                                                        ],
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          allow_insecure =
                                                                                            _js2n__-prdslib.anyOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    '"Bool",
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Null
                                                                                                ],
                                                                                          client_auth =
                                                                                            _js2n__-prdslib.oneOf
                                                                                                [
                                                                                                  _js2n__-prdslib.allOf
                                                                                                    [
                                                                                                      _js2n__-prdslib.isType
                                                                                                        '"String",
                                                                                                      _js2n__-prdslib.enum
                                                                                                        [
                                                                                                          "none",
                                                                                                          "request",
                                                                                                          "require",
                                                                                                          "require-verify"
                                                                                                        ]
                                                                                                    ],
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Null
                                                                                                ],
                                                                                          client_cert_auth =
                                                                                            _js2n__-prdslib.anyOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Null
                                                                                                ],
                                                                                          server_name =
                                                                                            _js2n__-prdslib.anyOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Null
                                                                                                ],
                                                                                        }
                                                                                        {}
                                                                                        true
                                                                                        _js2n__-prdslib.always
                                                                                    ],
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                  "match" =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.required
                                                                            [
                                                                              "domains",
                                                                              "internal_port"
                                                                            ],
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              domains =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.anyOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            '"Array",
                                                                                          _js2n__-prdslib.isType
                                                                                            'Null
                                                                                        ],
                                                                                      _js2n__-prdslib.arrays.arrayOf
                                                                                        (_js2n__-prdslib.isType
                                                                                          '"String")
                                                                                    ],
                                                                              internal_port =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.anyOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            '"Array",
                                                                                          _js2n__-prdslib.isType
                                                                                            'Null
                                                                                        ],
                                                                                      _js2n__-prdslib.arrays.arrayOf
                                                                                        (_js2n__-prdslib.isType
                                                                                          'Integer)
                                                                                    ],
                                                                              path =
                                                                                _js2n__-prdslib.anyOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                      _js2n__-prdslib.isType
                                                                                        'Null
                                                                                    ],
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                  mode =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"String",
                                                                          _js2n__-prdslib.enum
                                                                            [
                                                                              "random",
                                                                              "round-robin"
                                                                            ]
                                                                        ],
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ])
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/1/properties/details/properties/controllers/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "default", "identifier", "transport" ],
              _js2n__-prdslib.records.record
                {
                  "default" = _js2n__-prdslib.isType '"Bool",
                  identifier = _js2n__-prdslib.isType '"String",
                  transport =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "config", "disable", "mode", "routers" ],
                          _js2n__-prdslib.records.record
                            {
                              config =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [
                                          "ingress",
                                          "performance",
                                          "timeouts",
                                          "verbosity"
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          extension =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.required
                                                            [
                                                              "details",
                                                              "type"
                                                            ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              details =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Record,
                                                                      _js2n__-prdslib.records.required
                                                                        [
                                                                          "connections",
                                                                          "telemetry"
                                                                        ],
                                                                      _js2n__-prdslib.records.record
                                                                        {
                                                                          connections =
                                                                            _js2n__-prdslib.allOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    'Record,
                                                                                  _js2n__-prdslib.records.record
                                                                                    {}
                                                                                    {}
                                                                                    true
                                                                                    _js2n__-prdslib.always
                                                                                ],
                                                                          telemetry =
                                                                            _js2n__-prdslib.allOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    'Record,
                                                                                  _js2n__-prdslib.records.record
                                                                                    {
                                                                                      disable_router_metrics =
                                                                                        _js2n__-prdslib.isType
                                                                                            '"Bool",
                                                                                      persist_restarts =
                                                                                        _js2n__-prdslib.anyOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                '"Bool",
                                                                                              _js2n__-prdslib.isType
                                                                                                'Null
                                                                                            ],
                                                                                      tracking_window =
                                                                                        _js2n__-prdslib.anyOf
                                                                                            [
                                                                                              _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                              _js2n__-prdslib.isType
                                                                                                'Null
                                                                                            ],
                                                                                    }
                                                                                    {}
                                                                                    true
                                                                                    _js2n__-prdslib.always
                                                                                ],
                                                                        } {}
                                                                        true
                                                                        _js2n__-prdslib.always
                                                                    ],
                                                              type =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"String",
                                                                      _js2n__-prdslib.enum
                                                                        [
                                                                          "tcp"
                                                                        ]
                                                                    ],
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                      _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.required
                                                            [
                                                              "details",
                                                              "type"
                                                            ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              details =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Record,
                                                                      _js2n__-prdslib.records.required
                                                                        [
                                                                          "connections",
                                                                          "telemetry"
                                                                        ],
                                                                      _js2n__-prdslib.records.record
                                                                        {
                                                                          connections =
                                                                            _js2n__-prdslib.allOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    'Record,
                                                                                  _js2n__-prdslib.records.required
                                                                                    [
                                                                                      "max_idle_conns_per_connection"
                                                                                    ],
                                                                                  _js2n__-prdslib.records.record
                                                                                    {
                                                                                      max_idle_conns_per_connection =
                                                                                        _js2n__-prdslib.anyOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                'Integer,
                                                                                              _js2n__-prdslib.isType
                                                                                                'Null
                                                                                            ],
                                                                                    }
                                                                                    {}
                                                                                    true
                                                                                    _js2n__-prdslib.always
                                                                                ],
                                                                          telemetry =
                                                                            _js2n__-prdslib.allOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    'Record,
                                                                                  _js2n__-prdslib.records.required
                                                                                    [
                                                                                      "disable_router_metrics",
                                                                                      "disable_url_tracking"
                                                                                    ],
                                                                                  _js2n__-prdslib.records.record
                                                                                    {
                                                                                      disable_router_metrics =
                                                                                        _js2n__-prdslib.isType
                                                                                            '"Bool",
                                                                                      disable_url_tracking =
                                                                                        _js2n__-prdslib.isType
                                                                                            '"Bool",
                                                                                      group_paths =
                                                                                        _js2n__-prdslib.allOf
                                                                                            [
                                                                                              _js2n__-prdslib.anyOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Record,
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Null
                                                                                                ],
                                                                                              _js2n__-prdslib.records.record
                                                                                                {}
                                                                                                {}
                                                                                                true
                                                                                                (_js2n__-prdslib.isType
                                                                                                  '"String")
                                                                                            ],
                                                                                      ignore_paths =
                                                                                        _js2n__-prdslib.allOf
                                                                                            [
                                                                                              _js2n__-prdslib.anyOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    '"Array",
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Null
                                                                                                ],
                                                                                              _js2n__-prdslib.arrays.arrayOf
                                                                                                (_js2n__-prdslib.isType
                                                                                                  '"String")
                                                                                            ],
                                                                                      max_trackable_urls =
                                                                                        _js2n__-prdslib.anyOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                'Integer,
                                                                                              _js2n__-prdslib.isType
                                                                                                'Null
                                                                                            ],
                                                                                      persist_restarts =
                                                                                        _js2n__-prdslib.anyOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                '"Bool",
                                                                                              _js2n__-prdslib.isType
                                                                                                'Null
                                                                                            ],
                                                                                      track_invalid_requests =
                                                                                        _js2n__-prdslib.anyOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                '"Bool",
                                                                                              _js2n__-prdslib.isType
                                                                                                'Null
                                                                                            ],
                                                                                      tracking_window =
                                                                                        _js2n__-prdslib.anyOf
                                                                                            [
                                                                                              _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                              _js2n__-prdslib.isType
                                                                                                'Null
                                                                                            ],
                                                                                    }
                                                                                    {}
                                                                                    true
                                                                                    _js2n__-prdslib.always
                                                                                ],
                                                                        } {}
                                                                        true
                                                                        _js2n__-prdslib.always
                                                                    ],
                                                              type =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"String",
                                                                      _js2n__-prdslib.enum
                                                                        [
                                                                          "http"
                                                                        ]
                                                                    ],
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                      _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.required
                                                            [
                                                              "details",
                                                              "type"
                                                            ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              details =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Record,
                                                                      _js2n__-prdslib.records.required
                                                                        [
                                                                          "telemetry"
                                                                        ],
                                                                      _js2n__-prdslib.records.record
                                                                        {
                                                                          telemetry =
                                                                            _js2n__-prdslib.allOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    'Record,
                                                                                  _js2n__-prdslib.records.record
                                                                                    {
                                                                                      disable_router_metrics =
                                                                                        _js2n__-prdslib.isType
                                                                                            '"Bool",
                                                                                      persist_restarts =
                                                                                        _js2n__-prdslib.anyOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                '"Bool",
                                                                                              _js2n__-prdslib.isType
                                                                                                'Null
                                                                                            ],
                                                                                      tracking_window =
                                                                                        _js2n__-prdslib.anyOf
                                                                                            [
                                                                                              _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                              _js2n__-prdslib.isType
                                                                                                'Null
                                                                                            ],
                                                                                    }
                                                                                    {}
                                                                                    true
                                                                                    _js2n__-prdslib.always
                                                                                ],
                                                                        } {}
                                                                        true
                                                                        _js2n__-prdslib.always
                                                                    ],
                                                              type =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"String",
                                                                      _js2n__-prdslib.enum
                                                                        [
                                                                          "udp"
                                                                        ]
                                                                    ],
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ]
                                                    ]
                                                ],
                                          ingress =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "port" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      port =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      tls =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.anyOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.isType
                                                                    'Null
                                                                ],
                                                              _js2n__-prdslib.records.required
                                                                [ "enable" ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  enable =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          performance =
                                            _js2n__-prdslib.isType '"Bool",
                                          timeouts =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "idle" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      idle =
                                                        _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          verbosity =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "low",
                                                      "normal",
                                                      "high",
                                                      "debug"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              disable = _js2n__-prdslib.isType '"Bool",
                              mode =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "tcp", "udp", "http" ]
                                    ],
                              routers =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "config", "match", "mode" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                config =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.required
                                                          [
                                                            "destination_retries",
                                                            "sticky_sessions",
                                                            "timeouts"
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            destination_prioritization =
                                                              _js2n__-prdslib.oneOf
                                                                  [
                                                                    _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"String",
                                                                        _js2n__-prdslib.enum
                                                                          [
                                                                            "latency",
                                                                            "random"
                                                                          ]
                                                                      ],
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            destination_retries =
                                                              _js2n__-prdslib.isType
                                                                  'Integer,
                                                            extension =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Record,
                                                                    _js2n__-prdslib.oneOf
                                                                      [
                                                                        _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.required
                                                                              [
                                                                                "details",
                                                                                "type"
                                                                              ],
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                details =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          'Record,
                                                                                        _js2n__-prdslib.records.record
                                                                                          {}
                                                                                          {}
                                                                                          true
                                                                                          _js2n__-prdslib.always
                                                                                      ],
                                                                                type =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                        _js2n__-prdslib.enum
                                                                                          [
                                                                                            "tcp"
                                                                                          ]
                                                                                      ],
                                                                              }
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ],
                                                                        _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.required
                                                                              [
                                                                                "details",
                                                                                "type"
                                                                              ],
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                details =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          'Record,
                                                                                        _js2n__-prdslib.records.record
                                                                                          {
                                                                                            caching =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.anyOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Null
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        files =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      '"Array",
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Null
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.arrays.arrayOf
                                                                                                                  (_js2n__-prdslib.allOf
                                                                                                                    [
                                                                                                                      _js2n__-prdslib.isType
                                                                                                                        'Record,
                                                                                                                      _js2n__-prdslib.records.required
                                                                                                                        [
                                                                                                                          "match",
                                                                                                                          "ttl"
                                                                                                                        ],
                                                                                                                      _js2n__-prdslib.records.record
                                                                                                                        {
                                                                                                                          "match" =
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                '"String",
                                                                                                                          ttl =
                                                                                                                            _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                        }
                                                                                                                        {}
                                                                                                                        true
                                                                                                                        _js2n__-prdslib.always
                                                                                                                    ])
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                            forward =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.anyOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Null
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        content_mod =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Null
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.records.record
                                                                                                                  {
                                                                                                                    replace =
                                                                                                                      _js2n__-prdslib.allOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.anyOf
                                                                                                                              [
                                                                                                                                _js2n__-prdslib.isType
                                                                                                                                  '"Array",
                                                                                                                                _js2n__-prdslib.isType
                                                                                                                                  'Null
                                                                                                                              ],
                                                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                                                              (_js2n__-prdslib.allOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    'Record,
                                                                                                                                  _js2n__-prdslib.records.required
                                                                                                                                    [
                                                                                                                                      "match",
                                                                                                                                      "value"
                                                                                                                                    ],
                                                                                                                                  _js2n__-prdslib.records.record
                                                                                                                                    {
                                                                                                                                      "match" =
                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                            '"String",
                                                                                                                                      value =
                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                            '"String",
                                                                                                                                    }
                                                                                                                                    {}
                                                                                                                                    true
                                                                                                                                    _js2n__-prdslib.always
                                                                                                                                ])
                                                                                                                          ],
                                                                                                                  }
                                                                                                                  {}
                                                                                                                  true
                                                                                                                  _js2n__-prdslib.always
                                                                                                              ],
                                                                                                        scheme =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                            proxy =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.anyOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Null
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        content_mod =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Null
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.records.record
                                                                                                                  {
                                                                                                                    replace =
                                                                                                                      _js2n__-prdslib.allOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.anyOf
                                                                                                                              [
                                                                                                                                _js2n__-prdslib.isType
                                                                                                                                  '"Array",
                                                                                                                                _js2n__-prdslib.isType
                                                                                                                                  'Null
                                                                                                                              ],
                                                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                                                              (_js2n__-prdslib.allOf
                                                                                                                                [
                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                    'Record,
                                                                                                                                  _js2n__-prdslib.records.required
                                                                                                                                    [
                                                                                                                                      "match",
                                                                                                                                      "value"
                                                                                                                                    ],
                                                                                                                                  _js2n__-prdslib.records.record
                                                                                                                                    {
                                                                                                                                      "match" =
                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                            '"String",
                                                                                                                                      value =
                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                            '"String",
                                                                                                                                    }
                                                                                                                                    {}
                                                                                                                                    true
                                                                                                                                    _js2n__-prdslib.always
                                                                                                                                ])
                                                                                                                          ],
                                                                                                                  }
                                                                                                                  {}
                                                                                                                  true
                                                                                                                  _js2n__-prdslib.always
                                                                                                              ],
                                                                                                        domain =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                            redirect =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.anyOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Null
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.required
                                                                                                      [
                                                                                                        "auto_https_redirect",
                                                                                                        "remove_www"
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        auto_https_redirect =
                                                                                                          _js2n__-prdslib.isType
                                                                                                              '"Bool",
                                                                                                        port =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Integer,
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                        remove_www =
                                                                                                          _js2n__-prdslib.isType
                                                                                                              '"Bool",
                                                                                                        scheme =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                        url =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                          }
                                                                                          {}
                                                                                          true
                                                                                          _js2n__-prdslib.always
                                                                                      ],
                                                                                type =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                        _js2n__-prdslib.enum
                                                                                          [
                                                                                            "http"
                                                                                          ]
                                                                                      ],
                                                                              }
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ],
                                                                        _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.required
                                                                              [
                                                                                "details",
                                                                                "type"
                                                                              ],
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                details =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          'Record,
                                                                                        _js2n__-prdslib.records.record
                                                                                          {}
                                                                                          {}
                                                                                          true
                                                                                          _js2n__-prdslib.always
                                                                                      ],
                                                                                type =
                                                                                  _js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                        _js2n__-prdslib.enum
                                                                                          [
                                                                                            "udp"
                                                                                          ]
                                                                                      ],
                                                                              }
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ]
                                                                      ]
                                                                  ],
                                                            sticky_sessions =
                                                              _js2n__-prdslib.isType
                                                                  '"Bool",
                                                            timeouts =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Record,
                                                                    _js2n__-prdslib.records.required
                                                                      [
                                                                        "destination_connection"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        destination_connection =
                                                                          _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                      } {} true
                                                                      _js2n__-prdslib.always
                                                                  ],
                                                            tls =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        allow_insecure =
                                                                          _js2n__-prdslib.anyOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Bool",
                                                                                _js2n__-prdslib.isType
                                                                                  'Null
                                                                              ],
                                                                        client_auth =
                                                                          _js2n__-prdslib.oneOf
                                                                              [
                                                                                _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      '"String",
                                                                                    _js2n__-prdslib.enum
                                                                                      [
                                                                                        "none",
                                                                                        "request",
                                                                                        "require",
                                                                                        "require-verify"
                                                                                      ]
                                                                                  ],
                                                                                _js2n__-prdslib.isType
                                                                                  'Null
                                                                              ],
                                                                        client_cert_auth =
                                                                          _js2n__-prdslib.anyOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"String",
                                                                                _js2n__-prdslib.isType
                                                                                  'Null
                                                                              ],
                                                                        server_name =
                                                                          _js2n__-prdslib.anyOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"String",
                                                                                _js2n__-prdslib.isType
                                                                                  'Null
                                                                              ],
                                                                      } {} true
                                                                      _js2n__-prdslib.always
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                "match" =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.required
                                                          [
                                                            "domains",
                                                            "internal_port"
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            domains =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"Array",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                    _js2n__-prdslib.arrays.arrayOf
                                                                      (_js2n__-prdslib.isType
                                                                        '"String")
                                                                  ],
                                                            internal_port =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"Array",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                    _js2n__-prdslib.arrays.arrayOf
                                                                      (_js2n__-prdslib.isType
                                                                        'Integer)
                                                                  ],
                                                            path =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                mode =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "random",
                                                            "round-robin"
                                                          ]
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ])
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:properties/services/properties/vpn/anyOf/1/properties/service/anyOf/0!predicate"
        | doc "Stack spec configuration options common to all environment services. If one of these properties is defined, all must be."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  auto_update = _js2n__-prdslib.isType '"Bool",
                  enable = _js2n__-prdslib.isType '"Bool",
                  high_availability = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      about
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.required [ "description", "version" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ])
        | doc "Various properties describing this stack."
        | optional,
      annotations
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ])
        | doc "Additional meta info about the stack."
        | optional,
      containers
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required
                      [ "config", "image", "name", "stateful" ],
                    _js2n__-prdslib.records.record
                      {
                        annotations =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.isType 'Null
                                  ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                        config =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "deploy", "network" ],
                                _js2n__-prdslib.records.record
                                  {
                                    deploy =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "instances" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                constraints =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            node =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                    _js2n__-prdslib.records.required
                                                                      [
                                                                        "tags"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        tags =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    all =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    any =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                  }
                                                                                  {}
                                                                                  true
                                                                                  _js2n__-prdslib.always
                                                                              ],
                                                                      } {} true
                                                                      _js2n__-prdslib.always
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                function =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            max_pool_size =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            max_queue_time =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            max_runtime =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            max_shard_concurrency =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Integer,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                health_check =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.required
                                                          [
                                                            "command",
                                                            "interval",
                                                            "restart",
                                                            "retries",
                                                            "timeout"
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            command =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            delay =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            interval =
                                                              _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                            restart =
                                                              _js2n__-prdslib.isType
                                                                  '"Bool",
                                                            retries =
                                                              _js2n__-prdslib.isType
                                                                  'Integer,
                                                            timeout =
                                                              _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                instances =
                                                  _js2n__-prdslib.isType
                                                      'Integer,
                                                restart =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.required
                                                          [
                                                            "condition",
                                                            "delay",
                                                            "max_attempts"
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            condition =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.enum
                                                                      [
                                                                        "always",
                                                                        "never",
                                                                        "failure"
                                                                      ]
                                                                  ],
                                                            delay =
                                                              _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                            max_attempts =
                                                              _js2n__-prdslib.isType
                                                                  'Integer,
                                                            notify =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        emails =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Array",
                                                                                _js2n__-prdslib.arrays.arrayOf
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"String")
                                                                              ],
                                                                        web_hook =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} true
                                                                      _js2n__-prdslib.always
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                shutdown =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            graceful_timeout =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            signals =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"Array",
                                                                    _js2n__-prdslib.arrays.arrayOf
                                                                      (_js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"String",
                                                                          _js2n__-prdslib.enum
                                                                            [
                                                                              "SIGTERM",
                                                                              "SIGINT",
                                                                              "SIGUSR1",
                                                                              "SIGUSR2",
                                                                              "SIGHUB",
                                                                              "SIGKILL",
                                                                              "SIGQUIT"
                                                                            ]
                                                                        ])
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                startup =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            delay =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                stateful =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.required
                                                          [ "options" ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            options =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        use_base_hostname =
                                                                          _js2n__-prdslib.anyOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Bool",
                                                                                _js2n__-prdslib.isType
                                                                                  'Null
                                                                              ],
                                                                      } {} true
                                                                      _js2n__-prdslib.always
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                strategy =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"String",
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "resource-density",
                                                            "manual",
                                                            "high-availability",
                                                            "first-available",
                                                            "node",
                                                            "edge",
                                                            "function"
                                                          ]
                                                      ],
                                                telemetry =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.required
                                                          [ "disable" ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            disable =
                                                              _js2n__-prdslib.isType
                                                                  '"Bool",
                                                            interval =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            retention =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                            web_hook =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                update =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            stagger =
                                                              _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    integrations =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    backups =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.anyOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.isType
                                                                  'Null
                                                              ],
                                                            _js2n__-prdslib.records.required
                                                              [
                                                                "backup",
                                                                "destination",
                                                                "restore",
                                                                "retention"
                                                              ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                backup =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.required
                                                                          [
                                                                            "command",
                                                                            "cron_string",
                                                                            "timeout"
                                                                          ],
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            command =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            cron_string =
                                                                              _js2n__-prdslib.anyOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      '"String",
                                                                                    _js2n__-prdslib.isType
                                                                                      'Null
                                                                                  ],
                                                                            timeout =
                                                                              _js2n__-prdslib.anyOf
                                                                                  [
                                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                    _js2n__-prdslib.isType
                                                                                      'Null
                                                                                  ],
                                                                          } {}
                                                                          true
                                                                          _js2n__-prdslib.always
                                                                      ],
                                                                integration_id =
                                                                  _js2n__-refsenv."_js2n__-:properties/containers/additionalProperties/properties/image/properties/builder/properties/integration_id!predicate",
                                                                restore =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.anyOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.isType
                                                                              'Null
                                                                          ],
                                                                        _js2n__-prdslib.records.required
                                                                          [
                                                                            "command",
                                                                            "timeout"
                                                                          ],
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            command =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            timeout =
                                                                              _js2n__-prdslib.anyOf
                                                                                  [
                                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                    _js2n__-prdslib.isType
                                                                                      'Null
                                                                                  ],
                                                                          } {}
                                                                          true
                                                                          _js2n__-prdslib.always
                                                                      ],
                                                                retention =
                                                                  _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    files =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.anyOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"Array",
                                                                _js2n__-prdslib.isType
                                                                  'Null
                                                              ],
                                                            _js2n__-prdslib.arrays.arrayOf
                                                              (_js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "destination",
                                                                      "source"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      destination =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      source =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} true
                                                                    _js2n__-prdslib.always
                                                                ])
                                                          ],
                                                    lets_encrypt =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.anyOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.isType
                                                                  'Null
                                                              ],
                                                            _js2n__-prdslib.records.required
                                                              [ "enable" ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                additional_certs_path =
                                                                  _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"String",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                bundle_path =
                                                                  _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"String",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                certificate_path =
                                                                  _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"String",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                chain_path =
                                                                  _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"String",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                enable =
                                                                  _js2n__-prdslib.isType
                                                                      '"Bool",
                                                                key_path =
                                                                  _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"String",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    shared_file_systems =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.anyOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.isType
                                                                  'Null
                                                              ],
                                                            _js2n__-prdslib.records.record
                                                              {} {} true
                                                              (_js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "mount_point",
                                                                      "writable"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      mount_point =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      writable =
                                                                        _js2n__-prdslib.isType
                                                                            '"Bool",
                                                                    } {} true
                                                                    _js2n__-prdslib.always
                                                                ])
                                                          ],
                                                    webhooks =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.anyOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.isType
                                                                  'Null
                                                              ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                config =
                                                                  _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"String",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                                events =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.anyOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.isType
                                                                              'Null
                                                                          ],
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            deploy =
                                                                              _js2n__-prdslib.anyOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      '"String",
                                                                                    _js2n__-prdslib.isType
                                                                                      'Null
                                                                                  ],
                                                                            start =
                                                                              _js2n__-prdslib.anyOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      '"String",
                                                                                    _js2n__-prdslib.isType
                                                                                      'Null
                                                                                  ],
                                                                            stop =
                                                                              _js2n__-prdslib.anyOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      '"String",
                                                                                    _js2n__-prdslib.isType
                                                                                      'Null
                                                                                  ],
                                                                          } {}
                                                                          true
                                                                          _js2n__-prdslib.always
                                                                      ],
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                    network =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "hostname", "public" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                hostname =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                ports =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                                public =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "enable",
                                                            "disable",
                                                            "egress-only"
                                                          ]
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    resources =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "cpu", "ram" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    cpu =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                cpus =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                shares =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.required
                                                                          [
                                                                            "limit",
                                                                            "reserve"
                                                                          ],
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            limit =
                                                                              _js2n__-prdslib.isType
                                                                                  'Integer,
                                                                            reserve =
                                                                              _js2n__-prdslib.isType
                                                                                  'Integer,
                                                                          } {}
                                                                          true
                                                                          _js2n__-prdslib.always
                                                                      ],
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    ram =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                limit =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                reserve =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                swappiness =
                                                                  _js2n__-prdslib.isType
                                                                      '"Number",
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                    runtime =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    capabilities =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.arrays.arrayOf
                                                              (_js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "CAP_CHOWN",
                                                                      "CAP_FSETID",
                                                                      "CAP_DAC_OVERRIDE",
                                                                      "CAP_FOWNER",
                                                                      "CAP_SETFCAP",
                                                                      "CAP_SETGID",
                                                                      "CAP_SETUID",
                                                                      "CAP_KILL",
                                                                      "CAP_MKNOD",
                                                                      "CAP_NET_BIND_SERVICE",
                                                                      "CAP_NET_RAW",
                                                                      "CAP_AUDIT_WRITE",
                                                                      "CAP_SYS_CHROOT",
                                                                      "CAP_SETPCAP",
                                                                      "CAP_DAC_READ_SEARCH",
                                                                      "CAP_NET_ADMIN",
                                                                      "CAP_NET_BROADCAST",
                                                                      "CAP_SYS_ADMIN",
                                                                      "CAP_SYS_MODULE",
                                                                      "CAP_SYS_NICE",
                                                                      "CAP_SYS_PACCT",
                                                                      "CAP_SYS_PTRACE",
                                                                      "CAP_SYS_RAWIO",
                                                                      "CAP_SYS_RESOURCE",
                                                                      "CAP_SYS_BOOT",
                                                                      "CAP_SYS_TIME",
                                                                      "CAP_SYS_TTY_CONFIG",
                                                                      "CAP_SYSLOG",
                                                                      "CAP_AUDIT_CONTROL",
                                                                      "CAP_AUDIT_READ",
                                                                      "CAP_IPC_LOCK",
                                                                      "CAP_IPC_OWNER",
                                                                      "CAP_LINUX_IMMUTABLE",
                                                                      "CAP_MAC_ADMIN",
                                                                      "CAP_MAC_OVERRIDE",
                                                                      "CAP_BLOCK_SUSPEND",
                                                                      "CAP_LEASE",
                                                                      "CAP_WAKE_ALARM"
                                                                    ]
                                                                ])
                                                          ],
                                                    command =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                args =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                path =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    environment_vars =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {} {} true
                                                              (_js2n__-prdslib.isType
                                                                '"String")
                                                          ],
                                                    host =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.anyOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.isType
                                                                  'Null
                                                              ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                expose_proc =
                                                                  _js2n__-prdslib.anyOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"Bool",
                                                                        _js2n__-prdslib.isType
                                                                          'Null
                                                                      ],
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    namespaces =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.arrays.arrayOf
                                                              (_js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "ipc",
                                                                      "pid",
                                                                      "uts",
                                                                      "network",
                                                                      "mount",
                                                                      "user",
                                                                      "cgroup"
                                                                    ]
                                                                ])
                                                          ],
                                                    privileged =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    rlimits =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {} {} true
                                                              (_js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "hard",
                                                                      "soft"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      hard =
                                                                        _js2n__-prdslib.isType
                                                                            'Integer,
                                                                      soft =
                                                                        _js2n__-prdslib.isType
                                                                            'Integer,
                                                                    } {} true
                                                                    _js2n__-prdslib.always
                                                                ])
                                                          ],
                                                    rootfs =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.required
                                                              [ "readonly" ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                readonly =
                                                                  _js2n__-prdslib.isType
                                                                      '"Bool",
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    seccomp =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.required
                                                              [
                                                                "disable",
                                                                "rules"
                                                              ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                disable =
                                                                  _js2n__-prdslib.isType
                                                                      '"Bool",
                                                                rules =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"Array",
                                                                        _js2n__-prdslib.arrays.arrayOf
                                                                          (_js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.required
                                                                                [
                                                                                  "capabilities",
                                                                                  "syscall"
                                                                                ],
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  capabilities =
                                                                                    _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.records.required
                                                                                            [
                                                                                              "excludes",
                                                                                              "includes"
                                                                                            ],
                                                                                          _js2n__-prdslib.records.record
                                                                                            {
                                                                                              excludes =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              includes =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                            }
                                                                                            {}
                                                                                            true
                                                                                            _js2n__-prdslib.always
                                                                                        ],
                                                                                  syscall =
                                                                                    _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.records.required
                                                                                            [
                                                                                              "action",
                                                                                              "names"
                                                                                            ],
                                                                                          _js2n__-prdslib.records.record
                                                                                            {
                                                                                              action =
                                                                                                _js2n__-prdslib.allOf
                                                                                                    [
                                                                                                      _js2n__-prdslib.isType
                                                                                                        '"String",
                                                                                                      _js2n__-prdslib.enum
                                                                                                        [
                                                                                                          "SCMP_ACT_KILL",
                                                                                                          "SCMP_ACT_KILL_PROCESS",
                                                                                                          "SCMP_ACT_KILL_THREAD",
                                                                                                          "SCMP_ACT_TRAP",
                                                                                                          "SCMP_ACT_ERRNO",
                                                                                                          "SCMP_ACT_TRACE",
                                                                                                          "SCMP_ACT_ALLOW",
                                                                                                          "SCMP_ACT_LOG",
                                                                                                          "SCMP_ACT_NOTIFY"
                                                                                                        ]
                                                                                                    ],
                                                                                              args =
                                                                                                _js2n__-prdslib.allOf
                                                                                                    [
                                                                                                      _js2n__-prdslib.isType
                                                                                                        '"Array",
                                                                                                      _js2n__-prdslib.arrays.arrayOf
                                                                                                        (_js2n__-prdslib.allOf
                                                                                                          [
                                                                                                            _js2n__-prdslib.isType
                                                                                                              'Record,
                                                                                                            _js2n__-prdslib.records.required
                                                                                                              [
                                                                                                                "index",
                                                                                                                "op",
                                                                                                                "value"
                                                                                                              ],
                                                                                                            _js2n__-prdslib.records.record
                                                                                                              {
                                                                                                                index =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      'Integer,
                                                                                                                op =
                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                      [
                                                                                                                        _js2n__-prdslib.isType
                                                                                                                          '"String",
                                                                                                                        _js2n__-prdslib.enum
                                                                                                                          [
                                                                                                                            "SCMP_CMP_NE",
                                                                                                                            "SCMP_CMP_LT",
                                                                                                                            "SCMP_CMP_LE",
                                                                                                                            "SCMP_CMP_EQ",
                                                                                                                            "SCMP_CMP_GE",
                                                                                                                            "SCMP_CMP_GT",
                                                                                                                            "SCMP_CMP_MASKED_EQ"
                                                                                                                          ]
                                                                                                                      ],
                                                                                                                value =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      'Integer,
                                                                                                                valuetwo =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      'Integer,
                                                                                                              }
                                                                                                              {}
                                                                                                              true
                                                                                                              _js2n__-prdslib.always
                                                                                                          ])
                                                                                                    ],
                                                                                              errnoRet =
                                                                                                _js2n__-prdslib.isType
                                                                                                    'Integer,
                                                                                              names =
                                                                                                _js2n__-prdslib.allOf
                                                                                                    [
                                                                                                      _js2n__-prdslib.isType
                                                                                                        '"Array",
                                                                                                      _js2n__-prdslib.arrays.arrayOf
                                                                                                        (_js2n__-prdslib.isType
                                                                                                          '"String")
                                                                                                    ],
                                                                                            }
                                                                                            {}
                                                                                            true
                                                                                            _js2n__-prdslib.always
                                                                                        ],
                                                                                }
                                                                                {}
                                                                                true
                                                                                _js2n__-prdslib.always
                                                                            ])
                                                                      ],
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    sysctl =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {} {} true
                                                              (_js2n__-prdslib.isType
                                                                '"String")
                                                          ],
                                                    workdir =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                    scaling =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [
                                                    "autoscale_group",
                                                    "instances",
                                                    "thresholds",
                                                    "window"
                                                  ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    autoscale_group =
                                                      _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/identifier!predicate",
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                    instances =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.required
                                                              [
                                                                "max",
                                                                "max_server",
                                                                "min_ttl"
                                                              ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                max =
                                                                  _js2n__-prdslib.isType
                                                                      'Integer,
                                                                max_server =
                                                                  _js2n__-prdslib.isType
                                                                      'Integer,
                                                                min_ttl =
                                                                  _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    thresholds =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.arrays.arrayOf
                                                              (_js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.oneOf
                                                                    [
                                                                      _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.required
                                                                            [
                                                                              "details",
                                                                              "type"
                                                                            ],
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              details =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        'Record,
                                                                                      _js2n__-prdslib.records.required
                                                                                        [
                                                                                          "usage"
                                                                                        ],
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          usage =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                        }
                                                                                        {}
                                                                                        true
                                                                                        _js2n__-prdslib.always
                                                                                    ],
                                                                              type =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                      _js2n__-prdslib.enum
                                                                                        [
                                                                                          "ram"
                                                                                        ]
                                                                                    ],
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                      _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.required
                                                                            [
                                                                              "details",
                                                                              "type"
                                                                            ],
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              details =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        'Record,
                                                                                      _js2n__-prdslib.records.required
                                                                                        [
                                                                                          "utilization"
                                                                                        ],
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          utilization =
                                                                                            _js2n__-prdslib.isType
                                                                                                'Integer,
                                                                                        }
                                                                                        {}
                                                                                        true
                                                                                        _js2n__-prdslib.always
                                                                                    ],
                                                                              type =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                      _js2n__-prdslib.enum
                                                                                        [
                                                                                          "cpu"
                                                                                        ]
                                                                                    ],
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                      _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.required
                                                                            [
                                                                              "details",
                                                                              "type"
                                                                            ],
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              details =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        'Record,
                                                                                      _js2n__-prdslib.records.required
                                                                                        [
                                                                                          "connections_total"
                                                                                        ],
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          connections_total =
                                                                                            _js2n__-prdslib.isType
                                                                                                'Integer,
                                                                                        }
                                                                                        {}
                                                                                        true
                                                                                        _js2n__-prdslib.always
                                                                                    ],
                                                                              type =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                      _js2n__-prdslib.enum
                                                                                        [
                                                                                          "network-connections"
                                                                                        ]
                                                                                    ],
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                      _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.required
                                                                            [
                                                                              "details",
                                                                              "type"
                                                                            ],
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              details =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        'Record,
                                                                                      _js2n__-prdslib.records.required
                                                                                        [
                                                                                          "requests_total"
                                                                                        ],
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          requests_total =
                                                                                            _js2n__-prdslib.isType
                                                                                                'Integer,
                                                                                        }
                                                                                        {}
                                                                                        true
                                                                                        _js2n__-prdslib.always
                                                                                    ],
                                                                              type =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                      _js2n__-prdslib.enum
                                                                                        [
                                                                                          "network-requests"
                                                                                        ]
                                                                                    ],
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                      _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.required
                                                                            [
                                                                              "details",
                                                                              "type"
                                                                            ],
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              details =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        'Record,
                                                                                      _js2n__-prdslib.records.required
                                                                                        [
                                                                                          "bandwidth",
                                                                                          "private"
                                                                                        ],
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          bandwidth =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                          private =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"Bool",
                                                                                        }
                                                                                        {}
                                                                                        true
                                                                                        _js2n__-prdslib.always
                                                                                    ],
                                                                              type =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                      _js2n__-prdslib.enum
                                                                                        [
                                                                                          "network-throughput"
                                                                                        ]
                                                                                    ],
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ]
                                                                    ]
                                                                ])
                                                          ],
                                                    window =
                                                      _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ],
                        deprecate = _js2n__-prdslib.isType '"Bool",
                        image =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "origin" ],
                                _js2n__-prdslib.records.record
                                  {
                                    build =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.isType 'Null
                                              ],
                                            _js2n__-prdslib.records.required
                                              [ "args" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                args =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {} {} true
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    builder =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.isType 'Null
                                              ],
                                            _js2n__-prdslib.records.required
                                              [ "integration_id" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                integration_id =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    name =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                    origin =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "details", "type" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        details =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.required
                                                                  [ "target" ],
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    existing =
                                                                      _js2n__-prdslib.anyOf
                                                                          [
                                                                            _js2n__-refsenv."_js2n__-:properties/containers/additionalProperties/properties/image/properties/origin/oneOf/2/properties/details/properties/existing!predicate",
                                                                            _js2n__-prdslib.isType
                                                                              'Null
                                                                          ],
                                                                    target =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    token =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    username =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        type =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.enum
                                                                  [
                                                                    "docker-hub"
                                                                  ]
                                                              ],
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "details", "type" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        details =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    build_file =
                                                                      _js2n__-prdslib.anyOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              '"String",
                                                                            _js2n__-prdslib.isType
                                                                              'Null
                                                                          ],
                                                                    context_dir =
                                                                      _js2n__-prdslib.anyOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              '"String",
                                                                            _js2n__-prdslib.isType
                                                                              'Null
                                                                          ],
                                                                    credentials =
                                                                      _js2n__-prdslib.anyOf
                                                                          [
                                                                            _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Array",
                                                                                _js2n__-prdslib.arrays.arrayOf
                                                                                  (_js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        'Record,
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          token =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                          url =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                          username =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                        }
                                                                                        {}
                                                                                        true
                                                                                        _js2n__-prdslib.always
                                                                                    ])
                                                                              ],
                                                                            _js2n__-prdslib.isType
                                                                              'Null
                                                                          ],
                                                                    existing =
                                                                      _js2n__-prdslib.anyOf
                                                                          [
                                                                            _js2n__-refsenv."_js2n__-:properties/containers/additionalProperties/properties/image/properties/origin/oneOf/2/properties/details/properties/existing!predicate",
                                                                            _js2n__-prdslib.isType
                                                                              'Null
                                                                          ],
                                                                    repo =
                                                                      _js2n__-prdslib.anyOf
                                                                          [
                                                                            _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.required
                                                                                  [
                                                                                    "url"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    auth =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.anyOf
                                                                                              [
                                                                                                _js2n__-prdslib.isType
                                                                                                  'Record,
                                                                                                _js2n__-prdslib.isType
                                                                                                  'Null
                                                                                              ],
                                                                                            _js2n__-prdslib.oneOf
                                                                                              [
                                                                                                _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.isType
                                                                                                      'Record,
                                                                                                    _js2n__-prdslib.records.required
                                                                                                      [
                                                                                                        "credentials",
                                                                                                        "type"
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        credentials =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Record,
                                                                                                                _js2n__-prdslib.records.required
                                                                                                                  [
                                                                                                                    "password",
                                                                                                                    "username"
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.records.record
                                                                                                                  {
                                                                                                                    password =
                                                                                                                      _js2n__-prdslib.isType
                                                                                                                          '"String",
                                                                                                                    username =
                                                                                                                      _js2n__-prdslib.isType
                                                                                                                          '"String",
                                                                                                                  }
                                                                                                                  {}
                                                                                                                  true
                                                                                                                  _js2n__-prdslib.always
                                                                                                              ],
                                                                                                        type =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                                _js2n__-prdslib.enum
                                                                                                                  [
                                                                                                                    "http"
                                                                                                                  ]
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                                _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.isType
                                                                                                      'Record,
                                                                                                    _js2n__-prdslib.records.required
                                                                                                      [
                                                                                                        "credentials",
                                                                                                        "type"
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        credentials =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Record,
                                                                                                                _js2n__-prdslib.records.required
                                                                                                                  [
                                                                                                                    "passphrase",
                                                                                                                    "private_key",
                                                                                                                    "username"
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.records.record
                                                                                                                  {
                                                                                                                    passphrase =
                                                                                                                      _js2n__-prdslib.isType
                                                                                                                          '"String",
                                                                                                                    private_key =
                                                                                                                      _js2n__-prdslib.isType
                                                                                                                          '"String",
                                                                                                                    username =
                                                                                                                      _js2n__-prdslib.isType
                                                                                                                          '"String",
                                                                                                                  }
                                                                                                                  {}
                                                                                                                  true
                                                                                                                  _js2n__-prdslib.always
                                                                                                              ],
                                                                                                        type =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                                _js2n__-prdslib.enum
                                                                                                                  [
                                                                                                                    "ssh"
                                                                                                                  ]
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ]
                                                                                              ]
                                                                                          ],
                                                                                    branch =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    ref =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.anyOf
                                                                                              [
                                                                                                _js2n__-prdslib.isType
                                                                                                  'Record,
                                                                                                _js2n__-prdslib.isType
                                                                                                  'Null
                                                                                              ],
                                                                                            _js2n__-prdslib.records.required
                                                                                              [
                                                                                                "type",
                                                                                                "value"
                                                                                              ],
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                type =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                value =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              true
                                                                                              _js2n__-prdslib.always
                                                                                          ],
                                                                                    url =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  true
                                                                                  _js2n__-prdslib.always
                                                                              ],
                                                                            _js2n__-prdslib.isType
                                                                              'Null
                                                                          ],
                                                                    targz_url =
                                                                      _js2n__-prdslib.anyOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              '"String",
                                                                            _js2n__-prdslib.isType
                                                                              'Null
                                                                          ],
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        type =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.enum
                                                                  [
                                                                    "docker-file"
                                                                  ]
                                                              ],
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "details", "type" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        details =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.required
                                                                  [
                                                                    "target",
                                                                    "url"
                                                                  ],
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    existing =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                source_id =
                                                                                  _js2n__-refsenv."_js2n__-:properties/containers/additionalProperties/properties/image/properties/origin/oneOf/4/properties/details/properties/source_id!predicate",
                                                                              }
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ],
                                                                    password =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    target =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    token =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    url =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    username =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        type =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.enum
                                                                  [
                                                                    "docker-registry"
                                                                  ]
                                                              ],
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "details", "type" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        details =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.required
                                                                  [
                                                                    "target",
                                                                    "url"
                                                                  ],
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    auth =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.oneOf
                                                                              [
                                                                                _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.required
                                                                                      [
                                                                                        "details",
                                                                                        "type"
                                                                                      ],
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        details =
                                                                                          _js2n__-prdslib.allOf
                                                                                              [
                                                                                                _js2n__-prdslib.isType
                                                                                                  'Record,
                                                                                                _js2n__-prdslib.records.record
                                                                                                  {
                                                                                                    token =
                                                                                                      _js2n__-prdslib.isType
                                                                                                          '"String",
                                                                                                    username =
                                                                                                      _js2n__-prdslib.isType
                                                                                                          '"String",
                                                                                                  }
                                                                                                  {}
                                                                                                  true
                                                                                                  _js2n__-prdslib.always
                                                                                              ],
                                                                                        type =
                                                                                          _js2n__-prdslib.allOf
                                                                                              [
                                                                                                _js2n__-prdslib.isType
                                                                                                  '"String",
                                                                                                _js2n__-prdslib.enum
                                                                                                  [
                                                                                                    "user"
                                                                                                  ]
                                                                                              ],
                                                                                      }
                                                                                      {}
                                                                                      true
                                                                                      _js2n__-prdslib.always
                                                                                  ],
                                                                                _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.required
                                                                                      [
                                                                                        "details",
                                                                                        "type"
                                                                                      ],
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        details =
                                                                                          _js2n__-prdslib.allOf
                                                                                              [
                                                                                                _js2n__-prdslib.isType
                                                                                                  'Record,
                                                                                                _js2n__-prdslib.records.required
                                                                                                  [
                                                                                                    "credentials",
                                                                                                    "flavor"
                                                                                                  ],
                                                                                                _js2n__-prdslib.records.record
                                                                                                  {
                                                                                                    credentials =
                                                                                                      _js2n__-prdslib.allOf
                                                                                                          [
                                                                                                            _js2n__-prdslib.isType
                                                                                                              'Record,
                                                                                                            _js2n__-prdslib.records.record
                                                                                                              {
                                                                                                                api_key =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      '"String",
                                                                                                                client_id =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      '"String",
                                                                                                                config =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      '"String",
                                                                                                                namespace =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      '"String",
                                                                                                                region =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      '"String",
                                                                                                                secret =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      '"String",
                                                                                                                subscription_id =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      '"String",
                                                                                                              }
                                                                                                              {}
                                                                                                              true
                                                                                                              _js2n__-prdslib.always
                                                                                                          ],
                                                                                                    flavor =
                                                                                                      _js2n__-prdslib.allOf
                                                                                                          [
                                                                                                            _js2n__-prdslib.isType
                                                                                                              '"String",
                                                                                                            _js2n__-prdslib.enum
                                                                                                              [
                                                                                                                "ecr"
                                                                                                              ]
                                                                                                          ],
                                                                                                  }
                                                                                                  {}
                                                                                                  true
                                                                                                  _js2n__-prdslib.always
                                                                                              ],
                                                                                        type =
                                                                                          _js2n__-prdslib.allOf
                                                                                              [
                                                                                                _js2n__-prdslib.isType
                                                                                                  '"String",
                                                                                                _js2n__-prdslib.enum
                                                                                                  [
                                                                                                    "provider"
                                                                                                  ]
                                                                                              ],
                                                                                      }
                                                                                      {}
                                                                                      true
                                                                                      _js2n__-prdslib.always
                                                                                  ],
                                                                                _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.required
                                                                                      [
                                                                                        "details",
                                                                                        "type"
                                                                                      ],
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        details =
                                                                                          _js2n__-prdslib.allOf
                                                                                              [
                                                                                                _js2n__-prdslib.isType
                                                                                                  'Record,
                                                                                                _js2n__-prdslib.records.required
                                                                                                  [
                                                                                                    "url"
                                                                                                  ],
                                                                                                _js2n__-prdslib.records.record
                                                                                                  {
                                                                                                    url =
                                                                                                      _js2n__-prdslib.isType
                                                                                                          '"String",
                                                                                                  }
                                                                                                  {}
                                                                                                  true
                                                                                                  _js2n__-prdslib.always
                                                                                              ],
                                                                                        type =
                                                                                          _js2n__-prdslib.allOf
                                                                                              [
                                                                                                _js2n__-prdslib.isType
                                                                                                  '"String",
                                                                                                _js2n__-prdslib.enum
                                                                                                  [
                                                                                                    "webhook"
                                                                                                  ]
                                                                                              ],
                                                                                      }
                                                                                      {}
                                                                                      true
                                                                                      _js2n__-prdslib.always
                                                                                  ],
                                                                                _js2n__-prdslib.isType
                                                                                  'Null
                                                                              ]
                                                                          ],
                                                                    existing =
                                                                      _js2n__-refsenv."_js2n__-:properties/containers/additionalProperties/properties/image/properties/origin/oneOf/2/properties/details/properties/existing!predicate",
                                                                    target =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    url =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        type =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.enum
                                                                  [
                                                                    "oci-registry"
                                                                  ]
                                                              ],
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "details", "type" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        details =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.required
                                                                  [
                                                                    "source_id"
                                                                  ],
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    source_id =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        type =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.enum
                                                                  [
                                                                    "cycle-source"
                                                                  ]
                                                              ],
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ]
                                              ]
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ],
                        lock = _js2n__-prdslib.isType '"Bool",
                        name = _js2n__-prdslib.isType '"String",
                        role =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.isType 'Null
                                  ],
                                _js2n__-prdslib.enum [ "conductor" ]
                              ],
                        stateful = _js2n__-prdslib.isType '"Bool",
                        volumes =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.isType 'Null
                                  ],
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "destination", "read_only" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          destination =
                                            _js2n__-prdslib.isType '"String",
                                          local =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "max_size" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      max_size =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      storage_pool =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          read_only =
                                            _js2n__-prdslib.isType '"Bool",
                                          remote_access =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "enable", "password" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      enable =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      ips =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      password =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.required
                                                                [
                                                                  "algorithm",
                                                                  "data"
                                                                ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  algorithm =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"String",
                                                                          _js2n__-prdslib.enum
                                                                            [
                                                                              "raw",
                                                                              "sha512",
                                                                              "md5"
                                                                            ]
                                                                        ],
                                                                  data =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      web_hook =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ])
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "A mapping of containers that will be deployed as a part of this stack. The key is used as the container's identifier.",
      scoped_variables
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required
                      [ "access", "identifier", "scope" ],
                    _js2n__-prdslib.records.record
                      {
                        access =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    env_variable =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.isType 'Null
                                              ],
                                            _js2n__-prdslib.records.required
                                              [ "key" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                key =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    file =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.isType 'Null
                                              ],
                                            _js2n__-prdslib.records.required
                                              [ "decode", "path" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                decode =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                path =
                                                  _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.isType
                                                          'Null
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    internal_api =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.isType 'Null
                                              ],
                                            _js2n__-prdslib.records.record
                                              {
                                                duration =
                                                  _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.isType
                                                          'Null
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ],
                        identifier = _js2n__-prdslib.isType '"String",
                        scope =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "containers" ],
                                _js2n__-prdslib.records.record
                                  {
                                    containers =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "global" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                global =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                identifiers =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/identifier!predicate"
                                                      ],
                                                ids =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.isType
                                                              'Null
                                                          ],
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ],
                        source =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.isType 'Null
                                  ],
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "details", "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            details =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [
                                                        "auth_token_url",
                                                        "headers",
                                                        "url"
                                                      ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        auth_token_url =
                                                          _js2n__-prdslib.anyOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.isType
                                                                  'Null
                                                              ],
                                                        headers =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.record
                                                                  {} {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        url =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            type =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [ "url" ]
                                                  ],
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "details", "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            details =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "blob", "value" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        blob =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                        secret =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.anyOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Record,
                                                                    _js2n__-prdslib.isType
                                                                      'Null
                                                                  ],
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    hint =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    iv =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        value =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            type =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [ "raw" ]
                                                  ],
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ]
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "Describes variables that are assigned to one or more containers at runtime. Can be assigned as an environment variable, written as a file inside the container(s), or accessed over the internal API."
        | optional,
      services
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record
                {
                  discovery =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  config =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  empty_set_delay =
                                                    _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                          _js2n__-prdslib.isType
                                                            'Null
                                                        ],
                                                  hosts =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.anyOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.isType
                                                                'Null
                                                            ],
                                                          _js2n__-prdslib.records.record
                                                            {} {} true
                                                            (_js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    ipv4 =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.anyOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Array",
                                                                                _js2n__-prdslib.isType
                                                                                  'Null
                                                                              ],
                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                              (_js2n__-prdslib.isType
                                                                                '"String")
                                                                          ],
                                                                    ipv6 =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.anyOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Array",
                                                                                _js2n__-prdslib.isType
                                                                                  'Null
                                                                              ],
                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                              (_js2n__-prdslib.isType
                                                                                '"String")
                                                                          ],
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ])
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                  service =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:properties/services/properties/vpn/anyOf/1/properties/service/anyOf/0!predicate",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  loadbalancer =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  config =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [
                                                          "details",
                                                          "ipv4",
                                                          "ipv6",
                                                          "type"
                                                        ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          bind_host =
                                                            _js2n__-prdslib.anyOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Bool",
                                                                  _js2n__-prdslib.isType
                                                                    'Null
                                                                ],
                                                          details =
                                                            _js2n__-prdslib.anyOf
                                                                [
                                                                  _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Record,
                                                                      _js2n__-prdslib.records.required
                                                                        [
                                                                          "default",
                                                                          "ports"
                                                                        ],
                                                                      _js2n__-prdslib.records.record
                                                                        {
                                                                          "default" =
                                                                            _js2n__-refsenv."_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/0/properties/details/anyOf/0/properties/ports/additionalProperties!predicate",
                                                                          ports =
                                                                            _js2n__-prdslib.allOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    'Record,
                                                                                  _js2n__-prdslib.records.record
                                                                                    {}
                                                                                    {}
                                                                                    true
                                                                                    (_js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          'Record,
                                                                                        _js2n__-prdslib.records.required
                                                                                          [
                                                                                            "backend",
                                                                                            "frontend"
                                                                                          ],
                                                                                        _js2n__-prdslib.records.record
                                                                                          {
                                                                                            backend =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.isType
                                                                                                      'Record,
                                                                                                    _js2n__-prdslib.records.required
                                                                                                      [
                                                                                                        "balance",
                                                                                                        "timeouts"
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        balance =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                                _js2n__-prdslib.enum
                                                                                                                  [
                                                                                                                    "roundrobin",
                                                                                                                    "static-rr",
                                                                                                                    "leastconn",
                                                                                                                    "first",
                                                                                                                    "source"
                                                                                                                  ]
                                                                                                              ],
                                                                                                        timeouts =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Null
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.records.required
                                                                                                                  [
                                                                                                                    "connect_ms",
                                                                                                                    "queue_ms",
                                                                                                                    "server_fin_ms",
                                                                                                                    "server_secs",
                                                                                                                    "tunnel_secs"
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.records.record
                                                                                                                  {
                                                                                                                    connect_ms =
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Integer,
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Null
                                                                                                                          ],
                                                                                                                    queue_ms =
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Integer,
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Null
                                                                                                                          ],
                                                                                                                    server_fin_ms =
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Integer,
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Null
                                                                                                                          ],
                                                                                                                    server_secs =
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Integer,
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Null
                                                                                                                          ],
                                                                                                                    tunnel_secs =
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Integer,
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Null
                                                                                                                          ],
                                                                                                                  }
                                                                                                                  {}
                                                                                                                  true
                                                                                                                  _js2n__-prdslib.always
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                            frontend =
                                                                                              _js2n__-prdslib.allOf
                                                                                                  [
                                                                                                    _js2n__-prdslib.isType
                                                                                                      'Record,
                                                                                                    _js2n__-prdslib.records.required
                                                                                                      [
                                                                                                        "max_connections",
                                                                                                        "mode",
                                                                                                        "timeouts"
                                                                                                      ],
                                                                                                    _js2n__-prdslib.records.record
                                                                                                      {
                                                                                                        max_connections =
                                                                                                          _js2n__-prdslib.anyOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Integer,
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  'Null
                                                                                                              ],
                                                                                                        mode =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                                _js2n__-prdslib.enum
                                                                                                                  [
                                                                                                                    "tcp",
                                                                                                                    "http"
                                                                                                                  ]
                                                                                                              ],
                                                                                                        timeouts =
                                                                                                          _js2n__-prdslib.allOf
                                                                                                              [
                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Null
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.records.required
                                                                                                                  [
                                                                                                                    "client_fin_ms",
                                                                                                                    "client_secs",
                                                                                                                    "http_keep_alive_ms",
                                                                                                                    "http_request_ms"
                                                                                                                  ],
                                                                                                                _js2n__-prdslib.records.record
                                                                                                                  {
                                                                                                                    client_fin_ms =
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Integer,
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Null
                                                                                                                          ],
                                                                                                                    client_secs =
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Integer,
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Null
                                                                                                                          ],
                                                                                                                    http_keep_alive_ms =
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Integer,
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Null
                                                                                                                          ],
                                                                                                                    http_request_ms =
                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Integer,
                                                                                                                            _js2n__-prdslib.isType
                                                                                                                              'Null
                                                                                                                          ],
                                                                                                                  }
                                                                                                                  {}
                                                                                                                  true
                                                                                                                  _js2n__-prdslib.always
                                                                                                              ],
                                                                                                      }
                                                                                                      {}
                                                                                                      true
                                                                                                      _js2n__-prdslib.always
                                                                                                  ],
                                                                                          }
                                                                                          {}
                                                                                          true
                                                                                          _js2n__-prdslib.always
                                                                                      ])
                                                                                ],
                                                                        } {}
                                                                        true
                                                                        _js2n__-prdslib.always
                                                                    ],
                                                                  _js2n__-prdslib.isType
                                                                    'Null
                                                                ],
                                                          ipv4 =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          ipv6 =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          type =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "haproxy"
                                                                    ]
                                                                ],
                                                        } {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                                  _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [
                                                          "details",
                                                          "ipv4",
                                                          "ipv6",
                                                          "type"
                                                        ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          bind_host =
                                                            _js2n__-prdslib.anyOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Bool",
                                                                  _js2n__-prdslib.isType
                                                                    'Null
                                                                ],
                                                          details =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "controllers"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      controller_template =
                                                                        _js2n__-prdslib.anyOf
                                                                            [
                                                                              _js2n__-refsenv."_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/1/properties/details/properties/controllers/items!predicate",
                                                                              _js2n__-prdslib.isType
                                                                                'Null
                                                                            ],
                                                                      controllers =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                '"Array",
                                                                              _js2n__-prdslib.arrays.arrayOf
                                                                                (_js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.required
                                                                                      [
                                                                                        "default",
                                                                                        "identifier",
                                                                                        "transport"
                                                                                      ],
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        "default" =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"Bool",
                                                                                        identifier =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        transport =
                                                                                          _js2n__-prdslib.allOf
                                                                                              [
                                                                                                _js2n__-prdslib.isType
                                                                                                  'Record,
                                                                                                _js2n__-prdslib.records.required
                                                                                                  [
                                                                                                    "config",
                                                                                                    "disable",
                                                                                                    "mode",
                                                                                                    "routers"
                                                                                                  ],
                                                                                                _js2n__-prdslib.records.record
                                                                                                  {
                                                                                                    config =
                                                                                                      _js2n__-prdslib.allOf
                                                                                                          [
                                                                                                            _js2n__-prdslib.isType
                                                                                                              'Record,
                                                                                                            _js2n__-prdslib.records.required
                                                                                                              [
                                                                                                                "ingress",
                                                                                                                "performance",
                                                                                                                "timeouts",
                                                                                                                "verbosity"
                                                                                                              ],
                                                                                                            _js2n__-prdslib.records.record
                                                                                                              {
                                                                                                                extension =
                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                      [
                                                                                                                        _js2n__-prdslib.isType
                                                                                                                          'Record,
                                                                                                                        _js2n__-prdslib.oneOf
                                                                                                                          [
                                                                                                                            _js2n__-prdslib.allOf
                                                                                                                              [
                                                                                                                                _js2n__-prdslib.isType
                                                                                                                                  'Record,
                                                                                                                                _js2n__-prdslib.records.required
                                                                                                                                  [
                                                                                                                                    "details",
                                                                                                                                    "type"
                                                                                                                                  ],
                                                                                                                                _js2n__-prdslib.records.record
                                                                                                                                  {
                                                                                                                                    details =
                                                                                                                                      _js2n__-prdslib.allOf
                                                                                                                                          [
                                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                              'Record,
                                                                                                                                            _js2n__-prdslib.records.required
                                                                                                                                              [
                                                                                                                                                "connections",
                                                                                                                                                "telemetry"
                                                                                                                                              ],
                                                                                                                                            _js2n__-prdslib.records.record
                                                                                                                                              {
                                                                                                                                                connections =
                                                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                                                      [
                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                          'Record,
                                                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                                                          {}
                                                                                                                                                          {}
                                                                                                                                                          true
                                                                                                                                                          _js2n__-prdslib.always
                                                                                                                                                      ],
                                                                                                                                                telemetry =
                                                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                                                      [
                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                          'Record,
                                                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                                                          {
                                                                                                                                                            disable_router_metrics =
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                  '"Bool",
                                                                                                                                                            persist_restarts =
                                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      '"Bool",
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Null
                                                                                                                                                                  ],
                                                                                                                                                            tracking_window =
                                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Null
                                                                                                                                                                  ],
                                                                                                                                                          }
                                                                                                                                                          {}
                                                                                                                                                          true
                                                                                                                                                          _js2n__-prdslib.always
                                                                                                                                                      ],
                                                                                                                                              }
                                                                                                                                              {}
                                                                                                                                              true
                                                                                                                                              _js2n__-prdslib.always
                                                                                                                                          ],
                                                                                                                                    type =
                                                                                                                                      _js2n__-prdslib.allOf
                                                                                                                                          [
                                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                              '"String",
                                                                                                                                            _js2n__-prdslib.enum
                                                                                                                                              [
                                                                                                                                                "tcp"
                                                                                                                                              ]
                                                                                                                                          ],
                                                                                                                                  }
                                                                                                                                  {}
                                                                                                                                  true
                                                                                                                                  _js2n__-prdslib.always
                                                                                                                              ],
                                                                                                                            _js2n__-prdslib.allOf
                                                                                                                              [
                                                                                                                                _js2n__-prdslib.isType
                                                                                                                                  'Record,
                                                                                                                                _js2n__-prdslib.records.required
                                                                                                                                  [
                                                                                                                                    "details",
                                                                                                                                    "type"
                                                                                                                                  ],
                                                                                                                                _js2n__-prdslib.records.record
                                                                                                                                  {
                                                                                                                                    details =
                                                                                                                                      _js2n__-prdslib.allOf
                                                                                                                                          [
                                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                              'Record,
                                                                                                                                            _js2n__-prdslib.records.required
                                                                                                                                              [
                                                                                                                                                "connections",
                                                                                                                                                "telemetry"
                                                                                                                                              ],
                                                                                                                                            _js2n__-prdslib.records.record
                                                                                                                                              {
                                                                                                                                                connections =
                                                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                                                      [
                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                          'Record,
                                                                                                                                                        _js2n__-prdslib.records.required
                                                                                                                                                          [
                                                                                                                                                            "max_idle_conns_per_connection"
                                                                                                                                                          ],
                                                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                                                          {
                                                                                                                                                            max_idle_conns_per_connection =
                                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Integer,
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Null
                                                                                                                                                                  ],
                                                                                                                                                          }
                                                                                                                                                          {}
                                                                                                                                                          true
                                                                                                                                                          _js2n__-prdslib.always
                                                                                                                                                      ],
                                                                                                                                                telemetry =
                                                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                                                      [
                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                          'Record,
                                                                                                                                                        _js2n__-prdslib.records.required
                                                                                                                                                          [
                                                                                                                                                            "disable_router_metrics",
                                                                                                                                                            "disable_url_tracking"
                                                                                                                                                          ],
                                                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                                                          {
                                                                                                                                                            disable_router_metrics =
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                  '"Bool",
                                                                                                                                                            disable_url_tracking =
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                  '"Bool",
                                                                                                                                                            group_paths =
                                                                                                                                                              _js2n__-prdslib.allOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-prdslib.anyOf
                                                                                                                                                                      [
                                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                                          'Record,
                                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                                          'Null
                                                                                                                                                                      ],
                                                                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                                                                      {}
                                                                                                                                                                      {}
                                                                                                                                                                      true
                                                                                                                                                                      (_js2n__-prdslib.isType
                                                                                                                                                                        '"String")
                                                                                                                                                                  ],
                                                                                                                                                            ignore_paths =
                                                                                                                                                              _js2n__-prdslib.allOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-prdslib.anyOf
                                                                                                                                                                      [
                                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                                          '"Array",
                                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                                          'Null
                                                                                                                                                                      ],
                                                                                                                                                                    _js2n__-prdslib.arrays.arrayOf
                                                                                                                                                                      (_js2n__-prdslib.isType
                                                                                                                                                                        '"String")
                                                                                                                                                                  ],
                                                                                                                                                            max_trackable_urls =
                                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Integer,
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Null
                                                                                                                                                                  ],
                                                                                                                                                            persist_restarts =
                                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      '"Bool",
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Null
                                                                                                                                                                  ],
                                                                                                                                                            track_invalid_requests =
                                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      '"Bool",
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Null
                                                                                                                                                                  ],
                                                                                                                                                            tracking_window =
                                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Null
                                                                                                                                                                  ],
                                                                                                                                                          }
                                                                                                                                                          {}
                                                                                                                                                          true
                                                                                                                                                          _js2n__-prdslib.always
                                                                                                                                                      ],
                                                                                                                                              }
                                                                                                                                              {}
                                                                                                                                              true
                                                                                                                                              _js2n__-prdslib.always
                                                                                                                                          ],
                                                                                                                                    type =
                                                                                                                                      _js2n__-prdslib.allOf
                                                                                                                                          [
                                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                              '"String",
                                                                                                                                            _js2n__-prdslib.enum
                                                                                                                                              [
                                                                                                                                                "http"
                                                                                                                                              ]
                                                                                                                                          ],
                                                                                                                                  }
                                                                                                                                  {}
                                                                                                                                  true
                                                                                                                                  _js2n__-prdslib.always
                                                                                                                              ],
                                                                                                                            _js2n__-prdslib.allOf
                                                                                                                              [
                                                                                                                                _js2n__-prdslib.isType
                                                                                                                                  'Record,
                                                                                                                                _js2n__-prdslib.records.required
                                                                                                                                  [
                                                                                                                                    "details",
                                                                                                                                    "type"
                                                                                                                                  ],
                                                                                                                                _js2n__-prdslib.records.record
                                                                                                                                  {
                                                                                                                                    details =
                                                                                                                                      _js2n__-prdslib.allOf
                                                                                                                                          [
                                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                              'Record,
                                                                                                                                            _js2n__-prdslib.records.required
                                                                                                                                              [
                                                                                                                                                "telemetry"
                                                                                                                                              ],
                                                                                                                                            _js2n__-prdslib.records.record
                                                                                                                                              {
                                                                                                                                                telemetry =
                                                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                                                      [
                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                          'Record,
                                                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                                                          {
                                                                                                                                                            disable_router_metrics =
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                  '"Bool",
                                                                                                                                                            persist_restarts =
                                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      '"Bool",
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Null
                                                                                                                                                                  ],
                                                                                                                                                            tracking_window =
                                                                                                                                                              _js2n__-prdslib.anyOf
                                                                                                                                                                  [
                                                                                                                                                                    _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                                                      'Null
                                                                                                                                                                  ],
                                                                                                                                                          }
                                                                                                                                                          {}
                                                                                                                                                          true
                                                                                                                                                          _js2n__-prdslib.always
                                                                                                                                                      ],
                                                                                                                                              }
                                                                                                                                              {}
                                                                                                                                              true
                                                                                                                                              _js2n__-prdslib.always
                                                                                                                                          ],
                                                                                                                                    type =
                                                                                                                                      _js2n__-prdslib.allOf
                                                                                                                                          [
                                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                              '"String",
                                                                                                                                            _js2n__-prdslib.enum
                                                                                                                                              [
                                                                                                                                                "udp"
                                                                                                                                              ]
                                                                                                                                          ],
                                                                                                                                  }
                                                                                                                                  {}
                                                                                                                                  true
                                                                                                                                  _js2n__-prdslib.always
                                                                                                                              ]
                                                                                                                          ]
                                                                                                                      ],
                                                                                                                ingress =
                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                      [
                                                                                                                        _js2n__-prdslib.isType
                                                                                                                          'Record,
                                                                                                                        _js2n__-prdslib.records.required
                                                                                                                          [
                                                                                                                            "port"
                                                                                                                          ],
                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                          {
                                                                                                                            port =
                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                  'Integer,
                                                                                                                            tls =
                                                                                                                              _js2n__-prdslib.allOf
                                                                                                                                  [
                                                                                                                                    _js2n__-prdslib.anyOf
                                                                                                                                      [
                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                          'Record,
                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                          'Null
                                                                                                                                      ],
                                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                                      [
                                                                                                                                        "enable"
                                                                                                                                      ],
                                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                                      {
                                                                                                                                        enable =
                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                              '"Bool",
                                                                                                                                      }
                                                                                                                                      {}
                                                                                                                                      true
                                                                                                                                      _js2n__-prdslib.always
                                                                                                                                  ],
                                                                                                                          }
                                                                                                                          {}
                                                                                                                          true
                                                                                                                          _js2n__-prdslib.always
                                                                                                                      ],
                                                                                                                performance =
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                      '"Bool",
                                                                                                                timeouts =
                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                      [
                                                                                                                        _js2n__-prdslib.isType
                                                                                                                          'Record,
                                                                                                                        _js2n__-prdslib.records.required
                                                                                                                          [
                                                                                                                            "idle"
                                                                                                                          ],
                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                          {
                                                                                                                            idle =
                                                                                                                              _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                          }
                                                                                                                          {}
                                                                                                                          true
                                                                                                                          _js2n__-prdslib.always
                                                                                                                      ],
                                                                                                                verbosity =
                                                                                                                  _js2n__-prdslib.allOf
                                                                                                                      [
                                                                                                                        _js2n__-prdslib.isType
                                                                                                                          '"String",
                                                                                                                        _js2n__-prdslib.enum
                                                                                                                          [
                                                                                                                            "low",
                                                                                                                            "normal",
                                                                                                                            "high",
                                                                                                                            "debug"
                                                                                                                          ]
                                                                                                                      ],
                                                                                                              }
                                                                                                              {}
                                                                                                              true
                                                                                                              _js2n__-prdslib.always
                                                                                                          ],
                                                                                                    disable =
                                                                                                      _js2n__-prdslib.isType
                                                                                                          '"Bool",
                                                                                                    mode =
                                                                                                      _js2n__-prdslib.allOf
                                                                                                          [
                                                                                                            _js2n__-prdslib.isType
                                                                                                              '"String",
                                                                                                            _js2n__-prdslib.enum
                                                                                                              [
                                                                                                                "tcp",
                                                                                                                "udp",
                                                                                                                "http"
                                                                                                              ]
                                                                                                          ],
                                                                                                    routers =
                                                                                                      _js2n__-prdslib.allOf
                                                                                                          [
                                                                                                            _js2n__-prdslib.isType
                                                                                                              '"Array",
                                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                                              (_js2n__-prdslib.allOf
                                                                                                                [
                                                                                                                  _js2n__-prdslib.isType
                                                                                                                    'Record,
                                                                                                                  _js2n__-prdslib.records.required
                                                                                                                    [
                                                                                                                      "config",
                                                                                                                      "match",
                                                                                                                      "mode"
                                                                                                                    ],
                                                                                                                  _js2n__-prdslib.records.record
                                                                                                                    {
                                                                                                                      config =
                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                            [
                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                'Record,
                                                                                                                              _js2n__-prdslib.records.required
                                                                                                                                [
                                                                                                                                  "destination_retries",
                                                                                                                                  "sticky_sessions",
                                                                                                                                  "timeouts"
                                                                                                                                ],
                                                                                                                              _js2n__-prdslib.records.record
                                                                                                                                {
                                                                                                                                  destination_prioritization =
                                                                                                                                    _js2n__-prdslib.oneOf
                                                                                                                                        [
                                                                                                                                          _js2n__-prdslib.allOf
                                                                                                                                            [
                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                '"String",
                                                                                                                                              _js2n__-prdslib.enum
                                                                                                                                                [
                                                                                                                                                  "latency",
                                                                                                                                                  "random"
                                                                                                                                                ]
                                                                                                                                            ],
                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                            'Null
                                                                                                                                        ],
                                                                                                                                  destination_retries =
                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                        'Integer,
                                                                                                                                  extension =
                                                                                                                                    _js2n__-prdslib.allOf
                                                                                                                                        [
                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                            'Record,
                                                                                                                                          _js2n__-prdslib.oneOf
                                                                                                                                            [
                                                                                                                                              _js2n__-prdslib.allOf
                                                                                                                                                [
                                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                                    'Record,
                                                                                                                                                  _js2n__-prdslib.records.required
                                                                                                                                                    [
                                                                                                                                                      "details",
                                                                                                                                                      "type"
                                                                                                                                                    ],
                                                                                                                                                  _js2n__-prdslib.records.record
                                                                                                                                                    {
                                                                                                                                                      details =
                                                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                                                            [
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                'Record,
                                                                                                                                                              _js2n__-prdslib.records.record
                                                                                                                                                                {}
                                                                                                                                                                {}
                                                                                                                                                                true
                                                                                                                                                                _js2n__-prdslib.always
                                                                                                                                                            ],
                                                                                                                                                      type =
                                                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                                                            [
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                '"String",
                                                                                                                                                              _js2n__-prdslib.enum
                                                                                                                                                                [
                                                                                                                                                                  "tcp"
                                                                                                                                                                ]
                                                                                                                                                            ],
                                                                                                                                                    }
                                                                                                                                                    {}
                                                                                                                                                    true
                                                                                                                                                    _js2n__-prdslib.always
                                                                                                                                                ],
                                                                                                                                              _js2n__-prdslib.allOf
                                                                                                                                                [
                                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                                    'Record,
                                                                                                                                                  _js2n__-prdslib.records.required
                                                                                                                                                    [
                                                                                                                                                      "details",
                                                                                                                                                      "type"
                                                                                                                                                    ],
                                                                                                                                                  _js2n__-prdslib.records.record
                                                                                                                                                    {
                                                                                                                                                      details =
                                                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                                                            [
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                'Record,
                                                                                                                                                              _js2n__-prdslib.records.record
                                                                                                                                                                {
                                                                                                                                                                  caching =
                                                                                                                                                                    _js2n__-prdslib.allOf
                                                                                                                                                                        [
                                                                                                                                                                          _js2n__-prdslib.anyOf
                                                                                                                                                                            [
                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                'Record,
                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                'Null
                                                                                                                                                                            ],
                                                                                                                                                                          _js2n__-prdslib.records.record
                                                                                                                                                                            {
                                                                                                                                                                              files =
                                                                                                                                                                                _js2n__-prdslib.allOf
                                                                                                                                                                                    [
                                                                                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                                                                                        [
                                                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                                                            '"Array",
                                                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                                                            'Null
                                                                                                                                                                                        ],
                                                                                                                                                                                      _js2n__-prdslib.arrays.arrayOf
                                                                                                                                                                                        (_js2n__-prdslib.allOf
                                                                                                                                                                                          [
                                                                                                                                                                                            _js2n__-prdslib.isType
                                                                                                                                                                                              'Record,
                                                                                                                                                                                            _js2n__-prdslib.records.required
                                                                                                                                                                                              [
                                                                                                                                                                                                "match",
                                                                                                                                                                                                "ttl"
                                                                                                                                                                                              ],
                                                                                                                                                                                            _js2n__-prdslib.records.record
                                                                                                                                                                                              {
                                                                                                                                                                                                "match" =
                                                                                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                                                                                      '"String",
                                                                                                                                                                                                ttl =
                                                                                                                                                                                                  _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                                                                                              }
                                                                                                                                                                                              {}
                                                                                                                                                                                              true
                                                                                                                                                                                              _js2n__-prdslib.always
                                                                                                                                                                                          ])
                                                                                                                                                                                    ],
                                                                                                                                                                            }
                                                                                                                                                                            {}
                                                                                                                                                                            true
                                                                                                                                                                            _js2n__-prdslib.always
                                                                                                                                                                        ],
                                                                                                                                                                  forward =
                                                                                                                                                                    _js2n__-prdslib.allOf
                                                                                                                                                                        [
                                                                                                                                                                          _js2n__-prdslib.anyOf
                                                                                                                                                                            [
                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                'Record,
                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                'Null
                                                                                                                                                                            ],
                                                                                                                                                                          _js2n__-prdslib.records.record
                                                                                                                                                                            {
                                                                                                                                                                              content_mod =
                                                                                                                                                                                _js2n__-prdslib.allOf
                                                                                                                                                                                    [
                                                                                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                                                                                        [
                                                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                                                            'Record,
                                                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                                                            'Null
                                                                                                                                                                                        ],
                                                                                                                                                                                      _js2n__-prdslib.records.record
                                                                                                                                                                                        {
                                                                                                                                                                                          replace =
                                                                                                                                                                                            _js2n__-prdslib.allOf
                                                                                                                                                                                                [
                                                                                                                                                                                                  _js2n__-prdslib.anyOf
                                                                                                                                                                                                    [
                                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                                        '"Array",
                                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                                        'Null
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                                                                                                                                                    (_js2n__-prdslib.allOf
                                                                                                                                                                                                      [
                                                                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                                                                          'Record,
                                                                                                                                                                                                        _js2n__-prdslib.records.required
                                                                                                                                                                                                          [
                                                                                                                                                                                                            "match",
                                                                                                                                                                                                            "value"
                                                                                                                                                                                                          ],
                                                                                                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                                                                                                          {
                                                                                                                                                                                                            "match" =
                                                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                                                  '"String",
                                                                                                                                                                                                            value =
                                                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                                                  '"String",
                                                                                                                                                                                                          }
                                                                                                                                                                                                          {}
                                                                                                                                                                                                          true
                                                                                                                                                                                                          _js2n__-prdslib.always
                                                                                                                                                                                                      ])
                                                                                                                                                                                                ],
                                                                                                                                                                                        }
                                                                                                                                                                                        {}
                                                                                                                                                                                        true
                                                                                                                                                                                        _js2n__-prdslib.always
                                                                                                                                                                                    ],
                                                                                                                                                                              scheme =
                                                                                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                                                                                    [
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        '"String",
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        'Null
                                                                                                                                                                                    ],
                                                                                                                                                                            }
                                                                                                                                                                            {}
                                                                                                                                                                            true
                                                                                                                                                                            _js2n__-prdslib.always
                                                                                                                                                                        ],
                                                                                                                                                                  proxy =
                                                                                                                                                                    _js2n__-prdslib.allOf
                                                                                                                                                                        [
                                                                                                                                                                          _js2n__-prdslib.anyOf
                                                                                                                                                                            [
                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                'Record,
                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                'Null
                                                                                                                                                                            ],
                                                                                                                                                                          _js2n__-prdslib.records.record
                                                                                                                                                                            {
                                                                                                                                                                              content_mod =
                                                                                                                                                                                _js2n__-prdslib.allOf
                                                                                                                                                                                    [
                                                                                                                                                                                      _js2n__-prdslib.anyOf
                                                                                                                                                                                        [
                                                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                                                            'Record,
                                                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                                                            'Null
                                                                                                                                                                                        ],
                                                                                                                                                                                      _js2n__-prdslib.records.record
                                                                                                                                                                                        {
                                                                                                                                                                                          replace =
                                                                                                                                                                                            _js2n__-prdslib.allOf
                                                                                                                                                                                                [
                                                                                                                                                                                                  _js2n__-prdslib.anyOf
                                                                                                                                                                                                    [
                                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                                        '"Array",
                                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                                        'Null
                                                                                                                                                                                                    ],
                                                                                                                                                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                                                                                                                                                    (_js2n__-prdslib.allOf
                                                                                                                                                                                                      [
                                                                                                                                                                                                        _js2n__-prdslib.isType
                                                                                                                                                                                                          'Record,
                                                                                                                                                                                                        _js2n__-prdslib.records.required
                                                                                                                                                                                                          [
                                                                                                                                                                                                            "match",
                                                                                                                                                                                                            "value"
                                                                                                                                                                                                          ],
                                                                                                                                                                                                        _js2n__-prdslib.records.record
                                                                                                                                                                                                          {
                                                                                                                                                                                                            "match" =
                                                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                                                  '"String",
                                                                                                                                                                                                            value =
                                                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                                                  '"String",
                                                                                                                                                                                                          }
                                                                                                                                                                                                          {}
                                                                                                                                                                                                          true
                                                                                                                                                                                                          _js2n__-prdslib.always
                                                                                                                                                                                                      ])
                                                                                                                                                                                                ],
                                                                                                                                                                                        }
                                                                                                                                                                                        {}
                                                                                                                                                                                        true
                                                                                                                                                                                        _js2n__-prdslib.always
                                                                                                                                                                                    ],
                                                                                                                                                                              domain =
                                                                                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                                                                                    [
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        '"String",
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        'Null
                                                                                                                                                                                    ],
                                                                                                                                                                            }
                                                                                                                                                                            {}
                                                                                                                                                                            true
                                                                                                                                                                            _js2n__-prdslib.always
                                                                                                                                                                        ],
                                                                                                                                                                  redirect =
                                                                                                                                                                    _js2n__-prdslib.allOf
                                                                                                                                                                        [
                                                                                                                                                                          _js2n__-prdslib.anyOf
                                                                                                                                                                            [
                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                'Record,
                                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                                'Null
                                                                                                                                                                            ],
                                                                                                                                                                          _js2n__-prdslib.records.required
                                                                                                                                                                            [
                                                                                                                                                                              "auto_https_redirect",
                                                                                                                                                                              "remove_www"
                                                                                                                                                                            ],
                                                                                                                                                                          _js2n__-prdslib.records.record
                                                                                                                                                                            {
                                                                                                                                                                              auto_https_redirect =
                                                                                                                                                                                _js2n__-prdslib.isType
                                                                                                                                                                                    '"Bool",
                                                                                                                                                                              port =
                                                                                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                                                                                    [
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        'Integer,
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        'Null
                                                                                                                                                                                    ],
                                                                                                                                                                              remove_www =
                                                                                                                                                                                _js2n__-prdslib.isType
                                                                                                                                                                                    '"Bool",
                                                                                                                                                                              scheme =
                                                                                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                                                                                    [
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        '"String",
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        'Null
                                                                                                                                                                                    ],
                                                                                                                                                                              url =
                                                                                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                                                                                    [
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        '"String",
                                                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                                                        'Null
                                                                                                                                                                                    ],
                                                                                                                                                                            }
                                                                                                                                                                            {}
                                                                                                                                                                            true
                                                                                                                                                                            _js2n__-prdslib.always
                                                                                                                                                                        ],
                                                                                                                                                                }
                                                                                                                                                                {}
                                                                                                                                                                true
                                                                                                                                                                _js2n__-prdslib.always
                                                                                                                                                            ],
                                                                                                                                                      type =
                                                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                                                            [
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                '"String",
                                                                                                                                                              _js2n__-prdslib.enum
                                                                                                                                                                [
                                                                                                                                                                  "http"
                                                                                                                                                                ]
                                                                                                                                                            ],
                                                                                                                                                    }
                                                                                                                                                    {}
                                                                                                                                                    true
                                                                                                                                                    _js2n__-prdslib.always
                                                                                                                                                ],
                                                                                                                                              _js2n__-prdslib.allOf
                                                                                                                                                [
                                                                                                                                                  _js2n__-prdslib.isType
                                                                                                                                                    'Record,
                                                                                                                                                  _js2n__-prdslib.records.required
                                                                                                                                                    [
                                                                                                                                                      "details",
                                                                                                                                                      "type"
                                                                                                                                                    ],
                                                                                                                                                  _js2n__-prdslib.records.record
                                                                                                                                                    {
                                                                                                                                                      details =
                                                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                                                            [
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                'Record,
                                                                                                                                                              _js2n__-prdslib.records.record
                                                                                                                                                                {}
                                                                                                                                                                {}
                                                                                                                                                                true
                                                                                                                                                                _js2n__-prdslib.always
                                                                                                                                                            ],
                                                                                                                                                      type =
                                                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                                                            [
                                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                                '"String",
                                                                                                                                                              _js2n__-prdslib.enum
                                                                                                                                                                [
                                                                                                                                                                  "udp"
                                                                                                                                                                ]
                                                                                                                                                            ],
                                                                                                                                                    }
                                                                                                                                                    {}
                                                                                                                                                    true
                                                                                                                                                    _js2n__-prdslib.always
                                                                                                                                                ]
                                                                                                                                            ]
                                                                                                                                        ],
                                                                                                                                  sticky_sessions =
                                                                                                                                    _js2n__-prdslib.isType
                                                                                                                                        '"Bool",
                                                                                                                                  timeouts =
                                                                                                                                    _js2n__-prdslib.allOf
                                                                                                                                        [
                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                            'Record,
                                                                                                                                          _js2n__-prdslib.records.required
                                                                                                                                            [
                                                                                                                                              "destination_connection"
                                                                                                                                            ],
                                                                                                                                          _js2n__-prdslib.records.record
                                                                                                                                            {
                                                                                                                                              destination_connection =
                                                                                                                                                _js2n__-refsenv."_js2n__-:properties/scoped_variables/items/properties/access/properties/internal_api/properties/duration/anyOf/0!predicate",
                                                                                                                                            }
                                                                                                                                            {}
                                                                                                                                            true
                                                                                                                                            _js2n__-prdslib.always
                                                                                                                                        ],
                                                                                                                                  tls =
                                                                                                                                    _js2n__-prdslib.allOf
                                                                                                                                        [
                                                                                                                                          _js2n__-prdslib.anyOf
                                                                                                                                            [
                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                'Record,
                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                'Null
                                                                                                                                            ],
                                                                                                                                          _js2n__-prdslib.records.record
                                                                                                                                            {
                                                                                                                                              allow_insecure =
                                                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                                                    [
                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                        '"Bool",
                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                        'Null
                                                                                                                                                    ],
                                                                                                                                              client_auth =
                                                                                                                                                _js2n__-prdslib.oneOf
                                                                                                                                                    [
                                                                                                                                                      _js2n__-prdslib.allOf
                                                                                                                                                        [
                                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                                            '"String",
                                                                                                                                                          _js2n__-prdslib.enum
                                                                                                                                                            [
                                                                                                                                                              "none",
                                                                                                                                                              "request",
                                                                                                                                                              "require",
                                                                                                                                                              "require-verify"
                                                                                                                                                            ]
                                                                                                                                                        ],
                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                        'Null
                                                                                                                                                    ],
                                                                                                                                              client_cert_auth =
                                                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                                                    [
                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                        '"String",
                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                        'Null
                                                                                                                                                    ],
                                                                                                                                              server_name =
                                                                                                                                                _js2n__-prdslib.anyOf
                                                                                                                                                    [
                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                        '"String",
                                                                                                                                                      _js2n__-prdslib.isType
                                                                                                                                                        'Null
                                                                                                                                                    ],
                                                                                                                                            }
                                                                                                                                            {}
                                                                                                                                            true
                                                                                                                                            _js2n__-prdslib.always
                                                                                                                                        ],
                                                                                                                                }
                                                                                                                                {}
                                                                                                                                true
                                                                                                                                _js2n__-prdslib.always
                                                                                                                            ],
                                                                                                                      "match" =
                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                            [
                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                'Record,
                                                                                                                              _js2n__-prdslib.records.required
                                                                                                                                [
                                                                                                                                  "domains",
                                                                                                                                  "internal_port"
                                                                                                                                ],
                                                                                                                              _js2n__-prdslib.records.record
                                                                                                                                {
                                                                                                                                  domains =
                                                                                                                                    _js2n__-prdslib.allOf
                                                                                                                                        [
                                                                                                                                          _js2n__-prdslib.anyOf
                                                                                                                                            [
                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                '"Array",
                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                'Null
                                                                                                                                            ],
                                                                                                                                          _js2n__-prdslib.arrays.arrayOf
                                                                                                                                            (_js2n__-prdslib.isType
                                                                                                                                              '"String")
                                                                                                                                        ],
                                                                                                                                  internal_port =
                                                                                                                                    _js2n__-prdslib.allOf
                                                                                                                                        [
                                                                                                                                          _js2n__-prdslib.anyOf
                                                                                                                                            [
                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                '"Array",
                                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                                'Null
                                                                                                                                            ],
                                                                                                                                          _js2n__-prdslib.arrays.arrayOf
                                                                                                                                            (_js2n__-prdslib.isType
                                                                                                                                              'Integer)
                                                                                                                                        ],
                                                                                                                                  path =
                                                                                                                                    _js2n__-prdslib.anyOf
                                                                                                                                        [
                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                            '"String",
                                                                                                                                          _js2n__-prdslib.isType
                                                                                                                                            'Null
                                                                                                                                        ],
                                                                                                                                }
                                                                                                                                {}
                                                                                                                                true
                                                                                                                                _js2n__-prdslib.always
                                                                                                                            ],
                                                                                                                      mode =
                                                                                                                        _js2n__-prdslib.allOf
                                                                                                                            [
                                                                                                                              _js2n__-prdslib.isType
                                                                                                                                '"String",
                                                                                                                              _js2n__-prdslib.enum
                                                                                                                                [
                                                                                                                                  "random",
                                                                                                                                  "round-robin"
                                                                                                                                ]
                                                                                                                            ],
                                                                                                                    }
                                                                                                                    {}
                                                                                                                    true
                                                                                                                    _js2n__-prdslib.always
                                                                                                                ])
                                                                                                          ],
                                                                                                  }
                                                                                                  {}
                                                                                                  true
                                                                                                  _js2n__-prdslib.always
                                                                                              ],
                                                                                      }
                                                                                      {}
                                                                                      true
                                                                                      _js2n__-prdslib.always
                                                                                  ])
                                                                            ],
                                                                    } {} true
                                                                    _js2n__-prdslib.always
                                                                ],
                                                          ipv4 =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          ipv6 =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          type =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [ "v1" ]
                                                                ],
                                                        } {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                                  _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [
                                                          "details",
                                                          "ipv4",
                                                          "ipv6",
                                                          "type"
                                                        ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          details =
                                                            _js2n__-prdslib.oneOf
                                                                [
                                                                  _js2n__-refsenv."_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/0/properties/details/anyOf/0!predicate",
                                                                  _js2n__-refsenv."_js2n__-:properties/services/properties/loadbalancer/anyOf/1/properties/config/anyOf/0/oneOf/1/properties/details!predicate",
                                                                  _js2n__-prdslib.isType
                                                                    'Null
                                                                ],
                                                          ipv4 =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          ipv6 =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          type =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "default"
                                                                    ]
                                                                ],
                                                        } {} true
                                                        _js2n__-prdslib.always
                                                    ]
                                                ]
                                            ],
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                  service =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:properties/services/properties/vpn/anyOf/1/properties/service/anyOf/0!predicate",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  scheduler =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  config =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                              _js2n__-prdslib.records.required
                                                [ "public" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  access_keys =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.required
                                                                  [
                                                                    "name",
                                                                    "secret"
                                                                  ],
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    ips =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              '"Array",
                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                              (_js2n__-prdslib.isType
                                                                                '"String")
                                                                          ],
                                                                    name =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    secret =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ])
                                                        ],
                                                  public =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                  service =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:properties/services/properties/vpn/anyOf/1/properties/service/anyOf/0!predicate",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  vpn =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  config =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [ "allow_internet", "auth" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  allow_internet =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  auth =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.required
                                                            [
                                                              "cycle_accounts",
                                                              "vpn_accounts"
                                                            ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              cycle_accounts =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              vpn_accounts =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              webhook =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                  service =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  auto_update =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  enable =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  high_availability =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ])
        | doc "Settings for any auxillary services deployed as part of the environment, such as load balancer and discovery services."
        | optional,
      version
        | std.enum.TagOrString
        | [| '"1.0" |]
        | doc "The version of the Cycle stack file used.",
      ..
    }