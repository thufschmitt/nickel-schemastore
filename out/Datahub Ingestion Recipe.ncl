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
      "_js2n__-:definitions/AllowDenyPattern!predicate"
        | doc "A class to store allow deny regexes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  deny =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignoreCase = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AthenaProfilingConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  catch_exceptions = _js2n__-prdslib.isType '"Bool",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  field_sample_values_limit = _js2n__-prdslib.isType 'Integer,
                  include_field_distinct_count = _js2n__-prdslib.isType '"Bool",
                  include_field_distinct_value_frequencies =
                    _js2n__-prdslib.isType '"Bool",
                  include_field_histogram = _js2n__-prdslib.isType '"Bool",
                  include_field_max_value = _js2n__-prdslib.isType '"Bool",
                  include_field_mean_value = _js2n__-prdslib.isType '"Bool",
                  include_field_median_value = _js2n__-prdslib.isType '"Bool",
                  include_field_min_value = _js2n__-prdslib.isType '"Bool",
                  include_field_null_count = _js2n__-prdslib.isType '"Bool",
                  include_field_quantiles = _js2n__-prdslib.isType '"Bool",
                  include_field_sample_values = _js2n__-prdslib.isType '"Bool",
                  include_field_stddev_value = _js2n__-prdslib.isType '"Bool",
                  limit = _js2n__-prdslib.isType 'Integer,
                  max_number_of_fields_to_profile =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  offset = _js2n__-prdslib.isType 'Integer,
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                  partition_datetime = _js2n__-prdslib.isType '"String",
                  partition_profiling_enabled = _js2n__-prdslib.isType '"Bool",
                  profile_external_tables = _js2n__-prdslib.isType '"Bool",
                  profile_if_updated_since_days =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  profile_nested_fields = _js2n__-prdslib.isType '"Bool",
                  profile_table_level_only = _js2n__-prdslib.isType '"Bool",
                  profile_table_row_count_estimate_only =
                    _js2n__-prdslib.isType '"Bool",
                  profile_table_row_limit = _js2n__-prdslib.isType 'Integer,
                  profile_table_size_limit = _js2n__-prdslib.isType 'Integer,
                  query_combiner_enabled = _js2n__-prdslib.isType '"Bool",
                  report_dropped_profiles = _js2n__-prdslib.isType '"Bool",
                  sample_size = _js2n__-prdslib.isType 'Integer,
                  tags_to_ignore_sampling =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  turn_off_expensive_profiling_metrics =
                    _js2n__-prdslib.isType '"Bool",
                  use_sampling = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AwsAssumeRoleConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "RoleArn" ],
              _js2n__-prdslib.records.record
                {
                  ExternalId = _js2n__-prdslib.isType '"String",
                  RoleArn = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsConnectionConfig!predicate"
        | doc m%"
          Common AWS credentials config.
          
          Currently used by:
              - Glue source
              - SageMaker source
              - dbt source
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aws_access_key_id = _js2n__-prdslib.isType '"String",
                  aws_advanced_config = _js2n__-prdslib.isType 'Record,
                  aws_endpoint_url = _js2n__-prdslib.isType '"String",
                  aws_profile = _js2n__-prdslib.isType '"String",
                  aws_proxy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  aws_region = _js2n__-prdslib.isType '"String",
                  aws_role =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-refsenv."_js2n__-:definitions/AwsAssumeRoleConfig!predicate"
                                  ])
                            ]
                        ],
                  aws_secret_access_key = _js2n__-prdslib.isType '"String",
                  aws_session_token = _js2n__-prdslib.isType '"String",
                  read_timeout = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AzureConnectionConfig!predicate"
        | doc m%"
          Common Azure credentials config.
          
          https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-directory-file-acl-python
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "account_name", "container_name" ],
              _js2n__-prdslib.records.record
                {
                  account_key = _js2n__-prdslib.isType '"String",
                  account_name = _js2n__-prdslib.isType '"String",
                  base_path = _js2n__-prdslib.isType '"String",
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  container_name = _js2n__-prdslib.isType '"String",
                  sas_token = _js2n__-prdslib.isType '"String",
                  tenant_id = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BaseUsageConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  end_time = _js2n__-prdslib.isType '"String",
                  format_sql_queries = _js2n__-prdslib.isType '"Bool",
                  include_operational_stats = _js2n__-prdslib.isType '"Bool",
                  include_read_operational_stats =
                    _js2n__-prdslib.isType '"Bool",
                  include_top_n_queries = _js2n__-prdslib.isType '"Bool",
                  start_time = _js2n__-prdslib.isType '"String",
                  top_n_queries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  user_email_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BigQueryCredential!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "client_email",
                  "client_id",
                  "private_key",
                  "private_key_id",
                  "project_id"
                ],
              _js2n__-prdslib.records.record
                {
                  auth_provider_x509_cert_url =
                    _js2n__-prdslib.isType '"String",
                  auth_uri = _js2n__-prdslib.isType '"String",
                  client_email = _js2n__-prdslib.isType '"String",
                  client_id = _js2n__-prdslib.isType '"String",
                  client_x509_cert_url = _js2n__-prdslib.isType '"String",
                  private_key = _js2n__-prdslib.isType '"String",
                  private_key_id = _js2n__-prdslib.isType '"String",
                  project_id = _js2n__-prdslib.isType '"String",
                  token_uri = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BigQueryDestinationConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "dataset" ],
              _js2n__-prdslib.records.record
                {
                  credential =
                    _js2n__-refsenv."_js2n__-:definitions/BigQueryCredential!predicate",
                  dataset = _js2n__-prdslib.isType '"String",
                  extra_client_options = _js2n__-prdslib.isType 'Record,
                  project_on_behalf = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BigQueryUsageConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apply_view_usage_to_tables = _js2n__-prdslib.isType '"Bool",
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  end_time = _js2n__-prdslib.isType '"String",
                  format_sql_queries = _js2n__-prdslib.isType '"Bool",
                  include_operational_stats = _js2n__-prdslib.isType '"Bool",
                  include_read_operational_stats =
                    _js2n__-prdslib.isType '"Bool",
                  include_top_n_queries = _js2n__-prdslib.isType '"Bool",
                  max_query_duration = _js2n__-prdslib.isType '"Number",
                  start_time = _js2n__-prdslib.isType '"String",
                  top_n_queries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  user_email_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BucketDuration!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "DAY", "HOUR" ]
            ],
      "_js2n__-:definitions/CassandraCloudConfig!predicate"
        | doc "Configuration for connecting to DataStax Astra DB in the cloud."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "secure_connect_bundle", "token" ],
              _js2n__-prdslib.records.record
                {
                  connect_timeout = _js2n__-prdslib.isType 'Integer,
                  request_timeout = _js2n__-prdslib.isType 'Integer,
                  secure_connect_bundle = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ClassificationConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classifiers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DynamicTypedClassifierConfig!predicate"
                        ],
                  column_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  info_type_to_term =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  sample_size = _js2n__-prdslib.isType 'Integer,
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CollapseUrns!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  urns_suffix_regex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ConnectionMappingConfig!predicate"
        | doc "Any source that produces dataset urns in a single environment should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  env = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ConnectorDetail!predicate"
        | doc "Any source that connects to a platform should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  connector_database = _js2n__-prdslib.isType '"String",
                  connector_platform = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DBTEntitiesEnabled!predicate"
        | doc "Controls which dbt entities are going to be emitted by this source"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  model_performance =
                    _js2n__-refsenv."_js2n__-:definitions/EmitDirective!predicate",
                  models =
                    _js2n__-refsenv."_js2n__-:definitions/EmitDirective!predicate",
                  seeds =
                    _js2n__-refsenv."_js2n__-:definitions/EmitDirective!predicate",
                  snapshots =
                    _js2n__-refsenv."_js2n__-:definitions/EmitDirective!predicate",
                  sources =
                    _js2n__-refsenv."_js2n__-:definitions/EmitDirective!predicate",
                  test_definitions =
                    _js2n__-refsenv."_js2n__-:definitions/EmitDirective!predicate",
                  test_results =
                    _js2n__-refsenv."_js2n__-:definitions/EmitDirective!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DataBricksPlatformDetail!predicate"
        | doc "metastore is an additional field used in Databricks connector to generate the dataset urn"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "metastore" ],
              _js2n__-prdslib.records.record
                {
                  env = _js2n__-prdslib.isType '"String",
                  metastore = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DataLakeProfilerConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  include_field_distinct_value_frequencies =
                    _js2n__-prdslib.isType '"Bool",
                  include_field_histogram = _js2n__-prdslib.isType '"Bool",
                  include_field_max_value = _js2n__-prdslib.isType '"Bool",
                  include_field_mean_value = _js2n__-prdslib.isType '"Bool",
                  include_field_median_value = _js2n__-prdslib.isType '"Bool",
                  include_field_min_value = _js2n__-prdslib.isType '"Bool",
                  include_field_null_count = _js2n__-prdslib.isType '"Bool",
                  include_field_quantiles = _js2n__-prdslib.isType '"Bool",
                  include_field_sample_values = _js2n__-prdslib.isType '"Bool",
                  include_field_stddev_value = _js2n__-prdslib.isType '"Bool",
                  max_number_of_fields_to_profile =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                  profile_table_level_only = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DataProcessCleanupConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aspects_to_clean =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  batch_size = _js2n__-prdslib.isType 'Integer,
                  delay = _js2n__-prdslib.isType '"Number",
                  delete_empty_data_flows = _js2n__-prdslib.isType '"Bool",
                  delete_empty_data_jobs = _js2n__-prdslib.isType '"Bool",
                  hard_delete_entities = _js2n__-prdslib.isType '"Bool",
                  keep_last_n = _js2n__-prdslib.isType 'Integer,
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  retention_days = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DatabaseId!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "database" ],
              _js2n__-prdslib.records.record
                {
                  database = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DatahubExecutionRequestCleanupConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  batch_read_size = _js2n__-prdslib.isType 'Integer,
                  enabled = _js2n__-prdslib.isType '"Bool",
                  keep_history_max_count = _js2n__-prdslib.isType 'Integer,
                  keep_history_max_days = _js2n__-prdslib.isType 'Integer,
                  keep_history_min_count = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DeltaLakeDetails!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  env = _js2n__-prdslib.isType '"String",
                  platform_instance_name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DremioSourceMapping!predicate"
        | doc "Any source that produces dataset urns in a single environment should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "platform", "source_name" ],
              _js2n__-prdslib.records.record
                {
                  env = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  source_name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DynamicTypedClassifierConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  config = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ElasticProfiling!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/EmitDirective!predicate"
        | doc "A holder for directives for emission for specific types of entities"
        = _js2n__-prdslib.enum [ "YES", "NO", "ONLY" ],
      "_js2n__-:definitions/FileReadMode!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.enum [ "STREAM", "BATCH", "AUTO" ],
      "_js2n__-:definitions/FivetranLogConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bigquery_destination_config =
                    _js2n__-refsenv."_js2n__-:definitions/BigQueryDestinationConfig!predicate",
                  destination_platform =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "snowflake", "bigquery" ]
                        ],
                  snowflake_destination_config =
                    _js2n__-refsenv."_js2n__-:definitions/SnowflakeDestinationConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FolderTraversalMethod!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.enum [ "ALL", "MIN_MAX", "MAX" ],
      "_js2n__-:definitions/GEProfilingBaseConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  include_field_distinct_count = _js2n__-prdslib.isType '"Bool",
                  include_field_distinct_value_frequencies =
                    _js2n__-prdslib.isType '"Bool",
                  include_field_histogram = _js2n__-prdslib.isType '"Bool",
                  include_field_max_value = _js2n__-prdslib.isType '"Bool",
                  include_field_mean_value = _js2n__-prdslib.isType '"Bool",
                  include_field_median_value = _js2n__-prdslib.isType '"Bool",
                  include_field_min_value = _js2n__-prdslib.isType '"Bool",
                  include_field_null_count = _js2n__-prdslib.isType '"Bool",
                  include_field_quantiles = _js2n__-prdslib.isType '"Bool",
                  include_field_sample_values = _js2n__-prdslib.isType '"Bool",
                  include_field_stddev_value = _js2n__-prdslib.isType '"Bool",
                  limit = _js2n__-prdslib.isType 'Integer,
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  offset = _js2n__-prdslib.isType 'Integer,
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                  profile_table_level_only = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GEProfilingConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  catch_exceptions = _js2n__-prdslib.isType '"Bool",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  field_sample_values_limit = _js2n__-prdslib.isType 'Integer,
                  include_field_distinct_count = _js2n__-prdslib.isType '"Bool",
                  include_field_distinct_value_frequencies =
                    _js2n__-prdslib.isType '"Bool",
                  include_field_histogram = _js2n__-prdslib.isType '"Bool",
                  include_field_max_value = _js2n__-prdslib.isType '"Bool",
                  include_field_mean_value = _js2n__-prdslib.isType '"Bool",
                  include_field_median_value = _js2n__-prdslib.isType '"Bool",
                  include_field_min_value = _js2n__-prdslib.isType '"Bool",
                  include_field_null_count = _js2n__-prdslib.isType '"Bool",
                  include_field_quantiles = _js2n__-prdslib.isType '"Bool",
                  include_field_sample_values = _js2n__-prdslib.isType '"Bool",
                  include_field_stddev_value = _js2n__-prdslib.isType '"Bool",
                  limit = _js2n__-prdslib.isType 'Integer,
                  max_number_of_fields_to_profile =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  offset = _js2n__-prdslib.isType 'Integer,
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                  partition_datetime = _js2n__-prdslib.isType '"String",
                  partition_profiling_enabled = _js2n__-prdslib.isType '"Bool",
                  profile_external_tables = _js2n__-prdslib.isType '"Bool",
                  profile_if_updated_since_days =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  profile_nested_fields = _js2n__-prdslib.isType '"Bool",
                  profile_table_level_only = _js2n__-prdslib.isType '"Bool",
                  profile_table_row_count_estimate_only =
                    _js2n__-prdslib.isType '"Bool",
                  profile_table_row_limit = _js2n__-prdslib.isType 'Integer,
                  profile_table_size_limit = _js2n__-prdslib.isType 'Integer,
                  query_combiner_enabled = _js2n__-prdslib.isType '"Bool",
                  report_dropped_profiles = _js2n__-prdslib.isType '"Bool",
                  sample_size = _js2n__-prdslib.isType 'Integer,
                  tags_to_ignore_sampling =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  turn_off_expensive_profiling_metrics =
                    _js2n__-prdslib.isType '"Bool",
                  use_sampling = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GcsLineageProviderConfig!predicate"
        | doc "Any source that produces gcs lineage from/to Datasets should inherit this class."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore_non_path_spec_path = _js2n__-prdslib.isType '"Bool",
                  path_specs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PathSpec!predicate"
                        ],
                  strip_urls = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GenericConnectorConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "connector_name", "source_dataset", "source_platform" ],
              _js2n__-prdslib.records.record
                {
                  connector_name = _js2n__-prdslib.isType '"String",
                  source_dataset = _js2n__-prdslib.isType '"String",
                  source_platform = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitInfo!predicate"
        | doc "A reference to a Git repository, including a deploy key that can be used to clone it."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repo" ],
              _js2n__-prdslib.records.record
                {
                  branch = _js2n__-prdslib.isType '"String",
                  deploy_key = _js2n__-prdslib.isType '"String",
                  deploy_key_file = _js2n__-prdslib.isType '"String",
                  repo = _js2n__-prdslib.isType '"String",
                  repo_ssh_locator = _js2n__-prdslib.isType '"String",
                  url_template = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitReference!predicate"
        | doc "Reference to a hosted Git repository. Used to generate \"view source\" links."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repo" ],
              _js2n__-prdslib.records.record
                {
                  branch = _js2n__-prdslib.isType '"String",
                  repo = _js2n__-prdslib.isType '"String",
                  url_template = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GlueProfilingConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  column_count = _js2n__-prdslib.isType '"String",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  max = _js2n__-prdslib.isType '"String",
                  mean = _js2n__-prdslib.isType '"String",
                  median = _js2n__-prdslib.isType '"String",
                  min = _js2n__-prdslib.isType '"String",
                  null_count = _js2n__-prdslib.isType '"String",
                  null_proportion = _js2n__-prdslib.isType '"String",
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                  partition_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profile_table_level_only = _js2n__-prdslib.isType '"Bool",
                  row_count = _js2n__-prdslib.isType '"String",
                  stdev = _js2n__-prdslib.isType '"String",
                  unique_count = _js2n__-prdslib.isType '"String",
                  unique_proportion = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HMACKey!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "hmac_access_id", "hmac_access_secret" ],
              _js2n__-prdslib.records.record
                {
                  hmac_access_id = _js2n__-prdslib.isType '"String",
                  hmac_access_secret = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HiveMetastoreConfigMode!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "hive", "presto", "presto-on-hive", "trino" ]
            ],
      "_js2n__-:definitions/HostingEnvironment!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.enum [ "SELF_HOSTED", "ATLAS", "AWS_DOCUMENTDB" ],
      "_js2n__-:definitions/IcebergProfilingConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  include_field_max_value = _js2n__-prdslib.isType '"Bool",
                  include_field_min_value = _js2n__-prdslib.isType '"Bool",
                  include_field_null_count = _js2n__-prdslib.isType '"Bool",
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KafkaConsumerConnectionConfig!predicate"
        | doc "Configuration class for holding connectivity information for Kafka consumers"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bootstrap = _js2n__-prdslib.isType '"String",
                  client_timeout_seconds = _js2n__-prdslib.isType 'Integer,
                  consumer_config = _js2n__-prdslib.isType 'Record,
                  schema_registry_config = _js2n__-prdslib.isType 'Record,
                  schema_registry_url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LineageMode!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.enum [ "sql_based", "stl_scan_based", "mixed" ],
      "_js2n__-:definitions/LookerAPIConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "base_url", "client_id", "client_secret" ],
              _js2n__-prdslib.records.record
                {
                  base_url = _js2n__-prdslib.isType '"String",
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  max_retries = _js2n__-prdslib.isType 'Integer,
                  transport_options =
                    _js2n__-refsenv."_js2n__-:definitions/TransportOptionsConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LookerConnectionDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "default_db", "platform" ],
              _js2n__-prdslib.records.record
                {
                  default_db = _js2n__-prdslib.isType '"String",
                  default_schema = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                  platform_env = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LookerNamingPattern!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "pattern" ],
              _js2n__-prdslib.records.record
                { pattern = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LookerViewNamingPattern!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "pattern" ],
              _js2n__-prdslib.records.record
                { pattern = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ModeAPIConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max_attempts = _js2n__-prdslib.isType 'Integer,
                  max_retry_interval =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"Number"
                        ],
                  retry_backoff_multiplier =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"Number"
                        ],
                  timeout = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NifiAuthType!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.enum
            [
              "NO_AUTH",
              "SINGLE_USER",
              "CLIENT_CERT",
              "KERBEROS",
              "BASIC_AUTH"
            ],
      "_js2n__-:definitions/OAuthConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "authority_url", "client_id", "provider", "scopes" ],
              _js2n__-prdslib.records.record
                {
                  authority_url = _js2n__-prdslib.isType '"String",
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  encoded_oauth_private_key = _js2n__-prdslib.isType '"String",
                  encoded_oauth_public_key = _js2n__-prdslib.isType '"String",
                  provider =
                    _js2n__-refsenv."_js2n__-:definitions/OAuthIdentityProvider!predicate",
                  scopes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  use_certificate = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OAuthIdentityProvider!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.enum [ "microsoft", "okta" ],
      "_js2n__-:definitions/OperationConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  lower_freq_profile_enabled = _js2n__-prdslib.isType '"Bool",
                  profile_date_of_month = _js2n__-prdslib.isType 'Integer,
                  profile_day_of_week = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OwnershipMapping!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  create_corp_user = _js2n__-prdslib.isType '"Bool",
                  dataset_configured_by_as_owner =
                    _js2n__-prdslib.isType '"Bool",
                  owner_criteria =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  remove_email_suffix = _js2n__-prdslib.isType '"Bool",
                  use_powerbi_email = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PathSpec!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "include" ],
              _js2n__-prdslib.records.record
                {
                  allow_double_stars = _js2n__-prdslib.isType '"Bool",
                  autodetect_partitions = _js2n__-prdslib.isType '"Bool",
                  default_extension = _js2n__-prdslib.isType '"String",
                  enable_compression = _js2n__-prdslib.isType '"Bool",
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  file_types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  include = _js2n__-prdslib.isType '"String",
                  include_hidden_folders = _js2n__-prdslib.isType '"Bool",
                  sample_files = _js2n__-prdslib.isType '"Bool",
                  table_name = _js2n__-prdslib.isType '"String",
                  traversal_method =
                    _js2n__-refsenv."_js2n__-:definitions/FolderTraversalMethod!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PermissionIngestionConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enable_workbooks = _js2n__-prdslib.isType '"Bool",
                  group_name_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PlatformDetail!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  database = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PowerBiProfilingConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { enabled = _js2n__-prdslib.isType '"Bool", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ProfileConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  include_field_distinct_count = _js2n__-prdslib.isType '"Bool",
                  include_field_distinct_value_frequencies =
                    _js2n__-prdslib.isType '"Bool",
                  include_field_histogram = _js2n__-prdslib.isType '"Bool",
                  include_field_max_value = _js2n__-prdslib.isType '"Bool",
                  include_field_mean_value = _js2n__-prdslib.isType '"Bool",
                  include_field_min_value = _js2n__-prdslib.isType '"Bool",
                  include_field_null_count = _js2n__-prdslib.isType '"Bool",
                  include_field_quantiles = _js2n__-prdslib.isType '"Bool",
                  include_field_sample_values = _js2n__-prdslib.isType '"Bool",
                  include_field_stddev_value = _js2n__-prdslib.isType '"Bool",
                  limit = _js2n__-prdslib.isType 'Integer,
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  offset = _js2n__-prdslib.isType 'Integer,
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                  profile_table_level_only = _js2n__-prdslib.isType '"Bool",
                  query_timeout = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ProvidedConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "path_key", "provider", "value" ],
              _js2n__-prdslib.records.record
                {
                  path_key = _js2n__-prdslib.isType '"String",
                  provider = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/S3!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aws_config =
                    _js2n__-refsenv."_js2n__-:definitions/AwsConnectionConfig!predicate",
                  use_s3_bucket_tags = _js2n__-prdslib.isType '"Bool",
                  use_s3_object_tags = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/S3LineageProviderConfig!predicate"
        | doc "Any source that produces s3 lineage from/to Datasets should inherit this class."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore_non_path_spec_path = _js2n__-prdslib.isType '"Bool",
                  path_specs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PathSpec!predicate"
                        ],
                  strip_urls = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SQLAlchemyConnectionConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host_port", "scheme" ],
              _js2n__-prdslib.records.record
                {
                  database = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  scheme = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SalesforceAuthType!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.enum
            [ "USERNAME_PASSWORD", "DIRECT_ACCESS_TOKEN", "JSON_WEB_TOKEN" ],
      "_js2n__-:definitions/SalesforceProfilingConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SnowflakeDestinationConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "account_id", "database", "log_schema" ],
              _js2n__-prdslib.records.record
                {
                  account_id = _js2n__-prdslib.isType '"String",
                  authentication_type = _js2n__-prdslib.isType '"String",
                  connect_args = _js2n__-prdslib.isType 'Record,
                  database = _js2n__-prdslib.isType '"String",
                  log_schema = _js2n__-prdslib.isType '"String",
                  oauth_config =
                    _js2n__-refsenv."_js2n__-:definitions/OAuthConfiguration!predicate",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  private_key = _js2n__-prdslib.isType '"String",
                  private_key_password = _js2n__-prdslib.isType '"String",
                  private_key_path = _js2n__-prdslib.isType '"String",
                  role = _js2n__-prdslib.isType '"String",
                  scheme = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  warehouse = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SnowflakeShareConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "consumers", "database" ],
              _js2n__-prdslib.records.record
                {
                  consumers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DatabaseId!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  database = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SoftDeletedEntitiesCleanupConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  batch_size = _js2n__-prdslib.isType 'Integer,
                  delay = _js2n__-prdslib.isType '"Number",
                  entity_types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  limit_entities_delete = _js2n__-prdslib.isType 'Integer,
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  platform = _js2n__-prdslib.isType '"String",
                  query = _js2n__-prdslib.isType '"String",
                  retention_days = _js2n__-prdslib.isType 'Integer,
                  runtime_limit_seconds = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StatefulIngestionConfig!predicate"
        | doc "Basic Stateful Ingestion Specific Configuration for any source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { enabled = _js2n__-prdslib.isType '"Bool", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate"
        | doc "Base specialized config for Stateful Ingestion with stale metadata removal capability."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  remove_stale_metadata = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TableauLineageOverrides!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  database_override_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  platform_override_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TagOption!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "with_lineage", "without_lineage", "skip" ]
            ],
      "_js2n__-:definitions/TransportOptionsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "headers", "timeout" ],
              _js2n__-prdslib.records.record
                {
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  timeout = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/URIReplacePattern!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "match", "replace" ],
              _js2n__-prdslib.records.record
                {
                  "match" = _js2n__-prdslib.isType '"String",
                  replace = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UnityCatalogAnalyzeProfilerConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  call_analyze = _js2n__-prdslib.isType '"Bool",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  max_wait_secs = _js2n__-prdslib.isType 'Integer,
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "analyze" ]
                        ],
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                  pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profile_table_level_only = _js2n__-prdslib.isType '"Bool",
                  warehouse_id = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UnityCatalogGEProfilerConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  catch_exceptions = _js2n__-prdslib.isType '"Bool",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  field_sample_values_limit = _js2n__-prdslib.isType 'Integer,
                  include_field_distinct_count = _js2n__-prdslib.isType '"Bool",
                  include_field_distinct_value_frequencies =
                    _js2n__-prdslib.isType '"Bool",
                  include_field_histogram = _js2n__-prdslib.isType '"Bool",
                  include_field_max_value = _js2n__-prdslib.isType '"Bool",
                  include_field_mean_value = _js2n__-prdslib.isType '"Bool",
                  include_field_median_value = _js2n__-prdslib.isType '"Bool",
                  include_field_min_value = _js2n__-prdslib.isType '"Bool",
                  include_field_null_count = _js2n__-prdslib.isType '"Bool",
                  include_field_quantiles = _js2n__-prdslib.isType '"Bool",
                  include_field_sample_values = _js2n__-prdslib.isType '"Bool",
                  include_field_stddev_value = _js2n__-prdslib.isType '"Bool",
                  limit = _js2n__-prdslib.isType 'Integer,
                  max_number_of_fields_to_profile =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  max_wait_secs = _js2n__-prdslib.isType 'Integer,
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ge" ]
                        ],
                  offset = _js2n__-prdslib.isType 'Integer,
                  operation_config =
                    _js2n__-refsenv."_js2n__-:definitions/OperationConfig!predicate",
                  partition_datetime = _js2n__-prdslib.isType '"String",
                  partition_profiling_enabled = _js2n__-prdslib.isType '"Bool",
                  pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profile_external_tables = _js2n__-prdslib.isType '"Bool",
                  profile_if_updated_since_days =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  profile_nested_fields = _js2n__-prdslib.isType '"Bool",
                  profile_table_level_only = _js2n__-prdslib.isType '"Bool",
                  profile_table_row_count_estimate_only =
                    _js2n__-prdslib.isType '"Bool",
                  profile_table_row_limit = _js2n__-prdslib.isType 'Integer,
                  profile_table_size_limit = _js2n__-prdslib.isType 'Integer,
                  query_combiner_enabled = _js2n__-prdslib.isType '"Bool",
                  report_dropped_profiles = _js2n__-prdslib.isType '"Bool",
                  sample_size = _js2n__-prdslib.isType 'Integer,
                  tags_to_ignore_sampling =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  turn_off_expensive_profiling_metrics =
                    _js2n__-prdslib.isType '"Bool",
                  use_sampling = _js2n__-prdslib.isType '"Bool",
                  warehouse_id = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/abs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/abs_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "abs" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/abs_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path_specs" ],
              _js2n__-prdslib.records.record
                {
                  add_partition_columns_to_schema =
                    _js2n__-prdslib.isType '"Bool",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/AzureConnectionConfig!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  max_rows = _js2n__-prdslib.isType 'Integer,
                  number_of_files_to_sample = _js2n__-prdslib.isType 'Integer,
                  path_specs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PathSpec!predicate"
                        ],
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/DataLakeProfilerConfig!predicate",
                  spark_config = _js2n__-prdslib.isType 'Record,
                  spark_driver_memory = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  use_abs_blob_properties = _js2n__-prdslib.isType '"Bool",
                  use_abs_blob_tags = _js2n__-prdslib.isType '"Bool",
                  use_abs_container_properties = _js2n__-prdslib.isType '"Bool",
                  verify_ssl =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/athena!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/athena_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "athena" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/athena_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "aws_region", "query_result_location", "work_group" ],
              _js2n__-prdslib.records.record
                {
                  aws_region = _js2n__-prdslib.isType '"String",
                  aws_role_arn = _js2n__-prdslib.isType '"String",
                  aws_role_assumption_duration =
                    _js2n__-prdslib.isType 'Integer,
                  catalog_name = _js2n__-prdslib.isType '"String",
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  extract_partitions = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/AthenaProfilingConfig!predicate",
                  query_result_location = _js2n__-prdslib.isType '"String",
                  s3_staging_dir = _js2n__-prdslib.isType '"String",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  work_group = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/azure-ad!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/azure-ad_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "azure-ad" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/azure-ad_config!predicate"
        | doc "Config to create a token and connect to Azure AD instance"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "authority",
                  "client_id",
                  "client_secret",
                  "tenant_id",
                  "token_url"
                ],
              _js2n__-prdslib.records.record
                {
                  authority = _js2n__-prdslib.isType '"String",
                  azure_ad_response_to_groupname_attr =
                    _js2n__-prdslib.isType '"String",
                  azure_ad_response_to_groupname_regex =
                    _js2n__-prdslib.isType '"String",
                  azure_ad_response_to_username_attr =
                    _js2n__-prdslib.isType '"String",
                  azure_ad_response_to_username_regex =
                    _js2n__-prdslib.isType '"String",
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  filtered_tracking = _js2n__-prdslib.isType '"Bool",
                  graph_url = _js2n__-prdslib.isType '"String",
                  groups_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  ingest_group_membership = _js2n__-prdslib.isType '"Bool",
                  ingest_groups = _js2n__-prdslib.isType '"Bool",
                  ingest_groups_users = _js2n__-prdslib.isType '"Bool",
                  ingest_users = _js2n__-prdslib.isType '"Bool",
                  mask_group_id = _js2n__-prdslib.isType '"Bool",
                  mask_user_id = _js2n__-prdslib.isType '"Bool",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  redirect = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  tenant_id = _js2n__-prdslib.isType '"String",
                  token_url = _js2n__-prdslib.isType '"String",
                  users_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/bigquery!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/bigquery_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "bigquery" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/bigquery_config!predicate"
        | doc m%"
          Any source that produces gcs lineage from/to Datasets should inherit this class.
          This is needeed to group all lineage related configs under `gcs_lineage_config` config property.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bigquery_audit_metadata_datasets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  capture_dataset_label_as_tag =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  capture_table_label_as_tag =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  capture_view_label_as_tag =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  column_limit = _js2n__-prdslib.isType 'Integer,
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  credential =
                    _js2n__-refsenv."_js2n__-:definitions/BigQueryCredential!predicate",
                  dataset_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  debug_include_full_payloads = _js2n__-prdslib.isType '"Bool",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  enable_legacy_sharded_table_support =
                    _js2n__-prdslib.isType '"Bool",
                  enable_stateful_lineage_ingestion =
                    _js2n__-prdslib.isType '"Bool",
                  enable_stateful_profiling = _js2n__-prdslib.isType '"Bool",
                  enable_stateful_usage_ingestion =
                    _js2n__-prdslib.isType '"Bool",
                  end_time = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  exclude_empty_projects = _js2n__-prdslib.isType '"Bool",
                  extra_client_options = _js2n__-prdslib.isType 'Record,
                  extract_column_lineage = _js2n__-prdslib.isType '"Bool",
                  extract_lineage_from_catalog = _js2n__-prdslib.isType '"Bool",
                  extract_policy_tags_from_catalog =
                    _js2n__-prdslib.isType '"Bool",
                  gcs_lineage_config =
                    _js2n__-refsenv."_js2n__-:definitions/GcsLineageProviderConfig!predicate",
                  include_column_lineage_with_gcs =
                    _js2n__-prdslib.isType '"Bool",
                  include_data_platform_instance =
                    _js2n__-prdslib.isType '"Bool",
                  include_external_url = _js2n__-prdslib.isType '"Bool",
                  include_schema_metadata = _js2n__-prdslib.isType '"Bool",
                  include_table_constraints = _js2n__-prdslib.isType '"Bool",
                  include_table_lineage = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_table_snapshots = _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_usage_statistics = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  lineage_parse_view_ddl = _js2n__-prdslib.isType '"Bool",
                  lineage_sql_parser_use_raw_names =
                    _js2n__-prdslib.isType '"Bool",
                  lineage_use_sql_parser = _js2n__-prdslib.isType '"Bool",
                  log_page_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  match_fully_qualified_names = _js2n__-prdslib.isType '"Bool",
                  max_query_duration = _js2n__-prdslib.isType '"Number",
                  max_threads_dataset_parallelism =
                    _js2n__-prdslib.isType 'Integer,
                  number_of_datasets_process_in_batch_if_profiling_enabled =
                    _js2n__-prdslib.isType 'Integer,
                  options = _js2n__-prdslib.isType 'Record,
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  project_id_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  project_ids =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  project_labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  project_on_behalf = _js2n__-prdslib.isType '"String",
                  rate_limit = _js2n__-prdslib.isType '"Bool",
                  region_qualifiers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  requests_per_min = _js2n__-prdslib.isType 'Integer,
                  schema_resolution_batch_size =
                    _js2n__-prdslib.isType 'Integer,
                  scheme = _js2n__-prdslib.isType '"String",
                  sharded_table_pattern = _js2n__-prdslib.isType '"String",
                  start_time = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  table_snapshot_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  temp_table_dataset_prefix = _js2n__-prdslib.isType '"String",
                  upstream_lineage_in_report = _js2n__-prdslib.isType '"Bool",
                  usage =
                    _js2n__-refsenv."_js2n__-:definitions/BigQueryUsageConfig!predicate",
                  use_date_sharded_audit_log_tables =
                    _js2n__-prdslib.isType '"Bool",
                  use_exported_bigquery_audit_metadata =
                    _js2n__-prdslib.isType '"Bool",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  use_queries_v2 = _js2n__-prdslib.isType '"Bool",
                  use_tables_list_query_v2 = _js2n__-prdslib.isType '"Bool",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cassandra!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/cassandra_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "cassandra" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cassandra_config!predicate"
        | doc "Configuration for connecting to a Cassandra or DataStax Astra DB source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cloud_config =
                    _js2n__-refsenv."_js2n__-:definitions/CassandraCloudConfig!predicate",
                  contact_point = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  keyspace_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingBaseConfig!predicate",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/clickhouse!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/clickhouse_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "clickhouse" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/clickhouse-usage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/clickhouse-usage_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "clickhouse-usage" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/clickhouse-usage_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "email_domain" ],
              _js2n__-prdslib.records.record
                {
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  email_domain = _js2n__-prdslib.isType '"String",
                  end_time = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  format_sql_queries = _js2n__-prdslib.isType '"Bool",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_materialized_views = _js2n__-prdslib.isType '"Bool",
                  include_operational_stats = _js2n__-prdslib.isType '"Bool",
                  include_read_operational_stats =
                    _js2n__-prdslib.isType '"Bool",
                  include_table_lineage = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_top_n_queries = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  platform_instance_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  protocol = _js2n__-prdslib.isType '"String",
                  query_log_table = _js2n__-prdslib.isType '"String",
                  secure = _js2n__-prdslib.isType '"Bool",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  start_time = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  top_n_queries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  uri_opts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  user_email_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/clickhouse_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  end_time = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_materialized_views = _js2n__-prdslib.isType '"Bool",
                  include_table_lineage = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  platform_instance_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  protocol = _js2n__-prdslib.isType '"String",
                  secure = _js2n__-prdslib.isType '"Bool",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  start_time = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  uri_opts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cockroachdb!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/cockroachdb_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "cockroachdb" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cockroachdb_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host_port" ],
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  initial_database = _js2n__-prdslib.isType '"String",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/console_sink!predicate" =
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
                          _js2n__-prdslib.enum [ "console" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/csv-enricher!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/csv-enricher_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "csv-enricher" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/csv-enricher_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "filename" ],
              _js2n__-prdslib.records.record
                {
                  array_delimiter = _js2n__-prdslib.isType '"String",
                  delimiter = _js2n__-prdslib.isType '"String",
                  filename = _js2n__-prdslib.isType '"String",
                  write_semantics = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/datahub!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/datahub_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "datahub" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/datahub-business-glossary!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/datahub-business-glossary_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "datahub-business-glossary" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/datahub-business-glossary_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "file" ],
              _js2n__-prdslib.records.record
                {
                  enable_auto_id = _js2n__-prdslib.isType '"Bool",
                  file =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/datahub-gc!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/datahub-gc_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "datahub-gc" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/datahub-gc_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cleanup_expired_tokens = _js2n__-prdslib.isType '"Bool",
                  dataprocess_cleanup =
                    _js2n__-refsenv."_js2n__-:definitions/DataProcessCleanupConfig!predicate",
                  dry_run = _js2n__-prdslib.isType '"Bool",
                  execution_request_cleanup =
                    _js2n__-refsenv."_js2n__-:definitions/DatahubExecutionRequestCleanupConfig!predicate",
                  soft_deleted_entities_cleanup =
                    _js2n__-refsenv."_js2n__-:definitions/SoftDeletedEntitiesCleanupConfig!predicate",
                  truncate_index_older_than_days =
                    _js2n__-prdslib.isType 'Integer,
                  truncate_indices = _js2n__-prdslib.isType '"Bool",
                  truncation_sleep_between_seconds =
                    _js2n__-prdslib.isType 'Integer,
                  truncation_watch_until = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/datahub-lineage-file!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/datahub-lineage-file_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "datahub-lineage-file" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/datahub-lineage-file_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "file" ],
              _js2n__-prdslib.records.record
                {
                  file = _js2n__-prdslib.isType '"String",
                  preserve_upstream = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/datahub_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  commit_state_interval = _js2n__-prdslib.isType 'Integer,
                  commit_with_parse_errors = _js2n__-prdslib.isType '"Bool",
                  database_connection =
                    _js2n__-refsenv."_js2n__-:definitions/SQLAlchemyConnectionConfig!predicate",
                  database_query_batch_size = _js2n__-prdslib.isType 'Integer,
                  database_table_name = _js2n__-prdslib.isType '"String",
                  exclude_aspects =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  include_all_versions = _js2n__-prdslib.isType '"Bool",
                  include_soft_deleted_entities =
                    _js2n__-prdslib.isType '"Bool",
                  kafka_connection =
                    _js2n__-refsenv."_js2n__-:definitions/KafkaConsumerConnectionConfig!predicate",
                  kafka_topic_name = _js2n__-prdslib.isType '"String",
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  pull_from_datahub_api = _js2n__-prdslib.isType '"Bool",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulIngestionConfig!predicate",
                  urn_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/datahub_kafka_sink!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/datahub_kafka_sink_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "datahub-kafka" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/datahub_kafka_sink_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "connection" ],
              _js2n__-prdslib.records.record
                {
                  connection =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "bootstrap", "schema_registry_url" ],
                          _js2n__-prdslib.records.record
                            {
                              bootstrap = _js2n__-prdslib.isType '"String",
                              producer_config = _js2n__-prdslib.isType 'Record,
                              schema_registry_config =
                                _js2n__-prdslib.isType 'Record,
                              schema_registry_url =
                                _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  topic_routes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              MetadataChangeEvent =
                                _js2n__-prdslib.isType '"String",
                              MetadataChangeProposal =
                                _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/datahub_rest_sink!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/datahub_rest_sink_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "datahub-rest" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/datahub_rest_sink_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "server" ],
              _js2n__-prdslib.records.record
                {
                  ca_certificate_path = _js2n__-prdslib.isType '"String",
                  client_certificate_path = _js2n__-prdslib.isType '"String",
                  disable_ssl_verification = _js2n__-prdslib.isType '"Bool",
                  extra_headers = _js2n__-prdslib.isType '"String",
                  max_threads = _js2n__-prdslib.isType '"Number",
                  retry_status_codes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"Number")
                        ],
                  server = _js2n__-prdslib.isType '"String",
                  timeout_sec = _js2n__-prdslib.isType '"Number",
                  token = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dbt!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/dbt_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "dbt" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dbt-cloud!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/dbt-cloud_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "dbt-cloud" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dbt-cloud_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "account_id",
                  "job_id",
                  "project_id",
                  "target_platform",
                  "token"
                ],
              _js2n__-prdslib.records.record
                {
                  access_url = _js2n__-prdslib.isType '"String",
                  account_id = _js2n__-prdslib.isType 'Integer,
                  column_meta_mapping = _js2n__-prdslib.isType 'Record,
                  convert_column_urns_to_lowercase =
                    _js2n__-prdslib.isType '"Bool",
                  enable_meta_mapping = _js2n__-prdslib.isType '"Bool",
                  enable_owner_extraction = _js2n__-prdslib.isType '"Bool",
                  enable_query_tag_mapping = _js2n__-prdslib.isType '"Bool",
                  entities_enabled =
                    _js2n__-refsenv."_js2n__-:definitions/DBTEntitiesEnabled!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  include_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_compiled_code = _js2n__-prdslib.isType '"Bool",
                  include_env_in_assertion_guid =
                    _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  infer_dbt_schemas = _js2n__-prdslib.isType '"Bool",
                  job_id = _js2n__-prdslib.isType 'Integer,
                  meta_mapping = _js2n__-prdslib.isType 'Record,
                  metadata_endpoint = _js2n__-prdslib.isType '"String",
                  node_name_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  owner_extraction_pattern = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  prefer_sql_parser_lineage = _js2n__-prdslib.isType '"Bool",
                  project_id = _js2n__-prdslib.isType 'Integer,
                  query_tag_mapping = _js2n__-prdslib.isType 'Record,
                  run_id = _js2n__-prdslib.isType 'Integer,
                  skip_sources_in_lineage = _js2n__-prdslib.isType '"Bool",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  strip_user_ids_from_email = _js2n__-prdslib.isType '"Bool",
                  tag_prefix = _js2n__-prdslib.isType '"String",
                  target_platform = _js2n__-prdslib.isType '"String",
                  target_platform_instance = _js2n__-prdslib.isType '"String",
                  test_warnings_are_errors = _js2n__-prdslib.isType '"Bool",
                  token = _js2n__-prdslib.isType '"String",
                  use_identifiers = _js2n__-prdslib.isType '"Bool",
                  write_semantics = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dbt_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "catalog_path", "manifest_path", "target_platform" ],
              _js2n__-prdslib.records.record
                {
                  aws_connection =
                    _js2n__-refsenv."_js2n__-:definitions/AwsConnectionConfig!predicate",
                  catalog_path = _js2n__-prdslib.isType '"String",
                  column_meta_mapping = _js2n__-prdslib.isType 'Record,
                  convert_column_urns_to_lowercase =
                    _js2n__-prdslib.isType '"Bool",
                  enable_meta_mapping = _js2n__-prdslib.isType '"Bool",
                  enable_owner_extraction = _js2n__-prdslib.isType '"Bool",
                  enable_query_tag_mapping = _js2n__-prdslib.isType '"Bool",
                  entities_enabled =
                    _js2n__-refsenv."_js2n__-:definitions/DBTEntitiesEnabled!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  git_info =
                    _js2n__-refsenv."_js2n__-:definitions/GitReference!predicate",
                  include_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_compiled_code = _js2n__-prdslib.isType '"Bool",
                  include_env_in_assertion_guid =
                    _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  infer_dbt_schemas = _js2n__-prdslib.isType '"Bool",
                  manifest_path = _js2n__-prdslib.isType '"String",
                  meta_mapping = _js2n__-prdslib.isType 'Record,
                  node_name_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  only_include_if_in_catalog = _js2n__-prdslib.isType '"Bool",
                  owner_extraction_pattern = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  prefer_sql_parser_lineage = _js2n__-prdslib.isType '"Bool",
                  query_tag_mapping = _js2n__-prdslib.isType 'Record,
                  run_results_paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  skip_sources_in_lineage = _js2n__-prdslib.isType '"Bool",
                  sources_path = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  strip_user_ids_from_email = _js2n__-prdslib.isType '"Bool",
                  tag_prefix = _js2n__-prdslib.isType '"String",
                  target_platform = _js2n__-prdslib.isType '"String",
                  target_platform_instance = _js2n__-prdslib.isType '"String",
                  test_warnings_are_errors = _js2n__-prdslib.isType '"Bool",
                  use_identifiers = _js2n__-prdslib.isType '"Bool",
                  write_semantics = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/delta-lake!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/delta-lake_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "delta-lake" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/delta-lake_config!predicate"
        | doc "Any source that connects to a platform should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "base_path" ],
              _js2n__-prdslib.records.record
                {
                  base_path = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  platform =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "delta-lake" ]
                        ],
                  platform_instance = _js2n__-prdslib.isType '"String",
                  relative_path = _js2n__-prdslib.isType '"String",
                  require_files = _js2n__-prdslib.isType '"Bool",
                  s3 = _js2n__-refsenv."_js2n__-:definitions/S3!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  version_history_lookback = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/demo-data!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/demo-data_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "demo-data" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/demo-data_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dremio!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/dremio_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "dremio" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dremio_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  authentication_method = _js2n__-prdslib.isType '"String",
                  dataset_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  disable_certificate_verification =
                    _js2n__-prdslib.isType '"Bool",
                  domain = _js2n__-prdslib.isType '"String",
                  dremio_cloud_project_id = _js2n__-prdslib.isType '"String",
                  dremio_cloud_region =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "US", "EU" ]
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  hostname = _js2n__-prdslib.isType '"String",
                  include_query_lineage = _js2n__-prdslib.isType '"Bool",
                  is_dremio_cloud = _js2n__-prdslib.isType '"Bool",
                  max_workers = _js2n__-prdslib.isType 'Integer,
                  password = _js2n__-prdslib.isType '"String",
                  path_to_certificates = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/ProfileConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  source_mappings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DremioSourceMapping!predicate"
                        ],
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  tls = _js2n__-prdslib.isType '"Bool",
                  usage =
                    _js2n__-refsenv."_js2n__-:definitions/BaseUsageConfig!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/druid!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/druid_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "druid" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/druid_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host_port" ],
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dynamodb!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/dynamodb_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "dynamodb" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dynamodb_config!predicate"
        | doc "Any source that is a primary producer of Dataset metadata should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aws_access_key_id = _js2n__-prdslib.isType '"String",
                  aws_advanced_config = _js2n__-prdslib.isType 'Record,
                  aws_endpoint_url = _js2n__-prdslib.isType '"String",
                  aws_profile = _js2n__-prdslib.isType '"String",
                  aws_proxy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  aws_region = _js2n__-prdslib.isType '"String",
                  aws_role =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-refsenv."_js2n__-:definitions/AwsAssumeRoleConfig!predicate"
                                  ])
                            ]
                        ],
                  aws_secret_access_key = _js2n__-prdslib.isType '"String",
                  aws_session_token = _js2n__-prdslib.isType '"String",
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  include_table_item =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType 'Record)
                              ])
                        ],
                  platform_instance = _js2n__-prdslib.isType '"String",
                  read_timeout = _js2n__-prdslib.isType '"Number",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/elasticsearch!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/elasticsearch_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "elasticsearch" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/elasticsearch_config!predicate"
        | doc "Any source that connects to a platform should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_key =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.always,
                          _js2n__-prdslib.isType '"String"
                        ],
                  ca_certs = _js2n__-prdslib.isType '"String",
                  client_cert = _js2n__-prdslib.isType '"String",
                  client_key = _js2n__-prdslib.isType '"String",
                  collapse_urns =
                    _js2n__-refsenv."_js2n__-:definitions/CollapseUrns!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  host = _js2n__-prdslib.isType '"String",
                  index_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  index_template_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  ingest_index_templates = _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/ElasticProfiling!predicate",
                  ssl_assert_fingerprint = _js2n__-prdslib.isType '"String",
                  ssl_assert_hostname = _js2n__-prdslib.isType '"Bool",
                  url_prefix = _js2n__-prdslib.isType '"String",
                  use_ssl = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  verify_certs = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/feast!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/feast_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "feast" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/feast_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  enable_owner_extraction = _js2n__-prdslib.isType '"Bool",
                  enable_tag_extraction = _js2n__-prdslib.isType '"Bool",
                  environment = _js2n__-prdslib.isType '"String",
                  fs_yaml_file = _js2n__-prdslib.isType '"String",
                  owner_mappings =
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
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/file!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/file_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "file" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/file_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  aspect = _js2n__-prdslib.isType '"String",
                  count_all_before_starting = _js2n__-prdslib.isType '"Bool",
                  file_extension = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  read_mode =
                    _js2n__-refsenv."_js2n__-:definitions/FileReadMode!predicate",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/file_sink!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/file_sink_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "file" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/file_sink_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "filename" ],
              _js2n__-prdslib.records.record
                { filename = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/fivetran!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/fivetran_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "fivetran" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/fivetran_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fivetran_log_config" ],
              _js2n__-prdslib.records.record
                {
                  connector_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  destination_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  destination_to_platform_instance =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/PlatformDetail!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  fivetran_log_config =
                    _js2n__-refsenv."_js2n__-:definitions/FivetranLogConfig!predicate",
                  history_sync_lookback_period =
                    _js2n__-prdslib.isType 'Integer,
                  include_column_lineage = _js2n__-prdslib.isType '"Bool",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  sources_to_platform_instance =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/PlatformDetail!predicate"
                        ],
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/gcs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/gcs_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "gcs" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/gcs_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "credential", "path_specs" ],
              _js2n__-prdslib.records.record
                {
                  credential =
                    _js2n__-refsenv."_js2n__-:definitions/HMACKey!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  max_rows = _js2n__-prdslib.isType 'Integer,
                  number_of_files_to_sample = _js2n__-prdslib.isType 'Integer,
                  path_specs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PathSpec!predicate"
                        ],
                  platform_instance = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/glue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/glue_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "glue" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/glue_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aws_access_key_id = _js2n__-prdslib.isType '"String",
                  aws_advanced_config = _js2n__-prdslib.isType 'Record,
                  aws_endpoint_url = _js2n__-prdslib.isType '"String",
                  aws_profile = _js2n__-prdslib.isType '"String",
                  aws_proxy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  aws_region = _js2n__-prdslib.isType '"String",
                  aws_role =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-refsenv."_js2n__-:definitions/AwsAssumeRoleConfig!predicate"
                                  ])
                            ]
                        ],
                  aws_secret_access_key = _js2n__-prdslib.isType '"String",
                  aws_session_token = _js2n__-prdslib.isType '"String",
                  catalog_id = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  emit_s3_lineage = _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  extract_delta_schema_from_parameters =
                    _js2n__-prdslib.isType '"Bool",
                  extract_owners = _js2n__-prdslib.isType '"Bool",
                  extract_transforms = _js2n__-prdslib.isType '"Bool",
                  glue_s3_lineage_direction = _js2n__-prdslib.isType '"String",
                  ignore_resource_links = _js2n__-prdslib.isType '"Bool",
                  ignore_unsupported_connectors =
                    _js2n__-prdslib.isType '"Bool",
                  include_column_lineage = _js2n__-prdslib.isType '"Bool",
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GlueProfilingConfig!predicate",
                  read_timeout = _js2n__-prdslib.isType '"Number",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_s3_bucket_tags = _js2n__-prdslib.isType '"Bool",
                  use_s3_object_tags = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/grafana!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/grafana_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "grafana" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/grafana_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "service_account_token" ],
              _js2n__-prdslib.records.record
                {
                  platform_instance = _js2n__-prdslib.isType '"String",
                  service_account_token = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulIngestionConfig!predicate",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/hana!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/hana_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "hana" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/hana_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/hive!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/hive_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "hive" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/hive-metastore!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/hive-metastore_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "hive-metastore" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/hive-metastore_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  enable_properties_merge = _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_catalog_name_in_ids = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  ingestion_job_id = _js2n__-prdslib.isType '"String",
                  metastore_db_name = _js2n__-prdslib.isType '"String",
                  mode =
                    _js2n__-refsenv."_js2n__-:definitions/HiveMetastoreConfigMode!predicate",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  schemas_where_clause_suffix =
                    _js2n__-prdslib.isType '"String",
                  simplify_nested_field_paths = _js2n__-prdslib.isType '"Bool",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  tables_where_clause_suffix = _js2n__-prdslib.isType '"String",
                  use_catalog_subtype = _js2n__-prdslib.isType '"Bool",
                  use_dataset_pascalcase_subtype =
                    _js2n__-prdslib.isType '"Bool",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  views_where_clause_suffix = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/hive_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host_port" ],
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/iceberg!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/iceberg_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "iceberg" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/iceberg_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "catalog" ],
              _js2n__-prdslib.records.record
                {
                  catalog =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType 'Record)
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  group_ownership_property = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  processing_threads = _js2n__-prdslib.isType 'Integer,
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/IcebergProfilingConfig!predicate",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  user_ownership_property = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/json-schema!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/json-schema_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "json-schema" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/json-schema_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path", "platform" ],
              _js2n__-prdslib.records.record
                {
                  env = _js2n__-prdslib.isType '"String",
                  path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.maxLength 65536,
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  uri_replace_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/URIReplacePattern!predicate",
                  use_id_as_base_uri = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/kafka!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/kafka_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "kafka" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kafka-connect!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/kafka-connect_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "kafka-connect" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kafka-connect_config!predicate"
        | doc "Any source that connects to a platform should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cluster_name = _js2n__-prdslib.isType '"String",
                  connect_to_platform_map =
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
                  connect_uri = _js2n__-prdslib.isType '"String",
                  connector_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  convert_lineage_urns_to_lowercase =
                    _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  generic_connectors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/GenericConnectorConfig!predicate"
                        ],
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  platform_instance_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  provided_configs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ProvidedConfig!predicate"
                        ],
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/kafka_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  connection =
                    _js2n__-refsenv."_js2n__-:definitions/KafkaConsumerConnectionConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  disable_topic_record_naming_strategy =
                    _js2n__-prdslib.isType '"Bool",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  enable_meta_mapping = _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  field_meta_mapping = _js2n__-prdslib.isType 'Record,
                  ignore_warnings_on_schema_type =
                    _js2n__-prdslib.isType '"Bool",
                  meta_mapping = _js2n__-prdslib.isType 'Record,
                  platform_instance = _js2n__-prdslib.isType '"String",
                  schema_registry_class = _js2n__-prdslib.isType '"String",
                  schema_tags_field = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  strip_user_ids_from_email = _js2n__-prdslib.isType '"Bool",
                  tag_prefix = _js2n__-prdslib.isType '"String",
                  topic_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  topic_subject_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ldap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/ldap_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ldap" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ldap_config!predicate"
        | doc "Config used by the LDAP Source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "base_dn", "ldap_password", "ldap_server", "ldap_user" ],
              _js2n__-prdslib.records.record
                {
                  attrs_list =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  base_dn = _js2n__-prdslib.isType '"String",
                  custom_props_list =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  drop_missing_first_last_name = _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  filter = _js2n__-prdslib.isType '"String",
                  group_attrs_map = _js2n__-prdslib.isType 'Record,
                  ldap_password = _js2n__-prdslib.isType '"String",
                  ldap_server = _js2n__-prdslib.isType '"String",
                  ldap_user = _js2n__-prdslib.isType '"String",
                  manager_filter_enabled = _js2n__-prdslib.isType '"Bool",
                  manager_pagination_enabled = _js2n__-prdslib.isType '"Bool",
                  page_size = _js2n__-prdslib.isType 'Integer,
                  pagination_enabled = _js2n__-prdslib.isType '"Bool",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  use_email_as_username = _js2n__-prdslib.isType '"Bool",
                  user_attrs_map = _js2n__-prdslib.isType 'Record,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/looker!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/looker_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "looker" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/looker_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "base_url", "client_id", "client_secret" ],
              _js2n__-prdslib.records.record
                {
                  base_url = _js2n__-prdslib.isType '"String",
                  chart_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  dashboard_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  emit_used_explores_only = _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  explore_browse_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/LookerNamingPattern!predicate",
                  explore_naming_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/LookerNamingPattern!predicate",
                  external_base_url = _js2n__-prdslib.isType '"String",
                  extract_column_level_lineage = _js2n__-prdslib.isType '"Bool",
                  extract_embed_urls = _js2n__-prdslib.isType '"Bool",
                  extract_independent_looks = _js2n__-prdslib.isType '"Bool",
                  extract_owners = _js2n__-prdslib.isType '"Bool",
                  extract_usage_history = _js2n__-prdslib.isType '"Bool",
                  extract_usage_history_for_interval =
                    _js2n__-prdslib.isType '"String",
                  folder_path_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  include_deleted = _js2n__-prdslib.isType '"Bool",
                  include_platform_instance_in_urns =
                    _js2n__-prdslib.isType '"Bool",
                  max_retries = _js2n__-prdslib.isType 'Integer,
                  max_threads = _js2n__-prdslib.isType 'Integer,
                  platform_instance = _js2n__-prdslib.isType '"String",
                  skip_personal_folders = _js2n__-prdslib.isType '"Bool",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  strip_user_ids_from_email = _js2n__-prdslib.isType '"Bool",
                  tag_measures_and_dimensions = _js2n__-prdslib.isType '"Bool",
                  transport_options =
                    _js2n__-refsenv."_js2n__-:definitions/TransportOptionsConfig!predicate",
                  view_browse_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/LookerViewNamingPattern!predicate",
                  view_naming_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/LookerViewNamingPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/lookml!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/lookml_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "lookml" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/lookml_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api =
                    _js2n__-refsenv."_js2n__-:definitions/LookerAPIConfig!predicate",
                  base_folder = _js2n__-prdslib.isType '"String",
                  connection_to_platform_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/LookerConnectionDefinition!predicate"
                        ],
                  emit_reachable_views_only = _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  explore_browse_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/LookerNamingPattern!predicate",
                  explore_naming_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/LookerNamingPattern!predicate",
                  extract_column_level_lineage = _js2n__-prdslib.isType '"Bool",
                  git_info =
                    _js2n__-refsenv."_js2n__-:definitions/GitInfo!predicate",
                  liquid_variable = _js2n__-prdslib.isType 'Record,
                  looker_environment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "prod", "dev" ]
                        ],
                  max_file_snippet_length = _js2n__-prdslib.isType 'Integer,
                  model_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  parse_table_names_from_sql = _js2n__-prdslib.isType '"Bool",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  populate_sql_logic_for_missing_descriptions =
                    _js2n__-prdslib.isType '"Bool",
                  process_isolation_for_sql_parsing =
                    _js2n__-prdslib.isType '"Bool",
                  process_refinements = _js2n__-prdslib.isType '"Bool",
                  project_dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/GitInfo!predicate"
                              ])
                        ],
                  project_name = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  tag_measures_and_dimensions = _js2n__-prdslib.isType '"Bool",
                  transport_options =
                    _js2n__-refsenv."_js2n__-:definitions/TransportOptionsConfig!predicate",
                  view_browse_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/LookerViewNamingPattern!predicate",
                  view_naming_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/LookerViewNamingPattern!predicate",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/mariadb!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/mariadb_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "mariadb" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/mariadb_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/metabase!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/metabase_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "metabase" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/metabase_config!predicate"
        | doc m%"
          Any non-Dataset source that produces lineage to Datasets should inherit this class.
          e.g. Orchestrators, Pipelines, BI Tools etc.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  connect_uri = _js2n__-prdslib.isType '"String",
                  database_alias_map = _js2n__-prdslib.isType 'Record,
                  database_id_to_instance_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  default_schema = _js2n__-prdslib.isType '"String",
                  display_uri = _js2n__-prdslib.isType '"String",
                  engine_platform_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  exclude_other_user_collections =
                    _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/mlflow!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/mlflow_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "mlflow" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/mlflow_config!predicate"
        | doc "Any source that produces dataset urns in a single environment should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  env = _js2n__-prdslib.isType '"String",
                  model_name_separator = _js2n__-prdslib.isType '"String",
                  registry_uri = _js2n__-prdslib.isType '"String",
                  tracking_uri = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/mode!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/mode_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "mode" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/mode_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "password", "token", "workspace" ],
              _js2n__-prdslib.records.record
                {
                  api_options =
                    _js2n__-refsenv."_js2n__-:definitions/ModeAPIConfig!predicate",
                  connect_uri = _js2n__-prdslib.isType '"String",
                  default_schema = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  exclude_restricted = _js2n__-prdslib.isType '"Bool",
                  ingest_embed_url = _js2n__-prdslib.isType '"Bool",
                  owner_username_instead_of_email =
                    _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  space_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  tag_measures_and_dimensions = _js2n__-prdslib.isType '"Bool",
                  token = _js2n__-prdslib.isType '"String",
                  workspace = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/mongodb!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/mongodb_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "mongodb" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/mongodb_config!predicate"
        | doc "Any source that connects to a platform should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  authMechanism = _js2n__-prdslib.isType '"String",
                  collection_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  connect_uri = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  enableSchemaInference = _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  hostingEnvironment =
                    _js2n__-refsenv."_js2n__-:definitions/HostingEnvironment!predicate",
                  maxDocumentSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  maxSchemaSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  schemaSamplingSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  useRandomSampling = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/mssql!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/mssql_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "mssql" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/mssql_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_descriptions = _js2n__-prdslib.isType '"Bool",
                  include_jobs = _js2n__-prdslib.isType '"Bool",
                  include_lineage = _js2n__-prdslib.isType '"Bool",
                  include_stored_procedures = _js2n__-prdslib.isType '"Bool",
                  include_stored_procedures_code =
                    _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  procedure_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  uri_args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  use_odbc = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/mysql!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/mysql_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "mysql" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/mysql_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/nifi!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/nifi_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "nifi" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nifi_config!predicate"
        | doc "Any source that produces dataset urns in a single environment should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "site_url" ],
              _js2n__-prdslib.records.record
                {
                  auth =
                    _js2n__-refsenv."_js2n__-:definitions/NifiAuthType!predicate",
                  ca_file =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  client_cert_file = _js2n__-prdslib.isType '"String",
                  client_key_file = _js2n__-prdslib.isType '"String",
                  client_key_password = _js2n__-prdslib.isType '"String",
                  emit_process_group_as_container =
                    _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  process_group_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  provenance_days = _js2n__-prdslib.isType 'Integer,
                  site_name = _js2n__-prdslib.isType '"String",
                  site_url = _js2n__-prdslib.isType '"String",
                  site_url_to_site_name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/okta!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/okta_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "okta" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/okta_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "okta_api_token", "okta_domain" ],
              _js2n__-prdslib.records.record
                {
                  delay_seconds =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  include_deprovisioned_users = _js2n__-prdslib.isType '"Bool",
                  include_suspended_users = _js2n__-prdslib.isType '"Bool",
                  ingest_group_membership = _js2n__-prdslib.isType '"Bool",
                  ingest_groups = _js2n__-prdslib.isType '"Bool",
                  ingest_users = _js2n__-prdslib.isType '"Bool",
                  mask_group_id = _js2n__-prdslib.isType '"Bool",
                  mask_user_id = _js2n__-prdslib.isType '"Bool",
                  okta_api_token = _js2n__-prdslib.isType '"String",
                  okta_domain = _js2n__-prdslib.isType '"String",
                  okta_groups_filter = _js2n__-prdslib.isType '"String",
                  okta_groups_search = _js2n__-prdslib.isType '"String",
                  okta_profile_to_group_name_attr =
                    _js2n__-prdslib.isType '"String",
                  okta_profile_to_group_name_regex =
                    _js2n__-prdslib.isType '"String",
                  okta_profile_to_username_attr =
                    _js2n__-prdslib.isType '"String",
                  okta_profile_to_username_regex =
                    _js2n__-prdslib.isType '"String",
                  okta_users_filter = _js2n__-prdslib.isType '"String",
                  okta_users_search = _js2n__-prdslib.isType '"String",
                  page_size = _js2n__-prdslib.isType 'Integer,
                  skip_users_without_a_group = _js2n__-prdslib.isType '"Bool",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/openapi!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/openapi_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "openapi" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/openapi_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "name", "swagger_file", "url" ],
              _js2n__-prdslib.records.record
                {
                  bearer_token = _js2n__-prdslib.isType '"String",
                  forced_examples = _js2n__-prdslib.isType 'Record,
                  get_token = _js2n__-prdslib.isType 'Record,
                  ignore_endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  proxies = _js2n__-prdslib.isType 'Record,
                  swagger_file = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/oracle!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/oracle_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "oracle" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/oracle_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host_port" ],
              _js2n__-prdslib.records.record
                {
                  add_database_name_to_urn = _js2n__-prdslib.isType '"Bool",
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  data_dictionary_mode = _js2n__-prdslib.isType '"String",
                  database = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  service_name = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/postgres!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/postgres_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "postgres" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/postgres_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host_port" ],
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  initial_database = _js2n__-prdslib.isType '"String",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/powerbi!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/powerbi_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "powerbi" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/powerbi-report-server!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/powerbi-report-server_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "powerbi-report-server" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/powerbi-report-server_config!predicate"
        | doc "Any source that produces dataset urns in a single environment should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "host_port",
                  "password",
                  "report_server_virtual_directory_name",
                  "report_virtual_directory_name",
                  "username"
                ],
              _js2n__-prdslib.records.record
                {
                  chart_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  extract_ownership = _js2n__-prdslib.isType '"Bool",
                  graphql_url = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  ownership_type = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  platform_name = _js2n__-prdslib.isType '"String",
                  platform_urn = _js2n__-prdslib.isType '"String",
                  report_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  report_server_virtual_directory_name =
                    _js2n__-prdslib.isType '"String",
                  report_virtual_directory_name =
                    _js2n__-prdslib.isType '"String",
                  server_alias = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  workstation_name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/powerbi_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "client_id", "client_secret", "tenant_id" ],
              _js2n__-prdslib.records.record
                {
                  admin_apis_only = _js2n__-prdslib.isType '"Bool",
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  convert_lineage_urns_to_lowercase =
                    _js2n__-prdslib.isType '"Bool",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  enable_advance_lineage_sql_construct =
                    _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  extract_app = _js2n__-prdslib.isType '"Bool",
                  extract_column_level_lineage = _js2n__-prdslib.isType '"Bool",
                  extract_dashboards = _js2n__-prdslib.isType '"Bool",
                  extract_dataset_schema = _js2n__-prdslib.isType '"Bool",
                  extract_datasets_to_containers =
                    _js2n__-prdslib.isType '"Bool",
                  extract_endorsements_to_tags = _js2n__-prdslib.isType '"Bool",
                  extract_independent_datasets = _js2n__-prdslib.isType '"Bool",
                  extract_lineage = _js2n__-prdslib.isType '"Bool",
                  extract_ownership = _js2n__-prdslib.isType '"Bool",
                  extract_reports = _js2n__-prdslib.isType '"Bool",
                  extract_workspaces_to_containers =
                    _js2n__-prdslib.isType '"Bool",
                  filter_dataset_endorsements =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  include_workspace_name_in_dataset_urn =
                    _js2n__-prdslib.isType '"Bool",
                  m_query_parse_timeout = _js2n__-prdslib.isType 'Integer,
                  modified_since = _js2n__-prdslib.isType '"String",
                  native_query_parsing = _js2n__-prdslib.isType '"Bool",
                  ownership =
                    _js2n__-refsenv."_js2n__-:definitions/OwnershipMapping!predicate",
                  patch_metadata = _js2n__-prdslib.isType '"Bool",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/PowerBiProfilingConfig!predicate",
                  scan_batch_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 100,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  scan_timeout = _js2n__-prdslib.isType 'Integer,
                  server_to_platform_instance =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/PlatformDetail!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/DataBricksPlatformDetail!predicate"
                              ])
                        ],
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  tenant_id = _js2n__-prdslib.isType '"String",
                  workspace_id_as_urn_part = _js2n__-prdslib.isType '"Bool",
                  workspace_id_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  workspace_type_filter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "Workspace",
                                    "PersonalGroup",
                                    "Personal",
                                    "AdminWorkspace",
                                    "AdminInsights"
                                  ]
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/preset!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/preset_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "preset" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/preset_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_key = _js2n__-prdslib.isType '"String",
                  api_secret = _js2n__-prdslib.isType '"String",
                  connect_uri = _js2n__-prdslib.isType '"String",
                  database_alias =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  display_uri = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  manager_uri = _js2n__-prdslib.isType '"String",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  provider = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/presto!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/presto_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "presto" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/presto-on-hive!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/presto-on-hive_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "presto-on-hive" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/presto-on-hive_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  enable_properties_merge = _js2n__-prdslib.isType '"Bool",
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_catalog_name_in_ids = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  ingestion_job_id = _js2n__-prdslib.isType '"String",
                  metastore_db_name = _js2n__-prdslib.isType '"String",
                  mode =
                    _js2n__-refsenv."_js2n__-:definitions/HiveMetastoreConfigMode!predicate",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  schemas_where_clause_suffix =
                    _js2n__-prdslib.isType '"String",
                  simplify_nested_field_paths = _js2n__-prdslib.isType '"Bool",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  tables_where_clause_suffix = _js2n__-prdslib.isType '"String",
                  use_catalog_subtype = _js2n__-prdslib.isType '"Bool",
                  use_dataset_pascalcase_subtype =
                    _js2n__-prdslib.isType '"Bool",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  views_where_clause_suffix = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/presto_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "database", "host_port" ],
              _js2n__-prdslib.records.record
                {
                  catalog_to_connector_details =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/ConnectorDetail!predicate"
                        ],
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  ingest_lineage_to_connectors = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  trino_as_primary = _js2n__-prdslib.isType '"Bool",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/pulsar!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/pulsar_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "pulsar" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/pulsar_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  exclude_individual_partitions =
                    _js2n__-prdslib.isType '"Bool",
                  issuer_url = _js2n__-prdslib.isType '"String",
                  namespace_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  oid_config = _js2n__-prdslib.isType 'Record,
                  platform_instance = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  tenant_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  tenants =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  timeout = _js2n__-prdslib.isType 'Integer,
                  token = _js2n__-prdslib.isType '"String",
                  topic_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  verify_ssl =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  web_service_url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/qlik-sense!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/qlik-sense_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "qlik-sense" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/qlik-sense_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "api_key", "tenant_hostname" ],
              _js2n__-prdslib.records.record
                {
                  api_key = _js2n__-prdslib.isType '"String",
                  data_connection_to_platform_instance =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/PlatformDetail!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  ingest_owner = _js2n__-prdslib.isType '"Bool",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  space_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulIngestionConfig!predicate",
                  tenant_hostname = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/redash!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/redash_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "redash" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/redash_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_key = _js2n__-prdslib.isType '"String",
                  api_page_limit = _js2n__-prdslib.isType 'Integer,
                  chart_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  connect_uri = _js2n__-prdslib.isType '"String",
                  dashboard_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  page_size = _js2n__-prdslib.isType 'Integer,
                  parallelism = _js2n__-prdslib.isType 'Integer,
                  parse_table_names_from_sql = _js2n__-prdslib.isType '"Bool",
                  skip_draft = _js2n__-prdslib.isType '"Bool",
                  sql_parser = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/redshift!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/redshift_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "redshift" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/redshift_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host_port" ],
              _js2n__-prdslib.records.record
                {
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  default_schema = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  email_domain = _js2n__-prdslib.isType '"String",
                  enable_stateful_lineage_ingestion =
                    _js2n__-prdslib.isType '"Bool",
                  enable_stateful_profiling = _js2n__-prdslib.isType '"Bool",
                  enable_stateful_usage_ingestion =
                    _js2n__-prdslib.isType '"Bool",
                  end_time = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  extra_client_options = _js2n__-prdslib.isType 'Record,
                  extract_column_level_lineage = _js2n__-prdslib.isType '"Bool",
                  format_sql_queries = _js2n__-prdslib.isType '"Bool",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_copy_lineage = _js2n__-prdslib.isType '"Bool",
                  include_operational_stats = _js2n__-prdslib.isType '"Bool",
                  include_read_operational_stats =
                    _js2n__-prdslib.isType '"Bool",
                  include_table_lineage = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_table_rename_lineage = _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_top_n_queries = _js2n__-prdslib.isType '"Bool",
                  include_unload_lineage = _js2n__-prdslib.isType '"Bool",
                  include_usage_statistics = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  is_serverless = _js2n__-prdslib.isType '"Bool",
                  lineage_v2_generate_queries = _js2n__-prdslib.isType '"Bool",
                  match_fully_qualified_names = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  patch_custom_properties = _js2n__-prdslib.isType '"Bool",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  platform_instance_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  resolve_temp_table_in_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  s3_lineage_config =
                    _js2n__-refsenv."_js2n__-:definitions/S3LineageProviderConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  skip_external_tables = _js2n__-prdslib.isType '"Bool",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  start_time = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_lineage_mode =
                    _js2n__-refsenv."_js2n__-:definitions/LineageMode!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  top_n_queries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  use_lineage_v2 = _js2n__-prdslib.isType '"Bool",
                  user_email_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/s3!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/s3_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "s3" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/s3_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path_specs" ],
              _js2n__-prdslib.records.record
                {
                  add_partition_columns_to_schema =
                    _js2n__-prdslib.isType '"Bool",
                  aws_config =
                    _js2n__-refsenv."_js2n__-:definitions/AwsConnectionConfig!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  generate_partition_aspects = _js2n__-prdslib.isType '"Bool",
                  max_rows = _js2n__-prdslib.isType 'Integer,
                  number_of_files_to_sample = _js2n__-prdslib.isType 'Integer,
                  path_specs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PathSpec!predicate"
                        ],
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_patterns =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/DataLakeProfilerConfig!predicate",
                  sort_schema_fields = _js2n__-prdslib.isType '"Bool",
                  spark_config = _js2n__-prdslib.isType 'Record,
                  spark_driver_memory = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  use_s3_bucket_tags = _js2n__-prdslib.isType '"Bool",
                  use_s3_content_type = _js2n__-prdslib.isType '"Bool",
                  use_s3_object_tags = _js2n__-prdslib.isType '"Bool",
                  verify_ssl =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sac!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/sac_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "sac" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/sac_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "client_id", "client_secret", "tenant_url", "token_url" ],
              _js2n__-prdslib.records.record
                {
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  connection_mapping =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/ConnectionMappingConfig!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  folder_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  ingest_applications = _js2n__-prdslib.isType '"Bool",
                  ingest_import_data_model_schema_metadata =
                    _js2n__-prdslib.isType '"Bool",
                  ingest_stories = _js2n__-prdslib.isType '"Bool",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  query_name_template = _js2n__-prdslib.isType '"String",
                  resource_id_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  resource_name_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  tenant_url = _js2n__-prdslib.isType '"String",
                  token_url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sagemaker!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/sagemaker_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "sagemaker" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/sagemaker_config!predicate"
        | doc m%"
          Common AWS credentials config.
          
          Currently used by:
              - Glue source
              - DynamoDB source
              - SageMaker source
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aws_access_key_id = _js2n__-prdslib.isType '"String",
                  aws_advanced_config = _js2n__-prdslib.isType 'Record,
                  aws_endpoint_url = _js2n__-prdslib.isType '"String",
                  aws_profile = _js2n__-prdslib.isType '"String",
                  aws_proxy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  aws_region = _js2n__-prdslib.isType '"String",
                  aws_role =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-refsenv."_js2n__-:definitions/AwsAssumeRoleConfig!predicate"
                                  ])
                            ]
                        ],
                  aws_secret_access_key = _js2n__-prdslib.isType '"String",
                  aws_session_token = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  extract_feature_groups = _js2n__-prdslib.isType '"Bool",
                  extract_jobs =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  extract_models = _js2n__-prdslib.isType '"Bool",
                  read_timeout = _js2n__-prdslib.isType '"Number",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/salesforce!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/salesforce_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "salesforce" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/salesforce_config!predicate"
        | doc "Any source that is a primary producer of Dataset metadata should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  access_token = _js2n__-prdslib.isType '"String",
                  api_version = _js2n__-prdslib.isType '"String",
                  auth =
                    _js2n__-refsenv."_js2n__-:definitions/SalesforceAuthType!predicate",
                  consumer_key = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  ingest_tags = _js2n__-prdslib.isType '"Bool",
                  instance_url = _js2n__-prdslib.isType '"String",
                  is_sandbox = _js2n__-prdslib.isType '"Bool",
                  object_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  password = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  private_key = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/SalesforceProfilingConfig!predicate",
                  security_token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sigma!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/sigma_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "sigma" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/sigma_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "client_id", "client_secret" ],
              _js2n__-prdslib.records.record
                {
                  api_url = _js2n__-prdslib.isType '"String",
                  chart_sources_platform_mapping =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/PlatformDetail!predicate"
                        ],
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  extract_lineage = _js2n__-prdslib.isType '"Bool",
                  ingest_owner = _js2n__-prdslib.isType '"Bool",
                  ingest_shared_entities = _js2n__-prdslib.isType '"Bool",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  workbook_lineage_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  workspace_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/slack!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/slack_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "slack" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/slack_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "bot_token" ],
              _js2n__-prdslib.records.record
                {
                  api_requests_per_min = _js2n__-prdslib.isType 'Integer,
                  bot_token = _js2n__-prdslib.isType '"String",
                  channel_min_members = _js2n__-prdslib.isType 'Integer,
                  channels_iteration_limit = _js2n__-prdslib.isType 'Integer,
                  enrich_user_metadata = _js2n__-prdslib.isType '"Bool",
                  ingest_public_channels = _js2n__-prdslib.isType '"Bool",
                  should_ingest_archived_channels =
                    _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/snowflake!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/snowflake_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "snowflake" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/snowflake_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "account_id" ],
              _js2n__-prdslib.records.record
                {
                  account_id = _js2n__-prdslib.isType '"String",
                  apply_view_usage_to_tables = _js2n__-prdslib.isType '"Bool",
                  authentication_type = _js2n__-prdslib.isType '"String",
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  connect_args = _js2n__-prdslib.isType 'Record,
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  email_as_user_identifier = _js2n__-prdslib.isType '"Bool",
                  email_domain = _js2n__-prdslib.isType '"String",
                  enable_stateful_lineage_ingestion =
                    _js2n__-prdslib.isType '"Bool",
                  enable_stateful_profiling = _js2n__-prdslib.isType '"Bool",
                  enable_stateful_usage_ingestion =
                    _js2n__-prdslib.isType '"Bool",
                  end_time = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  extract_tags =
                    _js2n__-refsenv."_js2n__-:definitions/TagOption!predicate",
                  format_sql_queries = _js2n__-prdslib.isType '"Bool",
                  ignore_start_time_lineage = _js2n__-prdslib.isType '"Bool",
                  include_assertion_results = _js2n__-prdslib.isType '"Bool",
                  include_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_external_url = _js2n__-prdslib.isType '"Bool",
                  include_foreign_keys = _js2n__-prdslib.isType '"Bool",
                  include_operational_stats = _js2n__-prdslib.isType '"Bool",
                  include_primary_keys = _js2n__-prdslib.isType '"Bool",
                  include_read_operational_stats =
                    _js2n__-prdslib.isType '"Bool",
                  include_table_lineage = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_technical_schema = _js2n__-prdslib.isType '"Bool",
                  include_top_n_queries = _js2n__-prdslib.isType '"Bool",
                  include_usage_stats = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_definitions = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  lazy_schema_resolver = _js2n__-prdslib.isType '"Bool",
                  match_fully_qualified_names = _js2n__-prdslib.isType '"Bool",
                  oauth_config =
                    _js2n__-refsenv."_js2n__-:definitions/OAuthConfiguration!predicate",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  private_key = _js2n__-prdslib.isType '"String",
                  private_key_password = _js2n__-prdslib.isType '"String",
                  private_key_path = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  role = _js2n__-prdslib.isType '"String",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  shares =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/SnowflakeShareConfig!predicate"
                        ],
                  start_time = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  tag_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  temporary_tables_pattern =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  top_n_queries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  upstream_lineage_in_report = _js2n__-prdslib.isType '"Bool",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  use_queries_v2 = _js2n__-prdslib.isType '"Bool",
                  user_email_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  username = _js2n__-prdslib.isType '"String",
                  validate_upstreams_against_patterns =
                    _js2n__-prdslib.isType '"Bool",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  warehouse = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sql-queries!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/sql-queries_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "sql-queries" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/sql-queries_config!predicate"
        | doc "Any source that connects to a platform should inherit this class"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "platform", "query_file" ],
              _js2n__-prdslib.records.record
                {
                  default_db = _js2n__-prdslib.isType '"String",
                  default_dialect = _js2n__-prdslib.isType '"String",
                  default_schema = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  query_file = _js2n__-prdslib.isType '"String",
                  usage =
                    _js2n__-refsenv."_js2n__-:definitions/BaseUsageConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sqlalchemy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/sqlalchemy_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "sqlalchemy" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/sqlalchemy_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "connect_uri", "platform" ],
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  connect_uri = _js2n__-prdslib.isType '"String",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  platform = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/starburst-trino-usage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/starburst-trino-usage_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "starburst-trino-usage" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/starburst-trino-usage_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "audit_catalog",
                  "audit_schema",
                  "database",
                  "email_domain",
                  "host_port"
                ],
              _js2n__-prdslib.records.record
                {
                  audit_catalog = _js2n__-prdslib.isType '"String",
                  audit_schema = _js2n__-prdslib.isType '"String",
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  catalog_to_connector_details =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/ConnectorDetail!predicate"
                        ],
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  email_domain = _js2n__-prdslib.isType '"String",
                  end_time = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  format_sql_queries = _js2n__-prdslib.isType '"Bool",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_operational_stats = _js2n__-prdslib.isType '"Bool",
                  include_read_operational_stats =
                    _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_top_n_queries = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  ingest_lineage_to_connectors = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  start_time = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  top_n_queries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  trino_as_primary = _js2n__-prdslib.isType '"Bool",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  user_email_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/superset!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/superset_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "superset" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/superset_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_key = _js2n__-prdslib.isType '"String",
                  api_secret = _js2n__-prdslib.isType '"String",
                  connect_uri = _js2n__-prdslib.isType '"String",
                  database_alias =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  display_uri = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  manager_uri = _js2n__-prdslib.isType '"String",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  provider = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tableau!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/tableau_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "tableau" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/tableau_config!predicate"
        | doc m%"
          Any non-Dataset source that produces lineage to Datasets should inherit this class.
          e.g. Orchestrators, Pipelines, BI Tools etc.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "connect_uri" ],
              _js2n__-prdslib.records.record
                {
                  add_site_container = _js2n__-prdslib.isType '"Bool",
                  connect_uri = _js2n__-prdslib.isType '"String",
                  database_hostname_to_platform_instance_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  default_schema_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  extract_column_level_lineage = _js2n__-prdslib.isType '"Bool",
                  extract_lineage_from_unsupported_custom_sql_queries =
                    _js2n__-prdslib.isType '"Bool",
                  extract_project_hierarchy = _js2n__-prdslib.isType '"Bool",
                  extract_usage_stats = _js2n__-prdslib.isType '"Bool",
                  fetch_size = _js2n__-prdslib.isType 'Integer,
                  force_extraction_of_lineage_from_custom_sql_queries =
                    _js2n__-prdslib.isType '"Bool",
                  ingest_embed_url = _js2n__-prdslib.isType '"Bool",
                  ingest_external_links_for_charts =
                    _js2n__-prdslib.isType '"Bool",
                  ingest_external_links_for_dashboards =
                    _js2n__-prdslib.isType '"Bool",
                  ingest_multiple_sites = _js2n__-prdslib.isType '"Bool",
                  ingest_owner = _js2n__-prdslib.isType '"Bool",
                  ingest_tables_external = _js2n__-prdslib.isType '"Bool",
                  ingest_tags = _js2n__-prdslib.isType '"Bool",
                  lineage_overrides =
                    _js2n__-refsenv."_js2n__-:definitions/TableauLineageOverrides!predicate",
                  max_retries = _js2n__-prdslib.isType 'Integer,
                  page_size = _js2n__-prdslib.isType 'Integer,
                  password = _js2n__-prdslib.isType '"String",
                  permission_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/PermissionIngestionConfig!predicate",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  platform_instance_map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  project_path_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  project_path_separator = _js2n__-prdslib.isType '"String",
                  project_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  projects =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  session_trust_env = _js2n__-prdslib.isType '"Bool",
                  site = _js2n__-prdslib.isType '"String",
                  site_name_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  sql_parsing_disable_schema_awareness =
                    _js2n__-prdslib.isType '"Bool",
                  ssl_verify =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  token_name = _js2n__-prdslib.isType '"String",
                  token_value = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  workbook_page_size = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/teradata!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/teradata_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "teradata" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/teradata_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host_port" ],
              _js2n__-prdslib.records.record
                {
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  database_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  databases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  default_db = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  end_time = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_lineage = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_usage_statistics = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  start_time = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  usage =
                    _js2n__-refsenv."_js2n__-:definitions/BaseUsageConfig!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  use_qvci = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/trino!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/trino_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "trino" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/trino_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "database", "host_port" ],
              _js2n__-prdslib.records.record
                {
                  catalog_to_connector_details =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/ConnectorDetail!predicate"
                        ],
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  ingest_lineage_to_connectors = _js2n__-prdslib.isType '"Bool",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  trino_as_primary = _js2n__-prdslib.isType '"Bool",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/unity-catalog!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/unity-catalog_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "unity-catalog" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/unity-catalog_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "token", "workspace_url" ],
              _js2n__-prdslib.records.record
                {
                  bucket_duration =
                    _js2n__-refsenv."_js2n__-:definitions/BucketDuration!predicate",
                  catalog_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  catalogs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  column_lineage_column_limit = _js2n__-prdslib.isType 'Integer,
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  delta_lake_options =
                    _js2n__-refsenv."_js2n__-:definitions/DeltaLakeDetails!predicate",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  emit_siblings = _js2n__-prdslib.isType '"Bool",
                  enable_stateful_profiling = _js2n__-prdslib.isType '"Bool",
                  end_time = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  format_sql_queries = _js2n__-prdslib.isType '"Bool",
                  include_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_external_lineage = _js2n__-prdslib.isType '"Bool",
                  include_hive_metastore = _js2n__-prdslib.isType '"Bool",
                  include_metastore = _js2n__-prdslib.isType '"Bool",
                  include_notebooks = _js2n__-prdslib.isType '"Bool",
                  include_operational_stats = _js2n__-prdslib.isType '"Bool",
                  include_ownership = _js2n__-prdslib.isType '"Bool",
                  include_read_operational_stats =
                    _js2n__-prdslib.isType '"Bool",
                  include_table_lineage = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_top_n_queries = _js2n__-prdslib.isType '"Bool",
                  include_usage_statistics = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  ingest_data_platform_instance_aspect =
                    _js2n__-prdslib.isType '"Bool",
                  notebook_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  options = _js2n__-prdslib.isType 'Record,
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/UnityCatalogGEProfilerConfig!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UnityCatalogAnalyzeProfilerConfig!predicate"
                        ],
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  start_time = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  token = _js2n__-prdslib.isType '"String",
                  top_n_queries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  user_email_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  warehouse_id = _js2n__-prdslib.isType '"String",
                  workspace_name = _js2n__-prdslib.isType '"String",
                  workspace_url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/vertica!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "type" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/vertica_config!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "vertica" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vertica_config!predicate"
        | doc "Base configuration class for stateful ingestion for source configs to inherit from."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host_port" ],
              _js2n__-prdslib.records.record
                {
                  classification =
                    _js2n__-refsenv."_js2n__-:definitions/ClassificationConfig!predicate",
                  convert_urns_to_lowercase = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  domain =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate"
                        ],
                  env = _js2n__-prdslib.isType '"String",
                  host_port = _js2n__-prdslib.isType '"String",
                  include_models = _js2n__-prdslib.isType '"Bool",
                  include_projection_lineage = _js2n__-prdslib.isType '"Bool",
                  include_projections = _js2n__-prdslib.isType '"Bool",
                  include_table_location_lineage =
                    _js2n__-prdslib.isType '"Bool",
                  include_tables = _js2n__-prdslib.isType '"Bool",
                  include_view_column_lineage = _js2n__-prdslib.isType '"Bool",
                  include_view_lineage = _js2n__-prdslib.isType '"Bool",
                  include_views = _js2n__-prdslib.isType '"Bool",
                  incremental_lineage = _js2n__-prdslib.isType '"Bool",
                  models_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  options = _js2n__-prdslib.isType 'Record,
                  password = _js2n__-prdslib.isType '"String",
                  platform_instance = _js2n__-prdslib.isType '"String",
                  profile_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  profiling =
                    _js2n__-refsenv."_js2n__-:definitions/GEProfilingConfig!predicate",
                  schema_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  sqlalchemy_uri = _js2n__-prdslib.isType '"String",
                  stateful_ingestion =
                    _js2n__-refsenv."_js2n__-:definitions/StatefulStaleMetadataRemovalConfig!predicate",
                  table_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                  use_file_backed_cache = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                  view_pattern =
                    _js2n__-refsenv."_js2n__-:definitions/AllowDenyPattern!predicate",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.required [ "source" ],
          _js2n__-prdslib.records.record
            {
              sink =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/datahub_kafka_sink!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/datahub_rest_sink!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/console_sink!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/file_sink!predicate"
                    ],
              source =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/trino!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/openapi!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/cassandra!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/ldap!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/hana!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/preset!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/file!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/postgres!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/feast!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/delta-lake!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/nifi!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/superset!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/bigquery!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/looker!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/grafana!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/abs!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/tableau!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/qlik-sense!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/sqlalchemy!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/datahub-lineage-file!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/kafka-connect!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/dynamodb!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/powerbi-report-server!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/kafka!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/glue!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/gcs!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/elasticsearch!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/json-schema!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/mssql!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/mysql!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/starburst-trino-usage!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/csv-enricher!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/slack!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/iceberg!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/unity-catalog!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/metabase!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/powerbi!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/hive-metastore!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/sql-queries!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/cockroachdb!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/mariadb!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/mongodb!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/mlflow!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/presto-on-hive!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/salesforce!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/druid!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/azure-ad!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/lookml!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/datahub-gc!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/sagemaker!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/vertica!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/sac!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/redshift!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/okta!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/presto!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/teradata!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/dremio!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/oracle!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/pulsar!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/clickhouse-usage!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/athena!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/datahub-business-glossary!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/datahub!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/s3!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/sigma!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/dbt!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/fivetran!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/clickhouse!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/snowflake!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/mode!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/demo-data!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/hive!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/redash!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/dbt-cloud!predicate"
                    ],
              transformers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required [ "type" ],
                            _js2n__-prdslib.records.record
                              {
                                config = _js2n__-prdslib.isType 'Record,
                                type = _js2n__-prdslib.isType '"String",
                              } {} false _js2n__-prdslib.never
                          ])
                    ],
            } {} true _js2n__-prdslib.always
        ])