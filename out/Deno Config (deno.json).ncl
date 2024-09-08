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
      bench
        | {
          exclude
            | Array (String)
            | doc "List of files, directories or globs that will not be searched for benchmarks."
            | optional,
          files
            | {
              exclude
                | Array (String)
                | doc "List of files, directories or globs that will not be searched for benchmarks."
                | optional,
              include
                | Array (String)
                | doc "List of files, directories or globs that will be searched for benchmarks."
                | optional,
              ..
            }
            | optional,
          include
            | Array (String)
            | doc "List of files, directories or globs that will be searched for benchmarks."
            | optional,
          ..
        }
        | doc "Configuration for deno bench"
        | optional,
      compilerOptions
        | {
          allowJs
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Allow JavaScript files to be a part of your program. Use the `checkJS` option to get errors from these files."
            | optional,
          allowUnreachableCode
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Disable error reporting for unreachable code."
            | optional,
          allowUnusedLabels
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Disable error reporting for unused labels."
            | optional,
          checkJs
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Enable error reporting in type-checked JavaScript files."
            | optional,
          exactOptionalPropertyTypes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Differentiate between undefined and not present when type checking"
            | optional,
          experimentalDecorators
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Enable experimental support for legacy experimental decorators."
            | optional,
          jsx
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum
                [
                  "preserve",
                  "react",
                  "react-jsx",
                  "react-jsxdev",
                  "react-native",
                  "precompile"
                ])
            | doc "Specify what JSX code is generated."
            | optional,
          jsxFactory
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"String")
            | doc "Specify the JSX factory function used when targeting React JSX emit, e.g. 'React.createElement' or 'h'"
            | optional,
          jsxFragmentFactory
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"String")
            | doc "Specify the JSX Fragment reference used for fragments when targeting React JSX emit e.g. 'React.Fragment' or 'Fragment'."
            | optional,
          jsxImportSource
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"String")
            | doc "Specify module specifier used to import the JSX factory functions when using jsx: 'react-jsx*'."
            | optional,
          jsxImportSourceTypes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"String")
            | doc "Specify module specifier used to import the types for the JSX factory functions when using jsx: 'react-jsx*'. This is the logical equivalent of prefixing an import to the jsxImportSource with `// @deno-types=\"...\"`."
            | optional,
          jsxPrecompileSkipElements
            | Array (String)
            | doc "Specify list of elements that should be exempt from being precompiled when the jsx 'precompile' transform is used."
            | optional,
          keyofStringsOnly
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Make keyof only return strings instead of string, numbers or symbols. Legacy option."
            | optional,
          lib
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String"),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc "Specify a set of bundled library declaration files that describe the target runtime environment."
            | optional,
          noErrorTruncation
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Do not truncate error messages."
            | optional,
          noFallthroughCasesInSwitch
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Enable error reporting for fallthrough cases in switch statements."
            | optional,
          noImplicitAny
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Enable error reporting for expressions and declarations with an implied `any` type."
            | optional,
          noImplicitOverride
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Ensure overriding members in derived classes are marked with an override modifier."
            | optional,
          noImplicitReturns
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Enable error reporting for codepaths that do not explicitly return in a function."
            | optional,
          noImplicitThis
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Enable error reporting when `this` is given the type `any`."
            | optional,
          noImplicitUseStrict
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Disable adding 'use strict' directives in emitted JavaScript files."
            | optional,
          noPropertyAccessFromIndexSignature
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Enforces using indexed accessors for keys declared using an indexed type."
            | optional,
          noStrictGenericChecks
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Disable strict checking of generic signatures in function types."
            | optional,
          noUncheckedIndexedAccess
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Add `undefined` to a type when accessed using an index."
            | optional,
          noUnusedLocals
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Enable error reporting when a local variables aren't read."
            | optional,
          noUnusedParameters
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Raise an error when a function parameter isn't read"
            | optional,
          strict
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Enable all strict type checking options."
            | optional,
          strictBindCallApply
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Check that the arguments for `bind`, `call`, and `apply` methods match the original function."
            | optional,
          strictFunctionTypes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "When assigning functions, check to ensure parameters and the return values are subtype-compatible."
            | optional,
          strictNullChecks
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "When type checking, take into account `null` and `undefined`."
            | optional,
          strictPropertyInitialization
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Check for class properties that are declared but not set in the constructor."
            | optional,
          suppressExcessPropertyErrors
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Disable reporting of excess property errors during the creation of object literals."
            | optional,
          suppressImplicitAnyIndexErrors
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Suppress `noImplicitAny` errors when indexing objects that lack index signatures."
            | optional,
          useUnknownInCatchVariables
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType '"Bool")
            | doc "Default catch clause variables as `unknown` instead of `any`."
            | optional,
          ..
        }
        | doc "Instructs the TypeScript compiler how to compile .ts files."
        | optional,
      exclude
        | Array (String)
        | doc "List of files, directories or globs that will be ignored by all other configurations. Requires Deno 1.34 or later."
        | optional,
      exports
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^\\./.*$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    (_js2n__-prdslib.strings.pattern "^\\.(/.*)?$"),
                  _js2n__-prdslib.records.record {}
                    {
                      "^\\.(/.*)?$" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern "^\\./.*$"
                            ],
                    } true _js2n__-prdslib.always
                ]
            ])
        | optional,
      fmt
        | {
          exclude
            | Array (String)
            | doc "List of files, directories or globs that will not be formatted."
            | optional,
          files
            | {
              exclude
                | Array (String)
                | doc "List of files, directories or globs that will not be formatted."
                | optional,
              include
                | Array (String)
                | doc "List of files, directories or globs that will be formatted."
                | optional,
              ..
            }
            | optional,
          include
            | Array (String)
            | doc "List of files, directories or globs that will be formatted."
            | optional,
          indentWidth
            | Number
            | doc "The number of characters for an indent."
            | optional,
          lineWidth
            | Number
            | doc "The width of a line the printer will try to stay under. Note that the printer may exceed this width in certain cases."
            | optional,
          options
            | {
              indentWidth
                | Number
                | doc "The number of characters for an indent."
                | optional,
              lineWidth
                | Number
                | doc "The width of a line the printer will try to stay under. Note that the printer may exceed this width in certain cases."
                | optional,
              proseWrap
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "always", "never", "preserve" ])
                | doc "Define how prose should be wrapped in Markdown files."
                | optional,
              semiColons
                | Bool
                | doc "Whether to prefer using semicolons."
                | optional,
              singleQuote
                | Bool
                | doc "Whether to use single quote (true) or double quote (false) for quotation."
                | optional,
              useTabs
                | Bool
                | doc "Whether to use tabs (true) or spaces (false) for indentation."
                | optional,
              ..
            }
            | optional,
          proseWrap
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "always", "never", "preserve" ])
            | doc "Define how prose should be wrapped in Markdown files."
            | optional,
          semiColons
            | Bool
            | doc "Whether to prefer using semicolons."
            | optional,
          singleQuote
            | Bool
            | doc "Whether to use single quote (true) or double quote (false) for quotation."
            | optional,
          useTabs
            | Bool
            | doc "Whether to use tabs (true) or spaces (false) for indentation."
            | optional,
          ..
        }
        | doc "Configuration for formatter"
        | optional,
      importMap
        | String
        | doc "The location of an import map to be used when resolving modules. If an import map is specified as an `--importmap` flag or using \"imports\" and \"scopes\" properties, they will override this value."
        | optional,
      imports
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "A map of specifiers to their remapped specifiers."
        | optional,
      license
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"String" ])
        | doc "The SPDX license identifier if this is a JSR package. Specify this or add a license file to the package."
        | optional,
      lint
        | {
          exclude
            | Array (String)
            | doc "List of files, directories or globs that will not be linted."
            | optional,
          files
            | {
              exclude
                | Array (String)
                | doc "List of files, directories or globs that will not be linted."
                | optional,
              include
                | Array (String)
                | doc "List of files, directories or globs that will be linted."
                | optional,
              ..
            }
            | optional,
          include
            | Array (String)
            | doc "List of files, directories or globs that will be linted."
            | optional,
          report
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "pretty", "json", "compact" ])
            | doc "The default report format to use when linting"
            | optional,
          rules
            | {
              exclude
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 0,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "List of rule names that will be excluded from configured tag sets. If the same rule is in `include` it will be run."
                | optional,
              include
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 0,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "List of rule names that will be run. Even if the same rule is in `exclude` it will be run."
                | optional,
              tags
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 0,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "List of tag names that will be run. Empty list disables all tags and will only use rules from `include`."
                | optional,
              ..
            }
            | optional,
          ..
        }
        | doc "Configuration for linter"
        | optional,
      lock
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType 'Record
                ],
              _js2n__-prdslib.records.record
                {
                  frozen = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ])
        | doc "Whether to use a lock file or the path to use for the lock file. Can be overridden by CLI arguments."
        | optional,
      name
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^@[a-z0-9-]+/[a-z0-9-]+$"
            ])
        | doc "The name of this JSR package. Must be scoped"
        | optional,
      nodeModulesDir
        | Bool
        | doc "Enables or disables the use of a local node_modules folder for npm packages. Alternatively, use the `--node-modules-dir` flag or override the config via `--node-modules-dir=false`. Requires Deno 1.34 or later."
        | optional,
      patch
        | Array (String)
        | doc "UNSTABLE: List of relative paths to folders containing JSR packages to use local versions of."
        | optional,
      publish
        | {
          exclude
            | Array (String)
            | doc "List of files, directories or globs that will be excluded from the published package."
            | optional,
          include
            | Array (String)
            | doc "List of files, directories or globs that will be included in the published package."
            | optional,
          ..
        }
        | doc "Configuration for deno publish"
        | optional,
      scopes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
            ])
        | doc "Define a scope which remaps a specifier in only a specified scope"
        | optional,
      tasks
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[A-Za-z][A-Za-z0-9_\\-:]*$" =
                    _js2n__-prdslib.isType '"String",
                } false _js2n__-prdslib.never
            ])
        | doc "Configuration for deno task"
        | optional,
      test
        | {
          exclude
            | Array (String)
            | doc "List of files, directories or globs that will not be searched for tests."
            | optional,
          files
            | {
              exclude
                | Array (String)
                | doc "List of files, directories or globs that will not be searched for tests."
                | optional,
              include
                | Array (String)
                | doc "List of files, directories or globs that will be searched for tests."
                | optional,
              ..
            }
            | optional,
          include
            | Array (String)
            | doc "List of files, directories or globs that will be searched for tests."
            | optional,
          ..
        }
        | doc "Configuration for deno test"
        | optional,
      unstable
        | Array (String)
        | doc "List of unstable features to enable."
        | optional,
      vendor
        | Bool
        | doc "Enables or disables the use of a local vendor folder as a local cache for remote modules and node_modules folder for npm packages. Alternatively, use the `--vendor` flag or override the config via `--vendor=false`. Requires Deno 1.36.1 or later."
        | optional,
      version | String | doc "The version of this JSR package." | optional,
      workspace
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      members =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ])
        | optional,
      ..
    }