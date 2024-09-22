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
      "_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "$ref" = _js2n__-prdslib.isType '"String",
                  classification = _js2n__-prdslib.isType '"String",
                  config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              avroLogicalType =
                                _js2n__-prdslib.isType '"String",
                              avroType = _js2n__-prdslib.isType '"String",
                              bigqueryType = _js2n__-prdslib.isType '"String",
                              databricksType = _js2n__-prdslib.isType '"String",
                              glueType = _js2n__-prdslib.isType '"String",
                              redshiftType = _js2n__-prdslib.isType '"String",
                              snowflakeType = _js2n__-prdslib.isType '"String",
                              sqlserverType = _js2n__-prdslib.isType '"String",
                            } {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType 'Null
                              ])
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  enum =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  example = _js2n__-prdslib.isType '"String",
                  exclusiveMaximum = _js2n__-prdslib.isType '"Number",
                  exclusiveMinimum = _js2n__-prdslib.isType '"Number",
                  fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate"
                        ],
                  format = _js2n__-prdslib.isType '"String",
                  items =
                    _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate",
                  keys =
                    _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate",
                  links =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.propertyNames
                            (_js2n__-prdslib.strings.pattern
                              "^[a-zA-Z0-9_-]+$"),
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  maxLength = _js2n__-prdslib.isType 'Integer,
                  maximum = _js2n__-prdslib.isType '"Number",
                  minLength = _js2n__-prdslib.isType 'Integer,
                  minimum = _js2n__-prdslib.isType '"Number",
                  pattern = _js2n__-prdslib.isType '"String",
                  pii = _js2n__-prdslib.isType '"Bool",
                  precision = _js2n__-prdslib.isType '"Number",
                  primary = _js2n__-prdslib.isType '"Bool",
                  references = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  scale = _js2n__-prdslib.isType '"Number",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  title = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.always,
                  unique = _js2n__-prdslib.isType '"Bool",
                  values =
                    _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      dataContractSpecification
        | std.enum.TagOrString
        | [| '"0.9.0", '"0.9.1", '"0.9.2", '"0.9.3" |]
        | doc "Specifies the Data Contract Specification being used.",
      definitions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.propertyNames
                (_js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_-]+$"),
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name", "type" ],
                    _js2n__-prdslib.records.record
                      {
                        classification = _js2n__-prdslib.isType '"String",
                        description = _js2n__-prdslib.isType '"String",
                        domain = _js2n__-prdslib.isType '"String",
                        example = _js2n__-prdslib.isType '"String",
                        exclusiveMaximum = _js2n__-prdslib.isType '"Number",
                        exclusiveMinimum = _js2n__-prdslib.isType '"Number",
                        fields =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate"
                              ],
                        format = _js2n__-prdslib.isType '"String",
                        items =
                          _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate",
                        keys =
                          _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate",
                        links =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.minProperties 1,
                                _js2n__-prdslib.records.propertyNames
                                  (_js2n__-prdslib.strings.pattern
                                    "^[a-zA-Z0-9_-]+$"),
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        maxLength = _js2n__-prdslib.isType 'Integer,
                        maximum = _js2n__-prdslib.isType '"Number",
                        minLength = _js2n__-prdslib.isType 'Integer,
                        minimum = _js2n__-prdslib.isType '"Number",
                        name = _js2n__-prdslib.isType '"String",
                        pattern = _js2n__-prdslib.isType '"String",
                        pii = _js2n__-prdslib.isType '"Bool",
                        precision = _js2n__-prdslib.isType 'Integer,
                        scale = _js2n__-prdslib.isType 'Integer,
                        tags =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        title = _js2n__-prdslib.isType '"String",
                        type = _js2n__-prdslib.always,
                        values =
                          _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "Clear and concise explanations of syntax, semantic, and classification of business objects in a given domain."
        | optional,
      examples
        | Array
          {
            data
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Array"
                  ]),
            description
              | String
              | doc "An optional string describing the example."
              | optional,
            model
              | String
              | doc "The reference to the model in the schema, e.g., a table name."
              | optional,
            type
              | std.enum.TagOrString
              | [| 'custom, 'yaml, 'json, 'csv |]
              | doc "The type of the example data. Well-known types are csv, json, yaml, custom.",
            ..
          }
        | doc "The Examples Object is an array of Example Objects."
        | optional,
      id | String | doc "Specifies the identifier of the data contract.",
      info
        | {
          contact
            | {
              email
                | String
                | doc "The email address of the contact person/organization. This MUST be in the form of an email address."
                | optional,
              name
                | String
                | doc "The identifying name of the contact person/organization."
                | optional,
              url
                | String
                | doc "The URL pointing to the contact information. This MUST be in the form of a URL."
                | optional,
              ..
            }
            | doc "Contact information for the data contract."
            | optional,
          description
            | String
            | doc "A description of the data contract."
            | optional,
          owner
            | String
            | doc "The owner or team responsible for managing the data contract and providing the data."
            | optional,
          status
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"String")
            | doc "The status of the data contract. Can be proposed, in development, active, retired."
            | optional,
          title | String | doc "The title of the data contract.",
          version
            | String
            | doc "The version of the data contract document (which is distinct from the Data Contract Specification version or the Data Product implementation version).",
          ..
        }
        | doc "Metadata and life cycle information about the data contract.",
      links
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.propertyNames
                (_js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_-]+$"),
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "Links to external resources."
        | optional,
      models
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.propertyNames
                (_js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_-]+$"),
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        config =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    avroNamespace =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.isType 'Null
                                    ])
                              ],
                        description = _js2n__-prdslib.isType '"String",
                        fields =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          "$ref" =
                                            _js2n__-prdslib.isType '"String",
                                          classification =
                                            _js2n__-prdslib.isType '"String",
                                          config =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      avroLogicalType =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      avroType =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      bigqueryType =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      databricksType =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      glueType =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      redshiftType =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      snowflakeType =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      sqlserverType =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
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
                                                          '"Array",
                                                        _js2n__-prdslib.isType
                                                          'Null
                                                      ])
                                                ],
                                          description =
                                            _js2n__-prdslib.isType '"String",
                                          enum =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String"),
                                                  _js2n__-prdslib.arrays.uniqueItems
                                                ],
                                          example =
                                            _js2n__-prdslib.isType '"String",
                                          exclusiveMaximum =
                                            _js2n__-prdslib.isType '"Number",
                                          exclusiveMinimum =
                                            _js2n__-prdslib.isType '"Number",
                                          fields =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {} {} true
                                                    _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate"
                                                ],
                                          format =
                                            _js2n__-prdslib.isType '"String",
                                          items =
                                            _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate",
                                          keys =
                                            _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate",
                                          links =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.minProperties
                                                    1,
                                                  _js2n__-prdslib.records.propertyNames
                                                    (_js2n__-prdslib.strings.pattern
                                                      "^[a-zA-Z0-9_-]+$"),
                                                  _js2n__-prdslib.records.record
                                                    {} {} true
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
                                          maxLength =
                                            _js2n__-prdslib.isType 'Integer,
                                          maximum =
                                            _js2n__-prdslib.isType '"Number",
                                          minLength =
                                            _js2n__-prdslib.isType 'Integer,
                                          minimum =
                                            _js2n__-prdslib.isType '"Number",
                                          pattern =
                                            _js2n__-prdslib.isType '"String",
                                          pii = _js2n__-prdslib.isType '"Bool",
                                          precision =
                                            _js2n__-prdslib.isType '"Number",
                                          primary =
                                            _js2n__-prdslib.isType '"Bool",
                                          references =
                                            _js2n__-prdslib.isType '"String",
                                          required =
                                            _js2n__-prdslib.isType '"Bool",
                                          scale =
                                            _js2n__-prdslib.isType '"Number",
                                          tags =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
                                          title =
                                            _js2n__-prdslib.isType '"String",
                                          type = _js2n__-prdslib.always,
                                          unique =
                                            _js2n__-prdslib.isType '"Bool",
                                          values =
                                            _js2n__-refsenv."_js2n__-:properties/models/additionalProperties/properties/fields/additionalProperties!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ])
                              ],
                        title = _js2n__-prdslib.isType '"String",
                        type =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [ "table", "view", "object" ]
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "Specifies the logical data model. Use the models name (e.g., the table name) as the key."
        | optional,
      quality
        | {
          specification
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Record
                ]),
          type
            | std.enum.TagOrString
            | [| 'custom, 'great-expectations, 'montecarlo, 'SodaCL |]
            | doc "The type of the quality check. Typical values are SodaCL, montecarlo, great-expectations, custom.",
          ..
        }
        | doc "The quality object contains quality attributes and checks."
        | optional,
      schema
        | {
          specification
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Record
                ]),
          type
            | std.enum.TagOrString
            | [|
              'custom,
              'protobuf,
              'avro,
              'sql-ddl,
              'json-schema,
              'bigquery,
              'dbt
            |]
            | doc "The type of the schema. Typical values are dbt, bigquery, json-schema, sql-ddl, avro, protobuf, custom.",
          ..
        }
        | doc "The schema of the data contract describes the syntax and semantics of provided data sets. It supports different schema types."
        | optional,
      servers
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  environment = _js2n__-prdslib.isType '"String",
                } {} true
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "dataset", "project", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            dataset = _js2n__-prdslib.isType '"String",
                            project = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "bigquery", "BigQuery" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "location", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            delimiter =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "new_line", "array" ]
                                  ],
                            endpointUrl = _js2n__-prdslib.isType '"String",
                            format =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "parquet", "delta", "json", "csv" ]
                                  ],
                            location = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "s3" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "location", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            delimiter =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "new_line", "array" ]
                                  ],
                            format =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "parquet", "delta", "json", "csv" ]
                                  ],
                            location = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "gcs" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "location", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            delimiter =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "new_line", "array" ]
                                  ],
                            format =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "parquet", "delta", "json", "csv" ]
                                  ],
                            location = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "sftp" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "account", "database", "schema", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            account = _js2n__-prdslib.isType '"String",
                            database = _js2n__-prdslib.isType '"String",
                            schema = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "redshift" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "format", "location", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            delimiter =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "new_line", "array" ]
                                  ],
                            format =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "parquet", "delta", "json", "csv" ]
                                  ],
                            location = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "azure" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "database", "host", "schema", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            database = _js2n__-prdslib.isType '"String",
                            host = _js2n__-prdslib.isType '"String",
                            port = _js2n__-prdslib.isType 'Integer,
                            schema = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "sqlserver" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "account", "database", "schema", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            account = _js2n__-prdslib.isType '"String",
                            database = _js2n__-prdslib.isType '"String",
                            schema = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "snowflake" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "catalog", "schema", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            catalog = _js2n__-prdslib.isType '"String",
                            host = _js2n__-prdslib.isType '"String",
                            schema = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "databricks"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "type" ],
                        _js2n__-prdslib.records.record
                          {
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "dataframe"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "account", "database", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            account = _js2n__-prdslib.isType '"String",
                            database = _js2n__-prdslib.isType '"String",
                            format = _js2n__-prdslib.isType '"String",
                            location = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "glue"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "database", "host", "port", "schema", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            database = _js2n__-prdslib.isType '"String",
                            host = _js2n__-prdslib.isType '"String",
                            port = _js2n__-prdslib.isType 'Integer,
                            schema = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "postgres"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "host", "port", "serviceName", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            host = _js2n__-prdslib.isType '"String",
                            port = _js2n__-prdslib.isType 'Integer,
                            serviceName = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "oracle"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "host", "topic", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            format = _js2n__-prdslib.isType '"String",
                            host = _js2n__-prdslib.isType '"String",
                            topic = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "kafka" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "project", "topic", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            project = _js2n__-prdslib.isType '"String",
                            topic = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "pubsub" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "stream", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            format = _js2n__-prdslib.isType '"String",
                            region = _js2n__-prdslib.isType '"String",
                            stream = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "kinesis" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "catalog", "host", "port", "schema", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            catalog = _js2n__-prdslib.isType '"String",
                            host = _js2n__-prdslib.isType '"String",
                            port = _js2n__-prdslib.isType 'Integer,
                            schema = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "trino"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "format", "path", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            format = _js2n__-prdslib.isType '"String",
                            path = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "local" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ]
                  ])
            ])
        | doc "Information about the servers."
        | optional,
      servicelevels
        | {
          availability
            | {
              description
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional string describing the availability service level."
                | optional,
              percentage
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "^\\d+(\\.\\d+)?%$"
                    ])
                | doc "An optional string describing the guaranteed uptime in percent (e.g., `99.9%`)"
                | optional,
              ..
            }
            | doc "Availability refers to the promise or guarantee by the service provider about the uptime of the system that provides the data."
            | optional,
          backup
            | {
              cron
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional cron expression when data will be backed up, e.g., `0 0 * * *`."
                | optional,
              description
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional string describing the backup service level."
                | optional,
              interval
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional interval that defines how often data will be backed up, e.g., `daily`."
                | optional,
              recoveryPoint
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional Recovery Point Objective (RPO) defines the maximum acceptable age of files that must be recovered from backup storage for normal operations to resume after a disaster or data loss event. This essentially measures how much data you can afford to lose, measured in time (e.g., 4 hours, 24 hours)."
                | optional,
              recoveryTime
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional Recovery Time Objective (RTO) specifies the maximum amount of time allowed to restore data from a backup after a failure or loss event (e.g., 4 hours, 24 hours)."
                | optional,
              ..
            }
            | doc "Backup specifies details about data backup procedures."
            | optional,
          frequency
            | {
              cron
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "Optional. Only for batch: A cron expression when the pipelines is triggered. E.g., `0 0 * * *`."
                | optional,
              description
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional string describing the frequency service level."
                | optional,
              interval
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "Optional. Only for batch: How often the pipeline is triggered, e.g., `daily`."
                | optional,
              type
                | std.enum.TagOrString
                | [| 'manual, 'streaming, 'micro-batching, 'batch |]
                | doc "The method of data processing."
                | optional,
              ..
            }
            | doc "Frequency describes how often data is updated."
            | optional,
          freshness
            | {
              description
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional string describing the freshness service level."
                | optional,
              threshold
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional maximum age of the youngest entry. Supported formats: Simple duration (e.g., `24 hours`, `5s`) and ISO 8601 duration (e.g., `PT24H`)."
                | optional,
              timestampField
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional reference to the field that contains the timestamp that the threshold refers to."
                | optional,
              ..
            }
            | doc "The maximum age of the youngest row in a table."
            | optional,
          latency
            | {
              description
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional string describing the latency service level."
                | optional,
              processedTimestampField
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional reference to the field that contains the processing timestamp, which denotes when the data is made available to consumers of this data contract."
                | optional,
              sourceTimestampField
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional reference to the field that contains the timestamp when the data was provided at the source."
                | optional,
              threshold
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional maximum duration between the source timestamp and the processed timestamp. Supported formats: Simple duration (e.g., `24 hours`, `5s`) and ISO 8601 duration (e.g, `PT24H`)."
                | optional,
              ..
            }
            | doc "Latency refers to the maximum amount of time from the source to its destination."
            | optional,
          retention
            | {
              description
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional string describing the retention service level."
                | optional,
              period
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional period of time, how long data is available. Supported formats: Simple duration (e.g., `1 year`, `30d`) and ISO 8601 duration (e.g, `P1Y`)."
                | optional,
              timestampField
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional reference to the field that contains the timestamp that the period refers to."
                | optional,
              unlimited
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"Bool")
                | doc "An optional indicator that data is kept forever."
                | optional,
              ..
            }
            | doc "Retention covers the period how long data will be available."
            | optional,
          support
            | {
              description
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional string describing the support service level."
                | optional,
              responseTime
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional string describing the time it takes for the support team to acknowledge a request. This does not mean the issue will be resolved immediately, but it assures users that their request has been received and will be dealt with."
                | optional,
              time
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.isType '"String")
                | doc "An optional string describing the times when support will be available for contact such as `24/7` or `business hours only`."
                | optional,
              ..
            }
            | doc "Support describes the times when support will be available for contact."
            | optional,
          ..
        }
        | doc "Specifies the service level agreements for the provided data, including availability, data retention policies, latency requirements, data freshness, update frequency, support availability, and backup policies."
        | optional,
      tags
        | Array (String)
        | doc "Tags to facilitate searching and filtering."
        | optional,
      terms
        | {
          billing
            | String
            | doc "The billing describes the pricing model for using the data, such as whether it's free, having a monthly fee, or metered pay-per-use."
            | optional,
          limitations
            | String
            | doc "The limitations describe the restrictions on how the data can be used, can be technical or restrictions on what the data may not be used for."
            | optional,
          noticePeriod
            | String
            | doc "The period of time that must be given by either party to terminate or modify a data usage agreement. Uses ISO-8601 period format, e.g., 'P3M' for a period of three months."
            | optional,
          usage
            | String
            | doc "The usage describes the way the data is expected to be used. Can contain business and technical information."
            | optional,
          ..
        }
        | doc "The terms and conditions of the data contract."
        | optional,
      ..
    }