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
      "_js2n__-:definitions/advisory!predicate"
        | doc "Title and location where advisory information can be obtained. An advisory is a notification of a threat to a component, service, or system."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  title = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/affectedStatus!predicate"
        | doc "The vulnerability status of a given version or range of versions of a product. The statuses 'affected' and 'unaffected' indicate that the version is affected or unaffected by the vulnerability. The status 'unknown' indicates that it is unknown or unspecified whether the given version is affected. There can be many reasons for an 'unknown' status, including that an investigation has not been undertaken or that a vendor has not disclosed the status."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "affected", "unaffected", "unknown" ]
            ],
      "_js2n__-:definitions/aggregateType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "complete",
                  "incomplete",
                  "incomplete_first_party_only",
                  "incomplete_first_party_proprietary_only",
                  "incomplete_first_party_opensource_only",
                  "incomplete_third_party_only",
                  "incomplete_third_party_proprietary_only",
                  "incomplete_third_party_opensource_only",
                  "unknown",
                  "not_specified"
                ]
            ],
      "_js2n__-:definitions/annotations!predicate"
        | doc "A comment, note, explanation, or similar textual content which provides additional context to the object(s) being annotated."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "annotator", "subjects", "text", "timestamp" ],
              _js2n__-prdslib.records.record
                {
                  annotator =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "organization" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "individual" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "component" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "service" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.records.record
                            {
                              component =
                                _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                              individual =
                                _js2n__-refsenv."_js2n__-:definitions/organizationalContact!predicate",
                              organization =
                                _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                              service =
                                _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  signature =
                    _js2n__-refsenv."_js2n__-:definitions/signature!predicate",
                  subjects =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  text = _js2n__-prdslib.isType '"String",
                  timestamp = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/attachment!contract"
        | doc "Specifies the metadata and content for an attachment."
        = {
            content
              | String
              | doc "The attachment data. Proactive controls such as input validation and sanitization should be employed to prevent misuse of attachment text.",
            contentType
              | String
              | doc m%"
                Specifies the format and nature of the data being attached, helping systems correctly interpret and process the content. Common content type examples include `application/json` for JSON data and `text/plain` for plan text documents.
                 [RFC 2045 section 5.1](https://www.ietf.org/rfc/rfc2045.html#section-5.1) outlines the structure and use of content types. For a comprehensive list of registered content types, refer to the [IANA media types registry](https://www.iana.org/assignments/media-types/media-types.xhtml).
              "%
              | optional,
            encoding
              | std.enum.TagOrString
              | [| 'base64 |]
              | doc "Specifies the optional encoding the text is represented in."
              | optional,
          },
      "_js2n__-:definitions/attachment!predicate"
        | doc "Specifies the metadata and content for an attachment."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "content" ],
              _js2n__-prdslib.records.record
                {
                  content = _js2n__-prdslib.isType '"String",
                  contentType = _js2n__-prdslib.isType '"String",
                  encoding =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "base64" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/bomLink!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/bomLinkDocumentType!predicate",
              _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
            ],
      "_js2n__-:definitions/bomLinkDocumentType!predicate"
        | doc "Descriptor for another BOM document. See https://cyclonedx.org/capabilities/bomlink/"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:cdx:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/[1-9][0-9]*$"
            ],
      "_js2n__-:definitions/bomLinkElementType!predicate"
        | doc "Descriptor for an element in a BOM document. See https://cyclonedx.org/capabilities/bomlink/"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:cdx:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/[1-9][0-9]*#.+$"
            ],
      "_js2n__-:definitions/cipherSuite!contract"
        | doc "Object representing a cipher suite"
        = {
            algorithms
              | Array _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc "A list of algorithms related to the cipher suite."
              | optional,
            identifiers
              | Array (String)
              | doc "A list of common identifiers for the cipher suite."
              | optional,
            name
              | String
              | doc "A common name for the cipher suite."
              | optional,
          },
      "_js2n__-:definitions/cipherSuite!predicate"
        | doc "Object representing a cipher suite"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  algorithms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/refType!predicate"
                        ],
                  identifiers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/co2Measure!contract"
        | doc "A measure of carbon dioxide (CO2)."
        = {
            unit
              | std.enum.TagOrString
              | [| 'tCO2eq |]
              | doc "Unit of carbon dioxide (CO2).",
            value | Number | doc "Quantity of carbon dioxide (CO2).",
          },
      "_js2n__-:definitions/co2Measure!predicate"
        | doc "A measure of carbon dioxide (CO2)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "unit", "value" ],
              _js2n__-prdslib.records.record
                {
                  unit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "tCO2eq" ]
                        ],
                  value = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/command!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  executed = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/commit!contract"
        | doc "Specifies an individual commit"
        = {
            author
              | _js2n__-refsenv."_js2n__-:definitions/identifiableAction!contract"
              | doc "The author who created the changes in the commit"
              | optional,
            committer
              | _js2n__-refsenv."_js2n__-:definitions/identifiableAction!contract"
              | doc "The person who committed or pushed the commit"
              | optional,
            message
              | String
              | doc "The text description of the contents of the commit"
              | optional,
            uid
              | String
              | doc "A unique identifier of the commit. This may be version control specific. For example, Subversion uses revision numbers whereas git uses commit hashes."
              | optional,
            url
              | String
              | doc "The URL to the commit. This URL will typically point to a commit in a version control system."
              | optional,
          },
      "_js2n__-:definitions/commit!predicate"
        | doc "Specifies an individual commit"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  author =
                    _js2n__-refsenv."_js2n__-:definitions/identifiableAction!predicate",
                  committer =
                    _js2n__-refsenv."_js2n__-:definitions/identifiableAction!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  uid = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/component!contract" =
        {
            author
              | String
              | doc m%"
                [Deprecated] This will be removed in a future version. Use `@.authors` or `@.manufacturer` instead.
                The person(s) or organization(s) that authored the component
              "%
              | optional,
            authors
              | Array
                _js2n__-refsenv."_js2n__-:definitions/organizationalContact!contract"
              | doc m%"
                The person(s) who created the component.
                Authors are common in components created through manual processes. Components created through automated means may have `@.manufacturer` instead.
              "%
              | optional,
            bom-ref
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc m%"
                An optional identifier which can be used to reference the component elsewhere in the BOM. Every bom-ref must be unique within the BOM.
                Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
              "%
              | optional,
            components
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "A list of software and hardware components included in the parent component. This is not a dependency tree. It provides a way to specify a hierarchical representation of component assemblies, similar to system &#8594; subsystem &#8594; parts assembly in physical supply chains."
              | optional,
            copyright
              | String
              | doc "A copyright notice informing users of the underlying claims to copyright ownership in a published work."
              | optional,
            cpe
              | String
              | doc "Asserts the identity of the component using CPE. The CPE must conform to the CPE 2.2 or 2.3 specification. See [https://nvd.nist.gov/products/cpe](https://nvd.nist.gov/products/cpe). Refer to `@.evidence.identity` to optionally provide evidence that substantiates the assertion of the component's identity."
              | optional,
            cryptoProperties
              | _js2n__-refsenv."_js2n__-:definitions/cryptoProperties!contract"
              | optional,
            data
              | Array
                _js2n__-refsenv."_js2n__-:definitions/componentData!contract"
              | doc "This object SHOULD be specified for any component of type `data` and must not be specified for other component types."
              | optional,
            description
              | String
              | doc "Specifies a description for the component"
              | optional,
            evidence
              | _js2n__-refsenv."_js2n__-:definitions/componentEvidence!contract"
              | doc "Provides the ability to document evidence collected through various forms of extraction or analysis."
              | optional,
            externalReferences
              | Array
                _js2n__-refsenv."_js2n__-:definitions/externalReference!contract"
              | doc "External references provide a way to document systems, sites, and information that may be relevant but are not included with the BOM. They may also establish specific relationships within or external to the BOM."
              | optional,
            group
              | String
              | doc "The grouping name or identifier. This will often be a shortened, single name of the company or project that produced the component, or the source package or domain name. Whitespace and special characters should be avoided. Examples include: apache, org.apache.commons, and apache.org."
              | optional,
            hashes
              | Array _js2n__-refsenv."_js2n__-:definitions/hash!contract"
              | doc "The hashes of the component."
              | optional,
            licenses
              | _js2n__-refsenv."_js2n__-:definitions/licenseChoice!contract"
              | optional,
            manufacturer
              | _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!contract"
              | doc m%"
                The organization that created the component.
                Manufacturer is common in components created through automated processes. Components created through manual means may have `@.authors` instead.
              "%
              | optional,
            mime-type
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern
                      "^[-+a-z0-9.]+/[-+a-z0-9.]+$"
                  ])
              | doc "The optional mime-type of the component. When used on file components, the mime-type can provide additional context about the kind of file being represented, such as an image, font, or executable. Some library or framework components may also have an associated mime-type."
              | optional,
            modelCard
              | _js2n__-refsenv."_js2n__-:definitions/modelCard!contract"
              | optional,
            modified
              | Bool
              | doc "[Deprecated] This will be removed in a future version. Use the pedigree element instead to supply information on exactly how the component was modified. A boolean value indicating if the component has been modified from the original. A value of true indicates the component is a derivative of the original. A value of false indicates the component has not been modified from the original."
              | optional,
            name
              | String
              | doc "The name of the component. This will often be a shortened, single name of the component. Examples: commons-lang3 and jquery",
            omniborId
              | Array (String)
              | doc "Asserts the identity of the component using the OmniBOR Artifact ID. The OmniBOR, if specified, must be valid and conform to the specification defined at: [https://www.iana.org/assignments/uri-schemes/prov/gitoid](https://www.iana.org/assignments/uri-schemes/prov/gitoid). Refer to `@.evidence.identity` to optionally provide evidence that substantiates the assertion of the component's identity."
              | optional,
            pedigree
              | {
                ancestors
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/component!contract"
                  | doc "Describes zero or more components in which a component is derived from. This is commonly used to describe forks from existing projects where the forked version contains a ancestor node containing the original component it was forked from. For example, Component A is the original component. Component B is the component being used and documented in the BOM. However, Component B contains a pedigree node with a single ancestor documenting Component A - the original component from which Component B is derived from."
                  | optional,
                commits
                  | Array _js2n__-refsenv."_js2n__-:definitions/commit!contract"
                  | doc "A list of zero or more commits which provide a trail describing how the component deviates from an ancestor, descendant, or variant."
                  | optional,
                descendants
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/component!contract"
                  | doc "Descendants are the exact opposite of ancestors. This provides a way to document all forks (and their forks) of an original or root component."
                  | optional,
                notes
                  | String
                  | doc "Notes, observations, and other non-structured commentary describing the components pedigree."
                  | optional,
                patches
                  | Array _js2n__-refsenv."_js2n__-:definitions/patch!contract"
                  | doc ">A list of zero or more patches describing how the component deviates from an ancestor, descendant, or variant. Patches may be complementary to commits or may be used in place of commits."
                  | optional,
                variants
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/component!contract"
                  | doc "Variants describe relations where the relationship between the components is not known. For example, if Component A contains nearly identical code to Component B. They are both related, but it is unclear if one is derived from the other, or if they share a common ancestor."
                  | optional,
              }
              | doc "Component pedigree is a way to document complex supply chain scenarios where components are created, distributed, modified, redistributed, combined with other components, etc. Pedigree supports viewing this complex chain from the beginning, the end, or anywhere in the middle. It also provides a way to document variants where the exact relation may not be known."
              | optional,
            properties
              | Array _js2n__-refsenv."_js2n__-:definitions/property!contract"
              | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
              | optional,
            publisher
              | String
              | doc "The person(s) or organization(s) that published the component"
              | optional,
            purl
              | String
              | doc "Asserts the identity of the component using package-url (purl). The purl, if specified, must be valid and conform to the specification defined at: [https://github.com/package-url/purl-spec](https://github.com/package-url/purl-spec). Refer to `@.evidence.identity` to optionally provide evidence that substantiates the assertion of the component's identity."
              | optional,
            releaseNotes
              | _js2n__-refsenv."_js2n__-:definitions/releaseNotes!contract"
              | doc "Specifies optional release notes."
              | optional,
            scope
              | std.enum.TagOrString
              | [| 'excluded, '"optional", 'required |]
              | doc "Specifies the scope of the component. If scope is not specified, 'required' scope SHOULD be assumed by the consumer of the BOM."
              | optional,
            signature
              | _js2n__-refsenv."_js2n__-:definitions/signature!contract"
              | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
              | optional,
            supplier
              | _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!contract"
              | doc " The organization that supplied the component. The supplier may often be the manufacturer, but may also be a distributor or repackager."
              | optional,
            swhid
              | Array (String)
              | doc "Asserts the identity of the component using the Software Heritage persistent identifier (SWHID). The SWHID, if specified, must be valid and conform to the specification defined at: [https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html). Refer to `@.evidence.identity` to optionally provide evidence that substantiates the assertion of the component's identity."
              | optional,
            swid
              | _js2n__-refsenv."_js2n__-:definitions/swid!contract"
              | doc "Asserts the identity of the component using [ISO-IEC 19770-2 Software Identification (SWID) Tags](https://www.iso.org/standard/65666.html). Refer to `@.evidence.identity` to optionally provide evidence that substantiates the assertion of the component's identity."
              | optional,
            tags
              | _js2n__-refsenv."_js2n__-:definitions/tags!contract"
              | optional,
            type
              | std.enum.TagOrString
              | [|
                'cryptographic-asset,
                'data,
                'machine-learning-model,
                'file,
                'firmware,
                'device-driver,
                'device,
                'operating-system,
                'platform,
                'container,
                'library,
                'framework,
                'application
              |]
              | doc "Specifies the type of component. For software components, classify as application if no more specific appropriate classification is available or cannot be determined for the component.",
            version
              | _js2n__-refsenv."_js2n__-:definitions/version!contract"
              | doc "The component version. The version should ideally comply with semantic versioning but is not enforced."
              | optional,
          },
      "_js2n__-:definitions/component!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  author = _js2n__-prdslib.isType '"String",
                  authors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/organizationalContact!predicate"
                        ],
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  components =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  copyright = _js2n__-prdslib.isType '"String",
                  cpe = _js2n__-prdslib.isType '"String",
                  cryptoProperties =
                    _js2n__-refsenv."_js2n__-:definitions/cryptoProperties!predicate",
                  data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/componentData!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  evidence =
                    _js2n__-refsenv."_js2n__-:definitions/componentEvidence!predicate",
                  externalReferences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalReference!predicate"
                        ],
                  group = _js2n__-prdslib.isType '"String",
                  hashes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/hash!predicate"
                        ],
                  licenses =
                    _js2n__-refsenv."_js2n__-:definitions/licenseChoice!predicate",
                  manufacturer =
                    _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                  mime-type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[-+a-z0-9.]+/[-+a-z0-9.]+$"
                        ],
                  modelCard =
                    _js2n__-refsenv."_js2n__-:definitions/modelCard!predicate",
                  modified = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  omniborId =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  pedigree =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              ancestors =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/component!predicate"
                                    ],
                              commits =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/commit!predicate"
                                    ],
                              descendants =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/component!predicate"
                                    ],
                              notes = _js2n__-prdslib.isType '"String",
                              patches =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/patch!predicate"
                                    ],
                              variants =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/component!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  publisher = _js2n__-prdslib.isType '"String",
                  purl = _js2n__-prdslib.isType '"String",
                  releaseNotes =
                    _js2n__-refsenv."_js2n__-:definitions/releaseNotes!predicate",
                  scope =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "required", "optional", "excluded" ]
                        ],
                  signature =
                    _js2n__-refsenv."_js2n__-:definitions/signature!predicate",
                  supplier =
                    _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                  swhid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  swid = _js2n__-refsenv."_js2n__-:definitions/swid!predicate",
                  tags = _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "application",
                              "framework",
                              "library",
                              "container",
                              "platform",
                              "operating-system",
                              "device",
                              "device-driver",
                              "firmware",
                              "file",
                              "machine-learning-model",
                              "data",
                              "cryptographic-asset"
                            ]
                        ],
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/componentData!contract" =
        {
            bom-ref
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc m%"
                An optional identifier which can be used to reference the dataset elsewhere in the BOM. Every bom-ref must be unique within the BOM.
                Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
              "%
              | optional,
            classification
              | _js2n__-refsenv."_js2n__-:definitions/dataClassification!contract"
              | optional,
            contents
              | {
                attachment
                  | _js2n__-refsenv."_js2n__-:definitions/attachment!contract"
                  | doc "An optional way to include textual or encoded data."
                  | optional,
                properties
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/property!contract"
                  | doc "Provides the ability to document name-value parameters used for configuration."
                  | optional,
                url
                  | String
                  | doc "The URL to where the data can be retrieved."
                  | optional,
              }
              | doc "The contents or references to the contents of the data being described."
              | optional,
            description
              | String
              | doc "A description of the dataset. Can describe size of dataset, whether it's used for source code, training, testing, or validation, etc."
              | optional,
            governance
              | _js2n__-refsenv."_js2n__-:definitions/dataGovernance!contract"
              | optional,
            graphics
              | _js2n__-refsenv."_js2n__-:definitions/graphicsCollection!contract"
              | optional,
            name | String | doc "The name of the dataset." | optional,
            sensitiveData
              | Array (String)
              | doc "A description of any sensitive data in a dataset."
              | optional,
            type
              | std.enum.TagOrString
              | [|
                'other,
                'definition,
                'dataset,
                'configuration,
                'source-code
              |]
              | doc "The general theme or subject matter of the data being specified.",
          },
      "_js2n__-:definitions/componentData!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/dataClassification!predicate",
                  contents =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              attachment =
                                _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                              properties =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                                    ],
                              url = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  governance =
                    _js2n__-refsenv."_js2n__-:definitions/dataGovernance!predicate",
                  graphics =
                    _js2n__-refsenv."_js2n__-:definitions/graphicsCollection!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  sensitiveData =
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
                          _js2n__-prdslib.enum
                            [
                              "source-code",
                              "configuration",
                              "dataset",
                              "definition",
                              "other"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/componentEvidence!contract"
        | doc "Provides the ability to document evidence collected through various forms of extraction or analysis."
        = {
            callstack
              | {
                frames
                  | Array
                    {
                      column
                        | std.number.Integer
                        | doc "The column the code that is called resides."
                        | optional,
                      fullFilename
                        | String
                        | doc "The full path and filename of the module."
                        | optional,
                      function
                        | String
                        | doc "A block of code designed to perform a particular task."
                        | optional,
                      line
                        | std.number.Integer
                        | doc "The line number the code that is called resides on."
                        | optional,
                      module
                        | String
                        | doc "A module or class that encloses functions/methods and other code.",
                      package
                        | String
                        | doc "A package organizes modules into namespaces, providing a unique namespace for each type it contains."
                        | optional,
                      parameters
                        | Array (String)
                        | doc "Optional arguments that are passed to the module or function."
                        | optional,
                    }
                  | doc "Within a call stack, a frame is a discrete unit that encapsulates an execution context, including local variables, parameters, and the return address. As function calls are made, frames are pushed onto the stack, forming an array-like structure that orchestrates the flow of program execution and manages the sequence of function invocations."
                  | optional,
              }
              | doc "Evidence of the components use through the callstack."
              | optional,
            copyright
              | Array _js2n__-refsenv."_js2n__-:definitions/copyright!contract"
              | doc "Copyright evidence captures intellectual property assertions, providing evidence of possible ownership and legal protection."
              | optional,
            identity
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          _js2n__-refsenv."_js2n__-:definitions/componentIdentityEvidence!predicate"
                      ],
                    _js2n__-refsenv."_js2n__-:definitions/componentIdentityEvidence!predicate"
                  ])
              | doc "Evidence that substantiates the identity of a component. The identity may be an object or an array of identity objects. Support for specifying identity as a single object was introduced in CycloneDX v1.5. Arrays were introduced in v1.6. It is recommended that all implementations use arrays, even if only one identity object is specified."
              | optional,
            licenses
              | _js2n__-refsenv."_js2n__-:definitions/licenseChoice!contract"
              | optional,
            occurrences
              | Array
                {
                  additionalContext
                    | String
                    | doc "Any additional context of the detected component (e.g. a code snippet)."
                    | optional,
                  bom-ref
                    | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
                    | doc m%"
                      An optional identifier which can be used to reference the occurrence elsewhere in the BOM. Every bom-ref must be unique within the BOM.
                      Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
                    "%
                    | optional,
                  line
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ])
                    | doc "The line number where the component was found."
                    | optional,
                  location
                    | String
                    | doc "The location or path to where the component was found.",
                  offset
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ])
                    | doc "The offset where the component was found."
                    | optional,
                  symbol
                    | String
                    | doc "The symbol name that was found associated with the component."
                    | optional,
                }
              | doc "Evidence of individual instances of a component spread across multiple locations."
              | optional,
          },
      "_js2n__-:definitions/componentEvidence!predicate"
        | doc "Provides the ability to document evidence collected through various forms of extraction or analysis."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  callstack =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              frames =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "module" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                column =
                                                  _js2n__-prdslib.isType
                                                      'Integer,
                                                fullFilename =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                function =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                line =
                                                  _js2n__-prdslib.isType
                                                      'Integer,
                                                module =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                package =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                parameters =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                              } {} false _js2n__-prdslib.never
                                          ])
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  copyright =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/copyright!predicate"
                        ],
                  identity =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/componentIdentityEvidence!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/componentIdentityEvidence!predicate"
                        ],
                  licenses =
                    _js2n__-refsenv."_js2n__-:definitions/licenseChoice!predicate",
                  occurrences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "location" ],
                                _js2n__-prdslib.records.record
                                  {
                                    additionalContext =
                                      _js2n__-prdslib.isType '"String",
                                    bom-ref =
                                      _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                                    line =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    location = _js2n__-prdslib.isType '"String",
                                    offset =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    symbol = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/componentIdentityEvidence!predicate"
        | doc "Evidence that substantiates the identity of a component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "field" ],
              _js2n__-prdslib.records.record
                {
                  concludedValue = _js2n__-prdslib.isType '"String",
                  confidence =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 1,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  field =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "group",
                              "name",
                              "version",
                              "purl",
                              "cpe",
                              "omniborId",
                              "swhid",
                              "swid",
                              "hash"
                            ]
                        ],
                  methods =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "confidence", "technique" ],
                                _js2n__-prdslib.records.record
                                  {
                                    confidence =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.numbers.maximum 1,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    technique =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "source-code-analysis",
                                                "binary-analysis",
                                                "manifest-analysis",
                                                "ast-fingerprint",
                                                "hash-comparison",
                                                "instrumentation",
                                                "dynamic-analysis",
                                                "filename",
                                                "attestation",
                                                "other"
                                              ]
                                          ],
                                    value = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  tools =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/compositions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "aggregate" ],
              _js2n__-prdslib.records.record
                {
                  aggregate =
                    _js2n__-refsenv."_js2n__-:definitions/aggregateType!predicate",
                  assemblies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  signature =
                    _js2n__-refsenv."_js2n__-:definitions/signature!predicate",
                  vulnerabilities =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/condition!predicate"
        | doc "A condition that was used to determine a trigger should be activated."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  expression = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/copyright!contract"
        | doc "A copyright notice informing users of the underlying claims to copyright ownership in a published work."
        = { text | String | doc "The textual content of the copyright.", },
      "_js2n__-:definitions/copyright!predicate"
        | doc "A copyright notice informing users of the underlying claims to copyright ownership in a published work."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "text" ],
              _js2n__-prdslib.records.record
                { text = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cryptoProperties!contract"
        | doc "Cryptographic assets have properties that uniquely define them and that make them actionable for further reasoning. As an example, it makes a difference if one knows the algorithm family (e.g. AES) or the specific variant or instantiation (e.g. AES-128-GCM). This is because the security level and the algorithm primitive (authenticated encryption) are only defined by the definition of the algorithm variant. The presence of a weak cryptographic algorithm like SHA1 vs. HMAC-SHA1 also makes a difference."
        = {
            algorithmProperties
              | {
                certificationLevel
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "none",
                                  "fips140-1-l1",
                                  "fips140-1-l2",
                                  "fips140-1-l3",
                                  "fips140-1-l4",
                                  "fips140-2-l1",
                                  "fips140-2-l2",
                                  "fips140-2-l3",
                                  "fips140-2-l4",
                                  "fips140-3-l1",
                                  "fips140-3-l2",
                                  "fips140-3-l3",
                                  "fips140-3-l4",
                                  "cc-eal1",
                                  "cc-eal1+",
                                  "cc-eal2",
                                  "cc-eal2+",
                                  "cc-eal3",
                                  "cc-eal3+",
                                  "cc-eal4",
                                  "cc-eal4+",
                                  "cc-eal5",
                                  "cc-eal5+",
                                  "cc-eal6",
                                  "cc-eal6+",
                                  "cc-eal7",
                                  "cc-eal7+",
                                  "other",
                                  "unknown"
                                ]
                            ])
                      ])
                  | doc "The certification that the implementation of the cryptographic algorithm has received, if any. Certifications include revisions and levels of FIPS 140 or Common Criteria of different Extended Assurance Levels (CC-EAL)."
                  | optional,
                classicalSecurityLevel
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.minimum 0
                      ])
                  | doc "The classical security level that a cryptographic algorithm provides (in bits)."
                  | optional,
                cryptoFunctions
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "generate",
                                  "keygen",
                                  "encrypt",
                                  "decrypt",
                                  "digest",
                                  "tag",
                                  "keyderive",
                                  "sign",
                                  "verify",
                                  "encapsulate",
                                  "decapsulate",
                                  "other",
                                  "unknown"
                                ]
                            ])
                      ])
                  | doc "The cryptographic functions implemented by the cryptographic algorithm."
                  | optional,
                curve
                  | String
                  | doc "The specific underlying Elliptic Curve (EC) definition employed which is an indicator of the level of security strength, performance and complexity. Absent an authoritative source of curve names, CycloneDX recommends using curve names as defined at [https://neuromancer.sk/std/](https://neuromancer.sk/std/), the source of which can be found at [https://github.com/J08nY/std-curves](https://github.com/J08nY/std-curves)."
                  | optional,
                executionEnvironment
                  | std.enum.TagOrString
                  | [|
                    'unknown,
                    'other,
                    'hardware,
                    'software-tee,
                    'software-encrypted-ram,
                    'software-plain-ram
                  |]
                  | doc "The target and execution environment in which the algorithm is implemented in."
                  | optional,
                implementationPlatform
                  | std.enum.TagOrString
                  | [|
                    'unknown,
                    'other,
                    'ppc64le,
                    'ppc64,
                    's390x,
                    'armv9-m,
                    'armv9-a,
                    'armv8-m,
                    'armv8-a,
                    'armv7-m,
                    'armv7-a,
                    'x86_64,
                    'x86_32,
                    'generic
                  |]
                  | doc "The target platform for which the algorithm is implemented. The implementation can be 'generic', running on any platform or for a specific platform."
                  | optional,
                mode
                  | std.enum.TagOrString
                  | [|
                    'unknown,
                    'other,
                    'ctr,
                    'ofb,
                    'cfb,
                    'gcm,
                    'ccm,
                    'ecb,
                    'cbc
                  |]
                  | doc "The mode of operation in which the cryptographic algorithm (block cipher) is used."
                  | optional,
                nistQuantumSecurityLevel
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.maximum 6,
                        _js2n__-prdslib.numbers.minimum 0
                      ])
                  | doc "The NIST security strength category as defined in https://csrc.nist.gov/projects/post-quantum-cryptography/post-quantum-cryptography-standardization/evaluation-criteria/security-(evaluation-criteria). A value of 0 indicates that none of the categories are met."
                  | optional,
                padding
                  | std.enum.TagOrString
                  | [|
                    'unknown,
                    'other,
                    'raw,
                    'oaep,
                    'pkcs1v15,
                    'pkcs7,
                    'pkcs5
                  |]
                  | doc "The padding scheme that is used for the cryptographic algorithm."
                  | optional,
                parameterSetIdentifier
                  | String
                  | doc "An identifier for the parameter set of the cryptographic algorithm. Examples: in AES128, '128' identifies the key length in bits, in SHA256, '256' identifies the digest length, '128' in SHAKE128 identifies its maximum security level in bits, and 'SHA2-128s' identifies a parameter set used in SLH-DSA (FIPS205)."
                  | optional,
                primitive
                  | std.enum.TagOrString
                  | [|
                    'unknown,
                    'other,
                    'combiner,
                    'ae,
                    'kem,
                    'key-agree,
                    'kdf,
                    'xof,
                    'pke,
                    'hash,
                    'signature,
                    'stream-cipher,
                    'block-cipher,
                    'mac,
                    'drbg
                  |]
                  | doc "Cryptographic building blocks used in higher-level cryptographic systems and protocols. Primitives represent different cryptographic routines: deterministic random bit generators (drbg, e.g. CTR_DRBG from NIST SP800-90A-r1), message authentication codes (mac, e.g. HMAC-SHA-256), blockciphers (e.g. AES), streamciphers (e.g. Salsa20), signatures (e.g. ECDSA), hash functions (e.g. SHA-256), public-key encryption schemes (pke, e.g. RSA), extended output functions (xof, e.g. SHAKE256), key derivation functions (e.g. pbkdf2), key agreement algorithms (e.g. ECDH), key encapsulation mechanisms (e.g. ML-KEM), authenticated encryption (ae, e.g. AES-GCM) and the combination of multiple algorithms (combiner, e.g. SP800-56Cr2)."
                  | optional,
              }
              | doc "Additional properties specific to a cryptographic algorithm."
              | optional,
            assetType
              | std.enum.TagOrString
              | [|
                'related-crypto-material,
                'protocol,
                'certificate,
                'algorithm
              |]
              | doc "Cryptographic assets occur in several forms. Algorithms and protocols are most commonly implemented in specialized cryptographic libraries. They may, however, also be 'hardcoded' in software components. Certificates and related cryptographic material like keys, tokens, secrets or passwords are other cryptographic assets to be modelled.",
            certificateProperties
              | {
                certificateExtension
                  | String
                  | doc "The file extension of the certificate"
                  | optional,
                certificateFormat
                  | String
                  | doc "The format of the certificate"
                  | optional,
                issuerName
                  | String
                  | doc "The issuer name for the certificate"
                  | optional,
                notValidAfter
                  | String
                  | doc "The date and time according to ISO-8601 standard from which the certificate is not valid anymore"
                  | optional,
                notValidBefore
                  | String
                  | doc "The date and time according to ISO-8601 standard from which the certificate is valid"
                  | optional,
                signatureAlgorithmRef
                  | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
                  | doc "The bom-ref to signature algorithm used by the certificate"
                  | optional,
                subjectName
                  | String
                  | doc "The subject name for the certificate"
                  | optional,
                subjectPublicKeyRef
                  | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
                  | doc "The bom-ref to the public key of the subject"
                  | optional,
              }
              | doc "Properties for cryptographic assets of asset type 'certificate'"
              | optional,
            oid
              | String
              | doc "The object identifier (OID) of the cryptographic asset."
              | optional,
            protocolProperties
              | {
                cipherSuites
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/cipherSuite!contract"
                  | doc "A list of cipher suites related to the protocol."
                  | optional,
                cryptoRefArray
                  | _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!contract"
                  | doc "A list of protocol-related cryptographic assets"
                  | optional,
                ikev2TransformTypes
                  | {
                    auth
                      | _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!contract"
                      | doc "IKEv2 Authentication method"
                      | optional,
                    encr
                      | _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!contract"
                      | doc "Transform Type 1: encryption algorithms"
                      | optional,
                    esn
                      | Bool
                      | doc "Specifies if an Extended Sequence Number (ESN) is used."
                      | optional,
                    integ
                      | _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!contract"
                      | doc "Transform Type 3: integrity algorithms"
                      | optional,
                    ke
                      | _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!contract"
                      | doc "Transform Type 4: Key Exchange Method (KE) per [RFC 9370](https://www.ietf.org/rfc/rfc9370.html), formerly called Diffie-Hellman Group (D-H)."
                      | optional,
                    prf
                      | _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!contract"
                      | doc "Transform Type 2: pseudorandom functions"
                      | optional,
                  }
                  | doc "The IKEv2 transform types supported (types 1-4), defined in [RFC 7296 section 3.3.2](https://www.ietf.org/rfc/rfc7296.html#section-3.3.2), and additional properties."
                  | optional,
                type
                  | std.enum.TagOrString
                  | [|
                    'unknown,
                    'other,
                    'wpa,
                    'sstp,
                    'ike,
                    'ipsec,
                    'ssh,
                    'tls
                  |]
                  | doc "The concrete protocol type."
                  | optional,
                version
                  | String
                  | doc "The version of the protocol."
                  | optional,
              }
              | doc "Properties specific to cryptographic assets of type: `protocol`."
              | optional,
            relatedCryptoMaterialProperties
              | {
                activationDate
                  | String
                  | doc "The date and time (timestamp) when the related cryptographic material was activated."
                  | optional,
                algorithmRef
                  | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
                  | doc "The bom-ref to the algorithm used to generate the related cryptographic material."
                  | optional,
                creationDate
                  | String
                  | doc "The date and time (timestamp) when the related cryptographic material was created."
                  | optional,
                expirationDate
                  | String
                  | doc "The date and time (timestamp) when the related cryptographic material expires."
                  | optional,
                format
                  | String
                  | doc "The format of the related cryptographic material (e.g. P8, PEM, DER)."
                  | optional,
                id
                  | String
                  | doc "The optional unique identifier for the related cryptographic material."
                  | optional,
                securedBy
                  | _js2n__-refsenv."_js2n__-:definitions/securedBy!contract"
                  | doc "The mechanism by which the cryptographic asset is secured by."
                  | optional,
                size
                  | std.number.Integer
                  | doc "The size of the cryptographic asset (in bits)."
                  | optional,
                state
                  | std.enum.TagOrString
                  | [|
                    'destroyed,
                    'compromised,
                    'deactivated,
                    'suspended,
                    'active,
                    'pre-activation
                  |]
                  | doc "The key state as defined by NIST SP 800-57."
                  | optional,
                type
                  | std.enum.TagOrString
                  | [|
                    'unknown,
                    'other,
                    'token,
                    'credential,
                    'password,
                    'additional-data,
                    'tag,
                    'shared-secret,
                    'salt,
                    'seed,
                    'nonce,
                    'initialization-vector,
                    'digest,
                    'signature,
                    'ciphertext,
                    'key,
                    'secret-key,
                    'public-key,
                    'private-key
                  |]
                  | doc "The type for the related cryptographic material"
                  | optional,
                updateDate
                  | String
                  | doc "The date and time (timestamp) when the related cryptographic material was updated."
                  | optional,
                value
                  | String
                  | doc "The associated value of the cryptographic material."
                  | optional,
              }
              | doc "Properties for cryptographic assets of asset type: `related-crypto-material`"
              | optional,
          },
      "_js2n__-:definitions/cryptoProperties!predicate"
        | doc "Cryptographic assets have properties that uniquely define them and that make them actionable for further reasoning. As an example, it makes a difference if one knows the algorithm family (e.g. AES) or the specific variant or instantiation (e.g. AES-128-GCM). This is because the security level and the algorithm primitive (authenticated encryption) are only defined by the definition of the algorithm variant. The presence of a weak cryptographic algorithm like SHA1 vs. HMAC-SHA1 also makes a difference."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "assetType" ],
              _js2n__-prdslib.records.record
                {
                  algorithmProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              certificationLevel =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "none",
                                                "fips140-1-l1",
                                                "fips140-1-l2",
                                                "fips140-1-l3",
                                                "fips140-1-l4",
                                                "fips140-2-l1",
                                                "fips140-2-l2",
                                                "fips140-2-l3",
                                                "fips140-2-l4",
                                                "fips140-3-l1",
                                                "fips140-3-l2",
                                                "fips140-3-l3",
                                                "fips140-3-l4",
                                                "cc-eal1",
                                                "cc-eal1+",
                                                "cc-eal2",
                                                "cc-eal2+",
                                                "cc-eal3",
                                                "cc-eal3+",
                                                "cc-eal4",
                                                "cc-eal4+",
                                                "cc-eal5",
                                                "cc-eal5+",
                                                "cc-eal6",
                                                "cc-eal6+",
                                                "cc-eal7",
                                                "cc-eal7+",
                                                "other",
                                                "unknown"
                                              ]
                                          ])
                                    ],
                              classicalSecurityLevel =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              cryptoFunctions =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "generate",
                                                "keygen",
                                                "encrypt",
                                                "decrypt",
                                                "digest",
                                                "tag",
                                                "keyderive",
                                                "sign",
                                                "verify",
                                                "encapsulate",
                                                "decapsulate",
                                                "other",
                                                "unknown"
                                              ]
                                          ])
                                    ],
                              curve = _js2n__-prdslib.isType '"String",
                              executionEnvironment =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "software-plain-ram",
                                          "software-encrypted-ram",
                                          "software-tee",
                                          "hardware",
                                          "other",
                                          "unknown"
                                        ]
                                    ],
                              implementationPlatform =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "generic",
                                          "x86_32",
                                          "x86_64",
                                          "armv7-a",
                                          "armv7-m",
                                          "armv8-a",
                                          "armv8-m",
                                          "armv9-a",
                                          "armv9-m",
                                          "s390x",
                                          "ppc64",
                                          "ppc64le",
                                          "other",
                                          "unknown"
                                        ]
                                    ],
                              mode =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "cbc",
                                          "ecb",
                                          "ccm",
                                          "gcm",
                                          "cfb",
                                          "ofb",
                                          "ctr",
                                          "other",
                                          "unknown"
                                        ]
                                    ],
                              nistQuantumSecurityLevel =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.maximum 6,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              padding =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "pkcs5",
                                          "pkcs7",
                                          "pkcs1v15",
                                          "oaep",
                                          "raw",
                                          "other",
                                          "unknown"
                                        ]
                                    ],
                              parameterSetIdentifier =
                                _js2n__-prdslib.isType '"String",
                              primitive =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "drbg",
                                          "mac",
                                          "block-cipher",
                                          "stream-cipher",
                                          "signature",
                                          "hash",
                                          "pke",
                                          "xof",
                                          "kdf",
                                          "key-agree",
                                          "kem",
                                          "ae",
                                          "combiner",
                                          "other",
                                          "unknown"
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  assetType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "algorithm",
                              "certificate",
                              "protocol",
                              "related-crypto-material"
                            ]
                        ],
                  certificateProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              certificateExtension =
                                _js2n__-prdslib.isType '"String",
                              certificateFormat =
                                _js2n__-prdslib.isType '"String",
                              issuerName = _js2n__-prdslib.isType '"String",
                              notValidAfter = _js2n__-prdslib.isType '"String",
                              notValidBefore = _js2n__-prdslib.isType '"String",
                              signatureAlgorithmRef =
                                _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                              subjectName = _js2n__-prdslib.isType '"String",
                              subjectPublicKeyRef =
                                _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  oid = _js2n__-prdslib.isType '"String",
                  protocolProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cipherSuites =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/cipherSuite!predicate"
                                    ],
                              cryptoRefArray =
                                _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!predicate",
                              ikev2TransformTypes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          auth =
                                            _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!predicate",
                                          encr =
                                            _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!predicate",
                                          esn = _js2n__-prdslib.isType '"Bool",
                                          integ =
                                            _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!predicate",
                                          ke =
                                            _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!predicate",
                                          prf =
                                            _js2n__-refsenv."_js2n__-:definitions/cryptoRefArray!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "tls",
                                          "ssh",
                                          "ipsec",
                                          "ike",
                                          "sstp",
                                          "wpa",
                                          "other",
                                          "unknown"
                                        ]
                                    ],
                              version = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  relatedCryptoMaterialProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              activationDate = _js2n__-prdslib.isType '"String",
                              algorithmRef =
                                _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                              creationDate = _js2n__-prdslib.isType '"String",
                              expirationDate = _js2n__-prdslib.isType '"String",
                              format = _js2n__-prdslib.isType '"String",
                              id = _js2n__-prdslib.isType '"String",
                              securedBy =
                                _js2n__-refsenv."_js2n__-:definitions/securedBy!predicate",
                              size = _js2n__-prdslib.isType 'Integer,
                              state =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "pre-activation",
                                          "active",
                                          "suspended",
                                          "deactivated",
                                          "compromised",
                                          "destroyed"
                                        ]
                                    ],
                              type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "private-key",
                                          "public-key",
                                          "secret-key",
                                          "key",
                                          "ciphertext",
                                          "signature",
                                          "digest",
                                          "initialization-vector",
                                          "nonce",
                                          "seed",
                                          "salt",
                                          "shared-secret",
                                          "tag",
                                          "additional-data",
                                          "password",
                                          "credential",
                                          "token",
                                          "other",
                                          "unknown"
                                        ]
                                    ],
                              updateDate = _js2n__-prdslib.isType '"String",
                              value = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cryptoRefArray!contract" =
        Array _js2n__-refsenv."_js2n__-:definitions/refType!contract",
      "_js2n__-:definitions/cryptoRefArray!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/refType!predicate"
            ],
      "_js2n__-:definitions/cwe!predicate"
        | doc "Integer representation of a Common Weaknesses Enumerations (CWE). For example 399 (of https://cwe.mitre.org/data/definitions/399.html)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/dataClassification!contract"
        | doc "Data classification tags data according to its type, sensitivity, and value if altered, stolen, or destroyed."
        = String,
      "_js2n__-:definitions/dataClassification!predicate"
        | doc "Data classification tags data according to its type, sensitivity, and value if altered, stolen, or destroyed."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/dataFlowDirection!contract"
        | doc "Specifies the flow direction of the data. Direction is relative to the service."
        = std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'unknown, 'bi-directional, 'outbound, 'inbound |]
            ],
      "_js2n__-:definitions/dataFlowDirection!predicate"
        | doc "Specifies the flow direction of the data. Direction is relative to the service."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "inbound", "outbound", "bi-directional", "unknown" ]
            ],
      "_js2n__-:definitions/dataGovernance!contract"
        | doc "Data governance captures information regarding data ownership, stewardship, and custodianship, providing insights into the individuals or entities responsible for managing, overseeing, and safeguarding the data throughout its lifecycle."
        = {
            custodians
              | Array
                _js2n__-refsenv."_js2n__-:definitions/dataGovernanceResponsibleParty!contract"
              | doc "Data custodians are responsible for the safe custody, transport, and storage of data."
              | optional,
            owners
              | Array
                _js2n__-refsenv."_js2n__-:definitions/dataGovernanceResponsibleParty!contract"
              | doc "Data owners are concerned with risk and appropriate access to data."
              | optional,
            stewards
              | Array
                _js2n__-refsenv."_js2n__-:definitions/dataGovernanceResponsibleParty!contract"
              | doc "Data stewards are responsible for data content, context, and associated business rules."
              | optional,
          },
      "_js2n__-:definitions/dataGovernance!predicate"
        | doc "Data governance captures information regarding data ownership, stewardship, and custodianship, providing insights into the individuals or entities responsible for managing, overseeing, and safeguarding the data throughout its lifecycle."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  custodians =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/dataGovernanceResponsibleParty!predicate"
                        ],
                  owners =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/dataGovernanceResponsibleParty!predicate"
                        ],
                  stewards =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/dataGovernanceResponsibleParty!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dataGovernanceResponsibleParty!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "organization" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "contact" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ]
                  ],
                _js2n__-prdslib.records.record
                  {
                    contact =
                      _js2n__-refsenv."_js2n__-:definitions/organizationalContact!predicate",
                    organization =
                      _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                  } {} false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/dataGovernanceResponsibleParty!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "organization" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "contact" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  contact =
                    _js2n__-refsenv."_js2n__-:definitions/organizationalContact!predicate",
                  organization =
                    _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dependency!predicate"
        | doc "Defines the direct dependencies of a component, service, or the components provided/implemented by a given component. Components or services that do not have their own dependencies must be declared as empty elements within the graph. Components or services that are not represented in the dependency graph may have unknown dependencies. It is recommended that implementations assume this to be opaque and not an indicator of an object being dependency-free. It is recommended to leverage compositions to indicate unknown dependency graphs."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "ref" ],
              _js2n__-prdslib.records.record
                {
                  dependsOn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  provides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  ref =
                    _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/diff!contract"
        | doc "The patch file (or diff) that shows changes. Refer to https://en.wikipedia.org/wiki/Diff"
        = {
            text
              | _js2n__-refsenv."_js2n__-:definitions/attachment!contract"
              | doc "Specifies the optional text of the diff"
              | optional,
            url | String | doc "Specifies the URL to the diff" | optional,
          },
      "_js2n__-:definitions/diff!predicate"
        | doc "The patch file (or diff) that shows changes. Refer to https://en.wikipedia.org/wiki/Diff"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/energyConsumption!contract"
        | doc "Describes energy consumption information incurred for the specified lifecycle activity."
        = {
            activity
              | std.enum.TagOrString
              | [|
                'other,
                'inference,
                'deployment,
                'validation,
                'fine-tuning,
                'training,
                'data-preparation,
                'data-collection,
                'design
              |]
              | doc "The type of activity that is part of a machine learning model development or operational lifecycle.",
            activityEnergyCost
              | _js2n__-refsenv."_js2n__-:definitions/energyMeasure!contract"
              | doc "The total energy cost associated with the model lifecycle activity.",
            co2CostEquivalent
              | _js2n__-refsenv."_js2n__-:definitions/co2Measure!contract"
              | doc "The CO2 cost (debit) equivalent to the total energy cost."
              | optional,
            co2CostOffset
              | _js2n__-refsenv."_js2n__-:definitions/co2Measure!contract"
              | doc "The CO2 offset (credit) for the CO2 equivalent cost."
              | optional,
            energyProviders
              | Array
                _js2n__-refsenv."_js2n__-:definitions/energyProvider!contract"
              | doc "The provider(s) of the energy consumed by the associated model development lifecycle activity.",
            properties
              | Array _js2n__-refsenv."_js2n__-:definitions/property!contract"
              | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
              | optional,
          },
      "_js2n__-:definitions/energyConsumption!predicate"
        | doc "Describes energy consumption information incurred for the specified lifecycle activity."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "activity", "activityEnergyCost", "energyProviders" ],
              _js2n__-prdslib.records.record
                {
                  activity =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "design",
                              "data-collection",
                              "data-preparation",
                              "training",
                              "fine-tuning",
                              "validation",
                              "deployment",
                              "inference",
                              "other"
                            ]
                        ],
                  activityEnergyCost =
                    _js2n__-refsenv."_js2n__-:definitions/energyMeasure!predicate",
                  co2CostEquivalent =
                    _js2n__-refsenv."_js2n__-:definitions/co2Measure!predicate",
                  co2CostOffset =
                    _js2n__-refsenv."_js2n__-:definitions/co2Measure!predicate",
                  energyProviders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/energyProvider!predicate"
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/energyMeasure!contract"
        | doc "A measure of energy."
        = {
            unit | std.enum.TagOrString | [| 'kWh |] | doc "Unit of energy.",
            value | Number | doc "Quantity of energy.",
          },
      "_js2n__-:definitions/energyMeasure!predicate"
        | doc "A measure of energy."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "unit", "value" ],
              _js2n__-prdslib.records.record
                {
                  unit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "kWh" ]
                        ],
                  value = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/energyProvider!contract"
        | doc "Describes the physical provider of energy used for model development or operations."
        = {
            bom-ref
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc m%"
                An optional identifier which can be used to reference the energy provider elsewhere in the BOM. Every bom-ref must be unique within the BOM.
                Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
              "%
              | optional,
            description
              | String
              | doc "A description of the energy provider."
              | optional,
            energyProvided
              | _js2n__-refsenv."_js2n__-:definitions/energyMeasure!contract"
              | doc "The energy provided by the energy source for an associated activity.",
            energySource
              | std.enum.TagOrString
              | [|
                'other,
                'unknown,
                'biofuel,
                'hydropower,
                'geothermal,
                'solar,
                'wind,
                'nuclear,
                'natural-gas,
                'oil,
                'coal
              |]
              | doc "The energy source for the energy provider.",
            externalReferences
              | Array
                _js2n__-refsenv."_js2n__-:definitions/externalReference!contract"
              | doc "External references provide a way to document systems, sites, and information that may be relevant but are not included with the BOM. They may also establish specific relationships within or external to the BOM."
              | optional,
            organization
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate"
                  ])
              | doc "The organization that provides energy.",
          },
      "_js2n__-:definitions/energyProvider!predicate"
        | doc "Describes the physical provider of energy used for model development or operations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "energyProvided", "energySource", "organization" ],
              _js2n__-prdslib.records.record
                {
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  energyProvided =
                    _js2n__-refsenv."_js2n__-:definitions/energyMeasure!predicate",
                  energySource =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "coal",
                              "oil",
                              "natural-gas",
                              "nuclear",
                              "wind",
                              "solar",
                              "geothermal",
                              "hydropower",
                              "biofuel",
                              "unknown",
                              "other"
                            ]
                        ],
                  externalReferences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalReference!predicate"
                        ],
                  organization =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/environmentalConsiderations!contract"
        | doc "Describes various environmental impact metrics."
        = {
            energyConsumptions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/energyConsumption!contract"
              | doc "Describes energy consumption information incurred for one or more component lifecycle activities."
              | optional,
            properties
              | Array _js2n__-refsenv."_js2n__-:definitions/property!contract"
              | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
              | optional,
          },
      "_js2n__-:definitions/environmentalConsiderations!predicate"
        | doc "Describes various environmental impact metrics."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  energyConsumptions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/energyConsumption!predicate"
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/event!predicate"
        | doc "Represents something that happened that may trigger a response."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data =
                    _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                  target =
                    _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                  timeReceived = _js2n__-prdslib.isType '"String",
                  uid = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/externalReference!contract"
        | doc "External references provide a way to document systems, sites, and information that may be relevant but are not included with the BOM. They may also establish specific relationships within or external to the BOM."
        = {
            comment
              | String
              | doc "An optional comment describing the external reference"
              | optional,
            hashes
              | Array _js2n__-refsenv."_js2n__-:definitions/hash!contract"
              | doc "The hashes of the external reference (if applicable)."
              | optional,
            type
              | std.enum.TagOrString
              | [|
                'other,
                'rfc-9116,
                'digital-signature,
                'electronic-signature,
                'poam,
                'quality-metrics,
                'codified-infrastructure,
                'certification-report,
                'maturity-report,
                'component-analysis-report,
                'runtime-analysis-report,
                'dynamic-analysis-report,
                'static-analysis-report,
                'pentest-report,
                'exploitability-statement,
                'vulnerability-assertion,
                'risk-assessment,
                'adversary-model,
                'threat-model,
                'attestation,
                'formulation,
                'evidence,
                'configuration,
                'log,
                'model-card,
                'security-contact,
                'release-notes,
                'build-system,
                'build-meta,
                'license,
                'distribution-intake,
                'distribution,
                'source-distribution,
                'support,
                'documentation,
                'chat,
                'social,
                'mailing-list,
                'bom,
                'advisories,
                'website,
                'issue-tracker,
                'vcs
              |]
              | doc "Specifies the type of external reference.",
            url
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-refsenv."_js2n__-:definitions/bomLink!predicate"
                  ])
              | doc "The URI (URL or URN) to the external reference. External references are URIs and therefore can accept any URL scheme including https ([RFC-7230](https://www.ietf.org/rfc/rfc7230.txt)), mailto ([RFC-2368](https://www.ietf.org/rfc/rfc2368.txt)), tel ([RFC-3966](https://www.ietf.org/rfc/rfc3966.txt)), and dns ([RFC-4501](https://www.ietf.org/rfc/rfc4501.txt)). External references may also include formally registered URNs such as [CycloneDX BOM-Link](https://cyclonedx.org/capabilities/bomlink/) to reference CycloneDX BOMs or any object within a BOM. BOM-Link transforms applicable external references into relationships that can be expressed in a BOM or across BOMs.",
          },
      "_js2n__-:definitions/externalReference!predicate"
        | doc "External references provide a way to document systems, sites, and information that may be relevant but are not included with the BOM. They may also establish specific relationships within or external to the BOM."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type", "url" ],
              _js2n__-prdslib.records.record
                {
                  comment = _js2n__-prdslib.isType '"String",
                  hashes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/hash!predicate"
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "vcs",
                              "issue-tracker",
                              "website",
                              "advisories",
                              "bom",
                              "mailing-list",
                              "social",
                              "chat",
                              "documentation",
                              "support",
                              "source-distribution",
                              "distribution",
                              "distribution-intake",
                              "license",
                              "build-meta",
                              "build-system",
                              "release-notes",
                              "security-contact",
                              "model-card",
                              "log",
                              "configuration",
                              "evidence",
                              "formulation",
                              "attestation",
                              "threat-model",
                              "adversary-model",
                              "risk-assessment",
                              "vulnerability-assertion",
                              "exploitability-statement",
                              "pentest-report",
                              "static-analysis-report",
                              "dynamic-analysis-report",
                              "runtime-analysis-report",
                              "component-analysis-report",
                              "maturity-report",
                              "certification-report",
                              "codified-infrastructure",
                              "quality-metrics",
                              "poam",
                              "electronic-signature",
                              "digital-signature",
                              "rfc-9116",
                              "other"
                            ]
                        ],
                  url =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/bomLink!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/fairnessAssessment!contract"
        | doc "Information about the benefits and harms of the model to an identified at risk group."
        = {
            benefits
              | String
              | doc "Expected benefits to the identified groups."
              | optional,
            groupAtRisk
              | String
              | doc "The groups or individuals at risk of being systematically disadvantaged by the model."
              | optional,
            harms
              | String
              | doc "Expected harms to the identified groups."
              | optional,
            mitigationStrategy
              | String
              | doc "With respect to the benefits and harms outlined, please describe any mitigation strategy implemented."
              | optional,
          },
      "_js2n__-:definitions/fairnessAssessment!predicate"
        | doc "Information about the benefits and harms of the model to an identified at risk group."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  benefits = _js2n__-prdslib.isType '"String",
                  groupAtRisk = _js2n__-prdslib.isType '"String",
                  harms = _js2n__-prdslib.isType '"String",
                  mitigationStrategy = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/formula!predicate"
        | doc "Describes workflows and resources that captures rules and other aspects of how the associated BOM component or service was formed."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  components =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  services =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  workflows =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/workflow!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/graphic!contract" =
        {
            image
              | _js2n__-refsenv."_js2n__-:definitions/attachment!contract"
              | doc "The graphic (vector or raster). Base64 encoding must be specified for binary images."
              | optional,
            name | String | doc "The name of the graphic." | optional,
          },
      "_js2n__-:definitions/graphic!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/graphicsCollection!contract"
        | doc "A collection of graphics that represent various measurements."
        = {
            collection
              | Array _js2n__-refsenv."_js2n__-:definitions/graphic!contract"
              | doc "A collection of graphics."
              | optional,
            description
              | String
              | doc "A description of this collection of graphics."
              | optional,
          },
      "_js2n__-:definitions/graphicsCollection!predicate"
        | doc "A collection of graphics that represent various measurements."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  collection =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/graphic!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/hash!contract" =
        {
            alg | _js2n__-refsenv."_js2n__-:definitions/hash-alg!contract",
            content
              | _js2n__-refsenv."_js2n__-:definitions/hash-content!contract",
          },
      "_js2n__-:definitions/hash!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "alg", "content" ],
              _js2n__-prdslib.records.record
                {
                  alg =
                    _js2n__-refsenv."_js2n__-:definitions/hash-alg!predicate",
                  content =
                    _js2n__-refsenv."_js2n__-:definitions/hash-content!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/hash-alg!contract"
        | doc "The algorithm that generated the hash value."
        = std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'BLAKE3,
                'BLAKE2b-512,
                'BLAKE2b-384,
                'BLAKE2b-256,
                'SHA3-512,
                'SHA3-384,
                'SHA3-256,
                'SHA-512,
                'SHA-384,
                'SHA-256,
                'SHA-1,
                'MD5
              |]
            ],
      "_js2n__-:definitions/hash-alg!predicate"
        | doc "The algorithm that generated the hash value."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "MD5",
                  "SHA-1",
                  "SHA-256",
                  "SHA-384",
                  "SHA-512",
                  "SHA3-256",
                  "SHA3-384",
                  "SHA3-512",
                  "BLAKE2b-256",
                  "BLAKE2b-384",
                  "BLAKE2b-512",
                  "BLAKE3"
                ]
            ],
      "_js2n__-:definitions/hash-content!contract"
        | doc "The value of the hash."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^([a-fA-F0-9]{32}|[a-fA-F0-9]{40}|[a-fA-F0-9]{64}|[a-fA-F0-9]{96}|[a-fA-F0-9]{128})$"
              ]),
      "_js2n__-:definitions/hash-content!predicate"
        | doc "The value of the hash."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^([a-fA-F0-9]{32}|[a-fA-F0-9]{40}|[a-fA-F0-9]{64}|[a-fA-F0-9]{96}|[a-fA-F0-9]{128})$"
            ],
      "_js2n__-:definitions/identifiableAction!contract"
        | doc "Specifies an individual commit"
        = {
            email
              | String
              | doc "The email address of the individual who performed the action"
              | optional,
            name
              | String
              | doc "The name of the individual who performed the action"
              | optional,
            timestamp
              | String
              | doc "The timestamp in which the action occurred"
              | optional,
          },
      "_js2n__-:definitions/identifiableAction!predicate"
        | doc "Specifies an individual commit"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  email = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  timestamp = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/impactAnalysisJustification!predicate"
        | doc "The rationale of why the impact analysis state was asserted."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "code_not_present",
                  "code_not_reachable",
                  "requires_configuration",
                  "requires_dependency",
                  "requires_environment",
                  "protected_by_compiler",
                  "protected_at_runtime",
                  "protected_at_perimeter",
                  "protected_by_mitigating_control"
                ]
            ],
      "_js2n__-:definitions/impactAnalysisState!predicate"
        | doc "Declares the current state of an occurrence of a vulnerability, after automated or manual analysis."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "resolved",
                  "resolved_with_pedigree",
                  "exploitable",
                  "in_triage",
                  "false_positive",
                  "not_affected"
                ]
            ],
      "_js2n__-:definitions/inputOutputMLParameters!contract" =
        {
            format
              | String
              | doc "The data format for input/output to the model."
              | optional,
          },
      "_js2n__-:definitions/inputOutputMLParameters!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { format = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/inputType!predicate"
        | doc "Type that represents various input data types and formats."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "resource" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "parameters" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "environmentVars" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "data" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  data =
                    _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                  environmentVars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/property!predicate",
                                _js2n__-prdslib.isType '"String"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/parameter!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  resource =
                    _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                  target =
                    _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/issue!contract"
        | doc "An individual issue that has been resolved."
        = {
            description | String | doc "A description of the issue" | optional,
            id
              | String
              | doc "The identifier of the issue assigned by the source of the issue"
              | optional,
            name | String | doc "The name of the issue" | optional,
            references
              | Array (String)
              | doc "A collection of URL's for reference. Multiple URLs are allowed."
              | optional,
            source
              | {
                name | String | doc "The name of the source." | optional,
                url
                  | String
                  | doc "The url of the issue documentation as provided by the source"
                  | optional,
              }
              | doc "The source of the issue where it is documented"
              | optional,
            type
              | std.enum.TagOrString
              | [| 'security, 'enhancement, 'defect |]
              | doc "Specifies the type of issue",
          },
      "_js2n__-:definitions/issue!predicate"
        | doc "An individual issue that has been resolved."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  references =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  source =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              name = _js2n__-prdslib.isType '"String",
                              url = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "defect", "enhancement", "security" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/license!predicate"
        | doc "Specifies the details and attributes related to a software license. It can either include a valid SPDX license identifier or a named license, along with additional properties such as license acknowledgment, comprehensive commercial licensing information, and the full text of the license."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "name" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  acknowledgement =
                    _js2n__-refsenv."_js2n__-:definitions/licenseAcknowledgementEnumeration!predicate",
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  id = _js2n__-prdslib.always,
                  licensing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              altIds =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              expiration = _js2n__-prdslib.isType '"String",
                              lastRenewal = _js2n__-prdslib.isType '"String",
                              licenseTypes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "academic",
                                                "appliance",
                                                "client-access",
                                                "concurrent-user",
                                                "core-points",
                                                "custom-metric",
                                                "device",
                                                "evaluation",
                                                "named-user",
                                                "node-locked",
                                                "oem",
                                                "perpetual",
                                                "processor-points",
                                                "subscription",
                                                "user",
                                                "other"
                                              ]
                                          ])
                                    ],
                              licensee =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "organization" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "individual" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ]
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          individual =
                                            _js2n__-refsenv."_js2n__-:definitions/organizationalContact!predicate",
                                          organization =
                                            _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              licensor =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "organization" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "individual" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ]
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          individual =
                                            _js2n__-refsenv."_js2n__-:definitions/organizationalContact!predicate",
                                          organization =
                                            _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              purchaseOrder = _js2n__-prdslib.isType '"String",
                              purchaser =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "organization" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "individual" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ]
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          individual =
                                            _js2n__-refsenv."_js2n__-:definitions/organizationalContact!predicate",
                                          organization =
                                            _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/licenseAcknowledgementEnumeration!predicate"
        | doc "Declared licenses and concluded licenses represent two different stages in the licensing process within software development. Declared licenses refer to the initial intention of the software authors regarding the licensing terms under which their code is released. On the other hand, concluded licenses are the result of a comprehensive analysis of the project's codebase to identify and confirm the actual licenses of the components used, which may differ from the initially declared licenses. While declared licenses provide an upfront indication of the licensing intentions, concluded licenses offer a more thorough understanding of the actual licensing within a project, facilitating proper compliance and risk management. Observed licenses are defined in `@.evidence.licenses`. Observed licenses form the evidence necessary to substantiate a concluded license."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "declared", "concluded" ]
            ],
      "_js2n__-:definitions/licenseChoice!contract"
        | doc "EITHER (list of SPDX licenses and/or named licenses) OR (tuple of one SPDX License Expression)"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "license" ],
                              _js2n__-prdslib.records.record
                                {
                                  license =
                                    _js2n__-refsenv."_js2n__-:definitions/license!predicate",
                                } {} false _js2n__-prdslib.never
                            ])
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.items
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "expression" ],
                                _js2n__-prdslib.records.record
                                  {
                                    acknowledgement =
                                      _js2n__-refsenv."_js2n__-:definitions/licenseAcknowledgementEnumeration!predicate",
                                    bom-ref =
                                      _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                                    expression =
                                      _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ]
                          ],
                        _js2n__-prdslib.arrays.additionalItems
                          _js2n__-prdslib.never 1,
                        _js2n__-prdslib.arrays.maxItems 1,
                        _js2n__-prdslib.arrays.minItems 1
                      ]
                  ]
              ]),
      "_js2n__-:definitions/licenseChoice!predicate"
        | doc "EITHER (list of SPDX licenses and/or named licenses) OR (tuple of one SPDX License Expression)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required [ "license" ],
                            _js2n__-prdslib.records.record
                              {
                                license =
                                  _js2n__-refsenv."_js2n__-:definitions/license!predicate",
                              } {} false _js2n__-prdslib.never
                          ])
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.items
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "expression" ],
                              _js2n__-prdslib.records.record
                                {
                                  acknowledgement =
                                    _js2n__-refsenv."_js2n__-:definitions/licenseAcknowledgementEnumeration!predicate",
                                  bom-ref =
                                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                                  expression = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                      _js2n__-prdslib.arrays.additionalItems
                        _js2n__-prdslib.never 1,
                      _js2n__-prdslib.arrays.maxItems 1,
                      _js2n__-prdslib.arrays.minItems 1
                    ]
                ]
            ],
      "_js2n__-:definitions/localeType!contract"
        | doc "Defines a syntax for representing two character language code (ISO-639) followed by an optional two character country code. The language code must be lower case. If the country code is specified, the country code must be upper case. The language code and country code must be separated by a minus sign. Examples: en, en-US, fr, fr-CA"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^([a-z]{2})(-[A-Z]{2})?$"
              ]),
      "_js2n__-:definitions/localeType!predicate"
        | doc "Defines a syntax for representing two character language code (ISO-639) followed by an optional two character country code. The language code must be lower case. If the country code is specified, the country code must be upper case. The language code and country code must be separated by a minus sign. Examples: en, en-US, fr, fr-CA"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^([a-z]{2})(-[A-Z]{2})?$"
            ],
      "_js2n__-:definitions/metadata!contract" =
        {
            authors
              | Array
                _js2n__-refsenv."_js2n__-:definitions/organizationalContact!contract"
              | doc m%"
                The person(s) who created the BOM.
                Authors are common in BOMs created through manual processes. BOMs created through automated means may have `@.manufacturer` instead.
              "%
              | optional,
            component
              | _js2n__-refsenv."_js2n__-:definitions/component!contract"
              | doc "The component that the BOM describes."
              | optional,
            licenses
              | _js2n__-refsenv."_js2n__-:definitions/licenseChoice!contract"
              | doc m%"
                The license information for the BOM document.
                This may be different from the license(s) of the component(s) that the BOM describes.
              "%
              | optional,
            lifecycles
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "phase" ],
                              _js2n__-prdslib.records.record
                                {
                                  phase =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "design",
                                              "pre-build",
                                              "build",
                                              "post-build",
                                              "operations",
                                              "discovery",
                                              "decommission"
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "name" ],
                              _js2n__-prdslib.records.record
                                {
                                  description =
                                    _js2n__-prdslib.isType '"String",
                                  name = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never
                            ]
                        ]
                    ])
              )
              | doc "Lifecycles communicate the stage(s) in which data in the BOM was captured. Different types of data may be available at various phases of a lifecycle, such as the Software Development Lifecycle (SDLC), IT Asset Management (ITAM), and Software Asset Management (SAM). Thus, a BOM may include data specific to or only obtainable in a given lifecycle."
              | optional,
            manufacture
              | _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!contract"
              | doc m%"
                [Deprecated] This will be removed in a future version. Use the `@.component.manufacturer` instead.
                The organization that manufactured the component that the BOM describes.
              "%
              | optional,
            manufacturer
              | _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!contract"
              | doc m%"
                The organization that created the BOM.
                Manufacturer is common in BOMs created through automated processes. BOMs created through manual means may have `@.authors` instead.
              "%
              | optional,
            properties
              | Array _js2n__-refsenv."_js2n__-:definitions/property!contract"
              | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
              | optional,
            supplier
              | _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!contract"
              | doc " The organization that supplied the component that the BOM describes. The supplier may often be the manufacturer, but may also be a distributor or repackager."
              | optional,
            timestamp
              | String
              | doc "The date and time (timestamp) when the BOM was created."
              | optional,
            tools
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            components =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                                    _js2n__-prdslib.arrays.uniqueItems
                                  ],
                            services =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                                    _js2n__-prdslib.arrays.uniqueItems
                                  ],
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          _js2n__-refsenv."_js2n__-:definitions/tool!predicate"
                      ]
                  ])
              | doc "The tool(s) used in the creation, enrichment, and validation of the BOM."
              | optional,
          },
      "_js2n__-:definitions/modelCard!contract"
        | doc "A model card describes the intended uses of a machine learning model and potential limitations, including biases and ethical considerations. Model cards typically contain the training parameters, which datasets were used to train the model, performance metrics, and other relevant data useful for ML transparency. This object SHOULD be specified for any component of type `machine-learning-model` and must not be specified for other component types."
        = {
            bom-ref
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc m%"
                An optional identifier which can be used to reference the model card elsewhere in the BOM. Every bom-ref must be unique within the BOM.
                Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
              "%
              | optional,
            considerations
              | {
                environmentalConsiderations
                  | _js2n__-refsenv."_js2n__-:definitions/environmentalConsiderations!contract"
                  | doc "What are the various environmental impacts the corresponding machine learning model has exhibited across its lifecycle?"
                  | optional,
                ethicalConsiderations
                  | Array _js2n__-refsenv."_js2n__-:definitions/risk!contract"
                  | doc "What are the ethical risks involved in the application of this model?"
                  | optional,
                fairnessAssessments
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/fairnessAssessment!contract"
                  | doc "How does the model affect groups at risk of being systematically disadvantaged? What are the harms and benefits to the various affected groups?"
                  | optional,
                performanceTradeoffs
                  | Array (String)
                  | doc "What are the known tradeoffs in accuracy/performance of the model?"
                  | optional,
                technicalLimitations
                  | Array (String)
                  | doc "What are the known technical limitations of the model? E.g. What kind(s) of data should the model be expected not to perform well on? What are the factors that might degrade model performance?"
                  | optional,
                useCases
                  | Array (String)
                  | doc "What are the intended use cases of the model?"
                  | optional,
                users
                  | Array (String)
                  | doc "Who are the intended users of the model?"
                  | optional,
              }
              | doc "What considerations should be taken into account regarding the model's construction, training, and application?"
              | optional,
            modelParameters
              | {
                approach
                  | {
                    type
                      | std.enum.TagOrString
                      | [|
                        'self-supervised,
                        'semi-supervised,
                        'reinforcement-learning,
                        'unsupervised,
                        'supervised
                      |]
                      | doc "Learning types describing the learning problem or hybrid learning problem."
                      | optional,
                  }
                  | doc "The overall approach to learning used by the model for problem solving."
                  | optional,
                architectureFamily
                  | String
                  | doc "The model architecture family such as transformer network, convolutional neural network, residual neural network, LSTM neural network, etc."
                  | optional,
                datasets
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/componentData!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  ref =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ])
                  )
                  | doc "The datasets used to train and evaluate the model."
                  | optional,
                inputs
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/inputOutputMLParameters!contract"
                  | doc "The input format(s) of the model"
                  | optional,
                modelArchitecture
                  | String
                  | doc "The specific architecture of the model such as GPT-1, ResNet-50, YOLOv3, etc."
                  | optional,
                outputs
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/inputOutputMLParameters!contract"
                  | doc "The output format(s) from the model"
                  | optional,
                task
                  | String
                  | doc "Directly influences the input and/or output. Examples include classification, regression, clustering, etc."
                  | optional,
              }
              | doc "Hyper-parameters for construction of the model."
              | optional,
            properties
              | Array _js2n__-refsenv."_js2n__-:definitions/property!contract"
              | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
              | optional,
            quantitativeAnalysis
              | {
                graphics
                  | _js2n__-refsenv."_js2n__-:definitions/graphicsCollection!contract"
                  | optional,
                performanceMetrics
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/performanceMetric!contract"
                  | doc "The model performance metrics being reported. Examples may include accuracy, F1 score, precision, top-3 error rates, MSC, etc."
                  | optional,
              }
              | doc "A quantitative analysis of the model"
              | optional,
          },
      "_js2n__-:definitions/modelCard!predicate"
        | doc "A model card describes the intended uses of a machine learning model and potential limitations, including biases and ethical considerations. Model cards typically contain the training parameters, which datasets were used to train the model, performance metrics, and other relevant data useful for ML transparency. This object SHOULD be specified for any component of type `machine-learning-model` and must not be specified for other component types."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  considerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              environmentalConsiderations =
                                _js2n__-refsenv."_js2n__-:definitions/environmentalConsiderations!predicate",
                              ethicalConsiderations =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/risk!predicate"
                                    ],
                              fairnessAssessments =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/fairnessAssessment!predicate"
                                    ],
                              performanceTradeoffs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              technicalLimitations =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              useCases =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              users =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  modelParameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              approach =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          type =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "supervised",
                                                      "unsupervised",
                                                      "reinforcement-learning",
                                                      "semi-supervised",
                                                      "self-supervised"
                                                    ]
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              architectureFamily =
                                _js2n__-prdslib.isType '"String",
                              datasets =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.oneOf
                                          [
                                            _js2n__-refsenv."_js2n__-:definitions/componentData!predicate",
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    ref =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"String",
                                                            _js2n__-prdslib.anyOf
                                                              [
                                                                _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                                                                _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                                                              ]
                                                          ],
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ]
                                          ])
                                    ],
                              inputs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/inputOutputMLParameters!predicate"
                                    ],
                              modelArchitecture =
                                _js2n__-prdslib.isType '"String",
                              outputs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/inputOutputMLParameters!predicate"
                                    ],
                              task = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  quantitativeAnalysis =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              graphics =
                                _js2n__-refsenv."_js2n__-:definitions/graphicsCollection!predicate",
                              performanceMetrics =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/performanceMetric!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/note!contract"
        | doc "A note containing the locale and content."
        = {
            locale
              | _js2n__-refsenv."_js2n__-:definitions/localeType!contract"
              | doc "The ISO-639 (or higher) language code and optional ISO-3166 (or higher) country code. Examples include: \"en\", \"en-US\", \"fr\" and \"fr-CA\""
              | optional,
            text
              | _js2n__-refsenv."_js2n__-:definitions/attachment!contract"
              | doc "Specifies the full content of the release note.",
          },
      "_js2n__-:definitions/note!predicate"
        | doc "A note containing the locale and content."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "text" ],
              _js2n__-prdslib.records.record
                {
                  locale =
                    _js2n__-refsenv."_js2n__-:definitions/localeType!predicate",
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/organizationalContact!contract" =
        {
            bom-ref
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc m%"
                An optional identifier which can be used to reference the object elsewhere in the BOM. Every bom-ref must be unique within the BOM.
                Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
              "%
              | optional,
            email | String | doc "The email address of the contact." | optional,
            name | String | doc "The name of a contact" | optional,
            phone | String | doc "The phone number of the contact." | optional,
          },
      "_js2n__-:definitions/organizationalContact!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  email = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  phone = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/organizationalEntity!contract" =
        {
            address
              | _js2n__-refsenv."_js2n__-:definitions/postalAddress!contract"
              | doc "The physical address (location) of the organization"
              | optional,
            bom-ref
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc m%"
                An optional identifier which can be used to reference the object elsewhere in the BOM. Every bom-ref must be unique within the BOM.
                Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
              "%
              | optional,
            contact
              | Array
                _js2n__-refsenv."_js2n__-:definitions/organizationalContact!contract"
              | doc "A contact at the organization. Multiple contacts are allowed."
              | optional,
            name | String | doc "The name of the organization" | optional,
            url
              | Array (String)
              | doc "The URL of the organization. Multiple URLs are allowed."
              | optional,
          },
      "_js2n__-:definitions/organizationalEntity!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/postalAddress!predicate",
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  contact =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/organizationalContact!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/outputType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "resource" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "environmentVars" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "data" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  data =
                    _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                  environmentVars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/property!predicate",
                                _js2n__-prdslib.isType '"String"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  resource =
                    _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                  target =
                    _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "artifact",
                              "attestation",
                              "log",
                              "evidence",
                              "metrics",
                              "other"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/parameter!predicate"
        | doc "A representation of a functional parameter."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataType = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/patch!contract"
        | doc "Specifies an individual patch"
        = {
            diff
              | _js2n__-refsenv."_js2n__-:definitions/diff!contract"
              | doc "The patch file (or diff) that shows changes. Refer to [https://en.wikipedia.org/wiki/Diff](https://en.wikipedia.org/wiki/Diff)"
              | optional,
            resolves
              | Array _js2n__-refsenv."_js2n__-:definitions/issue!contract"
              | doc "A collection of issues the patch resolves"
              | optional,
            type
              | std.enum.TagOrString
              | [| 'cherry-pick, 'backport, 'monkey, 'unofficial |]
              | doc "Specifies the purpose for the patch including the resolution of defects, security issues, or new behavior or functionality.",
          },
      "_js2n__-:definitions/patch!predicate"
        | doc "Specifies an individual patch"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  diff = _js2n__-refsenv."_js2n__-:definitions/diff!predicate",
                  resolves =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/issue!predicate"
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "unofficial",
                              "monkey",
                              "backport",
                              "cherry-pick"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/performanceMetric!contract" =
        {
            confidenceInterval
              | {
                lowerBound
                  | String
                  | doc "The lower bound of the confidence interval."
                  | optional,
                upperBound
                  | String
                  | doc "The upper bound of the confidence interval."
                  | optional,
              }
              | doc "The confidence interval of the metric."
              | optional,
            slice
              | String
              | doc "The name of the slice this metric was computed on. By default, assume this metric is not sliced."
              | optional,
            type | String | doc "The type of performance metric." | optional,
            value
              | String
              | doc "The value of the performance metric."
              | optional,
          },
      "_js2n__-:definitions/performanceMetric!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  confidenceInterval =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              lowerBound = _js2n__-prdslib.isType '"String",
                              upperBound = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  slice = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/postalAddress!contract"
        | doc "An address used to identify a contactable location."
        = {
            bom-ref
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc m%"
                An optional identifier which can be used to reference the address elsewhere in the BOM. Every bom-ref must be unique within the BOM.
                Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
              "%
              | optional,
            country
              | String
              | doc "The country name or the two-letter ISO 3166-1 country code."
              | optional,
            locality
              | String
              | doc "The locality or city within the country."
              | optional,
            postOfficeBoxNumber
              | String
              | doc "The post office box number."
              | optional,
            postalCode | String | doc "The postal code." | optional,
            region
              | String
              | doc "The region or state in the country."
              | optional,
            streetAddress | String | doc "The street address." | optional,
          },
      "_js2n__-:definitions/postalAddress!predicate"
        | doc "An address used to identify a contactable location."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  country = _js2n__-prdslib.isType '"String",
                  locality = _js2n__-prdslib.isType '"String",
                  postOfficeBoxNumber = _js2n__-prdslib.isType '"String",
                  postalCode = _js2n__-prdslib.isType '"String",
                  region = _js2n__-prdslib.isType '"String",
                  streetAddress = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/property!contract"
        | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
        = {
            name
              | String
              | doc "The name of the property. Duplicate names are allowed, each potentially having a different value.",
            value | String | doc "The value of the property." | optional,
          },
      "_js2n__-:definitions/property!predicate"
        | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rating!predicate"
        | doc "Defines the severity or risk ratings of a vulnerability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  justification = _js2n__-prdslib.isType '"String",
                  method =
                    _js2n__-refsenv."_js2n__-:definitions/scoreMethod!predicate",
                  score = _js2n__-prdslib.isType '"Number",
                  severity =
                    _js2n__-refsenv."_js2n__-:definitions/severity!predicate",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/vulnerabilitySource!predicate",
                  vector = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/refLinkType!contract"
        | doc m%"
          Descriptor for an element identified by the attribute 'bom-ref' in the same BOM document.
          In contrast to `bomLinkElementType`.
        "%
        = _js2n__-refsenv."_js2n__-:definitions/refType!contract",
      "_js2n__-:definitions/refLinkType!predicate"
        | doc m%"
          Descriptor for an element identified by the attribute 'bom-ref' in the same BOM document.
          In contrast to `bomLinkElementType`.
        "%
        = _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
      "_js2n__-:definitions/refType!contract"
        | doc m%"
          Identifier for referable and therefore interlinkable elements.
          Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
        "%
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/refType!predicate"
        | doc m%"
          Identifier for referable and therefore interlinkable elements.
          Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/releaseNotes!contract" =
        {
            aliases
              | Array (String)
              | doc "One or more alternate names the release may be referred to. This may include unofficial terms used by development and marketing teams (e.g. code names)."
              | optional,
            description
              | String
              | doc "A short description of the release."
              | optional,
            featuredImage
              | String
              | doc "The URL to an image that may be prominently displayed with the release note."
              | optional,
            notes
              | Array _js2n__-refsenv."_js2n__-:definitions/note!contract"
              | doc "Zero or more release notes containing the locale and content. Multiple note objects may be specified to support release notes in a wide variety of languages."
              | optional,
            properties
              | Array _js2n__-refsenv."_js2n__-:definitions/property!contract"
              | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
              | optional,
            resolves
              | Array _js2n__-refsenv."_js2n__-:definitions/issue!contract"
              | doc "A collection of issues that have been resolved."
              | optional,
            socialImage
              | String
              | doc "The URL to an image that may be used in messaging on social media platforms."
              | optional,
            tags
              | _js2n__-refsenv."_js2n__-:definitions/tags!contract"
              | optional,
            timestamp
              | String
              | doc "The date and time (timestamp) when the release note was created."
              | optional,
            title | String | doc "The title of the release." | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/releaseType!contract"
              | doc "The software versioning type the release note describes.",
          },
      "_js2n__-:definitions/releaseNotes!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  featuredImage = _js2n__-prdslib.isType '"String",
                  notes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/note!predicate"
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  resolves =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/issue!predicate"
                        ],
                  socialImage = _js2n__-prdslib.isType '"String",
                  tags = _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                  timestamp = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/releaseType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/releaseType!contract"
        | doc m%"
          The software versioning type. It is recommended that the release type use one of 'major', 'minor', 'patch', 'pre-release', or 'internal'. Representing all possible software release types is not practical, so standardizing on the recommended values, whenever possible, is strongly encouraged.
          
          * __major__ = A major release may contain significant changes or may introduce breaking changes.
          * __minor__ = A minor release, also known as an update, may contain a smaller number of changes than major releases.
          * __patch__ = Patch releases are typically unplanned and may resolve defects or important security issues.
          * __pre-release__ = A pre-release may include alpha, beta, or release candidates and typically have limited support. They provide the ability to preview a release prior to its general availability.
          * __internal__ = Internal releases are not for public consumption and are intended to be used exclusively by the project or manufacturer that produced it.
        "%
        = String,
      "_js2n__-:definitions/releaseType!predicate"
        | doc m%"
          The software versioning type. It is recommended that the release type use one of 'major', 'minor', 'patch', 'pre-release', or 'internal'. Representing all possible software release types is not practical, so standardizing on the recommended values, whenever possible, is strongly encouraged.
          
          * __major__ = A major release may contain significant changes or may introduce breaking changes.
          * __minor__ = A minor release, also known as an update, may contain a smaller number of changes than major releases.
          * __patch__ = Patch releases are typically unplanned and may resolve defects or important security issues.
          * __pre-release__ = A pre-release may include alpha, beta, or release candidates and typically have limited support. They provide the ability to preview a release prior to its general availability.
          * __internal__ = Internal releases are not for public consumption and are intended to be used exclusively by the project or manufacturer that produced it.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/resourceReferenceChoice!predicate"
        | doc "A reference to a locally defined resource (e.g., a bom-ref) or an externally accessible resource."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "ref" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "externalReference" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  externalReference =
                    _js2n__-refsenv."_js2n__-:definitions/externalReference!predicate",
                  ref =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/risk!contract" =
        {
            mitigationStrategy
              | String
              | doc "Strategy used to address this risk."
              | optional,
            name | String | doc "The name of the risk." | optional,
          },
      "_js2n__-:definitions/risk!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  mitigationStrategy = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/scoreMethod!predicate"
        | doc "Specifies the severity or risk scoring methodology or standard used."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "CVSSv2",
                  "CVSSv3",
                  "CVSSv31",
                  "CVSSv4",
                  "OWASP",
                  "SSVC",
                  "other"
                ]
            ],
      "_js2n__-:definitions/securedBy!contract"
        | doc "Specifies the mechanism by which the cryptographic asset is secured by"
        = {
            algorithmRef
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc "The bom-ref to the algorithm."
              | optional,
            mechanism
              | String
              | doc "Specifies the mechanism by which the cryptographic asset is secured by."
              | optional,
          },
      "_js2n__-:definitions/securedBy!predicate"
        | doc "Specifies the mechanism by which the cryptographic asset is secured by"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  algorithmRef =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  mechanism = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/service!contract" =
        {
            authenticated
              | Bool
              | doc "A boolean value indicating if the service requires authentication. A value of true indicates the service requires authentication prior to use. A value of false indicates the service does not require authentication."
              | optional,
            bom-ref
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc m%"
                An optional identifier which can be used to reference the service elsewhere in the BOM. Every bom-ref must be unique within the BOM.
                Value SHOULD not start with the BOM-Link intro 'urn:cdx:' to avoid conflicts with BOM-Links.
              "%
              | optional,
            data
              | Array
                _js2n__-refsenv."_js2n__-:definitions/serviceData!contract"
              | doc "Specifies information about the data including the directional flow of data and the data classification."
              | optional,
            description
              | String
              | doc "Specifies a description for the service"
              | optional,
            endpoints
              | Array (String)
              | doc "The endpoint URIs of the service. Multiple endpoints are allowed."
              | optional,
            externalReferences
              | Array
                _js2n__-refsenv."_js2n__-:definitions/externalReference!contract"
              | doc "External references provide a way to document systems, sites, and information that may be relevant but are not included with the BOM. They may also establish specific relationships within or external to the BOM."
              | optional,
            group
              | String
              | doc "The grouping name, namespace, or identifier. This will often be a shortened, single name of the company or project that produced the service or domain name. Whitespace and special characters should be avoided."
              | optional,
            licenses
              | _js2n__-refsenv."_js2n__-:definitions/licenseChoice!contract"
              | optional,
            name
              | String
              | doc "The name of the service. This will often be a shortened, single name of the service.",
            properties
              | Array _js2n__-refsenv."_js2n__-:definitions/property!contract"
              | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
              | optional,
            provider
              | _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!contract"
              | doc "The organization that provides the service."
              | optional,
            releaseNotes
              | _js2n__-refsenv."_js2n__-:definitions/releaseNotes!contract"
              | doc "Specifies optional release notes."
              | optional,
            services
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "A list of services included or deployed behind the parent service. This is not a dependency tree. It provides a way to specify a hierarchical representation of service assemblies."
              | optional,
            signature
              | _js2n__-refsenv."_js2n__-:definitions/signature!contract"
              | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
              | optional,
            tags
              | _js2n__-refsenv."_js2n__-:definitions/tags!contract"
              | optional,
            trustZone
              | String
              | doc "The name of the trust zone the service resides in."
              | optional,
            version
              | _js2n__-refsenv."_js2n__-:definitions/version!contract"
              | doc "The service version."
              | optional,
            x-trust-boundary
              | Bool
              | doc "A boolean value indicating if use of the service crosses a trust zone or boundary. A value of true indicates that by using the service, a trust boundary is crossed. A value of false indicates that by using the service, a trust boundary is not crossed."
              | optional,
          },
      "_js2n__-:definitions/service!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  authenticated = _js2n__-prdslib.isType '"Bool",
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/serviceData!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  externalReferences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalReference!predicate"
                        ],
                  group = _js2n__-prdslib.isType '"String",
                  licenses =
                    _js2n__-refsenv."_js2n__-:definitions/licenseChoice!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  provider =
                    _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                  releaseNotes =
                    _js2n__-refsenv."_js2n__-:definitions/releaseNotes!predicate",
                  services =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  signature =
                    _js2n__-refsenv."_js2n__-:definitions/signature!predicate",
                  tags = _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                  trustZone = _js2n__-prdslib.isType '"String",
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                  x-trust-boundary = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/serviceData!contract" =
        {
            classification
              | _js2n__-refsenv."_js2n__-:definitions/dataClassification!contract",
            description
              | String
              | doc "Short description of the data content and usage"
              | optional,
            destination
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                    ])
              )
              | doc "The URI, URL, or BOM-Link of the components or services the data is sent to"
              | optional,
            flow
              | _js2n__-refsenv."_js2n__-:definitions/dataFlowDirection!contract"
              | doc "Specifies the flow direction of the data. Direction is relative to the service. Inbound flow states that data enters the service. Outbound flow states that data leaves the service. Bi-directional states that data flows both ways and unknown states that the direction is not known.",
            governance
              | _js2n__-refsenv."_js2n__-:definitions/dataGovernance!contract"
              | optional,
            name | String | doc "Name for the defined data" | optional,
            source
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                    ])
              )
              | doc "The URI, URL, or BOM-Link of the components or services the data came in from"
              | optional,
          },
      "_js2n__-:definitions/serviceData!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "classification", "flow" ],
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/dataClassification!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  destination =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                              ])
                        ],
                  flow =
                    _js2n__-refsenv."_js2n__-:definitions/dataFlowDirection!predicate",
                  governance =
                    _js2n__-refsenv."_js2n__-:definitions/dataGovernance!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  source =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/severity!predicate"
        | doc "Textual representation of the severity of the vulnerability adopted by the analysis method. If the analysis method uses values other than what is provided, the user is expected to translate appropriately."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "critical",
                  "high",
                  "medium",
                  "low",
                  "info",
                  "none",
                  "unknown"
                ]
            ],
      "_js2n__-:definitions/signature!contract"
        | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
        = Dyn,
      "_js2n__-:definitions/signature!predicate"
        | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
        = _js2n__-prdslib.always,
      "_js2n__-:definitions/standard!contract"
        | doc "A standard may consist of regulations, industry or organizational-specific standards, maturity models, best practices, or any other requirements which can be evaluated against or attested to."
        = {
            bom-ref
              | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
              | doc "An optional identifier which can be used to reference the object elsewhere in the BOM. Every bom-ref must be unique within the BOM."
              | optional,
            description
              | String
              | doc "The description of the standard."
              | optional,
            externalReferences
              | Array
                _js2n__-refsenv."_js2n__-:definitions/externalReference!contract"
              | doc "External references provide a way to document systems, sites, and information that may be relevant but are not included with the BOM. They may also establish specific relationships within or external to the BOM."
              | optional,
            levels
              | Array
                {
                  bom-ref
                    | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
                    | doc "An optional identifier which can be used to reference the object elsewhere in the BOM. Every bom-ref must be unique within the BOM."
                    | optional,
                  description
                    | String
                    | doc "The description of the level."
                    | optional,
                  identifier
                    | String
                    | doc "The identifier used in the standard to identify a specific level."
                    | optional,
                  requirements
                    | Array
                      _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                    | doc "The list of requirement `bom-ref`s that comprise the level."
                    | optional,
                  title | String | doc "The title of the level." | optional,
                }
              | doc "The list of levels associated with the standard. Some standards have different levels of compliance."
              | optional,
            name
              | String
              | doc "The name of the standard. This will often be a shortened, single name of the standard."
              | optional,
            owner
              | String
              | doc "The owner of the standard, often the entity responsible for its release."
              | optional,
            requirements
              | Array
                {
                  bom-ref
                    | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
                    | doc "An optional identifier which can be used to reference the object elsewhere in the BOM. Every bom-ref must be unique within the BOM."
                    | optional,
                  descriptions
                    | Array (String)
                    | doc "The supplemental text that provides additional guidance or context to the requirement, but is not directly part of the requirement."
                    | optional,
                  externalReferences
                    | Array
                      _js2n__-refsenv."_js2n__-:definitions/externalReference!contract"
                    | doc "External references provide a way to document systems, sites, and information that may be relevant, but are not included with the BOM. They may also establish specific relationships within or external to the BOM."
                    | optional,
                  identifier
                    | String
                    | doc "The unique identifier used in the standard to identify a specific requirement. This should match what is in the standard and should not be the requirements bom-ref."
                    | optional,
                  openCre
                    | Array (
                      _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.pattern
                              "^CRE:[0-9]+-[0-9]+$"
                          ])
                    )
                    | doc "The Common Requirements Enumeration (CRE) identifier(s). CRE is a structured and standardized framework for uniting security standards and guidelines. CRE links each section of a resource to a shared topic identifier (a Common Requirement). Through this shared topic link, all resources map to each other. Use of CRE promotes clear and unambiguous communication among stakeholders."
                    | optional,
                  parent
                    | _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                    | doc "The optional `bom-ref` to a parent requirement. This establishes a hierarchy of requirements. Top-level requirements must not define a parent. Only child requirements should define parents."
                    | optional,
                  properties
                    | Array
                      _js2n__-refsenv."_js2n__-:definitions/property!contract"
                    | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
                    | optional,
                  text
                    | String
                    | doc "The textual content of the requirement."
                    | optional,
                  title
                    | String
                    | doc "The title of the requirement."
                    | optional,
                }
              | doc "The list of requirements comprising the standard."
              | optional,
            signature
              | _js2n__-refsenv."_js2n__-:definitions/signature!contract"
              | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
              | optional,
            version | String | doc "The version of the standard." | optional,
          },
      "_js2n__-:definitions/step!predicate"
        | doc "Executes specific commands or tools in order to accomplish its owning task as part of a sequence."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  commands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/command!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/swid!contract"
        | doc "Specifies metadata and content for ISO-IEC 19770-2 Software Identification (SWID) Tags."
        = {
            name | String | doc "Maps to the name of a SoftwareIdentity.",
            patch
              | Bool
              | doc "Maps to the patch of a SoftwareIdentity."
              | optional,
            tagId | String | doc "Maps to the tagId of a SoftwareIdentity.",
            tagVersion
              | std.number.Integer
              | doc "Maps to the tagVersion of a SoftwareIdentity."
              | optional,
            text
              | _js2n__-refsenv."_js2n__-:definitions/attachment!contract"
              | doc "Specifies the metadata and content of the SWID tag."
              | optional,
            url | String | doc "The URL to the SWID file." | optional,
            version
              | String
              | doc "Maps to the version of a SoftwareIdentity."
              | optional,
          },
      "_js2n__-:definitions/swid!predicate"
        | doc "Specifies metadata and content for ISO-IEC 19770-2 Software Identification (SWID) Tags."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "tagId" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  patch = _js2n__-prdslib.isType '"Bool",
                  tagId = _js2n__-prdslib.isType '"String",
                  tagVersion = _js2n__-prdslib.isType 'Integer,
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                  url = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tags!contract"
        | doc "Textual strings that aid in discovery, search, and retrieval of the associated object. Tags often serve as a way to group or categorize similar or related objects by various attributes."
        = Array (String),
      "_js2n__-:definitions/tags!predicate"
        | doc "Textual strings that aid in discovery, search, and retrieval of the associated object. Tags often serve as a way to group or categorize similar or related objects by various attributes."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/task!predicate"
        | doc "Describes the inputs, sequence of steps and resources used to accomplish a task and its output."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "bom-ref", "taskTypes", "uid" ],
              _js2n__-prdslib.records.record
                {
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/inputType!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  outputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/outputType!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  resourceReferences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  runtimeTopology =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  taskTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/taskType!predicate"
                        ],
                  timeEnd = _js2n__-prdslib.isType '"String",
                  timeStart = _js2n__-prdslib.isType '"String",
                  trigger =
                    _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                  uid = _js2n__-prdslib.isType '"String",
                  workspaces =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/workspace!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/taskType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "copy",
                  "clone",
                  "lint",
                  "scan",
                  "merge",
                  "build",
                  "test",
                  "deliver",
                  "deploy",
                  "release",
                  "clean",
                  "other"
                ]
            ],
      "_js2n__-:definitions/tool!predicate"
        | doc "[Deprecated] This will be removed in a future version. Use component or service instead. Information about the automated or manual tool used"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  externalReferences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalReference!predicate"
                        ],
                  hashes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/hash!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  vendor = _js2n__-prdslib.isType '"String",
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/trigger!predicate"
        | doc "Represents a resource that can conditionally activate (or fire) tasks based upon associated events and their data."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "bom-ref", "type", "uid" ],
              _js2n__-prdslib.records.record
                {
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  conditions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/condition!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  event =
                    _js2n__-refsenv."_js2n__-:definitions/event!predicate",
                  inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/inputType!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  outputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/outputType!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  resourceReferences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  timeActivated = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "manual", "api", "webhook", "scheduled" ]
                        ],
                  uid = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/version!contract"
        | doc "A single disjunctive version identifier, for a component or service."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.maxLength 1024
              ]),
      "_js2n__-:definitions/version!predicate"
        | doc "A single disjunctive version identifier, for a component or service."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 1024
            ],
      "_js2n__-:definitions/versionRange!predicate"
        | doc "A version range specified in Package URL Version Range syntax (vers) which is defined at https://github.com/package-url/purl-spec/VERSION-RANGE-SPEC.rst"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 4096,
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/volume!predicate"
        | doc "An identifiable, logical unit of data storage tied to a physical device."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "filesystem", "block" ]
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  persistent = _js2n__-prdslib.isType '"Bool",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  remote = _js2n__-prdslib.isType '"Bool",
                  sizeAllocated = _js2n__-prdslib.isType '"String",
                  uid = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/vulnerability!predicate"
        | doc "Defines a weakness in a component or service that could be exploited or triggered by a threat source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  advisories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/advisory!predicate"
                        ],
                  affects =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "ref" ],
                                _js2n__-prdslib.records.record
                                  {
                                    ref =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-refsenv."_js2n__-:definitions/refLinkType!predicate",
                                            _js2n__-refsenv."_js2n__-:definitions/bomLinkElementType!predicate"
                                          ],
                                    versions =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.records.required
                                                            [ "version" ],
                                                          _js2n__-prdslib.records.record
                                                            {} {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                      _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.records.required
                                                            [ "range" ],
                                                          _js2n__-prdslib.records.record
                                                            {} {} true
                                                            _js2n__-prdslib.always
                                                        ]
                                                    ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      range =
                                                        _js2n__-refsenv."_js2n__-:definitions/versionRange!predicate",
                                                      status =
                                                        _js2n__-refsenv."_js2n__-:definitions/affectedStatus!predicate",
                                                      version =
                                                        _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ])
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  analysis =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              detail = _js2n__-prdslib.isType '"String",
                              firstIssued = _js2n__-prdslib.isType '"String",
                              justification =
                                _js2n__-refsenv."_js2n__-:definitions/impactAnalysisJustification!predicate",
                              lastUpdated = _js2n__-prdslib.isType '"String",
                              response =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "can_not_fix",
                                                "will_not_fix",
                                                "update",
                                                "rollback",
                                                "workaround_available"
                                              ]
                                          ])
                                    ],
                              state =
                                _js2n__-refsenv."_js2n__-:definitions/impactAnalysisState!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  created = _js2n__-prdslib.isType '"String",
                  credits =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              individuals =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/organizationalContact!predicate"
                                    ],
                              organizations =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  cwes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/cwe!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  detail = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  proofOfConcept =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              environment = _js2n__-prdslib.isType '"String",
                              reproductionSteps =
                                _js2n__-prdslib.isType '"String",
                              supportingMaterial =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/attachment!predicate"
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  published = _js2n__-prdslib.isType '"String",
                  ratings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/rating!predicate"
                        ],
                  recommendation = _js2n__-prdslib.isType '"String",
                  references =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "id", "source" ],
                                _js2n__-prdslib.records.record
                                  {
                                    id = _js2n__-prdslib.isType '"String",
                                    source =
                                      _js2n__-refsenv."_js2n__-:definitions/vulnerabilitySource!predicate",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  rejected = _js2n__-prdslib.isType '"String",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/vulnerabilitySource!predicate",
                  tools =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  components =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  services =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/tool!predicate"
                            ]
                        ],
                  updated = _js2n__-prdslib.isType '"String",
                  workaround = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/vulnerabilitySource!predicate"
        | doc "The source of vulnerability information. This is often the organization that published the vulnerability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/workflow!predicate"
        | doc "A specialized orchestration task."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "bom-ref", "taskTypes", "uid" ],
              _js2n__-prdslib.records.record
                {
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  inputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/inputType!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  outputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/outputType!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  resourceReferences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  runtimeTopology =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  taskDependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  taskTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/taskType!predicate"
                        ],
                  tasks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/task!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  timeEnd = _js2n__-prdslib.isType '"String",
                  timeStart = _js2n__-prdslib.isType '"String",
                  trigger =
                    _js2n__-refsenv."_js2n__-:definitions/trigger!predicate",
                  uid = _js2n__-prdslib.isType '"String",
                  workspaces =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/workspace!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/workspace!predicate"
        | doc "A named filesystem or data resource shareable by workflow tasks."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "bom-ref", "uid" ],
              _js2n__-prdslib.records.record
                {
                  accessMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "read-only",
                              "read-write",
                              "read-write-once",
                              "write-once",
                              "write-only"
                            ]
                        ],
                  aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  bom-ref =
                    _js2n__-refsenv."_js2n__-:definitions/refType!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  managedDataType = _js2n__-prdslib.isType '"String",
                  mountPath = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/property!predicate"
                        ],
                  resourceReferences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/resourceReferenceChoice!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  uid = _js2n__-prdslib.isType '"String",
                  volume =
                    _js2n__-refsenv."_js2n__-:definitions/volume!predicate",
                  volumeRequest = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      "$schema" | String | optional,
      annotations
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/annotations!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Comments made by people, organizations, or tools about any object with a bom-ref, such as components, services, vulnerabilities, or the BOM itself. Unlike inventory information, annotations may contain opinions or commentary from various stakeholders. Annotations may be inline (with inventory) or externalized via BOM-Link and may optionally be signed."
        | optional,
      bomFormat
        | std.enum.TagOrString
        | [| 'CycloneDX |]
        | doc "Specifies the format of the BOM. This helps to identify the file as CycloneDX since BOMs do not have a filename convention, nor does JSON schema support namespaces. This value must be \"CycloneDX\".",
      components
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/component!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "A list of software and hardware components."
        | optional,
      compositions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/compositions!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Compositions describe constituent parts (including components, services, and dependency relationships) and their completeness. The completeness of vulnerabilities expressed in a BOM may also be described."
        | optional,
      declarations
        | {
          affirmation
            | {
              signatories
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "signature" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "externalReference", "organization" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]
                          ],
                        _js2n__-prdslib.records.record
                          {
                            externalReference =
                              _js2n__-refsenv."_js2n__-:definitions/externalReference!predicate",
                            name = _js2n__-prdslib.isType '"String",
                            organization =
                              _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!predicate",
                            role = _js2n__-prdslib.isType '"String",
                            signature =
                              _js2n__-refsenv."_js2n__-:definitions/signature!predicate",
                          } {} false _js2n__-prdslib.never
                      ])
                )
                | doc "The list of signatories authorized on behalf of an organization to assert validity of this document."
                | optional,
              signature
                | _js2n__-refsenv."_js2n__-:definitions/signature!contract"
                | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
                | optional,
              statement
                | String
                | doc m%"
                  The brief statement affirmed by an individual regarding all declarations.
                  *- Notes This could be an affirmation of acceptance by a third-party auditor or receiving individual of a file.
                "%
                | optional,
            }
            | doc "A concise statement affirmed by an individual regarding all declarations, often used for third-party auditor acceptance or recipient acknowledgment. It includes a list of authorized signatories who assert the validity of the document on behalf of the organization."
            | optional,
          assessors
            | Array
              {
                bom-ref
                  | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
                  | doc "An optional identifier which can be used to reference the object elsewhere in the BOM. Every bom-ref must be unique within the BOM."
                  | optional,
                organization
                  | _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!contract"
                  | doc "The entity issuing the assessment."
                  | optional,
                thirdParty
                  | Bool
                  | doc "The boolean indicating if the assessor is outside the organization generating claims. A value of false indicates a self assessor."
                  | optional,
              }
            | doc "The list of assessors evaluating claims and determining conformance to requirements and confidence in that assessment."
            | optional,
          attestations
            | Array
              {
                assessor
                  | _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                  | doc "The `bom-ref` to the assessor asserting the attestation."
                  | optional,
                map
                  | Array
                    {
                      claims
                        | Array
                          _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                        | doc "The list of `bom-ref` to the claims being attested to."
                        | optional,
                      confidence
                        | {
                          rationale
                            | String
                            | doc "The rationale for the confidence score."
                            | optional,
                          score
                            | _js2n__-prdslib.contract_from_predicate
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Number",
                                  _js2n__-prdslib.numbers.maximum 1,
                                  _js2n__-prdslib.numbers.minimum 0
                                ])
                            | doc "The confidence of the claim between and inclusive of 0 and 1, where 1 is 100% confidence."
                            | optional,
                        }
                        | doc "The confidence of the claim meeting the requirement."
                        | optional,
                      conformance
                        | {
                          mitigationStrategies
                            | Array
                              _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                            | doc "The list of  `bom-ref` to the evidence provided describing the mitigation strategies."
                            | optional,
                          rationale
                            | String
                            | doc "The rationale for the conformance score."
                            | optional,
                          score
                            | _js2n__-prdslib.contract_from_predicate
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Number",
                                  _js2n__-prdslib.numbers.maximum 1,
                                  _js2n__-prdslib.numbers.minimum 0
                                ])
                            | doc "The conformance of the claim between and inclusive of 0 and 1, where 1 is 100% conformance."
                            | optional,
                        }
                        | doc "The conformance of the claim meeting a requirement."
                        | optional,
                      counterClaims
                        | Array
                          _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                        | doc "The list of  `bom-ref` to the counter claims being attested to."
                        | optional,
                      requirement
                        | _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                        | doc "The `bom-ref` to the requirement being attested to."
                        | optional,
                    }
                  | doc "The grouping of requirements to claims and the attestors declared conformance and confidence thereof."
                  | optional,
                signature
                  | _js2n__-refsenv."_js2n__-:definitions/signature!contract"
                  | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
                  | optional,
                summary
                  | String
                  | doc "The short description explaining the main points of the attestation."
                  | optional,
              }
            | doc "The list of attestations asserted by an assessor that maps requirements to claims."
            | optional,
          claims
            | Array
              {
                bom-ref
                  | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
                  | doc "An optional identifier which can be used to reference the object elsewhere in the BOM. Every bom-ref must be unique within the BOM."
                  | optional,
                counterEvidence
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                  | doc "The list of `bom-ref` to counterEvidence that supports this claim."
                  | optional,
                evidence
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                  | doc "The list of `bom-ref` to evidence that supports this claim."
                  | optional,
                externalReferences
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/externalReference!contract"
                  | doc "External references provide a way to document systems, sites, and information that may be relevant but are not included with the BOM. They may also establish specific relationships within or external to the BOM."
                  | optional,
                mitigationStrategies
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                  | doc "The list of  `bom-ref` to the evidence provided describing the mitigation strategies. Each mitigation strategy should include an explanation of how any weaknesses in the evidence will be mitigated."
                  | optional,
                predicate
                  | String
                  | doc "The specific statement or assertion about the target."
                  | optional,
                reasoning
                  | String
                  | doc "The written explanation of why the evidence provided substantiates the claim."
                  | optional,
                signature
                  | _js2n__-refsenv."_js2n__-:definitions/signature!contract"
                  | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
                  | optional,
                target
                  | _js2n__-refsenv."_js2n__-:definitions/refLinkType!contract"
                  | doc "The `bom-ref` to a target representing a specific system, application, API, module, team, person, process, business unit, company, etc...  that this claim is being applied to."
                  | optional,
              }
            | doc "The list of claims."
            | optional,
          evidence
            | Array
              {
                author
                  | _js2n__-refsenv."_js2n__-:definitions/organizationalContact!contract"
                  | doc "The author of the evidence."
                  | optional,
                bom-ref
                  | _js2n__-refsenv."_js2n__-:definitions/refType!contract"
                  | doc "An optional identifier which can be used to reference the object elsewhere in the BOM. Every bom-ref must be unique within the BOM."
                  | optional,
                created
                  | String
                  | doc "The date and time (timestamp) when the evidence was created."
                  | optional,
                data
                  | Array
                    {
                      classification
                        | _js2n__-refsenv."_js2n__-:definitions/dataClassification!contract"
                        | optional,
                      contents
                        | {
                          attachment
                            | _js2n__-refsenv."_js2n__-:definitions/attachment!contract"
                            | doc "An optional way to include textual or encoded data."
                            | optional,
                          url
                            | String
                            | doc "The URL to where the data can be retrieved."
                            | optional,
                        }
                        | doc "The contents or references to the contents of the data being described."
                        | optional,
                      governance
                        | _js2n__-refsenv."_js2n__-:definitions/dataGovernance!contract"
                        | optional,
                      name | String | doc "The name of the data." | optional,
                      sensitiveData
                        | Array (String)
                        | doc "A description of any sensitive data included."
                        | optional,
                    }
                  | doc "The output or analysis that supports claims."
                  | optional,
                description
                  | String
                  | doc "The written description of what this evidence is and how it was created."
                  | optional,
                expires
                  | String
                  | doc "The optional date and time (timestamp) when the evidence is no longer valid."
                  | optional,
                propertyName
                  | String
                  | doc "The reference to the property name as defined in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy/)."
                  | optional,
                reviewer
                  | _js2n__-refsenv."_js2n__-:definitions/organizationalContact!contract"
                  | doc "The reviewer of the evidence."
                  | optional,
                signature
                  | _js2n__-refsenv."_js2n__-:definitions/signature!contract"
                  | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
                  | optional,
              }
            | doc "The list of evidence"
            | optional,
          signature
            | _js2n__-refsenv."_js2n__-:definitions/signature!contract"
            | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
            | optional,
          targets
            | {
              components
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/component!contract"
                | doc "The list of components which claims are made against."
                | optional,
              organizations
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/organizationalEntity!contract"
                | doc "The list of organizations which claims are made against."
                | optional,
              services
                | Array _js2n__-refsenv."_js2n__-:definitions/service!contract"
                | doc "The list of services which claims are made against."
                | optional,
            }
            | doc "The list of targets which claims are made against."
            | optional,
        }
        | doc "The list of declarations which describe the conformance to standards. Each declaration may include attestations, claims, and evidence."
        | optional,
      definitions
        | {
          standards
            | Array _js2n__-refsenv."_js2n__-:definitions/standard!contract"
            | doc "The list of standards which may consist of regulations, industry or organizational-specific standards, maturity models, best practices, or any other requirements which can be evaluated against or attested to."
            | optional,
        }
        | doc "A collection of reusable objects that are defined and may be used elsewhere in the BOM."
        | optional,
      dependencies
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Provides the ability to document dependency relationships including provided & implemented components."
        | optional,
      externalReferences
        | Array
          _js2n__-refsenv."_js2n__-:definitions/externalReference!contract"
        | doc "External references provide a way to document systems, sites, and information that may be relevant but are not included with the BOM. They may also establish specific relationships within or external to the BOM."
        | optional,
      formulation
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/formula!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Describes how a component or service was manufactured or deployed. This is achieved through the use of formulas, workflows, tasks, and steps, which declare the precise steps to reproduce along with the observed formulas describing the steps which transpired in the manufacturing process."
        | optional,
      metadata
        | _js2n__-refsenv."_js2n__-:definitions/metadata!contract"
        | doc "Provides additional information about a BOM."
        | optional,
      properties
        | Array _js2n__-refsenv."_js2n__-:definitions/property!contract"
        | doc "Provides the ability to document properties in a name-value store. This provides flexibility to include data not officially supported in the standard without having to use additional namespaces or create extensions. Unlike key-value stores, properties support duplicate names, each potentially having different values. Property names of interest to the general public are encouraged to be registered in the [CycloneDX Property Taxonomy](https://github.com/CycloneDX/cyclonedx-property-taxonomy). Formal registration is optional."
        | optional,
      serialNumber
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:uuid:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
            ])
        | doc "Every BOM generated SHOULD have a unique serial number, even if the contents of the BOM have not changed over time. If specified, the serial number must conform to [RFC 4122](https://www.ietf.org/rfc/rfc4122.html). Use of serial numbers is recommended."
        | optional,
      services
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/service!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "A list of services. This may include microservices, function-as-a-service, and other types of network or intra-process services."
        | optional,
      signature
        | _js2n__-refsenv."_js2n__-:definitions/signature!contract"
        | doc "Enveloped signature in [JSON Signature Format (JSF)](https://cyberphone.github.io/doc/security/jsf.html)."
        | optional,
      specVersion
        | String
        | doc "The version of the CycloneDX specification the BOM conforms to.",
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 1
            ])
        | doc "Whenever an existing BOM is modified, either manually or through automated processes, the version of the BOM SHOULD be incremented by 1. When a system is presented with multiple BOMs with identical serial numbers, the system SHOULD use the most recent version of the BOM. The default version is '1'."
        | optional,
      vulnerabilities
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/vulnerability!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Vulnerabilities identified in components or services."
        | optional,
    }