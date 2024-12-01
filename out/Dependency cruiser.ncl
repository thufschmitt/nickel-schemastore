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
      "_js2n__-:definitions/AllowedRuleType!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-refsenv."_js2n__-:definitions/RegularAllowedRuleType!predicate",
                _js2n__-refsenv."_js2n__-:definitions/ReachabilityAllowedRuleType!predicate"
              ]),
      "_js2n__-:definitions/AnonReporterOptionsType!contract"
        | doc "Options to tweak the output of the anonymous reporter"
        = {
            wordlist
              | Array (String)
              | doc "List of words to use to replace path elements of file names in the output with so the output isn't directly traceable to its intended purpose. When the list is exhausted, the anon reporter will use random strings patterned after the original file name in stead. The list is empty by default. Read more in https://github.com/sverweij/dependency-cruiser/blob/main/doc/cli.md#anon---obfuscated-json"
              | optional,
          },
      "_js2n__-:definitions/CacheOptionsType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compress = _js2n__-prdslib.isType '"Bool",
                  folder = _js2n__-prdslib.isType '"String",
                  strategy =
                    _js2n__-refsenv."_js2n__-:definitions/CacheStrategyType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CacheStrategyType!predicate"
        | doc m%"
          The strategy to use for caching.
          - 'metadata': use git metadata to detect changes;
          - 'content': use (a checksum of) the contents of files to detect changes.
          
          'content' is useful if you're not using git or work on partial clones (which is typical on CI's). Trade-of: the 'content' strategy is typically slower.
          
          Defaults to 'metadata'.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "metadata", "content" ]
            ],
      "_js2n__-:definitions/CompoundDoNotFollowType!predicate"
        | doc "Criteria for modules to include, but not to follow further"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dependencyTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DependencyTypeType!predicate"
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CompoundExcludeType!contract"
        | doc "Criteria for dependencies to exclude"
        = {
            dynamic
              | Bool
              | doc "a boolean indicating whether or not to exclude dynamic dependencies"
              | optional,
            path
              | _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!contract"
              | doc "a regular expression for modules to exclude from being cruised"
              | optional,
          },
      "_js2n__-:definitions/CompoundExcludeType!predicate"
        | doc "Criteria for dependencies to exclude"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dynamic = _js2n__-prdslib.isType '"Bool",
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CompoundFocusType!contract"
        | doc "Criteria for modules to 'focus' on"
        = {
            depth
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.maximum 4,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "by default 'focus' only inlcudes the direct neighbours of the focus'ed module(s). This property makes dependency-cruiser will also include neighbors of neighbors, up to the specified depth."
              | optional,
            path
              | _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!contract"
              | doc "dependency-cruiser will include modules matching this regular expression in its output, as well as their neighbours (direct dependencies and dependents)"
              | optional,
          },
      "_js2n__-:definitions/CompoundFocusType!predicate"
        | doc "Criteria for modules to 'focus' on"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  depth =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 4,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CompoundHighlightType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CompoundIncludeOnlyType!contract"
        | doc "Criteria for modules to only include"
        = {
            path
              | _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!contract"
              | doc "dependency-cruiser will include modules matching this regular expression in its output, as well as their neighbours (direct dependencies and dependents)"
              | optional,
          },
      "_js2n__-:definitions/CompoundIncludeOnlyType!predicate"
        | doc "Criteria for modules to only include"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CompoundReachesType!contract" =
        {
            path
              | _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!contract"
              | doc "dependency-cruiser will include modules matching this regular expression in its output, as well as _any_ module that reaches them - either directly or via via"
              | optional,
          },
      "_js2n__-:definitions/CompoundReachesType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DependencyTypeType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'unknown,
                'undetermined,
                'type-only,
                'type-import,
                'triple-slash-type-reference,
                'triple-slash-file-reference,
                'triple-slash-directive,
                'triple-slash-amd-dependency,
                'require,
                'pre-compilation-only,
                'npm,
                'npm-unknown,
                'npm-peer,
                'npm-optional,
                'npm-no-pkg,
                'npm-dev,
                'npm-bundled,
                'localmodule,
                'local,
                'jsdoc-import-tag,
                'jsdoc-bracket-import,
                'jsdoc,
                '"import",
                'import-equals,
                'export,
                'exotic-require,
                'dynamic-import,
                'deprecated,
                'core,
                'amd-exotic-require,
                'amd-require,
                'amd-define,
                'aliased,
                'aliased-workspace,
                'aliased-webpack,
                'aliased-tsconfig,
                'aliased-tsconfig-paths,
                'aliased-tsconfig-base-url,
                'aliased-subpath-import
              |]
            ],
      "_js2n__-:definitions/DependencyTypeType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "aliased-subpath-import",
                  "aliased-tsconfig-base-url",
                  "aliased-tsconfig-paths",
                  "aliased-tsconfig",
                  "aliased-webpack",
                  "aliased-workspace",
                  "aliased",
                  "amd-define",
                  "amd-require",
                  "amd-exotic-require",
                  "core",
                  "deprecated",
                  "dynamic-import",
                  "exotic-require",
                  "export",
                  "import-equals",
                  "import",
                  "jsdoc",
                  "jsdoc-bracket-import",
                  "jsdoc-import-tag",
                  "local",
                  "localmodule",
                  "npm-bundled",
                  "npm-dev",
                  "npm-no-pkg",
                  "npm-optional",
                  "npm-peer",
                  "npm-unknown",
                  "npm",
                  "pre-compilation-only",
                  "require",
                  "triple-slash-amd-dependency",
                  "triple-slash-directive",
                  "triple-slash-file-reference",
                  "triple-slash-type-reference",
                  "type-import",
                  "type-only",
                  "undetermined",
                  "unknown"
                ]
            ],
      "_js2n__-:definitions/DependentsForbiddenRuleType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "module" ],
              _js2n__-prdslib.records.record
                {
                  comment = _js2n__-prdslib.isType '"String",
                  from =
                    _js2n__-refsenv."_js2n__-:definitions/DependentsFromRestrictionType!predicate",
                  module =
                    _js2n__-refsenv."_js2n__-:definitions/DependentsModuleRestrictionType!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  scope =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "module", "folder" ]
                        ],
                  severity =
                    _js2n__-refsenv."_js2n__-:definitions/SeverityType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DependentsFromRestrictionType!predicate"
        | doc "Criteria the dependents of the module should adhere to be caught by this rule rule. Leave it empty if you want any dependent to be matched."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  pathNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DependentsModuleRestrictionType!predicate"
        | doc "Criteria to select the module(s) this restriction should apply to"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  numberOfDependentsLessThan =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 100,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  numberOfDependentsMoreThan =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 100,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  pathNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DotReporterOptionsType!contract"
        | doc "Options to tweak the output of the dot reporters"
        = {
            collapsePattern
              | _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!contract"
              | doc "Regular expressions to collapse to. For the \"dot\" reporter defaults to null, but \"node_modules/[^/]+\" is recommended for most use cases."
              | optional,
            filters
              | _js2n__-refsenv."_js2n__-:definitions/ReporterFiltersType!contract"
              | optional,
            showMetrics
              | Bool
              | doc "When passed the value 'true', shows instability metrics in the output if dependency-cruiser calculated them. Doesn't show them in all other cases. Defaults to false"
              | optional,
            theme
              | _js2n__-refsenv."_js2n__-:definitions/DotThemeType!contract"
              | optional,
          },
      "_js2n__-:definitions/DotThemeArrayType!contract" =
        Array _js2n__-refsenv."_js2n__-:definitions/DotThemeEntryType!contract",
      "_js2n__-:definitions/DotThemeEntryType!contract" =
        { attributes | {  .. } | optional, criteria | {  .. } | optional, },
      "_js2n__-:definitions/DotThemeType!contract"
        | doc "A bunch of criteria to conditionally theme the dot output"
        = {
            dependencies
              | _js2n__-refsenv."_js2n__-:definitions/DotThemeArrayType!contract"
              | doc "List of criteria and attributes to apply for dependencies when the criteria are met. Conditions can use any dependency attribute. Attributes can be any that are valid in GraphViz dot edges."
              | optional,
            edge
              | {  .. }
              | doc "Name- value pairs of GraphViz dot edge attributes."
              | optional,
            graph
              | {  .. }
              | doc "Name- value pairs of GraphViz dot (global) attributes."
              | optional,
            modules
              | _js2n__-refsenv."_js2n__-:definitions/DotThemeArrayType!contract"
              | doc "List of criteria and attributes to apply for modules when the criteria are met. Conditions can use any module attribute. Attributes can be any that are valid in GraphViz dot nodes."
              | optional,
            node
              | {  .. }
              | doc "Name- value pairs of GraphViz dot node attributes."
              | optional,
            replace
              | Bool
              | doc "If passed with the value 'true', the passed theme replaces the default one. In all other cases it extends the default theme."
              | optional,
          },
      "_js2n__-:definitions/ExtendsType!contract"
        | doc "A configuration (or an array of configurations) this configuration uses as a base"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String")
                  ]
              ]),
      "_js2n__-:definitions/ForbiddenRuleType!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-refsenv."_js2n__-:definitions/RegularForbiddenRuleType!predicate",
                _js2n__-refsenv."_js2n__-:definitions/ReachabilityForbiddenRuleType!predicate",
                _js2n__-refsenv."_js2n__-:definitions/DependentsForbiddenRuleType!predicate"
              ]),
      "_js2n__-:definitions/FromRestrictionType!predicate"
        | doc "Criteria an end of a dependency should match to be caught by this rule. Leave it empty if you want any module to be matched."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  orphan = _js2n__-prdslib.isType '"Bool",
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  pathNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MarkdownReporterOptionsType!contract"
        | doc "Options to show and hide sections of the markdown reporter and to provide alternate boilerplate text"
        = {
            collapseDetails
              | Bool
              | doc "Whether or not to collapse the list of violations in a <details> block. Defaults to true."
              | optional,
            collapsedMessage
              | String
              | doc "The text to in the <summary> section of the <details> block. E.g. 'click to see all violations'. When left out shows a default value."
              | optional,
            detailsHeader
              | String
              | doc "The text to show as a header on top of the detailed list of violations. E.g. '### All violations'. When left out shows a default value."
              | optional,
            includeIgnoredInDetails
              | Bool
              | doc "Whether or not to show ignored violations in the detailed list. Defaults to true."
              | optional,
            includeIgnoredInSummary
              | Bool
              | doc "Whether or not to show rules in the list of rules for which all violations are ignored. Defaults to true."
              | optional,
            noViolationsMessage
              | String
              | doc "The text to show when no violations were found. E.g. 'No violations found'. When left out shows a default value."
              | optional,
            showDetails
              | Bool
              | doc "Whether or not to show a detailed list of violations. Defaults to true."
              | optional,
            showDetailsHeader
              | Bool
              | doc "Whether or not to give the detailed list of violations a header. Defaults to true."
              | optional,
            showFooter
              | Bool
              | doc "Whether or not to show a footer (with version & run date) at the bottom of the report. Defaults to true"
              | optional,
            showRulesSummary
              | Bool
              | doc "Whether or not to show a list of violated rules in the summary. Defaults to true."
              | optional,
            showStatsSummary
              | Bool
              | doc "Whether or not to show high level stats in the summary. Defaults to true."
              | optional,
            showSummary
              | Bool
              | doc "Whether or not to show a summary in the report. Defaults to true."
              | optional,
            showSummaryHeader
              | Bool
              | doc "Whether or not to give the summary a header. Defaults to true."
              | optional,
            showTitle
              | Bool
              | doc "Whether or not to show a title in the report. Defaults to true."
              | optional,
            summaryHeader
              | String
              | doc "The text to show as a header on top of the summary. E.g. '### Summary'. When left out shows a default value."
              | optional,
            title
              | String
              | doc "The text to show as a title of the report. E.g. '## dependency-cruiser forbidden dependency check - results'. When left out shows a default value."
              | optional,
          },
      "_js2n__-:definitions/MermaidReporterOptionsType!contract"
        | doc "Options to tweak the output of the mermaid reporters"
        = {
            minify
              | Bool
              | doc "Whether or not to compresses the output text. Defaults to true."
              | optional,
          },
      "_js2n__-:definitions/MetricsReporterOptionsType!contract"
        | doc "Options to tweak the output of the metrics reporter"
        = {
            hideFolders
              | Bool
              | doc "When true hides folder metrics from the report. Defaults to false"
              | optional,
            hideModules
              | Bool
              | doc "When true hides module metrics from the report. Defaults to false"
              | optional,
            orderBy
              | std.enum.TagOrString
              | [|
                'topLevelStatementCount,
                'size,
                'name,
                'efferentCouplings,
                'afferentCouplings,
                'moduleCount,
                'instability
              |]
              | doc "By what attribute (in addition to the names of the folders/ modules) to order the metrics by. Defaults to 'instability'."
              | optional,
          },
      "_js2n__-:definitions/MiniDependency!contract"
        | doc "A small dependency object with the uniquely identifying name of the module +the dependency types it has relative to the _previous_ module in the chain  it is part of (e.g. a cycle)."
        = {
            dependencyTypes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/DependencyTypeType!contract"
              | doc "The dependency types of the module relative to the previous module in the chain it is a part of (e.g. a cycle)",
            name | String | doc "The name of the module",
          },
      "_js2n__-:definitions/MiniDependencyRestrictionType!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      dependencyTypes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/DependencyTypeType!predicate"
                            ],
                      dependencyTypesNot =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/DependencyTypeType!predicate"
                            ],
                      path =
                        _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                      pathNot =
                        _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/ModuleSystemType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'tsd, 'amd, 'es6, 'cjs |] ],
      "_js2n__-:definitions/ModuleSystemsType!contract"
        | doc "List of module systems to cruise. Defaults to [amd, cjs, es6]"
        = Array
            _js2n__-refsenv."_js2n__-:definitions/ModuleSystemType!contract",
      "_js2n__-:definitions/OptionsType!contract"
        | doc "Runtime configuration options"
        = {
            affected
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | doc "dependency-cruiser will mark modules that have changed since the specified revision (or 'main', when not specified) in its output, as well as _any_ module that reaches them - either directly or via via. NOTE: this is currently a command line _only_ option, so if you pass this to the API or in a configuration file it will be ignored."
              | optional,
            babelConfig
              | {
                fileName
                  | String
                  | doc "The Babel configuration file to use. The fileName is relative to dependency-cruiser's current working directory. When not provided defaults to './.babelrc.json'. Dependency-cruiser currently supports only the json variant. Support for (js|cjs|mjs) variants and configuration in package.json might follow in future releases."
                  | optional,
              }
              | doc "Babel configuration (e.g. '.babelrc.json') to use."
              | optional,
            baseDir
              | String
              | doc "The directory dependency-cruiser should run its cruise from. Defaults to the current working directory."
              | optional,
            builtInModules
              | {
                add
                  | Array (String)
                  | doc "List of module names that are to be considered as 'built-in' in addition to the default list of the environment you're currently in. Use this e.g. if you're writing electron code and want to add 'electron' as built-in."
                  | optional,
                override
                  | Array (String)
                  | doc "List of module names that are to be considered as 'built-in'. By default dependency-cruiser uses the list of built-ins from nodejs. If you code for another environment (e.g. the browser) and you use shims for nodejs builtins like 'path' from node_modules, you could pass an empty array here. If you want to just add a couple of extra built-ins to the default list, use the 'add' attribute instead."
                  | optional,
              }
              | doc "Options to tweak what dependency-cruiser considers 'built-in' modules. If you're targeting nodejs, or don't use any built-in modules you can probably leave this alone."
              | optional,
            cache
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"Bool",
                    _js2n__-prdslib.isType '"String",
                    _js2n__-refsenv."_js2n__-:definitions/CacheOptionsType!predicate"
                  ])
              | doc m%"
                - false: don't use caching. 
                - true or empty object: use caching with the default settings 
                - a string (deprecated): cache in the folder denoted by the string & use the 
                  default caching strategy. This is deprecated - instead pass a cache object 
                  e.g. ```{ folder: 'your/cache/location' }```.
                
                Defaults to false (no caching).
                When caching is switched on the default cache folder is 'node_modules/.cache/dependency-cruiser/'
              "%
              | optional,
            collapse
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.maximum 9,
                        _js2n__-prdslib.numbers.minimum 1
                      ]
                  ])
              | doc "Collapse a to a folder depth by passing a single digit (e.g. 2). When passed a regex collapses to that pattern E.g. ^packages/[^/]+/ would collapse to modules/ folders directly under your packages folder."
              | optional,
            combinedDependencies
              | Bool
              | doc "if true combines the package.jsons found from the module up to the base folder the cruise is initiated from. Useful for how (some) mono-repos manage dependencies & dependency definitions. Defaults to `false`."
              | optional,
            detectJSDocImports
              | Bool
              | doc "When true, dependency-cruiser will detect dependencies in JSDoc-style import statements. Implies `\"parser\": \"tsc\"`. Defaults to false."
              | optional,
            doNotFollow
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/CompoundDoNotFollowType!predicate"
                  ])
              | doc "a regular expression for modules to include, but not follow further"
              | optional,
            enhancedResolveOptions
              | {
                aliasFields
                  | Array (String)
                  | doc "A list of alias fields in manifests (package.jsons). Specify a field, such as browser, to be parsed according to [this specification](https://github.com/defunctzombie/package-browser-field-spec). Also see [resolve.alias](https://webpack.js.org/configuration/resolve/#resolvealiasfields) in the webpack docs. Defaults to an empty array (don't use any alias fields)."
                  | optional,
                cachedInputFileSystem
                  | {
                    cacheDuration
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Integer,
                            _js2n__-prdslib.numbers.maximum 1800000,
                            _js2n__-prdslib.numbers.minimum 0
                          ])
                      | doc "The number of milliseconds [enhanced-resolve](webpack/enhanced-resolve)'s cached file system should use for cache duration. Typically you won't have to touch this - the default works well for repos up to 5000 modules/ 20000 dependencies, and likely for numbers above as well. If you experience memory problems on a (humongous) repository you can use the cacheDuration attribute to tame enhanced-resolve's memory usage by lowering the cache duration trading off against some (for values over 1000ms) or significant (for values below 500ms) performance. Dependency-cruiser currently uses 4000ms, and in the past has used 1000ms - both with good results."
                      | optional,
                  }
                  | doc "Options to pass to the resolver (webpack's 'enhanced resolve') regarding caching."
                  | optional,
                conditionNames
                  | Array (String)
                  | doc "List of conditions to check for in the exports field. e.g. use `['imports']` if you're only interested in exposed es6 modules, ['require'] for commonjs, or all conditions at once (['import', 'require', 'node', 'default']) if anything goes for you. Only works when the 'exportsFields' array is non-empty"
                  | optional,
                exportsFields
                  | Array (String)
                  | doc "List of strings to consider as 'exports' fields in package.json. Use ['exports'] when you use packages that use such a field and your environment supports it (e.g. node ^12.19 || >=14.7 or recent versions of webpack)."
                  | optional,
                extensions
                  | Array (String)
                  | doc "List of extensions to scan for when resolving. Typically you want to leave this alone as dependency-cruiser figures out what extensions to scan based on 1. what is available in your environment 2. in the order your environment (nodejs, typescript) applies the resolution itself. However, if you want it to scan less you can specify so with the extensions attribute. E.g. when you're 100% sure you _only_ have typescript & json and nothing else you can pass ['.ts', '.json'] - which can lead to performance gains on systems with slow i/o (like ms-windows), especially when your tsconfig contains paths/ aliases."
                  | optional,
                mainFields
                  | Array (String)
                  | doc "A list of main fields in manifests (package.json s). Typically you'd want to keep leave this this on its default (['main']) , but if you e.g. use external packages that only expose types, and you still want references to these types to be resolved you could expand this to ['main', 'types', 'typings']"
                  | optional,
                mainFiles
                  | Array Dyn
                  | doc "A list of files to consider 'main' files, defaults to ['index']. Only set this when you have really special needs that warrant it."
                  | optional,
              }
              | doc "Options used in module resolution that for dependency-cruiser's use cannot go in a webpack config. For details please refer to the documentation of enhanced-resolve itself."
              | optional,
            exclude
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/CompoundExcludeType!predicate"
                  ])
              | doc "a regular expression for modules to exclude from being cruised"
              | optional,
            exoticRequireStrings
              | Array (String)
              | doc "List of strings you have in use in addition to cjs/ es6 requires & imports to declare module dependencies. Use this e.g. if you've re-declared require (`const want = require`), use a require-wrapper (like semver-try-require) or use window.require as a hack to workaround something"
              | optional,
            experimentalStats
              | Bool
              | doc "When this flag is set to true, dependency-cruiser will calculate some stats for each module. Has some performance impact. EXPERIMENTAL Will be renamed when the 'experimental' state is lifted. Defaults to false."
              | optional,
            externalModuleResolutionStrategy
              | std.enum.TagOrString
              | [| 'yarn-pnp, 'node_modules |]
              | doc "What external module resolution strategy to use. Defaults to 'node_modules' (not used anymore - module resolution strategy determination is automatic now)"
              | optional,
            extraExtensionsToScan
              | Array (String)
              | doc "List of extensions to scan _in addition_ to the extensions already covered by any available parser. Dependency-cruiser will consider files ending in these extensions but it will _not_ examine its content or derive any of their dependencies Sample value: [\".jpg\", \".png\", \".json\"]"
              | optional,
            focus
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/CompoundFocusType!predicate"
                  ])
              | doc "dependency-cruiser will include modules matching this regular expression in its output, as well as their neighbours (direct dependencies and dependents)"
              | optional,
            forceDeriveDependents
              | Bool
              | doc "When true includes de-normalized dependents in the cruise-result, even though there's no rule in the rule set that requires them. Defaults to false."
              | optional,
            highlight
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/CompoundHighlightType!predicate"
                  ])
              | doc "dependency-cruiser will mark modules matching this regular expression as 'highlighted' in its output"
              | optional,
            includeOnly
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/CompoundIncludeOnlyType!predicate"
                  ])
              | doc "a regular expression for modules to cruise; anything outside it will be skipped"
              | optional,
            knownViolations
              | _js2n__-refsenv."_js2n__-:definitions/ViolationsType!contract"
              | doc "baseline of known validations. Typically you'd specify these in a file called .dependency-cruiser-known-violations.json (which you'd generate with the --outputType 'baseline') - and which is easy to keep up to date. In a pinch you can specify them here as well. The known violations in .dependency-cruiser-known-violations.json always take precedence."
              | optional,
            maxDepth
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 99,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "The maximum cruise depth specified. 0 means no maximum specified. While it might look attractive to regulate the size of the output, this is not the best option to do so. Filters (exclude, includeOnly, focus), the dot and archi reporter's collapsePattern and the collapse options offer better, more reliable and more understandable results."
              | optional,
            metrics
              | Bool
              | doc "When this flag is set to true, dependency-cruiser will calculate (stability) metrics for all modules and folders. Defaults to false."
              | optional,
            moduleSystems
              | _js2n__-refsenv."_js2n__-:definitions/ModuleSystemsType!contract"
              | optional,
            parser
              | std.enum.TagOrString
              | [| 'swc, 'tsc, 'acorn |]
              | doc "overrides the parser dependency-cruiser will use - EXPERIMENTAL. The use of 'swc' as a parser here is deprecated."
              | optional,
            prefix | String | optional,
            preserveSymlinks
              | Bool
              | doc "if true leave symlinks untouched, otherwise use the realpath. Defaults to `false` (which is also nodejs's default behavior since version 6)"
              | optional,
            progress
              | {
                maximumLevel
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.enum [ -1, 40, 50, 60, 70, 80, 99 ]
                      ])
                  | doc "The maximum log level to emit messages at. Ranges from OFF (-1, don't show any messages), via SUMMARY (40), INFO (50), DEBUG (60) all the way to show ALL messages (99)."
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'none, 'ndjson, 'performance-log, 'cli-feedback |]
                  | optional,
              }
              | doc "How dependency-cruiser shows progress. Defaults to 'none'."
              | optional,
            reaches
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/CompoundReachesType!predicate"
                  ])
              | doc "dependency-cruiser will include modules matching this regular expression in its output, as well as _any_ module that reaches them - either directly or via via"
              | optional,
            reporterOptions
              | _js2n__-refsenv."_js2n__-:definitions/ReporterOptionsType!contract"
              | optional,
            tsConfig
              | {
                fileName
                  | String
                  | doc "The TypeScript project file to use. The fileName is relative to dependency-cruiser's current working directory. When not provided defaults to './tsconfig.json'."
                  | optional,
              }
              | doc "TypeScript project file ('tsconfig.json') to use for (1) compilation and (2) resolution (e.g. with the paths property)"
              | optional,
            tsPreCompilationDeps
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"Bool",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum [ "specify" ]
                      ]
                  ])
              | doc "if true detect dependencies that only exist before typescript-to-javascript compilation."
              | optional,
            webpackConfig
              | {
                arguments
                  | {  .. }
                  | doc "Arguments to pass if your config file returns a function. E.g. {mode: 'production'} if you want to use webpack 4's 'mode' feature"
                  | optional,
                env
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType '"String"
                      ])
                  | doc "Environment to pass if your config file returns a function"
                  | optional,
                fileName
                  | String
                  | doc "The webpack conf file to use (typically something like 'webpack.conf.js'). The fileName is relative to dependency-cruiser's current working directory. When not provided defaults to './webpack.conf.js'."
                  | optional,
              }
              | doc "Webpack configuration file to use to get resolve options from"
              | optional,
          },
      "_js2n__-:definitions/REAsStringsType!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String")
                  ]
              ]),
      "_js2n__-:definitions/REAsStringsType!predicate" =
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
      "_js2n__-:definitions/ReachabilityAllowedRuleType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "to" ],
              _js2n__-prdslib.records.record
                {
                  comment = _js2n__-prdslib.isType '"String",
                  from =
                    _js2n__-refsenv."_js2n__-:definitions/ReachabilityFromRestrictionType!predicate",
                  scope =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "module", "folder" ]
                        ],
                  to =
                    _js2n__-refsenv."_js2n__-:definitions/ReachabilityToRestrictionType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ReachabilityForbiddenRuleType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "to" ],
              _js2n__-prdslib.records.record
                {
                  comment = _js2n__-prdslib.isType '"String",
                  from =
                    _js2n__-refsenv."_js2n__-:definitions/ReachabilityFromRestrictionType!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  scope =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "module", "folder" ]
                        ],
                  severity =
                    _js2n__-refsenv."_js2n__-:definitions/SeverityType!predicate",
                  to =
                    _js2n__-refsenv."_js2n__-:definitions/ReachabilityToRestrictionType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ReachabilityFromRestrictionType!predicate"
        | doc "Criteria an end of a dependency should match to be caught by this rule. Leave it empty if you want any module to be matched."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  pathNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ReachabilityToRestrictionType!predicate"
        | doc "Criteria the 'to' end of a dependency should match to be caught by this rule. Leave it empty if you want any module to be matched."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "reachable" ],
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  pathNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  reachable = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RegularAllowedRuleType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "to" ],
              _js2n__-prdslib.records.record
                {
                  comment = _js2n__-prdslib.isType '"String",
                  from =
                    _js2n__-refsenv."_js2n__-:definitions/FromRestrictionType!predicate",
                  scope =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "module", "folder" ]
                        ],
                  to =
                    _js2n__-refsenv."_js2n__-:definitions/ToRestrictionType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RegularForbiddenRuleType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "to" ],
              _js2n__-prdslib.records.record
                {
                  comment = _js2n__-prdslib.isType '"String",
                  from =
                    _js2n__-refsenv."_js2n__-:definitions/FromRestrictionType!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  scope =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "module", "folder" ]
                        ],
                  severity =
                    _js2n__-refsenv."_js2n__-:definitions/SeverityType!predicate",
                  to =
                    _js2n__-refsenv."_js2n__-:definitions/ToRestrictionType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ReporterFiltersType!contract"
        | doc "filters to apply to the reporter before rendering it (e.g. to leave out details from the graphical output that are not relevant for the goal of the report)"
        = {
            exclude
              | _js2n__-refsenv."_js2n__-:definitions/CompoundExcludeType!contract"
              | optional,
            focus
              | _js2n__-refsenv."_js2n__-:definitions/CompoundFocusType!contract"
              | optional,
            includeOnly
              | _js2n__-refsenv."_js2n__-:definitions/CompoundIncludeOnlyType!contract"
              | optional,
            reaches
              | _js2n__-refsenv."_js2n__-:definitions/CompoundReachesType!contract"
              | optional,
          },
      "_js2n__-:definitions/ReporterOptionsType!contract"
        | doc "Options to tweak the output of reporters"
        = {
            anon
              | _js2n__-refsenv."_js2n__-:definitions/AnonReporterOptionsType!contract"
              | optional,
            archi
              | _js2n__-refsenv."_js2n__-:definitions/DotReporterOptionsType!contract"
              | optional,
            ddot
              | _js2n__-refsenv."_js2n__-:definitions/DotReporterOptionsType!contract"
              | optional,
            dot
              | _js2n__-refsenv."_js2n__-:definitions/DotReporterOptionsType!contract"
              | optional,
            flat
              | _js2n__-refsenv."_js2n__-:definitions/DotReporterOptionsType!contract"
              | optional,
            markdown
              | _js2n__-refsenv."_js2n__-:definitions/MarkdownReporterOptionsType!contract"
              | optional,
            mermaid
              | _js2n__-refsenv."_js2n__-:definitions/MermaidReporterOptionsType!contract"
              | optional,
            metrics
              | _js2n__-refsenv."_js2n__-:definitions/MetricsReporterOptionsType!contract"
              | optional,
            text
              | _js2n__-refsenv."_js2n__-:definitions/TextReporterOptionsType!contract"
              | optional,
          },
      "_js2n__-:definitions/RequiredModuleRestrictionType!contract"
        | doc "Criteria to select the module(s) this restriction should apply to"
        = {
            path
              | _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!contract"
              | doc "A regular expression or an array of regular expressions an end of a dependency should match to be caught by this rule."
              | optional,
            pathNot
              | _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!contract"
              | doc "A regular expression or an array of regular expressions an end of a dependency should NOT match to be caught by this rule."
              | optional,
          },
      "_js2n__-:definitions/RequiredRuleType!contract" =
        {
            comment | String | optional,
            module
              | _js2n__-refsenv."_js2n__-:definitions/RequiredModuleRestrictionType!contract",
            name | String | optional,
            scope
              | std.enum.TagOrString
              | [| 'folder, 'module |]
              | doc "What to apply the rule to - modules (the default) or folders. Currently ignored for RequiredRules, defaulting to 'module'"
              | optional,
            severity
              | _js2n__-refsenv."_js2n__-:definitions/SeverityType!contract"
              | optional,
            to
              | _js2n__-refsenv."_js2n__-:definitions/RequiredToRestrictionType!contract",
          },
      "_js2n__-:definitions/RequiredToRestrictionType!contract"
        | doc "Criteria for modules the associated module must depend on."
        = {
            path
              | _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!contract"
              | doc "Criteria at least one dependency of each matching module must adhere to."
              | optional,
          },
      "_js2n__-:definitions/RuleSummaryType!contract"
        | doc "If there was a rule violation (valid === false), this object contains the name of the rule and severity of violating it."
        = {
            name
              | String
              | doc "The (short, eslint style) name of the violated rule. Typically something like 'no-core-punycode' or 'no-outside-deps'.",
            severity
              | _js2n__-refsenv."_js2n__-:definitions/SeverityType!contract",
          },
      "_js2n__-:definitions/SeverityType!contract"
        | doc "How severe a violation of a rule is. The 'error' severity will make some reporters return a non-zero exit code, so if you want e.g. a build to stop when there's a rule violated: use that."
        = std.contract.Sequence
            [ std.enum.TagOrString, [| 'ignore, 'info, 'warn, 'error |] ],
      "_js2n__-:definitions/SeverityType!predicate"
        | doc "How severe a violation of a rule is. The 'error' severity will make some reporters return a non-zero exit code, so if you want e.g. a build to stop when there's a rule violated: use that."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "error", "warn", "info", "ignore" ]
            ],
      "_js2n__-:definitions/TextReporterOptionsType!contract"
        | doc "Options that influence rendition of the text reporter"
        = {
            highlightFocused
              | Bool
              | doc "Whether or not to highlight modules that are focused with the --focus command line option (/ general option). Defaults to false"
              | optional,
          },
      "_js2n__-:definitions/ToRestrictionType!predicate"
        | doc "Criteria the 'to' end of a dependency should match to be caught by this rule. Leave it empty if you want any module to be matched."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  circular = _js2n__-prdslib.isType '"Bool",
                  couldNotResolve = _js2n__-prdslib.isType '"Bool",
                  dependencyTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DependencyTypeType!predicate"
                        ],
                  dependencyTypesNot =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DependencyTypeType!predicate"
                        ],
                  dynamic = _js2n__-prdslib.isType '"Bool",
                  exoticRequire =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  exoticRequireNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  exoticallyRequired = _js2n__-prdslib.isType '"Bool",
                  license =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  licenseNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  moreThanOneDependencyType = _js2n__-prdslib.isType '"Bool",
                  moreUnstable = _js2n__-prdslib.isType '"Bool",
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  pathNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  preCompilationOnly = _js2n__-prdslib.isType '"Bool",
                  via =
                    _js2n__-refsenv."_js2n__-:definitions/MiniDependencyRestrictionType!predicate",
                  viaNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                  viaOnly =
                    _js2n__-refsenv."_js2n__-:definitions/MiniDependencyRestrictionType!predicate",
                  viaSomeNot =
                    _js2n__-refsenv."_js2n__-:definitions/REAsStringsType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ViolationType!contract" =
        {
            comment
              | String
              | doc "Free format text you can e.g. use to explain why this violation can be ignored or is quarantined (only used in _known-violations_) "
              | optional,
            cycle
              | Array
                _js2n__-refsenv."_js2n__-:definitions/MiniDependency!contract"
              | doc "The circular path if the violation is about circularity"
              | optional,
            from | String,
            metrics
              | {
                from | { instability | Number, },
                to | { instability | Number, },
              }
              | optional,
            rule
              | _js2n__-refsenv."_js2n__-:definitions/RuleSummaryType!contract",
            to | String,
            type
              | _js2n__-refsenv."_js2n__-:definitions/ViolationTypeType!contract"
              | optional,
            via
              | Array
                _js2n__-refsenv."_js2n__-:definitions/MiniDependency!contract"
              | doc "The path from the from to the to if the violation is transitive"
              | optional,
          },
      "_js2n__-:definitions/ViolationTypeType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'folder,
                'instability,
                'cycle,
                'reachability,
                'module,
                'dependency
              |]
            ],
      "_js2n__-:definitions/ViolationsType!contract"
        | doc "A list of violations found in the dependencies. The dependencies themselves also contain this information, this summary is here for convenience."
        = Array _js2n__-refsenv."_js2n__-:definitions/ViolationType!contract",
    }
    in
  {
      "$schema" | String | optional,
      allowed
        | Array _js2n__-refsenv."_js2n__-:definitions/AllowedRuleType!contract"
        | doc "A list of rules that describe dependencies that are allowed. dependency-cruiser will emit the warning message 'not-in-allowed' for each dependency that does not at least meet one of them."
        | optional,
      allowedSeverity
        | _js2n__-refsenv."_js2n__-:definitions/SeverityType!contract"
        | doc "Severity to use when a dependency is not in the 'allowed' set of rules. Defaults to 'warn'"
        | optional,
      extends
        | _js2n__-refsenv."_js2n__-:definitions/ExtendsType!contract"
        | optional,
      forbidden
        | Array
          _js2n__-refsenv."_js2n__-:definitions/ForbiddenRuleType!contract"
        | doc "A list of rules that describe dependencies that are not allowed. dependency-cruiser will emit a separate error (warning/ informational) messages for each violated rule."
        | optional,
      options
        | _js2n__-refsenv."_js2n__-:definitions/OptionsType!contract"
        | optional,
      required
        | Array _js2n__-refsenv."_js2n__-:definitions/RequiredRuleType!contract"
        | doc "A list of rules that describe what dependencies modules _must_ have. E.g. - every controller needs to (directly) depend on a base controller. - each source file should be the dependency of a spec file with the same    base name"
        | optional,
    }