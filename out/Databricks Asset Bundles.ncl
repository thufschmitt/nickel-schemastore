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
  {
      artifacts
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "type" ],
                    _js2n__-prdslib.records.record
                      {
                        build = _js2n__-prdslib.isType '"String",
                        files =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "source" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          source =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ])
                              ],
                        path = _js2n__-prdslib.isType '"String",
                        type = _js2n__-prdslib.isType '"String",
                      } {} false _js2n__-prdslib.never
                  ])
            ])
        | doc "A description of all code artifacts in this bundle."
        | optional,
      bundle
        | {
          compute_id | String | optional,
          git
            | { branch | String | optional, origin_url | String | optional, }
            | optional,
          name | String | doc "The name of the bundle.",
        }
        | doc "The details for this bundle."
        | optional,
      experimental
        | {
          python_wheel_wrapper | Bool | optional,
          scripts
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ])
            | optional,
        }
        | optional,
      include
        | Array (String)
        | doc "A list of glob patterns of files to load and merge into the this configuration. Defaults to no files being included."
        | optional,
      permissions
        | Array
          {
            group_name | String | optional,
            level | String,
            service_principal_name | String | optional,
            user_name | String | optional,
          }
        | optional,
      resources
        | {
          experiments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            artifact_location =
                              _js2n__-prdslib.isType '"String",
                            creation_time = _js2n__-prdslib.isType '"Number",
                            experiment_id = _js2n__-prdslib.isType '"String",
                            last_update_time = _js2n__-prdslib.isType '"Number",
                            lifecycle_stage = _js2n__-prdslib.isType '"String",
                            name = _js2n__-prdslib.isType '"String",
                            permissions =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "level" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              group_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              level =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              service_principal_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              user_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            tags =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              value =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                          } {} false _js2n__-prdslib.never
                      ])
                ])
            | doc "List of MLflow experiments"
            | optional,
          jobs
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            compute =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "compute_key", "spec" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              compute_key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              spec =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          kind =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            continuous =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        pause_status =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            deployment =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required [ "kind" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        kind = _js2n__-prdslib.isType '"String",
                                        metadata_file_path =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            description = _js2n__-prdslib.isType '"String",
                            edit_mode = _js2n__-prdslib.isType '"String",
                            email_notifications =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        no_alert_for_skipped_runs =
                                          _js2n__-prdslib.isType '"Bool",
                                        on_duration_warning_threshold_exceeded =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        on_failure =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        on_start =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        on_success =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            format = _js2n__-prdslib.isType '"String",
                            git_source =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "git_provider", "git_url" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        git_branch =
                                          _js2n__-prdslib.isType '"String",
                                        git_commit =
                                          _js2n__-prdslib.isType '"String",
                                        git_provider =
                                          _js2n__-prdslib.isType '"String",
                                        git_snapshot =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    used_commit =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                        git_tag =
                                          _js2n__-prdslib.isType '"String",
                                        git_url =
                                          _js2n__-prdslib.isType '"String",
                                        job_source =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [
                                                    "import_from_git_branch",
                                                    "job_config_path"
                                                  ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    dirty_state =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    import_from_git_branch =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    job_config_path =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            health =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        rules =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          metric =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          op =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          value =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            job_clusters =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "job_cluster_key" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              job_cluster_key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              new_cluster =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          apply_policy_default_values =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          autoscale =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "max_workers",
                                                                      "min_workers"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      max_workers =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      min_workers =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          autotermination_minutes =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          aws_attributes =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      availability =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      ebs_volume_count =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      ebs_volume_iops =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      ebs_volume_size =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      ebs_volume_throughput =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      ebs_volume_type =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      first_on_demand =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      instance_profile_arn =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      spot_bid_price_percent =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      zone_id =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          azure_attributes =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      availability =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      first_on_demand =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      log_analytics_info =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  log_analytics_primary_key =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  log_analytics_workspace_id =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                }
                                                                                {}
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                      spot_bid_max_price =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          cluster_log_conf =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      dbfs =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  destination =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                }
                                                                                {}
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                      s3 =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  canned_acl =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  destination =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  enable_encryption =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"Bool",
                                                                                  encryption_type =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  endpoint =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  kms_key =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  region =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                }
                                                                                {}
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          cluster_name =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          cluster_source =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          custom_tags =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          data_security_mode =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          docker_image =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      basic_auth =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
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
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                      url =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          driver_instance_pool_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          driver_node_type_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          enable_elastic_disk =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          enable_local_disk_encryption =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          gcp_attributes =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      availability =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      boot_disk_size =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      google_service_account =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      local_ssd_count =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          init_scripts =
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
                                                                            dbfs =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                            file =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                            s3 =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        canned_acl =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        enable_encryption =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"Bool",
                                                                                        encryption_type =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        endpoint =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        kms_key =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        region =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                            volumes =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                            workspace =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ])
                                                                ],
                                                          instance_pool_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          node_type_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          num_workers =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          policy_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          runtime_engine =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          single_user_name =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          spark_conf =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          spark_env_vars =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          spark_version =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          ssh_public_keys =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          workload_type =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      clients =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  jobs =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"Bool",
                                                                                  notebooks =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"Bool",
                                                                                }
                                                                                {}
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            max_concurrent_runs =
                              _js2n__-prdslib.isType '"Number",
                            name = _js2n__-prdslib.isType '"String",
                            notification_settings =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        no_alert_for_canceled_runs =
                                          _js2n__-prdslib.isType '"Bool",
                                        no_alert_for_skipped_runs =
                                          _js2n__-prdslib.isType '"Bool",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            parameters =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "default", "name" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              "default" =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            permissions =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "level" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              group_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              level =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              service_principal_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              user_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            queue =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "enabled" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        enabled =
                                          _js2n__-prdslib.isType '"Bool",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            run_as =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        service_principal_name =
                                          _js2n__-prdslib.isType '"String",
                                        user_name =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            schedule =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [
                                        "quartz_cron_expression",
                                        "timezone_id"
                                      ],
                                    _js2n__-prdslib.records.record
                                      {
                                        pause_status =
                                          _js2n__-prdslib.isType '"String",
                                        quartz_cron_expression =
                                          _js2n__-prdslib.isType '"String",
                                        timezone_id =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            tags =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record {} {} true
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                            tasks =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "task_key" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              compute_key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              condition_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          left =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          op =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          right =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              dbt_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "commands" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          catalog =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          commands =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          profiles_directory =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          project_directory =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          schema =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          warehouse_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              depends_on =
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
                                                              [ "task_key" ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                outcome =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                task_key =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ])
                                                    ],
                                              description =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              email_notifications =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          on_duration_warning_threshold_exceeded =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          on_failure =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          on_start =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          on_success =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              existing_cluster_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              health =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
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
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            metric =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            op =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            value =
                                                                              _js2n__-prdslib.isType
                                                                                  '"Number",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ])
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              job_cluster_key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              libraries =
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
                                                                cran =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.required
                                                                          [
                                                                            "package"
                                                                          ],
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            package =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            repo =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ],
                                                                egg =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                jar =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                maven =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.required
                                                                          [
                                                                            "coordinates"
                                                                          ],
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            coordinates =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            exclusions =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      '"Array",
                                                                                    _js2n__-prdslib.arrays.arrayOf
                                                                                      (_js2n__-prdslib.isType
                                                                                        '"String")
                                                                                  ],
                                                                            repo =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ],
                                                                pypi =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.required
                                                                          [
                                                                            "package"
                                                                          ],
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            package =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            repo =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ],
                                                                whl =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ])
                                                    ],
                                              max_retries =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              min_retry_interval_millis =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              new_cluster =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          apply_policy_default_values =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          autoscale =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "max_workers",
                                                                      "min_workers"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      max_workers =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      min_workers =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          autotermination_minutes =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          aws_attributes =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      availability =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      ebs_volume_count =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      ebs_volume_iops =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      ebs_volume_size =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      ebs_volume_throughput =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      ebs_volume_type =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      first_on_demand =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      instance_profile_arn =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      spot_bid_price_percent =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      zone_id =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          azure_attributes =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      availability =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      first_on_demand =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      log_analytics_info =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  log_analytics_primary_key =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  log_analytics_workspace_id =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                }
                                                                                {}
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                      spot_bid_max_price =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          cluster_log_conf =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      dbfs =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  destination =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                }
                                                                                {}
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                      s3 =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  canned_acl =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  destination =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  enable_encryption =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"Bool",
                                                                                  encryption_type =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  endpoint =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  kms_key =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                  region =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                }
                                                                                {}
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          cluster_name =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          cluster_source =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          custom_tags =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          data_security_mode =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          docker_image =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      basic_auth =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
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
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                      url =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          driver_instance_pool_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          driver_node_type_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          enable_elastic_disk =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          enable_local_disk_encryption =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          gcp_attributes =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      availability =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      boot_disk_size =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                      google_service_account =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      local_ssd_count =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          init_scripts =
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
                                                                            dbfs =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                            file =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                            s3 =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        canned_acl =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        enable_encryption =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"Bool",
                                                                                        encryption_type =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        endpoint =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        kms_key =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        region =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                            volumes =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                            workspace =
                                                                              _js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      'Record,
                                                                                    _js2n__-prdslib.records.record
                                                                                      {
                                                                                        destination =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ],
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ])
                                                                ],
                                                          instance_pool_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          node_type_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          num_workers =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          policy_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          runtime_engine =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          single_user_name =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          spark_conf =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          spark_env_vars =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          spark_version =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          ssh_public_keys =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          workload_type =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      clients =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  jobs =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"Bool",
                                                                                  notebooks =
                                                                                    _js2n__-prdslib.isType
                                                                                        '"Bool",
                                                                                }
                                                                                {}
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              notebook_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "notebook_path" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          base_parameters =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          notebook_path =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          source =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              notification_settings =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          alert_on_last_attempt =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          no_alert_for_canceled_runs =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          no_alert_for_skipped_runs =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              pipeline_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          full_refresh =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          pipeline_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              python_wheel_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          entry_point =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          named_parameters =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          package_name =
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
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              retry_on_timeout =
                                                _js2n__-prdslib.isType '"Bool",
                                              run_if =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              run_job_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "job_id" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          job_id =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          job_parameters =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              spark_jar_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          jar_uri =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          main_class_name =
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
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              spark_python_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "python_file" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          parameters =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          python_file =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          source =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              spark_submit_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          parameters =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              sql_task =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "warehouse_id" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          alert =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "alert_id"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      alert_id =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      pause_subscriptions =
                                                                        _js2n__-prdslib.isType
                                                                            '"Bool",
                                                                      subscriptions =
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
                                                                                        destination_id =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        user_name =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ])
                                                                            ],
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          dashboard =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "dashboard_id"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      custom_subject =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      dashboard_id =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      pause_subscriptions =
                                                                        _js2n__-prdslib.isType
                                                                            '"Bool",
                                                                      subscriptions =
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
                                                                                        destination_id =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                        user_name =
                                                                                          _js2n__-prdslib.isType
                                                                                              '"String",
                                                                                      }
                                                                                      {}
                                                                                      false
                                                                                      _js2n__-prdslib.never
                                                                                  ])
                                                                            ],
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          file =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [ "path" ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      path =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          parameters =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {} {} true
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          query =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "query_id"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      query_id =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          warehouse_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              task_key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              timeout_seconds =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              webhook_notifications =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          on_duration_warning_threshold_exceeded =
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
                                                                            id =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ])
                                                                ],
                                                          on_failure =
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
                                                                            id =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ])
                                                                ],
                                                          on_start =
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
                                                                            id =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ])
                                                                ],
                                                          on_success =
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
                                                                            id =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ])
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            timeout_seconds = _js2n__-prdslib.isType '"Number",
                            trigger =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        file_arrival =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    min_time_between_triggers_seconds =
                                                      _js2n__-prdslib.isType
                                                          '"Number",
                                                    url =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    wait_after_last_change_seconds =
                                                      _js2n__-prdslib.isType
                                                          '"Number",
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                        pause_status =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            webhook_notifications =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        on_duration_warning_threshold_exceeded =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                        on_failure =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                        on_start =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                        on_success =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                          } {} false _js2n__-prdslib.never
                      ])
                ])
            | doc "List of Databricks jobs"
            | optional,
          model_serving_endpoints
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "config", "name" ],
                        _js2n__-prdslib.records.record
                          {
                            config =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        auto_capture_config =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    catalog_name =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    enabled =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                    schema_name =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    table_name_prefix =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                        served_entities =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          entity_name =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          entity_version =
                                                            _js2n__-prdslib.isType
                                                                '"String",
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
                                                          external_model =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "config",
                                                                      "name",
                                                                      "provider",
                                                                      "task"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      config =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  ai21labs_config =
                                                                                    _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.records.required
                                                                                            [
                                                                                              "ai21labs_api_key"
                                                                                            ],
                                                                                          _js2n__-prdslib.records.record
                                                                                            {
                                                                                              ai21labs_api_key =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                            }
                                                                                            {}
                                                                                            false
                                                                                            _js2n__-prdslib.never
                                                                                        ],
                                                                                  anthropic_config =
                                                                                    _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.records.required
                                                                                            [
                                                                                              "anthropic_api_key"
                                                                                            ],
                                                                                          _js2n__-prdslib.records.record
                                                                                            {
                                                                                              anthropic_api_key =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                            }
                                                                                            {}
                                                                                            false
                                                                                            _js2n__-prdslib.never
                                                                                        ],
                                                                                  aws_bedrock_config =
                                                                                    _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.records.required
                                                                                            [
                                                                                              "aws_access_key_id",
                                                                                              "aws_region",
                                                                                              "aws_secret_access_key",
                                                                                              "bedrock_provider"
                                                                                            ],
                                                                                          _js2n__-prdslib.records.record
                                                                                            {
                                                                                              aws_access_key_id =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              aws_region =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              aws_secret_access_key =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              bedrock_provider =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                            }
                                                                                            {}
                                                                                            false
                                                                                            _js2n__-prdslib.never
                                                                                        ],
                                                                                  cohere_config =
                                                                                    _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.records.required
                                                                                            [
                                                                                              "cohere_api_key"
                                                                                            ],
                                                                                          _js2n__-prdslib.records.record
                                                                                            {
                                                                                              cohere_api_key =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                            }
                                                                                            {}
                                                                                            false
                                                                                            _js2n__-prdslib.never
                                                                                        ],
                                                                                  databricks_model_serving_config =
                                                                                    _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.records.required
                                                                                            [
                                                                                              "databricks_api_token",
                                                                                              "databricks_workspace_url"
                                                                                            ],
                                                                                          _js2n__-prdslib.records.record
                                                                                            {
                                                                                              databricks_api_token =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              databricks_workspace_url =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                            }
                                                                                            {}
                                                                                            false
                                                                                            _js2n__-prdslib.never
                                                                                        ],
                                                                                  openai_config =
                                                                                    _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.records.required
                                                                                            [
                                                                                              "openai_api_key"
                                                                                            ],
                                                                                          _js2n__-prdslib.records.record
                                                                                            {
                                                                                              openai_api_base =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              openai_api_key =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              openai_api_type =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              openai_api_version =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              openai_deployment_name =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                              openai_organization =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                            }
                                                                                            {}
                                                                                            false
                                                                                            _js2n__-prdslib.never
                                                                                        ],
                                                                                  palm_config =
                                                                                    _js2n__-prdslib.allOf
                                                                                        [
                                                                                          _js2n__-prdslib.isType
                                                                                            'Record,
                                                                                          _js2n__-prdslib.records.required
                                                                                            [
                                                                                              "palm_api_key"
                                                                                            ],
                                                                                          _js2n__-prdslib.records.record
                                                                                            {
                                                                                              palm_api_key =
                                                                                                _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                            }
                                                                                            {}
                                                                                            false
                                                                                            _js2n__-prdslib.never
                                                                                        ],
                                                                                }
                                                                                {}
                                                                                false
                                                                                _js2n__-prdslib.never
                                                                            ],
                                                                      name =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      provider =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      task =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          instance_profile_arn =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          name =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          scale_to_zero_enabled =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          workload_size =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          workload_type =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                        served_models =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [
                                                          "model_name",
                                                          "model_version",
                                                          "scale_to_zero_enabled",
                                                          "workload_size"
                                                        ],
                                                      _js2n__-prdslib.records.record
                                                        {
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
                                                          instance_profile_arn =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          model_name =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          model_version =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          name =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          scale_to_zero_enabled =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          workload_size =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          workload_type =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                        traffic_config =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    routes =
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
                                                                      "served_model_name",
                                                                      "traffic_percentage"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      served_model_name =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      traffic_percentage =
                                                                        _js2n__-prdslib.isType
                                                                            '"Number",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ])
                                                          ],
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            name = _js2n__-prdslib.isType '"String",
                            permissions =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "level" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              group_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              level =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              service_principal_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              user_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            rate_limits =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "calls", "renewal_period" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              calls =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              renewal_period =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            tags =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "key" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              value =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                          } {} false _js2n__-prdslib.never
                      ])
                ])
            | doc "List of Model Serving Endpoints"
            | optional,
          models
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            creation_timestamp =
                              _js2n__-prdslib.isType '"Number",
                            description = _js2n__-prdslib.isType '"String",
                            last_updated_timestamp =
                              _js2n__-prdslib.isType '"Number",
                            latest_versions =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              creation_timestamp =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              current_stage =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              description =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              last_updated_timestamp =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              run_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              run_link =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              source =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              status =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              status_message =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              tags =
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
                                                                key =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                value =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ])
                                                    ],
                                              user_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              version =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            name = _js2n__-prdslib.isType '"String",
                            permissions =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "level" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              group_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              level =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              service_principal_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              user_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            tags =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              value =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            user_id = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ])
                ])
            | doc "List of MLflow models"
            | optional,
          pipelines
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            catalog = _js2n__-prdslib.isType '"String",
                            channel = _js2n__-prdslib.isType '"String",
                            clusters =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              apply_policy_default_values =
                                                _js2n__-prdslib.isType '"Bool",
                                              autoscale =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [
                                                          "max_workers",
                                                          "min_workers"
                                                        ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          max_workers =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          min_workers =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              aws_attributes =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          availability =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          ebs_volume_count =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          ebs_volume_iops =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          ebs_volume_size =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          ebs_volume_throughput =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          ebs_volume_type =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          first_on_demand =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          instance_profile_arn =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          spot_bid_price_percent =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          zone_id =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              azure_attributes =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          availability =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          first_on_demand =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          log_analytics_info =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      log_analytics_primary_key =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      log_analytics_workspace_id =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          spot_bid_max_price =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              cluster_log_conf =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          dbfs =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      destination =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                          s3 =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      canned_acl =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      destination =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      enable_encryption =
                                                                        _js2n__-prdslib.isType
                                                                            '"Bool",
                                                                      encryption_type =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      endpoint =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      kms_key =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      region =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              custom_tags =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {} {} true
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              driver_instance_pool_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              driver_node_type_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              gcp_attributes =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          availability =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          boot_disk_size =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                          google_service_account =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          local_ssd_count =
                                                            _js2n__-prdslib.isType
                                                                '"Number",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              init_scripts =
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
                                                                dbfs =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            destination =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ],
                                                                file =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            destination =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ],
                                                                s3 =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            canned_acl =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            destination =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            enable_encryption =
                                                                              _js2n__-prdslib.isType
                                                                                  '"Bool",
                                                                            encryption_type =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            endpoint =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            kms_key =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                            region =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ],
                                                                volumes =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            destination =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ],
                                                                workspace =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          'Record,
                                                                        _js2n__-prdslib.records.record
                                                                          {
                                                                            destination =
                                                                              _js2n__-prdslib.isType
                                                                                  '"String",
                                                                          } {}
                                                                          false
                                                                          _js2n__-prdslib.never
                                                                      ],
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ])
                                                    ],
                                              instance_pool_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              label =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              node_type_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              num_workers =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              policy_id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              spark_conf =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {} {} true
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              spark_env_vars =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {} {} true
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              ssh_public_keys =
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
                            configuration =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record {} {} true
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                            continuous = _js2n__-prdslib.isType '"Bool",
                            development = _js2n__-prdslib.isType '"Bool",
                            edition = _js2n__-prdslib.isType '"String",
                            filters =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        exclude =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        include =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            id = _js2n__-prdslib.isType '"String",
                            libraries =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              file =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          path =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              jar =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              maven =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "coordinates" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          coordinates =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          exclusions =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                          repo =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              notebook =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          path =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            name = _js2n__-prdslib.isType '"String",
                            notifications =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              alerts =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              email_recipients =
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
                            permissions =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "level" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              group_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              level =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              service_principal_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              user_name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            photon = _js2n__-prdslib.isType '"Bool",
                            serverless = _js2n__-prdslib.isType '"Bool",
                            storage = _js2n__-prdslib.isType '"String",
                            target = _js2n__-prdslib.isType '"String",
                            trigger =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        cron =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    quartz_cron_schedule =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    timezone_id =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                        manual = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ],
                          } {} false _js2n__-prdslib.never
                      ])
                ])
            | doc "List of DLT pipelines"
            | optional,
          registered_models
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "catalog_name", "name", "schema_name" ],
                        _js2n__-prdslib.records.record
                          {
                            catalog_name = _js2n__-prdslib.isType '"String",
                            comment = _js2n__-prdslib.isType '"String",
                            grants =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "principal", "privileges" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              principal =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              privileges =
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
                            name = _js2n__-prdslib.isType '"String",
                            schema_name = _js2n__-prdslib.isType '"String",
                            storage_location = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ])
                ])
            | doc "List of Registered Models"
            | optional,
        }
        | doc "Collection of Databricks resources to deploy."
        | optional,
      run_as
        | {
          service_principal_name | String | optional,
          user_name | String | optional,
        }
        | optional,
      sync
        | {
          exclude | Array (String) | optional,
          include | Array (String) | optional,
        }
        | optional,
      targets
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        artifacts =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "type" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          build =
                                            _js2n__-prdslib.isType '"String",
                                          files =
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
                                                          [ "source" ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            source =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ])
                                                ],
                                          path =
                                            _js2n__-prdslib.isType '"String",
                                          type =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ])
                              ],
                        bundle =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "name" ],
                                _js2n__-prdslib.records.record
                                  {
                                    compute_id =
                                      _js2n__-prdslib.isType '"String",
                                    git =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                branch =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                origin_url =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ],
                                    name = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                        compute_id = _js2n__-prdslib.isType '"String",
                        "default" = _js2n__-prdslib.isType '"Bool",
                        git =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    branch = _js2n__-prdslib.isType '"String",
                                    origin_url =
                                      _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                        mode = _js2n__-prdslib.isType '"String",
                        permissions =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "level" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          group_name =
                                            _js2n__-prdslib.isType '"String",
                                          level =
                                            _js2n__-prdslib.isType '"String",
                                          service_principal_name =
                                            _js2n__-prdslib.isType '"String",
                                          user_name =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ])
                              ],
                        resources =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    experiments =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      artifact_location =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      creation_time =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      experiment_id =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      last_update_time =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      lifecycle_stage =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      permissions =
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
                                                                        "level"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        group_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        level =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        service_principal_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        user_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      tags =
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
                                                                        key =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        value =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ])
                                          ],
                                    jobs =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      compute =
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
                                                                        "compute_key",
                                                                        "spec"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        compute_key =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        spec =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    kind =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      continuous =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  pause_status =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      deployment =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.required
                                                                [ "kind" ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  kind =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  metadata_file_path =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      edit_mode =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      email_notifications =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  no_alert_for_skipped_runs =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  on_duration_warning_threshold_exceeded =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"Array",
                                                                          _js2n__-prdslib.arrays.arrayOf
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                  on_failure =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"Array",
                                                                          _js2n__-prdslib.arrays.arrayOf
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                  on_start =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"Array",
                                                                          _js2n__-prdslib.arrays.arrayOf
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                  on_success =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"Array",
                                                                          _js2n__-prdslib.arrays.arrayOf
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      format =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      git_source =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.required
                                                                [
                                                                  "git_provider",
                                                                  "git_url"
                                                                ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  git_branch =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  git_commit =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  git_provider =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  git_snapshot =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              used_commit =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                            } {}
                                                                            false
                                                                            _js2n__-prdslib.never
                                                                        ],
                                                                  git_tag =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  git_url =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  job_source =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.required
                                                                            [
                                                                              "import_from_git_branch",
                                                                              "job_config_path"
                                                                            ],
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              dirty_state =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                              import_from_git_branch =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                              job_config_path =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                            } {}
                                                                            false
                                                                            _js2n__-prdslib.never
                                                                        ],
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      health =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
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
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    metric =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    op =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    value =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ])
                                                                        ],
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      job_clusters =
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
                                                                        "job_cluster_key"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        job_cluster_key =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        new_cluster =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    apply_policy_default_values =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    autoscale =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.required
                                                                                              [
                                                                                                "max_workers",
                                                                                                "min_workers"
                                                                                              ],
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                max_workers =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                min_workers =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    autotermination_minutes =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    aws_attributes =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                availability =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                ebs_volume_count =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                ebs_volume_iops =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                ebs_volume_size =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                ebs_volume_throughput =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                ebs_volume_type =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                first_on_demand =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                instance_profile_arn =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                spot_bid_price_percent =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                zone_id =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    azure_attributes =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                availability =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                first_on_demand =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                log_analytics_info =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.records.record
                                                                                                          {
                                                                                                            log_analytics_primary_key =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            log_analytics_workspace_id =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                          }
                                                                                                          {}
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                                spot_bid_max_price =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    cluster_log_conf =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                dbfs =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.records.record
                                                                                                          {
                                                                                                            destination =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                          }
                                                                                                          {}
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                                s3 =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.records.record
                                                                                                          {
                                                                                                            canned_acl =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            destination =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            enable_encryption =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                            encryption_type =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            endpoint =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            kms_key =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            region =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                          }
                                                                                                          {}
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    cluster_name =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    cluster_source =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    custom_tags =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    data_security_mode =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    docker_image =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                basic_auth =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
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
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                                url =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    driver_instance_pool_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    driver_node_type_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    enable_elastic_disk =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    enable_local_disk_encryption =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    gcp_attributes =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                availability =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                boot_disk_size =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                google_service_account =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                local_ssd_count =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    init_scripts =
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
                                                                                                      dbfs =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                      file =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                      s3 =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  canned_acl =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  enable_encryption =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"Bool",
                                                                                                                  encryption_type =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  endpoint =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  kms_key =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  region =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                      volumes =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                      workspace =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ])
                                                                                          ],
                                                                                    instance_pool_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    node_type_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    num_workers =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    policy_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    runtime_engine =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    single_user_name =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    spark_conf =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    spark_env_vars =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    spark_version =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    ssh_public_keys =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    workload_type =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                clients =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.records.record
                                                                                                          {
                                                                                                            jobs =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                            notebooks =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                          }
                                                                                                          {}
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      max_concurrent_runs =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      notification_settings =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  no_alert_for_canceled_runs =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  no_alert_for_skipped_runs =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      parameters =
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
                                                                        "name"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        "default" =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      permissions =
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
                                                                        "level"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        group_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        level =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        service_principal_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        user_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      queue =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.required
                                                                [ "enabled" ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  enabled =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      run_as =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  service_principal_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  user_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      schedule =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.required
                                                                [
                                                                  "quartz_cron_expression",
                                                                  "timezone_id"
                                                                ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  pause_status =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  quartz_cron_expression =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  timezone_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      tags =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {} {} true
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      tasks =
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
                                                                        "task_key"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        compute_key =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        condition_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    left =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    op =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    right =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        dbt_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.required
                                                                                  [
                                                                                    "commands"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    catalog =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    commands =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    profiles_directory =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    project_directory =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    schema =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    warehouse_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        depends_on =
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
                                                                                          "task_key"
                                                                                        ],
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          outcome =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                          task_key =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                        }
                                                                                        {}
                                                                                        false
                                                                                        _js2n__-prdslib.never
                                                                                    ])
                                                                              ],
                                                                        description =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        email_notifications =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    on_duration_warning_threshold_exceeded =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    on_failure =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    on_start =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    on_success =
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
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        existing_cluster_id =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        health =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
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
                                                                                                  _js2n__-prdslib.records.record
                                                                                                    {
                                                                                                      metric =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      op =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      value =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"Number",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ])
                                                                                          ],
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        job_cluster_key =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        libraries =
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
                                                                                          cran =
                                                                                            _js2n__-prdslib.allOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Record,
                                                                                                  _js2n__-prdslib.records.required
                                                                                                    [
                                                                                                      "package"
                                                                                                    ],
                                                                                                  _js2n__-prdslib.records.record
                                                                                                    {
                                                                                                      package =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      repo =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ],
                                                                                          egg =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                          jar =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                          maven =
                                                                                            _js2n__-prdslib.allOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Record,
                                                                                                  _js2n__-prdslib.records.required
                                                                                                    [
                                                                                                      "coordinates"
                                                                                                    ],
                                                                                                  _js2n__-prdslib.records.record
                                                                                                    {
                                                                                                      coordinates =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      exclusions =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                '"Array",
                                                                                                              _js2n__-prdslib.arrays.arrayOf
                                                                                                                (_js2n__-prdslib.isType
                                                                                                                  '"String")
                                                                                                            ],
                                                                                                      repo =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ],
                                                                                          pypi =
                                                                                            _js2n__-prdslib.allOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Record,
                                                                                                  _js2n__-prdslib.records.required
                                                                                                    [
                                                                                                      "package"
                                                                                                    ],
                                                                                                  _js2n__-prdslib.records.record
                                                                                                    {
                                                                                                      package =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      repo =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ],
                                                                                          whl =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                        }
                                                                                        {}
                                                                                        false
                                                                                        _js2n__-prdslib.never
                                                                                    ])
                                                                              ],
                                                                        max_retries =
                                                                          _js2n__-prdslib.isType
                                                                              '"Number",
                                                                        min_retry_interval_millis =
                                                                          _js2n__-prdslib.isType
                                                                              '"Number",
                                                                        new_cluster =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    apply_policy_default_values =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    autoscale =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.required
                                                                                              [
                                                                                                "max_workers",
                                                                                                "min_workers"
                                                                                              ],
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                max_workers =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                min_workers =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    autotermination_minutes =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    aws_attributes =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                availability =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                ebs_volume_count =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                ebs_volume_iops =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                ebs_volume_size =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                ebs_volume_throughput =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                ebs_volume_type =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                first_on_demand =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                instance_profile_arn =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                spot_bid_price_percent =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                zone_id =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    azure_attributes =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                availability =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                first_on_demand =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                log_analytics_info =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.records.record
                                                                                                          {
                                                                                                            log_analytics_primary_key =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            log_analytics_workspace_id =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                          }
                                                                                                          {}
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                                spot_bid_max_price =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    cluster_log_conf =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                dbfs =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.records.record
                                                                                                          {
                                                                                                            destination =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                          }
                                                                                                          {}
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                                s3 =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.records.record
                                                                                                          {
                                                                                                            canned_acl =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            destination =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            enable_encryption =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                            encryption_type =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            endpoint =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            kms_key =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                            region =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"String",
                                                                                                          }
                                                                                                          {}
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    cluster_name =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    cluster_source =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    custom_tags =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    data_security_mode =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    docker_image =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                basic_auth =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
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
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                                url =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    driver_instance_pool_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    driver_node_type_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    enable_elastic_disk =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    enable_local_disk_encryption =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    gcp_attributes =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                availability =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                boot_disk_size =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                                google_service_account =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                local_ssd_count =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    init_scripts =
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
                                                                                                      dbfs =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                      file =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                      s3 =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  canned_acl =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  enable_encryption =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"Bool",
                                                                                                                  encryption_type =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  endpoint =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  kms_key =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  region =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                      volumes =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                      workspace =
                                                                                                        _js2n__-prdslib.allOf
                                                                                                            [
                                                                                                              _js2n__-prdslib.isType
                                                                                                                'Record,
                                                                                                              _js2n__-prdslib.records.record
                                                                                                                {
                                                                                                                  destination =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ],
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ])
                                                                                          ],
                                                                                    instance_pool_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    node_type_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    num_workers =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    policy_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    runtime_engine =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    single_user_name =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    spark_conf =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    spark_env_vars =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    spark_version =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    ssh_public_keys =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    workload_type =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                clients =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.records.record
                                                                                                          {
                                                                                                            jobs =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                            notebooks =
                                                                                                              _js2n__-prdslib.isType
                                                                                                                  '"Bool",
                                                                                                          }
                                                                                                          {}
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        notebook_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.required
                                                                                  [
                                                                                    "notebook_path"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    base_parameters =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    notebook_path =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    source =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        notification_settings =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    alert_on_last_attempt =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    no_alert_for_canceled_runs =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    no_alert_for_skipped_runs =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        pipeline_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    full_refresh =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    pipeline_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        python_wheel_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    entry_point =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    named_parameters =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    package_name =
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
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        retry_on_timeout =
                                                                          _js2n__-prdslib.isType
                                                                              '"Bool",
                                                                        run_if =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        run_job_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.required
                                                                                  [
                                                                                    "job_id"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    job_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    job_parameters =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        spark_jar_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    jar_uri =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    main_class_name =
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
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        spark_python_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.required
                                                                                  [
                                                                                    "python_file"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    parameters =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    python_file =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    source =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        spark_submit_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    parameters =
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
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        sql_task =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.required
                                                                                  [
                                                                                    "warehouse_id"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    alert =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.required
                                                                                              [
                                                                                                "alert_id"
                                                                                              ],
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                alert_id =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                pause_subscriptions =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Bool",
                                                                                                subscriptions =
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
                                                                                                                  destination_id =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  user_name =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ])
                                                                                                      ],
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    dashboard =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.required
                                                                                              [
                                                                                                "dashboard_id"
                                                                                              ],
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                custom_subject =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                dashboard_id =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                pause_subscriptions =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Bool",
                                                                                                subscriptions =
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
                                                                                                                  destination_id =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                  user_name =
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                }
                                                                                                                {}
                                                                                                                false
                                                                                                                _js2n__-prdslib.never
                                                                                                            ])
                                                                                                      ],
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    file =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.required
                                                                                              [
                                                                                                "path"
                                                                                              ],
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                path =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    parameters =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    query =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.required
                                                                                              [
                                                                                                "query_id"
                                                                                              ],
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                query_id =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    warehouse_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        task_key =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        timeout_seconds =
                                                                          _js2n__-prdslib.isType
                                                                              '"Number",
                                                                        webhook_notifications =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    on_duration_warning_threshold_exceeded =
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
                                                                                                      id =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ])
                                                                                          ],
                                                                                    on_failure =
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
                                                                                                      id =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ])
                                                                                          ],
                                                                                    on_start =
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
                                                                                                      id =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ])
                                                                                          ],
                                                                                    on_success =
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
                                                                                                      id =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ])
                                                                                          ],
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      timeout_seconds =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      trigger =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  file_arrival =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              min_time_between_triggers_seconds =
                                                                                _js2n__-prdslib.isType
                                                                                    '"Number",
                                                                              url =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                              wait_after_last_change_seconds =
                                                                                _js2n__-prdslib.isType
                                                                                    '"Number",
                                                                            } {}
                                                                            false
                                                                            _js2n__-prdslib.never
                                                                        ],
                                                                  pause_status =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      webhook_notifications =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  on_duration_warning_threshold_exceeded =
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
                                                                                    id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ])
                                                                        ],
                                                                  on_failure =
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
                                                                                    id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ])
                                                                        ],
                                                                  on_start =
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
                                                                                    id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ])
                                                                        ],
                                                                  on_success =
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
                                                                                    id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ])
                                                                        ],
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ])
                                          ],
                                    model_serving_endpoints =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "config", "name" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      config =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  auto_capture_config =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              catalog_name =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                              enabled =
                                                                                _js2n__-prdslib.isType
                                                                                    '"Bool",
                                                                              schema_name =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                              table_name_prefix =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                            } {}
                                                                            false
                                                                            _js2n__-prdslib.never
                                                                        ],
                                                                  served_entities =
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
                                                                                    entity_name =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    entity_version =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    environment_vars =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    external_model =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.required
                                                                                              [
                                                                                                "config",
                                                                                                "name",
                                                                                                "provider",
                                                                                                "task"
                                                                                              ],
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                config =
                                                                                                  _js2n__-prdslib.allOf
                                                                                                      [
                                                                                                        _js2n__-prdslib.isType
                                                                                                          'Record,
                                                                                                        _js2n__-prdslib.records.record
                                                                                                          {
                                                                                                            ai21labs_config =
                                                                                                              _js2n__-prdslib.allOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                      [
                                                                                                                        "ai21labs_api_key"
                                                                                                                      ],
                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                      {
                                                                                                                        ai21labs_api_key =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                      }
                                                                                                                      {}
                                                                                                                      false
                                                                                                                      _js2n__-prdslib.never
                                                                                                                  ],
                                                                                                            anthropic_config =
                                                                                                              _js2n__-prdslib.allOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                      [
                                                                                                                        "anthropic_api_key"
                                                                                                                      ],
                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                      {
                                                                                                                        anthropic_api_key =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                      }
                                                                                                                      {}
                                                                                                                      false
                                                                                                                      _js2n__-prdslib.never
                                                                                                                  ],
                                                                                                            aws_bedrock_config =
                                                                                                              _js2n__-prdslib.allOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                      [
                                                                                                                        "aws_access_key_id",
                                                                                                                        "aws_region",
                                                                                                                        "aws_secret_access_key",
                                                                                                                        "bedrock_provider"
                                                                                                                      ],
                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                      {
                                                                                                                        aws_access_key_id =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                        aws_region =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                        aws_secret_access_key =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                        bedrock_provider =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                      }
                                                                                                                      {}
                                                                                                                      false
                                                                                                                      _js2n__-prdslib.never
                                                                                                                  ],
                                                                                                            cohere_config =
                                                                                                              _js2n__-prdslib.allOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                      [
                                                                                                                        "cohere_api_key"
                                                                                                                      ],
                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                      {
                                                                                                                        cohere_api_key =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                      }
                                                                                                                      {}
                                                                                                                      false
                                                                                                                      _js2n__-prdslib.never
                                                                                                                  ],
                                                                                                            databricks_model_serving_config =
                                                                                                              _js2n__-prdslib.allOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                      [
                                                                                                                        "databricks_api_token",
                                                                                                                        "databricks_workspace_url"
                                                                                                                      ],
                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                      {
                                                                                                                        databricks_api_token =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                        databricks_workspace_url =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                      }
                                                                                                                      {}
                                                                                                                      false
                                                                                                                      _js2n__-prdslib.never
                                                                                                                  ],
                                                                                                            openai_config =
                                                                                                              _js2n__-prdslib.allOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                      [
                                                                                                                        "openai_api_key"
                                                                                                                      ],
                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                      {
                                                                                                                        openai_api_base =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                        openai_api_key =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                        openai_api_type =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                        openai_api_version =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                        openai_deployment_name =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                        openai_organization =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                      }
                                                                                                                      {}
                                                                                                                      false
                                                                                                                      _js2n__-prdslib.never
                                                                                                                  ],
                                                                                                            palm_config =
                                                                                                              _js2n__-prdslib.allOf
                                                                                                                  [
                                                                                                                    _js2n__-prdslib.isType
                                                                                                                      'Record,
                                                                                                                    _js2n__-prdslib.records.required
                                                                                                                      [
                                                                                                                        "palm_api_key"
                                                                                                                      ],
                                                                                                                    _js2n__-prdslib.records.record
                                                                                                                      {
                                                                                                                        palm_api_key =
                                                                                                                          _js2n__-prdslib.isType
                                                                                                                              '"String",
                                                                                                                      }
                                                                                                                      {}
                                                                                                                      false
                                                                                                                      _js2n__-prdslib.never
                                                                                                                  ],
                                                                                                          }
                                                                                                          {}
                                                                                                          false
                                                                                                          _js2n__-prdslib.never
                                                                                                      ],
                                                                                                name =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                provider =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                task =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    instance_profile_arn =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    name =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    scale_to_zero_enabled =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    workload_size =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    workload_type =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ])
                                                                        ],
                                                                  served_models =
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
                                                                                    "model_name",
                                                                                    "model_version",
                                                                                    "scale_to_zero_enabled",
                                                                                    "workload_size"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    environment_vars =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {}
                                                                                              {}
                                                                                              true
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    instance_profile_arn =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    model_name =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    model_version =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    name =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    scale_to_zero_enabled =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Bool",
                                                                                    workload_size =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    workload_type =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ])
                                                                        ],
                                                                  traffic_config =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              routes =
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
                                                                                                "served_model_name",
                                                                                                "traffic_percentage"
                                                                                              ],
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                served_model_name =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                traffic_percentage =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Number",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ])
                                                                                    ],
                                                                            } {}
                                                                            false
                                                                            _js2n__-prdslib.never
                                                                        ],
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      permissions =
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
                                                                        "level"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        group_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        level =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        service_principal_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        user_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      rate_limits =
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
                                                                        "calls",
                                                                        "renewal_period"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        calls =
                                                                          _js2n__-prdslib.isType
                                                                              '"Number",
                                                                        key =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        renewal_period =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      tags =
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
                                                                      [ "key" ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        key =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        value =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ])
                                          ],
                                    models =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      creation_timestamp =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      last_updated_timestamp =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      latest_versions =
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
                                                                        creation_timestamp =
                                                                          _js2n__-prdslib.isType
                                                                              '"Number",
                                                                        current_stage =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        description =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        last_updated_timestamp =
                                                                          _js2n__-prdslib.isType
                                                                              '"Number",
                                                                        name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        run_id =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        run_link =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        source =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        status =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        status_message =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        tags =
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
                                                                                          key =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                          value =
                                                                                            _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                        }
                                                                                        {}
                                                                                        false
                                                                                        _js2n__-prdslib.never
                                                                                    ])
                                                                              ],
                                                                        user_id =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        version =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      permissions =
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
                                                                        "level"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        group_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        level =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        service_principal_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        user_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      tags =
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
                                                                        key =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        value =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      user_id =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ])
                                          ],
                                    pipelines =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      catalog =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      channel =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      clusters =
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
                                                                        apply_policy_default_values =
                                                                          _js2n__-prdslib.isType
                                                                              '"Bool",
                                                                        autoscale =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.required
                                                                                  [
                                                                                    "max_workers",
                                                                                    "min_workers"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    max_workers =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    min_workers =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        aws_attributes =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    availability =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    ebs_volume_count =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    ebs_volume_iops =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    ebs_volume_size =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    ebs_volume_throughput =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    ebs_volume_type =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    first_on_demand =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    instance_profile_arn =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    spot_bid_price_percent =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    zone_id =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        azure_attributes =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    availability =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    first_on_demand =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    log_analytics_info =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                log_analytics_primary_key =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                log_analytics_workspace_id =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    spot_bid_max_price =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        cluster_log_conf =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    dbfs =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                destination =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                    s3 =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              'Record,
                                                                                            _js2n__-prdslib.records.record
                                                                                              {
                                                                                                canned_acl =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                destination =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                enable_encryption =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"Bool",
                                                                                                encryption_type =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                endpoint =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                kms_key =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                                region =
                                                                                                  _js2n__-prdslib.isType
                                                                                                      '"String",
                                                                                              }
                                                                                              {}
                                                                                              false
                                                                                              _js2n__-prdslib.never
                                                                                          ],
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        custom_tags =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {}
                                                                                  {}
                                                                                  true
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"String")
                                                                              ],
                                                                        driver_instance_pool_id =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        driver_node_type_id =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        gcp_attributes =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    availability =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    boot_disk_size =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                    google_service_account =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    local_ssd_count =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"Number",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        init_scripts =
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
                                                                                          dbfs =
                                                                                            _js2n__-prdslib.allOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Record,
                                                                                                  _js2n__-prdslib.records.record
                                                                                                    {
                                                                                                      destination =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ],
                                                                                          file =
                                                                                            _js2n__-prdslib.allOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Record,
                                                                                                  _js2n__-prdslib.records.record
                                                                                                    {
                                                                                                      destination =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ],
                                                                                          s3 =
                                                                                            _js2n__-prdslib.allOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Record,
                                                                                                  _js2n__-prdslib.records.record
                                                                                                    {
                                                                                                      canned_acl =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      destination =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      enable_encryption =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"Bool",
                                                                                                      encryption_type =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      endpoint =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      kms_key =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                      region =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ],
                                                                                          volumes =
                                                                                            _js2n__-prdslib.allOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Record,
                                                                                                  _js2n__-prdslib.records.record
                                                                                                    {
                                                                                                      destination =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ],
                                                                                          workspace =
                                                                                            _js2n__-prdslib.allOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    'Record,
                                                                                                  _js2n__-prdslib.records.record
                                                                                                    {
                                                                                                      destination =
                                                                                                        _js2n__-prdslib.isType
                                                                                                            '"String",
                                                                                                    }
                                                                                                    {}
                                                                                                    false
                                                                                                    _js2n__-prdslib.never
                                                                                                ],
                                                                                        }
                                                                                        {}
                                                                                        false
                                                                                        _js2n__-prdslib.never
                                                                                    ])
                                                                              ],
                                                                        instance_pool_id =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        label =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        node_type_id =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        num_workers =
                                                                          _js2n__-prdslib.isType
                                                                              '"Number",
                                                                        policy_id =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        spark_conf =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {}
                                                                                  {}
                                                                                  true
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"String")
                                                                              ],
                                                                        spark_env_vars =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {}
                                                                                  {}
                                                                                  true
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"String")
                                                                              ],
                                                                        ssh_public_keys =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Array",
                                                                                _js2n__-prdslib.arrays.arrayOf
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"String")
                                                                              ],
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      configuration =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {} {} true
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      continuous =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      development =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      edition =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      filters =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  exclude =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"Array",
                                                                          _js2n__-prdslib.arrays.arrayOf
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                  include =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"Array",
                                                                          _js2n__-prdslib.arrays.arrayOf
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                      id =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      libraries =
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
                                                                        file =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    path =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        jar =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        maven =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.required
                                                                                  [
                                                                                    "coordinates"
                                                                                  ],
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    coordinates =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                    exclusions =
                                                                                      _js2n__-prdslib.allOf
                                                                                          [
                                                                                            _js2n__-prdslib.isType
                                                                                              '"Array",
                                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                                              (_js2n__-prdslib.isType
                                                                                                '"String")
                                                                                          ],
                                                                                    repo =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                        notebook =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  'Record,
                                                                                _js2n__-prdslib.records.record
                                                                                  {
                                                                                    path =
                                                                                      _js2n__-prdslib.isType
                                                                                          '"String",
                                                                                  }
                                                                                  {}
                                                                                  false
                                                                                  _js2n__-prdslib.never
                                                                              ],
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      notifications =
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
                                                                        alerts =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Array",
                                                                                _js2n__-prdslib.arrays.arrayOf
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"String")
                                                                              ],
                                                                        email_recipients =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Array",
                                                                                _js2n__-prdslib.arrays.arrayOf
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"String")
                                                                              ],
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      permissions =
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
                                                                        "level"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        group_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        level =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        service_principal_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        user_name =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      photon =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      serverless =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      storage =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      target =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      trigger =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  cron =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              quartz_cron_schedule =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                              timezone_id =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                            } {}
                                                                            false
                                                                            _js2n__-prdslib.never
                                                                        ],
                                                                  manual =
                                                                    _js2n__-prdslib.always,
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ])
                                          ],
                                    registered_models =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [
                                                      "catalog_name",
                                                      "name",
                                                      "schema_name"
                                                    ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      catalog_name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      comment =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      grants =
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
                                                                        "principal",
                                                                        "privileges"
                                                                      ],
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        principal =
                                                                          _js2n__-prdslib.isType
                                                                              '"String",
                                                                        privileges =
                                                                          _js2n__-prdslib.allOf
                                                                              [
                                                                                _js2n__-prdslib.isType
                                                                                  '"Array",
                                                                                _js2n__-prdslib.arrays.arrayOf
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"String")
                                                                              ],
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ])
                                                            ],
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      schema_name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      storage_location =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ])
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        run_as =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    service_principal_name =
                                      _js2n__-prdslib.isType '"String",
                                    user_name =
                                      _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                        sync =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    exclude =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    include =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        variables =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                        workspace =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    artifact_path =
                                      _js2n__-prdslib.isType '"String",
                                    auth_type =
                                      _js2n__-prdslib.isType '"String",
                                    azure_client_id =
                                      _js2n__-prdslib.isType '"String",
                                    azure_environment =
                                      _js2n__-prdslib.isType '"String",
                                    azure_login_app_id =
                                      _js2n__-prdslib.isType '"String",
                                    azure_tenant_id =
                                      _js2n__-prdslib.isType '"String",
                                    azure_use_msi =
                                      _js2n__-prdslib.isType '"Bool",
                                    azure_workspace_resource_id =
                                      _js2n__-prdslib.isType '"String",
                                    client_id =
                                      _js2n__-prdslib.isType '"String",
                                    file_path =
                                      _js2n__-prdslib.isType '"String",
                                    google_service_account =
                                      _js2n__-prdslib.isType '"String",
                                    host = _js2n__-prdslib.isType '"String",
                                    profile = _js2n__-prdslib.isType '"String",
                                    root_path =
                                      _js2n__-prdslib.isType '"String",
                                    state_path =
                                      _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
            ])
        | optional,
      variables
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        "default" = _js2n__-prdslib.isType '"String",
                        description = _js2n__-prdslib.isType '"String",
                        lookup =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    alert = _js2n__-prdslib.isType '"String",
                                    cluster = _js2n__-prdslib.isType '"String",
                                    cluster_policy =
                                      _js2n__-prdslib.isType '"String",
                                    dashboard =
                                      _js2n__-prdslib.isType '"String",
                                    instance_pool =
                                      _js2n__-prdslib.isType '"String",
                                    job = _js2n__-prdslib.isType '"String",
                                    metastore =
                                      _js2n__-prdslib.isType '"String",
                                    pipeline = _js2n__-prdslib.isType '"String",
                                    query = _js2n__-prdslib.isType '"String",
                                    service_principal =
                                      _js2n__-prdslib.isType '"String",
                                    warehouse =
                                      _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
            ])
        | optional,
      workspace
        | {
          artifact_path
            | String
            | doc "The remote path to synchronize build artifacts to. This defaults to `${workspace.root}/artifacts`"
            | optional,
          auth_type | String | optional,
          azure_client_id | String | optional,
          azure_environment
            | String
            | doc "Azure environment, one of (Public, UsGov, China, Germany)."
            | optional,
          azure_login_app_id
            | String
            | doc "Azure Login Application ID."
            | optional,
          azure_tenant_id | String | optional,
          azure_use_msi | Bool | optional,
          azure_workspace_resource_id
            | String
            | doc "Azure Resource Manager ID for Azure Databricks workspace."
            | optional,
          client_id | String | optional,
          file_path
            | String
            | doc "The remote path to synchronize local files artifacts to. This defaults to `${workspace.root}/files`"
            | optional,
          google_service_account | String | optional,
          host | String | doc "Host url of the workspace." | optional,
          profile
            | String
            | doc "Connection profile to use. By default profiles are specified in ~/.databrickscfg."
            | optional,
          root_path
            | String
            | doc "The base location for synchronizing files, artifacts and state. Defaults to `/Users/jane@doe.com/.bundle/${bundle.name}/${bundle.target}`"
            | optional,
          state_path
            | String
            | doc "The remote path to synchronize bundle state to. This defaults to `${workspace.root}/state`"
            | optional,
        }
        | doc "Configures which workspace to connect to and locations for files, state, and similar locations within the workspace file tree."
        | optional,
    }